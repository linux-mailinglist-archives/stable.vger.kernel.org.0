Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F642D957F
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 10:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgLNJvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 04:51:07 -0500
Received: from mail-eopbgr690055.outbound.protection.outlook.com ([40.107.69.55]:1696
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729420AbgLNJu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 04:50:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hueq8cO1U3E6gie+ZkK8JKRFTh74HFrxRlmfMXNCZCTar/3bck2c/SHYdqByth0bnTNKnuNDIMBjUP8bblDc6BbB9CrYSlN7iarBSPRGZ3Udq0LiUYv/sgpppTY/fyqnHOir9/rXU82e69SAjPmDFba7pZt7A1tgjElvqOKjQYyCo4x36ErkSjovIW/4gMKJcsBSEKXcjhRYU2mDHF/XemCpnBDY1qps24mIe9PImUQ94DaHkAY6FgxncIElu2C907UufauqYYln76isOKAzrg/etkDw0ABZxUZO600rOGXlSeHsz4WGm6r0ffXt1Opq7lUKmhCE24cZN5yqRh/F6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkHgv3hFz4givjHllppMSQT9JzZi4LWRQKCYJR24iRc=;
 b=RNicujKdJTK370FDy4gV4+EgHM28zSuzU9gbwBt3rWzkvOP3vYbpCNvg+W534wH/AnUCc74sd3CK1ftW/p4lH1PRzHuIclVz5wi7XCjHOTfowYC3kni6kfun63NaRWTHqr3vi1IcCxLOBYK1NreldDbCqIysw2Uv6u82Tcx4f4SQYVbwsQ4WpO6pgVlkzlEwQkz8ysqNQvEA8UTq/NOkEQyZB6iFnfbTObgLdH06Bg538P8NV4C08IXQPJ8Ozlr2UmFj+iXLMClNc0wM+Dy+nX4c1haw4Da69qQbAP2n3dsk/B1pfavbki2ZY0V2QDqGPlT7xxKyH4hdF+N6vEYbUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkHgv3hFz4givjHllppMSQT9JzZi4LWRQKCYJR24iRc=;
 b=NfDVpz2ofKhio9BCh7OQ0qg80/ron21kRKqw89TsMnoMfpUIvhqPPhyXM1DwJGKBVoNMtIpfUbYjBPC5bpDnsyM4qghtxVi+UdUxbl6+LPbe4ln3e3poFyrtfOAbz4PE1NbTIAuK/+WVsiMzkFqNKApVbufMqtLlZSrdj0MZSFg=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by BL0PR12MB2546.namprd12.prod.outlook.com (2603:10b6:207:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.19; Mon, 14 Dec
 2020 09:50:03 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::44f:9f01:ece7:f0e5]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::44f:9f01:ece7:f0e5%3]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 09:50:03 +0000
Subject: Re: [PATCH AUTOSEL 4.14 2/8] drm/nouveau: make sure ret is
 initialized in nouveau_ttm_io_mem_reserve
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Mark Hounschell <markh@compro.net>,
        Karol Herbst <kherbst@redhat.com>,
        dri-devel@lists.freedesktop.org
References: <20201212160859.2335412-1-sashal@kernel.org>
 <20201212160859.2335412-2-sashal@kernel.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <642b5479-d4d9-37a7-3b14-3162374829d5@amd.com>
Date:   Mon, 14 Dec 2020 10:49:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201212160859.2335412-2-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-ClientProxiedBy: AM0PR06CA0142.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::47) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM0PR06CA0142.eurprd06.prod.outlook.com (2603:10a6:208:ab::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 09:50:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9044164a-34e9-4e5d-6403-08d8a015a131
X-MS-TrafficTypeDiagnostic: BL0PR12MB2546:
X-Microsoft-Antispam-PRVS: <BL0PR12MB254688C881D3C64DF880747283C70@BL0PR12MB2546.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IIHQq5ye0Oi8MzsLeZOW9MSrf+UCkPkVLD3JKtyQJCFOnjZ96jiTGBhVmNwyiTcCYPCC3Ds+/gI0OeWYRwVJ+QAQcRynCkVpmf3Eo50crR8lXz82TLpA/9gkq4EdFvTT3DxJXCuX59/ZgXwda/Jh+gpZwqGSoxKV9fOywtW2OqolCaeVfnaLzFWf5r2qtzCRtLL7XsnkQgYzXmferrNor8dHOX4IBIDh1ICcDkUzjRr2iGIAVMmncnwl3qs6luXwjn5MJkM29WtGKFTF/c5CBW3IYSd8YyrzdJIQN/gztY/dMF02+iL35HMFyx8aAjWFoP5KUR83Z8GAY4Mz5wYHZi/TAskocjS4XnKf8o7I2/LZN3tuX37VAK9Dco7en9ZvtWu+ICSabmrzZKL5pcqGuPimRxON7J4CWqA/uzmZcZSscl2ZARwQaS0/DZKlFFP7Da5q2Bu2DQxqp5cVc5nYgG+G4ESIpUtd79LXbabqdfE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(31696002)(186003)(45080400002)(8676002)(66476007)(31686004)(508600001)(54906003)(6486002)(36756003)(66946007)(86362001)(16526019)(2616005)(2906002)(5660300002)(66556008)(83380400001)(966005)(66574015)(52116002)(34490700003)(8936002)(4326008)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Mnc1cXpkNG9GcDNkNUc4b1YxeU0zUFEwczRmUjB3OXlQOFlNN2x5YVZOSmtN?=
 =?utf-8?B?VzRSQWlmSXN3VXVidTB0ejlZMm5DS285VDlWY3pJd2EyVFgrRThJb0hSZnhI?=
 =?utf-8?B?ZllHbnNCUlF0QnkwL3l2a0c3YmNsNGdBd3ZOa2I1dXpzeUpXQnlwMFN6SFZN?=
 =?utf-8?B?SXlXL09OSUc4N3BwNUsybzVGelROaHpjRDEzVFRvUFJkQkZPWWp1WWNkNlRV?=
 =?utf-8?B?Yk9OU0s1cVAvdGU4aHVrL2tkNU4yUndXVTFGTnlQZlBNaWtEbnc0N1NIQW1i?=
 =?utf-8?B?ck1EeFhNSFZocGFzb0pXdmtpRmROM3lyOGd3ZExEdlZCcnA2dXo3aHpHTU4w?=
 =?utf-8?B?THhLQWZiZytGeVh3S2xySExYYlpNVDVmbW9LYmYrdHJDMThSakppR1hLWkpk?=
 =?utf-8?B?elRxODF3akNsb1A3Sks1eDhtM3hHTC9GUTIwcHk5YlNZYXpWTFNyNVhoM2lp?=
 =?utf-8?B?ek9SN3d4UitCak04djBaMXg1aDA0dHRmeU93Sm9RREtZaEFMRHc1R0RrTGkv?=
 =?utf-8?B?S0VEcEw1NG1vUVIweHBaNkhKLy82L0N2c0Z3U28vTHVhZ24rdDhOQ3dmemw2?=
 =?utf-8?B?M05EdU9zVjh3RmNtbFIxclFkRFdJbXFwUjU3d3Qya05GUUdJZHNOTHM4eHRp?=
 =?utf-8?B?cFVFNVBZaW9IYkZ5cVhOQVJxazd3djJQTkZzMG50MkhIcWViSnZHdG9ESHVn?=
 =?utf-8?B?Y0g5Q0FmckxiQnlqaGZJTzJHTGJucS9TRzhNZDVDdm1sT3hIYVJvVUJqd0xt?=
 =?utf-8?B?dzVEZWpma05MRTBJd2dnL09GUkQyZU1HcVZLN1NSTlNXMEFxQkI1c2QyTzdY?=
 =?utf-8?B?OFN1NmVDazk1TklRSGsxWmdRLzBWcTdUdXNIM3AxaVRmL0g4dnBkczF2dEJi?=
 =?utf-8?B?VUhPRGFQVnNKOWxSS1p1UjBicjVtOU5wbWxBZWtsMURIcUgrYk9kRy9qcHlv?=
 =?utf-8?B?MFhaczBlWkduSlhlSEluMStlZ21NZWN2R0pWeVhCVjNDUnl0Z1hFQXNOK0lL?=
 =?utf-8?B?aWpuK08zNkhDSTRLbUp1T0tQMktZNkY4ckJPNytRdUlzS1plT1RFc2FqWlU0?=
 =?utf-8?B?U2xaTTNjdVBoMEFzMTVTY1BSTkJwSHF5aURGSjFWMERNenBndWtDaXE5SEFa?=
 =?utf-8?B?SDJhdmVUNElpR3RBaWtBK3BheDkyZE9PY0J4cEtLdEN4NnVlRnllb2VLMVZH?=
 =?utf-8?B?czhwbTZUQThrZTlZd3Z2QzAvYm14bDl0akhFOU1BK281MENvMDJmcmZIOWtC?=
 =?utf-8?B?clRvT2h4RjB2bmFMek5Bc21COXhSNWVMY2RtV29TdDA2VHAwVmIwclA5YkNL?=
 =?utf-8?B?S0ZFL0JucVl4dnlzRkxUWm84Y0xNZitTb2NFRXhmOVpaa1E0QlF1amUybWc5?=
 =?utf-8?B?b1lFZlNrRytsZktvSjJRNnBwQWg5ZTlXVjBuUUR2OG85WEhYN0VZSXlSZXJ3?=
 =?utf-8?Q?YqcW4azv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 09:50:03.1431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 9044164a-34e9-4e5d-6403-08d8a015a131
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPB7hAbt/oAfuYTuPwMfi1jcoUYrvEEQGfdwRIbjr5BCa5AvYMeQWuvtOXEZt5uR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2546
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

please don't apply this patch to any older kernel.

The fix was only needed for a patch which went in with the 5.10 pull 
request.

Thanks,
Christian.

Am 12.12.20 um 17:08 schrieb Sasha Levin:
> From: Christian König <christian.koenig@amd.com>
>
> [ Upstream commit aea656b0d05ec5b8ed5beb2f94c4dd42ea834e9d ]
>
> This wasn't initialized for pre NV50 hardware.
>
> Signed-off-by: Christian König <christian.koenig@amd.com>
> Reported-and-Tested-by: Mark Hounschell <markh@compro.net>
> Reviewed-by: Karol Herbst <kherbst@redhat.com>
> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpatchwork.freedesktop.org%2Fseries%2F84298%2F&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C664e6201322444b319e908d89eb83eda%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637433861463180140%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=OQ2BSmlDxz%2BPGq6aDpQBaXjQgO0wdt6y6KlCzIIFVso%3D&amp;reserved=0
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/nouveau/nouveau_bo.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
> index e427f80344c4d..fddbe66935464 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> @@ -1375,6 +1375,7 @@ nouveau_ttm_io_mem_reserve(struct ttm_bo_device *bdev, struct ttm_mem_reg *reg)
>   			nvkm_vm_map(&mem->bar_vma, mem);
>   			reg->bus.offset = mem->bar_vma.offset;
>   		}
> +		ret = 0;
>   		break;
>   	default:
>   		return -EINVAL;

