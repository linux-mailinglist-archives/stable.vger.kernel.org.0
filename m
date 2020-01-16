Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62FE813DD39
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 15:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgAPOSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 09:18:06 -0500
Received: from mail-eopbgr1320100.outbound.protection.outlook.com ([40.107.132.100]:7920
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbgAPOSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 09:18:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4GvqKubvgYsjSRVxY9Ko6+Sbmhxi4t1EnT+sThVhplSFgE5Zp7IAwpqQySKoyCK+aUbhAVTOwNJrm+wJXVrntLtqKGOjDMU5+l6b7wRqQRi52hap0h7fiUkHj4jJ5LpEixiC87LkepxJzail52NOoH8oVW2Y3O0jDWbdAxbxn4Q+Wkbxz2k1M68q1Hfb9wx4KSsNA/mV4ZCSUSIsgjWtdQ2GgbTjnLK2HWO5tf4U4UWo/v7GNQVsI1crJoN5ucFbVx14NrGJHxDDHf4Ucd36Ypzn70QVzjeAL6rRNLFjiJr7WMYkBS6Ur9NbWPaDw6StFqziEUmGQIiXIUC/PnnWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzcjipmkHhB+JOxKByubuijnk+18YLlnac4YJHCXPWA=;
 b=hZolJFFfr9BedfU2y9Isc2LPCkWRGNYkV41UyfaX1TUmT4m24vde7Rj2Qpe8i8RoxlOQKzqliASIJSH6IkRu8daJgfzFT/R1tJQMuVWVyK+W9QL4ZYin9qDGQTAigEoE8eX9rI+CIfu2+F+551HAvoFdZblAmXXTBIDmW3S4VJsJzAC1FeQ3a1jViqwug4v0Jh4bSzkmSCTY/KO9PjsuKtS9wZbDQrXH9MpLUUQsT+WrGkKjIfpQ8GZ8M3EA4PIBWZUzURMUglLWWQfE/0Qz7Y9e5V8xRF1ao00ijcBL2GGfLRCkNaef6UvWewKdMdHA24WztXu9t+OrnpUkZ70Xng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzcjipmkHhB+JOxKByubuijnk+18YLlnac4YJHCXPWA=;
 b=EjSSiYf0bgNztFwDIz3FeCLSq5QZ0kDUi+DaFWNnze+rOeBsl9Guybr/wFAIGOEM5Y7OzwKDlJd30qjSi7sUZlWUaaz1vMije93u86GHErzeBX+U0IpbweNKLg/6P1Qxsvo2W5c3xDKfIam4hiUZcxTsfKpSULNPVBlIGGroaeY=
Received: from PS1P15301MB0347.APCP153.PROD.OUTLOOK.COM (10.255.67.140) by
 PS1P15301MB0329.APCP153.PROD.OUTLOOK.COM (10.255.67.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.1; Thu, 16 Jan 2020 14:17:58 +0000
Received: from PS1P15301MB0347.APCP153.PROD.OUTLOOK.COM
 ([fe80::c4c2:3647:37d0:bb99]) by PS1P15301MB0347.APCP153.PROD.OUTLOOK.COM
 ([fe80::c4c2:3647:37d0:bb99%9]) with mapi id 15.20.2644.015; Thu, 16 Jan 2020
 14:17:58 +0000
From:   Tianyu Lan <Tianyu.Lan@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>,
        "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [EXTERNAL] Re: [PATCH] x86/Hyper-V: Balloon up according to
 request page number
Thread-Topic: [EXTERNAL] Re: [PATCH] x86/Hyper-V: Balloon up according to
 request page number
Thread-Index: AQHVyr1W8BxUjxrtnEuWgRAW3x4BfKftCkaQ
Date:   Thu, 16 Jan 2020 14:17:57 +0000
Message-ID: <PS1P15301MB034760AF7857998198DD00AB92360@PS1P15301MB0347.APCP153.PROD.OUTLOOK.COM>
References: <20200114074435.12732-1-Tianyu.Lan@microsoft.com>
 <87blr6pepz.fsf@vitty.brq.redhat.com>
In-Reply-To: <87blr6pepz.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=tiala@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-16T14:17:54.7997933Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=49c04b44-f415-4dfa-b174-81fe68314286;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tianyu.Lan@microsoft.com; 
x-originating-ip: [167.220.255.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 99571dd5-92e0-4418-8a58-08d79a8ee337
x-ms-traffictypediagnostic: PS1P15301MB0329:|PS1P15301MB0329:|PS1P15301MB0329:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PS1P15301MB03294B6AA5A4A08F3E54C62C92360@PS1P15301MB0329.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(199004)(189003)(8676002)(7696005)(26005)(10290500003)(316002)(86362001)(107886003)(8936002)(4326008)(9686003)(81166006)(81156014)(66556008)(71200400001)(52536014)(5660300002)(8990500004)(55016002)(6506007)(53546011)(478600001)(186003)(110136005)(66476007)(66946007)(7416002)(2906002)(76116006)(54906003)(64756008)(33656002)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:PS1P15301MB0329;H:PS1P15301MB0347.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 05YyiXvuM2UQ2YIXGKRwX0lkWwFXCUWy0dUaO0LBNhH3rRGEP9vYBOMAXQTaHdnCL0fu23OyxmGjrhtcQ6Gb5Z7YVz0UOq8oQsEXmMZZVjxy+nwM+A7ra50nxNnCv4HGGuD19c2IqCIX+cQHnWhlvN9sLx4jOroMHyrdjqrbr7YRZ224imP2A82KmHrOye9qrKn+3Zg1so005Vr4iaKZJ9GD1cwicdrvzXvkmD5jdqTFB4yezPEggMDtefShhPoa9qednTDYEB3W+wYBGDVGyRTjMtLu3ArPD074AEJ+YvTLUDhrRvqWs9alESHc52JTmdLiKsNWIiBjVXSPZyLQJb8RyOiJWZLg4JrGy6qhp2gxJXslh2go5Zv9ycVtFM+VWlui2Fk8AXClVY2pgFEteqilK8ARf4XdM7jGAi4HiqBFB50LLlDgUCuu4Ubimhu+
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99571dd5-92e0-4418-8a58-08d79a8ee337
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 14:17:57.8849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KpwLnSVSF5H4w4S+ka/EV9ZIB6AdPksuiz7uK5psIZW/FE8IPPF0rtbIU9cCVuwNw+kA6YAiuigR9K0Bzuk0CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1P15301MB0329
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vitaly:
	Thanks for your review. I fix comments in V2.=20

> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-
> owner@vger.kernel.org> On Behalf Of Vitaly Kuznetsov
> Sent: Tuesday, January 14, 2020 5:31 PM
> To: lantianyu1986@gmail.com
> Cc: linux-kernel@vger.kernel.org; linux-hyperv@vger.kernel.org; linux-
> mm@kvack.org; stable@vger.kernel.org; tglx@linutronix.de;
> mingo@redhat.com; bp@alien8.de; hpa@zytor.com; x86@kernel.org;
> dave.hansen@linux.intel.com; luto@kernel.org; peterz@infradead.org; KY
> Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> Stephen Hemminger <sthemmin@microsoft.com>; sashal@kernel.org;
> akpm@linux-foundation.org; Michael Kelley <mikelley@microsoft.com>;
> Dexuan Cui <decui@microsoft.com>
> Subject: [EXTERNAL] Re: [PATCH] x86/Hyper-V: Balloon up according to requ=
est
> page number
>=20
> lantianyu1986@gmail.com writes:
>=20
> > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> >
> > Current code has assumption that balloon request memory size aligns
> > with 2MB. But actually Hyper-V doesn't guarantee such alignment. When
> > balloon driver receives non-aligned balloon request, it produces
> > warning and balloon up more memory than requested in order to keep 2MB
> alignment.
> > Remove the warning and balloon up memory according to actual requested
> > memory size.
> >
> > Fixes: f6712238471a ("hv: hv_balloon: avoid memory leak on alloc_error
> > of 2MB memory block")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > ---
> >  drivers/hv/hv_balloon.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c index
> > 7f3e7ab22d5d..38ad0e44e927 100644
> > --- a/drivers/hv/hv_balloon.c
> > +++ b/drivers/hv/hv_balloon.c
> > @@ -1684,7 +1684,7 @@ static unsigned int alloc_balloon_pages(struct
> hv_dynmem_device *dm,
> >  	if (num_pages < alloc_unit)
> >  		return 0;
> >
> > -	for (i =3D 0; (i * alloc_unit) < num_pages; i++) {
> > +	for (i =3D 0; i < num_pages / alloc_unit; i++) {
> >  		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
> >  			HV_HYP_PAGE_SIZE)
> >  			return i * alloc_unit;
> > @@ -1722,7 +1722,7 @@ static unsigned int alloc_balloon_pages(struct
> > hv_dynmem_device *dm,
> >
> >  	}
> >
> > -	return num_pages;
> > +	return i * alloc_unit;
> >  }
> >
> >  static void balloon_up(union dm_msg_info *msg_info) @@ -1737,9
> > +1737,6 @@ static void balloon_up(union dm_msg_info *msg_info)
> >  	long avail_pages;
> >  	unsigned long floor;
> >
> > -	/* The host balloons pages in 2M granularity. */
> > -	WARN_ON_ONCE(num_pages % PAGES_IN_2M !=3D 0);
> > -
> >  	/*
> >  	 * We will attempt 2M allocations. However, if we fail to
> >  	 * allocate 2M chunks, we will go back to PAGE_SIZE allocations.
>=20
> This looks correct but I've noticed we also have
>=20
> 	/* Refuse to balloon below the floor, keep the 2M granularity. */
> 	if (avail_pages < num_pages || avail_pages - num_pages < floor) {
> 		pr_warn("Balloon request will be partially fulfilled. %s\n",
> 			avail_pages < num_pages ? "Not enough memory." :
> 			"Balloon floor reached.");
>=20
> 		num_pages =3D avail_pages > floor ? (avail_pages - floor) : 0;
> 		num_pages -=3D num_pages % PAGES_IN_2M;
> 	}
>=20
> in balloon_up(). If 2M granularity is not guaranteed in the first place w=
e can't
> keep it.
>=20
> Also, when alloc_balloon_pages() is called with 2M alloc_unit and the reg=
ion is
> not 2M aligned, it will return someething < num_pages, the next condition=
,
> however, only checks for 0:
>=20
>                 if (alloc_unit !=3D 1 && num_ballooned =3D=3D 0) {
>                         alloc_unit =3D 1;
>                         continue;
>                 }
>=20
> we will proceed to sending a response to server and try doing next iterat=
ion by
> calling alloc_balloon_pages() with 2M alloc_unit again, this will finally=
 return 0
> and we will switch to 4k. I think we can optimize this to:
>=20
>                 if (alloc_unit !=3D 1 && num_ballooned !=3D num_pages) {
> 			alloc_unit =3D 1;
> 		        continue;
> 		}
>=20
> --
> Vitaly

