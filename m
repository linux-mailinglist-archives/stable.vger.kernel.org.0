Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B75AABBF
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 21:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732014AbfIETIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 15:08:44 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:61624 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731206AbfIETIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 15:08:43 -0400
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x85J1eHZ025043;
        Thu, 5 Sep 2019 19:08:26 GMT
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        by mx0a-002e3701.pphosted.com with ESMTP id 2uttq6phvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Sep 2019 19:08:26 +0000
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3426.houston.hpe.com (Postfix) with ESMTP id 9B29C4E;
        Thu,  5 Sep 2019 19:08:25 +0000 (UTC)
Received: from [16.116.163.9] (unknown [16.116.163.9])
        by g9t2301.houston.hpecorp.net (Postfix) with ESMTP id 727AF48;
        Thu,  5 Sep 2019 19:08:24 +0000 (UTC)
Subject: Re: [PATCH 0/8] x86/platform/UV: Update UV Hubless System Support
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20190905184741.256857552@stormcage.eag.rdlabs.hpecorp.net>
 <alpine.DEB.2.21.1909052056210.1902@nanos.tec.linutronix.de>
From:   Mike Travis <mike.travis@hpe.com>
Message-ID: <d90ffd5c-2e9f-ead2-b866-0af4ab261591@hpe.com>
Date:   Thu, 5 Sep 2019 12:08:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1909052056210.1902@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_06:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909050177
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/5/2019 12:02 PM, Thomas Gleixner wrote:
> Mike,
> 
> On Thu, 5 Sep 2019, Mike Travis wrote:
> 
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
> Can you please in future mark the next version of a patch or patch series
> with [PATCH V2 n/M] so its clear that this is something different and also
> add a quick summary what changed vs. V1? Adding to each patch which changed
> a short change info _after_ the '---' discard line is also good practice
> and helps reviewers to figure out which part needs to be looked at.
> 
> Thanks
> 
> 	tglx
> 

Yeah, I noticed that the V2: tag for the removal that Greg requested was 
missing in the copy sent to me.  Sorry I didn't catch that earlier.

The "[PATCH V2 n/M]" is something I hadn't been aware but I am now.

Should I resend the patches again with those updates?

Thanks.
