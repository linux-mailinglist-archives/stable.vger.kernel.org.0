Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9052A668B
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 15:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbgKDOkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 09:40:43 -0500
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:30086
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726564AbgKDOkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 09:40:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTfrKFzligo2j0zFlFSKeIB1156B2+nDpLyi+GgaMje3bZEQHAMYtiR6XOCy5K4g5/xBGs5ribv93jZFPZIYfnQohJJr091v3FGc7murfuTdl6gs6AP9P2kV0TmMIYdMIE3weMCZ1WFwQuy9Lu104K/VQIAlzaMQ1ls2pRmjy71coIhxhRYO6I7VZ2zfGnPHi0yTunmqYBfvDDU/a9Fna4GUx6gxq66TmdK5WpUGFQyDaV7Akmy3NzLQZSXzerGGmG0W4jrd84GXChC+mmal4KmiQLHbprFhVOoo1AG2ypknwKW5aqI3BQdTWmbaPt7q6a5xUDXs8Ytj9QpbTfWseA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IGtiNv2R3AeddcwjjTge0D3SC8tIaZBxn9xLC0s/G0s=;
 b=EZznxcWYpfvHwrhXzWfnn1CF7xTa7+yrMpKFEf8JazwFcutQjXV+FVJfcAVFiSSQ3kxF8O5Knl3GlHgJkZ6VmQQswlCKpCvE3fnav7iIYzB+AMPI53wt/cRHUEjAWw2vm8DjKbvyJIRpw5G3OLX5STUWMPKauL7GCmgfTA9lwvKE7VDLWQCo4+5B6R6wsEGs8wKosBDvYuOkzOjpuM3ZQViQHv/NwqtTNQJXSZ/rHqlbSsRpQP1l+lhNBs4DzXXepq+tRW+TiJvsmJLjotn4S+QAxQshKoR3SnJ/2epFtvqntYDA0r64W1DmJoM3mWZu9qvKowi9UHzsFM+Othex6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wacom.com; dmarc=pass action=none header.from=wacom.com;
 dkim=pass header.d=wacom.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wacomaad.onmicrosoft.com; s=selector2-wacomaad-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IGtiNv2R3AeddcwjjTge0D3SC8tIaZBxn9xLC0s/G0s=;
 b=eMCxfMvKhPyVWu5aynO6UpphYujoibqCTDJevERIcTklGoMlTYGMB/OuIunDhlQvA/OXoz+rLmT7Xn/4I/RxORS+jjBCemkXIrehtkzE2wQttRio1Z7Ng/Wc03+64USvHTQ9WPctgSvAy2mMrK0ZgfIm4UJFZFkwG076xElQHAA=
Received: from VI1PR07MB5821.eurprd07.prod.outlook.com (2603:10a6:803:ce::20)
 by VI1PR07MB5488.eurprd07.prod.outlook.com (2603:10a6:803:bb::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10; Wed, 4 Nov
 2020 14:40:38 +0000
Received: from VI1PR07MB5821.eurprd07.prod.outlook.com
 ([fe80::6d7f:4f2f:1458:7930]) by VI1PR07MB5821.eurprd07.prod.outlook.com
 ([fe80::6d7f:4f2f:1458:7930%5]) with mapi id 15.20.3541.017; Wed, 4 Nov 2020
 14:40:38 +0000
From:   "Gerecke, Jason" <Jason.Gerecke@wacom.com>
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gerecke <killertofu@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Cheng, Ping" <Ping.Cheng@wacom.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 4.19 146/191] HID: wacom: Avoid entering
 wacom_wac_pen_report for pad / battery
Thread-Topic: [PATCH 4.19 146/191] HID: wacom: Avoid entering
 wacom_wac_pen_report for pad / battery
Thread-Index: AQHWsiU8nYPLW7sITUmjvNop93TLtKm3mo+AgABsJTg=
Date:   Wed, 4 Nov 2020 14:40:38 +0000
Message-ID: <VI1PR07MB5821A87A8B0133C606C9911CEDEF0@VI1PR07MB5821.eurprd07.prod.outlook.com>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203246.442871831@linuxfoundation.org>,<20201104075221.GA4338@amd>
In-Reply-To: <20201104075221.GA4338@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ucw.cz; dkim=none (message not signed)
 header.d=none;ucw.cz; dmarc=none action=none header.from=wacom.com;
x-originating-ip: [75.164.212.231]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61abb1a0-671e-44ab-cf46-08d880cf98fc
x-ms-traffictypediagnostic: VI1PR07MB5488:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR07MB5488E4628C3FC2CDEC6CCDE5EDEF0@VI1PR07MB5488.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qNO2lRIQMPCvbbhltbW17HD3F2GnsDvmytycjca3dkNEt3NP8081pORJ6kUs+qxLp7YRimKZhXSZB2sVikIh0iBnJPxg9z6CE0XppUrV/tUuP4lDYiQBJ8oQJJlF/kbG8Jb+6POvqiI4ICd6nG0hF5udEl12fC5dWqUP0byp5RJqmGmRW1a3WW15CwF2MIJ+RVHuCgoQr09PzHnUzglu1Ps4FhhDwLPlXkjL8+7w+pDSMDqInzuOw5UVfuHfCv4biieVi3+FORL83fHX+N4K83D39VnSBeCOvk3FTrwjah62Lm314zF0eYFzI676GNuy090TZw9u92YVLhr2huLa0o7RfGr4VbKvoCBnavXENV+Y0xwGAIS8ug2Uf1fVcwgtLAgzsEdN0c0K2+/vkRO4Mx0ovkmQk3u/cqP784NE39E0EA9vY6i2rhZE++sx0dfuHAr1ZXDOEE4vsu3mJ1L3HA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB5821.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39850400004)(366004)(136003)(396003)(966005)(66446008)(64756008)(91956017)(66946007)(76116006)(52536014)(2906002)(66476007)(186003)(66556008)(6506007)(5660300002)(7696005)(8676002)(26005)(71200400001)(33656002)(110136005)(8936002)(478600001)(316002)(55016002)(4326008)(9686003)(83380400001)(54906003)(86362001)(18886065003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: mN1NDBTqo8OMG9B77EdldNUKtbiXwMq3YlQ13P/P/7ayXmWQwd5Qjf/sWPcAE6yOEQq2UbdXITwCR83tQDVYvZmRtuMzBnzPlWw+S+0OYStLnFXQ3HjPRGSICXt9n8TahUxYceFgSjv67Tap9nYl+U8dFjYRCuc0svBwzw8FqHRuICOlBcYhKMHJqA1oADB/9gMQNeLJvh3zjDjN3EkMRXsEDXKAOjJeICOu8u9g38aOc2QGnihc14TQo/FdSjUIxVrmIFS171Y+C/oIH4cBUN2nG/48x0gJZGjydZrk5aH915HHl6DvfpexvHyd7eoPiKVlHBDWOhIhXmKREbArGSd1cruO1rIsGFbEKnu1qfueEsh3CW9Sjc2u03BthKt8+xjwi6JkC89hGxTwb7ylJWtCvmabRKfccu4rx55WWVSvUR8kgQH5ifRz1ym8AWXegvT4RKUwwxY3pYNXKv1ockjnUHh3iLGMZK8exWP9dkk1N19IW+pwTmb0ckJjAeZNyuOCt5x/b318zo1I8edHmaMTzkW7C7Wzz7XEHE/1laZUS+0PoX9+GjBxLxV1IlqGxj87CUEVmQCbbvZc3Ll6Fzgxodp+7qlr5fZEmOhrKRD878U+vjqYvUvsJTRySr8ZjVNfBeq70hZihsQWF69/BA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wacom.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB5821.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61abb1a0-671e-44ab-cf46-08d880cf98fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 14:40:38.4706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9655a91b-107e-4537-834e-d15e84872626
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: raEivxasx6iDhKxBNszYuDmpPJpO3BpnyHFBuiHBmxC+4dvmjCLYShGnim5BNHA1k+c7Yr3gsniZ8YmsuCaY+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB5488
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Pavel Machek <pavel@ucw.cz>=0A=
> Sent: Tuesday, November 3, 2020 11:52 PM=0A=
>=0A=
> > To correct this, we restore a version of the `WACOM_PAD_FIELD` check=0A=
> > in `wacom_wac_collection()` and return early. This effectively prevents=
=0A=
> > pad / battery collections from being reported until the very end of the=
=0A=
> > report as originally intended.=0A=
> =0A=
> Okay... but code is either wrong or very confusing:=0A=
> =0A=
> > +++ b/drivers/hid/wacom_wac.c=0A=
> > @@ -2729,7 +2729,9 @@ static int wacom_wac_collection(struct h=0A=
> >        if (report->type !=3D HID_INPUT_REPORT)=0A=
> >                return -1;=0A=
> >  =0A=
> > -     if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)=0A=
> > +     if (WACOM_PAD_FIELD(field))=0A=
> > +             return 0;=0A=
> > +     else if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)=0A=
> >                wacom_wac_pen_report(hdev, report);=0A=
> =0A=
> wacom_wac_pen_report() can never be called, because WACOM_PEN_FIELD()=0A=
> can not be true here; if it was we'd return in the line above.=0A=
=0A=
For reference, here's the definition for WACOM_PAD_FIELD() and WACOM_PEN_FI=
ELD():=0A=
=0A=
> #define WACOM_PAD_FIELD(f)	(((f)->physical =3D=3D HID_DG_TABLETFUNCTIONKE=
Y) || \=0A=
> 				 ((f)->physical =3D=3D WACOM_HID_WD_DIGITIZERFNKEYS) || \=0A=
> 				 ((f)->physical =3D=3D WACOM_HID_WD_DIGITIZERINFO))=0A=
> =0A=
> #define WACOM_PEN_FIELD(f)	(((f)->logical =3D=3D HID_DG_STYLUS) || \=0A=
> 				 ((f)->physical =3D=3D HID_DG_STYLUS) || \=0A=
> 				 ((f)->physical =3D=3D HID_DG_PEN) || \=0A=
> 				 ((f)->application =3D=3D HID_DG_PEN) || \=0A=
> 				 ((f)->application =3D=3D HID_DG_DIGITIZER) || \=0A=
> 				 ((f)->application =3D=3D WACOM_HID_WD_PEN) || \=0A=
> 				 ((f)->application =3D=3D WACOM_HID_WD_DIGITIZER) || \=0A=
> 				 ((f)->application =3D=3D WACOM_HID_G9_PEN) || \=0A=
> 				 ((f)->application =3D=3D WACOM_HID_G11_PEN))=0A=
=0A=
WACOM_PAD_FIELD() evaluates to `true` for pad data *not* pen data because p=
en data is not inside any of the 3 physical collections its looks for.=0A=
=0A=
WACOM_PEN_FIELD() evaluates to `true` for pad data *and* pen data because b=
oth types of data are inside of the Digitizer application collection.=0A=
=0A=
Without the WACOM_PAD_FIELD() check in place at the very beginning, both pa=
d and pen data would trigger a call to wacom_wac_pen_report(). This is unde=
sired: only pen data should result in that function being called. Adding th=
e check causes the function to return early for pad data while pen data fal=
ls into the "else if" and is processed as before. Pad data is only reported=
 once the entire report has been valuated by making a call to wacom_wac_pad=
_report() at the very end of wacom_wac_report().=0A=
=0A=
Jason Gerecke, Senior Linux Software Engineer=0A=
Wacom Technology Corporation=0A=
tel: 503-525-3100 ext. 3229 (direct)=0A=
http://www.wacom.com=
