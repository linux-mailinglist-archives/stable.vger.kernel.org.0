Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A3A65BCCD
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 10:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237046AbjACJIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 04:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbjACJH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 04:07:59 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEDDE038
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 01:07:44 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pCdGo-0004iD-ON; Tue, 03 Jan 2023 10:07:42 +0100
Message-ID: <bf646395-1231-92f6-7c5a-5b7765596358@leemhuis.info>
Date:   Tue, 3 Jan 2023 10:07:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: USB-Audio regression on behringer UMC404HD
Content-Language: en-US, de-DE
To:     Michael Ralston <michael@ralston.id.au>,
        alsa-devel@alsa-project.org, regressions@lists.linux.dev,
        stable@vger.kernel.org
References: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
In-Reply-To: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1672736864;f8052871;
X-HE-SMSGID: 1pCdGo-0004iD-ON
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; all text you find below is based on a few templates
paragraphs you might have encountered already already in similar form.
See link in footer if these mails annoy you.]

[CCing alsa maintainers]

On 02.01.23 18:29, Michael Ralston wrote:
> I'm currently experiencing a regression with the audio on my Behringer
> U-Phoria UMC404HD.
> 
> Alsa info is at:
> http://alsa-project.org/db/?f=f453b8cd0248fb5fdfa38e1b770e774102f66135
> 
> I get no audio in or out for this device with kernel versions 6.1.1 and 6.1.2.
> 
> The versions I have tried that work correctly include 5.15.86 LTS,
> 5.19.12, and 6.0.13–16.
> 
> When I run this on 6.1.1, it will just hang until I ctrl+c:
> aplay -D plughw:1,0 /usr/share/sounds/alsa/Front_Center.wav
> 
> I've run strace on that command, and its output is at:
> https://pastebin.com/WaxJpTMe
> 
> Nothing out of the ordinary occurs when aplay is run, according to the
> kernel logs.
> 
> Please let me know how I can provide additional debugging information
> if necessary.

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced v6.0..v6.1
#regzbot title alsa: usb: audio stopped working
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Reminder for developers: When fixing the issue, add 'Link:' tags
pointing to the report (see page linked in footer for details).

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
