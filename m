Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476EEA6B15
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 16:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbfICORr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 10:17:47 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:53512 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728122AbfICORr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 10:17:47 -0400
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83EGqUX026941;
        Tue, 3 Sep 2019 14:17:28 GMT
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
        by mx0a-002e3701.pphosted.com with ESMTP id 2us2nfgyk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 14:17:28 +0000
Received: from g4t3433.houston.hpecorp.net (g4t3433.houston.hpecorp.net [16.208.49.245])
        by g9t5008.houston.hpe.com (Postfix) with ESMTP id 5D61B4F;
        Tue,  3 Sep 2019 14:17:27 +0000 (UTC)
Received: from [16.116.163.9] (unknown [16.116.163.9])
        by g4t3433.houston.hpecorp.net (Postfix) with ESMTP id 4F5EE45;
        Tue,  3 Sep 2019 14:17:26 +0000 (UTC)
Subject: Re: [PATCH 0/8] x86/platform/UV: Update UV Hubless System Support
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
 <20190903074717.GA34890@gmail.com>
From:   Mike Travis <mike.travis@hpe.com>
Message-ID: <481b2921-760a-c0f3-489b-2b9c5f792883@hpe.com>
Date:   Tue, 3 Sep 2019 07:17:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903074717.GA34890@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_02:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 impostorscore=0 clxscore=1011
 spamscore=0 bulkscore=0 phishscore=0 mlxlogscore=996 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030150
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/3/2019 12:47 AM, Ingo Molnar wrote:
> 
> * Mike Travis <mike.travis@hpe.com> wrote:
> 
>>
>> These patches support upcoming UV systems that do not have a UV HUB.
>>
>> 	* Save OEM_ID from ACPI MADT probe
>> 	* Return UV Hubless System Type
>> 	* Add return code to UV BIOS Init function
>> 	* Setup UV functions for Hubless UV Systems
>> 	* Add UV Hubbed/Hubless Proc FS Files
>> 	* Decode UVsystab Info
>> 	* Account for UV Hubless in is_uvX_hub Ops
> 
> Beyond addressing Christoph's feedback, please also make sure the series
> applies cleanly to tip:master, because right now it doesn't.
> 
> Thanks,
> 
> 	Ingo
> 

I will do this, and retest.  Currently we are using the latest upstream
version but obviously that thinking is flawed, since we are hoping to
get into the next merge period.

I also noticed that the MAINTAINERS list for UV is out of date, I will 
tend to that too.

Thanks,
Mike
