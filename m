Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B52509211
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 23:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345541AbiDTVa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 17:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379199AbiDTVa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 17:30:27 -0400
Received: from mail1.bemta33.messagelabs.com (mail1.bemta33.messagelabs.com [67.219.247.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8DA424A9;
        Wed, 20 Apr 2022 14:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1650490058; i=@motorola.com;
        bh=mUfCxTtuLS2uaqIBtMgvG7uvnU4pQujzQBXvZbexLDc=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=VGqmI64PDJAfS/xApdWCBi00DpubDSs6VslMZNn3QCT7XzGaO4emdafqArw7bBtT9
         OWhwgCDydRBiKCAM+OnBEnMwxDiZjibVYTGInfXsXWKkda5Vl1/m2B4Kd/f1ubaqdL
         H+9+K0hSgLaWvSbAwNyoBSz4uHZMD3xq9/awqQV6oNu9b14Y7o68IRHmUxsZUxhFOb
         MrGduNG/V4eMd/uARLfMf2z0QCCdrz/GMQ6yTqhtFQ1alsrHKjFvGvJwWVhv31gpET
         qXvIkuCrR1+Ay4TVUCfG3yGsOaL/iH8khsk3QIxjGCYnoxMIUfkCYd8eqtAGZU0wjc
         NouIZ/L29b9ow==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRWlGSWpSXmKPExsWS8eKJhO7JqoQ
  kg2WzlCyOtT1ht1i9+CqTRfPi9WwWnROXsFtc3jWHzWLRslZmiwUbHzE6sHvM7pjJ6rFpVSeb
  x/65a9g9nv7Yy+zxeZNcAGsUa2ZeUn5FAmvGy0WrWQtOC1ZsfXSUpYFxK18XIxeHkMBUJolfT
  ftYuxg5gZyFQM7+QhCbRUBV4sC96UwgNpuAmsSC16uYQWwRAQuJ3kXTGUGamQUuMkocXH8KrF
  lYIFzia/93sCJeAWWJ9VfWM0EMTZdY1PKXDSIuKHFy5hMWEJtZQEvixr+XQDUcQLa0xPJ/HCB
  hTgEriefftjNNYOSdhaRjFpKOWQgdCxiZVzFaJxVlpmeU5CZm5ugaGhjoGhqa6JpZ6Boameol
  Vukm6pUW66YmFpfoGukllhfrpRYX6xVX5ibnpOjlpZZsYgQGd0qRS+0Oxs5VP/UOMUpyMCmJ8
  m6tTEgS4kvKT6nMSCzOiC8qzUktPsQow8GhJMH7EyQnWJSanlqRlpkDjDSYtAQHj5IIL3MJUJ
  q3uCAxtzgzHSJ1ilFRSpz3MEifAEgiozQPrg0W3ZcYZaWEeRkZGBiEeApSi3IzS1DlXzGKczA
  qCfOeBZnCk5lXAjf9FdBiJqDF1VNiQRaXJCKkpBqYtn5+Ys7ZOu1nwYZOPYfM3c3zFLJV1lya
  9uay6l3/nMXMhpNNL8S9T0+W2Gsl/sBzxaqaF+l7NhzJ7l5a2Tf5Q/yM76pT2N3tvjSx35Iys
  Wya/Ta2Oyzk0plpNVv5lJViuD/XRc6tNu/13vtF4mTKdfePziY8iypeXoi828G45fwD7mk50n
  zMtUKNVveSLdK97hhtWfamokby+1cRMUatNCHV0osfY3YxbmTcOVv9hvDJ7gdrsq0Cpn8OOjn
  H6RFnaMzLW22Kd9bUWk1b3DA51CAoNdquwylyy/Jcs57l8YEOhbkps3rlT16NzlJTXHvYP/jP
  /+kuLJKWjHe33o9a8L+4NV1vgluPak2dznYlluKMREMt5qLiRAAMkH6faQMAAA==
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-2.tower-715.messagelabs.com!1650490057!24721!1
X-Originating-IP: [104.232.228.24]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.85.8; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 21978 invoked from network); 20 Apr 2022 21:27:37 -0000
Received: from unknown (HELO va32lpfpp04.lenovo.com) (104.232.228.24)
  by server-2.tower-715.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 20 Apr 2022 21:27:37 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp04.lenovo.com (Postfix) with ESMTPS id 4KkDKP1WCDzg1bq;
        Wed, 20 Apr 2022 21:27:37 +0000 (UTC)
Received: from p1g3 (unknown [10.45.5.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4KkDKN6ndnzbsGJ;
        Wed, 20 Apr 2022 21:27:36 +0000 (UTC)
Date:   Wed, 20 Apr 2022 16:27:27 -0500
From:   Dan Vacura <w36195@motorola.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] usb: gadget: uvc: Fix crash when encoding data for
 usb request
Message-ID: <YmB6v8AbzdOgITT8@p1g3>
References: <20220331184024.23918-1-w36195@motorola.com>
 <Yl8frWT5VYRdt5zA@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl8frWT5VYRdt5zA@pendragon.ideasonboard.com>
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

Thanks for the input.

On Tue, Apr 19, 2022 at 11:46:37PM +0300, Laurent Pinchart wrote:
> 
> This indeed fixes an issue, so I think we can merge the patch, but I
> also believe we need further improvements on top (of course if you would
> like to improve the implementation in a v4, I won't complain :-))

It looks like Greg has already accepted the change and it's in
linux-next. We can discuss here how to better handle these -EXDEV errors
for future improvements, as it seems like it's been an issue in the past
as well:
https://www.mail-archive.com/linux-usb@vger.kernel.org/msg105615.html

> 
> As replied in v2 (sorry for the late reply), it seems that this error
> can occur under normal conditions. This means we shouldn't cancel the
> queue, at least when the error is intermitent (if all URBs fail that's
> another story).

My impression was that canceling the queue was still necessary as we may
be in progress for the current frame. Perhaps we don't need to flush all
the frames from the queue, but at a minimum we need to reset the
buf_used value.

> 
> 
> We likely need to differentiate between -EXDEV and other errors in
> uvc_video_complete(), as I'd like to be conservative and cancel the
> queue for unknown errors. We also need to improve the queue cancellation
> implementation so that userspace gets an error when queuing further
> buffers.

We already feedback to userspace the error, via the state of
vb2_buffer_done(). When userspace dequeues the buffer it can check if
v4l2_buffer.flags has V4L2_BUF_FLAG_ERROR to see if things failed, then
decide what to do like re-queue that frame. However, this appears to not
always occur since I believe the pump thread is independent of the
uvc_video_complete() callback. As a result, the complete callback of the
failed URB may be associated with a buffer that was already released
back to the userspace client. In this case, I don't know if there's
anything to be done, since a new buffer and subsequent URBs might
already be queued up. You suggested an error on a subsequent buffer
queue, but I don't know how helpful that'd be at this point, perhaps in
the scenario that all URBs are failing?

> 
> -- 
> Regards,
> 
> Laurent Pinchart

Appreciate the feedback,

Dan
