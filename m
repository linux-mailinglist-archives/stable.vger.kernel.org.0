Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219A25AC9C9
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 07:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiIEF1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 01:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbiIEF1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 01:27:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC512E9FC
        for <stable@vger.kernel.org>; Sun,  4 Sep 2022 22:27:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldP/yfffXEoQRjioe1lxWDhMX8IBZHaUhmn/nhVTRBhIlJaT65bMWr1CZm9hO38Yb0JdC6nfo1O3Tlfh6VFDvRYtgN6HYvj5DICbswiLMOZAQrk9XpkYCM4zuAA6Icpg0iyp5nG/LjRgPSIfIwmMiHf5FXC5ypcvHpwNVM7gCXR8RvocRK6W0Xy47aqilmUksiDj61tqet18O61MrvdqoP85LQbgF6n20rQUfniVzoL7zxZwE+95tdbftZQilK/lzfI4M3XgA8OE6qzOmJPiF1jppTq3YwMg1C86ppZhF9mAPTshVTeKt7J+yf3WUYkgL+sS0FLfxz4daZXIXe3+9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zhNWkf/tl8bvHNzMhM2u2WKnvnLXlPV1vp2tFrFsTmg=;
 b=YFTuyGWnQNVOEfIkrEwrvy9OFybC0U8MMoby7iLx92US2n+dmDZPqMytIlNMY7INIHFkGulqqz5jPYUYXi7IRzRhVPxoGR+XVzFlPgn6lLdTAEHVaFpO48J/0FJtXeQapKWH7tD1VE/npLxHKiZ1nD37WZwGxFYaiZmoR7N/+DzAjvZRa0Ux7x6XkY51WxQnmkdzm8eyi4XAc3TxW2x9FGwdKhI3RlNNhYo/kpJj2Hm2vdqZdUyGhljcHM4oqmVzbAAfcW2QWwXZQK9nUGwjYdu7vwPbdVlk8E83p6HuPOcGr54ZdVIo9B736sLdY75Tw94zkYM3iOwUtWZefF+fWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhNWkf/tl8bvHNzMhM2u2WKnvnLXlPV1vp2tFrFsTmg=;
 b=u02sxePn58M/PKtsPRyeeNtnx/nbVBlq+ZTx4L4Pn3OHCmyrxvSC+zrGYa8ZAzkFyh7m1PpbnGrBG1BCa7Ev0eFsRWk4hZOGHZZQx+bWfI9WxgQvQaOnsZ7MG4Y+iN+hrK/N3G0ji30QM8z25PZb+oBNz96KTCmzUVi1R9gWcEM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by CH2PR12MB4969.namprd12.prod.outlook.com (2603:10b6:610:68::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Mon, 5 Sep
 2022 05:27:41 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8%3]) with mapi id 15.20.5588.016; Mon, 5 Sep 2022
 05:27:41 +0000
Message-ID: <e90fe5d6-2b19-f253-f2d9-e538c152ec75@amd.com>
Date:   Mon, 5 Sep 2022 10:57:29 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 1/2] drm/amdgpu: Move HDP remapping earlier during init
Content-Language: en-US
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     amd-gfx@lists.freedesktop.org, Felix.Kuehling@amd.com,
        stable@vger.kernel.org, tseewald@gmail.com, helgaas@kernel.org,
        Alexander.Deucher@amd.com, sr@denx.de, Christian.Koenig@amd.com,
        Hawking.Zhang@amd.com
References: <20220829081752.1258274-1-lijo.lazar@amd.com>
 <CADnq5_O=3u1Z4kH_5A+UsynQ31Grh-=j=3+hPWo398kfMi411w@mail.gmail.com>
 <3b2a9a8f-dedf-2781-0023-d6bd64f16d65@amd.com>
 <CADnq5_P0=+NNk2v_VOxyjOVSnY55SY=OX40xD5Bx6etspREnfA@mail.gmail.com>
 <1890aec6-a92d-e9b7-a782-fd6b0e8f8595@amd.com>
 <CADnq5_Pkpe_-SH8Wh=_s6FXDFEWvO8rr5Ls2=Q4HRXy9+eSOBQ@mail.gmail.com>
 <9ef0287a-e463-d440-58fe-0323a6eca94a@amd.com>
 <CADnq5_P1VV2zWpjtsedPCoJH_CKv+d-MuVJwxOBbdpo1fLFCjA@mail.gmail.com>
 <CADnq5_O1Z0FK99cKDmRuCoxg-hbD3LtcW1q3n4zvrB9xFo0XHw@mail.gmail.com>
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
In-Reply-To: <CADnq5_O1Z0FK99cKDmRuCoxg-hbD3LtcW1q3n4zvrB9xFo0XHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0059.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::34) To BYAPR12MB4614.namprd12.prod.outlook.com
 (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d93bf352-e28e-4f6f-4f83-08da8eff5a47
X-MS-TrafficTypeDiagnostic: CH2PR12MB4969:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pi25Q5yQ01+6cUBlQ/zT7JafO8SU1Q70/M0K0DdiEIrRTfeT6j9/MXeCzxK8FUqj5e/NFXcItamyaiahh3bJp8N2FvRhvAqtwi8AegMv//qRHv7xQdUBuq2ayY2Xtdj8hZgp6VLB5jFK2HlGGaKkaKR19nQECXardTaIzhZoNnhfkV6d85Rr/Gzj0NszMDrAVmyc+GXa6gVnOcIdI1AZEdTYyWYlb4gFrRLXqbyNROZMhQrrSo4QfuU4J7nbDeCCH2QNqEsxhmW067dDAbVoJkL9tYzRl0Tv+HKG0cMXDbsx/y3AqYd070NeLSRgC0DKXlrZfKvIki4vK296H+dD9WSygwNS9bRiLwT+qVV/cVSTLGKdTy/PvAd0+I6N4EWCnH9xd8p/xx8rbcV66MmI6TnB4LP7KkXzLIZUe6N/yuDdF0OtnUvtxBaTiN2OFcVr1vbHb9W/MzDxDd2OaBKAR2rQOvV2eg3pwU09oVkKcNqXD1p08UmwrWF+V0xAQCU6jbxc4F0AW3xtwSBKFb3kpq3grdqH+DxQNs3UXX7smt2VJwY8U7d54LtYz85S0/K3cGLgACrQVKytKxYlsMgbkCbQlFferGYL5Hbv2Wt2DObQmwqtGggaa5Dj4xni3iqYHNT40T8/chip1qdTIVGqugSVN5crj173a7UIf40W5GdfmS7xfPGiAtj6RkCdntCtwVfOPa9bXzatt0+nRXxSVHvuQoAre94Z0Xwq6H2SkFRlGeMbu3GJH41AtrXPejadYmh9qxa9e5EHmu6Ux8NRkHwL0uTmxvzvOZiw+Y43oaPuk/Hh5tyeb7n8MXqJ1/YJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(31696002)(86362001)(31686004)(36756003)(6506007)(83380400001)(6666004)(6512007)(26005)(186003)(41300700001)(53546011)(2616005)(66476007)(6916009)(45080400002)(316002)(966005)(66946007)(66556008)(4326008)(478600001)(6486002)(8676002)(38100700002)(2906002)(5660300002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjVwUmw3bDd4c0tTWkNFOTk3UFNocjFJNTB1S0pHT3lka2NUNUFMcjBVVkRO?=
 =?utf-8?B?WThkcVdsN290YnllMmI0U0NhMzdNK1ZkTVMvYUxRcXU2WjlIL05KSVJlUWl0?=
 =?utf-8?B?a3ROM3NYWC8zVWZYSFRRTlZldGx2ZThEc0x4VVVSbVlPZ05pZ3BHL3luaXR5?=
 =?utf-8?B?bjk2Q3pBYmxtbUdWblJqVG9VWEEyWk5yVmFJQUpnN2pmWkJGc0tTbWlxSC85?=
 =?utf-8?B?dTZxRU94Sm9heTdLYkgvQ1p3cEMrcVdoeFBjckVEMFROOFpnMXVlL0hHNzR0?=
 =?utf-8?B?K1ZnOTZrNklKK0hGRzZvWEgrYURpL3VLM09XSmxNTlc2ZUJQRlBxaW5PNDRl?=
 =?utf-8?B?WE0zeC9oZ01sM2dtb0lXbVBWc0dKTjRUQWQ2bHZPbkUzMnNtOUhzZXZQUUVl?=
 =?utf-8?B?ZVdyUld6ci83bFdUaTYzWnppSHJtQnFpZHZWV2lpa1BJN1BidjdUT3N5SXhz?=
 =?utf-8?B?Y0dxOGdNcjhRSzByUDR4UTJxb1lRV1ZmYlk3c3BiM2NkR05Sc0RTZEMxU1Vq?=
 =?utf-8?B?eVQ3UDZlSjNWVFRjck8vcHBHRWZUZklzbnZZQzd5TDlZZmZrdFhwd2FZbkRX?=
 =?utf-8?B?a3l4eFEzUUlveit6UUFBSjl1YzJUN2hIbUJ1Tm81ZmNiNFRDK25mejg2clk0?=
 =?utf-8?B?WmJTUkVhN1RlNy9wcTlUY1dhclU3Z3Zmc2wySUN6azR1RG1ZdzBhbWJDN0RK?=
 =?utf-8?B?NEw4KzZJa2lHTEhIYXJUN2U0Q3hhWkNIRmVyVmsxbG5tc3crU2lpMVdoYnR0?=
 =?utf-8?B?Ymg4SytDSXk5eWFHWFhTNnFwRHlua1lrWUNKdDhVeEorYjU1WHI5MStTM1Iv?=
 =?utf-8?B?UkQwclJaREpRVUc3bDdrWEhueHZ4NG9OU1BjWGQrZ1ltR2Jva3JoZGorTUNl?=
 =?utf-8?B?dmRlRmt4dFhzQnFCbVhZcnFqcXBMQ0RDMUpCYzloSXp3ampGRE53bnl5REFu?=
 =?utf-8?B?SWJEMUFucEQxa0p3SlpLZ09qZFZaVHQ5T2dDMnJpdGtmR241Q0JlNi95bTR2?=
 =?utf-8?B?SE8vZDRBNUNZWTVwTFk1Rjd4dFEwc29pbDZhMTBWVkhhZVRjdjVVcFhUdGQr?=
 =?utf-8?B?UTBlZ0tKSThWMWhkZDVQMVhNOWhVd3BOUks3LzYwNG1UaVNLMnZsWnlTK3Nj?=
 =?utf-8?B?aGgzNVNwV0NBaElSNHM3Q0lRMEMzaVBPajdHN3dFU3gzRlVSYmxacm1XYzU5?=
 =?utf-8?B?UVBmRzdoNDFRei9lYlAzQVN1L294cFhtcVNPNnh3eDF6OHlSamFtakw3VEwy?=
 =?utf-8?B?Si95NkRpR1BqcmRrU3pRK0huQXptaUd5T3lNMXJScm5tWWJ5TGhGOC9SNlNa?=
 =?utf-8?B?UUxTZGlxdVVXRHNwVHRETmNvL0dkUkpFejlGOWloUXZRWnJSWmRQSHh5dlNS?=
 =?utf-8?B?VU9ucmF6cnNOdkVxYkQvb1FVNWxLR1ZnakFvWXhaajZkY3N3S2pnVkZnRm9Y?=
 =?utf-8?B?YWFsTnV3aG9CU01COEd3K1lPaU5zaldnN0lKazdjY0pIc0xCYm93aWk0V3Bk?=
 =?utf-8?B?ZkJQazl4cTV5Ymk0Wnl5cnRpODlQN2RDZTVoMzhsZWhvZ3BxTmhRYmdwSkNy?=
 =?utf-8?B?UUc0cTkrYWZEYlJYS1g0VGZkMm1jbitCL2QxMXNYOERmQzdPWVh3cEcvTkdu?=
 =?utf-8?B?L1grM1Q4b2tEQzNyd1AxNnU2bG1VN05laXUxYUpJTFNpbHdmV3QrUHNSalZG?=
 =?utf-8?B?QlZweG9meXBHTk12ekpFbXFQN0Q5TDQ0TE1aUkc0a3RsRkxvZ1I4akErUlpt?=
 =?utf-8?B?endMYm9RSll5VDdhOFp3bjlaUEtSVVBSeFFDZ0JKYjlvQ09vNFdCNEJRc3NI?=
 =?utf-8?B?SzNiVGFhSFk2L2FZeDBLaVZKVXFIdkdxNWtZcWFxaXJsWFFrUDcrbFgraUZr?=
 =?utf-8?B?SzdqYzA4L3Z5OU1RNmdqZ1gzMVdHYjY2eC9FMk1OYWQrOHhzdTMrYzNmRnM1?=
 =?utf-8?B?UTVPb3h0dDdYcU9Vak9sZm9MbDBETWRqSU5uMUhNRFZXR2oyelBMUWozL0JT?=
 =?utf-8?B?OFFPSzhOSHlhM2daVjVtZkxaZm5DUFF6Q1g0cWY2S3hnWDZjak12NDBsYk9y?=
 =?utf-8?B?aTJQRWQ0b3NobkxWRHgwMWtaSE9kNTBMTEVkdTJTNnZHWnpjcnhsY1ltVmMr?=
 =?utf-8?Q?pqeFNZecbgbqWKus/o3HE5i+j?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d93bf352-e28e-4f6f-4f83-08da8eff5a47
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 05:27:41.2523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZwrURgh+wmkTFxzze5ulfe0UYGV+ZyK5vuM7Xyb6eJpCUrSSERFnb9WTFj66G8r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4969
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/2/2022 1:09 AM, Alex Deucher wrote:
> How about this?  We should just move HDP remap to gmc hw_init since
> that is mainly what uses it anyway.
> 

Sorry, I missed to R-B the previous version. Did you find any problem 
when common block is initialized first?

I think that patch provides a consistent IP init sequence during cold 
init and resume.

Thanks,
Lijo

> Alex
> 
> On Tue, Aug 30, 2022 at 2:05 PM Alex Deucher <alexdeucher@gmail.com> wrote:
>>
>> On Tue, Aug 30, 2022 at 12:06 PM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>>>
>>>
>>>
>>> On 8/30/2022 8:39 PM, Alex Deucher wrote:
>>>> On Tue, Aug 30, 2022 at 10:45 AM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 8/30/2022 7:18 PM, Alex Deucher wrote:
>>>>>> On Tue, Aug 30, 2022 at 12:05 AM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 8/29/2022 10:20 PM, Alex Deucher wrote:
>>>>>>>> On Mon, Aug 29, 2022 at 4:18 AM Lijo Lazar <lijo.lazar@amd.com> wrote:
>>>>>>>>>
>>>>>>>>> HDP flush is used early in the init sequence as part of memory controller
>>>>>>>>> block initialization. Hence remapping of HDP registers needed for flush
>>>>>>>>> needs to happen earlier.
>>>>>>>>>
>>>>>>>>> This also fixes the Unsupported Request error reported through AER during
>>>>>>>>> driver load. The error happens as a write happens to the remap offset
>>>>>>>>> before real remapping is done.
>>>>>>>>>
>>>>>>>>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D216373&amp;data=05%7C01%7Clijo.lazar%40amd.com%7C4e59ae0f8ed54aa7c5a208da8c51aa29%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637976579623485975%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=WTcd9ImY7Oba0MT6oQ7%2B7UEBkdS6azvqgYoK%2B%2F4mJPg%3D&amp;reserved=0
>>>>>>>>>
>>>>>>>>> The error was unnoticed before and got visible because of the commit
>>>>>>>>> referenced below. This doesn't fix anything in the commit below, rather
>>>>>>>>> fixes the issue in amdgpu exposed by the commit. The reference is only
>>>>>>>>> to associate this commit with below one so that both go together.
>>>>>>>>>
>>>>>>>>> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
>>>>>>>>>
>>>>>>>>> Reported-by: Tom Seewald <tseewald@gmail.com>
>>>>>>>>> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
>>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>>
>>>>>>>> How about something like the attached patch rather than these two
>>>>>>>> patches?  It's a bit bigger but seems cleaner and more defensive in my
>>>>>>>> opinion.
>>>>>>>>
>>>>>>>
>>>>>>> Whenever device goes to suspend/reset and then comes back, remap offset
>>>>>>> has to be set back to 0 to make sure it doesn't use the wrong offset
>>>>>>> when the register assumes default values again.
>>>>>>>
>>>>>>> To avoid the if-check in hdp_flush (which is more frequent), another way
>>>>>>> is to initialize the remap offset to default offset during early init
>>>>>>> and hw fini/suspend sequences. It won't be obvious (even with this
>>>>>>> patch) as to when remap offset vs default offset is used though.
>>>>>>
>>>>>> On resume, the common IP is resumed first so it will always be set.
>>>>>> The only case that is a problem is init because we init GMC out of
>>>>>> order.  We could init common before GMC in amdgpu_device_ip_init().  I
>>>>>> think that should be fine, but I wasn't sure if there might be some
>>>>>> fallout from that on certain cards.
>>>>>>
>>>>>
>>>>> There are other places where an IP order is forced like in
>>>>> amdgpu_device_ip_reinit_early_sriov(). This also may not affect this
>>>>> case as remapping is not done for VF.
>>>>>
>>>>> Agree that a better way is to have the common IP to be inited first.
>>>>
>>>> How about these patches?
>>>>
>>>
>>> Looks good to me. BTW, is nbio 7.7 for an APU (in which case hdp flush
>>> is not expected to be used)?
>>
>> It would be used in some cases, e.g., GPU VM passthrough where we use
>> the BAR rather than the carve out.
>>
>> Alex
>>
>>
>>>
>>> Thanks,
>>> Lijo
>>>
>>>> Alex
>>>>
>>>>
>>>>>
>>>>> Thanks,
>>>>> Lijo
>>>>>
>>>>>> Alex
>>>>>>
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Lijo
>>>>>>>
>>>>>>>> Alex
>>>>>>>>
>>>>>>>>> ---
>>>>>>>>> v2:
>>>>>>>>>             Take care of IP resume cases (Alex Deucher)
>>>>>>>>>             Add NULL check to nbio.funcs to cover older (GFXv8) ASICs (Felix Kuehling)
>>>>>>>>>             Add more details in commit message and associate with AER patch (Bjorn
>>>>>>>>> Helgaas)
>>>>>>>>>
>>>>>>>>>      drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 24 ++++++++++++++++++++++
>>>>>>>>>      drivers/gpu/drm/amd/amdgpu/nv.c            |  6 ------
>>>>>>>>>      drivers/gpu/drm/amd/amdgpu/soc15.c         |  6 ------
>>>>>>>>>      drivers/gpu/drm/amd/amdgpu/soc21.c         |  6 ------
>>>>>>>>>      4 files changed, 24 insertions(+), 18 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>>>>>>> index ce7d117efdb5..e420118769a5 100644
>>>>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>>>>>>> @@ -2334,6 +2334,26 @@ static int amdgpu_device_init_schedulers(struct amdgpu_device *adev)
>>>>>>>>>             return 0;
>>>>>>>>>      }
>>>>>>>>>
>>>>>>>>> +/**
>>>>>>>>> + * amdgpu_device_prepare_ip - prepare IPs for hardware initialization
>>>>>>>>> + *
>>>>>>>>> + * @adev: amdgpu_device pointer
>>>>>>>>> + *
>>>>>>>>> + * Any common hardware initialization sequence that needs to be done before
>>>>>>>>> + * hw init of individual IPs is performed here. This is different from the
>>>>>>>>> + * 'common block' which initializes a set of IPs.
>>>>>>>>> + */
>>>>>>>>> +static void amdgpu_device_prepare_ip(struct amdgpu_device *adev)
>>>>>>>>> +{
>>>>>>>>> +       /* Remap HDP registers to a hole in mmio space, for the purpose
>>>>>>>>> +        * of exposing those registers to process space. This needs to be
>>>>>>>>> +        * done before hw init of ip blocks to take care of HDP flush
>>>>>>>>> +        * operations through registers during hw_init.
>>>>>>>>> +        */
>>>>>>>>> +       if (adev->nbio.funcs && adev->nbio.funcs->remap_hdp_registers &&
>>>>>>>>> +           !amdgpu_sriov_vf(adev))
>>>>>>>>> +               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>>>>>> +}
>>>>>>>>>
>>>>>>>>>      /**
>>>>>>>>>       * amdgpu_device_ip_init - run init for hardware IPs
>>>>>>>>> @@ -2376,6 +2396,8 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
>>>>>>>>>                                     DRM_ERROR("amdgpu_vram_scratch_init failed %d\n", r);
>>>>>>>>>                                     goto init_failed;
>>>>>>>>>                             }
>>>>>>>>> +
>>>>>>>>> +                       amdgpu_device_prepare_ip(adev);
>>>>>>>>>                             r = adev->ip_blocks[i].version->funcs->hw_init((void *)adev);
>>>>>>>>>                             if (r) {
>>>>>>>>>                                     DRM_ERROR("hw_init %d failed %d\n", i, r);
>>>>>>>>> @@ -3058,6 +3080,7 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
>>>>>>>>>                     AMD_IP_BLOCK_TYPE_IH,
>>>>>>>>>             };
>>>>>>>>>
>>>>>>>>> +       amdgpu_device_prepare_ip(adev);
>>>>>>>>>             for (i = 0; i < adev->num_ip_blocks; i++) {
>>>>>>>>>                     int j;
>>>>>>>>>                     struct amdgpu_ip_block *block;
>>>>>>>>> @@ -3139,6 +3162,7 @@ static int amdgpu_device_ip_resume_phase1(struct amdgpu_device *adev)
>>>>>>>>>      {
>>>>>>>>>             int i, r;
>>>>>>>>>
>>>>>>>>> +       amdgpu_device_prepare_ip(adev);
>>>>>>>>>             for (i = 0; i < adev->num_ip_blocks; i++) {
>>>>>>>>>                     if (!adev->ip_blocks[i].status.valid || adev->ip_blocks[i].status.hw)
>>>>>>>>>                             continue;
>>>>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
>>>>>>>>> index b3fba8dea63c..3ac7fef74277 100644
>>>>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/nv.c
>>>>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/nv.c
>>>>>>>>> @@ -1032,12 +1032,6 @@ static int nv_common_hw_init(void *handle)
>>>>>>>>>             nv_program_aspm(adev);
>>>>>>>>>             /* setup nbio registers */
>>>>>>>>>             adev->nbio.funcs->init_registers(adev);
>>>>>>>>> -       /* remap HDP registers to a hole in mmio space,
>>>>>>>>> -        * for the purpose of expose those registers
>>>>>>>>> -        * to process space
>>>>>>>>> -        */
>>>>>>>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
>>>>>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>>>>>>             /* enable the doorbell aperture */
>>>>>>>>>             nv_enable_doorbell_aperture(adev, true);
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
>>>>>>>>> index fde6154f2009..a0481e37d7cf 100644
>>>>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
>>>>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
>>>>>>>>> @@ -1240,12 +1240,6 @@ static int soc15_common_hw_init(void *handle)
>>>>>>>>>             soc15_program_aspm(adev);
>>>>>>>>>             /* setup nbio registers */
>>>>>>>>>             adev->nbio.funcs->init_registers(adev);
>>>>>>>>> -       /* remap HDP registers to a hole in mmio space,
>>>>>>>>> -        * for the purpose of expose those registers
>>>>>>>>> -        * to process space
>>>>>>>>> -        */
>>>>>>>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
>>>>>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>>>>>>
>>>>>>>>>             /* enable the doorbell aperture */
>>>>>>>>>             soc15_enable_doorbell_aperture(adev, true);
>>>>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
>>>>>>>>> index 55284b24f113..16b447055102 100644
>>>>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/soc21.c
>>>>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
>>>>>>>>> @@ -660,12 +660,6 @@ static int soc21_common_hw_init(void *handle)
>>>>>>>>>             soc21_program_aspm(adev);
>>>>>>>>>             /* setup nbio registers */
>>>>>>>>>             adev->nbio.funcs->init_registers(adev);
>>>>>>>>> -       /* remap HDP registers to a hole in mmio space,
>>>>>>>>> -        * for the purpose of expose those registers
>>>>>>>>> -        * to process space
>>>>>>>>> -        */
>>>>>>>>> -       if (adev->nbio.funcs->remap_hdp_registers)
>>>>>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>>>>>>             /* enable the doorbell aperture */
>>>>>>>>>             soc21_enable_doorbell_aperture(adev, true);
>>>>>>>>>
>>>>>>>>> --
>>>>>>>>> 2.25.1
>>>>>>>>>
