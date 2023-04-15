Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3C26E2FA0
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 10:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjDOIGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 04:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDOIGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 04:06:48 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD41065A8;
        Sat, 15 Apr 2023 01:06:46 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pnavj-0004mq-U6; Sat, 15 Apr 2023 10:06:44 +0200
Message-ID: <c19e41e5-ec8c-e6e0-2148-fec36698b947@leemhuis.info>
Date:   Sat, 15 Apr 2023 10:06:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [REGRESSION] Asus X541UAK hangs on suspend and poweroff (v6.1.6
 onward)
Content-Language: en-US, de-DE
To:     Acid Bong <acidbong@tilde.cafe>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     stable@vger.kernel.org, linux-acpi@vger.kernel.org
References: <CRVU11I7JJWF.367PSO4YAQQEI@bong>
 <5f445dab-a152-bcaa-4462-1665998c3e2e@gmail.com>
 <b2edf1ed-2777-03ef-4d5e-e355a6074f78@leemhuis.info>
 <CRWCUOAB4JKZ.3EKQN1TFFMVQL@bong>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <CRWCUOAB4JKZ.3EKQN1TFFMVQL@bong>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681546006;80858dcb;
X-HE-SMSGID: 1pnavj-0004mq-U6
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 14.04.23 11:07, Acid Bong wrote:
>> Thorsten
>> why do you pass pci=nomsi
> It's a workaround for another issue i've been facing for about 2 or 3
> years, since when I first tried out Linux (started with loading Kubuntu
> and Mint live images). Without that workaround Kubuntu didn't boot for
> me - on kernel 5.8 it only reached the graphic installer part, but hung
> after language selection menu, on 5.4 and 5.11 - didn't even reach the
> graphic session. With Mint it was more severe - the screen was flooded
> with PCIe errors, like so:
> 
> 	Apr 10 18:47:08 bong last message buffered 3 times
> 	Apr 10 18:47:08 bong kernel: pcieport 0000:00:1c.5:   device [8086:9d15] error status/mask000001/00002000
> 	Apr 10 18:47:08 bong kernel: pcieport 0000:00:1c.5: PCIe Bus Error: severity=Corrected, type=Physical Layer, (Receiver ID)
> 	Apr 10 18:47:08 bong last message buffered 5 times
> 	Apr 10 18:47:08 bong kernel: pcieport 0000:00:1c.5:   device [8086:9d15] error status/mask000001/00002000
> 	Apr 10 18:47:08 bong kernel: pcieport 0000:00:1c.5: PCIe Bus Error: severity=Corrected, type=Physical Layer, (Receiver ID)
> 	Apr 10 18:47:08 bong last message buffered 13 times
> 	Apr 10 18:47:08 bong kernel: pcieport 0000:00:1c.5:   device [8086:9d15] error status/mask000001/00002000
> 	Apr 10 18:47:08 bong kernel: pcieport 0000:00:1c.5: PCIe Bus Error: severity=Corrected, type=Physical Layer, (Receiver ID)
> 	Apr 10 18:47:08 bong last message buffered 5 times
> 	Apr 10 18:47:08 bong kernel: pcieport 0000:00:1c.5:   device [8086:9d15] error status/mask000001/00002000
> 	Apr 10 18:47:08 bong kernel: pcieport 0000:00:1c.5: PCIe Bus Error: severity=Corrected, type=Physical Layer, (Receiver ID)
> 	Apr 10 18:47:08 bong last message buffered 6 times
> 
> `pci=nomsi` saved me also during Debian installation - without it the
> live ISO just crashed mid-installation.
> 
> But it wasn't a complete cure for Debian- and Ubuntu-based distros, and
> they still crashed even with this parameter (I don't know how exactly,
> at least they didn't flood with PCIe bus errors).
> 
> Since I moved to Manjaro, Void, Arch and now to Gentoo (which bases its
> config on the Fedora one), PCIe errors were my only trouble, which was
> easily mitigated with `pci=nomsi`. Recently I discovered that without it
> one of the kernel modules (irq/124-aerdrv) had high CPU load, so double
> useful.
> 
> https://forums.linuxmint.com/viewtopic.php?p=2237628
> Just googled and there's a guy with a very similar model as me (UVK
> instead of UAK) and same issues, but `noaer` and `nomsi` work identically
> for me (I found `nomsi` in a different thread).
> 
> Since I'm building my own kernel for the last 3 months, I've disabled
> the MSI in kernel config - and with that, a big part of IOMMU part as well:
> https://git.sr.ht/~acid-bong/kernel/commit/cac5c09dec0bea919ca071a9b738108b0d8a8ee5
> but I did it _after_ I first experienced the issue I described in the
> thread head, hoping that it'll save me from these hangs as well. It
> didn't.
> 
> I'm keeping it in the bootloader config for cases when I boot with a
> prebuilt Gentoo kernel, and add every time I'm booting with Arch or Void
> live USB for rescue purposes. It's not a constant issue tho, happens every
> other time.
> 
> ---
>> Bagas
>> Have you tried testing latest mainline?
> Just built and will boot in a moment. But we'll gotta wait for a couple
> of days, since the hanging is unexpected.

This is not my area of expertise, but the pre-existing hardware config
trouble the kernel apparently has makes this a problematic case, as what
causes those problems might directly or indirectly cause the regression
you see by chance -- and might be something that only happens on your
machine.

Maybe we are lucky and some developer of the affected kernel code areas
will see your report and have an idea what might cause the regressions.
But I'd say chances are slim. So unless we are lucky, we'll likely won't
can any closer to a solution without a bisection.

But I wouldn't take that path; instead I in your place would report and
sort out the hardware config trouble, as the problem might vanish by
solving that.

But as I said, this is not my area of expertise, so maybe it's a bad advice.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
