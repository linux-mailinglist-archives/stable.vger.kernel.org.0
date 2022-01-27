Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906D649EEB7
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 00:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbiA0XQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 18:16:31 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:9306 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231250AbiA0XQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 18:16:31 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20RMeFcC005984;
        Thu, 27 Jan 2022 18:16:22 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2057.outbound.protection.outlook.com [104.47.61.57])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3duu31rcrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 18:16:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8ni2uVVIoJYUQxd9Re6nG2uksU5iWKfEbhcbBRLlqX1bSMxuqZ3ajo3wbvaggYMbhYJlRfBJUDUzWH1lMOMZoGm9qM1qm5cdC16x6zCrJe47cYTEy5epsUvHC2YVvQX0k/2wWMqubpPrs63+H22Vja6otRofkTi/G06gIyLYjSoVA2lTrAIA5TYgKSRnSQpqmcAg1xSdSwgvim+vusJ5WoJP/uhFbk+00NExzfoDCXfSRL2LHo4ClZMrQ3yKm6I3qrttMapHyUEiVckJfznWv/Xekhx1w14nFcgqSYBal7Htcg+IxW6sSgGrs7CQQhvstndff9YGkpTXlbM1jCuNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dRhrLhbMVF0SimfPMAaK1w9Y37r0Uv7A5Wqp0/BkTc=;
 b=SJWTKy9dYWDiqm4X8zzIMd2Cn3sXr/KuvhAqyO3+8y3AruE+N3BlAFDFIPUh2Ry8yEHPZP+Beye4YsJnThIDrRooVcLjj4wutLSGBMGhFnyRfTmEBRH1IGsqeaFPLOE/aNdMx0N2sneKXoA32XMxh4mspicPGg08q1xirsh8Ds+iLNIHCExEcgk53W1YOB6emHytCCEz9RlKqUDa/CiOLyVfYIne50WOQ+YYJ8bOKQppNWlFTv5YEzGxcX0AacHeXT/h+l1z8ki2qkWNNiR97gKr0Ii3Fofb95ACJxAkM4hmOGEylm+MJ+NaJKcNCfchNRO442sBrHDfSi8Hq/yYVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dRhrLhbMVF0SimfPMAaK1w9Y37r0Uv7A5Wqp0/BkTc=;
 b=1saIe2y95unSiYmSpCQIYsrY3FO0xo01CSbLhJRcw6H7uHWeKiRS46L3fhNM/UHbHe3JNnSVmGAWE7jsyr0EaT3/joRe4AHGAVnu9oFKNS277GdVZsFs7dF1r5OxWISV+lBJE1kVwBZhZyKLKfMoG7zr2eUntNo/iJmufEAj65U=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTBPR01MB2942.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:24::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 23:16:20 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 23:16:20 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     linux-usb@vger.kernel.org
Cc:     balbi@kernel.org, gregkh@linuxfoundation.org,
        michal.simek@xilinx.com, manish.narani@xilinx.com,
        sean.anderson@seco.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, piyush.mehta@xilinx.com,
        Robert Hancock <robert.hancock@calian.com>,
        stable@vger.kernel.org
Subject: [PATCH] usb: dwc3: xilinx: fix uninitialized return value
Date:   Thu, 27 Jan 2022 16:15:00 -0600
Message-Id: <20220127221500.177021-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:610:59::29) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dbd5e21-903a-4619-289f-08d9e1eb0726
X-MS-TrafficTypeDiagnostic: YTBPR01MB2942:EE_
X-Microsoft-Antispam-PRVS: <YTBPR01MB2942B262B919D5D77241759CEC219@YTBPR01MB2942.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OaD/STnIQPctkAB7SOCpbCsXPVgxjkegbxOeuyA/Aw49r/fzQbNXkcPN8ImO/3w86j5eBdAr3Zr0j0zfUy/Xe0YJfn83fFZ7UKn4JFj5p1zWMHnSBdPDsXfPcTN6FLldjC2GLJmlAJhI6p5AOWzuHh1OjUKJIAR2rDOHLhq+2qAHWMTtx50v9lDZDFe4Rtdbo+yLiwDF4kzwOPbex9Qzd+YU/lTnROYGW55L9hDGhoFZshbf8w58hAufut0AvWeMaCnGXFoR7VakWUDN1+i5ooEA7kSHn/Vpvc9MjRWtEfwH+VnjXVzAgcuSiw0KUK9Tq+aG6OCKbUwJRsl1NrNN7p+XKTFlskW//vow4K8YHg4iYPWtq5xE451JWXZqX6zmS+a/pLcpS2fGDmPwRjp3YLL/lkVHxHcWVP1b/yb8M1jpZoDoSTWkRzKJ06OT9f0PC9b68Rho17MRYPFMDRQ07cb8SYMN+oTRAWUL7DTouViw5dmEaOwJPT7TQUKo8QvFCFxyE+njOYO3oL1u/s6xHtJPbP8HPyu2f+hwMefIvF34iDSqQ68znU4njPk60lGn6C3/ixP2Dr5XSE3fzi0R1tyCWTryxWUVoqHvlgkmhWCedWE/UmC2So4oq5YhZ+aWLJIuZeAU6pWjUb9P5sOpdcVCWMDdvTXlIE7ocPUXIRcbkY9I1zvOWgTsnFv4QF0H331kTC8n9HZbLoGyTxCFSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6512007)(66946007)(4326008)(66476007)(8676002)(66556008)(6486002)(86362001)(6916009)(316002)(38350700002)(8936002)(6666004)(38100700002)(6506007)(36756003)(44832011)(7416002)(2616005)(5660300002)(2906002)(83380400001)(508600001)(4744005)(1076003)(186003)(26005)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zzYGi4zCyNP9xzhfGHG8SbpCG/1jySSBcLt1mf3NGh6AyniaQpfmpdQJfbXH?=
 =?us-ascii?Q?7Vvmo5+pfCUAejMXDcyGAXZ4WQXVFWVU6gPQE4D0zxjm77UMV702ZqzuQJRZ?=
 =?us-ascii?Q?/nxyaU31Dy0FDrH0iH+SwGdTn3rk5b080xRLU7Sk22+zTyoma2xL6E3i44ms?=
 =?us-ascii?Q?0P/8tJm3eCQnIByNs7ZJ88IgV9dM2LrYoUo0kZFuYAgfrzD7p0wGvhLgfzMC?=
 =?us-ascii?Q?2iHa1JiLKp6ytJAPteIhwCTt/qRvlPF0VXgn7EN1ZTl7qTYsl0TFbXg1jobq?=
 =?us-ascii?Q?MFoBzP35Ruk5VpLKEgaCamftLTwg3dnzOqkrvdp3NssMxjwvLMrl/2e0Hdv+?=
 =?us-ascii?Q?1JjLAyAvQL3DRgU7GPJoGhl481i0jnEqlU3RwzXyun4tRLZuatPOmLasUMF5?=
 =?us-ascii?Q?/JxW5PLr++6IdW5+kVxmGanJI7SAk6Jr0coM1y1aIuK19AruUlpannuCwWFm?=
 =?us-ascii?Q?GSR3E8z7FmouwY7M+/V3p5jd6Y9NHo8UaKF4cjrjhQLLgJqhj8zUmGadEBMd?=
 =?us-ascii?Q?GShLoqF7FcXP21ydQXUkDslx+uEeCpdj5O72gJHEzRjrDEX0Fzz/AiOalhBN?=
 =?us-ascii?Q?dH3W6KOtXdgCZxxG0Craloo91GNHVWAEdLhjN3mQsD+y8DR4VNx/BB4vY1F1?=
 =?us-ascii?Q?p0C+tcTg8vvHZwK6KrujBYfumDslozxHRPs3l0xdTn+KFHvoMOkL8R8nJrMZ?=
 =?us-ascii?Q?Cjr0b+BNQxVeYZ4SHPhqNncZWEFFbgQFj43rtz9eMY2Vsx4gFuv3ShoFDKYc?=
 =?us-ascii?Q?zjCsYWaINVr3Guj4nu6FkgLViO5Oioi5B8VNpChc+rtRn3NABuVINaNICM8F?=
 =?us-ascii?Q?oq0gfB/avOZvXJw8eiTwMiy+ADvK/bXpvhjr89VwCbdU4Go3sEoRzRdzSQX2?=
 =?us-ascii?Q?klb4dlE6tAvShwtxZfvDjlEAIvexePeRGFT+gtm3yG/h2v4Y5pdYD4UqtRUV?=
 =?us-ascii?Q?lyaZh3v3/Ez3NF2dljMQtnyTNFzrTVmw7c6P2fIXzdme5i4roNhcq18BSHlO?=
 =?us-ascii?Q?z5tOK+MXcK9UnPzoQadef21w1DFYOnla1wgfXT290oGgMagDpmdYkiHVoON4?=
 =?us-ascii?Q?uDV1pG8z+Xv4M25J/OY9Jzf+u6Vti5UZ0ANdGzNSON3GebJymtomDvaAKiFL?=
 =?us-ascii?Q?djVXcTF8ekJZxy32hyStEGmO2zKMbFm72/4SmOxogLQvB8csepc6pXE054rf?=
 =?us-ascii?Q?I/+2Sshh2vjSHWb9mQNN6lE0LR20JeObHC0fcwtq1Tk5M2ZgoyvhGzROLlwH?=
 =?us-ascii?Q?Ar22OKVnLZFOoxkRJ83HgpF6H4Z8mb8UO8LYjKGJ0x1mrqN5L6BMJj7gmIjZ?=
 =?us-ascii?Q?9C5AfpfBIv6bShqTJEbhAY1YLyuGv9Ge/oVVLDgs+Xb07SNunRiFRJ6JjU3U?=
 =?us-ascii?Q?bBZXeHG0NUZVqXD3fyJvpqFZNY+MJUCogzYoUAY8spuTvz47BzIodQuyc4Ln?=
 =?us-ascii?Q?HjHc06PeB5Svf0lhdLMcBU6GXk0MbWjza6qaR4POcffB/mgOAaj9ZOOmuFIE?=
 =?us-ascii?Q?8AswCNGPsbmvw/lqtSa75gDAOtQnlePVi9DhrOlCeaiK72lnYzS5qEJ2mif0?=
 =?us-ascii?Q?7WN5+nLz7iM6oxAJ4s6Dyp2plzqykwBbAqqShFlsLWMXQ5mquh6+DxNFf5ol?=
 =?us-ascii?Q?xnqhznD9dYy3N0TSn3LoZPlLlAxJkWUuBwQiWJcr6xXYEkbdHr1TVxj3Jah+?=
 =?us-ascii?Q?3/JsOQX15P/hRIPbDMzssC99J+E=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dbd5e21-903a-4619-289f-08d9e1eb0726
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 23:16:20.5484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4LGrSyqY54pAEs+A/VPAwX4axQzLctzFCoZauwCaLF+jJZ0mPh6M/Dow8X4DuhxyATB33NlKmWf9njK5CUWiCVQyiBI8j2YPF/eaTJXUxxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB2942
X-Proofpoint-ORIG-GUID: EE1MpfjyLGmM1vrds-Dh2VN8rNM-zrkn
X-Proofpoint-GUID: EE1MpfjyLGmM1vrds-Dh2VN8rNM-zrkn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_06,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 spamscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 clxscore=1011 mlxscore=0 lowpriorityscore=0 mlxlogscore=501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270131
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A previous patch to skip part of the initialization when a USB3 PHY was
not present could result in the return value being uninitialized in that
case, causing spurious probe failures. Initialize ret to 0 to avoid this.

Fixes: 9678f3361afc ("usb: dwc3: xilinx: Skip resets and USB3 register settings for USB2.0 mode")
Cc: <stable@vger.kernel.org>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/usb/dwc3/dwc3-xilinx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-xilinx.c b/drivers/usb/dwc3/dwc3-xilinx.c
index e14ac15e24c3..a6f3a9b38789 100644
--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -99,7 +99,7 @@ static int dwc3_xlnx_init_zynqmp(struct dwc3_xlnx *priv_data)
 	struct device		*dev = priv_data->dev;
 	struct reset_control	*crst, *hibrst, *apbrst;
 	struct phy		*usb3_phy;
-	int			ret;
+	int			ret = 0;
 	u32			reg;
 
 	usb3_phy = devm_phy_optional_get(dev, "usb3-phy");
-- 
2.31.1

