Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B11DD3327
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 23:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfJJVEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 17:04:54 -0400
Received: from mail-eopbgr760127.outbound.protection.outlook.com ([40.107.76.127]:7878
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbfJJVEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 17:04:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYhvYEryiVl2XF6EsSzJyCPEA3SQjw5j24VaWPuE3veb0E7k35J+Xo/yC9QZ6jSV6H8eX4UuPDmpPIsyk7DYWSSMPkPzP0zpPKprulZvRoEI7lbsnZcC2fPo4wPiiXKv5RqH2CWMIF/TfVwYY2v1poCmRwN7O7hhzEQl3ws0WE60TW+Gcbywc8/JrCipVasn9KE+U5LAA3Cm38hyXRGo1wTypyX1pv+N8Al4fgj2biIRTdE6BLVEl0QyZecROzUVIzl6iC/pnHilqONxB8H9Zf1tZrafMI8gw7RPJKDTuxpMxTaxcUe9vqNqqNwCvHYz5ujTITiXbVe6DVqQgBlI4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eHH+OCm/bnAlCUMo9ltJ7B7LYvSQlRtMcXp0z55tPy4=;
 b=F+q+QUBQD+AhFc6Qek6STlKkxx6DmFn6kw2uwZxoo6czYmrFGuR3RDnIvy2G9bNyokWmJBwZpL789alBkl4sK07pRRAU+pC9gqpAg2ySFa9jRez5nBHPhTieubz8fI6kOGFOaSzsOFDVH4a3IKwilSyTxkkS6q+eXzgXM7Kb797sN8sEoBkukvRM7ZrHHA9ubs8ecx21fWYYVM+uVc8jRWlaxXr6gdV/XH2ZMqqOfKWfXV9HKe7v5D2m3F6n5sXLRmAi8gcaVX3Vij5Uz6Mlsu57rYosGXfgWftNwMyVh97DCZ6EqIC02wbW+YtzhA/c32YSFnCaC1Mk2Ra3kEt6JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eHH+OCm/bnAlCUMo9ltJ7B7LYvSQlRtMcXp0z55tPy4=;
 b=Nfik/k1wS8gbm2iqqLrSs7E3L7syoD0raZJDymLbubdE3F8/6uzgQgs3Fz937ekc09F68AUeHWF94f2Tpkx4r2HCEeoTtmIGyKl+luPjThmYsW48Y1K3POmKIjyNCrkfHTkwKP9jIi4jbkX7yqtXBe4w0eQBgAcG4kUNywh0lKw=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1408.namprd22.prod.outlook.com (10.172.61.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 21:04:51 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::c1dc:dba3:230c:e7f0]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::c1dc:dba3:230c:e7f0%8]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 21:04:51 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
CC:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Meng Zhuo <mengzhuo1203@gmail.com>,
        Paul Burton <pburton@wavecomp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH v1] MIPS: elf_hwcap: Export userspace ASEs
Thread-Topic: [PATCH v1] MIPS: elf_hwcap: Export userspace ASEs
Thread-Index: AQHVf65biijpxzKI+kuCl61go0I/wg==
Date:   Thu, 10 Oct 2019 21:04:51 +0000
Message-ID: <MWHPR2201MB127715CCA6D7B8CCBCCC2683C1940@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <20191010150157.17075-1-jiaxun.yang@flygoat.com>
In-Reply-To: <20191010150157.17075-1-jiaxun.yang@flygoat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:a03:80::14) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6e3c157-d17a-4636-2717-08d74dc57df1
x-ms-traffictypediagnostic: MWHPR2201MB1408:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2201MB1408BD8FC431F6DCF8FBFEC3C1940@MWHPR2201MB1408.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(366004)(39840400004)(136003)(189003)(199004)(66066001)(52536014)(6916009)(55016002)(9686003)(4326008)(5660300002)(6436002)(6116002)(66446008)(2906002)(3846002)(64756008)(66556008)(66476007)(8936002)(4744005)(66946007)(6246003)(7736002)(74316002)(305945005)(81156014)(81166006)(33656002)(8676002)(6306002)(7696005)(476003)(256004)(52116002)(76176011)(71200400001)(71190400001)(99286004)(44832011)(42882007)(11346002)(229853002)(26005)(386003)(966005)(14454004)(478600001)(6506007)(486006)(102836004)(446003)(186003)(25786009)(316002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1408;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K4XCeGsvYkaAcfGm0N97GSGSn4E7axUwZVlFvJcxWfRyXHKlOP1g6Lt4NabquqwLbshIrzDB1eGNAoNqyqzMpO7Y99yWGy7kVnGgReDFVTrJ5trajgYUV0bKRCUkQnvAVRUqLBNwut/XG5Y/yvMoFnxF/eYKbwIIpyqa7ic2gA7U497nlBNKknhK9tMLz+NinxjURSwTh0j+GaiL/2Soi1yoZTWZQcWen+i+dtCiTDJQOSysbnoWMHGlglAY+/3AKsMmKlF1zDf6oERXg1F7IwNSna/ykz0uu21P1ZdzU2HqUaTf440iR0DNQXh2eRxltSg6n++xZk3Oox2wnjhmNtfLjACbX3Sy9eIAWzM9DQeMnmvT0eztlI7/sBewyB3lM49SDexFj95iidU+C7qQ0deajbJ9HACHP7hTw9bD0gK6OfXzI4IwGoHTMyfYgM4IPHMOIZgpeouQ4NNEfk25gg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e3c157-d17a-4636-2717-08d74dc57df1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 21:04:51.5925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o5H4UaagZgQJwFix7uq4dB1qZR/S1j915P9teAB9Jz2SOYteUyGJHyfXKJi8xFgUmIZCs4S9ogp0CLPZ2jxVPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1408
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Jiaxun Yang wrote:
> A Golang developer reported MIPS hwcap isn't reflecting instructions
> that the processor actually supported so programs can't apply optimized
> code at runtime.
>=20
> Thus we export the ASEs that can be used in userspace programs.

Applied to mips-fixes.

> commit 38dffe1e4dde
> https://git.kernel.org/mips/c/38dffe1e4dde
>=20
> Reported-by: Meng Zhuo <mengzhuo1203@gmail.com>
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Signed-off-by: Paul Burton <paul.burton@mips.com>

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paul.burton@mips.com to report it. ]
