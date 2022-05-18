Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4442F52B073
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 04:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbiERCT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 22:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiERCT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 22:19:57 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2F2B96
        for <stable@vger.kernel.org>; Tue, 17 May 2022 19:19:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYQy2hC6STeqA6BG9MmzvHwNfsfXfxiRR/aCedh6CS2BNvAcmoDKWVcsCu47LGgyayDp1padU2M2CTUugGH4IJvIyI9YdD6vDTWkum02v1P0oeHhLrpp+E2b1We4WWgRCPNYHqYaTb6SEHyhC2ZaG2SCqhbostAy9AMl9dU0OFPbfRshTzk5xxyb9RKkCinY1uC8K5mIxEUmvVIaDkX2wWzNi4eB0qLpUbfOvwdEMjv5Cibv+IoOUvzLTi7yezIdy0icBuY34Dm5pjiy/qU9fwRth89NGeYjat4Z71PLEadc9uBnTs6CtAhk7gohDMU+mc3RFtcAzWXHeaTA1s36rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCrgeEQF/dUdwcbJd2MsimiH8baHLbQSXy7HonnCaTg=;
 b=EkTs8L2P3yChSo4S8Xqc01HuupnwDdoQ2kk7WdE2usrYQFzGfditPe53t1gdDv48WCTpdI47pmTYISmL/vmzJXzeyn11uElkU9n999Zoj60F5EHhQ+VRpGzJaGEiP6RZkGtJ88scnMP1e3n2ggRZQSeQ2kBOPE8qAwt3ah6Q8+dyyX6OAce7mt/KFAgN7PhSqsh4Hb1Be93O468CoDanOvsZvorsNtCY+z/2SlHR8r/135j2s5+ETKWJ6Cs/f1cBguvwlKAnjYNOijXUnsvEjLZPmP1M9G36ZS8BLhctYxQKn1mAMiNFKXyj0e8QzE3E/hBr7xHedHS2S7LF9udjoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCrgeEQF/dUdwcbJd2MsimiH8baHLbQSXy7HonnCaTg=;
 b=bwUQy5jNrWbD482sOsg3VXmRjgNZTw1mUFwnw/mGHiQutfwgs4R3eJBqjXlzSPLLXcxycIxsVOUS9mnGORTD/AgTmcVy2Ar3aFDLJycjUOO4vl5NI+tc1X0ZUefytv48x3RWUbERT1/SNmwzZEqANezOSaoS8giUTq15e4f63z8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MN2PR12MB3710.namprd12.prod.outlook.com (2603:10b6:208:16d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 02:19:51 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db%6]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 02:19:51 +0000
Message-ID: <4dc0d1e4-7e74-f85a-d8af-fdcd862d8a4a@amd.com>
Date:   Tue, 17 May 2022 21:19:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        casteyde.christian@free.fr
Cc:     stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        regressions@lists.linux.dev,
        alexander deucher <alexander.deucher@amd.com>,
        gregkh@linuxfoundation.org
References: <CAAd53p7Sw+EAjn2fH++g7dQaAHxzTqdN81f6xNVKy4hqCWgztw@mail.gmail.com>
 <75938817.547810377.1652809118472.JavaMail.root@zimbra40-e7.priv.proxad.net>
 <CAAd53p69LqeH7pD2S4T-D4i_+PEaejb12kx7rbapPrPCfQ9-iQ@mail.gmail.com>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <CAAd53p69LqeH7pD2S4T-D4i_+PEaejb12kx7rbapPrPCfQ9-iQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0173.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::28) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ada1e502-b379-4307-ce24-08da3874e35d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3710:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3710152BFCB7D739251A1456E2D19@MN2PR12MB3710.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GReZh8xGLirqRfRZPE3xc39mg/Wbw6W3J6bpr4JdBAlL3TPskmxudC0vTtX7vsxqmsHsicevgyTAtB7zQYlStnPsM3LWv7ip7Q/NLzONYCSS7hjtnEuxDO/K8rSkdJZ/4VXzk45m2aXtWeVdHzP8BUUw0Rrt2tMCs2mNIhx1BWLxJDZhGxSPbR2k+cc9VpHNuFLGW3KXy2JGhhi8bGIWRrVFtHvQ68nzz69m9v4lMTONIoHnCWxfZ/rsNV6zEFzkolhTL82XxU6HpbPg1KHEI3PfN08H5k1XtZV5QUnunMB0dNo4Si2Uu8VfTf0KLJ6RqXKrYbqmtHhMrCZMdcSYf1R8V9zySNV+G6lEEuRQKNRMNp7JY+CPHaEYFBY3dPTCN0YQWBmzCsaZQ1FecV4XsIYYMt6g+xY8RJBmgg8q/D1l2rrSnT8R1RIQLjwJnPUFpYbn6s8IQnXqdOd5Nf8jfUylDclrteqr9fI1olDqgv/PTs/y7Q4gOI98Ft1RF8r84g2X6Im56YPR+cxK4XhCUghbW83wp07ROiodddHhv5g/ZR2hb+a9AX7e1Yc984ceB3ZM70JVh3mquyfbDbkfd4wbCx1F0hGv5RitpCFq+HRCmoFlSRzcgIhXUE8GmMsQbJvszq9EgrntegIoBeyra+LigXRedFGmg5PzL/7zgK5NT6xtSt+ZsQRixzAYs60/GGtYBGNIK7gfKOwviisOIkJsO9/DgPcn7WQ5VxHhFxengtVFtMkqD6R6D10LdHRQlpvRAbEkztAzqhkdEOSr4/sHkQvdMHrZpDEjGp/K0rGbixKs0BrdAlBrTmHhR/dyC3z1VjgYznDcHwuEZGN5l+MQsQbCO4Y+LjHrAtmQsMniLd4BOlVq3yoQ1RxP5mC3g4HMbNt+6+sOBcUP0GO3IA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(2906002)(86362001)(83380400001)(66574015)(186003)(31686004)(6512007)(316002)(8676002)(36756003)(54906003)(966005)(6486002)(30864003)(2616005)(45080400002)(44832011)(66476007)(66556008)(508600001)(5660300002)(8936002)(66946007)(6506007)(26005)(53546011)(31696002)(4326008)(41080700001)(15866825006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3hlT09DS1FTNDVzYmRwRHVZdTIvS2E4aGpxNlhkdDd2MGN6YXVwWWE0Z3Mv?=
 =?utf-8?B?Ty9yWFJZbFRPUXFPaGVBTTJvY1RiTjdnMDhhanZGbGhoRnVNREVwZVQreEVt?=
 =?utf-8?B?UVlVbmpXOGVFVzBhejFoWEpnVUN6VGlubFVxWmJ2b2ZlTWtaUmczZGl2UUNI?=
 =?utf-8?B?d1U0ZGp3MW90dzNneWtRL3B4aDFTWms3QnU3UWlPakplSXR5T0dMVXpydXFT?=
 =?utf-8?B?TXhESUV0SnIwMk02dWM5Y0tWR3VHQVpIOUhZOVZmSkNtQitJLzYwNmVDSGRz?=
 =?utf-8?B?M0RjWGdXNGtQTUN5RzRibTJWWEJhOGJNZEFBTzI2SHZmMGlsa1U1ejlya0hZ?=
 =?utf-8?B?bTVUQk5CdkRMRUZsZDNlY0oxbXU5YThndFZpRUNUUWdJbkt1cFArb1owaElW?=
 =?utf-8?B?OG5zUi9Pc05nOWlKdjFOUCtoUXlkSnYrR3BBNzdGa1J4TTJnaXNlRjNyVDMw?=
 =?utf-8?B?TGtQVmUvMkxOeWpCNXJkUWRFT1diT0wxa3hvVGJveVdacGNRWkJxK2w3d1VD?=
 =?utf-8?B?RTgyaVZEdkNBajVPa1hrK3dDRUZMREpFTlRUOWxqbElhelBWYlVVa2o3VW9E?=
 =?utf-8?B?NXBHdDNFQldwdGFBUVBXU0JDbVFpbmpycTRvSTQ0dEhZU013cU41OWxVVE8y?=
 =?utf-8?B?VTJOQTRzeCtMOUxUZG11eDN4SUdjTmptVVhWeFcyNXFYRjFXeUV6ajk3ZWxY?=
 =?utf-8?B?aTdMamVYM05FY1hrdTNxcW5QbWxpTmFIUVF1NUNwYjd0bHZ6NjM3elhQWUxu?=
 =?utf-8?B?RUNIbnU0K2k1KzJJSGMzdGxTOUlJeURTZTZnZ0ZoeXdvMnlaMU9US1NuTnpK?=
 =?utf-8?B?ZWUreHFDM1doUW9DUUM3NEVZNFlxYWpyTFpDcEQ0UmxiR3lZNHFoM2JVbEg2?=
 =?utf-8?B?cmZNMjIzdzl1WHZMeituUXBHVlRFcFBIZVZCVmpVWk5XQUNYYzVnNng0NlVH?=
 =?utf-8?B?bDBiNGJnSmk1eU1qSzRFR3VseGNXOVlTTy9KRkxoSW1BR0RhdklscEI4Y0dM?=
 =?utf-8?B?OVRGdnFVaW5Hd1V6RmNPeWhQY3JET3MxNFNmRlhwOGVwandBWXkyS0EyaC94?=
 =?utf-8?B?b0VJdzRZNEZ4TEpSaWlMOGROWUJqME1ZcGRHU0Z2eU9HL0w1ZW5UOEFuMlFt?=
 =?utf-8?B?WVhFNWp5R002MWRwMkVFUnVRVWFFVlorZmpqUkplMTd2TlIzSWphTVZES3lX?=
 =?utf-8?B?OFhRNmIrR1FiV3NYREY3OGJpZTc3aXlKUnQ2cTRkZHRGSndBWUljd3Yxdkoy?=
 =?utf-8?B?cS9EYXFiaGdhdUR5czFNNmRvN0VXR2VISHBxYlpraFJPZnI1SDB2UXE4STRS?=
 =?utf-8?B?VGk4bms5K1c5dEdVSk1QU2FDN08vNzVRTWZEOGdZSGNCRjMwa2h2QlBZd1pi?=
 =?utf-8?B?Qmd2WHlmQ1k1clZYeWcwOGpVRitKaThZQmNyWU1zK2RpYkt2VVdKWFhQRE5E?=
 =?utf-8?B?MDZrQS9hWGttc2JnZDdHWGJpM0VaQVNzMTNMWDZjQms1THdkMVpmTFV3cldx?=
 =?utf-8?B?WndwbHc3alYwRE5BalVYd0txdGp4TVFHM2lxb0RJS05Wem15SDh2WVFDTjdU?=
 =?utf-8?B?MXRkSk9JckJRSnZiK2ttLzBhVHUwekUxODVTNmlycXk3Vmt6cnFDR1Z0bjBr?=
 =?utf-8?B?cmxDSzBHeW5Ba2tQY0xGaitFUHBvb2owNEczdTVWZzd3VjRaeXIzQVJVLzdR?=
 =?utf-8?B?SmFVZDB0ZWs5TlVrYk5ZNVJDQXNEcFVlbXBVREVZNDI0UjE1Y1hqSDlHbFI3?=
 =?utf-8?B?dUpxS0hOeXBFdGVmejVLZ1RZcXJ3eUNONmptdld1NGZPbm5UaVY3THl5cjdo?=
 =?utf-8?B?TDBJZGZhcjBNdHYrQ0ZSUzNvNU91Z1BTaGU0S2Y2SjgzMWhqN0Uxb0dOMnhH?=
 =?utf-8?B?SFhZMGU0MTkza2N3OE9rOFROZVhBZmw0dUJ5V3d2cHUzQ3hVU0hSbFNWUjJQ?=
 =?utf-8?B?OG1xZXJ3eGFCZFhvaXVBZmxLZ0sxQ1F3aXY0YVVsK3h0VFBCYVV3cXVvc2tF?=
 =?utf-8?B?RmMzQXg4ZzZXWjc5Zi9wSnlrM0J3eE84OFNzdXdGMlFGVEtsM2d1azlERzVl?=
 =?utf-8?B?bEFLY1pQNndBN2dwOTBjV1lGNmtlQTZqb1Fnay8rRnBpd090dmlLSEU2OHFH?=
 =?utf-8?B?ODZ3WGNHZE53SjgyNmU1dG1jZzFpb1JrWHNtVEdqbVQxck9HZXB0c1M1YXQw?=
 =?utf-8?B?bVNXdmZ1dGpRZVJaeEhIZlp1MFg2cUxzUVZnRmt2NVBvTTA1TjAvVTJISGg0?=
 =?utf-8?B?d1VwWk52am5keGVwTGw3T2ZQTENzTkRQV2dsNjFhTnJnb0hLYVpUYWt3RUdz?=
 =?utf-8?B?emEydXMyT1dycWd6c2dVeXhnTmtPdEE1azlEVEVNLytobWc0QXIxZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ada1e502-b379-4307-ce24-08da3874e35d
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 02:19:50.9858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wY/cw6sCFLplmLxUF1r6ztDyrf1wk4+msinmUL4Ef1ZnmSsnDkTcxzUkpboQXoTXIlHEqfxq5rSh2IN6ETYqjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3710
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/17/22 21:08, Kai-Heng Feng wrote:
> On Wed, May 18, 2022 at 1:38 AM <casteyde.christian@free.fr> wrote:
>>
>> dmesg logs
> 
> Actually, the "good" is still no good:
> [   43.375323] PM: suspend entry (deep)
> ...
> [   43.695342] PM: late suspend of devices failed
> ...
> [   44.554108] PM: suspend exit
> [   44.554168] PM: suspend entry (s2idle)
> 
> So we need to find out why the suspend failed at first place.
> 

I noticed that too; but the patch I suggested will completely avoid the 
GPU reset for the APU, which is my guess at why this suspend fails in 
the first place even in "good" scenario.

> Kai-Heng
> 
>>
>> ----- Mail original -----
>> De: "Kai-Heng Feng" <kai.heng.feng@canonical.com>
>> À: "Christian Casteyde" <casteyde.christian@free.fr>
>> Cc: stable@vger.kernel.org, "Thorsten Leemhuis" <regressions@leemhuis.info>, regressions@lists.linux.dev, "alexander deucher" <alexander.deucher@amd.com>, gregkh@linuxfoundation.org, "Mario Limonciello" <mario.limonciello@amd.com>
>> Envoyé: Mardi 17 Mai 2022 08:58:30
>> Objet: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since 5.17.4 (works 5.17.3)
>>
>> On Tue, May 17, 2022 at 2:36 PM Christian Casteyde
>> <casteyde.christian@free.fr> wrote:
>>>
>>> No, the problem is there even without acpicall. Fyi I use it to shutdown the NVidia card that eats the battery otherwise.
>>>
>>> I managed to get a dmesg output with 2.18rc7 I will post it this evening (basically exact same behavior as 2.17.4).
>>
>> Can you please also attach dmesg without the offending commit (i.e.
>> when it's working)?
>>
>> Kai-Heng
>>
>>>
>>> CC
>>>
>>> ⁣Télécharger BlueMail pour Android
>>>
>>> Le 17 mai 2022 à 04:03, à 04:03, Kai-Heng Feng <kai.heng.feng@canonical.com> a écrit:
>>>> On Tue, May 17, 2022 at 1:23 AM Christian Casteyde
>>>> <casteyde.christian@free.fr> wrote:
>>>>>
>>>>> I've tried with 5.18-rc7, it doesn't work either. I guess 5.18 branch
>>>> have all
>>>>> commits.
>>>>>
>>>>> full dmesg appended (not for 5.18, I didn't manage to resume up to
>>>> the point
>>>>> to get a console for now).
>>>>
>>>> Interestingly, I found you are using acpi_call:
>>>> [   30.667348] acpi_call: loading out-of-tree module taints kernel.
>>>>
>>>> Does removing the acpi_call solve the issue?
>>>>
>>>> Kai-Heng
>>>>
>>>>>
>>>>> CC
>>>>>
>>>>> Le lundi 16 mai 2022, 04:47:25 CEST Kai-Heng Feng a écrit :
>>>>>> [+Cc Mario]
>>>>>>
>>>>>> On Sun, May 15, 2022 at 1:34 AM Christian Casteyde
>>>>>>
>>>>>> <casteyde.christian@free.fr> wrote:
>>>>>>> I've applied the commit a56f445f807b0276 on 5.17.7 and tested.
>>>>>>> This does not fix the problem on my laptop.
>>>>>>
>>>>>> Maybe some commits are still missing?
>>>>>>
>>>>>>> For informatio, here is a part of the log around the suspend
>>>> process:
>>>>>> Is it possible to attach full dmesg?
>>>>>>
>>>>>> Kai-Heng
>>>>>>
>>>>>>> May 14 19:21:41 geek500 kernel: snd_hda_intel 0000:01:00.1: can't
>>>> change
>>>>>>> power state from D3cold to D0 (config space inaccessible)
>>>>>>> May 14 19:21:41 geek500 kernel: PM: late suspend of devices
>>>> failed
>>>>>>> May 14 19:21:41 geek500 kernel: ------------[ cut here
>>>> ]------------
>>>>>>> May 14 19:21:41 geek500 kernel: i2c_designware AMDI0010:03:
>>>> Transfer while
>>>>>>> suspended
>>>>>>> May 14 19:21:41 geek500 kernel: pci 0000:00:00.2: can't derive
>>>> routing for
>>>>>>> PCI INT A
>>>>>>> May 14 19:21:41 geek500 kernel: pci 0000:00:00.2: PCI INT A: no
>>>> GSI
>>>>>>> May 14 19:21:41 geek500 kernel: WARNING: CPU: 9 PID: 1972 at
>>>> drivers/i2c/
>>>>>>> busses/i2c-designware-master.c:570 i2c_dw_xfer+0x3f6/0x440
>>>>>>> May 14 19:21:41 geek500 kernel: Modules linked in: [last
>>>> unloaded:
>>>>>>> acpi_call] May 14 19:21:41 geek500 kernel: CPU: 9 PID: 1972 Comm:
>>>>>>> kworker/u32:18 Tainted: G           O      5.17.7+ #7
>>>>>>> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
>>>> Gaming
>>>>>>> Laptop
>>>>>>> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
>>>>>>> May 14 19:21:41 geek500 kernel: Workqueue: events_unbound
>>>>>>> async_run_entry_fn May 14 19:21:41 geek500 kernel: RIP:
>>>>>>> 0010:i2c_dw_xfer+0x3f6/0x440
>>>>>>> May 14 19:21:41 geek500 kernel: Code: c6 05 db 31 45 01 01 4c 8b
>>>> 67 50 4d
>>>>>>> 85 e4 75 03 4c 8b 27 e8 fc e1 e9 ff 4c 89 e2 48 c7 c7 00 01 cc
>>>>>>>
>>>>>>>   ab 48 89 c6 e8 b3 4f 45 00 <0f> 0b 41 be 94 ff ff ff e9 cc fc ff
>>>> ff e9 2d
>>>>>>>   9c>
>>>>>>> 4b 00 83 f8 01 74
>>>>>>> May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc31e7c68
>>>> EFLAGS:
>>>>>>> 00010286
>>>>>>> May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX:
>>>>>>> ffff888540f170e8
>>>>>>> RCX: 0000000000000be5
>>>>>>> May 14 19:21:41 geek500 kernel: RDX: 0000000000000000 RSI:
>>>>>>> 0000000000000086
>>>>>>> RDI: ffffffffac858df8
>>>>>>> May 14 19:21:41 geek500 kernel: RBP: ffff888540f170e8 R08:
>>>>>>> ffffffffabe46d60
>>>>>>> R09: 00000000ac86a0f6
>>>>>>> May 14 19:21:41 geek500 kernel: R10: ffffffffffffffff R11:
>>>>>>> ffffffffffffffff
>>>>>>> R12: ffff888540f5c070
>>>>>>> May 14 19:21:41 geek500 kernel: R13: ffff8dbfc31e7d70 R14:
>>>>>>> 00000000ffffff94
>>>>>>> R15: ffff888540f17028
>>>>>>> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
>>>>>>> GS:ffff88885f640000(0000) knlGS:0000000000000000
>>>>>>> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>>>>>>> 0000000080050033
>>>>>>> May 14 19:21:41 geek500 kernel: CR2: 00007f1984067028 CR3:
>>>>>>> 0000000045e0c000
>>>>>>> CR4: 0000000000350ee0
>>>>>>> May 14 19:21:41 geek500 kernel: Call Trace:
>>>>>>> May 14 19:21:41 geek500 kernel:  <TASK>
>>>>>>> May 14 19:21:41 geek500 kernel:  ? dequeue_entity+0xd4/0x250
>>>>>>> May 14 19:21:41 geek500 kernel:  ?
>>>> newidle_balance.constprop.0+0x1f7/0x3b0
>>>>>>> May 14 19:21:41 geek500 kernel:  __i2c_transfer+0x16d/0x520
>>>>>>> May 14 19:21:41 geek500 kernel:  i2c_transfer+0x7a/0xd0
>>>>>>> May 14 19:21:41 geek500 kernel:  __i2c_hid_command+0x106/0x2d0
>>>>>>> May 14 19:21:41 geek500 kernel:  ? amd_gpio_irq_enable+0x19/0x50
>>>>>>> May 14 19:21:41 geek500 kernel:  i2c_hid_set_power+0x4a/0xd0
>>>>>>> May 14 19:21:41 geek500 kernel:  i2c_hid_core_resume+0x60/0xb0
>>>>>>> May 14 19:21:41 geek500 kernel:  ?
>>>> acpi_subsys_resume_early+0x50/0x50
>>>>>>> May 14 19:21:41 geek500 kernel:  dpm_run_callback+0x1d/0xd0
>>>>>>> May 14 19:21:41 geek500 kernel:  device_resume+0x122/0x230
>>>>>>> May 14 19:21:41 geek500 kernel:  async_resume+0x14/0x30
>>>>>>> May 14 19:21:41 geek500 kernel:  async_run_entry_fn+0x1b/0xa0
>>>>>>> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>>>>>>> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>>>>>>> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
>>>>>>> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
>>>>>>> May 14 19:21:41 geek500 kernel:  ?
>>>> kthread_complete_and_exit+0x20/0x20
>>>>>>> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
>>>>>>> May 14 19:21:41 geek500 kernel:  </TASK>
>>>>>>> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
>>>> ]---
>>>>>>> May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00:
>>>> failed to
>>>>>>> change power setting.
>>>>>>> May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
>>>>>>> acpi_subsys_resume+0x0/0x50 returns -108
>>>>>>> May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00: PM:
>>>> failed
>>>>>>> to
>>>>>>> resume async: error -108
>>>>>>> May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0:
>>>>>>> [drm:amdgpu_ring_test_helper] *ERROR* ring gfx test failed (-110)
>>>>>>> May 14 19:21:41 geek500 kernel:
>>>> [drm:amdgpu_device_ip_resume_phase2]
>>>>>>> *ERROR* resume of IP block <gfx_v9_0> failed -110
>>>>>>> May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0: amdgpu:
>>>>>>> amdgpu_device_ip_resume failed (-110).
>>>>>>> May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
>>>>>>> pci_pm_resume+0x0/0x120 returns -110
>>>>>>> May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0: PM: failed
>>>> to resume
>>>>>>> async: error -110
>>>>>>> May 14 19:21:41 geek500 kernel: ------------[ cut here
>>>> ]------------
>>>>>>> May 14 19:21:41 geek500 kernel: AMDI0010:03 already disabled
>>>>>>> May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
>>>> drivers/clk/
>>>>>>> clk.c:971 clk_core_disable+0x80/0x1a0
>>>>>>> May 14 19:21:41 geek500 kernel: Modules linked in: [last
>>>> unloaded:
>>>>>>> acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
>>>>>>> kworker/6:3 Tainted: G W  O      5.17.7+ #7
>>>>>>> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
>>>> Gaming
>>>>>>> Laptop
>>>>>>> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
>>>>>>> May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
>>>>>>> May 14 19:21:41 geek500 kernel: RIP:
>>>> 0010:clk_core_disable+0x80/0x1a0
>>>>>>> May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44
>>>> 00 00 48
>>>>>>> 8b 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7d
>>>> 87 c4
>>>>>>> ab e8 79 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48
>>>> 0f a3 05
>>>>>>> 4a 61 9d 01 May 14 19:21:41 geek500 kernel: RSP:
>>>> 0018:ffff8dbfc1c47d50
>>>>>>> EFLAGS: 00010082 May 14 19:21:41 geek500 kernel:
>>>>>>> May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX:
>>>>>>> ffff8885401b6300
>>>>>>> RCX: 0000000000000027
>>>>>>> May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
>>>>>>> 0000000000000001
>>>>>>> RDI: ffff88885f59f460
>>>>>>> May 14 19:21:41 geek500 kernel: RBP: 0000000000000283 R08:
>>>>>>> ffffffffabf26da8
>>>>>>> R09: 00000000ffffdfff
>>>>>>> May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
>>>>>>> ffffffffabe46dc0
>>>>>>> R12: ffff8885401b6300
>>>>>>> May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
>>>>>>> 0000000000000008
>>>>>>> R15: 0000000000000000
>>>>>>> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
>>>>>>> GS:ffff88885f580000(0000) knlGS:0000000000000000
>>>>>>> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>>>>>>> 0000000080050033
>>>>>>> May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
>>>>>>> 0000000102956000
>>>>>>> CR4: 0000000000350ee0
>>>>>>> May 14 19:21:41 geek500 kernel: Call Trace:
>>>>>>> May 14 19:21:41 geek500 kernel:  <TASK>
>>>>>>> May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
>>>>>>> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x74/0xd0
>>>>>>> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
>>>>>>> May 14 19:21:41 geek500 kernel:
>>>> acpi_subsys_runtime_suspend+0x9/0x20
>>>>>>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>>>>>>> May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
>>>>>>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>>>>>>> May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
>>>>>>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>>>>>>> May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
>>>>>>> May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
>>>>>>> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>>>>>>> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>>>>>>> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
>>>>>>> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
>>>>>>> May 14 19:21:41 geek500 kernel:  ?
>>>> kthread_complete_and_exit+0x20/0x20
>>>>>>> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
>>>>>>> May 14 19:21:41 geek500 kernel:  </TASK>
>>>>>>> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
>>>> ]---
>>>>>>> May 14 19:21:41 geek500 kernel: ------------[ cut here
>>>> ]------------
>>>>>>> May 14 19:21:41 geek500 kernel: AMDI0010:03 already unprepared
>>>>>>> May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
>>>> drivers/clk/
>>>>>>> clk.c:829 clk_core_unprepare+0xb1/0x1a0
>>>>>>> May 14 19:21:41 geek500 kernel: Modules linked in: [last
>>>> unloaded:
>>>>>>> acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
>>>>>>> kworker/6:3 Tainted: G W  O      5.17.7+ #7
>>>>>>> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
>>>> Gaming
>>>>>>> Laptop
>>>>>>> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
>>>>>>> May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
>>>>>>> May 14 19:21:41 geek500 kernel: RIP:
>>>> 0010:clk_core_unprepare+0xb1/0x1a0
>>>>>>> May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48
>>>> 85 db 74
>>>>>>> a2 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 35
>>>> 87 c4
>>>>>>> ab e8 18 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f
>>>> a3 05 ea
>>>>>>> 62 9d 01 73 May 14 19:21:41 geek500 kernel: RSP:
>>>> 0018:ffff8dbfc1c47d60
>>>>>>> EFLAGS: 00010286 May 14 19:21:41 geek500 kernel: RAX:
>>>> 0000000000000000
>>>>>>> RBX: ffff8885401b6300 RCX: 0000000000000027
>>>>>>> May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
>>>>>>> 0000000000000001
>>>>>>> RDI: ffff88885f59f460
>>>>>>> May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08:
>>>>>>> ffffffffabf26da8
>>>>>>> R09: 00000000ffffdfff
>>>>>>> May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
>>>>>>> ffffffffabe46dc0
>>>>>>> R12: 0000000000000000
>>>>>>> May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
>>>>>>> 0000000000000008
>>>>>>> R15: 0000000000000000
>>>>>>> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
>>>>>>> GS:ffff88885f580000(0000) knlGS:0000000000000000
>>>>>>> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>>>>>>> 0000000080050033
>>>>>>> May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
>>>>>>> 0000000102956000
>>>>>>> CR4: 0000000000350ee0
>>>>>>> May 14 19:21:41 geek500 kernel: Call Trace:
>>>>>>> May 14 19:21:41 geek500 kernel:  <TASK>
>>>>>>> May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
>>>>>>> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x7c/0xd0
>>>>>>> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
>>>>>>> May 14 19:21:41 geek500 kernel:
>>>> acpi_subsys_runtime_suspend+0x9/0x20
>>>>>>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>>>>>>> May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
>>>>>>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>>>>>>> May 14 19:21:41 geek500 kernel: done.
>>>>>>> May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
>>>>>>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>>>>>>> May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
>>>>>>> May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
>>>>>>> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>>>>>>> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>>>>>>> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
>>>>>>> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
>>>>>>> May 14 19:21:41 geek500 kernel:  ?
>>>> kthread_complete_and_exit+0x20/0x20
>>>>>>> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
>>>>>>> May 14 19:21:41 geek500 kernel:  </TASK>
>>>>>>> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
>>>> ]---
>>>>>>> May 14 19:21:41 geek500 kernel: ------------[ cut here
>>>> ]------------
>>>>>>> May 14 19:21:41 geek500 kernel: AMDI0010:03 already disabled
>>>>>>> May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
>>>> drivers/clk/
>>>>>>> clk.c:971 clk_core_disable+0x80/0x1a0
>>>>>>> May 14 19:21:41 geek500 kernel: Modules linked in: [last
>>>> unloaded:
>>>>>>> acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
>>>>>>> kworker/6:3 Tainted: G W  O      5.17.7+ #7
>>>>>>> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
>>>> Gaming
>>>>>>> Laptop
>>>>>>> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
>>>>>>> May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
>>>>>>> May 14 19:21:41 geek500 kernel: RIP:
>>>> 0010:clk_core_disable+0x80/0x1a0
>>>>>>> May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44
>>>> 00 00 48
>>>>>>> 8b 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7d
>>>> 87 c4
>>>>>>> ab e8 79 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48
>>>> 0f a3 05
>>>>>>> 4a 61 9d 01 May 14 19:21:41 geek500 kernel: RSP:
>>>> 0018:ffff8dbfc1c47d50
>>>>>>> EFLAGS: 00010082 May 14 19:21:41 geek500 kernel: RAX:
>>>> 0000000000000000
>>>>>>> RBX: ffff8885401b6300 RCX: 0000000000000027
>>>>>>> May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
>>>>>>> 0000000000000001
>>>>>>> RDI: ffff88885f59f460
>>>>>>> May 14 19:21:41 geek500 kernel: RBP: 0000000000000287 R08:
>>>>>>> ffffffffabf26da8
>>>>>>> R09: 00000000ffffdfff
>>>>>>> May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
>>>>>>> ffffffffabe46dc0
>>>>>>> R12: ffff8885401b6300
>>>>>>> May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
>>>>>>> 0000000000000008
>>>>>>> R15: 0000000000000000
>>>>>>> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
>>>>>>> GS:ffff88885f580000(0000) knlGS:0000000000000000
>>>>>>> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>>>>>>> 0000000080050033
>>>>>>> May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
>>>>>>> 0000000102956000
>>>>>>> CR4: 0000000000350ee0
>>>>>>> May 14 19:21:41 geek500 kernel: Call Trace:
>>>>>>> May 14 19:21:41 geek500 kernel:  <TASK>
>>>>>>> May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
>>>>>>> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x88/0xd0
>>>>>>> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
>>>>>>> May 14 19:21:41 geek500 kernel:
>>>> acpi_subsys_runtime_suspend+0x9/0x20
>>>>>>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>>>>>>> May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
>>>>>>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>>>>>>> May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
>>>>>>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>>>>>>> May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
>>>>>>> May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
>>>>>>> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>>>>>>> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>>>>>>> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
>>>>>>> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
>>>>>>> May 14 19:21:41 geek500 kernel:  ?
>>>> kthread_complete_and_exit+0x20/0x20
>>>>>>> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
>>>>>>> May 14 19:21:41 geek500 kernel:  </TASK>
>>>>>>> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
>>>> ]---
>>>>>>> May 14 19:21:41 geek500 kernel: ------------[ cut here
>>>> ]------------
>>>>>>> May 14 19:21:41 geek500 kernel: AMDI0010:03 already unprepared
>>>>>>> May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
>>>> drivers/clk/
>>>>>>> clk.c:829 clk_core_unprepare+0xb1/0x1a0
>>>>>>> May 14 19:21:41 geek500 kernel: Modules linked in: [last
>>>> unloaded:
>>>>>>> acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
>>>>>>> kworker/6:3 Tainted: G W  O      5.17.7+ #7
>>>>>>> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
>>>> Gaming
>>>>>>> Laptop
>>>>>>> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
>>>>>>> May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
>>>>>>> May 14 19:21:41 geek500 kernel: RIP:
>>>> 0010:clk_core_unprepare+0xb1/0x1a0
>>>>>>> May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48
>>>> 85 db 74
>>>>>>> a2 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 35
>>>> 87 c4
>>>>>>> ab e8 18 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f
>>>> a3 05 ea
>>>>>>> 62 9d 01 73 May 14 19:21:41 geek500 kernel: RSP:
>>>> 0018:ffff8dbfc1c47d60
>>>>>>> EFLAGS: 00010286 May 14 19:21:41 geek500 kernel: RAX:
>>>> 0000000000000000
>>>>>>> RBX: ffff8885401b6300 RCX: 0000000000000027
>>>>>>> May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
>>>>>>> 0000000000000001
>>>>>>> RDI: ffff88885f59f460
>>>>>>> May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08:
>>>>>>> ffffffffabf26da8
>>>>>>> R09: 00000000ffffdfff
>>>>>>> May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
>>>>>>> ffffffffabe46dc0
>>>>>>> R12: 0000000000000000
>>>>>>> May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
>>>>>>> 0000000000000008
>>>>>>> R15: 0000000000000000
>>>>>>> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
>>>>>>> GS:ffff88885f580000(0000) knlGS:0000000000000000
>>>>>>> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>>>>>>> 0000000080050033
>>>>>>> May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
>>>>>>> 0000000102956000
>>>>>>> CR4: 0000000000350ee0
>>>>>>> May 14 19:21:41 geek500 kernel: Call Trace:
>>>>>>> May 14 19:21:41 geek500 kernel:  <TASK>
>>>>>>> May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
>>>>>>> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x90/0xd0
>>>>>>> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
>>>>>>> May 14 19:21:41 geek500 kernel:
>>>> acpi_subsys_runtime_suspend+0x9/0x20
>>>>>>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>>>>>>> May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
>>>>>>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>>>>>>> May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
>>>>>>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>>>>>>> May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
>>>>>>> May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
>>>>>>> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>>>>>>> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>>>>>>> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
>>>>>>> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
>>>>>>> May 14 19:21:41 geek500 kernel:  ?
>>>> kthread_complete_and_exit+0x20/0x20
>>>>>>> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
>>>>>>> May 14 19:21:41 geek500 kernel:  </TASK>
>>>>>>> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
>>>> ]---
>>>>>>> May 14 19:21:59 geek500 kernel: snd_hda_codec_hdmi hdaudioC1D0:
>>>> Unable to
>>>>>>> sync register 0x4f0800. -5
>>>>>>> May 14 19:21:59 geek500 kernel: (elapsed 0.175 seconds) done.
>>>>>>> May 14 19:21:59 geek500 kernel: amdgpu 0000:05:00.0: amdgpu:
>>>> Power
>>>>>>> consumption will be higher as BIOS has not been configured for
>>>>>>> suspend-to-idle. To use suspend-to-idle change the sleep mode in
>>>> BIOS
>>>>>>> setup.
>>>>>>> May 14 19:21:59 geek500 kernel: snd_hda_intel 0000:01:00.1: can't
>>>> change
>>>>>>> power state from D3cold to D0 (config space inaccessible)
>>>>>>> May 14 19:21:59 geek500 kernel: pci 0000:00:00.2: can't derive
>>>> routing for
>>>>>>> PCI INT A
>>>>>>> May 14 19:21:59 geek500 kernel: pci 0000:00:00.2: PCI INT A: no
>>>> GSI
>>>>>>> May 14 19:21:59 geek500 kernel: [drm] Fence fallback timer
>>>> expired on ring
>>>>>>> gfx May 14 19:21:59 geek500 kernel: Bluetooth: hci0: command
>>>> 0xfc20 tx
>>>>>>> timeout May 14 19:21:59 geek500 kernel: [drm] Fence fallback
>>>> timer
>>>>>>> expired on ring sdma0
>>>>>>> May 14 19:21:59 geek500 kernel: Bluetooth: hci0: RTL: download fw
>>>> command
>>>>>>> failed (-110)
>>>>>>> May 14 19:21:59 geek500 kernel: done.
>>>>>>> May 14 19:22:00 geek500 kernel: snd_hda_codec_hdmi hdaudioC1D0:
>>>> Unable to
>>>>>>> sync register 0x4f0800. -5
>>>>>>> May 14 19:22:00 geek500 dnsmasq[2079]: no servers found in
>>>> /etc/dnsmasq.d/
>>>>>>> dnsmasq-resolv.conf, will retry
>>>>>>> May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer
>>>> expired on ring
>>>>>>> sdma0
>>>>>>> May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer
>>>> expired on ring
>>>>>>> gfx May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer
>>>> expired on
>>>>>>> ring sdma0
>>>>>>> May 14 19:22:02 geek500 last message buffered 2 times
>>>>>>> May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
>>>> expired on ring
>>>>>>> gfx May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
>>>> expired on
>>>>>>> ring sdma0
>>>>>>> May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
>>>> expired on ring
>>>>>>> gfx May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
>>>> expired on
>>>>>>> ring sdma0
>>>>>>> May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
>>>> expired on ring
>>>>>>> gfx May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
>>>> expired on
>>>>>>> ring sdma0
>>>>>>> May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
>>>> expired on ring
>>>>>>> gfx May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
>>>> expired on
>>>>>>> ring sdma0
>>>>>>> May 14 19:22:05 geek500 last message buffered 2 times
>>>>>>> May 14 19:22:05 geek500 kernel: [drm] Fence fallback timer
>>>> expired on ring
>>>>>>> gfx May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer
>>>> expired on
>>>>>>> ring sdma0
>>>>>>> May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer
>>>> expired on ring
>>>>>>> gfx May 14 19:22:06 geek500 last message buffered 1 times
>>>>>>> ...
>>>>>>> May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer
>>>> expired on ring
>>>>>>> sdma0
>>>>>>> May 14 19:22:18 geek500 kernel:
>>>> [drm:amdgpu_dm_atomic_commit_tail] *ERROR*
>>>>>>> Waiting for fences timed out!
>>>>>>> May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer
>>>> expired on ring
>>>>>>> sdma0
>>>>>>>
>>>>>>> CC
>>>>>>>
>>>>>>> Le samedi 14 mai 2022, 17:12:33 CEST Thorsten Leemhuis a écrit :
>>>>>>>> Hi, this is your Linux kernel regression tracker. Thanks for
>>>> the report.
>>>>>>>>
>>>>>>>> On 14.05.22 16:41, Christian Casteyde wrote:
>>>>>>>>> #regzbot introduced v5.17.3..v5.17.4
>>>>>>>>> #regzbot introduced: 001828fb3084379f3c3e228b905223c50bc237f9
>>>>>>>>
>>>>>>>> FWIW, that's commit 887f75cfd0da ("drm/amdgpu: Ensure HDA
>>>> function is
>>>>>>>> suspended before ASIC reset") upstream.
>>>>>>>>
>>>>>>>> Recently a regression was reported where 887f75cfd0da was
>>>> suspected as
>>>>>>>> the culprit:
>>>>>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.freedesktop.org%2Fdrm%2Famd%2F-%2Fissues%2F2008&amp;data=05%7C01%7Cmario.limonciello%40amd.com%7C9f81b636194e44c69fb908da387358f3%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637884365323647690%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=Np%2FMfai9ObN6w3RncSlT3%2FjQNJtzzmY0LL4qK0hVo2k%3D&amp;reserved=0
>>>>>>>>
>>>>>>>> And a one related to it:
>>>>>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.freedesktop.org%2Fdrm%2Famd%2F-%2Fissues%2F1982&amp;data=05%7C01%7Cmario.limonciello%40amd.com%7C9f81b636194e44c69fb908da387358f3%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637884365323647690%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=kJXaC7bE3TSphzokMt4sG7xUd3Pi7VrNFYPr9DKrBrk%3D&amp;reserved=0
>>>>>>>>
>>>>>>>> You might want to take a look if what was discussed there might
>>>> be
>>>>>>>> related to your problem (I'm not directly involved in any of
>>>> this, I
>>>>>>>> don't know the details, it's just that 887f75cfd0da looked
>>>> familiar to
>>>>>>>> me). If it is, a fix for these two bugs was committed to master
>>>> earlier
>>>>>>>> this week:
>>>>>>>>
>>>>>>>>
>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git%2Fcommi&amp;data=05%7C01%7Cmario.limonciello%40amd.com%7C9f81b636194e44c69fb908da387358f3%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637884365323647690%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=ZD%2BXimGGTHtXIvQfHwSh4kwIln6oJxe4ppjwcrBncHY%3D&amp;reserved=0
>>>>>>>> t/?i d=a56f445f807b0276
>>>>>>>>
>>>>>>>> It will likely be backported to 5.17.y, maybe already in the
>>>> over-next
>>>>>>>> release. HTH.
>>>>>>>>
>>>>>>>> Ciao, Thorsten (wearing his 'the Linux kernel's regression
>>>> tracker' hat)
>>>>>>>>
>>>>>>>> P.S.: As the Linux kernel's regression tracker I deal with a
>>>> lot of
>>>>>>>> reports and sometimes miss something important when writing
>>>> mails like
>>>>>>>> this. If that's the case here, don't hesitate to tell me in a
>>>> public
>>>>>>>> reply, it's in everyone's interest to set the public record
>>>> straight.
>>>>>>>>
>>>>>>>>> Hello
>>>>>>>>> Since 5.17.4 my laptop doesn't resume from suspend anymore.
>>>> At resume,
>>>>>>>>> symptoms are variable:
>>>>>>>>> - either the laptop freezes;
>>>>>>>>> - either the screen keeps blank;
>>>>>>>>> - either the screen is OK but mouse is frozen;
>>>>>>>>> - either display lags with several logs in dmesg:
>>>>>>>>> [  228.275492] [drm] Fence fallback timer expired on ring gfx
>>>>>>>>> [  228.395466] [drm:amdgpu_dm_atomic_commit_tail] *ERROR*
>>>> Waiting for
>>>>>>>>> fences timed out!
>>>>>>>>> [  228.779490] [drm] Fence fallback timer expired on ring gfx
>>>>>>>>> [  229.283484] [drm] Fence fallback timer expired on ring
>>>> sdma0
>>>>>>>>> [  229.283485] [drm] Fence fallback timer expired on ring gfx
>>>>>>>>> [  229.787487] [drm] Fence fallback timer expired on ring gfx
>>>>>>>>> ...
>>>>>>>>>
>>>>>>>>> I've bisected the problem.
>>>>>>>>>
>>>>>>>>> Please note this laptop has a strange behaviour on suspend:
>>>>>>>>> The first suspend request always fails (this point has never
>>>> been
>>>>>>>>> fixed
>>>>>>>>> and
>>>>>>>>> plagues us when trying to diagnose another regression on
>>>> touchpad not
>>>>>>>>> resuming in the past). The screen goes blank and I can get it
>>>> OK when
>>>>>>>>> pressing the power button, this seems to reset it. After that
>>>> all
>>>>>>>>> suspend/resume works OK.
>>>>>>>>>
>>>>>>>>> Since 5.17.4, it is not possible anymore to get the laptop
>>>> working
>>>>>>>>> again
>>>>>>>>> after the first suspend failure.
>>>>>>>>>
>>>>>>>>> HW : HP Pavilion / Ryzen 4600H with AMD graphics integrated +
>>>> NVidia
>>>>>>>>> 1650Ti
>>>>>>>>> (turned off with ACPI call in order to get more battery, I'm
>>>> not using
>>>>>>>>> NVidia driver).
>>>>>
>>>

