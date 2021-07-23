Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1B03D35F7
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 10:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhGWHUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 03:20:49 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:34752
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234030AbhGWHUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 03:20:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApieuBAyvgKQRYs8PLGAvCVDHHcVVQ/q/dfzvFwWWKP1Flv+TgyPXlqzPMjb5eRbgFbBkcf2T2qhV+r4N2IpS2Ymb0ifsCe/bcdNqe6acJbzC4Frsj8FSt3o/T2WoqMnxERKNkUz0CMcHqRDv904j8/l6VhAv71UXXeyQKyOnEUvQI91D/ww/xIgZvEOrhzhwAY33WOmZrRCcYcOEkkGbnHNg15DCI+cm6pZeusO+Jh0xr2ebYHoqRn07MARb3aXkuiiIsbd8onqSw1Onwjy50dlz85TYUGEkWaUYhJrvQrSmxwYwPBDUMaxYtCxlUWfEP+GzGTNxhBq5NiP21tEHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/6W42g2Y+xb7jET7I6gsgtSPaSeLo/JuN6R4+21DYY=;
 b=T/ICfWjEZHKepkJqFr+NeoQEd/f9XIczahO9O5UjHaBQak6cBq541j/UMCl+UqIHo8Gu/R5TnGLZZnCUj6KuBXlpZYGqackkbmMOewKQKuXVPt3K03BBVrqIuuLo+qNThO3TluT2uO1A6fwyZH5CjHuec15bWFEaeIl63+vPgg93vJo5IP04EWByfnimZcuhQjDk/4GA58lOLwA8LdpZ5vQ87FjngZnaibh4fRsOR9XJK4T6NWykcEsN5gRXVmi4viSGPPgDsAT5N0XR0itH48CbcbtlxQ7TRoFWe+8ruO3Y/Niis7SlMu+NPxb3oX+rbCOh3Tcx/SaPeaQe4cojXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/6W42g2Y+xb7jET7I6gsgtSPaSeLo/JuN6R4+21DYY=;
 b=IM0Hkp11QXNXfA56TULsQmot6Dab1E16XniMRt1/Xm9+L/d5l2q8pc9VsUWIEdexGEut807cWlDmyIxF84oVLNlm928X/SiqksM4x1VnJKCo7nvEeIkryP5Sq1v+p1wxa62m7bwtYKU67BC0YkJMiny28mkbrK5Bmx68thJ4/P2Bd6OHPnMUETgcoYNdJvT2MlNIV1qrusZx77bv5MUQ8VMjWrVJhXInXffQPALmoCiVwOrH9a2E9zcPKBPpjJA0FhG3j5JExr8oHyRTmqSuU6/2x+xqk0NO+B9vOF0y/5qy0JQjoqGrKGfUolPrsAzb9gn7wIQRpHh4RDOH3tsU/Q==
Received: from BN6PR20CA0059.namprd20.prod.outlook.com (2603:10b6:404:151::21)
 by BN9PR12MB5131.namprd12.prod.outlook.com (2603:10b6:408:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Fri, 23 Jul
 2021 08:01:20 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::cd) by BN6PR20CA0059.outlook.office365.com
 (2603:10b6:404:151::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend
 Transport; Fri, 23 Jul 2021 08:01:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Fri, 23 Jul 2021 08:01:20 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Jul
 2021 08:01:20 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 23 Jul 2021 08:01:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 000/156] 5.13.5-rc1 review
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5c9558802e92442488cd21e88863d779@HQMAIL101.nvidia.com>
Date:   Fri, 23 Jul 2021 08:01:20 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b4ca047-ee69-4fdf-4873-08d94db00ece
X-MS-TrafficTypeDiagnostic: BN9PR12MB5131:
X-Microsoft-Antispam-PRVS: <BN9PR12MB513180E30DD719A9F1161FFED9E59@BN9PR12MB5131.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8AdhZELEIDZjPKEy5I9I2wry1FGBorqSXwJUjDpiVnqaT6gabEY8lDJBBBglovWvHY0y+rRmukvVZNner4nYItjSX9JZ5L/gCv8AG8DX3HiGRpcFFtC93ONKoDhYYsSmC0eoG1XsgJsW5IO9BB4eVpCh+iPBwOXLstTO34exIrRHXxoY4tm+IuqWzENDWQCHkT8TtuzSdgmJMx3HNvLjC378U3SjiUyYC2N2WunOVD7Z2dSDlZsSxHzBD7lhIZY70LtNpXO80EWLTsa+VyrEbsKuRjFBxo3OFZVgLYb+oXOdrko6NYxmJDNvMjPUmT+CnDSHsHkZNdn+C3krzyY3fYLPowTMA37h5Uut4RbaiVgsMkovoy47hb2cQHN5jIgw0Z1BIKgV2S9F+xggWwQ/218Ls9w0jI6NVAVvhFuXFU5jBGLZ6l9lEJKYqyz4rts2njlQSs1xcFEjJ2LEzoSUpeLfrhUEbX5XfodakINEg28uPJqNGtlJCXVWmZuDFhZtyHQ+8DsIALvPZTJHZqwmy0HYRwt/aa4bL1GFw3hQSgTXKkfvPg/xbQDwTUx6472Z3cxtXaQfxET2ZlWkQjzeYG6Zka7TXu64HSJ8OV11zsc+mnCrVCGck1t8Ty6UDlFXKAaJ5z46OvpbVIXxWdGoToAAd438gA3TsbNyFeVK0RmwzOTOPTdr/mWeayHKRoj/bvNltbOZFCioim8+9YcUQIzMNhGwdrAPilIpzGykOovBMfdkWr6yj7HWo6OvA9bTwKaTbM5JDvq3/Q1oTpZQfed/aUTZY2PEMB/SOoe+COQ=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(136003)(46966006)(36840700001)(24736004)(966005)(108616005)(7636003)(26005)(8676002)(86362001)(36906005)(5660300002)(6916009)(4326008)(316002)(70586007)(54906003)(47076005)(426003)(70206006)(7416002)(2906002)(82310400003)(356005)(36860700001)(478600001)(336012)(186003)(82740400003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2021 08:01:20.6019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b4ca047-ee69-4fdf-4873-08d94db00ece
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5131
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Jul 2021 18:29:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.5 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    110 tests:	110 pass, 0 fail

Linux version:	5.13.5-rc1-g80f75a7443c5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
