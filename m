Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3D7D0F88
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 15:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731355AbfJINDH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 9 Oct 2019 09:03:07 -0400
Received: from mx0b-00176a03.pphosted.com ([67.231.157.48]:41762 "EHLO
        mx0a-00176a03.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730901AbfJINDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 09:03:06 -0400
X-Greylist: delayed 3109 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Oct 2019 09:03:05 EDT
Received: from pps.filterd (m0048205.ppops.net [127.0.0.1])
        by m0048205.ppops.net-00176a03. (8.16.0.27/8.16.0.27) with SMTP id x99C9XgY029449;
        Wed, 9 Oct 2019 08:11:15 -0400
From:   "Safford, David (GE Global Research, US)" <david.safford@ge.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ken Goldman <kgold@linux.ibm.com>
CC:     Mimi Zohar <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Thread-Topic: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Thread-Index: AQHVdI4g9L3xPAeMJki3mq4fpV79C6dHrWSAgAFrf4CAABaxAIAAUs4AgAAPVoCAAOxxAIAAnnWA///LRNCAA7fgAIABcvOAgAGtUICAAAEjgIAAiUkQ
Date:   Wed, 9 Oct 2019 12:11:06 +0000
Message-ID: <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2B995@ALPMBAPA12.e2k.ad.ge.com>
References: <20191003114119.GF8933@linux.intel.com>
 <1570107752.4421.183.camel@linux.ibm.com>
 <20191003175854.GB19679@linux.intel.com>
 <1570128827.5046.19.camel@linux.ibm.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
 <20191004182711.GC6945@linux.intel.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
 <20191007000520.GA17116@linux.intel.com>
 <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
 <20191008234935.GA13926@linux.intel.com>
 <20191008235339.GB13926@linux.intel.com>
In-Reply-To: <20191008235339.GB13926@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcMjEyNDczOTUw?=
 =?us-ascii?Q?XGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0?=
 =?us-ascii?Q?YmEyOWUzNWJcbXNnc1xtc2ctZGRkMDhkMzItZWE4ZC0xMWU5LThlNjQtYTRj?=
 =?us-ascii?Q?M2YwYjU5OGE2XGFtZS10ZXN0XGRkZDA4ZDM0LWVhOGQtMTFlOS04ZTY0LWE0?=
 =?us-ascii?Q?YzNmMGI1OThhNmJvZHkudHh0IiBzej0iMjA5NSIgdD0iMTMyMTUwOTY2NjU0?=
 =?us-ascii?Q?NTEyMTE0IiBoPSJOeUxXaXhaaHFjUHNKaXhDWEppNWF4MkppRkE9IiBpZD0i?=
 =?us-ascii?Q?IiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFFb0NB?=
 =?us-ascii?Q?QUR5cXlxZ21uN1ZBZGZLMWFPdHBmaG4xOHJWbzYybCtHY0RBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBSEFBQUFEYUFRQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBUUFCQUFBQUZ0R2VRd0FBQUFBQUFBQUFBQUFBQUo0QUFBQm5BR1VB?=
 =?us-ascii?Q?WHdCakFHOEFiZ0JtQUdrQVpBQmxBRzRBZEFCcEFHRUFiQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdjQVpRQmZBR2dBYVFCbkFHZ0Fi?=
 =?us-ascii?Q?QUI1QUdNQWJ3QnVBR1lBYVFCa0FHVUFiZ0IwQUdrQVlRQnNBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNB?=
 =?us-ascii?Q?QUFBQUFDZUFBQUFad0JsQUY4QWJnQnZBRzRBY0FCMUFHSUFiQUJwQUdNQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9t?=
 =?us-ascii?Q?ZXRhPg=3D=3D?=
x-dg-rorf: 
x-originating-ip: [3.159.16.111]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Subject: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-09_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090115
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Sent: Tuesday, October 8, 2019 7:54 PM
> To: Ken Goldman <kgold@linux.ibm.com>
> Cc: Safford, David (GE Global Research, US) <david.safford@ge.com>; Mimi
> Zohar <zohar@linux.ibm.com>; linux-integrity@vger.kernel.org;
> stable@vger.kernel.org; open list:ASYMMETRIC KEYS
> <keyrings@vger.kernel.org>; open list:CRYPTO API <linux-
> crypto@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
> Subject: EXT: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
> 
> On Wed, Oct 09, 2019 at 02:49:35AM +0300, Jarkko Sakkinen wrote:
> > On Mon, Oct 07, 2019 at 06:13:01PM -0400, Ken Goldman wrote:
> > > The TPM library specification states that the TPM must comply with
> > > NIST
> > > SP800-90 A.
> > >
> > > https://trustedcomputinggroup.org/membership/certification/tpm-certi
> > > fied-products/
> > >
> > > shows that the TPMs get third party certification, Common Criteria EAL 4+.
> > >
> > > While it's theoretically possible that an attacker could compromise
> > > both the TPM vendors and the evaluation agencies, we do have EAL 4+
> > > assurance against both 1 and 2.
> >
> > Certifications do not equal to trust.
> 
> And for trusted keys the least trust solution is to do generation with the kernel
> assets and sealing with TPM. With TEE the least trust solution is equivalent.
> 
> Are you proposing that the kernel random number generation should be
> removed? That would be my conclusion of this discussion if I would agree any
> of this (I don't).
> 
> /Jarkko

No one is suggesting that.

You are suggesting changing the documented behavior of trusted keys, and
that would cause problems for some of our use cases. While certification
may not in your mind be equal to trust, it is equal to compliance with 
mandatory regulations.

Perhaps rather than arguing past each other, we should look into 
providing users the ability to choose, as an argument to keyctl?

dave
