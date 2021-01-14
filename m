Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5143D2F56C2
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 02:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbhANBw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 20:52:59 -0500
Received: from mail-eopbgr1310084.outbound.protection.outlook.com ([40.107.131.84]:30991
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727293AbhANBwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 20:52:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfbhPR1FjSaObN3CIMqC3Uc2tHWGUFsB2jY5YoFV0hISx7/ae76TSvIpdClrXdcID60isXK/wNI0IzEPfiOOOw8hwyiY7sH6KDTgDgmIcbGo5rCpfJsF2aQqo+scYyk62/TxMOn2x7EeVJEE7JLMktO+LuLQKo/Ebs2LRCbXQ15UVtHwDGxeEVH4a79QL53C3mjClhfNQ9T+odDE7txqUBmCwx5ibCjBYn9nBwPRFWxS80ZV81F5f4P7a5nG3OpyNwbbraKLGktH2WEMiBpnJJZP20OMNfF6FDFpHVQaAGjFIjsTXvBAI4sfSowEsx0XAJdCLdp5vVq8FEIW8j+BPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kM/q6TF+NCyW9DrUCtrprUHkZFAzrkt4+MOq23S903E=;
 b=V7lUTcr/zahB3zMEXSEeUNiz6jEUMneO9u/NKp5wMdmLvoKLX99FcBakwBDjx2ZrErzZHseeiYw8ywrtS1hBuiin7+EKs4ql9jn4U38Br05bjjKAAi57d09MK8DKD4l75U0K9/pPc398mTrvAvP9fPcEScgPNvOLx+Y8lp0ZYCSH/2t3mSHrpb4pnvnbU67o8tpfG9OUFjJfOAOGXRTKxyWVVpo/LZ+J3ZKYXxQsTUKf7+0pcCnPqcjroEj3JtybBqBbyRaBNMaeJkcPnjd5MvKmztdhaSLNl1AAQGfpEfzUEO61T2bRPVVid2oWANFABRqwD72EdfrHl3BtZ/NCEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kM/q6TF+NCyW9DrUCtrprUHkZFAzrkt4+MOq23S903E=;
 b=ddEly2VpiCCcytnJCJQChwmWSILhqevrp+roRB/eaABm8+1mHUS31JCnx00UcsYV/sG/ZX9CZBbGi7p/Wm064MUnFFs+SUJeV27vM1jTSD7IuDUJMMhb+buzLHQjq9YjCGNYgKlnbGWQFrRYrVOVDttbYCQNf6fIiiwD0jq60Gc=
Received: from TY1PR01MB1852.jpnprd01.prod.outlook.com (2603:1096:403:8::12)
 by TY2PR01MB4812.jpnprd01.prod.outlook.com (2603:1096:404:10e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Thu, 14 Jan
 2021 01:49:45 +0000
Received: from TY1PR01MB1852.jpnprd01.prod.outlook.com
 ([fe80::8453:2ddb:cf2b:d244]) by TY1PR01MB1852.jpnprd01.prod.outlook.com
 ([fe80::8453:2ddb:cf2b:d244%7]) with mapi id 15.20.3763.010; Thu, 14 Jan 2021
 01:49:45 +0000
From:   =?iso-2022-jp?B?SE9SSUdVQ0hJIE5BT1lBKBskQktZOH0hIUQ+TGkbKEIp?= 
        <naoya.horiguchi@nec.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/5] mm: Fix page reference leak in soft_offline_page()
Thread-Topic: [PATCH v4 4/5] mm: Fix page reference leak in
 soft_offline_page()
Thread-Index: AQHW6heInkqG7QE910OSp4LbdxOpwg==
Date:   Thu, 14 Jan 2021 01:49:45 +0000
Message-ID: <20210114014944.GA16873@hori.linux.bs1.fc.nec.co.jp>
References: <161058499000.1840162.702316708443239771.stgit@dwillia2-desk3.amr.corp.intel.com>
 <161058501210.1840162.8108917599181157327.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <161058501210.1840162.8108917599181157327.stgit@dwillia2-desk3.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nec.com;
x-originating-ip: [165.225.110.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db092a07-eda8-46d3-993c-08d8b82eab15
x-ms-traffictypediagnostic: TY2PR01MB4812:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TY2PR01MB4812CF3BDBA3F6492896C3A7E7A80@TY2PR01MB4812.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dIYyUlgQFBNZf8iezHkwsu4u7yx4CiAxuPGOOl1/h7VmHAS9+xGrX5gHBAqMw7IHFO0oDv0HBpxq6c9vwaHRZ43k8v8yVITyuI6/2tYs6ukuDCQy6bimd/HdLisWCGOVB7eaD9UqkkTPyA855YcJ6n8QtCbsC17868Uc+ZBc5CfCncPujH51vtIqzaZV4/Hjz9YQnwgOWa3rXsmyfVlvyEcvcCoP2Gjs88yueJuTDv413uAcAZB0EefD1InBLoy0vrizgRYH+0Tz4ccLoIhz2Hw5wTWr7fk/6+RxIrgB3KUNs+G+f9eXbEe5KXPIHH2fp8COPHs8ZFx9bSNyCbXBa/jWhFl0EybrEj8/6pe9qT47mjusJ4Zfr7tCWpNjJ6FpLa1/oZDZ2ztrobQJSgxSQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1852.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(9686003)(7416002)(6916009)(6512007)(26005)(186003)(478600001)(55236004)(64756008)(66476007)(5660300002)(66446008)(66556008)(8936002)(4326008)(33656002)(83380400001)(8676002)(6506007)(316002)(54906003)(2906002)(71200400001)(85182001)(76116006)(66946007)(86362001)(1076003)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-2022-jp?B?OE1waGcxaEREV29leUlnRHBjcnkybnV3YncwNi9BVHNjelhCU1pMVmZ2?=
 =?iso-2022-jp?B?K1dIc1daUFFSaGtkdjVoMmZGWXRycDNFM0dBNnhGSDNpVDF1ZzJybFJE?=
 =?iso-2022-jp?B?SlQxRWZjMjROczdtLzNyeXhLTzIzOGd4Tnc2WklBQk9EZnRJN2lMUVhT?=
 =?iso-2022-jp?B?WkxBL1hYZklqbmpPZStWNXlUQ284N3hFT0pnSGRwbVBsdjRycmZYVmJx?=
 =?iso-2022-jp?B?clZDL0JnQTFseHh4ZVlENzAwenhTUU5KTmNnQitxQWV1SVYzMmluYVZW?=
 =?iso-2022-jp?B?TzdBc0pSUlVoOXRNTjRlOXFSckZWSDVqVHJkOXRGZW0yZGNycmZRZ1Ro?=
 =?iso-2022-jp?B?SUx5Tm0yUElPUUhDcnlTTmx4VFhHbTZha3dqNEoyaG1BM3VQOHhkSEpD?=
 =?iso-2022-jp?B?dmdIbzlQV2ZXTlViUHYzRUhHT21rNGd5YWE4RUlkTVJuakZKRVU0SnQ0?=
 =?iso-2022-jp?B?ZmlUQnN5QS83YzdCZ2pDZjJ0YllUZFhZNERnUU1STGN6bWRHeEprWm5G?=
 =?iso-2022-jp?B?dUlmZkVVa3V6dEdZaWxHekYwK21VcG1ybE5VZkZrRmp5YmcySUtFc3NM?=
 =?iso-2022-jp?B?bVV1NEVua3ZHVnpTNzk3VURUM0hIckdsdDhVSDBXY2NhMUs2QXVKVzBB?=
 =?iso-2022-jp?B?VHRycVFHY0Y0clo3bUhuNEc3bmtnclFrYUF5MVBzeFdQbTN1K1RESmhs?=
 =?iso-2022-jp?B?dmNUb2VDd2N5NTZkQjljbmQ0Qi8yUytsYjA4Q3o0WHhGMW1DSVJHdzMy?=
 =?iso-2022-jp?B?dWVhc0dKSW1QejZ3OGdteEMyL0pTd2UvM0VRbDlJSzFZYXVWRFlrSHlD?=
 =?iso-2022-jp?B?by8xM1pDWTlaa3BIeDlEZ0ZSbi8wellIS08rMFFRV2FYY2pROEU1Z3ln?=
 =?iso-2022-jp?B?ZGpiOXozRU5Pa3RBczF3cS9xcmxsUzRIVlBjUklwNFRUTGhWcTF3a29x?=
 =?iso-2022-jp?B?ZitsTjAza3B1NEFlTEwwVDdHVCsycG5SOVFnaGpTQnQ3WkdZTVBmMFY1?=
 =?iso-2022-jp?B?aGFHaGROeXcvbjV0cWJ3YjZVZVhqeTJVM0hnK3pidnByUWt3N3hHV0J3?=
 =?iso-2022-jp?B?bUlIaDY5S2lzRWtBcUhNUnlSVWtGYmExdWtDaHhsUG4rbndDOVUvN0Fw?=
 =?iso-2022-jp?B?ajYrTlNRamtXTlZYSDdQRmdzbTNrazdFVXE1ZXdwVzJRNy9rZXNBaGlR?=
 =?iso-2022-jp?B?WGgrNVZuTTlyMUR5YktybVZNSGJTQThoS3BpMGNzd2lkOWpFREdEVW1l?=
 =?iso-2022-jp?B?a3VTMnhmSzZFdSt1Zm5rRjJtd2R6V25DdFkwblo1WlR5RmxGTFdZdkVt?=
 =?iso-2022-jp?B?TzRoUDVMQnFVNzVGREdiOC8yeU03M25OM2Npd252RjRjMCtCdEJGalh5?=
 =?iso-2022-jp?B?OXpiTGp1VVVzZy91dDJHdWtOUkpqTFJGcHNuYUdJZUx1VGFqZVJCd0kz?=
 =?iso-2022-jp?B?bU45YWRIRDlleWhiZkgrMg==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <45AEC839EF13FB4984DA5869108D5510@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1852.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db092a07-eda8-46d3-993c-08d8b82eab15
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 01:49:45.0811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EBbKCqF1lzsPhgStIKJQriHVRyWRdUwjrqGoU5iQbqDux/g6mo/G1rjFXz1ktl2tqTXhadoscgbDit/qmf0PvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB4812
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 04:43:32PM -0800, Dan Williams wrote:
> The conversion to move pfn_to_online_page() internal to
> soft_offline_page() missed that the get_user_pages() reference taken by
> the madvise() path needs to be dropped when pfn_to_online_page() fails.
> Note the direct sysfs-path to soft_offline_page() does not perform a
> get_user_pages() lookup.
>=20
> When soft_offline_page() is handed a pfn_valid() &&
> !pfn_to_online_page() pfn the kernel hangs at dax-device shutdown due to
> a leaked reference.
>=20
> Fixes: feec24a6139d ("mm, soft-offline: convert parameter to pfn")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I'm OK if we don't have any other better approach, but the proposed changes
make code a little messy, and I feel that get_user_pages() might be the
right place to fix. Is get_user_pages() expected to return struct page with
holding refcount for offline valid pages?  I thought that such pages are
only used by drivers for dax-devices, but that might be wrong. Can I ask fo=
r
a little more explanation from this perspective?

Thanks,
Naoya Horiguchi

> ---
>  mm/memory-failure.c |   20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>=20
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 5a38e9eade94..78b173c7190c 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1885,6 +1885,12 @@ static int soft_offline_free_page(struct page *pag=
e)
>  	return rc;
>  }
> =20
> +static void put_ref_page(struct page *page)
> +{
> +	if (page)
> +		put_page(page);
> +}
> +
>  /**
>   * soft_offline_page - Soft offline a page.
>   * @pfn: pfn to soft-offline
> @@ -1910,20 +1916,26 @@ static int soft_offline_free_page(struct page *pa=
ge)
>  int soft_offline_page(unsigned long pfn, int flags)
>  {
>  	int ret;
> -	struct page *page;
>  	bool try_again =3D true;
> +	struct page *page, *ref_page =3D NULL;
> +
> +	WARN_ON_ONCE(!pfn_valid(pfn) && (flags & MF_COUNT_INCREASED));
> =20
>  	if (!pfn_valid(pfn))
>  		return -ENXIO;
> +	if (flags & MF_COUNT_INCREASED)
> +		ref_page =3D pfn_to_page(pfn);
> +
>  	/* Only online pages can be soft-offlined (esp., not ZONE_DEVICE). */
>  	page =3D pfn_to_online_page(pfn);
> -	if (!page)
> +	if (!page) {
> +		put_ref_page(ref_page);
>  		return -EIO;
> +	}
> =20
>  	if (PageHWPoison(page)) {
>  		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
> -		if (flags & MF_COUNT_INCREASED)
> -			put_page(page);
> +		put_ref_page(ref_page);
>  		return 0;
>  	}
> =20
> =
