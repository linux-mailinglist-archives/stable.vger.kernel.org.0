Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E7B36836D
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 17:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbhDVPgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 11:36:51 -0400
Received: from mail-eopbgr1300128.outbound.protection.outlook.com ([40.107.130.128]:10711
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236563AbhDVPgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 11:36:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgeLpC/QjS6a8GnRr/SP5r8TxS0thDMvIYxUuWg5g3iYKgq9k0RwI3Nz64TyUOLJg8pNuPKZBi47jMyz8hIx3NZk1prKe91RptRgb3KMC6kyb8MofNwZ7jmVe38ZP+rBNKIVo7GXRqJ0YMqYDgE8ZeuYudSUIA0zEHKmN8RpW+k7eQo2rIigWBHEn4EhWuBAj36hD2f905b2+IaXR5b5ABiKSKWXg7gXL+PtYprqPrL6CYYWM9a30oj4/QMtv/CnHC1iiDt0Bq22sj13m2ZHAFzerIHxxUcOgCW8SWNPjKSDvJWA0+abckQo+3zozgmzTFldZiIom/fq0/zKVY55Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9S/Wqc0icqPkbPPgDWqa8l3+Sda+7bZ2XUUgI27ZNQw=;
 b=QXPiiWQHJSiLPAzbqwoLdzk50ze4g+DYfgjRxu9NgV4zQErDIqNXl8qJRReukAYaHy4PWCgHxcvqrkzOz5Wqxx6Or+fzssl5gSmO0agduxU90e3dhDETvnl83YpAUQ8c9/vjGjVUArYt/zldVa4w7V6iDVRIAK3NpmwodTvMmtoZbavzMDoLxebVFjFpn43kN54pt4KJ47NZ82NkghPpPWrWu7Cfr652dJ+jwJz+jbnrsD75iSq9xfW+YXvRYjd55+w7WnXuiGN+dQlNs9bPlKLWWCa7huGrGacrZyeWlL4fCrJc8jV6gA1S0YS7GlnnOhAkfPj31EbUe1FnFKIa7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9S/Wqc0icqPkbPPgDWqa8l3+Sda+7bZ2XUUgI27ZNQw=;
 b=dC3DYNEe3A2pzonmgGxCRuMI/kPtsIoLQPdl/nkRtogBLobHegeFMHp/JUMLf/WUrc+tntWKGBVPbPz2vb/QcgANX9TwLAusjjUXRXffrMuL2ottXaa485fj069US9+F3JsrVAo/d4qUBU/0zB1BAZxZSxVYdHizjtBwIzufAtI=
Received: from PSAP153MB0422.APCP153.PROD.OUTLOOK.COM (2603:1096:301:38::12)
 by PSAP153MB0520.APCP153.PROD.OUTLOOK.COM (2603:1096:301:90::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.11; Thu, 22 Apr
 2021 15:36:07 +0000
Received: from PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
 ([fe80::9921:b743:c0db:6f50]) by PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
 ([fe80::9921:b743:c0db:6f50%7]) with mapi id 15.20.4087.019; Thu, 22 Apr 2021
 15:36:07 +0000
From:   Shyam Prasad <Shyam.Prasad@microsoft.com>
To:     Salvatore Bonaccorso <carnil@debian.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     pc <pc@cjr.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Thread-Topic: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Thread-Index: AQHXKtl3oEpPTTCadkuXKYVCCMdGI6qnf4aAgAACKFCAABQAgIAC7L2AgAYL/YCACbwcAIABHItwgADAs4CABC3psA==
Date:   Thu, 22 Apr 2021 15:36:07 +0000
Message-ID: <PSAP153MB04225D77E22AFC17C4AEA52E94469@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org> <YGxIMCsclG4E1/ck@eldamar.lan>
 <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan> <YG7r0UaivWZL762N@eldamar.lan>
 <YHP+XbVWfGv21EL1@kroah.com> <YHwo5prs4MbXEzER@eldamar.lan>
 <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YH25PZn5Eb3qC6JA@eldamar.lan>
In-Reply-To: <YH25PZn5Eb3qC6JA@eldamar.lan>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-Mentions: gregkh@linuxfoundation.org
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=83def35d-d9f7-458b-bac6-b54f28f1711b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-22T08:58:38Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: debian.org; dkim=none (message not signed)
 header.d=none;debian.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2404:f801:8028:1:60f6:ca47:5dfc:b1d0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3c3c244-1cb3-480a-caf8-08d905a458f4
x-ms-traffictypediagnostic: PSAP153MB0520:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PSAP153MB05206C86F6FB63DE56CA04BB94469@PSAP153MB0520.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DjO3jEm7H2Kl6+93uUC4BgFGvWHcl3oymP1+DmW46W3QHZc26rcM2s/D+3otQGbni38lXLNHPPJ2YPUHx8WNAPqNmnqFvFC0JND0m1xCkeu9hN7p3rvyqslZOamw2q6xDMQirl7O3dy915ZNBwZjPgz5CaZctWqalS490vYeyDNXj+3BHROHUFO2PGHPdHpX42rXWiJHBUJvpZW8yu+qME0odxojFrhWeVSAu+vdLDRbzl9Vgap6/8blMjZ4Ywvx1CPYFuCQ0a1CDZq0arSsdgTstlFVGFzJnoUZZADVq0rK3UVM3V3XpSkf/QplsLVAJHeQAbwkvthXvl1qMUEmwzcfJzYwbC+LzWPihKUD5JuWQRMGiBnEFmJmUSnWLdCCTlF5/AmL7NLJZNo3yXA6+vFoSQmxxX38AVtSvcN0pQWZmdb+OwfVlLaxhbqNsauzFBJ7CyA8O5WCW0T/EikGvD1or/5jJ6p1ldfJ2w+eSPny23UyjOYS3nBnHJvVEiyMHEHRXxD3gdw/HZ78cMcX8V2b8dQuLbvX+GXb8e9RI8nb0EoDErx7P75eaew/aYdrf9okJM0IQmh46MnKlVTbrFpLJFeieqIsKAQ7vN9ps04=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAP153MB0422.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(33656002)(186003)(54906003)(110136005)(82960400001)(66446008)(76116006)(122000001)(66946007)(66556008)(64756008)(66476007)(8990500004)(8676002)(86362001)(38100700002)(82950400001)(83380400001)(55016002)(498600001)(7696005)(4326008)(53546011)(9686003)(6506007)(71200400001)(52536014)(10290500003)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YMPsk4YWUV+QGYF2J1sTJSCvSfx2TS0XcqXxaCTgpesbOqeHTBFw+tqotK+U?=
 =?us-ascii?Q?ImEPYxykYDXmsCN9aIJrNT2ngFcE3iw1/69DuL634fZgQ2h4wYDPNYdA3cua?=
 =?us-ascii?Q?9903XmDNjBgNzgTixofW+dixGmA0V4bt3WBJzayRxx4hz31oFxKLCcspmTYP?=
 =?us-ascii?Q?nOtNscR4+OUbmfuYd2JZIVsgP/iJp170HbtZEdE0t/hQs+aZBMFvHTk4+4Jh?=
 =?us-ascii?Q?VEblbpS8C6KxPZCgXtwW8TFRZ1A8worBTr6vVRcP2aqvCDu2oMPM4J2fdXvO?=
 =?us-ascii?Q?XmU6G/3GaVOJ94ZE8SZpYMmqkj1ydjKY1hX4VU6cGl2AHaJfMz4QjAfXzMu/?=
 =?us-ascii?Q?zPZ3OSvLxW0Q2RCluldxDnsK48hRQseAW2QzY3F/qqbLseKD5QyyzFeIRkUy?=
 =?us-ascii?Q?OpdVLyuAQ/zOzsPxIG+sp/H7cg8nUIQUY7OyTrDnw1q9cZiXSnFW4hPOd1EZ?=
 =?us-ascii?Q?fnXuFiTnN19B4WfI4+pDgB3Kfc+5uixBqpcWITfO8fbe/uU0ssn+BJy46Bfi?=
 =?us-ascii?Q?JZRM+0tdmdw6L3Kk0hYBkHhJbyPXxyjlCta68Xf0J+gAjEeGiErFxDahxM6L?=
 =?us-ascii?Q?iBTC0E06nl1yEeXq+PyAI2S/IgsS7fcdjTCNK0z+UNvKsZMySk41WZ56Ha0e?=
 =?us-ascii?Q?UJ8RcbrnRPCosMvTyxEWETrmiGVC83zVl35yTTuNDw4Ki3/+dKcRp6y1XNss?=
 =?us-ascii?Q?fnR1xMSCjhT2hgEu+DayqRtfve4uaRwvDOR1q3ToJ4GCJXMY8JqH0LdsMKVy?=
 =?us-ascii?Q?fHqZwvkTGfNIWqvnbr+SBrpKV/yqfSmq32Rj9M218KsEl6xfgt7xWC53Zp0r?=
 =?us-ascii?Q?U32UVxF96vAPwWl4HHHV3JJ5+bWkoi/SfLA+0+TiSzLMd3yKau53qcIDTztF?=
 =?us-ascii?Q?5Cb/eOGdOK8uukOGqBlAqxnmC6taKt+AbLSEIP6VdJj28E2K3oYi1bYEKBHA?=
 =?us-ascii?Q?XT4ST7xXGA8QJi8zqhMNHcuQngTA5WIEywKVLZ/t/6ivkFc9MIjSkvha3p5e?=
 =?us-ascii?Q?LH2xm2aWIqjcRcckQuqqRX/GVs8WgvAvBfo2mXub55vTtDiZM/AZsAO5PrNg?=
 =?us-ascii?Q?Al5TdNP4Znv4wqrDV2gyXUIaeJa/KWp+ObPBX3msoaxPuR5BG7a09dHKlt3G?=
 =?us-ascii?Q?xKwd6eJy5eiu/geIeiUzkUdWy24/HwQVjkGpClXArlOucbTMCqpCTmolEcsp?=
 =?us-ascii?Q?uxmli8RXB2MjmqZBUGlJjtQEErDDmP3eOh5Npjqg/K6YRSeLf4qXmFYFgwfy?=
 =?us-ascii?Q?B7/Tes/v5KO+XodnDd2bAhqjCpA2ykK9nyRU2EKWdNs6LXZX2Ng13zEVYPmv?=
 =?us-ascii?Q?pTNkPKXCdtlG1tg+QU5jhwtNrCqOyKKUvYEJrbjZyY5xnf4A1B33fbdItDoo?=
 =?us-ascii?Q?l4lBkeMrgPCMw/FxVY8EjZKcv0D0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c3c244-1cb3-480a-caf8-08d905a458f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 15:36:07.2479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bEQMizOaALcmZL+La84pO9J3xocN3z7lhCigO2Z0ffg2noOc4821iDmt4sDgj6o8WdOCUpIuWRtGneUON4ff8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAP153MB0520
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Salvatore and Santiago,

Thanks for testing this out.

@Greg Kroah-Hartman: The reverted patch used in combination with Paulo's fi=
x seems to fix both use cases.=20
Can we have both these taken in on stable kernels? Paulo's patch is needed =
only for kernels 5.10 and older.

Regards,
Shyam

-----Original Message-----
From: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com> On Behalf Of Sa=
lvatore Bonaccorso
Sent: Monday, April 19, 2021 10:39 PM
To: Shyam Prasad <Shyam.Prasad@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; pc <pc@cjr.nz>; linux-=
kernel@vger.kernel.org; stable@vger.kernel.org; Aurelien Aptel <aaptel@suse=
.com>; Steven French <Steven.French@microsoft.com>; Sasha Levin <sashal@ker=
nel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set CIFS_MOUNT_USE_P=
REFIX_PATH flag on setting cifs_sb->prepath.

Hi Shyam,

On Mon, Apr 19, 2021 at 05:48:24AM +0000, Shyam Prasad wrote:
> <Including Paulo in this email thread>
>=20
> Hi Salvatore,
>=20
> Attached is a proposed fix from Paulo for older kernels.=20
> Can you please confirm that this works for you too?=20

I re-applied commit a738c93fb1c1 ("cifs: Set CIFS_MOUNT_USE_PREFIX_PATH fla=
g on setting cifs_sb->prepath.") and on top of that your provided patch, an=
d this seems to resolve the issue for the testcase I have at hand!

Regards,
Salvatore
