Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9108320FF0
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 05:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhBVEDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 23:03:01 -0500
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:36863
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230083AbhBVEDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 23:03:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpJ5YKH/VtKiuC+eGvO2tBSnp8/xOdX1WFNGTQhXqFuE63saxuC1riJM6lzJ67d8/2kjQ5CBNt52l6ZihH4bnO/B8Ce0eHB/0DE1hxZBpWR6cM5QfBOmbCF9VFr8MDuiiB9r/UCY9Y8EiXOUbvJHufdlUklXJhBYdFMSxl4VkBm7NVFO+YcpeqgEEGHB/eIcptyp1ZseBUROwJRyl2rdSPjzeYVt/SmFA+NBKvGDRN+A4T7+VdOS4lzk0xgqjPkTJS8JkRXHIhOGQi3+DKj5mCaHYLh/rt8Bry5uzjzwp69F0u5re95hx8EtG8HX2wAZL8xGr0vRkkYpDUZX93LswA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJaMb3Dlgvlv0BPofKguQ79A1iD+tU31eiQwVqEFPi4=;
 b=KoFPL8j2rrHqlxDKxZKLMCoyLEt1cEiAmafnFr6fWQ0bLo1DsHren5UQpx6yRfYbLpEDl34l9HT8XMXR6dChfZmQC0FlsnEzuyb6mMeFQrfqG7qwXBZ+ApDossRfIfFKLmUYslFymbennTvj+ZTWEIH0HAk2rqjQFGztztoB7K6v2Y7ryHrlyGM3bIoNodDLRGxhj3Az/cjhzkItQFaXEAwTMIC7FwZHWWgbXaSpInN9CBXBcGICX99MVOnCm4QevH4dtr/YSAh8JGVP+No4A/MCkksfYLmk2wKzoHwz08wukfNekQ3YYz/IhCgFXnqplEH1Arwplq1M6ilhPeub/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org
 smtp.mailfrom=amd.com; dmarc=fail (p=none sp=none pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJaMb3Dlgvlv0BPofKguQ79A1iD+tU31eiQwVqEFPi4=;
 b=vlgZr0ldGTdZDx0XMXiF8fpzgIjdK9Ba/dPkm/Mq4ohY7VQmWCEOtyL+CkFVw9lMrAOGMPxGpXYtl+fP4T3vJkRowyxOCSe6q6xbrBsRNzmMAPMUN7g254We0Cdss0XoSGIoejZlSaaAWgYw+hgIKFSjpHmn3YMwCdqQc19dL6A=
Received: from MW4PR03CA0209.namprd03.prod.outlook.com (2603:10b6:303:b8::34)
 by BYAPR12MB2853.namprd12.prod.outlook.com (2603:10b6:a03:13a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Mon, 22 Feb
 2021 04:02:08 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::c0) by MW4PR03CA0209.outlook.office365.com
 (2603:10b6:303:b8::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend
 Transport; Mon, 22 Feb 2021 04:02:08 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none
 (message not signed) header.d=none;lists.freedesktop.org; dmarc=fail
 action=none header.from=amd.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 amd.com discourages use of 165.204.84.17 as permitted sender)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3868.27 via Frontend Transport; Mon, 22 Feb 2021 04:02:06 +0000
Received: from SATLEXMB01.amd.com (10.181.40.142) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sun, 21 Feb
 2021 22:02:05 -0600
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB01.amd.com (10.181.40.142) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Sun, 21 Feb 2021 22:02:03 -0600
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <stable@vger.kernel.org>,
        <Nicholas.Kazlauskas@amd.com>, <harry.wentland@amd.com>,
        <jerry.zuo@amd.com>, <eryk.brol@amd.com>, <qingqing.zhuo@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 0/2] Set CLEAR_PAYLOAD_ID_TABLE as broadcast request
Date:   Mon, 22 Feb 2021 12:00:25 +0800
Message-ID: <20210222040027.23505-1-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76e5c81a-6b15-4ad0-6047-08d8d6e69eba
X-MS-TrafficTypeDiagnostic: BYAPR12MB2853:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2853B70806D50D6543953A74FC819@BYAPR12MB2853.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XkFjVtzsnMkq692eHChnesp17LpZC25rC+lW4TbZ0qzHOmC+c+WWzUOqlKtOTuR2UVp73iAyGq9W+YssEFSUDaln7BMsE9fGPVP2wQpkhsI/+DlACWjxyA/S1qi6utIUcBraGNPOISgbSagrvlyJ7KtQMKGdM8KYbILIVynEO29uNjP4e8p67xBHLBQeDIdHEmmcxT11jYaXJUuhpkmBFAUDTQjUkO/7XvcGE3KGDdVoSmXopRldpHkQL7JGX9FrFhCWVtg4fW39Kq5ZkpawlCICTgjeGSGz0s5dF77V5kpU/NDT2Qhexfg1euMr+YhGLkpKbqUEgTeYkEpw6+Cr1faBi9tysOWngKkXkLLkYiV0+fIRUktD5qrDpMYHpiwceDrlo2sI3PKUUJ2vRqbm4SuEJpCMdgZDTCXHnhkCMUCSW5B8zSRvxBW/muQnOzcceVRkOUufAljvaAagnOilVro9Tr3RtbnFD4+qy2m/I5sLhVjynQuHZsSturVmJuJM1GzvtvGdeGRe51Q1Hwoihb932J2Kar35hR980xmd3z3t40Uu0sORjHUUVoFNiEmvAyLYJQilVmHfE/+ZdjOEcKcsJyDyM5Zz00PHwLkOobnhrb8RmmpyN3pv2kZPM+StuUexbmSLSawZO5of6uubfMqSCBSTV7AEdRVfKETNhVk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB01.amd.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(46966006)(36840700001)(8936002)(6666004)(81166007)(356005)(426003)(186003)(2906002)(316002)(6916009)(4326008)(8676002)(70586007)(86362001)(36756003)(4744005)(5660300002)(7696005)(26005)(82310400003)(82740400003)(336012)(54906003)(36860700001)(2616005)(1076003)(478600001)(47076005)(70206006)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2021 04:02:06.5122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e5c81a-6b15-4ad0-6047-08d8d6e69eba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2853
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While testing MST hotplug events on daisy chain monitors, find out
that CLEAR_PAYLOAD_ID_TABLE is not broadcasted and payload id table
is not reset. Dig in deeper and find out two parts needed to be fixed.

1. Link_Count_Total & Link_Count_Remaining of Broadcast message are
incorrect. Should set lct=1 & lcr=6
2. CLEAR_PAYLOAD_ID_TABLE request message is not set as path broadcast
request message. Should fix this.

Wayne Lin (2):
  drm/dp_mst: Revise broadcast msg lct & lcr
  drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast

 drivers/gpu/drm/drm_dp_mst_topology.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--
2.17.1

