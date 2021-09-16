Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B8040DD0D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 16:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbhIPOoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 10:44:08 -0400
Received: from mail-mw2nam08on2063.outbound.protection.outlook.com ([40.107.101.63]:38177
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232753AbhIPOoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 10:44:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RImhzzjN9IZoIK4RkhKizPT86lpBmXK6DQjhE3BZTTf1VIMKAVq5fKf2J3Vd4JzbRtM6dkbK8bhscGeyJKMSUUy+NtsDmlI1BRnxFaAz9jeiDQr5bu/AlPGewAHvr+4VyuqS7QOeZgukEtRJu/lUtBo0sxVnHl/zaywZy4iRnBrKw3lWGUqd0SIGJOnlorAnTEL71ZQkKBVlNu2Vx98j/3XXT2DGLwH4foUu7JtMuMcytZLN8zpmedE3us/SGa98UYiOKM+p6HI1yIPCH7U6dPsUksCu+tQKv1la32RF9wJRhMDEwKMo6zLg4HBOMcHYDbUTVMmx2lyiiJBUm0MZ5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3is4v6CEbrFiejaMtawsoQNQiZWk6/BTG3xfs2pT5wE=;
 b=lJoC1oD/ENDnQRstkFYqDisQ8IlAMMTOw7PyU4E4wlq4KiwRa0j23PsyHB8TDjYy9Z0x5nzw9E2ycTPcYL8Het4cRd7UgfW679PTxiIcLX+0FrxxIOxlYCp2UHc1f98WCKa/hN9LGp9usGy8HCqkKJiOXGjxkGcDm+CaYq+jWWfNq45pClG3n8HBgg9FjTMFHWKgznQshkUsa4JD9aj9qFdtREBM79xfLPZl70q0RYc6xFZlrqnlO8BNaLmRrTkxkgk551kZtmpnMs6d1J3qkHMI4+POpRh4LyKLeqt5nJtaXeq5jS1CsNkuZ+dP0Ka5WIdXuU/jMb43OHUbAaWx4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3is4v6CEbrFiejaMtawsoQNQiZWk6/BTG3xfs2pT5wE=;
 b=SHRhMD5lR2oLoaQk07jZDTrX5J1UbaIE1ppif4yPHt8tqiy3/j2JDkvwueSSuG+TIu9PiH8YdQdY3SrL7axiXVL+jHZkVKMUJsMkU1V4xkn/TqXg6jLA54EFGmiBnsHglmijuKnyenPkd9NB04kCq6s3yLjWOX53ttlQtmmvfM4=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BL1PR12MB5333.namprd12.prod.outlook.com (2603:10b6:208:31f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 14:42:43 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::7140:d1a:e4:a16a]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::7140:d1a:e4:a16a%8]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 14:42:43 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     =?iso-8859-1?Q?Michel_D=E4nzer?= <mdaenzer@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Quan, Evan" <Evan.Quan@amd.com>,
        "Lazar, Lijo" <Lijo.Lazar@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work when
 GFXOFF is disabled" failed to apply to 5.14-stable tree
Thread-Topic: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work when
 GFXOFF is disabled" failed to apply to 5.14-stable tree
Thread-Index: AQHXqvuG2ELZJjE1LEC3nFRE4SzJfaumqoUAgAACmQCAAAGwgIAADG9g
Date:   Thu, 16 Sep 2021 14:42:42 +0000
Message-ID: <BL1PR12MB514443A3990D3E9CEF5F1251F7DC9@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <163179752354221@kroah.com>
 <7fe8e175-efdc-b7d9-ab86-44aeec60c2e9@redhat.com>
 <YUNLMkxQPw/empni@kroah.com>
 <e5b4ad1d-4a4f-ae47-5c85-22842c1b44cc@redhat.com>
In-Reply-To: <e5b4ad1d-4a4f-ae47-5c85-22842c1b44cc@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-09-16T14:42:40Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=744b3066-fc42-43e3-9378-005b9b667f16;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60f2556f-acab-4042-387e-08d979203df3
x-ms-traffictypediagnostic: BL1PR12MB5333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL1PR12MB5333D79190EAB843E710B8A4F7DC9@BL1PR12MB5333.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8QM7yEKZ44o0/kFm9GN+2aUwaHnJcC3XvI5m3fs0h8S93j3UnmJqQeAcWDd18TtANRsNc8OT0J44iVKIWL2Gd6aE5ZObY7xZHprMlw4Xzf1PRglbmXQGo0QB8gCeBUp3kTNe6JiELmR36YGnxHZyhuwOLdUIQxINlionLrjD0ImxYwwpc6H4vPRqeZkTtqyzaLKm7iLj6uQZXmcWjQ1cOeHujSVWS3WruI54oeJRETcyLKChDVP4vkVzQqn7bTX7WRUYxx4hkVg6j+J+EpNpln7r2TApC58Qf4How22Jz4de2Sat0j6bRrLVGJppD3rTB4tgwG5zZza4E+j9osNlOLlA7LOSjLigLhbB6AiXqlbSKddZbHhGwzXdyYcILapzP1TFVh6JSWqbhr+U6tg4LYmBYn2c4kd30ibsrUph0EF4uRnQObnkuGMXMVzyO5F9MVL9zBWHqQDdLp2S8TDRDyKitS7YIxyxeV/dM7OFTz+HKxDFoWp1QwUYanU5IE/OvYxJJ91JOBHsGrixy2NeuTSVHeZZ3ZjDBU7U1ldTKFtX+ztaDk66AGra3QXLVlKu5GKqrMYYVEei3M9MRUXySH6nKz0H+Tw5WdkAkN/VmpSF8D7xAvJiEwk/Vf88zsxOQWdea27FNoAvNXxGcskqBGaeeIsiaO2PjcGJffInZdlMnDwMMd5VwEsJj9ZfUj61TY5f6Pl+qgcnrQrHe0oaqiXCk4alGPsmonvVWIUhKqoNMAyhp3+zYiUsumZDiS/jWX0xP4V+r8upJLOHY7LNtwIb0OSz32tLljbF6VZIems=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(38070700005)(71200400001)(110136005)(7696005)(33656002)(5660300002)(54906003)(38100700002)(122000001)(186003)(76116006)(86362001)(4326008)(66574015)(26005)(45080400002)(8936002)(478600001)(83380400001)(64756008)(66476007)(2906002)(52536014)(8676002)(55016002)(66556008)(66446008)(316002)(6506007)(66946007)(53546011)(9686003)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?88UgS/to3OKUw0xPVWYJMUUQ6PQaTR6lyu9940BbUOVwy/stuc7KhtHYXV?=
 =?iso-8859-1?Q?hg8XOyf6Xdh9gAeOJmiQOwEWZGTkrJLi98TgVlmq28GpsAQJwcPn6fjNVy?=
 =?iso-8859-1?Q?FoNnhrLFb7zbEBOIiYt+dTc67K3kobKQXvrB1tM0+FqOH+cHDMPjaGu8aN?=
 =?iso-8859-1?Q?G3K/x9M9/hfpX9sGeAExf5UL9OFRSZQfSJe2QDU+/vO7XFOYYE8HKIIn2b?=
 =?iso-8859-1?Q?+4n4BRncYpvDoVTPCITSSR3RI+oM1Gbfi7gCztrUzs2aK1qrCkl38zEVPz?=
 =?iso-8859-1?Q?GyZCOEIsWIAEzYm+rwo+wrFqPYNTaagDfRLXEsBH7wqMSAMX+V1QwsJHTQ?=
 =?iso-8859-1?Q?V/hBsLTZ0EK8KkGait7MTHvjQ9svuWmCL1UHSXeMiwcysoIcAmA+Uu6S7O?=
 =?iso-8859-1?Q?xHqwuX6WACveERGmEJ9NPbKVebEECZ7GxJiFEXmhd4L5aF1OJVX2Z5Et7t?=
 =?iso-8859-1?Q?shKFpKDBNRGGnKfhzYB/okVoYHPZlTGaYm1XL/zDVprW8jqVQKeW8Zf/LK?=
 =?iso-8859-1?Q?X5/VqnamQQC1eEQMJKr9h/3vLAKlNZ1TdRJOvQFYFZSm8hLCHzQ6jX4jTz?=
 =?iso-8859-1?Q?OM08Kc4jLy804A42SSc5FUSDbFWVnF0nQmEUxU2LSR7EVmHjUhachvnrhK?=
 =?iso-8859-1?Q?qb4/98TGvbmM25ygfbfYg3xxzTE92/JfcEd8fMZcnhmj2UEN5CB9QJlXge?=
 =?iso-8859-1?Q?gFNvVlIPmGrYWxpuTLG8g1aK6T5OEfHE/F7VRoeVt0U9xmeowBZl3Pz5ok?=
 =?iso-8859-1?Q?kwEkKSGZPsYo1flau9qSjiFKVmJfGqShWgA5virBz+cKrOZ2BDG7V6MXRy?=
 =?iso-8859-1?Q?JSl+VlwKX3H7a3H9LBWp4GX1nBFSXV/ge7fz001ZzcAOV4qekGXve7nuu5?=
 =?iso-8859-1?Q?SmvZesDoL4bV9wGE6aJpCK0HMnwt/ab7EIip571O74cPy8wOYHmsDrk7CV?=
 =?iso-8859-1?Q?GYU55eKmcWSgoQLWyftT9Jys/A81BeXolaITgyasqaf3mO+JTbvo2pGwqE?=
 =?iso-8859-1?Q?9aP/LBrqNpCSkejsaqT4F0n56dPb/wjKIJMGbpb43J2XjMMZa0hqzzLiVg?=
 =?iso-8859-1?Q?wkdmAX/RuKb7cr2ekRwvrBy1TmnieI3tgmCFXtGuaOEOt5bk+oFx78K2oB?=
 =?iso-8859-1?Q?POXV07AFW2KX5Z5h/1kq7q3C2p+o8Z1IF8xtL4DnapkdScehQ0o1uRxDFj?=
 =?iso-8859-1?Q?TbZJRNZvnkUQML6gvvsdz8eIfy7pqRHCLySoFO7JONQM0nyIeaV7raq6TB?=
 =?iso-8859-1?Q?/ajk/StdIvCd2yD18ooGLgVr0vsGJQGWQM+u3GJsXhxPa6nBin2XQRi8gq?=
 =?iso-8859-1?Q?FzB7LY5ToDxQ7FVfu0VgR+wPn1TUgJ7GxyTgXyObMN8JLU7SNYQR69mLol?=
 =?iso-8859-1?Q?p6oq4QN65g?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f2556f-acab-4042-387e-08d979203df3
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 14:42:43.3137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J8wJk14sUYkBT+EP0Pu7PBlwY2ltggZTZbEmUVbUZUieXIHJMmhnQhB+om//AwXl+vVb5vZQB0aL5exI62pphg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5333
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Michel D=E4nzer <mdaenzer@redhat.com>
> Sent: Thursday, September 16, 2021 9:55 AM
> To: Greg KH <gregkh@linuxfoundation.org>
> Cc: Deucher, Alexander <Alexander.Deucher@amd.com>; Koenig, Christian
> <Christian.Koenig@amd.com>; Quan, Evan <Evan.Quan@amd.com>; Lazar,
> Lijo <Lijo.Lazar@amd.com>; stable@vger.kernel.org
> Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work
> when GFXOFF is disabled" failed to apply to 5.14-stable tree
>=20
> On 2021-09-16 15:48, Greg KH wrote:
> > On Thu, Sep 16, 2021 at 03:39:16PM +0200, Michel D=E4nzer wrote:
> >> On 2021-09-16 15:05, gregkh@linuxfoundation.org wrote:
> >>>
> >>> The patch below does not apply to the 5.14-stable tree.
> >>> If someone wants it applied there, or to any other stable or
> >>> longterm tree, then please email the backport, including the
> >>> original git commit id to <stable@vger.kernel.org>.
> >>
> >> It's already in 5.14, commit 32bc8f8373d2d6a681c96e4b25dca60d4d1c6016.
> >
> > Odd, how were we supposed to know that?
>=20
> Looks like the fix was merged separately for 5.14 and 5.15. I don't know
> how/why that happened. Alex / Christian?

The fix already landed in drm-next, but since this was before the merge win=
dow, we wanted to make sure the fix also landed in stable, so I cherry-pick=
ed it to 5.14.  I'm not sure of a better way to handle these sort of cases.

Alex


>=20
>=20
> --
> Earthling Michel D=E4nzer               |
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fredh
> at.com%2F&amp;data=3D04%7C01%7Calexander.deucher%40amd.com%7Ceaf
> ba6f5f87c49c5fc0b08d9791987a2%7C3dd8961fe4884e608e11a82d994e183d%
> 7C0%7C0%7C637673972820037953%7CUnknown%7CTWFpbGZsb3d8eyJWIjoi
> MC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C100
> 0&amp;sdata=3DVQ5VPN9N3%2B0oRSWQDSgwU9D7V6ONdwaE34huiwRYoW8
> %3D&amp;reserved=3D0
> Libre software enthusiast             |             Mesa and X developer
