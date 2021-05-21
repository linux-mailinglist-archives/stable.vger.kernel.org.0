Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA00C38C292
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 11:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhEUJGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 05:06:51 -0400
Received: from mail-mw2nam10on2075.outbound.protection.outlook.com ([40.107.94.75]:11578
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232908AbhEUJGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 05:06:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJOoW43A7EcKrGuzE2LNNNogEsGmtQplRTgaC1YzEh9ZY1toZoFxCEFDnyesR0g5HLy7aGvWHTG6gUOagHfTAZzRGqZzsY+gs2zICCS0BNjsLxU4E9OcGVvbxXTFCtyEJp+4Xvx5gPcVSfHwqPPID7tz+zaXhPlFkY69ShGzEhx8IItmsUI/aaimkBZQIwxgkSQEOlP5DJkHp5hJv7JUBM5HxmYxeqmsQu/q1l4a+GEDFKHYqg6vfmJjzMJQgRuEY7zS16M2PphJz9wyO8qCBxWD/k6DjNAHmtsrb5hE/Js5JzAePo2xzb+mmNS3d8Gf/2N+V3S2927HZBtWvoNPQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GK3Bjm9dZTsWhccNyyN3K+b227n+30+Oet38TA4gkUk=;
 b=M37myQrZsz+bu5oGGe21AnPD+7kmFdp0EF9EiIyswiMvK9aTbKA99kap+SurreTCQFWkd7WVfWvCI3aYtPpNLV2NRYzEeEqjgELJvlWWWvLbaqGEVwQ/kEaWsHopx1IYTrdkeyg7Usm2kXasB3YVyfBzoOcsa83mDPloKX5aH2d5QOlToHT/aNByQcNlXhXHxgLs/TkYrSEDHUGb/w9rbo/X9bDvR6RIXLlQJ6yqLEqyuYxiq1LuRCoAo7HTmwxUhECu3uW4gGGundmpiEBYvWjYoQ5Zz3rJQ/igC12Y/T9c44xCGZ/XGO0mtrDysRPWc8U6/gjJ8d9bigthHjGSjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GK3Bjm9dZTsWhccNyyN3K+b227n+30+Oet38TA4gkUk=;
 b=I/WaZLpmjirtxqcomwdvnDeyayfvZus/DulJTxptYZmWZ6euJ/YyVUSft8YHlMCc38+DlgwSoN5MLthLLj6hIMx5d/if3YZGrCdvJP4HkJZ+NLxTw+o/TpXLaAMALMBUvLuf5/CSrpFcO58POKimOEjawcgavJgZCr/bGzxvNbWxsScvTxoQjVJ59x3IYO7xY/pIG0YwvpmnIJExcDJCIxGQp4PbJlOGYxBknG4SMwoKkheGEG4aT6s1/p1ZcmVgf4mFKlGUFMjYEliWdtRk59bhuG1ZPY+/f91uXklRzNx3jA53XL0QbcraCylHfGQfY9roBgRsahZDRHpx66zX5w==
Received: from MWHPR01CA0039.prod.exchangelabs.com (2603:10b6:300:101::25) by
 DM6PR12MB2649.namprd12.prod.outlook.com (2603:10b6:5:49::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.25; Fri, 21 May 2021 09:05:27 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:101:cafe::4b) by MWHPR01CA0039.outlook.office365.com
 (2603:10b6:300:101::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend
 Transport; Fri, 21 May 2021 09:05:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Fri, 21 May 2021 09:05:26 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 May
 2021 09:05:26 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 21 May 2021 02:05:26 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/186] 4.4.269-rc2 review
In-Reply-To: <20210520152221.547672231@linuxfoundation.org>
References: <20210520152221.547672231@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2b697d9aa6744c778c24a1edda41ae71@HQMAIL109.nvidia.com>
Date:   Fri, 21 May 2021 02:05:26 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11cab7de-a19a-4532-636d-08d91c379348
X-MS-TrafficTypeDiagnostic: DM6PR12MB2649:
X-Microsoft-Antispam-PRVS: <DM6PR12MB26493F958CCBBA3E6E22AB9CD9299@DM6PR12MB2649.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WnvOg0I85xykyUHBHU61or+r+7U6NgAucWO90++iLcTjKmoZQpVoHVQwYAdF6zB9WDgMx9xDtzCbCOPeqesaUgNYGTwi+xMCZFdwPOj5uU8lC9yhAfKvZMjoMv0aOnCXQ/Wmln8P3f/E6IdTD+Pa19hzR0bZjKbfVXe6ywFIkETZfS237YkGPtTUr9qji58URn8/OM+5/8sQfsz6wwrVUaaS6z218HpbdTpp5xJhziM/eg/ErJzBzpXIKt+oPmGUKOpdeouRVydSznqVAVb0rLi/x5WWJNyPSmUgGaAY5QtaloVEHsYHtWhox6NFigjEI2ZyaPSbgsPSoWOGn0pX9DtcS+mp/OH0hyEs4n2LeKG+abtgPdfp1LDH8OsrLqQCEyC3xtRdnU7CXo8NFoiOt+e4FLqo1HKVLqUn05yCcg5jekkRVd6t7zdXseTjqtb/M214k5g2mlBViW/PVkqXBJxdsoIXnVPGm9aK+shA6ViZtc23ySJOk9N8Pj82I9pdjL+XLPM8cbQVbS0Mtc6kSySO/D/Y+rS4fYA8gQbxFDdhPkz1I73S+X1vuiVrror7UKFUfxKXeJ1ECUT793RSbz2hpVWqdvy+7RSB6LuQy7CG/FKsbf0x8hGHwsBulKJPvjJU81CuxLoYO8HTabf1xJasGt2v6dIenw3u+/GfQcgB5Jk3l0XMMNKJCLbokb+JkYa1oF1MNdXlsrZyP/hLAr88BEpeQTiNolWFBxI/hd8UI7vr49CLkSzXzo2FZuqAlKeYDmD9Quy6UYtV352Zaw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39850400004)(136003)(46966006)(36840700001)(426003)(36906005)(316002)(24736004)(108616005)(8676002)(186003)(356005)(82740400003)(7416002)(82310400003)(54906003)(6916009)(336012)(47076005)(7636003)(8936002)(26005)(70586007)(5660300002)(478600001)(4326008)(70206006)(2906002)(966005)(36860700001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 09:05:26.8350
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11cab7de-a19a-4532-636d-08d91c379348
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2649
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 May 2021 17:23:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.269 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:21:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.269-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.269-rc2-g9d2abc11d0b5
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
