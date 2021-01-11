Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E032F1881
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbhAKOmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:42:42 -0500
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:23648
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726526AbhAKOml (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 09:42:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRgMqJXQYikfGFnzD7voMQbZ2ECFpeqOmZ/EZ63d7kqBhWXIEkcGj2yw0Sgt//4fG+kohG1BBbp73SIghug7e3X7OoQbHO/UY/ONYoHYrNz49bnepv3klRTh4hA6Y1c5+Uo4NDtR5LcVSn0JSi9Wi0f8RS+MAR0rp02CsnqGikjJG8yj79e9DFIXSZ1X63PRTJzjOFmUaPRqp3Tghkca9v6zA1OXh90vQOfFZsst8fLZSZxCP9ApV2mlKUaVAjzsZTnalTAzE8yydIslf7XJHw0xRVKUefKOWaWI/K+wQGIVrWv5O8tm5diKnyYgjGm7d0Auox7uurUGUXLM7A/EgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecR9VcKwKPS/TvHjUlKMaK6hN0z5NxceadUXUiXxdjg=;
 b=ZQ08pwykIlJmfoF72Z1gEB7E5gVYru+AlC02JVujir7H/8ep5vINqGurK9dYsMND0zYoGYdzqbqkbSOrm72P0nqfzvwjuYLgnLSNb/h5CTqAwjWdedsfHTMnMPuNW3syS7MrkdhhU/9BBiL59GqHkNxsSsF5cQAHVxKcj5/w/L3/V2wXtBxE2DZ68NGNHRX3LNLeXtACHUJOBu8RWIMSzv4G+EWOMZIufb9Y2f5vAdcZxKzeRTHP+7k9iNXNDoEWjVzJTabljp+X8+780QyrE9wgd5bIpg3I5kGGhM1YINAmhSi1V0sR73NEMiQaBCgwqATHdCLAio31WahA8bz/Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecR9VcKwKPS/TvHjUlKMaK6hN0z5NxceadUXUiXxdjg=;
 b=OgAhRdLv8rvFdoIQUckHkflyY9toUSUmN7NwiyfA+vTzCvmamew9X/RfsXWJxR/7tbUgMRQkW/duiKagQfPWShoiU24vbcjU3sLx3pxoTt6QeMFozLYwkGxlsNe/PoZFjp+gw93/XY/eRIU8QJFHY3F4jNy+5trad9y9EkeEE6E=
Received: from MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19)
 by MN2PR12MB3821.namprd12.prod.outlook.com (2603:10b6:208:16f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 14:41:48 +0000
Received: from MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::b0c4:9a8b:4c4c:76af]) by MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::b0c4:9a8b:4c4c:76af%5]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 14:41:48 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "andre@tomt.net" <andre@tomt.net>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix memory leaks
 in S3 resume"" failed to apply to 5.4-stable tree
Thread-Topic: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix memory leaks
 in S3 resume"" failed to apply to 5.4-stable tree
Thread-Index: AQHW5/fceJUvD/SFuUyZdBwl9xnabaoif5bQ
Date:   Mon, 11 Jan 2021 14:41:48 +0000
Message-ID: <MN2PR12MB448888B4B1DCDCDE4DD942EAF7AB0@MN2PR12MB4488.namprd12.prod.outlook.com>
References: <1610355550252222@kroah.com>
In-Reply-To: <1610355550252222@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-01-11T14:41:33Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=894504d0-1542-4ca2-952a-0000a8238a5b;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_enabled: true
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_setdate: 2021-01-11T14:41:40Z
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_method: Privileged
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_name: Public_0
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_actionid: 07bceb8f-b3b9-4ee4-8c80-0000b8687458
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_contentbits: 0
dlp-product: dlpe-windows
dlp-version: 11.5.0.60
dlp-reaction: no-action
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-originating-ip: [165.204.55.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f8ff03e3-d68d-4cf6-1a72-08d8b63f068c
x-ms-traffictypediagnostic: MN2PR12MB3821:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB3821DCE3982F6BD64D6CE4BDF7AB0@MN2PR12MB3821.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7FEeiJtP6DEhJm2oKYPrd+xoDsoVnvsBFQoI7PxEqNr25yviRJgh1WW7aU/HFd0vQbpzcQxMjGBaIZT2UeINvKTBGcebm8Z2CtWWa1xl6ERhNXDUcFwr1UdBwfMOTmZawPixjXw+aCtisfeVDrZdH56w7dyAsUQthJSi59UWCd1M5kHarIdF7eYEYk+/o518jHRqMrzKHA7ZItKoo0W40+ro6buYCr8rZfZK3QTR/aoZI/+ubhc5EoWk7HtAyjdM6nQPbIK6dhKeY19cpFoSTBiyK40tLDKD98s/L8wAZrkhOsZQFsMmyPLb9wGFKK/jgrLrLHCLrOo3/JPQWvqhSkprwrIH/qryF92y1hkoPuvNszkqStdzBDcSTXZU16FYvMzsHicdbt9Dj/2PnjX1edY1QZMJ6nlkdd6NjthS4s/tUZ5roB4i3ohAxqgkgCm4Gr5i4fZI5evaYe+UyV2apQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4488.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(52536014)(316002)(26005)(7696005)(83380400001)(66446008)(6636002)(64756008)(110136005)(4326008)(66476007)(66556008)(33656002)(186003)(8936002)(76116006)(5660300002)(71200400001)(2906002)(66946007)(8676002)(53546011)(6506007)(86362001)(45080400002)(966005)(55016002)(9686003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TilALdWPAtdjf5DA5dXs2lAvcYlBSEvQrwJtnc0P0geQMKgRIZLAUxcDca8A?=
 =?us-ascii?Q?GloMSylN6rafxS53l+hv4s3Pe6wPH7id9FGCBv4pdAyauzwOIxkkeMKqTD7G?=
 =?us-ascii?Q?1uDzHa/+xAe5/kCjcvYvNspIyN4ribvWt4ICafJRAe5JPVmW1nv/QFeMeKui?=
 =?us-ascii?Q?vCUgY1upx1UeLVNNEYiBro/yd6G4RI6t+cuHnSAIWjB8L6u4e/MCQCSXsU2Z?=
 =?us-ascii?Q?tKnTW7H+9mGHFZpe+LgR7TEfjSrfCrBOkdix+lahYwkpywhgg/6q0nITgr+Z?=
 =?us-ascii?Q?AUUeuRfrwG6zfshRJNn+zzUaznfTRHeLC5IVO0F7pzIm140dZYXdY/JEfioC?=
 =?us-ascii?Q?171oUn8yIs2M5+20+1AnYbZv987y/r61tg0eakr0SCzAd+uUmeXqLtUnB76g?=
 =?us-ascii?Q?qcgw1akz0lyWhA0D0yVOC3OKxs1ZddHfEhpK9eE8xW6YowMDcW394C4A0elF?=
 =?us-ascii?Q?oTELJ4X1UA5qORJInD5FFNB4ETKMHCJ24PVaWCqzugzzvHmD3ThyQtEiXIND?=
 =?us-ascii?Q?JChIn6C/zTQ5vy7LdwrFh0acxzsLFfUEvV+j0/UcPRFdXV3Ru9ZPAbPUR1tb?=
 =?us-ascii?Q?7YUJAMLz7P+3gOLOCIUd8s/m5R9aLoa5GlyJdD9Tuw/ZITzuPEJdRn6wJ8Lq?=
 =?us-ascii?Q?L0t2qeKYbXYIGqwZc+l4GXUcnLMcw9mehZPrAbec6ySfHAhvHj3QVOfUK6kN?=
 =?us-ascii?Q?hvCOhzG++OG9zLFMwNpsLTPMSXYQ9EB4qZypLmmm203Kyb+xdl44MH4B5MWI?=
 =?us-ascii?Q?cH8uZrRmPHMraBF0DS860Pgj8IN8BlHTDVX+vBoCTM4hTY2+NtgNA6KX+I16?=
 =?us-ascii?Q?b6RT+96LhuHDM60FMr+jRkEVSwWpnY11u8krIylMlzs02ZzdwfeGVdoYOjSC?=
 =?us-ascii?Q?+4fRE8sloA0H2C3pdIofGCjFWXqlGqMiRIDPEOUY7xKrCxJ60KlFaki7u2yQ?=
 =?us-ascii?Q?gM6un4DTILmAc6ciPp4VTsCiB7QpUlEJE6pDxy2rCy8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4488.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8ff03e3-d68d-4cf6-1a72-08d8b63f068c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 14:41:48.1367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m+LPd5zOy/K0amFJyZiY6L9bHPHHa+5N4rZXd/tdVLpt8sHhVch4cIz0y9zvzsgcPekLT9xRSciUs8xaPg3YEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3821
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Monday, January 11, 2021 3:59 AM
> To: Deucher, Alexander <Alexander.Deucher@amd.com>; andre@tomt.net;
> Wentland, Harry <Harry.Wentland@amd.com>; Kazlauskas, Nicholas
> <Nicholas.Kazlauskas@amd.com>; oleksandr@natalenko.name; Wang,
> Chao-kai (Stylon) <Stylon.Wang@amd.com>
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix memory leaks
> in S3 resume"" failed to apply to 5.4-stable tree
>=20
>=20
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm tre=
e,
> then please email the backport, including the original git commit id to
> <stable@vger.kernel.org>.


This patch is already in 5.4.  The revert ended up going to stable and upst=
ream at the same time.  Sorry for the confusion.

Alex

>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 5efc1f4b454c6179d35e7b0c3eda0ad5763a00fc Mon Sep 17 00:00:00
> 2001
> From: Alex Deucher <alexander.deucher@amd.com>
> Date: Tue, 5 Jan 2021 11:42:08 -0500
> Subject: [PATCH] Revert "drm/amd/display: Fix memory leaks in S3 resume"
>=20
> This reverts commit a135a1b4c4db1f3b8cbed9676a40ede39feb3362.
>=20
> This leads to blank screens on some boards after replugging a display.  R=
evert
> until we understand the root cause and can fix both the leak and the blan=
k
> screen after replug.
>=20
> Bug:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbugz
> illa.kernel.org%2Fshow_bug.cgi%3Fid%3D211033&amp;data=3D04%7C01%7Cal
> exander.deucher%40amd.com%7C84b09c22c469404992b308d8b60efe6b%7C
> 3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637459522804784905%7
> CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJ
> BTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DCOVjAY9N%2By6Psbo
> gUWfTTWVGUdC4KDHv5UmmycvxLcM%3D&amp;reserved=3D0
> Bug:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla
> b.freedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F1427&amp;data=3D04%7C01%7Calexander.deucher%40amd.com
> %7C84b09c22c469404992b308d8b60efe6b%7C3dd8961fe4884e608e11a82d99
> 4e183d%7C0%7C0%7C637459522804784905%7CUnknown%7CTWFpbGZsb3d8
> eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> D%7C1000&amp;sdata=3DQsldTtqFAIda6pQBpQ%2FmuE0CcYqbm3BeOZbGyjQ
> hbn0%3D&amp;reserved=3D0
> Cc: Stylon Wang <stylon.wang@amd.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> Cc: Andre Tomt <andre@tomt.net>
> Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
>=20
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 3fb6baf9b0ba..146486071d01 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -2386,8 +2386,7 @@ void
> amdgpu_dm_update_connector_after_detect(
>=20
>  			drm_connector_update_edid_property(connector,
>  							   aconnector->edid);
> -			aconnector->num_modes =3D
> drm_add_edid_modes(connector, aconnector->edid);
> -			drm_connector_list_update(connector);
> +			drm_add_edid_modes(connector, aconnector-
> >edid);
>=20
>  			if (aconnector->dc_link->aux_mode)
>  				drm_dp_cec_set_edid(&aconnector-
> >dm_dp_aux.aux,
