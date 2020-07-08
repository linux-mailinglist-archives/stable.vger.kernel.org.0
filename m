Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D9B218CB0
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 18:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgGHQNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 12:13:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43820 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728148AbgGHQNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 12:13:21 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068G1smT029292;
        Wed, 8 Jul 2020 12:13:19 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325h8kggm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 12:13:19 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 068G2P7X032157;
        Wed, 8 Jul 2020 12:13:18 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325h8kggka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 12:13:18 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 068GAtpv010405;
        Wed, 8 Jul 2020 16:13:17 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 322hd7vrdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 16:13:17 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 068GDEqx196934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jul 2020 16:13:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC23DAE05A;
        Wed,  8 Jul 2020 16:13:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1589AE058;
        Wed,  8 Jul 2020 16:13:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.202.84])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jul 2020 16:13:13 +0000 (GMT)
Message-ID: <1594224793.23056.251.camel@linux.ibm.com>
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with
 kernel measurements
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date:   Wed, 08 Jul 2020 12:13:13 -0400
In-Reply-To: <20200708154116.3199728-3-sashal@kernel.org>
References: <20200708154116.3199728-1-sashal@kernel.org>
         <20200708154116.3199728-3-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_13:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1031
 cotscore=-2147483648 bulkscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007080106
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Wed, 2020-07-08 at 11:40 -0400, Sasha Levin wrote:
> From: Maurizio Drocco <maurizio.drocco@ibm.com>
> 
> [ Upstream commit 20c59ce010f84300f6c655d32db2610d3433f85c ]
> 
> Registers 8-9 are used to store measurements of the kernel and its
> command line (e.g., grub2 bootloader with tpm module enabled). IMA
> should include them in the boot aggregate. Registers 8-9 should be
> only included in non-SHA1 digests to avoid ambiguity.

Prior to Linux 5.8, the SHA1 template data hashes were padded before
being extended into the TPM.  Support for calculating and extending
the per TPM bank template data digests is only being upstreamed in
Linux 5.8.

How will attestation servers know whether to include PCRs 8 & 9 in the
the boot_aggregate calculation?  Now, there is a direct relationship
between the template data SHA1 padded digest not including PCRs 8 & 9,
and the new per TPM bank template data digest including them.

Mimi
