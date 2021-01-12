Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797832F3644
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 17:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbhALQ5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 11:57:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726113AbhALQ5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 11:57:39 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CGondv007647;
        Tue, 12 Jan 2021 11:56:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=b+ac3jeEv5SLCCdbpBji9elosV82TGVn32zwP4hDzSY=;
 b=RNIvnFpRKlohMJ4s8AL6Ogq6JrxhfAkmR8m6ZYvO0yUZYgiU9awhem5oJqAwly7jDsTU
 4TXuuWdEPD05dTISvYAkEPTopiQsqwFn6HmEeK6oe8DA+2VwqTMZXfwnlQso8CitOxKa
 C5e6tu6GTCt62OZEN6VyQNT/iiscfWaKoC2E4JCt1fY1yIdOqm4iJmzGvXO5xpDGQk+K
 25rQ4MD81yKnV24PuqVq4BcnsNw22rIlTgU5EVsAnvT3YeN6/q8NR93C41kiNXuqffq9
 TfJUCf4OM7OFj465RyZRsmwGhm0brHLeM24Y+z8ZtNljM7ZqCGRM83+egn6fKYW30YyR yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361fn883cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 11:56:56 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CGpaWp012126;
        Tue, 12 Jan 2021 11:56:54 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361fn883bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 11:56:53 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CGuptv018744;
        Tue, 12 Jan 2021 16:56:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 35y447uwfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 16:56:51 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CGuiI629032802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 16:56:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 134FB4C044;
        Tue, 12 Jan 2021 16:56:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1A1E4C04E;
        Tue, 12 Jan 2021 16:56:46 +0000 (GMT)
Received: from sig-9-65-221-171.ibm.com (unknown [9.65.221.171])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 16:56:46 +0000 (GMT)
Message-ID: <3a163a1839ff469acfa8dbb889c1b0889ec771bc.camel@linux.ibm.com>
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with
 kernel measurements
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Tyler Hicks <tyhicks@linux.microsoft.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date:   Tue, 12 Jan 2021 11:56:45 -0500
In-Reply-To: <20210112153534.GA4146@sequoia>
References: <20200708154116.3199728-1-sashal@kernel.org>
         <20200708154116.3199728-3-sashal@kernel.org>
         <1594224793.23056.251.camel@linux.ibm.com>
         <20200709012735.GX2722994@sasha-vm>
         <5b8dcdaf66fbe2a39631833b03772a11613fbbbf.camel@linux.ibm.com>
         <20201211031008.GN489768@sequoia>
         <659c09673affe9637a5d1391c12af3aa710ba78a.camel@linux.ibm.com>
         <20201214164222.GK4951@sequoia> <20210112153534.GA4146@sequoia>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1031
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120095
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tyler,

On Tue, 2021-01-12 at 09:35 -0600, Tyler Hicks wrote:
> On 2020-12-14 10:42:24, Tyler Hicks wrote:
> > On 2020-12-11 06:01:54, Mimi Zohar wrote:
> > > On Thu, 2020-12-10 at 21:10 -0600, Tyler Hicks wrote:
> > > > On 2020-11-29 08:17:38, Mimi Zohar wrote:
> > > > > Hi Sasha,
> > > > > 
> > > > > On Wed, 2020-07-08 at 21:27 -0400, Sasha Levin wrote:
> > > > > > On Wed, Jul 08, 2020 at 12:13:13PM -0400, Mimi Zohar wrote:
> > > > > > >Hi Sasha,
> > > > > > >
> > > > > > >On Wed, 2020-07-08 at 11:40 -0400, Sasha Levin wrote:
> > > > > > >> From: Maurizio Drocco <maurizio.drocco@ibm.com>
> > > > > > >>
> > > > > > >> [ Upstream commit 20c59ce010f84300f6c655d32db2610d3433f85c ]
> > > > > > >>
> > > > > > >> Registers 8-9 are used to store measurements of the kernel and its
> > > > > > >> command line (e.g., grub2 bootloader with tpm module enabled). IMA
> > > > > > >> should include them in the boot aggregate. Registers 8-9 should be
> > > > > > >> only included in non-SHA1 digests to avoid ambiguity.
> > > > > > >
> > > > > > >Prior to Linux 5.8, the SHA1 template data hashes were padded before
> > > > > > >being extended into the TPM.  Support for calculating and extending
> > > > > > >the per TPM bank template data digests is only being upstreamed in
> > > > > > >Linux 5.8.
> > > > > > >
> > > > > > >How will attestation servers know whether to include PCRs 8 & 9 in the
> > > > > > >the boot_aggregate calculation?  Now, there is a direct relationship
> > > > > > >between the template data SHA1 padded digest not including PCRs 8 & 9,
> > > > > > >and the new per TPM bank template data digest including them.
> > > > > > 
> > > > > > Got it, I'll drop it then, thank you!
> > > > > 
> > > > > After re-thinking this over, I realized that the attestation server can
> > > > > verify the "boot_aggregate" based on the quoted PCRs without knowing
> > > > > whether padded SHA1 hashes or per TPM bank hash values were extended
> > > > > into the TPM[1], but non-SHA1 boot aggregate values [2] should always
> > > > > include PCRs 8 & 9.
> > > > 
> > > > I'm still not clear on how an attestation server would know to include
> > > > PCRs 8 and 9 after this change came through a stable kernel update. It
> > > > doesn't seem like something appropriate for stable since it requires
> > > > code changes to attestation servers to handle the change.
> > > > 
> > > > I know this has already been released in some stable releases, so I'm
> > > > too late, but perhaps I'm missing something.
> > > 
> > > The point of adding PCRs 8 & 9 only to non-SHA1 boot_aggregate values
> > > was to avoid affecting existing attestation servers.  The intention was
> > > when attestation servers added support for the non-sha1 boot_aggregate
> > > values, they'd also include PCRs 8 & 9.  The existing SHA1
> > > boot_aggregate value remains PCRs 0 - 7.
> > 
> > AFAIK, there's nothing that prevents the non-SHA1 TPM 2.0 PCR banks from
> > being used even before v5.8, albeit with zero padded SHA1 digests.
> > Existing attestation servers that already support that configuration are
> > broken by this stable backport.

> To wrap up this thread, I think the last thing to address is if this
> commit should be reverted from stable kernels? Do you have any thoughts
> about that, Mimi?
> 
> > 
> > > To prevent this or something similar from happening again, what should
> > > have been the proper way of including PCRs 8 & 9?
> > 
> > I don't think that commits like 6f1a1d103b48 ("ima: Switch to
> > ima_hash_algo for boot aggregate") and 20c59ce010f8 ("ima: extend
> > boot_aggregate with kernel measurements") should be backported to
> > stable.
> > 
> > Including PCRs 8 and 9 definitely makes sense to include in the
> > boot_aggregate value but limiting such a change to "starting in 5.8",
> > rather than "starting in 5.8 and 5.4.82", is the safer approach when
> > attestation server modifications are required.

As I recall, commit 6f1a1d103b48 ("ima: Switch to ima_hash_algo for
boot aggregate") was backported to address TPMs without SHA1 support,
as reported by Jerry.

Mimi




