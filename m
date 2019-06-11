Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85003D5E0
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 20:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391625AbfFKSxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 14:53:55 -0400
Received: from mout.gmx.net ([212.227.15.18]:47303 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389470AbfFKSxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 14:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1560279214;
        bh=UaIRE1hGIwlyuWzt5YPdN/DKYTObr8mGY6LVa+rNJIk=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:References:Date:In-Reply-To;
        b=UczRZRdhx2rMxCtc0G02WPETGFQg0Vx6lbXeDktzKF3TKlcMcDkjd4DOBBXPuT+nl
         YsY48ssQlrkt/AbbyyT6JtdwZ242bwcS0HtNY/wG01b7iDUqia2b1sPbD71XxzhlDN
         iC8ojlM1WlL6U7n8FOHsY6SVJnqyZiN/m5NvIZvQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.203.76.133]) by mail.gmx.com
 (mrgmx002 [212.227.17.190]) with ESMTPSA (Nemesis) id
 0McEkx-1hHBe523kd-00JYmI; Tue, 11 Jun 2019 20:53:34 +0200
Received: by localhost.localdomain (Postfix, from userid 1000)
        id E9F20800A7; Tue, 11 Jun 2019 20:53:26 +0200 (CEST)
From:   Sven Joachim <svenjoac@gmx.de>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: Linux 5.1.9 build failure with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n
References: <87k1dsjkdo.fsf@turtle.gmx.de> <20190611153656.GA5084@kroah.com>
        <CAKMK7uH_3P3pYkJ9Ua4hOFno5UiQ4p-rdWu9tPO75MxGCbyXSA@mail.gmail.com>
Date:   Tue, 11 Jun 2019 20:53:26 +0200
In-Reply-To: <CAKMK7uH_3P3pYkJ9Ua4hOFno5UiQ4p-rdWu9tPO75MxGCbyXSA@mail.gmail.com>
        (Daniel Vetter's message of "Tue, 11 Jun 2019 19:33:16 +0200")
Message-ID: <87ef40j6mx.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:6ypP048I125pJ0I5YNHrcLIMYTqFXYLdE+MkOxEKBEtbhPpIfwp
 t4o+VUMSrGspYkDtrxarOZlU0FoIr/GfA5WxiIUUWpiCzy936KYjKIldkMD7BoljfE+OZuN
 NOP9B3C7xdxDT9CrTAS4D1UwKHHjOa9vvCZQeesC30Hb75D1zZK2diQXeBOZlJnBm+9PTDy
 YCeIp7iF5hDjKfmbtALDw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:iz0Gk0y+KZ0=:QOVlq99LMrRWeWsXMRncsD
 3DsRZcSfWbqgo5lXt5SHgYzQYmVpXTGhEOf66ef4HuABm/6dp0+lLsN2+H8QSavcjiT9kFKDB
 KL+N3oOm7OQYFB+vd3n7u3L5H0NfltNCup/xKzuwzu/6sTkOX4lWtu8OqZDPHY6JOeP36yI0t
 qxoZD+6S+yt24d+AiSKdE/LyVH9zUoY4uBCJ2YAfX4C0uTTLHwnZYjXTK46N9dwebeXWtx6p6
 mFKLXX4eN9AzRHDCxRk00mphQNPTYUbbCuxRxCqENTnNzGrUIq1PnYj2vGOsGhlTc1SvwZL0n
 METH5FGO+C+YDSo6W63UYhRwxitjTdmx4f2ktF97RwGCA+UCgOekD5AjTM2IjAVDQfaHObIT1
 5AcNVjy0wSM0pFRRcY+1VqSn0jT0eRI4cT50syjjBgxp/AI7T6m96Cw2ydqiS3AOaNnKwl0Ch
 K3RPDg7C8JDwnZJY7VnfPPNl+56m4Rx0ebMYiScyaEHzUt+lDGbtHwcPWJmOwAB4cj/vpMqBT
 idCmH29TaqREoAayn3Dg9mxKkEn+cKvuF2BJg+2HLh/q079L8BJBZT7gspxSUaoYl6Z34okrc
 NQLSyJ55hBX/vJRu8YjvkRdYvK/FKrkIh2aT//cB8hnzYhACAdIPorXYFqyavQ19NgcaYyEJ6
 ev0NVY1Zk4N2adUdk0KqJiuhI61nY4MNMSyZqv6Q52T02IJyyKtv7+EPrKaEnwMNBKjMPDZvw
 kX2Aea+aoDZu+hurGm1yEoi5RNyM8Zjq3s1MC6CQQLUsdMDCpdK88cpwBaG11orwInEPjBhcW
 /24uJ8wC2X0asHzJtk/ttC6eIs2L7kGIeh9IHUgudGGQS9qRVrsf35o3TgzfCjVDF1JXfQjg+
 TJxCz+3CndxFQQDbarrzHCZuZbvt6COJVTTnJ6QSNc1idAz8U4AwEyu8I0Py4P00uNq8Q4qul
 +G0CpLldS1vaKOu99J0wrkoZiImOGa5eH1CLzTmEZPnf3/8A3fyYt4ulUoytWSoRj339rEbjw
 kQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-06-11 19:33 +0200, Daniel Vetter wrote:

> On Tue, Jun 11, 2019 at 5:37 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Tue, Jun 11, 2019 at 03:56:35PM +0200, Sven Joachim wrote:
>> > Commit 1e07d63749 ("drm/nouveau: add kconfig option to turn off nouveau
>> > legacy contexts. (v3)") has caused a build failure for me when I
>> > actually tried that option (CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n):
>> >
>> > ,----
>> > | Kernel: arch/x86/boot/bzImage is ready  (#1)
>> > |   Building modules, stage 2.
>> > |   MODPOST 290 modules
>> > | ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
>> > | scripts/Makefile.modpost:91: recipe for target '__modpost' failed
>> > `----
>
> Calling drm_legacy_mmap is definitely not a great idea.

Certainly not, but it was done by Dave in commit 2036eaa7403 ("nouveau:
bring back legacy mmap handler") for compatibility with old
xf86-video-nouveau versions (older than 1.0.4) that call DRIOpenDRMMaster.

If that is really necessary, it probably has been broken in Linus' tree
by commit bed2dd8421 where the test has been moved to ttm_bo_mmap() and
returns -EINVAL on failure.

> I think either
> we need a custom patch to remove that out on older kernels, or maybe
> even #ifdef if you want to be super paranoid about breaking stuff ...
>
>> > Upstream does not have that problem, as commit bed2dd8421 ("drm/ttm:
>> > Quick-test mmap offset in ttm_bo_mmap()") has removed the use of
>> > drm_legacy_mmap from nouveau_ttm.c.  Unfortunately that commit does not
>> > apply in 5.1.9.
>> >
>> > Most likely 4.19.50 and 4.14.125 are also affected, I haven't tested
>> > them yet.
>>
>> They probably are.
>>
>> Should I just revert this patch in the stable tree, or add some other
>> patch (like the one pointed out here, which seems an odd patch for
>> stable...)
>
> ... or backport the above patch, that should be save to do too. Not
> sure what stable folks prefer?
> -Daniel

Cheers,
       Sven
