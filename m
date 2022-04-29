Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D755153D0
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379960AbiD2Sml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 14:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359759AbiD2Smk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 14:42:40 -0400
Received: from mail1.bemta35.messagelabs.com (mail1.bemta35.messagelabs.com [67.219.250.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07005D64C7;
        Fri, 29 Apr 2022 11:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1651257560; i=@motorola.com;
        bh=m1WVYkVymN+qEiuNhv+8BRhPhexi6XHOEfprm3oobaw=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=iiXEw8WTWjSPbCvWKYaVlzfpbajHZ+S+1A262rKA/jdQXUAEk5+SbSklUiuK4j9+f
         qGwZz82FOPUmRcrYRFHOJnzs4pm+Fgz6DWFFfSW5ySTe1jTUOtzXNrq87fU9LfA2mL
         uV7Lppv2IU0fhywmTsgGWYGaLuL3ytW+ofH5IvlTqBVEar5O8/TWvDN5ovDEz+2KxD
         HH9HFGSSJ9zf5Z+YgegMzphpA6zSQZ+nnbTfSbp++lwXTNIpOtNJNHdMMWsB0jPt/v
         UVZc3wit6Al11hDPVEymS78OeyQuynUrA1U/ljk9AG+aV5LmzW5Q95T52NDNuBS1GH
         kJ9DvOd2ioR7w==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRWlGSWpSXmKPExsWS8eKJqO55g5w
  kg8XfjSyOtT1ht1i9+CqTRfPi9WwWnROXsFtc3jWHzWLRslZmiy1tV5gsFmx8xOjA4TG7Yyar
  x6ZVnWwe++euYffo/2vg8fTHXmaPz5vkAtiiWDPzkvIrElgzWnfOYSzYq1vxf9llpgbG1ypdj
  FwcQgJTmSSmTmljhXAWMUmc3rwQyOHkYBFQlVg47xYbiM0moCax4PUqZhBbRMBConfRdEYQm1
  mgiUni2qEUEFtYIFzia/93sBpeAWWJy5sesEEMXc8ocXLXcxaIhKDEyZlPWCCatSRu/HvJ1MX
  IAWRLSyz/xwES5hSwklh7ZQ3LBEbeWUg6ZiHpmIXQsYCReRWjdVJRZnpGSW5iZo6uoYGBrqGh
  CZg2tdBLrNJN1Cst1i1PLS7RNdJLLC/WSy0u1iuuzE3OSdHLSy3ZxAgM+JSiFKsdjJP6f+odY
  pTkYFIS5d2lmZMkxJeUn1KZkVicEV9UmpNafIhRhoNDSYK3SRcoJ1iUmp5akZaZA4w+mLQEB4
  +SCK+pNlCat7ggMbc4Mx0idYpRUUqct0IBKCEAksgozYNrg0X8JUZZKWFeRgYGBiGegtSi3Mw
  SVPlXjOIcjErCvCX6QFN4MvNK4Ka/AlrMBLR4ZVEmyOKSRISUVANTGafJFr1LR502+NiFHoks
  ObU/om6Vck4266p/DrwX9OXqqyXeRPlMjTHgWK1/yGGH63qe+LMP042Wu0eUZ+Rctrtw86efq
  Z+Ka9bfj4dLHj20PWDjVmmZrdYf/KB5h9Hz5Ix6FY7fExeWPDmScaF7hkH1Z/7rPsc7XyQI7E
  m+l1Fn0X5H8d6dJeq8tju71z/o1fHX+XnMRufW18zHL+1uSXwPejJVdP6ZyM5WvtdCAS68B/7
  H6re9dSipcH0knGJ96MD2fYm5e2dasK4wO/rV8MmizvNfhT/cODDh0+39DGLZlxaxudt9uTX1
  m/YpR5Vw59ZPkTIT2/W/1TKzbb/F5J4mv6O/xszsSsRduSwlluKMREMt5qLiRAAlu9yAcwMAA
  A==
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-18.tower-655.messagelabs.com!1651257550!19896!1
X-Originating-IP: [104.232.228.21]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.86.4; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 21481 invoked from network); 29 Apr 2022 18:39:11 -0000
Received: from unknown (HELO va32lpfpp01.lenovo.com) (104.232.228.21)
  by server-18.tower-655.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 29 Apr 2022 18:39:11 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp01.lenovo.com (Postfix) with ESMTPS id 4Kqh8t48TRzgQ3G;
        Fri, 29 Apr 2022 18:39:10 +0000 (UTC)
Received: from p1g3 (unknown [10.45.4.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4Kqh8t1yGQzbvDd;
        Fri, 29 Apr 2022 18:39:10 +0000 (UTC)
Date:   Fri, 29 Apr 2022 13:39:04 -0500
From:   Dan Vacura <w36195@motorola.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] usb: gadget: uvc: Fix crash when encoding data for
 usb request
Message-ID: <YmwwyMg08P1Yol8j@p1g3>
References: <20220331184024.23918-1-w36195@motorola.com>
 <Yl8frWT5VYRdt5zA@pendragon.ideasonboard.com>
 <YmB6v8AbzdOgITT8@p1g3>
 <YmXWLFfN4KTFp0wW@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmXWLFfN4KTFp0wW@pendragon.ideasonboard.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurent,

ccing Michael for comments about returning v4l2 bufs too early.

On Mon, Apr 25, 2022 at 01:58:52AM +0300, Laurent Pinchart wrote:
> Hi Dan,
> 
> On Wed, Apr 20, 2022 at 04:27:27PM -0500, Dan Vacura wrote:
> > On Tue, Apr 19, 2022 at 11:46:37PM +0300, Laurent Pinchart wrote:
> > > 
> > > This indeed fixes an issue, so I think we can merge the patch, but I
> > > also believe we need further improvements on top (of course if you would
> > > like to improve the implementation in a v4, I won't complain :-))
> > 
> > It looks like Greg has already accepted the change and it's in
> > linux-next. We can discuss here how to better handle these -EXDEV errors
> > for future improvements, as it seems like it's been an issue in the past
> > as well:
> > https://www.mail-archive.com/linux-usb@vger.kernel.org/msg105615.html
> > 
> > > As replied in v2 (sorry for the late reply), it seems that this error
> > > can occur under normal conditions. This means we shouldn't cancel the
> > > queue, at least when the error is intermitent (if all URBs fail that's
> > > another story).
> > 
> > My impression was that canceling the queue was still necessary as we may
> > be in progress for the current frame. Perhaps we don't need to flush all
> > the frames from the queue, but at a minimum we need to reset the
> > buf_used value.
> 
> I think we have three classes of errors:
> 
> - "Packet-level" errors, resulting in either data loss or erroneous data
>   being transferred to the host for one (or more) packets in a frame.
>   When such errors occur, we should probably notify the application (on
>   the gadget side), but we can continue sending the rest of the frame.
> 
> - "Frame-level" errors, resulting in errors in the rest of the frame.
>   When such an error occurs, we should notify the application, and stop
>   sending data for the current frame, moving to the next frame.
> 
> - "Stream-level" errors, resulting in errors in all subsequent frames.
>   When such an error occurs, we should notify the application and stop
>   sending data until the application takes corrective measures.
> 
> I'm not sure if packet-level errors make sense, if data is lost, maybe
> we would be better off just cancelling the current frame and moving to
> the next one.
> 
> For both packet-level errors and frame-level errors, the buffer should
> be marked as erroneous to notify the application, but there should be no
> need to cancel the queue and drop all queued buffers. We can just move
> to the next buffer.
> 
> For stream-level errors, I would cancel the queue, and additionally
> prevent new buffers from being queued until the application stops and
> restarts the stream.
> 
> Finally, which class an error belongs to may not be an intrinsic
> property of the error itself, packet-level or frame-level errors that
> occur too often may be worth cancelling the queue (I'm not sure how to
> quantify "too often" though).
> 
> Does this make sense ?

Yes, this makes sense, but I'm not sure if the USB controllers send back
that info and/or if it's all standardized. For example in the dwc3
controller I see the following status values returned: -EPIPE,
-ECONNRESET, -ESHUTDOWN, and -EXDEV; whereas in the musb controller
doesn't appear to return -EXDEV. 

> 
> > > We likely need to differentiate between -EXDEV and other errors in
> > > uvc_video_complete(), as I'd like to be conservative and cancel the
> > > queue for unknown errors. We also need to improve the queue cancellation
> > > implementation so that userspace gets an error when queuing further
> > > buffers.
> > 
> > We already feedback to userspace the error, via the state of
> > vb2_buffer_done(). When userspace dequeues the buffer it can check if
> > v4l2_buffer.flags has V4L2_BUF_FLAG_ERROR to see if things failed, then
> > decide what to do like re-queue that frame. However, this appears to not
> > always occur since I believe the pump thread is independent of the
> > uvc_video_complete() callback. As a result, the complete callback of the
> > failed URB may be associated with a buffer that was already released
> > back to the userspace client.
> 
> Good point. That would only be the case for errors in the last
> request(s) for a frame, right ?

From logging it seems it can be up to the last few requests that come
back, where the queue is already empty. I guess this is timing dependent
on the hw, the system scheduling, and how deep the request queue is.

> 
> > In this case, I don't know if there's
> > anything to be done, since a new buffer and subsequent URBs might
> > already be queued up. You suggested an error on a subsequent buffer
> > queue, but I don't know how helpful that'd be at this point, perhaps in
> > the scenario that all URBs are failing?
> 
> Should we delay sending the buffer back to userspace until all the
> requests for the buffer have completed ?

Yes, I had that same thought later on. We'll either need a new
pending_complete_queue to move the buffer from the current queue, or
create logic to leverage the existing uvc_buffer_state flags; like
uvcg_queue_head() looks for the first buffer with UVC_BUF_STATE_QUEUED.
When the complete call comes in we'll have to identify if the request is
the last completed one for that buffer. It looks like the UVC_STREAM_EOF
flag will be present, hopefully that's sufficient to rely on. Also,
since this is a FIFO queue, we can assume that the first buffer with
UVC_BUF_STATE_DONE can be vb2_buffer_done()'d. If we implement this type
of logic then we can probably remove this change:
https://lore.kernel.org/r/20220402232744.3622565-3-m.grzeschik@pengutronix.de
since its purpose is similar. How does that sound and do you have an
opinion on a new queue or creating logic around uvc_buffer_state flags?

> 
> -- 
> Regards,
> 
> Laurent Pinchart
