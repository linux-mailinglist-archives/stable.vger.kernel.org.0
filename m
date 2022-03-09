Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393C44D38CD
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 19:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbiCIS26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 13:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiCIS25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 13:28:57 -0500
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5B831206;
        Wed,  9 Mar 2022 10:27:57 -0800 (PST)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2dbd8777564so33640277b3.0;
        Wed, 09 Mar 2022 10:27:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=abyW9EPAt1/N2g7LcA6pvtwKR9wcKCKXIM62EVOVNTg=;
        b=YrQWr5MRlTKtKfiHJOJ/KDZwvgPoPPoGw7IurCuo1JY4ISiyPCaoAkWBNzLvUL4cyg
         WY06c+xpxnWRflqHFuygmL9vueS2Uyhi64A+v6rIOIdTjCciKF+Q0mmbnZlxemaaN8/y
         RHcyf1faQGLrTKXKOarmuwxfozXv+LXZ2AVZmfmyJy5tIchAS2m2SVkA8o2Q4nhpoWjJ
         c+tTV0lvWpXfn1TpL3qBzHf028jYatQnpXKAquEXOEHVRivhlM2AK0kN4Mludd1w4ntZ
         aRwxUuhaYcku0FS/CVqfG97XAWlX+U1V5/VL+AfwmghLpfQkLxqb/PW+HX2UVYloWeT+
         GSdg==
X-Gm-Message-State: AOAM530R7GCq/7yQoeiylpTVraYev5fKHXaUvzAaXKHj+6IYCEDmHZz+
        XOUWRvXAvphBSQRPRJ4GQ1YDP05w6BEz0TP44TIpgfw1/7c=
X-Google-Smtp-Source: ABdhPJxl9BcwZnFKR4ckz/GGm2JFpaPyXO9ChA7b1yNGKEZEX9CiJuXw85c12rE55V8JfkQgTQ0xbzXGlD/5zF4jdOg=
X-Received: by 2002:a81:524c:0:b0:2dc:1a00:1124 with SMTP id
 g73-20020a81524c000000b002dc1a001124mr981662ywb.196.1646850476426; Wed, 09
 Mar 2022 10:27:56 -0800 (PST)
MIME-Version: 1.0
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
 <CAJZ5v0hQifvD+U8q1O7p_5QeicG_On4=CrgNj0RsbPSbkY8Hww@mail.gmail.com>
 <ad3b77f8-7e75-1dfa-8ee4-1077336911aa@redhat.com> <CAJZ5v0js8Vr7dW09WGyR_JTn4kMybDhaTWt4yziqwSM+oAXUNA@mail.gmail.com>
In-Reply-To: <CAJZ5v0js8Vr7dW09WGyR_JTn4kMybDhaTWt4yziqwSM+oAXUNA@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 9 Mar 2022 19:27:45 +0100
Message-ID: <CAJZ5v0imJfOp-Uw=tH2dimSQzb-EgHu_yEU_0LScmrQ43t3pbw@mail.gmail.com>
Subject: Re: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 9, 2022 at 5:34 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Wed, Mar 9, 2022 at 5:33 PM Hans de Goede <hdegoede@redhat.com> wrote:
> >
> > Hi,
> >
> > On 3/9/22 14:57, Rafael J. Wysocki wrote:
> > > On Wed, Mar 9, 2022 at 2:44 PM Hans de Goede <hdegoede@redhat.com> wrote:
> > >>
> > >> Hi Rafael,
> > >>
> > >> We (Fedora) have been receiving a whole bunch of bug reports about
> > >> laptops getting hot/toasty while suspended with kernels >= 5.16.10
> > >> and this seems to still happen with 5.17-rc7 too.
> > >>
> > >> The following are all bugzilla.redhat.com bug numbers:
> > >>
> > >>    1750910 - Laptop failed to suspend and completely drained the battery
> > >>    2050036 - Framework laptop: 5.16.5 breaks s2idle sleep
> > >>    2053957 - Package c-states never go below C2
> > >>    2056729 - No lid events when closing lid / laptop does not suspend
> > >>    2057909 - Thinkpad X1C 9th in s2idle suspend still draining battery to zero over night , Ap
> > >>    2059668 - HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case ge
> > >>    2059688 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
> > >>
> > >> And one of the bugs has also been mirrored at bugzilla.kernel.org by
> > >> the reporter:
> > >>
> > >>  bko215641 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
> > >>
> > >> The common denominator here (besides the kernel version) seems to
> > >> be that these are all Ice or Tiger Lake systems (I did not do
> > >> check this applies 100% to all bugs, but it does see, to be a pattern).
> > >>
> > >> A similar arch-linux report:
> > >>
> > >> https://bbs.archlinux.org/viewtopic.php?id=274292&p=2
> > >>
> > >> Suggest that reverting
> > >> "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"
> > >>
> > >> which was cherry-picked into 5.16.10 fixes things.
> > >
> > > Thanks for letting me know!
> > >
> > >> If you want I can create Fedora kernel test-rpms of a recent
> > >> 5.16.y with just that one commit reverted and ask users to
> > >> confirm if that helps. Please let me know if doing that woulkd
> > >> be useful ?
> > >
> > > Yes, it would.
> > >
> > > However, it follows from the arch-linux report linked above that
> > > 5.17-rc is fine, so it would be good to also check if reverting that
> > > commit from 5.17-rc helps.
> >
> > Ok, I've done Fedora kernel builds of both 5.16.13 and 5.17-rc7 with
> > the patch reverted and asked the bug-reporters to test both.
>
> Thanks!

Also, in the cases where people have not tested 5.17-rc7 without any
reverts, it would be good to ask them to do so.

I have received another report related to this issue where the problem
is not present in 5.17-rc7 (see
https://lore.kernel.org/linux-pm/CAJZ5v0hKXyTtb1Jk=wqNV9_mZKdf3mmwF4bPOcmADyNnTkpMbQ@mail.gmail.com/).

It is likely that the commit in question actually depends on some
other commits that were not backported into 5.16.y.
