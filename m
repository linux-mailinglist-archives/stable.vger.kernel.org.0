Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B272B2D7474
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 12:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389466AbgLKLC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 06:02:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389198AbgLKLCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 06:02:55 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BBB1uHl044220;
        Fri, 11 Dec 2020 06:02:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=2UWdtsIqmeTCpDTpXt5VueVpDBTzEi7aN1IYg6RDpdA=;
 b=ZOKHrGBDbNvIl0Sa1klVruC7a0MCf9kjMh++99ZBZ5L5XfT6V3K4F2QSU+nWWSMlDSr7
 ZWIyZjtshjuWtdXdbU+j+nXCq03eGQyfA2y0Ur10nKSEiPduD4td3TP1peYZEUUT9CkX
 DCD9B41g4oOcUxO4gMj8HEM9HCZBZga0esQirtU6fswHlUpOfe999SQmQu+qxREC71mG
 GbUIs9KjI5pjCBWGT+2t93Vm+clsjvkOZyHz73TgaWASR378gdV6yonj6br6G7dWZs3l
 c8ys5y5sYEVhuL3sfOFxES0xQGCIi7qiRcONlCIki/iolfTSsk6TRZmvmd8Ucks/9ifH Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6ka9mhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 06:02:12 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BBB2ALL045416;
        Fri, 11 Dec 2020 06:02:10 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6ka9mbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 06:02:10 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BBAvTb2000783;
        Fri, 11 Dec 2020 11:01:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u86wx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 11:01:59 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BBB1vvD29950354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 11:01:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E07B4A4062;
        Fri, 11 Dec 2020 11:01:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EE6DA4054;
        Fri, 11 Dec 2020 11:01:55 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.117.114])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Dec 2020 11:01:55 +0000 (GMT)
Message-ID: <659c09673affe9637a5d1391c12af3aa710ba78a.camel@linux.ibm.com>
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with
 kernel measurements
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Tyler Hicks <tyhicks@linux.microsoft.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date:   Fri, 11 Dec 2020 06:01:54 -0500
In-Reply-To: <20201211031008.GN489768@sequoia>
References: <20200708154116.3199728-1-sashal@kernel.org>
         <20200708154116.3199728-3-sashal@kernel.org>
         <1594224793.23056.251.camel@linux.ibm.com>
         <20200709012735.GX2722994@sasha-vm>
         <5b8dcdaf66fbe2a39631833b03772a11613fbbbf.camel@linux.ibm.com>
         <20201211031008.GN489768@sequoia>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_01:2020-12-09,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 clxscore=1031 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110066
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-12-10 at 21:10 -0600, Tyler Hicks wrote:
> On 2020-11-29 08:17:38, Mimi Zohar wrote:
> > Hi Sasha,
> > 
> > On Wed, 2020-07-08 at 21:27 -0400, Sasha Levin wrote:
> > > On Wed, Jul 08, 2020 at 12:13:13PM -0400, Mimi Zohar wrote:
> > > >Hi Sasha,
> > > >
> > > >On Wed, 2020-07-08 at 11:40 -0400, Sasha Levin wrote:
> > > >> From: Maurizio Drocco <maurizio.drocco@ibm.com>
> > > >>
> > > >> [ Upstream commit 20c59ce010f84300f6c655d32db2610d3433f85c ]
> > > >>
> > > >> Registers 8-9 are used to store measurements of the kernel and its
> > > >> command line (e.g., grub2 bootloader with tpm module enabled). IMA
> > > >> should include them in the boot aggregate. Registers 8-9 should be
> > > >> only included in non-SHA1 digests to avoid ambiguity.
> > > >
> > > >Prior to Linux 5.8, the SHA1 template data hashes were padded before
> > > >being extended into the TPM.  Support for calculating and extending
> > > >the per TPM bank template data digests is only being upstreamed in
> > > >Linux 5.8.
> > > >
> > > >How will attestation servers know whether to include PCRs 8 & 9 in the
> > > >the boot_aggregate calculation?  Now, there is a direct relationship
> > > >between the template data SHA1 padded digest not including PCRs 8 & 9,
> > > >and the new per TPM bank template data digest including them.
> > > 
> > > Got it, I'll drop it then, thank you!
> > 
> > After re-thinking this over, I realized that the attestation server can
> > verify the "boot_aggregate" based on the quoted PCRs without knowing
> > whether padded SHA1 hashes or per TPM bank hash values were extended
> > into the TPM[1], but non-SHA1 boot aggregate values [2] should always
> > include PCRs 8 & 9.
> 
> I'm still not clear on how an attestation server would know to include
> PCRs 8 and 9 after this change came through a stable kernel update. It
> doesn't seem like something appropriate for stable since it requires
> code changes to attestation servers to handle the change.
> 
> I know this has already been released in some stable releases, so I'm
> too late, but perhaps I'm missing something.

The point of adding PCRs 8 & 9 only to non-SHA1 boot_aggregate values
was to avoid affecting existing attestation servers.  The intention was
when attestation servers added support for the non-sha1 boot_aggregate
values, they'd also include PCRs 8 & 9.  The existing SHA1
boot_aggregate value remains PCRs 0 - 7.

To prevent this or something similar from happening again, what should
have been the proper way of including PCRs 8 & 9?

thanks,

Mimi

