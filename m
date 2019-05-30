Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F278C2F72F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 07:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfE3Fp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 01:45:27 -0400
Received: from mail-eopbgr110059.outbound.protection.outlook.com ([40.107.11.59]:48096
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726308AbfE3Fp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 01:45:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=camlinlimited.onmicrosoft.com; s=selector1-camlinlimited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrmLJ1ylB3YjZbM4YNJaAgn8qujKCAXoyuLrXadZTTU=;
 b=bPnzhaUwM/rAMOoZ2A1KT6Lnrtx0aHODLUhRQ2w848VqzfvrEq/VbFZQtoYfRoCgpX8m7MxgmolQ2FlSe94CdIFSKH2cGXOzMME0nxHd7CSKXwX45nlzLjHWPlOztqt0fuUeOIj6EacJqGWh2LrPCLYvVmOLjzEzNB56P5r7Wik=
Received: from CWLP123MB2050.GBRP123.PROD.OUTLOOK.COM (20.176.59.213) by
 CWLP123MB2050.GBRP123.PROD.OUTLOOK.COM (20.176.59.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Thu, 30 May 2019 05:45:22 +0000
Received: from CWLP123MB2050.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5ddf:2082:669a:f4ba]) by CWLP123MB2050.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5ddf:2082:669a:f4ba%4]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 05:45:22 +0000
From:   Piotr Figiel <p.figiel@camlintechnologies.com>
To:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Subject: Re: Patch "brcmfmac: fix Oops when bringing up interface during USB
 disconnect" has been added to the 4.19-stable tree
Thread-Topic: Patch "brcmfmac: fix Oops when bringing up interface during USB
 disconnect" has been added to the 4.19-stable tree
Thread-Index: AQHVFnmUuy41UgHfxkmVWQMMssyex6aDKMYA
Date:   Thu, 30 May 2019 05:45:22 +0000
Message-ID: <20190530054518.GA31931@phoenix>
References: <20190529235228.38C9E2054F@mail.kernel.org>
In-Reply-To: <20190529235228.38C9E2054F@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.143.242.242]
x-clientproxiedby: DB6PR0201CA0025.eurprd02.prod.outlook.com
 (2603:10a6:4:3f::35) To CWLP123MB2050.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:401:66::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=p.figiel@camlintechnologies.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa8a00c0-6fb1-420e-6690-08d6e4c2019b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CWLP123MB2050;
x-ms-traffictypediagnostic: CWLP123MB2050:
x-microsoft-antispam-prvs: <CWLP123MB20505E02FA9C0EA7F85D770AE7180@CWLP123MB2050.GBRP123.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39850400004)(376002)(136003)(366004)(396003)(346002)(199004)(189003)(186003)(229853002)(33716001)(52116002)(5660300002)(102836004)(76176011)(66066001)(26005)(4326008)(73956011)(71190400001)(25786009)(386003)(6506007)(99286004)(2501003)(305945005)(68736007)(6486002)(7736002)(14454004)(110136005)(478600001)(71200400001)(86362001)(476003)(9686003)(6246003)(6512007)(486006)(6436002)(316002)(66476007)(66556008)(64756008)(66446008)(8936002)(256004)(81166006)(81156014)(11346002)(53936002)(1076003)(8676002)(4744005)(66946007)(33656002)(2906002)(446003)(6116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:CWLP123MB2050;H:CWLP123MB2050.GBRP123.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: camlintechnologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Kq6KX0EA/WbnMbEWWs6ZEbxf+nGvwix1hjeGcuIzhItyGhZ4RRd8oRNeiJhWjQoJ/ePel6EVBQNheai50aCMugQmPW84FtsLvPikF7G9fdLKfWr0pj/CnPOH2+ujxyAq9gnM0Ew94bv60keKEEJ4utecR6O72gBc9eJwFjkvK0gCw3wV45cKGj4lACFY4l1HriM+cgV8WXglAmo95zfX3hJPji+GviYa1s2MZDc5IP5/Bx/ubE4j5Nl001wzi6CQW14tR9UZHxR1FslTmGK7sQcXqkirO3VYIVwrT0pVzSdSsoisl/fMOks/8PPQpOLlrxTriDTsihyx6GENJTzo/Tg5HDObeLsEKjmUOXi4Vxkbh9TBxXMgzh/VxuCHBf5mVXv9aRBCYNzT6dL2WuXxTAVczRST2jNw0JE/eJQX/M8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <873DB994F0F1164FB904213ED0A5D125@GBRP123.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: camlintechnologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8a00c0-6fb1-420e-6690-08d6e4c2019b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 05:45:22.7520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p.figiel@camlintechnologies.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB2050
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Wed, May 29, 2019 at 07:52:27PM -0400, Sasha Levin wrote:
>     brcmfmac: fix Oops when bringing up interface during USB disconnect

> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

I see you taken the brcmfmac fixes to stable, if I recall correctly the
following commit was also pretty relevant and I don't think it was picked-u=
p.
It's in the upstream:

commit 5cdb0ef6144f47440850553579aa923c20a63f23
Author: Piotr Figiel <p.figiel@camlintechnologies.com>
Date:   Mon Mar 4 15:42:52 2019 +0000

    brcmfmac: fix NULL pointer derefence during USB disconnect

Maybe you could consider also taking this.

Best regards,
--=20
Piotr Figiel
