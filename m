Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D9D12F460
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 06:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgACFug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 00:50:36 -0500
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:45280
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725916AbgACFug (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 00:50:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZ630UoCcyezj17IwHAF6f+1fYEjbHMT4ml3GzG5QIR4a4so5Q+x1Z2Lmb+TI/32g5orRneKL86Q1UmsDrJfYPHcj6+IB4pdhW0o/29CrHLqglu+JMEtGcbxn1VcVR1fXeS+Ciqa1M/EdZYfAJXwdC/5H8fqNMzVrZhTIac9Euyr3tNUkYfxVbZrUPgPiPngvFI/rgSA1Ca4WsgOVERCg2PEG8Askl5DKQX1O29J69TuXPLz0S7+II6vR/dUFY9MRJDa5Z+F3B9gvsTq4gw4u7rfjVMvjIKSH8wlF/f89cUDtMa+ke+GbTZqiqyxa0cGgsmgg+sCa9pDzc8y57ZZxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPmkNEG3IGdRANSqyPiXBSyTXRa92AA+Coo7nORYDGk=;
 b=lN7AmgRY6uMEWGtPLrXA5xaXWCQBgxc5VXJJsZhz97kr34I3iyn2gr1v06yXTGRqOp67a9F6PptoeAxKgcvbQmBWRk0ITx/DuU5n51H1MeiLulE92CcKXeOtV1iDxE7XluDjBHMXO6XjP34kP7PUnRdlwSMQ6TUHrRzj1OvI1jIeo9fmeCRfKbUORsg3P+lljJIhI1Hl3srUA9nKhLEtfZxqy5TfWnNxLfxAtD32HOtEI+w2dYXMSWrqqkARvko+9YCWJ0Q6pc96viM9pNyfmQvd2XFkza5n7KI2ofh64ajg3WF5q6Snnpov5FRM+hf5v1nBJhEzz8KQU0adpxscSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPmkNEG3IGdRANSqyPiXBSyTXRa92AA+Coo7nORYDGk=;
 b=VCrtCwM8VT881q9gKDb89FqKZnfT/M9h/KKcLTsou/137XFWoOF+i6s45jh2IuftzNWvFggWiWu8LCKHXTis9cd9LwlvWP1wCgokaIzemPwJaIC8tO9VP4yhtSFVAV+mRreWtVZ1Co4cGg8OfbY9dQ4IblGUcwlyraQ8StSB+ZI=
Received: from CY4PR12CA0029.namprd12.prod.outlook.com (2603:10b6:903:129::15)
 by CY4PR1201MB0087.namprd12.prod.outlook.com (2603:10b6:910:1b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12; Fri, 3 Jan
 2020 05:50:33 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2a01:111:f400:7eae::201) by CY4PR12CA0029.outlook.office365.com
 (2603:10b6:903:129::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend
 Transport; Fri, 3 Jan 2020 05:50:33 +0000
Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB02.amd.com (165.204.84.17) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.2602.11 via Frontend Transport; Fri, 3 Jan 2020 05:50:32 +0000
Received: from SATLEXMB01.amd.com (10.181.40.142) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 2 Jan 2020
 23:50:32 -0600
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB01.amd.com (10.181.40.142) with Microsoft SMTP Server id 15.1.1713.5
 via Frontend Transport; Thu, 2 Jan 2020 23:50:30 -0600
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>, <amd-gfx@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <Nicholas.Kazlauskas@amd.com>,
        <harry.wentland@amd.com>, <jerry.zuo@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] drm/dp_mst: correct the shifting in DP_REMOTE_I2C_READ
Date:   Fri, 3 Jan 2020 13:50:01 +0800
Message-ID: <20200103055001.10287-1-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:165.204.84.17;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(428003)(189003)(199004)(426003)(4326008)(478600001)(70206006)(70586007)(81156014)(81166006)(336012)(2616005)(26005)(186003)(8676002)(7696005)(8936002)(316002)(110136005)(54906003)(2906002)(5660300002)(6666004)(1076003)(356004)(36756003)(86362001)(70780200001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR1201MB0087;H:SATLEXMB02.amd.com;FPR:;SPF:None;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d75a8b35-ffce-4863-dfe9-08d79010d8f2
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0087:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0087E15897D273FDAA884B0DFC230@CY4PR1201MB0087.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:167;
X-Forefront-PRVS: 0271483E06
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wXX820ZZCUSnt1T/DQQ0GzhfozhRr3vNWg+aOU6QuAHVU8/nDQ5e/of9QKmg95+ZPtsNcwll5uD/rG2lVhdjdY7h5DOPUD1OMa1o8bhjD91jMYCUrhD6QmbhSsPcmvdOOJ02xo5Qfxo8UU2WqQol0OyyosolRXraUaZodrDeKueiB6sh/jzYOsSumWKXWKLG3iuXUWoqTR05RCcvBZ+vck4CzwXJ+zCWc9AnzmQuAsMMHZWMLTKiSnZcYhdOSi8LmjU6EWaMhv6BKfbDPk0isjSKGJR641+pXrDU3NJdYmyQvYkxWefIYcoOuwQACkq0IwnAI+c7gMkkjQr/aRIJZMwd1uPaNnw8lHoEqsjx0P85kaVrWRVqsR9n6Gk3vxENZg4l1mf7GFeZRIq+6pQQIy5ehTaZfB4rnmoxW7m5B9dp1mvG5G/HHwLFrl4hSF01MjCUB9/n0Z45AUBalcCHY4Yz5MHMfR7B0CqLkXZNv+ewtcxmseslEmXu3sOJpP/jp3bJnOOzlSGnP5D8m6t/m/ImF60ed3rip+wV9kbxVco=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2020 05:50:32.9460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d75a8b35-ffce-4863-dfe9-08d79010d8f2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB02.amd.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0087
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
According to DP spec, it should shift left 4 digits for NO_STOP_BIT
in REMOTE_I2C_READ message. Not 5 digits.

In current code, NO_STOP_BIT is always set to zero which means I2C
master is always generating a I2C stop at the end of each I2C write
transaction while handling REMOTE_I2C_READ sideband message. This issue
might have the generated I2C signal not meeting the requirement. Take
random read in I2C for instance, I2C master should generate a repeat
start to start to read data after writing the read address. This issue
will cause the I2C master to generate a stop-start rather than a
re-start which is not expected in I2C random read.

[How]
Correct the shifting value of NO_STOP_BIT for DP_REMOTE_I2C_READ case in
drm_dp_encode_sideband_req().

Changes since v1:(https://patchwork.kernel.org/patch/11312667/)
* Add more descriptions in commit and cc to stable

Fixes: ad7f8a1f9ce (drm/helper: add Displayport multi-stream helper (v0.6))
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 1cf5f8b8bbb8..9d24c98bece1 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -393,7 +393,7 @@ drm_dp_encode_sideband_req(const struct drm_dp_sideband_msg_req_body *req,
 			memcpy(&buf[idx], req->u.i2c_read.transactions[i].bytes, req->u.i2c_read.transactions[i].num_bytes);
 			idx += req->u.i2c_read.transactions[i].num_bytes;
 
-			buf[idx] = (req->u.i2c_read.transactions[i].no_stop_bit & 0x1) << 5;
+			buf[idx] = (req->u.i2c_read.transactions[i].no_stop_bit & 0x1) << 4;
 			buf[idx] |= (req->u.i2c_read.transactions[i].i2c_transaction_delay & 0xf);
 			idx++;
 		}
-- 
2.17.1

