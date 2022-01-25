Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C4F49B07C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 10:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574886AbiAYJhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 04:37:00 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30266 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1573990AbiAYJbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 04:31:00 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20P3LCfv012250;
        Tue, 25 Jan 2022 01:30:56 -0800
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3dt97n11b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 01:30:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AeeRonGqRH3k83ls12AB1H3l9nZGdme7nMrmx7fINkBPEpUco2y856RNvevPBec85pIjsAU7YUknC1f5dkfTIYei1SZHiPftc44i2rSwPc7PAGHk8SLDGc2g6dWOW0aXJiw4AdxdVIv0eaN+N42b9/DNU/MOF3R2fRYjAy7aMxlyRlYJx8VKAXpU870WQ8j1ohe3cn9uXPvJuzPjsSUS6VJ59q1VJGFUwyyE/Zhv7TQsoXz6wWvVpoUloMy10FE8myFBJlaI4Mev2jVX1lP/GkBxbxN18V2kq4hHvYtdDGpWsetWXviSvm9H5YqyyVjumxKRMO3QjPePTqZ/EO5anA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHKnBPJtKk5Dy5Df9Gl8SM9jn+t1whtULC+ZsdPtrm0=;
 b=Zw8KqUMSJ/mqdGlrEQB3pH8AUHVTycx+1LfNJxqj+RMIKoCViHIKv8gA2HKTVym+DZhNaoa4VY9FhnAtoYooESNtJO6GSeHO15ateQpW1ETIaTUz9hDc72fZwx3+lBZjryYn3Z6TzlZZEG9lww3FD7NiD06URJAvkztC43ESa/7ULefbEDpG0gKQqRvl43bRgVnj0Tocgg24un7CkFW4IK636lguCF/T6Sh/WyJZz5nnHT1yGMsFjogU+8l4T8/mmXqINAuB6FfK2elFEYoNQLurtEUXh+bp9EkwkmaVEbB5x1stM6fL/RXdXWkor9HtMBFX0iulPTMnlIO2h9n9dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHKnBPJtKk5Dy5Df9Gl8SM9jn+t1whtULC+ZsdPtrm0=;
 b=TSS2QKsPHZeo6ZNbvvAyhcETRDTbg+GHdovmA3wQPingH+yNl29clEMz8ajOz0B3RDB3mL4cWXM1IQa/xH9600NVrbc+vd8QcfH4avq6W+KgBTMKuSypgwPoXZEvZC3bNB23+UtnjGoJ6deJZi7a8XKVQlwO4nzNYWmShkg+9SU=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by BY5PR18MB3345.namprd18.prod.outlook.com (2603:10b6:a03:1ae::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 25 Jan
 2022 09:30:53 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::94cd:c7d4:4871:7612]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::94cd:c7d4:4871:7612%5]) with mapi id 15.20.4930.015; Tue, 25 Jan 2022
 09:30:53 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXT] FAILED: patch "[PATCH] bnx2x: Invalidate fastpath HSI
 version for VFs" failed to apply to 5.10-stable tree
Thread-Topic: [EXT] FAILED: patch "[PATCH] bnx2x: Invalidate fastpath HSI
 version for VFs" failed to apply to 5.10-stable tree
Thread-Index: AQHYESxAW7FO81wk7EeiH9+IHKZ2pKxzd4DA
Date:   Tue, 25 Jan 2022 09:30:53 +0000
Message-ID: <BY3PR18MB4612CDF3D37F516764972650AB5F9@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <164303346429105@kroah.com>
In-Reply-To: <164303346429105@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59498764-e0db-43cb-d169-08d9dfe561cf
x-ms-traffictypediagnostic: BY5PR18MB3345:EE_
x-microsoft-antispam-prvs: <BY5PR18MB334538E9D49429A7947BFE64AB5F9@BY5PR18MB3345.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BJTEpMPsCWYNyatGj3dJcb7TyqWxXfdcWXZji+iF3iYSeh3wBuCmlq8Zv1Nt+0LTCQDdlCEbuMREIU7Wilmod08UUU4ySY3Nok+jLPkpiohqzx8u0PjXK0cX2N5xFta5ajv4MUk5oQiuJ99Aa14/GaZXuequP5bGP3ZKmf7wtxlvk8NAN80z8gYjfPj7uMzNLy5zplsSjngeKCfFKDN582uHIQyGNsqI1bc+ar8vjC3ZxomCLgmehnGC1FeP8lNQZOdupJl9uh056virbAYT+1qmkBo8f7U220O+Ks7wDwkyuNRAJOjnVZuHPkYKBy4vVbYCkcuKn+fpHkZhRntytgWwyFtNvrDItzZfubbFQxZ1DWvlGeAvWQ3gXzq9qXYabZukwbmEbtMZ7TMiBp8exWFTM2UiuS6Ghsn1RqhuYUsmwtIfCkIRytnpDNNGlaETzrkwUUL4EIOJYOz+qBgBHFg0Wng+ipJJJ6WId6dWpgTt5APVkFOH704wynNvOlLbLnj1VOzqsCQE+DhY+DNiwXAEGFcCeJp/zYbwFRm/xcQcHz6abP4Ea38eoil1PKqGWsNWgzhM837HeWvt4V0DzqxjI4WYZXAS0CnBIDBHuAxjcBT+7VhpBosyj0hTSd05IY/u32k0dChM7M7jugyHDz2xsnfJhVHaG1lvW9rOzD5GkP9own56+pyzWtTylYlKvNW3qeMLNgtHqjmLhcRbqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(38100700002)(2906002)(76116006)(66946007)(66556008)(66476007)(64756008)(8676002)(66446008)(8936002)(33656002)(5660300002)(55016003)(4326008)(52536014)(9686003)(86362001)(316002)(110136005)(7696005)(6506007)(38070700005)(71200400001)(6636002)(53546011)(83380400001)(508600001)(122000001)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qSexmwy9Z3klacAiyxKyq97fmg5mGPwP0HqRID4iZU5ycywtvib1YLqU63fF?=
 =?us-ascii?Q?1nuKaKX5sT/F96EIQPXBsfDHIQz42EHVcwLThKK3zLz6QNaEUJ+hi8vmzGq3?=
 =?us-ascii?Q?zX8C2CLuV6NI00dGNjmD2lOCwfprZbmrzQFXy4UIX4wcViOXHNf6lP/xP23I?=
 =?us-ascii?Q?L2JaUSvycQ/BfTZ/k8K93C4VDCwQm4ugXJ3jOiXCd+JL5gZTWoe/rDnd15fW?=
 =?us-ascii?Q?OaWUNvWb1hS4E51zKnZrRyxtQ7DASzj8cXvhKrZvsuumfADnLTa/HDzpFL3s?=
 =?us-ascii?Q?dHvnDF8SZ+L9hscr4hy6BXU1tiotKCJ1Jrs0mEXchDnyW+w2xRpBZrRWQYfS?=
 =?us-ascii?Q?mNLPr1SNmUgIcn4QcUc2YCPMvHvYRN1FFjn6ufMO8l9vTfU6IZTO6VOflH8S?=
 =?us-ascii?Q?/pSB2TrAI8wYtrjidXUsg7/WUmmZm/0eYydI0yPxmC/GzRFvmd6r7RsLTDFI?=
 =?us-ascii?Q?Yve/Nc9JbyI6iB6lNHlqurlqGoCtl212W22dXF95cR76JwQeOC1KkSUPbiCB?=
 =?us-ascii?Q?SJNiLx9I5TmEjdVNF8SiSW0IFbsjDrYClwFXdXXum36AAZClhalTRvn+o39n?=
 =?us-ascii?Q?LHOy0PNmUJtwvHesje6mugonrVTbEGUOiRkaJNUB9SdQyA6Rm9+CoIxYOt5V?=
 =?us-ascii?Q?OLcf9oO6sq1f+96T+Jie2iBWzEV9Hlxq4Y2KATJa4WvZnT4nSITU9YNGDJpI?=
 =?us-ascii?Q?EjbmT+OUlOtgas4m+4hhtJ8TQNg8TW1dnXiZsJkMsqstzPbLP3SGsem/eBGc?=
 =?us-ascii?Q?q1fHqAF9SCt4eEHx679g+SOEgKjY4OxauaYsnSswHmox8GGtpWi7NpyOFYXO?=
 =?us-ascii?Q?8BgS8Nxn6t0KsI31ljRY08fnUSIz7Xe+okd2+0O+eyRJH1iHkJj7+SVyLSgH?=
 =?us-ascii?Q?B/MPloHVdLWknfxton/jwXKBIAudZU4KnTRdqI8vAWTqH/PkNUjOijFAAFC8?=
 =?us-ascii?Q?yToNE9xib3sAQsP/x4AGrSR4txx+cazt0U/Qnq9yhMoHabeukYuObcQ4Z/yF?=
 =?us-ascii?Q?pMKH7n0mcvd5iPy4OOYEM9rpJZTj/5WzVHl0WDzFzJxNj6BLnZk2hR1QqGvE?=
 =?us-ascii?Q?SF0qNUxdNqO/uHDUU7kuRjqg7LTpVa9vwpw6dUAAV8Dwy++Im5TmFiONE14R?=
 =?us-ascii?Q?ihxjVCQ5eo6G7UAK9GJSlWg9Y2v+w44W8Teimt/5UZUaz5x4VnrqKfb22nc2?=
 =?us-ascii?Q?stf94PoxNmzYsZGx/dik8YJxvJIUmadMIh6F1m8GoYzH0MfrF7tKMn6XV1cW?=
 =?us-ascii?Q?pwj3br2NtVRuvRArCt9B2e/7wYygK3mDL5c2TTYdq1PTxa8qUkCovYWZkaFb?=
 =?us-ascii?Q?YJ7kcBuikzLtHNnXwDj5kya2uHmJGA/IPIIero0uUqsj8YYMHQKzBNTHwYU6?=
 =?us-ascii?Q?AMRzscjhgWdXU3AciGWOnlg/LXq9ewRFCv6lR5bpkRnH0cKF4/Rs2APqWzG8?=
 =?us-ascii?Q?82tAnOAKGXRNzhb93PQGIQce2eol1mSVQr9RYX5HfJjiaY8pvkDkqWWHgY9V?=
 =?us-ascii?Q?uKzo6TT9IAroZ6uk+Oyg+etQUjZKbEQ27BfRVUcBBtFypB+wCmXRwwdyoq/d?=
 =?us-ascii?Q?6YTJ55KaUfdh20QaxrHi40+U/R8JuApzVhswL/lprWfI/57zAIEdVDlXtuak?=
 =?us-ascii?Q?aw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59498764-e0db-43cb-d169-08d9dfe561cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 09:30:53.0196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: edg86/QOX/O/50Q2kb4ZvG2Gg8Z+kdVYyf5e1Zv1OAMrcSrp2CXG64kjmTb06PvCZ7hXHIsO3WcGrkIz+M/xGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3345
X-Proofpoint-ORIG-GUID: 5hryn3eKgeGVLYaPU9c3ClqnAJkd5p8i
X-Proofpoint-GUID: 5hryn3eKgeGVLYaPU9c3ClqnAJkd5p8i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_02,2022-01-24_02,2021-12-02_01
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Monday, January 24, 2022 7:41 PM
> To: Manish Chopra <manishc@marvell.com>; Ariel Elior
> <aelior@marvell.com>; davem@davemloft.net; Alok Prasad
> <palok@marvell.com>; Prabhakar Kushwaha <pkushwaha@marvell.com>
> Cc: stable@vger.kernel.org
> Subject: [EXT] FAILED: patch "[PATCH] bnx2x: Invalidate fastpath HSI vers=
ion
> for VFs" failed to apply to 5.10-stable tree
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm tre=
e,
> then please email the backport, including the original git commit id to
> <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 802d4d207e75d7208ff75adb712b556c1e91cf1c Mon Sep 17 00:00:00
> 2001
> From: Manish Chopra <manishc@marvell.com>
> Date: Fri, 17 Dec 2021 08:55:52 -0800
> Subject: [PATCH] bnx2x: Invalidate fastpath HSI version for VFs
>=20
> Commit 0a6890b9b4df ("bnx2x: Utilize FW 7.13.15.0.") added validation for
> fastpath HSI versions for different client init which was not meant for S=
R-IOV
> VF clients, which resulted in firmware asserts when running VF clients wi=
th
> different fastpath HSI version.
>=20
> This patch along with the new firmware support in patch #1 fixes this beh=
avior
> in order to not validate fastpath HSI version for the VFs.
>=20
> Fixes: 0a6890b9b4df ("bnx2x: Utilize FW 7.13.15.0.")
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> index 74a8931ce1d1..11d15cd03600 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> @@ -758,9 +758,18 @@ static void bnx2x_vf_igu_reset(struct bnx2x *bp,
> struct bnx2x_virtf *vf)
>=20
>  void bnx2x_vf_enable_access(struct bnx2x *bp, u8 abs_vfid)  {
> +	u16 abs_fid;
> +
> +	abs_fid =3D FW_VF_HANDLE(abs_vfid);
> +
>  	/* set the VF-PF association in the FW */
> -	storm_memset_vf_to_pf(bp, FW_VF_HANDLE(abs_vfid),
> BP_FUNC(bp));
> -	storm_memset_func_en(bp, FW_VF_HANDLE(abs_vfid), 1);
> +	storm_memset_vf_to_pf(bp, abs_fid, BP_FUNC(bp));
> +	storm_memset_func_en(bp, abs_fid, 1);
> +
> +	/* Invalidate fp_hsi version for vfs */
> +	if (bp->fw_cap & FW_CAP_INVALIDATE_VF_FP_HSI)
> +		REG_WR8(bp, BAR_XSTRORM_INTMEM +
> +
> XSTORM_ETH_FUNCTION_INFO_FP_HSI_VALID_E2_OFFSET(abs_fid), 0);
>=20
>  	/* clear vf errors*/
>  	bnx2x_vf_semi_clear_err(bp, abs_vfid);

Hello Greg,

Although this patch fixes the actual issue but the patch is dependent on be=
low patch as those were part of same series, due to this it fails to apply =
probably.

commit b7a49f73059fe6147b6b78e8f674ce0d21237432
Author: Manish Chopra <manishc@marvell.com>
Date:   Fri Dec 17 08:55:51 2021 -0800

    bnx2x: Utilize firmware 7.13.21.0

    This new firmware addresses few important issues and enhancements
    as mentioned below -

    - Support direct invalidation of FP HSI Ver per function ID, required f=
or
      invalidating FP HSI Ver prior to each VF start, as there is no VF sta=
rt
    - BRB hardware block parity error detection support for the driver
    - Fix the FCOE underrun flow
    - Fix PSOD during FCoE BFS over the NIC ports after preboot driver
    - Maintains backward compatibility

    This patch incorporates this new firmware 7.13.21.0 in bnx2x driver.

    Signed-off-by: Manish Chopra <manishc@marvell.com>
    Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
    Signed-off-by: Alok Prasad <palok@marvell.com>
    Signed-off-by: Ariel Elior <aelior@marvell.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks,
Manish=20
