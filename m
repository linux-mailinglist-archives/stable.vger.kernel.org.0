Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340735FFF3E
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 14:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiJPMnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 08:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJPMnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 08:43:16 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD101E3D9;
        Sun, 16 Oct 2022 05:43:15 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ok2z0-0003bd-TA; Sun, 16 Oct 2022 14:43:10 +0200
Message-ID: <6e744247-60b8-febb-9cc6-5c24ff6e3019@leemhuis.info>
Date:   Sun, 16 Oct 2022 14:43:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: BISECT result: 6.0.0-RC kernels trigger Firefox snap bug with
 6.0.0-rc3 through 6.0.0-rc7
Content-Language: en-US, de-DE
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        mirsad.todorovac@alu.unizg.hr
Cc:     linux-kernel@vger.kernel.org, marcmiltenberger@gmail.com,
        regressions@lists.linux.dev, srw@sladewatkins.net,
        stable@vger.kernel.org
References: <8702a833-e66c-e63a-bfc8-1007174c5b3d@leemhuis.info>
 <20221015205936.5735-1-phillip@squashfs.org.uk>
 <2d1ca80c-1023-9821-f401-43cff34cca86@gmail.com>
 <b811fb3a-b5bb-bb0d-0cdf-e5bc0e88836f@gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <b811fb3a-b5bb-bb0d-0cdf-e5bc0e88836f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1665924195;e932962c;
X-HE-SMSGID: 1ok2z0-0003bd-TA
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.10.22 14:24, Bagas Sanjaya wrote:
> On 10/16/22 19:21, Bagas Sanjaya wrote:
>> On 10/16/22 03:59, Phillip Lougher wrote:
>>>
>>> Which identified the "squashfs: support reading fragments in readahead call"
>>> patch.

BTW, Phillip, sorry for specifying the wrong culprit in an earlier mail.

> Also, since this regression is also found on linux-6.0.y stable branch,
> don't forget to Cc stable list.

FWIW, that's afaics not needed (and actually slightly confusing I'd
say). That is only important when the problem was introduced in a stable
release to make the stable team aware of it, as then they might be
willing to revert the culprit if the problem is not present in mainline.

But this problem was introduced in the 6.0 mainline cycle and thus needs
to be fixed there first.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.

P.P.S.:

#regzbot introduced: b09a7a036d2035b14636c
