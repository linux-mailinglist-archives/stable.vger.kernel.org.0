Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9BC40CFBF
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 00:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhIOWyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 18:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhIOWyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 18:54:50 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056BEC061574;
        Wed, 15 Sep 2021 15:53:31 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id v2so6395906oie.6;
        Wed, 15 Sep 2021 15:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SjVpNS9ng6AxAhwsp9QMTVjnxhptehqqdISuh8ToKLE=;
        b=k+xDi8L3vjcu+zR44mli5T87UI7/l/laxQQmw+Bc7hkQiNjpztBULca8uQxj7fNGN8
         rl4LIEssDDOtVWwKM5/zTZ/I2nobP48vlsHN1Ct6sZx2o05EKsrl1pbOm5OVPiMWhkfn
         8TByrO/w1GDtdQe1+VBMgh2j+7slv3iF+232kCyWHH4NVurOdx2VWnocccgDtim0rZud
         myLRQOhokqjqneo1hFFDzYLVXkAEZm5PHtcGHK3LwR6D9EMSNtQcDRjAu72K72faOWRH
         S0Rh5PP2Ffhu6abfyi8goTuRgCA05pCXgxpW6fohH9q+6jGQWbbHBUz8KMjMHQWAuG9Y
         u5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SjVpNS9ng6AxAhwsp9QMTVjnxhptehqqdISuh8ToKLE=;
        b=Ehorz8hGFKG8qAIhFUwHlriVapjnQh/IWqb7YqC82ygoMEuneLvcXVC7tWD5/Bin7i
         gv7AgVLZrRPv2bvybtK+MSz7OrpYtUk910RliGhvypKXF0Yf/1YwYaa8o8GlZBO4Y/73
         cuSflyey1BD1eRsWKRkPmWUoo4RdPU+nSxh/Fn90ZLBzd3TjMkFfqy2rxhfCpwTNzuU0
         nTk1Xd8CTSyPcfh3hD0wZp2SXS9IHJY/iaMdOQTDxK6x6TR8ySYKQh4AEolTeeEXQqnE
         oqwLjLc6m9gPdPQGp45/4k8v2JMT2AAVUHfqKF6yKZn01S4d5Umjgj+sXdV/y5Oz0xlX
         2b4w==
X-Gm-Message-State: AOAM530PdrbwVa6hP9Rm1CFoyr1pvuxaxp0XYTUW4ZMkh2Y009ZBXwW5
        3c6Vrg7SO2QhBQrZL57d48/0hYtG05pDkDhKxPE3sQ52w/g=
X-Google-Smtp-Source: ABdhPJxcb6AgmC0d9pqAvAmiISC7hhj0/nut0s10kwxOT9m4Mvfi3d5Ha4oGCd/pApjpx8pqwzBVFQ/vWGtXtZt8Vh4=
X-Received: by 2002:aca:5cc3:: with SMTP id q186mr6897055oib.17.1631746410418;
 Wed, 15 Sep 2021 15:53:30 -0700 (PDT)
MIME-Version: 1.0
References: <16317104197115@kroah.com>
In-Reply-To: <16317104197115@kroah.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 16 Sep 2021 01:54:11 +0300
Message-ID: <CAHNKnsRRaXzuoiyibMiF9brhhmNJCMKMOxY6K7rcwzQr8M8Htw@mail.gmail.com>
Subject: Re: Patch "wwan: core: Fix missing RTM_NEWLINK event for default
 link" has been added to the 5.14-stable tree
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        stable-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

looks like the commit 8cc236db1a91 ("wwan: core: Fix missing
RTM_NEWLINK event for default link") already included in v5.14, see
details below the patch.

On Wed, Sep 15, 2021 at 3:54 PM <gregkh@linuxfoundation.org> wrote:
> This is a note to let you know that I've just added the patch titled
>
>     wwan: core: Fix missing RTM_NEWLINK event for default link
>
> to the 5.14-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      wwan-core-fix-missing-rtm_newlink-event-for-default-link.patch
> and it can be found in the queue-5.14 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>
>
> From 8cc236db1a91d0c91651595ba75942a583008455 Mon Sep 17 00:00:00 2001
> From: Loic Poulain <loic.poulain@linaro.org>
> Date: Thu, 22 Jul 2021 20:21:05 +0200
> Subject: wwan: core: Fix missing RTM_NEWLINK event for default link
>
> From: Loic Poulain <loic.poulain@linaro.org>
>
> commit 8cc236db1a91d0c91651595ba75942a583008455 upstream.
>
> A wwan link created via the wwan_create_default_link procedure is
> never notified to the user (RTM_NEWLINK), causing issues with user
> tools relying on such event to track network links (NetworkManager).
>
> This is because the procedure misses a call to rtnl_configure_link(),
> which sets the link as initialized and notifies the new link (cf
> proper usage in __rtnl_newlink()).
>
> Cc: stable@vger.kernel.org
> Fixes: ca374290aaad ("wwan: core: support default netdev creation")
> Suggested-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/wwan/wwan_core.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -990,6 +990,8 @@ static void wwan_create_default_link(str
>
>         rtnl_configure_link(dev, NULL); /* Link initialized, notify new link */
>
> +       rtnl_configure_link(dev, NULL); /* Link initialized, notify new link */
> +
>  unlock:
>         rtnl_unlock();

This change will duplicate the notification call. Fix already in v5.14:

$ git log --oneline v5.14 -- drivers/net/wwan/wwan_core.c
d9d5b8961284 wwan: core: Avoid returning NULL from wwan_create_dev()
68d1f1d4af18 wwan: core: Fix missing RTM_NEWLINK event for default link


> Patches currently in stable-queue which might be from loic.poulain@linaro.org are
>
> queue-5.14/wwan-core-fix-missing-rtm_newlink-event-for-default-link.patch
> queue-5.14/wcn36xx-ensure-finish-scan-is-not-requested-before-start-scan.patch

-- 
Sergey
