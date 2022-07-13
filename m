Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644C457321B
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 11:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbiGMJJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 05:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiGMJJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 05:09:17 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30056.outbound.protection.outlook.com [40.107.3.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A628CC8F;
        Wed, 13 Jul 2022 02:09:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aR4mXd7gjCkKbc4oBA0V5I30QM0FtR91VYDCZMEXzTH5DrgqKdjWGACKIdJVao8+ukH3/1sWGe7YJtrG/7t05r8sJRdLWo7XjWVMJt4CXzh7UegJ5wd3cgT5T2nKl3pcFr6+wxDyA+DmtKvmXQUw2oWy6mIHqoKbNnTN2OxtBUXYD/aGNYwfWshThurROlG24KCJOzFpVsR3FnEITtwQSDFMUMv4QBly+X3Ke64RqaC/RfZ3jvoZQvp1Mi/mrvavwpfE4jny3aQeBVdAogQTFwiPc7sMyhirvrkC0zhMkfgql4gu6ORB+WcFzz5Locd9UJtQtcZ9NaTM7ElXZY6pDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+5BeByCAvhnJPAdbRxFkwRX/efyDeJVoskJ23RlZaM=;
 b=GdvnY7sb6YtsA87tTfr6D5uA1WaKcMg8Db/NBBksMvd9P8JQfojMaeIpnBxmaQd0VfZpR+ul+ifkXkPRDk3Ut+TsujRFHf1qmfkPI8wksyuvlmL0ySu4xuVd6U6QGhbd5Qp9eGnayJzzaDR1wSMqwdQaFWSp3RO2IXqYbpjTz0Q9a8ksINXGQaXHmC07ZJJ1WmCnulHdn9iYVXRNweHhvI+ceeIU/Zre2vusLy+rrFgvfhRAZZShrVSg2RasBV8HYdvz0nwxJDXoiLaS/j8631U5nUPrkE0hFuGcI4stYmq/bi4qn4pgYTTwwXURSQxGWSMdnv6heydsFcbnl+72zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+5BeByCAvhnJPAdbRxFkwRX/efyDeJVoskJ23RlZaM=;
 b=ZDbNagrx7eVbkewDCpUhu9TyVr3ATr3qknrF/utLGGoaza1lNMgSQUFl+dVEQKGys/IFGVFq5QGullTy+JBEmypcgPE3/Dnbd1uAbrrlCw9s3pApU3O/z8iC7cWuR26WSlc1IwUHJ7IkDGSG1Jt5ifiS5JlGd6CitkX+RxKxMEpjqULHN6kLRbroDVidc4GkLRWTinSwE/zxUQYUAfSQ3xN9M4s44+7iPrmyA+k3DY1AfNK8gMCVRMiy8NdlAP1FQnlj988rq7YkSIk9Q5NcXp4AQDObv9Dp8oPePNCOkrWzfAEn729PN3wG0fZv62/LepLz0MdjwtvExXezD3uLtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM0PR04MB6689.eurprd04.prod.outlook.com (2603:10a6:208:172::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 13 Jul
 2022 09:09:13 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5417.025; Wed, 13 Jul 2022
 09:09:12 +0000
Message-ID: <e15c0030-3270-f524-17e4-c482e971eb88@suse.com>
Date:   Wed, 13 Jul 2022 11:09:10 +0200
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
        linux-kernel@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <e0faeb99-6c32-a836-3f6b-269318a6b5a6@suse.com>
 <3d3f0766-2e06-428b-65bb-5d9f778a2baf@netscape.net>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <3d3f0766-2e06-428b-65bb-5d9f778a2baf@netscape.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::23) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08968a7a-700c-4c5e-3fd2-08da64af5a8a
X-MS-TrafficTypeDiagnostic: AM0PR04MB6689:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5NkZ3dqTgOMNmIo+wihuvg+M2kx2PCe9f/MD90aUR13CCc0C19rOa4WrP0e6NhR6rSp8rBKarwpAHyItm3+zfN48tGM48rtGlh0bZNjoY+GjCDS4e227NN9JcOcmy9+3aF1fuU01A5WSOk7+SnpUxJXZG8qqW5llBtmO3JsIKoSXP6J/3aKGrpcBL+BUVI+HKOxdbyu0Ngf9nQaBBxzWZGno0r9izrf4u50ZtiIqJIfo27+Wi793u+ZqMxWqJXZCj0+BDzN4pgWoQIavprmD+CqEc8wTwAY9BlyCe0CnLnoct7bGDnrStY6NBqeM9jTZc8tUKjP33xeTqPX2aedXwJagWSvCzqR39GkaFXRyWn1t5TQXkwZsHg2Sk8wlv5k7Msz2l4c5JoE3uckkA/Mr/5O67xFBoaLm/iddCEkChgJjP6nKjE9GhdjnrFTxjBbVLpCXE8hBybhMiWbhdZTUJY0pGX5A4SnLLdcgGxd3svPnUzX2w+QqXwMoZ7/U+FBM23Bud3cJf6YNjDAuaBsPuyrbKc2POnrPbvzE+wjTP0H+UCbvvj2PBuP/A53Jzl3zMin+PWfCbLziATQ8VYgB6LX/8kGqBnS7QOpnZClcIYVFMEKG8KIT70NQL8pgFCaxnWvpLgJSCH41+UjwPzsO3kxIpGyUuhXWrto9Bzb3D50jcjBpzhHcLOgmzStQ6NB0U0UwSAr0baqQUKmLHdH9QpLmgefXQtsQFk7I3nKMMJg04xqzwD86D247XxywtEc1LUVXo0sOt3tWXRfsu32l4WTfzs05zz6aQI7Xa4D2JJR2NPUAf4pGrSXUdN5KW+Wiz8s14ChoPeAN7IyASmGOtNkRVJhPFhunzySsolJRS/I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(376002)(396003)(136003)(366004)(6512007)(2616005)(86362001)(31686004)(7416002)(478600001)(6486002)(31696002)(5660300002)(8936002)(53546011)(6506007)(26005)(41300700001)(2906002)(38100700002)(83380400001)(186003)(66476007)(6916009)(54906003)(66946007)(316002)(66556008)(36756003)(4326008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEdqNGpWeVZvbmpJc1ZEV1QxSEFhS2tGWFBxaHVUWGR1QnVsVk93dTBHSnVO?=
 =?utf-8?B?QUxlME5xY0xQZlpxME9IbVJNY1Y3bEJiYUdmZ1FJM1Vvbi8vWEpQdFF4N3Z0?=
 =?utf-8?B?amFhc3Y2N0JNZ2srVHdraE1CWXJUalBIeWxxNEtiRWVBN3d1N0xrczF6cnZt?=
 =?utf-8?B?TTlFeHBRYlUzUDQvUFhPWnFBQ2dkY3NzYmg4T0o2VU9GeVNxMHRIeTZCbUNi?=
 =?utf-8?B?dHdPUEV6dlpFZGtkWDlHN0NBN0luMnlHdWNRaWRoZG9mamJhangxa3FLSUZr?=
 =?utf-8?B?dEQzWmduVDZtSFNrbVRwNDh2VnF3VUQxNnlGVXJIWk5tVkVXdlVESnBFTTJS?=
 =?utf-8?B?ZHRaMmhrUVUwNDREaUJTVEc3TVJoUkpENDNFcE85U0Urd2s3bFpBT3l0bEtY?=
 =?utf-8?B?TmR5d2JibnQ0REV1MVF6SmZnS21BYUFCMUNENWZtd1NWUmZrUGJ2UUNyeDEz?=
 =?utf-8?B?VGhaZlNGUWhBZ0R2VzdVc0poTmp2WEtXRzZyU0ZQb3hNM2Q4OTFrbEZCNDlF?=
 =?utf-8?B?UlZKcTZDM2xralNnaE1xWU90R0JMWC9JN00zQnR1SVlEbGl5ZW01TTRWKzBZ?=
 =?utf-8?B?ZllHbDdRTFd6c2Z1ME5oOENZQzBEcEhhUVU0VzEzcGlsQ0NZcGt5VmN0dUU4?=
 =?utf-8?B?d3FiN1Bsb0drRVg0bjhZZS8ySU00b0JZdFdiYUJGcWxFOHNoN3BJeXF2Rk5M?=
 =?utf-8?B?aTFnRUpwRDlQQjdMUUExbW9ST3hqMC9nb05DVWJLVjlzQVNFZzFGelBrTDJj?=
 =?utf-8?B?a0YzZTZsTTJOL0pRa2xUS1F6Tno0Ymgvd0FBazkyQ09HVCs3TzgrUUFXTFVF?=
 =?utf-8?B?OENORmRTKzhhVG5pUWRFZGM4ZGlaYURVRVR5Si9CdEYvME03b1d5ZmhDS0dG?=
 =?utf-8?B?bmY3ZWRUamVWTzN2MG1MaUM4TXpEZENERGx5Y0lvcmpIN3p4cFd2VG9ZSDRn?=
 =?utf-8?B?Y3lNa29CVTBmY2liMDhvOHBvQ0x6RHRmTXlITTFnb0w3NDdSV3d1OHFmTXB1?=
 =?utf-8?B?VjNPT25PSFV0SHhiYWxsOWxDbTJjTlZBQVZVME0xdmhtaDgrL3pRazNtMWlm?=
 =?utf-8?B?Rzd6anVTT3U0UTdhellLM1M1Sm1IcDlnV2NHWElzQWF0VDNwZnlickxRc0xs?=
 =?utf-8?B?ZnJwTGVROWtXbDk2TTZTY0U4Tmt1bWNIalJyNTlvWGorck9qOTJFdXhTOHpU?=
 =?utf-8?B?MVU5cnpZT09lSUxuMGpYQ2IwcWlGY2JjL3FPRWZEZG05bHdGVllNQ2NobklS?=
 =?utf-8?B?RnM4aExZNE5wWVpMeHhlaHZqaldnT291c2U2bTgxNmNwd3dOTDFqa3JDVU1Z?=
 =?utf-8?B?TVRNa2N4VGx6K08xaXg5VVYxSW82ME5NZTQ4KzBlNi9DK2hCKzVyQnNjUFMy?=
 =?utf-8?B?VGRHZU5GT1IrSmhqeUtrUTgxdC9NTURSL29XSHN6dnV0YlpqcU9Bb1JBWTAr?=
 =?utf-8?B?Mk44RmFnVDJJa3RqVTlULzB1MW9YeWlydmI5K3NyKzdRQ21uZ2dCSmtkMG5E?=
 =?utf-8?B?MnlLZlhRSlNNbmUvSFhud0RKMWJWWjM3bjcvYURzQmphcXRzV0lqbDNlNzYr?=
 =?utf-8?B?b2JqZFRyYk1NdDV2aDlNcWVmZjkzaEhoSk1kL2V3eEV5M0JkVHd5UlFsQXYy?=
 =?utf-8?B?Ynp2R29sM09wYmthYzF3TEZiRktCNVJvakFlU2xZNFhGNHNDQmRxWFpJSWkw?=
 =?utf-8?B?ZTd0MnpQeGFyQnZMUVEvaDdiRXJnbEZoeGU4Q2hUVE42ZVhaei9ZbGVhSXpR?=
 =?utf-8?B?SG9pSnp3NWxrQndNdnA5azg4WDg5OGFQQnpCSG5kZlVSRDEwMHNnTlNJZ2tM?=
 =?utf-8?B?SkUwSjBDVUlOZ1lXSUw5V3JERDlvbDZIQ1dORTRhNzQ2ZE9iTjE4TExsS1Zn?=
 =?utf-8?B?ZzlRSkNRNzdLdnpaQk1HbW1MY01GNHUvSzdpWkZkbGVkZm9Xd2lxR3VhaFI5?=
 =?utf-8?B?azRPdVlIZG5Cb25IajNsRHh4Wi9TNzB2ZmhIWVMrYXlXaXZPQUlxWCs4MjJx?=
 =?utf-8?B?VkUxNCtPa1BiZ0NoSGNXYmpUQ21HRjZPSEZuNklCMlR1NGRYZzBIV3VXUjAw?=
 =?utf-8?B?VEFJQmJhVDFmRTBDRGVqOEwvZkVhazkrR3FUcWJvTlc1SjNzUjJaMHFKYWlO?=
 =?utf-8?Q?r/wwJZwS0llaQHUlqUzjYBa8I?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08968a7a-700c-4c5e-3fd2-08da64af5a8a
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 09:09:12.8973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyEcEkhfyCd6P70l8CSe1eR2tuQhcmr+R5I3uaG+uzWv0LJrRFzx1jhZ8XqFTiU4fbg8BMNkW0eZEuTSHkHHDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6689
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13.07.2022 10:51, Chuck Zmudzinski wrote:
> On 7/13/22 2:18 AM, Jan Beulich wrote:
>> On 13.07.2022 03:36, Chuck Zmudzinski wrote:
>>> v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
>>>     *Add the necessary code to incorporate the "nopat" fix
>>>     *void init_cache_modes(void) -> void __init init_cache_modes(void)
>>>     *Add Jan Beulich as Co-developer (Jan has not signed off yet)
>>>     *Expand the commit message to include relevant parts of the commit
>>>      message of Jan Beulich's proposed patch for this problem
>>>     *Fix 'else if ... {' placement and indentation
>>>     *Remove indication the backport to stable branches is only back to 5.17.y
>>>
>>> I think these changes address all the comments on the original patch
>>>
>>> I added Jan Beulich as a Co-developer because Juergen Gross asked me to
>>> include Jan's idea for fixing "nopat" that was missing from the first
>>> version of the patch.
>>
>> You've sufficiently altered this change to clearly no longer want my
>> S-o-b; unfortunately in fact I think you broke things:
> 
> Well, I hope we can come to an agreement so I have
> your S-o-b. But that would probably require me to remove
> Juergen's R-b.
> 
>>> @@ -292,7 +294,7 @@ void init_cache_modes(void)
>>>  		rdmsrl(MSR_IA32_CR_PAT, pat);
>>>  	}
>>>  
>>> -	if (!pat) {
>>> +	if (!pat || pat_force_disabled) {
>>
>> By checking the new variable here ...
>>
>>>  		/*
>>>  		 * No PAT. Emulate the PAT table that corresponds to the two
>>>  		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
>>> @@ -313,6 +315,16 @@ void init_cache_modes(void)
>>>  		 */
>>>  		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
>>>  		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
>>
>> ... you put in place a software view which doesn't match hardware. I
>> continue to think that ...
>>
>>> +	} else if (!pat_bp_enabled) {
>>
>> ... the variable wants checking here instead (at which point, yes,
>> this comes quite close to simply being a v2 of my original patch).
>>
>> By using !pat_bp_enabled here you actually broaden where the change
>> would take effect. Iirc Boris had asked to narrow things (besides
>> voicing opposition to this approach altogether). Even without that
>> request I wonder whether you aren't going to far with this.
>>
>> Jan
> 
> I thought about checking for the administrator's "nopat"
> setting where you suggest which would limit the effect
> of "nopat" to not reporting PAT as enabled to device
> drivers who query for PAT availability using pat_enabled().
> The main reason I did not do that is that due to the fact
> that we cannot write to the PAT MSR, we cannot really
> disable PAT. But we come closer to respecting the wishes
> of the administrator by configuring the caching modes as
> if PAT is actually disabled by the hardware or firmware
> when in fact it is not.
> 
> What would you propose logging as a message when
> we report PAT as disabled via pat_enabled()? The main
> reason I did not choose to check the new variable in the
> new 'else if' block is that I could not figure out what to
> tell the administrator in that case. I think we would have
> to log something like, "nopat is set, but we cannot disable
> PAT, doing our best to disable PAT by not reporting PAT
> as enabled via pat_enabled(), but that does not guarantee
> that kernel drivers and components cannot use PAT if they
> query for PAT support using boot_cpu_has(X86_FEATURE_PAT)
> instead of pat_enabled()." However, I acknowledge WC mappings
> would still be disabled because arch_can_pci_mmap_wc() will
> be false if pat_enabled() is false.
> 
> Perhaps we also need to log something if we keep the
> check for "nopat" where I placed it. We could say something
> like: "nopat is set, but we cannot disable hardware/firmware
> PAT support, so we are emulating as if there is no PAT support
> which puts in place a software view that does not match
> hardware."
> 
> No matter what, because we cannot write to PAT MSR in
> the Xen PV case, we probably need to log something to
> explain the problems associated with trying to honor the
> administrator's request. Also, what log level should it be.
> Should it be a pr_warn instead of a pr_info?

I'm afraid I'm the wrong one to answer logging questions. As you
can see from my original patch, I didn't add any new logging (and
no addition was requested in the comments that I have got). I also
don't think "nopat" has ever meant "disable PAT", as the feature
is either there or not. Instead I think it was always seen as
"disable fiddling with PAT", which by implication means using
whatever is there (if the feature / MSR itself is available).

Jan
