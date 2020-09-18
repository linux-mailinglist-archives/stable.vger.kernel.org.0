Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4766F26F691
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 09:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgIRHRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 03:17:14 -0400
Received: from mail-dm6nam10on2057.outbound.protection.outlook.com ([40.107.93.57]:10112
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726435AbgIRHRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 03:17:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/iUQocRgOqu2+s8nd8Ja2ApYbkKZtd1YuTHDbJp333AjL88q29DfXc32QDACd4qi89M6jPlQ136HcktT72VES/r/dc3rXhfZHbb7KndQ3Wt4HdyJ81Rths4yuSitepgfTxbM/po4AxAsebXw6pOrm5L7PwTxuQpdiBY/ZZ6oFZU9p7I1M+sv7EUZuORmtmbobgiALIC+qQBNE2eZ/WIAeW/U+aq4lfIWTUKtseEHktWt2MMQmZyCpk1YK+DUPsCUDoEUsQfu578izrUxQLpkuaJyThlVYCW80coABuxorVYAbh2Y1GLDyf2YZg/b6AwxIA3g9GRXnI5FxaZ5mFMeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99AsseXjS6VNuQufT6MUZ0NvfrQdFCDr9DJrXmruu9w=;
 b=dsjLoleXZOXQxkrV6s4N3QCeYPVki7VFDnUTqyjRtLyLsh0/9dN8+COQwK+n2V7VDMMzbtlsoIf4T+PvvJXPlIYwzMOLqjPKfz6sOr6mu3/h6yME0bOqRoxsjmb10k0P0NG/jJIFngThoyvAgOrWFQXdgm1t3B1plw4hoU+qiWvYRZ2AIExl1NOoqHbFzkVU/ho8CTB6FeFMH3jtJpy/TWY26iSIr76YWw1ABcgamZdAaDn6fqOzqN477a2fuW5AGeYYmM6YNXxVgaa/qNYUl7QjJiYkxROlZQ4ErfhDMwfo0nqvB+Ebq53w0+rdhdp+3MyezCSk7hN3cUwTfyBfyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99AsseXjS6VNuQufT6MUZ0NvfrQdFCDr9DJrXmruu9w=;
 b=IHlj0nQfPzpsSUJjeg3/qrFyb5IlOtgynJyQgubkj1ZWyg8mLVL96t70I6rBrDIqWy5r+czXKKA2BgQeeOxMaZtCxDrJsuq7CfTl03kE9UHjSIbbV4HaD1R9fM258CBRJI9upOBwiB1KCVuYzCLPaxeVdtebfz5FmSWMiC6l6J4=
Received: from DM6PR12MB2619.namprd12.prod.outlook.com (2603:10b6:5:45::18) by
 DM6PR12MB3961.namprd12.prod.outlook.com (2603:10b6:5:1cc::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Fri, 18 Sep 2020 07:17:11 +0000
Received: from DM6PR12MB2619.namprd12.prod.outlook.com
 ([fe80::bcb1:de80:f60c:8118]) by DM6PR12MB2619.namprd12.prod.outlook.com
 ([fe80::bcb1:de80:f60c:8118%5]) with mapi id 15.20.3391.011; Fri, 18 Sep 2020
 07:17:10 +0000
From:   "Quan, Evan" <Evan.Quan@amd.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: RE: [PATCH AUTOSEL 5.4 265/330] drm/amd/powerplay: try to do a
 graceful shutdown on SW CTF
Thread-Topic: [PATCH AUTOSEL 5.4 265/330] drm/amd/powerplay: try to do a
 graceful shutdown on SW CTF
Thread-Index: AQHWjWBYgeFbDdiTCkGrAPBF9dsOp6ltrz2A
Date:   Fri, 18 Sep 2020 07:17:10 +0000
Message-ID: <DM6PR12MB26190E9DD4C2DF9CEEFAD8EFE43F0@DM6PR12MB2619.namprd12.prod.outlook.com>
References: <20200918020110.2063155-1-sashal@kernel.org>
 <20200918020110.2063155-265-sashal@kernel.org>
In-Reply-To: <20200918020110.2063155-265-sashal@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-Mentions: sashal@kernel.org,Alexander.Deucher@amd.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_ActionId=e7eed646-395b-47cc-9b0e-239a505d9931;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_ContentBits=0;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Enabled=true;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Method=Standard;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Name=Internal
 Use Only -
 Unrestricted;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SetDate=2020-09-18T02:39:57Z;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
x-originating-ip: [58.247.170.242]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 82c3b5c3-80f9-4dbc-b405-08d85ba2dc21
x-ms-traffictypediagnostic: DM6PR12MB3961:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB39617D50BE4E8344B0BE906DE43F0@DM6PR12MB3961.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:127;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M+WlIf1fwwi8kDBcUWdTi0HUtSnG0HiPU6aQURaV67UTOc0dP/DzLt/kuaIamtkZ4GgeYis+51x18ltFcnKeNyc0qrXpASSEn4w/NY5u2PSNP0Lg74quxhXIhMW9VNVsqXDelC5XiS0ikv6nWvuyawTPr2wutgRa4WzIpimFUbl9KhXMIY9qWZRK//f6+VXt7LA7QLy8UsxDEJUQrLkPjzVNjoT8KnYgAW0E8OC64ki3V8STB/z2pUPFfRFQk2zw3YcoPMkrr7od7JCarmeLhLbZG8b5OUaUJ1dEw2H+wESsMAQMLy0UrYbAWsHs64w4UMlHEF/C4a4RjdNgtCQ8tQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2619.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(366004)(136003)(110136005)(8676002)(71200400001)(186003)(55016002)(83380400001)(26005)(33656002)(9686003)(2906002)(8936002)(5660300002)(66556008)(66476007)(66946007)(6506007)(53546011)(66446008)(76116006)(478600001)(86362001)(6636002)(52536014)(4326008)(316002)(64756008)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: irHKHgJ/KqaA5bqqJqW3i40+2Z2h0JHsD09O/G75y9fVzeinXNrV4qso8cWgOlZ1oerTQqDK3EeLdhpvyrau4LoJyDdvKudAnV/miakn9iVCCOJSCQpzu+WXoldR/p2V49qbvh9dYC1Ucn33OcEgLd4mKutDd2uo7Yt1ZmRNM0oPmt1SoDFT8mThLRLi+dPbCLEyvJs0XcyMrWZs/bLQHGvFkAYsH8sW6diIUqHuPycwa7lrfX5VPYuq0lk/FkrIByLsWgRr38fzI/fe8rF1V3Emua9cEVZ/obU8wpFCal1ZA/c2UJai10UXwQ3IJ4hkew6Y2DV0pGIJRAr29F5Y3wIWQrTUrOz3ORsD+YcnxEU4DoCagC3Covp9tUjtA25p6uRMhWokgTbjrhfScIpX07nZtWMgUIx/x7MpWyHX0WWbHufP6Tdkc31+4dMJ5Pw1pwX+v+28yQyRz0u8hlyFqyfnwidpMZR8WaT0OjbvjNfyfOU/i4GmqJGRxjoHpfXXwiUP0Fes05ucNRtxkzo5AGPVvZGazRrRw1SwYugN5ia+uP5aoo0YFahmmIq0uXxg56Arknx0XblV3CKtf1NXpirjrCOsYFpGL8z1HgFrPwBAKEubCfCLaoYkjiyvg1nlaYdz8EshQ8xODX6Q9ETSdQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2619.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c3b5c3-80f9-4dbc-b405-08d85ba2dc21
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 07:17:10.7321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1MQZlvAJW1tqTdO4RhaL+wnaGe+5rKAfE6jvsQf1XKnYNHQHmPTYIrLz7IB7RzxN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3961
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only - Internal Distribution Only]

Hi @Sasha Levin @Deucher, Alexander,

The following changes need to be applied also.
Otherwise, you may see unexpected shutdown on stress gpu loading on Vega10.

drm/amd/pm: avoid false alarm due to confusing softwareshutdowntemp setting
drm/amd/pm: correct the thermal alert temperature limit settings
drm/amd/pm: correct Vega20 swctf limit setting
drm/amd/pm: correct Vega12 swctf limit setting
drm/amd/pm: correct Vega10 swctf limit setting

BR
Evan
-----Original Message-----
From: Sasha Levin <sashal@kernel.org>
Sent: Friday, September 18, 2020 10:00 AM
To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
Cc: Quan, Evan <Evan.Quan@amd.com>; Deucher, Alexander <Alexander.Deucher@a=
md.com>; Sasha Levin <sashal@kernel.org>; dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 265/330] drm/amd/powerplay: try to do a gracefu=
l shutdown on SW CTF

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 9495220577416632675959caf122e968469ffd16 ]

Normally this(SW CTF) should not happen. And by doing graceful shutdown we =
can prevent further damage.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/powerplay/hwmgr/smu_helper.c  | 21 +++++++++++++++----
 drivers/gpu/drm/amd/powerplay/smu_v11_0.c     |  7 +++++++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c b/drivers/gpu=
/drm/amd/powerplay/hwmgr/smu_helper.c
index d09690fca4520..414added3d02c 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
@@ -22,6 +22,7 @@
  */

 #include <linux/pci.h>
+#include <linux/reboot.h>

 #include "hwmgr.h"
 #include "pp_debug.h"
@@ -593,12 +594,18 @@ int phm_irq_process(struct amdgpu_device *adev,
 uint32_t src_id =3D entry->src_id;

 if (client_id =3D=3D AMDGPU_IRQ_CLIENTID_LEGACY) {
-if (src_id =3D=3D VISLANDS30_IV_SRCID_CG_TSS_THERMAL_LOW_TO_HIGH)
+if (src_id =3D=3D VISLANDS30_IV_SRCID_CG_TSS_THERMAL_LOW_TO_HIGH) {
 pr_warn("GPU over temperature range detected on PCIe %d:%d.%d!\n",
 PCI_BUS_NUM(adev->pdev->devfn),
 PCI_SLOT(adev->pdev->devfn),
 PCI_FUNC(adev->pdev->devfn));
-else if (src_id =3D=3D VISLANDS30_IV_SRCID_CG_TSS_THERMAL_HIGH_TO_LOW)
+/*
+ * SW CTF just occurred.
+ * Try to do a graceful shutdown to prevent further damage.
+ */
+dev_emerg(adev->dev, "System is going to shutdown due to SW CTF!\n");
+orderly_poweroff(true);
+} else if (src_id =3D=3D VISLANDS30_IV_SRCID_CG_TSS_THERMAL_HIGH_TO_LOW)
 pr_warn("GPU under temperature range detected on PCIe %d:%d.%d!\n",
 PCI_BUS_NUM(adev->pdev->devfn),
 PCI_SLOT(adev->pdev->devfn),
@@ -609,12 +616,18 @@ int phm_irq_process(struct amdgpu_device *adev,
 PCI_SLOT(adev->pdev->devfn),
 PCI_FUNC(adev->pdev->devfn));
 } else if (client_id =3D=3D SOC15_IH_CLIENTID_THM) {
-if (src_id =3D=3D 0)
+if (src_id =3D=3D 0) {
 pr_warn("GPU over temperature range detected on PCIe %d:%d.%d!\n",
 PCI_BUS_NUM(adev->pdev->devfn),
 PCI_SLOT(adev->pdev->devfn),
 PCI_FUNC(adev->pdev->devfn));
-else
+/*
+ * SW CTF just occurred.
+ * Try to do a graceful shutdown to prevent further damage.
+ */
+dev_emerg(adev->dev, "System is going to shutdown due to SW CTF!\n");
+orderly_poweroff(true);
+} else
 pr_warn("GPU under temperature range detected on PCIe %d:%d.%d!\n",
 PCI_BUS_NUM(adev->pdev->devfn),
 PCI_SLOT(adev->pdev->devfn),
diff --git a/drivers/gpu/drm/amd/powerplay/smu_v11_0.c b/drivers/gpu/drm/am=
d/powerplay/smu_v11_0.c
index c4d8c52c6b9ca..6c4405622c9bb 100644
--- a/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
@@ -23,6 +23,7 @@
 #include <linux/firmware.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/reboot.h>

 #include "pp_debug.h"
 #include "amdgpu.h"
@@ -1538,6 +1539,12 @@ static int smu_v11_0_irq_process(struct amdgpu_devic=
e *adev,
 PCI_BUS_NUM(adev->pdev->devfn),
 PCI_SLOT(adev->pdev->devfn),
 PCI_FUNC(adev->pdev->devfn));
+/*
+ * SW CTF just occurred.
+ * Try to do a graceful shutdown to prevent further damage.
+ */
+dev_emerg(adev->dev, "System is going to shutdown due to SW CTF!\n");
+orderly_poweroff(true);
 break;
 case THM_11_0__SRCID__THM_DIG_THERM_H2L:
 pr_warn("GPU under temperature range detected on PCIe %d:%d.%d!\n",
--
2.25.1

