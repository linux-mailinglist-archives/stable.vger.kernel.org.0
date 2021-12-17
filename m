Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9745D47898D
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 12:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhLQLM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 06:12:59 -0500
Received: from mail-sn1anam02on2085.outbound.protection.outlook.com ([40.107.96.85]:8718
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235276AbhLQLM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Dec 2021 06:12:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmHAp5AVnowK3Y5JAbpBGqO16ur/mGSFvtHa0/wzEU3qQGPnSm6nroN6N5f0qnL4/wb9xkcbmD0B4hJaVa3gkRLVsbRVFJ69LCsQ+pNUOZR26COSXJ9VzlXeJIuywd2yJr5BT/fjAe/HvXUigWKA+c8M8BGp0GnPekLnlZ8+5mwvNaJfcuRI0PJ9rVvfiBWJlbDxxqYZ4aY44yMB7OXxEK5a3M+BLgO6azaQIRNLGiqtEihn+5V0D67Z15NsJFURY3ka1X8U/PfRK0z7haxdxw0wCwwlORiYc/5ghzKaTQ6i+SUGiHFxQOm/pdGBOfeKrnE5Wr6x/pppPSi6Kk24gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yMLyBmWU3OPaKLt1LDY51pcvqdWEJYnmjU546Cplfw=;
 b=YteQyBzXGimg5x5yYjvEZWeYksgsauAzD+Rt+FrqcnQVFQcgcJ1A1g+SlIqj/uoYXwQgidpB4J9nAz6meRyNwRZQA256r1CQ6unJ33jJLWwSkM5TyUCFdlPxJuGGtA7LN7vbUk4yNTC5cUrDCXJ1InDl3C2b6S/GJ3XVrgshNDZr7NGGJd9sBb+RO3Mh8MwlEX2YHagJJ/uUz6DAxy2dRg8cAGUW4cFRkT4yerQjRF3KZZ65hYhPwXDjB42bRLaM+OjtgEMMwWFT7qIOSkf9YvR4ez1wMqZITipPHr7kyrxu7Zm0juwyBgJ1qjus3ycQqp/HPSl22JylaiIfGsp7Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yMLyBmWU3OPaKLt1LDY51pcvqdWEJYnmjU546Cplfw=;
 b=tQI6hsINK7mFq1qBjplF5VV5qFy7jZt6e1efmuLOaXHFB1Eg0+uqOJ1idNaTGYu00EVALwL+aT164xSHKglMh+hRQoI55iaMw6pFp9QvWcy/ZEH1u8b2Z0sGqM5+fefVm8ar8xTDidhDsRLwqRy7lW/0JAqcWxcxV5g7886cewOZS8Pwd5nF2XrkaPDDZiXtSKSZhI9jYet1+eqXRlGg/9xgXksEavp+yqgw8Brx/p5xblAFGRSLC1GKb1Va7PS1hcExh0Y2+MdNB1umKtsScWSFj+PgTathVrm1XbqgjNbV72+IQGVCUnc/hi4FEjRnrt/1jMDQdwGJSITASSUcOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CO6PR12MB5441.namprd12.prod.outlook.com (2603:10b6:303:13b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Fri, 17 Dec
 2021 11:12:57 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0%5]) with mapi id 15.20.4801.015; Fri, 17 Dec 2021
 11:12:56 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Subject: stable request: 5.15.y: reset: tegra-bpmp: Revert Handle errors in
 BPMP response
Message-ID: <d917c97d-8023-419c-06c3-d471097fbd7b@nvidia.com>
Date:   Fri, 17 Dec 2021 11:12:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P194CA0040.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::17) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e6a32e5-1d53-480a-4882-08d9c14e2d8c
X-MS-TrafficTypeDiagnostic: CO6PR12MB5441:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB5441BCE955EEDD6EA3748373D9789@CO6PR12MB5441.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGX/s0oOSnfmoZ2IxIxlhQ79noh8+/rJYnPdDpDqRDr+fmcv2nVZONnTEJOu1anIeDS3WK6FuuGATbR4pyWaD5UW0PZy2rOz1WCKv3H9d23g9SASIhVtos1NznViWSpuvqiQknNpmb4/GaHZBSkPQmZxnL71/3LFoIk5wYSmAHpIpf/f9YmEtb8n8TcVYHDH+BgXd+U6eMsede3gOWDa3u5kVLz3w47yAIxFleaL05DyhfLIWXyS8DPrR0K/PLhqO/N/yAV1UP8jkcVXNgPc93cLAiA0QP7GrBPfqQqZNrWXhWXFUahWvLWEitCVPmfd5Nn7uyfbgViIsWoNNBB5eyhfFstxn0eGhO6dFB8hwazMBEtxlayMDZQsBvsrt7l3N+IASf0O1IllcYch9dpJ+kXKnz2SD1P7XMYavNwqgsvltZSz6R0tifhu1uY9yF7gDItHHhrW0nKS1vFWPH2p4C6wCk3JGYObMjTun7qUPmWvZxZ/D2NKnM6Q0Z9zcqcpMSOJIBioGcwnBh8h5kydfwuZevow5a+nVIwWzaQXqncdWaM4yIx5i7TTeyIOZP1MX8Y9jhWPF3Ux1FU3FZG8vvt9ew43h9joj0Dz/q4XEHLXpm4uERygWifYNpYQF7+aBqMTLhZ/B5WOwRl2ow2/vI/dWwxgBBwHqWlLI66nA+NacHvSvf60QFlR0Bf2vEdo4KM5cnIf+muDrwNG+hPkULWVn/9sfhtx6zbOFNukw4c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(55236004)(6666004)(4326008)(508600001)(6512007)(8936002)(5660300002)(2906002)(31686004)(8676002)(6486002)(86362001)(66946007)(38100700002)(31696002)(186003)(66476007)(4744005)(26005)(6506007)(36756003)(2616005)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlJQZTJHaU5wQlRtSTV6SnpURTFqUmpnQUgxMjJwbHA0MGVIY0t4c2ZmcEtE?=
 =?utf-8?B?a0luNEIvckg4clF1TDE4WkNmQ0d2S2Y1aG9MTWdtYytlVXpLamdoRmdWTXdI?=
 =?utf-8?B?Z2hIUG5BUk5kVWJscmlqajRkazREMS92RENWWE15Z2RJNVlEblF5YzBtNERy?=
 =?utf-8?B?RElxSlJ3YVJscThhdFBiTGI2QXM2eFlqOWdJMmV3RGJCNnR5WVlOdFBxWEtv?=
 =?utf-8?B?VytyaTBQR1ZMWkl4VFcrdUUxSm9Zbjk5UUs4QUJYOGJrTkNxbHVVbzA0UjZQ?=
 =?utf-8?B?RXgvUnRhRmJ4cXhUa2lHdE81UFFMMTgyWWhQeXg5cXdURkkySzdhSkJodEhj?=
 =?utf-8?B?Zk1ZUlA2dHlaaHAyL09FQnZZZFlLQkhqYlBsV2g3SVRTS3BHZVJJU3ZhUE51?=
 =?utf-8?B?bThpc2xWR2IrWFMrRzdFTGhDSHJVV3JvaXlGdHZ0NUJHQTl1eHZ2Rm5xb0Fp?=
 =?utf-8?B?QUV0OGNkazJUbmVyRHhGNWFiZENyREt2YjF0bktTL0cwTGRWNVZTMEJ6VXNH?=
 =?utf-8?B?MTduWnpqamp3SlFUYmR6NTZrV1IyRDY4bGN4azdTZ2Q5YWJ6aU8rM1owVlE1?=
 =?utf-8?B?eHhDNHFVMU5abWVkaVRnMEU4am56WXhEcmVaVEpwakNIa3drelViVHZ6c1po?=
 =?utf-8?B?TFFmZHVSOE5aREU5cGF0b3NUaHNzcVVUZnlWajJKZTNnbnVDeUVEOFVqa29G?=
 =?utf-8?B?UlhNRTQxaS93TCtwVzhEUWcxcTIvSktEdmE4OGdiVUEyTUxKSWJWY2tJc1h6?=
 =?utf-8?B?TGVOdTBGc2JPVU5oeFdySWhRNTRNVHMyTDUydmEzT04yWXZ3YnN5WmIvOHNw?=
 =?utf-8?B?Nkx1d215aUN6by9vV1NXWDNNdTU3V2VMREU5QXdvZ1VTMHg2MXhHUTU5R2M3?=
 =?utf-8?B?cHNTVWp2Q0RqM3MvSWsxQ1FoTklvK21ydnJCbzhTY0k4S3dwSncyeW1PWTEr?=
 =?utf-8?B?TUZGZnJIaS9QZTVGazNKZ0ZCT2xjQmxxQ1pJVkU3OXN0QWxyQlN6aFZZTHBl?=
 =?utf-8?B?WUZ5M1gzRFNMLzBLb1E1UnYzaVpuRHVSa1YrV3k5Tno5TGh5c2lvL3g2QStL?=
 =?utf-8?B?T2NLOG5uTmluR1dZeVdzYkFoSTZXRWl6cWxjdS8vVmN0QkJBdmowbzIwMXVF?=
 =?utf-8?B?M29yaGNDc3hyZnBHSHRXMEVYaTA2RThLbDhQNjVjcmhSNWU5Z0IzSW5JazRp?=
 =?utf-8?B?UHZ2UzFTMzhncXh0R21yUUYvanZvakJicjFLUjZRMHVoVy83em1WUklpVnBj?=
 =?utf-8?B?VE9qMFIwSTdIZ3NxVUU0bnk0QVVDYmpybExoY2lSQXFFUnRHR3pLb1ZkcSs4?=
 =?utf-8?B?dTBZUDYyQXR3bFVEUDFzZU5uSjNCQ3RsMTZoYlFMaFUwdm5zN0J6Y3l1dFpU?=
 =?utf-8?B?MFBNTm1sbERMOWRqUURhOFlpelhsazhDK01EcEVVRzhNelVPaHM1elBMeExt?=
 =?utf-8?B?OEp4Q2ljVVNKUWd3aCtVVDhreWdKcmxvWk0xcmE3UWxmL1BKYTgwai84NThB?=
 =?utf-8?B?NHZnTU80RFludUsvL3RYUzUwLzFTUVYxRFN2Rkc3S2dWQmNzSTdYd1NKT0JG?=
 =?utf-8?B?WTEvYWxmWGNLOVBha1ByWjZxTExoOTBkTG9uNDQvL3g2bFEzUStBc2g4alV0?=
 =?utf-8?B?QXlOS2V2R0tsYUlBVEM1alg4bGtYRjJqQ1p2bCtjK2FLbnF5YjU4blZjTlhp?=
 =?utf-8?B?a0xISFcrSW85THdqY2lNUVQ5eGJVUEE1VHBHdFhlb21KMnZYY1MybGljdlVF?=
 =?utf-8?B?b21yOEVicmpVd2Q5VE1rNmFYVU56d2lWRk9FN3NPK1hlcWZKRndyVmlsNmZL?=
 =?utf-8?B?Zkphck1kK09VOUJCa1B0U3RCT2dvVHJIVno5NVM4TXJkK1V4S2dWNE5adkta?=
 =?utf-8?B?ajlHOWxPdExrNmFJcC9mYmYvbGpMck1yR2t2MTdYVW53WFBwemVzZ2hRUXZi?=
 =?utf-8?B?V2xIWUtyVlhVYTN1QzZuMzhGbmczRnJlNVA1aFQxV3ZuaXJhNWZ1VmNLTnVh?=
 =?utf-8?B?dEJWMkNXR2N3Wk9qeUo5Ny82Z05hUjBZNW9MZkJDL1R5bGdDZTBLRWlNbzR1?=
 =?utf-8?B?Y2tSVkRSZ29FVnRoakJaWFdJdGFONG9GRlk3ZTZGclY0bVZpYVhFcGM3MTVp?=
 =?utf-8?B?VmFVWU4rYWNVcTdlUmlkMFRlSFJuaVpYNFloTFYxd1htTW9PUDl0djBycGds?=
 =?utf-8?Q?4C8o6cue2mLgWWb1zy4oZw0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6a32e5-1d53-480a-4882-08d9c14e2d8c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 11:12:56.7474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: peQbG7rlC6ywyA3GsSvc4RbnjPl4qic1kHIysIWSk1vJN3ilUSjLKshvvE6DDyO+NBrLFs8iO9uiWLMG1Fuzaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5441
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Please can you include the following commit for 5.15.y? This is the last 
one that we have been waiting for :-)

commit 69125b4b9440be015783312e1b8753ec96febde0
Author: Jon Hunter <jonathanh@nvidia.com>
Date:   Fri Nov 12 11:27:12 2021 +0000

     reset: tegra-bpmp: Revert Handle errors in BPMP response

Cheers!
Jon

-- 
nvpublic
