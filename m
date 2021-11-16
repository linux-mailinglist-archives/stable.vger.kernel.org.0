Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971834532FB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 14:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbhKPNmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 08:42:44 -0500
Received: from mail-dm6nam08on2043.outbound.protection.outlook.com ([40.107.102.43]:62560
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236566AbhKPNmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 08:42:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=loioUIB3JYlH2mSIBzoE+WewgIL6i4rdbn1wzBJcMOexsD78Es1XBmcjubuoFR5rZrK8PMzTNdco71Njiaa+UzwbuPcqFWMWTnVwuCch9/0KnWsx4uumMHozy73Q88DfJmInibD2OgpJ2jtQNmqZ0c+BOFvnfSueKlR+Y/yRl9ClOSmlXPMAsyR/RJ5+XhEF98tNaV02ESt1CPNvE4u4m4GA4xO9GpMllNx58cIiKrY7EpqMQFdZRipMtPgI5ttyccBEtn5GoRYOaf4B/b6Jh6j3KXhPdWGXDcFF16moW60SNkKe1ceAnjiY+n3kIMXIegT/WnvqBzD5iX+YMF+9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BS2r4Zs7WyU0+lxSWh7gjNspcMstvLZ1hM3yM2nwyhs=;
 b=WkBaO/6yJSv3maJYUq3YsRYBfcUCc+jBGsxXI3fbN1GhHMM+mp1OaGPNR1Xw05gdBr8JT9GVGWiNqShNwoFMPPwYJHfuKAjQ1+4BMn4dRweSWtbVUKuq1amamisblfC+SFOicWeBRnD3K4m8rHevhex2dVRqZ5IS9KDHUr34zgEkHt877O8yQ5N6D0lZnw0w+2MOt9hHrL7vGMwv/DwemgqvgMYcsU7z7LXgniP0BXl7ToXuq8WLFn8AYaKsj/cv0VNhE/o7d/o2PNkHKqdfFEtfALwClB9Lvhnimi9HGNBqlylODLvVobOGz/LRUPEHXk9wfiYkOaGnq+ZUK4s0rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BS2r4Zs7WyU0+lxSWh7gjNspcMstvLZ1hM3yM2nwyhs=;
 b=AXUNwUBFnFSvaqmNmumfVWtFOYOhNntwaclUzh9qqbl0ujTvB5eOeY1/8I5CgI0iYpBhIbJKSoOrhz2CDh5glcRVcFDXJMQJGVUb1InzmZ3gtEEJwdvYVTGSJ8/nzis7e3bQTkE+mPovurBSKd6+0idsp4UNXbgzMRk57HRkHhMA0g9EF0VmYbOtjFApncKavSneBFHyMlhrq/E8L9fz+/Q60tckZwqJo73Yg/i45j8MTqWuLCA5Pt+4HrPi903rjmyjRauK/zO/Q6Ed+fZVuKP9cDeG0EOGA6R7lbXIxUCwt04USUODeaoB9/qAN/yw+QwltggiLYBcux886f1xcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5261.namprd12.prod.outlook.com (2603:10b6:5:398::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.19; Tue, 16 Nov 2021 13:39:44 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86%9]) with mapi id 15.20.4669.016; Tue, 16 Nov 2021
 13:39:44 +0000
Subject: Re: [PATCH 5.14 000/849] 5.14.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20211115165419.961798833@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <8805071f-e696-c2b1-05dc-c13b00bb95e1@nvidia.com>
Date:   Tue, 16 Nov 2021 13:39:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0070.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::34) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
Received: from [IPv6:2a00:23c7:b086:2f00:5a53:1500:28ae:ff6a] (2a00:23c7:b086:2f00:5a53:1500:28ae:ff6a) by LNXP265CA0070.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 16 Nov 2021 13:39:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 936e4021-7cce-4742-db2e-08d9a9068c7e
X-MS-TrafficTypeDiagnostic: DM4PR12MB5261:
X-Microsoft-Antispam-PRVS: <DM4PR12MB526193A563C6C450E425A227D9999@DM4PR12MB5261.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ndh0Jvo6uF/93QdYqksbvDlGCXxnYDOCC0t1qj0oKCYhOXD5p1OUnJORNkUC0IU0toPL/LFMqncuckg2zoG2qREaNHncG/CefvzafB6Wqx6Pcjf0jnTlkZtzxMe9dE2q4d8Tbi92pbp2ELZ3usANxZ8+UowshEfZ3Ghttkflnbnoy59p+rTFzGgUPl2ARnm7ljqQTNYWrRVAKV7T+iNhvPfERiGkskLapTn6RJFq2oAb/8Q6wJe/aLdSsTMJSO9gwjwQEfIaEVMgmVeEbwIUTmpcVaLIZ7GQJnA1lzAqSM6kKUqqHuj4c6MNQF5Y6sPHTFAt6Mg1oiiOSiJzmxWwPiBfEi27vuCt4s7V4YQZvZewJkrZyUmXicYFK2ctLUe0GW7BzK1sG4A4yBgHOrZ+0YeisntrMibnSUvzztPvV3+Vii3QcF4sRjl1kZZ4wdSsok52HCjaCViBwGfuPwDfQPJ6fXQOUUvf340i0xpWNjxwGYjEFCTlA2hqqvwrKBTcOcx+oWH0dp1g/mmUyW5fxCWBxt0bZqEnBYXfVuGv9obIFj7ds9dhUPOSwZ3Odx+Y/agUxOn5gS89kgkRwS+qeFCm7PjZ/u+rMtDh6EukOlizdzwsVJsxldq5xmFcc8SlO4zQhHnQ1xlhXzgTBlv/3jZKPZh81F34b09JwMOgc83Kkofy7//WVC6SiDuWnvwkP/Vvx7iKAlBzbCxGW2dhuzO7rZk+IphdmWzfSokJgiS4wejdza1VwUq/4CuKF32WDaKnh4WamKA9cJ3/9z1FhogreOcDM0C55O0+pbYGxdZD57072ExHSEsK/gpzh2cfjdpiuqcGidOXxa88a6uhfLSbsntjL0VZZtTLPOITiOmionlo9JR6BY6jF/9ayBx8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(66556008)(66946007)(2616005)(7416002)(31686004)(86362001)(6486002)(966005)(31696002)(66476007)(508600001)(2906002)(316002)(38100700002)(186003)(8676002)(53546011)(6666004)(4326008)(8936002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTFuUjNFd25mU215TVExR0RaeHZLUWdQdC9SU0FDZzZFRk5GbXlnZzQ0WXI4?=
 =?utf-8?B?K20yYTJubXk3WEM5eXY0RGdBaUxSRlJHanEzTjhwWUVMcXIvK3EzOHFrY0to?=
 =?utf-8?B?cDNXY3VpUkc1T2Y2ODJXT1lxaW9iVWYySVBpTWRCUWJKTkNsYkVBSVVDWXF4?=
 =?utf-8?B?aUpmZDlSTGRTT1lPM3AyenJjR3E0NXNIdVp4QVVlT2xGcnhYUmRMZmpIMjJw?=
 =?utf-8?B?bWgyWkJTQ3diOFI4VXdwakdPVkdITWRuZEV0Sy9iekM4NHE1QnNOMTRLUm9j?=
 =?utf-8?B?Z2RXRzh0Ry9XaWxzYUYyQ2hQdnNQTzNIN0t4VDVERFVSUzBBQUhhNmgzL2NM?=
 =?utf-8?B?c3ljQ2ZsVEp6UmpOVHU3Nll2MmExTVE1UWRicjRRcFJVOWFoSUNIamtWaTlD?=
 =?utf-8?B?R20zWDYvR2czMUdVSlNPQ2pwbWowSWpMR2dxdXlYSWM2U0FQTk9uQTRHK05B?=
 =?utf-8?B?SzdNQk03dnlJZmM3SEJkdEJDSmdtYVlPWVE2cHpCTWR0UHZSWXNZWnV5c3c2?=
 =?utf-8?B?Vmx1N092MllwbTdsQU5rYlBYa0hBc1Mva2hhOW5yclhqdjYwMFdzbSthWHJV?=
 =?utf-8?B?SGVvbExvNEp5RkpsUkpTWStKblRsbklzeVhVZGFxYkgrMzdrV2hjUGszOExO?=
 =?utf-8?B?NjRWaFpTZFE2OVlqNDRUNTViMTBkbHdvaWhMcWxUK25sdjNBb1ZZRjRBODYw?=
 =?utf-8?B?YlRlVWZCcEZJUkhzcGJtK0NFaWpFRCtLWTlDNW53UGpHang2NVp1Sm1ZTVhM?=
 =?utf-8?B?UjEvRkNBd2hkckRIUjdHelcyT0ZnWERyRFJOQWJJOVgrb25FUFlybXpOQkhu?=
 =?utf-8?B?OXRlTjAxR2dKWmFpQ0IwV1FWUDFMTnhqdHVMNUZmWGM0L3lvMEVnOEhZdXBs?=
 =?utf-8?B?UDhwTzlIdkNKODREa0xuZm10V1VRQkJsd3RjZkIwK0E0MUZhb3dZYVV1TEFj?=
 =?utf-8?B?VlpZSExTaDYrRDRoZGlMbzRCdVdJWThyWGx2c1N3MTEwQ0JtZGptNXl1aU00?=
 =?utf-8?B?OGhJWTJKS2I3c0JXK25sb2IxNnZXVXF2NzdtYVBoeTgra1NTK0s2VW00VTJW?=
 =?utf-8?B?SU9lMFlKemQzLyt5QnA3NWhCajV6bWMyUFZkK2Y4LzVDRG1saWJmOGZWMDJZ?=
 =?utf-8?B?UjJZbi9tOGVmZmNJSzFoRStMRlByMUhMNW5VZHFwbk9zTnk0Rlg0MnFjVmlr?=
 =?utf-8?B?dkJaSDlYRGdYdGFoblMyZk1zei9XUEdFQkhYTHAxejk1R25tSjVMZ0pXa3JO?=
 =?utf-8?B?QlFNOWFPVGZkWDk3QkIxMU0vWnJDOUlDSVJ1LzdHdEhxWHdqKzJZa0J3SmxE?=
 =?utf-8?B?Qnl6THdQalQwWUlFb3gxK3VYanZKWGl5WWdyTXhqYkl4NERVQ1ZhK0hWUVdS?=
 =?utf-8?B?SEx4ZkhHbXNFR1YvY0RYVlVWTzV5MHNMcytNQ1dvbVVOeHBjZW5RZlJRTnkw?=
 =?utf-8?B?Y2haWm01eXBGdFAvOEFCMk1wcFJzdnc3MjBRNEpUVzR6STNEbjVFZ2xTU3pV?=
 =?utf-8?B?VWp3Mzc1Q3BpQWpIWjRVOUNWZU4rU1hkN0ZHY1Nxanpvd2ZnYzRhNklHY3Bz?=
 =?utf-8?B?UVFibHc3dkh2UCtRZUtydjJNM2ZHTUl4NjhqMzVoeDJMUmRHMSswTlRzMmNu?=
 =?utf-8?B?U3RvZjFmanBRSkVnWGNwNHFQQjh5eHBETXhwaTBJdStjL3d0aHFPcnNoc2ZZ?=
 =?utf-8?B?UU90L1VQTjBycGJjeDNSQmFNR21ickNTYi9QL3VmOTl1V0NZNzlnd1dwMVJR?=
 =?utf-8?B?M3RHMFBqTFVOdmJIYjBRLzNZcnowRWduL1NpWDREc3FjVWNNaitsN2RMMXE4?=
 =?utf-8?B?NlloWlVGeGxGUHZXdDNCUDFNenpiVlErVjFJQkJaK3Z5dmNVR2VJeEJFb2pD?=
 =?utf-8?B?dE02dTlNQm1KSzNSWk9lUENlSlp2NFZaVXZzSElJYTRqRXQ2enlmNUk5OTFY?=
 =?utf-8?B?T2Y0bjVINmc5YUVDR0lxVG93ZlcvZ04zOWxxanpLZVNSVFB1QXRyQ2loODRj?=
 =?utf-8?B?ZUlKQjJiR1FVNjdPNXJ5ZndXZUIxYmJtQ3ZSM2QzTHZYc1g3bkhJWFFiUVp1?=
 =?utf-8?B?ait6aXQ0ek1vdW5CcG1CUU1nTE5rSGFWVDdrTitoeUE3bU5nbGhWTkZ5Z1p0?=
 =?utf-8?B?Y3NWc2tNVWxyajQ5OTh5UzRLN1gvbktPNUNiL2xGbWZUV1A4bmtOKys4aWpF?=
 =?utf-8?B?UDZ3aXZPQVEraWlxYU8reFQ1b1BQbFM5UGYwTUt5YVZweWVFOWNGWjFNUjRp?=
 =?utf-8?Q?UWmGr70bd/E5ptatQr6tUQ1lGa+7JziMFrWWo3ojdM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 936e4021-7cce-4742-db2e-08d9a9068c7e
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 13:39:44.3290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kvtA3YumYkc5/zqi350qp6hoqLhthbRt7lcyGVOeU/5lyZykPYN+TdEwA7tbvyFHHFXJF9lvHWijUUusHDE4Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5261
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 15/11/2021 16:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.19 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> Mikko Perttunen <mperttunen@nvidia.com>
>      reset: tegra-bpmp: Handle errors in BPMP response


The above is causing a regression for HDA audio on Tegra. Please can you 
drop this from stable for now until we get this sorted out.

Thanks
Jon

-- 
nvpublic
