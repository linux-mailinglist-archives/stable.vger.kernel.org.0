Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111842C95A2
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 04:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgLADNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 22:13:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727175AbgLADNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 22:13:52 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B12XWtF006157;
        Mon, 30 Nov 2020 22:13:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=U+7tVdah5JE6eK79o/rDLnBG1iVAJhi1zZFFZuJdUoI=;
 b=nJvsqH/TBLc+bfD1FJgxehzybeOIXPaKrq7a42pLx4ToFJ+W0ltWoE6G5fHz8zZ7k6Uh
 flkPpUj4T/X/eyZT5svj7nBDHW6ET1rdntb6xdahghiKyDh2flaa7ipY9hj85H+OnvLA
 g5CklXIyalVuask+cUVtnLXsJ2TSfsNBczntIEI8LkjlyMkT2vWlWvtlFFp1lgrDaw1K
 f616rQcwyb5+BQELArp+dStxd7o4Y794OrbKx/tBVWkIY/wq+xsEKm/vKywV/pJkeWfH
 t8tvmQHp0nkYZpl6g/NQcjhGKTJ6BoOydbKRl4sUQGTqHuAYVEQSrUQ8OEET7k+LddgD BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355d210yx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 22:13:10 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B131ljO121314;
        Mon, 30 Nov 2020 22:13:10 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355d210ywd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 22:13:10 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B138TBH028584;
        Tue, 1 Dec 2020 03:13:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 354fpd9df5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 03:13:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B13D5re45809934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 03:13:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95D02A4057;
        Tue,  1 Dec 2020 03:13:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 189E8A4051;
        Tue,  1 Dec 2020 03:13:04 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.59.46])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 03:13:03 +0000 (GMT)
Message-ID: <02e53ce5fc00a2eaff3cace9c94b8b375dc580ef.camel@linux.ibm.com>
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with
 kernel measurements
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date:   Mon, 30 Nov 2020 22:13:02 -0500
In-Reply-To: <20201201002157.GT643756@sasha-vm>
References: <20200708154116.3199728-1-sashal@kernel.org>
         <20200708154116.3199728-3-sashal@kernel.org>
         <1594224793.23056.251.camel@linux.ibm.com>
         <20200709012735.GX2722994@sasha-vm>
         <5b8dcdaf66fbe2a39631833b03772a11613fbbbf.camel@linux.ibm.com>
         <20201201002157.GT643756@sasha-vm>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1031 malwarescore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010015
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-11-30 at 19:21 -0500, Sasha Levin wrote:
> On Sun, Nov 29, 2020 at 08:17:38AM -0500, Mimi Zohar wrote:
> >Hi Sasha,
> >
> >On Wed, 2020-07-08 at 21:27 -0400, Sasha Levin wrote:
> >> On Wed, Jul 08, 2020 at 12:13:13PM -0400, Mimi Zohar wrote:
> >> >Hi Sasha,
> >> >
> >> >On Wed, 2020-07-08 at 11:40 -0400, Sasha Levin wrote:
> >> >> From: Maurizio Drocco <maurizio.drocco@ibm.com>
> >> >>
> >> >> [ Upstream commit 20c59ce010f84300f6c655d32db2610d3433f85c ]
> >> >>
> >> >> Registers 8-9 are used to store measurements of the kernel and its
> >> >> command line (e.g., grub2 bootloader with tpm module enabled). IMA
> >> >> should include them in the boot aggregate. Registers 8-9 should be
> >> >> only included in non-SHA1 digests to avoid ambiguity.
> >> >
> >> >Prior to Linux 5.8, the SHA1 template data hashes were padded before
> >> >being extended into the TPM.  Support for calculating and extending
> >> >the per TPM bank template data digests is only being upstreamed in
> >> >Linux 5.8.
> >> >
> >> >How will attestation servers know whether to include PCRs 8 & 9 in the
> >> >the boot_aggregate calculation?  Now, there is a direct relationship
> >> >between the template data SHA1 padded digest not including PCRs 8 & 9,
> >> >and the new per TPM bank template data digest including them.
> >>
> >> Got it, I'll drop it then, thank you!
> >
> >After re-thinking this over, I realized that the attestation server can
> >verify the "boot_aggregate" based on the quoted PCRs without knowing
> >whether padded SHA1 hashes or per TPM bank hash values were extended
> >into the TPM[1], but non-SHA1 boot aggregate values [2] should always
> >include PCRs 8 & 9.
> >
> >Any place commit 6f1a1d103b48 was backported [2], this commit
> >20c59ce010f8 ("ima: extend boot_aggregate with kernel measurements")
> >should be backported as well.
> 
> Which kernels should it apply to? 5.7 is EOL now, so I looked at 5.4 but
> it doesn't apply cleanly there.

For 5.4, both "git cherry-pick" and "git am --3way" for 20c59ce010f8
seem to work.

thanks,

Mimi

