Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17343E7380
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 15:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbfJ1OSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 10:18:41 -0400
Received: from mail-eopbgr50057.outbound.protection.outlook.com ([40.107.5.57]:59521
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728544AbfJ1OSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 10:18:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/IPYvQAMYInQl636mUWBsefv5gEor96c7VT/0a9cOk82F3HkDUcInIvRmYB38G51nwZI3W/+uWnOHuuo9XwrFJAyHZHHR4SG9lo98TvG4/k8Qebd6YpjLgNgicIFJ0Dje6uSpcMiF5+JvZwLiU1DV5j1qcLRLp4WSHgnlT4dxKv8F9qpsN3ALkrkTI/IiT0q9HLh1s+jOhP/nkVsGvZguKdt7ZXmj4h8fpOHjBtyInRvtYQ9BS5NSk+YGmx0dpQ/pXPvQweWm9S3DAoYuK/ikRI5r5fYMB9TWLCvW4wqxZ5kDPPlprqZau7SmAwNMMpljkdiP75osbdlWjun4F56Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fu5O/5k4IwSHoNcU4atzij6jD+YC7ivT5mRoLhowfKU=;
 b=Z+fJKq6VoyZsBLB/SL5H0PP7w0g+/WfBdR10/cOYnpLRAbi2kJQ6PIye6PM8QjY+7yfdPmJpV1TC40BQE9J40UEDm0ZJpEd7Y/KtS8l6TBPvfU//aEbmwdgdELm3Xg48lfJGMLt78oM6JSQDZszuDZ5blc5CNvVjdUJq8r4meFVuuXH3c6+xE50UYn/bJ7vlZSfiLS3AV/Kbg2v936qUAJbzeK8zvQ6Fd+ABjzw5wpQD4EkczAAl4i/CaWf9DSpDd/1r1U7zd8fYKglaWeP2IBXB7/n5cs+3WnT1CaE8Mc1Yg5pU1tVW+H2zTP2yqhUpYW619+n688J3Pd5UTDwiEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fu5O/5k4IwSHoNcU4atzij6jD+YC7ivT5mRoLhowfKU=;
 b=LhJ+iEINwnLIZAZDrKfXcyRzplMcEXFEiIDVGgtCCC8h1U1c9zeF+CGFb9J5eCAclNhE+mfMPBSabFbYRBPX3hBOh8vpXwAqPcZITHUM4Yx56szXbkeV7qr9jtPcnAWl2Eed18dQI6aQEm37MypVjcT5q+q9R4de9AlFioW7QNs=
Received: from VI1PR04MB7023.eurprd04.prod.outlook.com (10.186.159.144) by
 VI1PR04MB4448.eurprd04.prod.outlook.com (20.177.55.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 14:18:38 +0000
Received: from VI1PR04MB7023.eurprd04.prod.outlook.com
 ([fe80::24fb:fb99:b1c6:ba1f]) by VI1PR04MB7023.eurprd04.prod.outlook.com
 ([fe80::24fb:fb99:b1c6:ba1f%4]) with mapi id 15.20.2387.021; Mon, 28 Oct 2019
 14:18:38 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Sasha Levin <sashal@kernel.org>, Stephen Boyd <sboyd@kernel.org>
CC:     Shawn Guo <shawnguo@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] clk: imx8m: Use SYS_PLL1_800M as intermediate parent of
 CLK_ARM
Thread-Topic: [PATCH] clk: imx8m: Use SYS_PLL1_800M as intermediate parent of
 CLK_ARM
Thread-Index: AQHViQ3qYLRhV3CzhEeqhZsvUx8hAQ==
Date:   Mon, 28 Oct 2019 14:18:38 +0000
Message-ID: <VI1PR04MB7023BCCB8A07D748EC845899EE660@VI1PR04MB7023.eurprd04.prod.outlook.com>
References: <f5d2b9c53f1ed5ccb1dd3c6624f56759d92e1689.1571771777.git.leonard.crestez@nxp.com>
 <20191026131046.00973206DD@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 71264ec0-642f-422a-98a3-08d75bb1b9f2
x-ms-traffictypediagnostic: VI1PR04MB4448:
x-microsoft-antispam-prvs: <VI1PR04MB44481854CB00A9B6DE44A145EE660@VI1PR04MB4448.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(189003)(199004)(14454004)(86362001)(446003)(229853002)(486006)(25786009)(9686003)(55016002)(102836004)(26005)(6506007)(71200400001)(71190400001)(53546011)(6436002)(6116002)(110136005)(4326008)(478600001)(44832011)(6246003)(2906002)(476003)(8936002)(81156014)(8676002)(52536014)(3846002)(81166006)(256004)(99286004)(66446008)(66556008)(64756008)(66946007)(66476007)(4744005)(76116006)(91956017)(33656002)(186003)(5660300002)(76176011)(7696005)(316002)(66066001)(74316002)(305945005)(7736002)(54906003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4448;H:VI1PR04MB7023.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v/TGOPGpnznqFGgp+khTcx4U9sxtdIhh1IGkW6p2czdE7IIP292hRV+srbdymVv4fFpJiNpFFsqorGaVIPubskeDEilfOvz+E+kBQJYi9dtF38wKFyxVW/iVt12mnLEiB6glfB7H0i4WEQ7pt8qHQtDwfVkcB3EKiyXH6lK/2ieBMNqDAZnBdNu8VX/AITEnTb/HDHrJv35+MvtAUNovKQYuulZtXhOcpQh5Km9CkFg7umV/MFWXcgRhyehD69v6KE2JyCz4vtpEKSV+8gGqB+9M2LyVjhFUeO1UXq4Uz8FMSk5reUDrLeXnP6sylL1T2VKYkvaHCbeDTCkyjPD+YNvQc1G9kbL6JL22bUxKLJQp35afy/96ZzDWC1J7sZolTxqszRhK+/ZFYvmVCVFqKNrB+A63uv/0HteTULZuwxxoM9uu19In/bFnr/II0S+4
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71264ec0-642f-422a-98a3-08d75bb1b9f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 14:18:38.1514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eTcinBKCQqtBRncDbNtjklpkYxbgd2bSVcnXrnvPzofF8k9WvsdHHl1ZoEMYmZyrQEeoT2TuJ1E/hA188JWGDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4448
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.10.2019 16:10, Sasha Levin wrote:=0A=
> Hi,=0A=
> =0A=
> [This is an automated email]=0A=
> =0A=
> This commit has been processed because it contains a "Fixes:" tag,=0A=
> fixing commit: ba5625c3e272c clk: imx: Add clock driver support for imx8m=
m.=0A=
> =0A=
> The bot has tested the following trees: v5.3.7.=0A=
> =0A=
> v5.3.7: Failed to apply! Possible dependencies:=0A=
>      96d6392b54dbb ("clk: imx: Add support for i.MX8MN clock driver")=0A=
> =0A=
> =0A=
> NOTE: The patch will not be queued to stable trees until it is upstream.=
=0A=
> =0A=
> How should we proceed with this patch?=0A=
=0A=
This is a single patch which fixes an identical bug in two clk drivers =0A=
which were accepted at different points. I was going to repost in as two =
=0A=
patches (8mm/8mn) but I saw that Stephen already applied it.=0A=
=0A=
Just fixing 5.4 is fine, or let me know if I should resend.=0A=
=0A=
--=0A=
Regards,=0A=
Leonard=0A=
=0A=
