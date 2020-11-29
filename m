Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCE52C7965
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 14:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgK2NSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 08:18:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727073AbgK2NSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Nov 2020 08:18:30 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ATD2Yb7009442;
        Sun, 29 Nov 2020 08:17:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=RET6IEGV68d1uV4rz0SlQt3ZjlfobHeZrj6jvGCfiKE=;
 b=W40tMc3Qrq+LHzjaQ3hAZ+7kBNUWb98bsvqczXv4rmBCigQfNLpxlccYYtNdgR7uB2+c
 7DgpZp9Xe7FSFiynXiTjOgHR0HBnFQECcXX4SdCd24kiiuO7dVOTuXWOGAGaOZVI5O2p
 5Gb3VoQLQT6lh77aDjb6fwe5Ib1uOEjSJT/dBXUIaNykHGpHrU15/JLcxoOtwjDgvbxe
 dLqH6A3cT4nSORiSGfqdKIxmN8JzT56ZsMEyD/4qg96u0Jl55FnFJxSWGqpTcbfy70wz
 cSaAGY9sxNG1tqv272x5WbRsbffMf/1zTHPtRpBVG6PFySqH9T+y1Cs+ZwKlH6q6ZYbt 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3544deynbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Nov 2020 08:17:48 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ATD2cMb009724;
        Sun, 29 Nov 2020 08:17:47 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3544deyn7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Nov 2020 08:17:47 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ATDH1s5028058;
        Sun, 29 Nov 2020 13:17:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 353e688jvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Nov 2020 13:17:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ATDHeAC59441586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Nov 2020 13:17:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 889D811C04C;
        Sun, 29 Nov 2020 13:17:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E48011C04A;
        Sun, 29 Nov 2020 13:17:39 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.20.242])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 29 Nov 2020 13:17:38 +0000 (GMT)
Message-ID: <5b8dcdaf66fbe2a39631833b03772a11613fbbbf.camel@linux.ibm.com>
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with
 kernel measurements
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date:   Sun, 29 Nov 2020 08:17:38 -0500
In-Reply-To: <20200709012735.GX2722994@sasha-vm>
References: <20200708154116.3199728-1-sashal@kernel.org>
         <20200708154116.3199728-3-sashal@kernel.org>
         <1594224793.23056.251.camel@linux.ibm.com>
         <20200709012735.GX2722994@sasha-vm>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-29_07:2020-11-26,2020-11-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 clxscore=1031 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011290087
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Wed, 2020-07-08 at 21:27 -0400, Sasha Levin wrote:
> On Wed, Jul 08, 2020 at 12:13:13PM -0400, Mimi Zohar wrote:
> >Hi Sasha,
> >
> >On Wed, 2020-07-08 at 11:40 -0400, Sasha Levin wrote:
> >> From: Maurizio Drocco <maurizio.drocco@ibm.com>
> >>
> >> [ Upstream commit 20c59ce010f84300f6c655d32db2610d3433f85c ]
> >>
> >> Registers 8-9 are used to store measurements of the kernel and its
> >> command line (e.g., grub2 bootloader with tpm module enabled). IMA
> >> should include them in the boot aggregate. Registers 8-9 should be
> >> only included in non-SHA1 digests to avoid ambiguity.
> >
> >Prior to Linux 5.8, the SHA1 template data hashes were padded before
> >being extended into the TPM.  Support for calculating and extending
> >the per TPM bank template data digests is only being upstreamed in
> >Linux 5.8.
> >
> >How will attestation servers know whether to include PCRs 8 & 9 in the
> >the boot_aggregate calculation?  Now, there is a direct relationship
> >between the template data SHA1 padded digest not including PCRs 8 & 9,
> >and the new per TPM bank template data digest including them.
> 
> Got it, I'll drop it then, thank you!

After re-thinking this over, I realized that the attestation server can
verify the "boot_aggregate" based on the quoted PCRs without knowing
whether padded SHA1 hashes or per TPM bank hash values were extended
into the TPM[1], but non-SHA1 boot aggregate values [2] should always
include PCRs 8 & 9.

Any place commit 6f1a1d103b48 was backported [2], this commit
20c59ce010f8 ("ima: extend boot_aggregate with kernel measurements")
should be backported as well.

thanks,

Mimi

[1] commit 1ea973df6e21 ("ima: Calculate and extend PCR with digests in ima_template_entry")
[2] commit 6f1a1d103b48 ("ima: Switch to ima_hash_algo for boot aggregate")

