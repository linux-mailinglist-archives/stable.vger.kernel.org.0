Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47258FB3F4
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 16:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfKMPnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 10:43:11 -0500
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:6791
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbfKMPnL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Nov 2019 10:43:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ynobs0Z/jNbiTlqmXMKRqPhO0tV8avbWw+rSJdSGGMNKmqe4VqVx1C6RsusSraRxoK4kJ7KH+0Z/Q/YhWfWX2U2rPjBPh+EqtUG8V9iYSiwqEv1RL5TgGISvnqT8zncPND66JG3KLeAaSL71y0D4F/oS3e7dkgRP0l4W2+EbXRnqXAP1ApJrFfpJI9uJqxkCKmypGypbcuDImxoo7qluhEBsG0dHqRcrnKNkg5CVMCDvEXu9JS2FRLkRtMODQZgSrAZQosDssA2F5oeE/DMEy3WVnUecrYFkn8LSM5Km2EUIjtdRw1XQW5r2MGMZcIEifSdZXaQKPZk8Y/8zcV+zzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srnWfCHQaJ0o37nhuaCaY/+zeuse0ejp1PdvBMWSjyU=;
 b=Rl3E5av5Nd+o9ETyyxMl6hX41QFBS0CQ6K63z9e2uvrVDEpY3HQMp3cVmiZIXKgRHQHx+w/z5FChDfofR1oOlF7mBPI4wifPBPbnptIg80YWWpua37XU/ha5LneAMRyXGQPpHbEkSFkkYeYxdsuOap3YO4FMYon99tOkm5EQ86M56vLtezkoiiVjk1LKY6OEaOOOebEPLXSAPjisTuS3BIiLA+31sx34XNiWcCf6rUHab4XYQPwKvUJNU0DGWSev8hqUgv39DlIdhpWMvDm44nNm3hLo6Uv04itg8k4E4N07GvBeCd2fRZS2Ag1JAFlgX8B3iAggWJavpvDIYgQ5Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wacom.com; dmarc=pass action=none header.from=wacom.com;
 dkim=pass header.d=wacom.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wacomaad.onmicrosoft.com; s=selector2-wacomaad-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srnWfCHQaJ0o37nhuaCaY/+zeuse0ejp1PdvBMWSjyU=;
 b=AP3/M1wiHiYzhU3FBQmoprqjeYTZWoFLTbRFLX0gVp56fAHUAMx8lWvtTQI3R8Bw8QbRyo8TrC/Z3B0dnVFsv0vKS/rH1D26+hK9GS+G9hTNJhl5IL4Z3qRPawDRSWRmpacu+hJW5ORiULHcee7bcQOhlRMr2UW2ITNZADJHmo8=
Received: from AM6PR07MB4454.eurprd07.prod.outlook.com (20.177.38.214) by
 AM6PR07MB4037.eurprd07.prod.outlook.com (52.134.118.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.7; Wed, 13 Nov 2019 15:43:07 +0000
Received: from AM6PR07MB4454.eurprd07.prod.outlook.com
 ([fe80::55c9:367b:bd42:b3e8]) by AM6PR07MB4454.eurprd07.prod.outlook.com
 ([fe80::55c9:367b:bd42:b3e8%6]) with mapi id 15.20.2474.007; Wed, 13 Nov 2019
 15:43:07 +0000
From:   "Gerecke, Jason" <Jason.Gerecke@wacom.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Skomra, Aaron" <Aaron.Skomra@wacom.com>,
        Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 4.19 027/125] HID: wacom: generic: Treat serial number and
 related fields as unsigned
Thread-Topic: [PATCH 4.19 027/125] HID: wacom: generic: Treat serial number
 and related fields as unsigned
Thread-Index: AQHVmL+hfZWoSt7hxkmYkNPzu/4PaKeI7fcAgAAEIoCAAExzwQ==
Date:   Wed, 13 Nov 2019 15:43:07 +0000
Message-ID: <AM6PR07MB44548A58061624B037D7C60CED760@AM6PR07MB4454.eurprd07.prod.outlook.com>
References: <20191111181438.945353076@linuxfoundation.org>
 <20191111181444.186103315@linuxfoundation.org>
 <20191113104724.GD32553@amd>,<nycvar.YFH.7.76.1911131201010.1799@cbobk.fhfr.pm>
In-Reply-To: <nycvar.YFH.7.76.1911131201010.1799@cbobk.fhfr.pm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jason.Gerecke@wacom.com; 
x-originating-ip: [75.148.82.17]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ec2b784-1aed-4943-1e9d-08d768502e0a
x-ms-traffictypediagnostic: AM6PR07MB4037:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR07MB4037955E3CB437A1FFCAE4A5ED760@AM6PR07MB4037.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:265;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(366004)(346002)(40224003)(199004)(189003)(91956017)(52536014)(102836004)(76176011)(5660300002)(186003)(6506007)(26005)(446003)(11346002)(476003)(86362001)(7696005)(53546011)(76116006)(66066001)(66946007)(64756008)(66556008)(66476007)(66446008)(486006)(478600001)(14454004)(6116002)(99286004)(6916009)(54906003)(71200400001)(71190400001)(33656002)(3846002)(229853002)(8676002)(81166006)(25786009)(8936002)(81156014)(316002)(6436002)(305945005)(7736002)(55016002)(74316002)(4326008)(2906002)(6246003)(9686003)(256004)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR07MB4037;H:AM6PR07MB4454.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wacom.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I0dbXrwf896ijaGlJTQRoSo6F0D47HNrzg0YPAQOwnkJJntfiwxfsReoaRgUs6lFj3ZbwhC7dcCl1uqJ79/viguSD9kyB/GKgj3o89c7iglIndUP55U1zdWaf0jdL2xNqWk0r+TPR7GFNB2VSJgX0Dx8mza4CKH0lT4FeIDQbncXJm7ZwUiOE3RLc8d3Jgdy/LARddJdEilWXkFKkgJ+ZKun9EuZ65tuADo5c7wKvXrKB0bwojyjIQy7yxZk0J/72hDIeMZLBM3tc+nP0BEyexa1/Kr+xYE1bBaaJ1bW3RTqJZl1TjHbQGS/cPYy1r8qMzLFjDu+0AXTHSPvuIPw0dLqcBrBuPu6xxehbatd0lfsjHdasMdajL6aH0BjicXjCIU7CwYcKEJosMqRAXFDhJ2iJKZYkee2Bl7cCd0nsrHjS1+0GzXykILfzURiWD/A
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wacom.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec2b784-1aed-4943-1e9d-08d768502e0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 15:43:07.3131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9655a91b-107e-4537-834e-d15e84872626
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zh9PTOcjHvOQN7NI87HJhtXuv9GLIPjkX7I/QcsqohHh9vMfhV6J5BVaS33tq0AKE00DNFBJtQPpCRHxog5BXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB4037
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Jiri Kosina <jikos@kernel.org>=0A=
> Sent: Wednesday, November 13, 2019 3:02 AM=0A=
> To: Pavel Machek <pavel@denx.de>=0A=
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; linux-kernel@vger.ke=
rnel.org <linux-kernel@vger.kernel.org>; stable@vger.kernel.org <stable@vge=
r.kernel.org>; Gerecke, Jason <Jason.Gerecke@wacom.com>; Skomra, Aaron <Aar=
on.Skomra@wacom.com>=0A=
> Subject: Re: [PATCH 4.19 027/125] HID: wacom: generic: Treat serial numbe=
r and related fields as unsigned=0A=
>  =0A=
> =0A=
> [EXTERNAL]=0A=
> =0A=
> On Wed, 13 Nov 2019, Pavel Machek wrote:=0A=
> =0A=
> > > From: Jason Gerecke <killertofu@gmail.com>=0A=
> > >=0A=
> > > commit ff479731c3859609530416a18ddb3db5db019b66 upstream.=0A=
> > >=0A=
> > > The HID descriptors for most Wacom devices oddly declare the serial=
=0A=
> > > number and other related fields as signed integers. When these number=
s=0A=
> > > are ingested by the HID subsystem, they are automatically sign-extend=
ed=0A=
> > > into 32-bit integers. We treat the fields as unsigned elsewhere in th=
e=0A=
> > > kernel and userspace, however, so this sign-extension causes problems=
.=0A=
> > > In particular, the sign-extended tool ID sent to userspace as ABS_MIS=
C=0A=
> > > does not properly match unsigned IDs used by xf86-input-wacom and lib=
wacom.=0A=
> > >=0A=
> > > We introduce a function 'wacom_s32tou' that can undo the automatic si=
gn=0A=
> > > extension performed by 'hid_snto32'. We call this function when proce=
ssing=0A=
> > > the serial number and related fields to ensure that we are dealing wi=
th=0A=
> > > and reporting the unsigned form. We opt to use this method rather tha=
n=0A=
> > > adding a descriptor fixup in 'wacom_hid_usage_quirk' since it should =
be=0A=
> > > more robust in the face of future devices.=0A=
> >=0A=
> > > +++ b/drivers/hid/wacom.h=0A=
> > > @@ -205,6 +205,21 @@ static inline void wacom_schedule_work(s=0A=
> > >     }=0A=
> > >  }=0A=
> > >=0A=
> > > +/*=0A=
> > > + * Convert a signed 32-bit integer to an unsigned n-bit integer. Und=
oes=0A=
> > > + * the normally-helpful work of 'hid_snto32' for fields that use sig=
ned=0A=
> > > + * ranges for questionable reasons.=0A=
> > > + */=0A=
> > > +static inline __u32 wacom_s32tou(s32 value, __u8 n)=0A=
> > > +{=0A=
> > > +   switch (n) {=0A=
> > > +   case 8:  return ((__u8)value);=0A=
> > > +   case 16: return ((__u16)value);=0A=
> > > +   case 32: return ((__u32)value);=0A=
> > > +   }=0A=
> > > +   return value & (1 << (n - 1)) ? value & (~(~0U << n)) : value;=0A=
> > > +}=0A=
> >=0A=
> > Can we do something like:=0A=
> >=0A=
=0A=
The implementation here was copied from 'hid_snto32' (except, of course,=0A=
to make it convert signed to unsigned). That function provides=0A=
justification for how it is written, but if changes make sense then=0A=
we should probably do them to both this and 'hid_snto32'.=0A=
=0A=
Jason=0A=
=0A=
> >     BUG_ON(n>32);=0A=
> =0A=
> Please no BUG_ON()s in bitop helpers.=0A=
> =0A=
> Thanks,=0A=
> =0A=
> --=0A=
> Jiri Kosina=0A=
> SUSE Labs=0A=
> =
