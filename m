Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0A921AFEF
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 09:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgGJHRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 03:17:02 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20859 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgGJHRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 03:17:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594365424; x=1625901424;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=yzADV//sVEeyFQCrWKyCKhlMtNMIvHjMzQSLM1JAHCg=;
  b=Pj9yf3xkIUilCjrJ6Tg5/668o+b0fbVzIKN23ZmHSggOvhKgMq/dhhVy
   4H74dUtyUspk90qc6Vqac+5s9XSuCkAsEUHpZXj2L+p6bZPyCrnb5mePB
   Mdu2sKihtLnOd8VplSRzbI01OpPsqU9t0ub4hHsKXeeLphzI3wzGt20Zb
   AV0j4kA/rpy5SCxdO8Hdg3baAiqYVzmfTHmA8JiBEFrC4yd8gcA8/QyxM
   5tjPL00y4Dtt7fI6J6MWUPnfS1eGXYJSB1Jk6DwWnrmSvrjQnysoc2Mw4
   XnMjEiZ8EV04WH1QZXi7ENfMpDeMgME0q/aLSF3JzfpWgQIDax7n4HV7b
   w==;
IronPort-SDR: CZkw4wBJFiCSe7rTd3vhqLDsUICicg5YTlZyRDrCYyGdyeg+J4FSxwXUe8WVr1lbidcmgbYB4+
 g1oh0EbTWRse7cToMslp2QBHu4qdqL9Oh7IZJ7oI1uBHRgRhEdZUui46LGlqg5gPoqOytM/sd5
 SGZQpBEp4XRDFvciTxI3Q7EEPj3CJ5/GQ6yKBXQhe7J7Ko3lmdnCmItWObbkCakAoZOH0NrR7I
 jiqCj8TarQV71FF3PWI7DHp8d23xjW87Nl74UoY/Th/XjgEbg4N9r3n1Dp+hVqJMEA2uO52nbV
 yxI=
X-IronPort-AV: E=Sophos;i="5.75,334,1589212800"; 
   d="scan'208";a="245129104"
Received: from mail-bl2nam02lp2055.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.55])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 15:17:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D43IhckpUAfpb/NoC1F90wC5tnP8T1CFopZi3lw91qItDzgFWoosgnRtGwghpDCaAXkIrCROUo4iwROdYrmFL+hCGQ4I9E7F5bm6djfJfR4ielfN0df3Q2j/yp75M/7hD2Z0eInYn9b1s5jj2ZaUQGeBBBOzUWwpY/CFl7NzgWgu4Sr2DglyU22aA8yMzzEo50yFU4uUtFOiN6zjChFYGN60frem17gQNqg9UVYXQiuvYjnRgKFG5XwZ4aoMFniGfoCmb5Uv7KT6HoJeGK5tsNdJiWm3opHfeFiJI5bgxp4nQHOYBVfdQLDW5Q/zJWpcAsGgVJ9cUOceJJQWsEu1rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzADV//sVEeyFQCrWKyCKhlMtNMIvHjMzQSLM1JAHCg=;
 b=PWL76l/8NndWERJjfXJs7LCl73rBNoQVNm52mbJLXEyjPsRfllRvDCEVsaIOvFCjbcKQMy+ICFIx8JHiwCu9Kbp2GBSlqhsGnAG/ORgwj7xYxt6KxoWKs5SJGLtuugnPjDbKLtLE6Ua0DHyxe4YywJWcchDouirGrEfRbhT0yD31R5L2pZgHXdTydETZEZmkD/OGP4XhCWhDcLNsUwZq8pHxr8yw5/nbj2gzFX7E5OXZVGzmdfVU1YzDxyDZqAd93xI0qVOMXrp89K0jCIcKqEPI7U11BYNj55eNroaoCUUgzvh7mcQx0daNi2sk83/1o8wuInw/5c8nPRcafz3UvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzADV//sVEeyFQCrWKyCKhlMtNMIvHjMzQSLM1JAHCg=;
 b=xzmhnGNjazEed6VjF8NJCX3wRz8Rjmdx92GE2hYWmR3p2rPfCXqM3tuZnR7M8cfyOsnzYPImMFeLIO52EpRUqZQGtI/5cWMgm4dwvlXfW9ERMPZcqyQ2Z1GYUYVBn4IA9HhJMMrIItDPeiB3hQnpcT6pNRb/ck/S3Vd2LLIshv0=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3680.namprd04.prod.outlook.com
 (2603:10b6:803:4e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 07:16:59 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 07:16:58 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hans van Kranenburg <hans@knorrie.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v5] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Thread-Topic: [PATCH v5] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Thread-Index: AQHWU6dz/dJGHpip8kylOkU+DLHb6A==
Date:   Fri, 10 Jul 2020 07:16:58 +0000
Message-ID: <SN4PR0401MB3598AD00963CCAD88F49BAE79B650@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200706150924.40218-1-johannes.thumshirn@wdc.com>
 <20200709145211.GA3533@twin.jikos.cz>
 <3a9bc1b2-a780-1ba9-eba0-7fca2198e5c3@knorrie.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: knorrie.org; dkim=none (message not signed)
 header.d=none;knorrie.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:3d54:75d5:bb74:f595]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ac76c43f-742f-40a7-96e3-08d824a13c1f
x-ms-traffictypediagnostic: SN4PR0401MB3680:
x-microsoft-antispam-prvs: <SN4PR0401MB368060FFE92E103697F3F54D9B650@SN4PR0401MB3680.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ipa9Vhpi60qu1qx9RwcVA89QivxkpxYa07vdS5cxWCa97aIeUyHamuiHGp4bG7Bf+dMYx8/SPplGnixmvqZtR2zmOZP92r57di+O06K2VxHJqojwUcfATPTtoysj13zOGiCDtamYnVre9uaABTIaoAKgdwSNxniPFN2QDZHnrneS2xhW+yL3M3dTUSn1XKXDSY7UTEkGp4ukApB6BqQnxUTOy1VJ2gQ86bqyBttKhc6Tzz964mnOcM2Psk3pGfMBdstbi3RGzOeMJ5PQ/x1sCJvGcP1floxsyJNm+FKIfgUMtwL3V9YdQgvtXVSYCYXGGX7ZXuzaVTcDI2U34cSO5jKY/qbbkym8+o/tJBwk0/0JHlE9HlWEKcq9wZr1nmiXKzjlGd168x4TnU4kgco5ig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(316002)(9686003)(66446008)(64756008)(66946007)(558084003)(2906002)(478600001)(55016002)(66476007)(110136005)(6506007)(53546011)(66556008)(966005)(91956017)(186003)(8676002)(76116006)(86362001)(71200400001)(8936002)(33656002)(7696005)(16799955002)(5660300002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xd1ikJ9IenL9aNA/Jfha338dmfiYndEChRKuU9iSQEsUWyQDN5x9iGYyms80Yl0BKgPleacoUeHLh7KbEKkz8WhRF/wham8FVhZG5d/WIT/wgTqA7XMUe8gq3Ni9sIqBp4nS1GL6qQ5dthPfkQY4nW4Y9NB3bbfMqPY/JcQn/MWZ6vbqMiADnC7eZHVNPsDJovjmmTrYzq2q/UNX1tLOL+fsyaMHJdwQQTkmKoAHsr/oC8OhCDu5Yz8BZIy/Vi4gjXF+jb8EXq1iFgfwqK9RLBzxRuEm+YgGwHbEqaf5bV0baoXIK61G1RwXtuseu7hP516WNQrGabDIF3sySutswW1B76MK4ERUDsx3WpU1NmY14mHNVoY+h4LFPtz+25+rrQgyFNA9C4u7uYxNoUqRWkfeEIEaPWKD/JgDgKWiVymGYQs9VbcPZwQM4P3Mdu1A4ylEfPejI3PIwIKNvDkIz0mZj+pEniDxCkTwsTcXlvzAh+CvG7B2me2Y89dYn4+bw9E+uD4ih13+UBdUB7ItNLLZfa8hk4Ia43JqymWDJjnnDVzxib6oAnc6J5+3szuo
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac76c43f-742f-40a7-96e3-08d824a13c1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 07:16:58.8763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MpQuyFubavXE9hfZk9AxhgZR6WKaMVhwePCvjlx9IXdzSbwF2z3DGmumNUvtuM9oy2rfOBzHRN3Fwm04nKnup9jLKxkS08lKWN5jsPj7kec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3680
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/07/2020 18:20, Hans van Kranenburg wrote:=0A=
[...]=0A=
=0A=
> Next task is to write changes for strace:=0A=
> =0A=
> https://btrfs.wiki.kernel.org/index.php/Development_notes#Adding_a_new_io=
ctl.2C_extending_an_existing_one=0A=
=0A=
Yes I do have code for v1 of this for strace, need to adopt it.=0A=
