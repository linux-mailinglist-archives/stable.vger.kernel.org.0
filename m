Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E149A323A55
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 11:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhBXKSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 05:18:01 -0500
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:50977
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234891AbhBXKRz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 05:17:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7eVQUW6hRSBw7qxkUM3S8vIVOc4tN6pPXcslGHS2PWoVEVKv82Bm+0kz2k2pIa+SL6sBHQX/Ce02BD7FXDA3sACdcfGoma2YfhqNURsxazmImgn6p1R14WEtjfteqJQXX4Zg2C2LPR0qGrKQo5N9J6WxNtoqLajAJh3F6dZw/tzdNxQizyJ31pjAAgb7EOpskcjmlEmXfb33SklehMLb1mCvxAr2mxAd0y3JXzBRG6K80SM4/yMOOq1anXLg1a+z9LiuFzHJk8loY5H5f5RLeK30ISYyT0eO+tUsaJivNkebg8N/pKcCfoDbyWyUYp7s2axjdBuKJ7cSdLX/KzKlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmvgxgeTc7rAcsfelwSAYbITFjfFRvcSd8AlR9/lNLg=;
 b=CpxukVxipud4zL5ci0NzPe6jCrn3E+5zFCDt87+ZujH969J4D3kXd+YCXelqciXP2ue1661gMa4VPvsmST2uvG3sUGjXW66fqbrVT7aDUBCSJ78D+V7QXI8hwg8SI+wT+WE7MLhJRVFXzF5TFDiy+kVJ49QGbsRjMH3dYsm15DRoYzoBhLegXxZHUlI2G3yIzbqWuWmwTX6jZPhSg1VjsapwvvBitImUm5Ur95Gqw2SSHRf100arqdsqjpZo5ZBBom0haFy8xI6oClRvoMbPusndlb32dxaXD4TwB3ZgkYBExBdEvO2Lv+QK5vJH7ZGdMeJIHc+yM/VzCk7VOdDGew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org
 smtp.mailfrom=amd.com; dmarc=fail (p=none sp=none pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmvgxgeTc7rAcsfelwSAYbITFjfFRvcSd8AlR9/lNLg=;
 b=OK2uKAZwve6ufBsRT6ReKSMZMpjrttWigzT/b5m53L96cBfvUyYg/nF/STWvjX+mn9bsjEz5Pku8wFTkUCWWHOFgoz74GN/nAFGHaL6gjcz82ZzdKDq3MSbOpG1SINry7IDPX+KxPnaoQ9B+p6OyfY59LRmkAIxlUvqx1Azm45s=
Received: from BN6PR2001CA0022.namprd20.prod.outlook.com
 (2603:10b6:404:b4::32) by DM5PR12MB1610.namprd12.prod.outlook.com
 (2603:10b6:4:3::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Wed, 24 Feb
 2021 10:17:01 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::bf) by BN6PR2001CA0022.outlook.office365.com
 (2603:10b6:404:b4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend
 Transport; Wed, 24 Feb 2021 10:17:01 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none
 (message not signed) header.d=none;lists.freedesktop.org; dmarc=fail
 action=none header.from=amd.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 amd.com discourages use of 165.204.84.17 as permitted sender)
Received: from SATLEXMB02.amd.com (165.204.84.17) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3868.27 via Frontend Transport; Wed, 24 Feb 2021 10:16:59 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 24 Feb
 2021 04:16:57 -0600
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 24 Feb
 2021 04:16:57 -0600
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB02.amd.com (10.181.40.143) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Wed, 24 Feb 2021 04:16:54 -0600
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <ville.syrjala@linux.intel.com>, <lyude@redhat.com>,
        <stable@vger.kernel.org>, <Nicholas.Kazlauskas@amd.com>,
        <harry.wentland@amd.com>, <jerry.zuo@amd.com>, <eryk.brol@amd.com>,
        <qingqing.zhuo@amd.com>, Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH v2 0/2] Set CLEAR_PAYLOAD_ID_TABLE as broadcast request
Date:   Wed, 24 Feb 2021 18:15:19 +0800
Message-ID: <20210224101521.6713-1-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 175f4323-37cd-4d26-1df0-08d8d8ad525a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1610:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1610C759EAFE9B35AD27A64CFC9F9@DM5PR12MB1610.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwH0Ji3rY/yQP8gPPso5tq/wdSK+yI1dlwSund/Ms/NGBy+kjLmj/rLf9Kk1pv/J4tWrYCZgFAvNNHUyB4JDRBcgSQ41iA1qB00WiE5x2NFfGTf8UmOX/IZi4Q03SUxm2AOS7WCNnHIa8qZZxWFHUFipTMMSQtvmwl17/pf8ufT19ouLXnvEXkHhfB8AfjncHP78Bw0VAUuFwlK9aweeqrZKJ2SXkxMymtMYhONyeuWZhGiOkTQ1hp98126Jk6741k3xDg30mxCueSXviwnsdWp8jVCbfTM5mMkGERqd1dl96D0nP3ZBgGx65xejniyYFr96lRBZ21ex4zJ3zwJPGJbzeebDuxnxHi4mX8BeBvLRUiZJbhSEmXywbvfdIC9dvFix+gDe3F3nfMlStSorPYOpV3RW3zJbz82qCEzQFjXP+q7UNZ8fz2YEWW0qG4lQCF19kb5fc4MKiCqdIzZWcrjmSh1mCZwt7F7L/pYNYpEAsAsX5y1hye7WrbbXT2acbkkyyQQTtgF96M18CWrZwg/Hk3Fto6OE4OjMiL5nuoePrz2q1lsRPU5bWTP1T0UjHZLAo8+PtE586vNIr2bf8c4emDGxgBuefxeuIan22iDskuAX3NTxLr/yCQpQIh+EbSFXfK3QIgiR3vFuoixYa7K9Zm9IMg+MtYfEJHJb7W4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB02.amd.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(36840700001)(46966006)(26005)(36756003)(70586007)(478600001)(4744005)(5660300002)(186003)(8676002)(7696005)(1076003)(36860700001)(6666004)(86362001)(4326008)(426003)(336012)(82740400003)(70206006)(54906003)(316002)(2616005)(81166007)(2906002)(356005)(6916009)(83380400001)(47076005)(82310400003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 10:16:59.4964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 175f4323-37cd-4d26-1df0-08d8d8ad525a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB02.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1610
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

Changes since v1:
*Refer to the suggestion from Ville Syrjala. While preparing hdr-rad,
take broadcast case into consideration.

Wayne Lin (2):
  drm/dp_mst: Revise broadcast msg lct & lcr
  drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast

 drivers/gpu/drm/drm_dp_mst_topology.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--
2.17.1

