Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355C16AE2A6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 15:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjCGOfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 09:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjCGOfZ (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 7 Mar 2023 09:35:25 -0500
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB453898F2;
        Tue,  7 Mar 2023 06:31:15 -0800 (PST)
Received: from pps.filterd (m0209327.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327E3AYg020073;
        Tue, 7 Mar 2023 14:30:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=S1;
 bh=bTe3483GqQPnAPwIQfWduSqYNTJBWzzu5hFHtzqq9Kk=;
 b=Yd1xVpcxsrGQB+86LBTIzz+8tnaoehdmXkdLXFXYdANVWk8N/ghYGcbDHBuXbnLGgrl5
 BpEX6jaFUz78OUVqmO4bfw97mDYzz80lV05vC6JS2oYiQiVlKhFjMXUSTLQ+ixyz48id
 BSZNcOza9mM218xgZyIa+diu505viNgNpPzuhFfFkX8K9c0kKW8Bm/7ObHeq9iT+fsrB
 BApHzPYeYjr7Ax+sdKQGpnRADM+OWvTSm9uCc+B/o9tgJvYjvsmzeSLUySrypggLHkZq
 elj7n6c9wNaf7Qe1+v7z+EMi2YS3hB3y7WfXr8laB+pHHERupwmbF6ImmMf9YWSrnLC0 ZA== 
Received: from eur02-vi1-obe.outbound.protection.outlook.com (mail-vi1eur02lp2048.outbound.protection.outlook.com [104.47.11.48])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3p418njn3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 14:30:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2BgE8vYyYzhV7YV9hT3QDqLeEus9KRfTGITnt+VOPZXcQ/CilUG9PSuMZPh4/nG4h0Zx/b/FFTzDYiRYVa4HrAH68ZCx4WqA57+jdi3aJqaWYU4cPioHFEUyRUDBcngzEE/aeLTpihrPPxEJPeJJrR9yg4oeHYYtsVT6sDZcc9IBt7S9/ERVKfzO1QbA07TgIdVMpPnljBx17JMpa6UFYieHimIyn+eSGytf+qKNyfnESQ9lDqf3QoQsoYaVM/kPuylYVoBWUXMeCDhN2v80oYgBRrCNSk3Mv+6JVBt5E1V/fAvMKRyDAQcZq33Lhu/Klnr1PsHximXIo/+1AZBSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bTe3483GqQPnAPwIQfWduSqYNTJBWzzu5hFHtzqq9Kk=;
 b=dwHoCXKqFCd9bxk0tv4xsb3ycshRwfllsK1/g8/LYi7831diW3dRVlL9aqJ11ze0BgBXNMALamDi41YrLFURt3BIyGWjDHdAuyt2jHi6hHRnZTkaOdexqgzNL+dA4sbBQ1efFHIBdwdGJemgy72uZLhcf+IMsJz/p6GUZtqn1vCLsbkvumLJXqABzclqjBU65dc5yHBhpxia509zopaSKqsOx69Xge5iecLaG7yLnWYmpZnswbehe7oAySWH//hcOi4CPzCy82h4OE3gSY1dkzVVaSP7bR4sLrTOpsm19Dqarra2Eu8w7njYZt1egDB8xHm+eZrChSgs9cunBooPXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from AM9P193MB1332.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:30d::9)
 by PR3P193MB0604.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:34::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 14:30:26 +0000
Received: from AM9P193MB1332.EURP193.PROD.OUTLOOK.COM
 ([fe80::b1ea:2de8:5297:f6ab]) by AM9P193MB1332.EURP193.PROD.OUTLOOK.COM
 ([fe80::b1ea:2de8:5297:f6ab%4]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 14:30:26 +0000
Message-ID: <73971153-b46e-0332-aa4a-0dbe0a59fd22@sony.com>
Date:   Tue, 7 Mar 2023 15:30:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/2] maple_tree: Fix mas_skip_node() end slot detection
Content-Language: en-US
To:     Peng Zhang <zhangpeng.00@bytedance.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc:     Stable@vger.kernel.org, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20230303021540.1056603-1-Liam.Howlett@oracle.com>
 <cec2dec7-818a-b32c-3ad4-8b23fc1351f3@bytedance.com>
From:   Snild Dolkow <snild@sony.com>
In-Reply-To: <cec2dec7-818a-b32c-3ad4-8b23fc1351f3@bytedance.com>
X-ClientProxiedBy: LO4P265CA0258.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::13) To AM9P193MB1332.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:30d::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9P193MB1332:EE_|PR3P193MB0604:EE_
X-MS-Office365-Filtering-Correlation-Id: e1c2c58f-9f27-4aea-0e3a-08db1f187e84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UAL4XKYidVnyJrVRlAO/9PYdWNHaUb5/xa42iiODXgcdKZwXXGdxkUf6imwV7mnP0Ce6nx5+OEsk/sYAsFYxGXlbyWpRb5PpToPFOYTCGSilOO7lwwBNGpNUBoelPAExNVYQK+c0edCOMSSqKOmFWThJXOuRKMlByFUOBXDlIqTB5itDQ0kfXYRm+8R+OrpewGQFZLB5I3z6e9N9PVWpbath3uVio++xSgQOySLbMLxr+atS3b8XI1p/qnGdt3swzVA/3scO7hmrpY0705jMhv3CXmZiuDmXajufgEPBTMMEzT7/izgsSZENBtdE0zfPSw93G32x3kxDIBxc9Up6qIX6AjHC9OT36wlWvo1bKWUb7lMojzjNFOkWIw3oYZZlZ6pF/tViPu9zmmzjRi34Tk9LE0NIYO7XBDlyy+lx9SQr7ehowRGuJ98wmJ9JoKpS2dySw2htKYNNqGjGZ+ePjhwBVe99dvLq7tSPi7U8J0XIoYF7LyVHlETXAKo1s7lSLiZPHx/gbFvXf1Tdut7DAaNzYl3K89cuNLZe2pSyjLvj5XYOP16vowatrz7n0zE/vPrdu7Z9jvM+n+cUVr8bAzcg61p5agO9p/YHVVzRBlfg5Bz10+gKaWlj06Rzp96n7/vZ5wXGBk+DnrLunmFTxCLgr9AswDyVFdcBkH91mK3SdZH9IQq56kIlAJblJjsHQxarAWH9rvR4tdU9KNFWKv57dVIRXZ+z0G3LsCQa6dQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P193MB1332.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199018)(31686004)(316002)(110136005)(36756003)(31696002)(38100700002)(86362001)(186003)(82960400001)(6512007)(6506007)(53546011)(83380400001)(2616005)(8936002)(5660300002)(478600001)(6486002)(4326008)(41300700001)(2906002)(66946007)(66476007)(66556008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3FRQ0lLTjdPd0toUHlybHc2YVlXL3pQM01wY2tkMFMwUk1mWVV6V3BST1Ix?=
 =?utf-8?B?d1lqS3pkSWRWalNHTWFPb2xTN05UZTZ0NE1FT09hNUtvb3hNZVcvZzk2ZC9u?=
 =?utf-8?B?QVg0QUhkN0ZBSW5IOXlvL1dnQjkvZldqS1AzanJGT21IM1ArQmJhcUNPbjJ4?=
 =?utf-8?B?YWxtYU5nTzFoSnd6OHNaeERWcWdFVDVzRlB4Qk5jK2VRSS9QTE9yb2F6Rzls?=
 =?utf-8?B?WGlvdEhtWGlrS0l1NEF5eEhLaTJEWVBTSFFrRjFTY3lBNWdpU3VaeFJ2bVB1?=
 =?utf-8?B?ZWxkN1psNTU5U1NxMTZ1WHR0S1R4UVFkUEN4T3BBN2ovdWt2b0FtR1pOZFlB?=
 =?utf-8?B?clM4NCtRb3dzeGg1b3Z1QnU5T2R6WXR2L2VkWVJWVVI5aXAvM3NzOHdjb0tE?=
 =?utf-8?B?N09NeVV1WHpPTFlTZ1VQS0ZBcDEzY3MvYS9Qc3p1MzhUM1J1d0hRVnZPTkdW?=
 =?utf-8?B?QlJVeUxocTlsd3lETnpiOWRwUHlhM1lFQlptM3ZYUXhEZU5tbWN4cU9ud3Nk?=
 =?utf-8?B?Qnc4T1htM2JpczdJd2pneGY2SUxNOTJ3cmhKeVdLUWxQUGJGejh1NjVhbmk0?=
 =?utf-8?B?dldJemJMa1oxNXJEVkhZRW10SlBNdFNYcnkvekJkQWo5dW5UTVY3enEyTk9j?=
 =?utf-8?B?cCt2cU9LaUx1c0hvNXVKR2wrQXRHSHNvRVhTSXUrbTM5YVlKZ3k2anFLbGs0?=
 =?utf-8?B?VXVjRW5YRlNwNEtTNlFnS0Rob3lhQk9MTElnVEk4SWZKanZIaUtqUE9QdkJi?=
 =?utf-8?B?V0ZJREVVbXpmT2NKWksxL1p4dUc3bWxGU2c4NDlKMTNZSXg1aE9WS3BkbGU2?=
 =?utf-8?B?VmZhdFN1OXRDQW5wcFFmYk9WZVk3WGZldGtrTXFCbkpRODJLbWFWcUVNNkdG?=
 =?utf-8?B?K09WTzF2dlFvdXpvTEJORlJsdXFyOElvL0xJKzN2SFo2MzNOOHVmeGxJcUJo?=
 =?utf-8?B?a1VjTTVwUitnQlpNRzlMYytWS3BSL3U0RXpQV0l4c0o5dmpFTkM3QmY0TEhZ?=
 =?utf-8?B?MWZwZ3FFRHN4ZkVVaVNqRXZRZ3RBejFjdGVEaVVLN2I3alhweDlKSFQ0NnBo?=
 =?utf-8?B?Vy9rOVFtT1FDeG5xaW5iZFV1MmMrT0pHV2tJTHhGeU5mMzhVWmtET2xMMitq?=
 =?utf-8?B?cU5mMUxQV3ptR3UrV0lwTVp4dGx0bzBieEM1V2tVeGIyQlNvSVZwUkZvdWQx?=
 =?utf-8?B?U0NmdUV1KzhRaGE5MlF2Y09GN3VKNmdmNUJWbjA2d2o3QjFVUjRrY3BybzRX?=
 =?utf-8?B?cnZZODZoVW5yQ1FGNWNtbGNnYXF3bnhWVURLRDhuT3JTeHBZdkpISkVGUnhv?=
 =?utf-8?B?U3hzSC9yZ05tczg1b1licmJyeGZSd2hpMHVhTnNtb2x5Si9Zcko1TTlwRC9G?=
 =?utf-8?B?L0VjRDVRY0xKRDR6OHhpN3Y4VDA1MS9QYWh3SnNWeER0NWdOYUJicnZVcGNi?=
 =?utf-8?B?WFRpdDZKTXVJZHNXN3ErSDBLcmVJQWEvOW1vd1Nxb0Z2SjNMWFFxSVFpZ05q?=
 =?utf-8?B?bERNUVRmM0REUTZDL1diRlB4NnVqenVGeW5weVVhT3NxQUhObXRQZ2k3bVY5?=
 =?utf-8?B?YmVPVFl0WGZHeG9PVHNSTEl2VHhXbEZzaDlmYkNIdnQ0MndWRHhwRFp2K2VZ?=
 =?utf-8?B?V2hNWkFlaCtIUmdpMS9uZWl4K0x3RWNzYklOVGZxZDRyWjZuM0w1aEFYdWl2?=
 =?utf-8?B?Z0Y4VVNwVVlleW9MZk1PYUltWGlrc1lMTEhaRHZmMnBiTXBXUDJ5ZkZHd3FV?=
 =?utf-8?B?QmRYR1plbFJIZmY2bC8zRURHT0V4TnZoeDFtN0tKNmdnRktZTXVNSEtxUDVo?=
 =?utf-8?B?aXZlV0U3NjduUFE5VERzTUhTVlIrMVZPZitOcmRacDE0NFk1RCsrZERDQ1FN?=
 =?utf-8?B?bkZKbjNUcW83NUNHVHdWVFNvVExUdG5tRDlzZnVtbXRhVm1NdVNsc1Q3c3RJ?=
 =?utf-8?B?NWQ0V2lHT1YxZVUwdlA3b3ZPYUMyaUc2MGwwNnhSY2NGZmJHbEZzUzFoOVBL?=
 =?utf-8?B?S3kyQ0VORnFiMEI2SVFyeEZvYWp5SngyNlFBN2I3L0ZMcjdRMlliRzNFeU95?=
 =?utf-8?B?QzV6M0lOSDZMQVJwakZoaDNxdkI1ZEdQdUxvN1lLVGhtOXowTG1tKzB2RHlo?=
 =?utf-8?B?QzdDL3YzTjNoc3VzaUpLa25tNHVGZDU3VzcxeXFlU0ZRazhJaExRaDVXV0Rt?=
 =?utf-8?Q?5DM4JjzO4bH4l8921fsFI2o=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aEJQL1ZnOVhyY2tuMGpEaDZkWVlZVGlpZUJ2MlloUXE0cXh1cmU0WUFhYTVv?=
 =?utf-8?B?ME1oUXFkcmpPZFJqc3Y5SjREQ1J2VS8vQkpTWlBQU0N1K25KMkF0aHpWc2U1?=
 =?utf-8?B?TjlUdDhzZ0o4Vy84cUY5ellmRDBqM2IxYmhCNnA2bU5LSE1zWDMzSWpudEVH?=
 =?utf-8?B?Q1BNNU55S0l2bnVmRGVyWWIwQmVBZmVmK2RnU295UUdBTDNlUkc1MlRNeHNw?=
 =?utf-8?B?QWwxZWl6a1hVbFBLRm9xT1gwaFhSbXl5NW10bmRYV2MrWWFaQXZVVmh5RjZP?=
 =?utf-8?B?TENxcHkzdHRWU0FNYlA0SjJzMzhFNlo1T0k4OUFRemRVS0JOUVoybng3STBR?=
 =?utf-8?B?Qi80dmlPRktqeVM1TU1rTlVPUmlCRFlPZ1JvY3JvRGlPamN3YmZDRUhLZGVP?=
 =?utf-8?B?QlN6dlNIMjlKaWo0clp1ZE9DQUQvSzJaVnk0aEwvSFpPUExXNWhwWDBpL1My?=
 =?utf-8?B?R2pFRGNuT0lGWlJmOFE5RzVXNlArSWl3d0lGR3ZwZ3drME9XbVNnQ0M1eEVu?=
 =?utf-8?B?ZWNZeWZEd0R0Y1NMSUkzbGlJWmUzbEt2TXM1UExyeTFUOERWMU84RlR2eW1k?=
 =?utf-8?B?dkJ1YmN2amxyT2dYNU1mSExibkdxbXZhWjM5SVFjdXRieWpnRVhkbFE1U3Ja?=
 =?utf-8?B?WnVaS3FRUUFyQzFRUUhXWmI0cHd6OFhOVFlTN2VLeDFOalBLN0MvV25vcXFK?=
 =?utf-8?B?WFRjdFJwV0lMSS9qbndJWTlFMytybFZmdDhtVkVKZkRXRXhRSDF5a01LWmc1?=
 =?utf-8?B?aTh3ME43ZHVha081Z0NIRDNTc0gzekFJVnZ6aHUyUkdzeUZURmNUMGp2UjNn?=
 =?utf-8?B?Z0NsSU9rN0JReEVsM2EyeUJVakYxbU9QeExFYTFacEEyNDhzWnR4OEQ2TnVC?=
 =?utf-8?B?NjgzeG9CdFdac3A5cGUvVzBJZ3JVNWNqZDlxUzRTaDJpdmhsNnc1SzBLMUJk?=
 =?utf-8?B?NkJQajVHQXV2RVlNOXlPUGxHcURGaGJCZkQrUlRKSjVFd3Y1MVc5UjF4TERj?=
 =?utf-8?B?aW1GcVNhMTZDMkF3a1RtekZyWG84UjhtaHpFY2ZkcmNIN2lGdGZ4S0lBSHpL?=
 =?utf-8?B?N3lCUXBLZWF4WmtBM0dlOThwWjlseVJZd2RjUndmR0prQTc1djJNd2k5eUx1?=
 =?utf-8?B?ZDZhdnY4MFo1ZHRmdExuUFd3SjQ5ZVBTZWNtcTNmaXdFUGl2RUF5OVJpT0Rh?=
 =?utf-8?B?OU90TnUvb1BHbTQzbmdLaVVvL0R4RnJmUVF0cXk3T0Q2R0xvNWhINjNMcWFa?=
 =?utf-8?B?LzVXQk9pY3M4VGlYVmJqZ2owQXVEL3ZkMVhYMHJxbUxhU1VhZlRNK0hZUjlB?=
 =?utf-8?Q?6TCU9hFYhShi8=3D?=
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c2c58f-9f27-4aea-0e3a-08db1f187e84
X-MS-Exchange-CrossTenant-AuthSource: AM9P193MB1332.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 14:30:26.6879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5DXxZP37GjzVOiy3rfXXgBhC7OBUznAuPP/gNQQLn5V9QwzhVpnwPKx4aEaMhrac
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P193MB0604
X-Proofpoint-ORIG-GUID: iaxNBPVzBTR9FVzDFr3dtH4F0iLiuR-L
X-Proofpoint-GUID: iaxNBPVzBTR9FVzDFr3dtH4F0iLiuR-L
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Sony-Outbound-GUID: iaxNBPVzBTR9FVzDFr3dtH4F0iLiuR-L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_08,2023-03-07_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-03-07 14:05, Peng Zhang wrote:
> Hi, Liam,
>> -    } while (slot > slot_count);
>> +    } while (mas->offset >= mas_data_end(mas));
>> -    mas->offset = ++slot;
>> +    mt = mte_node_type(mas->node);
>>       pivots = ma_pivots(mas_mn(mas), mt);
>> -    if (slot > 0)
>> -        mas->min = pivots[slot - 1] + 1;
>> -
>> -    if (slot <= slot_count)
>> -        mas->max = pivots[slot];
>> +    mas->min = pivots[mas->offset] + 1;
>> +    mas->offset++;
>> +    if (mas->offset < mt_slots[mt])
>> +        mas->max = pivots[mas->offset];
> There is a bug here, the assignment of mas->min and mas->max is wrong.
> The assignment will make them represent the range of a child node, but 
> it should represent the range of the current node. After mas_ascend() 
> returns, mas-min and mas->max already represent the range of the current 
> node, so we should delete these assignments of mas->min and mas->max.


Thanks for your suggestion, Peng. Applying it literally by removing only 
the min/max assignments:

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 6fc1ad42b409..9b6e581cf83f 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5118,10 +5118,7 @@ static inline bool mas_skip_node

         mt = mte_node_type(mas->node);
         pivots = ma_pivots(mas_mn(mas), mt);
-       mas->min = pivots[mas->offset] + 1;
         mas->offset++;
-       if (mas->offset < mt_slots[mt])
-               mas->max = pivots[mas->offset];

         return true;
  }


This allowed my test to pass 100/100 runs. Still in qemu with the test 
as init, so not really stressed in any way except that specific usecase.

//Snild
