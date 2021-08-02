Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3573DDDA9
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 18:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhHBQ1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 12:27:53 -0400
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:54528
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232056AbhHBQ1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 12:27:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DYUwJU8sukHiDd3JRaavYyoi8zn/5rOImZleT44CYdbsJuXofbYFmd+JsY9BVHhvw0+HZWQS5FdjnkZlLr5rn98Z6NpTxXPTv40EF/liY3fMOpiHnHU2+vAZFshR3HmfU0IA37a0zrJtU8pd/hPBgz3Fqu77yZ5TavvxL8tI0XGa0FLiwn4v9bY6MFY4TAkpHE2oYusr4ZQFn6TgPdroM0Vxu43CmRYsFuEwTL/dbFtbSIB1hb9uAXsduSEHUeuceiNrtOiV1y8g4eZm37bohDP14N8WvyQy2sZoL/IbTyCDFmUOUg17uttkf86PWf1WHEaSEvVWWRwBCOBsiQd0YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXcywl4VjnNPV6jV0o14MXIHymMsABJNhybItXaafXs=;
 b=EoWyTSDkP87FIScfnQ/PDZ+a9QvSNAj3X2QrAEntpBrR8q38KP4NXeg9mr+8XbJgN2Huj86KqUhbac1FijtaRl0i1TpQK9u2RMLWR86i8kMTbqmk8styo/oQnzqf9TKOoryvLy+HBEJKowPgRpMvihJqfb7ArIYfRIo3Tty9WLD31gg1StUtV7a/4QG/xnQ/U2oKh25hifEIl/EItyl7IyqOgXB9VyqLao73AehgAG1H6MfYMXyMzpgz1bCaMnSzUtn2JAo1ZOj+NNqF40B65iEJ7rovuCpC1zSW4SyAubIgnC4iVPcdA0RswHsuv7Qy6wrgOsJYNjUJQYpzTM7u0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXcywl4VjnNPV6jV0o14MXIHymMsABJNhybItXaafXs=;
 b=TLL6ooqZM6XgOJ5ryVQuPzVAm5oP0edPWrmogHQ3+GhogyVwakZvp7KBPtsmB4A9sAbWQOPTIIuBcVBqSWxkI+a4heMUrKdLT/M2eyNlhSTiPCJloJW+epxXkLxVUFjpKr2q+SNnINKb+zOnAEUpkkwB1oAK9dRIxY12EGo6JHE=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BL1PR12MB5126.namprd12.prod.outlook.com (2603:10b6:208:312::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Mon, 2 Aug
 2021 16:27:42 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::8cb6:59d6:24d0:4dc3]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::8cb6:59d6:24d0:4dc3%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 16:27:42 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] drm/amd/display: Fix ASSR regression on
 embedded panels" failed to apply to 5.13-stable tree
Thread-Topic: FAILED: patch "[PATCH] drm/amd/display: Fix ASSR regression on
 embedded panels" failed to apply to 5.13-stable tree
Thread-Index: AQHXgf1t/5rh9awZzEOpJ1XflYyWJ6tgcizw
Date:   Mon, 2 Aug 2021 16:27:41 +0000
Message-ID: <BL1PR12MB5144F36AF9DB901EA963487AF7EF9@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <162729011947167@kroah.com>
In-Reply-To: <162729011947167@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-08-02T16:27:39Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=f69a6828-62c4-4ebb-a83d-c06eb7038052;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76b67809-68d2-4bb0-7e39-08d955d273a1
x-ms-traffictypediagnostic: BL1PR12MB5126:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL1PR12MB512669A3F8075E2751DE5C76F7EF9@BL1PR12MB5126.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hJ78MSuIryB95tjFQKA7AdGCKuLbH5t3XonC2cIVt/gkOGmFgiHTjXqN067Xy3r9Xcpx1OHnFJMRqjnfR9krNmYHblbZieDCuMafd43gVlDSSSQVf0aVvOLth+4UIkktcGtYYlOsi8u+XYMddluXs33cY3RpL3tY5YxdF7j27MDZ1ceMpd2QsNS/yaQC8wUjWAYsHBA2A9eyM2iv1usivjAKwtM8PKw5K20F0S4ka87dToSjOrqYKeZSD/ivppfaDCSv9AAfi6CZdqy1CfS2NQ/3VAj+awaSO2S2877o4UmMIiCzdVuODI2BvLk9PuoHPQYkUV0RQzJDWd/nPQdOzT+XdYHhzsPHsygzH8JR/DLEpIOSIcKnIR0dUvoxtUf9VgLCGDfVJ+H/363r3LgC29WAKa4eB+9Dl9+dcy3kKDf7g/+OajHt2Xxh1g2PZnYcYd3KEDcwFoyVWps6yPvyyYuu7h864SmxfZjScerRLPuKxrhIL0ExMgkuD9eHVRwGDpQvh/Wi7ALHY1DUoks7Dzh19fpVsqIS81sM8gG6yJ1vHpxxfmqu1C/xWgxGVRr1L+cvxgwFK5Ng1mycKS7QyCY2GFoFrLN2n4lL0mH693+Oy+/FA/3fXxL2s9ixzTT8fw5iIBHpJpvTIXI71HFKjalxWnH6IJWQasZVH3GEdEhGhQEQjNLxrh5j8hNfWHtx2cKeNuNHPvzZvRLep+tchLL0uxzsHKlphmW0xlOF4Cn63ueYM2sGH43/Jx0e4IQVZB9Jtw2M80ZUVQvkTAjZVs/advyB9y7CbryVYuncbJ2dhT3feaREtdvdMR2csQJ0hq1v2FdoAwG7o53hk5YxYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(4326008)(6636002)(8676002)(5660300002)(9686003)(33656002)(8936002)(38100700002)(99936003)(55016002)(122000001)(53546011)(66616009)(66476007)(76116006)(26005)(6506007)(38070700005)(71200400001)(52536014)(45080400002)(110136005)(478600001)(316002)(966005)(66946007)(66446008)(64756008)(186003)(86362001)(83380400001)(66556008)(2906002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T/XuIzK5sB+sD/TWfFMBdbrYYorRlOVlrCdIq/pSLyGLC3fhRJ6j+7K/5XAT?=
 =?us-ascii?Q?+bJmJ8+Vcjk2FlZZvvDLLLV/O940Xd9byQbaMiOba6URBla7vnfJnukfoJso?=
 =?us-ascii?Q?bu+4SCoT/Ma7scu/1GzsGrhQHFgcMt+VTSeW74Mo8fmvpvAMpUPLalRS+eOD?=
 =?us-ascii?Q?tADCoXPRne+XP+DFxyMqFBSujxhTWxykSkGzbE/XSuXNH8xe62ZdoHKKieVI?=
 =?us-ascii?Q?C/FLZjcR4MYoBA8gXlEa/khFCE6eHT50vLP4y7m21WLbaRFthyDkIu/Q4N4y?=
 =?us-ascii?Q?n9+94j+fomP/fLvmP2JYMTWQN1wH8ngrq8WwizBPNy4kaQ7tnX2f606vs7U7?=
 =?us-ascii?Q?QQZOtbdujpR4DqqEC/hyyl5B7HdGflGi08g6+r5eCu5hRddbvCeVD8I8D6BH?=
 =?us-ascii?Q?l67sFaNc7b29iKczB4X1rPe1IX+4T2GdfTzt7GXjXJpp6NvKAwzf5sOnX91O?=
 =?us-ascii?Q?I5jIsT+duPPZtZAMcRN+fFYscisN3UEh8lkUsp+ZhF/C7PMTRpiOOKI1HgKU?=
 =?us-ascii?Q?OqzuDbYVkTX9baJlkBIRLuyi17Klz5ffwXmoZ63LAf576P87PVmIabiKCQQ6?=
 =?us-ascii?Q?rupZT8z3bvUcNj5PbK+mnbudZZnaEN+cHZdp0BqA3q0z+fnh+QVIVp3UmONk?=
 =?us-ascii?Q?MFAE4FZ+pzPV76kA3Z+fmyTS9or7K6uy8zE/1rNiPAVu3cgTUWL/pq6zYhgQ?=
 =?us-ascii?Q?5wEZ6ILnl46Lb2yENBaEner5Cy6LoD+ioybH26XprgXsuqPuJJHVo9QJBndu?=
 =?us-ascii?Q?lvMJ96nyUTuD8uUQuMP2ZAketGNB2t5LD8RMQL/oIzykWcJ2J0B2GCesS7fM?=
 =?us-ascii?Q?85e443IWB8zrp+eIzunZb7rKwiJoUkOhAUS79ZoR7l4+Idc1YS720YPVgUOd?=
 =?us-ascii?Q?9yEuXbMBFtX7D9ZXEswmdpDyIt7sgN0O5dniinh7/aUxnW7HLv0iVmsnIT65?=
 =?us-ascii?Q?3M28IXjvpMIVlXxK7FqIwS07qcd4DweSJM82g97d1sm57o9q3wgjgIj3Xw61?=
 =?us-ascii?Q?0FFq9Xt7axlJXE9/v1VSUSshyGTH0dllh7zT8tIDz9B+gsaDEIufwc06juds?=
 =?us-ascii?Q?1P55U6rdiDc7NCpb7XzjrBay3i+RNqm195ForKhcuHpKMvjP+dI60Ffoo1XB?=
 =?us-ascii?Q?3KxbV9HBuvpeyVDwdI65yfU9pFfPnad866E1kPat/1Wl7svMgNmHGdA3ZKR0?=
 =?us-ascii?Q?qAHZB3p+lhvS6TIiJ0vmr9WoVTuj5y+dMHc8biL62TpCbOWO4bZwk9w1ejEW?=
 =?us-ascii?Q?EdOpNGTCNPZZ3HzvjhpCPRmeJmIw6AFXbdYVB4Bj8JZshw8tKrz91fBVOBm4?=
 =?us-ascii?Q?7No=3D?=
Content-Type: multipart/mixed;
        boundary="_002_BL1PR12MB5144F36AF9DB901EA963487AF7EF9BL1PR12MB5144namp_"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76b67809-68d2-4bb0-7e39-08d955d273a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 16:27:41.9917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BxqnSoBUcplhs9CuBoe/7W9qxDDijJR5kj1Caj3y4h8HDR0D6WLWYSfjs5H6T+4SJihegGvHKaTw5bWGf/4nWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5126
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_BL1PR12MB5144F36AF9DB901EA963487AF7EF9BL1PR12MB5144namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

[Public]

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Monday, July 26, 2021 5:02 AM
> To: Wang, Chao-kai (Stylon) <Stylon.Wang@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] drm/amd/display: Fix ASSR regression on
> embedded panels" failed to apply to 5.13-stable tree
>=20
>=20
> The patch below does not apply to the 5.13-stable tree.
> If someone wants it applied there, or to any other stable or longterm tre=
e,
> then please email the backport, including the original git commit id to
> <stable@vger.kernel.org>.

Hi Greg, please use the attached backported patch.

Thanks,

Alex

>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 6be50f5d83adc9541de3d5be26e968182b5ac150 Mon Sep 17 00:00:00
> 2001
> From: Stylon Wang <stylon.wang@amd.com>
> Date: Wed, 21 Jul 2021 12:25:24 +0800
> Subject: [PATCH] drm/amd/display: Fix ASSR regression on embedded
> panels
>=20
> [Why]
> Regression found in some embedded panels traces back to the earliest
> upstreamed ASSR patch. The changed code flow are causing problems with
> some panels.
>=20
> [How]
> - Change ASSR enabling code while preserving original code flow
>   as much as possible
> - Simplify the code on guarding with internal display flag
>=20
> Bug:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbugz
> illa.kernel.org%2Fshow_bug.cgi%3Fid%3D213779&amp;data=3D04%7C01%7Cal
> exander.deucher%40amd.com%7Ce32d71d4386e4ae8ec0808d950148f5e%7C
> 3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637628871500920897%7
> CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJ
> BTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3Dwsm8GZ9dxUHah8az
> u3uC%2B%2BeLu5wQiQuVhzwQOqZCnMQ%3D&amp;reserved=3D0
> Bug:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla
> b.freedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F1620&amp;data=3D04%7C01%7Calexander.deucher%40amd.com
> %7Ce32d71d4386e4ae8ec0808d950148f5e%7C3dd8961fe4884e608e11a82d99
> 4e183d%7C0%7C0%7C637628871500920897%7CUnknown%7CTWFpbGZsb3d8
> eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> D%7C1000&amp;sdata=3DD6bXgLCoPAVutKRagSPfPWw1FTUjY5fa5qSqm38nN
> QM%3D&amp;reserved=3D0
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Stylon Wang <stylon.wang@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
>=20
> diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
> b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
> index 12066f5a53fc..9fb8c46dc606 100644
> --- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
> +++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
> @@ -1820,8 +1820,7 @@ bool perform_link_training_with_retries(
>  					 */
>  					panel_mode =3D
> DP_PANEL_MODE_DEFAULT;
>  				}
> -			} else
> -				panel_mode =3D DP_PANEL_MODE_DEFAULT;
> +			}
>  		}
>  #endif
>=20
> @@ -4650,7 +4649,10 @@ enum dp_panel_mode
> dp_get_panel_mode(struct dc_link *link)
>  		}
>  	}
>=20
> -	if (link->dpcd_caps.panel_mode_edp) {
> +	if (link->dpcd_caps.panel_mode_edp &&
> +		(link->connector_signal =3D=3D SIGNAL_TYPE_EDP ||
> +		 (link->connector_signal =3D=3D SIGNAL_TYPE_DISPLAY_PORT &&
> +		  link->is_internal_display))) {
>  		return DP_PANEL_MODE_EDP;
>  	}
>=20

--_002_BL1PR12MB5144F36AF9DB901EA963487AF7EF9BL1PR12MB5144namp_
Content-Type: application/octet-stream;
	name="0001-drm-amd-display-Fix-ASSR-regression-on-embedded-pane.patch"
Content-Description:
 0001-drm-amd-display-Fix-ASSR-regression-on-embedded-pane.patch
Content-Disposition: attachment;
	filename="0001-drm-amd-display-Fix-ASSR-regression-on-embedded-pane.patch";
	size=1560; creation-date="Mon, 02 Aug 2021 16:25:35 GMT";
	modification-date="Mon, 02 Aug 2021 16:24:33 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmYmQzM2ExNTBhM2Q0NjlmMzRmZjdjZWY4MmNiZGQ5YzQ0ODRmZjFlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdHlsb24gV2FuZyA8c3R5bG9uLndhbmdAYW1kLmNvbT4KRGF0
ZTogV2VkLCAyMSBKdWwgMjAyMSAxMjoyNToyNCArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGRybS9h
bWQvZGlzcGxheTogRml4IEFTU1IgcmVncmVzc2lvbiBvbiBlbWJlZGRlZCBwYW5lbHMKCltXaHld
ClJlZ3Jlc3Npb24gZm91bmQgaW4gc29tZSBlbWJlZGRlZCBwYW5lbHMgdHJhY2VzIGJhY2sgdG8g
dGhlIGVhcmxpZXN0CnVwc3RyZWFtZWQgQVNTUiBwYXRjaC4gVGhlIGNoYW5nZWQgY29kZSBmbG93
IGFyZSBjYXVzaW5nIHByb2JsZW1zCndpdGggc29tZSBwYW5lbHMuCgpbSG93XQotIENoYW5nZSBB
U1NSIGVuYWJsaW5nIGNvZGUgd2hpbGUgcHJlc2VydmluZyBvcmlnaW5hbCBjb2RlIGZsb3cKICBh
cyBtdWNoIGFzIHBvc3NpYmxlCi0gU2ltcGxpZnkgdGhlIGNvZGUgb24gZ3VhcmRpbmcgd2l0aCBp
bnRlcm5hbCBkaXNwbGF5IGZsYWcKCkJ1ZzogaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3No
b3dfYnVnLmNnaT9pZD0yMTM3NzkKQnVnOiBodHRwczovL2dpdGxhYi5mcmVlZGVza3RvcC5vcmcv
ZHJtL2FtZC8tL2lzc3Vlcy8xNjIwClJldmlld2VkLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRl
ci5kZXVjaGVyQGFtZC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0eWxvbiBXYW5nIDxzdHlsb24ud2Fu
Z0BhbWQuY29tPgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVy
QGFtZC5jb20+CkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCihjaGVycnkgcGlja2VkIGZyb20g
Y29tbWl0IDZiZTUwZjVkODNhZGM5NTQxZGUzZDViZTI2ZTk2ODE4MmI1YWMxNTApCi0tLQogZHJp
dmVycy9ncHUvZHJtL2FtZC9kaXNwbGF5L2RjL2NvcmUvZGNfbGlua19kcC5jIHwgMyAtLS0KIDEg
ZmlsZSBjaGFuZ2VkLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2Ry
bS9hbWQvZGlzcGxheS9kYy9jb3JlL2RjX2xpbmtfZHAuYyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQv
ZGlzcGxheS9kYy9jb3JlL2RjX2xpbmtfZHAuYwppbmRleCBhZTY4MzBmZjFjZjcuLjc3NGU4MjVl
NWFhYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9kaXNwbGF5L2RjL2NvcmUvZGNf
bGlua19kcC5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvZGlzcGxheS9kYy9jb3JlL2RjX2xp
bmtfZHAuYwpAQCAtMTY3NSw5ICsxNjc1LDYgQEAgc3RhdGljIGVudW0gZHBfcGFuZWxfbW9kZSB0
cnlfZW5hYmxlX2Fzc3Ioc3RydWN0IGRjX3N0cmVhbV9zdGF0ZSAqc3RyZWFtKQogCX0gZWxzZQog
CQlwYW5lbF9tb2RlID0gRFBfUEFORUxfTU9ERV9ERUZBVUxUOwogCi0jZWxzZQotCS8qIHR1cm4g
b2ZmIEFTU1IgaWYgdGhlIGltcGxlbWVudGF0aW9uIGlzIG5vdCBjb21waWxlZCBpbiAqLwotCXBh
bmVsX21vZGUgPSBEUF9QQU5FTF9NT0RFX0RFRkFVTFQ7CiAjZW5kaWYKIAlyZXR1cm4gcGFuZWxf
bW9kZTsKIH0KLS0gCjIuMzEuMQoK

--_002_BL1PR12MB5144F36AF9DB901EA963487AF7EF9BL1PR12MB5144namp_--
