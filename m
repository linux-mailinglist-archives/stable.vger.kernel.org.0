Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F4C467C7F
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 18:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353048AbhLCRbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 12:31:08 -0500
Received: from mail-dm6nam12on2071.outbound.protection.outlook.com ([40.107.243.71]:40928
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239848AbhLCRbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Dec 2021 12:31:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wzcyovxpe2rejxiSBvwHY63BHfasBnF5Uckp90Ip4ZwhKem54lC5mw534CTDE2TsKM3WzTXELY09OJa9uSrMl3v/oq19Yrt1LN4p/f/7dap8JHxpP8Z/dtaxwertvAIArDO6sOk6aJpGf9pTB6P6zDHCDDk9samFm4e7wQxNLgr9YIippFgAhoM0slFNboarGz1qoiNCexHzve1nj6G5Gp0tOzIA0fxzQEFwH7pnlnALnvfqYRXc58TNGqi0WQW0qmMA0KSQMyHza0IVcd6ycjP61WyF7uHD6cEx6k/tjjoWRJjWbWZqt/P5yLAJjKLBs5/2eYSQ9FEvMVVEI4rE5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9DmGm7hcVgr6xdOQJeSCOvWh6s8imuqsQ0YcALkJA7Y=;
 b=J2IVf3iiXIc9RN9AqVsLbznOEwlYB+UxOhf3StvBQOV2X+gQyrcUhLrJjULBACfI6ZoDslfPdd7G6Nc40fgbu/FlMbtspkYjKSta+Dwg4SXDErA8poudjAuWOPvcQvjC6psBIWzxh12PiWWutwdpgiYb2lQMI4qVn73EMBTZNv71Xep93YctGZ44U+L/zt4WPJE5RsPGqGCXLb/07UlZaWgRkgip/FLGy5W1Qb8UU7lcor8SUsNmKNDng9jfjXzE3sW05ER61y6oCyu8886g3AAxipRK7I11iuj1P5E/tqVCDPMjdhEMNWFl5lSZGTQ6S5tkLdeOfij5mVNoLsbmxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DmGm7hcVgr6xdOQJeSCOvWh6s8imuqsQ0YcALkJA7Y=;
 b=yJ6rrke8d74wGoZaQ29xoKoapaoDoLpyGOEtTmj0xmRoCEVeM9QKKDt+7b+ik8xFYwJz4mu85x0UTrYGW+Ujj+9Q1pwIQwTnRhCGR5JVxOjVhF/rxQ1U/kCoLkK0SlbSs15cIj+NNgkdG9gVhjCOFhupdJNKEX1jW3NfRTvgTyY=
Received: from DM5PR11CA0019.namprd11.prod.outlook.com (2603:10b6:3:115::29)
 by DM6PR12MB3483.namprd12.prod.outlook.com (2603:10b6:5:11f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Fri, 3 Dec
 2021 17:27:41 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::e2) by DM5PR11CA0019.outlook.office365.com
 (2603:10b6:3:115::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend
 Transport; Fri, 3 Dec 2021 17:27:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Fri, 3 Dec 2021 17:27:41 +0000
Received: from work_495456.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 3 Dec
 2021 11:27:40 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>
Subject: [PATCH 0/5] Bug:211277 fix backport for 5.10, 5.12 stable
Date:   Fri, 3 Dec 2021 12:27:27 -0500
Message-ID: <1638552452-4198-1-git-send-email-James.Zhu@amd.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b017db90-1bf4-48e9-ec70-08d9b68235da
X-MS-TrafficTypeDiagnostic: DM6PR12MB3483:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3483CF50A94039A98EFC61DCE46A9@DM6PR12MB3483.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sCbCfKZPh/wHdiuQZeb2LqKrgqyU7XqOGcmZGyj+EewZowFEpV70XDFWzx47aaXDBf88uiPs0BMKJF+UrqkqoAaP/utnftiOiT7csf2CHESW5FGbw5bOayNdKJxw1XfZl/XLFigFQFOrhomNmW8pUfcbdFDsiV1bt0m5tk2/yi7jVhlamBPoiSUMIrIx2QKRGbqcvpD/h6adMydeddJFELTwHWxo0iK4/lmy6v8GbHi3Sd/sXrrqR5E9U+myjfZIDaftV39BCosKsIc5aI5KluSax94qqKFnrtmO1BssX96XJtDfIsty0IKSUs/d3OzX5TSbwbGvABVfXLbbnmLqpoIAWDzqPdCqfv+PCi6CpCflmQddae4up3y822vk0n0ntMq0hvIO00mXxTBiFRdCNnlNL0Stpk9YUoQuOFIxQrvW7loIq5OERsNS1kJCaf2FQ+vv96KWysiiQvoU6yQSqaD/MutdRK6wF2q9yZVEswASSv8lExxqzAsqMuBH4xZc97oTpPipMbEZolbw1uOzgDT7jJEoIGogrbZS6S4f3JEHhTgCAapvH47kr+yFEjqLnmgP60jk9fJ/KCoJlVewfNn0gFom/VoKiEf+rPaup2R0lHM7tk+WHYkzqOilm/blJVSIaSl+3FJogqoKXA/bo0dwBTrAc/48mJoDnaDOxwCv5S7giKp+IeCJKnNgYIXrtuU4gZ/grO/kJDluph66JeNnVKxuroeoI98BK3Vo/1pIu5tOyGJ3jFjcMegbmJ11XI+F0tsDBXA8bQdDdcsrJn3HNrJbxr8jgP8lQcI8AGFNovb8fBXK7/1OX93sYbitIvvHpqoONvOMQGDfvTPMwVh10OapMV7vHrr8/LxDIqREG0iGDG0RbYgr7CLYTwHS
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(54906003)(36756003)(426003)(2616005)(16526019)(2906002)(40460700001)(70586007)(26005)(86362001)(8676002)(5660300002)(336012)(6666004)(4744005)(356005)(186003)(8936002)(6916009)(83380400001)(81166007)(966005)(508600001)(82310400004)(316002)(7696005)(36860700001)(70206006)(47076005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 17:27:41.4085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b017db90-1bf4-48e9-ec70-08d9b68235da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3483
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These patches are back port for 5.10 and 5.12 stable.
They are cherry-picked from 5.14 stable and has some conflict fix.

BugFix: https://bugzilla.kernel.org/show_bug.cgi?id=211277

James Zhu (3):
  drm/amdkfd: separate kfd_iommu_resume from kfd_resume
  drm/amdgpu: add amdgpu_amdkfd_resume_iommu
  drm/amdgpu: move iommu_resume before ip init/resume

Yifan Zhang (2):
  drm/amdgpu: init iommu after amdkfd device init
  drm/amdkfd: fix boot failure when iommu is disabled in Picasso.

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 10 ++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  8 ++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 15 +++++++++++----
 4 files changed, 31 insertions(+), 4 deletions(-)

-- 
2.7.4

