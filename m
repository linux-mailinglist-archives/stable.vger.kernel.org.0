Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACB24DD97A
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 13:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbiCRMQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 08:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236059AbiCRMQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 08:16:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0646663B3
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 05:15:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE6A91424;
        Fri, 18 Mar 2022 05:15:18 -0700 (PDT)
Received: from [10.57.88.118] (unknown [10.57.88.118])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF9EB3F7F5;
        Fri, 18 Mar 2022 05:15:17 -0700 (PDT)
Subject: Re: [stable:PATCH v5.4.184 00/22] arm64: Mitigate spectre style
 branch history side channels
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org
References: <20220315182415.3900464-1-james.morse@arm.com>
 <YjIFE8Abn7XI+4yW@sashalap> <YjMGwYeBTx36/6uO@kroah.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <6d749d6c-aa5b-0c82-a404-62633a3da8ee@arm.com>
Date:   Fri, 18 Mar 2022 12:15:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YjMGwYeBTx36/6uO@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 3/17/22 10:00 AM, Greg KH wrote:
> On Wed, Mar 16, 2022 at 11:41:07AM -0400, Sasha Levin wrote:
>> On Tue, Mar 15, 2022 at 06:23:53PM +0000, James Morse wrote:
>>> Hi Greg,
>>>
>>> Here is the state of the current v5.4 backport. Now that the 32bit
>>> code has been merged, it doesn't conflict when KVM's shared 32bit/64bit
>>> code needs to use these constants.
>>>
>>> I've fixed the two issues that were reported against the v5.10 backport.
>>>
>>> I had a go at bringing all the pre-requisites in to add proton-pack.c
>>> to v5.4. Its currently 39 patches:
>>> https://git.gitlab.arm.com/linux-arm/linux-jm.git /bhb/alternative_backport/UNTESTED/v5.4.183
>>> (or for web browsers:
>>> https://gitlab.arm.com/linux-arm/linux-jm/-/commits/bhb/alternative_backport/UNTESTED/v5.4.183/
>>> )
>>
>> I've queued it up.
> 
> Thanks for merging these, and James, thanks for the backports!  I agree,
> this way is a bit "simpler", but thanks for trying the other way as
> well.

> Does this mean that the 4.19 and older backports will be easier?

It means they'll be based on the versions I posted on before. But: the last review comment that
needs addressing is the A76 ID macros that came in with an errata workaround, but the workaround
wasn't backported. I need to work out how easy that is to do.


Thanks,

James
