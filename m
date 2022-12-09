Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540D3647DCB
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 07:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiLIGbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 01:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiLIGbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 01:31:07 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A4EA8498;
        Thu,  8 Dec 2022 22:31:05 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1p3WuV-0007g4-VQ; Fri, 09 Dec 2022 07:31:04 +0100
Message-ID: <cf8401c8-d9cb-c0be-890b-6aa14d06c1d2@leemhuis.info>
Date:   Fri, 9 Dec 2022 07:31:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] ext4: Fix deadlock due to mbcache entry corruption
Content-Language: en-US, de-DE
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Thilo Fromm <t-lo@linux.microsoft.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
References: <20221123193950.16758-1-jack@suse.cz>
 <20221201151021.GA18380@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <9c414060-989d-55bb-9a7b-0f33bf103c4f@leemhuis.info>
 <Y5F8ayz4gEtKn0LF@mit.edu> <20221208091523.t6ka6tqtclcxnsrp@quack3>
 <Y5IFR4K9hO8ax1Y0@mit.edu>
 <e2a77778-7a2b-2811-95ff-be67a44afceb@leemhuis.info>
 <Y5LR2ffwz39donWu@mit.edu>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <Y5LR2ffwz39donWu@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1670567465;01e3d1a2;
X-HE-SMSGID: 1p3WuV-0007g4-VQ
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.12.22 07:12, Theodore Ts'o wrote:
> On Thu, Dec 08, 2022 at 06:16:02PM +0100, Thorsten Leemhuis wrote:
>>
>> Maybe I should talk to Greg again to revert backported changes like
>> 1be97463696c until fixes for them are ready.
> 
> The fix is in the ext4 git tree, and it's ready to be pushed to Linus
> when the merge window opens --- presumably, on Sunday.

Thx!

> So it's probably not worth it to revert the backported change, only to
> reapply immediately afterwards.

Definitely agreed, I was more taking in the general sense (sorry, should
have been clearer), as it's not the first time some backport exposes
existing problems that take a while to get analyzed and fixed in
mainline. Which is just how it is sometimes, hence a revert and a
reapply of that backport (once the fix is available) in stable/longterm
sounds appropriate to me to prevent users from running into known problems.

Ciao, Thorsten
