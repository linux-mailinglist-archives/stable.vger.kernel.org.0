Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21200F7FA9
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfKKTSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:18:32 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:55351 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbfKKTSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 14:18:32 -0500
Received: from mail-qt1-f171.google.com ([209.85.160.171]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1M1pk0-1iS3Li26zw-002Fgs; Mon, 11 Nov 2019 20:18:30 +0100
Received: by mail-qt1-f171.google.com with SMTP id o3so16843234qtj.8;
        Mon, 11 Nov 2019 11:18:30 -0800 (PST)
X-Gm-Message-State: APjAAAVTJORSwpc1e4OKZwFVLchsIdcNuDMfZTuGgefWoOz1AQONTcdM
        vFBrOy04wM36dn+hNS7eofp3pE9aM3Bbwtv6zUk=
X-Google-Smtp-Source: APXvYqwMVw3H+iof+ix+/L2TJ9lLRKjD4R0tC3c40dtcOhrtVO3sEPmg679ulBD5HjGCDawg+phWJyVcA3g8siZqOAA=
X-Received: by 2002:ac8:18eb:: with SMTP id o40mr27497636qtk.304.1573499909109;
 Mon, 11 Nov 2019 11:18:29 -0800 (PST)
MIME-Version: 1.0
References: <20191108203435.112759-1-arnd@arndb.de> <20191108203435.112759-9-arnd@arndb.de>
 <20191111182828.GC57214@dtor-ws>
In-Reply-To: <20191111182828.GC57214@dtor-ws>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 11 Nov 2019 20:18:12 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1coj4GpwcCgL0rEvZKb4OvktopjRETCNWEwfaLxgbcHQ@mail.gmail.com>
Message-ID: <CAK8P3a1coj4GpwcCgL0rEvZKb4OvktopjRETCNWEwfaLxgbcHQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] Input: input_event: fix struct padding on sparc64
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:TxRoHKMo2qW71QlQNSP/PK/SfamwG+mthBc1VrRvIyixftshMpd
 5TArJhIk165GPHIEthUQe/I6ZVXC2pyru/7/ZCaj4T6C8Tso3ylqWcuBxUt5DBM3HVRp7Q1
 wWXAIq1X6PPMliWWQuQP3sipuLlUx6HgowiHw95uAJMAnGkjHfEGQ+aRBhmcIBwgsWX1EUq
 l/SJ5szI7aA/nsoCH3+pg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:P3jbIN4wk2o=:yu62QjFqdHZLVZCYL1aChf
 ApgvGBT3NMq6uEL30XfY8BMPTfiHB4RibqozDfMc6OldJ3HHvi6o3y52nKaeq05xNVMWZtBzH
 P4uhlbYHUn2VlPAsz4Hd2rnjY5/5L+V6gCrwAVFkGz7RSnZbUa7wxOQD1TXFindLQIliJSKVF
 EkFaZL16HUmpNmkCmgs6PbYPCSMQUO1UGyLz8ziKXdVnGiEPJASMVBa4VgEjMbEbrB8J3el+N
 yEmQBgcfnw9dG9p961GoCnZOw+oWlg9tZIqYN8ECEsRmvyu8jNXnomPKIZQiLaPMPqFQw4jGG
 ZC72w4cqrGUuSNB9FnBCW1NYzrvluthYrCiaMK9HyYOphY1AubKDc04t6TBq1tQdsm8Stt3s1
 aF6KuW+9QwEEYkOLYEUXohjz5J3JboL/4G3NORQJ0wzlf+tTCAWZtBgPmhEhxRBSw4Nbx/xAj
 cKHdqOXycVZUsK6uWhiYSZo1xh6uE+UbmBWfrF+4jFOK/inrdRdb1+h4O0xeO9j4F+whhywIe
 CphyX8fq0L2zGV0wmQqbcNBmioMV2pqA4DrNTKryVam1atxJtlSG9aPMz9+DaORDytsjz20yJ
 eb3HK3Qgd/Ey8HCyxYsL7+1KPyRZM7xkp7CCfELVtu/v7ka6sX7FDwyInq+/xv/+i51ZZvGpa
 MCnNy80w6nTjDzC85Mqcbl6SaE6ND9Qv09JBT8wjN7JfA1E5NFMd3/00321wc0UaMo58KSjgh
 mN+wvqUjq5aeJtXO7uowLKlSFrrEq+PCl5BjAUzmLHczeFx+jvAB94wSjoYqa7OA3UZDLZdNk
 1546pWVrmvrG0ilFQkKxrdty9y6lUa3+/UzD96ftz0XY8L0aIUmOCbQsuQwhHJmUunzjTJpzY
 8vM9nsijd8B+Fa4LaudA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 7:28 PM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> I do not like ifdefs here, do you think we could write:
>
>                 client->buffer[client->tail] = (struct input_event) {
>                         .input_event_sec = event->input_event_sec,
>                         .input_event_usec = event->input_event_usec,
>                         .type = EV_SYN,
>                         .code = SYN_DROPPED,
>                 };
>
> to ensure all padded fields are initialized? This is not hot path as we
> do not expect queue to overfill too often.

Good idea, changed both instances now. Thanks for taking a look!

      Arnd
