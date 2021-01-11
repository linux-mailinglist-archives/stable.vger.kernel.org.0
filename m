Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921072F1875
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbhAKOlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:41:22 -0500
Received: from mail-dm6nam10on2088.outbound.protection.outlook.com ([40.107.93.88]:18273
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727484AbhAKOlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 09:41:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhGnS4856ky9hJvghRfJUTfOxmCYJqPYAMBFjiRaukSu3rwp8Rgpw2WVrn2uL/YSfzYCwBRvwwTavdC3vkmCN9PB3NUsmCAxcd05alpIoBenlr1Dv1TaofkrGzZMgsuQC49hamXFH1fqd+EhWp3N9vLHA7Srxb4RNIX0IOX911SB0nvGuhJ2M0thcUZS1O/2YrQE0tHY9zTrFZfDYdVe7QyOE7iVdUHnqAwq8uMhZN4Da4FMeOQCzo7uk3D2uFEodeJnfMmqdsW9Hk1ipZJZxTd2Eyy5Mp1iA3a/gWGcJ0LbP1TIONjPk5kvhwbClknoEsXNQE+++WwTDsgUrR+EcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ucgjut07gs+PVrGyO6KC73e8aaLmEwjiT7EdOguwgHc=;
 b=EpWlZG8zi7uUFQjjdvrpD6Ixso4q62BQvKhNHA5tGZP+qXbTDnX1ld7bAsvZJlxubAahzvjRiq2GJaGfLKVSOyqEV3OPojTNKlpDG7a2Xdy+s4za8+i6mLwlUvH8kNiPLnXo62BOoDFs7v+c5Xq86kPmPRfJ7bxrjHURLaBKSGsr5f4qXRtV2gPzLCjOS+ciwdMz17rDw+ERMUp8Z+LSd7y/0Ss5tGIVztanVpCuJt8VLYP57piugDvtePhHydxz43tetvo8yaHVsI2BbcGbn7mZ4DiQA0MeJM1ASgMzUEfUjoLM3LHT4/B6QK8oJZT1pZdd+gJ9bcDN/9zVL2Nulg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ucgjut07gs+PVrGyO6KC73e8aaLmEwjiT7EdOguwgHc=;
 b=zfCOYDheMGoIOjt7G2t4ERaz94QnBZgnSQUm/INXRxxIB65byCyIcTsXHNj28mraaL1HIB89htSPA3Q5jF6GgG1zkOyF3uGALdUsMAogRJntRRwdIYsrWF3LtQ1o1fkYgWW4ZdB/7HUKw9XkvASpxiID+WEtUO6+SjwVFHOYpEc=
Received: from MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19)
 by MN2PR12MB3821.namprd12.prod.outlook.com (2603:10b6:208:16f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 14:40:27 +0000
Received: from MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::b0c4:9a8b:4c4c:76af]) by MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::b0c4:9a8b:4c4c:76af%5]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 14:40:27 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "andre@tomt.net" <andre@tomt.net>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix memory leaks
 in S3 resume"" failed to apply to 5.10-stable tree
Thread-Topic: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix memory leaks
 in S3 resume"" failed to apply to 5.10-stable tree
Thread-Index: AQHW5/fiTfCnOViHLUeHW5ZRwX//zaoifrzQ
Date:   Mon, 11 Jan 2021 14:40:27 +0000
Message-ID: <MN2PR12MB4488ECF24D89C1874B3E9087F7AB0@MN2PR12MB4488.namprd12.prod.outlook.com>
References: <1610355550144178@kroah.com>
In-Reply-To: <1610355550144178@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-01-11T14:40:07Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=11834095-a3de-4acb-86a9-0000f4e3684b;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_enabled: true
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_setdate: 2021-01-11T14:39:58Z
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_method: Standard
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_name: Internal Use Only -
 Unrestricted
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_actionid: e07b0ac9-3862-42a0-9766-0000219fb443
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_contentbits: 0
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_enabled: true
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_setdate: 2021-01-11T14:40:23Z
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_method: Privileged
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_name: Public_0
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_actionid: 8097d28e-cbf2-4a1b-9e80-000095f1a1a9
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
x-ms-office365-filtering-correlation-id: 3228db4e-a00f-4a95-5697-08d8b63ed66b
x-ms-traffictypediagnostic: MN2PR12MB3821:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB3821EE47899FE13AA1F06F9DF7AB0@MN2PR12MB3821.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OU5Ix8NkalhX+pOt503WR1Z2HjgIE+WXUFYw0HHgKIHxw91QftM5KrIVdIcEX8X5jdLANmbfHThl3l0CruvLW4xRhlQpgPuIqkaTwgzBdv9FSKapMxmjSBrTeUg1Iuns3YKHRcg6nLHGOI5vjo72en4oeBrSTBfhbxXw2xi6pK62nJ3iNh4GHnLQ0tngb4L/MgJiukMFqb7Kn99mcKpZ1GugK0kwU6tzxQeOl49LIsFJjVRDTX3CfidNIgXvMr6fl/XzkIGLgsjxlqR1jVlkzdiqlHoH8ugfeklH8WLHaVgU1EG6aNWjlvTxWMb3nfBgh6hW083k6fO9xIY5PtIrN0cQHI7YB609CvErpvVJOMNvt+0WBc6w/xmMlsV9Se913OeYyUxXseiwp6Toqi5JobGOwuM5AfULfrzsEWkwq5UEZfXb+cGCFNUn5WqbRy4P7FXn3iO8QXp1cVKyf79rCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4488.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(52536014)(316002)(26005)(7696005)(83380400001)(66446008)(6636002)(64756008)(110136005)(4326008)(66476007)(66556008)(33656002)(186003)(8936002)(76116006)(5660300002)(71200400001)(2906002)(66946007)(8676002)(53546011)(6506007)(86362001)(45080400002)(966005)(55016002)(9686003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hOD08Q5ggWZ1CvqyjrQL0PRErow0CvQFFsrnrCAQMJq0MD70gVuCCwQhX77m?=
 =?us-ascii?Q?GbmkMJ5OIeMVqaQFiuda4IeXXXAFXl1tp+xn0shbxzOqGR5fSeO/JR0mAR67?=
 =?us-ascii?Q?IeLOcoyofOn38YcMqaXrHHmkQPgIfOF9ykn0Fgt7CrbY8ndDgC8mCncsbkT/?=
 =?us-ascii?Q?PYiW2eI4muT3StrE6Id+iXP/jvRH5MWhOjmXCOdb+z+BgYS3WvYJwvrsO+QP?=
 =?us-ascii?Q?SP4/UinXVsawsS+A3eqOc3VBZkvQS4/ohJGZ5aVcWpv2Y15T2iXCVCNUgXDD?=
 =?us-ascii?Q?e62L7KAXmaWRnpNiK2+X+ZzSI8Cb9Dn1w4ZNj6cQvqu/WIBiLcOMqyP4L583?=
 =?us-ascii?Q?YBgzEIGSqPUI2vORSXcYvlaYbHb/VL8I+ulTlKfqiRycH8l1aiFaMYi9bS32?=
 =?us-ascii?Q?o4Tmv7cM6wycVt09sfZSwaq0tVVLPzYNXT8+qrXAx3lCt9BRr2I3ZjRtYUYx?=
 =?us-ascii?Q?jycW8HUBANNKqPItm5xqWxDP8jq3F9PTdm5leur2CUDK52Qr3zf+yz8zAz15?=
 =?us-ascii?Q?dhgVpuqdwpDHxDShIi6SI0bkXqKYDQv7GWb2wtTi9Ch7Z930PT1RFPBkq1I+?=
 =?us-ascii?Q?sTRDcoXInFBlvCUO3NE06aMBs9m5g9TqtyNzk0Mlm/PqY/hVHrQSdQUPntRT?=
 =?us-ascii?Q?dGhZSp6Of4DvXHbUZdDjpDo/e/Zhm+c7JnhJF+UKnZwQrnNNxwdccUHYpkt3?=
 =?us-ascii?Q?d5T1Lh8KZX9LYMNjOmLCtqrdM5CotFkAKDHic5OITSmmKXZ4/OYUDOUe5DMO?=
 =?us-ascii?Q?0IqpAIox9wcKjdSD4JkBEQAMLVmWPDGLb360GI6CuH5cGLzS966neO62tfVi?=
 =?us-ascii?Q?v43wqJUHTNXDe5dBEiW+ofHkCf075QAQXdAJopPVn6ii6PlpdzPEv9MnVgOn?=
 =?us-ascii?Q?k3aoTZshLihtb7++PjtRPsvEdjmZE4Xtlk0kKalB8xqBQF55546m3fqV1zi4?=
 =?us-ascii?Q?QUGugjkjP/jwtt2kVAn+dnkiHrdw4ItQHYXxuWXh28E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4488.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3228db4e-a00f-4a95-5697-08d8b63ed66b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 14:40:27.3894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t5IKZGuk3WD87COlhSSI18PNshhT7NYb2plcregwht+bzvBhHJ11VgfbwAxeeCSh0dWZyXhNbzI1PpRTzE/IyQ==
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
> in S3 resume"" failed to apply to 5.10-stable tree
>=20
>=20
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm tre=
e,
> then please email the backport, including the original git commit id to
> <stable@vger.kernel.org>.
>=20

This patch is already in 5.10.  The revert ended up going to stable and ups=
tream at the same time.  Sorry for the confusion.

Alex



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
> exander.deucher%40amd.com%7C289ab8e4d59b4cc7091208d8b60f035e%7C
> 3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637459522892609085%7
> CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJ
> BTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3D54bcvpMtYCw98Nb1S
> DeNC6LZOoY365gnM9054qMo8tM%3D&amp;reserved=3D0
> Bug:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla
> b.freedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F1427&amp;data=3D04%7C01%7Calexander.deucher%40amd.com
> %7C289ab8e4d59b4cc7091208d8b60f035e%7C3dd8961fe4884e608e11a82d99
> 4e183d%7C0%7C0%7C637459522892609085%7CUnknown%7CTWFpbGZsb3d8
> eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> D%7C1000&amp;sdata=3DuSJC2lY4Bm%2BxiecaPXivfncCUEsb1%2FKJ%2Fudaxsl
> TGs4%3D&amp;reserved=3D0
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
