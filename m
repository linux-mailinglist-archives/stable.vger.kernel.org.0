Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0936B3EFD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCJMRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjCJMRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:17:54 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA33103EF3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:17:51 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8C5F432003D3;
        Fri, 10 Mar 2023 07:17:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 10 Mar 2023 07:17:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1678450670; x=1678537070; bh=ln
        Dy+Z3Zn/JpRhEid/Pb6/Lu/QzCVDRoZSTsZItuxek=; b=A9p5zBY7LMIGSvg0Ne
        MyfCTPxT598/QKcOR03Us5yiYUmqGmVS4FC6wdCoOa1iAnZoKyWA1iAOzTPfk0X1
        upVua3qknrZLMmWk7k439aknsFAGYOCHyHZR6qRAMETl9GimDSSsNtAZuLtRyep7
        gY6W3sqlQrzYzs4Dd8YXcD0+BC/4XIxqjeUdjj1e//82sIan0F1jRFaYegbINEG/
        annfCrl/GGeieUOcIVCKlsBdMCJVYDhgZTFtVuC9nRYoRcsGx3GwTmE4RI/8U81E
        JlMyjBhS7zNvhwt4xm6llNNA4o2EJpM/wHOEdUDD0BSR4Ba0g+phpw/a9dA3X/SN
        0Obw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1678450670; x=1678537070; bh=lnDy+Z3Zn/JpR
        hEid/Pb6/Lu/QzCVDRoZSTsZItuxek=; b=rIkVK3HhbfjBTiIJeQp10CdSbmflY
        Ih4dB6z5kKwBWY8B+khhP1nmMz3tFNqBgaTcXUYDbdQB6t/3JbvFjOPy+RdK08eL
        XKzmN5jCGuZ9nJCuellCdhOi+SBkGBAkJo6tZ0tMz2l+ezEpfA01QpjGrRoFigEG
        fmkYLD6x304TfDYI7xfyrAkKs7tQp7RsFmv68IU41WPVaflZvPLlP8Z2/paWPUHc
        xDXUMkvisXvLqVLQrGzSFImwaMyWYiunpw+FRYYqK+5rt6v4rIAm8FdhYVvRM9Jk
        v9kqFfbcA/T7sVOBaGjc/vPCaFM+ZxmkU+Bnfgix49HtSsiat3/1orr7Q==
X-ME-Sender: <xms:7h8LZLrHAZKCa7rYDiwMuxvhm4clamoOn2CnM4lNc6w8LeugGUosFg>
    <xme:7h8LZFpCoXeQ1fMtrctJX34A6QDy-zL5qIGcc1Hd5Zx8BBSZzqp2W22SmVsFl9ywQ
    gkFRXvYaqGF4w>
X-ME-Received: <xmr:7h8LZIN0nv87_cxS-lDZCqoJakmSN8c7AODVFxUifiQiHjFQs-vtUtzT4m8qiNvvg610SRqwMBs4uACXdrbYwZyPfvFEy_Bxr46HDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddukedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:7h8LZO65zHpKVMwsDYZjwdlLmUD3gPG4f1S44cW9KuFZQu1prSZPgw>
    <xmx:7h8LZK7C4j8rS9REHQ6QViUJ16BwOnAxSDPCBonQen5xRwYTmWL10g>
    <xmx:7h8LZGjUw8tcI825CHmpG1rbU02HOD_aWAoB_kUMUQnZl6d5T37bWQ>
    <xmx:7h8LZHuPuAE395n-JC7fBFU8FXVbrk0prvjG69WtGJXeeQ8weNVbTA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Mar 2023 07:17:49 -0500 (EST)
Date:   Fri, 10 Mar 2023 13:17:47 +0100
From:   Greg KH <greg@kroah.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     stable@vger.kernel.org, Yunke Cao <yunkec@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 6.2.y] media: uvcvideo: Fix race condition with
 usb_kill_urb
Message-ID: <ZAsf6wksYtH9/Ura@kroah.com>
References: <16781002113959@kroah.com>
 <20230308133025.191306-1-ribalda@chromium.org>
 <ZAsaiH4YhwHSDHOO@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAsaiH4YhwHSDHOO@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 12:54:48PM +0100, Greg KH wrote:
> On Wed, Mar 08, 2023 at 02:30:25PM +0100, Ricardo Ribalda wrote:
> > usb_kill_urb warranties that all the handlers are finished when it
> > returns, but does not protect against threads that might be handling
> > asynchronously the urb.
> > 
> > For UVC, the function uvc_ctrl_status_event_async() takes care of
> > control changes asynchronously.
> > 
> > If the code is executed in the following order:
> > 
> > CPU 0					CPU 1
> > ===== 					=====
> > uvc_status_complete()
> > 					uvc_status_stop()
> > uvc_ctrl_status_event_work()
> > 					uvc_status_start() -> FAIL
> > 
> > Then uvc_status_start will keep failing and this error will be shown:
> > 
> > <4>[    5.540139] URB 0000000000000000 submitted while active
> > drivers/usb/core/urb.c:378 usb_submit_urb+0x4c3/0x528
> > 
> > Let's improve the current situation, by not re-submiting the urb if
> > we are stopping the status event. Also process the queued work
> > (if any) during stop.
> > 
> > CPU 0					CPU 1
> > ===== 					=====
> > uvc_status_complete()
> > 					uvc_status_stop()
> > 					uvc_status_start()
> > uvc_ctrl_status_event_work() -> FAIL
> > 
> > Hopefully, with the usb layer protection this should be enough to cover
> > all the cases.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
> > Reviewed-by: Yunke Cao <yunkec@chromium.org>
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > (cherry picked from commit 619d9b710cf06f7a00a17120ca92333684ac45a8)
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > ---
> >  drivers/media/usb/uvc/uvc_ctrl.c   |  5 ++++
> >  drivers/media/usb/uvc/uvc_status.c | 37 ++++++++++++++++++++++++++++++
> >  drivers/media/usb/uvc/uvcvideo.h   |  1 +
> >  3 files changed, 43 insertions(+)
> 
> This fails to apply to the 6.2.y queue right now:
> 
> checking file drivers/media/usb/uvc/uvc_ctrl.c
> Hunk #1 FAILED at 6.
> Hunk #2 succeeded at 1509 (offset 67 lines).
> 1 out of 2 hunks FAILED
> checking file drivers/media/usb/uvc/uvc_status.c
> checking file drivers/media/usb/uvc/uvcvideo.h
> Hunk #1 succeeded at 559 (offset -1 lines).
> 
> Can you redo this?

I got 5.15.y and newer to work here on my own, can you redo the older
ones as well?

thanks,

greg k-h
