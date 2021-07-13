Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97593C6BDD
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 10:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbhGMIGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 04:06:54 -0400
Received: from mail-mw2nam12on2075.outbound.protection.outlook.com ([40.107.244.75]:32544
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234486AbhGMIGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 04:06:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LagASf4KUDbpq1i4YtHlUsgByd6Nw/0LR+SmoJsGCkvpeC1ECnESYUa0bcd4SF4RUs6wDCcGENFRd1H25FKjWrc2mnKTs+0G5EF31QqtyWq/uFjXcm7r0hqqu9Yv170sNRIQTXd9L9pFivt9yGCjn+q7AURNQ2G5xOnWOdmTPz8fo7+hp71aPeOG60wO82HlaAKdInRdiYSrlefe2tFKsrIaLuyvjsu5AfMRPPhl9AoCAMTzEpeiEDZrXmvkQdNPOJWnm3LQGFPRlePph0eB1HLsfPM0kxDVFoyg1WgqstKZes/6igtG9zo+hglNqZWjRCkc0+7qZX2sqWzn3vYPvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXm2FaMoPE3/Qp168hDx0B2gv2ljJIE73hC1gqFbKQA=;
 b=U/TaVwYrKef9DT2GP4zlmu1oPTbbj9/pvk8LQ2J5b5yNsdb/hlzR+JL5OCjgQLIBUtVa27JdejWzZG253vg2K3sXIDfyNnWkyC3+KkDivl+Fc3F2T62vEwmcitF4kAnNvr40O4GoEYMDF5md3BWjn1w8Rcr56wBnIJKJhe3DHCav7pS+NLa1T5hWsWRuRl7/BmTS8SdH/d+OL61AIINs/Qr/YMNBPeXd2+1166o0ihib5RQQ2U5ALPHDrAMZfwQpNG27ulUdrK03Tw89q17azlKkwN3QRGnwFSihHOcGog7+XTOfD+NVPu5CX2mF3PrWyOsZjSLSdqiyzs/p+NeyJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXm2FaMoPE3/Qp168hDx0B2gv2ljJIE73hC1gqFbKQA=;
 b=UOqWp+r1TZL/GZXObiwWT/aUp+RgWNhlG8gP0TousCnZt5TMLcmpFYc4n02I2v7mbrFNAQqTpwWo9ZdcfBu+NVoyq6Wf+IU4+/FIJ4uQYQyfOnn1mTtK7Hq35stzS+K9IYNleGWbL9zg0NmBoyMpKpoaGzY6f4JxgViLF4VNpYlwQPJLH4MgYdcInjLbfU2OZcXYVE1QoP+xi27adL9LcrrVoHqhSnfTXjYDf4I3lNgBYUjN1UPa2hUTSlPsJ1ZexMXu63PTWxkdsBL4+Gff1zn7UYg4TwhHA3m+uSW+MAMPcrPAZvtu2lYw7B2HszSTzPC7k7syWX52gxHgTcnVmg==
Received: from DM5PR07CA0168.namprd07.prod.outlook.com (2603:10b6:3:ee::34) by
 MN2PR12MB3245.namprd12.prod.outlook.com (2603:10b6:208:103::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Tue, 13 Jul
 2021 08:04:02 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ee:cafe::4a) by DM5PR07CA0168.outlook.office365.com
 (2603:10b6:3:ee::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Tue, 13 Jul 2021 08:04:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 08:04:02 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 13 Jul
 2021 01:04:01 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 13 Jul 2021 01:04:01 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/598] 5.10.50-rc2 review
In-Reply-To: <20210712184832.376480168@linuxfoundation.org>
References: <20210712184832.376480168@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d52768a9c05b4633a275cabe6b79fc2d@HQMAIL109.nvidia.com>
Date:   Tue, 13 Jul 2021 01:04:01 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 320c9018-31ec-465b-c4b8-08d945d4c6f2
X-MS-TrafficTypeDiagnostic: MN2PR12MB3245:
X-Microsoft-Antispam-PRVS: <MN2PR12MB324580D1AC7936C7F64C312ED9149@MN2PR12MB3245.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajJzuDC9AFsfn58zIr1K7UoiZbA0l4qXL6obR02tkLEdK79O7pz5YtiGPOiN70J0DZTutEYTsO9pXaeeEJEx0K8q8mDKRGj3+9uuVq6/dS9pYVIskK17w1Mjm2Qp9HeYXEMSgF5Po9Bj40B2QB99EvpePqErSd1Ry/Kjh6dqvqepLSCGKzOBn1wgPkKD9W3Jg+/vnfBJri+5uU1jsePxSilW7TSD8pQCEivh6yY/LeMdd1uUhWgEv19JqbJvD3U7SGbx51JGkdmQM5jn02P4woIf5/10Vx+5r9BU8sVA9loWK7cT7o98InDiehYDQEl4wC4xAvEnu79eIlmvA2f495Ns/jLNfXd1b6/Y99fJDSwXB1pIlFpNaAH5oYNmhX7EjX43DeSyejZGcABbVWQ0eIKpfS1dTH1pBsHblcyigt14QL02Fud5NqH7R2qlDWhMi9bGPDWniRFER6+nW8+TXtdSLpYCS3worgmuzw4OoJYy/9cGb3v9Tt3J0cfksYzbzpzbERMVxg553DpmxYBhbKyCqIySRYneDyBISFnDAGHXKFvonWWWH7SuIshLZH9I3pi6Np+glhlSx0T3f1yo4iQNRQ7PDOcrX+FYWRhu07wwPKhQN27+BDPS44SaGr2DAHhEGaVq1lS7ZeyN7N9wAz2DuQdEuT0oGJlY8/IitLijjvExy1GUsF6NDnTR1u/8//Wb8LznoqoHI4ETk00jB+MwMXh70IzUnhF6A+sJE7bNdr9q28WVOUW9NK8gCXjF9kxPnn1rnnaFZCXfDb6Xa8UD+x4XatJze6+UkP8zf+ZlpUPmqGIwsvJlU+tZwf6P
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(46966006)(36840700001)(4326008)(316002)(82740400003)(8936002)(70586007)(8676002)(34020700004)(7636003)(82310400003)(26005)(36860700001)(86362001)(426003)(6916009)(70206006)(966005)(54906003)(356005)(47076005)(7416002)(24736004)(336012)(478600001)(108616005)(5660300002)(186003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 08:04:02.1378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 320c9018-31ec-465b-c4b8-08d945d4c6f2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3245
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 20:49:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.50 release.
> There are 598 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 18:45:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.50-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.50-rc2-gf820b41f4b3e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
