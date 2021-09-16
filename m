Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0120540DF1A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbhIPQGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:06:45 -0400
Received: from mail-bn7nam10on2078.outbound.protection.outlook.com ([40.107.92.78]:29952
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234053AbhIPQG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:06:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSVmeWOYt+AIuhG0OtR6G6e6Zm3tXLVYOybX8pjwsDDD7NegfmYU1RsjP9+6dKhceJ75GHS1YwXUvXP0c4OIBv8hU2onvCkpBO32++42esHNyJJ10pW5GN1tOMQ7tlI94Lymd9hqv6PMmDKHIjxxW8i00WNAr8FzPBBnEsn+BSqo0tboOvchTOF8xLMNdnBnYaGielmMHgh3T+VUXmjrnzzX/fASqUaCSHTbHNpemAi4j8IuFX11XIsoM1JHLu2Zkg1Wf4MldcoqRyHGwloFmDnuuv7O+0p5lOn5b3DUaosrpMqE6nWOZ0yjyybajjAan59i/n4jK4vSBdRnQdL37Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4U9duYH5iyMjY3jk9NBP5YVqwX3k05AsjwDfBEVeYCE=;
 b=Okh+/2Q3utF7dwZBbvL1DF4zMhSEYKtgBBJ3Qj8Y0jk/egBtYrVZ+WmcQVsDFTAG5GJ7hMU6ij4k7PgbmFDINDzOfAfr8vVroUuGXDTb4jKLb252vIteyBMiuJM504e1vhcGoEVquSN/JN22YiISlFl+XuVgls1juiS6rnZjSS/VsMiYojn4VfoNUzxKwbUEfRCSevavoJ2Zrwo1ov/wvjf5ZpyPqwtCQMMtg/nhAofBLYpCOfr38whwRmLrVXWc6bAyWs9HOsanrHFO6FXCsyILYnxDWeGbORABnjW+pnHlB8L7bOsSJIjVjgWmLPY4n59tmu+7SmPG0a0L25ZZNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4U9duYH5iyMjY3jk9NBP5YVqwX3k05AsjwDfBEVeYCE=;
 b=1FxWM/PHAFA8kvf+LoXkvpmmq21gOLc6uXKnSytaEE+2hX54888ydUfcnwtX+Y3VzSAreXUvnKodBpqAJtfNnEUAtpB2ZruGHaOL4EmoIMNgjMDTiTchOR+bfYq55CI2gjKg+3Bx4hRflgmyDmnW7DV+3jWFUqjhPRfkX+xKeU8=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BL1PR12MB5047.namprd12.prod.outlook.com (2603:10b6:208:31a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 16:05:05 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::7140:d1a:e4:a16a]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::7140:d1a:e4:a16a%8]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 16:05:05 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     =?iso-8859-1?Q?Michel_D=E4nzer?= <mdaenzer@redhat.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Quan, Evan" <Evan.Quan@amd.com>,
        "Lazar, Lijo" <Lijo.Lazar@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work when
 GFXOFF is disabled" failed to apply to 5.14-stable tree
Thread-Topic: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work when
 GFXOFF is disabled" failed to apply to 5.14-stable tree
Thread-Index: AQHXqvuG2ELZJjE1LEC3nFRE4SzJfaumqoUAgAACmQCAAAGwgIAADG9ggAAPwQCAAAffQA==
Date:   Thu, 16 Sep 2021 16:05:05 +0000
Message-ID: <BL1PR12MB51446E52A8B46EAA5210CB8AF7DC9@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <163179752354221@kroah.com>
 <7fe8e175-efdc-b7d9-ab86-44aeec60c2e9@redhat.com>
 <YUNLMkxQPw/empni@kroah.com>
 <e5b4ad1d-4a4f-ae47-5c85-22842c1b44cc@redhat.com>
 <BL1PR12MB514443A3990D3E9CEF5F1251F7DC9@BL1PR12MB5144.namprd12.prod.outlook.com>
 <YUNkQgB2hJLLWvgT@kroah.com>
In-Reply-To: <YUNkQgB2hJLLWvgT@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-09-16T16:05:02Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=11382836-eea4-492c-82d4-ee2e54759800;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13052a4c-cfc1-4daf-b506-08d9792bbf76
x-ms-traffictypediagnostic: BL1PR12MB5047:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL1PR12MB504773694DA929883DA68EF7F7DC9@BL1PR12MB5047.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OwqM4mfbtPc5WO0BS/0l9BjysG2iANgTeYIe/86h1cqsvDGOzs8awIy3cdNrPyjlRX0Y3v1uICOiqKXP9DxyMMDAx1kDr9AvEhT/YGSHIsNuZRK0SSLLD5ufnlbAK5flQvE7Ox96g84rXGna315t8xFjWxJj6FC8Q/q7/tUHzBpfpkkI6ZiIhXopCn8/1X4bytHIwz7W28ZQpLkuH9WmMzb+kTzhcBmgk7q6+9xld0JTZtDL8aAw3cRSn1DBjMFluQFlIbZBcm4cnfOUI0KH3pI8sg2lSRSrSFWsCCIKgYjGmWgD+cMuolmAyZ0fWNo/HhLmIzqWKsg5PWBqcTFiSnpmW5rCcmS74wFgoWBZvcugGsEgiT9QwhV9aQtGu+2S7xUu+6jxkvODWxgT8JudCPIxS6skNin8EfAzqQUUh1LpGWN/4NR30C3PU3xPAGCs5G23T8w2D0XUVTo7005tYbH8BhGF6DZjFfKDJs+fgyrZhuCNa0N8+Z83cQ6AHyFw35Onwb7m4N4aIFtLuOtNnoPMuWLdbtOHSGyb7ZV7DCTEA9zMObP1ggVBnIvS5GH89vuW5NVzBXOBMBNeQtRguWMUyG68kz8gQI4/uPPSzJK/lR16f0uwVlRA0SbrRvS6i/Ks7WBUDqGsNQ8/s9qJVwIiHXvHNV4nZdEgqzZntb50FEWk1I84aSpzjgSZ8TsuSzJvz/jWiH+1pM4YXYEW6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(52536014)(53546011)(54906003)(83380400001)(66446008)(66476007)(64756008)(66946007)(76116006)(66556008)(6916009)(6506007)(86362001)(316002)(2906002)(38100700002)(122000001)(71200400001)(8676002)(186003)(55016002)(66574015)(478600001)(5660300002)(9686003)(8936002)(7696005)(26005)(33656002)(38070700005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ndplVuMch3lZp+cUP+n1XtPYI8hYZI8pFPLBoOHBlaUn/Ci/XPNlZnt4I9?=
 =?iso-8859-1?Q?L4cYOqQj6Hfgi4PhajwJqeOCopCZLBy3r2kTpxMvywjsAUmOvameqUKfcc?=
 =?iso-8859-1?Q?xEcO1hzatazS5zEfc7qr1Dg3FC8RJPrbRWYzZw0hxZQgDHxHT+PcLLCNM0?=
 =?iso-8859-1?Q?xcU6PHxht6vYD5eh0l4PFxWOQKVb2qwtKdNajEqeBfdbAF9jv0k7UTWY0f?=
 =?iso-8859-1?Q?Axxbu33lpsS9DLevZaQAACIYIEzD94VB0SzQOYjrZOaLz+ckX5QTixGwju?=
 =?iso-8859-1?Q?J9c+L5U2YyzYvS6IINxMvtLgueLX104SPQQgiEPebjjKcqgEiJBhrYOIAv?=
 =?iso-8859-1?Q?pctW5NhnTl3VpamV2AvEBrKW1yYdYHMCrgSlgW+CshthUiMT1uwNue4nV6?=
 =?iso-8859-1?Q?Cdxgs25wKaHTw0YFcDDv/g4md4/Tr756oPNSILh6RJnufuts0AoGq1e0W/?=
 =?iso-8859-1?Q?MbxTxFNd/RNWI97yU+nOBNYS+WFIOqr8S8ZhUw1BZx0cBTRIeZyo8kUq/m?=
 =?iso-8859-1?Q?gVMepIn8C/Mqv6L4xnKflWIOPyD0Ve2FmjFi9fInquFp863ZZ+xlLTvamI?=
 =?iso-8859-1?Q?dCVZIvDF5895tgC06FsCsDQ71t3tlq9lInnuNhoaiS4lQSJqRdu+Mq2g6e?=
 =?iso-8859-1?Q?5mxFID8LYEQ2/CIUMCtkKwYL+2v3i9MwhR3DfCIjIAg7g+rVc3QwljHSsi?=
 =?iso-8859-1?Q?mtXKvRGmp1Celz2eQvlKrNrhNq/cdYPOvZ38kP8P77jtuqvq6sZ1W+lHQX?=
 =?iso-8859-1?Q?DL7rVCXKZmkVbrhhBVNXvaDJDzTCf6Al0TeEQE8Mx0DApJMihrX5a2TKiv?=
 =?iso-8859-1?Q?NM1yaL9xVfQvivfeezax4HzRDEoQFrjtfezi19qrxtKzNpPhWrQjxdVJNp?=
 =?iso-8859-1?Q?63b1JWIAou1Y8tmoZzZAzsg8m3veyodpE3YvowYXGGO9L+c95TPTOcHIyy?=
 =?iso-8859-1?Q?SclEFzuEiB9emw7IfKi+YJBgyTQn9/avYRIVY7hjD1jQUiVbL7qnwETZrL?=
 =?iso-8859-1?Q?X5Ts7+LuSnalcwwjl+9A3Tbwet2RaWC8c64ejKaFpdwllOv2AyNHUUM1Om?=
 =?iso-8859-1?Q?Qfreu4ccYM4598xItaQ+mcPT2W4+SmI4qW6jyOKNz5b5uFWKVJvS909QqQ?=
 =?iso-8859-1?Q?x3tNfxqHswZti7dmrhkrt2NAANo36GhzfmCDJ2GSS0EXtvKWLL44C2hm8z?=
 =?iso-8859-1?Q?rstm3RMUVq6qHpb6zULpMUkcFsAs2k9yDjrudzBHZWa2YQmd0kYGaFnXJB?=
 =?iso-8859-1?Q?ZGertyYfeSvcFzYDlhsDjFQ+Z3aWT8Zv3u0eG7SjHtSPtiOQbKaKIrm9Ha?=
 =?iso-8859-1?Q?hGIxJjksPQjDASdzV/kC5fqzJGhOeQ+28osY53tfx6xgaqIHl0SaXktUzA?=
 =?iso-8859-1?Q?AApcoUmgu8?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13052a4c-cfc1-4daf-b506-08d9792bbf76
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 16:05:05.1343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xtlhbrOm2iCA1nEhqb+ezoXxEF3vGTpQh2UCv7pW2hZaH3GamcNgqj4dDq1jM3XsH2pVJlKacSDM2kvZBHm+AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5047
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Thursday, September 16, 2021 11:36 AM
> To: Deucher, Alexander <Alexander.Deucher@amd.com>
> Cc: Michel D=E4nzer <mdaenzer@redhat.com>; Koenig, Christian
> <Christian.Koenig@amd.com>; Quan, Evan <Evan.Quan@amd.com>; Lazar,
> Lijo <Lijo.Lazar@amd.com>; stable@vger.kernel.org
> Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work
> when GFXOFF is disabled" failed to apply to 5.14-stable tree
>=20
> On Thu, Sep 16, 2021 at 02:42:42PM +0000, Deucher, Alexander wrote:
> > [Public]
> >
> > > -----Original Message-----
> > > From: Michel D=E4nzer <mdaenzer@redhat.com>
> > > Sent: Thursday, September 16, 2021 9:55 AM
> > > To: Greg KH <gregkh@linuxfoundation.org>
> > > Cc: Deucher, Alexander <Alexander.Deucher@amd.com>; Koenig,
> > > Christian <Christian.Koenig@amd.com>; Quan, Evan
> > > <Evan.Quan@amd.com>; Lazar, Lijo <Lijo.Lazar@amd.com>;
> > > stable@vger.kernel.org
> > > Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work
> > > when GFXOFF is disabled" failed to apply to 5.14-stable tree
> > >
> > > On 2021-09-16 15:48, Greg KH wrote:
> > > > On Thu, Sep 16, 2021 at 03:39:16PM +0200, Michel D=E4nzer wrote:
> > > >> On 2021-09-16 15:05, gregkh@linuxfoundation.org wrote:
> > > >>>
> > > >>> The patch below does not apply to the 5.14-stable tree.
> > > >>> If someone wants it applied there, or to any other stable or
> > > >>> longterm tree, then please email the backport, including the
> > > >>> original git commit id to <stable@vger.kernel.org>.
> > > >>
> > > >> It's already in 5.14, commit
> 32bc8f8373d2d6a681c96e4b25dca60d4d1c6016.
> > > >
> > > > Odd, how were we supposed to know that?
> > >
> > > Looks like the fix was merged separately for 5.14 and 5.15. I don't
> > > know how/why that happened. Alex / Christian?
> >
> > The fix already landed in drm-next, but since this was before the
> > merge window, we wanted to make sure the fix also landed in stable, so
> > I cherry-picked it to 5.14.  I'm not sure of a better way to handle
> > these sort of cases.
>=20
> You gotta give me a chance to know what happened.  As the drm developers
> do this a lot, they have been putting the "cherry picked from" line in th=
e
> patch because they can not merge between branches and keep the git id the
> same.
>=20
> So try using the '-x' option to 'git cherry-pick' next time?

I can do that, but historically, I've gotten a lot of flack for that becaus=
e the commit doesn't exist in Linus' tree yet at that point as the merge wi=
ndow hasn't opened yet.

Alex

>=20
> thanks,
>=20
> greg k-h
