Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B5333AB36
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 06:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCOFrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 01:47:51 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:11018 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229899AbhCOFra (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 01:47:30 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12F5gVlx010398;
        Sun, 14 Mar 2021 22:47:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=5MVZuo+AcG68Z/Szk1fLqkUIsBkFIqCsuiwpTUFBC3s=;
 b=fwr5WQjAwEmViA2TfHTkN8BOjrUG55bxZjx3YbExkDu2sAaXV8SCOe0q2UqllT5qiPem
 1QcNV2MtrAB63hdrpFqfWQb+i8DKR+MdAD5niz7+p38i36slfTkhtO554yZ8mqf0avr+
 jpfACDJP2JEMDWWey66t66ln0xoVDXeqTzqbmkVVOylJGngYdzuNUkOcKCZQrtkDwsgW
 TPIVFTyfT27Pu5GT8QFx391nnPkhQfx3J9KuoYC8Fy8GRXET6BmNHZ3wGqD064JIAkNe
 5qS6uq+mm+ern1+kK9cG4ao8jIgy3KzB8lYnTltOuP2aGCBxBKKVCMimaoBS811XGtaV lw== 
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2056.outbound.protection.outlook.com [104.47.38.56])
        by mx0a-0014ca01.pphosted.com with ESMTP id 378tu1ve2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Mar 2021 22:47:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kuyo7nQ4dZWDHPC0q0cXvVM388G53q4z8s5YHgTEPMTQ9G71HDMHepXpvP+EFFP3RBoaIWt/6NeMVkjHbEmRVsZmHJUNngA4luafOjqibOm3CtbBAcxKvCKuyFtrk94+761rCDU5N5PeTcoQitE20c/PXxY3cay4x5klt3X+PACkD5Fl64K3wpcnJ0U3zUPE2rJVOJRxcf6qq/JyvmilpJAgRQTUggUSZohuvMiYEI2jrMMRzot3dR5d20pufDkqDuc3lAI6pPDDKiEcHoYq2XS/W4dF4ZjhRnZHI3yEU4r7wmJEFyn+UmwYc91O7b5M4LHdbUwMz02KcofBy0/nLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MVZuo+AcG68Z/Szk1fLqkUIsBkFIqCsuiwpTUFBC3s=;
 b=KgM0o6vCtaaueypaiQHJaGd8oRXaUPYD777vM9ssUy40qhUt0ZNoPwjU8XfUroL0LMEdeI0m8VCZgfJYqO79GCzh9vXewIq7+AZ0QxRwXHmOGHoDGah1AP7x7it4X68ykq90vYM9VRLBpWxhTwpPKrC4liJXAfmZ2wFvByOFKgMwYe3I4ChlSUHKb2oxTVtkjyQO4lfw4yk9MDTeZNEBH9Hzj0opyQi74v1oUldfLC0Ofu7vW9OqmUSOhwPVOfU4E5pAES8UhR6x1ZjSxdMkNIsL25sKsg7XeeVDo+AETUYypuGfmBSAP+CFVYvot1TRcLo0Gtw5zvb/0+D4aUwXPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MVZuo+AcG68Z/Szk1fLqkUIsBkFIqCsuiwpTUFBC3s=;
 b=BIJFQ01VcLfGaT9X90TwymkhbsdeIoacL8Uf8ekUbitsLAFZrNbBv8nnhSUduUdHhV2KhEwUibqj9xAB4ryMOcDDRVaIRqbbWTMzTfKNiUhdvj4bVhgXpvS3weAfQN/97PcHH+XRtuIXBex3+iCSWxzk5JTSr/cZlmIpmiLs4nw=
Received: from MN2PR07MB6160.namprd07.prod.outlook.com (2603:10b6:208:11d::30)
 by BLAPR07MB8258.namprd07.prod.outlook.com (2603:10b6:208:323::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 05:47:17 +0000
Received: from MN2PR07MB6160.namprd07.prod.outlook.com
 ([fe80::294b:4e83:24b:ce39]) by MN2PR07MB6160.namprd07.prod.outlook.com
 ([fe80::294b:4e83:24b:ce39%4]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 05:47:17 +0000
From:   Swapnil Kashinath Jakhade <sjakhade@cadence.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v6 02/13] phy: ti: j721e-wiz: Invoke wiz_init() before
 of_platform_device_create()
Thread-Topic: [PATCH v6 02/13] phy: ti: j721e-wiz: Invoke wiz_init() before
 of_platform_device_create()
Thread-Index: AQHXFcSB69/wViqcVUq4MNab63JkLap/7Zug
Date:   Mon, 15 Mar 2021 05:47:17 +0000
Message-ID: <MN2PR07MB6160046609B94969CAC0EB17C56C9@MN2PR07MB6160.namprd07.prod.outlook.com>
References: <20210310154558.32078-1-kishon@ti.com>
 <20210310154558.32078-3-kishon@ti.com>
In-Reply-To: <20210310154558.32078-3-kishon@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2pha2hhZGVcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1lNGM4MjNhMi04NTUxLTExZWItODU0Ny1jOGY3NTA0NDIyZDhcYW1lLXRlc3RcZTRjODIzYTMtODU1MS0xMWViLTg1NDctYzhmNzUwNDQyMmQ4Ym9keS50eHQiIHN6PSIyNjE1IiB0PSIxMzI2MDI2MDgzNTI0NTMwMDAiIGg9IlczNkVkbnN0TVRSQ2x6SWo4Q2VvWndCRzNndz0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: ti.com; dkim=none (message not signed)
 header.d=none;ti.com; dmarc=none action=none header.from=cadence.com;
x-originating-ip: [59.145.174.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 141f63c5-732e-423c-19e4-08d8e775cae7
x-ms-traffictypediagnostic: BLAPR07MB8258:
x-microsoft-antispam-prvs: <BLAPR07MB8258BCEE84D5DFA9D331FC45C56C9@BLAPR07MB8258.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1RW9Jy1u60CDlo5xVTBNagUbXMEaumWa2b9CkAKHQLvFbSRycjO6yWFLdu8AaHfl606JapD27zDeseODvhaXY3Coisq7+hd8cTEjp2cN3KuIaXOY4qQ6o7nXihzdLWV5Uq12/hxKJ1U5/vUf7Bs5/1WjbcbdMlyBdPijQ6b6sWCWp27YavUkecbwvhS23x09SlCbG+oc9K27BK5cYV3y+XhkvLE4N8dNm5ylGm7p3All6xwbDKxkN1/yxGoCZDndDj/NgiL1W0gZNJrNXlPrpcKReRwkMlQ7QX6i2iYQ0gzrqwEfhD2zkzdqvCJybFXRrAlbbiYZKz46kADQdWK1LWhQg0nBbiG9CV+5dCYPP3kjRCasrJ29tk0A0R6mAanM0OPvh2YpqDk6Fp4XX0iBZIx1vYa2XCIP+y90ArzCQNZuGp0UF6n34qi97AE1PG1DXtnk3b7ZCilVdPkkCN2ECt4fGeyMGn60V5DqEvSx837+QyKtQ1qwqXYDf0Mpky+IX9QovbHZmlYH5R8NTEH/BGO4Szm+2jFztIxhlZQSnoRF1fUBp0p2nzj9/1sKkUe8gh034KeM+wkYXfBhyT8HfhJkMV7ItUItCdxRbCKYYQWGOa4v5ZxcVP+VcKWbGGUA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR07MB6160.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(36092001)(66946007)(64756008)(66446008)(66556008)(66476007)(26005)(53546011)(33656002)(186003)(52536014)(71200400001)(5660300002)(6506007)(316002)(76116006)(8676002)(7696005)(8936002)(4326008)(478600001)(9686003)(55016002)(86362001)(54906003)(83380400001)(2906002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gBF9Oq7DkE12/GRL4QuFEA2b5sA37iyEeYYCRBVoVzTEvlvpEVBjyXvrG1Ap?=
 =?us-ascii?Q?9IdIsLfHVC7iErXrSHfjrH65hg3RMzK+h/HMCJUrGIHoEjZNJIx8I27kyHzA?=
 =?us-ascii?Q?HIAOLX39DD+gG6YDXrqNQsVqVcpcfCUrOE5ES+VG7crKyw12BNxuLZugmDJv?=
 =?us-ascii?Q?arLchkOo70u4YtYsGM/WOJDIFAwq9XSk73pf/5+uXU86oSgvRlGOXOkzbaSn?=
 =?us-ascii?Q?yVt7MTC1jRPsM580tUKk83zLBhmkMEHPUtVKqW8Lazp0zYBFqLt6BoHYhbJk?=
 =?us-ascii?Q?z4qoPA11tGToeV+3wUrha5gk4gJE7JLWpwGxjNnuIE7UR/i3gkwux0XG9obv?=
 =?us-ascii?Q?Gs/9Rqwnzx7sxlABCuSS3TedHSnvIoOXFxVAAZdSGZ1ZR1pCMOLFRJjWZUQv?=
 =?us-ascii?Q?/8tbEWtZaj/RkObrP9Z9RcgvLMa57Aw7CEAWpk+oWbuMND1JDpC6pGgZ/QLe?=
 =?us-ascii?Q?GvUGItg6KB23aRIXohTT2/IZ2pkkEnOHoxuzuonZ9n0fVtwlWVUKHskCof5t?=
 =?us-ascii?Q?T5FauBuw7uHbdGzEc/mM/rSR1/6++DeBakN/nZlYgYzfJ/eYkAeY0M2hvNbM?=
 =?us-ascii?Q?nXMod0VO5VK2f7YtEpI4EBFqRS3WD0WM4qE+Q2smTtz5kD8ZquImllG0BAXf?=
 =?us-ascii?Q?Ed8ATQYAWoD/4fZvu2ausd6oy3BS7GPQjmsOyUShY947Qty3rbQrl/H+xE0r?=
 =?us-ascii?Q?fhpdCDVKGWm4Udsm32Wjx7zj7aoHgoo0cHrW6HYcPWzTKbyw6B/tQZmjtMLP?=
 =?us-ascii?Q?YtCYXS5r7QlGo5Wd5yfJJb3JhnmC9+mhRRn1eh21FtfOJQRLjmfnrvtKpVbG?=
 =?us-ascii?Q?4oELdZzb3AH2WDVIKn7CKEbKEUf3MyNCbhOPkDyUSV+kywAVHfrVS0mS4E9E?=
 =?us-ascii?Q?R1tDzJkapzZ0IGZ7liM+eRJj2DISzPdamEdly8YdeWbQkNkceOzvmHNKeJzT?=
 =?us-ascii?Q?wMKw0VRNn8PPYxWJifycU4vrJKLw229Yc46gv3jBZmMpIn6hW8Ccz/tCF+we?=
 =?us-ascii?Q?aureRgrVPOZb1J9HUJThhUFkbvW2E3r/zkl1yfz6qX/sKW7eX2PWGdUQNtc6?=
 =?us-ascii?Q?PL20EdC5mUM2L9wki6u6clrex8HfYLSbU9B2Y0PamOr2Nqm/IbHAkReLQ0NZ?=
 =?us-ascii?Q?23Ew2GrdnOMIZI+hxxYr+fS99nfy/8x7dHXsOHnLbvJZTtzCIxWUZfADkMnM?=
 =?us-ascii?Q?dPt7eWH3fh+yKpm2WY244DLCAruxWVjbiYcTM14xxB+05IiiENI9D7MHvYGm?=
 =?us-ascii?Q?qfXNDgdCMRHsQjQ78czmW3i6lD5ks8lAeHvrSJZwvtyI1r8J2XWwO4ftUDFk?=
 =?us-ascii?Q?5FjVyVAHkspFlFZWsxcY8Qty?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR07MB6160.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 141f63c5-732e-423c-19e4-08d8e775cae7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2021 05:47:17.3468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yk1g4Byp6mbEzVq0UNj9625uFWDLhn7GTTtasGoEprdwG/ZyaQVdpNO8q+2m/QVGNAPK3w5Dd35HiCdQQDB3MtRZdis5UVGaYmROsLT+Dy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR07MB8258
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_01:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 adultscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103150039
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Kishon Vijay Abraham I <kishon@ti.com>
> Sent: Wednesday, March 10, 2021 9:16 PM
> To: Kishon Vijay Abraham I <kishon@ti.com>; Vinod Koul
> <vkoul@kernel.org>; Rob Herring <robh+dt@kernel.org>; Philipp Zabel
> <p.zabel@pengutronix.de>; Swapnil Kashinath Jakhade
> <sjakhade@cadence.com>
> Cc: linux-kernel@vger.kernel.org; devicetree@vger.kernel.org; Lokesh Vutl=
a
> <lokeshvutla@ti.com>; stable@vger.kernel.org
> Subject: [PATCH v6 02/13] phy: ti: j721e-wiz: Invoke wiz_init() before
> of_platform_device_create()
>=20
> EXTERNAL MAIL
>=20
>=20
> Invoke wiz_init() before configuring anything else in Sierra/Torrent
> (invoked as part of of_platform_device_create()). wiz_init() resets the
> SERDES device and any configuration done in the probe() of
> Sierra/Torrent will be lost. In order to prevent SERDES configuration
> from getting reset, invoke wiz_init() immediately before invoking
> of_platform_device_create().
>=20
> Fixes: 091876cc355d ("phy: ti: j721e-wiz: Add support for WIZ module
> present in TI J721E SoC")
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: <stable@vger.kernel.org> # v5.10
> ---
>  drivers/phy/ti/phy-j721e-wiz.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
>=20

Reviewed-by: Swapnil Jakhade <sjakhade@cadence.com>

Thanks & regards,
Swapnil

> diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wi=
z.c
> index 995c7dbec77b..1bb73822f44a 100644
> --- a/drivers/phy/ti/phy-j721e-wiz.c
> +++ b/drivers/phy/ti/phy-j721e-wiz.c
> @@ -1262,27 +1262,24 @@ static int wiz_probe(struct platform_device
> *pdev)
>  		goto err_get_sync;
>  	}
>=20
> +	ret =3D wiz_init(wiz);
> +	if (ret) {
> +		dev_err(dev, "WIZ initialization failed\n");
> +		goto err_wiz_init;
> +	}
> +
>  	serdes_pdev =3D of_platform_device_create(child_node, NULL, dev);
>  	if (!serdes_pdev) {
>  		dev_WARN(dev, "Unable to create SERDES platform
> device\n");
>  		ret =3D -ENOMEM;
> -		goto err_pdev_create;
> -	}
> -	wiz->serdes_pdev =3D serdes_pdev;
> -
> -	ret =3D wiz_init(wiz);
> -	if (ret) {
> -		dev_err(dev, "WIZ initialization failed\n");
>  		goto err_wiz_init;
>  	}
> +	wiz->serdes_pdev =3D serdes_pdev;
>=20
>  	of_node_put(child_node);
>  	return 0;
>=20
>  err_wiz_init:
> -	of_platform_device_destroy(&serdes_pdev->dev, NULL);
> -
> -err_pdev_create:
>  	wiz_clock_cleanup(wiz, node);
>=20
>  err_get_sync:
> --
> 2.17.1

