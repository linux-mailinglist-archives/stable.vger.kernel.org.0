Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22F94E69C1
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 21:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353361AbiCXUZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 16:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236500AbiCXUZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 16:25:13 -0400
Received: from mail1.bemta33.messagelabs.com (mail1.bemta33.messagelabs.com [67.219.247.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00655B6E4A;
        Thu, 24 Mar 2022 13:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1648153420; i=@motorola.com;
        bh=EtFQHRKPGWj6kQ7alPkt9Qz1coxOsxfkUKXJIZ9ZO7M=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=Vb3jYeT2TG1naK6CIy1r8x20Upysw1nq+Rg1hFoqqnfWm3uAdEDZSbgMNXb8bXwDX
         SeTcUzNKmGsPnpzxdAoY8T9yXJEMAFHJqIxTV6b2wz7Kd2Hd+DtwfOCkBGyQletJ9j
         ZuIvqzOCiIyze4wq0PUZjkUhQ6MNve1l0Q5DgMzevgZEHqw+HGyJylFyBm49A6PP8E
         Hi+bHGr0bODsCQhty+qgM5qYTKhiASgbBNBQJUX+sAZpkDHLG6y+0IJFeqYGUSMa5W
         K5do/8ic2uIdc9wtPL1AtPb951FT2UQh7Lt+qVw308vG0DKCvgyUJrGI4VrcKKJLYu
         v1gnv1xXWnypw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRWlGSWpSXmKPExsWS8eKJqK73ZZs
  kg/9vZSyOtT1ht1i9+CqTRfPi9WwWnROXsFtc3jWHzWLRslZmix9/+pgtFmx8xOjA4TG7Yyar
  x6ZVnWwe++euYfd4+mMvs8fnTXIBrFGsmXlJ+RUJrBknnqxnL+hUrvg1s4m9gXGybBcjF4eQw
  FQmiSkL/jFCOIuYJG6sXM/UxcjBwSKgKnHtW00XIycHm4CaxILXq5hBbBEBC4neRdPB6pkF/j
  BKPOueCFYvLBAucWOZDEgNr4CyRPPr5WwgtpBAukTz9q9MEHFBiZMzn7CA2MwCWhI3/r0Ea2U
  WkJZY/o8DJMwpYCXx/t1FtgmMvLOQdMxC0jELoWMBI/MqRuukosz0jJLcxMwcXUMDA11DQxNd
  M0tdI2MzvcQq3US90mLd1MTiEl0jvcTyYr3U4mK94src5JwUvbzUkk2MwCBPKXJ9s4Px+Yqfe
  ocYJTmYlER532yySRLiS8pPqcxILM6ILyrNSS0+xCjDwaEkwfvyIlBOsCg1PbUiLTMHGHEwaQ
  kOHiUR3toTQGne4oLE3OLMdIjUKUZjjkuHruxl5nh6FUgKseTl56VKifMWgEwSACnNKM2DGwR
  LBJcYZaWEeRkZGBiEeApSi3IzS1DlXzGKczAqCfPuB5nCk5lXArfvFdApTECnPP9pCXJKSSJC
  SqqBqSjO4Jj9s1+b+S9Kndaev7ZqhsG66RlPqubciPo4uezCR4EHBesZLS1vdDnXb/axcb5q5
  rRR/WT3t0SP5Wd2PhHrb4vz45j3QTnkmY1U7BvpTRybzpeHXXsuy5a3le+pvPUM5/8F71U9ql
  gVxU8UPaq/byLMV6UT9O6eSJ181oVGT5PvyQL/8z9MZUyq7+TdNiVD9DX3sXUiW2V+W77p+9Q
  SmLH/xKTkXdtX2gacWuS/l8nfNizxjtmstT+vaJw4nhbH/EZxe1/rSu79jT/6va2vrBS7pRSb
  vW53nKzFuW0M3y448fRlMnHkcW1ff0RMvchyqufzLG7hNeoOG80aYivEE/xXiRQcKZZbIvVJi
  aU4I9FQi7moOBEAmYDqXH8DAAA=
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-8.tower-715.messagelabs.com!1648153419!14576!1
X-Originating-IP: [104.232.228.21]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.10; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 30146 invoked from network); 24 Mar 2022 20:23:39 -0000
Received: from unknown (HELO va32lpfpp01.lenovo.com) (104.232.228.21)
  by server-8.tower-715.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 24 Mar 2022 20:23:39 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp01.lenovo.com (Postfix) with ESMTPS id 4KPcB30bzqzf6mX;
        Thu, 24 Mar 2022 20:23:39 +0000 (UTC)
Received: from p1g3 (unknown [10.45.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4KPcB25dzGzbsGc;
        Thu, 24 Mar 2022 20:23:38 +0000 (UTC)
Date:   Thu, 24 Mar 2022 15:23:29 -0500
From:   Dan Vacura <w36195@motorola.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        linux-kernel@vger.kernel.org,
        Paul Elder <paul.elder@ideasonboard.com>
Subject: Re: [PATCH v2] usb: gadget: uvc: Fix crash when encoding data for
 usb request
Message-ID: <YjzTQX3PlkBG2q6U@p1g3>
References: <20220318164706.22365-1-w36195@motorola.com>
 <YjyDp4l37XimcoZh@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjyDp4l37XimcoZh@pendragon.ideasonboard.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurent,

Appreciate the feedback.

On Thu, Mar 24, 2022 at 04:43:51PM +0200, Laurent Pinchart wrote:
> Hi Dan,
> 
> (CC'ing Paul Elder)
> 
> Thank you for the patch.
> 
> On Fri, Mar 18, 2022 at 11:47:06AM -0500, Dan Vacura wrote:
> > During the uvcg_video_pump() process, if an error occurs and
> > uvcg_queue_cancel() is called, the buffer queue will be cleared out, but
> > the current marker (queue->buf_used) of the active buffer (no longer
> > active) is not reset. On the next iteration of uvcg_video_pump() the
> > stale buf_used count will be used and the logic of min((unsigned
> > int)len, buf->bytesused - queue->buf_used) may incorrectly calculate a
> > nbytes size, causing an invalid memory access.
> 
> When uvcg_queue_cancel() is called, it will empty the queue->irqqueue.
> The next uvcg_video_pump() iteration should thus get a NULL buffer when
> calling uvcg_queue_head(), and shouldn't proceed to calling
> video->encode(). Is the issue that the application queues further
> buffers after cancellation, which puts a new buffer in the irqqueue ?

Yes, that's exactly what's happening. The application has one thread
that is receiving camera frames and queuing them to the gadget driver,
the other thread is waiting for empty buffers to dequeue, generated via
uvcg_queue_next_buffer(), to send back for camera to fill. Is there a
requirement to serialize this logic? In addition, I can check for the
state of the buffers that have just been dequeued, but not sure what to
do if there's a failure.

> 
> I wonder if we need to expand the discussion here to what should be done
> if an error occurs in uvcg_video_pump(). We currently cancel the queue
> and drop all queued buffers, but don't prevent more buffers to be
> queued. Should we force the application to stop streaming in case of
> error, clean up and restart ? Or are usb_ep_queue() errors expected to
> happen from time to time, with graceful error recovery a required
> feature of the gadget driver ?

Good question, this is out of my expertise, but I can comment about what
I see in our current setup, qcom snapdragon chipsets with the dwc3
drivers on 5.10-android. Depending on the host I connect to, the -18
errors in uvc_video_complete() can occur during normal use, sometimes
several times in a span of a few seconds. I wasn't seeing usb_eq_queue()
errors. When the error occurs the device application doesn't do anything
special and continues queuing subsequent buffers. Sometimes there is
visible corruption in the received data, but the streaming gracefully
recovers, mpeg or yuv.

> 
> > [80802.185460][  T315] configfs-gadget gadget: uvc: VS request completed
> > with status -18.
> > [80802.185519][  T315] configfs-gadget gadget: uvc: VS request completed
> > with status -18.
> > ...
> > uvcg_queue_cancel() is called and the queue is cleared out, but the
> > marker queue->buf_used is not reset.
> > ...
> > [80802.262328][ T8682] Unable to handle kernel paging request at virtual
> > address ffffffc03af9f000
> > ...
> > ...
> > [80802.263138][ T8682] Call trace:
> > [80802.263146][ T8682]  __memcpy+0x12c/0x180
> > [80802.263155][ T8682]  uvcg_video_pump+0xcc/0x1e0
> > [80802.263165][ T8682]  process_one_work+0x2cc/0x568
> > [80802.263173][ T8682]  worker_thread+0x28c/0x518
> > [80802.263181][ T8682]  kthread+0x160/0x170
> > [80802.263188][ T8682]  ret_from_fork+0x10/0x18
> > [80802.263198][ T8682] Code: a8c12829 a88130cb a8c130
> > 
> > Fixes: d692522577c0 ("usb: gadget/uvc: Port UVC webcam gadget to use videobuf2 framework")
> > Signed-off-by: Dan Vacura <w36195@motorola.com>
> > 
> > ---
> > Changes in v2:
> > - Add Fixes tag
> > 
> >  drivers/usb/gadget/function/uvc_queue.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
> > index d852ac9e47e7..2cda982f3765 100644
> > --- a/drivers/usb/gadget/function/uvc_queue.c
> > +++ b/drivers/usb/gadget/function/uvc_queue.c
> > @@ -264,6 +264,8 @@ void uvcg_queue_cancel(struct uvc_video_queue *queue, int disconnect)
> >  		buf->state = UVC_BUF_STATE_ERROR;
> >  		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
> >  	}
> > +	queue->buf_used = 0;
> > +
> >  	/* This must be protected by the irqlock spinlock to avoid race
> >  	 * conditions between uvc_queue_buffer and the disconnection event that
> >  	 * could result in an interruptible wait in uvc_dequeue_buffer. Do not
> 
> -- 
> Regards,
> 
> Laurent Pinchart
