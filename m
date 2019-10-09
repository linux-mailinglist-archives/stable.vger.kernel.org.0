Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC74D0907
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 10:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbfJIIC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 04:02:59 -0400
Received: from mail-eopbgr690041.outbound.protection.outlook.com ([40.107.69.41]:10633
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728429AbfJIIC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 04:02:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/vW4uYTw4Zi/ap/t8CiNxKVXNy5f+OlAG1i2PkJfE0yssuevMpDkCPU3sM0gBDK2tCNt42nmZCBS8mgDepNTd8q+IGpKSIheoaZy0kCi5EROU1EVWcgE9pwykn4gDHEjJTC0C+UwDs5xv1rogWqm4b+z/Y8vmLwja1UzXZM6WrpTmGyhAECO9KdVv4AtvQEVUN2nhZWFQLyygC3ckEdveuaZVddyjjuJpbJaj/utfY8MpYTC8Zk+RuVRZ6bQ638eavbsnd0g7oNVJIZuejOmNSdtOEDdmo8iVkPaFZSowDjMLFHXNzfpJQzV7Gn1D3zBmD9Q3tkguLiawov7ibJbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bItYDZp3f3y6Y5NKrtL5yfpJz+2BWJLq8nvDvjp/zfk=;
 b=Cz+J/L8JhguvOjE93hr92H7/WU/UjJAzRXfCb05oR2D7vgAAzGqayIhpPAd79FvjCs2EQUkHIqbpiGhoQzCv8oneMouxLbO7YS9W1yCWZK82LZAIzkdDPqsiGXOqmCrcSXbkBbz2ZyyzDkf4rwuZMNnWIsoHFrACM8Z4Z6U9/nQBUPcEQcwHKzq9JvLMWOuScK0B6pYQPTBhgLHwkMu/IeSIn2s+zJH+ezPxrCtErjmPM2xHhHOJnP9yz2QMtrmGgK8UYXQ2pW5SUZJMxyhxsEGcjqYuem5nba7CJKU3I30yvj/hK0I1y3AVtFG+qrgMZ+ru0k8o2HXiEWj3DpHXYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bItYDZp3f3y6Y5NKrtL5yfpJz+2BWJLq8nvDvjp/zfk=;
 b=fgbKF5F6tPzpvGrfxFWE+feKkpchXisORqqDJ9d4Tssr3tgpMxSuE9FokHy29h3V0msJiF0HiQNZiez/sAq+LNKmNCX3CwHGERCSJft6P1JBcUPrQS0TtRohiuqnfjm+dmJRxw+uDc/yTbA2OEajrE8zKpKBVNmfnmbzYnwn8U4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB3246.namprd20.prod.outlook.com (52.132.175.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 08:02:53 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 08:02:52 +0000
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
Thread-Index: AQHVdI4da48CsX6QxkCmhP/96hjLv6dHalaAgAFrf4CAABaxAIAAUs4AgAAPVYCAATcGAIAAU+GAgAAY0oCAA2pSAIABcvOAgAGtUICAAAEjgIAAgGmAgAABCDA=
Date:   Wed, 9 Oct 2019 08:02:52 +0000
Message-ID: <MN2PR20MB29732A856A40131A671F949FCA950@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1570107752.4421.183.camel@linux.ibm.com>
 <20191003175854.GB19679@linux.intel.com>
 <1570128827.5046.19.camel@linux.ibm.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
 <20191004182711.GC6945@linux.intel.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
 <20191007000520.GA17116@linux.intel.com>
 <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
 <20191008234935.GA13926@linux.intel.com>
 <20191008235339.GB13926@linux.intel.com>
 <20191009073315.GA5884@linux.intel.com>
In-Reply-To: <20191009073315.GA5884@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41018c77-fd8a-4f46-e891-08d74c8f15f4
x-ms-traffictypediagnostic: MN2PR20MB3246:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB3246958C95991AF953D19426CA950@MN2PR20MB3246.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39840400004)(376002)(396003)(136003)(189003)(199004)(13464003)(52536014)(71190400001)(6116002)(99286004)(476003)(478600001)(71200400001)(33656002)(966005)(4326008)(5660300002)(14444005)(7736002)(256004)(3846002)(74316002)(54906003)(110136005)(316002)(76116006)(229853002)(305945005)(2906002)(6436002)(446003)(14454004)(53546011)(6506007)(11346002)(8936002)(66446008)(7696005)(66476007)(55016002)(64756008)(76176011)(66556008)(6246003)(25786009)(486006)(9686003)(6306002)(66946007)(81166006)(86362001)(66066001)(26005)(81156014)(186003)(15974865002)(102836004)(8676002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3246;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: idKhIqPGnv5ii4HY+P6vKBANR8BK7UzDLueU3zhsB5vaOITqqOXQqHoK9GS69PwVNhGTPmb/tL038N6G7+eWwLbVcI6S6z8S9MgPTtRSStvxurxJ8C4lhufR2oSpOm8G1MpgGuD1cibFAfwNY0kjSFORELOgLzKYE3WNUqrJIb5ozB/w+NOw2KoK2RvhF9i68eXoqXntBwsXmSgOai30P+yd1MFzDtDuT4pb+YEjwara3EkX5l/vP2esLSVvovrMNUm2407lkGMsBdsokS62bLnRUxOPmuwv4iOKEEYLd1EUsNL3OA/MSxhBVhxgo/vqd4RuPgeDAOAUsZ6h8UHzrefVOyK7kU9ZhATnRpkdDbQOWoPLZh9c2kKTsS9xqCcBu+OKXP1P0mquJJG3gnoCZa4ld/gl3dCAzh8nILMD1L48JwK+Yhaq0ow13/oWBj3geeCE/gRoXOpp+QGXRU4JHw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41018c77-fd8a-4f46-e891-08d74c8f15f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 08:02:52.6132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: abmUcUe3PYsnVIyYNceW7/FRWPqVQeq81rTUFD8mIZzc3jMIt7KqzVaYUltmqbxRY3zjJi4Vb8z9Gry4Sn0DvMPbSCouW5JfP10L7ekGVNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3246
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Jarkko Sakkinen
> Sent: Wednesday, October 9, 2019 9:33 AM
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
> On Wed, Oct 09, 2019 at 02:53:39AM +0300, Jarkko Sakkinen wrote:
> > On Wed, Oct 09, 2019 at 02:49:35AM +0300, Jarkko Sakkinen wrote:
> > > On Mon, Oct 07, 2019 at 06:13:01PM -0400, Ken Goldman wrote:
> > > > The TPM library specification states that the TPM must comply with =
NIST
> > > > SP800-90 A.
> > > >
> > > > https://trustedcomputinggroup.org/membership/certification/tpm-cert=
ified-products/
> > > >
> > > > shows that the TPMs get third party certification, Common Criteria =
EAL 4+.
> > > >
> > > > While it's theoretically possible that an attacker could compromise
> > > > both the TPM vendors and the evaluation agencies, we do have EAL 4+
> > > > assurance against both 1 and 2.
> > >
> > > Certifications do not equal to trust.
> >
> > And for trusted keys the least trust solution is to do generation
> > with the kernel assets and sealing with TPM. With TEE the least
> > trust solution is equivalent.
> >
> > Are you proposing that the kernel random number generation should
> > be removed? That would be my conclusion of this discussion if I
> > would agree any of this (I don't).
>=20
> The whole point of rng in kernel has been to use multiple entropy
> sources in order to disclose the trust issue.
>=20
I do understand that, and combining multiple entropy sources, if
you have them available to get _more_ entropy is a good idea, at=20
least in theory. But ...

How do I know the mixing of entropy happens properly? Especially
if I'm not capable of judging this by myself.=20
And how do I know the SW entropy pool and/or code cannot be influenced
_somehow_? (either directly or indirectly by influencing one of the
contributors). More code and/or HW involved means more attack vectors
and complication of the review process.

The point is, if you want to certify such an application, you would
have to have _all_ contributors _plus_ the kernel rng code certified.
And you would have to have it _recertified_ every time a _single_
component - including the kernel code itself! - changes.

> Even with weaker entropy than TPM RNG it is still a better choice for
> *non-TPM* keys because of better trustworthiness.
>
"Even with weaker entropy"? Now that's just silly. If you _know_ and
_trust_ the TPM to have _better_ entropy, then obviously that is the
better choice. I guess the key word being the trust you don't have.

> Using only TPM RNG is
> a design flaw that has existed probably because when trusted keys were
> introduced TPM was more niche than it is today.
>
For non-TPM keys, possibly. Assuming the kernel RNG indeed adds=20
(or at least does not weaken) entropy. And assuming I _can_ trust
the kernel RNG implementation. Question is: why would I trust that
more than the TPM implementation? Sure, I could look at the code,
but would I truly and fully understand it? (so maybe _I_ would,
but would Joe Random User?)

> Please remember that a trusted key is not a TPM key. The reality
> distortion field is strong here it seems.
>=20
Agree. But you should not mess with the possibility to generate
keys based on _just_ the TPM RNG _where that is required_ (and
perhaps _only_ where that is required, if possible)

> /Jarkko

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

