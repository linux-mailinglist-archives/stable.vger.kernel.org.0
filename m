Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D572B7C2A
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 12:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgKRLMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 06:12:54 -0500
Received: from mail-eopbgr50135.outbound.protection.outlook.com ([40.107.5.135]:15491
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726216AbgKRLMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 06:12:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IkMbEce/MW8MV/aGviF4sAOFdlI0sauSQgoRVep98pZ9NJDeQSkz2axdUiBrzITnSzTjEWzzGEjA+4muZvUbPIcxyhuA37z4gf3PXq3YsO6pxnyJBTUzD13U9mKaCVyMBaY9qox3sIz5RCD+24hM0513vC1Wc4356K+BlLMF5DgjTDiLMy2BfRGSnfi3XvPrDEGqXiTkNsilO7qGHWUImmVsdfu7mVxu3Y0WK/iS3lMsruuIIZOlEk43T6Yo36cCCjP+gLk3ri06rzntuYnDS/UGM1nDu7UODS7ThW7vHzf5v6vyD4lXxwup7JHDtoMjAlwEU3JTLbmPtX8C0JR1pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdHQtO6EhGByLPrx75jRd0misKA3pscuaJAjF5aWO8A=;
 b=Yh64QuziWqLeb1DQEpJJU3NxusJChsbF+mcAln6ZiEWjjdC8p0iTE+0lczxS4pYPrYjcVlFwcYFHSqyf6VqSCAEFqqZJNLxMFlAedZhLWaFvxO0yFGaOTLhiRwlEEy5nh4W9GcmoDU3AQxdhkgRJz+jZdewEYmaMFmaKEZxOWIfy6w5/QtbtfsIXNMekevr9OV4Qa3PTuBQYX6hQnj/mwGi1oBK7rCFXgPnR+mXTzAq38XQVu80kixFT9F6GrBIE1x9RSwRIBGbOl8PsVU3nOV6+KgxqL8avGg+0uAfCJTYrCfYsBJRSGxaVYfaJIdbYLePVhnUgxKYOsnKPcFYUxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdHQtO6EhGByLPrx75jRd0misKA3pscuaJAjF5aWO8A=;
 b=v3/tPZPKtnTkWkLvREKRAxAbZwJEn2vsFPjC7lpydhiCTC0h2A8tGBZIP1xbH38QFTBAJ6BLSdB1efqWeVQ0sephHa9xoTnYmBCN6F9EvAQ0it3soEQ6sN/lVETDoN0ayEdHBAcB1InySgr5czN60QWQzGDkpKNyv7bhxmOzI6E=
Received: from AM7PR07MB6707.eurprd07.prod.outlook.com (2603:10a6:20b:1af::11)
 by AM6PR07MB5495.eurprd07.prod.outlook.com (2603:10a6:20b:85::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.9; Wed, 18 Nov
 2020 11:12:50 +0000
Received: from AM7PR07MB6707.eurprd07.prod.outlook.com
 ([fe80::f5d7:501f:102d:60c3]) by AM7PR07MB6707.eurprd07.prod.outlook.com
 ([fe80::f5d7:501f:102d:60c3%9]) with mapi id 15.20.3589.017; Wed, 18 Nov 2020
 11:12:50 +0000
From:   "Wiebe, Wladislav (Nokia - DE/Ulm)" <wladislav.wiebe@nokia.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wiebe, Wladislav (Nokia - DE/Ulm)" <wladislav.wiebe@nokia.com>
Subject: RE: [PATCH] clk: move orphan_list back to DEBUG_FS section
Thread-Topic: [PATCH] clk: move orphan_list back to DEBUG_FS section
Thread-Index: Ada9k+6gKWQKOxMWRaK2973BbyOELwABCvOAAABXgBA=
Date:   Wed, 18 Nov 2020 11:12:50 +0000
Message-ID: <AM7PR07MB670744C9A6320FE5B6F4B9DBFAE10@AM7PR07MB6707.eurprd07.prod.outlook.com>
References: <AM7PR07MB67076EAED784F061D17AC015FAE10@AM7PR07MB6707.eurprd07.prod.outlook.com>
 <X7T7kxuY1fuAtlqX@kroah.com>
In-Reply-To: <X7T7kxuY1fuAtlqX@kroah.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nokia.com;
x-originating-ip: [109.192.217.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8afb8afe-38ee-4a46-79fb-08d88bb2e349
x-ms-traffictypediagnostic: AM6PR07MB5495:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR07MB5495E54407A28234B7A846BAFAE10@AM6PR07MB5495.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K/cSVLAQY+rQna9p72JoNEovY5/NnVwyvh05FRGrlKUHQTVJ4OGcGN+8BSnv8NeQ+g9XR/4Lpkm53zUrd1sgCFD5VAbHoeVi6oM3hxXKm21OnaBN14coUcCWgzEOND3bWPaXghl/wFhNgeFYrVCwnOEMifZAF/oAtiIke7mCMi/o5EqxyL39g7aBPjBp/SG7kzyBRcyCRBNKJhy59yQT+xSltD6F4TX/GJrwHX6MeixaNrRJCSeWF6zlBouvRJ0bWTJwfmp4zzgBcQ/SIJu/nmLoTJBfmTtD4dFpTx0Slefn0YGscFGN4uC40MknAmjXST3nbtdzaJzidUtK6QdmvPzAEArsmbDs6B3iLB5gYUSW5YhL1vfGmMcJ6Vrz0XXfhawfES/y3GmCvJZbygE94Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR07MB6707.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(8676002)(26005)(71200400001)(8936002)(54906003)(52536014)(6506007)(33656002)(186003)(316002)(5660300002)(9686003)(83380400001)(55016002)(107886003)(966005)(478600001)(7696005)(76116006)(66946007)(4326008)(66476007)(66556008)(64756008)(2906002)(66446008)(6916009)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: hrzprNAE1AbOuo3yQo880MNrbvl4BoppYqUYiu8o7mpJBRuWd3cK5QEe58LjqFBezAeFh2vRqwI0aFEjvsQTTEiXRUOKLQzI2XcpMoNWROpFIYXo6QaHEZmBe2JGDt1z9T9YB+cDrs5qlPNWhhr6xrVtN+iokzjH2MIXDYJykPPA5LO3h8phYzw8rE+Tt2HA6m0ybt4YH56/zcZ2c+OHZFbMZ0pmHXlxR27EKxwweXjts/J34VeQGsg81HjRqBfUIxzmUZ5q9dW6AnFSKZQwB5/lrdDbUuLLC8HIbh5/7Mm5CCbrGCKKGKRdeh7JWIuqY5OZucOO3la1zydHq3WMZE2vVN8fez2kIBy+S4p384wwIayRzwV9PTQqEWUGuMhPVxcuLV7UuWLBiiGDSWJ7p1ogXIfYwnpN9H37V8Y9bprx0ajAdhT8JHAe+E04XgO7d5Ys3dXwxdaVEcG3oxXfh30G56pvkZOKyWtzrXCDHrA+XSSMwliO2Br31OY5gzykYneNmHIXQRfO+pvLYSQNo6Mi7uWsVkgbWrhaRbmqeVc7EA4YdFHjloCkld/w7/611UwPrQngWE9kknxdsxPIutcDDAAkezjvhylZ/O9l8vUhsPss+ln1KNI+M6WEpd/5YA5Dok/AiHk0oCQg1tFm4GvhmmbJzZfweDwcrtArIOxe1c9mkXAOTvTNbFanlqqXNioXSDh41B5lIK6MSVFyI0FVU39MxeHu0KedSiZ7mZDMEwVtDhk4VN9VXFo1fyCejCPBsCIVStlUaVJFWQCC43NkLLvhTPgoqNdWGCxvpo+2Rtt48Y84zR1aTlgZgtFith9vlFmR6P3AOPhdWztaJF4HLd7Iq9+Cb4EMKUFG9vkWdOuqtBMm6YZE2R2AtUZO5LkCjMvkZjOqA1Ndu6of2w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR07MB6707.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8afb8afe-38ee-4a46-79fb-08d88bb2e349
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2020 11:12:50.5801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EgDRA73y3RNLyib+/4GfoJ8inoxHhgI9xt1wsEWr+mAGVdKY5Y+vNQhmF43ALb4ZEc2jqWMaX6PYto0OzJJnDzATORUFsAokfHcFgQU75Kg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB5495
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, November 18, 2020 11:47 AM
>=20
> On Wed, Nov 18, 2020 at 10:23:02AM +0000, Wiebe, Wladislav (Nokia -
> DE/Ulm) wrote:
> > commit 903c6bd937ca ("clk: Evict unregistered clks from parent
> > caches") in v4.19.142 moves orphan_list to global section which is not
> > used when CONFIG_DEBUG_FS is disabled.
> >
> > Fixes:
> > drivers/clk/clk.c:49:27: error: 'orphan_list' defined but not used
> > [-Werror=3Dunused-variable]  static struct hlist_head *orphan_list[] =
=3D {
> >                            ^~~~~~~~~~~
> >
> > Fixes: 903c6bd937ca ("clk: Evict unregistered clks from parent
> > caches")
> >
> > Signed-off-by: Wladislav Wiebe <wladislav.wiebe@nokia.com>
> >
> > ---
> >  drivers/clk/clk.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> <formletter>
>=20
> This is not the correct way to submit patches for inclusion in the stable=
 kernel
> tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.ht=
ml
> for how to do this properly.
>=20
> </formletter>

Thanks for the hint Greg, I will resend.

- Wladislav
