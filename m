Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8695204A22
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 08:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbgFWGqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 02:46:22 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:33690 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730489AbgFWGqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 02:46:22 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N6iH4v010006;
        Mon, 22 Jun 2020 23:46:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=fkBwROS9fo/fJQQkdXbkk+3ZcGmIMMYyQAkXvsNp7c0=;
 b=PTqqt/sByfHCI6TPdYtltuP8SC+8LUToxc9HO2ZqSfbrAbf718VL3Y5DRK3MqArjIZXD
 SLyQ60p04hK9wsSrOkPwX6T2ApZXmcv07HkXhzfN0Y1ImniXfpGQ6W0kswGZ2+UPL60W
 ahdkno9hWreSwkgVBdUjLuJZlPySzhx4cO2AvKAduOxybGQu4WPmixcsDkWZnwIAqvuF
 i6wCGuH1KSuiiuC+ovu9NNNVfKqp1cDkGDHGzDXyiuGuAP+ksS4icGMKvTJgDC27JvDv
 nV51motJo8Et9NC2m6cqyeB4qZ+yUobBUL782xy0cZt5RzXqx7BhlYJS1mE24P0mrT9e AA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0b-0014ca01.pphosted.com with ESMTP id 31tbucna1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 23:46:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+NUA+nkWpCT/GGTOi0Ef4nz3H7ZaqYIxO4S3FdQk4Wy3rerRhRogguk3PLqR5MY0yiMgYmDZyby234V7EWU+XpTnpfTOM3peNImO852utH9NbtDpuG/TpY8DHkdMk3rORImGcDdNew45GYddNnSWE9BNJzGCzCC+sXbfFB9gSbCEWAeo3I4XbPIfjUp67MRlCNvNH6aolhyRwoZtyqDfpkFKu4OZAr17U0S46gPxZNu0QFkfKnz8+2uhJ1eDaUALQ/T6BZfuG0+So7NQob/C8+I14zmigDaMvHi4i4qR854B2SVgg0wkiVYZ79wOWwwC2Xt5kTb2qJSL180ZMQMHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkBwROS9fo/fJQQkdXbkk+3ZcGmIMMYyQAkXvsNp7c0=;
 b=Q+ghTb6UC95Gz+OKNLmakePKpb1jhSsVo4KT0VU8Fy73v+AY3VVWZyKeEzqTv07MVkGN32UgwkqiNv9NEvUVD0coRiRC2A1Iy8yy2NP/Ir/VCwrqUu41zn/IIYUaxdTzNpQpV2yNqa8xlvKJWVZqlylXiTeU7YAOx+3PYV8qGmjDq7xCTu/Q1pQeAUMb9eOsct8lwJmQGclNjm4hyRONnMn72ASjWHziHcrQpII3l9s1j423xeD8LovgCZW23cVAOMRDsgqlT1wh/rAtNMYtbF3sZ2Ma3xc2/XIgbdyeGO1lsgBH3PW5I/JuyFq52FTwamiaMOtwuoP6feRE/y7kdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkBwROS9fo/fJQQkdXbkk+3ZcGmIMMYyQAkXvsNp7c0=;
 b=v7SA8ydQQEBR5UMab25JiZhDZz5iFDAWd0lB69/lF4Hax/pbsTpz4NgDGg0CyWm0mrZylRpPZbaexY+FaTT675eMpUe2dYG8f/QKn2QtO7XtctZ+lLmN/irbVIROlFtMkHYKJmE8d0ljY6Xkc6he0H1YgNfQP1lom3QUVAZJUc4=
Received: from DM6PR07MB5529.namprd07.prod.outlook.com (2603:10b6:5:7a::30) by
 DM5PR07MB4037.namprd07.prod.outlook.com (2603:10b6:4:b2::38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22; Tue, 23 Jun 2020 06:46:07 +0000
Received: from DM6PR07MB5529.namprd07.prod.outlook.com
 ([fe80::f447:6767:a746:9699]) by DM6PR07MB5529.namprd07.prod.outlook.com
 ([fe80::f447:6767:a746:9699%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 06:46:07 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@nxp.com>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "rogerq@ti.com" <rogerq@ti.com>, "jun.li@nxp.com" <jun.li@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 2/3] usb: cdns3: trace: using correct dir value
Thread-Topic: [PATCH 2/3] usb: cdns3: trace: using correct dir value
Thread-Index: AQHWSQuvDLdzRvDYyUmwvTVangc7Yajlwbqw
Date:   Tue, 23 Jun 2020 06:46:07 +0000
Message-ID: <DM6PR07MB55295C4AC293AEC65EFFE7D6DD940@DM6PR07MB5529.namprd07.prod.outlook.com>
References: <20200623030918.8409-1-peter.chen@nxp.com>
 <20200623030918.8409-3-peter.chen@nxp.com>
In-Reply-To: <20200623030918.8409-3-peter.chen@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctMzU3Y2UwYjAtYjUxZC0xMWVhLTg3NjctMWM0ZDcwMWRmYmE0XGFtZS10ZXN0XDM1N2NlMGIyLWI1MWQtMTFlYS04NzY3LTFjNGQ3MDFkZmJhNGJvZHkudHh0IiBzej0iMTMzNyIgdD0iMTMyMzczNjgzNjU0NDY0MTExIiBoPSI2RThHajB1OXlHd0FvS3dPSGpyVC8vRnVOZUE9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=cadence.com;
x-originating-ip: [185.217.253.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37a659db-9562-4550-bb2d-08d817411b47
x-ms-traffictypediagnostic: DM5PR07MB4037:
x-microsoft-antispam-prvs: <DM5PR07MB4037052ED8F6EF7C33231096DD940@DM5PR07MB4037.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r36d/ydxr6POEyUM53ovL+c0zhDZcsikTZw2sgcEK5ETNs1jDZJMsBaUsv9luf61YkmxlCo/u40ruNVBJRKgJNW/aCZXcdJapWuJVArlSVAOKdYzOuj5151LfzbdbQFsLY00o0TJFKFGn5glpgiKHWKR6MjBz+z6U2C9Z7EoJ84FYe2ih7/IUbblvlNGL5fVt4tNDA8VX52TRWhs75zZHVgaZdKI58XecnrKAQF7Uu01bk+/Us3zisYXtmj58JWvfJcKTfmjoVUHcK3CRUw4dzYsRrl5x94rCc5VDeGKlNu2E9gpeOtskH6mKyNF8HrkpR46eYCz2YTQcRzixnViphyK/6qsZ/G2w+V2imY5G/fSWditk2vlsNUXErHO+cPA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR07MB5529.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(36092001)(6506007)(9686003)(52536014)(26005)(8936002)(5660300002)(55016002)(8676002)(2906002)(86362001)(76116006)(186003)(66946007)(66556008)(66446008)(66476007)(64756008)(4326008)(71200400001)(83380400001)(54906003)(478600001)(7696005)(110136005)(316002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 8S/chqSvcdQI13bQkZQZCMMn/WKr6RXPvBHU9W9+cWcQZ+SwA3dXBprYyTu8I8TRlRb2yrLgO1wOkUysq+x+u/MCVZf7bVRBRZfoxzwPduRVXTnfZh2pDogz73wngWBflbRb6aDq3LRuoUCw2Hb4H9a34nAfniT0k6FYvYOClENidoi4rgZgo/uQZzPRTAfB3al0ArFWz/pNyDQQ/JFuTa3SgtOYc568TfgwVbUyIdEhFaCkbjHvrduOhV6dYEnyj7dNs+lB0BZ6+LGublSL6RjRNp+OpoDgcN4Iepq4JIFhIhVAcabthQq88ybkjeafkD+lVVI24sED6WQLIYhsXXqhGkuigcNiBfDkZTLcJWBQEMmhLSQ1pS0UlfrmcPRKNpNrEbkJUNExy4G7GUTSJePsWnsnJaESRl/zd+ZZI/Pyxl+QH38HPEBbvxd1KxTRy0Sq++7tNKIP3ahCg+P5xsxvv0nClQ0Srt7nNspabT84ryDZ76xvIlDjRWgqgv1q
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a659db-9562-4550-bb2d-08d817411b47
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 06:46:07.0244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: avRBJOze5+cDFIEq4HHkoHTrP0/Zb6Ny1G2DPSwpyUvRpVwi7NrQ4JjMFXhhV92sKFY/xrhS1yDJDGkOwWZ0E/FFzgr4Z52D4JXqJP8ELtA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB4037
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_04:2020-06-22,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 cotscore=-2147483648 impostorscore=0
 malwarescore=0 mlxlogscore=671 bulkscore=0 priorityscore=1501 spamscore=0
 phishscore=0 suspectscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230052
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>
>It should use the correct direction value from register, not depends
>on previous software setting. It fixed the EP number wrong issue at
>trace when the TRBERR interrupt occurs for EP0IN.
>
>When the EP0IN IOC has finished, software prepares the setup packet
>request, the expected direction is OUT, but at that time, the TRBERR
>for EP0IN may occur since it is DMULT mode, the DMA does not stop
>until TRBERR has met.
>
>Cc: <stable@vger.kernel.org>
>Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
>Signed-off-by: Peter Chen <peter.chen@nxp.com>

Reviewed-by: Pawel Laszczak <pawell@cadence.com>

>---
> drivers/usb/cdns3/trace.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/usb/cdns3/trace.h b/drivers/usb/cdns3/trace.h
>index de2c34d5bfc5..0a2a3269bfac 100644
>--- a/drivers/usb/cdns3/trace.h
>+++ b/drivers/usb/cdns3/trace.h
>@@ -156,7 +156,7 @@ DECLARE_EVENT_CLASS(cdns3_log_ep0_irq,
> 		__dynamic_array(char, str, CDNS3_MSG_MAX)
> 	),
> 	TP_fast_assign(
>-		__entry->ep_dir =3D priv_dev->ep0_data_dir;
>+		__entry->ep_dir =3D priv_dev->selected_ep;
> 		__entry->ep_sts =3D ep_sts;
> 	),
> 	TP_printk("%s", cdns3_decode_ep0_irq(__get_str(str),
>--
>2.17.1

