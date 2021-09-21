Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A05B4135B2
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 16:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhIUO67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 10:58:59 -0400
Received: from mail-bn1nam07on2045.outbound.protection.outlook.com ([40.107.212.45]:7087
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233647AbhIUO66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 10:58:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iME4rZluWDGI/h19YjzioD9NxNnfD+UMFo0OaJEpcvd7j/DluuV6BDif7BcET8DKJyqJHiDhq1ww6kyF5BnpKiH99yMF18wdR9BM9eFB2yBDPHO3PuB6fW6adr63B8hCmlPs/HxHgNhL5VYopWRAxKx0OKvBLAqJhPONOjMQQt1CE8B7WtSs1AEzu92UVSJwnzi/1XyozwW5n0crze2yQb3FukTx4on/tJl8N1hQ+R0htJcGaJ+lAGrkCJL/4tFoxRouzuntFWoSjpVGz9tE/3wZIvdT9wL8B+jyH9/HGb/MH11BRoGcctJwFUQYceyTFgCeviu1EkrEDKiLz5vyZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UfZ8xe+r5wd+JkW5l3liw9mm0ol+PLo1Y/ARxEMES48=;
 b=lGN3319GVA9BOSOd70zOMeN4CsF92qAZ6xyy7saLcxgY8hz5srGdzrTXc4jkP3+gUT/D+PEDoxL02I467kN+efOhNHPUTZIK81Yt21zMgcqkgbaW3+ERp79hnvpZeFY/ZL0TLqG4ZDW4unE6f26sxyGzl6gmihKrsP0/WStkkC+vH2wVbBaaQndw3rMNN5ldw7yP7D2NU4xEvvMhRHaY3XI4joHYpznyODD+HbvbryhVE1+pxiYB7fKGg5T0BvmMd4Q3nyamS/rAQf51MZdWhGyLnJf79Ic8NKvmRVfcZFERmcvYm/Pqhxzpw0LBUnR3RcS31eni/w1Qb21hjL1nvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UfZ8xe+r5wd+JkW5l3liw9mm0ol+PLo1Y/ARxEMES48=;
 b=a5soDqLzFeJawQcdleCpDtPppX4kvZRWkC6H6jv8JMbsSecnvttBoIjT4zjCsDafXzmBP9FfxESdP50QlPz6aXnQmONLxHh7cP0VcCveXBrSOiL5/VoUqiHo2HwB4W7/KUGOiVJgoyREDFzW/AfgQyf0EMqBLnt5JtdBOo+VQAo=
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 14:57:27 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1%4]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 14:57:27 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Maxwell Beck <max@ryt.one>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 5.14 10/25] ACPI: PM: s2idle: Run both AMD and
 Microsoft methods if both are supported
Thread-Topic: [PATCH AUTOSEL 5.14 10/25] ACPI: PM: s2idle: Run both AMD and
 Microsoft methods if both are supported
Thread-Index: AQHXqO9wTlSUanUmiEerKAIJC86xAKuun49Q
Date:   Tue, 21 Sep 2021 14:57:26 +0000
Message-ID: <SA0PR12MB451092FB36EAFACFCD928212E2A19@SA0PR12MB4510.namprd12.prod.outlook.com>
References: <20210913223339.435347-1-sashal@kernel.org>
 <20210913223339.435347-10-sashal@kernel.org>
In-Reply-To: <20210913223339.435347-10-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-09-21T14:57:23Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=32715274-8728-4366-8b21-6cbec1dc028a;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a76430dc-3433-42e2-68b4-08d97d1020db
x-ms-traffictypediagnostic: SA0PR12MB4511:
x-microsoft-antispam-prvs: <SA0PR12MB4511391505B7CF74E34ECF80E2A19@SA0PR12MB4511.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CGfQ7Y5qJylcnwScjFriWT6xC5ZNFBPLGPLTeSnuNlkJcT4oBQmR7DphcWEUeSYD6gMSu8HfWdICJfE7o/hMFW4dZw0L/EYjPk71h+EFSw2mi+0Sgg2O2tExXC6iDiTVpAV3ZUoqc8TFNwopmOd4okYRH3iwKsV4zmBafKIyC7nqDUkJUVcLobb+GG848iWlx9l0EikaNWInobzAPXS/aIUY4lUYTZWyKGita1suewyqLXxfcjXPzoqyXPbxZf6T5JeZU/ugSQnv5tRXJGCUvURp7gxHVPgXX5mrlF4/qAK0NprzvMR8mmaHWm5IimQW6guN+7gHM3Y3Y5I4VO1upzUDihTTVAwMghcs20oqtUp8L0mojOnRgez7Hqhlue6EUnVvrYg1udxovxJoZzEjfjQGm2xHKai/BxDbwsufLC+IVAeEN8o+XH2LCVZLZfXSd6K0fejLyEtXDleOUHJtbK5A7tYCaxZxF3NGudy2fKdBHf20M1Jvlj4iW8FMrMq97aa2S+8LBbaYwHPEIGJOeThS4gbYnlTAmaZqUAnFKsURTGhqSzolYuec8+Sf0SSvMRba7lFyeyaSEMZsLtHGUXClKMpSXgnSxuVALx2jIQ64AmVZ8YoM5WUNhXR//AMASmn/+wJqSxJhGx7VTpkaXKhiVJLlnjHrJftHP/hGaI1PpQ9WafE9gqts/jOCV0oScyTQ3y/F7NNkGbGdWowHCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(47530400004)(54906003)(508600001)(110136005)(76116006)(8676002)(38070700005)(316002)(38100700002)(64756008)(5660300002)(66446008)(83380400001)(186003)(66946007)(2906002)(55016002)(966005)(8936002)(52536014)(4326008)(9686003)(66556008)(33656002)(7696005)(6506007)(53546011)(122000001)(45080400002)(66476007)(71200400001)(86362001)(52230400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dQPU+5iEVY5u4VKZEF86jxXjMzMD+Ar9Af/yR3G8YPx4QR4S+KYsa17tjso5?=
 =?us-ascii?Q?gKNg6jN1UVfbWrkQgf2kRlHRya7mX325oezxqAJOIvmwK4iTZ2WnLYJuasrx?=
 =?us-ascii?Q?9tm5Pzjs4/zpCM3JLIi/spRop/6fPylLH7yYcPibh/IpYd9zcUL+HowSWrTD?=
 =?us-ascii?Q?9D/c3g493X7H5tXr9Sjjg0FsyXP/lF8rZfsMqwHjfBmfNYuYWIuEOisy+O9k?=
 =?us-ascii?Q?Fp+sgg5oEXqtvPIBA6rvcAJ2ZtoZUm9E5bSTK/mZS5iDDpVQNVF/Nnp3L7UB?=
 =?us-ascii?Q?kStTv33XiDcHFZZ/4fOT3tcJGWTbRhyVDrMqQ84c0Wgdyd8TGI1mGM1KHv8e?=
 =?us-ascii?Q?imoZ6jmHtg3m0QXx1bof+Q5QZjBL/OMPGjIDqYa+Yg1HWijy/v7pBIe3XlB1?=
 =?us-ascii?Q?+3YBCKja6rMh71AcC74ZUG0RzGr450xx/McGmi2ekn5Yoc6aYz/r5ZwZkZzw?=
 =?us-ascii?Q?JUb9DoCKKgdYOnjBSAiw1AEXg1M9VcnVLclmjil/AHhacMhYH7eN+YKvxM0m?=
 =?us-ascii?Q?XJNgN28a5UtwNxPrHJJfYRylnAGScoSNinMCFMvBE4BIWqspZ8d/77LgNtWV?=
 =?us-ascii?Q?vPw0SEUuBlYx7H7ABtvvanMKNAuprhVDvvjJb3SQYXx1JV3Hm77fOQiLg0lJ?=
 =?us-ascii?Q?ywgZi9fPg6B2FLkocE3xCxs+dWER7hZMKCQk4KnKzNQoK10fo0g1dRIg/t9V?=
 =?us-ascii?Q?Tg8NePx+BdOra5yIkC3hlLqEj7knfba9CiyDx+PXcnFqubpDrM0EIVibhLXm?=
 =?us-ascii?Q?m+KfU88mGYZGe0mntRZVgx5jNymd1p3BGxZzXKHjh/WugYeVVJL4DV1pHhJb?=
 =?us-ascii?Q?7XOkHSBWevarRC619OQbfiUiMzWwyBpWg/rBNhk5w+jaOvHSQLffjb8xnGNj?=
 =?us-ascii?Q?2ntJm8G/RfmS6tNNOr+n2u2aMCX1bXVvBzN6T+TojjJtOerCAWU2pStSdDCr?=
 =?us-ascii?Q?8BXdHlmPvKzHrW99j4UlOekfOvHTcRjLGfCHxkcqnA/DYjINpyYeGLr9iC/C?=
 =?us-ascii?Q?22v1rUiybOMPDDMG32GEZZM8t75flAqT8VU87wm00vNr4xmLc/Y7TA5JFSIU?=
 =?us-ascii?Q?zWwTRQMQywh741SHKkNrHxaOgop/twrU3XC9S6oNO6ZiYrYjR/RQqtc6ZMVR?=
 =?us-ascii?Q?z0vGIl9Vr7bhgqFuCeTCOQlOK3Ztqy+6HX/7C3r6CGBtgTLv+8VR1bCEtSKZ?=
 =?us-ascii?Q?f1HNLE4NZMtzpq99RaPwLwS1KjGS+C+YcYb5bUq8EHEH+4xeV/D/X0QehQzV?=
 =?us-ascii?Q?xtKIC5ZN3gGFPjMV0d4rPrDT/moIWwmNJ49yUSRhfCN6R7oH/K7Sg4sVbt+2?=
 =?us-ascii?Q?7b9IX7zFJS4WbKxR++eBx3Fb6atWnBLGVw3kmjH9Z6Aj9X6ttFjWLg+v7M36?=
 =?us-ascii?Q?ZrD4v6lCCI8P2FRFyNpu2oDqFksY?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a76430dc-3433-42e2-68b4-08d97d1020db
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2021 14:57:27.1793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aH0eu+c3c1fqyzNxIu/RLGrTYtK/G5vwpBjbS+0b6iOO3JMiW8v6cVEJllcbEWFOIuIU0KwHfcA3oqUem3vxnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Monday, September 13, 2021 17:33
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Limonciello, Mario <Mario.Limonciello@amd.com>; Maxwell Beck
> <max@ryt.one>; Rafael J . Wysocki <rafael.j.wysocki@intel.com>; Sasha Lev=
in
> <sashal@kernel.org>; linux-acpi@vger.kernel.org
> Subject: [PATCH AUTOSEL 5.14 10/25] ACPI: PM: s2idle: Run both AMD and
> Microsoft methods if both are supported
>=20
> From: Mario Limonciello <mario.limonciello@amd.com>
>=20
> [ Upstream commit fa209644a7124b3f4cf811ced55daef49ae39ac6 ]
>=20
> It was reported that on "HP ENVY x360" that power LED does not come
> back, certain keys like brightness controls do not work, and the fan
> never spins up, even under load on 5.14 final.
>=20
> In analysis of the SSDT it's clear that the Microsoft UUID doesn't
> provide functional support, but rather the AMD UUID should be
> supporting this system.
>=20
> Because this is a gap in the expected logic, we checked back with
> internal team.  The conclusion was that on Windows AMD uPEP *does*
> run even when Microsoft UUID present, but most OEM systems have
> adopted value of "0x3" for supported functions and hence nothing
> runs.
>=20
> Henceforth add support for running both Microsoft and AMD methods.
> This approach will also allow the same logic on Intel systems if
> desired at a future time as well by pulling the evaluation of
> `lps0_dsm_func_mask_microsoft` out of the `if` block for
> `acpi_s2idle_vendor_amd`.
>=20
> Link:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla=
b.fr
> eedesktop.org%2Fdrm%2Famd%2Fuploads%2F9fbcd7ec3a385cc6949c9bacf45d
> c41b%2Facpi-
> f.20.bin&amp;data=3D04%7C01%7Cmario.limonciello%40amd.com%7Ce1f8dfc3d
> bfb45fc44ef08d97706917f%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C
> 0%7C637671692363481559%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjA
> wMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sda
> ta=3DwP0oz8OMnby9PA4MFrbY1ZAT%2FKv1jctTyXl%2BDteNHqY%3D&amp;reserv
> ed=3D0
> BugLink:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla=
b.fr
> eedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F1691&amp;data=3D04%7C01%7Cmario.limonciello%40amd.com%7
> Ce1f8dfc3dbfb45fc44ef08d97706917f%7C3dd8961fe4884e608e11a82d994e183
> d%7C0%7C0%7C637671692363481559%7CUnknown%7CTWFpbGZsb3d8eyJWIj
> oiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C100
> 0&amp;sdata=3DMVhVz%2BYBTdwgvkkSRRFsL5QdfDLPgTzoMBjD4dsFfMA%3D&a
> mp;reserved=3D0
> Reported-by: Maxwell Beck <max@ryt.one>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> [ rjw: Edits of the new comments ]
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/acpi/x86/s2idle.c | 67 +++++++++++++++++++++++----------------
>  1 file changed, 39 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
> index 3a308461246a..bd92b549fd5a 100644
> --- a/drivers/acpi/x86/s2idle.c
> +++ b/drivers/acpi/x86/s2idle.c
> @@ -449,25 +449,30 @@ int acpi_s2idle_prepare_late(void)
>  	if (pm_debug_messages_on)
>  		lpi_check_constraints();
>=20
> -	if (lps0_dsm_func_mask_microsoft > 0) {
> +	/* Screen off */
> +	if (lps0_dsm_func_mask > 0)
> +		acpi_sleep_run_lps0_dsm(acpi_s2idle_vendor_amd() ?
> +					ACPI_LPS0_SCREEN_OFF_AMD :
> +					ACPI_LPS0_SCREEN_OFF,
> +					lps0_dsm_func_mask, lps0_dsm_guid);
> +
> +	if (lps0_dsm_func_mask_microsoft > 0)
>  		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_OFF,
>  				lps0_dsm_func_mask_microsoft,
> lps0_dsm_guid_microsoft);
> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_ENTRY,
> -				lps0_dsm_func_mask_microsoft,
> lps0_dsm_guid_microsoft);
> +
> +	/* LPS0 entry */
> +	if (lps0_dsm_func_mask > 0)
> +		acpi_sleep_run_lps0_dsm(acpi_s2idle_vendor_amd() ?
> +					ACPI_LPS0_ENTRY_AMD :
> +					ACPI_LPS0_ENTRY,
> +					lps0_dsm_func_mask, lps0_dsm_guid);
> +	if (lps0_dsm_func_mask_microsoft > 0) {
>  		acpi_sleep_run_lps0_dsm(ACPI_LPS0_ENTRY,
>  				lps0_dsm_func_mask_microsoft,
> lps0_dsm_guid_microsoft);
> -	} else if (acpi_s2idle_vendor_amd()) {
> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_OFF_AMD,
> -				lps0_dsm_func_mask, lps0_dsm_guid);
> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_ENTRY_AMD,
> -				lps0_dsm_func_mask, lps0_dsm_guid);
> -	} else {
> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_OFF,
> -				lps0_dsm_func_mask, lps0_dsm_guid);
> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_ENTRY,
> -				lps0_dsm_func_mask, lps0_dsm_guid);
> +		/* modern standby entry */
> +		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_ENTRY,
> +				lps0_dsm_func_mask_microsoft,
> lps0_dsm_guid_microsoft);
>  	}
> -
>  	return 0;
>  }
>=20
> @@ -476,24 +481,30 @@ void acpi_s2idle_restore_early(void)
>  	if (!lps0_device_handle || sleep_no_lps0)
>  		return;
>=20
> -	if (lps0_dsm_func_mask_microsoft > 0) {
> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT,
> -				lps0_dsm_func_mask_microsoft,
> lps0_dsm_guid_microsoft);
> +	/* Modern standby exit */
> +	if (lps0_dsm_func_mask_microsoft > 0)
>  		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_EXIT,
>  				lps0_dsm_func_mask_microsoft,
> lps0_dsm_guid_microsoft);
> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_ON,
> -				lps0_dsm_func_mask_microsoft,
> lps0_dsm_guid_microsoft);
> -	} else if (acpi_s2idle_vendor_amd()) {
> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT_AMD,
> -				lps0_dsm_func_mask, lps0_dsm_guid);
> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_ON_AMD,
> -				lps0_dsm_func_mask, lps0_dsm_guid);
> -	} else {
> +
> +	/* LPS0 exit */
> +	if (lps0_dsm_func_mask > 0)
> +		acpi_sleep_run_lps0_dsm(acpi_s2idle_vendor_amd() ?
> +					ACPI_LPS0_EXIT_AMD :
> +					ACPI_LPS0_EXIT,
> +					lps0_dsm_func_mask, lps0_dsm_guid);
> +	if (lps0_dsm_func_mask_microsoft > 0)
>  		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT,
> -				lps0_dsm_func_mask, lps0_dsm_guid);
> +				lps0_dsm_func_mask_microsoft,
> lps0_dsm_guid_microsoft);
> +
> +	/* Screen on */
> +	if (lps0_dsm_func_mask_microsoft > 0)
>  		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_ON,
> -				lps0_dsm_func_mask, lps0_dsm_guid);
> -	}
> +				lps0_dsm_func_mask_microsoft,
> lps0_dsm_guid_microsoft);
> +	if (lps0_dsm_func_mask > 0)
> +		acpi_sleep_run_lps0_dsm(acpi_s2idle_vendor_amd() ?
> +					ACPI_LPS0_SCREEN_ON_AMD :
> +					ACPI_LPS0_SCREEN_ON,
> +					lps0_dsm_func_mask, lps0_dsm_guid);
>  }
>=20
>  static const struct platform_s2idle_ops acpi_s2idle_ops_lps0 =3D {
> --
> 2.30.2

I noticed this didn't get picked up automatically for 5.14.6, so as the sub=
mitter of the
original patch here is an explicit:

Acked-by: Mario Limonciello <mario.limonciello@amd.com>
