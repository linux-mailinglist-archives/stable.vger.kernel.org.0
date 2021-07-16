Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895353CB370
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhGPHqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:46:11 -0400
Received: from mail-dm6nam08on2081.outbound.protection.outlook.com ([40.107.102.81]:60655
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231482AbhGPHqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:46:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9MXWn2aDdgJmaJBi07QvDZwlsLybMmYW4xqRg45jJm+4sdye6X9sRngLE9qHmSZ9VSrCbnwIe3mXog8HSuP5Hjg/pFIx6jky5qES+xp2Dq0ABJdg4arl308dWM8vxshFRlkTb0gI6156WVFjlZIAj7kYKPtubqCJzt6Hy/gRtVYCkbJ15SakPllL0rFoPKPg0FQHc8AJel41M0BN2kyTJ80wvlwUC2rF4Z99jXvfYzkq1JBaNf1FIcpTzOmb7kgGqt7UFEE7hMb1XOpj8dzKI64GT53eBokkO6cGNxyBO5nTv4iHRUd/OxA5bFhm2Y0v0FC6JPRC3oOYIFTNYSXDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upKSYkVB2qmTY33aqrKD50p04riDzEM1xZ4VZzMC/GE=;
 b=nbS/8B0quQX+PzZ8aRyao8IA+HQSo68iOxoOSNOY7amPjQD72eqlsce3X3Rnq4LZG3RUuclXaFcZViCKPVwvFltxXxHELS9pfm6IMlggUc00kQwH/qwrl8L4UsnJMKWOllE1plWA7vgHug4YcZkKiG7cyN2YeLJ8KkoCu/A8XeqCgaBHFreIdPAViLaDpKZB6URbNvp8nxrU1APi/n8kSUeHnb/wfTaYlPUxTJx/CvbMzIgUbI3aK+eJWVKovexuVCWAWkEgvdNLnX6AqRdH0YnquW9SgcpNjy2BBHApaA8DroKK4M9X9UaieyuNIxf6sYObHPD6mvqI2r4UQQDdTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upKSYkVB2qmTY33aqrKD50p04riDzEM1xZ4VZzMC/GE=;
 b=jxpLvnBBGJy6J3qTIYIHD0SnWtnxKJcDYeFUzjaIl94VpxXWWSCH7mXuhwBjAYG9xNAwcpiYkNk5oreejGeqTxBwXAGzKag1Bobqz2YhYSvA1KRpBQYIszMxZPSWqzSgSMAl1LvGyrlADWaa6nqz07BgUXWpuwZ0ejYrSNiFWec=
Received: from BN9PR03CA0082.namprd03.prod.outlook.com (2603:10b6:408:fc::27)
 by MWHPR1201MB2492.namprd12.prod.outlook.com (2603:10b6:300:e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Fri, 16 Jul
 2021 07:43:14 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::59) by BN9PR03CA0082.outlook.office365.com
 (2603:10b6:408:fc::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend
 Transport; Fri, 16 Jul 2021 07:43:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 07:43:14 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:43:14 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Fri, 16 Jul 2021 02:43:12 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lyude@redhat.com>, Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 0/3] Backport patches for 5.13-stable tree
Date:   Fri, 16 Jul 2021 15:41:58 +0800
Message-ID: <20210716074201.28291-1-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c91145e7-5250-4922-7c9e-08d9482d5e9e
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2492:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB2492703ADF10533FA3288CCFFC119@MWHPR1201MB2492.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:556;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 35001YfbB5jOkOUucrKB1STSvH6DVWXJ2GE9/65Dfhkf4qVqUz/BdiVg++MAAoJzEvlJLtgwSqzHg1qJ4yq1BgJk619LJw2VZY0Ptoah7RYcAKW1C3Kz7q69RmBjHLyFQEJyuJwTyafjZ1vQ44fC+Z1w77oUCId9/JVTz0XrpHlwFcYyi2iWcn/kKjkmuuZxNiB28sVRVJRaGSUmtzc1l18NDPt0LnfzZeILWOOWLPhoYyT84KSc7wgzULlhiX2Lv1jUfAYkX0yCNlQGto46ytz7AG9Ky86FNWm9Us1UVuP/hitd2P9uNnCGqvOK/gljX1z3p8HLpQroviB6k3rGk7H+ghOwk7lZ+V3g3Fpj3wSQMjafwVm9LwcN7I242yjtFTe1dp1VCKLfvCnL8ugXw5uuTc/1o3JaXwarTok0ninkdDmZvS4ywhBSxplkgmrYn4xfNMzenUBgY2D5YFwq8ePK6G2fPMX5l2oj7moWqzX0nZAoEHkxDFUuI5u//sZeNPFNHxaQrfpvgB1G5j4nKPPeISs1AUMzyaIxeOya+DiJUjlY3zQ/s65pzSk0cebd1wBns0fMUlR1nJHNehzvlVrUdXCSlUzO1Z9AhUmOEzNJovbBFKBitEHXtWdBqJxNyIYajilwyXwg+J47RaJIMlfKgkjXG27knicsBygVhXtg8P6PrLzBTr6B7MhhU98s++WDby+JjYx6pKiyIbOsoCvToYJI3Zug8Pv9Q/Q7OWw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(36840700001)(46966006)(36860700001)(478600001)(47076005)(81166007)(82740400003)(6666004)(1076003)(356005)(110136005)(36756003)(54906003)(316002)(8676002)(2906002)(186003)(26005)(5660300002)(86362001)(8936002)(82310400003)(4326008)(7696005)(336012)(426003)(70586007)(2616005)(70206006)(83380400001)(4744005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 07:43:14.7189
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c91145e7-5250-4922-7c9e-08d9482d5e9e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2492
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patches below in Linus's tree failed to apply to 5.13-stable tree.
Adjust them so we can apply them to 5.13-stable tree.

original git commit id:
* 3769e4c0af5b82c8ea21d037013cb9564dfaa51f
  [PATCH] drm/dp_mst: Avoid to mess up payload table by ports in stale topology

* 35d3e8cb35e75450f87f87e3d314e2d418b6954b
  [PATCH] drm/dp_mst: Do not set proposed vcpi directly

* 24ff3dc18b99c4b912ab1746e803ddb3be5ced4c
  [PATCH] drm/dp_mst: Add missing drm parameters to recently added call to drm_dbg_kms()

José Roberto de Souza (1):
  drm/dp_mst: Add missing drm parameters to recently added call to
    drm_dbg_kms()

Wayne Lin (2):
  drm/dp_mst: Do not set proposed vcpi directly
  drm/dp_mst: Avoid to mess up payload table by ports in stale topology

 drivers/gpu/drm/drm_dp_mst_topology.c | 68 +++++++++++++++++----------
 1 file changed, 42 insertions(+), 26 deletions(-)

-- 
2.17.1

