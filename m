Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E524639ED
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242982AbhK3PZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:25:52 -0500
Received: from mail-bn7nam10on2051.outbound.protection.outlook.com ([40.107.92.51]:40894
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234594AbhK3PYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 10:24:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grR3NkfSqTEN96BwVSP9pEUq9zLu/3RESsbAxOrFyXAoE8mZCv/tQFqI4YxqpAr0YlOtVr9VoS/iYNPMs9zi5Adu6WoG/HbAIA300/lQdJQFkx5aTQdkPjgsgULgkNmSkx4ATGlyMhJMcdkByq2J0VKuE92o3dw4PB+L88Uoae6RHRM2LQSG+UZx6LqSPxJvkIek4sCLyHTIJw7E8nHkfk3y5aIyBfjcsnenlaQRPC48YFGGw7iPwyXr8FPC0OqrdWb0Pi+L2FQ5+J5yGr7E1LkcrVrhpb5Rrp8LIlgfd6fpCK22vdaeFDpbnOS8WxARsmpjxoUg+bznBaaEgYcRLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNnmXyPEEV7NPbg7W3savE662WmZnnR25VvwdhnJ1RA=;
 b=bFhojgO12WmPcaKn4n5uW6vvzjb7UZGsyEi+qJj6AbTIWN/b67zEhlP1AYCiaD4eMr3vCCVzURExB2Gfa3FCfMNaVIlQb8Bu0H8ptjj/QGYmL92miMqU8pMc8K8N9Hu1pW/mvMPZ5yItH/VJLpgbSYMJTLL1qK85bQ5327KSLgRTQsNS3ckE1Xs1coLE4CJ38IlJGBNoadu0KcvElS0+LLsO+PvITlF6v9VePuB51nAOEGJ5kUcC35BO+gt093A+U50f/X6CdX11C7RTrdpmtVamUaAt2eogT/8K3D5WlRWeoR+5+mcINoscf9IZNt7D/vIqgx1qYT3yDqCq2i8bIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WNnmXyPEEV7NPbg7W3savE662WmZnnR25VvwdhnJ1RA=;
 b=pEo1Rb70a+RTgnEa16NhaKWbDgepBSec3O9nu87wDeSseEy6D6zRx1AqFCxzwXVpQzu6+fqbm264rjnAlHWBZWxfiwp6wqNqHDIiA9FJCoY6vq06Q4J3KdYU+clh2o6rDONyRrribbyysOXlMiz9BE1QRdK7yU9fC++pyzHT+Mk=
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN1PR12MB2543.namprd12.prod.outlook.com (2603:10b6:802:2a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 30 Nov
 2021 15:20:48 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea%6]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 15:20:48 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Tuikov, Luben" <Luben.Tuikov@amd.com>
Subject: RE: [PATCH] drm/amdgpu/gfx9: switch to golden tsc registers for
 renoir+
Thread-Topic: [PATCH] drm/amdgpu/gfx9: switch to golden tsc registers for
 renoir+
Thread-Index: AQHX5U6DCKQ1660+qkSMdDoZDkl2Wawb2x2AgABV5bA=
Date:   Tue, 30 Nov 2021 15:20:47 +0000
Message-ID: <SA0PR12MB4510F2869FB9C83D2D162700E2679@SA0PR12MB4510.namprd12.prod.outlook.com>
References: <20211129182527.26440-1-mario.limonciello@amd.com>
 <YaX5MWZNRMNGY5yi@kroah.com>
In-Reply-To: <YaX5MWZNRMNGY5yi@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45fd674c-1d7a-4f2e-0eea-08d9b414fcae
x-ms-traffictypediagnostic: SN1PR12MB2543:
x-microsoft-antispam-prvs: <SN1PR12MB2543B8BA76CA35FB88B3C4CCE2679@SN1PR12MB2543.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0XOqOWmzp91wMJ8UEF7XfohGpT+hXBH0SbgqfbZl14uQGSUypXmXproarDaBOLOYHpGTS7a3Nf3PxeekNhlwjsMP6YT6Eo3AKQirqm8gXZ7eoL/Hr7zsw6qfnha1DH6AUPbZ6Bb9Rcfezqa4Pa9YoUv3/OoRe84lVWBNF3FLN+QYpfScDSV4rC6mT4znDfnAPQcz8xsS+SrKuUL6oLlIF9IPFk6rVZV9d2mS5WuLUG45mcKKSwhqSWA9MiU8k+UmzagFcSEpUIyPTIe/hY4CTuSXYFtax725XKAfsIPKiNmCR9dNixm9Ci1ysA2/x0LcYFk3QiDSFXYm36HK0fYT8W7yNh3EeLEkQkxMB2u9bxch/Ty7HD1zDaviOLKMGWBMsABIe0hR4Uw/+M0kip7npVYojIG1JaOrHdPaxPX+yGFpNo8i7oCux9g4+HT5mrbS4mZB24uJtWS7O4/QWzxfEAkwnnHop1mZrNjYlBp9WnebR3lNG0cFXmmyqL6qmr4FclaHhoMHkdi72Ta1IRAu1LEMVUM+NCTR3vjY1/0BgO8bkRB2e8dPyJxtAd2Mt/cVhHApLOsLNW9Q1oxkCxWd3aV5upJ8FOrPBu1AkiRcrXlICJUeBNClRur2G31LUA/4EcZlR08me9EptCZ0jh6e1tLBEXwdrBUGWdWODxzQ8l0+j7KAZgD0xPLLumRK2RQQLon/RueoAhmwY2R5AuKzRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(52536014)(122000001)(38100700002)(7696005)(54906003)(316002)(53546011)(186003)(33656002)(2906002)(6506007)(38070700005)(55016003)(508600001)(9686003)(86362001)(8936002)(66476007)(66946007)(8676002)(66556008)(64756008)(4326008)(66446008)(71200400001)(6916009)(83380400001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j55J55mOAaG5odcuuftU5Fg5lJ4dqHGZivQ3EYhK7O9EBkfpdOWXf+pVYvR7?=
 =?us-ascii?Q?ePLuIzX5C5cfUbZJ/Tc+JtBzLAqioMdrsCshMSQW1g8f/Wq9GRrRIAl1zrfo?=
 =?us-ascii?Q?woivzF5M8U8zHhv8Evp2sFfdwtaa2f1BGkhP65dU10iQSj5wwZO7jhtURwth?=
 =?us-ascii?Q?CInbm5w0XhroNpGSlJgsvElDteS2loqUFOzwmdDyAquLg91kYx0ZX60B21df?=
 =?us-ascii?Q?iw1fJhMtaGH21ASe8msLUUou5GE+B4ol7e5GtTNHOBg45cpe723fL9mUsFIZ?=
 =?us-ascii?Q?NRMO9+hm+vu6Ls5Gaqh78JWhKghz0TNKu/BlAnM9O4JoBXvh1a5yn9ZCDLLo?=
 =?us-ascii?Q?qzgwATLbS2E5EKuXdD8JQ4UmBIUdfBhso2+hQQpAK7VKc5IgnXsZX+2709lj?=
 =?us-ascii?Q?JvKh/KZx59KOuKTLpiX4eDgGMYAx3VGim2b0DhXFioTiEHM3d/UVMb7lYEH6?=
 =?us-ascii?Q?EVSI5ruFTD8SyZ11FqfuEGKw0DQ5z6q4VT4KmKxY58adO5Ik3bafJWshYha5?=
 =?us-ascii?Q?LZdCc+zjMnd29L6GsZgNHXaqbkBcg4qYSEIa4eszkErDcFC1LJ2DMdUht5R4?=
 =?us-ascii?Q?gJyBN6SBUIZ+b8HOQWJdBAA+cUUyEfDf+5RDbAppby7zUh6NJxASE8/OsBqJ?=
 =?us-ascii?Q?6Ziv/nNIOP9HXdZkhW3kZXjqqG9kfe2PNM4O2tX3/8VIkNX10UWPgm6tEn0V?=
 =?us-ascii?Q?Fs0AGwyPltP2P4Yq8TGWC1tTmTPrPPmgjOdOaBzwPWYbvwL9vEYV1fpjMiKO?=
 =?us-ascii?Q?RkZbthLcwYsVXzJFFPOh1J+LJLQvUfjc/p0y/+vBPj2FZ0mVSAHpzc93iMXg?=
 =?us-ascii?Q?EjheVt+Uld/15C+/Jcy/alSg/SnL+JK1bruBbJL+nouM4FHiD3C1U21vHCA7?=
 =?us-ascii?Q?/iXAU6RkvhjGmcYy5uc6Cb4x20DkrGILQpHITsUS+Xu1mHwMmdhtROJPTIYx?=
 =?us-ascii?Q?z1QyCS+PgSBkLgWebbV5DixLpv7RohCO8CuNU1VXeQ02G8cHeDy6SXtfEs5q?=
 =?us-ascii?Q?YRv0tbYCmEreSK4YpSRX7RrtIUj000HrHtUqvUjpLVXNqdPwjb+1am7yc4hI?=
 =?us-ascii?Q?TS5kxNkV2itg9t0UnFDe46gbIniMLjm36RaiNpTCU0Uu2npRw06+pcscmI6/?=
 =?us-ascii?Q?wlXC7hCShOGIQcZ6O3l2zUZUgvo5kDoZKgtFIOh8jmAR7mzNrH2HCaBYO2Do?=
 =?us-ascii?Q?gwTf0PzBIqvwJBNzEGODvzspKKJpMwGGi9RcCI563n4T4r10dnbZgwWYsMsw?=
 =?us-ascii?Q?pjn/CLTsXR2Lklle//CS2l/93njibeFqsNClUQJLqr/LEwV6ji4dZ/HENn8p?=
 =?us-ascii?Q?3/x8bxUxchw+VmzyM5AQAxsCkQuP4ICp9znM2Rio+sPhj/oM5eaCzH/upiMV?=
 =?us-ascii?Q?k6vXQvBRliDeWmHM2gUbwleo+wZTek4+aNG+XR+MYD6iBKkkRuvG4XXIazHx?=
 =?us-ascii?Q?BUoCVDjWcbI/YqQzHdMLfFtssCWZaZ/5+rjgll0UT1xHUEirm/Xl/gdYTGjJ?=
 =?us-ascii?Q?dTisvFb9kr4DnMLLUU503zBWf8lM1A/zZQZsFXNOF1icmketMoa4tI75ok3i?=
 =?us-ascii?Q?q55yKUt60aPOuwJ9X5kbaHECeHX5zbEJ0yX1JwEHeJqhQULeMLYRXfsZop+r?=
 =?us-ascii?Q?0R0gI1W8/VRrCZ9IkYtADYUGvevwGuFofLQ8L4h0aOuCRDsrpbMmvRQfYFfX?=
 =?us-ascii?Q?NFxecg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45fd674c-1d7a-4f2e-0eea-08d9b414fcae
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 15:20:48.0171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7iDCFoeyqeZaRLHyOgoNU5rvjj3SsIwWwfPGVETQOXFie5z3QL1kHv0YdvkjNNyCtH48CbM+auXrzdCBcJ9qrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2543
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Tuesday, November 30, 2021 04:13
> To: Limonciello, Mario <Mario.Limonciello@amd.com>
> Cc: stable@vger.kernel.org; Deucher, Alexander
> <Alexander.Deucher@amd.com>; Tuikov, Luben <Luben.Tuikov@amd.com>
> Subject: Re: [PATCH] drm/amdgpu/gfx9: switch to golden tsc registers for
> renoir+
>=20
> On Mon, Nov 29, 2021 at 12:25:26PM -0600, Mario Limonciello wrote:
> > From: Alex Deucher <alexander.deucher@amd.com>
> >
> > commit 53af98c091bc ("drm/amdgpu/gfx9: switch to golden tsc registers
> > for renoir+")
> >
> > Renoir and newer gfx9 APUs have new TSC register that is
> > not part of the gfxoff tile, so it can be read without
> > needing to disable gfx off.
> >
> > Acked-by: Luben Tuikov <luben.tuikov@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > ---
> >  drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 46 ++++++++++++++++++++-------
> >  1 file changed, 35 insertions(+), 11 deletions(-)
> >
> > This is necessary for s0i3 to work well on GNOME41 which tries to acces=
s
> > timestamps during suspend process causing GFX to wake up.
> >
> > Modified to take use ASIC IDs rather than IP version checking
> > Please apply this to both 5.14.y and 5.15.y.
>=20
> Please note that 5.14.y is end-of-life as the front page of kernel.org
> should show.
>=20

Thanks, I didn't realize that until now.
