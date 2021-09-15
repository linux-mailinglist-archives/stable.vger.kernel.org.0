Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AB340C6F4
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 16:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhIOOEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 10:04:55 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:38189 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237678AbhIOOEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 10:04:52 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1M8yU2-1mWXNi0EFy-0063eu for <stable@vger.kernel.org>; Wed, 15 Sep 2021
 16:03:32 +0200
Received: by mail-wr1-f48.google.com with SMTP id m9so4136142wrb.1
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 07:03:31 -0700 (PDT)
X-Gm-Message-State: AOAM532VoLcVOw5dinvg3Abna0lAb1DwO1YMpWcgmYdiDDERzNgCVwl5
        in6Xnz1kqzUW6n/78m0n0Si+WXEY04wX2x7azhA=
X-Google-Smtp-Source: ABdhPJyPTCjN0lPxQ4vPuD3OdRsZkXbiYf9mDveCLsJeDFfgSELy7Wp7aMWX8DNrGyXWFFHV7wKAn4C5F49LOl1Lh3Y=
X-Received: by 2002:a5d:528b:: with SMTP id c11mr34919wrv.369.1631714611596;
 Wed, 15 Sep 2021 07:03:31 -0700 (PDT)
MIME-Version: 1.0
References: <163171120021629@kroah.com>
In-Reply-To: <163171120021629@kroah.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 15 Sep 2021 16:03:16 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1kZkgphnOTFx3ViRKH6ZaKbUH8iDoQyVTTbsLHX4OLmw@mail.gmail.com>
Message-ID: <CAK8P3a1kZkgphnOTFx3ViRKH6ZaKbUH8iDoQyVTTbsLHX4OLmw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] ARM: 9109/1: oabi-compat: add epoll_pwait
 handler" failed to apply to 4.4-stable tree
To:     gregkh <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:qbwHBIE5bQ4oZE80okdB1PzoxJQxMyY8alnkBZmilP1daz9yOaq
 RczYf4GDXyuRx+cU60ZsVJbuFZnsh8VtsccaFaGOKIf7kDPjnC1Jc1ruDYfc0FjBuhLCn82
 MUX/UPvyR9vUPc6RLVg34aN9PUkRLH048smcDayP/HZomj7Z4LsWz0sa/zTBySX3Nz98YLp
 OkEpnHo+ZWUIoO+MooFLg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dkISuuQJHUs=:FOy4sypRSn0rg40CvjNcDm
 ze26oRhSqnOeObiKYgsCb2ixn8iVuX6JQMMCz543HK2oG8Cv7FptMQNJr1U4KB+Q6hemuk5I8
 16a8cJTa3f94ebRhi22IgwLZw8RhHmhuIbfkM/7SvbaAJdxuDkKcDIcz4M46+SIzVG+i2Y2Lm
 cGy7P9d8cdccOCDYr2NodX3LLZqJO4g5CDTbAf30H7ERIQCgEFosQEYfcFJEsX7oE8DTvhRpO
 8n8ZxNTlUDTpduyWEYAzN+hrYmC557R5z+cPQKGTUAB8Q24Ka1Ze2zFTjQbs3eM2wmptPts3i
 bvATg14CXMfxLctkF25BVjbpmV97fu3cClM3NH1kLOfYrfPTsIQyS7QWfwuKK0okplF23YDQH
 l5ouXd6yuGRv/3RpfecCu65aj/ZBoQzLHmzi0B8ItAlRHmraG/E/usrfezAWu2cDs8zX5YUc2
 ZRSN4e3lTN9DtgIFfgMv/uH1tx5zepP2PP+zUJqdFPqq9Y3rnvmpeN5IdJhEtNfrjGwo0Hjbd
 Ltq5WorNvxiVk+yStBvqt4nq5Ab2sEC8OOJlC1J2bORXfOsW7TNnL85MJlvkNvG7kZ5uN1nqO
 UpKTWV+u9IvlaVsTahJHAyZL06/srRiGmB9O9PdTdOMoPNrBkogg4jzIs4b5B0Kuw1go25YUe
 FI4et/tMinV8SzO/fOJgtEf6+1PI7+qTjpmeBjXP/16Pcvkorxg7EkUnjc8lDn7G3CUZmR/uL
 KeHIqpm7bgQL2nLiOH+/kzbGWhSZUZb40ECF9w==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 3:06 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I think we're good without the backport. While this fixes a real bug, the only
reason to actually need OABI support is to run old binaries, and those predate
this syscall.

         Arnd
