Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A417462EDC
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 09:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhK3Ivc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 03:51:32 -0500
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:60256
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232024AbhK3Ivc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 03:51:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kT7MjgBBxKvA+D3EhBK3jikG/o5I1sB8ar1xk2SXK2aVAO7gxYmFpQHawg3JouxdthMhUDpJOzYnzHq2i2fzqbjV1apOI/Qp084o2O1oFY5yXC/QEfN6+ffHcIo20KClw8ug2qzqmyFLJmbgNh3T7C6kkAnumbR73A3AdIRkV/BqzLGUAuKqL650eqV01rmgWeBHzEFVQT4V467U/y++e2CoNUTj/TIWqgRbmh6tanNcmIZVuyTtP5cAziJhGW6HlonhaT5ypsPOVPW9yp72akXH8TWGVelgGTK4M+62hrHkDz/0Zy2gKnA8kVyfXTn7bqtcjp2VFODqp2nDXXy+qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G/PaEQgDhwpXr7sC5tUc0GxkSNHbpmV1H3Fs0sZVf40=;
 b=c+bZQH0acUCxtjHO609yDFrpw9iESs9GL51hTlmcinkET/DOz2STiQPpohsJoG0MggqijyDJ0s1nLi8cWG1xvd+nS/2WX3UJDqU2l9c1DarVY/hPj1hFh+q5gUOyB14zcRaHV8ixKy79MTiHvbnPO1uIoZAI7Tg/UuRll4IpGjrfwE701UieYcG9lRoo7/Lqn5V5UlSb1/ous3qQhEcovVcmDQ9H7YdBNfvAC76BDvZTMciQki9X38rai58D8WVtl08Zk+jT4bHu8oJtt92Iz0bGWcUC3LivdRKoQTzXwyOrLoQ324/eMLMQsbI96mXkLSZnKcABmsan3W/ldWyPNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/PaEQgDhwpXr7sC5tUc0GxkSNHbpmV1H3Fs0sZVf40=;
 b=Q+XhXdmPgf1MFhFjRw16NdSfNmsHEeQmxzzT+E0iOGJMuZ0xiXm4Me9WTkbfeePz16pPO8uQwZMSNEBzF0q16mweV1RvDGXuAGCwjFWsKuEqer2Rsb+jpxeJnVHYpwsfD8wIuF05Uv+HOkrd5MUzG9pi4LWJqT1GuriPRvPyRqXFnLu/NnWXTI8vwX36r2eoOfGExxpDL01NbD3vWX9p+271ungJZ1fstkNOhxm16OcUq02iXOF2yOvdDHQmK6AT+TXQDiCdwqdYSq6KlSgD5FVSMPgw3pWm6RZO39YTN2sqOKsJ91YN8Js2/Z2UUJI7/GhUOBEDcd46uNIeSG5+Bg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 MW5PR12MB5570.namprd12.prod.outlook.com (2603:10b6:303:190::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 30 Nov
 2021 08:48:10 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0%4]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 08:48:10 +0000
Subject: Re: [PATCH 5.15 000/179] 5.15.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20211129181718.913038547@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <3210f340-f3a0-2cf1-8b3b-59db6e58e65e@nvidia.com>
Date:   Tue, 30 Nov 2021 08:48:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0501CA0005.eurprd05.prod.outlook.com
 (2603:10a6:800:92::15) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
Received: from [10.26.49.14] (195.110.77.193) by VI1PR0501CA0005.eurprd05.prod.outlook.com (2603:10a6:800:92::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Tue, 30 Nov 2021 08:48:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fc6801c-8947-4d7f-b937-08d9b3de22cd
X-MS-TrafficTypeDiagnostic: MW5PR12MB5570:
X-Microsoft-Antispam-PRVS: <MW5PR12MB55706F6885369FBF35CCE52FD9679@MW5PR12MB5570.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /mSwgBFzwR3VEO9xawHyedCELI/cC3Rv8BNMVePMs+j0Y9jdo5gFyqXwbVn2d4HGwCOW9WtVG4CK2swjW+CmyhcItkgNHntgLpB+fQiyNOAbs/6zW5WeI1WaEFiMlwHh+3c0+OrQfzcMOFWNlW6DLjomeGKHnqThR3cFo9YqTmfI+l6a6dLuSdS31JIYiB2SKCrBNGMep59u8o1n99ZiSGqqZr4JrAHg+Mk8ADfYgbmFBACO+ibMm/dD10K9olxJOYQTUQU+ExavW6A0iUJwZVe1GuHprZ6fuRuIyFBXE0agFHOVetQ+wdDEPnSQoBjI2+oTYl6L+Zylov2e3QynrifpB/HigpkL8i4OkjuYFe6uAQPSWe4ZwhihVZ7wQBrn/JyRbUP0jE8Z2vPWN5Y7nQlFzU6gVOsHaWvd3e8SOpUNzayGgqpt4pm2lYOt2/vX5zjDtuedKN6BFSLEU6MVbd/iKK2FEtyFVSWbRTnEZD01PXsXBdsvJCp0XZZbQ2xvisGzrjopzjRwPpXLAzWrUM2ZHlHbcTd4Nem6O6DyrrZS4B4MIiATtyQZ/FuHyNuk46wezeiZ1ANsJGnCw9zYOviibqHi5L4kDRh7FNHTabhbdtNVTPHo9/25jN6CUWJk2/3z4e14EGOvSv6Tqlz4AV4I9euU+oGH7kRI3ThFlFVV+4b51hJxvk5jLUpX4MJUFrq6nxTgA5nvzM9H0g1DgcLQe5VDe9pVxuR8fKhJv4bF6ge1o2ZJinH2b/LgLnjUkYXiPNnb4XqKXAWwD9sJ1wRFBJauVRWEh9QwNEnUZmGPY3BcAs/4uUlQndZaxGfzTc3+XnVSVOlVey03ZnKfMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(31696002)(6666004)(26005)(66946007)(2616005)(7416002)(55236004)(38100700002)(956004)(508600001)(8936002)(66476007)(66556008)(316002)(36756003)(6486002)(53546011)(86362001)(8676002)(4326008)(2906002)(966005)(31686004)(16576012)(186003)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXZlbkxDNFY2ZHZqeTUrZmdrWUkwMkdPdkhHUmRpbFlQT3ROT09YbFBETFhG?=
 =?utf-8?B?eFR4Und5YnoyK0ZZeEMrdzhZUFpwQTlRREFsWG5OWDFJZ28zRlk1RS9HN3d6?=
 =?utf-8?B?b0oybkQ5TnVITEZSTVlWaC96OGRiQ2JRek5YN3Y5RmVPcjlVTEprR2xYYTRZ?=
 =?utf-8?B?SnVxMUVIdUVzQWQvdWNNckg3LzQ0b3BhM29vRHR0MWNLenFOYWxmS1crOU9W?=
 =?utf-8?B?bUN0OVpxbkUzd3FZdzkyQk50VXM5S2FhaHozamlldnNtTk5nanFmWUZkSG1P?=
 =?utf-8?B?ajNDcVh5ZGFDUUdMT2N5QUEvVUxXRVJuMTNyVXJlSVVOTEZTblJIaTVVYSs5?=
 =?utf-8?B?a0pDMUtXK0N5aXY1djcrUzVXYU5JSFQyeHgrODR2RWNMR2wwTjVRMHRraVVJ?=
 =?utf-8?B?bWVPa2lXQ01hZ3FKTUhDcFlBVEpGU3ZkdXZ6dXhaUzkvemVkdWQ3VU9FQlZN?=
 =?utf-8?B?QmppNlZJcDlkVm1heWdxVDRNL21RTzBVM1UrWCtkYWxZcTA4U2ljdjUyNTk2?=
 =?utf-8?B?bk9ZSk9PZk40b0Z5OHBoZDAyd0NMSkZ4a0UxaVNhcnF3b2Q5NGJzTGpCRWNn?=
 =?utf-8?B?SHQ1Y2FsZG5yZ1FsbWx2eERsbXZ1NjNDbmRFaFRZcmxKWndnRzJkcFBVb1F2?=
 =?utf-8?B?Y1V0NFk0M2hJUWxibUFvRDB5ZU9wak80a2Z3Y09ZeFYvdDd0MXpObysrMDJ0?=
 =?utf-8?B?dWpYNnQ4eXFwSUJZMFZxVXo3dzJxZ0NXYXVmVWQzNytOS0x0ZFBXOGRhV1JV?=
 =?utf-8?B?VDNocTA2V0Y3dGdJUUdDQXlIYVdYNDhRRlNDQzk3UEhHajhRWkZ1UkZoeitL?=
 =?utf-8?B?TjIyVzVRcjJqRC9sYzAzOHNDL1dyMjhuRDVuUWlvNUVpOG42eFZBNld6TGVq?=
 =?utf-8?B?MmhnMlJaSmI5S21MbW1WYVVNZm9jUmFDV2VrWXRoWFNGaGxjWG92RzZGUkVS?=
 =?utf-8?B?MGFlSGljRlM5WktuN1ViOUdxTHl0eTBLSlpCd0VnZTJvQ0xkSTdsMk9FZVdL?=
 =?utf-8?B?VDVDK010MmpPcUFHNkF0eXJXMGQ0VXFIVmRJS3NnMnRwdlFzWUQ1U294cEVR?=
 =?utf-8?B?cE5LYlV0QTFOdGNFNVNwOE1iSjF5dDN1L2p0eStSYitZUUltUjEwZWJpT0hC?=
 =?utf-8?B?bzEydE5USVIzL3Bod05XdGVnNWl3NWpJTW9IaUFnMzI0cFprZUd5L2VzYmQz?=
 =?utf-8?B?c1BJNmxOOG52b2Y5ZTVkZXJVdnp3eFl3MUtkMHpXTXJvSE42bDV3SnFLeE92?=
 =?utf-8?B?REhsWEZuc3Jnekw1UzBJZkZVR01KbUJRZmRjR242bTlEcDlRNlMyaklQS2c4?=
 =?utf-8?B?RlpvZk0yRXF1TEwyMm1veVZkVXBKbGV5S0tVTjFIWWd6bWRwVHNiOHlnQmti?=
 =?utf-8?B?TjFzZTVxTThRTHdmLy9UamhFOGJra2ZKTXB5aUFyRndkWFAyWmVKMHFIK0l1?=
 =?utf-8?B?ajkxSTUrT3F3YUl5Y0dEbFlFZ2ZwYlV2dEYra0d3bjNNbml2ZFd2ZGkwa0tJ?=
 =?utf-8?B?SGdaVUEvbnQrUXVqUElMN1JaYzZLcm1yRnF3WEtBaVpxd1BZSjM0OW5yR1I1?=
 =?utf-8?B?WkZ5b05Zckp5ZStuVTV5Z3FDY08yYjFmT04zanluZlNZbHVYUW9yWEJHdVJo?=
 =?utf-8?B?NmgzMWtYOWQ2TFRGemNXcVYrR1dMTmF0OXVla2hSeE44blRaL3V3Q0svOGw4?=
 =?utf-8?B?OEpQOWJ2b3QxN2hGeEJNVitYejVTTTNGcDNsdGRKaGFuSDZ2M2lOeWdwVDVZ?=
 =?utf-8?Q?0OylSnQUnJRnmEnFtN73qBWHFLu7d6ZUpF/QDfz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc6801c-8947-4d7f-b937-08d9b3de22cd
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 08:48:10.3519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0oqiwLmSiJHDxAHiiKgwG0rhT5S4/nv55h1qeUEH8R0WiTc5yUThEooOQANpjQdaUIz87AiULUZHcR9OCC53qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5570
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/11/2021 18:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.6 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No new regressions.

Test results for stable-v5.15:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     114 tests:	108 pass, 6 fail

Linux version:	5.15.6-rc1-ga6dab1fb6f7d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py
                 tegra194-p2972-0000: tegra-audio-boot-sanity.sh
                 tegra194-p2972-0000: tegra-audio-hda-playback.sh
                 tegra194-p3509-0000+p3668-0000: devices
                 tegra194-p3509-0000+p3668-0000: tegra-audio-boot-sanity.sh
                 tegra194-p3509-0000+p3668-0000: tegra-audio-hda-playback.sh

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
