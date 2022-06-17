Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2C754FB05
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 18:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383115AbiFQQ17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 12:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiFQQ16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 12:27:58 -0400
Received: from mail1.bemta35.messagelabs.com (mail1.bemta35.messagelabs.com [67.219.250.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20321583F;
        Fri, 17 Jun 2022 09:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1655483276; i=@motorola.com;
        bh=2kDYzt/VGbsG0nzURDxax2rcRa5S2Q9ZXehQBx7o2So=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=FyELOb68bKc/Wx57kMVFf2Pn1se1hE1RevDfi+7XKFNEf4htk16C6iEJjRbqbZjZn
         uM420vq/B/KUchC/iKdbUdUiFWdp+yPsi5bu/Bp6X9stCXyPD1uuNSkVrvNTOcYMVA
         T01iR8jSYDJF5mgbOQsNQiE7g5dxR9bgQdlFlQq9sx8C2CBFX7E1hveTZv3w9h63U8
         4pjTnJPA709rQOXPNxnk+hb1TMtf3N+/xlsimeXoCWDEcdGgvD7TxjOEQiPJdcG9L+
         jyYRThGk+7Od690ZGmkZzMqv1aQlXhUbfqz60/NslQsQjy9w44DDsmq2olXWXqtt+p
         ElnRVZ5KIIhDQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRWlGSWpSXmKPExsUyYU+Ds2736jV
  JBjtfylkca3vCbtG8eD2bRefEJewWl3fNYbNYtKyV2WJL2xUmix9/+pgtFmx8xOjA4TG7Yyar
  x6ZVnWwe++euYffo/2vg8XmTXABrFGtmXlJ+RQJrxo65Z5gKJgtV7GroZ2lgvMTXxcjFISQwm
  Uli+ZqpzBDOQiaJRc1P2bsYOTlYBFQlHsyZwgJiswmoSSx4vYoZxBYRsJDoXTSdEcRmFmhhkj
  hzURjEFhbwlTg4fw9YnFdAWeLn+glsILaQQIbEm4YT7BBxQYmTM5+wQPRqSdz495Kpi5EDyJa
  WWP6PAyTMKWAlce35V6YJjLyzkHTMQtIxC6FjASPzKkbrpKLM9IyS3MTMHF1DAwNdQ0MTXUtL
  XUMTM73EKt1EvdJi3fLU4hJdI73E8mK91OJiveLK3OScFL281JJNjMAgTylKnrSD8XvfT71Dj
  JIcTEqivGVL1yQJ8SXlp1RmJBZnxBeV5qQWH2KU4eBQkuD9uwIoJ1iUmp5akZaZA4w4mLQEB4
  +SCK/scqA0b3FBYm5xZjpE6hSjLkfn/q4DzEIsefl5qVLivLtXARUJgBRllObBjYBF/yVGWSl
  hXkYGBgYhnoLUotzMElT5V4ziHIxKwrznQS7hycwrgdv0CugIJqAjGvetADmiJBEhJdXAlNtj
  9S3pZofHhKtnJ54usHJLmhgZYrZvwdXpTP1Xps/u3jqBSVB0Unb8bv77fccXKgmFbK9UuGFSu
  vN5iDfjvfCXUZ/uN+9eJcO6TCiOV7vg3s3WTWIZzHtKZBc36u5aEqXXuGfidcWSztu3DSb8WC
  +xYIdRvVDO1+0rHt7Re8b2I+yZ/P/ze3QYa2bEeBlPj53Ra57yZZlc9zLnPj+h1LtxUX68jvI
  3BX2482frbXOzF3o5banZI/FnG1bMebM/163eO/rHGovs4MVPUmw7Gi1vWxSruyx2W1a/NWE7
  f97PlO7ZzmcFV1dOqbz0zYB/p6bZyQdSbW2c+lNPBeRfiTC/0XnOI0AleV+MlXOpEktxRqKhF
  nNRcSIAqyBdWHkDAAA=
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-13.tower-636.messagelabs.com!1655483274!23406!1
X-Originating-IP: [144.188.128.67]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.86.7; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 18209 invoked from network); 17 Jun 2022 16:27:55 -0000
Received: from unknown (HELO ilclpfpp01.lenovo.com) (144.188.128.67)
  by server-13.tower-636.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Jun 2022 16:27:55 -0000
Received: from ilclmmrp02.lenovo.com (ilclmmrp02.mot.com [100.65.83.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by ilclpfpp01.lenovo.com (Postfix) with ESMTPS id 4LPkwp5DcFzfBZq;
        Fri, 17 Jun 2022 16:27:54 +0000 (UTC)
Received: from p1g3 (unknown [10.45.6.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp02.lenovo.com (Postfix) with ESMTPSA id 4LPkwp3x5XzbrlP;
        Fri, 17 Jun 2022 16:27:54 +0000 (UTC)
Date:   Fri, 17 Jun 2022 11:27:35 -0500
From:   Dan Vacura <w36195@motorola.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: fix list double add in uvcg_video_pump
Message-ID: <Yqyrd6vY/rdhAONd@p1g3>
References: <20220616030915.149238-1-w36195@motorola.com>
 <Yqx4vPp78Sl2I3nU@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqx4vPp78Sl2I3nU@pendragon.ideasonboard.com>
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

Thanks for the review!

On Fri, Jun 17, 2022 at 03:51:08PM +0300, Laurent Pinchart wrote:
> Hi Dan,
> 
> Thank you for the patch.
> 
> On Wed, Jun 15, 2022 at 10:09:15PM -0500, Dan Vacura wrote:
> > A panic can occur if the endpoint becomes disabled and the
> > uvcg_video_pump adds the request back to the req_free list after it has
> > already been queued to the endpoint. The endpoint complete will add the
> > request back to the req_free list. Invalidate the local request handle
> > once it's been queued.
> 
> Good catch !
> 
> > <6>[  246.796704][T13726] configfs-gadget gadget: uvc: uvc_function_set_alt(1, 0)
> > <3>[  246.797078][   T26] list_add double add: new=ffffff878bee5c40, prev=ffffff878bee5c40, next=ffffff878b0f0a90.
> > <6>[  246.797213][   T26] ------------[ cut here ]------------
> > <2>[  246.797224][   T26] kernel BUG at lib/list_debug.c:31!
> > <6>[  246.807073][   T26] Call trace:
> > <6>[  246.807180][   T26]  uvcg_video_pump+0x364/0x38c
> > <6>[  246.807366][   T26]  process_one_work+0x2a4/0x544
> > <6>[  246.807394][   T26]  worker_thread+0x350/0x784
> > <6>[  246.807442][   T26]  kthread+0x2ac/0x320
> > 
> > Fixes: f9897ec0f6d3 ("usb: gadget: uvc: only pump video data if necessary")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Dan Vacura <w36195@motorola.com>
> > ---
> >  drivers/usb/gadget/function/uvc_video.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
> > index 93f42c7f800d..59e2f51b53a5 100644
> > --- a/drivers/usb/gadget/function/uvc_video.c
> > +++ b/drivers/usb/gadget/function/uvc_video.c
> > @@ -427,6 +427,9 @@ static void uvcg_video_pump(struct work_struct *work)
> >  		if (ret < 0) {
> >  			uvcg_queue_cancel(queue, 0);
> >  			break;
> > +		} else {
> > +			/* Endpoint now owns the request */
> > +			req = NULL;
> >  		}
> >  		video->req_int_count++;
> 
> I'd write it as
> 
> 		if (ret < 0) {
> 			uvcg_queue_cancel(queue, 0);
> 			break;
> 		}
> 
> 		/* Endpoint now owns the request. */
> 		req = NULL;
> 		video->req_int_count++;

This is cleaner. I'll send a v2 with this suggestion.

> 
> Apart from that,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> >  	}
> 
> -- 
> Regards,
> 
> Laurent Pinchart
