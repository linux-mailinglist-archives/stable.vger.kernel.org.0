Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2466B3E7E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCJL4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjCJLzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:55:49 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2A0E6D9B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:55:08 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id C2BAA3200955;
        Fri, 10 Mar 2023 06:54:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 10 Mar 2023 06:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1678449293; x=1678535693; bh=st
        +W8sAQXzQ972r21W87NSWkHpQj8wCRAy5nwMG+Btg=; b=ijevSKOWgeub8gcW0J
        sWQdytgjlmunNd3s59A4WSa074bLi6EWpbB35TXqeFId6fADvWUY5ZKFIQ0FOxKk
        qtFke8LQLDLkM9K3csLy+0AtDvCgqSfcRnosZFzddfs5NOkkbR5jFVsNv4CmmZl7
        mIAm4rS78rWvIovQoTJf9R6siD3hN1nv7T0DIsx23VgSqt3y/d5hedCgTxMX8idE
        TY5svSHYMcl6oudWZK1sR3UR3Zcf3mSx8NZ9z28Lv/7+kQBij0jYz5wHsq50LmTt
        Y/3KpeAaH2b9NE1n0JTU/1c3elNRgPkuMFzD8Uq7xSDyheVx8BazLpypZa1qAq58
        J/uQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1678449293; x=1678535693; bh=st+W8sAQXzQ97
        2r21W87NSWkHpQj8wCRAy5nwMG+Btg=; b=VeA6g8SnfK0PapDZ0B6sRTn8YRaU7
        acEyhWGTlLt3mVcc4TdJxAyUOe9Y+GdPdmUZaDUHCiSQ96uA/FqDECxhyqYGv/M8
        HF4E5q0+UTskV+bbPXZg+DUnVUMCHlA5hDCubsF7EPsr7Mcf7KnDNxtilYxtiQRm
        QARwO5YAf1UG+Rou48sy8Wj6nuQnr0PNPIbkIIvfP4skb8GacwT0ED1pnGfCOSG9
        AE/Yb3xuu0vLaS75WzTKKwTqdp/cp/prBXDudXL8AghQzDgIgRh5nt1x3lrxhmjY
        3zwG8zxVaB4IivOmlsHLKblGO9W0rKTIKKp6wGYTucIjFckyy6bfrKX+A==
X-ME-Sender: <xms:jRoLZOd8ZwZBzat890BsZreycmg0lXMhbtO-KIU35jlpC5Nmttz4cQ>
    <xme:jRoLZIPUMXO_FBn2ELnCsP0jPKWBeSxyQnlUiqTSqTgygwc2_8gJ6jUpLd6Q_kTaO
    nD_dyionXEQvw>
X-ME-Received: <xmr:jRoLZPiFSUt4u46zwjZcyAiawliSOVWAXGnqxZAHclbyfzwYtXtICtFaFEKQy9wKl-9XdZskRPJwM7-pvS5Rh4rrBVdg4lc-InZQdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddukedgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:jRoLZL9GLvIqjlBrBQv6k6fPz9MKli-8wwx2B_-164kGEdEhanAAhg>
    <xmx:jRoLZKt9m8fYT98QaTnBKhKDJeqBeSEBAXlILeio-O59tBG_RVIQRg>
    <xmx:jRoLZCHAplTFfOQonlgeovGdeBWZBULNWwuxyA-zTs-wdTCxRNPK8g>
    <xmx:jRoLZOjpWVPZe_AEKuQxL1WBOo3-zqcJ_Ji4r_2EhtT2lTz2OmZjRA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Mar 2023 06:54:52 -0500 (EST)
Date:   Fri, 10 Mar 2023 12:54:48 +0100
From:   Greg KH <greg@kroah.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     stable@vger.kernel.org, Yunke Cao <yunkec@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 6.2.y] media: uvcvideo: Fix race condition with
 usb_kill_urb
Message-ID: <ZAsaiH4YhwHSDHOO@kroah.com>
References: <16781002113959@kroah.com>
 <20230308133025.191306-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308133025.191306-1-ribalda@chromium.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 08, 2023 at 02:30:25PM +0100, Ricardo Ribalda wrote:
> usb_kill_urb warranties that all the handlers are finished when it
> returns, but does not protect against threads that might be handling
> asynchronously the urb.
> 
> For UVC, the function uvc_ctrl_status_event_async() takes care of
> control changes asynchronously.
> 
> If the code is executed in the following order:
> 
> CPU 0					CPU 1
> ===== 					=====
> uvc_status_complete()
> 					uvc_status_stop()
> uvc_ctrl_status_event_work()
> 					uvc_status_start() -> FAIL
> 
> Then uvc_status_start will keep failing and this error will be shown:
> 
> <4>[    5.540139] URB 0000000000000000 submitted while active
> drivers/usb/core/urb.c:378 usb_submit_urb+0x4c3/0x528
> 
> Let's improve the current situation, by not re-submiting the urb if
> we are stopping the status event. Also process the queued work
> (if any) during stop.
> 
> CPU 0					CPU 1
> ===== 					=====
> uvc_status_complete()
> 					uvc_status_stop()
> 					uvc_status_start()
> uvc_ctrl_status_event_work() -> FAIL
> 
> Hopefully, with the usb layer protection this should be enough to cover
> all the cases.
> 
> Cc: stable@vger.kernel.org
> Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
> Reviewed-by: Yunke Cao <yunkec@chromium.org>
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> (cherry picked from commit 619d9b710cf06f7a00a17120ca92333684ac45a8)
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c   |  5 ++++
>  drivers/media/usb/uvc/uvc_status.c | 37 ++++++++++++++++++++++++++++++
>  drivers/media/usb/uvc/uvcvideo.h   |  1 +
>  3 files changed, 43 insertions(+)

This fails to apply to the 6.2.y queue right now:

checking file drivers/media/usb/uvc/uvc_ctrl.c
Hunk #1 FAILED at 6.
Hunk #2 succeeded at 1509 (offset 67 lines).
1 out of 2 hunks FAILED
checking file drivers/media/usb/uvc/uvc_status.c
checking file drivers/media/usb/uvc/uvcvideo.h
Hunk #1 succeeded at 559 (offset -1 lines).

Can you redo this?

thanks,

greg k-h
