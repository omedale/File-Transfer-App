// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .
//= require dropzone

$(document).ready(function(){
	// disable auto discover
	Dropzone.autoDiscover = false;

	// grap our upload form by its id
	$("#new_upload").dropzone({
		// restrict image size to a maximum 1MB
		maxFilesize: 1,
		// changed the passed param to one accepted by
		// our rails app
		paramName: "upload[image]",
		// show remove links on each image upload
		addRemoveLinks: true
	});

	$('#reset-form').click(function() {
		$('#progress-wrap').empty().append('<div id="progress-bar"></div>')
		$('form')[0].reset();
	});
	
	addEventListener("direct-upload:initialize", event => {
		const { detail } = event
		const { id, file } = detail
		const progressBar = document.getElementById("progress-bar")
		progressBar.insertAdjacentHTML("beforebegin", `
		<div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
			<div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
			<span class="direct-upload__filename">${file.name} </span>
			<br>
		</div>
	`)
	})
	
	addEventListener("direct-upload:start", event => {
		const { id } = event.detail
		const element = document.getElementById(`direct-upload-${id}`)
		element.classList.remove("direct-upload--pending")
	})
	 
	addEventListener("direct-upload:progress", event => {
		const { id, progress } = event.detail
		const progressElement = document.getElementById(`direct-upload-progress-${id}`)
		progressElement.style.width = `${progress}%`
	})
	 
	addEventListener("direct-upload:error", event => {
		event.preventDefault()
		const { id, error } = event.detail
		const element = document.getElementById(`direct-upload-${id}`)
		element.classList.add("direct-upload--error")
		element.setAttribute("title", error)
		alert(error + ". This file already exist")
	})
	 
	addEventListener("direct-upload:end", event => {
		const { id } = event.detail
		const element = document.getElementById(`direct-upload-${id}`)
		element.classList.add("direct-upload--complete")
	})
});