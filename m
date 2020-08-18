Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B7C248356
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 12:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHRKtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 06:49:08 -0400
Received: from mail-dm6nam08on2071.outbound.protection.outlook.com ([40.107.102.71]:23678
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbgHRKtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 06:49:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2Axp/Vmr8C2mSViXat03oHBwJsf6wLutzgY/18b5Qi1kO6qeCyx9wVsV2qTnaMu+OYnzfpchZs0ItD/+6CI9iwjXjmE3mwC6GMWSWcVcmflgZp7JicIivqqLgPvk7WKfaFpuNyUPyD5XLbjKFh26BhsidCy6LPcdtbiXdrZTllExswUCIjOOhm+2s9UO+PF6A8bBvqhY2uvst0LXzxdpr3nfPTB02LdxKC+6GSQh1hNDfgUbROLXg3BXhHwwAeQWcpwuULN81oi9MS4LA68mbmJoqPai9xUXkyTeShIyPM+Q8i27Uc6irG8zLOkbkkEa0GXxk9EIpXaA+vD1nhRqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Biz3aXjx+2jQ61i/tvLYaHWwIrQzNiNR9Bv5d6AsvOQ=;
 b=kfpxuE54iJq+y95HPq2Hfzz4NNzMmVpOIj4ZyH+db2laOZMV7PITo2PUIBgBCjSwe0KYigSNH8ShSJGAN1+XNncrBjdjiHfU7hDrpQCS07Y+JxDwEdcfWW4KGArXAAYK6hTCTgoEG221KPs88QTRu9X1O3rPcPWfEfU8BkkiuzJjFtp/g+3H3Sj37QtJEGkPuRUfQHu4oScLbKrGY0L1LmVydMWa4R20GhDb48JHzdgXVd/PISVShA21eoy2q+gCavVdE3bRfcNk/L1KxWUU2cTq2FoJdOgtUg40x2CTlDd4FP8LoC8lG9EmFRgf8h3Mo3PDE4m9YimLviRt9+03Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Biz3aXjx+2jQ61i/tvLYaHWwIrQzNiNR9Bv5d6AsvOQ=;
 b=MvM5tuM2BPRgobT66/S2vSS8Z8ZI8xFG43maotaLlmkzWObEQEkeW2Qz5E7TTC32RRv51AY9gZkg48IWOk7QioebTIYBlMtGqy+szoWF4p8T+ddMqmdVx6yc6zn9DSTejAcAbTwPyhdxIBejWuLB8YIbpZiWC0Jq6UPNoxc/kio=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4343.namprd12.prod.outlook.com (2603:10b6:208:26f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Tue, 18 Aug
 2020 10:49:02 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d%6]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 10:49:02 +0000
Subject: Re: [PATCH 4.19 040/168] drm/radeon: disable AGP by default
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
References: <20200817143733.692105228@linuxfoundation.org>
 <20200817143735.768643197@linuxfoundation.org> <20200818094135.GC10974@amd>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <06ccec09-ecd2-b18f-6234-7409f2a3c30a@amd.com>
Date:   Tue, 18 Aug 2020 12:48:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200818094135.GC10974@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR07CA0004.eurprd07.prod.outlook.com
 (2603:10a6:205:1::17) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM4PR07CA0004.eurprd07.prod.outlook.com (2603:10a6:205:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.10 via Frontend Transport; Tue, 18 Aug 2020 10:49:01 +0000
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3bb0fbf1-40af-4bcf-8b4b-08d8436451c2
X-MS-TrafficTypeDiagnostic: MN2PR12MB4343:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB4343CA35D58E031BD3EC1CB5835C0@MN2PR12MB4343.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Vi2yvo8dsKV9RreNPnTayM139s8DDk4q2WO7NTmXTZ6h3GP0F0mGQNr/HZSASQKaEWvRJ2p1/x/gkliteFJgcl6/POxDlCdVt4wfQAsSe/MfC4e1luKiqbRQiSeAALjS8TX9J5GtGP4Br6CED9/4mLCK9/gE2Vvnj8L7xUeeopUoYIOOBGc0HUpl0+X/sfgpJS7cdGaPZHjwKp6jB0skWv6kx7FGt4s/pElGmDQRhvW2a3X5NuEQWnBA+fAH4XOXLKEoYwBr3Fob5++nOL/8c045/ghVBQy0TaNTUoGVXk0Y9gP1TgbO7UbtRkhLZzlHNW+jMiz8QKnRXOZpwJ8KmVwSpW2SSP/so3rKgbD/jXWJTIQT2zv6i/Gc+w9jFmw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(16526019)(66556008)(66476007)(36756003)(66574015)(8676002)(5660300002)(8936002)(186003)(2906002)(4744005)(52116002)(2616005)(6486002)(86362001)(31686004)(6666004)(31696002)(54906003)(66946007)(110136005)(478600001)(4326008)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ve7oO6M+CwndVmIcpypS6pY60VlD7SdW7JyrCCk+XPaYEENhCmu48lDYrWpZRD4fudOSIuILnulROQfqotzHMyxaetQDJau1MN7FNHno3V5Rc49tg46bEHTKpu2B6hk8ewquC176YgiQt6edvoYVpxdW31cNgbiZqLb+QrvXokpkF6wUw4zNGWePsK6HPTyVO/U0FpclNwjU3BjiU28yzHFIBLx/eGNU1D8GU/he51bSeHR36MeG/TYPr97fsetsl1u30qH7qcQCPO++52vbbVjNqS0LN23uVVDHqnOHVngR8KXUosKy2+QcppcMTJG0HaC8MzaTYhEXK3NnbtfzLs6afCDNcZZp3ACVcEW/qBgjowzqMeJvRhwhGdvPjVV5+wACSm/WakPrw51j6Rs20+8LBbW3S3Tf7PWLvPBIBWzC9PShcIcZRvOmck/zhfA1zQ6K7fq9HHhY1en+7+6nJxFkFyk4vdB2k2GWSdoUoBVlpO/qYs1TPtnACy2W1x+5IlJxHxeAcWCCMrk8kPbWwHhcr3OXs0nSyt0sBZ0t0gsEj7MnxIpQMXtYURn1++ymLQROlkrwDKm0HNhWMrgHJ9YpmC9DViL8/0JDIzNmovqQZi62WpAtBTNe9jLdD3gqdHNJrK6YgLeMnwSjIOfFHDfC/IJc7GTg5Q1z+8laBIEI9Y9IG8YNKhCghSkCJLJSplJozlT1MqhLTHQejMvkbg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb0fbf1-40af-4bcf-8b4b-08d8436451c2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 10:49:02.5457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0HOfQ0zLoXhwKtybyf80Eu0tMUo8xo9oU01Ou+gr92CCTj2ePHUAotLEyMb7Y3TE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4343
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 18.08.20 um 11:41 schrieb Pavel Machek:
> On Mon 2020-08-17 17:16:11, Greg Kroah-Hartman wrote:
>> From: Christian König <christian.koenig@amd.com>
>>
>> [ Upstream commit ba806f98f868ce107aa9c453fef751de9980e4af ]
>>
>> Always use the PCI GART instead. We just have to many cases
>> where AGP still causes problems. This means a performance
>> regression for some GPUs, but also a bug fix for some others.
> Yes, and the regressions mean this is not suitable for -stable, right?

The stability fix weight more than the performance regression for some 
GPUs. So this is indeed meant to be back ported to stable.

This just modifies the default of the module parameter. The end user 
case still override it with radeon.agp_mode=4 or 8 if those modes work 
stable for the individual case.

Regards,
Christian.

>
> Best regards,
> 									Pavel

