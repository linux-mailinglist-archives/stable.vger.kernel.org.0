Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65FCFD70D5
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 10:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfJOIQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 04:16:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3715 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728638AbfJOIQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 04:16:34 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 684F722A77D763E6CFE1;
        Tue, 15 Oct 2019 16:16:30 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.179) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 15 Oct 2019
 16:16:22 +0800
Subject: Re: [PATCH for-stable-5.3 1/2] ACPI/PPTT: Add support for ACPI 6.3
 thread flag
To:     Sasha Levin <sashal@kernel.org>
References: <1571054162-71090-1-git-send-email-john.garry@huawei.com>
 <1571054162-71090-2-git-send-email-john.garry@huawei.com>
 <20191014232958.GC31224@sasha-vm>
CC:     <stable@vger.kernel.org>, <catalin.marinas@arm.com>,
        <will@kernel.org>, <rjw@rjwysocki.net>, <lenb@kernel.org>,
        <sudeep.holla@arm.com>, <rrichter@marvell.com>,
        <jeremy.linton@arm.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linuxarm@huawei.com>, <gregkh@linuxfoundation.org>,
        <guohanjun@huawei.com>, <wanghuiqiang@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <635a839b-bc1e-37ab-bd47-a554acc9b282@huawei.com>
Date:   Tue, 15 Oct 2019 09:16:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <20191014232958.GC31224@sasha-vm>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/10/2019 00:29, Sasha Levin wrote:
> On Mon, Oct 14, 2019 at 07:56:01PM +0800, John Garry wrote:
>> From: Jeremy Linton <jeremy.linton@arm.com>
>>
>> Commit bbd1b70639f785a970d998f35155c713f975e3ac upstream.
>>
>> ACPI 6.3 adds a flag to the CPU node to indicate whether
>> the given PE is a thread. Add a function to return that
>> information for a given linux logical CPU.
>>
>> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>> Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
>> Reviewed-by: Robert Richter <rrichter@marvell.com>
>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Signed-off-by: Will Deacon <will@kernel.org>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>
> How far back should these patches be backported?
>

Hi Sasha,

This patchset is for 5.3, and I sent a separate patchset for 4.19, since 
the backport is a little different and required some hand modification - 
 
https://lore.kernel.org/linux-arm-kernel/1571046986-231263-1-git-send-email-john.garry@huawei.com/. 
4.19 is as far back as we want.

Please note that the patches in this 5.3 series are relevant for 5.2 
also, but since 5.2 is EOL, I didn't mention it. We did test 5.2, so you 
can add there also.

Please let me know if any more questions.

All the best,
John



