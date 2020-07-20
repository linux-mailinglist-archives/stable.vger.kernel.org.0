Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DE02262A8
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 16:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGTO6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 10:58:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgGTO6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 10:58:25 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KEXt6l046593;
        Mon, 20 Jul 2020 10:58:18 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32dcyq93r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 10:58:18 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06KEYJap048848;
        Mon, 20 Jul 2020 10:58:17 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32dcyq93qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 10:58:17 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06KEjraO017836;
        Mon, 20 Jul 2020 14:58:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 32brq7tukj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 14:58:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06KEuvu627066708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 14:56:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD9F1A405F;
        Mon, 20 Jul 2020 14:56:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42802A405C;
        Mon, 20 Jul 2020 14:56:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.145.253])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jul 2020 14:56:56 +0000 (GMT)
Message-ID: <1595257015.5055.8.camel@linux.ibm.com>
Subject: Re: [PATCH v6] ima: move APPRAISE_BOOTPARAM dependency on
 ARCH_POLICY to runtime
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Nayna <nayna@linux.vnet.ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-integrity@vger.kernel.org
Cc:     erichte@linux.ibm.com, nayna@linux.ibm.com, stable@vger.kernel.org
Date:   Mon, 20 Jul 2020 10:56:55 -0400
In-Reply-To: <d337cbba-e996-e898-1e75-9f142d480e5e@linux.vnet.ibm.com>
References: <20200713164830.101165-1-bmeneg@redhat.com>
         <d337cbba-e996-e898-1e75-9f142d480e5e@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200099
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-07-20 at 10:40 -0400, Nayna wrote:
> On 7/13/20 12:48 PM, Bruno Meneguele wrote:
> > The IMA_APPRAISE_BOOTPARAM config allows enabling different "ima_appraise="
> > modes - log, fix, enforce - at run time, but not when IMA architecture
> > specific policies are enabled.  This prevents properly labeling the
> > filesystem on systems where secure boot is supported, but not enabled on the
> > platform.  Only when secure boot is actually enabled should these IMA
> > appraise modes be disabled.
> >
> > This patch removes the compile time dependency and makes it a runtime
> > decision, based on the secure boot state of that platform.
> >
> > Test results as follows:
> >
> > -> x86-64 with secure boot enabled
> >
> > [    0.015637] Kernel command line: <...> ima_policy=appraise_tcb ima_appraise=fix
> > [    0.015668] ima: Secure boot enabled: ignoring ima_appraise=fix boot parameter option
> >

Is it common to have two colons in the same line?  Is the colon being
used as a delimiter when parsing the kernel logs?  Should the second
colon be replaced with a hyphen?  (No need to repost.  I'll fix it
up.)
 

> > -> powerpc with secure boot disabled
> >
> > [    0.000000] Kernel command line: <...> ima_policy=appraise_tcb ima_appraise=fix
> > [    0.000000] Secure boot mode disabled
> >
> > -> Running the system without secure boot and with both options set:
> >
> > CONFIG_IMA_APPRAISE_BOOTPARAM=y
> > CONFIG_IMA_ARCH_POLICY=y
> >
> > Audit prompts "missing-hash" but still allow execution and, consequently,
> > filesystem labeling:
> >
> > type=INTEGRITY_DATA msg=audit(07/09/2020 12:30:27.778:1691) : pid=4976
> > uid=root auid=root ses=2
> > subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 op=appraise_data
> > cause=missing-hash comm=bash name=/usr/bin/evmctl dev="dm-0" ino=493150
> > res=no
> >
> > Cc: stable@vger.kernel.org
> > Fixes: d958083a8f64 ("x86/ima: define arch_get_ima_policy() for x86")
> > Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
> 
> 
> Reviewed-by: Nayna Jain<nayna@linux.ibm.com>
> Tested-by: Nayna Jain<nayna@linux.ibm.com>

Thanks, Nayna.

Mimi

