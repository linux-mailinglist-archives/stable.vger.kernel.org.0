Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF7F683754
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 21:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjAaUPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 15:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjAaUPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 15:15:09 -0500
X-Greylist: delayed 1798 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 Jan 2023 12:15:07 PST
Received: from mx07-0063e101.pphosted.com (mx07-0063e101.pphosted.com [205.220.184.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779F256EEF
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 12:15:07 -0800 (PST)
Received: from pps.filterd (m0247495.ppops.net [127.0.0.1])
        by mx08-0063e101.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30VJJGoR005577;
        Tue, 31 Jan 2023 19:20:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx08-0063e101.pphosted.com (PPS) with ESMTPS id 3ncsu32d0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 19:20:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRAyIpFOHt70zZSyvi3XNGibshc5LN4xUVipiYjqWqoIk/0OrEvYZel9aAGmBn5N+FyOKt6rWOd6hVIBr31joKXtprVBioHCO6aKzhLi88u/zeXZg/EGASq+YeCk+nlUBqT/pe1vsZ4/lItWUO5Ts9j/njaP23LydHrl9W89HEJ/IKFkl/wYG9K+SM980+QjFQuRz//QVoD3Yh/B4P1YCm/lJ7YgFwE5Zq+OC31Gaeaq8XdK9xZltmv3C+Hv+66CQ8dO+PDceJajky/jYyfeGC0FfZ5J/L/8r1nBMRSbt0Tl+6RKkMyGWK4XuBYK9AwFZqoI926pKoJDQIo3zGHpsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvQo2QTnFc6PnhwvyN4x0vgtasuhGfQIJ8BwhVIeqF4=;
 b=ie9XepCaiQjBwrvMpke0QE7LfTwu34sNcXR7jsRCsElSKSXl+bN8aBfop2mpI3fbjgF5caBbi0LcIbcBvdbM8jgUHHfJF8IVbDif2FYLTJhYd5h+3Gh1ntewfvtobKXFtwtREKt0YM7as9sfJKmTnhp64AxEMuREK0d+bdOWX0pPv3vkO6Y/q8B4vfB3/WpoiLQo4hsrSUDmqyUCRn/hN3bpDq5Kq4GX94/+QNCCd4cEmnzzfvNIJZXiK61umNGaZ+uOE8ZZgMWuoVgtd4HYAD7j0bbv9HhJ46kt/4UNZTTsS8za6GWlQg5BX6+NeiYvn4olTLhA6bkKYw1aqr8MUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=blaize.com; dmarc=pass action=none header.from=blaize.com;
 dkim=pass header.d=blaize.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=BLAIZE.COM;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvQo2QTnFc6PnhwvyN4x0vgtasuhGfQIJ8BwhVIeqF4=;
 b=H9TG4VPZapIDiph/vIpyMp+0RAxB5x+eAu4cPIi1kZhIkmMbv4PrDNnhe93cUzFJnQW/NtYYTTBhDWf9YwYJsHSn2Nxv7jdMUtI6orAp8rQSMCCwEQkijptVIpB7aS8ZNiNGJFl64PK3RWXckqiX/Tk+KLB+Nltpg+JVVdRs1tw=
Received: from MAZPR01MB7261.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:5b::9)
 by MAZPR01MB7328.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:46::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Tue, 31 Jan
 2023 19:19:57 +0000
Received: from MAZPR01MB7261.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::6847:b57b:6b84:28a2]) by MAZPR01MB7261.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::6847:b57b:6b84:28a2%2]) with mapi id 15.20.6064.022; Tue, 31 Jan 2023
 19:19:57 +0000
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
Subject: [RESEND PATCH] drm/panel: otm8009a: Set backlight parent to panel
 device
Thread-Topic: [RESEND PATCH] drm/panel: otm8009a: Set backlight parent to
 panel device
Thread-Index: AQHZNakBZUUgkrNplEWf8+OaQ+Z2iw==
Date:   Tue, 31 Jan 2023 19:19:57 +0000
Message-ID: <20230131191748.874884-1-james.cowgill@blaize.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MAZPR01MB7261:EE_|MAZPR01MB7328:EE_
x-ms-office365-filtering-correlation-id: cd34869e-37a9-4a5e-928e-08db03c023fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nsJA6NRSGCzia+CdMEUmfdnigkl/sQjrDaq4ZhiBcon2YhWVjhbrHFBhBg61TOAY/6UaNYP+qYM0yStRnPLStn+S/00/lARMUUxJmKb9qKCdXZpVnIPVEdmTdBO56IMnOoOwEPBnjl8TwFxxzk2j2/bCNhLfMvxHqSGThgKzjW5NhDaB8I4ekvkJHFBAdya4o5nHBecEWkyFWcyJSbvfSjU8JjG3zQt5jZqJfBQMeeVeaAnNZ2+74wIbQ1+3K8/MCJzyMwdIfx4onl22thGIbZo+hvvDKq2e/3Z4MiEbmM8dzUlXs/tXO3NO6QysIeSjbZsA3B68NeRl4KXzVCeNYW1uutqmc/X1ncQ60UaiLi0BNvBmECqjwUOWg/5wjl3sUL61w9+NZCmP/JIc1bjyqpCciUYcOc8h2w6UFbGSGOwL/Y59tLXVJXhuBX2xN7UDAZYkj1TG+K/FK2sJSWzvtQadqEZhhXQ4zEo96ykvczVaH+0q9h6I7k2OCdqamgrjaLzvynYTRx9b9Y0OS8mi6ZLeLVvn0Gts+EhnTkdoQ6e7I8c5yD9y2mMny3E3uGNUv47dsddKk31pWwKGM8YHJryHvzw11xneMew9vI1eMsDMUCcPi6I58KIwmgK0iKp9EE8rxQU7Hlvr+H4LpNCsgGO3ODp+ZvPsPrOUltH8w2UTSODyq7CgfDfWGaivmvSgduRUA4Iuhs8f8yPSqaPSig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MAZPR01MB7261.INDPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(39840400004)(366004)(346002)(136003)(451199018)(36756003)(5660300002)(2906002)(71200400001)(316002)(186003)(2616005)(83380400001)(6512007)(478600001)(6486002)(110136005)(6506007)(26005)(1076003)(54906003)(64756008)(86362001)(66446008)(66476007)(66556008)(8936002)(44832011)(41300700001)(38070700005)(91956017)(4326008)(8676002)(122000001)(66946007)(38100700002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?tFt9cHDKUrgRIEifjlIYUMhSBz55EdI6z4n9PUaZVSGzEFMxThKW6w7u2J?=
 =?iso-8859-1?Q?mLcuRqVLdeTLpfBSKdCSU+ELdeOD7dRaV1oWoiOUpzFodxpHiWjbN6nthu?=
 =?iso-8859-1?Q?AL/qf/3xqWfshc9wYmSkvfLtgQaEva7sJR6FuXLY6L9LkS1B+Oq0DlxzRO?=
 =?iso-8859-1?Q?Dm7McuBF9BHybSIszBeY/60c2k44vBi7ZI8LU26bwZ/VCZePDvo0PRRCUG?=
 =?iso-8859-1?Q?rJlvlPt72LwKbYD6mqeDP6sQp2AUgTOkiG7s6TZgLTWiiI5t7GOK8PmOYD?=
 =?iso-8859-1?Q?NOyhg0XIpBYQEGAWu+XhhSHf1YhCJhJYGXxRh5A5mR+ysCuSJjGSggbJ7J?=
 =?iso-8859-1?Q?cj8Y/szKXJ+DvrumP2GmzxKfGidHmQMFFwEPFaEJcVir6cflw9pPWgUcHT?=
 =?iso-8859-1?Q?1vrrU/rYAKg79qssIBc/4MtmcemOM23K3JQfpv+LcRkIyc+bCVIPsWEWg2?=
 =?iso-8859-1?Q?NpV8C53oq0l3vW5gkxaN25CQE1XcXpcPYp9HQrj5eMhjpmE9RD8pI6C/13?=
 =?iso-8859-1?Q?Az3tnTaMIi2ZK/kSuHoztjwyZ3zVfLIpjHB/HmA3Zz5BJGl6hN+RDi9fGT?=
 =?iso-8859-1?Q?aB7fpFmAKRlMt4VTT8ak+Z/qaKyq03XkPWNSBVB7ir7293SPFq8W2awvo4?=
 =?iso-8859-1?Q?YBVFk2G8dkptWq8TDtgPtBV8t3nGSPIAnpcWqOKwb3VIOH1gpOjGWUUEEA?=
 =?iso-8859-1?Q?SmcGUK3wpJ8T3pfRvNYPGu9Ca6N5rOR7xtRYWMZV65p+4sVerW6TKJ67T3?=
 =?iso-8859-1?Q?kYsZzmrc4yAiJBTUgkj3XDd39ddQ12aR3m5zpIyDr2bkUmGUAA39VoeHNo?=
 =?iso-8859-1?Q?zoeBDDiuOKtWHVKBpjLCb7WhOJXqmhA3rJBFqbCW1QzJlC5bUR0GIkDOsF?=
 =?iso-8859-1?Q?9D93sx2/xM6RBJXOE0eUZMPtPyeyZQ6hCO9YFotZHY3iV8LNi2Gs6HySf3?=
 =?iso-8859-1?Q?NOYUgx1EYfqkC7suSf4cTioenkVmwVRlUBrXxB0aSjuMDhJK3/ecRkD7F+?=
 =?iso-8859-1?Q?JxmIWZKFA+9yMNBQ1lvNaoLGrpks+4rui22Ecgwt87KKE4w7sipiMi2oiw?=
 =?iso-8859-1?Q?jAjZw3SytFULH8s1t6r5VgEkEWeW6jfeyRwFo7c6CO1gsbi2LBjR8gfViH?=
 =?iso-8859-1?Q?1lLx/quCYA+mCNO7gi2rYYx7KgYDJmMnL4F3LESxMlSbKnMKmwYkAhpFM6?=
 =?iso-8859-1?Q?gKHXp6CeDYMz9oXuPXhVZ4k3Ui036uOqQ2rtRqTbFJK1XCRwVVNweH5zdW?=
 =?iso-8859-1?Q?kSnnPu8W3EFtKoJEKQ4pK8gkYNMu5j6E5kMxjbwIzC6NIIeZW0EEmVfZuM?=
 =?iso-8859-1?Q?zam5L2D9OiKT41Y1b6MYzVoqXUlmloBUWle8F0qzaHsH+pu3NyZ6hdNWS8?=
 =?iso-8859-1?Q?dakbNXeA2GBmx0WzWf/JSLqku/1vTouy8tHiSfBelctJHe1hDv+fCyP6Cc?=
 =?iso-8859-1?Q?WlknK+Q7K5B8TwzWpYQV+rrb0LRz17dOa1F658mazRQkxR57s1BeEayrJH?=
 =?iso-8859-1?Q?TENMl7LAmmDcerne2YgGYqVeY3NFH9IsBBqd7VzHgohylhlNTdf0ZCbxH3?=
 =?iso-8859-1?Q?K+PXzhIA18c9MAKGV3BHSXuqH5ZzTwIrv4JowJI/16ycZeAwnob4cvBBSS?=
 =?iso-8859-1?Q?TqKIGMlcVaxK4iBddaAWtOxusK/Whp319x?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: blaize.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MAZPR01MB7261.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: cd34869e-37a9-4a5e-928e-08db03c023fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 19:19:57.4948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9d1c3c89-8615-4064-88a7-bb1a8537c779
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Ah2CtB+FbUIqs7vxqJO8qb7DTE0S36jhSGyMz/ljF9pWN1VoT9hAc7fLzjiuBIX8wFxN+b+LRUlq99lvLz8tg4dStHDjNqrxojpkPf/FCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MAZPR01MB7328
X-Proofpoint-GUID: rMgVotVNIMLkYlutfg-nnY2Biucg2A54
X-Proofpoint-ORIG-GUID: rMgVotVNIMLkYlutfg-nnY2Biucg2A54
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 mlxlogscore=848 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301310168
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

