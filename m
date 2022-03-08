Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5349D4D2009
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 19:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238229AbiCHSWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 13:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234598AbiCHSWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 13:22:38 -0500
Received: from mout-xforward.gmx.net (mout-xforward.gmx.net [82.165.159.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FED56C24
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 10:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1646763692;
        bh=9Q1pP74/isvd1ynPssOmwT5gSvUEzLM9Ck/pWaFaS3Q=;
        h=X-UI-Sender-Class:Subject:From:Reply-To:To:Cc:Date;
        b=KM9RYJlmaC7SMgxmg/DhwmDvbhqcrR23fJ6oL0TNl+E0k8pbvnMWaBbClYJWT0/CW
         Jot6I2KcJBEgumVO/tIOQefbZ/rXRrQWdJH0wxg0GHaHp8jyPsAnnz9tVqo8BQ1uHZ
         rDa/Kz3X1f3x0v5hIDH2I3cbkOGBNk88fMPqZMQg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from RMLAP1 ([86.107.21.198]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MIwz4-1nkxUs0NvW-00KRgb; Tue, 08
 Mar 2022 19:21:32 +0100
Message-ID: <4a83b8d3dc68a2bf6c7e988552a213f161b54c3a.camel@gmx.at>
Subject: laptop does not go to suspend anymore with kernel version > 5.16.10
From:   Reinhold Mannsberger <reinhold.mannsberger@gmx.at>
Reply-To: reinhold.mannsberger@gmx.at
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev
Date:   Tue, 08 Mar 2022 19:21:31 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:CWicR2c8aBXPUS24Ow8Az2d6qJtZcUeImJ6EBDfDqi/27SHpCWF
 IiwPxlCav0rc83X16iwBiZCvWD5wOKQnM3e3y1Pg7y2yix3SpOyqBLWlqO8KtXHS2tc7s28
 sh3UsKwCsvi9RBSIUWhqGvTvslRF8W62SKHtU50mISMAlzE7Wp/ZMOc3JMunJVV/fKtGCKr
 MI8z3V0o2HdxcXvmhbMgw==
X-UI-Out-Filterresults: junk:10;V03:K0:SRbmMU/FvyU=:e2oHBG4BMGFAJfA5XDhXYxtD
 CK+i7Ja/XHkiR4TpmTk92L7Xg8PSEatenTE/lkEjl5QllGziSdyofTBhy1Zz9Sz/AvvqVtYsx
 /XMQBazZ4iw7bttBt/i9fNn6OyzbQt58it5y4sbOVkD4XwCgnP/m2mm11CGE1nbjJ2lQHd2me
 75eEAa41CBcse1Kg4ISJkEFa84LawbBVHhJHE34XotVoslMDf5GPNXoOfWJ1EAyP83kqZeHQ+
 9Qb/BSJvT7KcQnlYzGh2NPVbpMu/1uxUS+7ENATm96dNrq++DR/L4N6NN00nLCDbfsISq3c11
 7oOkBDFBOvaedZZYG0/n00rfiqrdFJJw9RzRvFw8gEslyaosfIjZXzjRKuauJ6z9CkDUFvGZR
 5JORCMLOpJ15/Elsp3afG2Qphj4nRakmCYyFXPgl21CLMJn/fXxUnyq/UNEWAv8A4dw8pB5SJ
 SOJM/XNYxKWIiu6YNWMCVrLxn9DPBlSO0BLFUWW5gAYNxqH0POUvsEcRB2RWQPN0SeIYeJ40D
 mLqNW3aRjKOlvH7UpUa+kDxJ5klO2mE8e/7cSFJPZcIGb8aLMfptZoPlCMuye+nQRijS00U0F
 QCn9/pKs2dTFP3+dvlEKNviw8QzKvtxF4+6TIsPoYPcR/ANKTgOsC0Cqzyl8tm5/V4vnrpm9n
 oYe/VKUPI0j17JzjFG0yo9GttAUwuDvk99/dnJmxoq3SbKrIv5HfFKrwOEp7h3NF1sx3D82VL
 O4vNvP+BeAoAszFlJi0PkAHaYFKRmjGyCqAnijK5T7tM5k489DnvY+kF7IAw4dn0DttI3N9Or
 4KI8h/UtJIbo3EcMMEkEE2vblhmTLPkOzZG0C6IfKoTEXwG4OCZAUOwN5xDbo2xfN6TpxD+iz
 +QANYRbX4irMhac/+Pw/4iJOE/7XgcnnclrCbzzjbZ2mii+SP4ych9u2hFclIJmLiLo/fPEW+
 QR6bZ2ZOcnivJyQtb0yETq3L0YqBfrb7xIz1EvR8bQ1AaISaEBXp1TvbtqGFORZBmZGSAEWBD
 PoBF6unzZz698Y9FjRrBIwYYCbr1bN+yOX/WRJB+4QZwM+CLfynfdJp3Y6bvic345KiNDfIn2
 x8rXD1PC7Vcxkc0nw3EluM+RXDJeYfTWsFR8ltl4Hs5cX/kd1NWjfuA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear kernel developers!

I am using Linux Mint Xfce 20.3 with kernel version 5.16. I had to use
kernel 5.16 because with the standard kernel version of Linux mit 20.3
(which is 5.13) my laptop did not correctly resume, when I closed the
lid.

With kernel 5.16 my laptop perfectly went to to suspend when I closed
the lid and it perfectly resumed, when I opened the lid again. This
means: I had to press the power button once when I reopened the lid -
and then the laptop resumed (to the login screen). This was true until
kernel version 5.16.10. With kernel version > 5.16.10 my laptop does
not go into suspend anymore. This means: When I open the lid I am back
at the login screen immediately (I don't have to press the power button
anymore).

System information for my laptop:
=2D---------------------------------------------------------------------
System:    Kernel: 5.16.10-051610-generic x86_64 bits: 64 compiler: N/A
Desktop: Xfce 4.16.0
           tk: Gtk 3.24.20 wm: xfwm4 dm: LightDM Distro: Linux Mint
20.3 Una
           base: Ubuntu 20.04 focal
Machine:   Type: Laptop System: HP product: HP ProBook 455 G8 Notebook
PC v: N/A serial: <filter>
           Chassis: type: 10 serial: <filter>
           Mobo: HP model: 8864 v: KBC Version 41.1E.00 serial:
<filter> UEFI: HP
           v: T78 Ver. 01.07.00 date: 10/08/2021
Battery:   ID-1: BAT0 charge: 43.8 Wh condition: 44.5/45.0 Wh (99%)
volts: 13.0/11.4
           model: Hewlett-Packard Primary serial: <filter> status:
Unknown
CPU:       Topology: 8-Core model: AMD Ryzen 7 5800U with Radeon
Graphics bits: 64 type: MT MCP
           arch: Zen 3 L2 cache: 4096 KiB
           flags: avx avx2 lm nx pae sse sse2 sse3 sse4_1 sse4_2 sse4a
ssse3 svm bogomips: 60685
           Speed: 3497 MHz min/max: 1600/1900 MHz Core speeds (MHz): 1:
3474 2: 3464 3: 3473
           4: 3471 5: 4362 6: 4332 7: 3478 8: 3455 9: 3459 10: 3452 11:
3462 12: 3468 13: 3468
           14: 3468 15: 3467 16: 3472
Graphics:  Device-1: AMD vendor: Hewlett-Packard driver: amdgpu v:
kernel bus ID: 05:00.0
           chip ID: 1002:1638
           Display: x11 server: X.Org 1.20.13 driver: amdgpu,ati
unloaded: fbdev,modesetting,vesa
           resolution: 1920x1080~60Hz
           OpenGL: renderer: AMD RENOIR (DRM 3.44.0 5.16.10-051610-
generic LLVM 12.0.0)
           v: 4.6 Mesa 21.2.6 direct render: Yes
=2D---------------------------------------------------------------------


Best regards,

Reinhold Mannsberger

