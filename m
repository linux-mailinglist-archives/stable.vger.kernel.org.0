Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EF953389E
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 10:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbiEYIiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 04:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbiEYIiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 04:38:04 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85391DA64
        for <stable@vger.kernel.org>; Wed, 25 May 2022 01:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653467880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vbpT3yZcSXHDw7MmrRliht8SFh4l2ZuEudQzP1kWPus=;
        b=f16lBcr8AZwncP7uL6qlyhtIk+OLk80/pH/PlN1Zn9OqYQhi/083ANilFPv9/qN8kVeu/D
        HY/ptw+gsu1m4Q2i6WGtRlq5mhCTiSDP/GmCbmHYA/MTABrTz4WOzbHs3v/JemxYs4/+A5
        qD+q7D/+cJWPv2jxgu5OfXdPI2yFCJ4=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2055.outbound.protection.outlook.com [104.47.1.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-23-OJKHBF5LPNilveXCpqcp-w-1; Wed, 25 May 2022 10:37:59 +0200
X-MC-Unique: OJKHBF5LPNilveXCpqcp-w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDHn91MkUeMT7Z811TnbqoY3xgwJ/diKP/6ICZAOXUq5iqkGxqiOD2PZhv+X3/JiDlsHJ0D/3PM6vFvR1kho6nsONSesRAzTXAeX/Xnl0WGsJet/8fck8wc7G+oGvo6Aw/hjGNJ0HMHdAn5MVXAj84m4e1Pq5frPFHpn5P6A9QQ0DOE0sKhhp16D780pzPZsWKE4YAqFNuyD+fO35NRTStIbLBc1NjyTvyBk6LCKSlSCK6vGcmXZRXCgjNTQZrh3NlLaNwV0KXXTWDC6+H6Ht2kEsj/WwXWSUYRf/W2Nt8y1lAxMmkpg77dUcRTr7ume5W3SVJQVC3guqBJYz4YRuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbpT3yZcSXHDw7MmrRliht8SFh4l2ZuEudQzP1kWPus=;
 b=itxqXOC9z4YLGXePcTIjHujw+iXw/cfnEXKHhx+SWSpvaC5hjLYeMj/o7UKIwBN2KM8U5qShDvkSOyzZciY9RS2RN1FD33Fzpdeekw8Wh12tl+YQDUvTYNCzqrGhXN0pTmji3EIQZo9OLKjh+47P07rAm6lCox3Nm/LmQMdTGaiFUuJZKYKoowyorXtqOETH+4TS46MYGO0Sw1dUq/N9o5tkT4wY7vpRsZbPlfIqJV85odNtgWqKMQX4LzfiDIB08TdAvgOujhypBS9cTrbiGkzagU3TOqnUCFOqe5VnTEElZcABFpyyst+7jDhHTYjS2B9v5/k4cTEcNlw5pDv1Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM0PR04MB4049.eurprd04.prod.outlook.com (2603:10a6:208:67::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 08:37:56 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::dfa:a64a:432f:e26b]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::dfa:a64a:432f:e26b%7]) with mapi id 15.20.5293.013; Wed, 25 May 2022
 08:37:56 +0000
Message-ID: <83cbd5ce-7f00-9121-44b3-5d1b94d66f02@suse.com>
Date:   Wed, 25 May 2022 10:37:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] x86/pat: add functions to query specific cache mode
 availability
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Juergen Gross <jgross@suse.com>,
        Chuck Zmudzinski <brchuckz@netscape.net>,
        regressions@lists.linux.dev, stable@vger.kernel.org
References: <20220503132207.17234-1-jgross@suse.com>
 <20220503132207.17234-3-jgross@suse.com>
 <1d86d8ff-6878-5488-e8c4-cbe8a5e8f624@suse.com>
 <0dcb05d0-108f-6252-e768-f75b393a7f5c@suse.com>
 <77255e5b-12bf-5390-6910-dafbaff18e96@netscape.net>
 <a2e95587-418b-879f-2468-8699a6df4a6a@suse.com>
 <8b1ebea5-7820-69c4-2e2b-9866d55bc180@netscape.net>
 <c5fa3c3f-e602-ed68-d670-d59b93c012a0@netscape.net>
 <3bff3562-bb1e-04e6-6eca-8d9bc355f2eb@suse.com>
 <3ca084a9-768e-a6f5-ace4-cd347978dec7@netscape.net>
 <9af0181a-e143-4474-acda-adbe72fc6227@suse.com>
 <b2585c19-d38b-9640-64ab-d0c9be24be34@netscape.net>
 <dae4cc45-a1cd-e33f-25ef-c536df9b49e6@leemhuis.info>
 <3fc70595-3dcc-4901-0f3f-193f043b753f@netscape.net>
 <eab9fdb0-11ef-4556-bdd7-f021cc5f10b7@leemhuis.info>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <eab9fdb0-11ef-4556-bdd7-f021cc5f10b7@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0510.eurprd06.prod.outlook.com
 (2603:10a6:20b:49b::35) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3166e3b-759d-43af-31dd-08da3e29dde5
X-MS-TrafficTypeDiagnostic: AM0PR04MB4049:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AM0PR04MB4049612FE581918490A6357BB3D69@AM0PR04MB4049.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WwP78UU8d82jS9vXHiR3ZCG96ajbYTjupxiVv4m99p/gARtERhenblFCHo2cLpbRz6OkO0qyN7AxPsgvlkWuTcREX+bfTfiP8auotCRL/1tE9GKPJO24/bApUJQsrxiWK3aXd9dp5mhDy5JdTX9ePIY+B4JC2kBS9A1KQ91+SZrcgASCinKddr0Z2Gwc0sbqrN5sFUEyU4mo/0HN8i1yqu2G7ivMO01zh6lC/qRhXXNbM0klEu4nmcsaPa7Hs7cpmGlVeyxoHH4VHc+QvCjiWAm3SJevs9xw+j4leOQWTm1+wNy85R+koIoOh5PgcO/jKGRXaesev824veXCIrMtfUza9UfhqnrkRzXMd+fs3Pdoh82YARACIgWeiCanlzWAG6FcjjK8ymPLV2JJ96V51vxO7nnLLD6Y+s+KTvwBA2Nke9Ju73lBukSR2NapEl6EIFfZ+nTC0hu0nGyp9jfKOVxqbwfXIwJhYaHx+QF1nxzArUpwrN6hW1+f4WocyiTfKen3POprwbjU2skCzgmsnkEE4SG435Idoi2cel1H0QXNrnWPCzp3AmYkbRR1VvWnQySU5K7ZN5M7qc4XYuSnsYJQXhoMGKjze+nB7/BekL/Zb9x/r6vakOf8NkFRS5Uaxf8ymA2L6vqmaa8huUZOMZOdN96ZVmBiLLAvC6UXfmFDkfrUrXo8Tdfts3FVW76zV00ltbv4yN+JrdCMiaNEZnHvL4iA9ZiidBM8TUxPZWIBRMrcSLBtHmilRN8ktg/RgV240xP8tb4K73TShlJj7+PEK7GSDycFOe7IiqgnGgVC7T3nMWB9AMS7rK7XYNdt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(36756003)(53546011)(8936002)(5660300002)(54906003)(7416002)(83380400001)(508600001)(6506007)(66946007)(4326008)(66556008)(66476007)(6512007)(26005)(31686004)(8676002)(966005)(186003)(6916009)(31696002)(2616005)(2906002)(86362001)(6486002)(316002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVBYaXc4Zm9SSlVsRytvWGZVRE9raWVNSlpOOWM3Nkt1Znc4MVR1d0xuUWxv?=
 =?utf-8?B?dTlpL0tQbC9XaFAva2d3UGkyS2swVFU2M3ZiRW54ZmlDakpublE4dTdMb2h3?=
 =?utf-8?B?eWtab1NUc1RYaERsZjRYTVlkbm1DWkJ1eHZTUzNuQ1FDV0VFajNJektnMkw0?=
 =?utf-8?B?WVBmRlBUV0hKTVFVcGpWNk5hV0V6anBuYUlSQTE5QTd3TzNFT0VGdmxJbCt3?=
 =?utf-8?B?Q0pwOFVLQ3RLdFZZTDJFQnQ4RjZLVG9kd1BMcDdKQ3hMS29rSUhWYnZjZktq?=
 =?utf-8?B?cUIxMUNUZlZyYmg1VGhGVW91NXRUS1RqaFR6NEg1R3JZVVhNUEk0anBMNkdB?=
 =?utf-8?B?UktjU1NFM1JpRC84aFFSWGRYZGxKZjd0anFkWUN0U05ZeWxjRHlXbHRXeUZy?=
 =?utf-8?B?NTEveG5TTHI5QTRpc1VkdFN2MWRiQzRhMUxBMGxOVzBKTldmNkRzdHFPaHdH?=
 =?utf-8?B?UzFTUFZLQ0h3WVBQWkRWMXUrYm1GWEpURkt4VWp6N0ZxS0xwdFdhNXZ4My9P?=
 =?utf-8?B?MzJBcWtEQUZBSXpibXBmUWYvSWw3MFdLcXpPQ01ocEhrRmR4REpQRXVZaEhk?=
 =?utf-8?B?R010MkVWVDR6ampiN0N5bVVENE1HcGdXeTNDbDBhUEJmMU1NR25kdXBScmlz?=
 =?utf-8?B?Z3R0cElraElyaHB4eWxHMFgwOWVMajB6czZBM1VxUzgrelEvU3Fid3VvaTY0?=
 =?utf-8?B?dG9pK2puTHpqckloRDdtaVRjcExVbXR0L29VWHdJT1VLUi9JTXBieFJXdnZL?=
 =?utf-8?B?eklnTUlXT0N5NHhDejdDNEFJazl4VXBqd1dzcnFBUFRxa0NYU0xyK0h3bjZl?=
 =?utf-8?B?cHFIaVQ1REw4amE3MEpnRjBHTnM3VGNCOTZnUmZNOVA1ODNoUERReGx6clA3?=
 =?utf-8?B?SFRTRUNiUVB0RW5lODFlNWFlbGJWY29QdFkzYTRsNjJTL2lscDFyMFZDZ1Ir?=
 =?utf-8?B?ajlER3k0ZzZ0SktVSWs0WnFmQTd2Yzd0cTVndERpbTd0WU9ZT3Ewcm9wWEFJ?=
 =?utf-8?B?N05US2UzeE94cU84bXVvWnFqTmZ4VUphMEVnbmFKb0FQaVlpb01HOHpnTFJn?=
 =?utf-8?B?NUluSE1ZdVhUTVJZYnFqdVJOQ1ZJNzRtK0ZpcUs4UFpkR1FlMS8yT0RVeTBS?=
 =?utf-8?B?M0xBSTJVb2VXQXB0enlrcUlkWk5ZbXRWR0N5MklCNkovUXlHRnNZc0JPbWo4?=
 =?utf-8?B?YXpEN3pTZDZJWVhKYWlRbE5SRFZjS2tNSEJjQXlvNnhGWVRpU2h4NmNXUGpp?=
 =?utf-8?B?bVR1dmdSNm8weHUvY0djaDFWRXR4cE9ObjduVXVJcmdjaTljeVc1RzRMMHpO?=
 =?utf-8?B?RkNPSGJuWnVHRndlTktTM0plbmVCdis4b2lnekdQVm5tRkl2VGlBWmEwd3Bm?=
 =?utf-8?B?dDNpZUJHR09lK2VGbnJuNFRDcUQ0ank3K2xGZEx4VVFEU0xrYmo3cUxIQm1o?=
 =?utf-8?B?R2dwaGJ2U3hUVndiNEZRYTB6V1BjYkRuenkwVW1jTjZSVzM4RnFiSjlNd2U0?=
 =?utf-8?B?VHphWVloT3ZOb2hWa0dWc1V6SHU3MnQ5ck1Va01ZcExJYk9Nc1ZlSUljWXBQ?=
 =?utf-8?B?WVJhT0I0S2k5c0lhQTVVTjd5RFdZUG82V21WUzUrblk4RnhGT3Q1djBLS282?=
 =?utf-8?B?RDdoOHQvTDhQN0d1eXpNVmhiWXhJSHM1RU1qSTJ6eUNSelJwTzZNNHZpbm9j?=
 =?utf-8?B?RDZtNWRBU2l5UEt0eE8yNUREcmdqQTBlc1ZOVXlrci9rMUd0Q2hMb1d5M3R4?=
 =?utf-8?B?NWlUblhvcDlFMG5USXNGMXlHWEMvU1VyMlZnVVRzNytpajFDS1h4Y010UTRU?=
 =?utf-8?B?dWtLRTcybzA0cmZoRVI1bVp3UFd3b3UyN2hpVjRQNkViTkM1NVJ0N3crS0dP?=
 =?utf-8?B?cFF5UmlkQTNVc2hrRlAwRmw4T2FnRTVoSEc0RTFlWlJtWVpmd2l1dW1OdmJm?=
 =?utf-8?B?SjZIMFhxZk13QXozKzVrcXVSNEZJUUJLN0pIdzJtL3BtQnQra3Qvd3FUTDEx?=
 =?utf-8?B?SVFBdlJXWWprNXRjMThwVXRweGJLckQzVzRmclpxT1lIWEVvRjJaUTllZHRx?=
 =?utf-8?B?YzdMd3VkWGRsWXlKQWlYanpvdjBFcDhzcnhmVXVrMHdvVEdXenVXbzBBbFFF?=
 =?utf-8?B?S2xCOE43SUQ2UWlVdnh4a0w5UElSVjVVeDVMNlJFQS9sbGEwRW1ZdUFBMGh1?=
 =?utf-8?B?d0xzK3JuekNqdEFhMmh2VEtHVTlZUkpxMUMrV3VWNmh1Q3ZxL3Q0Sk13Tmtq?=
 =?utf-8?B?V2t0b0lhNXZ2U1FBUlJES2tibGpaV2pSclZ1S1diR0pCd0t1VS9EZlNyMm9m?=
 =?utf-8?B?Vk1HMEYrWkd3L2NCSmlSVDlhZkc5MHBVNnZpVUFSOWNEQ0Q1WWxMUT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3166e3b-759d-43af-31dd-08da3e29dde5
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 08:37:56.5119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SfUW3x+gPRKMK0LNQNnVKDS/effpSJ33cfgbsPov83HWtlAev8dRsI5IeW0bkWf7OHtetBI2KRXKSKq7NwUOzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4049
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.05.2022 09:45, Thorsten Leemhuis wrote:
> On 24.05.22 20:32, Chuck Zmudzinski wrote:
>> On 5/21/22 6:47 AM, Thorsten Leemhuis wrote:
>>> I'm not a developer and I'm don't known the details of this thread and
>>> the backstory of the regression, but it sounds like that's the approach
>>> that is needed here until someone comes up with a fix for the regression
>>> exposed by bdd8b6c98239.
>>>
>>> But if I'm wrong, please tell me.
>>
>> You are mostly right, I think. Reverting bdd8b6c98239 fixes
>> it. There is another way to fix it, though.
> 
> Yeah, I'm aware of it. But it seems...
> 
>> The patch proposed
>> by Jan Beulich also fixes the regression on my system, so as
>> the person reporting this is a regression, I would also be satisfied
>> with Jan's patch instead of reverting bdd8b6c98239 as a fix. Jan
>> posted his proposed patch here:
>>
>> https://lore.kernel.org/lkml/9385fa60-fa5d-f559-a137-6608408f88b0@suse.com/
> 
> ...that approach is not making any progress either?
> 
> Jan, can could provide a short status update here? I'd really like to
> get this regression fixed one way or another rather sooner than later,
> as this is taken way to long already IMHO.

What kind of status update could I provide? I've not heard back from
anyone of the maintainers, so I have no way to know what (if anything)
I need to do.

Jan

