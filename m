Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7706AAB12
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 17:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjCDQRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 11:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCDQRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 11:17:45 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3531BAEC
        for <stable@vger.kernel.org>; Sat,  4 Mar 2023 08:17:27 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pYUZZ-0002Hn-Am; Sat, 04 Mar 2023 17:17:25 +0100
Message-ID: <1562be6d-7c91-b453-dc24-5d4eabcf33ba@leemhuis.info>
Date:   Sat, 4 Mar 2023 17:17:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Too many BDL entries regression
Content-Language: en-US, de-DE
To:     Laurent Lyaudet <laurent.lyaudet@gmail.com>, stable@vger.kernel.org
Cc:     regressions@lists.linux.dev
References: <CAB1LBmv1kY+kuUBWvXRoe+mbQBjtJOFvZB8Smmbcuy2MdvgJnA@mail.gmail.com>
 <CAB1LBmsBGFDLoKZHUZCLHDvHb68eOfc-W+W9hQXbXkqRB7Uykw@mail.gmail.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <CAB1LBmsBGFDLoKZHUZCLHDvHb68eOfc-W+W9hQXbXkqRB7Uykw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1677946647;6297a9bc;
X-HE-SMSGID: 1pYUZZ-0002Hn-Am
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.03.23 16:53, Laurent Lyaudet wrote:
> 
> I filled a bug report to Ubuntu also :
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2009271

That's the right thing to do, as it's definitely something the Ubuntu
folks caused if its recent.

To quote https://docs.kernel.org/admin-guide/reporting-issues.html

"Are you facing an issue with a Linux kernel a hardware or software
vendor provided? Then in almost all cases you are better off to stop
reading this document and reporting the issue to your vendor instead […]"

In an ideal world it would not be like that, but we don't live in one.

The reference section of above document explains this aspect in more
detail, albeit it doesn't really explain one aspect that is quite
relevant in this case here: the kernel.org community doesn't maintain
5.19.y anymore, it was deemed "end of life" months ago. But if you can
reproduce the issue with the latest mainline release, feel free to raise
as outlined in above document.

HTH, Ciao, Thorsten

> Le sam. 4 mars 2023 à 16:41, Laurent Lyaudet
> <laurent.lyaudet@gmail.com> a écrit :
>>
>> Hello,
>>
>> Thanks for your hard work :)
>> Ubuntu 22.10 shipped kernel 5.19.0-35 thursday.
>> And some people started having syslogs :
>> "Too many BDL entries"
>> https://askubuntu.com/questions/1457367/snd-hda-intel-0000001f-3-too-many-bdl-entries-messages-in-system-log
>>
>> I looked here how to report it :
>> https://docs.kernel.org/admin-guide/reporting-issues.html
>> and searched for "Too many BDL entries" but found nothing
>>
>> I looked at versions here :
>> https://kernel.org/
>> but I don't know if version 5.19 should be reported at
>> stable@vger.kernel.org
>> since it is in between
>> 5.15.98
>> and 6.1.15
>> or maybe Ubuntu does some renumbering ?
>>
>> Excuse me if my report does not contain all needed data,
>> or should be addressed elsewhere.
>> Sorry if I cannot do all the checks with latest kernel ;
>> my current laptop is my only PC for work,
>> and I would prefer to avoid breaking it, even for a day or two.
>>
>> Nevertheless, I would be happy to provide log extracts or other
>> information that may help.
>>
>> Have a nice week-end, best regards,
>>     Laurent Lyaudet
> 
> 
