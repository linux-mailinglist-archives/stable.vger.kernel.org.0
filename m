Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203F952B2A0
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 08:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiERGhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 02:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiERGhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 02:37:34 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF57192A4
        for <stable@vger.kernel.org>; Tue, 17 May 2022 23:37:32 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nrDJK-00085B-Rj; Wed, 18 May 2022 08:37:30 +0200
Message-ID: <2ce8f87e-785a-25b2-159a-cca45243b75b@leemhuis.info>
Date:   Wed, 18 May 2022 08:37:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     casteyde.christian@free.fr, stable@vger.kernel.org,
        regressions@lists.linux.dev,
        alexander deucher <alexander.deucher@amd.com>,
        gregkh@linuxfoundation.org,
        Mario Limonciello <mario.limonciello@amd.com>
References: <941867856.547807110.1652809066335.JavaMail.root@zimbra40-e7.priv.proxad.net>
 <4c8afdd6-3573-619d-d46c-e13a4fdd9ac7@leemhuis.info>
 <CAAd53p4ddFYE+O6Je8z9XDy54nTiODJsQEn7PncZ95K_PXPtPQ@mail.gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <CAAd53p4ddFYE+O6Je8z9XDy54nTiODJsQEn7PncZ95K_PXPtPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1652855852;34bc1a47;
X-HE-SMSGID: 1nrDJK-00085B-Rj
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.05.22 07:54, Kai-Heng Feng wrote:
> On Wed, May 18, 2022 at 1:52 PM Thorsten Leemhuis
> <regressions@leemhuis.info> wrote:
>>
>> On 17.05.22 19:37, casteyde.christian@free.fr wrote:
>>
>>> I've tryied to revert the offending commit on 5.18-rc7 (887f75cfd0da
>>> ("drm/amdgpu: Ensure HDA function is suspended before ASIC reset"), and
>>> the problem disappears so it's really this commit that breaks.
>>
>> In that case I'll update the regzbot status to make sure it's visible as
>> regression introduced in the 5.18 cycle:
>>
>> #regzbot introduced: 887f75cfd0da
>>
>> BTW: obviously would be nice to get this fixed before 5.18 is released
>> (which might already happen on Sunday), especially as the culprit
>> apparently was already backported to stable, but I guess that won't be
>> easy...
>>
>> Which made me wondering: is reverting the culprit temporarily in
>> mainline (and reapplying it later with a fix) a option here?
> 
> It's too soon to call it's the culprit.

Well, sure, the root-cause might be somewhere else. But from the point
of kernel regressions (and tracking them) it's the culprit, as that's
the change that triggers the misbehavior. And that's how Linus
approaches these things as well when it comes to reverting to fix
regressions -- and he even might...

> The suspend on the system
> doesn't work properly at the first place.

...ignore things like this, as long as a revert is unlikely to cause
more damage than good.

Ciao. Thorsten


>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>>
>> P.S.: As the Linux kernel's regression tracker I deal with a lot of
>> reports and sometimes miss something important when writing mails like
>> this. If that's the case here, don't hesitate to tell me in a public
>> reply, it's in everyone's interest to set the public record straight.
> 
