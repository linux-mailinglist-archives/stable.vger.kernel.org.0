Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAC46DFD57
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 20:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjDLSSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 14:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjDLSS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 14:18:28 -0400
X-Greylist: delayed 1798 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Apr 2023 11:18:09 PDT
Received: from mx07-0063e101.pphosted.com (mx07-0063e101.pphosted.com [205.220.184.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8E4524B;
        Wed, 12 Apr 2023 11:18:09 -0700 (PDT)
Received: from pps.filterd (m0247495.ppops.net [127.0.0.1])
        by mx08-0063e101.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33CHZFnT022708;
        Wed, 12 Apr 2023 18:35:15 +0100
Received: from ind01-bmx-obe.outbound.protection.outlook.com (mail-bmxind01lp2233.outbound.protection.outlook.com [104.47.74.233])
        by mx08-0063e101.pphosted.com (PPS) with ESMTPS id 3ptwgya01h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Apr 2023 18:35:15 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOD4wsIByIoKsiELNOmkTOowD+TGnbLMU1jRGjJPRb4Pz0Po962cLCy6SKRSsa6FsJpjH4fJDR3sahvDiApa3wIuHBbqERdfPIiw0PVk2aaaPSgJ9cp+NDhswn0FOmGoa0H6Xuro8U9QYrEyYLzlJLM3BQQQKwuQ4Zw8zpbUMDvleWx/Hko+8sHfe8slBkKb33d2mwYdag3OeBALqbQM7paAfbRqIbxW2OVpLwHMRB3p1Xk2GLyL969mfji38jDFsYnoTnJSwxmozEdXbFsRsBlhjz+Twj1p9RJvHyk5/jnKdP1klvPxGwTl56/XfGaL4mdng8AlIJFDXE05zoRFPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvQo2QTnFc6PnhwvyN4x0vgtasuhGfQIJ8BwhVIeqF4=;
 b=Vg19ng3GJkfuvsjxWuJfOiNGz2HZNpnogNlmeif1Vu6hiZ748W7IKther0QaxqYUWJr/5dcFvZ+oAwiYANbwgP7KfdIJn5qf3nLv6WUAQsHR1bvK7LD2sCJC4TsA7+SxidRJz2IthhmyIGju2ZD+lKgAw+g86gvMbRl3gVqNzjN/4R4b4XIZv3Sn4Vtg0wOlxA3sImBvW003CiT2C63QUAPzi/Bli3oTMTus/CmepZ6GN3NemZYNMufiXlrN9pTO5hOO3O9/4xgUo2vhBne8CPXJTw3zVUQRK5is724uYvhxQQAnr70piIbGggXAW8u0N9weFsEvL+xKb5x61cSfJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=blaize.com; dmarc=pass action=none header.from=blaize.com;
 dkim=pass header.d=blaize.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=BLAIZE.COM;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvQo2QTnFc6PnhwvyN4x0vgtasuhGfQIJ8BwhVIeqF4=;
 b=jNSz0lmCgHgcjxMU4qfZ2sBy+jzETIogBrZ21xCw7rv3I6zub/vKCc1i6ncJCwS014t5UlvjEVpvDWCYuSqBsOfEgo4MjQZXiB7sZxQbdX3Y+wWSyM7VocZA/Tdr+o00r5MpUzgq5xTGv0RWV2FKioU+foj9fNgirHArfW8r2ow=
Received: from PN3PR01MB7255.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:8a::12)
 by MAZPR01MB5695.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:63::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 17:35:07 +0000
Received: from PN3PR01MB7255.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::fb61:6425:3c3c:f35c]) by PN3PR01MB7255.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::fb61:6425:3c3c:f35c%4]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 17:35:07 +0000
From:   James Cowgill <james.cowgill@blaize.com>
To:     Neil Armstrong <neil.armstrong@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Philippe CORNU <philippe.cornu@st.com>,
        Thierry Reding <treding@nvidia.com>
CC:     James Cowgill <james.cowgill@blaize.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH] drm/panel: otm8009a: Set backlight parent to panel
 device
Thread-Topic: [RESEND PATCH] drm/panel: otm8009a: Set backlight parent to
 panel device
Thread-Index: AQHZbWUfGy1msHv/AUKBj1pHg3WUfA==
Date:   Wed, 12 Apr 2023 17:35:07 +0000
Message-ID: <20230412173450.199592-1-james.cowgill@blaize.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PN3PR01MB7255:EE_|MAZPR01MB5695:EE_
x-ms-office365-filtering-correlation-id: 8b7ea748-136d-40b3-5822-08db3b7c4209
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QscvbKP1Gu0snYOCT7WWa+z/DChpBZlcIvEvLbl+M7BbvAlIjCzt8TcKp4dSB44SlVcSevv1MKsd7/lrfxL8tTouZbHJFUcxEpgRTz0stz08lMs06RQ0ZbYbiLWhPD0xfzTbtwshPl8CqzR8WsVwypceYwhh9wp6zlXoUNg6xzTh5PSLcgr6e+Qgjb6G8GaymAvtPRrMg9WipsLYa62iaARjsbW0GU0SPl5n6IpPkFJzIzPsec0mUH5PM+eP4fppKJW0XQ3HdBdUejWuqIeesQ/IMLwvFXBKMoMfCmV3sO16RC+729pSgB6qVbP/6ttDsAexUoQVYmVVxuSPu2DVqnJ/h+AAavl46aQo4gKYkIt+pHDxAxrn4EE6lcvhz6qMpoPFGzWuGhNCXdS436oI2k8cfiqbVur/2VbcQsrp1HUc1SDR0s43SA2d2xOEdQ7KkMrTzbZ0A7regjIOOMqJ4TB78W0weermIhJWe1mqFPd0vEHR966Nd53LOcqDBbzzN+tn5smkJR9QSQ0/UtGNzsxYwZAlUPqwKn7TJlSZSuJyRW6iU44oe2WnSYyWTrD2nexGS0f/8oPBFpV7DU3rLUQkQ+RKDL9W+4aiEo59fIx2Vi1Xg3ew8IcAZXidcYTU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PN3PR01MB7255.INDPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(136003)(39840400004)(396003)(376002)(366004)(346002)(451199021)(66946007)(478600001)(66556008)(66476007)(64756008)(66446008)(76116006)(4326008)(91956017)(86362001)(54906003)(316002)(110136005)(26005)(6512007)(6506007)(1076003)(55236004)(186003)(38070700005)(36756003)(5660300002)(44832011)(71200400001)(8676002)(8936002)(38100700002)(2616005)(2906002)(41300700001)(6486002)(122000001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?PHGy9/DQeGlK1PlhPfH7jCH5C6DIcL0sQyrW3wTQKEJ+DU6lzOps1QBAG/?=
 =?iso-8859-1?Q?Lwnzu5XOyyJr0oRULl793oqtK3Ym8x7liIvxUs03s4vUy8E6AXl4IuXGOx?=
 =?iso-8859-1?Q?6rSdF5Z7yzdHx8ZIyR+FmKqunzHETeTNdvbQ/Ap6UZXmYAJMyqwBhyjgYg?=
 =?iso-8859-1?Q?8NcdlmOU3pa7Bu/OD5rCaQQNYmooMv0Crn5wfcJBcfW3hNfeBgO/7pnNvd?=
 =?iso-8859-1?Q?sqkWF3KxPVhuRpz7Nersa59sPBp/+GPnJN8stXpl2gXYnsv/9L3h4KnLen?=
 =?iso-8859-1?Q?WR3oNglFYpIUC+VInD/3kR7XADgUlpa9ky0388/wpFVFq1TibShhOMoGyN?=
 =?iso-8859-1?Q?9DjFCg6T+XFx52TVKot5l6kcQRxP/ghegx+o0gcsqHCqCrFVBMHkeeAm1m?=
 =?iso-8859-1?Q?Bf7Bd5SRW22qERYecwpu76fIV33MW5GRQW+DprAPwITl8JNRX/+Hd3N3gF?=
 =?iso-8859-1?Q?4+dlFPTi0e+J1Hw3+GSVc8eMmDwkkhPxaMOLO1LDNLCu3uf2ORubGPBXG5?=
 =?iso-8859-1?Q?ao73DT8fnl9iOBKeguI3dZ0fT5elOCdZ2GwS5JXwgbP30ufrw1OJk//hit?=
 =?iso-8859-1?Q?WxnR9xzNxSAzg6MLYBbmfem3hRhGLq2rwQF7P/LMAvM78vE36CM0fQD7Bm?=
 =?iso-8859-1?Q?QKnz2tt/9PUsMR0yqqOYZ9V7+fE47Io+plT19dXRt8/4wqH5Pxb695eEnb?=
 =?iso-8859-1?Q?wSW9nygf5Z+wk3jwfdtIscIYmjJKzIQetX1SnSrqCv3rY+54cttK+qu9yv?=
 =?iso-8859-1?Q?zXOi07OKkqGoxmTVmsE67bWJXJNtf4AHkgwd8gdWtzJAieqKc1FzlVzpcR?=
 =?iso-8859-1?Q?cU1Vm87CjxCmweabK+g3nKHMzz8FXmwB6AlFMcAHdyqDHyJcGOKH06Mfx/?=
 =?iso-8859-1?Q?BMvsK4oBLAJyGY/LqlS1YNmwzP8ICajriaq+LjkA8gWFH0DfqRRaxhwxIe?=
 =?iso-8859-1?Q?NdYsnPkuCrFaqdTlZSC2EQzcfgU4kiYwmmqmvIrJPGJGxQ2QOmRmM0/xIa?=
 =?iso-8859-1?Q?zqveNgUKeDBXbrf954niVpwpZhBPn/SPt2mS/oUY1Wn1ifsgZmC/RQ8Y4N?=
 =?iso-8859-1?Q?iEQKq1KuO+qNvbYsf/krLFlnUYTcvnCeBL+WtzAHF5IM2TpVmjs+hFV3h1?=
 =?iso-8859-1?Q?DykgC8jiM3TFT4HeXm7GGGXwRKBSapHb3DwrcLoJN0tQ4q6Xi5P7RWUG3Z?=
 =?iso-8859-1?Q?Tq6BDW+gVEJt+FZeVf2wBuya1Br074sWGtF91NLMiz00sH43GBqC/LbWU6?=
 =?iso-8859-1?Q?x/Y9tYWCHRQnTd0hsqf4vtg8mlC/yjVeu5ahFx6H2jNwvP5hx0hybwpZMu?=
 =?iso-8859-1?Q?SKX7Pu/pVLpL+hBiTRqnD4fq3yMfyEcmb21Z/cklBFk2QYZf/yRuCTHdDb?=
 =?iso-8859-1?Q?JGw8F2VGNYZezI5siv4AD/DbRVvs6WUm5YG358FhEg071vuv/4fnUk+Z2k?=
 =?iso-8859-1?Q?rtEUSphBLZFDoDLk61znPGWsYblFHbTAOBtTIWcWC7fu9tp/e1k9jVP8L7?=
 =?iso-8859-1?Q?1nOxbqYtSiyZfU1LgvxB5Wttyq4OsuIKTFOoJcB63049MOCyFSGMc8YUyt?=
 =?iso-8859-1?Q?Biz+r9HNiB4ZCj/VVSxhHvgbNnHxuwqRLTgDU0Xcot7D3UkaOPT9WuHLbT?=
 =?iso-8859-1?Q?ermYSqyMbS7iRcWxvtZuhqE/iJDYVqB1xf?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: blaize.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PN3PR01MB7255.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7ea748-136d-40b3-5822-08db3b7c4209
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 17:35:07.2638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9d1c3c89-8615-4064-88a7-bb1a8537c779
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VNXwmNTUlnPciRSfY2n2mBsma8HfEyVsX9iWE5TZRZmFsG1iZN9YewRl2dpfsKslasWzuPL9cCERGkvTcX+oUsJyLwxBA76lAbWbKkTPVsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MAZPR01MB5695
X-Proofpoint-GUID: dFacKEj5WTGz5ekLtbGnTCMVS5upKklJ
X-Proofpoint-ORIG-GUID: dFacKEj5WTGz5ekLtbGnTCMVS5upKklJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-12_08,2023-04-12_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=830
 impostorscore=0 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120151
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the logical place to put the backlight device, and it also
fixes a kernel crash if the MIPI host is removed. Previously the
backlight device would be unregistered twice when this happened - once
as a child of the MIPI host through `mipi_dsi_host_unregister`, and
once when the panel device is destroyed.

Fixes: 12a6cbd4f3f1 ("drm/panel: otm8009a: Use new backlight API")
Signed-off-by: James Cowgill <james.cowgill@blaize.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/panel/panel-orisetech-otm8009a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c b/drivers/gpu=
/drm/panel/panel-orisetech-otm8009a.c
index b4729a94c34a8..898b892f11439 100644
--- a/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c
+++ b/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c
@@ -471,7 +471,7 @@ static int otm8009a_probe(struct mipi_dsi_device *dsi)
 		       DRM_MODE_CONNECTOR_DSI);
=20
 	ctx->bl_dev =3D devm_backlight_device_register(dev, dev_name(dev),
-						     dsi->host->dev, ctx,
+						     dev, ctx,
 						     &otm8009a_backlight_ops,
 						     NULL);
 	if (IS_ERR(ctx->bl_dev)) {
--=20
2.39.1

