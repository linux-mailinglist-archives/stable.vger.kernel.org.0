Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235BB25AA6C
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 13:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIBLmZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 2 Sep 2020 07:42:25 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2734 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgIBLmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 07:42:25 -0400
Received: from lhreml704-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id B8F9D176BA1B83CC7429;
        Wed,  2 Sep 2020 12:42:20 +0100 (IST)
Received: from fraeml705-chm.china.huawei.com (10.206.15.54) by
 lhreml704-chm.china.huawei.com (10.201.108.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 2 Sep 2020 12:42:20 +0100
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 2 Sep 2020 13:42:19 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Wed, 2 Sep 2020 13:42:19 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        "mjg59@google.com" <mjg59@google.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>
Subject: RE: [PATCH 01/11] evm: Execute evm_inode_init_security() only when
 the HMAC key is loaded
Thread-Topic: [PATCH 01/11] evm: Execute evm_inode_init_security() only when
 the HMAC key is loaded
Thread-Index: AQHWRYobDbVZBK0ooUeUmv97U2KzFqlDJY2AgASqawCADd9g0A==
Date:   Wed, 2 Sep 2020 11:42:19 +0000
Message-ID: <5404e618f79b4914b45c1d19791f470b@huawei.com>
References: <20200618160133.937-1-roberto.sassu@huawei.com>
         <2b204e31d21e93c0167d154c2397cd5d11be6e7f.camel@linux.ibm.com>
 <d4c9d5333256b17acdbe41729dd680f534266130.camel@linux.ibm.com>
In-Reply-To: <d4c9d5333256b17acdbe41729dd680f534266130.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.203.41]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> Sent: Monday, August 24, 2020 7:45 PM
> Hi Roberto,
> 
> On Fri, 2020-08-21 at 14:30 -0400, Mimi Zohar wrote:
> > Sorry for the delay in reviewing these patches.   Missing from this
> > patch set is a cover letter with an explanation for grouping these
> > patches into a patch set, other than for convenience.  In this case, it
> > would be along the lines that the original use case for EVM portable
> > and immutable keys support was for a few critical files, not combined
> > with an EVM encrypted key type.   This patch set more fully integrates
> > the initial EVM portable and immutable signature support.
> 
> Thank you for more fully integrating the EVM portable signatures into
> IMA.
> 
> " [PATCH 08/11] ima: Allow imasig requirement to be satisfied by EVM
> portable signatures" equates an IMA signature to having a portable and
> immutable EVM signature.  That is true in terms of signature
> verification, but from an attestation perspective the "ima-sig"
> template will not contain a signature.  If not the EVM signature, then
> at least some other indication should be included in the measurement
> list.

Would it be ok to print the EVM portable signature in the sig field if the IMA
signature is not found? Later we can introduce the new template evm-sig
to include all metadata necessary to verify the EVM portable signature.

> Are you planning on posting the associated IMA/EVM regression tests?

I didn't have a look yet at the code. I will try to write some later.

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Li Jian, Shi Yanli
