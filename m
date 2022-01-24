Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E674996A0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376400AbiAXVFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:17 -0500
Received: from mail-mw2nam08on2075.outbound.protection.outlook.com ([40.107.101.75]:55966
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1444473AbiAXVBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 16:01:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCGVEZ+Oeo1nrnHWgszdjj2FoQR5Gu7gv/ym9+cxP7MGkCvvG++FXw89r8WUPmLcUWObUZ9ug0gz2if+ESPYrQ4D41TguSoJAuQIgVvyQ1BzfB6HDCotS7syH5iVFZ6hdf7OLtjEn/gG6INYXeKQ5WrVIcoLWg3h7vy6UFlcu1q4l4uZgGXeq4zTte8gxVFJ+P3+cUGkOWq4D7RuqKIwB4XWlu0y1rcp+Dv7Tf9Ih6rpz90eYpb5r6r/ehO4bQt4SZ7xohk9OQMtrs3oCknVyCm4W2lx7eOYHFdjFfRHfjMTq5v+hdGBMU/TJO1S08R5AfmwZ4R9yuA28VanlvkvYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oWixpKdwDwzkaCC1y28vBT8hlFKJJSHp563EoOuyHSM=;
 b=gLSVBpw5vrOlhzvsLmWT72+jCtyh6+vojTmJ7A30/qSQPv8CCJrVZeMSoB4xPey2OhpeipmJQIAcK8lWJeENXSr4J6oEOEBmOErcCPOJgbPViNDTaFKazi8Npv3HrgnqP6cR/WAAy/0hewQGoFRNYmVdxWaCli75G+C1iG+VvoL1OIAF471vwBKWrxzCHIjGwpM8kFdvMbaIKWZ47XXZFJA0UxQh3haFcxXzwqksOL1SHPsiTzf2cTTsrpUepp///nzLizC7mlkIpFEHhK/wC/oz3198Ssixs8g6KZmGOEpKPtYL4xzdDsc5P1vFgL7uuskWwvofsMsjEgVnbbeM9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWixpKdwDwzkaCC1y28vBT8hlFKJJSHp563EoOuyHSM=;
 b=DcPGjySCFIN1y7tuO4/4VuLwGEVU49jTWHy/5Vs0K5LXTwl4ZaGVtRszSDV0riCmHnDBDVdTwKf2HgHHMZNmWg6sFCd69MS3rBkEFNTE3YoAxlF2BwRuYaKGqCY5T4PQf2llwich1ZITUgWtdJHEMorkJNCeZi+7OeSizqGr9Ns=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BN6PR12MB1940.namprd12.prod.outlook.com (2603:10b6:404:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Mon, 24 Jan
 2022 21:00:58 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 21:00:58 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hdegoede@redhat.com" <hdegoede@redhat.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] platform/x86: amd-pmc: only use callbacks
 for suspend" failed to apply to 5.16-stable tree
Thread-Topic: FAILED: patch "[PATCH] platform/x86: amd-pmc: only use callbacks
 for suspend" failed to apply to 5.16-stable tree
Thread-Index: AQHYEGOYSgAT0O/wlUKzjVEkNCMwu6xyp+eQ
Date:   Mon, 24 Jan 2022 21:00:58 +0000
Message-ID: <BL1PR12MB5157E901F4A7C12C6944E168E25E9@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <1642947284246237@kroah.com>
In-Reply-To: <1642947284246237@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-24T21:00:32Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=54517727-c24c-4b62-a15e-383fb9d8dcf9;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-24T21:00:56Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: e2ab9eb1-873b-4d60-9d10-997431b34a95
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a710efa-246c-4838-cdeb-08d9df7c9edb
x-ms-traffictypediagnostic: BN6PR12MB1940:EE_
x-microsoft-antispam-prvs: <BN6PR12MB19406A564BB2D1D4C5C8D195E25E9@BN6PR12MB1940.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: biiphlp7dz31A5odnnwHsumKGljMfmLFf6B1gcsREkP+Fs7pEM08yFkf7bMFPRSEkG5yioVML3w6pDh2QULSbMdcdzQO6wdvWOm7+gzovgOYoipDN5i5jHPZziHK1D2R4r6PpsBlEQ4Dr0iO9lF8gdv0Xru5PB5cXBXI4rvoqrHxxeSl/YIc8MEy4rCw6NjBHgGoCi/0eCJtAGu+DIwZMnMYXXmBTc8Cdz2qbkpkYEerlpezNA084O2KAmRcrJmxBS29vka2Jms1pZFAm00Y8ATcum/g5jO5ytTznBEP49iu5Yo695zUM1oCb9yvATB+pBiTyJzEyQrG0XbPxjEfm3LrgT5mr+9aEpTDrhlTLZqV2HU7mRX1GdiVl2VHNm+/n7EKl+7JvoYesWr+acw2dWco71jn4z1jYD6JUt0+109NoO+okTVVrxSW8gXC0kx54i1SoO9s+kaMOGFHCkOhYbcE8u4xHmL58sxHP47c30FrcY1zyyJv33Gadx1WjHNRuRv1Yd0cuQ6MGqCebfsMgja+PUCHCj2w36hcCb6aDFjDqihpMGb8HutSfpo2rlwqriI+0j7mjjtnUKE6GBXvvrHMlrzT0onhGDMMM56+3txPPjXKvLKMJmNMFh7MXUKc5w4D9DXK5L+WDqpcr0ZjIr0PEyssf1n4dwIgJlrD+qtWjTvQEIvr0i48Z9gAUkv1GFxm/bGABbnIaVDLK/IatkqG/1J3zoQ0r3bmG2odbWhRWv4DR3XhoRRXdRT36H1LqrlXwNrZI/D2twdXYdhdhALZ/7oVbfQbsLuLlsEYEwU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(86362001)(2906002)(64756008)(110136005)(66476007)(7696005)(9686003)(8936002)(45080400002)(966005)(52536014)(15650500001)(38070700005)(6506007)(53546011)(186003)(316002)(76116006)(38100700002)(5660300002)(122000001)(55016003)(33656002)(508600001)(4326008)(83380400001)(66446008)(66556008)(8676002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4KhdZx6Ng/2xedIBId9d0E21OKxAnoTHyLeJVgHwPET81aCybj9qEm7PKA2P?=
 =?us-ascii?Q?1gfeiSrbK+irjVK62nu9JpjbgTJYTFoOfG9vgEaL+IXDlnufPy6PUofX/kQ9?=
 =?us-ascii?Q?0udPvo+6U6BWviyLekGvCM3tEfboE2FdVEZ/j0PUYJFvAO3GaxPw+LX4Zun3?=
 =?us-ascii?Q?d6ourIzo18T2UFPfRjUCiq0K126+OdTtziF4qeU7GgbuRfSitbDTHeJf1ZsT?=
 =?us-ascii?Q?+9eAbfmInkZcbOoBqI/d7/LnKWmcfLgiWHmSj4fWdp4rZyOd811AZl7bNKa9?=
 =?us-ascii?Q?L8w7KCyYJPSyh5BlpC7ij4X68/MKw6SVk0dYNnQQPROzZm8pfG/loVmAu2PA?=
 =?us-ascii?Q?Sj+onw7uArASXo2uji+5WowAIjMqPut86xB9rVYKp2rxFWI1rWzQHRVWlo14?=
 =?us-ascii?Q?31CGviXDYFms1UGYxAwCy3lBn3upSanGZ4ZX22t7RJqHqd2/PMKzMSUxi9k7?=
 =?us-ascii?Q?0cS1k7QQUbQAlRy4AGO0PVJGAJKBlj9m9v3BQurLqRabejy/gn+M9XRun31h?=
 =?us-ascii?Q?guQWBu+6GZmlThWNLMw50MfbmGsWCeIAGp2//ZrXvDAjhAdWBLI9JHLvZcxi?=
 =?us-ascii?Q?LLGtdzNcKweedGVWphv+xkOV1x9vqv/UGUZl/hMe1Te/a8J5HA+9ik8ccfh8?=
 =?us-ascii?Q?AAbD1QyCO3sD0ewN7gXIqZdXVHm5StKB/TVuNI/rvPGtQg69u2SP1yO06jzC?=
 =?us-ascii?Q?VxWa77jbuCBVlD90xSxTh3wZD6cY5BgQpkRl+Kr7FjFpXhp8iYRC7XF+5zj0?=
 =?us-ascii?Q?Yv2YZxebc5+rH1/RdsqFbIW4Viqs0gxailBZC28n2/mrSYNOTwR9LvvP8V82?=
 =?us-ascii?Q?zx/kjp8bHSBeNod/RLw4Y6tob8UG4eYOWAH9ofHNpEw1+ZxecnbbVQkSg57k?=
 =?us-ascii?Q?kkdS/EJzc5GUw5ZLDDiR0YBSoB81xtAYONkY1yWLqbFTz36uIyP3bHey1FrY?=
 =?us-ascii?Q?ymJ+tOhp9+z1O5C5NVQr0b1EGUf64SDOvQatfA7nb7BmUtRbeM4UvN4rA5BT?=
 =?us-ascii?Q?ZjKrI7N8YdMI3Z8fVNzt4vPTimVZLDbeDZkf9d7a3SFz4cFwlf6XBUkWHz1U?=
 =?us-ascii?Q?9GDtf3+Thr/44ytyZmvWScXOYuEHDhWGABMS8MsiAOIC9QF3f2evgzbroQFU?=
 =?us-ascii?Q?Dhzx39ZTUfGy/ZTIMv2hoGESWQdNfF1oIShqwOUIy9/sL31Agma915lOqjwQ?=
 =?us-ascii?Q?C/tn7KY1efOX/EePUyELMGkByudJkMoinr4jn/tw3uq7EXIsQVVvR3Us5S/P?=
 =?us-ascii?Q?mVfk804k26kle1PAuRKmrG+j/ygpO4C/yIDJJoUQkcZhAuVdKX5QRIazrDAf?=
 =?us-ascii?Q?agDceX7lK3GDVa9izzzlmaLZjCaCYoLTynt5HP/77YSINZ+CFvmIyjrQQ//B?=
 =?us-ascii?Q?pya+83ME9MBH+gBuTtUfCaI+3z3SQD0velRduPf4wUH2WdpokCYfpIrjQZOG?=
 =?us-ascii?Q?+h/CFFCOqz0wN8AGF15VpqAP4HGHnIUT3RK2XAbYajwNRURUDHC1uM9hm83c?=
 =?us-ascii?Q?xjyZzQasLx0PYDF9FgbbqerMOsq7TxxcXg5KbOKPTOkz12ywCmj8GXAAnD8D?=
 =?us-ascii?Q?r/fbDrI5PpCZr1Z06XJL22kWoZpsSyH5gDP/zuiSelUfgfzzl1KbUYb8GiB4?=
 =?us-ascii?Q?eGfnICtrtJMjdp9ehM8TGOR6A8iAID85QGIpMfkEZo9TCrLpGQjOSJds3sFb?=
 =?us-ascii?Q?ItTp7yBGmcLXumEdew/u3FwJznw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a710efa-246c-4838-cdeb-08d9df7c9edb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 21:00:58.2842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5qsz60xX2TdjTveVUr++YGO25K9Z5aklgBBzwXjrqUk9LAVsC5viS+7WfOARnL0/ar89y88MHJTNq7D0k7m9KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1940
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

It looks to me that this was already applied for both 5.15.y and 5.16.y, so=
 that's why it won't be able to apply again, no concerns.

$ git log --oneline stable/linux-5.16.y drivers/platform/x86/amd-pmc.c | gr=
ep "only use callbacks for suspend"
09fc14061f3e platform/x86: amd-pmc: only use callbacks for suspend
$ git log --oneline stable/linux-5.15.y drivers/platform/x86/amd-pmc.c | gr=
ep "only use callbacks for suspend"
a42c41be8324 platform/x86: amd-pmc: only use callbacks for suspend

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Sunday, January 23, 2022 08:15
> To: Limonciello, Mario <Mario.Limonciello@amd.com>; hdegoede@redhat.com
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] platform/x86: amd-pmc: only use callbacks=
 for
> suspend" failed to apply to 5.16-stable tree
>=20
>=20
> The patch below does not apply to the 5.16-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From d386f7ef9f410266bc1f364ad6a11cb28dae09a8 Mon Sep 17 00:00:00 2001
> From: Mario Limonciello <mario.limonciello@amd.com>
> Date: Fri, 10 Dec 2021 08:35:29 -0600
> Subject: [PATCH] platform/x86: amd-pmc: only use callbacks for suspend
>=20
> This driver is intended to be used exclusively for suspend to idle
> so callbacks to send OS_HINT during hibernate and S5 will set OS_HINT
> at the wrong time leading to an undefined behavior.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Link:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.=
ker
> nel.org%2Fr%2F20211210143529.10594-1-
> mario.limonciello%40amd.com&amp;data=3D04%7C01%7Cmario.limonciello%40a
> md.com%7Cec1064b7e16b4b48609208d9de7ab928%7C3dd8961fe4884e608e11
> a82d994e183d%7C0%7C0%7C637785440946508125%7CUnknown%7CTWFpbGZ
> sb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0
> %3D%7C3000&amp;sdata=3DWbi1ZGIBtIaQAmTiYhLNSb%2BtnHQG93PkLtG2OPN
> NR%2Bg%3D&amp;reserved=3D0
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>=20
> diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pm=
c.c
> index c709ff993e8b..f794343d6aaa 100644
> --- a/drivers/platform/x86/amd-pmc.c
> +++ b/drivers/platform/x86/amd-pmc.c
> @@ -585,7 +585,8 @@ static int __maybe_unused amd_pmc_resume(struct
> device *dev)
>  }
>=20
>  static const struct dev_pm_ops amd_pmc_pm_ops =3D {
> -	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(amd_pmc_suspend,
> amd_pmc_resume)
> +	.suspend_noirq =3D amd_pmc_suspend,
> +	.resume_noirq =3D amd_pmc_resume,
>  };
>=20
>  static const struct pci_device_id pmc_pci_ids[] =3D {
