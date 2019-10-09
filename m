Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C87AD07DB
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 09:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbfJIHKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 03:10:14 -0400
Received: from mail-eopbgr760042.outbound.protection.outlook.com ([40.107.76.42]:5120
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725440AbfJIHKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 03:10:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljCO9dlo2vXAlB/2deXfMGWI0Gm0mW27mmZ4Ono037JeDuxxkqnxxUKbDbhJfRD8bxDNiZE0rlap46a+4tyDrj2N3IpJITmu1M8/lSk/BzbZC9DXgpwwvLPwn4VNvD9ZubLaUUyB1NXtgkpx6J97dG2NoiyOEgnWJaCavNQMak6s/EFftuwWcALsNreU3gUjB43SudlZkEf0JRkjSpHpUjQ/MIAtsCDSBfxKZ2PlJA41P1rmr7jo1nncU8vh5G8U10AWTSH1478yT4uEOQJDzccquYg8YXWgDCGmfb7BdOUlR1aX86LlhXEN2Tg2UlgbQ3s44IampvItf5fH9XSSrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOhJzOvTr0kjdufU/zPHMgdFzCE502tDiy0ZEgFZpNE=;
 b=C2DW+F0HB4w7cXasXAizt/Lse45AGqPm9iAWEYzpCOBH8LEhn20vNn/wmWdFWVEmF4TtJF9PDfSSJXi7xZsxDs26snjjdb5s8tI7240EOZeomdWfcyNxyybdpNTTXnOUuFoj8H3KGSxk73KQFr+nZyF+vYl4SIxKnNyZy9ohKknHRnCUeVdJN8UAKzQjgJZzYRwENwBvwMitCtYx0F9VU/qljsSZTPTXYrtWhLsxbLRki13OFJwYM6UjWUlWNyfi7MZO+oQcnklJRMyNPAf/vq2gUImUnckiKkK3LGdP1JrazzWjuIAoYjgxlCv2N+ViGW4RXM9aeQpgvh4gU0N0bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOhJzOvTr0kjdufU/zPHMgdFzCE502tDiy0ZEgFZpNE=;
 b=As0mUd0fH2nd8vqfdfsY0XasF6cOlTFKipWECgw7GwvNy8OYXPXcOCrVG75ajz+UBHBRMFRKagZ+xn/IlutPtVe1B5vZv8xY5b/FO459LJYgnuhle/FGOosgSgT2LCLgxoV0cs3xDJ2pkB/fl45iBxE2+/QoG5qb4XjBKn28jPo=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2302.namprd20.prod.outlook.com (20.179.145.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Wed, 9 Oct 2019 07:10:08 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 07:10:08 +0000
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
Thread-Index: AQHVdI4da48CsX6QxkCmhP/96hjLv6dHalaAgAFrf4CAABaxAIAAUs4AgAAPVYCAATcGAIAAU+GAgAAY0oCAA2pSAIABcvOAgAGtUICAAAEjgIAAc48g
Date:   Wed, 9 Oct 2019 07:10:08 +0000
Message-ID: <MN2PR20MB2973D1DDDC1C0D41D449E4CCCA950@MN2PR20MB2973.namprd20.prod.outlook.com>
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
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b7226e2-3622-4bc8-7f9b-08d74c87b7e2
x-ms-traffictypediagnostic: MN2PR20MB2302:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB23023662A6BDCC2623BA9C42CA950@MN2PR20MB2302.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39850400004)(376002)(396003)(366004)(13464003)(189003)(199004)(26005)(110136005)(15974865002)(86362001)(316002)(55016002)(53546011)(6306002)(6506007)(486006)(7696005)(76176011)(9686003)(102836004)(54906003)(186003)(5660300002)(66946007)(74316002)(66446008)(64756008)(66556008)(66476007)(7736002)(76116006)(305945005)(52536014)(3846002)(14444005)(256004)(2906002)(6246003)(66066001)(14454004)(8936002)(6436002)(81166006)(81156014)(8676002)(71190400001)(99286004)(229853002)(478600001)(6116002)(476003)(446003)(11346002)(33656002)(966005)(25786009)(71200400001)(4326008)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2302;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c+j5fBs5wUzKu/48obyepdNHGScDRgrfRBUL/DyEvD2u+yVEsZnBa31h8UpxOAwj+vUgA40ycNbq/wAYQHq3mopt/j28esAjqjZraZXNMRvB5O40Km08saZNS9YfpZr/BNuLTaBmbSBaDjWrCmuR3lqsIBGAbswaKl6t2MCmwIpXNNow7Tk5HLiKgJHi8eGJH58BpwlFVlQXncaRqst4gRaFb5Var+Gzx6sxnO8ENOiG/Ufo3jE6iE0CtqU/DTiQAYpAOk1srQ2WhHpxSXrS9YK113aRDzvlPWeHoDXQ+TIwtoTnYzbmE37F7+9/fqGVKF9fwoqqq16RGMRxY9oy3P6RFoAiNoBqCeOyDmPFmKRRsNSTXib7FMe0dgoWp3L7MIgIkTFJJvvJOx/09Bp7Gkv4NrpYGIeikyA9mcMDUrQJbIkAJGqyTdjR+M/CncrTLzKeJhZB0k3vpibNY5XlJQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b7226e2-3622-4bc8-7f9b-08d74c87b7e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 07:10:08.2286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d5QHziXmOpz7fOMU7ccvp00GyGuug913kZv1wGra5q5EzjG8Qu2S48y1+1bpp1JRGoDcYERB+AF/ZzMq79AgmgJ73wn4YK0sdF1Bd4yCL7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2302
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Jarkko Sakkinen
> Sent: Wednesday, October 9, 2019 1:54 AM
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
> On Wed, Oct 09, 2019 at 02:49:35AM +0300, Jarkko Sakkinen wrote:
> > On Mon, Oct 07, 2019 at 06:13:01PM -0400, Ken Goldman wrote:
> > > The TPM library specification states that the TPM must comply with NI=
ST
> > > SP800-90 A.
> > >
> > > https://trustedcomputinggroup.org/membership/certification/tpm-certif=
ied-products/
> > >
> > > shows that the TPMs get third party certification, Common Criteria EA=
L 4+.
> > >
> > > While it's theoretically possible that an attacker could compromise
> > > both the TPM vendors and the evaluation agencies, we do have EAL 4+
> > > assurance against both 1 and 2.
> >
> > Certifications do not equal to trust.
>=20
So having an implementation reviewed by a capable third party of=20
your choosing (as that's how certification usually works) is less
trustworthy than having random individuals hacking away at it?
(and trust me, _most_ people are not going to review that by=20
themselves - very few people on this planet are capable to do so)

> And for trusted keys the least trust solution is to do generation
> with the kernel assets and sealing with TPM. With TEE the least
> trust solution is equivalent.
>=20
> Are you proposing that the kernel random number generation should
> be removed? That would be my conclusion of this discussion if I
> would agree any of this (I don't).
>=20
Life is not that black and white.

If certification is _not_ a requirement you can use the kernel random
number generator, especially if you don't trust, say, the TPM one.
If you _do_ require certification - and in many industries this is
_mandatory_, you simply _must_ follow the certification rules (which
may impose restrictions how the random number generation is done),
and this should not be made impossible for such _existing_ use cases.

Having said all that, generating _true_ entropy (and, importantly,
ensuring it cannot be manipulated) is a very complicated subject and
considering how all encryption security ultimately  depends on the
quality of the random numbers used for key material, I would not=20
trust any implementation that has not been certified or otherwise=20
carefully scrutinized by people _proven_ to have the expertise.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
