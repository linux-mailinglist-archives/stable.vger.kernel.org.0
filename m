Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6352552406A
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 00:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348896AbiEKWw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 18:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348894AbiEKWw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 18:52:57 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E02E633A8
        for <stable@vger.kernel.org>; Wed, 11 May 2022 15:52:55 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id o132so1843716vko.11
        for <stable@vger.kernel.org>; Wed, 11 May 2022 15:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=29E8HlhduSQieWez20AluJPdVntOzq6QdIcJrP9MAKk=;
        b=eXGPAqhI9a4OPJLyWf2JCXYWPoGF2Iqgn/jpjizCOMqrKYoxsu1tb7zHp3VJp3IFTo
         9yAYtEqlcPCbW21popx8Zr45u8pa+c9YhpeTgmeLUZo0K6sfDkZg+TRKDhcITVSjd6ET
         zKDrLLI2q4L+21rdFSp174xKy8LWXr9bNw/3XZGcMo3ke+9mdeNHfzLeZlAavO+zzdnx
         VRDsPxze0AR4UuOxdZwyW6VCwrI9v1kHbE1dKzaXVQ9tYQPORPjLUuTtxOYnxkD/zr8i
         0uUdnLTlZWQKD/qJyTxesp836Zw49IcLVD9QHDeByverzbHjaJDoWoSV5qW0RhxqtPoq
         LVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=29E8HlhduSQieWez20AluJPdVntOzq6QdIcJrP9MAKk=;
        b=75vT7OxD7WcTUdUUOuhcSQEzsZibNDBs/3V+WzggDoJs7NQEPcx9Og7/PKQGzbCF+0
         J7/Ik0FWX//4PL28APCy2DJptVX34GiKwf0bDMhh7Uw47z3QV2crDr0BG7jVb+bDBkln
         9zRpkq0Ztawq1dC3zrZbKtEy0dAmp2uZlNqwcCAA0fbcX9iHbFNEv6udO3eEYGzKu3J4
         oQHbfh6pfZVaZFFgAKdWHFok+1xsQCBEj7FOg4opuvaUk2H7n8nHN+cnS540w4yhKNka
         G+bT0FkExw03po8ha4Qks7LnkRJxyCTIuD8WcSoD0WxaSt7KDs71pzEujXsJGoAhBrUp
         WqbQ==
X-Gm-Message-State: AOAM532rscYKeFkHP2lKdW4lEgOr8oyOCYeYLkyHophlNjjmKf9IHbGY
        FMHFMQjf7FaBFJlx7LT0t/voOYL8V70FyC2JA9rA
X-Google-Smtp-Source: ABdhPJzmuGqT2ng35Dpv3DBtE0pM/yQmY6DTNKnBIPS+Zw6hZvfILYF5ZN6FVAZD2LvgVRo04xAXzJ4beqwpGm+ZkrI=
X-Received: by 2002:a1f:91cb:0:b0:34e:10c8:cf1c with SMTP id
 t194-20020a1f91cb000000b0034e10c8cf1cmr15641958vkd.31.1652309574277; Wed, 11
 May 2022 15:52:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200527165718.129307-1-briannorris@chromium.org>
 <YmPadTu8CfEARfWs@xps> <CA+ASDXPeJ6fD9hvc0Nq_RY05YRdSP77U_96vUZcTYgkQKY9Bvg@mail.gmail.com>
 <CAG2Q2vXce2V3Y6MnPhV6obcNWyQzyusMTL=5oCQLRNh2_ffNYA@mail.gmail.com>
In-Reply-To: <CAG2Q2vXce2V3Y6MnPhV6obcNWyQzyusMTL=5oCQLRNh2_ffNYA@mail.gmail.com>
From:   Cale Collins <ccollins@gateworks.com>
Date:   Wed, 11 May 2022 15:52:18 -0700
Message-ID: <CAG2Q2vXFcSVwF4CbU5o3VP1MWwrdqrZjTHgfBj_Q0t3nNipJRw@mail.gmail.com>
Subject: Re: [PATCH] Revert "ath: add support for special 0x0 regulatory domain"
To:     kvalo@kernel.org, Brian Norris <briannorris@chromium.org>
Cc:     Patrick Steinhardt <ps@pks.im>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        Stephen McCarthy <stephen.mccarthy@pctel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Adding Kalle, I got his address wrong the first time.


On Mon, May 9, 2022 at 11:16 AM Cale Collins <ccollins@gateworks.com> wrote:
>
> Hello Brian and Kalle,
>
> I'm experiencing an issue very similar to this.  The regulatory domain
> settings wouldn't allow me to create an AP on 5ghz bands on kernels
> newer than 5.10 when using a WLE900VX (QCA9984) radio.  I bisected the
> kernel and ultimately landed on the regression that Brian patched.  I
> applied the patch and that resolved the issue from 5.4 up to 5.10.
> For versions later than that I encountered the same problem.  I tried
> to bisect again but PCI is broken for the ARM board(s) I'm using in
> many of the RC's, I'm pretty new to all of this and it was just over
> my head. I saw Kalle pushed Brian's patch a few weeks ago, so I
> figured the politics behind how the regulatory domain should be
> addressed was decided at that point.  I cherry picked Brian's patch
> onto 5.17 to test, the results are below.  Can someone help me figure
> out what I can do to get 5ghz APs back?
>
> If there's any more information I can provide please let me know, I
> wanted to keep things on the shorter side.
>
> cale@cale:~/builds/upstream/linux$ git log --oneline
> 5c12efe9e783 (HEAD) Revert "ath: add support for special 0x0 regulatory domain"
> f443e374ae13 (tag: v5.17) Linux 5.17
>
> #On my ARM64 board
>
> root@focal-ventana:~# uname -a
> Linux focal-ventana 5.17.0-00001-g5c12efe9e783 #1 SMP Wed Apr 6
> 16:33:54 PDT 2022 armv7l armv7l armv7l GNU/Linux
>
>
> root@focal-ventana:~# ls /sys/class/net/
> can0  eth0  lo  sit0  wlp6s0
>
> root@focal-ventana:~# iw phy phy0 info | grep " MHz \[" | grep -v "no
> IR\|disabled"
>             * 2412 MHz [1] (20.0 dBm)
>             * 2417 MHz [2] (20.0 dBm)
>             * 2422 MHz [3] (20.0 dBm)
>             * 2427 MHz [4] (20.0 dBm)
>             * 2432 MHz [5] (20.0 dBm)
>             * 2437 MHz [6] (20.0 dBm)
>             * 2442 MHz [7] (20.0 dBm)
>             * 2447 MHz [8] (20.0 dBm)
>             * 2452 MHz [9] (20.0 dBm)
>             * 2457 MHz [10] (20.0 dBm)
>             * 2462 MHz [11] (20.0 dBm)
>
>
> root@focal-ventana:~# iw reg get
> global
> country 00: DFS-UNSET
>     (2402 - 2472 @ 40), (N/A, 20), (N/A)
>     (2457 - 2482 @ 20), (N/A, 20), (N/A), AUTO-BW, NO-IR
>     (2474 - 2494 @ 20), (N/A, 20), (N/A), NO-OFDM, NO-IR
>     (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW, NO-IR
>     (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW, NO-IR
>     (5490 - 5730 @ 160), (N/A, 20), (0 ms), DFS, NO-IR
>     (5735 - 5835 @ 80), (N/A, 20), (N/A), NO-IR
>     (57240 - 63720 @ 2160), (N/A, 0), (N/A)
>
> phy#0
> country 99: DFS-UNSET
>     (2402 - 2472 @ 40), (N/A, 20), (N/A)
>     (5140 - 5360 @ 80), (N/A, 30), (N/A), PASSIVE-SCAN
>     (5715 - 5860 @ 80), (N/A, 30), (N/A), PASSIVE-SCAN
>
> #dmesg |grep ath output
>
>     [    5.724215] ath10k_pci 0000:06:00.0: enabling device (0140 -> 0142)
>     [    5.732439] ath10k_pci 0000:06:00.0: pci irq msi oper_irq_mode
> 2 irq_mode 0 reset_mode 0
>     [   17.573591] ath10k_pci 0000:06:00.0: qca988x hw2.0 target
> 0x4100016c chip_id 0x043202ff sub 0000:0000
>     [   17.573707] ath10k_pci 0000:06:00.0: kconfig debug 0 debugfs 0
> tracing 0 dfs 0 testmode 0
>     [   17.575118] ath10k_pci 0000:06:00.0: firmware ver
> 10.2.4-1.0-00047 api 5 features no-p2p,raw-mode,mfp,allows-mesh-bcast
> crc32 35bd9258
>     [   17.637397] ath10k_pci 0000:06:00.0: board_file api 1 bmi_id
> N/A crc32 bebc7c08
>     [   18.849651] ath10k_pci 0000:06:00.0: htt-ver 2.1 wmi-op 5
> htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1
>
> Best regards,
>
> Cale Collins
>
>
> Cale Collins
> Field Applications Engineer II
> Gateworks Corporation
> (805)781-2000 x37
> 3026 S. Higuera, San Luis Obispo, CA 93401
> www.gateworks.com
>
>
>
> On Mon, Apr 25, 2022 at 11:55 AM Brian Norris <briannorris@chromium.org> wrote:
> >
> > Hi Patrick,
> >
> > On Sat, Apr 23, 2022 at 3:52 AM Patrick Steinhardt <ps@pks.im> wrote:
> > > This revert is in fact causing problems on my machine. I have a QCA9984,
> > > which exports two network interfaces. While I was able to still use one
> > > of both NICs for 2.4GHz, I couldn't really use the other card to set up
> > > a 5GHz AP anymore because all frequencies were restricted. This has
> > > started with v5.17.1, to which this revert was backported.
> > >
> > > Reverting this patch again fixes the issue on my system. So it seems
> > > like there still are cards out there in the wild which have a value of
> > > 0x0 as their regulatory domain.
> > >
> > > Quoting from your other mail:
> > >
> > > > My understanding was that no QCA modules *should* be shipped with a
> > > > value of 0 in this field. The instance I'm aware of was more or less a
> > > > manufacturing error I think, and we got Qualcomm to patch it over in
> > > > software.
> > >
> > > This sounds like the issue should've already been fixed in firmware,
> > > right?
> >
> > See the original patch:
> > https://git.kernel.org/linus/2dc016599cfa9672a147528ca26d70c3654a5423
> >
> > "Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00029."
> >
> > That patch was only tested for QCA6174 SDIO, and the 6174 firmware has
> > since been updated. So none of that really applies to QCA9984. I
> > suppose your device was also not working before v5.6 either, and IIUC,
> > according to Qualcomm your hardware is a manufacturing error (i.e.,
> > invalid country code).
> >
> > I don't know what to tell you exactly, other than that the original
> > patch was wrong/unnecessary (and broke various existing systems) so it
> > should be reverted. I'm not quite sure how to fix the variety of
> > hardware out there (like yours) that may be using non-conforming
> > EEPROM settings. It would seem to me that we might need some more
> > targeted way of addressing broken hardware, rather than changing this
> > particular default workaround. I'm honestly not that familiar with
> > this Qualcomm regulatory stuff though, so my main contribution was
> > just to suggest reverting (i.e., don't break what used to work); I'm
> > not as savvy on providing alternative "fixes" for you.
> >
> > (That said: I *think* what's happening is that in the absence of a
> > proper EEPROM code, ath drivers fall back to a default=US country
> > code, and without further information to know you're compliant,
> > regulatory rules disallow initiating radiation (such as, an AP) on
> > 5GHz.)
> >
> > >  I've added the relevant dmesg
> > > snippets though in case I'm mistaken:
> >
> > With what kernel? That looks like pre-v5.17.1. The "broken"
> > (post-5.17.1) logs might be a bit more informative.
> >
> > Sorry,
> > Brian
