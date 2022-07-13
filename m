Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE7B573779
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 15:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiGMNeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 09:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbiGMNeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 09:34:21 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30080.outbound.protection.outlook.com [40.107.3.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4502EF7A;
        Wed, 13 Jul 2022 06:34:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDJbUzwl/X+XUxY7eWwDGPatnVdvnW3WtFLtgtgh+Ty4tIuPSfQ9DmR72xU3uj2Rl4kMeLPZl6gLcV7CZK42kUcHB4/BEQZggHuNPqBo4C94kh62ioPI8taUT7o9V19sPMz6uYv6p48ATFH2tVNAP8CA4TINjl9wEt8zoqej/VPkR1+FSaPHCZDr+pwBp3c+J1SWwQo9gqqWLiF9DYJd8M9QRWkaMCUizff1CMVo+GIWoKhdMK/sksHGEvUFEDFHrEQJy5OPJZeHtbXsMAu6NspXE09suMJwUAm2PPdVLzaEUErwfcX1sgXhuLqk19iiNtnHDBA/8g/eW8SKlm4NTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FdSkwSBxSLlF9TLha0Dcz4mHjxZuODbfNcHXKcCCbXE=;
 b=dcWnchSiju7jCsVSrUoqymnHeylZCcwnwjZdjZMPZQz3bJ/CfewTCL1XWe4LPLsa5Swf3h9qFm1FPvAzqHG4QwTCAYelDepZcKZ+t1Jagzu6qUU1mBc9nzsh2lVNPV06hIktBCw3a58M4o3pOxcXgMF7oMBhAvHfPU1yStRfnhG1CVM104k2xE5eu81VoClSaBREM9GSC9QDXEN05cY/pmgrzKE6Kg64TBeDE8EBZoigGCN7E7lf/jQfFhRBzwNXxfh2Z5Q3zhhjQIM7YHVCIlcVw9zTyjkYJx0bp0nHuHmasyPaFNf4F+rpXIaSanb7R4LTHJvJaT/jH6zv9CbAQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdSkwSBxSLlF9TLha0Dcz4mHjxZuODbfNcHXKcCCbXE=;
 b=kQwVxPrYy0/5GEnHsiwN7dZ4WquHf1nLswcN9BsoSdatexXwfgttd4JVla42EF+aTRYcfXQoQejf88qCr/ViPS7d9kqESJMEYXvDvcLLc9K7UUmDZgYgosfipVySgnr7xsKteXyTFg9PpQFPE8fPxM7cBumjPtl1tTt7FJByhzt7i9ScLQI9fQqGWipErW0IaEFwcE+3EoXEwHRgZxFr/ywjQ9ygi0+a3Tt7b4Y3jDJipSkujseomzVIItOGe+9w6yZFm7Re3I3SuI/qpFsolu3N3lreGh5SWUA0KeW+tJzSKp4cibtBMTllj8FMVvOv2il2oCa4zaTKNJnE+IDsrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM9PR04MB8383.eurprd04.prod.outlook.com (2603:10a6:20b:3ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 13 Jul
 2022 13:34:18 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5417.025; Wed, 13 Jul 2022
 13:34:17 +0000
Message-ID: <1d06203b-97ff-e7eb-28ae-4cdbc7569218@suse.com>
Date:   Wed, 13 Jul 2022 15:34:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
To:     Chuck Zmudzinski <brchuckz@netscape.net>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <e0faeb99-6c32-a836-3f6b-269318a6b5a6@suse.com>
 <3d3f0766-2e06-428b-65bb-5d9f778a2baf@netscape.net>
 <e15c0030-3270-f524-17e4-c482e971eb88@suse.com>
 <775493aa-618c-676f-8aa4-d1667cf2ca78@netscape.net>
 <c2ead659-d0aa-5b1f-0079-ce7c02970b35@netscape.net>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <c2ead659-d0aa-5b1f-0079-ce7c02970b35@netscape.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0107.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::17) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1a87adb-7c31-4533-9d9c-08da64d462b0
X-MS-TrafficTypeDiagnostic: AM9PR04MB8383:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UrNm6I3Q1oDa+JN1L6kVetIpsAxDmxMcujNSFoRcG50x5OpRLTS7wOU42sBLcyzMA39FxgntvMPS6b41Ew7gm55ocYSQRi912lf+EYGtTMN01/zat43uEm3/uMSq56FtI4duxJ9t/PyVTDsfM1XNMB7Vjj2LwYqZCHHjKa/zCyStQOzP+ZcBRuZMmNLyHdPUmEU+9sxf+Y7kGhCd0esi00TMAhpfkrlWiAcIesCmidGn9gLwUNQ8fbH29lKTGduW+Hby7W9c0Vu6IYbCFCpC4XVp3ku9U5g++o+QtFJCOKQckbKtwkklgyCM59Ix/BbnDdiAlsJk9YT6/tH1QTBIZu8cHIRwuRUNjIE35hQwBGKsBpRk4gzq71zqK37X6S4/ArHjWzskqQ0FVqkYO/2mCGeg6zej0y4kUxlGiRAQSYNgVZg4pelrZmpiCAJhk21RBoXZg2pHEGH0bX+2lzpPBEkoJ5raE4JL6X3WcZ0gwFLuk8XqJtMz9rrwMLrZYfkomHbdDPjdiSaDhTpVuOymdoJOyCaDLjXU2qp/pNRsAK3HAifTOdLW6eB/bgOvenKpkrNxhdO05avVT0JzzP+gUYTwlufpMCGZgW3J4lo38st8dChGruiIk44w0RDDT7CJBmu7HR88Np+jIU9zYRPkYqkMKqlp0PW1Nv+PI0gIIs6oPRSI8exwxl0erK2mkcICIACkFNno88rQjhdy46PADwaA+VCngMVca3psNFCz4N042d80pyTXJwUg2hLErumg4GsrbNfiRtTRUefgwwLPYQJhDOjitTZ4lEDFsjmpZiGUisEXWjt4usAdcEo8JjdQ1vTi+aF6kExRvWnHp0v9bLjNafvBdPPDRXzdEfs28g4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(136003)(39860400002)(346002)(366004)(83380400001)(31696002)(86362001)(8936002)(5660300002)(478600001)(6486002)(38100700002)(41300700001)(7416002)(6916009)(54906003)(31686004)(316002)(66476007)(4326008)(8676002)(66946007)(66556008)(36756003)(186003)(53546011)(6512007)(2906002)(2616005)(26005)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTl3Lyt4R2haQ1psZUJReUlGd0dHYlVDeDhpUnhyM3FMYlYrMTI3WU5QeEt5?=
 =?utf-8?B?MTZ4d3JvVFVZK0IrclQ2T3JtalZTZVF6a3dPUHpocWxIdDVDT1lLZmszbWF3?=
 =?utf-8?B?cmppVUtLbG9OWVR3ZmRzbFptTXpwUTJhcmQzZGxPdE9jRUVITFBPOHZKdlY4?=
 =?utf-8?B?em5FQTh4RkptZmpYN2cxMTNhRitka2VneEptMUNGNE1Vc1hUVkwyNUtyOGZ2?=
 =?utf-8?B?Y0FHVTBBdGxYcXlvNFVMa2Z0L2dpMjMwWUZjVjFmaSt4VG8vZUF1dUI4V2t2?=
 =?utf-8?B?VVFTS3NQbUZHY2RsbjhRTnRhS2l0Z0VpUUtTQmx6ZkFQOGN6akEwTk1yTmZI?=
 =?utf-8?B?aDVxQ2QwNzh5UU10eEkvbmpKbmtPVkgyY3pmeVdtbFdoVUhBL1g0WjBxNUEy?=
 =?utf-8?B?Vjg1MUoxZHVCQmZjNjNtdVU4cXdsd2pLdDVIQ1M0QnRYZE84RW1aSzRDTjho?=
 =?utf-8?B?bDVRZlFhZTNzUjNrVjRwdkJIRWoybnoyUEkvR0FSRXMwVHYrVlUrRm51L0g5?=
 =?utf-8?B?R1paOXBWMk8vNzNtcmpoSkE5UEp4LzB2QnhqclVCWUpCVm11bE5NeEZEWUNU?=
 =?utf-8?B?czROTnpFMG1rM3ZlUHZkWUNOL2dab29CdHY3QlVKUW5pQ3YrdDZvZ21ROXVm?=
 =?utf-8?B?Z3RTdUZkRGVjcThIUjBYa043Y1dmQ2k2aHBFeWpLS0RVMTVBUG5JdXFDVlRu?=
 =?utf-8?B?b1M4c3hjdTNYZDU4Wk5jV2lLN0kxdXcwMTgvUWI0NHNjMzM2Y1lqalQ4aWhj?=
 =?utf-8?B?RzlkMnFrUzdlbmZtTEpxTVRSc2I0UTkxdmlTbmFFTEhjRi9LZ21jaG42QXJJ?=
 =?utf-8?B?VW9VaE9YUlVyeVQ3NXBLSlFMRVlMZlVxWTQxMUgxWk1nVEk3cEtxQUl5YSty?=
 =?utf-8?B?SWhBallnSmxmaTJwamsyMHF0SlZkVTgvKzhzQnFtc1Z5eks5V3d5QUFnSFda?=
 =?utf-8?B?T3J2R040Q3NLcjZMVERJNVVYY2taRk9pMmt1QmRSL3djTkpkNVo0K0hrS0ZZ?=
 =?utf-8?B?VndlblJRcUZSdFN5MFMxMGJWdmpodjBxSmhjTXZrcnFTSGE3YnV5YUxzY3U1?=
 =?utf-8?B?QnQ4elc1RHdSWDdxZjhseS9lSGlKQVdqSjY5WEQ1d3VJR3U5ZjhMYldZNkpq?=
 =?utf-8?B?eE0vQm5wRkpHWCt1TEV6Q2NOeHIrZG9JalZ2YU5YSVBDWHpUU2RuRkRjWGR2?=
 =?utf-8?B?cjVlZ3lLemlhSHpnd0kxVGNvY2dwNzNLQkFFcmNyMThFa051a3ZtQndQWDBx?=
 =?utf-8?B?ODRpdm15RmVUeitsZGxCRmIwNmVuR3BITVRIMDBGZUF0WXY1WlRvUHEzQkc5?=
 =?utf-8?B?MTZ2NmEyZU00Q1c5ZzVQb3l1MHVzUDZMdTRnS2JmV2wxc21lSlhlclMrN3ND?=
 =?utf-8?B?UjZjWG1RQzJnWllyM3QwT1F3VGRDUTAwMXpZNGVtbVZFT05BUEhBendqZ1Y5?=
 =?utf-8?B?VktFMGFYSkFQWGZsaGM5R2MyMm91Yy9jeEx1TWRDb2syQkZmcGFDUU1TRTFy?=
 =?utf-8?B?U1FjSlV5T0JGZEJoNUt4V2JaU3FOV3NRM05hZzQxK1N5UnA3WmdVUEVYN2hF?=
 =?utf-8?B?WVF6TDdLMjRDME1UREpIeVB6N0ZLVTFna0creGw0UnhldGlNd2RKM0hzSFNB?=
 =?utf-8?B?OUNYc0V1TGMzc2lJSjI1VUJqa2JjSStwTlluejd3Y0JyWGZJRkVDVzgxbXh0?=
 =?utf-8?B?MmR2MzNUWnN0ZmE3VGVOeFNVbVJCZTF3aVhTSWRCc29RbS9qalZ2c2tRMFRj?=
 =?utf-8?B?VThPOGROYm1FRWoraytiM2ZTUEgyY3dzR3I4MmZYUkxJbm8vZG84b3NqYXZw?=
 =?utf-8?B?SWI1MGRjSXVaTzViVHFyZGk5RndkSndyVHQ4ZVJacU8xeUlLbDJObDBidWVW?=
 =?utf-8?B?NlE3Q3NVVkthanB4TUJBQ0JhMjJNN1NnLzg0eVYzejh5bWdvakRFRzdmNDRC?=
 =?utf-8?B?NjJhakVnR3VwRzhRcTE4SGVhQ0daRk1EdVpmWGIyRzZ1c1pNa3BDeE1ES1pm?=
 =?utf-8?B?bVRodmdhRU4xZlpuUzdnVmNrbFVzWHZlSFJDbzVVT0JyZWdGSGRreFY2bjdM?=
 =?utf-8?B?ZUZqU1NZc2EwZmhBenl2dXl3UjNBTU5FUkFsZEk1cUY4Z1R3RldQZlR3aGxO?=
 =?utf-8?Q?wrSKwD+cvqlRYLrrRyxUQm5XY?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a87adb-7c31-4533-9d9c-08da64d462b0
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 13:34:17.9495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7rkSGaHbeh+E1ogjBzKrH8T4ht7u8CaTsp5jkwd4TrDnsY6JbV9T9I6+lBijiq6UF9OUMPXbO8qaXQPhOLgDfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8383
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13.07.2022 13:10, Chuck Zmudzinski wrote:
> On 7/13/2022 6:36 AM, Chuck Zmudzinski wrote:
>> On 7/13/2022 5:09 AM, Jan Beulich wrote:
>>> On 13.07.2022 10:51, Chuck Zmudzinski wrote:
>>>> On 7/13/22 2:18 AM, Jan Beulich wrote:
>>>>> On 13.07.2022 03:36, Chuck Zmudzinski wrote:
>>>>>> v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
>>>>>>     *Add the necessary code to incorporate the "nopat" fix
>>>>>>     *void init_cache_modes(void) -> void __init init_cache_modes(void)
>>>>>>     *Add Jan Beulich as Co-developer (Jan has not signed off yet)
>>>>>>     *Expand the commit message to include relevant parts of the commit
>>>>>>      message of Jan Beulich's proposed patch for this problem
>>>>>>     *Fix 'else if ... {' placement and indentation
>>>>>>     *Remove indication the backport to stable branches is only back to 5.17.y
>>>>>>
>>>>>> I think these changes address all the comments on the original patch
>>>>>>
>>>>>> I added Jan Beulich as a Co-developer because Juergen Gross asked me to
>>>>>> include Jan's idea for fixing "nopat" that was missing from the first
>>>>>> version of the patch.
>>>>>
>>>>> You've sufficiently altered this change to clearly no longer want my
>>>>> S-o-b; unfortunately in fact I think you broke things:
>>>>
>>>> Well, I hope we can come to an agreement so I have
>>>> your S-o-b. But that would probably require me to remove
>>>> Juergen's R-b.
>>>>
>>>>>> @@ -292,7 +294,7 @@ void init_cache_modes(void)
>>>>>>  		rdmsrl(MSR_IA32_CR_PAT, pat);
>>>>>>  	}
>>>>>>  
>>>>>> -	if (!pat) {
>>>>>> +	if (!pat || pat_force_disabled) {
>>>>>
>>>>> By checking the new variable here ...
>>>>>
>>>>>>  		/*
>>>>>>  		 * No PAT. Emulate the PAT table that corresponds to the two
>>>>>>  		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
>>>>>> @@ -313,6 +315,16 @@ void init_cache_modes(void)
>>>>>>  		 */
>>>>>>  		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
>>>>>>  		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
>>>>>
>>>>> ... you put in place a software view which doesn't match hardware. I
>>>>> continue to think that ...
>>>>>
>>>>>> +	} else if (!pat_bp_enabled) {
>>>>>
>>>>> ... the variable wants checking here instead (at which point, yes,
>>>>> this comes quite close to simply being a v2 of my original patch).
>>>>>
>>>>> By using !pat_bp_enabled here you actually broaden where the change
>>>>> would take effect. Iirc Boris had asked to narrow things (besides
>>>>> voicing opposition to this approach altogether). Even without that
>>>>> request I wonder whether you aren't going to far with this.
>>>>>
>>>>> Jan
>>>>
>>>> I thought about checking for the administrator's "nopat"
>>>> setting where you suggest which would limit the effect
>>>> of "nopat" to not reporting PAT as enabled to device
>>>> drivers who query for PAT availability using pat_enabled().
>>>> The main reason I did not do that is that due to the fact
>>>> that we cannot write to the PAT MSR, we cannot really
>>>> disable PAT. But we come closer to respecting the wishes
>>>> of the administrator by configuring the caching modes as
>>>> if PAT is actually disabled by the hardware or firmware
>>>> when in fact it is not.
>>>>
>>>> What would you propose logging as a message when
>>>> we report PAT as disabled via pat_enabled()? The main
>>>> reason I did not choose to check the new variable in the
>>>> new 'else if' block is that I could not figure out what to
>>>> tell the administrator in that case. I think we would have
>>>> to log something like, "nopat is set, but we cannot disable
>>>> PAT, doing our best to disable PAT by not reporting PAT
>>>> as enabled via pat_enabled(), but that does not guarantee
>>>> that kernel drivers and components cannot use PAT if they
>>>> query for PAT support using boot_cpu_has(X86_FEATURE_PAT)
>>>> instead of pat_enabled()." However, I acknowledge WC mappings
>>>> would still be disabled because arch_can_pci_mmap_wc() will
>>>> be false if pat_enabled() is false.
>>>>
>>>> Perhaps we also need to log something if we keep the
>>>> check for "nopat" where I placed it. We could say something
>>>> like: "nopat is set, but we cannot disable hardware/firmware
>>>> PAT support, so we are emulating as if there is no PAT support
>>>> which puts in place a software view that does not match
>>>> hardware."
>>>>
>>>> No matter what, because we cannot write to PAT MSR in
>>>> the Xen PV case, we probably need to log something to
>>>> explain the problems associated with trying to honor the
>>>> administrator's request. Also, what log level should it be.
>>>> Should it be a pr_warn instead of a pr_info?
>>>
>>> I'm afraid I'm the wrong one to answer logging questions. As you
>>> can see from my original patch, I didn't add any new logging (and
>>> no addition was requested in the comments that I have got). I also
>>> don't think "nopat" has ever meant "disable PAT", as the feature
>>> is either there or not. Instead I think it was always seen as
>>> "disable fiddling with PAT", which by implication means using
>>> whatever is there (if the feature / MSR itself is available).
>>
>> IIRC, I do think I mentioned in the comments on your patch that
>> it would be preferable to mention in the commit message that
>> your patch would change the current behavior of "nopat" on
>> Xen. The question is, how much do we want to change the
>> current behavior of "nopat" on Xen. I think if we have to change
>> the current behavior of "nopat" on Xen and if we are going
>> to propagate that change to all current stable branches all
>> the way back to 4.9.y,, we better make a lot of noise about
>> what we are doing here.
>>
>> Chuck
> 
> And in addition, if we are going to backport this patch to
> all current stable branches, we better have a really, really,
> good reason for changing the behavior of "nopat" on Xen.
> 
> Does such a reason exist?

Well, the simple reason is: It doesn't work the same way under Xen
and non-Xen (in turn because, before my patch or whatever equivalent
work, things don't work properly anyway, PAT-wise). Yet it definitely
ought to behave the same everywhere, imo.

Jan

> Or perhaps, Juergen, could you
> accept a v3 of my patch that does not need to decide
> how to backport the change to "nopat" to the stable branches
> that are affected by the current behavior of "nopat" on Xen?
> 
> To do such a v3, I would just have to fix the style problems
> with my original patch and not come to an agreement with
> Jan about how to deal with the "nopat" problem.
> 
> Chuck
> 
> Chuck

