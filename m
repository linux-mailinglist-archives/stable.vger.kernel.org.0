Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1A1D093F
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 10:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbfJIIJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 04:09:34 -0400
Received: from mail-eopbgr720045.outbound.protection.outlook.com ([40.107.72.45]:14560
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725903AbfJIIJe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 04:09:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtE4ekxl45xUqbMN0a1J1C2bW255M8nODDq5aYiZeF1BzIUO86UtosQl/HX/5uaw+VHtQ+n+KwedBCdFCUHIWrQSGk/+3sujRkcRn8ZxCRp1eRVW1NO+HSunH58g2U/VkUUwL2t3s8lIFzUBVPVRD1UVwvnAJ3ASmvE6Xa0p+cazZLxLHs4Tin87IgVpX6KCkl0rsR9w3l3fo77mwxVP34y1/2SQU04DNW/9KD8IAFDzBkFVceXOf/6rBwL/18FXQX/KPz55oGFzoF8hvgAwDE5JlMg5CGNs9yA/HwH8wmP4JGms4tKyt+w/+lmelelwwKFXoHvD38toS3503PrH7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIchv6O98zsBSO/0JaoImQzpBr2k+e7q2hQl4XIEtrQ=;
 b=GXnHr0bs1vHGSW0B4cQTs1v0SPonSdll3HpuUhoRXqsHY17Lcth3sDU3Xp/k21Zcq05TqXBcUIjZ7avAlyBNGUD+Nx6ufeAa2xH7NqE+LTfAbHduoQT0BrhvLOTP0VuzStI9PUhlgJ8rky4fSz26fUlTXcF0ZYd9k3yHZcHTCRILllam36WTW9iiZlx+dNK0zYKl8fjb9HHI/5iMx3NMz1zje3UF4LdPMbB0YOUSt4Mf8J6scOWEWEQCDSHJiLANIMAZNzw5itS6nCXulfCMIRwQLUWqEBeBkFwkAHkU11OpqZuDS+1V7AV5Lgd9ss36uVCNZ0VR/CJJTZkSAGlxhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIchv6O98zsBSO/0JaoImQzpBr2k+e7q2hQl4XIEtrQ=;
 b=SzgCp/oS9IeUvDcmUKAOIjrzLvntuz44EMIPljJVqjPJwQugU07+9moXz96SqtkFlPFCkzEFRB2wFreKcPhSU4LqLexhBcx36YbjVSC3MqmSwHO5j6nUHaEakA/1eFK9iBTjfgA7+0TvHEYkuRMYLV7P9jKOlRNMZ9wYYUGGsfY=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2974.namprd20.prod.outlook.com (52.132.172.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 08:09:29 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 08:09:29 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ken Goldman <kgold@linux.ibm.com>
CC:     "Safford, David (GE Global Research, US)" <david.safford@ge.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Thread-Topic: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Thread-Index: AQHVdI4da48CsX6QxkCmhP/96hjLv6dHalaAgAFrf4CAABaxAIAAUs4AgAAPVYCAATcGAIAAU+GAgAAY0oCAA2pSAIABcvOAgAGtUICAAAEjgIAAgGmAgAACUoCAAAYDIA==
Date:   Wed, 9 Oct 2019 08:09:29 +0000
Message-ID: <MN2PR20MB2973CDE87E4EC25CA21DD2C8CA950@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191003175854.GB19679@linux.intel.com>
 <1570128827.5046.19.camel@linux.ibm.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
 <20191004182711.GC6945@linux.intel.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
 <20191007000520.GA17116@linux.intel.com>
 <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
 <20191008234935.GA13926@linux.intel.com>
 <20191008235339.GB13926@linux.intel.com>
 <20191009073315.GA5884@linux.intel.com>
 <20191009074133.GA6202@linux.intel.com>
In-Reply-To: <20191009074133.GA6202@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 231a20d5-3448-4010-7c98-08d74c90025c
x-ms-traffictypediagnostic: MN2PR20MB2974:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB297431602F70410B492E50B1CA950@MN2PR20MB2974.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39850400004)(396003)(346002)(376002)(199004)(189003)(13464003)(54906003)(110136005)(99286004)(6436002)(74316002)(25786009)(305945005)(33656002)(55016002)(66066001)(6306002)(316002)(7736002)(102836004)(53546011)(76176011)(6506007)(7696005)(8936002)(86362001)(9686003)(229853002)(71200400001)(71190400001)(26005)(81156014)(14454004)(8676002)(81166006)(446003)(14444005)(4326008)(6246003)(76116006)(66556008)(256004)(478600001)(476003)(186003)(66476007)(66446008)(3846002)(66946007)(6116002)(52536014)(15974865002)(486006)(11346002)(2906002)(5660300002)(64756008)(966005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2974;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NR3B7ytvHNg7EqAW0FhGyGdlU7RGxtXmuYMlW8sQ3OTR0wrbDjaVDmmthhuXDIDX/FLT5CEUTvfxQbyoAu5T+F7XvBfEcEo2WFwsPCBLvlk0dnOUcYCUPvBIH0ga1LRuaMEGfs3lW0tTsF0SiJxACt9Ez9pKy0NMdgex0R+mw8AqKpib+hH4RU+vzpHtzPuFDCEj9sSxvSsEbdf5YTqwP0xv6mPmmrmfMd2kAXoi7E9sldeXZVEX0R5gvgWnpwQafN4FiIikfrB5VG50MaX44uYIvNj7NNrg+wxoYYo5hAZ1Ze7pELkSVN9kMO/AyfZOXLZbDKflTHsaNzkscOabk5DUCMICa6TFN4srGbVAvTq9VjMa3aenfzDrlW7jReRBc/fsSs0SU1pOTeU824PQ6VheYEQhM1jYRVv19TkeJaMA0+aUka6OvVZpfWVyhEM3EXNW2Yb6BzQVJk0D9orCLw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 231a20d5-3448-4010-7c98-08d74c90025c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 08:09:29.2862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mEH7V9JiTUdNcyeoYCYRvmIKiD2xjezMmax3hxQC6PZjazTzLNMovi1chcrHfUwx4sFAXBj85twOShT7wfNiKufm3WSqClXQbrCVGTEYXlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2974
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Jarkko Sakkinen
> Sent: Wednesday, October 9, 2019 9:42 AM
> To: Ken Goldman <kgold@linux.ibm.com>
> Cc: Safford, David (GE Global Research, US) <david.safford@ge.com>; Mimi =
Zohar
> <zohar@linux.ibm.com>; linux-integrity@vger.kernel.org; stable@vger.kerne=
l.org; open
> list:ASYMMETRIC KEYS <keyrings@vger.kernel.org>; open list:CRYPTO API <li=
nux-
> crypto@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
>=20
> On Wed, Oct 09, 2019 at 10:33:15AM +0300, Jarkko Sakkinen wrote:
> > On Wed, Oct 09, 2019 at 02:53:39AM +0300, Jarkko Sakkinen wrote:
> > > On Wed, Oct 09, 2019 at 02:49:35AM +0300, Jarkko Sakkinen wrote:
> > > > On Mon, Oct 07, 2019 at 06:13:01PM -0400, Ken Goldman wrote:
> > > > > The TPM library specification states that the TPM must comply wit=
h NIST
> > > > > SP800-90 A.
> > > > >
> > > > > https://trustedcomputinggroup.org/membership/certification/tpm-ce=
rtified-products/
> > > > >
> > > > > shows that the TPMs get third party certification, Common Criteri=
a EAL 4+.
> > > > >
> > > > > While it's theoretically possible that an attacker could compromi=
se
> > > > > both the TPM vendors and the evaluation agencies, we do have EAL =
4+
> > > > > assurance against both 1 and 2.
> > > >
> > > > Certifications do not equal to trust.
> > >
> > > And for trusted keys the least trust solution is to do generation
> > > with the kernel assets and sealing with TPM. With TEE the least
> > > trust solution is equivalent.
> > >
> > > Are you proposing that the kernel random number generation should
> > > be removed? That would be my conclusion of this discussion if I
> > > would agree any of this (I don't).
> >
> > The whole point of rng in kernel has been to use multiple entropy
> > sources in order to disclose the trust issue.
> >
> > Even with weaker entropy than TPM RNG it is still a better choice for
> > *non-TPM* keys because of better trustworthiness. Using only TPM RNG is
> > a design flaw that has existed probably because when trusted keys were
> > introduced TPM was more niche than it is today.
> >
> > Please remember that a trusted key is not a TPM key. The reality
> > distortion field is strong here it seems.
>=20
> And why not use RDRAND on x86 instead of TPM RNG here? It is also FIPS
> compliant and has less latency than TPM RNG. :-) If we go with this
> route, lets pick the HRNG that performs best.
>=20
There's certification and certification. Not all certificates are
created equally. But if it matches your specific requirements, why not.
There's a _lot_ of HW out there that's not x86 though ...

And: is RDRAND certified for _all_ x86 processors? Or just Intel?
Or perhaps even only _specific (server) models_ of CPU's?
I also know for a fact that some older AMD processors had a broken
RDRAND implementation ...

So the choice really should be up to the application or user.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

