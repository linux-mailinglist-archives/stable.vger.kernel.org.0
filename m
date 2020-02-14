Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAC515EB11
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391780AbgBNRSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:18:31 -0500
Received: from mail-bn8nam11on2118.outbound.protection.outlook.com ([40.107.236.118]:48129
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391692AbgBNQLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:11:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LoPLp0YSa2VdHkFO/zzjF9RSUR4o1Le0xM7lk12Xjton4DaPVc2tRgvW8Uew8TVsD6+4SxTMjQmNFyGKFAgImlsUZUhnYUnAmhBj7BlMfpcL97bHSCRtHO2gbjVmDJWG2gGNuMwjPHjBG9sNBVkPH6yGQ8if4cvxSHLzPRh5Vn0wv/+70Iy5jo6jigj5bA7aeVKWdku9IYnyQiZX70puPwL4fRm4Dwuc/AbWVHXvUFCCXVQz50qW2TVpEXwwjmDTugXPsSMocB1veDVzJbtq/D+vagQrrDNMeHzvvKux0E37YS68DbI+uZn3i0hmj2mAESae1BLYfv91a5qxCjuCMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9WbUbg+fzaMyDvnIex918MogQLZM+c1PpNq6G9P2GLI=;
 b=YOIl7zZ7MT40DXOh2J/o3ZCu/8gV4RqaQmIqkNd8QhuuPLBRWBWQedO1LHuqlWgeKlnntvPgNhAf4wCF1lLF2X3nJg8g5dWN1QZSgB4fFBIEoOfQy1f6xo51KyCTJNBuObZJnj59ulYSZnlm6k6dyjPdbp6gZKvOZzfW15ZObIzRf7v0k/6MStpP8A9fLRuSWAXvtrFeImkm6T1c8HiuxQdWVG78z+Gx/IAC9XZqR5dZ2ElmPilNRC/uN9DCgHvwmRa6eSWldIVCnsQVwmw8Kud12kohjjPd1pnkAABvM/hhKCdQJIQ+Vwuz5N77G7uwhU3PJ4nY3fTFSip3UHrzDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9WbUbg+fzaMyDvnIex918MogQLZM+c1PpNq6G9P2GLI=;
 b=E5mWP8Jf8IwnX5cMfFdJQVZBcUE8ViD9Yz3pyrjBLjygQMf2Ebogkn9O+QuufL1uCwhATMQlJBhsCwGY1sjVO0asdXun23iMoCclQRCK56pLgiED1kD0FTXzip74/CJuZUDgNCcOlWXREoksgE5U4tsbYL2GFkq+XKgO1VygC84=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (52.132.149.16) by
 MW2PR2101MB0890.namprd21.prod.outlook.com (52.132.152.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.7; Fri, 14 Feb 2020 16:11:03 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::79be:4582:d077:d039]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::79be:4582:d077:d039%6]) with mapi id 15.20.2729.010; Fri, 14 Feb 2020
 16:11:03 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: RE: [PATCH AUTOSEL 5.5 389/542] clocksource/drivers/hyper-v: Reserve
 PAGE_SIZE space for tsc page
Thread-Topic: [PATCH AUTOSEL 5.5 389/542] clocksource/drivers/hyper-v: Reserve
 PAGE_SIZE space for tsc page
Thread-Index: AQHV409wsUPJXk6VkkSYQ6dCaZFY+qga24bg
Date:   Fri, 14 Feb 2020 16:11:03 +0000
Message-ID: <MW2PR2101MB10526693E43DF07E03D5EB0FD7150@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-389-sashal@kernel.org>
In-Reply-To: <20200214154854.6746-389-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-02-14T16:11:01.4460446Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8d27b095-821a-49bf-a930-3531898cc13b;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [173.197.107.13]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f3be4da9-d1c4-4a1b-0923-08d7b1687d44
x-ms-traffictypediagnostic: MW2PR2101MB0890:
x-microsoft-antispam-prvs: <MW2PR2101MB08900266012D6F61D24FDEF1D7150@MW2PR2101MB0890.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-forefront-prvs: 03137AC81E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(199004)(189003)(186003)(966005)(478600001)(5660300002)(8990500004)(4326008)(53546011)(26005)(2906002)(52536014)(6506007)(10290500003)(8676002)(54906003)(55016002)(110136005)(81166006)(8936002)(7696005)(86362001)(316002)(64756008)(66946007)(33656002)(76116006)(9686003)(71200400001)(66556008)(66476007)(81156014)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB0890;H:MW2PR2101MB1052.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EIjCcYMDVqbu4rcy0Pjf55jun2LlkvemNF9RrsQyZUHm33cEFLa0ydEm/4VvB0Z3MgVjkwFqY2/lD46iA8ZEt79SFxRcGb3BpcQU52YWACCaFtRo9KaQj7X6dp3GLd9EkpTYGmAef5m1+++BL7NnVYdgUrE2B7tv+Yh0nz8jXcRcg+WlwsnklpLw7Qj4IEW3LXXxcPItw+WKooyadef4AOX+7daz1RA6t9RjZ5OdpMjOvGghhGCmPmmXi/JWvOKyxenEjoa/xq+J094IgzHjdvPoQerePZcsbTCmHzJi4Ab4walPi6ScdphsSWJ678UTOhTS25MMAXwUisnj1h/+yq9E2lMveZGYyXlblPVLY7QO3jsDc5pNe01FdQYS8z4dAh52hrqu2AWDyAYyVMGrAb8bag28RYkaxJsVK0b/QJDHM8ON/0ynI0D1XdiOcqc2xKuBLvpLlr4OWaeOFPErWg5Hwq8zIUWmn0W7CLSHCg73r703UvaYImrjaqe7DoQ2xdjHyZC5chd4A/bgVIOL1Q==
x-ms-exchange-antispam-messagedata: nbWtDIoysD1FlN7Vrl3DYQucG8l4bt4o+QcbHqK02McjJAN0iLmcVfu1LHa36GcPJcApqoyP2Ne1uPlyKtjhEi7ALPgHW5oDhPnzwFptDlkCkZ4K9uH0A1nV0D5NhOtMdbqpkwHpEfGKUA6YagWXCA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3be4da9-d1c4-4a1b-0923-08d7b1687d44
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2020 16:11:03.0681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pH/m/5ezlNZK2+DUgvReVXncY1QeTX7ubsFAt+R6TlYop1kY9faNBWKHkjzLyufBmizH0A6MtAFG15ql7aa+7FSEXNvf9f/IxKH/TlLdYrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0890
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch does not need to be backported to any stable releases.  It is pr=
ep work for guests on Hyper-V ARM64 when the guest page size is 16K or 64K,=
 and that functionality isn't upstream yet.

Michael

> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Friday, February 14, 2020 7:46 AM
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Boqun Feng <boqun.feng@gmail.com>; linux-hyperv@vger.kernel.org; Mich=
ael Kelley
> <mikelley@microsoft.com>; Daniel Lezcano <daniel.lezcano@linaro.org>; Sas=
ha Levin
> <sashal@kernel.org>
> Subject: [PATCH AUTOSEL 5.5 389/542] clocksource/drivers/hyper-v: Reserve=
 PAGE_SIZE
> space for tsc page
>=20
> From: Boqun Feng <boqun.feng@gmail.com>
>=20
> [ Upstream commit ddc61bbc45017726a2b450350d476b4dc5ae25ce ]
>=20
> Currently, the reserved size for a tsc page is 4K, which is enough for
> communicating with hypervisor. However, in the case where we want to
> export the tsc page to userspace (e.g. for vDSO to read the
> clocksource), the tsc page should be at least PAGE_SIZE, otherwise, when
> PAGE_SIZE is larger than 4K, extra kernel data will be mapped into
> userspace, which means leaking kernel information.
>=20
> Therefore reserve PAGE_SIZE space for tsc_pg as a preparation for the
> vDSO support of ARM64 in the future. Also, while at it, replace all
> reference to tsc_pg with hv_get_tsc_page() since it should be the only
> interface to access tsc page.
>=20
> Signed-off-by: Boqun Feng (Microsoft) <boqun.feng@gmail.com>
> Cc: linux-hyperv@vger.kernel.org
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Link:
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.=
kernel.org%2Fr
> %2F20191126021723.4710-1-
> boqun.feng%40gmail.com&amp;data=3D02%7C01%7Cmikelley%40microsoft.com%7C2f=
481a9
> 3db624cb4b5e208d7b16691f6%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63=
71
> 72926408924092&amp;sdata=3D%2F1JNMBiq7l1ufSsWphZb%2FMLNep2EIOCzlXcG%2F9fo=
ZNw
> %3D&amp;reserved=3D0
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/clocksource/hyperv_timer.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyp=
erv_timer.c
> index 287d8d58c21ac..b6ea3a2093c56 100644
> --- a/drivers/clocksource/hyperv_timer.c
> +++ b/drivers/clocksource/hyperv_timer.c
> @@ -307,17 +307,20 @@ EXPORT_SYMBOL_GPL(hv_stimer_global_cleanup);
>  struct clocksource *hyperv_cs;
>  EXPORT_SYMBOL_GPL(hyperv_cs);
>=20
> -static struct ms_hyperv_tsc_page tsc_pg __aligned(PAGE_SIZE);
> +static union {
> +	struct ms_hyperv_tsc_page page;
> +	u8 reserved[PAGE_SIZE];
> +} tsc_pg __aligned(PAGE_SIZE);
>=20
>  struct ms_hyperv_tsc_page *hv_get_tsc_page(void)
>  {
> -	return &tsc_pg;
> +	return &tsc_pg.page;
>  }
>  EXPORT_SYMBOL_GPL(hv_get_tsc_page);
>=20
>  static u64 notrace read_hv_clock_tsc(struct clocksource *arg)
>  {
> -	u64 current_tick =3D hv_read_tsc_page(&tsc_pg);
> +	u64 current_tick =3D hv_read_tsc_page(hv_get_tsc_page());
>=20
>  	if (current_tick =3D=3D U64_MAX)
>  		hv_get_time_ref_count(current_tick);
> @@ -372,7 +375,7 @@ static bool __init hv_init_tsc_clocksource(void)
>  		return false;
>=20
>  	hyperv_cs =3D &hyperv_cs_tsc;
> -	phys_addr =3D virt_to_phys(&tsc_pg);
> +	phys_addr =3D virt_to_phys(hv_get_tsc_page());
>=20
>  	/*
>  	 * The Hyper-V TLFS specifies to preserve the value of reserved
> --
> 2.20.1

