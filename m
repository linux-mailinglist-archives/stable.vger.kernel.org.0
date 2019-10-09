Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E74CDD06FF
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 08:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfJIGDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 02:03:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4132 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726698AbfJIGDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 02:03:51 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9962kYK110131
        for <stable@vger.kernel.org>; Wed, 9 Oct 2019 02:03:50 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vh6h1dvrd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 02:03:49 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <clg@kaod.org>;
        Wed, 9 Oct 2019 07:03:47 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 9 Oct 2019 07:03:44 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9963hwx33161414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Oct 2019 06:03:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E17A4AE056;
        Wed,  9 Oct 2019 06:03:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D757BAE055;
        Wed,  9 Oct 2019 06:03:42 +0000 (GMT)
Received: from smtp.tls.ibm.com (unknown [9.101.4.1])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Oct 2019 06:03:42 +0000 (GMT)
Received: from yukon.kaod.org (sig-9-145-55-18.uk.ibm.com [9.145.55.18])
        by smtp.tls.ibm.com (Postfix) with ESMTP id 5A017220198;
        Wed,  9 Oct 2019 08:03:42 +0200 (CEST)
Subject: Re: FAILED: patch "[PATCH] KVM: PPC: Book3S HV: XIVE: Free escalation
 interrupts before" failed to apply to 4.19-stable tree
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     mpe@ellerman.id.au, stable@vger.kernel.org
References: <1570519208179101@kroah.com> <20191008214550.GE1396@sasha-vm>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Date:   Wed, 9 Oct 2019 08:03:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191008214550.GE1396@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19100906-0016-0000-0000-000002B656E9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100906-0017-0000-0000-000033175BB7
Message-Id: <4bcac721-5e89-a12b-e728-d9309c85f4ee@kaod.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=906 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910090056
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/10/2019 23:45, Sasha Levin wrote:
> On Tue, Oct 08, 2019 at 09:20:08AM +0200, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 4.19-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From 237aed48c642328ff0ab19b63423634340224a06 Mon Sep 17 00:00:00 2001
>> From: =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
>> Date: Tue, 6 Aug 2019 19:25:38 +0200
>> Subject: [PATCH] KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before
>> disabling the VP
>> MIME-Version: 1.0
>> Content-Type: text/plain; charset=UTF-8
>> Content-Transfer-Encoding: 8bit
>>
>> When a vCPU is brought done, the XIVE VP (Virtual Processor) is first
>> disabled and then the event notification queues are freed. When freeing
>> the queues, we check for possible escalation interrupts and free them
>> also.
>>
>> But when a XIVE VP is disabled, the underlying XIVE ENDs also are
>> disabled in OPAL. When an END (Event Notification Descriptor) is
>> disabled, its ESB pages (ESn and ESe) are disabled and loads return all
>> 1s. Which means that any access on the ESB page of the escalation
>> interrupt will return invalid values.
>>
>> When an interrupt is freed, the shutdown handler computes a 'saved_p'
>> field from the value returned by a load in xive_do_source_set_mask().
>> This value is incorrect for escalation interrupts for the reason
>> described above.
>>
>> This has no impact on Linux/KVM today because we don't make use of it
>> but we will introduce in future changes a xive_get_irqchip_state()
>> handler. This handler will use the 'saved_p' field to return the state
>> of an interrupt and 'saved_p' being incorrect, softlockup will occur.
>>
>> Fix the vCPU cleanup sequence by first freeing the escalation interrupts
>> if any, then disable the XIVE VP and last free the queues.
>>
>> Fixes: 90c73795afa2 ("KVM: PPC: Book3S HV: Add a new KVM device for the XIVE native exploitation mode")
>> Fixes: 5af50993850a ("KVM: PPC: Book3S HV: Native usage of the XIVE interrupt controller")
>> Cc: stable@vger.kernel.org # v4.12+
>> Signed-off-by: Cédric Le Goater <clg@kaod.org>
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> Link: https://lore.kernel.org/r/20190806172538.5087-1-clg@kaod.org
> 
> I've dropped the xive native part on 4.19 and 4.14 because 90c73795afa24
> ("KVM: PPC: Book3S HV: Add a new KVM device for the XIVE native
> exploitation mode") isn't there.

yes. It was introduced in 5.2. 

The fixes on the XICS-on-XIVE KVM device and the XIVE native KVM device 
are often the same patch because they have a lot in common. 
We should try to separate the patches in the future to ease backport
on the stable trees. Thanks for doing so,

C.


