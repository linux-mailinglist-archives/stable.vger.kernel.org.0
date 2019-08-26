Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A982D9CDBB
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 13:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731058AbfHZLFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 07:05:51 -0400
Received: from mail-eopbgr790105.outbound.protection.outlook.com ([40.107.79.105]:1313
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730553AbfHZLFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 07:05:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFs+lgkkJWWxtndll4coKEdU9qr1BMh5JMNjVa+GmBmTXjxUTSiD/hrGZ9hzb8cOPNXbLzcIWr/whjBywD3s06PAG5WxyF8dC/buZ481fcZHHEnfcj/WwqleC+8z15mfELxTdXibaWJOHoat+UrkjW8tE7ZgE4TBNZx3i0WdOG85R58xAxuPttP+KvD7I8s3Ip0ymeh98aF77WSFrQ4V23+bx4En7cGDEDHqFeNcBVXfBe+OpXrzkFMWo8CfTuXvNjDoE5WQ03ucPaCUPLcUHD+B0FOjqtEbHrTcuDMZBYFF9wcvLzrn5Vwecd1k6S+VuYVi+DMXsNxelOzk7ZX0mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJHZKZpUamjKm4MRLFT/wRrk3/rcveY6YN9J0eo1DJw=;
 b=EFpY7FGlOZFQzY3YfjHCiUJHzo/bAC/BN1NoLfoJqRCElr60bCk5VJOKoANqSiWR0MiriZrvRcWwQkZwq2SgxebuSQe/lzVUyBUOQh0nmUBsaZF3izOFgbVe6xjQjYGIV9UKbgarCuXu1L9p+XXyEfyk0a/6fXjRfi/xo1R0ha0QZUbWNtPb8g2T5NGNtSMQSpjTOxi1jHlXhi0RzwCIi/AbB6MjocvtNZQ1YJkiVbVSvSCirRtM93RpDFRYGKGERuofCtBsZBP8LCD5ceEg4cvd0hknLBOP5Wnu+Miyn0JaxDdAdfJD5zWEmikbBd/75jfs+8bS8Z9ZSOay6Cmk0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJHZKZpUamjKm4MRLFT/wRrk3/rcveY6YN9J0eo1DJw=;
 b=QU9BFs0TD9CnG5Uu588cqWMuXQxu7x2WdAhCh5fYFzcxDCFJSspQTx/IINWFeutn+FwjYjrB1f24uLESjXECNYlh8c3tUmGJ/5H6IkyIq1pHptXRmUDAhZKSTRhsDVLTFMd9FC4GP4XE1mnvCUMND54tZZBSPVtvBTU4gGhDOVs=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1469.namprd22.prod.outlook.com (10.174.170.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Mon, 26 Aug 2019 11:05:48 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::f9e8:5e8c:7194:fad3]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::f9e8:5e8c:7194:fad3%11]) with mapi id 15.20.2199.021; Mon, 26 Aug
 2019 11:05:48 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
CC:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Paul Burton <pburton@wavecomp.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Yunqiang Su <ysu@wavecomp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH v2] MIPS: Treat Loongson Extensions as ASEs
Thread-Topic: [PATCH v2] MIPS: Treat Loongson Extensions as ASEs
Thread-Index: AQHVFfqV0yX2/vkQwEWahkz1FhXytKcN0HEA
Date:   Mon, 26 Aug 2019 11:05:48 +0000
Message-ID: <MWHPR2201MB127704420DB0B7CA6CE9C390C1A10@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <20190529084259.8511-1-jiaxun.yang@flygoat.com>
In-Reply-To: <20190529084259.8511-1-jiaxun.yang@flygoat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0062.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::26) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [79.77.158.32]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49e0f14c-7420-48bf-74df-08d72a155999
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1469;
x-ms-traffictypediagnostic: MWHPR2201MB1469:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2201MB1469EE049BF11E26A16D25B5C1A10@MWHPR2201MB1469.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(136003)(39840400004)(366004)(199004)(189003)(478600001)(966005)(5660300002)(14454004)(2906002)(229853002)(6436002)(74316002)(6306002)(9686003)(55016002)(4744005)(25786009)(54906003)(6246003)(53936002)(66946007)(52536014)(7736002)(3846002)(6116002)(4326008)(66446008)(64756008)(66556008)(66476007)(305945005)(316002)(256004)(71190400001)(71200400001)(486006)(44832011)(8676002)(81156014)(81166006)(8936002)(66066001)(186003)(102836004)(99286004)(386003)(6916009)(6506007)(476003)(26005)(11346002)(446003)(42882007)(7696005)(52116002)(76176011)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1469;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vrN0GB2WXQJykdnh9isiRJsO7IlqhVAYQScnLJitoW9AwKO0mH0U6l5kPErMnNKb5KI6bnar57jQDd9ZrdOoNeI+peNZ/8Ss5uwUw+48/qK/pyHZi1q94b6pJNSVe5F5/dy9biAtXUUjchD69fK/cK33jjzrj/aorju6eUTf+QcOktP/9bX2uiLJF6zooJLPQPDl3oTjKePyRpD1Iwtq5vl4zoLn+UM+5DPy7Q0OMZ0Sok1eYouVW60h3RiP4a3f8zdMVaJ3akZOM8/iBZNw60yBxC9kW4Djhng3LtUw5Oq7Gd0+Nu2mv1tT5deshy5Fmnz4Pru+2lSK+3MZ4jvrTxWTrYkLEiDJ4cEV8bDftlUudz18NeMAI6X+PegTNADWauWOAIQyANhBNkAUyh8fksPOdVLIP7DSQOEFKX0wg/c=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49e0f14c-7420-48bf-74df-08d72a155999
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 11:05:48.4682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ho49ChBP3HwVA9RYk0uXpvsLHH7yu3ZnoBJS96iHCSrdL/P3QidPs8WdiqTZkEZYRM1rdCxwjMOKiPCzOrnw2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1469
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Jiaxun Yang wrote:
> Recently, binutils had split Loongson-3 Extensions into four ASEs:
> MMI, CAM, EXT, EXT2. This patch do the samething in kernel and expose
> them in cpuinfo so applications can probe supported ASEs at runtime.

Applied to mips-next.

> commit d2f965549006
> https://git.kernel.org/mips/c/d2f965549006
>=20
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Signed-off-by: Paul Burton <paul.burton@mips.com>

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paul.burton@mips.com to report it. ]
