Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4A53AFE8A
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 09:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFVIAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 04:00:30 -0400
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:22320
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229695AbhFVIA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 04:00:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSMY7uBrqXd2kGlFCodlnoxhjNNX6EPOwU4dwfI5R6+xO581oM4PiW91/xBf9Q5UWYdZanOI5d7EibvlFFs6i5ottnRC0Hi7Iq03mCplNqcUxjQ9PhR5zfdi2GCUoD5V0/RP3bCan1RhvAQMX80aRtFRyoyTPc9p7QK+E55lHYBjjdMSlGPmWpeSuxDogb1H/cn3RGL1fzOWgjzCEz3QriCzGm/kgy6w3WxNGny6Kc7/GCU6+5GO0PYvLHhZcWwqiNyI9ULnYCB5zORcyVPTbp9Hf/Lr5Mbln6u75cVc53nW7GqbskIERss3q6N7EWtSWdMscqf4MQJp175mf0JWlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=He0a3RGRMTKIANLCY06YtMN9idyyekRfXElmFKkjHT4=;
 b=eEQ/8Oc+ieZoA3dv2ettTzGChH+U5H15G4XvH910HU3BHFpxdBqSKi2OqbEPBDyqIDRb/SnMLK8LrmW0TFZ7io/+uZ1X1vq0b9lcWzHOW9qHn5ps4yhsf5ycroF8Yk425tnMAo+PpBNvBlEpFysXubOXz0YF6262Ri8knLqa8nlMHNVrNt5/YMHLxOTQZ3tfKk/SQVrNXz4lxo06JNQPJHAqBkXrlquCOklaAdjq1Gd3RDRZsXm7OLEHXcA04Vao+WCHsF6TIjbbdSKyO/j3CEWLF4OA38tTRbQiHVHgZZ864bhukrIgLu/nP/ET85jQveyDqfmAnNZWQGhjFnwV/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=He0a3RGRMTKIANLCY06YtMN9idyyekRfXElmFKkjHT4=;
 b=GDF3u6vdzVtJBzVXms4Qly9BhxduIgSRXJr9DRpMR3EXCAPik52RSoP+bHCc585idkJT8bQ6GmeC151pJ3k8zr5Is0/FXBALYUSnZKHNw3KDMUjBKowzbmrWKjMd6FcTNJo/Yj84xag6jFV+axuYCvy5NKKhMchupnfdPIgFQ76+UwzPb/OPbf6J/+FH8E0ZOETSPQeFVhnbgL78XWQajUFCA5ByhKRKZP6aBWmF4o2GMGkxx5CkB+HRQLxJP/2w5UgWhRlvGmiknh8cJHu2m2YjG88IV4sXFOszfwoSuN60izxF9bFm9E+B73cWb9tryJ/QIMVkmD7H/oo21tLoNw==
Received: from DM5PR04CA0051.namprd04.prod.outlook.com (2603:10b6:3:ef::13) by
 DM5PR1201MB0139.namprd12.prod.outlook.com (2603:10b6:4:4e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.21; Tue, 22 Jun 2021 07:58:12 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::5d) by DM5PR04CA0051.outlook.office365.com
 (2603:10b6:3:ef::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend
 Transport; Tue, 22 Jun 2021 07:58:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Tue, 22 Jun 2021 07:58:12 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Jun
 2021 07:58:11 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Jun 2021 07:58:11 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/90] 5.4.128-rc1 review
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0b020a8fe9fc4e9b9ffc7576d24681cb@HQMAIL101.nvidia.com>
Date:   Tue, 22 Jun 2021 07:58:11 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 403aa793-8ec0-4439-ccbe-08d935537b9a
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0139:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0139F514788614B95E65E309D9099@DM5PR1201MB0139.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LLa9yhMxJmvHdd96U7KWEte3q6Q6u4SiUob2KHZwXwHdOIiPtIpVhZi4RRZPK8SzXtpqyzyrrB8wWDEjTQlhnanEjkVx+jbF2/Wuux8UNq1ydWKX42eiUmCL1qnga0G0rcaVuZ953LmrhC9HSAsVkG5y4wlvyZz1O8h5vJdP+bQ97fl2XE++CwYQutDuZBO6frAg/De04vrg4L9oNB1WvaxIeTK2MK6LxiEkLaNjak8yIgeLxgP4EhuqRyJcbdjNJ58ZvjGawFVFOX9uXAiiD/Kw03i2qQOeUrMRjnSIqBnG+E23eCvdt0VDNVs+fXyes5uR/Wbo/csgeUXYJPBvJNBbqiEVzFNgv6HVP53om0F2E8tBlDxqQMZPkNaqRoHcmpGAceIzXDgdA9hw+hNHdVYlN9HEfqOP07j2C13qf++EMSpFueZBeRg9sSH0S/2uSMcPYT3rNQ2+JhTnnzOVhB1II7xukI2EatGOUwnU5pXWGfcXzPaq9s72zS+bcfCy43hgsa7usJM+qNhkd8MgzsCem2xLPnURSTSiRQ2tiWaH/OBX+HxJCU/v+AonIbBB2ZpTdJwEmyX6uz8gNNf8yR4OkdOtbAOrHStGO6Dn5vVF7WPIu5EktcRGAA91pjf9CrwUOEYSQgjYXoJ9tJShIbvKD2f2PccRWN5WfUj4XGKVGmvqsDq4L1Vq1C29g1o8DFfmrKmFA+1C9hgz9fJBBdzskQak/Igq2QmXeR3cjW6QADoIHUrpQ8YNBPgUSEmwVidyXkhRfRWC1tZM3u5D2A==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(46966006)(36840700001)(54906003)(426003)(24736004)(108616005)(82740400003)(5660300002)(7636003)(8936002)(47076005)(8676002)(478600001)(356005)(316002)(336012)(36906005)(4326008)(86362001)(70206006)(70586007)(82310400003)(2906002)(7416002)(966005)(6916009)(186003)(36860700001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 07:58:12.0796
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 403aa793-8ec0-4439-ccbe-08d935537b9a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0139
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Jun 2021 18:14:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.128 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.128-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.128-rc1-g3840287eb948
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
