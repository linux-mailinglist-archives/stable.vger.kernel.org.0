Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A8A56FF4A
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiGKKmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiGKKme (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:42:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4793121F;
        Mon, 11 Jul 2022 02:50:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHqmyPxj4BZVbicl1ZPOnYqWjYn02sIlytEysWSKqMuG2GXyTK6EZZ1T78zamVB+1c2bGPGamUDdR1eRgexN0kFLlyHHMNlbNH5R2tOgbbAXPaGyQbgGBfB8JcunpYGYeiTeuiVAqoE9G1QWkMz/aTT6/jpC+F86hx1ZBb9QDgCGAWGfBU2yE6lEU8Akuiedb4Oc5zzmgmYYw7ommQNwER7d2kAW+uigeI9PY0N21qnRZMXOftYb8U4yiSJVM+f13x7Sy2Si+1hllyQh0ojUHh7lg3iSf46UpA0kGO9+gQG39UiVvbw4gC2w4MGmdrgbIW2z+qWUW7bDGM5EPHQO9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7jH3v9lBn11WuPv2UQzolt8HtFCHhHNqKhr0HL0n+0=;
 b=bn6n9+0yi3p8+eK8z3DWF5TC7ybcV0TK5V1D9R/2aWccGt37LcHZXo6Pk3hA/ihZ7lmaePILYQ9wmr8fIYYp8QG0GYxCl0UsPlWcNK8/bP2r3kIQEgRPirwXxWz+/PGCJYDqSm1K7igV0YrUXFt9x0OON38pHeVQo37bntzOY848Wb1K2HisC8xBSo1ySJE9DdAuoY+FtGaebX8g4WFrrg5SQrJMjQNTQGsY2FCN8s3AwhZqL6Yt5RSeGvJEEkfKi0ocREO33Zsflcl3iZM7oQH9V+rSe6/hJi/ollyMazFwxDsBtS8xj1IFDvDYUGZwUbeFL+QVCU06quSt6lJ2Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7jH3v9lBn11WuPv2UQzolt8HtFCHhHNqKhr0HL0n+0=;
 b=HI1yJ2XrysrSRUyKT7F0fvCAOmSm7K79koUmDgReSjOSFGEtczS0yYnjEMiOiXG+KDOGVpYSymSTbuhUySbOQWZny+trELh+WWVoeXY0uqUxULAUFE3RbX5WgMMKlJApePUufzdZC2V4Fmzqvb8Kz1NldaT5PUYAFcPjHdS58yc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by MWHPR1201MB0191.namprd12.prod.outlook.com (2603:10b6:301:56::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Mon, 11 Jul
 2022 09:50:40 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::905:1701:3b51:7e39]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::905:1701:3b51:7e39%2]) with mapi id 15.20.5417.025; Mon, 11 Jul 2022
 09:50:40 +0000
Message-ID: <0db981a4-9519-ca7d-b6ce-ff498070bf8e@amd.com>
Date:   Mon, 11 Jul 2022 11:50:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 138/230] drm/amdgpu: bind to any 0x1002 PCI diplay
 class device
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Deucher <alexander.deucher@amd.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
References: <20220711090604.055883544@linuxfoundation.org>
 <20220711090607.978575207@linuxfoundation.org>
 <8c73c2b5-f70e-f343-7ca4-e1db420d5419@amd.com> <YsvvXmH9DpMMIIiK@kroah.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <YsvvXmH9DpMMIIiK@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::23) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bc9ec34-b4bf-411a-f6df-08da6322d010
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0191:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5nRlPfjdCm+R2q3wKIubj0MtU+ZJ0/e7FxxPtzdcPpZ97N4AlFbZwGJ8uCE1lGYJGNCCw2+1FwgvdTqEEuCk4JpANjiFvPUi7FU8gE1M6t/gNx3ef71OwM8X9/YX+1D/xJZszNVGlqojQ8ThG8MHUTBOxOafUX63o3DLTPv3eXulGPWcHo3x5OG0BRsYeNkYMsxF5CYNb7nPRUE3tLQn7x2lxclqhlEDVgE8/4Er6IDSPnYcZHYdZdD9u7pgx5jYR9KaOWp46s202AjC8sW2DetwD7zQH2bDe6RbaDQ9f1yFCVCxPT1uEZAydEiToBQLRG9OGgJ5WN8CE7owqEhrbPKFzXE44uPkqV+RBzE9cyEmOIdKRxTYqxUayFdA2kAqEKK8jHNm1iEZ7/NpDdz/EEq0MCS22l1Rx2p+Nz7gXAGsurbyBbf+E/kZ4hkTi8dIM9Wo9uSCoOsTgo9SKaE01jntJx2iQIki7t9JN7WnbCF8KvG89HLnEzJ7jsmUjLbJL4PNz5gDjoZ2LqRqzJnOKxNWeR9KAlNG0ddDLTdKkRrXL0/w7PUJAWAy4OfswsTemzUenBd/CO3joSciQ2aznBKqhrcPz2aMV2Ht88aKbxF4odYX3OYreU16CN/OIBhrpHVHlPa+9qUu9etvEjB4LK0bLNAWw//RcEVul/dcFT64EXGrSgH/ui0BWwpBh2m3DIbpoCPU4jASiyNr6JwuGm4zfABk/khC+RnZana6ggMP4DlND4swJ6OJqn/ToGcAkI2ZFcXb7dPD6fBHrw5kIwYVbwaBvSC73PBaLZGJHdtIZ1+C280g1NMgDxxSEOTq1n8py4Yw21PP2EG1T0pkokRvOJVzvGpYGxE2d3Sw1+c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(8936002)(110136005)(31686004)(316002)(38100700002)(83380400001)(478600001)(5660300002)(36756003)(2906002)(26005)(6512007)(6486002)(66476007)(66556008)(66574015)(66946007)(6506007)(186003)(31696002)(6636002)(6666004)(41300700001)(86362001)(2616005)(8676002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkRMa05CWkE4REF3cnBMMlRYcTB4SUFscHpGTWZwMkE2b0Y5dEJpY0V4Mjg3?=
 =?utf-8?B?MGtxV0k2MWZXdlAvK0IvNjhvU0Q5b2JVaWJzZExBZVU2QkwwbktwRmdRZnZz?=
 =?utf-8?B?YWIrZC80ajRoMDhVdlZYaXAwZXEwMkZBVysvdWN6akMxZDFsOTg1eVlqY21C?=
 =?utf-8?B?aEhXM3dyUHh2bWFHeEJldDJtOFdmN1FQc0VZOHRuYlg4czFjUkNxQjNTTjB4?=
 =?utf-8?B?emVYbldSSXBEcW1ucllNL21pL09IdzJKWWhRSGoxTkZlaFcrS1VKY1B2dVZs?=
 =?utf-8?B?UGNqNlE1d2NPVDUwT2ExemZ0MlBPaHMydFpaTjZyNGhDdG5hQmd6ZzZaajVV?=
 =?utf-8?B?bE5SdkZQZjQvS09hMGkvOFlSOE9SaFkvb1hsRE9nMHFacEw2T3FmOVhaL05h?=
 =?utf-8?B?bUg1YmNRTnRWN0k0eERENGxLbHZXdWxscDQvcGNoZm00c1lVdmFSbkxRWFgv?=
 =?utf-8?B?KzVQUktiWjNiMStndGZyZm5DanE0dVJUWStaVTNGWFJhUFA5RlJ3dVYrdVlG?=
 =?utf-8?B?UGNrMGpwNTRubDc1NzB5RnFKbk5yRkkwQ2ZKSGlXTUJUTUpEVVUvLzhwTTZt?=
 =?utf-8?B?YVZtSS8zNWpRWWpoNE9lczh5L2k1U2psQjl0VmxhcXFPVGJXVHcrbXAyV0ho?=
 =?utf-8?B?SHN1RC9oOVRYSFRMdko5aXE0UnZHU2JySnRleTlrODM1MkpoQ3N4ajNSbUgw?=
 =?utf-8?B?c25kTmtyTjAwNG9HTmk0OVkzaWJSSlZ6d2hXeTNKZnR3L2JMaHV0c1p6VXJK?=
 =?utf-8?B?dmttNExLUU5XUHMxSHQxN1NnaWgxNTkvMU5NMkg4T3F6dkltSUhmZWNZaXYy?=
 =?utf-8?B?WHR5T29qQXlWNHhkRXpYR0xZbXRMeTRudU9rNjlrR2wzRzhNR2FDTlFmYmk3?=
 =?utf-8?B?djRYcHBvSXBsNW5SSmFha0cvRVpUZjl0V3RHQ2xEdUJxbDNGeVFmNUwrbkdL?=
 =?utf-8?B?OGcxQkRZck1qaWR2V1VRMDVsU2lUNVI3SmU1eS93K0EzVElQa0lnd1I3VGQy?=
 =?utf-8?B?MDYxUFYwOG8xdEUycWlhdnVHZGkwWmYwSnh6ZnUvTVBEbTh4SDdEaHhPc2dl?=
 =?utf-8?B?M0ladEFST2pFbkFJU0pzcUlPUTdINWtMdkNvOCtSWWtrYkNZOVBORXJKSTlm?=
 =?utf-8?B?MXpUb3RWMkxwR2xJTHFRZVRSVXE1dVpCK0JhVkl4clN3YUNFaUZKbDZCK0ZY?=
 =?utf-8?B?OFF4M0FRTG5odTFTSzArNlFxNVZoaEZlUzZUWFBqZUZmT3o1alZWQzJDNkhC?=
 =?utf-8?B?UTVTWWZLT2hzWldaMmhnT0hQd1FEaEoxYVcxZzkzTzV4Qmxnd2hxL0crelZH?=
 =?utf-8?B?NGFoZzJRU2VCYVYwdnRIWkpFUWdmQ0haeFExUWxLbGtoK0lFZVB3cVNQOWRT?=
 =?utf-8?B?YVdMWG9SY1FHdXpCZGZXejYyS1pSRVlxR0MvZXo1cEZKRWcxQ2pmTVpsb2Zt?=
 =?utf-8?B?YlZ1OU5ETnJxSTk0cUVjLzI0MnFqYmNXTUxubUp2QUNRc2pFUXcyY0o0Wnpr?=
 =?utf-8?B?MG5HY3Eza3MrN0U0YWVEc3FINVVUbkNueWFHZjNDYm1kL1lnZkVlRFBHSXl4?=
 =?utf-8?B?U3ZSSUlyTEF3UzR2S3NmN0pmc05reTVDdi9wTkc2MGtmb0lMWUpPdWtqdVBr?=
 =?utf-8?B?RWt1NkJCTGNJNzgzL3IwTlRON0t4YjVmaHVGU3VvNERQQUthT2hQcVNVVzNJ?=
 =?utf-8?B?WVFyaGdtNTl2cmQxWW5TZFNwRWdTRjVZa3RET3JlUkZiaVlHNFRpaDNSZThD?=
 =?utf-8?B?M0FDUzZ0Y0JkbjhPUEl6dUtHdFRHdHBNZTZOQXduaHVCV2N1WDBxRzJjSEdU?=
 =?utf-8?B?V1dzenBuVjZGWVA5OWU4U1JXYWNWSlh2RGVOZFIyYWVuZTJnYWdwQmRHNlZo?=
 =?utf-8?B?alBqQmZTaHhVWFpjWXA4TzBURmtSc3dLZFEwYXdtellXbmdoc201dUkvTmxs?=
 =?utf-8?B?ZkZPR2kyR2k4YUJmODl0Vm5NUG1MZC9CTFgwUWVhbVczVWY2YWdFZ2J0Z1RH?=
 =?utf-8?B?VUx4czJqdWRjTkhSUmxEV2htaStlYzJTU2YzMW1ZY0ZiNytQdFAxSzVDejZl?=
 =?utf-8?B?Q1BLSDRkZEV5bWdLVXI4eDlJSUU5ZWNEVnFrL3UzT3N4SlZmaTBlMGNJVEVX?=
 =?utf-8?Q?8Fn9ErDSPxT0zYfl4m1RvCn7h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bc9ec34-b4bf-411a-f6df-08da6322d010
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 09:50:40.0594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tPe8nFSjbf14l1/LybhYbfQPmgjTSBRayjGaWQP4mvlXeWPxPiNdBmRueMZijvV8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0191
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 11.07.22 um 11:37 schrieb Greg Kroah-Hartman:
> On Mon, Jul 11, 2022 at 11:29:53AM +0200, Christian König wrote:
>> Hi Greg & Alex
>>
>> why is that patch picked up for stable? Or are we backporting IP based
>> discovery?
> New device ids are usually added to stable trees as they are "trivial".

Ah! Ok, sounds like a misunderstanding.

For the background this is *not* a new device id, but rather changes the 
way the existing device ids are discovered.

Instead of a table with device ids and hard coded list of hw blocks 
inside a device, we now look at a VBIOS table to determine which hw 
version/blocks are present.

So yes, this might enable new hardware but it's most likely not trivial 
enough to be backported.

>> If yes, is that wise? IIRC we had quite a number of typos etc.. in the
>> initial patches.
> If this commit is incorrect, we will be glad to drop it, or add any
> needed add-on commits.  Which do you want to see happen here?

Alex, that is mostly a question for you.

Thanks,
Christian.

>
> thanks,
>
> greg k-h

