Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B514CFC80
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 12:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbiCGLSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 06:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242288AbiCGLSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 06:18:39 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F019FE0A34;
        Mon,  7 Mar 2022 02:43:24 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBCACED1;
        Mon,  7 Mar 2022 02:43:24 -0800 (PST)
Received: from [10.57.39.47] (unknown [10.57.39.47])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D41843F73D;
        Mon,  7 Mar 2022 02:43:23 -0800 (PST)
Message-ID: <6417e59f-6329-cdb8-0155-c765483a31af@arm.com>
Date:   Mon, 7 Mar 2022 10:43:16 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Patch "iommu/amd: Use put_pages_list" has been added to the
 5.16-stable tree
Content-Language: en-GB
To:     Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        stable@vger.kernel.org
References: <20220305205638.144916-1-sashal@kernel.org>
 <YiU6BL2d+Z6o6JX2@casper.infradead.org>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YiU6BL2d+Z6o6JX2@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-03-06 22:47, Matthew Wilcox wrote:
> On Sat, Mar 05, 2022 at 03:56:38PM -0500, Sasha Levin wrote:
>> This is a note to let you know that I've just added the patch titled
>>
>>      iommu/amd: Use put_pages_list
>>
>> to the 5.16-stable tree which can be found at:
>>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>       iommu-amd-use-put_pages_list.patch
>> and it can be found in the queue-5.16 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
> 
> I would defer to Robin, but I don't think this is a good candidate for
> a stable backport.  It has some dependencies, IIRC.  And it's not really
> fixing a bug.

Indeed, I'd feel a bit uncomfortable about backporting this 
unnecessarily. It doesn't make much sense in isolation without the other 
patch(es) converting the rest of the IOMMU subsystem as well, but either 
way unless the whole SLAB rework needs backporting for some reason then 
it just represents risk without benefit.

Thanks,
Robin.
