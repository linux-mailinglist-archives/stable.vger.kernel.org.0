Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EE7201F6A
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 03:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731275AbgFTBOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 21:14:18 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:6044
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730293AbgFTBOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 21:14:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNxynIb/uTleJYFTulqmTUkgcQJ1Z6WAGNbmykBZpnZdCN9slyybz4j303Q0CGFDGSNrAgK68/ygya1CHaGN/dQYRBe8njCnD8aKRG/QNEyX1Uouss3r9D55Xgx22vg67LRalAhi8D9bZPwbK69FOxUXDERukPknkWz/LnYojS3Gft7qwv6RUvKkqkomgC3oMZbXX3XIL+G9kdxoa8F54AKFIxu31gOD/4KG4fOyJ66H58fqV6TB0fFciOHtMBaZ+u5RTm1zNkDsfsIMUxLm6XAIaV37CxlTjKbsHJk8FOdEemjCmdQumXJk6NJDvROrf+H50ec3sL0WrSmGkswCtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLiJGhKBx803s8EWkgs8g6g1lHQUoZjDCDuZjE2SJac=;
 b=c5BrypJ531Vw0cU8BW1TTc3S6SCNRCXiZGUYvvTQjM3GsbjGzM/0zI1YdVBn87RV4XGJdZXG6Rvz3CuQml+weOb+G1naM/n65kvrGfrE25eNEXdePxhy8kM4pZezL0RbWJyUreIUv5TzX7I6CFVvUArYXN58X6Yqmk1Bn6Qem3xruBhu9Zbi6LgKiSw7Q6Izu9Hhu8J5kZwpU668hB45L8w08iRVztVv3GSW9rgf4AMklz3nh4v7Iq4hQWwTFVXLcPkK5c2B7SLoyQvgBN/d+l5TO3rik6ae3Hl5qQKAhnjFNVPmey0uqrfs3gpbJzZUXvaLOqQrq9+avh+/xhTQGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLiJGhKBx803s8EWkgs8g6g1lHQUoZjDCDuZjE2SJac=;
 b=sdyUAsOXgEBniBrO2O45cm1f/3DeT/+ipVpmiaOLBmiDJMGmWQFfYHfEqXMgIloe+UbjFJIB3Z/oT70nlVLGPZQDHsOS+6vPs3TiOniL3ie8AtH9c205SV9Aip7ADtlPLVWZB0RoKF1C4o30z8y4FmJuyy6+uwPpdf6ZZYfUc1k=
Received: from DM6PR02MB4140.namprd02.prod.outlook.com (2603:10b6:5:97::21) by
 DM5PR0201MB3605.namprd02.prod.outlook.com (2603:10b6:4:7b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22; Sat, 20 Jun 2020 01:14:12 +0000
Received: from DM6PR02MB4140.namprd02.prod.outlook.com
 ([fe80::3de9:d192:ff78:5302]) by DM6PR02MB4140.namprd02.prod.outlook.com
 ([fe80::3de9:d192:ff78:5302%5]) with mapi id 15.20.3109.024; Sat, 20 Jun 2020
 01:14:11 +0000
From:   Dragan Cvetic <draganc@xilinx.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     John Hubbard <jhubbard@nvidia.com>,
        Derek Kiernan <dkiernan@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH AUTOSEL 5.4 199/266] misc: xilinx-sdfec: improve
 get_user_pages_fast() error handling
Thread-Topic: [PATCH AUTOSEL 5.4 199/266] misc: xilinx-sdfec: improve
 get_user_pages_fast() error handling
Thread-Index: AQHWRQ61FS7zdg3QMUy0hbZWF+zzJKjgtYLA
Date:   Sat, 20 Jun 2020 01:14:11 +0000
Message-ID: <DM6PR02MB4140DF2D6689DC0250F31523CB990@DM6PR02MB4140.namprd02.prod.outlook.com>
References: <20200618011631.604574-1-sashal@kernel.org>
 <20200618011631.604574-199-sashal@kernel.org>
In-Reply-To: <20200618011631.604574-199-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=xilinx.com;
x-originating-ip: [149.199.80.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a1046cf3-c501-4b57-3892-08d814b73d97
x-ms-traffictypediagnostic: DM5PR0201MB3605:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR0201MB36057AC2B2F660DD8DBC40BCCB990@DM5PR0201MB3605.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0440AC9990
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d7iCBDyJBjnaux6jXIQmfE4HSF7IUOXqc2BmdZo/P4K6DdImu1tf9S8bQ4fJDVjxH5HtkI84gGkveY2pCX0hatR20EZKUR9YBTCUEp0rAStVMImQ1DUL295oJzaw+OmhhCnP0F5V/FNoiQ/zGeJEF4KXT/QAA6KFp/C3LZcKlVYX4iST2E9TBTDL533IElqNfOH9dz2vguWwAUFygQBFFOPaLcVST/lx5Qd+TswNOxJELtrgdw9dDU8j0zRS6znB46XeBvbsGrf+r1hKRj7HZbAClWMjx6XRlcSSUfnhKlbSCVZfxdxiZZnUnmZgj1P+ZF45xQJPPMm/LxOuTJtQwYJs83tK02zQBdmH82vzFPHQeQBqhyQXOgBwwg7o+r7GzBOcmyTduTxaN76CsBcS5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR02MB4140.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(346002)(366004)(136003)(376002)(396003)(83380400001)(4326008)(478600001)(2906002)(86362001)(966005)(53546011)(52536014)(33656002)(6506007)(66946007)(8936002)(54906003)(66446008)(110136005)(7696005)(66476007)(66556008)(64756008)(71200400001)(9686003)(26005)(186003)(8676002)(5660300002)(316002)(76116006)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZDAqdo2P5+sEqB6ffxCBRW6muQ5+suEnispvdopLNuB9y+X+901IUoYHuptyuwMTTsd/5cLx0mxWDMJfD7QrZiD4gd2k97G2gW8ff80puW0OdeyMRLu5BYkiluvOZ6IT6vazr6WogDdIfyU4pnTqEUtN5Pi0OvdBUpR5GRpk6SXiwUzbvGMoQanyt1MC7gEDIyHGoCvOnWa9jmmcyDiN5oI5By+4nWDWu+smA3gy1pPtFk6WNeVAiYKKKdKG9Q1oKSm3QGho8RTyRpOmxXCPxubzKOizDKDtdzxkKE25Z3wyWaleiXdLgcXSPnhT8HRDdzFZDT+PpAim0xZaUPYpfWD+2SLXe5lIIrxTkJK1JDwuIlAgTllXQjUyg2kR695YMkLBXLaRhLTK7LDLTuAyIBk9SJIGUpxoe6Ha6zedy3GtLX8gDZIbukUG9zAf1OzDiQlvHs7rmO7liAKYsaKN1Bze362T+vT+4SdQ57kumABdCN5qqsusHxLKtLTlXsy2
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1046cf3-c501-4b57-3892-08d814b73d97
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2020 01:14:11.5457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cctLywiMkuljfWumdTx4eEVPMp9axFW0fu7oZIhkeXvQbyZ/ZLR+mX7Qu52iRTn4BqWshhEnUSakEELQWU+mCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0201MB3605
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

Thank you for the patch.


> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Thursday 18 June 2020 02:15
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: John Hubbard <jhubbard@nvidia.com>; Derek Kiernan <dkiernan@xilinx.co=
m>; Dragan Cvetic <draganc@xilinx.com>; Arnd
> Bergmann <arnd@arndb.de>; Greg Kroah-Hartman <gregkh@linuxfoundation.org>=
; Michal Simek <michals@xilinx.com>; linux-arm-
> kernel@lists.infradead.org; Sasha Levin <sashal@kernel.org>
> Subject: [PATCH AUTOSEL 5.4 199/266] misc: xilinx-sdfec: improve get_user=
_pages_fast() error handling
>=20
> From: John Hubbard <jhubbard@nvidia.com>
>=20
> [ Upstream commit 57343d51613227373759f5b0f2eede257fd4b82e ]
>=20
> This fixes the case of get_user_pages_fast() returning a -errno.
> The result needs to be stored in a signed integer. And for safe
> signed/unsigned comparisons, it's best to keep everything signed.
> And get_user_pages_fast() also expects a signed value for number
> of pages to pin.
>=20
> Therefore, change most relevant variables, from u32 to int. Leave
> "n" unsigned, for convenience in checking for overflow. And provide
> a WARN_ON_ONCE() and early return, if overflow occurs.
>=20
> Also, as long as we're tidying up: rename the page array from page,
> to pages, in order to match the conventions used in most other call
> sites.
>=20
> Fixes: 20ec628e8007e ("misc: xilinx_sdfec: Add ability to configure LDPC"=
)
> Cc: Derek Kiernan <derek.kiernan@xilinx.com>
> Cc: Dragan Cvetic <dragan.cvetic@xilinx.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Michal Simek <michal.simek@xilinx.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> Link: https://lore.kernel.org/r/20200527012628.1100649-2-jhubbard@nvidia.=
com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/misc/xilinx_sdfec.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/misc/xilinx_sdfec.c b/drivers/misc/xilinx_sdfec.c
> index 48ba7e02bed7..d4c14b617201 100644
> --- a/drivers/misc/xilinx_sdfec.c
> +++ b/drivers/misc/xilinx_sdfec.c
> @@ -602,10 +602,10 @@ static int xsdfec_table_write(struct xsdfec_dev *xs=
dfec, u32 offset,
>  			      const u32 depth)
>  {
>  	u32 reg =3D 0;
> -	u32 res;
> -	u32 n, i;
> +	int res, i, nr_pages;
> +	u32 n;
>  	u32 *addr =3D NULL;
> -	struct page *page[MAX_NUM_PAGES];
> +	struct page *pages[MAX_NUM_PAGES];
>=20
>  	/*
>  	 * Writes that go beyond the length of
> @@ -622,15 +622,22 @@ static int xsdfec_table_write(struct xsdfec_dev *xs=
dfec, u32 offset,
>  	if ((len * XSDFEC_REG_WIDTH_JUMP) % PAGE_SIZE)
>  		n +=3D 1;
>=20
> -	res =3D get_user_pages_fast((unsigned long)src_ptr, n, 0, page);
> -	if (res < n) {
> -		for (i =3D 0; i < res; i++)
> -			put_page(page[i]);
> +	if (WARN_ON_ONCE(n > INT_MAX))
> +		return -EINVAL;
> +
> +	nr_pages =3D n;
> +
> +	res =3D get_user_pages_fast((unsigned long)src_ptr, nr_pages, 0, pages)=
;
> +	if (res < nr_pages) {
> +		if (res > 0) {
> +			for (i =3D 0; i < res; i++)
> +				put_page(pages[i]);
> +		}
>  		return -EINVAL;
>  	}
>=20
> -	for (i =3D 0; i < n; i++) {
> -		addr =3D kmap(page[i]);
> +	for (i =3D 0; i < nr_pages; i++) {
> +		addr =3D kmap(pages[i]);
>  		do {
>  			xsdfec_regwrite(xsdfec,
>  					base_addr + ((offset + reg) *
> @@ -639,7 +646,7 @@ static int xsdfec_table_write(struct xsdfec_dev *xsdf=
ec, u32 offset,
>  			reg++;
>  		} while ((reg < len) &&
>  			 ((reg * XSDFEC_REG_WIDTH_JUMP) % PAGE_SIZE));
> -		put_page(page[i]);
> +		put_page(pages[i]);
>  	}
>  	return reg;
>  }
> --
> 2.25.1

Acked-by: Dragan Cvetic <dragan.cvetic@xilinx.com>

Regards
Dragan
