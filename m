Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563BE203FD0
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 21:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbgFVTBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 15:01:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22622 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730020AbgFVTBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 15:01:34 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MIWJxZ122180;
        Mon, 22 Jun 2020 15:01:32 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tyvucp16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 15:01:32 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MIWe11122980;
        Mon, 22 Jun 2020 15:01:32 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tyvucp0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 15:01:32 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MJ046U020167;
        Mon, 22 Jun 2020 19:01:31 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 31sa38htam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 19:01:31 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MJ1SlX18350440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 19:01:28 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 396A1BE054;
        Mon, 22 Jun 2020 19:01:30 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A52DBBE053;
        Mon, 22 Jun 2020 19:01:28 +0000 (GMT)
Received: from swastik.ibm.com (unknown [9.160.110.135])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 22 Jun 2020 19:01:28 +0000 (GMT)
Subject: Re: [PATCH v2] ima: move APPRAISE_BOOTPARAM dependency on ARCH_POLICY
 to runtime
To:     Bruno Meneguele <bmeneg@redhat.com>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.ibm.com, erichte@linux.ibm.com, nayna@linux.ibm.com,
        stable@vger.kernel.org
References: <20200622172754.10763-1-bmeneg@redhat.com>
From:   Nayna <nayna@linux.vnet.ibm.com>
Message-ID: <043e52d4-6835-c2c4-bc9d-d36ddb3db0e9@linux.vnet.ibm.com>
Date:   Mon, 22 Jun 2020 15:01:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200622172754.10763-1-bmeneg@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_10:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 clxscore=1011 mlxlogscore=999 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220122
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 6/22/20 1:27 PM, Bruno Meneguele wrote:
> IMA_APPRAISE_BOOTPARAM has been marked as dependent on !IMA_ARCH_POLICY in
> compile time, enforcing the appraisal whenever the kernel had the arch
> policy option enabled.
>
> However it breaks systems where the option is actually set but the system
> wasn't booted in a "secure boot" platform. In this scenario, anytime the
> an appraisal policy (i.e. ima_policy=appraisal_tcb) is used it will be
> forced, giving no chance to the user set the 'fix' state (ima_appraise=fix)
> to actually measure system's files.
>
> This patch remove this compile time dependency and move it to a runtime
> decision, based on the arch policy loading failure/success.

Thanks for looking at this.

For arch specific policies, kernel signature verification is enabled 
based on the secure boot state of the system. Perhaps, enforce the 
appraisal as well based on if secure boot is enabled.

Thanks & Regards,

     - Nayna

