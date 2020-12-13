Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCD52D8AE8
	for <lists+stable@lfdr.de>; Sun, 13 Dec 2020 03:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgLMCXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 21:23:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52672 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgLMCXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Dec 2020 21:23:11 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BD22bPD077188;
        Sat, 12 Dec 2020 21:22:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=tWY3YF6DA1XcS3oAelvBMQoR9dB9l5Yj7c/3IydIsls=;
 b=I/U4eHYYfTvpzpC6xLaC3XdV19Nc1FBK5nkbQz0TRRjCZfU/7+D1gKBJjvtsDqMTGfbU
 WV79Uo54V4wRYGrq1GMcm2tQ+vWOIdAPAhTY8BijDHYtlZd83BWmoNHcU9UC0XWhxLmS
 12dlZ8pNsNkmopzBH6t4dX6mTKBkmH7VPDujK4pnjBeX0Pet76TYMO7+QTOzg3TPmu4H
 v1ASzoFim114aV+cE5f0L+3gcngLvPTyzgvCsTDXwGhjYUFTJfIgW7rD/nFIrFanx1+v
 yrC8F4Eu1Ha4j9/iOA/nI/vwFCkMpHwwHSN0ugT2A7laRvnDC0A8a5+4MiXVFLAlLoei rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35d9hmrk7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 12 Dec 2020 21:22:25 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BD23QJx078887;
        Sat, 12 Dec 2020 21:22:25 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35d9hmrk74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 12 Dec 2020 21:22:24 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BD2Cfsn029791;
        Sun, 13 Dec 2020 02:22:22 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 35cng89657-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Dec 2020 02:22:22 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BD2MK1l31064462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 02:22:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77FB6AE051;
        Sun, 13 Dec 2020 02:22:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7803DAE057;
        Sun, 13 Dec 2020 02:22:18 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.98.152])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 13 Dec 2020 02:22:18 +0000 (GMT)
Message-ID: <05266e520f62276b07e76aab177ea6db47916a7f.camel@linux.ibm.com>
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with
 kernel measurements
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date:   Sat, 12 Dec 2020 21:22:17 -0500
In-Reply-To: <76710d8ec58c440ed7a7b446696b8659f694d0db.camel@HansenPartnership.com>
References: <20200708154116.3199728-1-sashal@kernel.org>
         <20200708154116.3199728-3-sashal@kernel.org>
         <1594224793.23056.251.camel@linux.ibm.com>
         <20200709012735.GX2722994@sasha-vm>
         <5b8dcdaf66fbe2a39631833b03772a11613fbbbf.camel@linux.ibm.com>
         <20201211031008.GN489768@sequoia>
         <659c09673affe9637a5d1391c12af3aa710ba78a.camel@linux.ibm.com>
         <76710d8ec58c440ed7a7b446696b8659f694d0db.camel@HansenPartnership.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-12_12:2020-12-11,2020-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 impostorscore=0 clxscore=1031 bulkscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012130011
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-12-11 at 09:46 -0800, James Bottomley wrote:
> On Fri, 2020-12-11 at 06:01 -0500, Mimi Zohar wrote:
> > On Thu, 2020-12-10 at 21:10 -0600, Tyler Hicks wrote:
> > > On 2020-11-29 08:17:38, Mimi Zohar wrote:
> > > > Hi Sasha,
> > > > 
> > > > On Wed, 2020-07-08 at 21:27 -0400, Sasha Levin wrote:
> > > > > On Wed, Jul 08, 2020 at 12:13:13PM -0400, Mimi Zohar wrote:
> > > > > > Hi Sasha,
> > > > > > 
> > > > > > On Wed, 2020-07-08 at 11:40 -0400, Sasha Levin wrote:
> > > > > > > From: Maurizio Drocco <maurizio.drocco@ibm.com>
> > > > > > > 
> > > > > > > [ Upstream commit 20c59ce010f84300f6c655d32db2610d3433f85c
> > > > > > > ]
> > > > > > > 
> > > > > > > Registers 8-9 are used to store measurements of the kernel
> > > > > > > and its command line (e.g., grub2 bootloader with tpm
> > > > > > > module enabled). IMA should include them in the boot
> > > > > > > aggregate. Registers 8-9 should be only included in non-
> > > > > > > SHA1 digests to avoid ambiguity.
> > > > > > 
> > > > > > Prior to Linux 5.8, the SHA1 template data hashes were padded
> > > > > > before being extended into the TPM.  Support for calculating
> > > > > > and extending the per TPM bank template data digests is only
> > > > > > being upstreamed in Linux 5.8.
> > > > > > 
> > > > > > How will attestation servers know whether to include PCRs 8 &
> > > > > > 9 in the the boot_aggregate calculation?  Now, there is a
> > > > > > direct relationship between the template data SHA1 padded
> > > > > > digest not including PCRs 8 & 9, and the new per TPM bank
> > > > > > template data digest including them.
> > > > > 
> > > > > Got it, I'll drop it then, thank you!
> > > > 
> > > > After re-thinking this over, I realized that the attestation
> > > > server can verify the "boot_aggregate" based on the quoted PCRs
> > > > without knowing whether padded SHA1 hashes or per TPM bank hash
> > > > values were extended into the TPM[1], but non-SHA1 boot aggregate
> > > > values [2] should always include PCRs 8 & 9.
> > > 
> > > I'm still not clear on how an attestation server would know to
> > > include PCRs 8 and 9 after this change came through a stable kernel
> > > update. It doesn't seem like something appropriate for stable since
> > > it requires code changes to attestation servers to handle the
> > > change.
> > > 
> > > I know this has already been released in some stable releases, so
> > > I'm too late, but perhaps I'm missing something.
> > 
> > The point of adding PCRs 8 & 9 only to non-SHA1 boot_aggregate values
> > was to avoid affecting existing attestation servers.  The intention
> > was when attestation servers added support for the non-sha1
> > boot_aggregate values, they'd also include PCRs 8 & 9.  The existing
> > SHA1 boot_aggregate value remains PCRs 0 - 7.
> > 
> > To prevent this or something similar from happening again, what
> > should have been the proper way of including PCRs 8 & 9?
> 
> Just to be pragmatic: this is going to happen again.  Shim is already
> measuring the Mok variables through PCR 14, so if we want an accurate
> boot aggregate, we're going to have to include PCR 14 as well (or
> persuade shim to measure through a PCR we're already including, which
> isn't impossible since I think shim should be measuring the Mok
> variables using the EV_EFI_VARIABLE_DRIVER_CONFIG event and, since it
> affects secure boot policy, that does argue it should be measured
> through PCR 7).

Ok.   Going forward, it sounds like we need to define a new
"boot_aggregate" record.  One that contains a version number and PCR
mask.

Mimi

