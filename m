Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F925BFBC8
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 11:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiIUJzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 05:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiIUJzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 05:55:21 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E93F25C6;
        Wed, 21 Sep 2022 02:55:08 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oawRe-0004yz-68; Wed, 21 Sep 2022 11:55:06 +0200
Message-ID: <e3353084-264c-859a-3b42-a98e29f039cf@leemhuis.info>
Date:   Wed, 21 Sep 2022 11:55:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: Ext4: Buffered random writes performance regression with
 dioread_nolock enabled
Content-Language: en-US, de-DE
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
References: <CACX6voDfcTQzQJj=5Q-SLi0in1hXpo=Ri28rX73Og3GTObPBWA@mail.gmail.com>
 <48bb6266-2d5c-ffcd-6982-4fd02bfdcfc3@leemhuis.info>
 <Yyp59DELlYXpoCBC@mit.edu>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <Yyp59DELlYXpoCBC@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1663754108;7b6f0d50;
X-HE-SMSGID: 1oawRe-0004yz-68
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21.09.22 04:41, Theodore Ts'o wrote:
> Hazem started separate e-mail threads on this issue (separated by
> about an hour), and I replied to the earlier one here:
> 
>     https://lore.kernel.org/all/Yypx6VQRbl3bFP2v@mit.edu/

#regbot monitor: https://lore.kernel.org/all/Yypx6VQRbl3bFP2v@mit.edu/

> TL;DR:
> 
> 1)  The patch landed in 5.6, and improved performance for some
> workloads, and also fixed a potential security problem (exposure of
> stale data caused by a race).
> 
> 2)  If you are using a storage device >= 128GB, and a version of
> e2fsprogs v1.43.2 (released six years ago), the journal size will be
> 1GB, which Hazem reported resolved the problem.
> 
> 3) I disagree that we should revert this commit, as it only changes a
> default.  If you prefer the older behavior, you can change it with a
> mount option.

Great, thx for clarifying, in that case let me remove this from the
tracking:

#regzbot invalid: caused by a change of defaults that (among others) was
done for security reasons, see Ted's answer in
https://lore.kernel.org/all/Yypx6VQRbl3bFP2v@mit.edu/ for details

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
