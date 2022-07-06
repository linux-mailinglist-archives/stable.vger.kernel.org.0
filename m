Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB66568221
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 10:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiGFIva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 04:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiGFIv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 04:51:29 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231A32408B
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 01:51:27 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v12so5738326edc.10
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 01:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sc0xgxFqbxbNm5gREhne6QGBAqVzmczh60MJ4fT99Tg=;
        b=R9UK7ZLEFS3oEZRYT2Y7wYPt//Vsg58f3Q+h10Ek067wcfYR/VM3Wqslm0LE7KpxHB
         IVWnteSr4UnsBLsljf3HlTRd4PlZoQ4rsgLRcqAATo0VFnYJExmupPmMu9mlqNGTP2YC
         A2KSLoDawR6oPdBHVm6MKkBHRdDi8VV0tmjzI+uM7+SBrYlmlsPE0J8Lo5bXHxvDWsbg
         CNYTqYAylsj3rTksk7UHlh8/S3EgmdxX1fUUlFQ1bXc45eKtGno/amkwRCIrXOzN40Kc
         dZeqKQZmcCea9rPKujzjT4cIr5Notex7xNwq+P1EbaEZj3Y8tYr5UjKOPv9wFqco5U7y
         RYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sc0xgxFqbxbNm5gREhne6QGBAqVzmczh60MJ4fT99Tg=;
        b=ULN1wCQRFEDsCoeXezjQV5my48PYC7tjEOZqjuErAEE2GU/nyaUgIzqDarJOwYYpZ9
         sQh3HR4gdJuk3CmcvDkp5kaF47x/MFyd6em+RXtDG/emeOYRcV2vzUiih/iOQ9Dhay3N
         2BBc6yak7Z61PuRYkxADQRzmzHepBVQRRCaCM/3/BZHbGGqBTLa0liGZtScZCTzZxJmQ
         jC7smOTgrTj7rYo348Wcqt2vzoAjqKMKcGHq40eVYnpvcCpHXH6l0190veHOWPGGhSOq
         YBaSVXiwSKr9TWIoG60o97PmTKo447MHSFyOikKXmlF8QQbPtxdTCKOvYfMBbiPAjWrI
         Obmg==
X-Gm-Message-State: AJIora8NET/q4g9mLQIMceJCInnPp8rT5IuuGvQD0KpwZyp2oBaxisO9
        MFOiDVtscejFBDEGPJ3xDgfomw==
X-Google-Smtp-Source: AGRyM1uqGCJbv4jTY+jqr4MJcAreoVFWXBTSJjCSjcFeJ4dfWBzObgi1ZNjthyq4XBw0/PerGbtjMg==
X-Received: by 2002:a05:6402:84f:b0:437:6293:d264 with SMTP id b15-20020a056402084f00b004376293d264mr51517721edz.317.1657097485677;
        Wed, 06 Jul 2022 01:51:25 -0700 (PDT)
Received: from ?IPV6:2a02:a03f:aaeb:6d00:dcca:63aa:cbce:5bb4? ([2a02:a03f:aaeb:6d00:dcca:63aa:cbce:5bb4])
        by smtp.gmail.com with ESMTPSA id v19-20020a170906381300b00721d8e5bf0bsm17055252ejc.6.2022.07.06.01.51.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 01:51:25 -0700 (PDT)
Message-ID: <557a6b90-601a-c2b1-b29b-4b3f480a894f@tessares.net>
Date:   Wed, 6 Jul 2022 10:51:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 51/84] selftests: mptcp: add ADD_ADDR timeout test
 case
Content-Language: en-GB
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        MPTCP Upstream <mptcp@lists.linux.dev>
References: <20220705115615.323395630@linuxfoundation.org>
 <20220705115616.814163273@linuxfoundation.org>
 <a2260559-86af-74ff-ca95-d494688d5ea7@tessares.net>
 <YsRnZ/wmcqGiYzOt@kroah.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <YsRnZ/wmcqGiYzOt@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 05/07/2022 18:31, Greg Kroah-Hartman wrote:
> On Tue, Jul 05, 2022 at 05:59:22PM +0200, Matthieu Baerts wrote:
>> Hi Greg, Sasha,
>>
>> (+ MPTCP upstream ML)
>>
>> First, thank you again for maintaining the stable branches!
>>
>> On 05/07/2022 13:58, Greg Kroah-Hartman wrote:
>>> From: Geliang Tang <geliangtang@gmail.com>
>>>
>>> [ Upstream commit 8d014eaa9254a9b8e0841df40dd36782b451579a ]
>>>
>>> This patch added the test case for retransmitting ADD_ADDR when timeout
>>> occurs. It set NS1's add_addr_timeout to 1 second, and drop NS2's ADD_ADDR
>>> echo packets.
>> TL;DR: Could it be possible to drop all selftests MPTCP patches from
>> v5.10 queue please?
>>
>>
>> I was initially reacting on this patch because it looks like it depends on:
>>
>>   93f323b9cccc ("mptcp: add a new sysctl add_addr_timeout")
>>
>> and indirectly to:
>>
>>   9ce7deff92e8 ("docs: networking: mptcp: Add MPTCP sysctl entries")
>>
>> to have "net.mptcp.add_addr_timeout" sysctl knob needed for this new
>> selftest.
>>
>> But then I tried to understand why this current patch ("selftests:
>> mptcp: add ADD_ADDR timeout test case") has been selected for 5.10. I
>> guess it was to ease the backport of another one, right?
>> Looking at the 'series' file in 5.10 queue, it seems the new
>> "selftests-mptcp-more-stable-diag-tests" patch requires 5 other patches:
>>
>> -> selftests-mptcp-more-stable-diag-tests.patch
>>  -> selftests-mptcp-fix-diag-instability.patch
>>   -> selftests-mptcp-launch-mptcp_connect-with-timeout.patch
>>    -> selftests-mptcp-add-add_addr-ipv6-test-cases.patch
>>     -> selftests-mptcp-add-link-failure-test-case.patch
>>      -> selftests-mptcp-add-add_addr-timeout-test-case.patch
>>
>>
>> When looking at these patches in more detail, it looks like "selftests:
>> mptcp: add ADD_ADDR IPv6 test cases" depends on a new feature only
>> available from v5.11: ADD_ADDR for IPv6.
>>
>>
>> Could it be possible to drop all these patches from v5.10 then please?
> 
> Sure, but leave them in for 5.15.y and 5.18.y?

(@Mat: Thank you for having replied to this part: yes, please leave them
there)

>> The two recent fixes for the "diag" selftest mainly helps on slow / busy
>> CI. I think it is not worth backporting them to v5.10.
>>
>>
>> (Note that if we want "selftests: mptcp: fix diag instability" patch, we
>> also need 2e580a63b5c2 ("selftests: mptcp: add cfg_do_w for cfg_remove")
>> and the top part of 8da6229b9524 ("selftests: mptcp: timeout testcases
>> for multi addresses"): the list starts to be long.)
>>
>>
>> One last thing: it looks like when Sasha adds patches to a stable queue,
>> a notification is sent to less people than when Greg adds patches. For
>> example here, I have not been notified for this patch when added to the
>> queue while I was one of the reviewers. I already got notifications from
>> Greg when I was a reviewer on other patches.
>> Is it normal? Do you only cc people who signed off on the patch?
> 
> I cc: everyone on the commit, Sasha should also do that but sometimes
> his script acts up.

All good, thank you!

>> It looks like you don't cc maintainers from the MAINTAINERS file but
>> that's probably on purpose. I didn't get cc for all MPTCP patches of the
>> series here but I guess I can always subscribe to 'stable' ML for that.
> 
> No, we don't use the MAINTAINERS file, that would just be too noisy as
> ideally who ever the MAINTAINER was, they already saw this as the commit
> is already in Linus's tree.

I understand, thank you for the explanation.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
