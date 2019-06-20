Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7904C4DC9D
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 23:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfFTVee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 17:34:34 -0400
Received: from mail-eopbgr750091.outbound.protection.outlook.com ([40.107.75.91]:39758
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfFTVee (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 17:34:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9drLOeHfcjuBmuT0pYMdpgQOVuKqTDh6DTw1qUcGrs=;
 b=BZVg7dPlyVZQJ7dV71BzDIkWW4akL/uvRI0DR3MKQJRTfvhdMr4eoxThXxKNmyhp00LV/eBIMd31LeX+iP0WwAGQWA+s9ww29KgpEiAS+IgC5HfNcbtUZZJz7HfgtBeUuKZ/3KQj8nAztdGYfYghuHg+z9HkY5QyQM9PHwxsTIM=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1055.namprd22.prod.outlook.com (10.174.169.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Thu, 20 Jun 2019 21:34:30 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40%2]) with mapi id 15.20.2008.007; Thu, 20 Jun 2019
 21:34:30 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     "Hombourger, Cedric" <Cedric_Hombourger@mentor.com>
CC:     Sasha Levin <sashal@kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] MIPS: have "plain" make calls build dtbs for selected
 platforms
Thread-Topic: [PATCH] MIPS: have "plain" make calls build dtbs for selected
 platforms
Thread-Index: AQHVIgBpf6BYLkAQw0aPbj6clwp5T6adO4kAgACh3B+ABltpAIAAyaOAgAATRgCAAAYngA==
Date:   Thu, 20 Jun 2019 21:34:30 +0000
Message-ID: <20190620213427.pavgu64cxhrsmuo7@pburton-laptop>
References: <1560415970-844-1-git-send-email-Cedric_Hombourger@mentor.com>
 <20190615221604.E6FB82183F@mail.kernel.org> <1560668291651.87711@mentor.com>
 <1561017706300.81899@mentor.com>
 <20190620200325.se6e6yicvlkjrb46@pburton-laptop>
 <366B6D73-2DCF-49B6-80B2-B1FAD6C73580@mentor.com>
In-Reply-To: <366B6D73-2DCF-49B6-80B2-B1FAD6C73580@mentor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0029.prod.exchangelabs.com (2603:10b6:a02:80::42)
 To MWHPR2201MB1277.namprd22.prod.outlook.com (2603:10b6:301:18::12)
user-agent: NeoMutt/20180716
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.93.153.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c09630a-74e9-4335-b8d3-08d6f5c71399
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1055;
x-ms-traffictypediagnostic: MWHPR2201MB1055:
x-microsoft-antispam-prvs: <MWHPR2201MB105538B038293D2C86DD6B58C1E40@MWHPR2201MB1055.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(39850400004)(366004)(346002)(376002)(136003)(189003)(199004)(476003)(26005)(1076003)(6116002)(3846002)(54906003)(6436002)(316002)(58126008)(11346002)(6486002)(6916009)(446003)(102836004)(44832011)(42882007)(6512007)(6506007)(486006)(66946007)(186003)(386003)(64756008)(73956011)(66476007)(53936002)(8936002)(66556008)(7736002)(99286004)(8676002)(71190400001)(6246003)(81166006)(4326008)(52116002)(81156014)(33716001)(66066001)(305945005)(9686003)(2906002)(14454004)(71200400001)(5660300002)(478600001)(25786009)(66446008)(76176011)(229853002)(256004)(68736007)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1055;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jcNgHf+cKZcGYhsV1zrKENiKuSNw3Am/O8b6QJ4CRRI+MVHWInjoL5R04tydLO4wHwbC6yBsvnlUSmZUNpRydahqzik+5GVKx2T5toGYr4Xaaw108mvKM5hQovqUlyim1VMgUVzH6+JbliQix+Gu5AsVDyIz4svppStN506rWxtLv9xW+EDlML1/ew9fekwNT5aZiF4beyTST65l7lgP0KDWADZim5/1NfTbz9V5UAlE+0TGHmYE1hLqv1CIQy1xlGiCbWwjNWkDAsxy0Buw+iU1aGMo5JY9WrFJ4wNCeS+zJKqXURxko5b80IymXsClUZi5k04inGLikZcZjf95ihcuGMsBk6QTGiN5DQcBt/lEckd7/u5dc5M6ucuQ2hlFROqkk26BIsIO+axjgTJ5nW2dLyTsr60OdSf8cyZeXTU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <97B42FC4A6994C4AAA315BB4E5726C90@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c09630a-74e9-4335-b8d3-08d6f5c71399
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 21:34:30.5510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1055
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Cedric,

On Thu, Jun 20, 2019 at 09:12:26PM +0000, Hombourger, Cedric wrote:
> Hello Paul,=20
>=20
> I will recheck tomorrow morning but the kernel I was initially working
> with was 4.19 and I did not find dtbs being compiled from a plain make
> or from builddeb=20

Oh, sure - I don't expect they'd get built either. I did think builddeb
would succeed without them though, but actually looking at history it
would still fail for v4.1 through v4.19 because although builddeb
checked for a dtbs_install target in the arch Makefile prior to the
commit I mentioned before, we used to have one in those versions...

So I'll mark your commit for backport as far as v4.1 where our
dtbs_install target was introduced.

The usual approach is that the patch goes into mainline first, and once
that happens you can submit your backports for the stable branches where
it doesn't apply cleanly. You should receive an email following the
failed attempts to cherry-pick the commit onto the stable branches,
which is often a good reminder to handle the backport.

(PS. Top posting is frowned upon pretty much universally in the kernel
     communify - I'd recommend switching your email reply style before
     it draws too much attention ;) )

Thanks,
    Paul
