Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83471CC3D3
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 21:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730968AbfJDT4I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 4 Oct 2019 15:56:08 -0400
Received: from mx0a-00176a03.pphosted.com ([67.231.149.52]:53736 "EHLO
        mx0a-00176a03.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730836AbfJDT4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 15:56:08 -0400
Received: from pps.filterd (m0047962.ppops.net [127.0.0.1])
        by m0047962.ppops.net-00176a03. (8.16.0.42/8.16.0.42) with SMTP id x94JsTeF011265;
        Fri, 4 Oct 2019 15:56:07 -0400
From:   "Safford, David (GE Global Research, US)" <david.safford@ge.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     Mimi Zohar <zohar@linux.ibm.com>,
        "Wiseman, Monty (GE Global Research, US)" <monty.wiseman@ge.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Thread-Topic: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Thread-Index: AQHVdI4g9L3xPAeMJki3mq4fpV79C6dHrWSAgAFrf4CAABaxAIAAUs4AgAAPVoCAAOxxAIAAnnWA///LRNA=
Date:   Fri, 4 Oct 2019 19:56:01 +0000
Message-ID: <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
 <1570024819.4999.119.camel@linux.ibm.com>
 <20191003114119.GF8933@linux.intel.com>
 <1570107752.4421.183.camel@linux.ibm.com>
 <20191003175854.GB19679@linux.intel.com>
 <1570128827.5046.19.camel@linux.ibm.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
 <20191004182711.GC6945@linux.intel.com>
In-Reply-To: <20191004182711.GC6945@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcMjEyNDczOTUw?=
 =?us-ascii?Q?XGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0?=
 =?us-ascii?Q?YmEyOWUzNWJcbXNnc1xtc2ctZmM1ZWJkODctZTZlMC0xMWU5LThlNWMtYTRj?=
 =?us-ascii?Q?M2YwYjU5OGE2XGFtZS10ZXN0XGZjNWViZDg5LWU2ZTAtMTFlOS04ZTVjLWE0?=
 =?us-ascii?Q?YzNmMGI1OThhNmJvZHkudHh0IiBzej0iMTkzMSIgdD0iMTMyMTQ2OTI1NjAy?=
 =?us-ascii?Q?OTY5NzY4IiBoPSJJb1M3U21NaU54OWR1V0xqclpiM1c5a2d5YUU9IiBpZD0i?=
 =?us-ascii?Q?IiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFFb0NB?=
 =?us-ascii?Q?QUNvbUxtKzdYclZBYnV1SzdTSmoxQmZ1NjRydEltUFVGOERBQUFBQUFBQUFB?=
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
x-originating-ip: [3.159.19.191]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Subject: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-04_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040163
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> From: linux-integrity-owner@vger.kernel.org <linux-integrity-
> owner@vger.kernel.org> On Behalf Of Jarkko Sakkinen
> Sent: Friday, October 4, 2019 2:27 PM
> Subject: EXT: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
> 
> If you are able to call tpm_get_random(), the driver has already registered
> TPN as hwrng. With this solution you fail to follow the principle of defense in
> depth. If the TPM random number generator is compromissed (has a bug)
> using the entropy pool will decrease the collateral damage.

And if the entropy pool has a bug or is misconfigured, you lose everything.
That does not sound like defense in depth to me. In the real world
I am not aware of a single instance of RNG vulnerability on a TPM.
I am directly aware of several published vulnerabilities in embedded systems 
due to a badly ported version of the kernel random pool. In addition, 
the random generator in a TPM is hardware isolated, and less likely to be
vulnerable to side channel or memory manipulation errors. The TPM
RNG is typically FIPS certified.  The use of the TPM RNG was a deliberate
design choice in trusted keys.

> > Third, as Mimi states, using a TPM is not a "regression". It would be
> > a regression to change trusted keys _not_ to use the TPM, because that
> > is what trusted keys are documented to provide to user space.
> 
> For asym-tpm.c it is without a question a regression because of the evolution
> that has happened after trusted keys. For trusted keys using kernel rng
> would be improvement.

Perhaps this is a language issue, but you are not using "regression" correctly.
Changing to the kernel pool would not only be a debatable  "improvement", 
but also would certainly be a change to the documented trusted key  
behavior, which I thought was frowned upon.

dave
