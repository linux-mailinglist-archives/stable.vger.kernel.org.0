Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6BF59B731
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 03:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbiHVBQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 21:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiHVBQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 21:16:08 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181D61FCEB;
        Sun, 21 Aug 2022 18:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661130965;
        bh=x5pSxYkH1+MKJHQizQrAJ0MWNoO/BUWSG6YS+I3fQCw=;
        h=X-UI-Sender-Class:Date:To:Cc:From:Subject;
        b=EAcpOnwTymAvyYa1R4afV1u8B5MNrNb/azpV13iHXqqqV7m3eOzH/ch5UY9Qzpl+S
         T4Psb2VU7eVxGl0h0JEgLgaatRyR0RwHQ96u6yX390qu3SmIgR9+1jsdfdYrS+PHfR
         Ym8YqsGFRhJfL58HrID2GByckh1zlg8sR5vEHGkQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M3DJl-1oTVU10F3N-003d7j; Mon, 22
 Aug 2022 03:16:05 +0200
Message-ID: <2d6012e8-805d-4225-80ed-d317c28f1899@gmx.com>
Date:   Mon, 22 Aug 2022 09:15:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     stable <stable@vger.kernel.org>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x86_64@vger.kernel.org
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64 UEFI
 runtime)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:s6xZ76BCYb4OTJdeDQQ2yV2g8i10/2Ry6601fyssiI0Hd9Z5r2d
 tJwT0WkUtCSvECZ3ir20Nqd4UpuabJxTvIZ8zoHeWwikZkb2+dHn89UdC8ps3/2tsGEbkBx
 AbXLiJ8a5Iej21MpyUdWSI0zsNY06ATMCkFDWxL69TA8CiqoFwI0P1QxkQT7MnQRsa2t1zt
 qWUQXjXEhet3PouG+jutg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:KG6Er7NV+bw=:QDaCbemftEYo5b/eRSq7n8
 s6On5XJux3PigsetgcTY/zn4pax3prlgKakG4JGFoZDbCBuguJ4K+QQJEXA2FYT1rJTNz9dC0
 jRtyyBDlqgiwj+J/O/r9g/7Xv/FlXN3KsudLazvf666kP4zJNYf/TNx/6MiMohDQb928fNRI0
 UxzQGxk4uK/QWdJ7+3izb+X6m55QBtTPDmEvMRfOjMVYt1d3qY3ENJ2FBTAnze6wiAP1WuMJS
 MFfEqL7fQBFtir7SfKxXgrnEXzirR2CvhxaKyofrADKBzaH3E6Jbdaal+ZlFxZD92ORHnFyEH
 dCpKHpuNUIH5myyEReR6rjdNif4kWUNdfxF5I85mO0J/XgO8PoqUSGbNhJxn+q1Wbn1oFVmy6
 qF/QJNRIWoGhVtjzBcsg+Y3XansIkTUpqdjrzFcTipmCCgmNmTIU4ZfrOrsQ7POEccjHeLqzl
 XgnNct0uS0gnBl6ao1kUSByVwOppCNT05MsDcWGMWwuocL3vuFlU+K7xWonM8wt0H3edGf71w
 exdRG84tJB3uc/jLpUprVtbwsUMn0pgVoRdh6aHqaqa2EYTL9k6enaeLbJnNmnU4XeSMgbutW
 JanXCo1bBUEe8W7jScPUWuqR5p0IiCLGuinXuwSUyB3Bmd2mZy1h9gNEa92lDFZokMdv22a02
 3VFnMyMrbipZ55CkmIvbwi0R0M2tnfBzmBYyYRKXiHuUE38ADXJANYFzVK0eG+9DN1EXPNwDz
 OiEBWtDp6WdZ3hQhbFFNr76BO4T/FoVJ8WHEUL1vezMJq3IEIN9u05yQIL27IwPQzLF67ZIXe
 BdoyLgWtYCDn2LofWPRcxU8CbdAqUQJtdmveF3R/OEqzbq+/bO9xIwn283AuH3qvIqSOtr7kS
 qzO6yWD/fWMoXR5uJ1K1qFMu9ppvTB+2BfCUtOZnJ4vYhWwII40n4+iZtfuYAA+HMjMgINTz8
 iY1Dkaq03UtX/H+F8g73IdybtBb8klV+Ql4if+NVCvy9avNsAngokUzjRsutq7AZre6chuOsH
 N4ryDfd3uHKVudx5Bz3XMECqEifk1t7X3sZJo0XoyGP4XAf3PbSwwVJwDEeeXJPmsM2x0BC9/
 HbfZM8spbdy0rq/T8G/C6BvW5KbmQ5e2UPI2yGlo1sCuhIguALrPBUWoA==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

When backporting some btrfs specific patches to all LTS kernels, I found
v4.14.290 kernel unable to boot as a KVM guest with edk2-ovmf
(edk2-ovmf: 202205, qemu 7.0.0, libvirt 1:8.6.0).

While all other LTS/stable branches (4.19.x, 5.4.x, 5.10.x, 5.15.x,
5.18.x, 5.19.x) can boot without a hipccup.

I tried the following configs, but none of them can even provide an
early output:

- CONFIG_X86_VERBOSE_BOOTUP
- CONFIG_EARLY_PRINTK
- CONFIG_EARLY_PRINTK_EFI

Is this a known bug or something new?

Thanks,
Qu
