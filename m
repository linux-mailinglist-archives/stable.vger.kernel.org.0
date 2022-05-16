Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0277528B87
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 19:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344051AbiEPRE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 13:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344007AbiEPREU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 13:04:20 -0400
Received: from mail1.bemta35.messagelabs.com (mail1.bemta35.messagelabs.com [67.219.250.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A1C248F9
        for <stable@vger.kernel.org>; Mon, 16 May 2022 10:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1652720655; i=@motorola.com;
        bh=em6uw7kreOMEWrrwsp2XqxKezD72TRGb3tlISQxX/tE=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=kpUECtqtUS54RWiV/hE/tW4zF1W47gsiWgbPxQbPaGYVQi+oSeaMgF+uBaS/DE0+S
         9SyzE5KQ0p52LSLVzyn6HdMlfDBtcRe0m9OwaSbFKLoR4g1h9PEu3RySzd9rYA33B1
         Wz7AyHEv9phRkg4uj0Q5BsilaFjWs1aWv5sMxt45rTSypebZWaw6WBy3uAsEbXY5mL
         IHGcTqaKSnZUCGwvWNrItlIEODSHCLdJMNYI5d4CH4GX0445eIHkL82eU4R/hzkh9w
         p2WNs958SqTgilXV/bEt6970E85fKCT4Rxi9CbcQQBJiDRqjK+ZjPHNi2NAqqUD9L5
         c0h+8rN51SWig==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRWlGSWpSXmKPExsWS8eKJqC5fS1O
  SwZZ2OYvmxevZLBZsfMTowOSxf+4ado/Pm+QCmKJYM/OS8isSWDMO9k9hKXhtUnFr8WL2BsZe
  3S5GLg4hgSlMEse+bWSDcBYxSUw5sJu1i5GTg0VAVWLD/tfsIDabgJrEgtermEFsEQE5iSe3/
  4DZzAJSEus+HQJrFhZoZZQ4cOQ9E0iCV0BZYvXZ2YwgtpCAusTOs38ZIeKCEidnPmGBaNaSuP
  HvJVA9B5AtLbH8HwdImFNAQ+L7vVfMExh5ZyHpmIWkYxZCxwJG5lWM1klFmekZJbmJmTm6hgY
  GuoaGJmDazFIvsUo3Ua+0WLc8tbhE10gvsbxYL7W4WK+4Mjc5J0UvL7VkEyMwHFOKUlx3MG7u
  /6l3iFGSg0lJlPdIYVOSEF9SfkplRmJxRnxRaU5q8SFGGQ4OJQlejwagnGBRanpqRVpmDjA2Y
  NISHDxKIrypIGne4oLE3OLMdIjUKUZjjkuHruxl5rh6BUgKseTl56VKifP2NQGVCoCUZpTmwQ
  2CxewlRlkpYV5GBgYGIZ6C1KLczBJU+VeM4hyMSsK8pxqBpvBk5pXA7XsFdAoT0Cki+o0gp5Q
  kIqSkGpjSNRzfTOZff/bTI+b6ddezpWfeZ/y6LTReqJZtyg+/MCeZnlfr7x8usGa3KX3PJZq7
  rvD0juTfUvMdfi5MSm24/Hluc6ab4KL26jKLidO4426cqN/u4f8xkmFnzwaWG0ll/ice1cj/S
  Mo8zDDp5zamzItFiyZLB89r2bpe+oAT/7ytfo7hXTEzdh3KNdjI675JYKvHnce2xs5b3ffIVg
  u7XjuYYWp0W3k3W+PXP1tyZ0fkBnx+a2E0STrmf+/iz2n7z91MZhD+8FI9otF1Tae35I+ZK63
  nKtYbuGdxsSnZ8ck2+DGeXe4UJ1d+fN+hpooaHReD8xvjk3pcRDNWWfRFSKvkCWS9/Nx/SUx5
  kxJLcUaioRZzUXEiAC9F6AZUAwAA
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-17.tower-636.messagelabs.com!1652720653!1463!1
X-Originating-IP: [104.232.228.21]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.86.4; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 29225 invoked from network); 16 May 2022 17:04:14 -0000
Received: from unknown (HELO va32lpfpp01.lenovo.com) (104.232.228.21)
  by server-17.tower-636.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 16 May 2022 17:04:14 -0000
Received: from ilclmmrp02.lenovo.com (ilclmmrp02.mot.com [100.65.83.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp01.lenovo.com (Postfix) with ESMTPS id 4L25FT3TQSzf6mc;
        Mon, 16 May 2022 17:04:13 +0000 (UTC)
Received: from p1g3 (unknown [10.45.4.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp02.lenovo.com (Postfix) with ESMTPSA id 4L25FT1y0TzbxPp;
        Mon, 16 May 2022 17:04:13 +0000 (UTC)
Date:   Mon, 16 May 2022 12:04:08 -0500
From:   Dan Vacura <w36195@motorola.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: gadget: uvc: allow for application
 to cleanly shutdown" failed to apply to 5.10-stable tree
Message-ID: <YoKECFfK9zbgMvJn@p1g3>
References: <165268797312322@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165268797312322@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Greg,

On Mon, May 16, 2022 at 09:59:33AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Please cherry-pick e6bab2b66329b40462fb1bed6f98bc3fcf543a1c "usb:
gadget: uvc: rename function to be more consistent" before applying the
below patch.

I didn't realize it got tagged for stable. Ideally the submission (
https://lore.kernel.org/r/20220503201039.71720-1-w36195@motorola.com )
should've been:

Cc: <stable@vger.kernel.org> # 5.10+: e6bab2b66329: usb: gadget: uvc: rename function to be more consistent
Cc: <stable@vger.kernel.org> # 5.10+

Earlier than 5.10 is a bit more complicated.

Thanks,
Dan

> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From b81ac4395bbeaf36e078dea1a48c02dd97b76235 Mon Sep 17 00:00:00 2001
> From: Dan Vacura <w36195@motorola.com>
> Date: Tue, 3 May 2022 15:10:38 -0500
> Subject: [PATCH] usb: gadget: uvc: allow for application to cleanly shutdown
> 
> Several types of kernel panics can occur due to timing during the uvc
> gadget removal. This appears to be a problem with gadget resources being
> managed by both the client application's v4l2 open/close and the UDC
> gadget bind/unbind. Since the concept of USB_GADGET_DELAYED_STATUS
> doesn't exist for unbind, add a wait to allow for the application to
> close out.
> 
> Some examples of the panics that can occur are:
> 
> <1>[ 1147.652313] Unable to handle kernel NULL pointer dereference at
> virtual address 0000000000000028
> <4>[ 1147.652510] Call trace:
> <4>[ 1147.652514]  usb_gadget_disconnect+0x74/0x1f0
> <4>[ 1147.652516]  usb_gadget_deactivate+0x38/0x168
> <4>[ 1147.652520]  usb_function_deactivate+0x54/0x90
> <4>[ 1147.652524]  uvc_function_disconnect+0x14/0x38
> <4>[ 1147.652527]  uvc_v4l2_release+0x34/0xa0
> <4>[ 1147.652537]  __fput+0xdc/0x2c0
> <4>[ 1147.652540]  ____fput+0x10/0x1c
> <4>[ 1147.652545]  task_work_run+0xe4/0x12c
> <4>[ 1147.652549]  do_notify_resume+0x108/0x168
> 
> <1>[  282.950561][ T1472] Unable to handle kernel NULL pointer
> dereference at virtual address 00000000000005b8
> <6>[  282.953111][ T1472] Call trace:
> <6>[  282.953121][ T1472]  usb_function_deactivate+0x54/0xd4
> <6>[  282.953134][ T1472]  uvc_v4l2_release+0xac/0x1e4
> <6>[  282.953145][ T1472]  v4l2_release+0x134/0x1f0
> <6>[  282.953167][ T1472]  __fput+0xf4/0x428
> <6>[  282.953178][ T1472]  ____fput+0x14/0x24
> <6>[  282.953193][ T1472]  task_work_run+0xac/0x130
> 
> <3>[  213.410077][   T29] configfs-gadget gadget: uvc: Failed to queue
> request (-108).
> <1>[  213.410116][   T29] Unable to handle kernel NULL pointer
> dereference at virtual address 0000000000000003
> <6>[  213.413460][   T29] Call trace:
> <6>[  213.413474][   T29]  uvcg_video_pump+0x1f0/0x384
> <6>[  213.413489][   T29]  process_one_work+0x2a4/0x544
> <6>[  213.413502][   T29]  worker_thread+0x350/0x784
> <6>[  213.413515][   T29]  kthread+0x2ac/0x320
> <6>[  213.413528][   T29]  ret_from_fork+0x10/0x30
> 
> Signed-off-by: Dan Vacura <w36195@motorola.com>
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20220503201039.71720-1-w36195@motorola.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
> index 71bb5e477dba..d37965867b23 100644
> --- a/drivers/usb/gadget/function/f_uvc.c
> +++ b/drivers/usb/gadget/function/f_uvc.c
> @@ -890,13 +890,37 @@ static void uvc_function_unbind(struct usb_configuration *c,
>  {
>  	struct usb_composite_dev *cdev = c->cdev;
>  	struct uvc_device *uvc = to_uvc(f);
> +	long wait_ret = 1;
>  
>  	uvcg_info(f, "%s()\n", __func__);
>  
> +	/* If we know we're connected via v4l2, then there should be a cleanup
> +	 * of the device from userspace either via UVC_EVENT_DISCONNECT or
> +	 * though the video device removal uevent. Allow some time for the
> +	 * application to close out before things get deleted.
> +	 */
> +	if (uvc->func_connected) {
> +		uvcg_dbg(f, "waiting for clean disconnect\n");
> +		wait_ret = wait_event_interruptible_timeout(uvc->func_connected_queue,
> +				uvc->func_connected == false, msecs_to_jiffies(500));
> +		uvcg_dbg(f, "done waiting with ret: %ld\n", wait_ret);
> +	}
> +
>  	device_remove_file(&uvc->vdev.dev, &dev_attr_function_name);
>  	video_unregister_device(&uvc->vdev);
>  	v4l2_device_unregister(&uvc->v4l2_dev);
>  
> +	if (uvc->func_connected) {
> +		/* Wait for the release to occur to ensure there are no longer any
> +		 * pending operations that may cause panics when resources are cleaned
> +		 * up.
> +		 */
> +		uvcg_warn(f, "%s no clean disconnect, wait for release\n", __func__);
> +		wait_ret = wait_event_interruptible_timeout(uvc->func_connected_queue,
> +				uvc->func_connected == false, msecs_to_jiffies(1000));
> +		uvcg_dbg(f, "done waiting for release with ret: %ld\n", wait_ret);
> +	}
> +
>  	usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
>  	kfree(uvc->control_buf);
>  
> @@ -915,6 +939,7 @@ static struct usb_function *uvc_alloc(struct usb_function_instance *fi)
>  
>  	mutex_init(&uvc->video.mutex);
>  	uvc->state = UVC_STATE_DISCONNECTED;
> +	init_waitqueue_head(&uvc->func_connected_queue);
>  	opts = fi_to_f_uvc_opts(fi);
>  
>  	mutex_lock(&opts->lock);
> diff --git a/drivers/usb/gadget/function/uvc.h b/drivers/usb/gadget/function/uvc.h
> index c3607a32b986..886103a1fe9b 100644
> --- a/drivers/usb/gadget/function/uvc.h
> +++ b/drivers/usb/gadget/function/uvc.h
> @@ -14,6 +14,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/usb/composite.h>
>  #include <linux/videodev2.h>
> +#include <linux/wait.h>
>  
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-dev.h>
> @@ -129,6 +130,7 @@ struct uvc_device {
>  	struct usb_function func;
>  	struct uvc_video video;
>  	bool func_connected;
> +	wait_queue_head_t func_connected_queue;
>  
>  	/* Descriptors */
>  	struct {
> diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
> index a2c78690c5c2..fd8f73bb726d 100644
> --- a/drivers/usb/gadget/function/uvc_v4l2.c
> +++ b/drivers/usb/gadget/function/uvc_v4l2.c
> @@ -253,10 +253,11 @@ uvc_v4l2_subscribe_event(struct v4l2_fh *fh,
>  
>  static void uvc_v4l2_disable(struct uvc_device *uvc)
>  {
> -	uvc->func_connected = false;
>  	uvc_function_disconnect(uvc);
>  	uvcg_video_enable(&uvc->video, 0);
>  	uvcg_free_buffers(&uvc->video.queue);
> +	uvc->func_connected = false;
> +	wake_up_interruptible(&uvc->func_connected_queue);
>  }
>  
>  static int
> 
