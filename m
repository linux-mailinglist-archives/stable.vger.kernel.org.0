Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093603D2B6A
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhGVRKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 13:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhGVRKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 13:10:41 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D29C061757
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 10:51:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p9so7254608pjl.3
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 10:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+AOwG940J9OuJndHWfq9f7twNmPq5S90ZEVjB1FfoBw=;
        b=MJe0HGZRMl6/9p191rXLlZ+gkzyZYn/mht2+PErk8CZtc+xOYK1nP8vUydwL/8JPjf
         tPb0AB+HuAPKa/vFB3aUKVfpgIsRmnEE2ig72169GpBCEm7hB259Hv32fqXKtxYRfM2C
         uCnK/ehpgnhniz7w21JBsXrCX/4y88nmp9ZuTb3IMvmMeBmn9hchWtgZ2rzMpqIczwz1
         aVFx2SdTlpcSBC+86Ownpr6BLSbCqyEdjLQedvTXdv+GXr0BJw6EcOBxD99Qw0L6Di1a
         EYKjo7mRxLEC177VrGRs6I9RWtDiqGDwDcNcRnNIMnvFecTWGJJyId7Fe2TySQ8Gp3WE
         QIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+AOwG940J9OuJndHWfq9f7twNmPq5S90ZEVjB1FfoBw=;
        b=S2QVsyI+LoaVIiLCrI7yr6xtsdLKYdLINMF5LsVxcsACAIRwNFv2YeQj0fb6jpMzbg
         ZpvKC/C8b+zpvr8o3nTvwBePxHKSdH4iz2Balo0tUCE1uvZrKFGyKM3MQoOV6p9P/uYx
         J0SWZzmS8WI15BrlR5Fq9mp8Q/30s1FHq6Dl/RYaWjcVJXX1FDB6U5Y6h9XBOwlXCvo1
         pRRIitQ3K+RIUR+HzwKQf8wQ7xP4bBh14vA6Bv3YRsQAxNT3NUN27B5t9RrqGTp4DsHX
         2aL0eAmgbWWXhneP7ZelPdj9TeKCqRVtR5O8jjwowQPwl2qB/2kgzjELOlY1aYKR35O9
         XKjg==
X-Gm-Message-State: AOAM530VZSCmrViwD66/mtEYLHxtVCDyPTfZp+1f5SgOWK7vTYHD47WI
        Mmkg7Wb7R/P6IC5gQptdLkezXGvkIwoeTBo/9a1OJA==
X-Google-Smtp-Source: ABdhPJy95Gu8VLqjxh01S5sfiptNLZEK5dtudVOGNkOyRacB4+PSWV3F54z4SGbloK8325svi1uet6cDgTXOI1LdV9s=
X-Received: by 2002:a17:90a:5892:: with SMTP id j18mr912318pji.18.1626976275801;
 Thu, 22 Jul 2021 10:51:15 -0700 (PDT)
MIME-Version: 1.0
References: <1626968964-17249-1-git-send-email-loic.poulain@linaro.org>
 <CAHNKnsS1yQq9vbuLaa0XuKQ2PEmsw--tx-Fb8sEpzUmiybzuRA@mail.gmail.com>
 <CAMZdPi_7-2tXGu0fqE4-Dx7MQpL=9St3JTgfTwov402BXBF5hg@mail.gmail.com> <CAHNKnsTskbtMYvZhSMW4FBE3NwbOyAQ73C6n__6wT7WoV_5HVw@mail.gmail.com>
In-Reply-To: <CAHNKnsTskbtMYvZhSMW4FBE3NwbOyAQ73C6n__6wT7WoV_5HVw@mail.gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 22 Jul 2021 20:01:08 +0200
Message-ID: <CAMZdPi_pDAQ=KB2EUcT62=c+z7jGNOVqMTFWBn1VgBtWg+c6rw@mail.gmail.com>
Subject: Re: [PATCH] wwan: core: Fix missing RTM_NEWLINK event
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Network Development <netdev@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Jul 2021 at 19:42, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> On Thu, Jul 22, 2021 at 7:44 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> > On Thu, 22 Jul 2021 at 18:14, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
> >> On Thu, Jul 22, 2021 at 6:39 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> >>> By default there is no rtnetlink event generated when registering a
> >>> netdev with rtnl_link_ops until its rtnl_link_state is switched to
> >>> initialized (RTNL_LINK_INITIALIZED). This causes issues with user
> >>> tools like NetworkManager which relies on such event to manage links.
> >>>
> >>> Fix that by setting link to initialized (via rtnl_configure_link).
> >>
> >> Shouldn't the __rtnl_newlink() function call rtnl_configure_link()
> >> just after the newlink() callback invocation? Or I missed something?
> >
> > Ah right, but the first call of rtnl_configure_link() (uninitialized)
> > does not cause RTM_NEWLINK event (cf __dev_notify_flags). It however
> > seems to work for other link types (e,g, rmnet), so probably something
> > to clarify here.
>
> Just check additional netdev creation with hwsim:
>
> # ip link add wwan0.3 parentdev wwan0 type wwan linkid 3
>
> On the other console:
>
> # ip -d mon
> 6: wwan0.3: <POINTOPOINT,NOARP> mtu 1500 qdisc noop state DOWN group default
>     link/none  promiscuity 0 minmtu 68 maxmtu 65535
>     wwan numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
>
> But I saw no notification at the moment of wwan_hwsim module loading.
> This happens since I missed the rtnl_configure_link() call in the
> wwan_create_default_link() after the default link successful creation
> :(

Yep just realized that!

> So we need your fix at least in the default link creation routine to
> fix ca374290aaad ("wwan: core: support default netdev creation").
> Something like this:
>
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index 3e16c318e705..374aa2cc884c 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -984,6 +984,8 @@ static void wwan_create_default_link(struct
> wwan_device *wwandev,
>   goto unlock;
>   }
>
> + rtnl_configure_link(dev, NULL); /* trigger the RTM_NEWLINK event */
> +

Testing right now.

Loic
