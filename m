Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AC969009D
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 07:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjBIGy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 01:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBIGyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 01:54:55 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2075.outbound.protection.outlook.com [40.107.7.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F8235276
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 22:54:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxbTfJXQOEdqIrV0wy6yE+R/7ITryoP15+DyBw+kJykuCNFmWkJSQ+/UEzDZlCUivHp2sB1/OjQH34Ys5UU6tO9OSyJsuHWiXd6vhgbdhItT1tzyOV7cB3seRAe3ScPn3afMwOUPERXQ/GogAcEtYTRGUXjvPF+mde0idfgQZpPbbGHN2r1BpTiLZXeHtWPyXxeO71Wkz+bivuKAdK4UDpfd1/eyflXIBQiUNTk1sKEfQXEDFPQp/iZ0Oh7JSBncroKLjUwGVjKo6kkguLRNuq1cyNuvT6phVlqjYJ0I3asbLMldAyu6uRDtWxgVs/WyoDRyBsJlP6bmcAlfpyTLXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHEExj657vXnTyxEbY8b9TuNELlTxcQBvC67XvXobVs=;
 b=IJWBJdRPrYAdk7qW+FjmWy9SvqAjOVmOhiZGv+AWRlCti6vtA+r5UkirlnTD+EzAkk9M3pDU3Te72eVaxm4B+yHRuoX/npzJdaC/Sh7fjAvjrycmnGleSvpp+TjKYSDM7jd+gg19SM7dvT2AzaCsbIiXJ/aS19j3aGa7R8iOtDsHrJEwR+q8yYWybcWtwT+R787RfnUhlCMUcVJwtJNKNivsMWIlz3zNA5QDU+gr22+05KVgxcrjbb+GSN+TDsF24kMlv4FI4bXQYNaZTpdOMQRGkrWSHj/OtNmJyKcJr2yIO8eJWwybwh2u8DpZizGgipYpF7HuVXpEPCbkpVi6Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=netclusive.com; dmarc=pass action=none
 header.from=netclusive.com; dkim=pass header.d=netclusive.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=netclusive.onmicrosoft.com; s=selector1-netclusive-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHEExj657vXnTyxEbY8b9TuNELlTxcQBvC67XvXobVs=;
 b=N+AlyAjIEKGiBpNgDi97OhlpHbaBy4N2/I0OGwLj5izc2sT3eTlJYLn6NPIVvBmETWFW/Vnxj1/wo8JYmvEbEWtXY5PmV7ESzIXSRE2KPkdH71y7gfqZdPx62/ijcYZTeREABqO7XcoXGqj7NocqU3uJVsMlPo63NXNk0w6D78c=
Received: from HE1PR0902MB1882.eurprd09.prod.outlook.com (2603:10a6:3:ea::8)
 by PA4PR09MB4544.eurprd09.prod.outlook.com (2603:10a6:102:f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 06:54:51 +0000
Received: from HE1PR0902MB1882.eurprd09.prod.outlook.com
 ([fe80::4740:8147:4e2d:60f9]) by HE1PR0902MB1882.eurprd09.prod.outlook.com
 ([fe80::4740:8147:4e2d:60f9%12]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 06:54:51 +0000
From:   Michael Nies <michael.nies@netclusive.com>
To:     "'stable@vger.kernel.org'" <stable@vger.kernel.org>
Subject: Kernel Bug 217013
Thread-Topic: Kernel Bug 217013
Thread-Index: Adk8U0nCCXnRlWY+TKyDxaRCFq68Aw==
Date:   Thu, 9 Feb 2023 06:54:51 +0000
Message-ID: <HE1PR0902MB188277E37DED663AE440510BE1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=netclusive.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HE1PR0902MB1882:EE_|PA4PR09MB4544:EE_
x-ms-office365-filtering-correlation-id: e8e8da98-69bc-4a01-3cc0-08db0a6a8a8c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bN6ibFQ39NiaaCgYkWaZmcUZb14oQnWLGAPStM5DqQfimJjSTc654jdYml0FKZXKWtw0XhSjjMoP7d56JLoZn4XVLzwvV4Bc7D2BM1wncFJaB59gKNn389u1HJO5W5NEphIzCOdm6taXFSMaPmi4YuGevwYUOy7NNDF09r9xBpnWXGJvCXfibkj66ecaD0jHth9Dnvjvpv6BVefkh4EfuR5wvK1Ew3Chm2NmXvdG7SDJsQoJsv82sbUPiyB3pjTu2nCQGAkTqMP1axpgYdpEI2yOtK8eps0WiXhzWzkfkbJJiE8Zbf944XT0HQAb7ep8YbONP7MtU5NBQDcicHmFumpPS2gM56goU/b5oLBusl1eKsTUeOtJgrD34/MysQikLO4QMxjIZ6K8z1dVL9fw/BwqHxbm/7zgz9sutHXFoHfHRvPRlJVKI6tl8+3VtvzG9KgCpvlfOAyyQPk2WaEdvdpQeR01PGdeKgaqBO7hdQNcAiL/Me1GJbxRplG4y5sNmPlbDvimwk6n1yRZiJmlTabFQH0rt/5X/u+9BPCGmFGH64z8Mz4RsE+lylsLqmVHrGZbOf+dJqzATXOUyxNUq/rkeqqQK5/1lgvC4i3Qnn1SvTN8EEv1bnrRCYmfk3UKOVyU7cKYExNlVTwljR1V7BzwmUfgLadge3kJ4FNuhwxjO7txf3ASJfbiYnG2z32w3NBEjUNYbwTD2ax8r43F1cFVqkZYmu+VUjXuyBeiACP6IIbOcdMqe5BpoKxXwBPi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0902MB1882.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(136003)(39830400003)(366004)(451199018)(44832011)(2906002)(122000001)(71200400001)(55016003)(38100700002)(86362001)(38070700005)(66946007)(33656002)(64756008)(66446008)(66476007)(66556008)(76116006)(316002)(8676002)(7116003)(8936002)(52536014)(558084003)(5660300002)(6916009)(186003)(6506007)(9686003)(7696005)(41300700001)(478600001)(966005)(491001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T88nKkzLwJy3umrmJYtaHtnnjuhNlfbWhX0gEn5htx6uNMXpxpsBuKZ6AYJR?=
 =?us-ascii?Q?ehXgconC3/2NDDZZJ/7ZM4HVkj6G2dOvFcprxmylABdcgwf76YOuf92qD+Bk?=
 =?us-ascii?Q?r4Chmdjm/wA+YIEX16AM3g+XwnEhFNh1Lk2XFOrMLxiSD70W39QcTlF4iqRc?=
 =?us-ascii?Q?sVoitONfrfONQzhf+O5skoceJA/N5sR4zg5JH3YdsEnH4LVez1gEttiFQRog?=
 =?us-ascii?Q?zq8jw3gPmp2Q3dvOTBPNpIIHEBFbBID02qniF3EsR8flklDZJMU2SDDlIWSu?=
 =?us-ascii?Q?O8Ap7gOavbkf+tVA+/j81lcjh+7YsTGho6993Oc9e9ExKJ5ieklatzKwlnXy?=
 =?us-ascii?Q?jA03BywUCvJcWV05Q0RzvOGUYwdeGVyPCzUbN/uwJLwFD7cpUYQ2dQjoRuPE?=
 =?us-ascii?Q?QnTkVw2TDplBoq3/5zzApSIjB4vjmGWEYA2BuXzZ1u/0el8BjiMEz1Hp15N3?=
 =?us-ascii?Q?BYuNFLZH2gGq1pXcrCceRv834eIzGUlrvyNzL8x9XbOcX0QHprwURun2QVHX?=
 =?us-ascii?Q?tSxjv/jxaVSumW7Q0QcFlpdwDBK/Q6+5zxE+KRSC3uKFbGp7/ttv8i+CcTKL?=
 =?us-ascii?Q?UOiTqmt9cBfVwMdZpjA8NLMZL11IJVzkMf54IQjtitlVh4EkI4o7/nNjZqsI?=
 =?us-ascii?Q?jL+4fZcE+OjydfF23KPTTJtRVEKj8O5dYNb4Z12arAQw61f6rUFAC2gNEsvN?=
 =?us-ascii?Q?KQRj/6CGn37xjyiT7Sh3vHVkHXX4y3iRgNCaL74gMIMVBuZb1+ooVqNjb8Ea?=
 =?us-ascii?Q?p6QfxkM/VQvCkMc6exJcRIQRzad87TDp6+BtuUR+e7y44QzskDopzstBtDn0?=
 =?us-ascii?Q?HOqmx/FTpLsjAnvgrDOSzw9fLwxaZZ2To3EGBKcFjeNGQ2vJuURou8SE4L72?=
 =?us-ascii?Q?LUhpE7KO8qAFEVhl3qFAfZ9brnI10WszoRBoc7rMmlB6jv9/UVFauY2kylIu?=
 =?us-ascii?Q?oHbGcKwia2rgypm8MyP4pStplrVDUTrgmLuG7ZAiWeeWkGzs6VVV1Cegar3p?=
 =?us-ascii?Q?Ho3JBlrzb8tcfwOnq4T1TBmDn82bDPakbqkUPYuYKfkcp1GJW8hgcEWrMPoO?=
 =?us-ascii?Q?x24zVC4BRdW+pwv6ZwbRxkFciXrzHe887gXR3QLoas9cadBZ7ZRNvhbvVnmb?=
 =?us-ascii?Q?N0SEDlJvsILTj1d9IZL4S/zamcA3dA87RAO9TQunQIGolIo9TuYLIIrQkiQi?=
 =?us-ascii?Q?HhzN0Ar801snq4HnAWRJeRox/pmYJcDf0ZSWlXYyaMuOgLeYSYfigwjPzS/i?=
 =?us-ascii?Q?WWBMYaQmIUjSCf4fh7mf3sfpCbY8ABHhGn2jARWoz5UTkNYgqdpNd3so5z2/?=
 =?us-ascii?Q?qxuJibLfz+qhZD7q4yxrzXJNlNghTWTxSgi3DuBBAPcvDzGph0yjCqD9spsO?=
 =?us-ascii?Q?pOb1vsiTDDdKvDvOFqQ3T4MK8+wl+nyNo5og7WCzEIwuUl0/BtwEEkUfc61s?=
 =?us-ascii?Q?Tb1i13QAjBEcbsWz8ExTbMeMqIQmYZbw/btK6seWg82RfxibOQrSCeaOsOSV?=
 =?us-ascii?Q?LIudZHEGWWr/vT2/dN8ClDh7xM82O/U0TS8j17IMOOtpAnXTB/VpBgMkeDKo?=
 =?us-ascii?Q?geIcZdfmiN0eE+tzllAJhXI5JCjeGDDCWOrd70XVP/Df2oLSH1+52VN/0WNH?=
 =?us-ascii?Q?REYuP+jtZt66njJuFmMlfS+HrNO90C7hDUtDKaoqW3fU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: netclusive.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0902MB1882.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8e8da98-69bc-4a01-3cc0-08db0a6a8a8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 06:54:51.0158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7efcf5f5-5d2f-4b3b-800b-1cc1cfa2a04e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fs79dBN2g7v5rrSmgkXFfTiKeKyd194v/rXErgAvILSGsSDzdzzMPEpM7hqpX4ZKSOV9euW2PXn+W1w6NLuvIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR09MB4544
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

could you please have a look at Kernel Bug 217013 that was reported by me y=
esterday?
https://bugzilla.kernel.org/show_bug.cgi?id=3D217013

Greg wrote that I should write a Mail to this address.

Thank you & best regards,
Michael
