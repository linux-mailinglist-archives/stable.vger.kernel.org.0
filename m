Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E965675C1E
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 18:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjATRvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 12:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjATRvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 12:51:22 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0561DCD213
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 09:51:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ch4Gicf47Zjey1AyfYJfq+HCrM1+LcKqvLNn/7bdyfjz0donaU/DzES+uoRa2c5a0X+Js8eqadxKrrALi3WHnx/J6jNKILQgUWPxXNlHtCn8r+8dSiJk272n426zTPjuaM8iGAo5P/fNSyZ8EwvXGiS3sPVUcNkhxJ06RQeJmulC+RvTApJ6dIdA4nRu67aqtv8sV2cKhU9GGvMAfe5oKY6cRnR9vwBI/NnhKkqfzqCv7YBUrK8yyg2E3r4X2Ly9nTqi6ignEjUrI5LhAcItvadxH3L08TR4Yfw4o3GaSWQt0ho7JY7eYTzIQLHoKUW99IB90yxgSx9DgHFwCEgGvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9XRDAFniXPzzbsLai/Om+1O5xzoUKVzTPi7zqmoE/c=;
 b=bsrTGXldg+Bf21mmHu6tluCdvVJtnA89+rncxWy94l2Sg77LXUg8RYw+W6hfkyVBvpoVJxbC2X2h0kE2Ukcv+1xpjhMuNr5naT2VhH+gn6kh1qymuKruidcFVDDh/xs3/9B3r374wHUbRxuXEhaYtNPG0Rem+8E5IAQuExbQ/LGiJRk+E8tpxPSXPSfEWPgyu+uVYkEp+cP3Kto1R9kzAmUtWOlqtWLcilpqVrfmVLKk8/Pg2AsItqT6loR8T0slNk/m0E5vzcctfigFp4Rv5y/CJaU6oFtY9ckKKiKar++241CrLjjCdz+C1vITSUl5K/r0t7jJW4ONpk5dO5ebsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9XRDAFniXPzzbsLai/Om+1O5xzoUKVzTPi7zqmoE/c=;
 b=lV2qkc6HFHDN0bXMLcYKGvVeN20S35+V2syep2gU9iJE3U32zqn/Okl1OFgD9gaT5KvjQtTtnuZnRjjZ2SwP8jazKXbeZsYw90A9rIfxSiQPvZXIji3UC1A18CfX6BCIkd5oKazIrirmptqaGq94el9AKJXKtyxSiQMgjjDKIVo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by IA1PR12MB8078.namprd12.prod.outlook.com (2603:10b6:208:3f1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 17:51:07 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%5]) with mapi id 15.20.6002.025; Fri, 20 Jan 2023
 17:51:07 +0000
Message-ID: <a9deecb3-5955-ee4e-c76f-2654ee9f1a92@amd.com>
Date:   Fri, 20 Jan 2023 11:51:04 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] Revert "drm/display/dp_mst: Move all payload info into
 the atomic state"
Content-Language: en-US
To:     Guenter Roeck <linux@roeck-us.net>, Wayne Lin <Wayne.Lin@amd.com>
Cc:     dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        stable@vger.kernel.org, stanislav.lisovskiy@intel.com,
        Fangzhi Zuo <Jerry.Zuo@amd.com>, bskeggs@redhat.com
References: <20230112085044.1706379-1-Wayne.Lin@amd.com>
 <20230120174634.GA889896@roeck-us.net>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <20230120174634.GA889896@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0043.namprd20.prod.outlook.com
 (2603:10b6:208:235::12) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|IA1PR12MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: e4972827-d2c2-4d75-0208-08dafb0ee81c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GE7rbTowvavYdq3z86sl0QnY0bXetF5kD1dNGgtdTk4Mf1P6tE8knSfP1CWDiZBfs8g/nhv9FBIflKB1+/miANy8MZsINA53NPv1QDPvXXMPe5bxf7NCuvMSXoGOKxgixTflSL3OxS8WVjU0ul/KKL7RY2pQBr0cfc2fehnQFUnkklIWh2lc7pG7Mm0lT9rUVz/WFQavdWQLRUBtJhVvaFtxnys8crad4gyxtwozG5PwX90o5hHSMhKkBNihwY4rFZBNEK6vcIxVRq5bOVjBtatkLwvhdtL/deEY+8SKdfor7vrMPVVOgqIasD+5EO30ac+sFKmXGNuJUteDfDK4+lfoeut8BPUJWImCKSkFp04nlkOGRFP5NKUVGdAjj56iq+qsZVepobBBefD3f9xs+iM1ZnLA3kibgjMU4b0jf0yldUolfDqRVmTZXqjhzurQ5dRPo61T342hpInPZuyOoeno3VFZZcXNxGSKA1cJmgO8t2K5KZ6aRNOd62t3A1A/ozK6p9SeRxisnKpZRyzb+meX2TeOfWjspE0AEK9WE3YJS+Qb2rVHlI6Aok9sPIeJCxSG+O/HXDlpall1p5+fY4Yerq/OUFvB7ZNjnc3b1V/w0ssbhPPULDMf3AAe5Leu2UW2P15PkfTrLYAek74FKhhBCittzDALPz3CXu25ujGHOveuQZ9jioSd0+runctp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199015)(186003)(2906002)(26005)(6506007)(6512007)(110136005)(6636002)(2616005)(53546011)(316002)(966005)(6486002)(478600001)(36756003)(6666004)(38100700002)(31696002)(86362001)(83380400001)(41300700001)(4326008)(5660300002)(8936002)(31686004)(66946007)(66476007)(66556008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajhweG5Sc0dnTjg5S0c0TTdxV1NiZFREUWdLbTNlMGNUM2IrdFBFd0hOVnlO?=
 =?utf-8?B?ZWlsV0ZRNFdueFdaNmlLZGpidDNlbVl2cEVHd0tacUhZcTdUNkt1RkVWOVM4?=
 =?utf-8?B?TktuSmdrc1dRN3A3NjhqWENTZkZ0cHZpbkVRcDVhVUJtNEVEU3ZvYlQvVkta?=
 =?utf-8?B?ak1taklVWnczbUNSM0ZxSXFzTlh1bnRZTWw3Nk5ZQUsrdVovR05CUHNITExM?=
 =?utf-8?B?VXkzTkkrOTA0anVEaGhubWZhVm1kWEFqYmljOWxWbUZiejBoaE96OGJQSWdI?=
 =?utf-8?B?NTBnWEIxTm51TXB0bVZia2FtREgwM2tEL3ExcXMwV3VhZjhJWlNzMm4yTGE3?=
 =?utf-8?B?R3FsSjJQYkhJeGZDTk9YdHR4Zk1ha0JTRUJiM1RINVZ5TjBmMU1XNVRSSmo2?=
 =?utf-8?B?SUNXbTZjRFVIUExiYkFxU1lYMVNYcnNkSWlMQWtybE1MeTlwQkNlMGtLd1N5?=
 =?utf-8?B?cjlsN0xwellsaDhHTHZyeWpYbGswWXgzZ1E2YTRXTlNqeXRNSGEwc3BNWE93?=
 =?utf-8?B?S2tPQ2ptcytBSmdmM01tbWkwakNqZlh3bjU3YlRaZ1U3Sk9NMUVVNWlEZSsx?=
 =?utf-8?B?MWNNalBlK256SEg5M2hmTFZldWFsbkRXSTN4c0NPMGJDVU5uZHdEUmFieE84?=
 =?utf-8?B?NU1vZ2NlSDV4NnM4MTBab3JZaVFVK08vYVY1RHI4d3AyK2tiOVNNbVVXMVVy?=
 =?utf-8?B?S2YzSEJ2aHM4YlZsZ0ZBNEZVd1hzNWNOSWs3UDR3OTNlRnBQWXBPRi9md1RF?=
 =?utf-8?B?dGF3d1JEeWszLzU2WkZrdmpPejJRUGordXVxVjBVMXhSdHgwU052OHhwWUVl?=
 =?utf-8?B?SEVZcmJJalFVYW91WG85TTB5eVFaLzU0d3phMzExWHk4R3FlVGNUejQraCt3?=
 =?utf-8?B?eDFuVFJOQnVPMGFLWXpvaElsTWtPeHdUQ1NXT0Q2bFdPV0ZNTjliTmFuS2RZ?=
 =?utf-8?B?b0w3UkwyTGRFS1BMdWc0dW45eVprVXpFcEtmNHVCUjZIaXJqVzc4a0MyWXVz?=
 =?utf-8?B?OVNjTFZYQ2x2MEdOL2NSKzRwbHNyOStmZ2FTUjFna1VsRTdNaHhXWXlxRjJG?=
 =?utf-8?B?dEM5NWhPLzFUUlIzQWhiU29kVjdybnAyWkZ4T2lwMGFyYVJNMUVnRTBTc1Fm?=
 =?utf-8?B?aFhFT1o3WENCMXllNENGWnc5WlpXSGxZZ1FYaEdwWTNwZTNVSWZ0U1pPNG0r?=
 =?utf-8?B?VVJDUUtlanc5Ujk3OWY0emkrK3U4WlNrUm5WZ0tOUDVPRW1aSnNmbWFXcU9N?=
 =?utf-8?B?T2pQTkNZZ0xQM2Z1UG1wYWVnbkxCZGR0SWdCWmJNZTNuU2FjMkVWL0l3QzJS?=
 =?utf-8?B?c0JIdkVqMThoUWxtOEpaK2FpYm1OUWovenBCcWhJektSYVkyNm5VVUVwR0Zh?=
 =?utf-8?B?U3NoNmdWWDBFSlpRTk90ZHdZczUxZVo2MVZvcTc2WjRuK1RLdWo4aXk3dzBU?=
 =?utf-8?B?N0xvNS9MOEFBWjV4dHE0R092QkRKbnRIQjlJUnl0UkFkQ3RYYzZFMDBob0hy?=
 =?utf-8?B?UHJrcW1wd3hiSythSTkxQUVTclJ0bFNkYzlxYmhQekxCcmM0d0xpVVFaNnpn?=
 =?utf-8?B?UlBlanNoMXA1UStVUUpjeFJEYkdkWHZXZ29va3BGUDkyellkQUVUQlNlcEhO?=
 =?utf-8?B?czRveGZnS1MxQWVUM3BSKzVoSGk1S1pKUjBEZ3lhZkFERFV4K1pVVmdFVzEv?=
 =?utf-8?B?Q0UzRlYrMnJqSWxhdHl6c1QvL0dxTW5XMy8wSXV4bnVMaHZWS1ZRaS9KajN0?=
 =?utf-8?B?SWxBSU9kTUk4Vk1BaUh1T05SUmh5REhOY3owaTlyWXhKZk9WYlU3ajR6YjJm?=
 =?utf-8?B?TXJVV1RtMy9iVTlPUGMzdHRaR25sOVVydnJyR29uOE10aW9LV1VYRU45UVpF?=
 =?utf-8?B?bVQzSTQzaW03QVU0RHc0bzM5VUpRdnl4TTFJZFFucklVZllhWWYrT3ZxeFNp?=
 =?utf-8?B?NHNvNW5vSWRzNUtISEhEaHd0MFF3MmkzSnpuWWt5Tnp0VzdCa2RXbTg0Mm1L?=
 =?utf-8?B?OXR1U2pjUEZKdk5wVDlqbXJaaS9aQUVTTitpNVpYcFZoMUJ0Rno4YnVUWkNy?=
 =?utf-8?B?TmthT0d1WFZoQklWcTFCN1FLOS9wWnVQMjR0L01ycGdCNldmbFF5TzE3YytX?=
 =?utf-8?Q?C3AzTiP3m6GdKr0JFk1VQNzhi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4972827-d2c2-4d75-0208-08dafb0ee81c
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 17:51:07.0015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0KifPQIsx+qh5dR7pgOohRAUJBv6BMU6dhQjdwO18j7tj0Dz71GWx4gZqhKRMfERdN7Ovcq1g9q1o5C1lTJ/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8078
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/20/2023 11:46, Guenter Roeck wrote:
> On Thu, Jan 12, 2023 at 04:50:44PM +0800, Wayne Lin wrote:
>> This reverts commit 4d07b0bc403403438d9cf88450506240c5faf92f.
>>
>> [Why]
>> Changes cause regression on amdgpu mst.
>> E.g.
>> In fill_dc_mst_payload_table_from_drm(), amdgpu expects to add/remove payload
>> one by one and call fill_dc_mst_payload_table_from_drm() to update the HW
>> maintained payload table. But previous change tries to go through all the
>> payloads in mst_state and update amdpug hw maintained table in once everytime
>> driver only tries to add/remove a specific payload stream only. The newly
>> design idea conflicts with the implementation in amdgpu nowadays.
>>
>> [How]
>> Revert this patch first. After addressing all regression problems caused by
>> this previous patch, will add it back and adjust it.
> 
> Has there been any progress on this revert, or on fixing the underlying
> problem ?
> 
> Thanks,
> Guenter

Hi Guenter,

Wayne is OOO for CNY, but let me update you.

Harry has sent out this series which is a collection of proper fixes.
https://patchwork.freedesktop.org/series/113125/

Once that's reviewed and accepted, 4 of them are applicable for 6.1.

Thanks,
