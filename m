Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDF264CB7F
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 14:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237426AbiLNNol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 08:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiLNNok (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 08:44:40 -0500
X-Greylist: delayed 953 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 14 Dec 2022 05:44:38 PST
Received: from mx08-0063e101.pphosted.com (mx08-0063e101.pphosted.com [185.183.31.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3B826AB8;
        Wed, 14 Dec 2022 05:44:38 -0800 (PST)
Received: from pps.filterd (m0247494.ppops.net [127.0.0.1])
        by mx08-0063e101.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BECuSwU028947;
        Wed, 14 Dec 2022 13:28:30 GMT
Received: from ind01-bmx-obe.outbound.protection.outlook.com (mail-bmxind01lp2234.outbound.protection.outlook.com [104.47.74.234])
        by mx08-0063e101.pphosted.com (PPS) with ESMTPS id 3meyef8geq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 13:28:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WV7LfdwIHgsKqTJzrqvbeL28FHHCOpNiAViar3bOmofuqkNBKrOjxsA06aQbPfRWUa0ZdwTWNnajIjHTaN3fhGVq7+NjG+YKTbgGoIpzHUNn6KZbYnPf6uAvPdfyjNkPCOZDNRPmHAmA4Mc1bBz6qkQeBHrBVRxRMNUedB1VAOf+XAwjOTigguNJyfIajnV4xCTho73sQ0wmQC8FtfrBvk8iUP8zZVIHMU3kyxL9HqTjoaVgvu5z8zL1yHNbDZrbGM2ALeU80oYzyhz/upyPLAIT3R+A+CmoYnUsqXA6DzWxJIu3uzMpr1pMVLNPv7sXBSqmjLt31zjkPcsibaQQ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNOtqqH5EmMbKf2SMX9ZWg0NCBynpRC6ne5LzE/q7i4=;
 b=QXWTIin7Spv+OqU8u3WYZiVPbcphye7fke8SAFf4egzvzwe/ht/LX8ag8YdwmknFaQ1kJSkJyJLg1CCK+5I9uQYBHGjGT7MCt2i93oJApyUMbuxvquRZkABTSVcQH23ZD2FT9dMpH8JGlJ37x6rxthIBkBIwsWpKcXMr/LvcmOed66aL4D8FVAWI5FhPbaCiUVQP1kxP91WSqA9RAIIZ0MOEUqbLdEhqt55bV4RzqGv0e+EgXdXYOo5Yv8AUza7BM517QE9A1HB03XeDOq21bTWaafqTNC8holECiurqvl+M90nWTWBBIUg4EkNEwo1Rn6VygKxZLzsOCo/N2c+uQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=blaize.com; dmarc=pass action=none header.from=blaize.com;
 dkim=pass header.d=blaize.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=BLAIZE.COM;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNOtqqH5EmMbKf2SMX9ZWg0NCBynpRC6ne5LzE/q7i4=;
 b=H7eU6gqIcwQ9w73M/5FaOJdFG7V5ea/FplGhSdQDPI9an0uxkjdUMgJisXcM62Pkv0W90xRvjbSszOlaQZm6u0jT6+bFyacpAiVmJVag9QCqU1DqU6otciU9a3iXOVGSMu6xO7BOTI6kgz3s5WlAJPrl6udLXCnu3yITiSW0PA0=
Received: from MAZPR01MB7261.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:5b::9)
 by PN3PR01MB7415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:8e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 13:28:26 +0000
Received: from MAZPR01MB7261.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::6847:b57b:6b84:28a2]) by MAZPR01MB7261.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::6847:b57b:6b84:28a2%7]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 13:28:26 +0000
From:   James Cowgill <james.cowgill@blaize.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Philippe CORNU <philippe.cornu@st.com>
CC:     James Cowgill <james.cowgill@blaize.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm/panel: otm8009a: Set backlight parent to panel device
Thread-Topic: [PATCH] drm/panel: otm8009a: Set backlight parent to panel
 device
Thread-Index: AQHZD7/yW1tRwpgRQkCNYshTJ7Gg4g==
Date:   Wed, 14 Dec 2022 13:28:26 +0000
Message-ID: <20221214132747.198462-1-james.cowgill@blaize.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MAZPR01MB7261:EE_|PN3PR01MB7415:EE_
x-ms-office365-filtering-correlation-id: 76913d30-bd89-46a8-0e9e-08daddd7151f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jhVBT7GY9qq1vwyFeBmBrT5nU1dmPJfPlhUBxy/JCbuN1Yo6oftX4iw/9w1qf87tQj5+AKLHNO7NvswsN+mwozbEtmathTDxx0y/ZuvXGIhiRnLAkoUbOhrN3Nt7y+uyDsaW9n4eSZ6EWxrJbikeZ3eavMrKpSBlDua65T0Tm94dNhse+21vjHm5mr6f1Rejk9zyCqAQZtAC01jhvoCvvdmlVUBavEkbpKm4UTV7jMuwEn+w5BWFm9abO4vAdJa8j5Hh8dAAkMs8WMxxASm4MvcKiSPaViY7sg3cyVs9cgTq+vGhkT82ISljuOzPwj7z2R1itLb960t+papl7PCNvcJCkSJwa7nxNJVFHZh5/ETCmDD1gYvlhq53E11ZnbNqsJ8Krh8PDYdOG+bxokb+CNhZe94AznP1+gkth1SLDjf8HeG9sAdWpjAibKLSaFx/zhrhIGxVS4PPQGGl2G2rdFamF+bLuzd0uW8YA3oQvB3wwzZkVLy/vasEGYgykGwb/avbcGuv78UgdVBDVAuIJS1srgeQN/vW4G96sR0U5OlmEFDZD5wVVnqBAOFrYDL5qGuxzCB/H9g9HV2e6V/uAyqQrf3SIM+pTJdScz6OejhYAhY4eDZoX5bML75yW94Rg/MxCS169XgwG2lDI/LjSHGeVILmnvdRLe2xeNqpubKGs9q9h4wJpU98BRPM2mJoc7UeVHz6jgUrRYKeAncKWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MAZPR01MB7261.INDPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39840400004)(396003)(346002)(366004)(451199015)(6486002)(38100700002)(38070700005)(2616005)(26005)(1076003)(83380400001)(6512007)(6506007)(478600001)(71200400001)(36756003)(86362001)(186003)(122000001)(64756008)(8676002)(41300700001)(4326008)(76116006)(66556008)(66476007)(66446008)(66946007)(8936002)(91956017)(54906003)(2906002)(5660300002)(44832011)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?u52aPcwHC+vDZgRo726AmTmNKgvafWq649YWeQybTpi23T5S8zk0eLEc29?=
 =?iso-8859-1?Q?LfBaFzF0scse7vk503EzVeo3AQbXk0JZhZYojYHRzyfDY8oSo57OnKYOTL?=
 =?iso-8859-1?Q?agQfrkJNHf348WBS5j4BFdhYRd/P+pv4JH6xL/WEvlcZqtYjOH0ccl8ndJ?=
 =?iso-8859-1?Q?k42pt3zk7q0nIGxpmAPKO6lTSHE+UTyU9Of8NAs3D9ukz8bwr+2r99jEe6?=
 =?iso-8859-1?Q?d+uScRyaah0osrmt6bJzLoZAzm3h5bnfPaMXTgj38Z6OOjdFydt1C6wd9h?=
 =?iso-8859-1?Q?yrEQsYIyln7BB9xNfOgdGu8HYz2+22fCTMSD1J/CFPy9t/hRZWb3epwwmt?=
 =?iso-8859-1?Q?91ozeFpcM/TjNVBZEZY0E0H5AQFiT2BkzObI6kehSsQVFCUZr/Ldo1/Snk?=
 =?iso-8859-1?Q?f+a2OpM4njBmE/iQWKw9tjzQh5pVUt9ZMf5/7OgHuLP1AyU8IkMtIAEJJx?=
 =?iso-8859-1?Q?RwV6rczpCZXBO1mRPmSFh2UrY+Bfgh4GPzXN3zBT5MOwo7NT0SKUZCF1f4?=
 =?iso-8859-1?Q?WhnKJBvS9wi6bTW68tFvAgsCs2RpYpfmQ8mE4D2hVrxgtdY1dgz+CvKf2v?=
 =?iso-8859-1?Q?xLy17176h9Nd07JqY6vuqydSheJIwLN07umyaZIFCWdTDVgw8fcrP6/dRS?=
 =?iso-8859-1?Q?Nf17q259c2DdpwbiyXsvsKpLKjso410tkS0H1C3ZEDDAOgmRlR1dSBgRgU?=
 =?iso-8859-1?Q?dj1uGVvwUNBe/2W9u+NGPVCRSMfE0zQiA+RGD1q8tXsRzlIOKUPt2bj3jx?=
 =?iso-8859-1?Q?9QlRKFuIAbWfE4QfZCkzMml8hnqecac8Jw8/pVIh73otHHNhFzZKTfoO1W?=
 =?iso-8859-1?Q?lhyRtpwK6tGwDd6BCERE+eH/DFWEEf/YIFViScJ9wJFrjj5T3EIQXL/ziV?=
 =?iso-8859-1?Q?0hrzrrYc5WOyoMfgUasAr0FTEHCrB0vZ0d4DEr0doD5Pt9yx6I0yQauk0n?=
 =?iso-8859-1?Q?bVPKEoe9K/wrlVjUF9zM2/xt2iQv5/UsXzXSbqvN0obQRQ80wtQhnj53i7?=
 =?iso-8859-1?Q?z4ZiP9vbw+U4DCl86spdXP5uj5wiLSvGJyjHhSUFvzGRLK+MlwNkUS+/eP?=
 =?iso-8859-1?Q?CYL1JPGN8HA+DZle0BD7FSx6QDenR7gExJ9UnSSkKKq6OvbwY2ABv+LXFD?=
 =?iso-8859-1?Q?A8UAZlJpchrBz7LwzbNQaT7hdkXYLv6rRLTDfkV1jnRGC7M0DhQEO6MyaR?=
 =?iso-8859-1?Q?+KurjXkN6NGh6gXM50GRwaP9d/z1pyPAuRebcJnLz2hS1vnycMCeg3CvJM?=
 =?iso-8859-1?Q?AM+PYc1bc+6VZpXAg+9RWgxgCXRhL/q5SF9QQg++h2NoRE2YFO8kPPIh1l?=
 =?iso-8859-1?Q?JQQuxbN6b7Yl0KoWDlm0RTJwZ+dK9a7xtVOGF8DXmJ3EQPoSQMhpqjXPRA?=
 =?iso-8859-1?Q?1LFCjT51lOV93DpMn18D1PdiQHTdBdV5LKh8TN/ljLmbHQg+Cibgi9wjMy?=
 =?iso-8859-1?Q?b8ymtJCVX4E37NImEoE0f7m+N5w7oKAi3Md6nzJb9pN62C2SBj8WcDwnmC?=
 =?iso-8859-1?Q?IEEBeqYH/Hs8TVkhnxy751RmJ1MJfiWH+Yu6MUcaQXntyei5x+5GnOUMEh?=
 =?iso-8859-1?Q?DKuAMdA+Nnw2vSlnCzxv6vdblmH+HSkpXOQJJViD6FdanmW0pRN/udpY3M?=
 =?iso-8859-1?Q?mT8Plvt92aogKxGTHSVzzor19+HaE/xl17?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: blaize.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MAZPR01MB7261.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 76913d30-bd89-46a8-0e9e-08daddd7151f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 13:28:26.8098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9d1c3c89-8615-4064-88a7-bb1a8537c779
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Al0nFxncY3BRCDadgz0KPJz7WUNNDgTfInr/+0CI554GYYP3kYr8nRrZfNq5xhNS8AupVa/KlGkH1UhDhlIAMjSqocwNn9qLdFQTZG1ks50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3PR01MB7415
X-Proofpoint-GUID: HFXwl7dgix38BolGhWU89Mw9Jl-nPBzk
X-Proofpoint-ORIG-GUID: HFXwl7dgix38BolGhWU89Mw9Jl-nPBzk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_06,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Reason: orgsafe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
index b4729a94c34a..898b892f1143 100644
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
2.38.1

