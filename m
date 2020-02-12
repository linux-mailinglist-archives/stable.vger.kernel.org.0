Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4793E15A8AB
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 13:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgBLMEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 07:04:36 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42960 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727860AbgBLMEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 07:04:36 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CC2R4Q006246;
        Wed, 12 Feb 2020 04:04:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=pfpt0818;
 bh=KYPxeYe5iUXkUsLpwcrTvWlhZhiK9RMaGy1e6FE4u04=;
 b=OPqUZIJ68pRG8c/I1wnbeimjYEUhcYy1X2w/c4sjoFyLs9kZhihGu6zPm+MjDcoffy95
 uTxFDD6JgPAEPaG9eJHnvkmXhtCxQArPbXT3p4GGYs9l9eoWBT9xm0bw/xlRj8xvTi2k
 YT6fBylf60qCRg48XHjesAZTgLku66Pl1rRMA4SaraQuuU8muw40fNSddEU9c6YQrdW1
 Fn4HK+DgRTNONmDgeKBfMva4JzQWpVl51UHplu+WGCk2kB3mBxhvLgucmAG8ZyYD2ikL
 qyPCLp4ZPzI53V1gj0kbJrAtbKd3yjjJj596nX/0T95wo6WOLXgPYt/dNTz8slQYJMzU qw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be29cm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 04:04:24 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 04:04:22 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 12 Feb 2020 04:04:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AxRpe2PPRjx2VyUcYGzpVr0Dd/GacUXa0O8032Yi/x+sadHlDmmTJOVzA3mJAwysrWVl+aLUlqMl35/18lz8+I6Gju/YTzn8ykI2lr1YYZUnGQHdRrt7w+vrOTuOxBbEkttVUmJDXjFijHKEH957b7UbTPicP6UdSsNXCE3OhRLHPFTxs8TY2Pri0GuiK19dDV/FWaYZkHTRUK7hHvwIN1zjLgTyh/NVDXlqHLdQF/LsgUuk3LpPcPIMisOv07xhFucrHIV4w8V+MjMlfK/45fKQ7YUkE0dJ0un2/YQFep5nOCgj0JFBPhK+fxh8iR5fjn3KqNKC+weKCAcgIO2Kuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KYPxeYe5iUXkUsLpwcrTvWlhZhiK9RMaGy1e6FE4u04=;
 b=LEwT8eQYBwNjO2GA2KEwLRe6B8bfFiefomFaibpVAc6J5MoZRQQvKv6Psk0fo8Zfj8w0QVAXINwW2YZO0IDP3bD6rGYYad22JUGNLPfF9z+qpncK2IvIjucV6Psnua0bMP7XVciHKrQOzQ9Bw1XzOKzVRsWwXV5WFY3JzBR77zDK5XILsx4+nTgHEOyigUue0pDjP9U899Xzj96LXrSGMv8M+Jvrl5GELw/f9pCRqMezHG1MKQjLSNzqkH1/1mJ4v5FzRqhfiWEeg0IcZgEbzyO9BJ5hKrZXEq7ZX0yCV6R0TVZORqJ3+f8uanOTGPuDgx/irjS7zO/tcv1lFxds3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KYPxeYe5iUXkUsLpwcrTvWlhZhiK9RMaGy1e6FE4u04=;
 b=AlaBSCSvW09US+xXtetsoYP1YxQVA0I6cXsrXXqZ7U8Nldy9KMOsjErs35xmOdCFFzUhmLQiwJ8hw2rTcl7KZ46DWUzIkzCCXq3A62uUXfvtXfGFAMDOLhUmaUr5s2gneQlMY/IYeBar0M2SF1sUbh5yhOVjpg2Kgu1oxPe4IRc=
Received: from MN2PR18MB3408.namprd18.prod.outlook.com (10.255.237.10) by
 MN2PR18MB3512.namprd18.prod.outlook.com (20.180.247.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.27; Wed, 12 Feb 2020 12:04:21 +0000
Received: from MN2PR18MB3408.namprd18.prod.outlook.com
 ([fe80::b96d:5663:6402:82ea]) by MN2PR18MB3408.namprd18.prod.outlook.com
 ([fe80::b96d:5663:6402:82ea%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 12:04:21 +0000
From:   Robert Richter <rrichter@marvell.com>
To:     Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>
CC:     James Morse <james.morse@arm.com>,
        Aristeu Rozanski <aris@redhat.com>,
        Robert Richter <rrichter@marvell.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v3 3/4] EDAC/sysfs: Remove csrow objects on errors
Date:   Wed, 12 Feb 2020 13:03:39 +0100
Message-ID: <20200212120340.4764-4-rrichter@marvell.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200212120340.4764-1-rrichter@marvell.com>
References: <20200212120340.4764-1-rrichter@marvell.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HE1PR05CA0226.eurprd05.prod.outlook.com
 (2603:10a6:3:fa::26) To MN2PR18MB3408.namprd18.prod.outlook.com
 (2603:10b6:208:165::10)
MIME-Version: 1.0
Received: from rric.localdomain (31.208.96.227) by HE1PR05CA0226.eurprd05.prod.outlook.com (2603:10a6:3:fa::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 12 Feb 2020 12:04:20 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [31.208.96.227]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbe6e404-7498-42fa-47dc-08d7afb3b1e3
X-MS-TrafficTypeDiagnostic: MN2PR18MB3512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR18MB35121C5ED775CF976E659316D91B0@MN2PR18MB3512.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0311124FA9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(189003)(199004)(8676002)(66476007)(66556008)(36756003)(66946007)(1076003)(6506007)(81156014)(81166006)(6666004)(186003)(2906002)(478600001)(52116002)(8936002)(16526019)(5660300002)(26005)(6512007)(4326008)(6486002)(110136005)(54906003)(86362001)(316002)(2616005)(956004);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3512;H:MN2PR18MB3408.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nTGU0gXiQh5EmIXcFPXtuKxNc724yJW43OaNnQ0tfJ2BL6nb9xpKcL32sbdh+YHbR2Qwn60+NOHJ3nKhFNMgU9hdSK5m1vs/f2QVV48pENLZWUQ2//KJITcl/CTJ0YZSvHZmkFQpBKv/oqtVxPPeboB0h0PkIwH24WoaIqreccpmza8N9kZP6htJK4xT9RsCp458DNKU5+JYDP/rCBCy52b2XqUiXyTfbvsTDi13FAxDpRQL7sfPL/LE3f0YIlTxAOgWNNj+XFtZ9dEpLjp56dUv/gxmap6s0utX5M5l6r/kSk5Q568M30LWzXGnqTcdbLpPoJmzH7CPmc0l+v8q4K7lbCNKouyeGF8odT/YKTaJiLQX/aApqMeblQYO+9UZZb/ewRMbBguv7EW8AFYeUyE98xP3H3LE7w10F9qf6FfJWcI7VnLhehHHdizJHEXt
X-MS-Exchange-AntiSpam-MessageData: 28YZx4fcDUYV/oq89PDZmxlB64Q0jXvDnVY9L8bJA0M5B1Kj29mrqMIGsVJ6tc6/aVBfrA8ZShdLUn3OQOSH83zEhWMQM+VsWPV8Y2hBjo3oePKSsmV26TPK8mO8irpEXWZhIFvD2oaoRb6SxwLh8Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe6e404-7498-42fa-47dc-08d7afb3b1e3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2020 12:04:21.7961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iydOlmDAB9+yXCjhqLIB/RGWPlJnxFvHa0LvYLCdzorUS0oN98E6bfAeojwg24wJXqB2fbZIAmtjLvEBviPYhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3512
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_06:2020-02-11,2020-02-12 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All created csrow objects must be removed in the error path of
edac_create_csrow_objects(). The objects have been added as devices.
They need to be removed by doing a device_del() *and* put_device()
call to also free their memory. The misssing put_device() leaves a
memory leak. Use device_unregister() instead of device_del() which
properly unregisters the device doing both.

Fixes: 7adc05d2dc3a ("EDAC/sysfs: Drop device references properly")
Cc: <stable@vger.kernel.org>
Signed-off-by: Robert Richter <rrichter@marvell.com>
---
 drivers/edac/edac_mc_sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 1c9c6a7b9f66..c70ec0a306d8 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -444,8 +444,7 @@ static int edac_create_csrow_objects(struct mem_ctl_info *mci)
 		csrow = mci->csrows[i];
 		if (!nr_pages_per_csrow(csrow))
 			continue;
-
-		device_del(&mci->csrows[i]->dev);
+		device_unregister(&mci->csrows[i]->dev);
 	}
 
 	return err;
-- 
2.20.1

