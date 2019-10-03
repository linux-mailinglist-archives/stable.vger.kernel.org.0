Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFBBFCB1C4
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 00:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbfJCWIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 18:08:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22474 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728564AbfJCWIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 18:08:21 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x93M6vwJ089282
        for <stable@vger.kernel.org>; Thu, 3 Oct 2019 18:08:20 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vdqd2c542-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 18:08:20 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Thu, 3 Oct 2019 23:08:18 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 3 Oct 2019 23:08:14 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x93M8EWs54919378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Oct 2019 22:08:14 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8611A4051;
        Thu,  3 Oct 2019 22:08:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64297A4040;
        Thu,  3 Oct 2019 22:08:12 +0000 (GMT)
Received: from dhcp-9-31-103-196.watson.ibm.com (unknown [9.31.103.196])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Oct 2019 22:08:12 +0000 (GMT)
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     David Safford <david.safford@ge.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 03 Oct 2019 18:08:11 -0400
In-Reply-To: <20191003215743.GB30511@linux.intel.com>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
         <1570024819.4999.119.camel@linux.ibm.com>
         <20191003114119.GF8933@linux.intel.com>
         <1570107752.4421.183.camel@linux.ibm.com>
         <20191003175854.GB19679@linux.intel.com>
         <1570128827.5046.19.camel@linux.ibm.com>
         <20191003215125.GA30511@linux.intel.com>
         <20191003215743.GB30511@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19100322-0016-0000-0000-000002B3CD22
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100322-0017-0000-0000-00003314D99D
Message-Id: <1570140491.5046.33.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-03_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=640 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910030179
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-10-04 at 00:57 +0300, Jarkko Sakkinen wrote:
> On Fri, Oct 04, 2019 at 12:51:25AM +0300, Jarkko Sakkinen wrote:
> > On Thu, Oct 03, 2019 at 02:53:47PM -0400, Mimi Zohar wrote:
> > > [Cc'ing David Safford]
> > > 
> > > On Thu, 2019-10-03 at 20:58 +0300, Jarkko Sakkinen wrote:
> > > > On Thu, Oct 03, 2019 at 09:02:32AM -0400, Mimi Zohar wrote:
> > > > > On Thu, 2019-10-03 at 14:41 +0300, Jarkko Sakkinen wrote:
> > > > > > On Wed, Oct 02, 2019 at 10:00:19AM -0400, Mimi Zohar wrote:
> > > > > > > On Thu, 2019-09-26 at 20:16 +0300, Jarkko Sakkinen wrote:
> > > > > > > > Only the kernel random pool should be used for generating random numbers.
> > > > > > > > TPM contributes to that pool among the other sources of entropy. In here it
> > > > > > > > is not, agreed, absolutely critical because TPM is what is trusted anyway
> > > > > > > > but in order to remove tpm_get_random() we need to first remove all the
> > > > > > > > call sites.
> > > > > > > 
> > > > > > > At what point during boot is the kernel random pool available?  Does
> > > > > > > this imply that you're planning on changing trusted keys as well?
> > > > > > 
> > > > > > Well trusted keys *must* be changed to use it. It is not a choice
> > > > > > because using a proprietary random number generator instead of defacto
> > > > > > one in the kernel can be categorized as a *regression*.
> > > > > 
> > > > > I really don't see how using the TPM random number for TPM trusted
> > > > > keys would be considered a regression.  That by definition is a
> > > > > trusted key.  If anything, changing what is currently being done would
> > > > > be the regression. 
> > > > 
> > > > It is really not a TPM trusted key. It trusted key that gets sealed with
> > > > the TPM. The key itself is used in clear by kernel. The random number
> > > > generator exists in the kernel to for a reason.
> > > > 
> > > > It is without doubt a regression.
> > > 
> > > You're misusing the term "regression" here.  A regression is something
> > > that previously worked and has stopped working.  In this case, trusted
> > > keys has always been based on the TPM random number generator.  Before
> > > changing this, there needs to be some guarantees that the kernel
> > > random number generator has a pool of random numbers early, on all
> > > systems including embedded devices, not just servers.
> > 
> > I'm not using the term regression incorrectly here. Wrong function
> > was used to generate random numbers for the payload here. It is an
> > obvious bug.
> 
> At the time when trusted keys was introduced I'd say that it was a wrong
> design decision and badly implemented code. But you are right in that as
> far that code is considered it would unfair to speak of a regression.
> 
> asym-tpm.c on the other hand this is fresh new code. There has been
> *countless* of discussions over the years that random numbers should
> come from multiple sources of entropy. There is no other categorization
> than a bug for the tpm_get_random() there.

This week's LWN article on "5.4 Merge window, part 2" discusses "boot-
time entropy".  This article couldn't have been more perfectly timed.

Mimi

