Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016224E8934
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 20:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbiC0SK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 14:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbiC0SK5 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Mar 2022 14:10:57 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07olkn2054.outbound.protection.outlook.com [40.92.15.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D0B34656;
        Sun, 27 Mar 2022 11:09:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkkpofr0oY4mwalITBGCLd6X9IQN+QQGHf3YzMO8b39LeFgBsPU5LNdylZ5ThLbvrt0CTXYHNOQr/P3GK1gBjz6BGuo6n0MMxa8mbe/p6MB5VZeD49J98dNo4mOWquK0EuEj+LTABXlSjgPkUkBb61KP54hfP1aDYGmY69hca4cbjxZXfp0iQn6nq2jnWy6IiucGKUnpEOx4oNF2JmCeFVzrphbzBHUGktKI3BeCRoYAAXHi2fJeC58+fdOz5TkPo6LHzRSFRrVu+f+pbv0ReRv6KPYHpXkEUOhItsbUHaYZ0ELvUWxxJr8B+OYBpswD2xBw0FZFJZmfvDMdBU/vwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFKoQI8qtTgwudEHVjf9qhOg5oV2gYjmdqDJG42AWBY=;
 b=koB1Rnqd1anMBUcwuVEQlzNGcHw6YIh+TNOFbB2P77WLeq9wUUeIIwj1u8p3H6MPV+mpwfbFCGHJM145h+5h0Nq6mkszG/wYaeTQX4vZD+VhB0UeGt2AB5hbAArZcFKm/JzKCRNCIc8iwHKwTQGENv5WrASajbgHqTDzxe4EYFUdpR/pTIkpRFoOBr4H87y3gV0UkU6KdnvuQ2gpNGh6YPcN8Pyh4IXWyfWuUZ7fOr3i2TnoyhG9l28OFptk1kyT2C2anEMcxt0/ngg4xixGLETyJ7cEjEWZh13IgLmKE4Pv+CpdWLNXPcDn4tfyfprIg8Qy5kPNn8yOfuGqYs/5Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from CY4PR04MB0567.namprd04.prod.outlook.com (2603:10b6:903:b1::20)
 by BN8PR04MB5778.namprd04.prod.outlook.com (2603:10b6:408:a3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Sun, 27 Mar
 2022 18:09:17 +0000
Received: from CY4PR04MB0567.namprd04.prod.outlook.com
 ([fe80::451b:e5ed:c1a3:4070]) by CY4PR04MB0567.namprd04.prod.outlook.com
 ([fe80::451b:e5ed:c1a3:4070%5]) with mapi id 15.20.5102.022; Sun, 27 Mar 2022
 18:09:17 +0000
From:   Jonathan Bakker <xc-racer2@live.ca>
To:     krzk@kernel.org, alim.akhtar@samsung.com
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Bakker <xc-racer2@live.ca>, Stable@vger.kernel.org
Subject: [PATCH v2 1/5] ARM: dts: s5pv210: Remove spi-cs-high on panel in Aries
Date:   Sun, 27 Mar 2022 11:08:50 -0700
Message-ID: <CY4PR04MB05670C771062570E911AF3B4CB1C9@CY4PR04MB0567.namprd04.prod.outlook.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CY4PR04MB05677B4C4E26A8A179F6ABC0CB179@CY4PR04MB0567.namprd04.prod.outlook.com>
References: <CY4PR04MB05677B4C4E26A8A179F6ABC0CB179@CY4PR04MB0567.namprd04.prod.outlook.com>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-TMN:  [uUYvmy3QjvIbmARDGHzr5iugghlbHRmzJjCi7GnE28JI5+m8aBTL1r5eg0qWb6TS]
X-ClientProxiedBy: BYAPR07CA0031.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::44) To CY4PR04MB0567.namprd04.prod.outlook.com
 (2603:10b6:903:b1::20)
X-Microsoft-Original-Message-ID: <20220327180854.4857-2-xc-racer2@live.ca>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21a008ae-231a-4a23-d8ef-08da101ce7e6
X-MS-TrafficTypeDiagnostic: BN8PR04MB5778:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KK0ykxToTmj01VFGW5KzIqdwRroyv4C/6NdEszLhbLjPPBpWB14ALtBHojZ/uXum0rf/3epreAf7/KIndlTIhBh/F2Az1J8YbKEc5h8n9rA+xqB6sYGRBR9BVsIyAwxWEnuQIC8mmOnT6ozyzWnfgNc6OUEVay+PiuMdL4YJKlm2TGgAJpdxdzyTSUJwvtGvxk/vtD+rGgKVRZzJRWmAuda7s5lGQkbr6R7Tx4jZ7Gd0CgpyzLtRH2vW/nd8mcpbzBN726SpSo8SUVmGqs0MkC1KFbBFTZ1hXE8u2I9fGtozNCMtnLgNcf9xqBhH+kINHcrAGiIEkwFa1imz9lyktGhHVITR7GSzf8ueaxeJd/bQg1iOPhgHY0C2i9+qdFXm36a6X7xPwHi7AITlrpQoBjlQbc2IwZTj0USa/43vkFYuRkfiTbpYIH9C5eXPbTxvuwuRfh5i7OaEFqrV1hsNv7/JpjEslayY6nstKqEv6olGjxAam7C6BYYW3jpA/qWv89LFHU1gYHMKLec1vbjjBirqEbdPm2UIyE0bKJdPcewSrEYJ60XsRTPCeNKadTktdU8fo1ZA7PKVUubbbishxA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8y8nSEKwF3hjnESNh5S2mTCwRYpHDZwSxVIN6hsq4boaCYP0VMq7lHczK696?=
 =?us-ascii?Q?5X69EgIs+btw7ZW9sImE7hA38k1cBOmORC4ro8iC67usJF1ualoDz18T6N16?=
 =?us-ascii?Q?/ADJTmLpNtFXfQYEZzyjGz5y0xMV8cPNofnCy6uzkhG081msFNIbqIYszV+V?=
 =?us-ascii?Q?7pGhmlTbJT/H0+/oxTXXGRAYTGcWEuVPZr8SHiRcE8DZ7s6cI1L965FfJBS6?=
 =?us-ascii?Q?iKdL9IL8ox0R1oTlus4rus1FFu4HMWAf38xoBy+FLVTyDsw7k5zVOPCcUJrf?=
 =?us-ascii?Q?+ka3dFDREFW+CaiN4in5S85sM/7S1cWKBdwVCJIfgcb2EBlHccz4INp3Nkao?=
 =?us-ascii?Q?lx/lFhn33QqdR7kcGYYUAUspp+0Hdc3VZnEW28Ky8PLj042UquCdbfikCJSa?=
 =?us-ascii?Q?SR0TB0J6kX7MsKlW6yU4aumUxATLx+cCJoH662BWsB1OruiH1FD24/HQjYbb?=
 =?us-ascii?Q?sTcCTuS01BIVjtCnAaO1Pb/LWRgpc8WB1bUPGOxBEqFBt1gcA/lchhLPjpII?=
 =?us-ascii?Q?64PPRbfhjYYaffrX5K2jN+Qhcp4jVPlge+l27pfvVmZDC0BNvT09liOPzKQZ?=
 =?us-ascii?Q?vLyw/YRFs4xSdPOrjclwLbVOxrMdYH5saPBluDpynjw1ObYxJVdwGna6juH/?=
 =?us-ascii?Q?rmFOrKV77ND4FU3qm1a64MN6AwuqCEkusDybPdvvOZdAlFz3NChQM/Zuc52N?=
 =?us-ascii?Q?/JPYodFtXH/IvGGV09EnEd7npMxbt4X4xRgFsw3EojQQtHqyJiMrXQ5iwXL7?=
 =?us-ascii?Q?7v8mhAB8JQj9mNt9/g7fGGJ1ss+ehsKxLuw+2UQ6rRUzcqXWsiz0v81Dxixq?=
 =?us-ascii?Q?/cm/fk8OdCT4dO8ZTuEXEsntcsFpV+3Sona6WM7kzJ6bNvZ9oe7nERn5wmNS?=
 =?us-ascii?Q?3x6Auu3YSTOSc0x4HM+SH3oa+GT4gJrdKcv6O1DiINy8J52UjQzVY7I4RaGN?=
 =?us-ascii?Q?4GjGjHZixXj+tLuC9sI5rNsfAkosyDj2ugpHK6EM+5/l4xQei/u4XzfonqSL?=
 =?us-ascii?Q?beAE7q2ykcoxAzgxRys5Ll4Xx28KP5oZ87FiBdk0F/6Nvd6AP6b15A/tLkMI?=
 =?us-ascii?Q?uxL7Cqw9ehChzUwwHqT+0RDq+0YfIpfETtPD+VSC/Os4e+C8eEg9dO1+sVvO?=
 =?us-ascii?Q?BwrHmhxPYE2V/irKosj4IcxfUDe53YBbePN4hJcExfBSZ9pz3B3mbvlhnZA9?=
 =?us-ascii?Q?zEb8D2nL0KpRMqdmj8fmQuXY+xui7HcgyH255pE6EnMMoCjmNDOm3MJCfyOv?=
 =?us-ascii?Q?0IEjtVQFeLc69FXU7wxaMxHh4Lic6cMEuPAVSyk24n2Y9XLoX+wLSrerlixC?=
 =?us-ascii?Q?KwN6LryNXcJ0MYHxVcGXzshwEcNyghzyIJ5otK80mhW2PPy/xeB9NJzR+uCr?=
 =?us-ascii?Q?MijNM2hUQXIEQ6UR71KjfGaqTotR88gOxIaoxuhnB7eh7wklr54GLNnkWxY1?=
 =?us-ascii?Q?5NYyNEaqSWK0ezznHSfxHgZODfT4H/5ptid8ZIwgIElMFXAqamdjYKBvwdo1?=
 =?us-ascii?Q?B1LgJG7M4sQwPaY=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-edb50.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 21a008ae-231a-4a23-d8ef-08da101ce7e6
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB0567.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2022 18:09:17.0890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB5778
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 766c6b63aa04 ("spi: fix client driver breakages when using
GPIO descriptors"), the panel has been blank due to an inverted CS GPIO.
In order to correct this, drop the spi-cs-high from the panel SPI device.

Fixes: 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
---
Changes in v2
- CC Stable
- Put bugfix at start of series
---
 arch/arm/boot/dts/s5pv210-aries.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/s5pv210-aries.dtsi b/arch/arm/boot/dts/s5pv210-aries.dtsi
index 160f8cd9a68d..740036a61c8e 100644
--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -564,7 +564,6 @@
 			reset-gpios = <&mp05 5 GPIO_ACTIVE_LOW>;
 			vdd3-supply = <&ldo7_reg>;
 			vci-supply = <&ldo17_reg>;
-			spi-cs-high;
 			spi-max-frequency = <1200000>;
 
 			pinctrl-names = "default";
-- 
2.20.1

