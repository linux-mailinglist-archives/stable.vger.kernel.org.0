Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD1D4CCFA8
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 09:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiCDIL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 03:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiCDIL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 03:11:58 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2078.outbound.protection.outlook.com [40.107.96.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6596518F226;
        Fri,  4 Mar 2022 00:11:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSZ5p74Zh2DFGU5qzxMbJxeAuUaHyZpot+2Em0ii2EHBLEzoD+H3i/j+mPfEWDnKwOvMrsakhFuzTPcSQNgjC9J3o8RAeW0nCsJJjZxi9bf8Y2wDUzbCTeuddnG4CP1RQAQijk6HTP4SoBlbRzfDXXG9/k5PEvvWzbz6Mdp6BO7DfUAFS5d8PknE8UlE4hZPGhJ98SIAqg+B+gWvw7NIu7Ni3c31rIwbAFR+mTmgDtdbLk3rr+RKZyRLaAGEmRufrnlS30iN10AMn37++EJCZ/Gd3n/vDnxDlZxVboeFLNjjMXS3MabHEWFX+DIx/xHQabdUfY2wrpMEgm0eNbK5Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FU6US8/3SiUBDXs3+HUAOgMF/KkysQPS4IHL1+wKVJA=;
 b=KFt948GIFm5RFQGfDPCxv4sSBTVAePTdGgPJcUD53CRseNGPX4Jtc3ZyBPq7h67lWc0oppsZG26reGinDjOpy9xd61E6ci2jz/XJe06isiE33lEvDS9AlDNqEF+3uLFVDjFr1x63Wn7Q50NQjoJr7egLNcJ7QkiXaBj6M856WpmxO/YcbUmRjZWeQ/lj6QgsvslEgDn1U9FPDz5Z9mzHT9iYL/CwPLJsUwz2IqMu2g9skxSlQlIQhVnacizyCsoTO8N6wmioJI+qw0QlaESuHw/Qyi6EJgsVvUjvjDNT7A0ap8MY9W/hb+YbLNGmPyXm9K0K65PsphHYjk7MVdQ3Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FU6US8/3SiUBDXs3+HUAOgMF/KkysQPS4IHL1+wKVJA=;
 b=vyk559MEdQhobpieFGGbd6MYuDqYnvInmvr2FjOA60j4Oe2KuFsXmvKl9DASL/v2yAXTbfz84/5vbuGAVvhuN6q0uYvXNWjvI2Ms/xv4JFdUQeJFty4/CjahLMz9qEDObUuUPcb7sUqLTLJE4S8X+YPPgGdVG1kSoQe9UA0iMQ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 08:11:06 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::e03f:901a:be6c:b581]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::e03f:901a:be6c:b581%6]) with mapi id 15.20.5038.014; Fri, 4 Mar 2022
 08:11:06 +0000
Message-ID: <4e25e595-cccb-0970-67b3-fc215bfd5b14@amd.com>
Date:   Fri, 4 Mar 2022 09:10:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] i2c: at91: use dma safe buffers
Content-Language: en-US
To:     Wolfram Sang <wsa@kernel.org>, Michael Walle <michael@walle.cc>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        stable@vger.kernel.org
References: <20220303161724.3324948-1-michael@walle.cc>
 <fff424e7-247c-38d8-4151-8b0503a16a7d@amd.com> <YiHIIjSs03gDJmHV@shikoro>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <YiHIIjSs03gDJmHV@shikoro>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0188.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::13) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1c5f600-518d-4a61-06d6-08d9fdb6884b
X-MS-TrafficTypeDiagnostic: DS7PR12MB5933:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB59333EBD2E59D3B53C2B947283059@DS7PR12MB5933.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qSGJSYfWlcNLCMJWYdl6GoOl7cFb0jLrMs/qDfdtVtEPdJrP6T5/6hIJYF8hU3tiQD+VcYJxHXUIcXZyc278w0WjK/iwJ4xaolPPcX5Xf1scux8pO+3iXdpk5nIcI/Wtq/A70tCf7YjWcqUFPgqvIYgs0aMgepXtkWXlTH7L9f5heoT0DVXpwfyuJST1cN1pifIEwLRJoY0VgX3AxP8TTLkLGZVVWtRb7YjyE0CKyclwm+IKCz/yN1SbVUFWXQ3cYAaOP8gYnZFqARDwR257p5WxllCdYTwTrtHrh157F5M8tETyk67DOQ1uJOboQi8uDInB9fUqSH3t0UNBlalpk4A5YI+xRX58LOmDeLv0UiWGryAmI04wJxJofHvXOJjDzX1mpqegwMhuGMHaYpaTjI2vpypziQU+ZCAI3xyoDrSHQQqwK6d2ZQi+uF7X2/Vt3ofoF5XHuhPvS2gWyDCYysxHsGd5Tx95hfJG7EGN6nhHZtxTQHvy6XLW3RsmE2r4JLln8B+A56xLiFTp9Msc6o049f8fKbI4pNeGhz5VMFVYiORkcKOK37G/ePet9RQ7mKnwZQTfVT0CzmTghRroR4wyuI5qL8fyezZ3aNeF8RV0irjvKV3Lgcyvz/0VD6PM2w9xZul2K/l7T3YlhMdy6Kyv5wdTZQCggdxnO9nws0ZMxICaDTz1XKj9JV5tx6CK5T7hQBPqQgkE7yLyJPVnkkrqdmGktlQc8Fky/+ceZwxuPw5GI2TizD9F+nh32obKEgZDXt6PMSH1ELnBI7QurQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(921005)(8936002)(316002)(31696002)(110136005)(86362001)(38100700002)(7416002)(6506007)(2616005)(186003)(26005)(66556008)(66946007)(66476007)(8676002)(6512007)(31686004)(6666004)(508600001)(6486002)(2906002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXNrS25BcVB6K0VkdEcrQ29qMzU4YXFtc3F2Y1M3d2tGbjRsUFJzVzBIL3dB?=
 =?utf-8?B?S1pKUlcwK0p6emVsRWtHaDhzY0xlTm5FSENMcDlhN29PcWxYRTJFemNobktZ?=
 =?utf-8?B?OFNVa21udUQyWVRJRHJaL2JPVWJUdkpHTmZLd25kSkR1cUhrMVA2aTcyYkoz?=
 =?utf-8?B?MmxEVFJWaCt0RlFjYjlvYUpMMHJvQXF4Yk9NbExkZFM0dVVzS3hpS3JMbFhz?=
 =?utf-8?B?VHJ0aG1WVlRpYUZ2QllUbkVmRi9QbHVmdnRUSDFSRC8zWVE2NnZqMmJjMDJZ?=
 =?utf-8?B?dFBYaDI5akJZY2JFOXExM2Nwam9HdWIwTkxEc0d5OEVDYTE2V2kzbUxyQ2Qw?=
 =?utf-8?B?dC9XcWE1MEF6b3NtNlRWbUg4YWZkK1pQeXJJSmxoYnFzVTVtMzI1QmEyWkVR?=
 =?utf-8?B?eWtsTnp0Vy90ODZvY1d2SUxXamZuMlhEL3dBNy8vT0pHWGRRTzFyYVYzQ3Qv?=
 =?utf-8?B?UDRSaWZnY0U5a2VuV1ZYbjhYR3lrYkVZVHIvT1RoOURVdnRmM2RsSHIxT3o4?=
 =?utf-8?B?dGVwMk5qRGsreXJ4T3RhSEwvaCtpUlVQVmV4WHUzR3F4c2Z2V3Z4WnJ0UUwz?=
 =?utf-8?B?NFVXTmlaNzFqOFVTK1FnOWZuckNIYTIydE0vWXp4MzBrOFpQVFRodWtZOGZw?=
 =?utf-8?B?WktiSk5WcTlIYktGdlFzbzRjaFdrZ21CQkR6enNQUWs1bFNVSTNaeGJnZXlX?=
 =?utf-8?B?SG0wOGtIVU8rcTBIcVViamYrcDdSYTdoYko2T2hrODVZNldsS2QrY0RGOXk0?=
 =?utf-8?B?WTRVV1QyMW1aNFBNcDUvZWkxNExiNnVneWh4TGh4ejdSV2xKUkgxY2F0N21u?=
 =?utf-8?B?a2dvWjVNcEhod05vNFFHV2VYakdaOE5FNXZGN0JOZExzNWIvbHBlQWpTamlr?=
 =?utf-8?B?aVd6RUF1Q2kyZWpKK1FlL3l6WVc3Y210dTlzcmFxTVk4SHVDbWk4WjFXc3FH?=
 =?utf-8?B?RVlCMUdmK0R6VkJuYnhZaHNRWXRHL1BjV2xSMEJ4WGpxS2FiZmdMSCtBdzVH?=
 =?utf-8?B?Ry8wb1RLeDlORk5pMElid1V2SXF6aDdVU3FRaTJDMHF0UlpsRzByNmY2RWRq?=
 =?utf-8?B?QWZaajhwTklGK015ZjFBaVI1YzFaQzl2WjlxK2ZsVGc0cU1Tam1DRXNlZWt4?=
 =?utf-8?B?aFZZcU9zWDJseUVpMjhMcHlrNVlmNEE5WkNlVHMxd0JwRkh0d05pK0l0U0F6?=
 =?utf-8?B?VHI5UkpmZTZGcGczdG1LM2FpUC93amwwOS9qaXZCSjNzSTN3ZkhLNWpXaGVs?=
 =?utf-8?B?elFDZXpFRGRGS3J4SFJOT0l1eWxJcmg1Nmh3SmpjOFplN3FFdWxTUVVmaDFS?=
 =?utf-8?B?Mlo4VHV4Y3ZnRHFGcEs3NDdNWjhOUmpnaUljWUEvVnk3Z1R1OTNPaE5UR3gr?=
 =?utf-8?B?SGszckdXcEJhNGFMdTBESDhEbzhub2RBdnFLUnVpZ0plZUxKWnpoVnU2SHpa?=
 =?utf-8?B?QldLL0tIZ3JBOFFER0F5eDBGZ2dFYkZsc1ZnR1VaN24vdWtabDdXRFczT0Q1?=
 =?utf-8?B?enZHS2N5MllYR05CbytIWE4wM1k5K3NhMlNJeU5BQ2dNTDhpM0d3SW9ybzcv?=
 =?utf-8?B?SUMxQUVmenduU3JmMmhQSGg1ekpWbW1jbVRnamJTQ3loTkZzVy9mRWdQVHZz?=
 =?utf-8?B?STRQb0M2bXJUYVByeHFXdGRaUkJwVklXT1Zxdm5nOGZVNzVtUHdNT3p6MmFL?=
 =?utf-8?B?ZEhodDNiYVZQWnBrSURPVmgzQU9jVDJTbTR5dGwya3g2cUlPUnFIY2RLMlAr?=
 =?utf-8?B?S0hPdUw3Q1d6aUdTKzE3ckwwczJOalZmTnZhY3hvTnM3MWkzSU5TeTJ3VWFr?=
 =?utf-8?B?TEptRGYwNFZINDdWTmowLzdjNUovOGxoTmZuTFNnQjVtRjNsWVFTZFplQXNh?=
 =?utf-8?B?R2VCOWdRaHk2R010dmdPcjRTeU9wLzlhUHJUd1hGN0hxekFHa2E2dmpjUUQx?=
 =?utf-8?B?Wno4bjhLeCtMNFFXWVZBdHBaSVpWaU9rdFR4cVV3blY5RWFEY3UrVXlRSTU0?=
 =?utf-8?B?SThvcWlKOUY3dnZqZ002Rk5lbDB1ZTZUK2t0RmJpbWtEaXNObFJBMW45eU4w?=
 =?utf-8?B?S3pNenB1SVNLZjZCOThFWVJzZmt3c2JxU3h1MktUTWMxK3Y4ZDU0d2YvQjFZ?=
 =?utf-8?Q?pjS4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1c5f600-518d-4a61-06d6-08d9fdb6884b
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 08:11:06.4785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zNGTFvnf/GNOmGMVgf/iLOW7uA5WgvxggWicxWcBFeN4tUvyK8+VIhzxTU3iHGbd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 04.03.22 um 09:04 schrieb Wolfram Sang:
> Hi Christian,
>
>> Maybe call your variable differently. DMA-buf is an inter driver buffer
>> sharing frame we use for GPU acceleration and V4L.
>>
>> It doesn't cause any technical issues, but the maintainer regex now triggers
>> on that. So you are CCing people not related to this code in any way.
> Frankly, I think the 'dma_buf' regex is a bit too generic. 'dma_buf'
> seems like a reasonable name to me if some subsystem has to deal with
> different buffers which can be DMA or non-DMA, like I2C. If you git-grep
> the tree, you will find it in quite some places.
>
> We could now think of renaming the variable to 'dmabuf' but this is
> a strange and kind of arbitrary rule to remember IMO.
>
> I wonder if you'd miss a lot of patches if we remove 'dma_buf' from the
> regex and keep 'dma_fence' and 'dma_resv'? Or extend it to 'dma_buf_' or
> 'struct dma_buf'?

Yeah, I'm already considering something similar for a while.

I'm getting quite a bunch of unrelated mails because the regex is not 
the best.

On the other hand the framework is used in a lot of drivers and I do 
want to be notified when they mess with their interfaces.

Going to take a another look at that when I have time.

Thanks,
Christian.

>
> All the best,
>
>     Wolfram
>

