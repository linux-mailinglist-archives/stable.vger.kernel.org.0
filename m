Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D58461A40
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 15:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344730AbhK2Ov3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 09:51:29 -0500
Received: from mail-dm6nam11on2055.outbound.protection.outlook.com ([40.107.223.55]:25601
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234274AbhK2Ot2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 09:49:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1nw8HrQQ5LdxR9rruAwd2uZf5Qc1Nqw9ejYsACvhUA4eczu5mmms4jzI/df+wVB9ItNBkfQTqVMi5aP7pteDIEcdr8gsVD7BjgDM+w01k5Wgvjf+uwB2ny3v6Zwe/kxC7FQTLAv/wDT9tUt6xwiQX9JUs7E7YwfRj1vCiEbYW54MQyCvP2h+YSAAgaRcXveMcX9Zc+JCEzvDaRmS8ZE+CBYCc6rIaPXNnR2ZdELAB8QZgOFCl5FFyp+fjg9RTBocGWwvO3WHWL2H+CAOELds8eUPya0wbNbfEDIlf2xTquxYW3Xc/SqJn3V7A4l68ict7Tn8Z6XxwzOer+6XhpGiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y0f3oVZoGStGG+hp0kn3gdZw8Me/sMQ4W9avSpAJeto=;
 b=oISuRwjvKBXmAkAESIQowdYMYGh2jCrIjcqrOE23kUlg3SWoBDsHij7mP6xlUdhBPtzp4RHHaCYLc3lUG0QUQI1FwiL439W7hOAt5KvVHmRutu2+SugwstH+vmrjSFJbhMWUnkdLNc6mXM6Z0iVPgyCq1yD1RKSrUXNTT0ODm1ESFs+RrGjQv9xfHHB77njw1KB8WeqX+n81Kmrs91mp4noayNq4yrgr1OBCfZRONNPuK5wWRdPNRIYTuUKCYhlvvlQ1NxcLZhporjzRRHPmVzONRmRXs2ugatYXuBFQGU95eb+EiZqVNKUkVafuhwSZDcCw06tym2jVBjlBxLyH5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0f3oVZoGStGG+hp0kn3gdZw8Me/sMQ4W9avSpAJeto=;
 b=zPvOCd9ff7cPxI0YbUHR5gxlOjAyKsrzBWeKxI6wVf288h87WiJ4hwO+32upa0YASiNVfYQ+WMS2PUI4b/eH3ZFJI+YxLyJZnH8MVm3QmQ9M+NYlqDfMP8RMfyXZj/l8pZFV5Jt3XvHbXb0ZRMJgPATMNZqAXgkSq/VAcKQjB1s=
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 14:46:09 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea%6]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 14:46:09 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Shah, Nehal-bakulchandra" <Nehal-bakulchandra.Shah@amd.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 5.15 28/39] ata: libahci: Adjust behavior when
 StorageD3Enable _DSD is set
Thread-Topic: [PATCH AUTOSEL 5.15 28/39] ata: libahci: Adjust behavior when
 StorageD3Enable _DSD is set
Thread-Index: AQHX4m3uCQqkwa+t+Ee513+VqjeqJKwamo7Q
Date:   Mon, 29 Nov 2021 14:46:09 +0000
Message-ID: <SA0PR12MB45107C702F031A7FF2052A2BE2669@SA0PR12MB4510.namprd12.prod.outlook.com>
References: <20211126023156.441292-1-sashal@kernel.org>
 <20211126023156.441292-28-sashal@kernel.org>
In-Reply-To: <20211126023156.441292-28-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ee7f250-f3e0-469e-c8b0-08d9b346fb39
x-ms-traffictypediagnostic: SN6PR12MB2717:
x-microsoft-antispam-prvs: <SN6PR12MB2717002A899CC4FF0F85B1F1E2669@SN6PR12MB2717.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y5xXEcjyDDql9sGdbpGDxKUMzaNLQZ13UWAhoxwHbACY0gCr8qXPaRXRz19PIKUffIGmKd+wRXeEMpX+Nx6V4iV+Wu+sTQwQQ+PWFoVg/169ZPy+O6tDqzp5f5eOQJDZpjabzXWRfsQCjJDrV7kTw92mZMBy28aS2lBSAekXQj1hC8HeksG23RQLmwyunJOvISZZCN36HI1Ka3l5hAUn9XXywZ8P+6YN8DZitTijZcf0jNMotLYsirZ+iH0XYs0Kx2oRsIywcfTPS3M+2SaTcoHqpI0bArb9uLtI7K1eNDCj6OglFGQLsLYy5uXP99255qbr19bi6EWWRtXsIi0JJat9UZ5j7PsLkZUTg2aQEb/P9PGWCDPCkEwfKl3aIMmLEWQn/QV91zFQ9jzXn0dyOUQPB47n7gUCjyP4WWQHWkQS+e1wiEdqpSVfo95MQb5WvrhCSb2oWQI+nRueB4MnBec50D6d5AE1H4DmodfOUvjR6J5e0kKh/lPmYbL5Z2F0/RaJVlqE2ixooXJFUy54IYicr2cgOE3utVqCcWi95LuSr+YqskW9GJTTeBElW7axBzl1/BUJHBqoGlhMf1G9J2imBIT5v6wvs6oQGWgZgN17YLo5WztGVeA02uZjJgc7px+VJ1TloFHAJozu1RDi8Koq5FYnFFrNUuqwM+vcoH8GHBO1y0l6+0rdZcbRdwF/HTIqksixVByytCdhLpPWiLLTCPn7GSwD2zCnkDbAVe4DVjpuTTVCg6QH5CDrWKJK1L+sjXeOAr2D3QZR64uCWC/6NoCAISD4wVevXM7NH5cQdxV9KboseXeOQh9lXnYXvxyC2RSj5YXW5mvTQ5JRFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(66476007)(52536014)(66946007)(76116006)(26005)(66556008)(9686003)(2906002)(45080400002)(33656002)(186003)(38070700005)(55016003)(7696005)(66446008)(64756008)(6506007)(53546011)(38100700002)(122000001)(4326008)(71200400001)(508600001)(316002)(86362001)(110136005)(8936002)(54906003)(8676002)(966005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S8enzK2o0hGOXxg3IpGzV28pISDqDNLSRYL3QvR9IcSBkJEw6YFW7nT408lM?=
 =?us-ascii?Q?XICEkB8hAQfA6SxrEmMCDn+HfRozwEEggu6xH/koOQkFaUH2bgwsAI2i7xf1?=
 =?us-ascii?Q?7tbhFSG6BHf1oW6eZVl+I3bCyiBWrZZTcj9OlpXSlQsMbYN1QOd9rLAfUzPH?=
 =?us-ascii?Q?RXyKg4V+ekuTWKSDTT/8tLbRX0+g3kjHW9fO3n4sVTKp7OdDpSgfaRLvCecp?=
 =?us-ascii?Q?QcULawjQkRkQrFi0K8FDWWJn4j5kAC7xSJd62VkupY82bQzb87majjIsfJCl?=
 =?us-ascii?Q?SaZXKjEBdpsSvQC4MpOfCh5z4iZCDlX1WOQb+Ub0rdjeH43dvajtkYMDpknU?=
 =?us-ascii?Q?3V5aL7fhMxJmXL5T/dg48+Fd/LOQWkUf5o01i8irHpQNrHvd6Vt1z5LxqZE9?=
 =?us-ascii?Q?tpIjuKs+mqB+/tSDRQHzsUxElGXHMXS1M9DKaeL2O4UH2wZelHCO8dwG8b3g?=
 =?us-ascii?Q?1kB0B7FDIO8UbfELEmJ27z/zHBWrIXlSnXYmI2UYZpXpoesNDS2rreBq8DYP?=
 =?us-ascii?Q?oQD+mf98ZnjnMCZ9QHtwdsO0XJWmY8+PZPSoIm1lWaPkhmDpLHH/AOBJaPGN?=
 =?us-ascii?Q?51R25ABrZ5+CXkCgPcsFSV1w7TIOSsKU4g1ddacJyJP5ZYrluEIRzEKMfFow?=
 =?us-ascii?Q?iCV1AExvCtVJZhY8pwmTK5zVNI8YZAhmeWB9tR7o3JGqhYm9Zmh6tQl/JP1U?=
 =?us-ascii?Q?yhs9eNfMzp7q8jN9r5QJwWQjONshExdB2EeXONnjb8jpvj1RIatJULyEwzGp?=
 =?us-ascii?Q?7d2kAwkfHtGe7fIDVE9qWtrpWJC4LVOo9GMEdk9CKI4sDrsOyddNdJL8A7b1?=
 =?us-ascii?Q?WbY7f7hIuuJOmd46rThC8g8f6m2penX1gOnp80N/Rp1zaMB//u59Y5GTedOu?=
 =?us-ascii?Q?Y1pcezGimXF81LshlqVW1o6iy6YxVz0kPdr/KvS92sqvRGxnnfCJpLpwGKk2?=
 =?us-ascii?Q?XCiDefVmUDZ/ShL+pgEKjSvh5pNrrfTiPtqMAtsFBEaSbFkY5lcq4GHKqWJf?=
 =?us-ascii?Q?z5SJOX7ZH4ZviDECcFUdBO5WcSy89JpQdbWYL4Xi1J/rh+Iq6nrrv76yJxrl?=
 =?us-ascii?Q?TKFTsmXcE5TEIgRz0ilILUtStDB6IgUINFMPvx/eIbCmB4/mWlH1TMj3CKv5?=
 =?us-ascii?Q?3esLa2M3n8GPrWh/E02tOBy4UjyMql5vnimA2q2T29UdCaFym6DYJICKhpj8?=
 =?us-ascii?Q?zFKC7tdJW3Oty4Aqwy8LKwyF/32snW/+DRpjItnpBn+Ahrvqu+WfHo8oexH4?=
 =?us-ascii?Q?0V2ROt3Af/+C5fL0epCpM0TBP7feW8Xu56M0nbEHjIc726N+uvdCSEuLMsv2?=
 =?us-ascii?Q?R6y6RkXkNK3XkOTeQUeCaxqaAhBjhtGSazwzOFQU6lO+ZtPwFihtr1NIle5W?=
 =?us-ascii?Q?i9kWaQMNPSc2/v9SQX0dBZAkctvn8K7cJzzFk4m1NwDUiJN/9Iexb/6+j4As?=
 =?us-ascii?Q?aDr3hkVptGx1nX0ssx0NuEBDsx0LJquSClh/05wc6EWfmku6kIs8ninjEk6p?=
 =?us-ascii?Q?Ny0o++szuoJtDQPXnxrhdKMM7maO6QHvRiD3sLlA9+MKt1/hI7WJdXuiaNB3?=
 =?us-ascii?Q?0qKQkbPbSkVT/4s9PxBm3NLbCEH8ThJtgCLxF3wGmg5zuXw++PGwg8XJSdZP?=
 =?us-ascii?Q?Ww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee7f250-f3e0-469e-c8b0-08d9b346fb39
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 14:46:09.2252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BTrvOZlp+xL+Vz1YB6KZE2Axftg0hNT2A1f2lgN3ly3itUmH1DfbJ8LhtOguWj91zd7LpWJkeayDv8RmYYgfOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Thursday, November 25, 2021 20:32
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Limonciello, Mario <Mario.Limonciello@amd.com>; Shah, Nehal-
> bakulchandra <Nehal-bakulchandra.Shah@amd.com>; Damien Le Moal
> <damien.lemoal@opensource.wdc.com>; Sasha Levin <sashal@kernel.org>;
> linux-ide@vger.kernel.org
> Subject: [PATCH AUTOSEL 5.15 28/39] ata: libahci: Adjust behavior when
> StorageD3Enable _DSD is set
>=20
> From: Mario Limonciello <mario.limonciello@amd.com>
>=20
> [ Upstream commit 7c5f641a5914ce0303b06bcfcd7674ee64aeebe9 ]
>=20
> The StorageD3Enable _DSD is used for the vendor to indicate that the disk
> should be opted into or out of a different behavior based upon the platfo=
rm
> design.
>=20
> For AMD's Renoir and Green Sardine platforms it's important that any
> attached SATA storage has transitioned into DevSlp when s2idle is used.
>=20
> If the disk is left in active/partial/slumber, then the system is not abl=
e
> to resume properly.
>=20
> When the StorageD3Enable _DSD is detected, check the system is using
> s2idle
> and DevSlp is enabled and if so explicitly wait long enough for the disk =
to
> enter DevSlp.
>=20
> Cc: Nehal-bakulchandra Shah <Nehal-bakulchandra.Shah@amd.com>
> BugLink:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbugz
> illa.kernel.org%2Fshow_bug.cgi%3Fid%3D214091&amp;data=3D04%7C01%7Cm
> ario.limonciello%40amd.com%7C15dc139812a0497d31bc08d9b0850f45%7C3d
> d8961fe4884e608e11a82d994e183d%7C0%7C0%7C637734907816859936%7CU
> nknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI
> 6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=3D%2BX2cfl%2BYeFYWZJ%2
> FPFWX%2FzxnNtneb2er7w%2BeJpVxxBcU%3D&amp;reserved=3D0
> Link:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fdocs
> .microsoft.com%2Fen-us%2Fwindows-hardware%2Fdesign%2Fcomponent-
> guidelines%2Fpower-management-for-storage-hardware-devices-
> intro&amp;data=3D04%7C01%7Cmario.limonciello%40amd.com%7C15dc139812
> a0497d31bc08d9b0850f45%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C
> 0%7C637734907816859936%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLj
> AwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;
> sdata=3DubGKpzMA6EaXugHAanwRUQJ2lvL957wBRFKKMjUBGlw%3D&amp;re
> served=3D0
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/ata/libahci.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>=20
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index 5b3fa2cbe7223..395772fa39432 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -2305,6 +2305,18 @@ int ahci_port_resume(struct ata_port *ap)
>  EXPORT_SYMBOL_GPL(ahci_port_resume);
>=20
>  #ifdef CONFIG_PM
> +static void ahci_handle_s2idle(struct ata_port *ap)
> +{
> +	void __iomem *port_mmio =3D ahci_port_base(ap);
> +	u32 devslp;
> +
> +	if (pm_suspend_via_firmware())
> +		return;
> +	devslp =3D readl(port_mmio + PORT_DEVSLP);
> +	if ((devslp & PORT_DEVSLP_ADSE))
> +		ata_msleep(ap, devslp_idle_timeout);
> +}
> +
>  static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
>  {
>  	const char *emsg =3D NULL;
> @@ -2318,6 +2330,9 @@ static int ahci_port_suspend(struct ata_port *ap,
> pm_message_t mesg)
>  		ata_port_freeze(ap);
>  	}
>=20
> +	if (acpi_storage_d3(ap->host->dev))
> +		ahci_handle_s2idle(ap);
> +
>  	ahci_rpm_put_port(ap);
>  	return rc;
>  }
> --
> 2.33.0

Sasha,

No concerns for me to 5.15 or any of the earlier kernels the autosel picked=
, but would you mind also sending this to 5.14.y too?

Thanks,
