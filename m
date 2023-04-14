Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269E56E1C3B
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 08:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjDNGNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 02:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjDNGNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 02:13:47 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FF540E4
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 23:13:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQcSa5+lq8qL9NfkRXDiYpkeT/WUInmv9dxAwxZM49PT6/cqT/EaGqAScqfD4/k1RuqB6sv9tRfifwfABX+QEuB7wvNhSfBm5tRCo9qIUqDC0J0/Yu8PON7AgJzAwaNyP3MJBaUGD9uwLLk12sLMQgFJFF6SCjv5RrjejLWOIg4nGrFMxovmWJ3f7QKsM34ACYHFXpxmkBjR/jMGHuI6o6Y6+/zHsoZVsreNed/J6OL/0/ffXsNNkzo5vHVb171BjJ3IBBCdIqm+XXhx0r0zAfY+0mPSVJCg7tpnRp/fBWScdS/ERcPjxmO0gG1aXSEAA0pNz9jEkfxiRJ0wTFLwXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enzvtgOUWaRaenrRWQIIkTgK74ls3QEHVPGTqYxZuSc=;
 b=chRTcrkwkJiUM+P8TGEqIxxgOMZt+RVpn1mB08RCG5S96EGCuWWw2p4RuW/3I8/AXnT744FK97fQHSh7wxyB83iIX08O1/tqrO4aWquJVU/IlDtk+sox2CxB34095cAZAOiM9X3BYGc/RnYOA+uhcbtL5l0zoRwdLjet64c1klPdyFjYTnSwpBt/W8YE8dVxe9gzLZMsL+9bR5vFhZAPHOOwzWZy6qvty4CoBsg9IQrKyJoxjx3HTQHXoHwiGBdbx9FeaXzPAmvTo76+NYAV+W3ECb0Lw0r7nKGwkdvcTkaSLpR2Hi2ty1g9UO16VIE9/fqncuyJVI5Pj3pbLM3l6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enzvtgOUWaRaenrRWQIIkTgK74ls3QEHVPGTqYxZuSc=;
 b=zuk7ZWHrsz/7MHJqye2kUB9s9julo2QIcg+gZ5gEikCm/9ajLUpg2bRyseL/ipZehtqj+eYxEqBNSbT4VBlcitPmNsScVrfFwbMCCREEn8O+Iwt98AYIMJnWPrJWKsz9dZ3F4uJ3GxTY8b+PIXD4NVm03131/J/9XXWCZxXIz1c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH0PR12MB5346.namprd12.prod.outlook.com (2603:10b6:610:d5::24)
 by PH7PR12MB7282.namprd12.prod.outlook.com (2603:10b6:510:209::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.47; Fri, 14 Apr
 2023 06:13:41 +0000
Received: from CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::51a6:a1e6:5fda:f57a]) by CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::51a6:a1e6:5fda:f57a%5]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 06:13:41 +0000
Message-ID: <3f9cab44-13bf-a725-7c33-9573c259facf@amd.com>
Date:   Fri, 14 Apr 2023 11:43:29 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 5.10 092/173] tee: amdtee: fix race condition in
 amdtee_open_session
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140417.410529300@linuxfoundation.org> <ZCwKjzsnhxkI+eFS@duo.ucw.cz>
Content-Language: en-US
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
In-Reply-To: <ZCwKjzsnhxkI+eFS@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0022.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::19) To CH0PR12MB5346.namprd12.prod.outlook.com
 (2603:10b6:610:d5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5346:EE_|PH7PR12MB7282:EE_
X-MS-Office365-Filtering-Correlation-Id: 716fb287-077d-48a5-c7cd-08db3caf6460
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8WOf+uhjBIAlXx+FP7M5Qn/i0ArBsg3c+9sGfLfXQ2sflXBMUVxHqalouT7J6DFyjzZhAqFvXhmt+7f10jD81yhppzU9jmic5eJWeb2LGolG/YtlFXOR9tgedpMKc/MK2IiCWsPfGDV4/g2CkZOHHpdDbf5Z6qwFHwxLSswWfx16KagZq1bfQscKTMGMi5e4vn+6oTAqWFG/ttMHQ/GoTfIaxyJyTHJwr1+F3mckWJkJ0xYvGqbmZKTJBIhTrkvQuIQjCT5XZXfVx0hZ6Mqc9ZoGW42KaKcu/Wu09stHLYLla/enPFdcxN0b3PkwtULb/i2pztypm7s3SVKgILjfeb4b3Vy/N6JcLOTutCUH31Fjbibi5UkHb3cbzEW1ybLk1/M6Ca5BbQJ9V+Q0XPKDL2PqMkw86bUMUfxhrm/oH1ekbBu0nIssUepvmyYjznCA2zban0WGq7u44WNQFY8sKoXroDZCpjC0dwIDmmRvbxHv4TYB3diOts0NsLuCcEpVFqUuy7JM1aC85xF5US4/ki1h7MWf2dQN6q0Sh69+ROS1fhDmEzH3Vqjwdz1n0T2KbNaKzsJ920SeAogH1uEPj/GYu/R6VEqE0nTcyeZgsL2f+f/2hgIyYJzcQ7YpeJFVzCVmTnO53BEqagvrrBCegw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5346.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199021)(8936002)(54906003)(6486002)(5660300002)(316002)(110136005)(4326008)(41300700001)(8676002)(36756003)(66476007)(66556008)(66946007)(478600001)(38100700002)(2616005)(53546011)(86362001)(31696002)(26005)(6512007)(6506007)(186003)(83380400001)(6666004)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEsvU214bkxid202UG92TkdadFRyZ1VlZkh4RWlaNTZjSUNyaTNnTm5mbjRH?=
 =?utf-8?B?dmkyTzVWcTBPSUE1d2xISlI5UnMxWGp1RkFWWnh5ZFdWTEYwVExFaWkrNWwx?=
 =?utf-8?B?b0k5cnhzaGJ6RmdoUDJRQ1VlUExtbzFGWkhzc2o3eXdkZVEvM1Nic2JvN2tG?=
 =?utf-8?B?V1BzSUFKMkoxWU5MejY3MjNMN1Z2U3JuTXp1NE9kaTRFT2lCNjk5dHdTNnRn?=
 =?utf-8?B?NTdxUVRnZ0dCY3FrTHppbmhjdVhMcE1CTjNHdEp2SVFhUzlqejVFd3NZSG4y?=
 =?utf-8?B?TWZkYy8zOHN2a2hTaW5wdmwzL25FekdWbWFOTWZPZEVRbkk5TWdLZGxEYmxy?=
 =?utf-8?B?WE9zbDJkUHBrTVRicllacUhTN1ZZSEFHOVFaN3k0MFlYN1o5WVVka1BRS1A4?=
 =?utf-8?B?RjBmbkordUlXQzdoMmFpRVVHTG1rZDNyeW0xTzZzSjJPa09rZzJhVTEwUzQ3?=
 =?utf-8?B?TlZFSkVNb21PMVovaFBCTThyVnBZN09xeG55ZVFEbzNkZWYzNFhReVUxQW5I?=
 =?utf-8?B?WWo3R1lkZUZpbTFqZ2RKM0ZLS20xZFVaOVk1RUV2eU5xcS9uejljUTJEQVVN?=
 =?utf-8?B?eUY2cHp2QWFqZ2w3eEdZOFlYc1d6M1JYNXhHTkUvaFlKVi9VdGNYSVl5NlJS?=
 =?utf-8?B?STU4QlJTeTFFY29uMmg2cWN0YTBsUTRFSVRtenhHd2RJYzNCbmpkQm1WeVJJ?=
 =?utf-8?B?NkMwU0NlcWdJTjhmcVZIeFN5cmJpTUlOODh1UDdZUTQ5TnBDNGUzT2Zlb1pY?=
 =?utf-8?B?dlhnbE5kVnBkZkhRYUpZMkJyb3VoN1RnTmZJam1HblFBcVVrWFJXTkxYUyt2?=
 =?utf-8?B?TzFETytDVlVPY0RRVjJ1ZFFoeFpTV3cwVDVWTkxtckpmSDlvNm9lMDlIeGFZ?=
 =?utf-8?B?WDdMTmV3Ykpob003dGRBSFZkVGFRdS9rc1JqNTlhWVlUYWw5QlVxL25OR2xr?=
 =?utf-8?B?ZmQ5SkNVUTh6Wk1jMk5jS2dRdWIveDdSTHlVeFhQajJkYVhhR016NTY2Nmo2?=
 =?utf-8?B?QzhzbTJDMFdac0wxTUxhd2gwbEg0L3lJZUhnc01qUzlYaFFYM09jeDNQTkNj?=
 =?utf-8?B?YWtuc1RtaXdlOGJObmxUTGlYNEFHa2xiVHhxL3RtNjEwUkJ5TFlQVTk2bm5o?=
 =?utf-8?B?U0dZR1pvb2tGR3oyNkxVT0VWN0RCVnQycjhSN3RlYXNVanFvcE1FeWJGUnFX?=
 =?utf-8?B?VzRjU0E4ekVtdGVFamFjUkhWK0hYVHlOL2VnUVpjOUdicFp4NituYjFlc25a?=
 =?utf-8?B?Rlh4VGREOVpla09TZXVuWERsOW1GbjFJZlRkRHZDRHVBenhKSWdLRmVMaUs1?=
 =?utf-8?B?RWN3cWlVNnJudGpxQVA2Wmk5U0ZWU2dKTFRyRVNuN3NpNVhldHVUNDk5VjBS?=
 =?utf-8?B?UmFpTjM0VzFxS3pCTlpBcHdXQzhtOTRNTnNMT2UzSmkzTUF4VnBiU1R2Umpp?=
 =?utf-8?B?OC8yYnBFeFFXN2VhOEowNEI4Zjc1YzJIM25xTmJ5ZERLY2JMQ3EvVTlwK3pq?=
 =?utf-8?B?YnlZUXNzN0VGSk1RODNGUHFoTEhhTlBXWVJOQS81aHZGY3M3M2VaRTFLNDd2?=
 =?utf-8?B?c1NRVmhkU2dyWGhYdFR1a3hQUEhSOW93MUpjWkxTUzhIc1dPSXZLb3RIVEZU?=
 =?utf-8?B?VDZqNi9zZW1JNDk0VStWNTBiNy9xczRsbk8valJiNkxldEVIVDZZSys3anRz?=
 =?utf-8?B?ZWRpdTlVbndhOXN4OXEwUmJGVkI2UUk1TnYvb09vWFIzUzVSZndGY2lhMHlU?=
 =?utf-8?B?M1V6dFlYT0FUZzI3UEwyRU8yaFdkNENKaXc0Q0c4QW95YVo4cjU0YThaVERx?=
 =?utf-8?B?S2tRbjVCYkt2L2diMHBNVXk0dnJJMkFLNnlhM2tkZitPL1kxU1VGd3pnR0c5?=
 =?utf-8?B?UVhqdkh3YnE5V2l4cStJZVNMSy9SOUM0b1JoZzZHV1pxOFQyWVVWME5RS1BL?=
 =?utf-8?B?Ym5Cclh6V1BRYk5KOEtrMTF4VENOMUZXMnBoRVFuLzR5Sm5Qb0cveERFYVhS?=
 =?utf-8?B?ckZmZmRrclFEREVZSEUyR3VrVlRkbVhHczlETnd5YTBpVDBIaElKUjBBRjBC?=
 =?utf-8?B?VEFwYWJickRDVDhOaUo5SEQ0cWlveUlnUTFzUlFSeGViQXAzZStaUWgvZkZi?=
 =?utf-8?Q?5avj+rvFDoralH5MjjZWTAVqq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 716fb287-077d-48a5-c7cd-08db3caf6460
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5346.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 06:13:40.8289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yDroo0juTkglLsIAbOraDgJG7bwPfqE6o4DQAn/amk/pjT1W/t1ViLF2pXC2oaftLRv6m5t2s2xXigvClWMiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7282
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/4/2023 5:01 PM, Pavel Machek wrote:
> Hi!
> 
>> commit f8502fba45bd30e1a6a354d9d898bc99d1a11e6d upstream.
>>
>> There is a potential race condition in amdtee_open_session that may
>> lead to use-after-free. For instance, in amdtee_open_session() after
>> sess->sess_mask is set, and before setting:
>>
>>     sess->session_info[i] = session_info;
>>
>> if amdtee_close_session() closes this same session, then 'sess' data
>> structure will be released, causing kernel panic when 'sess' is
>> accessed within amdtee_open_session().
>>
>> The solution is to set the bit sess->sess_mask as the last step in
>> amdtee_open_session().
> 
> Ok, but:
> 
>> +++ b/drivers/tee/amdtee/core.c
>> @@ -267,35 +267,34 @@ int amdtee_open_session(struct tee_conte
>>  		goto out;
>>  	}
>>  
>> +	/* Open session with loaded TA */
>> +	handle_open_session(arg, &session_info, param);
>> +	if (arg->ret != TEEC_SUCCESS) {
>> +		pr_err("open_session failed %d\n", arg->ret);
>> +		handle_unload_ta(ta_handle);
>> +		kref_put(&sess->refcount, destroy_session);
>> +		goto out;
>> +	}
> 
> rc needs to be set to something here, otherwise we'll return 0 below.
> 

Sorry about the delay in my response. Somehow missed this email.

Yes, that is the expected behavior. rc will be 0 while arg->ret will have
the return status.

Thanks,
Rijo

>>  out:
>>  	free_pages((u64)ta, get_order(ta_size));
>>  	return rc;
> 
> Best regards,
> 								Pavel
> 
