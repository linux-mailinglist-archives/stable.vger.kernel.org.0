Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775B5573801
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 15:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbiGMNxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 09:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236452AbiGMNwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 09:52:45 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2042.outbound.protection.outlook.com [40.107.20.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CDB2C12D;
        Wed, 13 Jul 2022 06:52:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsgpC7RkIM1A3AKlznaSkFJIGndkEpACUZZVF16voyeaqBVGFAT59IJdk/qcGY3C/bw00gkWrjzTw9gD6czyF5koA0JssQSCDrfdW7Pjr3aXeEpcOnQyOjlCMZS6NLibwGK3L/yanvagHrfNjYOyrLUgd24HAzQxhkM24JFiRmj/KezQCpKgdIwipBF/jkaWi2Nq/behvNlQmlfSBviANLcqxETBuOV5FkycvWAyxoU+aXdUjT7OFjHN6orIWaVqp6x68+Z4MQwXscjnnEjBZIU9l5l7tVdnDDxBfb2eDfDmoP8AK125fz3dzNVOwnRfzlmkvlVaxx1TEdFcwRCSwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yF24IXqYWvWlZbD6zmFf1dRj9zustWalBNss3N4AFag=;
 b=ELMn2ctXs0dYLWi9MdTwsdB0qebfDWeKlOnFAqLNgn4x3fXu6Rqbvj9NDpRfD+3/g/bzefK5iH/3ltDXs9sMWKIi/zyW9tgv3BPsVvziretaRgBL9OwvSBlDmA1GtP7B5ttBS3PuEYgIpvC7KBqdvWX3T8+ns8DI7+0ug90nxbMimoC7Mi5Pc4M3JB0qpAQ5QWKrUXUSlT8PS4XJzRHB+8PVjnHSeWdv5Ce9VyTJ6Kz9TnKquLGv/zCuoOKtDrGaMFfPD+gLl8MnMU51Mp8SWE8s51mFZSaCQbA00cck8szc9tgHg1pYBHK/Ywpaj7TknzUDsof/jmfmFKgG6Z5zdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yF24IXqYWvWlZbD6zmFf1dRj9zustWalBNss3N4AFag=;
 b=vQFcNxyYBe3QkvKmKAt8TatLuiUCzZgdrPsQpWdOh3v9PUhTtJ9UafSliwrGuecHrU8fW899Zq7KP8c5zQYA78Sa12GoB5ulzAzKGlVqpsWbpK5HGaIV1fsccRFPRRGXKqU3/N16bucDDdMdTSCqBw/hFrExeN0VOd43rTJ/oYUjdXJYwoYH4DsE7wPv2SVayMYT5yE9l1SHPcU/UFx08UiOFVZB/7wnGqXlDd9Ti+PvGc/6PoyuBUod24RUS2YHnrTXglSjAlhOUVPKAg/s8QTOPcV5GtoLY5hv4Ida8ASdJuXy2ujqB++gQrd/BErhSOe8mIUrR7oNmr6ngKP+Hw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM6PR04MB6040.eurprd04.prod.outlook.com (2603:10a6:20b:bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 13:52:04 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5417.025; Wed, 13 Jul 2022
 13:52:04 +0000
Message-ID: <dbfd3a14-781e-c66e-b11c-e21ba4134067@suse.com>
Date:   Wed, 13 Jul 2022 15:52:01 +0200
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
 <1d06203b-97ff-e7eb-28ae-4cdbc7569218@suse.com>
 <62e32913-cfcb-e0b0-2bbe-75cc8597951d@netscape.net>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <62e32913-cfcb-e0b0-2bbe-75cc8597951d@netscape.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR04CA0178.eurprd04.prod.outlook.com
 (2603:10a6:20b:530::23) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d43b685f-0701-4c70-cf9c-08da64d6de3f
X-MS-TrafficTypeDiagnostic: AM6PR04MB6040:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TA2Bqkv1iGE3wbf8K0Bs/JPizFxpFQTkuyWdv4P+GTbX2LYwoYsOzu23WXuRl8Z1f9zwlTJohfUCkJST1lflUZMrQLyS119W5Gll/3EVUucT2rdFD9M+G5DNNsg3v+RdV9pOA2jgrBTjt890vxoN4VoHFz2tReQJ03lC3lvujtoxqncGN4fClTBGJxohRJNUgK3mI5l5f/k5c04IuDPczQnSr1U6NtQ1fRJr2gVoaLIkTRsasuTaPRnizH1kFIkXYDV6Lquc+OO5gfg+eDWvc2pMN5pSJAgzGs2jzAH3GX3UOLISivKOga/uSoO558qTpJn69sygRjCqIlt/53UsePLf/T8eokrTlJRIpBEzA2CxcXrj4ylNaS1O8Z9Nb9yCDSbYl+dUiSqwGC7vR9rOTirXIXjO0vlR41nZUexla41wzxgA23+thEH8Sj6CTFEk+s7TXQth/0svPduHHbYA8w8po3JhNo0lKugc2zP4SF4lEOW27fNrwLLuDZ+tQlaGV012jVYREPo+Ul5fcQEZgaRJwVtLb5sOA3xt9M5HS2MuXx1C1EYmrIhJDyYOPPFxFSPRh/gfHdSAFTQJlsa6QSMAOy9O0pxgUbUxfRwsl4IV8U9XSgeqDNB1gcMdxmnc/Apt4KlTOcG9gVlRY1cdGHN2xy9tU58bo+ojQeXdmcokIj84bqFBy1/hMsVBHNXpwvOt8S3xPjWCf65KJFhfwc1OP/GUNqpdd1axahIIUv2zzJzBZGsVfACOPzX6KmjIdaT0F1OBy6LUtdEfWit42xAydpYaVTtMoWvLyJgcp1yaOGkif2qcWWLIO05eGaig2PLQiLJEzOPR1uPoWoLaHeXgnVfoMPymol+d8k1Kkbc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(39860400002)(366004)(136003)(83380400001)(5660300002)(66476007)(8676002)(7416002)(31696002)(6916009)(66556008)(316002)(54906003)(66946007)(6486002)(478600001)(86362001)(2616005)(36756003)(4326008)(6506007)(26005)(6666004)(41300700001)(53546011)(6512007)(186003)(8936002)(2906002)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTRFUVNwdEYwSnFic2swMXpnRUdES1hYdFRCemFzaWpsWmRBTmtyTi9FSUhV?=
 =?utf-8?B?WGlzMzFaVFdkRmVab1VQSXVOYjJpR1hKcjJnV1JkMmltcXVEeUpPMmkxNXg3?=
 =?utf-8?B?ZTBCUm9VckNqVWc5dGJvQWI2WWt6TTRyQUlHYlJMZWZEK1VnNUR3V0ZhUlBk?=
 =?utf-8?B?ZzJveVM1dFFlWXdDbWh5SGZaZW5xSENzaEs1NndhWHFQcEV2dFVrSmNoTDRH?=
 =?utf-8?B?RlFhWW04bDNvYWowMnBCc0JaTUdIclFKZ3BxcS95U3BQTEVwckNUQVZtdHo1?=
 =?utf-8?B?TkszZFVRL3VkUzNGcFlHS2xnZDNlZGxzOUNhbTZZaGRMUFQ5VGtzSzhxR0VO?=
 =?utf-8?B?OXRQeDhBamV2MzBDVzdJUEdjaytzZnkrRnJmUFl3b0tiaXhRS2lnRFRibTVj?=
 =?utf-8?B?U3pSdWVFV2NwN09ZWXhmeVFwbElZbzNzbFhxK00ydFNibml2UEZ6SVUzZDBM?=
 =?utf-8?B?bjd1NUxaMElzVEFiWVdONURqSVJFVUREZkFGR1Z3bk1ZOHlvUlNoZWZ4Mm95?=
 =?utf-8?B?WnlIbGhPdDNNaTVNVEZjbTE5Y2dOUkFxelZva2F4WGwwamhVUEtXelNNY2la?=
 =?utf-8?B?ckRwdExkbWNoRC81d0sxMGwzSDdmTXgzd2xaSlkwdTJ3dWozSk1naFJTMmhY?=
 =?utf-8?B?TW1meXVFZytXZ1UzMmdZNkwzV1R4OTNUMlRGQVZsVEtnNW03bDd5UnBMd21M?=
 =?utf-8?B?M2g4c2pvT0R0Rk1sU0pnNVl3ZS91RkVVWUNiQ2RQYTd0eUlwbmF2OUNEWXpB?=
 =?utf-8?B?YmFOamMxMHV4ZWFwYXAwVVNDbkxVS3JJcGJFaG15bitMWHFRelFpMC9DZDZL?=
 =?utf-8?B?cmpkRDJ0MzFZWU4yQzEwbi9hTUdFeS9UcmtsTWpFK294ZDFRU25NbXE5Z2JP?=
 =?utf-8?B?eGJWSHNuODQ2RkQ3aEpURkxXYXFkNEhGdDdKSkJaQWJaYjdhdW9HRVBRYzNs?=
 =?utf-8?B?eUtxMGJ1K1Z4eHlkMnBIYTFmZ1hyTitXZi9jYXFyU2ExQ0xTTExyMTBsMno1?=
 =?utf-8?B?NmRrSUNTamZsbFVzWU1wOXNCbmZSQzMveW9yN0E5bTByaExvdG1rSkdIKzcw?=
 =?utf-8?B?WEdFZDNUMmtRNGJoMDV3clV3bmxoRlhUR2paQkQveGpVS0xQUmVwd1FsMlpG?=
 =?utf-8?B?eDhaTWxIbFBSRkllMXk1Uk1DS3Q5TzAwQStaRnpDR2huWkZCRk9lY3p2dUIy?=
 =?utf-8?B?MFVBSmFPbmhUYWh2VXE4ck94eVptQStuR29hOXl4ODI2T3Z2bjB2S3dJV0gw?=
 =?utf-8?B?cGZMandrRDdkVVUvc0lGUkYrb1l6L0g1SHFNU1RUT3JnNFdNcyt1TFV3RHNW?=
 =?utf-8?B?S24rRmFLTndyUmc2cEdQaTJiNFZlbHUwa1NjeWd1cklrM2pKZERrNmRJL2dz?=
 =?utf-8?B?WlU3dC80aDJvL2VpWGkwSEc0ZUZTOGp1SFN3QXZNdkNZMm1TWUowQkk1Tm9G?=
 =?utf-8?B?N1IzcWpUNFBmbE4yUWFLNW5rc0ZwQjRsclJYSXVYRjFmVkR2UytVeUlmZ0Yv?=
 =?utf-8?B?Z1o4Nk8zOW5aKzN1R1NLc1FjVGp3R0RvNkRPM1l0VXo0bktkTXc3eU5UN0cv?=
 =?utf-8?B?MmJUNTdwNGJmMk9wRlEzRkZ3dHJOSmdEcTdXWU8yU0VhMVBOZXdiWkl1Tzdt?=
 =?utf-8?B?SnN1ajB0M3k3cUxOdW9qbzc0M1FxUk9IQ0UrY1ZjV3hZV0VqL3J6Qk1KYVFU?=
 =?utf-8?B?Qi8xcnZCSXRwTmhDY1J1WTFOUG92NHFhcmNoTnVuMFdyTEpYTWNzeUQ0Z21z?=
 =?utf-8?B?TFp0Lzl1OHhQd3VBSnJuckJuMVdpNW5lenkxL25leWRBdEF3YjZUSC9IbzRs?=
 =?utf-8?B?d0FXVE1GaE1xSVY5aEw2YlU2VURXQXJxc09ySTJjVmo3ZnVnbFg1ZzNkYU8y?=
 =?utf-8?B?V0E3L1FjTElOK05jbWZEblVhaDJscm1TZW5VV09SVVVzTUxHYjV1RWlEVXl4?=
 =?utf-8?B?a3JTanRWWUVGL24xbUovS1BVQXBHQVVla2Vmc2hvVm8za29TOGxVQ3RvajUy?=
 =?utf-8?B?cW52eFNKUDFXZU1xYlNYK0VDOUlwRXpJQW44cmpVcklZbjFlbW0reE93REtF?=
 =?utf-8?B?bVI4ajdMYjNvNEVEOGNJZ2JNZk9sWWg2WC95ZHBrRVY5N21BYkcrVWdHQ0hE?=
 =?utf-8?Q?BBXqE6/A2Vz3xlyvZnJDVaqB0?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d43b685f-0701-4c70-cf9c-08da64d6de3f
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 13:52:04.2255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NXnMhclZSUYYkdh36X8UyTMVtmJR38FfisCAgS90E/kjqVarrlR7bCje2iFk+cIvh6ICQVnHOV52nCL2aXmE+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6040
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13.07.2022 15:49, Chuck Zmudzinski wrote:
> On 7/13/2022 9:34 AM, Jan Beulich wrote:
>> On 13.07.2022 13:10, Chuck Zmudzinski wrote:
>>> On 7/13/2022 6:36 AM, Chuck Zmudzinski wrote:
>>>> On 7/13/2022 5:09 AM, Jan Beulich wrote:
>>>>> On 13.07.2022 10:51, Chuck Zmudzinski wrote:
>>>>>> On 7/13/22 2:18 AM, Jan Beulich wrote:
>>>>>>> On 13.07.2022 03:36, Chuck Zmudzinski wrote:
>>>>>>>> v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
>>>>>>>>     *Add the necessary code to incorporate the "nopat" fix
>>>>>>>>     *void init_cache_modes(void) -> void __init init_cache_modes(void)
>>>>>>>>     *Add Jan Beulich as Co-developer (Jan has not signed off yet)
>>>>>>>>     *Expand the commit message to include relevant parts of the commit
>>>>>>>>      message of Jan Beulich's proposed patch for this problem
>>>>>>>>     *Fix 'else if ... {' placement and indentation
>>>>>>>>     *Remove indication the backport to stable branches is only back to 5.17.y
>>>>>>>>
>>>>>>>> I think these changes address all the comments on the original patch
>>>>>>>>
>>>>>>>> I added Jan Beulich as a Co-developer because Juergen Gross asked me to
>>>>>>>> include Jan's idea for fixing "nopat" that was missing from the first
>>>>>>>> version of the patch.
>>>>>>>
>>>>>>> You've sufficiently altered this change to clearly no longer want my
>>>>>>> S-o-b; unfortunately in fact I think you broke things:
>>>>>>
>>>>>> Well, I hope we can come to an agreement so I have
>>>>>> your S-o-b. But that would probably require me to remove
>>>>>> Juergen's R-b.
>>>>>>
>>>>>>>> @@ -292,7 +294,7 @@ void init_cache_modes(void)
>>>>>>>>  		rdmsrl(MSR_IA32_CR_PAT, pat);
>>>>>>>>  	}
>>>>>>>>  
>>>>>>>> -	if (!pat) {
>>>>>>>> +	if (!pat || pat_force_disabled) {
>>>>>>>
>>>>>>> By checking the new variable here ...
>>>>>>>
>>>>>>>>  		/*
>>>>>>>>  		 * No PAT. Emulate the PAT table that corresponds to the two
>>>>>>>>  		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
>>>>>>>> @@ -313,6 +315,16 @@ void init_cache_modes(void)
>>>>>>>>  		 */
>>>>>>>>  		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
>>>>>>>>  		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
>>>>>>>
>>>>>>> ... you put in place a software view which doesn't match hardware. I
>>>>>>> continue to think that ...
>>>>>>>
>>>>>>>> +	} else if (!pat_bp_enabled) {
>>>>>>>
>>>>>>> ... the variable wants checking here instead (at which point, yes,
>>>>>>> this comes quite close to simply being a v2 of my original patch).
>>>>>>>
>>>>>>> By using !pat_bp_enabled here you actually broaden where the change
>>>>>>> would take effect. Iirc Boris had asked to narrow things (besides
>>>>>>> voicing opposition to this approach altogether). Even without that
>>>>>>> request I wonder whether you aren't going to far with this.
>>>>>>>
>>>>>>> Jan
>>>>>>
>>>>>> I thought about checking for the administrator's "nopat"
>>>>>> setting where you suggest which would limit the effect
>>>>>> of "nopat" to not reporting PAT as enabled to device
>>>>>> drivers who query for PAT availability using pat_enabled().
>>>>>> The main reason I did not do that is that due to the fact
>>>>>> that we cannot write to the PAT MSR, we cannot really
>>>>>> disable PAT. But we come closer to respecting the wishes
>>>>>> of the administrator by configuring the caching modes as
>>>>>> if PAT is actually disabled by the hardware or firmware
>>>>>> when in fact it is not.
>>>>>>
>>>>>> What would you propose logging as a message when
>>>>>> we report PAT as disabled via pat_enabled()? The main
>>>>>> reason I did not choose to check the new variable in the
>>>>>> new 'else if' block is that I could not figure out what to
>>>>>> tell the administrator in that case. I think we would have
>>>>>> to log something like, "nopat is set, but we cannot disable
>>>>>> PAT, doing our best to disable PAT by not reporting PAT
>>>>>> as enabled via pat_enabled(), but that does not guarantee
>>>>>> that kernel drivers and components cannot use PAT if they
>>>>>> query for PAT support using boot_cpu_has(X86_FEATURE_PAT)
>>>>>> instead of pat_enabled()." However, I acknowledge WC mappings
>>>>>> would still be disabled because arch_can_pci_mmap_wc() will
>>>>>> be false if pat_enabled() is false.
>>>>>>
>>>>>> Perhaps we also need to log something if we keep the
>>>>>> check for "nopat" where I placed it. We could say something
>>>>>> like: "nopat is set, but we cannot disable hardware/firmware
>>>>>> PAT support, so we are emulating as if there is no PAT support
>>>>>> which puts in place a software view that does not match
>>>>>> hardware."
>>>>>>
>>>>>> No matter what, because we cannot write to PAT MSR in
>>>>>> the Xen PV case, we probably need to log something to
>>>>>> explain the problems associated with trying to honor the
>>>>>> administrator's request. Also, what log level should it be.
>>>>>> Should it be a pr_warn instead of a pr_info?
>>>>>
>>>>> I'm afraid I'm the wrong one to answer logging questions. As you
>>>>> can see from my original patch, I didn't add any new logging (and
>>>>> no addition was requested in the comments that I have got). I also
>>>>> don't think "nopat" has ever meant "disable PAT", as the feature
>>>>> is either there or not. Instead I think it was always seen as
>>>>> "disable fiddling with PAT", which by implication means using
>>>>> whatever is there (if the feature / MSR itself is available).
>>>>
>>>> IIRC, I do think I mentioned in the comments on your patch that
>>>> it would be preferable to mention in the commit message that
>>>> your patch would change the current behavior of "nopat" on
>>>> Xen. The question is, how much do we want to change the
>>>> current behavior of "nopat" on Xen. I think if we have to change
>>>> the current behavior of "nopat" on Xen and if we are going
>>>> to propagate that change to all current stable branches all
>>>> the way back to 4.9.y,, we better make a lot of noise about
>>>> what we are doing here.
>>>>
>>>> Chuck
>>>
>>> And in addition, if we are going to backport this patch to
>>> all current stable branches, we better have a really, really,
>>> good reason for changing the behavior of "nopat" on Xen.
>>>
>>> Does such a reason exist?
>>
>> Well, the simple reason is: It doesn't work the same way under Xen
>> and non-Xen (in turn because, before my patch or whatever equivalent
>> work, things don't work properly anyway, PAT-wise). Yet it definitely
>> ought to behave the same everywhere, imo.
>>
>> Jan
> 
> IOW, you are saying PAT has been broken on Xen for a
> long time, and it is necessary to fix it now not only on
> master, but also on all the stable branches.
> 
> Why is it necessary to do it on all the stable branches?

I'm not saying that's _necessary_ (but I think it would make sense),
and I'm not the one to decide whether or how far to backport this.

Jan
