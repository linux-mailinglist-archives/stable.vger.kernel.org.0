Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17ECB16579
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 16:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfEGOPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 10:15:39 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:47960 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbfEGOPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 10:15:39 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 19432C01C3;
        Tue,  7 May 2019 14:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557238541; bh=GIeJKktwhSGd5wafQaABKD1cgbkQN4Uwg9qKVqqyDOw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=C1tRkzBG3ZvadYarqek9GGucnznIVPGFg6jlJ76iGFtAn1yfNU2QoS1Gvsqw9V+uP
         fc0GYEQOwaCc9jIVc/tYqbavi605dnt0nhfOKQ+vy4MXiCu7elQIWMZuJamktmaG2z
         i0bZJMH8oNSJHId/XQGzCKj+ixP1hkTqqUDMAqSnEpc+8FqA1x0Pv9/sTzJH7EOpGc
         NwOEtV7ayB9ncEKcWTvUaSdkBdV8KhsubyPY+uZB5eCSH3Bkds1R1mfMkaO6R+4lAt
         cfv2kb1ctA07ORXN34r2kRtLEVQXmH5u71qkGL9Cosjse6Mmvdw+pmTb9dY456gzG6
         8qE2MCUOWpxmg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 0BF8DA0066;
        Tue,  7 May 2019 14:15:35 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 7 May 2019 07:15:35 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 7 May 2019 07:15:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3JayWQUCAh87xOkE47UnBlKgwytKxHcNI4I7TOJl5I=;
 b=ICJDmdw41LqKylmxdJ7lODGTTFgUVHex+tkv8qVSuNZSwhAmfX9oaVS8ku5g53tofbRt2RV1DMwMWY9B8nM2RaVCpkpvAGMG5P9AZr07z6UuqtBnsP5SmJvZfNEqgwl83CoVBrCDRGkcwoWdMPFCcgGmAXuZmmr1jxFJy2ncerw=
Received: from CY4PR1201MB0120.namprd12.prod.outlook.com (10.172.78.14) by
 CY4PR1201MB0024.namprd12.prod.outlook.com (10.172.77.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Tue, 7 May 2019 14:15:33 +0000
Received: from CY4PR1201MB0120.namprd12.prod.outlook.com
 ([fe80::ac77:1c39:d9eb:ee9a]) by CY4PR1201MB0120.namprd12.prod.outlook.com
 ([fe80::ac77:1c39:d9eb:ee9a%4]) with mapi id 15.20.1856.012; Tue, 7 May 2019
 14:15:33 +0000
From:   Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "David Laight" <David.Laight@aculab.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: RE: [PATCH AUTOSEL 4.14 72/95] devres: Align data[] to
 ARCH_KMALLOC_MINALIGN
Thread-Topic: [PATCH AUTOSEL 4.14 72/95] devres: Align data[] to
 ARCH_KMALLOC_MINALIGN
Thread-Index: AQHVBJd3onwrWwkS2UueAl57c5ZJEaZfKNsAgAATBJCAAA2mgIAAa1uQ
Date:   Tue, 7 May 2019 14:15:32 +0000
Message-ID: <CY4PR1201MB012086E453B1C8435535D44AA1310@CY4PR1201MB0120.namprd12.prod.outlook.com>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-72-sashal@kernel.org>
 <20190507055214.GA17986@kroah.com>
 <CY4PR1201MB01200B5B52E39A88D8D3FDDDA1310@CY4PR1201MB0120.namprd12.prod.outlook.com>
 <20190507074909.GD26478@kroah.com>
In-Reply-To: <20190507074909.GD26478@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=abrodkin@synopsys.com; 
x-originating-ip: [188.243.7.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e222b65d-eb95-4e8a-a227-08d6d2f677ae
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:CY4PR1201MB0024;
x-ms-traffictypediagnostic: CY4PR1201MB0024:
x-microsoft-antispam-prvs: <CY4PR1201MB00249969AC593A4BEA5AA8F0A1310@CY4PR1201MB0024.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0030839EEE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39850400004)(366004)(376002)(346002)(136003)(189003)(199004)(52536014)(33656002)(74316002)(6506007)(478600001)(561944003)(53936002)(305945005)(76116006)(66556008)(66446008)(64756008)(5660300002)(2906002)(229853002)(73956011)(3846002)(66946007)(6246003)(54906003)(6116002)(486006)(14454004)(81156014)(11346002)(66476007)(68736007)(446003)(8676002)(476003)(81166006)(7416002)(26005)(7736002)(14444005)(6436002)(8936002)(25786009)(256004)(186003)(4326008)(6916009)(71190400001)(71200400001)(7696005)(76176011)(86362001)(99286004)(9686003)(102836004)(66066001)(316002)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB0024;H:CY4PR1201MB0120.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1cl7EKsTI4uvi0soir0P/FpDCyRqnUTxtO23jVslcH57v9xRjonZ186nru8PwwttuMiKqBTZoKz/tc38WIzJF4EHDkmJUaDXigl/13jxpJ5W7fHJEINr78qZLbz092O8dX6LXfxbiUm10uuonARLgL+I3wNFsWIZ3Bfm2XWmLAK8yvUG2hhO9RPMlPKcQUUzwdvqaVXN7GHu9UpOz8tQvWxcTQ6etDqYdIq1l2p/M4GQvvBuF278LQVL26v2lCEO+Djo9E9Kbox/n3QpvHN+htIasS/73+j6KtY6H/jtH4+b1JAzf9H7Z6CQaR/AUAsfQbBxoQaTNo2BIy7eCzz+MZQYL2a/f2ufZP233LfY4ku8LZAPUn1DEMIMNTgcQaR9BK4kr9Tqc3u+YaObLcpmyK2WHPqr/i+UDbK6WFhfXcg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e222b65d-eb95-4e8a-a227-08d6d2f677ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2019 14:15:32.9924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0024
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

[snip]

> > > This is not needed in any of the older kernels, despite what the stab=
le@
> > > line said, as it ends up taking a lot of memory up for all other arch=
es.
> > > That's why I only applied it to the one kernel version.  I'm betting
> > > that it will be eventually reverted when people notice it as well :)
> >
> > That very well might become the case but then we're back to the initial=
 problem,
> > right? So maybe some other more future-proof solution should be impleme=
nted?
>=20
> Possibly yes.
>=20
> > See initially we discussed simple explicit 8-byte alignment which won't=
 change
> > data layout for most of arches while fixing our issue on ARC but for so=
me reason
> > people were not happy with that proposal and that's how we ended-up wit=
h what we
> > discuss here now.
>=20
> I'm not disagreeing that this is a valid solution for you, I wasn't part
> of the original discussion, sorry.  Just that this probably isn't
> something that should be backported to older kernels at this point in
> time.

That's fine for now.

Then if it ever gets reverted in Linux tree hopefully I'll be CCed and
it will be enough time to come up with a better fix.

-Alexey
