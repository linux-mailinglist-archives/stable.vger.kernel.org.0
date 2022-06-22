Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58530554F8B
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 17:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358743AbiFVPjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 11:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358182AbiFVPjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 11:39:54 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2129.outbound.protection.outlook.com [40.107.22.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCAA2E6A4
        for <stable@vger.kernel.org>; Wed, 22 Jun 2022 08:39:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3u2Edl3HMf5pwMypxGQg4sq4zTOV/o7rds4Dgf7RbcxFwlRFKT1qI1+pqcV4z1M4oz/4A3b0ZtV02TqU/gzgF6MnC57wEO7HU1qTuXeK57ERp4KG/omNDMjs9owwGIV7MlxZiilAHfvIa012x7U46fURoR7hOExl/KOWVnFE9nv8kKSlgHCJUYBdUIKcPHv09xyLdydNSzApA51MjVG0mni76RFb9vmQPWUvlHAiLojIEUGCR6jT38XdHJJxj6/UjFpodL3Sy9GPMdOGrSybk6mOkLHEmZ3Pt9/MjZjDtNCUineZr8vnuUlwcdPWAPE080l1/lrxGFQO5QqkrKo9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hyi+l1idA39OqrKyzb7se6JpoIunlP4xOQ8l68zEJVs=;
 b=WdZei3b2PXJglzG6hoGukFDvKOhgYeNNA2TRTLOIBIxCINKzqtm23nuu/lVTiL4Yv/uuE2Y5xFUkL9mjmKXkN2zS51s8k03BiG7vAQ2AJJiwayYzi9X5+1JA+XegUPcjVmspYeklmNL6KoS91jcyso3cWfhV8unTOn8uae4VNInHDXHFG4Zv1KxNejBeBe+aW05ZtaDN09weMWJzpo7KpNuehjEOCHCjOnn4YQ/IihhPjL/VIjd7vjGQNIxYOs6vSM/WHQ3WjB/wiDhzsTMieZyG4CxHbVdCwStsW0ebpXbAwMTolBW5e2mur5jZxk9zG/UAhxL4yDdmeJEMf1M/TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 212.159.232.72) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=bbl.ms.philips.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=bbl.ms.philips.com; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Philips.onmicrosoft.com; s=selector2-Philips-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hyi+l1idA39OqrKyzb7se6JpoIunlP4xOQ8l68zEJVs=;
 b=nCmadzPPEFRk//uglRLpBtMpI53CiCnpan+KdepRQiuQivKXpIrzNhxkZgUxRn02wwP/1G9dsMvTGhLBoydtWH2OYYG9gXXcoA+HWcxwFlfNghG1ieOZRnGHk+sk1SBYpZvcXbe5gelXio6+2XPIiejmdKLxyRensrmFwYQecT4=
Received: from OS6P279CA0047.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:31::14)
 by DB6P122MB0040.EURP122.PROD.OUTLOOK.COM (2603:10a6:24:2::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.22; Wed, 22 Jun 2022 15:39:51 +0000
Received: from HE1EUR01FT072.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:e10:31:cafe::2e) by OS6P279CA0047.outlook.office365.com
 (2603:10a6:e10:31::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17 via Frontend
 Transport; Wed, 22 Jun 2022 15:39:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 212.159.232.72)
 smtp.mailfrom=bbl.ms.philips.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=bbl.ms.philips.com;
Received-SPF: Pass (protection.outlook.com: domain of bbl.ms.philips.com
 designates 212.159.232.72 as permitted sender)
 receiver=protection.outlook.com; client-ip=212.159.232.72;
 helo=ext-eur1.smtp.philips.com; pr=C
Received: from ext-eur1.smtp.philips.com (212.159.232.72) by
 HE1EUR01FT072.mail.protection.outlook.com (10.152.1.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.15 via Frontend Transport; Wed, 22 Jun 2022 15:39:50 +0000
Received: from smtprelay-eur1.philips.com ([130.144.57.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 256/256 bits)
        (Client did not present a certificate)
        by ext-eur1.smtp.philips.com with ESMTP
        id 3ujLoYic4l9Zi42SMoHNJq; Wed, 22 Jun 2022 17:39:50 +0200
Received: from mail.bbl.ms.philips.com ([130.143.87.230])
        by smtprelay-eur1.philips.com with ESMTP
        id 42SMoEnQNK1kB42SMoyQry; Wed, 22 Jun 2022 17:39:50 +0200
X-CLAM-Verdict: legit
X-CLAM-Score: ??
X-CLAM-Description: ??
Received: from bbl2xr12.bbl.ms.philips.com (bbl2xr12.bbl.ms.philips.com [130.143.222.238])
        by mail.bbl.ms.philips.com (Postfix) with ESMTP id 5064F1832D3;
        Wed, 22 Jun 2022 17:39:50 +0200 (CEST)
Received: by bbl2xr12.bbl.ms.philips.com (Postfix, from userid 1876)
        id 4C1E82A0010; Wed, 22 Jun 2022 17:39:50 +0200 (CEST)
From:   Julian Haller <jhaller@bbl.ms.philips.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Julian Haller <julian.haller@philips.com>
Subject: Re: [PATCH 5.4 1/2] hwmon: Introduce hwmon_device_register_for_thermal
Date:   Wed, 22 Jun 2022 17:39:50 +0200
Message-Id: <20220622153950.3001449-1-jhaller@bbl.ms.philips.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220622150234.GC1861763@roeck-us.net>
References: <20220622150234.GC1861763@roeck-us.net>
Reply-To: Julian Haller <julian.haller@philips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: dcdd4e2a-b53b-43e1-5c0d-08da54657200
X-MS-TrafficTypeDiagnostic: DB6P122MB0040:EE_
X-Microsoft-Antispam-PRVS: <DB6P122MB0040307522DF1B94EFAB32DCC4B29@DB6P122MB0040.EURP122.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kE6thqfPOjVBXRC4zWCodG97Rj/5ZXVmsCjQZvBa7eILoB4Lwng+96OXAldP1ip2NKzAWoDfSPQlV+LalpvG5Ft79dzUVo0QWfzkbqnC5Y6tzZheqeN/uE0rpHmvhZ3q6svQkroJwsWvC37orn50hkJ3c8Yu5XsNlm58pWiLVKPPRyfYo7Nu/pRUMBP9IgVQ5035Uje0Xb5s3bm8oejCzSib5P5KeHMIM7L8oH6szC20ZpXhLr7K4sEccj03o39caVEgBt8+IyzPPIxdP7iKpqSn4G1fRb5GKkn78NV9IMuaWauh6rBIslH5Pgf4tAAZdTgSgK6HHs7O7pIW/27UiDJRq63leA/d+L+a/Rddq1jdtxdYqQgbECnw9qDhj9h5gv2MFsxdBfuLYKMAc8BoNlF+D5wgR4AnQ1fBQk1lvuTp/mphAZc+9fKdDVTFa7oUF8C0sguSyjnXcGfhiByU0C/gx0FpXFXl5Vv9uIehfMDPSCxjGaTFGcbP5eByWm1kBnQ66H9ZZ7BfafvZ0zxZgHU/w87++LaPQ5DwOmORsfdUQ6jxJEK/pfGbaiJf8ex7NsQwcEoNIYKJlLxVNd3jApmM7WPW05kh32HKSPrJpyPeiNO95N+chRc/kPrHnAWdifDd8RVJF4CdpuWw6A9GQd0Ck/PS4QaZV9dc1prmYCR66w6ERtViX+LEgVaUQX04hFVr6vd5Cx9dgpUtoVEdXgem4AR9tIinA+2YuIvhBIeyEbiIZnEmdZ+BmuK+givvIS1xWSYFoVYmpVe2dLdKg==
X-Forefront-Antispam-Report: CIP:212.159.232.72;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:ext-eur1.smtp.philips.com;PTR:ext-eur1.smtp.philips.com;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966006)(40470700004)(36840700001)(7596003)(7636003)(40480700001)(82310400005)(356005)(82960400001)(86362001)(82740400003)(40460700003)(26005)(42186006)(6862004)(36860700001)(70586007)(186003)(8936002)(478600001)(70206006)(2906002)(5660300002)(1076003)(426003)(120186005)(2616005)(41300700001)(336012)(47076005)(4326008)(107886003)(6266002)(316002)(8676002);DIR:OUT;SFP:1102;
X-OriginatorOrg: ms.philips.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 15:39:50.6504
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcdd4e2a-b53b-43e1-5c0d-08da54657200
X-MS-Exchange-CrossTenant-Id: 1a407a2d-7675-4d17-8692-b3ac285306e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1a407a2d-7675-4d17-8692-b3ac285306e4;Ip=[212.159.232.72];Helo=[ext-eur1.smtp.philips.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT072.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P122MB0040
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Wed, Jun 22, 2022 at 04:49:01PM +0200, Julian Haller wrote:
> > From: Guenter Roeck <linux@roeck-us.net>
> > 
> > [ upstream commit e5d21072054fbadf41cd56062a3a14e447e8c22b ]
> > 
> > The thermal subsystem registers a hwmon driver without providing
> > chip or sysfs group information. This is for legacy reasons and
> > would be difficult to change. At the same time, we want to enforce
> > that chip information is provided when registering a hwmon device
> > using hwmon_device_register_with_info(). To enable this, introduce
> > a special API for use only by the thermal subsystem.
> > 
> > Acked-by: Rafael J . Wysocki <rafael@kernel.org>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> 
> What is the point of applying those patches to the 5.4 kernel ?
> This was intended for use with new code, not for stable releases.
> 
> Guenter

The upstream commit ddaefa209c4ac791c1262e97c9b2d0440c8ef1d5 ("hwmon: Make chip
parameter for with_info API mandatory") was backported to the 5.4 kernel as
part of v5.4.198, see commit 1ec0bc72f5dab3ab367ae5230cf6f212d805a225. This
breaks the hwmon device registration in the thermal drivers as these two
patches here have been left out. We either need to include them as well or
revert the original commit.

I'm also not sure why the original commit found its way into the 5.4 stable
branch.

- Julian
