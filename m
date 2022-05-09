Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD9652045B
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 20:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240110AbiEISU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 14:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240096AbiEISUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 14:20:52 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF13E985B0
        for <stable@vger.kernel.org>; Mon,  9 May 2022 11:16:57 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id q4so5788840uas.0
        for <stable@vger.kernel.org>; Mon, 09 May 2022 11:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CEWD095MTOxfk6m8EXeU/SEynd8zoPXbmNPb5cx6VuQ=;
        b=yFRVfUfbRFn1oqm8PM9R8gvlByUtyrnryPwjZZr9Mmza9c+/JOUHoEbVxImTSQldPS
         Vmjyl0CYzISDW164eQCf3kjn91i/O0V89uJVSBB1lk7hv7VBCpX0x47NPVT3kE9URxoI
         TiZWnEj6Qd247uEAl2KpfA3TrQnhNB6Y9VP1o4c3zxomXFrf77FKS9kdcpzXQor5eVKd
         Vepju0L3AW9dA75mRUnV7lRajkMVhMCAY1shjObVGi/pbB/BpKjypoxUIHuMHb6mPLlJ
         UZyxkcEjaaRvrrwalTcsezt1toWlWjFUaIeE87oDish+BEw6UGIo7CWNZlJ3teVLYejB
         Cq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CEWD095MTOxfk6m8EXeU/SEynd8zoPXbmNPb5cx6VuQ=;
        b=xC9nTgKTQx00O1i6R1xmfSpo3bnZx9GseEIl8pUzVDuiQh229EKlYY6wmzHduvrO0O
         OnosZfRhA+57sVhpSP1hK3nrUx4AZBlZwOdxZgEt5QTSb7vR+9I/SvimZJhiPbO2CM+I
         I8vtg09Z+E7yg7JUABEA0OMmIN10vky4G89D3x4T2YgiKc/w3rda6tAH+xXFAIxEZi3j
         aKSc4hT/uc88QJx02krVmr8QLSBMwkRnivAsj6U+Ca9/EX3Zb7SPfQE/Ds66NM4snxgU
         sKSOPO0bYY3s7At7rg6AGWTeN2NH2bY9hB2RpGJZjO+Sa/LBuKYSaGh9AU5gX8XOhK7v
         F/tQ==
X-Gm-Message-State: AOAM5335jzt1NmWAQ46fFEDAwJSkIS9T/bmUK+mXdLAnEInznIzMXOhy
        +OvyqDFaITtXOBZ5J7WjETJV6V6mkrePQE7bm8H7
X-Google-Smtp-Source: ABdhPJwNvAMpqlS3sdklxAuAC6zwn8wlVqWIiEXGzvYdYIvDQRAl2UcE4uvhIBKD3Y/dAq6ICiiF8pgDhTQ+K3aQRvU=
X-Received: by 2002:a05:6130:3a1:b0:365:84fa:2f57 with SMTP id
 az33-20020a05613003a100b0036584fa2f57mr10300866uab.62.1652120216817; Mon, 09
 May 2022 11:16:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200527165718.129307-1-briannorris@chromium.org>
 <YmPadTu8CfEARfWs@xps> <CA+ASDXPeJ6fD9hvc0Nq_RY05YRdSP77U_96vUZcTYgkQKY9Bvg@mail.gmail.com>
In-Reply-To: <CA+ASDXPeJ6fD9hvc0Nq_RY05YRdSP77U_96vUZcTYgkQKY9Bvg@mail.gmail.com>
From:   Cale Collins <ccollins@gateworks.com>
Date:   Mon, 9 May 2022 11:16:19 -0700
Message-ID: <CAG2Q2vXce2V3Y6MnPhV6obcNWyQzyusMTL=5oCQLRNh2_ffNYA@mail.gmail.com>
Subject: Re: [PATCH] Revert "ath: add support for special 0x0 regulatory domain"
To:     Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
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
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Brian and Kalle,

I'm experiencing an issue very similar to this.  The regulatory domain
settings wouldn't allow me to create an AP on 5ghz bands on kernels
newer than 5.10 when using a WLE900VX (QCA9984) radio.  I bisected the
kernel and ultimately landed on the regression that Brian patched.  I
applied the patch and that resolved the issue from 5.4 up to 5.10.
For versions later than that I encountered the same problem.  I tried
to bisect again but PCI is broken for the ARM board(s) I'm using in
many of the RC's, I'm pretty new to all of this and it was just over
my head. I saw Kalle pushed Brian's patch a few weeks ago, so I
figured the politics behind how the regulatory domain should be
addressed was decided at that point.  I cherry picked Brian's patch
onto 5.17 to test, the results are below.  Can someone help me figure
out what I can do to get 5ghz APs back?

If there's any more information I can provide please let me know, I
wanted to keep things on the shorter side.

cale@cale:~/builds/upstream/linux$ git log --oneline
5c12efe9e783 (HEAD) Revert "ath: add support for special 0x0 regulatory domain"
f443e374ae13 (tag: v5.17) Linux 5.17

#On my ARM64 board

root@focal-ventana:~# uname -a
Linux focal-ventana 5.17.0-00001-g5c12efe9e783 #1 SMP Wed Apr 6
16:33:54 PDT 2022 armv7l armv7l armv7l GNU/Linux


root@focal-ventana:~# ls /sys/class/net/
can0  eth0  lo  sit0  wlp6s0

root@focal-ventana:~# iw phy phy0 info | grep " MHz \[" | grep -v "no
IR\|disabled"
            * 2412 MHz [1] (20.0 dBm)
            * 2417 MHz [2] (20.0 dBm)
            * 2422 MHz [3] (20.0 dBm)
            * 2427 MHz [4] (20.0 dBm)
            * 2432 MHz [5] (20.0 dBm)
            * 2437 MHz [6] (20.0 dBm)
            * 2442 MHz [7] (20.0 dBm)
            * 2447 MHz [8] (20.0 dBm)
            * 2452 MHz [9] (20.0 dBm)
            * 2457 MHz [10] (20.0 dBm)
            * 2462 MHz [11] (20.0 dBm)


root@focal-ventana:~# iw reg get
global
country 00: DFS-UNSET
    (2402 - 2472 @ 40), (N/A, 20), (N/A)
    (2457 - 2482 @ 20), (N/A, 20), (N/A), AUTO-BW, NO-IR
    (2474 - 2494 @ 20), (N/A, 20), (N/A), NO-OFDM, NO-IR
    (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW, NO-IR
    (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW, NO-IR
    (5490 - 5730 @ 160), (N/A, 20), (0 ms), DFS, NO-IR
    (5735 - 5835 @ 80), (N/A, 20), (N/A), NO-IR
    (57240 - 63720 @ 2160), (N/A, 0), (N/A)

phy#0
country 99: DFS-UNSET
    (2402 - 2472 @ 40), (N/A, 20), (N/A)
    (5140 - 5360 @ 80), (N/A, 30), (N/A), PASSIVE-SCAN
    (5715 - 5860 @ 80), (N/A, 30), (N/A), PASSIVE-SCAN

#dmesg |grep ath output

    [    5.724215] ath10k_pci 0000:06:00.0: enabling device (0140 -> 0142)
    [    5.732439] ath10k_pci 0000:06:00.0: pci irq msi oper_irq_mode
2 irq_mode 0 reset_mode 0
    [   17.573591] ath10k_pci 0000:06:00.0: qca988x hw2.0 target
0x4100016c chip_id 0x043202ff sub 0000:0000
    [   17.573707] ath10k_pci 0000:06:00.0: kconfig debug 0 debugfs 0
tracing 0 dfs 0 testmode 0
    [   17.575118] ath10k_pci 0000:06:00.0: firmware ver
10.2.4-1.0-00047 api 5 features no-p2p,raw-mode,mfp,allows-mesh-bcast
crc32 35bd9258
    [   17.637397] ath10k_pci 0000:06:00.0: board_file api 1 bmi_id
N/A crc32 bebc7c08
    [   18.849651] ath10k_pci 0000:06:00.0: htt-ver 2.1 wmi-op 5
htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1

Best regards,

Cale Collins


Cale Collins
Field Applications Engineer II
Gateworks Corporation
(805)781-2000 x37
3026 S. Higuera, San Luis Obispo, CA 93401
www.gateworks.com



On Mon, Apr 25, 2022 at 11:55 AM Brian Norris <briannorris@chromium.org> wrote:
>
> Hi Patrick,
>
> On Sat, Apr 23, 2022 at 3:52 AM Patrick Steinhardt <ps@pks.im> wrote:
> > This revert is in fact causing problems on my machine. I have a QCA9984,
> > which exports two network interfaces. While I was able to still use one
> > of both NICs for 2.4GHz, I couldn't really use the other card to set up
> > a 5GHz AP anymore because all frequencies were restricted. This has
> > started with v5.17.1, to which this revert was backported.
> >
> > Reverting this patch again fixes the issue on my system. So it seems
> > like there still are cards out there in the wild which have a value of
> > 0x0 as their regulatory domain.
> >
> > Quoting from your other mail:
> >
> > > My understanding was that no QCA modules *should* be shipped with a
> > > value of 0 in this field. The instance I'm aware of was more or less a
> > > manufacturing error I think, and we got Qualcomm to patch it over in
> > > software.
> >
> > This sounds like the issue should've already been fixed in firmware,
> > right?
>
> See the original patch:
> https://git.kernel.org/linus/2dc016599cfa9672a147528ca26d70c3654a5423
>
> "Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00029."
>
> That patch was only tested for QCA6174 SDIO, and the 6174 firmware has
> since been updated. So none of that really applies to QCA9984. I
> suppose your device was also not working before v5.6 either, and IIUC,
> according to Qualcomm your hardware is a manufacturing error (i.e.,
> invalid country code).
>
> I don't know what to tell you exactly, other than that the original
> patch was wrong/unnecessary (and broke various existing systems) so it
> should be reverted. I'm not quite sure how to fix the variety of
> hardware out there (like yours) that may be using non-conforming
> EEPROM settings. It would seem to me that we might need some more
> targeted way of addressing broken hardware, rather than changing this
> particular default workaround. I'm honestly not that familiar with
> this Qualcomm regulatory stuff though, so my main contribution was
> just to suggest reverting (i.e., don't break what used to work); I'm
> not as savvy on providing alternative "fixes" for you.
>
> (That said: I *think* what's happening is that in the absence of a
> proper EEPROM code, ath drivers fall back to a default=US country
> code, and without further information to know you're compliant,
> regulatory rules disallow initiating radiation (such as, an AP) on
> 5GHz.)
>
> >  I've added the relevant dmesg
> > snippets though in case I'm mistaken:
>
> With what kernel? That looks like pre-v5.17.1. The "broken"
> (post-5.17.1) logs might be a bit more informative.
>
> Sorry,
> Brian
