Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE5549BBE9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiAYTRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:17:20 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27342 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229722AbiAYTRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:17:19 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PDQukc029141;
        Tue, 25 Jan 2022 11:17:17 -0800
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3dtj3nhbt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 11:17:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBs8dMdkr04ps9kyV/5WnvORVqbxF9LY42G7I/yairsheA9EwJTBwq+yKj3SMZD1Vqajet0KCZAPDh76C7a4bMFag4QFdIzIY6aifR53r0D8GERuYLRV0kcOpEndLVtvbEqcmsW0CLR8CAQiQFtPCn8xcZOSPg8klTqstKXt6Kx6m1gSi93zNlMdDEtaJ8QuaxJDTIjdpVsaLJI8Pf/cgu1BTruhsy52ncGt3a44n0ttDQHuIVPH/nTuXsFPP8FFhTURCgHGgfTLjfFfcGgzFg4dx6TxOLulaw4xs7WciByrnNA1KOKrbkpSNSekmVxqzzY4jNfDbvu7q5xx3AaWiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=myRyzclmKzKbSPGpmqhqP+1XCnBr0vMI0ktgHaS3Qno=;
 b=JzKwKwHFLyby3WyMwlBfHFNrTzPBrzNd7FCg1dwiEpUNaRY4RUPRMqZBMOVXXklEhZ3HYRhhTAOSgYAvfyQqcTO3k6GZvElRtmmO94mA556XL24GBO6rOEYokbNoe1K3rKifR15KjX9p5iklkEk49w1ms/podkSE54mm6W45tJOYj0LYSYFsZ5/TaFReRpLRibJ1AQ4rXt7PH7mPP1sAWra0EoFtlYD0QnQqGvwtzZIhZzfET+SwNFqXpQQPM/ZsaKGqLEuDm3Jc4x2+KOtkcjBA5TLQoGpQGz5bJrhygTM9eUJMN5aXdY3194fUGxfqNIvKCT2GS9pXCC6cqyMM/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=myRyzclmKzKbSPGpmqhqP+1XCnBr0vMI0ktgHaS3Qno=;
 b=BvuJa7W8g/ZiKmq/IRsj+s8Z9zenMROKqwv+Av9/ZxZYE37YtC/D5O/Ncyr1WIJaCMnl6ljsQNh3VA/jBbdQqA+ieZcn8jyzFlz/K4OL6Uydu2zT0QkhiYdgpYrmjB6lnEqo+YVScJSksyx+vfHY2usQBXYYzL3t4q2KQufcHt8=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by SN7PR18MB3903.namprd18.prod.outlook.com (2603:10b6:806:f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Tue, 25 Jan
 2022 19:17:15 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::94cd:c7d4:4871:7612]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::94cd:c7d4:4871:7612%5]) with mapi id 15.20.4930.015; Tue, 25 Jan 2022
 19:17:15 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXT] FAILED: patch "[PATCH] bnx2x: Invalidate fastpath HSI
 version for VFs" failed to apply to 5.10-stable tree
Thread-Topic: [EXT] FAILED: patch "[PATCH] bnx2x: Invalidate fastpath HSI
 version for VFs" failed to apply to 5.10-stable tree
Thread-Index: AQHYESxAW7FO81wk7EeiH9+IHKZ2pKxzd4DAgAASugCAAI6X4A==
Date:   Tue, 25 Jan 2022 19:17:15 +0000
Message-ID: <BY3PR18MB46126A183605747B9550E536AB5F9@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <164303346429105@kroah.com>
 <BY3PR18MB4612CDF3D37F516764972650AB5F9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <Ye/QynAZSyyHdgbQ@kroah.com>
In-Reply-To: <Ye/QynAZSyyHdgbQ@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce6423a8-102c-470c-6035-08d9e0374bfb
x-ms-traffictypediagnostic: SN7PR18MB3903:EE_
x-microsoft-antispam-prvs: <SN7PR18MB3903FC6CFC485F054E1F9B8EAB5F9@SN7PR18MB3903.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WSa55jElEDWoCwjvifBFNoO8mb3rc9Q6i/UpgK0zxX408lnwSzLVaC1nZmMht/Ui5MlgJglDMg4uL4v/2dOnAyoaMrFfSziatf5NlcFtVCgLujjCeWTscp/frn5tpa2jEtQrMb+iQUSHqlYlMw9+ol8EtQ0FWOGrmfmBnoe0iOdoy+gu1gzy2aMw63Ac6lOTY1R+1ke+kHjkWhs5s2cyw9xtTVCOfLPoYu+DQ0CHFCuZZNtXfC7dutDQq+xKuKRRAkIiiKbNRHBZ4t9urbyKJ4eGjWD+fKfQB/z6NYTEj+be4qqSwlINq9VyQ6yq7QlMg4ypfUoE3Lez31P3DE8Wo8CWuESzHUYatXq8JsSj2+w1AnabbiekxPexJKQOsLQ5SNmZuJJ3wjjrcjd6iwdENV+vipMXnmsLTMZe8nMKQoxBuxddJFvw1zx5VansTucETU7D6ek5efvDNL7NIswJlydOV629f0/QtndvVuLo1jhZtVjUlSoWIgVKdFR3Q8OWnkcROp79P/Bs1gX9tpYxBHlaOSOIZj4Jq/rozLPAwrd0OQ9CgNf49WiaV4fOZ7VdoUULuAPGQFWyRyyKOrSX/k0rUWsrFt+amWiP2GIWYh0SHe0KTT3hF3dp0TXIp21blTsN3ukO0biEEMQIirgVUhUvxtw58g4BtkGt39fiH98yMXhy2GVuWx62uApMokQDl/3WwXpgI+c03tDZCF5RXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(122000001)(54906003)(76116006)(71200400001)(38100700002)(8676002)(4326008)(83380400001)(52536014)(6506007)(33656002)(316002)(508600001)(86362001)(9686003)(66476007)(66446008)(64756008)(55016003)(6916009)(7696005)(186003)(66556008)(2906002)(38070700005)(66946007)(5660300002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AqUFY4etw1SQnct+c01NIs/RmblDUuo7RAxHpWDE52n2ADbteoPtF3CTg5q5?=
 =?us-ascii?Q?ERv7RDM0pzQyv3+nA5NWVrDrZdthyCbNbDjD+S5rz2IWtINlJ8nH3P+HCyjI?=
 =?us-ascii?Q?lR4HPPm2icHu3gU33Oeaxpi3pGap1u6O54EeW2eQgDxO2zDHJGZftfzya+pP?=
 =?us-ascii?Q?rTtLmO4GcVnVPob/DOnFygWEyks2MdrE8vK4feBAdvfQU7B1y+CeYHQKL3zY?=
 =?us-ascii?Q?iq0TCS/IwZTpppAFl2FDqlKkzmuhk/zwltT4vkdncOeYqSwspU14SUq39Kx1?=
 =?us-ascii?Q?J820VI2k7TurAbRhgSAq7spFqE/7JqXgxl5LHQ0t8eE/+CzIqEWCQO9a4WmP?=
 =?us-ascii?Q?Vvif5B7mq9XNXc/ohMQAjk0QppSaOZ76zpIn515xL3QQxEp8Nxrhm2crgJ7v?=
 =?us-ascii?Q?1tc5h03dM9effX9zwQZDL9KYTGsjXWL9/z2YqKD0oCkOGkac5A3AjQMNg05L?=
 =?us-ascii?Q?zu5medhx/+abuDRHEdRKvcevHcTTTQwFLPXO4hWgSBkIKUcjHlN/tySf6lAu?=
 =?us-ascii?Q?+fPNXAbB0lEqUV8hPaVBR1n7pO4LfPbRNQjTxrlBQVxt3e3yq6BpyoQJ7eDO?=
 =?us-ascii?Q?p88kKYlk4NSnNRrrzKEtwLwC8VgNOSSmIQHS/8kNeSjXJWksNm6uSPfc3o93?=
 =?us-ascii?Q?klUG7SvO0oZ/dS1HatP1ZZrXFJChLYVjW+34hq3mNKBmohgHxB7YnB8yZ12c?=
 =?us-ascii?Q?u2JpHguwurQqEt6pcLbLGIJKs+VgQN8AcCWSzJFyF8tsDaP+XfGezDQGI8dn?=
 =?us-ascii?Q?nrrSwqWh0AaIKFXNxPu0YGKpwxxOsJ+9OUGLH81UEWHeVMYLwzRm5t0Q9lgH?=
 =?us-ascii?Q?fYwjqsyLDijlVdqT5V25WkGuVfsqK363UKEXRUzfhFS6/wIvQISy8MwW4TUr?=
 =?us-ascii?Q?+CYhdlG8H808srJM9US4xtwIi7B5ri3yLGtoOLdSeRwVMh7NaXdtsT3z6ABt?=
 =?us-ascii?Q?MSZDodX9sPeblMQzv3sHNpkIN0Ch6+Oiq5r6cCs3x0Oco13128qXUp6JQnAg?=
 =?us-ascii?Q?gFH87mjxkQL0ZiVrD9m6SuX/+YrRuQSo3Zj7YRGk15zz7jow94mR/K20s+oB?=
 =?us-ascii?Q?9BorOJELoR4hVqCx/ot0nqnxxNBxiYE8/IoEiw2nI0CX8Kf7PHgBLHrg4cZH?=
 =?us-ascii?Q?loigOhyXEhWfJu+L2dilEGp45YP8+cTG5V1ySqqhRa0zFrOPJTaieggSF1cb?=
 =?us-ascii?Q?4lOpQ/XHsH5pKgkqIPMcDQRqd3WUmeJGHEVoS1rMf4YiApUYESFrTkmAqL/z?=
 =?us-ascii?Q?Za7iZ14wFHJhNzfhm1Wld3ln8fKaEQDECmbElqXIpUANlr+Fkz/uVDPuyf8f?=
 =?us-ascii?Q?9V+5Xb2GeDwy9KSvYyAvG8y+otxATt+GFdvY5Wd7uD7geZRc9tO0gug1hkb3?=
 =?us-ascii?Q?XGHRktuLbDkgGeYZ1+H0CwzYUsnRGiMJjEnChvVAvg2piDZizHUsHOg/6wfp?=
 =?us-ascii?Q?NU1BeB3ki29nqX7x6P7RmfGWC4krmj+ieh+uCzRKFpWErotJnhXdtDP0L/WH?=
 =?us-ascii?Q?aNKPvaPqwZs1dtGQX8gWg0lCmcU3mk42UDV6mAlnwXmBsyhctGXI0pRMgaNY?=
 =?us-ascii?Q?pbCAw37romGzHgW8HZQGUHdUTo0JXw5ZhWFAupaYJFyEXw4eun99YmhbaZ7z?=
 =?us-ascii?Q?SFz8INYcJK2k61ZYRJZr38PWfG5A+b6NNQSl9nDW74H7pPbcHAoqrKAa/Tdj?=
 =?us-ascii?Q?gKDJkA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce6423a8-102c-470c-6035-08d9e0374bfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 19:17:15.1425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /sBRiKKu9sn6uYrM0fZgvz0ia+bOUn86TQ3+ScWmJMBqzJhBTebkqd7a1xzXaK9ISM1FdUKypj4Dn0qBRjb6Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB3903
X-Proofpoint-GUID: wcpmiNgIUQ3FSYsZGibWRL8UI4kqmVqF
X-Proofpoint-ORIG-GUID: wcpmiNgIUQ3FSYsZGibWRL8UI4kqmVqF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_04,2022-01-25_02,2021-12-02_01
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Tuesday, January 25, 2022 3:58 PM
> To: Manish Chopra <manishc@marvell.com>
> Cc: Ariel Elior <aelior@marvell.com>; davem@davemloft.net; Alok Prasad
> <palok@marvell.com>; Prabhakar Kushwaha <pkushwaha@marvell.com>;
> stable@vger.kernel.org
> Subject: Re: [EXT] FAILED: patch "[PATCH] bnx2x: Invalidate fastpath HSI
> version for VFs" failed to apply to 5.10-stable tree
>=20
> On Tue, Jan 25, 2022 at 09:30:53AM +0000, Manish Chopra wrote:
> > > -----Original Message-----
> > > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > > Sent: Monday, January 24, 2022 7:41 PM
> > > To: Manish Chopra <manishc@marvell.com>; Ariel Elior
> > > <aelior@marvell.com>; davem@davemloft.net; Alok Prasad
> > > <palok@marvell.com>; Prabhakar Kushwaha <pkushwaha@marvell.com>
> > > Cc: stable@vger.kernel.org
> > > Subject: [EXT] FAILED: patch "[PATCH] bnx2x: Invalidate fastpath HSI
> > > version for VFs" failed to apply to 5.10-stable tree
> > >
> > > External Email
> > >
> > > --------------------------------------------------------------------
> > > --
> > >
> > > The patch below does not apply to the 5.10-stable tree.
> > > If someone wants it applied there, or to any other stable or
> > > longterm tree, then please email the backport, including the
> > > original git commit id to <stable@vger.kernel.org>.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > > ------------------ original commit in Linus's tree
> > > ------------------
> > >
> > > From 802d4d207e75d7208ff75adb712b556c1e91cf1c Mon Sep 17
> 00:00:00
> > > 2001
> > > From: Manish Chopra <manishc@marvell.com>
> > > Date: Fri, 17 Dec 2021 08:55:52 -0800
> > > Subject: [PATCH] bnx2x: Invalidate fastpath HSI version for VFs
> > >
> > > Commit 0a6890b9b4df ("bnx2x: Utilize FW 7.13.15.0.") added
> > > validation for fastpath HSI versions for different client init which
> > > was not meant for SR-IOV VF clients, which resulted in firmware
> > > asserts when running VF clients with different fastpath HSI version.
> > >
> > > This patch along with the new firmware support in patch #1 fixes
> > > this behavior in order to not validate fastpath HSI version for the V=
Fs.
> > >
> > > Fixes: 0a6890b9b4df ("bnx2x: Utilize FW 7.13.15.0.")
> > > Signed-off-by: Manish Chopra <manishc@marvell.com>
> > > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > > Signed-off-by: Alok Prasad <palok@marvell.com>
> > > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > >
> > > diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> > > b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> > > index 74a8931ce1d1..11d15cd03600 100644
> > > --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> > > +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> > > @@ -758,9 +758,18 @@ static void bnx2x_vf_igu_reset(struct bnx2x
> > > *bp, struct bnx2x_virtf *vf)
> > >
> > >  void bnx2x_vf_enable_access(struct bnx2x *bp, u8 abs_vfid)  {
> > > +	u16 abs_fid;
> > > +
> > > +	abs_fid =3D FW_VF_HANDLE(abs_vfid);
> > > +
> > >  	/* set the VF-PF association in the FW */
> > > -	storm_memset_vf_to_pf(bp, FW_VF_HANDLE(abs_vfid),
> > > BP_FUNC(bp));
> > > -	storm_memset_func_en(bp, FW_VF_HANDLE(abs_vfid), 1);
> > > +	storm_memset_vf_to_pf(bp, abs_fid, BP_FUNC(bp));
> > > +	storm_memset_func_en(bp, abs_fid, 1);
> > > +
> > > +	/* Invalidate fp_hsi version for vfs */
> > > +	if (bp->fw_cap & FW_CAP_INVALIDATE_VF_FP_HSI)
> > > +		REG_WR8(bp, BAR_XSTRORM_INTMEM +
> > > +
> > > XSTORM_ETH_FUNCTION_INFO_FP_HSI_VALID_E2_OFFSET(abs_fid), 0);
> > >
> > >  	/* clear vf errors*/
> > >  	bnx2x_vf_semi_clear_err(bp, abs_vfid);
> >
> > Hello Greg,
> >
> > Although this patch fixes the actual issue but the patch is dependent o=
n
> below patch as those were part of same series, due to this it fails to ap=
ply
> probably.
> >
> > commit b7a49f73059fe6147b6b78e8f674ce0d21237432
> > Author: Manish Chopra <manishc@marvell.com>
> > Date:   Fri Dec 17 08:55:51 2021 -0800
> >
> >     bnx2x: Utilize firmware 7.13.21.0
> >
> >     This new firmware addresses few important issues and enhancements
> >     as mentioned below -
> >
> >     - Support direct invalidation of FP HSI Ver per function ID, requir=
ed for
> >       invalidating FP HSI Ver prior to each VF start, as there is no VF=
 start
> >     - BRB hardware block parity error detection support for the driver
> >     - Fix the FCOE underrun flow
> >     - Fix PSOD during FCoE BFS over the NIC ports after preboot driver
> >     - Maintains backward compatibility
> >
> >     This patch incorporates this new firmware 7.13.21.0 in bnx2x driver=
.
> >
> >     Signed-off-by: Manish Chopra <manishc@marvell.com>
> >     Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> >     Signed-off-by: Alok Prasad <palok@marvell.com>
> >     Signed-off-by: Ariel Elior <aelior@marvell.com>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > Thanks,
> > Manish
>=20
> Ok, care to send a working backport?

Hi Greg,

I have sent relevant backport for each of the kernel. By the way I have got=
 two questions here -

1. when doing backporting over stable/linux.git (let's say backport for 5.1=
0-stable kernel)
    should we backport on particular kernel branch (origin/linux-5.10.y) or=
 we should backport based on resetting master branch on a git tag (git rese=
t --hard v5.10) ?

2. if the same backport works for multiple stable kernels - do we need to s=
end the backport separately for each kernel ? OR we can send it single back=
port mentioning all the kernels in the subject like below ?
    [PATCH stable 5.10, 5.15, 5.16] ?

Thanks,
Manish
=20





