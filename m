Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EFFD29D1
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 14:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733191AbfJJMqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 08:46:24 -0400
Received: from foss.arm.com ([217.140.110.172]:58600 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733051AbfJJMqX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 08:46:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6795128;
        Thu, 10 Oct 2019 05:46:23 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (unknown [10.1.197.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 936CF3F68E;
        Thu, 10 Oct 2019 05:46:22 -0700 (PDT)
Subject: Re: [PATCH] arm64: cpufeature: Fix truncating a feature value
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, mark.rutland@arm.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20191010110856.4376-1-suzuki.poulose@arm.com>
 <ca77dec7-b29b-5a3b-0c01-047a06d1854d@arm.com>
 <20191010122922.GA720144@kroah.com>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <295cfb9e-ac7b-73e7-bc80-8b9150f4a626@arm.com>
Date:   Thu, 10 Oct 2019 13:46:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191010122922.GA720144@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/10/2019 13:29, Greg KH wrote:
> On Thu, Oct 10, 2019 at 12:12:01PM +0100, Suzuki K Poulose wrote:
>> All,
>>
>> On 10/10/2019 12:08, Suzuki K Poulose wrote:
>>> A signed feature value is truncated to turn to an unsigned value
>>> causing bad state in the system wide infrastructure. This affects
>>> the discovery of FP/ASIMD support on arm64. Fix this by making sure
>>> we cast it properly.
>>>
>>> Fixes: 4f0a606bce5ec ("arm64: cpufeature: Track unsigned fields")
>>> Cc: stable@vger.kernel.org # v4.4
>>
>> Please note that this patch is only applicable for stable 4.4 tree.
>> I should have removed the Fixes tag.
> 
> Why is it only for 4.4?  That needs to be documented really really

This was fixed later in v4.6 onwards with commit 28c5dcb22f90113dea
("arm64: Rename cpuid_feature field extract routines") rather inadvertently.

> really well in the changelog as to why this is a one-off patch, and why
> we can't just take the relevant patches that are in Linus's tree
> instead.
> 
> Please fix up and resend.

I can resend the patch with the above information included if you like.

Cheers
Suzuki
