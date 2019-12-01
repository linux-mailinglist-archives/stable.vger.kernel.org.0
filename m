Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C795910E3FD
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 00:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfLAXyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 18:54:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727266AbfLAXyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Dec 2019 18:54:55 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB1NqUqU104695;
        Sun, 1 Dec 2019 18:54:53 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wm6sm59du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 01 Dec 2019 18:54:53 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xB1No2sl023106;
        Sun, 1 Dec 2019 23:54:52 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 2wkg265vsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 01 Dec 2019 23:54:52 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB1Nspo047251850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 1 Dec 2019 23:54:51 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25DCC7805F;
        Sun,  1 Dec 2019 23:54:51 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A1217805C;
        Sun,  1 Dec 2019 23:54:50 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun,  1 Dec 2019 23:54:50 +0000 (GMT)
Subject: Re: [PATCH 0/2] Revert patches fixing probing of interrupts
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-security-module@vger.kernel.org
References: <20191126131753.3424363-1-stefanb@linux.vnet.ibm.com>
 <20191129223418.GA15726@linux.intel.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
Message-ID: <6f6f60a2-3b55-e76d-c11a-4677fcb72c16@linux.ibm.com>
Date:   Sun, 1 Dec 2019 18:54:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191129223418.GA15726@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-01_04:2019-11-29,2019-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 suspectscore=0 clxscore=1011 malwarescore=0 adultscore=0 impostorscore=0
 phishscore=0 mlxlogscore=845 spamscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912010215
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/19 5:37 PM, Jarkko Sakkinen wrote:
> On Tue, Nov 26, 2019 at 08:17:51AM -0500, Stefan Berger wrote:
>> From: Stefan Berger <stefanb@linux.ibm.com>
>>
>> Revert the patches that were fixing the probing of interrupts due
>> to reports of interrupt stroms on some systems
> Can you explain how reverting is going to fix the issue?


The reverts fix 'the interrupt storm issue' that they are causing on 
some systems but don't fix the issue with the interrupt mode not being 
used. I was hoping Jerry would get access to a system faster but this 
didn't seem to be the case. So sending these patches seemed the better 
solution than leaving 5.4.x with the problem but going back to when it 
worked 'better.'


>
> This is wrong way to move forward. The root cause must be identified
> first and then decide actions like always in any situation.
>
> /Jarkko


