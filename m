Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A347C1767EC
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 00:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgCBXNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 18:13:40 -0500
Received: from nwk-aaemail-lapp02.apple.com ([17.151.62.67]:41162 "EHLO
        nwk-aaemail-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726700AbgCBXNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 18:13:40 -0500
Received: from pps.filterd (nwk-aaemail-lapp02.apple.com [127.0.0.1])
        by nwk-aaemail-lapp02.apple.com (8.16.0.27/8.16.0.27) with SMTP id 022ND2h7017635;
        Mon, 2 Mar 2020 15:13:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : subject : to
 : cc : references : from : message-id : date : mime-version : in-reply-to
 : content-type : content-transfer-encoding; s=20180706;
 bh=fSmNnFJRfIU4ktl8+lZWfYa+llqxM8otQhXUWvP6bXk=;
 b=FZm5Zox6wYXSgMN6c58Ty5SmX9761v/WHR+xmS4DmcrbpYK6sReg2JLraRLffvZOa1K4
 PTbTEO0ARNKjJy4Eboiw7m+wY/B2LDjUsHPD9Yll30tuMTO3dhT1JyhlSZ1/tGx5Aci4
 gTSCLN9xItYyaxYwvimC998x8JfFYwSQesPsnMIXhHeGpVjdttZx4Dx+VuOAMOBcyls7
 uEht/rWEXrsvKgjNTBGJncftwyAx37f8AByNX4or6OFubj9bueDA4TJOQCu2vGR89SVA
 ZAb1W7+UByLmcoXQxH0V2MUR087Tm7JiIthrN/v25+o2xweQKy1c7jrdMlHDFAjT+mgd AA== 
Received: from rn-mailsvcp-mta-lapp02.rno.apple.com (rn-mailsvcp-mta-lapp02.rno.apple.com [10.225.203.150])
        by nwk-aaemail-lapp02.apple.com with ESMTP id 2yfndkh9r1-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Mon, 02 Mar 2020 15:13:28 -0800
Received: from rn-mailsvcp-mmp-lapp03.rno.apple.com
 (rn-mailsvcp-mmp-lapp03.rno.apple.com [17.179.253.16])
 by rn-mailsvcp-mta-lapp02.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.1.20190704 64bit (built Jul  4
 2019)) with ESMTPS id <0Q6L00NW39UD7TE0@rn-mailsvcp-mta-lapp02.rno.apple.com>;
 Mon, 02 Mar 2020 15:13:25 -0800 (PST)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp03.rno.apple.com by
 rn-mailsvcp-mmp-lapp03.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.1.20190704 64bit (built Jul  4
 2019)) id <0Q6L00A009QE5O00@rn-mailsvcp-mmp-lapp03.rno.apple.com>; Mon,
 02 Mar 2020 15:13:25 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 3858d3b7fb8b1cc950f911c6fbdd6870
X-Va-E-CD: 44ad1d096edb94b374157e30c18c7e83
X-Va-R-CD: ecda2c9763e2ef451915f5fd3d5ded1a
X-Va-CD: 0
X-Va-ID: e80c6213-fc9b-4958-92c9-940ac10ae77a
X-V-A:  
X-V-T-CD: 3858d3b7fb8b1cc950f911c6fbdd6870
X-V-E-CD: 44ad1d096edb94b374157e30c18c7e83
X-V-R-CD: ecda2c9763e2ef451915f5fd3d5ded1a
X-V-CD: 0
X-V-ID: d87aa545-fb69-4662-8e2e-3bc2f8a31d61
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_09:2020-03-02,2020-03-02 signatures=0
Received: from Vishnus-iMac-Pro.local (unknown [17.149.214.206])
 by rn-mailsvcp-mmp-lapp03.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.1.20190704 64bit (built Jul  4
 2019))
 with ESMTPSA id <0Q6L00KLA9UDT0C0@rn-mailsvcp-mmp-lapp03.rno.apple.com>; Mon,
 02 Mar 2020 15:13:25 -0800 (PST)
Subject: Re: Fixes for 4.19 stable
To:     Sasha Levin <sashal@kernel.org>,
        Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        Andrew Forgue <andrewf@apple.com>, vincent.guittot@linaro.org,
        peterz@infradead.org, dietmar.eggemann@arm.com,
        rafael.j.wysocki@intel.com
References: <6CF798B4-B68B-4729-A496-2152FC032ABC@apple.com>
 <20200301031128.GK21491@sasha-vm>
From:   Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Message-id: <2f569b8a-329f-8259-d91c-7e526e0d768c@apple.com>
Date:   Mon, 02 Mar 2020 15:13:24 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-version: 1.0
In-reply-to: <20200301031128.GK21491@sasha-vm>
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_09:2020-03-02,2020-03-02 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

Not sure of this, looks relevant but I'm no expert on this code.
This particular change bef69dd87828 doesn't apply cleanly, need to 
backport it. I'll do that now and retest on the failing setup and report 
back.

Best
Vishnu

On 2/29/20 7:11 PM, Sasha Levin wrote:
> On Fri, Feb 28, 2020 at 12:13:54PM -0800, Vishnu Rangayyan wrote:
>> Hi,
>>
>> I still see high (upto 30%) ksoftirqd cpu use with 4.19.101+ after 
>> these 2 back ports went in for 4.19.101
>> (had all 4 backports applied earlier to our tree):
>>
>> commit f6783319737f28e4436a69611853a5a098cbe974 sched/fair: Fix 
>> insertion in rq->leaf_cfs_rq_list
>> commit 5d299eabea5a251fbf66e8277704b874bbba92dc sched/fair: Add 
>> tmp_alone_branch assertion
>>
>> perf shows for any given ksoftirqd, with 20k-30k processes on the 
>> system with high scheduler load:
>>  58.88%  ksoftirqd/0  [kernel.kallsyms]  [k] update_blocked_averages
>>
>> Can we backport these 2 also, confirmed that it fixes this behavior of 
>> ksoftirqd.
>>
>> commit 039ae8bcf7a5f4476f4487e6bf816885fb3fb617 upstream
>> commit 31bc6aeaab1d1de8959b67edbed5c7a4b3cdbe7c upstream
> 
> Do we also need bef69dd87828 ("sched/cpufreq: Move the
> cfs_rq_util_change() call to cpufreq_update_util()") then?
> 
