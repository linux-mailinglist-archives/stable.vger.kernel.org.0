Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9794DD66
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 00:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfFTWVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 18:21:09 -0400
Received: from mail-eopbgr790095.outbound.protection.outlook.com ([40.107.79.95]:19590
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726015AbfFTWVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 18:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/UYgWmro7vABB8hkcUMfy5qZnl54pnh8/ZX53FTRNc=;
 b=E3wletjzF0D6Qaa5Szu4yx69gqrbarbKO4jKiWn56tkf05Fu+a3HSkO840Q8OMcT3UYXCU70pvZ/cbdficrbpq4o4Bi1R/Y71ZLb++Liw49tlgXbCsnc1FRPX9+m0Uj0Ydwn5yXkurOQzaWuOtFSGtMxk0wjnEe86LhrJY3siw8=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1391.namprd22.prod.outlook.com (10.172.62.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Thu, 20 Jun 2019 22:21:06 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40%2]) with mapi id 15.20.2008.007; Thu, 20 Jun 2019
 22:21:06 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Dmitry Korotin <dkorotin@wavecomp.com>
CC:     Paul Burton <pburton@wavecomp.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] Added missing EHB in mtc0 -> mfc0 sequence.
Thread-Topic: [PATCH] Added missing EHB in mtc0 -> mfc0 sequence.
Thread-Index: AQHVIxJBW2AHYf1PYUy4ub6PviN/IaalJsAA
Date:   Thu, 20 Jun 2019 22:21:05 +0000
Message-ID: <20190620222103.quvgfrkwfvmcgfgv@pburton-laptop>
References: <CY4PR22MB02453FCB184A7ED1534D0C2CAFE90@CY4PR22MB0245.namprd22.prod.outlook.com>
In-Reply-To: <CY4PR22MB02453FCB184A7ED1534D0C2CAFE90@CY4PR22MB0245.namprd22.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::38) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
user-agent: NeoMutt/20180716
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.93.153.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9dcdeb57-829d-4acb-d358-08d6f5cd9612
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1391;
x-ms-traffictypediagnostic: MWHPR2201MB1391:
x-microsoft-antispam-prvs: <MWHPR2201MB139162DBC13AED0512629D9CC1E40@MWHPR2201MB1391.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(346002)(376002)(39850400004)(136003)(366004)(396003)(189003)(199004)(316002)(186003)(446003)(5660300002)(52116002)(11346002)(76176011)(42882007)(44832011)(6506007)(305945005)(386003)(3716004)(7736002)(25786009)(26005)(58126008)(66066001)(102836004)(476003)(33716001)(1076003)(54906003)(486006)(99286004)(66446008)(256004)(64756008)(14444005)(81156014)(68736007)(6116002)(3846002)(6436002)(66476007)(66946007)(66556008)(14454004)(8676002)(6246003)(73956011)(81166006)(2906002)(6862004)(478600001)(4326008)(8936002)(53936002)(9686003)(6512007)(229853002)(71200400001)(450100002)(6486002)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1391;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3uJvlSqeOpNvs3adSGu9U/jt3F8XNdZO4+QRyJyAYh8NLv7wJ6kUFzUjgXviWSo3OogCODdBnmoDn1d4XDwwEAiS07ALIgroXXacC26NYQsU60WTZ73uE1ZxkT0W6Jz6QbBZARs0REPemJ54jPbiGBqNjwEW4x4UU3iRTivHSQ2YFKrXN0XKYhzGGa6BrvIkeNTbfNtESG2mt8v2mn4UsGIno2B9OPsMfOYRrP3rAcTpfceta1gMa5SVKeOjJVwh2wv5K4fnMPwW0xrGI9pSZ9i/896YrowFpErsFwlgCyfCpblEujkuXOKdwfT+mZwLEeAJ9PigxPSYNOyFr4sSPb/KfvGUYW6u928N/KPzBEbZDyq5AW1VVgxTgM8mU33hAwlQJkkJysztZP1j3se78jyO8Ey8AH3S37SAfUrsggM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7F3312D614B3EE449DFFC227C9663D5C@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dcdeb57-829d-4acb-d358-08d6f5cd9612
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 22:21:06.0135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1391
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dmitry,

On Sat, Jun 15, 2019 at 12:35:39AM +0000, Dmitry Korotin wrote:
>     Added missing EHB (Execution Hazard Barrier) in mtc0 -> mfc0 sequence=
.
>     Mips documentation Volume III (rev 6.03) table 8.1.

It would be good to describe the problem you saw here - ie. mention that
without this execution hazard barrier it's possible for the value read
back from the KScratch register to be the value from before the mtc0.

Also probably good to mention which CPUs the problem has been seen on.

Information like this can be really useful when making decisions about
stable backports, or for others who come across the patch later & just
want to figure out why you wrote it.

> Signed-off-by: Dmitry Korotin <dkorotin@wavecomp.com>
> ---
>  arch/mips/mm/tlbex.c |   32 ++++++++++++++++++++++----------
>  1 files changed, 22 insertions(+), 10 deletions(-)
>=20
> diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
> index 65b6e85..bf7f131 100644
> --- a/arch/mips/mm/tlbex.c
> +++ b/arch/mips/mm/tlbex.c
> @@ -391,6 +391,7 @@ static struct work_registers build_get_work_registers=
(u32 **p)
>  static void build_restore_work_registers(u32 **p)
>  {
>  	if (scratch_reg >=3D 0) {
> +		uasm_i_ehb(p);
>  		UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
>  		return;
>  	}
> @@ -668,10 +669,12 @@ static void build_restore_pagemask(u32 **p, struct =
uasm_reloc **r,
>  			uasm_i_mtc0(p, 0, C0_PAGEMASK);
>  			uasm_il_b(p, r, lid);
>  		}
> -		if (scratch_reg >=3D 0)
> +		if (scratch_reg >=3D 0) {
> +			uasm_i_ehb(p);
>  			UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
> -		else
> +		} else {
>  			UASM_i_LW(p, 1, scratchpad_offset(0), 0);
> +		}
>  	} else {
>  		/* Reset default page size */
>  		if (PM_DEFAULT_MASK >> 16) {
> @@ -938,10 +941,12 @@ void build_get_pmde64(u32 **p, struct uasm_label **=
l, struct uasm_reloc **r,
>  		uasm_i_jr(p, ptr);
> =20
>  		if (mode =3D=3D refill_scratch) {
> -			if (scratch_reg >=3D 0)
> +			if (scratch_reg >=3D 0) {
> +				uasm_i_ehb(p);
>  				UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
> -			else
> +			} else {
>  				UASM_i_LW(p, 1, scratchpad_offset(0), 0);
> +			}
>  		} else {
>  			uasm_i_nop(p);
>  		}
> @@ -1258,6 +1263,7 @@ struct mips_huge_tlb_info {
>  	UASM_i_MTC0(p, odd, C0_ENTRYLO1); /* load it */
> =20
>  	if (c0_scratch_reg >=3D 0) {
> +		uasm_i_ehb(p);
>  		UASM_i_MFC0(p, scratch, c0_kscratch(), c0_scratch_reg);
>  		build_tlb_write_entry(p, l, r, tlb_random);
>  		uasm_l_leave(l, *p);
> @@ -1603,15 +1609,19 @@ static void build_setup_pgd(void)
>  		uasm_i_dinsm(&p, a0, 0, 29, 64 - 29);
>  		uasm_l_tlbl_goaround1(&l, p);
>  		UASM_i_SLL(&p, a0, a0, 11);
> -		uasm_i_jr(&p, 31);
>  		UASM_i_MTC0(&p, a0, C0_CONTEXT);
> +		uasm_i_ehb(&p);
> +		uasm_i_jr(&p, 31);
> +		uasm_i_nop(&p);

Could the ehb go in the JR's delay slot here?

>  	} else {
>  		/* PGD in c0_KScratch */
> -		uasm_i_jr(&p, 31);
>  		if (cpu_has_ldpte)
>  			UASM_i_MTC0(&p, a0, C0_PWBASE);
>  		else
>  			UASM_i_MTC0(&p, a0, c0_kscratch(), pgd_reg);
> +		uasm_i_ehb(&p);
> +		uasm_i_jr(&p, 31);
> +		uasm_i_nop(&p);

Likewise here.

>  	}
>  #else
>  #ifdef CONFIG_SMP
> @@ -1625,13 +1635,15 @@ static void build_setup_pgd(void)
>  	UASM_i_LA_mostly(&p, a2, pgdc);
>  	UASM_i_SW(&p, a0, uasm_rel_lo(pgdc), a2);
>  #endif /* SMP */
> -	uasm_i_jr(&p, 31);
> =20
>  	/* if pgd_reg is allocated, save PGD also to scratch register */
> -	if (pgd_reg !=3D -1)
> +	if (pgd_reg !=3D -1) {
>  		UASM_i_MTC0(&p, a0, c0_kscratch(), pgd_reg);
> -	else
> -		uasm_i_nop(&p);
> +		uasm_i_ehb(&p);
> +	}
> +
> +	uasm_i_jr(&p, 31);
> +	uasm_i_nop(&p);

And here too.

Thanks,
    Paul
