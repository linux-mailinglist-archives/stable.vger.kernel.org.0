Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A2E572E0A
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 08:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiGMGSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 02:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGMGSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 02:18:13 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2067.outbound.protection.outlook.com [40.107.21.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359EDC08FA;
        Tue, 12 Jul 2022 23:18:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zx9YaJZvFrwrhnAdf5cj3aZKu10jI9rD/SlIT38tlbaR+cK2FZDksxxfcbZfQnUcBvk0lNNcP27ZI+M3D4iWEe295Qz7ZqVkQxQ4x6pZjIng93OHuohpKTDFeEYkcIEsxywE8VXIOf4R9Iall3ceTcs5FgL7H8RLURyjXVAJ8N7KSNMeSmnOyX2Mxsurf+rpQJDLQhPi+K8ELknqjHt443OYTX2OwC+c9OxjYEjMnyXYtR7RynIuMyw8NrLllPhdezLEL2MndZ6wiMlR4TjbWhYHia81nc0cqW5w+WNALbf6SsFU5DcmJDS4d/k9sE3paDhFIjdmvDZRaTFh6hvWPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mGf2VtS2XfS4FW9gt7nfASnSt8IWDWM5M09W0hzIawE=;
 b=lFaPlFz00w3zuDrfbzDlfdTagPvkktBzA1FSEt2DW3l1MonLRMJZ7NS/XEg1/GR1yr48V7FJw+mG+z7+A6xhrnOdJtQVGt6i8ZKal5OwzQvOdTyCtriJUWwYRGRu756UEkYfLkg9sUcmQOg9z8G1R52eleTbJoz2+ODizoH40VMlsoD3GjB3ojbusfgJVAKZTnS+ar9EKe2twwTsMQzrteD+P70V0EnShxdzf6loohHox3RggGsqU38kH2d0rpentI2bqCHD81OUnRfwvUFIwUJIZu6DKGoYsT16xrbzSqp3Zf5go4fzPN70mZ736AV8fmcP2/vXN1Belw1CIhtlNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGf2VtS2XfS4FW9gt7nfASnSt8IWDWM5M09W0hzIawE=;
 b=JOj1rsHWPVHDkKitNZMyH+HQB7ejBjwS4bLp0Mu99WDnxZ41VH5CDkaHq6glBjZQh2p6TTtmRsaHfM+vy3QcGiyo3jJYiY7GQsyLBArdJ1eu374SZHCT3tHjljdNOz0cFDM/mJCA5gwRgW5mAgA+YP9/JaQJul0m98PoSs/LbtIN08jlLwsxNUmSylTtyMo1Ir7uJ0qND73cd75nr2YzfiK2I6wSOMUILOsRBWjCmnVolyNv1x0zjUKwOnJmH5/kmohNv/JBUaD2Zk+OeezJZMBR4AXskiw1oI0JkpfQVesEvTrk4x8SPXjp+o9TEMah+9Aa9Q95Gc4gER3fGqGDNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by DB7PR04MB4892.eurprd04.prod.outlook.com (2603:10a6:10:14::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 06:18:09 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5417.025; Wed, 13 Jul 2022
 06:18:08 +0000
Message-ID: <e0faeb99-6c32-a836-3f6b-269318a6b5a6@suse.com>
Date:   Wed, 13 Jul 2022 08:18:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
To:     Chuck Zmudzinski <brchuckz@aol.com>
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
        linux-kernel@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0653.eurprd06.prod.outlook.com
 (2603:10a6:20b:46f::33) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af25e754-b29f-4d9b-e49d-08da64977493
X-MS-TrafficTypeDiagnostic: DB7PR04MB4892:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zEukMHj6TqsgD326RWoDXEaExZKN0mU77UrAXftHhpledUW9smQcu7xlJOd6yT4fTsTbVmJJaGZ+ios05+7sPkQ8A/AoOmjRB5O3UYDq59/iWXBQf8/EKTaIbsfExL3NO679IgzodChsg/qMs9xmn/Qnz1jLRUdCpnzIGCNY4OKzJERhg8gfor4sI0A6Mg06KTZ21m0G3dve4M+hanz/exJvnO0b8MKE9meBa/gBNsysiJRLmBjSzn38pcg1+udTaB/XHkpgcS4utizF0zP1A8UuoK08ini1BoDADGY/p28PXuPwq2MTW0unZSaPUaj/feGuB+yt2pJ1/GkpMkAMcpSY5Vkw3iO2rsYCHcYDof5euHEpsgnItgfLCmyYCGP9USySpE1BGOa3x2KR66rQv9EoZMZLeNcdDAJ/EnwMFhsVivo7snlUf+HK6JXNUjXAaEf2IaE5v6hBY+IeRddJtHoUi1l9ek2cKSpOeg52cA+pynKMgRZM+X42FC04Wp1+82LJQ5zqxLQZEBZYfVc8WVqVPRQTzu3EWmfE08qhiSWxXpWC8bITD9YL1rzyIIMpEPIX3h0EjHhWUd0ElbkepLIwB3ts/NWIHDtmljkwdcDPqqrYpi6ezXpN6MMt2kGUlr3kM/bBeI0T7re99UPLsVIgappUeYAmPglhbaN/P+Ff1h6lxgpFnexQwGAJ/uJNvgSBIlhK3ZNv7u57fDdscn2rpbsl3MeeeSo+mr6WBRpqQxlyJdohgJqrzshBWxIjjihw91rwTBu2yfkkxOTQqMl9aTA1z8k1bv2UxpK30N/+FKiUXKrjxMkqC5N3EwpDUp+idB+MW94EGu3AUm9sCScfQCnsouuegJFIMSOsKmQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39860400002)(136003)(376002)(41300700001)(7416002)(6512007)(5660300002)(8936002)(6666004)(31686004)(2906002)(83380400001)(53546011)(4326008)(478600001)(38100700002)(6486002)(36756003)(186003)(2616005)(86362001)(66946007)(8676002)(66556008)(66476007)(6916009)(316002)(6506007)(26005)(31696002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2lsVDA3ZlpiQ202TW45QnkvQlFVMGxUL0pWUExmWFpoQ3I3WkR3QzVTeDF6?=
 =?utf-8?B?cDRPL0VtcFZpcWl4N0VRL3NlL0lURDh4azY5a25JbHRWMkJsMVZOWGlSa2gy?=
 =?utf-8?B?bDRzUCtjTDloaWdHdDFWYjFkVC82bEVXOURMVWdlRm8vMm1ZQ3NWS3ByMlN3?=
 =?utf-8?B?NDlMcXU2bzFrZzdicERVRXd3dnhBRUI3dklqWlkyK2pUaEVyVHdLOFdwd05D?=
 =?utf-8?B?TWdyTEF4WGtiRzQ5VE1WMjlpaUNpNEFINkkySXcxS1VmRHZJMzA0VjRzelhj?=
 =?utf-8?B?aWpOQzYyMlVVektLMTBzaitTZnJPc2xzdjVGRmRSaDBWVzllckIzaVRMWG80?=
 =?utf-8?B?T24xRVJIdUlPVkVNL1VBeTlYY0JEV0Qwc2ZHemxzdnBoeTFEMjl0UTVqNW5O?=
 =?utf-8?B?UjJDN2dHb3ZkL3dRdmk5RVI5NjlzM0NqU2lpLzYvK2o4N3p5cFlaNmJzYTZr?=
 =?utf-8?B?b004ZkNkVmdmVGtWd1ZjSmpMMC83YzBMVmFPamI3MUdFeTNrMG9IdTdna3RH?=
 =?utf-8?B?eWhwdy9YTDI1TGl3bFgzTWhJVVd3aUY5eWFHbjR5d25BYWJIdU42aUFIZE1t?=
 =?utf-8?B?Q2k2V01UMTJWd2dWNUc5Q09MOXUydXRnUHNVR1J6YzF2ZVVIc0RCM29DdlZ5?=
 =?utf-8?B?YkhOV0kxUXBTRlVMRWFJcGZKSVc3bXpHR0E4NE0wR1R3Nzd5aG91aEpSUTRv?=
 =?utf-8?B?WFl0am5RUi9rZ1NHS2xPazZZVnpxMmttd1RJRDkwaTd2TjhhR2UySEQ5emM5?=
 =?utf-8?B?RUFyYWxscG5uTHNMWktpaW9SWTlPbEhxSTY0UWNtZzZlQnRrOUk1RzV4WFdS?=
 =?utf-8?B?SC9zYnRtOWpPVUdJQk0vTVZWdlJBUW1hb1NDYWNQUC81VjIxSUJLUmE2WUtO?=
 =?utf-8?B?czBVVGdQenBjeS8rZW1ZdEpYaGljY1lGVkQybWtYdTRxNE5PcDZUVFpzcUhO?=
 =?utf-8?B?ckNTN2NyTllWNUhBNFVVWUJpeHc4VThXc3ZURUxYWTRuR2plbGp3MS9nSGc0?=
 =?utf-8?B?SzhGOUJKTS9NWlVQQjIrbDJ6dTVDWUZ0dEhQMkNHUENQZE9EVjEwR1pZZ081?=
 =?utf-8?B?WXd5bGJZRzk3VTZKci9jTTNlb012RVpVNUJpVUdEYndPZFFRK1VvT0tVUEd4?=
 =?utf-8?B?bk5jaW8zQnI2UU8yQUR1c1F2YjA4MFRvMzdXckN0REs2OVRkUTc4OUI1RHRZ?=
 =?utf-8?B?NXNRdDZCd2wvcTdnaEl5L1JzUE1mZlBzL2Jod3RjU0dZMThQM3c2ZEM0cE5r?=
 =?utf-8?B?K0VXNWN3QW15VnVSMENNVEVnTnJ5QzdjNHFhQ3MwMDUzdWY4Ynp5clo3OExD?=
 =?utf-8?B?L0hXc1BCZS9XbllWRUwremhOVjNNeGpaYkgrQ2htNFlzcDJKWE1vdmNQSlN4?=
 =?utf-8?B?MmhIdlRsNXByYk1sSndFeUhDdS9ZdnRSU01rVkg0OTZyYW5MV1h4UmlzS2pD?=
 =?utf-8?B?ZU9CV0FjdU1rRkp2Zm5ndWNVRTlFUlRDUFdBSzAra2EzVE9hQ1MzUWdQK2ZJ?=
 =?utf-8?B?YU5rR05LeXZNYnk2dXlVN2h5K2krNzBiRUJ0NE42RkJyc3ZkT0tmeHZ1SlNY?=
 =?utf-8?B?M2M4czRlaFVGdTg1ZE0wNS92ZDkwTDl3L2NXcE9SUS8rSDdod056UEFWclQ1?=
 =?utf-8?B?eHZvanE5Qkw4VG0relBEVlZlOCtNSE40ZlNTNVQzVnBKZGwzMWhCcVg1OXNN?=
 =?utf-8?B?Nyt5VTgrS1J0TTRtVWJUN2pkdk8rV0tWdUswTmlvc2Q5WEZDTkdEVFo4KzBp?=
 =?utf-8?B?Mzh1Y2QvenJpL3hSRWxaQ3drZG9UaUV6aUY0UUdjZmpwWSsvYWhUN1A2UG1E?=
 =?utf-8?B?ZzZQbXRZUUkveGpKbTRGQnM5Q0g4OHdrcFBqanU0TmgrOTJiYk9RSTBwOGdK?=
 =?utf-8?B?VjFXMjRFeWpWVnBwaEltVDk4b1hQdURScEp1NHFUZXZRYWkrVldpcCtLQS9v?=
 =?utf-8?B?RDZwclh2cS9rb1kydnlJUFRLSHVIa0N1SExlVmp2djBvNzAwWFI0UW1FYTgx?=
 =?utf-8?B?Q0x6SkxXUWFEaU44UEFNSW53aTlvQm03RHdWR2NZTTQwbHZWOVVRa0FxbEs3?=
 =?utf-8?B?MUQwaEtZaGJKU1lLcWs2Z1NoVWQzUlAzYzBEVmZaQnhOOWEvVmxKSWg2WWJh?=
 =?utf-8?Q?X1xld6PWszTA4VYb1TZk29NGP?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af25e754-b29f-4d9b-e49d-08da64977493
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 06:18:08.6441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +w/j5yjxr17wQz8KWanpBaKeMFDFLqo+mWLUqLm/BpOV0Xzg5i+k8gC5iTI01a9Rnb2jtAY1b4Vjnd9rACI24A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4892
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13.07.2022 03:36, Chuck Zmudzinski wrote:
> v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
>     *Add the necessary code to incorporate the "nopat" fix
>     *void init_cache_modes(void) -> void __init init_cache_modes(void)
>     *Add Jan Beulich as Co-developer (Jan has not signed off yet)
>     *Expand the commit message to include relevant parts of the commit
>      message of Jan Beulich's proposed patch for this problem
>     *Fix 'else if ... {' placement and indentation
>     *Remove indication the backport to stable branches is only back to 5.17.y
> 
> I think these changes address all the comments on the original patch
> 
> I added Jan Beulich as a Co-developer because Juergen Gross asked me to
> include Jan's idea for fixing "nopat" that was missing from the first
> version of the patch.

You've sufficiently altered this change to clearly no longer want my
S-o-b; unfortunately in fact I think you broke things:

> @@ -292,7 +294,7 @@ void init_cache_modes(void)
>  		rdmsrl(MSR_IA32_CR_PAT, pat);
>  	}
>  
> -	if (!pat) {
> +	if (!pat || pat_force_disabled) {

By checking the new variable here ...

>  		/*
>  		 * No PAT. Emulate the PAT table that corresponds to the two
>  		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
> @@ -313,6 +315,16 @@ void init_cache_modes(void)
>  		 */
>  		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
>  		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);

... you put in place a software view which doesn't match hardware. I
continue to think that ...

> +	} else if (!pat_bp_enabled) {

... the variable wants checking here instead (at which point, yes,
this comes quite close to simply being a v2 of my original patch).

By using !pat_bp_enabled here you actually broaden where the change
would take effect. Iirc Boris had asked to narrow things (besides
voicing opposition to this approach altogether). Even without that
request I wonder whether you aren't going to far with this.

Jan
