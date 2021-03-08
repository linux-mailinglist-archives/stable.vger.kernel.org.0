Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01734331478
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 18:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhCHRTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 12:19:10 -0500
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:30081
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230475AbhCHRTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 12:19:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0zX5AwN3/xNAZJmhBZ6bFG3EF2gW18zFagBEiXqvJoIxp3lfXhER18qzwmJwfd7pVdcQTojCNSGPSDq21TejCSe6kh+uJ6H0ODIu8BU/PEfHjGZLwfi6yX2XGjX8sUM6YpiKmHrj6EahavoClsvcOms8Tb67fkCiGN+3r736S+z7v/5ub8xMlOOgWkXfSndxXRw+V7CY1uUKGhb563CHkU6OW8tApzBWX7y2aGhdB+K1kdc1SaVYy1jSKnG/91z9FWemNQcty97ObpOVhOcZhinAL8vWxS27qwtGfjsR9TH7BXp5M6tqWwrzmYBXzu8yihW3QeX/c8yvtMUhJIaww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqBBqq5MPImCYaP3XE7rwI5/XkYTFg3dSoEpwVGHmQQ=;
 b=akGSWJwM9Yo9Zo+3V9rGBa+2AGGRHXaaVAx8Wc1/DDhyr5caSE60Y82dyLHfZP6nCgVkAaEv8y3qZImF9crE5NcOQMjVCTdD7vw7wiIpqYSpozkLWKU+eiW5s1D31jk/FMw6TWQ19i7eIau8Hte3Abgz0TWvDd7QodsXgtmd8WQT4Pvg5B9ZGVK3ZMcr/LE6OJjTAg7pN0J8VEsRYDDBHHjH8p9WEA9JuxbQoWFXErV34Qow/BKySqkFGK7vOPOkBgDwqV7aTzC6v2tgt7W3PYtxVgRcqQro54z4GRgZleux+DLLbFOuOB7raYmpF5HsItC1H27cENXzMj4WWBlcjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqBBqq5MPImCYaP3XE7rwI5/XkYTFg3dSoEpwVGHmQQ=;
 b=DNxApICHK7+DkffLa8uXdWaZcdD9uV3cRPXChW312X+GQeVWodnXNXcBvgOd+n6xbQkj71BkIltwnj+XTCnPLnLsVgbzuU1DgqqHkQv6qnqOHd8PRLBdfrKn2Jh/YjB2ecNzSwww4IYgo0GgYG79KhgXAInqc5s606UXuC1hyoI=
Received: from BN0PR04CA0141.namprd04.prod.outlook.com (2603:10b6:408:ed::26)
 by BN6PR12MB1844.namprd12.prod.outlook.com (2603:10b6:404:fc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 8 Mar
 2021 17:18:57 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::31) by BN0PR04CA0141.outlook.office365.com
 (2603:10b6:408:ed::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Mon, 8 Mar 2021 17:18:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 17:18:56 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Mar
 2021 17:18:55 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 8 Mar 2021 17:18:55 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 00/44] 5.11.5-rc1 review
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <76e87d7a575a48389a952e5b035d0da4@HQMAIL111.nvidia.com>
Date:   Mon, 8 Mar 2021 17:18:55 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 231e988f-c65f-42a4-8404-08d8e256415d
X-MS-TrafficTypeDiagnostic: BN6PR12MB1844:
X-Microsoft-Antispam-PRVS: <BN6PR12MB184476057ABC0FE4B6D915D5D9939@BN6PR12MB1844.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KRwkZoosagzSctZeyH5KKnPvbRCmCiRX8WgCI6orSAAreVpubaXqu8PEBasRn+D6Le/a4aiku5q4Wvnjil9Oa54qbLRpfmNFUQ5lX7Vpcf5ncB2E6n73z/Q0ZeVajW5U509Ejmty5fTQdfk4SIo9GVMQU7Ra9aTnoFbYf5joDichuVizLBmEV3JloJApS5TsU2NivzS+Ig6GCdJjuHPsaVGnda7dULqEfc/E2c5WfffOIFL7P5YosIY6jZP6yxCOx/mx3De6T4kdDQ2s8koavoTJZWGc1MN2O+tDbznAJpKS7j/+4m9s5SxknBCbVGjjAf8GdiPENIaGJiw5ng8jvjveBWu0Q3qapoy0d2yWYsHpU3e0rhLwEKdFSYwyN4Rd1/bJRXRoa+i4w/nFXZioWHZSFGfkikYNd75UwqS1sPi6jd/8XTHIEpSlj8XyvaJEWg0TUZfLoUJIrx0t7oFkEgOuZutsScMjZHKbqH4vC4mD8nCzwZ1nR3DxiDufqGrJhvpTL4Ue/Pij0XgCCUSgHM2CjU71DsTbJG4JN/rCKNAP3IZh41eYfJLIRu7Y0lOQNdTTaatH70GpVAQyifCk5Vs8Z8Bdroul80J8qEEn9O+tSAfuBNXGwopJxPySOGU99CBbDpcBNJTHPMQzB1MqxMF969JYLVKjln543GVwjltPxGEc+0SvLCFhN4CwItctQVRDWDHzkFdTiRXMsNwcZrc1k6hAwoucAIVnJolKjHxxSP+ChyySjljR4mevD6VFMRVfG1VMTrwaV2eEjK8Nlw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(46966006)(36840700001)(7416002)(34020700004)(336012)(426003)(8936002)(6916009)(8676002)(24736004)(966005)(70206006)(356005)(70586007)(5660300002)(36860700001)(316002)(82310400003)(478600001)(2906002)(26005)(186003)(7636003)(54906003)(47076005)(82740400003)(4326008)(86362001)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 17:18:56.3048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 231e988f-c65f-42a4-8404-08d8e256415d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1844
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 08 Mar 2021 13:34:38 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.11.5 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.11:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.11.5-rc1-g89449ac6c715
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
