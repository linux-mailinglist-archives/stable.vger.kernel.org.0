Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8C846B80E
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbhLGJ4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbhLGJ4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 04:56:01 -0500
Received: from lb2-smtp-cloud8.xs4all.net (lb2-smtp-cloud8.xs4all.net [IPv6:2001:888:0:108::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BB8C061574;
        Tue,  7 Dec 2021 01:52:30 -0800 (PST)
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id uX96mxufCQyExuX99m6Mav; Tue, 07 Dec 2021 10:52:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1638870748; bh=YIK8OHDbi3V4LndmzWao6mLqVaAtXkrpBG9mG5TVAco=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From:
         Subject;
        b=ET2rNmICLk25V6X121sF2QETLZMyvygTF/J9Ke96bkaYZk1A8tzrA3Vml13GhNBCb
         TemdWpPzs1qFchb43BGfsVvGq1zHCTdAAzFPQzUNcF7t9Gurw4ESM0z0AsrzOSyAUJ
         S5gfMaVlpmadluchLBNs5xle/MLKQdPisg/Eqk+Gmy6oe1kpRmZjQXMq7KY2jvMsnC
         F0fKi7ubIVxDL9OWJQFZBQIqBz+CZ3g0u152BSLpHDDkXHy0B29xmNN0N0tM5Ww14+
         xONBla2v0xYa4DBe3DllwPbzjRHvKI80WjWo6dysFjEAj6JvtW1o8+aNlX+3Fc+G9G
         vnGJzqBe4shVQ==
Message-ID: <6e64bb76-14f5-b492-ca36-775a0011acba@xs4all.nl>
Date:   Tue, 7 Dec 2021 10:52:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [PATCH v2 1/4] Revert "media: uvcvideo: Set unique vdev name
 based in type"
Content-Language: en-US
To:     Ricardo Ribalda <ribalda@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org
Cc:     stable@vger.kernel.org
References: <20211207003840.1212374-1-ribalda@chromium.org>
 <20211207003840.1212374-2-ribalda@chromium.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
In-Reply-To: <20211207003840.1212374-2-ribalda@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfE+7voatNWDKUjr1aMl0AXKaQkhI98MJFkc/Lc4uEEl8JUYVekHCg1kpUPeDtNOSCR3zbvKlb+wACVj4luuYXw9Rk+IR0nLOdcaRSIxSONlfqOMOK0eS
 Jb5s3XXxzu5qTJSwy+/iKd30uvGIB4wa3L3j9cH/WZLi1zfuQ6rzvoIX+Cb93sfMjk6LXHi0BJQtzDJGXMO2f0dXmiMGLq1bOp7Pzn3w4NXIox46Vqr8qC+v
 g15GyFUrFPyBsN/wFm+7LQUuMsdI8mm2GpkwQFLneCgI1qAPEJritCAi7RPwwNJ8sltnfsTr8ViLJlSrwOtlmW+RpLQa5hIbVtnemMiAwzBVVgmEEUrqCNYA
 rU54yNRvsCR8oaQ7Mq5Y1cNppAoERPWeMv611qc2eO+GIyyiV2fMrRjOvG3p3ZUuHnO1dGtP+DBN//8bTTzj1PZMzPOiZaLid3LCGPetROHYbNkuc/+5+sOF
 PZ/zbuptl7bKZ3TiBrtTmDMABy5f1p9BevFd+A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/12/2021 01:38, Ricardo Ribalda wrote:
> A lot of userspace depends on a descriptive name for vdev. Without this
> patch, users have a hard time figuring out which camera shall they use
> for their video conferencing.
> 
> This reverts commit e3f60e7e1a2b451f538f9926763432249bcf39c4.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: e3f60e7e1a2b ("media: uvcvideo: Set unique vdev name based in type")
> Reported-by: Nicolas Dufresne <nicolas@ndufresne.ca>
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Thanks!

	Hans

> ---
>  drivers/media/usb/uvc/uvc_driver.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index 7c007426e082..058d28a0344b 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2193,7 +2193,6 @@ int uvc_register_video_device(struct uvc_device *dev,
>  			      const struct v4l2_file_operations *fops,
>  			      const struct v4l2_ioctl_ops *ioctl_ops)
>  {
> -	const char *name;
>  	int ret;
>  
>  	/* Initialize the video buffers queue. */
> @@ -2222,20 +2221,16 @@ int uvc_register_video_device(struct uvc_device *dev,
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	default:
>  		vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> -		name = "Video Capture";
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>  		vdev->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> -		name = "Video Output";
>  		break;
>  	case V4L2_BUF_TYPE_META_CAPTURE:
>  		vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
> -		name = "Metadata";
>  		break;
>  	}
>  
> -	snprintf(vdev->name, sizeof(vdev->name), "%s %u", name,
> -		 stream->header.bTerminalLink);
> +	strscpy(vdev->name, dev->name, sizeof(vdev->name));
>  
>  	/*
>  	 * Set the driver data before calling video_register_device, otherwise
> 

