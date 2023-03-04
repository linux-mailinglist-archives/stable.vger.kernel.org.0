Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB7F6AAA51
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 14:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCDN6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 08:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDN6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 08:58:33 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965FD13D70;
        Sat,  4 Mar 2023 05:58:31 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pYSP7-0001uK-Bl; Sat, 04 Mar 2023 14:58:29 +0100
Message-ID: <229e264a-9af6-7662-c04c-9c1492a18c51@leemhuis.info>
Date:   Sat, 4 Mar 2023 14:58:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [regression] Bug 217114 - Tiger Lake SATA Controller not
 operating correctly [bisected]
Content-Language: en-US, de-DE
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        emmi@emmixis.net, schwagsucks@gmail.com,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Simon Gaiser <simon@invisiblethingslab.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>
References: <ad02467d-d623-5933-67e0-09925c185568@leemhuis.info>
 <af6a355b-3ac2-a610-379a-167e87145368@opensource.wdc.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <af6a355b-3ac2-a610-379a-167e87145368@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1677938311;b61ab3a7;
X-HE-SMSGID: 1pYSP7-0001uK-Bl
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03.03.23 10:48, Damien Le Moal wrote:
> On 3/3/23 16:10, Linux regression tracking (Thorsten Leemhuis) wrote:
>>
>> I noticed a regression report in bugzilla.kernel.org that apparently
>> affects 6.2 and later as well as 6.1.13 and later, as it was already
>> backported there.
>>
>> As many (most?) kernel developer don't keep an eye on bugzilla, I
>> decided to forward the report by mail. Quoting from
>> https://bugzilla.kernel.org/show_bug.cgi?id=217114 :
>>
>>>  emmi@emmixis.net 2023-03-02 11:25:00 UTC
>>>
>>> As per kernel problem found in https://bbs.archlinux.org/viewtopic.php?id=283906 ,
>>>
>>> Commit 104ff59af73aba524e57ae0fef70121643ff270e
>>
>> [FWIW: That's "ata: ahci: Add Tiger Lake UP{3,4} AHCI controller" from
>> Simon Gaiser]
> 
> I sent a revert with cc: stable.

Many thx for this and your quick actions.

@Greg, @Sasha: that revert landed as 6210038aeaf4 ("ata: ahci: Revert
"ata: ahci: Add Tiger Lake UP{3,4} AHCI controller""); you might want to
ensure you have it in the first batch of 6.1 backports in case you need
to split the backports from the merge window over multiple 6.1.y releases.

Ciao, Thorsten
