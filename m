Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BECD0AEE98
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 17:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393987AbfIJPej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 11:34:39 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:26636 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393960AbfIJPej (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 11:34:39 -0400
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8AFW19p001475;
        Tue, 10 Sep 2019 15:34:16 GMT
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com [15.241.140.78])
        by mx0a-002e3701.pphosted.com with ESMTP id 2uxc4t2b6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Sep 2019 15:34:16 +0000
Received: from g4t3433.houston.hpecorp.net (g4t3433.houston.hpecorp.net [16.208.49.245])
        by g4t3425.houston.hpe.com (Postfix) with ESMTP id C8E7CAA;
        Tue, 10 Sep 2019 15:34:15 +0000 (UTC)
Received: from [16.116.129.27] (unknown [16.116.129.27])
        by g4t3433.houston.hpecorp.net (Postfix) with ESMTP id 8873D46;
        Tue, 10 Sep 2019 15:34:14 +0000 (UTC)
Subject: Re: [PATCH 0/8] x86/platform/UV: Update UV Hubless System Support
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
References: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
 <CANiq72nTKbNEKezoy_CqdFRuQ0SD2OsORV8u=i_1g=2atkCRiA@mail.gmail.com>
From:   Mike Travis <mike.travis@hpe.com>
Message-ID: <797654d8-562a-6492-79e1-65a292157d04@hpe.com>
Date:   Tue, 10 Sep 2019 08:34:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <CANiq72nTKbNEKezoy_CqdFRuQ0SD2OsORV8u=i_1g=2atkCRiA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-10_11:2019-09-10,2019-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=883 spamscore=0 adultscore=0 priorityscore=1501 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909100147
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/10/2019 5:07 AM, Miguel Ojeda wrote:
> On Thu, Sep 5, 2019 at 3:50 PM Mike Travis <mike.travis@hpe.com> wrote:
>>
>> These patches support upcoming UV systems that do not have a UV HUB.
> 
> Please send patches as plain text without attachments. See:
> 
>    https://www.kernel.org/doc/html/latest/process/submitting-patches.html#no-mime-no-links-no-compression-no-attachments-just-plain-text
> 
> for details.
> 
> Cheers,
> Miguel
> 

Hi,  I'm not conscientiously adding any attachments.  I think what is 
happening is some email readers mistake the '---' to signify an 
attachment follows.  I see the "staple" symbol on some indicating an 
attachment, but not usually all of the email I send.  Thanks, Mike
