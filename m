Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FB145A0C6
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 11:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbhKWLCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:02:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234392AbhKWLCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 06:02:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637665178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uZYQ3dK+pTT7W58kN2j4Xwy6L3bp58RUTZUB/WeZRis=;
        b=HriXuLv8hO80KOp6Og/QiZ0JcxVWiZRQKl0VUg9scYdM9hU9jaoKttbb3ee1GWfTiX/RMa
        TFTKGMgBmtKO8jt2c7riEilo3sz7MubyzrvueQrjucdNHQeMFRjZUbN+mXxqQyNtWzuiT4
        oT2hA6GcuaOzIr8a0X3NQhFSqgqOptE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-kvunhmy5NSus4-tV9rfMyA-1; Tue, 23 Nov 2021 05:59:37 -0500
X-MC-Unique: kvunhmy5NSus4-tV9rfMyA-1
Received: by mail-pg1-f200.google.com with SMTP id 141-20020a630793000000b003214e421b2cso1185531pgh.5
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 02:59:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uZYQ3dK+pTT7W58kN2j4Xwy6L3bp58RUTZUB/WeZRis=;
        b=BbN+qTqe1TEymcKTeWYBoO1jkNW+X+b6BvzMXi3BcCYlCp5xc4IbUlBg0mqdYLhg90
         TdKmwHQqHFooBm/11TMTUGwjrFRdMgm6/CrdDXPAK4LqOm+eIeDc4zB33Pd8De3Naxgq
         liEcceBCul0BRXI54Nt/yjOWmBji2DM6y72MmIF63KXGi3TGpfWuvxYE17Snmr9xI+3X
         uZHvZu/u7gPkLVJ+xZi5QBgBH2psFrjt69vTuUUck1oQm/OoVzQhk4yu6l4hLurVouq7
         BBs4uCIaBCUlErmfK5bgrDrGU8RvEX1TofmbwUprsWpubBYP3h7Xkvmi0BsFyxTT4gVy
         7Mkg==
X-Gm-Message-State: AOAM532fVGPlm5FUyr9LyXCjzt1NyP3oneHGG1VmrzCPIL90zjdiIDjm
        lmjWSBkc41Op34ye9FjpfB7YXHmYiC3maLU9T9kBb26iCGoey2Jj1i3kmtcCLEWOQUfSu5IBUQv
        RgInUwFiH723gDjm+OMy03TvWpAjO8jJ6
X-Received: by 2002:a17:90b:1185:: with SMTP id gk5mr1722080pjb.113.1637665176144;
        Tue, 23 Nov 2021 02:59:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxx7xv4fxhzwasQ8imE1160Q++nWpnzPEJXzYqlRiVVCYcO7RJBWLhLr9lrRSy327vFY2wCVhywraOuWK7xPMo=
X-Received: by 2002:a17:90b:1185:: with SMTP id gk5mr1722053pjb.113.1637665175957;
 Tue, 23 Nov 2021 02:59:35 -0800 (PST)
MIME-Version: 1.0
References: <20211121230439.76777-1-sashal@kernel.org>
In-Reply-To: <20211121230439.76777-1-sashal@kernel.org>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue, 23 Nov 2021 11:59:25 +0100
Message-ID: <CAO-hwJLkmZPj25O49Xr++jWcoBUEJHQAtPZFkXTjwFZvRqFKJA@mail.gmail.com>
Subject: Re: Patch "HID: playstation: require multicolor LED functionality"
 has been added to the 5.15-stable tree
To:     Sasha Levin <sashal@kernel.org>, "3.8+" <stable@vger.kernel.org>
Cc:     stable-commits@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Jiri Kosina <jikos@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 22, 2021 at 12:04 AM Sasha Levin <sashal@kernel.org> wrote:
>
> This is a note to let you know that I've just added the patch titled
>
>     HID: playstation: require multicolor LED functionality
>
> to the 5.15-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      hid-playstation-require-multicolor-led-functionality.patch
> and it can be found in the queue-5.15 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

I am deeply puzzled by this cherry-pick.

The purpose of this patch was to fix fc97b4d6a1a6 ("HID: playstation:
expose DualSense lightbar through a multi-color LED.")

So unless this patch gets backported in stable (and this is *not* a
request to do so), bringing in this patch in 5.15 is wrong.

Cheers,
Benjamin

>
>
>
> commit e3d2570f947ede21072fd5a08c0d4bc40b6688ea
> Author: Jiri Kosina <jkosina@suse.cz>
> Date:   Mon Nov 1 15:12:02 2021 +0100
>
>     HID: playstation: require multicolor LED functionality
>
>     [ Upstream commit d7f1f9fec09adc1d77092cb2db0e56e2a4efd262 ]
>
>     The driver requires multicolor LED support; express that in Kconfig.
>
>     Reported-by: kernel test robot <lkp@intel.com>
>     Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 3c33bf572d6d3..d78b1c1fb97e9 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -868,6 +868,7 @@ config HID_PLANTRONICS
>  config HID_PLAYSTATION
>         tristate "PlayStation HID Driver"
>         depends on HID
> +       depends on LEDS_CLASS_MULTICOLOR
>         select CRC32
>         select POWER_SUPPLY
>         help
>

