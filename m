Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B3B6DCE8D
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 02:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjDKAsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 20:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDKAsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 20:48:03 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2074.outbound.protection.outlook.com [40.107.101.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749CB11C
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 17:48:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dc0ekEnTF0QWcg0nwDY0Kn/VaRD8M0aEXNhWEqg4N0rGdjg4yWqz2JKatfE6Tcn/cx3qg1tRUX8IXhPvA9i0WNaMwgYmed0ib095teSLwkhftw9hcY7rHjb4++tJ8s7xVaUmXAhRn4e6cAHcpd5EBre7Qgqqr7NnBEdDmY8byJ0C2Gh57BdzMdaeiXQnmJAo17AQjjw4DW0QPe1/5z0x5l14AIzQIDWXBndEcdrJN3ZbnlaBuFeZSe5Xc9yVkAa8LYArsYiUuRj2XKkdagjjOihhXyp0ioZUcu1zwMjvuvNhkat5gABPbLfj3KhZ5W8y8HmeXqmCLfSofAGws/BeoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sfCTkBKhzkr6MurmDPDKPUECxuGEWZf3TeyEo49uG4s=;
 b=nSA0sq/8I/FwvXx5mjk/jYF6vz9Qy1CgEHptpkLMSDtJVzIhn5pToHI5aRb1JzqVtLgbTjRSYTunuPBVOQ470X5QWEt5Pbk/1tqabz+l9+jN5JTGfiaLwox8k/hb8QmRakHvMCq8OStEJ0gX8m/iVmMI/0lu/YUT2RF+wA2quBQJQtt/LuiGlkbik+tdyutq6yWOIfJEfd6KwPy+Gou1NQjZOnJCfYXdlkKMZuDDPqxRxxHdStp08Nz2GTGufMSBbjdoySgbXvrxuW1aDIkePlMuHckIoqTch7uCeNphHhaolSQR24aoHF56Q8YrgxSBdUn1d693zNh5vpPljy/IOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfCTkBKhzkr6MurmDPDKPUECxuGEWZf3TeyEo49uG4s=;
 b=if6mySY+ghqRZIR/RLtFjlwTEMnB6KUP/K3FUyxxBWja/C838CPvRPBm/fpldvx2TRbsjT5P0UancLUw7CxcjWAQolGsDB3fYm4PQUtjaMSULX09CDYeiQ/xfYzB7V1kj8pW0YsmCLUE5jI71jn8YUbEgIyX0s0XseaKnhnH9s0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DS7PR12MB8417.namprd12.prod.outlook.com (2603:10b6:8:e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 00:47:59 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe%2]) with mapi id 15.20.6277.036; Tue, 11 Apr 2023
 00:47:58 +0000
Message-ID: <fec3d50f-8d4e-6828-b480-e9ff2531faaa@amd.com>
Date:   Mon, 10 Apr 2023 19:47:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Regression in 6.2.10 monitors connected via MST hub stay black
To:     Veronika Schwan <veronika@pisquaredover6.de>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <8e90142e-cdc3-a4a0-754a-4c7a2388940b@pisquaredover6.de>
 <MN0PR12MB61014AE52F7F84A86F909717E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
 <MN0PR12MB61011B4C8FF79D3035963095E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
 <5d0f31da-add5-b0b4-2a91-57859529dd88@pisquaredover6.de>
Content-Language: en-US
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <5d0f31da-add5-b0b4-2a91-57859529dd88@pisquaredover6.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN0PR03CA0037.namprd03.prod.outlook.com
 (2603:10b6:408:e7::12) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|DS7PR12MB8417:EE_
X-MS-Office365-Filtering-Correlation-Id: e5b5e2d8-17e8-4dd3-3ab1-08db3a266512
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+3ca4rpZD8w75GA4Br29CtjsEujx88qMBRbNYyyk4BMFqnWIKcJEqkqbcseJy4VcdHdzAb/NZ0sMMQtTK5VS35n+5RMY9/eHAdpAklrTrSqQ651NWVO4vN7/XGrAExKzc2nETWkRWkGOEV6rF0VJqNYuBAQ+OvwlZPfnukgsI/HUmGMhpL424BHIAnmtuPNCcQ52P0kdtn0xB8K+D2OuQyjPMu1dcpSCeCXeJmpW2HDLhjLYiGe6DVikU1vhQekcI5W6pt/acUxSg19d3QLrBGeLJJ0FewLIO/PLdMkD+G0P4Vjqdg4tp7fhUxg5b4x1xuNRr3T83QOF+2+Xw0ji4caSjs0CtyIFhT2KkzIeXv1MMtDs4y1dfA2iAW8AAIiPwOQgh8Cv+FFUr8pgtflVTUR1P0UboFVmCm/qRk7m6tT2/tLECZND6vXFQZ7kEnTTHYcYxN5xZSiE9BCgc0Di0AO/G5FG7tJny/sq9rFjLkbCYu9xAFCxvfG8Po9exetroxYS2duj/5M+afdGGq8ueBqc+FcDYqVGY2SBj01RowShTxidsZU4Pq36QsmE2suzolJzFuHLcOkO1VISfUZ6NkjFIGHEBIP1+cYTGPBeG4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199021)(31686004)(6486002)(966005)(66556008)(478600001)(4326008)(6636002)(8676002)(66946007)(66476007)(316002)(41300700001)(110136005)(86362001)(31696002)(36756003)(83380400001)(2616005)(6512007)(6506007)(53546011)(2906002)(8936002)(44832011)(5660300002)(38100700002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHpLb3J1S1FxQXMzdEFmeGFJQ2orZGFZMkM0WE5RTDBXQ2tOZ0VRSU9YWUZj?=
 =?utf-8?B?d0d1NUZHNlFqbGltNllBdE91WTc0ZktvQUY1OUhIOVVHVmYvVE5EVm92d3lX?=
 =?utf-8?B?VUhPV1RxMTB4Qzl2TkV2N0VEUWVhZ0l3bkZvMUlTb1RSWGtmZzZVV20vYXZ1?=
 =?utf-8?B?d2ZSNzRsS1pDWjhscUE3cWxYbW44QUUzV0VobitSSThqNDdkTzRYeFRXYW53?=
 =?utf-8?B?VUdraVUwODZ6TGdZUzNsbnRsMklBME0rNS9iZkR3Vk9XVXFvaEIwLzdJcExy?=
 =?utf-8?B?cGU4L2hvWDBaRUc5K0hBY0xqQUdNZUlXdmxlT1NndXdQTC9zb0tCZCtNVkJZ?=
 =?utf-8?B?RU9pSnVsTy9GcFV6NERWSE16S29tWlVneVNkS2lZQVVxNXp1OUtYNXBOZmFF?=
 =?utf-8?B?WklGRTM2Q1RkcXl0aHZkUUo3c1RRZngrNTNVUVpiYTJYM251cjhaeUNvNkhl?=
 =?utf-8?B?NTdvcWFSakpBZ2d1WjNwZE9Rd0xVK3NJYkJUbEs0ZHlLMklISWlNVkowNWZp?=
 =?utf-8?B?MlFvY3d0bHBkcUJUazZNQUNwdmQrZmlPbWg4NytoTS9XSGpkb1dobUxJUUpC?=
 =?utf-8?B?d3QwK1ZYNGxqYjAvWElQVlJjRERwREJlbko3aFBoQ2hJdk1Td1JKcEdJQTBK?=
 =?utf-8?B?ZGh1WDFMbmJYeDhNbm5KeXBmb3ZwdEZmVjNMZzdiM3RpMk5uWXdyN2drZUgv?=
 =?utf-8?B?aFBzRGhQaDFkLzNxT0J2VTBxRWNoaU4yNXZ0SU5CMnJQdnJXRDBlNGdDV1A3?=
 =?utf-8?B?d05PbHZ5WUs4ZGhkL2FOVHczV20wTVNjRml4OVBtd0Zha1FqL2F3a2lacDlt?=
 =?utf-8?B?MkN0MDJMMGpVbm9IT0RRT3BSNFBEK2JMdnFtWDFCc3paZjJYTUhmaDMySTJa?=
 =?utf-8?B?UlhZdFBROTNRNStCQXJtUWJTbm10bjNCOXA1cklhR2lzbyt2dGx0bTgza0sz?=
 =?utf-8?B?c3dneHBtRlpmaE9UeWV2cnM0UmtjR2dkWVFPdEpDRWdaOTRUR01xdDN3YnhX?=
 =?utf-8?B?YzkxU1pWRFFXbkgxN0F3ZEV4Um1GNnRLVDBuQXdiTTYrbjF2YTJ6Y0N1SGor?=
 =?utf-8?B?VlVZVVhxd0RaUEVIZ3UxamtsV0NUbGFINHZJcGJhL00yb3NjU3RmeWlJZlll?=
 =?utf-8?B?ZkpFWkRXNE5SYWRXanBCaTZuRko0aW16Uk1rcE5sSkowTkxEaUtxV1Q2UlJ0?=
 =?utf-8?B?WEtZQ3QrUllGVHJxekgzcjlHNnVjSGNSNVprN24vUW9KaElLVm0vQ1ZwckJT?=
 =?utf-8?B?eWpkTVg1bGJvNlFhVkdQem9IOVd6YkpxNVJmUFpjeVhUZmMyNDJZQzlTRVpB?=
 =?utf-8?B?Q1VLYUdPNkl6NDdTVkhnQnlUbmV2eXpHV3dsTWVKTm5OUisxQVFEdjJDTSsw?=
 =?utf-8?B?MlpPSkx6THdKbVdNQmdramdTVHdwbGNaRjVGTE1MQlU0VkJ5NVpsMzJIeUxL?=
 =?utf-8?B?RzBnQVB2RFpPamovcnAxRmswaW95c1k1aDZIQTFKRmFOeDRNWHozcXM2aHV5?=
 =?utf-8?B?N01GNTBEY3VNODVVOHVPMXNPYkF6Q2t1a0VNNXhwT1E2Z2UzaVUxVittQitY?=
 =?utf-8?B?NmN5LzVNZTR1Y2RMYk1kbUMvaGRpZWZTZmhZTWZoS1QvNXlCb1oyS3ZnQS9q?=
 =?utf-8?B?bkQvbUwxK3JLdmxDQUxOblFXM2tuU2YybWpUV2NCUkdlZ3RRVHBOUWJVYkRU?=
 =?utf-8?B?ZUVSc1dqN2ZhdG1LcFllbU1ncDI2Qk5rTm9uNGlMZTJCeEw1cS95SmtqN0wx?=
 =?utf-8?B?ME5oQlY3S1MzTVpSVVdHc0E5WUZpQjBUTW1oakFIZ2Vsc0NqN0pqZnRSSGhP?=
 =?utf-8?B?K1RIRStscEFpWXJxVXRkRHNneGU4S1MwTEhXcWl3U0ZueC9NbUM5dVVQekdl?=
 =?utf-8?B?Vm9EMG03amhFRDZCVlYyalM1Zm5WdkxaZWVGRDZscEk5NkQzQllEcXVTblcy?=
 =?utf-8?B?ZFZlbVN6WDJRMEtKUUxnN2svUWc2OTRtUDhzb2dDNTNhZll2Q3BsQmoxSVZH?=
 =?utf-8?B?TUpRLzdDNzFrUDNnWEhnMVFicVRoOUtCeU9EOTVTWitKUkFxOEpvaVEvRlJ5?=
 =?utf-8?B?MERGQjBVT0Q4KzhnZjdwMFIvd0JickdRZTgrZHhNd09DRjRiTUszMENTZEFR?=
 =?utf-8?B?Y3JwS3B4S2N1OG1SbmRUVWFOeUpvTXN0c0xMVWY0TjJTQmVjYVNNbXhuRjY1?=
 =?utf-8?Q?jHUHBY5Vx6PdpPvoDgOzWgHP4Q1MZETvJPKzzkPcFPlV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b5e2d8-17e8-4dd3-3ab1-08db3a266512
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 00:47:58.3389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OVpJHGdcjeBWk3tpU01QHTyLR8RU0j4IK9ej1nFg2WsZcM+3Tfncw9JTAyFpKi8+cMJe6eLNxUhXCrti3g2IAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8417
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

That's great, thanks!  So we do have a path to getting this fixed 
without a revert then, it just might be a few steps.

Can you try to apply that directly to 6.2.y as well to see if it helps 
there too?

On 4/10/23 16:35, Veronika Schwan wrote:
> Hi,
>
> 6.3-rc6 alone fails the same way.
> When the commit is added, it works.
>
> On 10/04/2023 21.22, Limonciello, Mario wrote:
>> [Public]
>>
>> And if 6.3-rc6 fails the same way, please one more check with 6.3-rc6 
>> + this commit:
>> https://gitlab.freedesktop.org/agd5f/linux/-/commit/c7c4fe5d0b0a
>>
>>> Hi,
>>>
>>> Can you by chance cross reference 6.3-rc6?
>>> It's quite possible we're missing some other commits to backport at 
>>> the same
>>> time.
>>>
>>> Thanks,
>>>
>>>> -----Original Message-----
>>>> From: Veronika Schwan <veronika@pisquaredover6.de>
>>>> Sent: Monday, April 10, 2023 14:15
>>>> To: Zuo, Jerry <Jerry.Zuo@amd.com>
>>>> Cc: stable@vger.kernel.org; Limonciello, Mario
>>>> <Mario.Limonciello@amd.com>
>>>> Subject: Regression in 6.2.10 monitors connected via MST hub stay 
>>>> black
>>>>
>>>> I found a regression while updating from 6.2.9 to 6.2.10 (Arch Linux).
>>>> After upgrading to 6.2.10, my external monitors stopped working (no
>>>> input) when starting my display manager.
>>>> My hardware:
>>>> Lenovo T14s AMD gen 1
>>>> Lenovo USB-C Dock Gen 2 40AS (firmware up to date: 13.24)
>>>> 2 monitors connected via dock and thus via an MST hub
>>>>
>>>> Reverting commit d7b5638bd3374a47f0b038449118b12d8d6e391c fixes the
>>>> issue.
>>>>
>>>> Best regards,
>>>> Veronika
