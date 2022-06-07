Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA9653FA63
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239661AbiFGJxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240237AbiFGJw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:52:59 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC6563B1
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 02:52:25 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nyVst-0006cU-Nr; Tue, 07 Jun 2022 11:52:23 +0200
Message-ID: <a9a68c68-8830-2aa0-acbe-d5d3bb04968f@leemhuis.info>
Date:   Tue, 7 Jun 2022 11:52:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: boot loop since 5.17.6
Content-Language: en-US
To:     Thomas Sattler <sattler@med.uni-frankfurt.de>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
 <c3b370a8-193e-329b-c73a-1371bd62edf3@med.uni-frankfurt.de>
 <181a6369-e373-b020-2059-33fb5161d8d3@med.uni-frankfurt.de>
 <YpksflOG2Y1Xng89@dev-arch.thelio-3990X>
 <1f8a4bec-53bd-aaaa-49a7-b5ed4fc5ae34@med.uni-frankfurt.de>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <1f8a4bec-53bd-aaaa-49a7-b5ed4fc5ae34@med.uni-frankfurt.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1654595545;dbc47cd4;
X-HE-SMSGID: 1nyVst-0006cU-Nr
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker. Sorry, I'm behind mail.

On 03.06.22 00:44, Thomas Sattler wrote:
> Am 02.06.22 um 23:32 schrieb Nathan Chancellor:
>>> Am 02.06.22 um 18:42 schrieb Thomas Sattler:
>>>>
>>>> I tried to compile 5.17.6 without the three mentioned diffs which
>>>> modify the following files:
>>>>
>>>>      tools/objtool/check.c   and
>>>>      tools/objtool/elf.c      and
>>>>      tools/objtool/include/objtool/elf.h
>>>>
>>>> and was then able to successfully boot 5.17.6.
>>
>> 5.17.6 has commit 60d2b0b1018a ("objtool: Fix code relocs vs weak
>> symbols"),

FWIW, that is 4abff6d48dbc in mainline

>> which has a known issue that is fixed with commit
>> ead165fa1042 ("objtool: Fix symbol creation"). If you apply ead165fa1042
>> on 5.17.6 or newer, does that resolve your issue?
> 
> I applied ead165fa1042 ontop of 5.17.12, but that did not make
> my system boot that kernel.

Was there any progress to get down to this? Peter, who authored
4abff6d48dbc, is not even CCed yet to this thread yet afaics.

BTW, 5.17 will likely be EOL in a week or two. Thomas, maybe it might be
the best to give 5.19-rc1 a shot and in case the regression is still
there start a new thread about this that focuses on the regression in
mainline. That makes things less confusing and the regression needs to
be fixed in mainline first anyway before it can be fixed in the stable
trees.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
