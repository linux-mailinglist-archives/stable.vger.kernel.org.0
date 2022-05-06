Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CBD51DBE2
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 17:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355450AbiEFP0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 11:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236859AbiEFPZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 11:25:59 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC1B6D181;
        Fri,  6 May 2022 08:22:15 -0700 (PDT)
Received: from [192.168.1.30] (097-089-247-249.biz.spectrum.com [97.89.247.249])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 4F4A93F741;
        Fri,  6 May 2022 15:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1651850534;
        bh=xeNUGaT4p7FRhfwjeWmLkgogYHfgQxHD8jC1ffB16qc=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=BOrbwwqMJgYB7MMeDKt6CJV/BzxbcAzJhmM0IMybCrP0+Np3etyNxHy8f9msYe/BI
         JupmgffARce/69urpHn21syPU4Ca7BZQF/WDPwysfELAMDvJBRO/0RNCGi4gkEqbsp
         Pmz3fPktq55CkK8UDZwbjnArU2i+jj2iYvlNaj2NWbmt9688dXnUmaqaee0WQsRuPT
         kbudqpHht73fEd4l90KZB6HGHCHreh3LN7DJjKCDN36gahi9p0vxFdu9AcY1WrfKc5
         YZBgMcd+WI4QTvaypa6fbdUI/aBtG1aMOQIJ+O28JNrcAGAfm8U5nsH9ZxEQTzEGkB
         Lap6FsoMpPZyg==
Message-ID: <0a3e8894-bc12-5854-dbaf-71ac8f1367f2@canonical.com>
Date:   Fri, 6 May 2022 11:22:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] docs: sched: Update sched-rt-group Documentation For
 Gender Inclusiveness
Content-Language: en-US
To:     Phil Auld <pauld@redhat.com>
Cc:     linux-kernel@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, stable@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20220505021424.12656-1-joseph.salisbury@canonical.com>
 <YnUwsnt52aB0sZi0@lorien.usersys.redhat.com>
From:   Joseph Salisbury <joseph.salisbury@canonical.com>
In-Reply-To: <YnUwsnt52aB0sZi0@lorien.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/6/22 10:29, Phil Auld wrote:
> On Wed, May 04, 2022 at 10:14:24PM -0400 Joseph Salisbury wrote:
>> Document assumes root user is he:
>> "assumes root knows what he is doing."
>>
>> Update documentation for inclusivness, since root is not limited by gender.
>>
>> Fixes: 60aa605dfce2 ("sched: rt: document the risk of small values in the bandwidth settings")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
>> ---
>>   Documentation/scheduler/sched-rt-group.rst | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/scheduler/sched-rt-group.rst b/Documentation/scheduler/sched-rt-group.rst
>> index 655a096ec8fb..e55fee6772c4 100644
>> --- a/Documentation/scheduler/sched-rt-group.rst
>> +++ b/Documentation/scheduler/sched-rt-group.rst
>> @@ -19,7 +19,7 @@ Real-Time group scheduling
>>   ==========
>>   
>>    Fiddling with these settings can result in an unstable system, the knobs are
>> - root only and assumes root knows what he is doing.
>> + root only and assumes root knows what they are doing.
>>
> Now there's a singular vs plural problem.
>
> "... assumes root users know ..."  ?
Thanks for the feedback, Phil.

Your suggestion makes more sense.  I'll wait for any additional 
responses before sending a v2 with your suggestion.
>
>
>
> Cheers,
> Phil
>
>>   Most notable:
>>   
>> -- 
>> 2.34.1
>>

