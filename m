Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE6F60E064
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 14:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbiJZMKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 08:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiJZMKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 08:10:07 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291F3895CE;
        Wed, 26 Oct 2022 05:08:58 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1onfDN-0004cQ-4G; Wed, 26 Oct 2022 14:08:57 +0200
Message-ID: <f34cafd4-f224-ad10-6962-e8f6c709cb39@leemhuis.info>
Date:   Wed, 26 Oct 2022 14:08:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [Regression] Bug 216613 - Sound stopped working with v6.0.3 on
 Lenovo T14 Gen2i: ASoC: error at snd_soc_component_probe #forregzbot
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     alsa-devel@alsa-project.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <2c028797-b313-be93-7b1e-8d838e694948@leemhuis.info>
To:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
In-Reply-To: <2c028797-b313-be93-7b1e-8d838e694948@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1666786139;5108ec38;
X-HE-SMSGID: 1onfDN-0004cQ-4G
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Note: this mail is primarily send for documentation purposes and/or for
regzbot, my Linux kernel regression tracking bot. That's why I removed
most or all folks from the list of recipients, but left any that looked
like a mailing lists. These mails usually contain '#forregzbot' in the
subject, to make them easy to spot and filter out.]

On 22.10.22 08:35, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker speaking.
> 
> I noticed a regression report in bugzilla.kernel.org. As many (most?)
> kernel developer don't keep an eye on it, I decided to forward it by
> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216613 :
> 
>>  Grzegorz Alibożek 2022-10-21 19:26:43 UTC
>>
>> After upgrade kernel from 6.0.2 to 6.0.3 on Lenovo T14 Gen2i, sound stopped working.
>> dmesg:
>>
>> paź 21 21:11:45 kernel: snd_hda_codec_hdmi ehdaudio0D2: failed to create hda codec -12
>> paź 21 21:11:45 kernel: snd_hda_codec_hdmi ehdaudio0D2: ASoC: error at snd_soc_component_probe on ehdaudio0D2: -12
>> paź 21 21:11:45 kernel: skl_hda_dsp_generic skl_hda_dsp_generic: ASoC: failed to instantiate card -12
>>
>> [reply] [−] Comment 1 Grzegorz Alibożek 2022-10-21 19:56:43 UTC
>>
>> Created attachment 303070 [details]
>> trace

#regzbot introduced: 7494e2e6c55ed19
#regzbot fixed-by: 02356311982b
