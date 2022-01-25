Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE2A49BCC2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 21:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiAYUOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 15:14:38 -0500
Received: from mail-mw2nam12on2059.outbound.protection.outlook.com ([40.107.244.59]:17984
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229506AbiAYUOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 15:14:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApJSXZVKNYkgkkVhJsjIn5UEYOPs5yaOOI5xRPuXKKW+tLfubDgAPuQIDHBnHlQePsCuj/uXPgMl5TU3WlhAEHYzdXXdaFx/QnWinvtn3CSZeQRhdmnZFwLAZH+0DIefQ+REByt9T50sa+6onYmrbabNm/skDKYTF62kECjSJqqi99ykU12gSZFOqzh0uUOhp01HBsQUdygwCnVz7fP+w1RhZ0DD5VR2SyhgzWOFRt03LXZuW+o6vY0VyinyLm4N/WqjMV6AT0sjGtymtNG15Ab3OB0HNsIq7lKPdsdv1UM1NYlueIMx+1T7YwyfxO1/CSNLRU81xNRDGPOqIQcKJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7I6vvfLlAj9GgXJ+67qg8BFYtWNxQXiyj6gsEAmiWPM=;
 b=Jt71etuAqXwI84ntmtUF2uBZE2Ifv0p3wTkWvSNGUy6nUX4FI/8KcNOX4+mk0TG5wNFAil5WX5drZudwZGL0cPc7jbf/Af4bISpPBYcffT1K+vePBpkWENpWWNNvwpW8lCbxyKUx44XcoG63UMnU5h9X+cY9FBYYXf+6dUkDbxCtWcTl0008cQOgqKx/oI+p6TEoD6rnUU0QyeBEXXjuK2LRdl4RddwE+G+l5qZWODOc7WleiCyQwijgF25DzETxB2EZNYziw2X/m4Zrff5IfUtMewLYkfHn7zvIT2wLHogBLL+vuMNNDpIK4kFhcWnx12UlOnQ/4ZLFdczfO1OGWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7I6vvfLlAj9GgXJ+67qg8BFYtWNxQXiyj6gsEAmiWPM=;
 b=F5UtmJlVvQtC/Mfrphevhb2wceh59EXj2jtfnuIWNSlxYZN46u2ogoB9xhK1D18dhQm1UwMKz/Lu6rGXOL3dZWIyteV4sYwJQThmhZYcz0vDoPp6hVnKRewhCY0mEUIDsjQr3qnyL2Yauhx0uiuWVIzRQ8le5Wv+YAe/oEGsqHbI8g536lqp9tCswcESL09EJ0rlxMyXhcGQ8THXouMs2yRltQ1ujCu9iGgNf5DkZcllF+0fkUezPp3MwLQI1WsA/dPIQxQaTnj8FXB4j6hoNtvO233sDxbkOgNLu8i5N4t/o36zJBiy+uhmbJg5QcypS8qJMWIq4605RLhgKqqfiA==
Received: from DS7PR05CA0035.namprd05.prod.outlook.com (2603:10b6:8:2f::18) by
 DM5PR12MB1946.namprd12.prod.outlook.com (2603:10b6:3:110::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.8; Tue, 25 Jan 2022 20:14:22 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::91) by DS7PR05CA0035.outlook.office365.com
 (2603:10b6:8:2f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.4 via Frontend
 Transport; Tue, 25 Jan 2022 20:14:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 20:14:21 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 25 Jan 2022 20:14:21 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 25 Jan 2022 12:14:20 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 25 Jan 2022 12:14:20 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/239] 4.19.226-rc1 review
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1e48028c-01ae-45c5-9624-36b25d81c331@drhqmail203.nvidia.com>
Date:   Tue, 25 Jan 2022 12:14:20 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8221fda-298e-4eae-2e27-08d9e03f4691
X-MS-TrafficTypeDiagnostic: DM5PR12MB1946:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB19460D30B34751FB657A2663D95F9@DM5PR12MB1946.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: abMBcxwMZumWh7/IAeCPUCZiyWJ+bN1cERfufgzFh43rKrvwHZ1oc0oNIAkw0Xgq6zmHvmYREQkRnRH5WGbgbuacrP+0VvuHbHUpoyuKO0uGbCBKzqzV6GbTZoxWYJukCOMqJwsAHOeLrvkwAec9Gn3YTGvvIPPKjbqvFE67QmFZ/5uusT4ymqbYGVM0N+xsTA9UpDezik2LppHV3jhghV7YHlqOlxTeEZ2oAuHQQ8ykADlEnfDm3TdWYYM/eZLJm1CyQfKDDk9B2OVirgQpIg0ltYjX2GVyt5UjjuEsRO5nlaXGFnueuphrFaO1ewysB3usGrm9+qTTPOJWfb6l6b2BEii6g02gDF5bXI4lQIfHCUQw1QsSPVV4dvxIgr9EKj51jV6R/ZgyuAgciKn8D00twhnvt0QEqBue+MgRnohaxSulT6giy5JV6+8hoTeL6OwlBdE5d1N1HQL5tzKOgBGoc2O88i7N7crcbl6jj3xCfMa3/g/R3FcAusf7vEhBFuB6GZk5Oa8d2Bb1fvqFiehSRnsMeavFjntFeBDfMkv8jLU6iKZvc1xfOJ+1l8W+e4M8+8q2PvbQIBw8eM8jVoI1rWSz17trdVHJTPTCz1lqjeHg0N1vo4R8w/ll3so8TIO9T3Yn089SwSVSV9g72PgO7It7TzzL2h4q72b0uKJk66Q48jV8Dtz6u1JOsFCt2KpXkYKXzsUk0BZXSH0jk8dvFe+vzAiiF+0hbed32mSnkLekVrigVROXh0wMzTIcBLL3L28WCEPZDvF3EH5XDtcUiEqmLlby2Jf5oeypDvpnV9mweEuxoZ++hM3hS0LhVAM4+59uZPPKtlMzySSDYX/Bi+zpTH44aeq45AoT3AOvUW43ec0ESAhHaOdBbZhv
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700004)(426003)(81166007)(40460700003)(186003)(336012)(70586007)(4326008)(86362001)(70206006)(31686004)(36860700001)(8676002)(966005)(31696002)(82310400004)(356005)(2906002)(47076005)(7416002)(6916009)(26005)(316002)(54906003)(5660300002)(8936002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 20:14:21.9867
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8221fda-298e-4eae-2e27-08d9e03f4691
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1946
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Jan 2022 19:40:38 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.226 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.226-rc1-gcedebae149c2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
