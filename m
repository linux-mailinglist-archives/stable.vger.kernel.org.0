Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9985EC88D
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 17:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiI0Puq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 11:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiI0PuV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 11:50:21 -0400
Received: from mail1.bemta31.messagelabs.com (mail1.bemta31.messagelabs.com [67.219.246.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F525E651;
        Tue, 27 Sep 2022 08:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1664293682; i=@motorola.com;
        bh=muqfVUx/mpxcI3+xSxkIJS8bgdxtr+N6oOA1TE2KqkI=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=JJ7XeU4VCCH925Ia2amsr+6tanQuQcnsu0b8J6H9SwczDmAfq53rqQGTo6dOATwgB
         LSXLcbecK/TY9naZ72S60O6AtD70cZ/KVaqCWLKv4MPOXh0Tx8Pvo1a1z4rtVHbeSq
         Xk7eUWWUVZXePkB5glugz2iFFN0ggeUoRmZYZUvzhm8O2ab4u29kEJRdG+RheghSBB
         o4IUnDlqQF0xq8oFtNU7kP9TSzrhYZtAnXqsGZE3vciz+u0Slla22fr5m+H7d+MyxC
         Vug2RkEdv5p9OgtddZAFvqsyWhp4TjMkLnE5+YqO7Ef+DdLlILQPCrxgvIHBLuTPJm
         d8dVmYSkN4XKA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRWlGSWpSXmKPExsWS8eKJuK6htHG
  yQftcY4tjbU/YLZoXr2ez6Jy4hN3i8q45bBaLlrUyW2xpu8JksWDjI0aLVQsOsDtweMzumMnq
  sWlVJ5vH/rlr2D36/xp4bNn/mdHj8ya5ALYo1sy8pPyKBNaMbTuWMxZ0WlfM2LWSqYFxt0EXI
  xeHkMAMJon9nS+YIJxlTBINr2awdDFycLAIqErc7SvtYuTkYBNQk1jwehUziC0iYCzRf3YWO0
  g9s0AnUPPfN2AJYQEXiaVrFoDZvALKEgt+noca2sYosXPpdBaIhKDEyZlPwGxmAS2JG/9eMoE
  sYxaQllj+jwMkzCmgKbFj6S2WCYy8s5B0zELSMQuhYwEj8ypGq6SizPSMktzEzBxdQwMDXUND
  E11zXUNzM73EKt1EvdJi3dTE4hJdQ73E8mK91OJiveLK3OScFL281JJNjMBwTyli37CDcV7PT
  71DjJIcTEqivLv/GiUL8SXlp1RmJBZnxBeV5qQWH2KU4eBQkuCdJGmcLCRYlJqeWpGWmQOMPZ
  i0BAePkghvFEiat7ggMbc4Mx0idYrRmGPq7H/7mTk693cdYBZiycvPS5US5/WQAioVACnNKM2
  DGwRLCZcYZaWEeRkZGBiEeApSi3IzS1DlXzGKczAqCfMyg0zhycwrgdv3CugUJqBTPjKBnVKS
  iJCSamDin6gdOT2i7NWO9L8v08WkKy/3yvze9u/FDKl9JfqG/G82Tjrcmcy/c4vcPCG+l+29l
  hoXTDj8OK/3vmkQD1OIbC3ujDeYIGN73nHNYq9Cv5R/z1h00rIOrHg4V2fznzIHYW+m5hebzx
  dp/rj07mWpQf3mYwUbrwhkp81sVA09N8tw25kXGSe4rQV/pOQXVUSbhn06HnwnMVfCK31OZ6X
  o0UMzMqzMhWbumaAwNUghLPnA5JtnfV4Gvl4mat3/UNa852tjmWRw1MEOXW2hayViPs+aNC55
  LD2au4bjf7FE6u0f3qWOcl57+ZL40rjufky723FQKmX6P96I7bYzP4d8Xbdpi7GQ1L9nRWKKT
  UosxRmJhlrMRcWJAKkVXkqEAwAA
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-16.tower-686.messagelabs.com!1664293681!93017!1
X-Originating-IP: [104.232.228.23]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 23920 invoked from network); 27 Sep 2022 15:48:01 -0000
Received: from unknown (HELO va32lpfpp03.lenovo.com) (104.232.228.23)
  by server-16.tower-686.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 27 Sep 2022 15:48:01 -0000
Received: from va32lmmrp01.lenovo.com (va32lmmrp01.mot.com [10.62.177.113])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp03.lenovo.com (Postfix) with ESMTPS id 4McPCj4BVFz50WfM;
        Tue, 27 Sep 2022 15:48:01 +0000 (UTC)
Received: from p1g3 (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by va32lmmrp01.lenovo.com (Postfix) with ESMTPSA id 4McPCj2SZJzf6f8;
        Tue, 27 Sep 2022 15:48:01 +0000 (UTC)
Date:   Tue, 27 Sep 2022 10:47:55 -0500
From:   Dan Vacura <w36195@motorola.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: fix sg handling in error case
Message-ID: <YzMbK0ZZ08WD8ql+@p1g3>
References: <20220926195307.110121-1-w36195@motorola.com>
 <20220926195307.110121-2-w36195@motorola.com>
 <YzK1Xry5KIrMr18F@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzK1Xry5KIrMr18F@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Sep 27, 2022 at 10:33:34AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Sep 26, 2022 at 02:53:07PM -0500, Dan Vacura wrote:
> > If there is a transmission error the buffer will be returned too early,
> > causing a memory fault as subsequent requests for that buffer are still
> > queued up to be sent. Refactor the error handling to wait for the final
> > request to come in before reporting back the buffer to userspace for all
> > transfer types (bulk/isoc/isoc_sg) to ensure userspace knows if the
> > frame was successfully sent.
> > 
> > Fixes: e81e7f9a0eb9 ("usb: gadget: uvc: add scatter gather support")
> > Cc: <stable@vger.kernel.org> # 859c675d84d4: usb: gadget: uvc: consistently use define for headerlen
> > Cc: <stable@vger.kernel.org> # f262ce66d40c: usb: gadget: uvc: use on returned header len in video_encode_isoc_sg
> > Cc: <stable@vger.kernel.org> # 61aa709ca58a: usb: gadget: uvc: rework uvcg_queue_next_buffer to uvcg_complete_buffer
> > Cc: <stable@vger.kernel.org> # 9b969f93bcef: usb: gadget: uvc: giveback vb2 buffer on req complete
> > Cc: <stable@vger.kernel.org> # aef11279888c: usb: gadget: uvc: improve sg exit condition
> 
> I don't understand, why we backport all of these commits to 5.15.y if
> the original problem isn't in 5.15.y?
> 
> Or is it?
> 
> I'm confused,

It seems we have a regression in 5.15 with some recent, still in
development, features for the uvc gadget driver. Compared to the last
kernel I worked with, 5.10, I'm seeing stability and functional issues
in 5.15, explained in my summary here:
https://lore.kernel.org/all/20220926195307.110121-1-w36195@motorola.com/

I think we have few approaches.
1) Work through these issues and get the fixes into mainline and stable
versions, this patch starts that effort, but there's still more work to
be done.
2) Revert the changes that are causing regressions in 5.15 (two changes
from what I can see).
3) Add a configfs ability to allow sg isoc transfers and couple the
quarter interrupt logic to only sg xfers.

Approach 2 is my preference, as there are issues still present that need
to be figured out. However, I don't know how we can revert to just a
stable line. I'm basically looking for feedback and input for the next
steps, and if it's just me with these issues on 5.15.

> 
> greg k-h
> 
> 
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Dan Vacura <w36195@motorola.com>
> > 
> > ---
> >  drivers/usb/gadget/function/uvc_queue.c |  8 +++++---
> >  drivers/usb/gadget/function/uvc_queue.h |  2 +-
> >  drivers/usb/gadget/function/uvc_video.c | 18 ++++++++++++++----
> >  3 files changed, 20 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
> > index ec500ee499ee..72e7ffd9a021 100644
> > --- a/drivers/usb/gadget/function/uvc_queue.c
> > +++ b/drivers/usb/gadget/function/uvc_queue.c
> > @@ -304,6 +304,7 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
> >  
> >  		queue->sequence = 0;
> >  		queue->buf_used = 0;
> > +		queue->flags &= ~UVC_QUEUE_MISSED_XFER;
> >  	} else {
> >  		ret = vb2_streamoff(&queue->queue, queue->queue.type);
> >  		if (ret < 0)
> > @@ -329,10 +330,11 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
> >  void uvcg_complete_buffer(struct uvc_video_queue *queue,
> >  					  struct uvc_buffer *buf)
> >  {
> > -	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
> > -	     buf->length != buf->bytesused) {
> > -		buf->state = UVC_BUF_STATE_QUEUED;
> > +	if ((queue->flags & UVC_QUEUE_MISSED_XFER)) {
> > +		queue->flags &= ~UVC_QUEUE_MISSED_XFER;
> > +		buf->state = UVC_BUF_STATE_ERROR;
> >  		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
> > +		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
> >  		return;
> >  	}
> >  
> > diff --git a/drivers/usb/gadget/function/uvc_queue.h b/drivers/usb/gadget/function/uvc_queue.h
> > index 41f87b917f6b..741ec58ae9bb 100644
> > --- a/drivers/usb/gadget/function/uvc_queue.h
> > +++ b/drivers/usb/gadget/function/uvc_queue.h
> > @@ -42,7 +42,7 @@ struct uvc_buffer {
> >  };
> >  
> >  #define UVC_QUEUE_DISCONNECTED		(1 << 0)
> > -#define UVC_QUEUE_DROP_INCOMPLETE	(1 << 1)
> > +#define UVC_QUEUE_MISSED_XFER 		(1 << 1)
> 
> Why change the name of the error?

I thought MISSED_XFER was a more explicit name to what is going on,
instead of an action. I can change it back.

> 
> >  
> >  struct uvc_video_queue {
> >  	struct vb2_queue queue;
> > diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
> > index bb037fcc90e6..e46591b067a8 100644
> > --- a/drivers/usb/gadget/function/uvc_video.c
> > +++ b/drivers/usb/gadget/function/uvc_video.c
> > @@ -88,6 +88,7 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
> >  		struct uvc_buffer *buf)
> >  {
> >  	void *mem = req->buf;
> > +	struct uvc_request *ureq = req->context;
> >  	int len = video->req_size;
> >  	int ret;
> >  
> > @@ -113,13 +114,14 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
> >  		video->queue.buf_used = 0;
> >  		buf->state = UVC_BUF_STATE_DONE;
> >  		list_del(&buf->queue);
> > -		uvcg_complete_buffer(&video->queue, buf);
> >  		video->fid ^= UVC_STREAM_FID;
> > +		ureq->last_buf = buf;
> >  
> >  		video->payload_size = 0;
> >  	}
> >  
> >  	if (video->payload_size == video->max_payload_size ||
> > +	    video->queue.flags & UVC_QUEUE_MISSED_XFER ||
> >  	    buf->bytesused == video->queue.buf_used)
> >  		video->payload_size = 0;
> >  }
> > @@ -180,7 +182,8 @@ uvc_video_encode_isoc_sg(struct usb_request *req, struct uvc_video *video,
> >  	req->length -= len;
> >  	video->queue.buf_used += req->length - header_len;
> >  
> > -	if (buf->bytesused == video->queue.buf_used || !buf->sg) {
> > +	if (buf->bytesused == video->queue.buf_used || !buf->sg ||
> > +			video->queue.flags & UVC_QUEUE_MISSED_XFER) {
> >  		video->queue.buf_used = 0;
> >  		buf->state = UVC_BUF_STATE_DONE;
> >  		buf->offset = 0;
> > @@ -195,6 +198,7 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
> >  		struct uvc_buffer *buf)
> >  {
> >  	void *mem = req->buf;
> > +	struct uvc_request *ureq = req->context;
> >  	int len = video->req_size;
> >  	int ret;
> >  
> > @@ -209,12 +213,13 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
> >  
> >  	req->length = video->req_size - len;
> >  
> > -	if (buf->bytesused == video->queue.buf_used) {
> > +	if (buf->bytesused == video->queue.buf_used ||
> > +			video->queue.flags & UVC_QUEUE_MISSED_XFER) {
> >  		video->queue.buf_used = 0;
> >  		buf->state = UVC_BUF_STATE_DONE;
> >  		list_del(&buf->queue);
> > -		uvcg_complete_buffer(&video->queue, buf);
> >  		video->fid ^= UVC_STREAM_FID;
> > +		ureq->last_buf = buf;
> >  	}
> >  }
> >  
> > @@ -255,6 +260,11 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
> >  	case 0:
> >  		break;
> >  
> > +	case -EXDEV:
> > +		uvcg_info(&video->uvc->func, "VS request missed xfer.\n");
> 
> Why are you spamming the kernel logs at the info level for a USB
> transmission problem?   That could get very noisy, please change this to
> be at the debug level.

Previously this would printout as a dev_warn in a725d0f6dfc5 ("usb:
gadget: uvc: call uvc uvcg_warn on completed status instead of
uvcg_info"), which I think might be too noisy. Info is helpful to
see what's going on if there is video corruption, but I can change to a
dbg as well.

> 
> thanks,
> 
> greg k-h


Appreciate the input,

Dan
