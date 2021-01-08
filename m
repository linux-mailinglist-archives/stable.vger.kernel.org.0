Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE29B2EED47
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 06:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbhAHFt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 00:49:56 -0500
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:5312
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725844AbhAHFt4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 00:49:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbqhmFMakf844J/ysjxUxTW3xhbAfPEJKOWScFuq5RUwHFCuINoO+dBlMYInbq3CmT4RkeNgYqOpV3oFkzNVp7wNQA6mUAJfGwa/VpfCEkCxCT0QfcU+AZoSig3+i66V3S2xCloMlkODB7Y8lSrXlU+usK5loaaPlWf83wJ9oHE9aZHjlJoXO6UMTVFXSgqmeUtg7pIk545rH2AqowtKJjRACcXuzaHtA0Cr0RsyNaH+1PqLnPoySunQOpzNwAqEerhg6BBa9+kWnUBQyooTzo4T4iUpxXD/MQGE+U2TfiyxV8sqEURNBbsRZo7jAmnu4DGOw6zf/6LRNQeY+RO7GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xcleXbDGsR7WUTislfp+brWYCR/8Ir+gpVQE0qIx80=;
 b=RO8UB0jwZTAPlQeemQ4q9KjwmRbsx+Uvw8LazlQb6fOIan5sDR+ohFwrrs/rQXAx3SRlIlohUH7lzM3rDnkAr9ZCtldKVqaApW3m7cPGmNzfba5d8ZU5o4tp4+NwkygZeMWK7xE2pbKJEoS+3IUza7o5R6lpbAZhQOEIqr0RSazL50zThf7lZTUy6V8At4lTf5hWwreLOX5p/vkFSXJ0IdsdEUawW7/o5vAMONuYgx17f8gM8TyGLnn4Eoa+rb0/Io5+8WlucYQ/Q5NyCJteVBtYek9fZogwdeA6NWvHZcf3ffIAMhXWsR8YwDhC4TRkxrJ2xr59sh6vtRYfc12edQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xcleXbDGsR7WUTislfp+brWYCR/8Ir+gpVQE0qIx80=;
 b=jF9OlIOEesm7+63PmoAyIA5XuMZ1DRXAAOfYFMdp3z5V/jM/nr6MA4dIMtFOYHlpq3sEoJN+o7QLvnkxLlwpiUnd/Sbt5fHCeAIotMSYA73zPYjfL2aUQUI9bjYfDjqp1uh8nShHw7yInPq83K2R2GOvamJON0eTMKlIUBTS+KU=
Received: from DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10)
 by DM5PR12MB1833.namprd12.prod.outlook.com (2603:10b6:3:111::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 05:49:03 +0000
Received: from DM6PR12MB4388.namprd12.prod.outlook.com
 ([fe80::84e9:dd44:12cf:bdb3]) by DM6PR12MB4388.namprd12.prod.outlook.com
 ([fe80::84e9:dd44:12cf:bdb3%6]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 05:49:03 +0000
From:   "Chatradhi, Naveen Krishna" <NaveenKrishna.Chatradhi@amd.com>
To:     David Arcari <darcari@redhat.com>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>
CC:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] hwmon: (amd_energy) fix allocation of hwmon_channel_info
 config
Thread-Topic: [PATCH] hwmon: (amd_energy) fix allocation of hwmon_channel_info
 config
Thread-Index: AQHW5QQZdSyCjckTx0WGIHiGz4uxF6odMEOA
Date:   Fri, 8 Jan 2021 05:49:03 +0000
Message-ID: <DM6PR12MB4388220A9F55F5DDC984B91FE8AE0@DM6PR12MB4388.namprd12.prod.outlook.com>
References: <20210107144707.6927-1-darcari@redhat.com>
In-Reply-To: <20210107144707.6927-1-darcari@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_Enabled=true;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_SetDate=2021-01-08T05:48:07Z;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_Method=Privileged;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_Name=Internal Use Only -
 Restricted;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_ActionId=fa637c64-fb07-47e6-b07b-000052bed65a;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_ContentBits=1
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_enabled: true
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_setdate: 2021-01-08T05:48:59Z
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_method: Privileged
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_name: Internal Use Only -
 Restricted
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_actionid: 18486720-8e3c-4f38-a78a-0000883627e9
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_contentbits: 0
dlp-product: dlpe-windows
dlp-version: 11.5.0.60
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [175.101.104.147]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 30c39e59-f83c-4e26-8332-08d8b3991ab3
x-ms-traffictypediagnostic: DM5PR12MB1833:
x-microsoft-antispam-prvs: <DM5PR12MB1833826426878B732C1D1499E8AE0@DM5PR12MB1833.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QuovBIt3pMtuMbuUSp8tQZ1djdFJecodZKhwwPY7Znh+bEpZtRbIJ3nCyqHHTqSrTLJcnKVaRwLoviFoaaDiq43daNGcHNBHH2/7XMOrJSC5HWLpV1cDsS2PzbUQwaJRfHMzyW5lmgKwJ5ojeOp1IV9j2PnVoiUtbKDjvhXOYtf+z6iqiECV6Rhadfy+xq5kdKYJM/MMFYdVtJH5olXhCGf5+2jgXH3j8kX2nUZ1+BhqQaM2JyeSf12d0Q9K+8o3QLSL0tGCXJphX9UhgGvWVjNydS5wN6Z1TRXcdrB8wnI65Ii3fJ/0QwFsQMaAWMxtKu2JA4d40LPmPB8/6yUCZppkl24bt8mr5cimOX4hT1IOdpEhtIxjqsMVULyp8JTj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4388.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(26005)(83380400001)(86362001)(6506007)(55016002)(4326008)(186003)(9686003)(7696005)(8676002)(66556008)(54906003)(8936002)(53546011)(110136005)(316002)(33656002)(66946007)(478600001)(5660300002)(76116006)(66446008)(66476007)(52536014)(71200400001)(64756008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CTPRpXYVMR4M670j+lMAkqeqJR+LEqDI3JzeUuoq6O+l5dXmbObqESK1eT9R?=
 =?us-ascii?Q?a6Di7GrcVgTAvRjgcT2E0lSSFADR8S18FnsNAWvuGpEuiS7ctJKlwIIFBEVK?=
 =?us-ascii?Q?MNpPxhjA0Vf3h2T/1BFVg7ZcVL+kup9P24A6Nt6jrbey2NE9jnWmuUcdY1xR?=
 =?us-ascii?Q?6vXXxCR2gfbMR9f5wJiGXKn67AUHnPa3Kmzbhoce5CLPqeyFRr8U++icfDzh?=
 =?us-ascii?Q?WgsT4a6/7gXf4scRwGhvAG287JV94vLRwCOsQe83Q/osXjglizzZxjZahBQd?=
 =?us-ascii?Q?uXWiBEwZEPwybtOcDUlPGaIytm6708WHLBzLkovsltaLHihDBHGvTdXVUEIm?=
 =?us-ascii?Q?BOQ4OBL02k6pMtHZJSL5e1MwfThW5C1YoUm0fy6nxabhYgFNxzHA0QAQI+Tc?=
 =?us-ascii?Q?2cYMPdGtiSkH1zH80ErElz3JVA/ddSbIa4GX6tMaDeV8jmx3LVBJHK5N5K/G?=
 =?us-ascii?Q?MnSAC0Tf5oRFHoNZ1+zJd3TeAOZO9TfTG6Rl1w4D+n6AgMluQKKG0kRpWcL0?=
 =?us-ascii?Q?MBliTMqR+B127IRKB7QCwti1YRX4aim9RBxFXHoACAhRfiGbiRjnKH/HVBCY?=
 =?us-ascii?Q?tnTDoqmyiuJc0tbH/8EeRKeOJDGheNGZ4kLzKJUnOIDWFUf2tz/kmi6yXi0u?=
 =?us-ascii?Q?8/EctCUC+73MAqegdaAoTIj8+4nF9K6YQkXcU4RpgxI3qEAjuNwLw8vVK4Gn?=
 =?us-ascii?Q?cCSdqBjcfx1dIqwrLIwt7Cfh3XuiykVNKFv6Dnk/bP6ABX39zIN6RhZpuFNQ?=
 =?us-ascii?Q?s+XuiDvAmBO5s7cjyUlRGRt4BoQWiYVCXz+ZVYhHE64C+fqwk7P6s6fUzq2n?=
 =?us-ascii?Q?O+UAelU4DYaqBn98pBJdLA2b7GNkulT0WShrvybKOLkpclv+vXw9Y3TH8tJZ?=
 =?us-ascii?Q?hXlAlEDCBqS4Dac8BOXIWPb7YbiH7L37jvNAORbQCI7xHO3i3heT2sDCq3eN?=
 =?us-ascii?Q?43EJRJnL4VZwRs1WmgiBs4Fc01nT+DrWNf2oQ/KT+m4=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4388.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c39e59-f83c-4e26-8332-08d8b3991ab3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2021 05:49:03.1090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbG+x4IxTzS8QiIML4FoziEUW6Np4mxRKLvRxUvq8mxwHyArI1oCSoA6wlMGX9jh9kVxWUzdOdivWzOaQ8cVqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1833
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only - Approved for External Use]

Hi David,

Thank you for noticing and submitting a fix. You may use
Signed-off-by: Naveen Krishna Chatradhi <nchatrad@amd.com>

Regards,
Naveenk

-----Original Message-----
From: David Arcari <darcari@redhat.com>=20
Sent: Thursday, January 7, 2021 8:17 PM
To: linux-hwmon@vger.kernel.org
Cc: David Arcari <darcari@redhat.com>; Chatradhi, Naveen Krishna <NaveenKri=
shna.Chatradhi@amd.com>; Jean Delvare <jdelvare@suse.com>; Guenter Roeck <l=
inux@roeck-us.net>; linux-kernel@vger.kernel.org; stable@vger.kernel.org
Subject: [PATCH] hwmon: (amd_energy) fix allocation of hwmon_channel_info c=
onfig

[CAUTION: External Email]

hwmon, specifically hwmon_num_channel_attrs, expects the config array in th=
e hwmon_channel_info structure to be terminated by a zero entry.  amd_energ=
y does not honor this convention.  As result, a KASAN warning is possible. =
 Fix this by adding an additional entry and setting it to zero.

Fixes: 8abee9566b7e ("hwmon: Add amd_energy driver to report energy counter=
s")

Signed-off-by: David Arcari <darcari@redhat.com>
Cc: Naveen Krishna Chatradhi <nchatrad@amd.com>
[naveenk:] Signed-off-by: Naveen Krishna Chatradhi <nchatrad@amd.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 drivers/hwmon/amd_energy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/amd_energy.c b/drivers/hwmon/amd_energy.c index =
9b306448b7a0..822c2e74b98d 100644
--- a/drivers/hwmon/amd_energy.c
+++ b/drivers/hwmon/amd_energy.c
@@ -222,7 +222,7 @@ static int amd_create_sensor(struct device *dev,
         */
        cpus =3D num_present_cpus() / num_siblings;

-       s_config =3D devm_kcalloc(dev, cpus + sockets,
+       s_config =3D devm_kcalloc(dev, cpus + sockets + 1,
                                sizeof(u32), GFP_KERNEL);
        if (!s_config)
                return -ENOMEM;
@@ -254,6 +254,7 @@ static int amd_create_sensor(struct device *dev,
                        scnprintf(label_l[i], 10, "Esocket%u", (i - cpus));
        }

+       s_config[i] =3D 0;
        return 0;
 }

--
2.18.1
