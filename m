Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BAE575F19
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 12:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiGOKHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 06:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbiGOKGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 06:06:23 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2084.outbound.protection.outlook.com [40.107.21.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FA985D48;
        Fri, 15 Jul 2022 03:05:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0m/otbQBR1z3RHKxAh+8yj4tIfez70sYAJeNhDORekLhW8/J/+3Gi8eSUMb56j7CJgTkJ4JWionkd2bskFFCNSK8L05kBD2wobP/L0ETblncWDhldBSGnQcez/BYbkeKbA9Azq91xhFOxyzKscLBAjt1ugOzC5zCgEyWcH+E8gRZcRy06WiPWnTh4i4+pyiQK581ekd/9PjN+7Y7fWxqheBKdppTje+C2QkpL32D+MS+yy/O2cPG2QNVYj+pkjXbyyaPbE7B4ORs05oMXRnkoJ5lsyh6ByF1ByRyZqt3aVnSr4Vh5AsDko8mrmt5VCiEM6J+1ic06V0agV62BEc6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F75NRxR9MgeTn5EeqhVQIyF7+ur8NDOgRsR5SJEcsqI=;
 b=ETPzDUB8LgyO1eVOwvYc4GLvLoxgGTbNFH2ulPp0jDoLCdAMuOuMUyXxSLAnIJHG/omo96Mr2gNDiUIleyK2XtL8R3WysJyClAU1f/E5xZbBr0AuVI9bZIdgwZrP0Q+oEu/hKrkZNgTvI38CeN2XzVX/ZtUxz8D01/nXDYP9KcX8kus5lpDZn00WuL848ir/WhY1ev2scZZhbbgyYm95RueSqd0dlyPuDS4TxEi7G3PgSWk78YmzDEPrmn5p2tpkF2iBODoV65ZZrAf3cFiOFaWBwt5WWykiYEqOLnEhgvtycEl9iSfkIX6pZBcWaL+KBfUNhgrKiqM6fxMnImJOgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F75NRxR9MgeTn5EeqhVQIyF7+ur8NDOgRsR5SJEcsqI=;
 b=WdNO32ZJxxebqYmT81MGcXnaLuUPnKhuOd+TRbr5Z5PonUhEKkPoHi6SMHF+5WMLGJw4YZk0pVWZe8+dqxF0RXg2myfCkbShzaVN5xGxgM1vG/B2vtrcofdkBgolZT6Or47le8iK3pD6MTH5iHSne9htUY3KTsjyCfERmkyeZz52tzZ0sO9i0CIPSpCWS2LKpKddIblT0I1NyunKGqIDEWh6bPTPMKXmTeX3tnENhNRGAwPzFVaZ8sEdUfzQnDeCJk1NL9m8wGFHO2hBY22vvrFrFsOGcvuchIDBzHu+70S/6f/zOeFKskLohlFlCF63X+kmSdBPWC2x+K79IsBMiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AS8PR04MB9206.eurprd04.prod.outlook.com (2603:10a6:20b:44d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 10:05:42 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 10:05:42 +0000
Message-ID: <d3555a74-d0cb-ca73-eb2e-082f882b5c81@suse.com>
Date:   Fri, 15 Jul 2022 12:05:39 +0200
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Chuck Zmudzinski <brchuckz@aol.com>,
        linux-kernel@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <5ea45b0d-32b5-1a13-de86-9988144c0dbe@leemhuis.info>
 <56a6ab5f-06fb-fa11-5966-cb23cb276fa6@netscape.net>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <56a6ab5f-06fb-fa11-5966-cb23cb276fa6@netscape.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR05CA0010.eurprd05.prod.outlook.com
 (2603:10a6:20b:488::15) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18a1ce87-d6ed-421b-ed42-08da66499398
X-MS-TrafficTypeDiagnostic: AS8PR04MB9206:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bEUb81t3iRAnc6GagpTLOd5WGjTqdcLOLaDkw/hooa4w4/LziT8n6BdLwtAjSDtyp3LTzHvvCAAg4svqkhewQzEtu5w5jceNYU3ujHQioL85BAxFhtpi5KCzM5AZErOY8Db5+zHbYC3ibcKB7IOHkBR1ndmSGZfkizoNWcPNLYo4pyF/miTMnR3sQCdUaQznnrmDkBU3PXAGkDCnehseL5mMAUw23uKpgAyRrvT4H8gHVlvuWugra19bbm4f4RaFnX6Lyt9PuzO/GiKL16+dNr3v3ff2jZHoRJhhPAKVzHke5N4u+VRI0srhOgpV3nK88bFStGYloeLsZlS+pyfLyF4UjeOnDeuTTfg6a4+pD/RVxm569gz+9QxU8sspuHkss0KsSye4S0/pT2orY9ate8tJlr2asQfJ05ktHiIGPUnz5V0HmvJA/BCdTKNyvihOwsfV4PW6IkD2rx6WNSVA0+TUSFITkLdp8soErsPair7Gb/p/3JNqb9rpc2ct1eDDz08TzDa2XjN5O9DnKUVCfl5NWzjQhf8Btn6CTj7I35MKVnc7tAp29ti+XoCvDbGSShzWVwHN4ALPsE7Zaugypdw+6f+JwkTJAAjepG3zdiaq3CwF5/5YQsgkLDYTni+Yw5AyoQRTy+uDrK55Zm7ebm/IOE74N1KKWO6QnpN8ZSXKk3Me24qxk2V4LSxr0iICSH5fRtrDrKpLlKEWkmvZI1WCqOkFaliv+k2n01v95A/+kNG8JZzvf3Y03cLML3Z27sAFhTgLLCzEtIu9KvpVGiQJjY0bCXA0Qpy9KdH4k8Zo297sP+wpazo1hDQMx+homnfzymqOec27SRjnMMMD8ep9x3z5iEt8yEk0fXxOm0Zv2LBq8SA6XQfpEfbVzjjB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(396003)(39860400002)(366004)(136003)(83380400001)(6512007)(2616005)(36756003)(86362001)(186003)(478600001)(6506007)(54906003)(6486002)(53546011)(316002)(41300700001)(8936002)(6666004)(26005)(66476007)(966005)(8676002)(2906002)(31686004)(6916009)(7416002)(66946007)(38100700002)(31696002)(66556008)(5660300002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWt0dWFxQXVnb2E0eXU1WHk0bjJCOVkwcThrQnd5ZURrRUs2TWlYN01wdzRU?=
 =?utf-8?B?Rm13TG9qTjUrR3hCVzQxNlNzMUFoaS9yY0JETEg0bCtuQnE0Y1FsdlFjZ0Zx?=
 =?utf-8?B?RE5Wd09acThEbmowVlFlTGF5Vkt5ZHVBZkdSc3NBOFVzRCtDVFNLa1ZTMHZZ?=
 =?utf-8?B?Q0k4VExhYmNuSXFPUWE2YVVOdDZmYllnN3ZHNW9YWDF4SGRwMEswNktXTGRY?=
 =?utf-8?B?ZHVwQkFLN2FUWTJsdzJ3YjErbXo5eXg3Z1hoc0M3QjVVYkJ5K0gycjMxeklZ?=
 =?utf-8?B?enY0YUdtZTdoTS9NTzY5d2VXNkhNTm93OEtLT3djQThUbjJVSmhIYVh6bWFM?=
 =?utf-8?B?bG83QkVTZEpGK21NQVVmVWZWanRDdjNpWkErc0E1Ym5DVlF3c0VadXd5QlMx?=
 =?utf-8?B?dGZvR1pEUHhBWThsYXp6MVhiWThVVy8zQnkwSTRkSG1pQ0hCMU5sRXpvemYv?=
 =?utf-8?B?bWxJcDA5QXBPTnZqTVFuci9MbXZ4L3BDM1lxUlUwd2dST1FNK0VVYi9WVVpU?=
 =?utf-8?B?TFU5STlWMzV4a1IvdVp2L2RzSC9maHA2bkRGTUM1ckRUWFlndlBpSmxnWWQv?=
 =?utf-8?B?c2o4WGpma3ZUWWlUMittYTZMTGtqa3lmdzVBQ0lpT0dua3Q3R0lFTW9naE9T?=
 =?utf-8?B?REF4enI0L2wrS1Z4dlVWMTJhbFM0OCtzeG9KemhXQXdlUmdINWtHMG5RV2o1?=
 =?utf-8?B?ME00enRTZUdHNjJjZnFKTFZrSFpKWHRDVU9IR0FXSXVjUVhqZndFaFE1Tk5o?=
 =?utf-8?B?bENOZFd4V2IzK3ZwaUI0MWROY01BUXdQNjVzaXpERkdKOTJCNno5TTFLT0J5?=
 =?utf-8?B?OHlxQlh2aUhyZ2t6VjYraGw0N2tQNjZwUEQ4RFAzOWlkTGtlQjljNHc3ZDIr?=
 =?utf-8?B?WFN3MXVORkpDVyt5OFFER2EwQUtSdWNVempZSm1pQll0ZlBSRFZ1UDNFRGhs?=
 =?utf-8?B?a3g5TkhzaDVhSzBxVG9zZjFwMUwxTGQ5U3F2MEJNd3dscEZpdGVUeEh3YmtU?=
 =?utf-8?B?ODUzT1UrRmZ0cFRTM0JvOXNMOHhVWFhSb2g4aHkrRjBXUW90TEtiN3ZwcHVP?=
 =?utf-8?B?OStwQmZqZmJTS0VML095elpsRXVVNDJjUmNOMHpTSGNyMWlJSlpMWDBiN1FR?=
 =?utf-8?B?ZEErdlliVUIwakZ0RmdBVzljTi91UC90aEZQc21nYk95RDBPL2phUHd6VU5h?=
 =?utf-8?B?ZVdpdGREU3dJQVhTVHo5TURnL3V3a05LUFJCSndsWnE4eHpoc2U0M1JxY3VM?=
 =?utf-8?B?T0ErS3hLbVZ3WGEwYmFWTGt4SksvYWxQQmx6cE5rUFV3Q2pBbnNPcjR2STh6?=
 =?utf-8?B?SGNiRWd0ZVhoWkJxbTZ1bzl2aVp6UWZlTXdoR3BwT1BDUVU2Uy9rL1dEb2ha?=
 =?utf-8?B?TFJoUmFkL0hQeHoxczJMamcwTDI0TE85S3htR0c1S3hmWkhOVDA1bERhUk51?=
 =?utf-8?B?ZGdYTnBjSW55RTJqanZOT3NPMWJYWnh3N1JHQ0dyeTk0dWZYak9jTlBKYU14?=
 =?utf-8?B?bHFNZllHTkxqNml6dkxlZHlaK0owTUtrREw0eXhIeEIvbFRuelVoa0dvOXkv?=
 =?utf-8?B?QVNEbU9mU1VXV0d4ZTNaZ3ZTVWpUekpOR3Z2eDcvRHZoRC9vcURxdjcydFRv?=
 =?utf-8?B?OHJ2VVFFWm9nQUtDSUFQMVh4a2RLSGN2V0ZBSjFleERtZHZaRHlWL0JRWjJK?=
 =?utf-8?B?ZVNIYXNUMnN4TGNQUEVlWlB2ajBzY0NtWERNbnhQWXFxajNRWXpPbjFaNGp6?=
 =?utf-8?B?Wk9PV0FxM3hrdCtCOEplM1pITkJVbUxnK0NWcm1pM1Vjc0hpNFU2Nk13dGtB?=
 =?utf-8?B?OVFQN3owOXFlTnJyVEZDeStWc2lDVFAvc1RjRDdGaXlSM0ZEamdzNm94bnFv?=
 =?utf-8?B?Nlo3b0pPQlVMNGFBYzVUa05Qbml4SGZLMGxqZlNvUjhlRHY1ejBRY0FrWHNX?=
 =?utf-8?B?T0huZE1lMkVEU0VONjN5K3E5a2x3cVFOWmI3d3g3WjUyYjZ2U3hrTTJuMEVv?=
 =?utf-8?B?WS9QR2ZNRERoLzY0S0xNMjI3VitCdmo5MEZxNmFLTCt5TUFwWEt6blF0Z1FC?=
 =?utf-8?B?a2FiaHpRanZjWmg0RENYaTV4T3c2REd2blJ5cFlEUTA1dGhJQjN5d0VnU0Zk?=
 =?utf-8?Q?Jtg59MIAWfjrR3y706AuS76gI?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a1ce87-d6ed-421b-ed42-08da66499398
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 10:05:42.3608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Odorhk4LqhFbyfoSR8HvULu7T5DGTUViViGBL6nr/hiq7jw8Knki+I/xt4e6pDnNJQx9axKFkeUmd+vLtBNFRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9206
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.07.2022 04:07, Chuck Zmudzinski wrote:
> On 7/14/2022 1:30 AM, Thorsten Leemhuis wrote:
>> On 13.07.22 03:36, Chuck Zmudzinski wrote:
>>> The commit 99c13b8c8896d7bcb92753bf
>>> ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
>>> incorrectly failed to account for the case in init_cache_modes() when
>>> CPUs do support PAT and falsely reported PAT to be disabled when in
>>> fact PAT is enabled. In some environments, notably in Xen PV domains,
>>> MTRR is disabled but PAT is still enabled, and that is the case
>>> that the aforementioned commit failed to account for.
>>>
>>> As an unfortunate consequnce, the pat_enabled() function currently does
>>> not correctly report that PAT is enabled in such environments. The fix
>>> is implemented in init_cache_modes() by setting pat_bp_enabled to true
>>> in init_cache_modes() for the case that commit 99c13b8c8896d7bcb92753bf
>>> ("x86/mm/pat: Don't report PAT on CPUs that don't support it") failed
>>> to account for.
>>>
>>> This approach arranges for pat_enabled() to return true in the Xen PV
>>> environment without undermining the rest of PAT MSR management logic
>>> that considers PAT to be disabled: Specifically, no writes to the PAT
>>> MSR should occur.
>>>
>>> This patch fixes a regression that some users are experiencing with
>>> Linux as a Xen Dom0 driving particular Intel graphics devices by
>>> correctly reporting to the Intel i915 driver that PAT is enabled where
>>> previously it was falsely reporting that PAT is disabled. Some users
>>> are experiencing system hangs in Xen PV Dom0 and all users on Xen PV
>>> Dom0 are experiencing reduced graphics performance because the keying of
>>> the use of WC mappings to pat_enabled() (see arch_can_pci_mmap_wc())
>>> means that in particular graphics frame buffer accesses are quite a bit
>>> less performant than possible without this patch.
>>>
>>> Also, with the current code, in the Xen PV environment, PAT will not be
>>> disabled if the administrator sets the "nopat" boot option. Introduce
>>> a new boolean variable, pat_force_disable, to forcibly disable PAT
>>> when the administrator sets the "nopat" option to override the default
>>> behavior of using the PAT configuration that Xen has provided.
>>>
>>> For the new boolean to live in .init.data, init_cache_modes() also needs
>>> moving to .init.text (where it could/should have lived already before).
>>>
>>> Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
>>
>> BTW, "submitting-patches.rst" says it should just be "the first 12
>> characters of the SHA-1 ID"
> 
> Actually it says "at least", so more that 12 is It is probably safest
> to put the entire SHA-1 ID in because of the possibility of
> a collision. At least that's how I understand what
> submitting-patches.rst.
> 
>>
>>> Co-developed-by: Jan Beulich <jbeulich@suse.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
>>
>> Sorry, have to ask: is this supposed to finally fix this regression?
>> https://lore.kernel.org/regressions/YnHK1Z3o99eMXsVK@mail-itl/
> 
> Yes that's the first report I saw to lkml about this isssue. So if I submit
> a v3 I will include that. But my patch does not have a sign-off from the
> Co-developer as I mentioned in a message earlier today, and the
> discussion that has ensued leads me to think a better solution is to just
> revert the commit in the i915 driver instead, and leave the bigger questions
> for Juergen Gross and his plans to re-work the x86/PAT code in September,
> as he said on this thread in the last couple of days. This patch is dead
> now,
> as far as I can tell, because the Co-developer is not cooperating.

???

Jan
