Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E17FAF00A
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 18:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436973AbfIJQ5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 12:57:33 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:29760 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436883AbfIJQ5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 12:57:33 -0400
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8AGv3OH030750;
        Tue, 10 Sep 2019 16:57:11 GMT
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        by mx0a-002e3701.pphosted.com with ESMTP id 2ux7qqq4vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Sep 2019 16:57:11 +0000
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g9t5009.houston.hpe.com (Postfix) with ESMTP id BAA1258;
        Tue, 10 Sep 2019 16:57:10 +0000 (UTC)
Received: from [16.116.129.27] (unknown [16.116.129.27])
        by g9t2301.houston.hpecorp.net (Postfix) with ESMTP id 8FC924D;
        Tue, 10 Sep 2019 16:57:09 +0000 (UTC)
Subject: Re: [PATCH 0/8] x86/platform/UV: Update UV Hubless System Support
To:     Borislav Petkov <bp@alien8.de>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
 <797654d8-562a-6492-79e1-65a292157d04@hpe.com>
 <20190910164050.GH23931@zn.tnic>
From:   Mike Travis <mike.travis@hpe.com>
Message-ID: <ba26a8c1-26e7-fb88-9466-76ba35404a05@hpe.com>
Date:   Tue, 10 Sep 2019 09:57:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190910164050.GH23931@zn.tnic>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-10_11:2019-09-10,2019-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 suspectscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909100162
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/10/2019 9:40 AM, Borislav Petkov wrote:
> On Tue, Sep 10, 2019 at 08:34:44AM -0700, Mike Travis wrote:
>> Hi,  I'm not conscientiously adding any attachments.  I think what is
>> happening is some email readers mistake the '---' to signify an attachment
>> follows.  I see the "staple" symbol on some indicating an attachment, but
>> not usually all of the email I send.  Thanks, Mike
> 
> Btw, is there anyway to fix your mail setup and not flood with your
> patchset?
> 
> I have received your V2 patchset 5(!) times yesterday and today. All
> separate submissions!
> 
> ;-(
> 

Sorry, I've been testing them and monitoring LKML to check for leakages. 
  I certainly did not intend for any of those test sends to get out. 
And I don't understand right now how they did.  I am using sendmail in 
it's basic form and you or anyone else was not on the recipient list.

(Honestly, if I had known they got out, I would have stopped testing... 
:)  But the latest ones are obviously the "official" submissions, since 
those are the copies that I also have.)  If you accept them upstream, 
I'll quit sending them, I promise... :)
