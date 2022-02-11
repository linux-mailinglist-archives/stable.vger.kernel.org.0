Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F8C4B1D79
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 05:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244510AbiBKEvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 23:51:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiBKEvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 23:51:32 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2067.outbound.protection.outlook.com [40.92.103.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0099725D7;
        Thu, 10 Feb 2022 20:51:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Frp9qhuIDdDdaXzd0o+o3bWJEGfsu/kyGwi2+jggVIOnd/A9JOTPQ+1kfD4+NHFj6gA0n++I2tQfT/15NBpxZsQEqoWMhtQzO+bamFJpbDlyPdpRxmr+cuGKv37Ur5NWsF/uz4J+umXcAnMoSBVDfnAGhBs9EYrUOHR9sSELysQ2JgL028+KMf5RhxOs+lZjiChB0r/JRyfEYtrK1faV5wtpjQwxCl94ko8MTkIy738PP8hiYtrh9wBD1THZ90LmR79vPy4vh4R1fVJpx9q0uV/aUH09btnhFdfWmh9bx+ZcZRPIwJth0jOjXVxfdF/2eS2hTTEHbxbz6LFXuKJ8Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHWL3RkOCaKZtr+FJDWPqHlV39WQXqBUx8ROmYfRmIA=;
 b=Ddw+GGoYsmhPpTjGEbgLp1h8xSS8KMYab3bWCUCwp4vwJw4e/hc/Ga9ZAjC0qvByD6iEz1ZhYI9W2Fa2F4o65lHeYHK9C498r+11mZCkPNHhPRF7YIT+bMdVOj311rSARU6AvDM1ITx65UFvQN4PDsohlMeJUJ3TgzS/CiDLNLeeijvJAoT/Lj35VL5XJb0HF1hPYhhVojnzOb7WOXgifzk3SXhJGGSXCny4tKY3ESkYfizXu6BDIjADlxNZ8L6ivPpfj9Meyg6tUwLOJ9g3E820WCRwYz5ilfLiwRjqxpscz60D+N2kTf3kiusJZU3FBNMj1A7TeEQ6sT/K8zXnwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHWL3RkOCaKZtr+FJDWPqHlV39WQXqBUx8ROmYfRmIA=;
 b=f4oOS21U67OHSVtcBPWj3R5uX/FGgdyleJ66DY98y+4zTQwvJTNNogtfOCzrjWjiE0lpvq4tAZzPHireVB5Vgu6P3QB0SW55BP3LiiLa4dRPLcjISDW2lIN5lfBdMF8A7yng8o1y1d8FbaHK06FPehjjsiYkaj9VTNOz3s10naVou8hC0s90avedFOftEZ/2zxMLr7+ocnezg+58NWDrcjQkTRU4gTiy+LZYodPYtgtZ7aCvg1QBCjFqjUpspPRQJ634i509Bnd5decYox+LRdu2z5Vdctqj7x1zGPWc76puV7DFi59tpai7E+PWlL3OXkNj79I297f57HCU5QNTtg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB4361.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.14; Fri, 11 Feb 2022 04:51:22 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Fri, 11 Feb 2022
 04:51:22 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Matthew Garrett <mjg59@srcf.ucam.org>
CC:     Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eric.snowberg@oracle.com" <eric.snowberg@oracle.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "James.Bottomley@hansenpartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "mic@digikod.net" <mic@digikod.net>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aun-Ali Zaidi <admin@kodeit.net>
Subject: Re: [PATCH] efi: Do not import certificates from UEFI Secure Boot for
 T2 Macs
Thread-Topic: [PATCH] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYHcE4ht34Z1CESEaNjR8+yzmieayLbqGAgAAURwCAAAlIgIAAESOAgACrMQCAAM6NgIAAs3IA
Date:   Fri, 11 Feb 2022 04:51:22 +0000
Message-ID: <99BB011C-71DE-49FA-81CB-BE2AC9613030@live.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <20220209164957.GB12763@srcf.ucam.org>
 <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
 <20220209183545.GA14552@srcf.ucam.org> <20220209193705.GA15463@srcf.ucam.org>
 <2F1CC5DE-5A03-46D2-95E7-DD07A4EF2766@live.com>
 <20220210180905.GB18445@srcf.ucam.org>
In-Reply-To: <20220210180905.GB18445@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [yZA/DGOyESbG5o3D8r1SuhFdfL3lA8xALCuWaamire3Xe+wG+tiI680FbAnCRFs+]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe319675-92a0-48fc-8ea7-08d9ed1a2706
x-ms-traffictypediagnostic: PN2PR01MB4361:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P4Yi7ScuYmDjcqWAcLDPCvtIcwSKFGNWDGrc8qA4qG1pDji5HiEkspakdYZ6vmnGhO/3B3SYsiblb8hyLc9J84/z12e4pWCEp69506rgybMXG8uXX/4BL+noAVQkk10HkqBY1KwMSp4gIqHwKvVYnqQZ4pyEtlABR0EX36Fm5h6XqPh+4eoUIGWEPIMDMRVXSIneorZ8yS6wAHFndtxIVtVPgFyZ+6WCEXD/S58sJWe35xq8igsaJx2dPcv7cpWISsM4A7DcvdvaULYo/QZ6MxIrOyW57NrFFc3bqvjweafHDUq8cvTiKyPBurUezEwASjQKy9Su3su862YVUOUPcKUMmBUXOm5P8Wnu82Wqji8rMx6/4rsQ5Ur2WOZFWSsJzi6WU/DDj3xs/rBNsCJJXlDAIbget7EQToEbN/aF98GQ3EHs9gjoR07vgGH7UeKAz3q6l6k7C6dZMKN67oZOciElfkcEx9BJLBQPDUDr7oXQoxngqXY4GkG8HotEiScFv5JDtdlgBFiIJU73dpy6Q1v5cioE3uAgl3xR1vwMrZMzmKy30qDgGFUfaRQihd6xO9kbGfsxZTVJ6d4IQhHAKw4jEUANd8wyERhIeyu2fe2vz4CT5teMC2QH/6hwJuPM
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8r2JYH0jnBtJL4U0heP896Qmk59HA+lCNjujpOgpOg5Dta6Spulu7mF0izMg?=
 =?us-ascii?Q?K6dmMvXieRs48+zMElwsKoP0qpUDnE0J94IUDO/5LyOwkpwxxFFLZovwg0xY?=
 =?us-ascii?Q?M6pmfhzhZJIMYWuUU0pulJF0PlFZtxc3GOX85CPMo3OLhD2sVGswQCw8EWui?=
 =?us-ascii?Q?yLkFZ6EYSmJC1snQtumg89pAYZLMr/OsgUp/EDBqQI75V7APxNEUWjZaQbjP?=
 =?us-ascii?Q?i+uJxaGYQ7WDJeYEcEPIZ2dlzYdtP3HDSm0b9oUsitRDRMVlp2cVlSZgwCBL?=
 =?us-ascii?Q?6NakrWsxaIGvZMiCQvklR9wGuEwtGwZHqKmLDQWMAKvc7phfI/QyGqAtSbiy?=
 =?us-ascii?Q?OdPRgqcfhrvGa/z7U4VeCaXHjKoOubS/MBOTlrvtUjx5SfeUwSXJypCFeyXK?=
 =?us-ascii?Q?dygN9kq4gx00bUQNDR6fYKu/Fy6OZ9B4HJ1NglYOQh25f16q1DzvIgtueqnK?=
 =?us-ascii?Q?ntdKdMcexq7m+yVeKMBfF6SnAJ+VeJuQcabYSdReXKeSxyvFb5nn8wTCCGCv?=
 =?us-ascii?Q?QDNKLsjZpTSST5TTm4fwPlelb/qoVbJAaRFwpHIiivUEvZt5VRMdcU8XzGE3?=
 =?us-ascii?Q?zIhCKOdWeZ1LD4Xj/K80o9UYTGR9U8qWYun9Xksw7Ve4p5ksAlAcdgjtcRMQ?=
 =?us-ascii?Q?mtfa6uX5Wi+l8qOQUNAGZ6egYSluQ9w37Ox3+BC2MuCnm+oBI74HeFXgsQad?=
 =?us-ascii?Q?dKOhORGgkmznqtFxdMSQca6kd0fICFmoAdrqg6MJG9vlb8TTFseVqD7MTW9J?=
 =?us-ascii?Q?jAiIbnQaNVQ6Npv00vau+7YOsyc4bKtdjEEqd4QhVlzRbw5f/WZKR0Cg8pmQ?=
 =?us-ascii?Q?OZRSOVmTvpbjwf4UedG7CKbJefyC3B7w4sEvgqoAKA9bMYt7QNZF8tS8J6Ql?=
 =?us-ascii?Q?/dXTZVyZrnWXuBnK1C9B9d8oVV/nnGfLe/178O479GrmQ1dBQ+jUUyWoMJ7N?=
 =?us-ascii?Q?aMlaw0sanMbSnioRC+ETGNebv84nC5YqQp5XKAKT3tVqbSNGApztOfkSvZo0?=
 =?us-ascii?Q?cnhMSODtvP/zZSfhvuqT3qBnuA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C85B47D04F07CB43933C5B0A4CBB4230@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: fe319675-92a0-48fc-8ea7-08d9ed1a2706
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 04:51:22.8528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB4361
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,TRACKER_ID,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



>=20
> I'm sorry, I'd build tested it here but clearly screwed that up. Try=20
> this one?
>=20
>=20
With this patch, I built 2 kernels, one with CONFIG_LOAD_UEFI_KEYS=3Dy and =
other with CONFIG_LOAD_UEFI_KEYS=3Dn. I have got different variables causin=
g panics in both cases. The logs couldn't get saved in journalctl so, I cli=
cked a picture of the same. The kernel anyways was refusing to boot after t=
hese logs.

With CONFIG_LOAD_UEFI_KEYS=3Dy, this variable seems to be causing panics

MokIgnoreDB-605dab50-e046-4300-abb6-3dd810dd8b23

The link of the logs :- https://gist.githubusercontent.com/AdityaGarg8/8e82=
0c2724a65fb4bbb5deae2b358dc8/raw/2d3ef24c2b5025d500c5bebd418db5c185a47328/C=
ONFIG_LOAD_UEFI_KEYS=3Dy.jpeg

With CONFIG_LOAD_UEFI_KEYS=3Dn, this variable seems to be causing panics

AppleSecureBootPolicy-94b73556-2197-4702-82a8-3e1337dafbfb

The link of the logs :- https://gist.githubusercontent.com/AdityaGarg8/8e82=
0c2724a65fb4bbb5deae2b358dc8/raw/2d3ef24c2b5025d500c5bebd418db5c185a47328/C=
ONFIG_LOAD_UEFI_KEYS=3Dn.jpeg

