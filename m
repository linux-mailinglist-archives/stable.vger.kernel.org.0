Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468BC5FCC4D
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 22:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiJLUpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 16:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJLUox (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 16:44:53 -0400
Received: from mail1.bemta33.messagelabs.com (mail1.bemta33.messagelabs.com [67.219.247.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF51165AC;
        Wed, 12 Oct 2022 13:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1665607486; i=@motorola.com;
        bh=NuV/ZGwsWjAzsHDHgnc/JPfaJ5DcepwLsVMqiW5NXXA=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=GrKHdhxGg/SpLG/5AeENWlQLQsnmn8vjm5/L4ImleGBcYo6mgxvmbOVuuboQ4sce7
         nXCmKXfUsf6aRmCAjiz4o3Ca6qqyNJAgYR7V7cgUIqEkmpAog14PDnpl5x0Xrlp1me
         1Zh1QUTUpc3BjjvcQCdtf0rCRVkT/UaRgG7mATpis0JeLn53Pzz3nK9/xmNdKM8eou
         vvkEysWBmGHan4ZVmh4R0ZTTO/1sZ0ghGOevqhi2o5akYGv4t0QA340rV6LaDV+KgE
         YIMKiYWkABEhYVe/GIqOHDkKCpvew8s3crucLBnmgncmQipiqB+STlxrRitNxykRmP
         NVq7YykEO2pGg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleJIrShJLcpLzFFi42LJePFETNdG3T3
  Z4N1qa4tjbU/YLZ4caGe06F22h82iefF6NovOiUvYLRa2LWGxuLxrDpvFomWtzBZb2q4wWfz4
  08dssWDjI0aLVQsOsDvweMzumMnqsWlVJ5vH/rlr2D0W901m9ej/a+CxZf9nRo/Pm+QC2KNYM
  /OS8isSWDNO7XjMXvDJuaLh7T7WBsadFl2MnBxCAjOYJN5fCOpi5AKyFzNJfNuyngkkwSKgKv
  G38S8ziM0moCax4PUqMFtEQFbi8JXfzCANzALbmCV6rm9mA0kIC4RKPFzRCWRzcPAKKEvceFs
  HsSBD4v7nw4wgNq+AoMTJmU9YQGxmAS2JG/9eMoGUMwtISyz/xwES5hSwkph85BvrBEbeWUg6
  ZiHpmIXQsYCReRWjdVJRZnpGSW5iZo6uoYGBrqGhia6ZGZCy1Eus0k3UKy3WTU0sLtE10kssL
  9ZLLS7WK67MTc5J0ctLLdnECIyPlCKn8h2MTSt/6h1ilORgUhLlPczmnizEl5SfUpmRWJwRX1
  Sak1p8iFGGg0NJgpdDDSgnWJSanlqRlpkDjFWYtAQHj5II71xJoDRvcUFibnFmOkTqFKMxx9T
  Z//Yzc3Tu7zrALMSSl5+XKiXOe0oVqFQApDSjNA9uECyFXGKUlRLmZWRgYBDiKUgtys0sQZV/
  xSjOwagkzPsdZApPZl4J3L5XQKcwAZ2y9JQbyCkliQgpqQYm8a05EnO6JWr6y49wZPpdexo08
  efkZqakPeldMyYqpd/ivb7h+aKrOsHJtguXTF902sIwJurcxSfxO25FzIyueG67Oa9iE9f5A5
  fTXmfkrGGJvjBph9ws2f3Ljsz4f9pYL5xxkWP8ohf1X1k3+27Iu8Hloz555WmDAylah69zXps
  Y4JTbOaWEL7gq36Tpn5GJbNX53I1mf0Nj9/EeD1pmOXk9dxT/wmkbnCtEFk7Sj2yeuMrjPUfE
  vwdqpufWm0t9PmL74MUfAd3uW/+W2nTrcTMoz9+8R/7G4y/cyg0f9S5zx234u/mL2zM/o7V3e
  v7vmpd+5MzXSilNfbYXq5ZJR3/cXX9Q1cdkAkPRNI8VHEosxRmJhlrMRcWJAKoOu8mcAwAA
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-7.tower-635.messagelabs.com!1665607484!45916!1
X-Originating-IP: [104.232.228.22]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 26666 invoked from network); 12 Oct 2022 20:44:44 -0000
Received: from unknown (HELO va32lpfpp02.lenovo.com) (104.232.228.22)
  by server-7.tower-635.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 12 Oct 2022 20:44:44 -0000
Received: from va32lmmrp02.lenovo.com (va32lmmrp02.mot.com [10.62.176.191])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp02.lenovo.com (Postfix) with ESMTPS id 4Mnl58409Dz50GH2;
        Wed, 12 Oct 2022 20:44:44 +0000 (UTC)
Received: from p1g3 (unknown [10.45.5.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by va32lmmrp02.lenovo.com (Postfix) with ESMTPSA id 4Mnl580lVZzftPJ;
        Wed, 12 Oct 2022 20:44:44 +0000 (UTC)
Date:   Wed, 12 Oct 2022 15:44:37 -0500
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/3] usb: gadget: uvc: make interrupt skip logic
 configurable
Message-ID: <Y0cnNSE+pHOQ0mMo@p1g3>
References: <20221011183437.298437-1-w36195@motorola.com>
 <20221011183437.298437-2-w36195@motorola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011183437.298437-2-w36195@motorola.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It looks like configurability of interrupt throttling is not in favor,
but if we do proceed with this patch, I'll need to fix some logic. I
found a bug where req_int_skip_div will have a stale value used with
repeated resolution switches.

This fixes the bug:

diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 003c2d610e61..b7a5681d5f85 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -649,7 +649,7 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
                cpu_to_le16(max_packet_size * max_packet_mult *
                            (opts->streaming_maxburst + 1));

-       uvc->video.req_int_skip_div = opts->req_int_skip_div;
+       uvc->config_skip_int_div = opts->req_int_skip_div;
        uvc->video.queue.use_sg = opts->sg_supported;

        /* Allocate endpoints. */
diff --git a/drivers/usb/gadget/function/uvc.h b/drivers/usb/gadget/function/uvc.h
index ddca23680c35..e7033cce0a43 100644
--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -153,6 +153,7 @@ struct uvc_device {
        /* Events */
        unsigned int event_length;
        unsigned int event_setup_out : 1;
+       unsigned int config_skip_int_div;
 };

 static inline struct uvc_device *to_uvc(struct usb_function *f)
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index c7b76ac36194..b6fada4eab12 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -63,11 +63,11 @@ static int uvc_queue_setup(struct vb2_queue *vq,
         */
        nreq = DIV_ROUND_UP(DIV_ROUND_UP(sizes[0], 2), req_size);
        nreq = clamp(nreq, 4U, 64U);
-       if (0 == video->req_int_skip_div) {
+       if (0 == video->uvc->config_skip_int_div) {
                video->req_int_skip_div = nreq;
        } else {
-               video->req_int_skip_div =
-                       min_t(unsigned int, nreq, video->req_int_skip_div);
+               video->req_int_skip_div = min_t(unsigned int, nreq,
+                               video->uvc->config_skip_int_div);
        }
        video->uvc_num_requests = nreq;

On Tue, Oct 11, 2022 at 01:34:33PM -0500, Dan Vacura wrote:
> Some UDC hw may not support skipping interrupts, but still support the
> request. Allow the interrupt frequency to be configurable to the user.
> Default to not skip interrupts, a value of 0. This fixes a smmu panic
> that is occurring on dwc3 hw.
> 
> Fixes: fc78941d8169 ("usb: gadget: uvc: decrease the interrupt load to a quarter")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Vacura <w36195@motorola.com>
> ---
> V1 -> V2:
> - no change, new patch in series
> 
>  Documentation/ABI/testing/configfs-usb-gadget-uvc | 1 +
>  Documentation/usb/gadget-testing.rst              | 2 ++
>  drivers/usb/gadget/function/f_uvc.c               | 3 +++
>  drivers/usb/gadget/function/u_uvc.h               | 1 +
>  drivers/usb/gadget/function/uvc.h                 | 1 +
>  drivers/usb/gadget/function/uvc_configfs.c        | 2 ++
>  drivers/usb/gadget/function/uvc_queue.c           | 6 ++++++
>  drivers/usb/gadget/function/uvc_video.c           | 3 ++-
>  8 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/configfs-usb-gadget-uvc b/Documentation/ABI/testing/configfs-usb-gadget-uvc
> index 611b23e6488d..5dfaa3f7f6a4 100644
> --- a/Documentation/ABI/testing/configfs-usb-gadget-uvc
> +++ b/Documentation/ABI/testing/configfs-usb-gadget-uvc
> @@ -8,6 +8,7 @@ Description:	UVC function directory
>  		streaming_maxpacket	1..1023 (fs), 1..3072 (hs/ss)
>  		streaming_interval	1..16
>  		function_name		string [32]
> +		req_int_skip_div	unsigned int
>  		===================	=============================
>  
>  What:		/config/usb-gadget/gadget/functions/uvc.name/control
> diff --git a/Documentation/usb/gadget-testing.rst b/Documentation/usb/gadget-testing.rst
> index 2278c9ffb74a..f9b5a09be1f4 100644
> --- a/Documentation/usb/gadget-testing.rst
> +++ b/Documentation/usb/gadget-testing.rst
> @@ -794,6 +794,8 @@ The uvc function provides these attributes in its function directory:
>  			    sending or receiving when this configuration is
>  			    selected
>  	function_name       name of the interface
> +	req_int_skip_div    divisor of total requests to aid in calculating
> +			    interrupt frequency, 0 indicates all interrupt
>  	=================== ================================================
>  
>  There are also "control" and "streaming" subdirectories, each of which contain
> diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
> index 6e196e06181e..75f524c83996 100644
> --- a/drivers/usb/gadget/function/f_uvc.c
> +++ b/drivers/usb/gadget/function/f_uvc.c
> @@ -655,6 +655,8 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
>  		cpu_to_le16(max_packet_size * max_packet_mult *
>  			    (opts->streaming_maxburst + 1));
>  
> +	uvc->video.req_int_skip_div = opts->req_int_skip_div;
> +
>  	/* Allocate endpoints. */
>  	ep = usb_ep_autoconfig(cdev->gadget, &uvc_control_ep);
>  	if (!ep) {
> @@ -872,6 +874,7 @@ static struct usb_function_instance *uvc_alloc_inst(void)
>  
>  	opts->streaming_interval = 1;
>  	opts->streaming_maxpacket = 1024;
> +	opts->req_int_skip_div = 0;
>  	snprintf(opts->function_name, sizeof(opts->function_name), "UVC Camera");
>  
>  	ret = uvcg_attach_configfs(opts);
> diff --git a/drivers/usb/gadget/function/u_uvc.h b/drivers/usb/gadget/function/u_uvc.h
> index 24b8681b0d6f..6f73bd5638ed 100644
> --- a/drivers/usb/gadget/function/u_uvc.h
> +++ b/drivers/usb/gadget/function/u_uvc.h
> @@ -24,6 +24,7 @@ struct f_uvc_opts {
>  	unsigned int					streaming_interval;
>  	unsigned int					streaming_maxpacket;
>  	unsigned int					streaming_maxburst;
> +	unsigned int					req_int_skip_div;
>  
>  	unsigned int					control_interface;
>  	unsigned int					streaming_interface;
> diff --git a/drivers/usb/gadget/function/uvc.h b/drivers/usb/gadget/function/uvc.h
> index 40226b1f7e14..53175cd564e5 100644
> --- a/drivers/usb/gadget/function/uvc.h
> +++ b/drivers/usb/gadget/function/uvc.h
> @@ -107,6 +107,7 @@ struct uvc_video {
>  	spinlock_t req_lock;
>  
>  	unsigned int req_int_count;
> +	unsigned int req_int_skip_div;
>  
>  	void (*encode) (struct usb_request *req, struct uvc_video *video,
>  			struct uvc_buffer *buf);
> diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
> index 4303a3283ba0..419e926ab57e 100644
> --- a/drivers/usb/gadget/function/uvc_configfs.c
> +++ b/drivers/usb/gadget/function/uvc_configfs.c
> @@ -2350,6 +2350,7 @@ UVC_ATTR(f_uvc_opts_, cname, cname)
>  UVCG_OPTS_ATTR(streaming_interval, streaming_interval, 16);
>  UVCG_OPTS_ATTR(streaming_maxpacket, streaming_maxpacket, 3072);
>  UVCG_OPTS_ATTR(streaming_maxburst, streaming_maxburst, 15);
> +UVCG_OPTS_ATTR(req_int_skip_div, req_int_skip_div, UINT_MAX);
>  
>  #undef UVCG_OPTS_ATTR
>  
> @@ -2399,6 +2400,7 @@ static struct configfs_attribute *uvc_attrs[] = {
>  	&f_uvc_opts_attr_streaming_interval,
>  	&f_uvc_opts_attr_streaming_maxpacket,
>  	&f_uvc_opts_attr_streaming_maxburst,
> +	&f_uvc_opts_attr_req_int_skip_div,
>  	&f_uvc_opts_string_attr_function_name,
>  	NULL,
>  };
> diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
> index ec500ee499ee..872d545838ee 100644
> --- a/drivers/usb/gadget/function/uvc_queue.c
> +++ b/drivers/usb/gadget/function/uvc_queue.c
> @@ -63,6 +63,12 @@ static int uvc_queue_setup(struct vb2_queue *vq,
>  	 */
>  	nreq = DIV_ROUND_UP(DIV_ROUND_UP(sizes[0], 2), req_size);
>  	nreq = clamp(nreq, 4U, 64U);
> +	if (0 == video->req_int_skip_div) {
> +		video->req_int_skip_div = nreq;
> +	} else {
> +		video->req_int_skip_div =
> +			min_t(unsigned int, nreq, video->req_int_skip_div);
> +	}
>  	video->uvc_num_requests = nreq;
>  
>  	return 0;
> diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
> index bb037fcc90e6..241df42ce0ae 100644
> --- a/drivers/usb/gadget/function/uvc_video.c
> +++ b/drivers/usb/gadget/function/uvc_video.c
> @@ -413,7 +413,8 @@ static void uvcg_video_pump(struct work_struct *work)
>  		if (list_empty(&video->req_free) ||
>  		    buf->state == UVC_BUF_STATE_DONE ||
>  		    !(video->req_int_count %
> -		       DIV_ROUND_UP(video->uvc_num_requests, 4))) {
> +		       DIV_ROUND_UP(video->uvc_num_requests,
> +			       video->req_int_skip_div))) {
>  			video->req_int_count = 0;
>  			req->no_interrupt = 0;
>  		} else {
> -- 
> 2.34.1
> 
