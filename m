Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C3D21B25D
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 11:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgGJJf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 05:35:27 -0400
Received: from mail-eopbgr700088.outbound.protection.outlook.com ([40.107.70.88]:36032
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726288AbgGJJf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 05:35:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0cFzABRnMwm4RiXkGxaAJPFLTD08CkQmxa3YQhObnh+j/5t/EQLDAx6azvFojEXWHDfDKGDsRa1+eD4RsWHMOMlxZWJ4CCTjqcKc51KpzExIZBaaO+o2NYthTZAK8oYT4qomky/L26Qpq30BYyrtx/A/WUd57+YhpiEcxOIg2Sjq6YzEk+pOUoKA/Nue2bFWmJEcbGS3aPXkVB7/zmgu8y0kQbkLPJ8Gc0DWEKjH1dnzzN+ZGuMMSesNHWkzpOR8AyKwnvjSRkqyMq4Ne26UVNZv47lZAgPz+TA6mb4NnpA8il3o/8Pw3yR6k2P1noQNiB0/nfE0DFDTdRwS7ukUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mfiN0E6b/FXqX3htDjZ8hxU3o+n9EKdhmIRCCgPy80=;
 b=TE5lqtSY1YFd5E9Btyk3sElBfe2x3g3m07A3tvGiAhCZljq9i6jPCoYLCRIor2CH6gLS9sPsqJ//3gfTPrGcex2sphUQaw6vyzpM18XBO5kkXn4reaWeqT3aaJnC/CclcPl2cF9i3jkGIBiBgkjIYz5FjA/SdUQ73sPzpRhBINpO1r5o9ihpLDjeFt6H9OpdjEHEF/7ekQYLu14cTz0TkbDQVDkKzO2TT5wJrJPwv4lhRhsbI7BaEqXQBuCdlfsWsHwpjT5466N1YkUONKLfb7SeLgJSXc1uT9+fZ0RaT28lb8pxXj+w7l7r0pkOYhC+H0cLEpo+IAnFJRWJHtiwDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.191) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mfiN0E6b/FXqX3htDjZ8hxU3o+n9EKdhmIRCCgPy80=;
 b=MzMFQRfExaa6h1AImpDpcNp7WwDlGFd8J18Pvn0WtZ1pmuialpEp0/Zyf/zJpHhtOejoWd9do4yNopEwrlwsk1nMIt6CQZ9ZcmDuZk99lMvv701OHcHgFfLHHt29a+MshDUhKHLkdEPzr1aV2acSdAbhU4KS93bWgmP1E+TihRE=
Received: from MWHPR14CA0055.namprd14.prod.outlook.com (2603:10b6:300:81::17)
 by DM6PR10MB3161.namprd10.prod.outlook.com (2603:10b6:5:1a3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 09:35:24 +0000
Received: from CO1NAM03FT035.eop-NAM03.prod.protection.outlook.com
 (2603:10b6:300:81:cafe::f1) by MWHPR14CA0055.outlook.office365.com
 (2603:10b6:300:81::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend
 Transport; Fri, 10 Jul 2020 09:35:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.191)
 smtp.mailfrom=infinera.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.191 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.191; helo=owa.infinera.com;
Received: from owa.infinera.com (8.4.225.191) by
 CO1NAM03FT035.mail.protection.outlook.com (10.152.80.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 09:35:23 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 10 Jul 2020 02:35:23 -0700
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.1847.3 via Frontend Transport; Fri, 10 Jul 2020 02:35:23 -0700
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Fri, 10 Jul 2020 02:35:22 -0700
Received: from gentoo-jocke.infinera.com (unknown [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id 200342C06DF0;
        Fri, 10 Jul 2020 11:35:22 +0200 (CEST)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id 19C4E7EF8; Fri, 10 Jul 2020 11:35:22 +0200 (CEST)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     "linux-usb @ vger . kernel . org" <linux-usb@vger.kernel.org>
CC:     Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Date:   Fri, 10 Jul 2020 11:35:18 +0200
Message-ID: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Jul 2020 09:35:22.0772 (UTC) FILETIME=[6F183540:01D6569D]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:8.4.225.191;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(46966005)(47076004)(82310400002)(1076003)(336012)(83380400001)(36756003)(5660300002)(6266002)(4326008)(2616005)(54906003)(70206006)(2906002)(426003)(70586007)(450100002)(316002)(8676002)(186003)(6916009)(82740400003)(26005)(42186006)(356005)(86362001)(44832011)(6666004)(478600001)(81166007)(8936002);DIR:OUT;SFP:1101;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bce12dd-47b6-423f-f8e8-08d824b4923f
X-MS-TrafficTypeDiagnostic: DM6PR10MB3161:
X-Microsoft-Antispam-PRVS: <DM6PR10MB31613010C3E7F79C5BEF7321F4650@DM6PR10MB3161.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:200;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EGJe04fQD9SnKKo4YLiFP6Ce3Dm8N4zZHBO7ZGtFMk4gQu2qn4IpCMXaDuXl0GAZY/P42MlNRNHzkzlC+qIUFC9h8TR7kVL3JcUY1OKPp7S7J7IIY9gWDN4Lk6Od5IinFVBwplrlmcxj3894mnfyWaEmMfI+IAL8cZBxE9Nie4f6DqXFObrbNLNazOPphA9Eb03MuKNsVUUcIJKBsnArFg97zcO6Vbqf8DVcCUQcFq7zLbkqtOxrXTnITDgWuDubJQS5ZrgsdxuMz/TUh7cih2vzScZYGQ0bWBNsVz7h3Vx8ozK4vtSwvl/uQFd+aOg0gmeXkv8KhnEwdR7A/kkzmsRt3WZO3QAo4EnXxCHWqSRuNaPlcuSU32H5zZVDcVmPA7kgtQ1+H+Y9EdASGZR3IA==
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 09:35:23.8704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bce12dd-47b6-423f-f8e8-08d824b4923f
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.191];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM03FT035.eop-NAM03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3161
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

BO will disable USB input until the device opens. This will
avoid garbage chars waiting flood the TTY. This mimics a real UART
device better.
For initial termios to reach USB core, USB driver has to be
registered before TTY driver.

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc: stable@vger.kernel.org
---

 I hope this change makes sense to you, if so I belive
 ttyUSB could do the same.

 drivers/usb/class/cdc-acm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 751f00285ee6..5680f71200e5 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1999,19 +1999,19 @@ static int __init acm_init(void)
 	acm_tty_driver->subtype = SERIAL_TYPE_NORMAL,
 	acm_tty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 	acm_tty_driver->init_termios = tty_std_termios;
-	acm_tty_driver->init_termios.c_cflag = B9600 | CS8 | CREAD |
+	acm_tty_driver->init_termios.c_cflag = B0 | CS8 | CREAD |
 								HUPCL | CLOCAL;
 	tty_set_operations(acm_tty_driver, &acm_ops);
 
-	retval = tty_register_driver(acm_tty_driver);
+	retval = usb_register(&acm_driver);
 	if (retval) {
 		put_tty_driver(acm_tty_driver);
 		return retval;
 	}
 
-	retval = usb_register(&acm_driver);
+	retval = tty_register_driver(acm_tty_driver);
 	if (retval) {
-		tty_unregister_driver(acm_tty_driver);
+		usb_deregister(&acm_driver);
 		put_tty_driver(acm_tty_driver);
 		return retval;
 	}
-- 
2.26.2

