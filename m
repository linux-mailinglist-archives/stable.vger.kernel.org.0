Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F6A66457B
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 17:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbjAJQA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 11:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbjAJQAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 11:00:20 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A3258337;
        Tue, 10 Jan 2023 08:00:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JprVp6hZOE/cv4yyO73tGJ2gFCPbs9FCWL5d2RupAnUWwsFz4DWp71GiltC6X9wxxpQtq9u4Gk2KjK4sk7E+liqndSDzjGiViXl9OILIzDyT0Zt3rF1Lx67R+AkM5M3UnaDeAGXpuD63OzawEuhb+tDDurwlMAwB6vllDOKr7I7XqOW/TNxmv9xoUxXKPP3HjS4F3K3+SEY0joyq0Uvq61dh6KPXBfNhsBPMZvKnJMvM/DNkQZy/Flye8Kis3G/slJ18zzGNv2a2gCHpeB12tXVdQ4PMrzhxDCrXidanvl5QZjRIuaoCzI0bGHZqmaBAsTNE4y3f9SSBcJ95Rtmn4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7F3dxZU1XV48GRgKOpEvW0W5IYkBk1A5mW3JJu5JaI=;
 b=VPpOup2ypLlKFx48n7FwkRDnYMT1IglwnI4Y18XsidsRkc2lHmFQe2lZqT9uJbVPGeHV0FgTwK/CtZ9ZeUIu+07J3JI4dDDfOI8aD494oI5RrXAJd7+MUZxX6+jWAxfP0IWbSBb8z/W+FXEWn6rDKbjp/PyYS/9f1zqSvYGGPVBN3SFxTLZyrC39FymxpVgn+vEM07pdMMt7F6sbJ/oUT5f22Ojg4IC7n3l0KewV2Hk7mYu14WbSc/VfvIikbAZj1tpqu1DiGtj3wuUsIgO1s+2QFAORJxfVfkb90Xnqo1M/HV+pZ6jxfN52fdesu2kjZ5meq21gvy8F4l2NQIiFyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7F3dxZU1XV48GRgKOpEvW0W5IYkBk1A5mW3JJu5JaI=;
 b=k4Hy5JcIcuNJcpmw7NTKrwy3jDg8LQS8bf2gmlq/VAKFMlCeZwGCsAYODaGLQgqwiKg6vb/bO48Gnz+wJWu7YY6se2rRnPnNFc5+zZ6YLebUARdiYIZ22X/KeeubFGMoYZpFrQNlb6iaIjw7w/Y01B73asZSv3WdqI9+DW0NSBc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by IA0PR12MB7673.namprd12.prod.outlook.com (2603:10b6:208:435::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 16:00:00 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::790c:da77:2d05:6098]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::790c:da77:2d05:6098%7]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 16:00:00 +0000
Message-ID: <b5f9e70b-f3b2-c1a5-a4fc-365747460677@amd.com>
Date:   Tue, 10 Jan 2023 09:59:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v3 1/2] x86/resctrl: Fix event counts regression in reused
 RMIDs
Content-Language: en-US
To:     Peter Newman <peternewman@google.com>, reinette.chatre@intel.com,
        fenghua.yu@intel.com
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, eranian@google.com,
        hpa@zytor.com, james.morse@arm.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, quic_jiles@quicinc.com, tan.shaopeng@fujitsu.com,
        tglx@linutronix.de, x86@kernel.org, stable@vger.kernel.org
References: <20221220164132.443083-1-peternewman@google.com>
From:   "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20221220164132.443083-1-peternewman@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0063.namprd03.prod.outlook.com
 (2603:10b6:610:cc::8) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|IA0PR12MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: bdacf26c-a357-40e3-3a8f-08daf323ba5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+E1BgEj/QeycGFM2xwmTPsAtXmR5eZVycLXRlV7iyXih85JMrz7F3Q0o+rnjjKkCAK6fLhhgrFwh19k+n5MFg5X3YEouwVtUDRoTxk1AcZfEv+d/M7pIUC3RflzVVLm+GP5UcD8I94/k8iphTt3uHF6DuRf1JHthlTD6uEfwJVmaBwZMAKmzE/ZLD+wL5SjjQQhBL11ixy8Y7OQGIlXkFIcFkpXl7eGGG0xAj3pkg7dmYy07p5fBpxVprIGUuoYD8UYmiBUOq5T1TcvBbOlkSVgQuxgIJ3hxgyCqW3WMqjfAz3TA0Aw5OQuiM2Ez1fOO+FFQq057zCB5JhYF9LRj3+CK+SpR/H6LvG7JJ48rMJrhE/Nz1Kh0Bn1cLsttSKQpNfElun0OCtWHXQeWdIMrfFGst0DQyah9NQ4WBCNA+wh0PG0WBwpWdz9/eWAW1ROjXAvyAbQ2PkVBtwrf9aNsS17Vsq/+kCQ9QsSbmKenniTpZvycWTir9DbMke12vQ0rvIs3IlxAo5banmVIH8b1vDOtAbawQRNV1C2s5uVW+hqtjBbGj8UOpfqS0HOvafE1BQr2rnZ3TZDz2lasF1ElP9qxleSD0X0/thiMvjQvXLDiaLMUpXrjuXfhd1ORC6NfpFDcc7gy3FCew2waRKveoe0ZcsjiKGPYwTT6Avyfg5Q+6TFtPmGEGx57zurUAloTLAvPC3NAqUpOOoU8d+kZC5uwA04JR1Hi9+dB4Cq6PURkKnfZqnV1ZTZDFBB5YXv9LS2AzD9U0pZougN/qHmK4JR8XpylD3VKI67cXsQc2M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199015)(7416002)(316002)(5660300002)(26005)(6512007)(186003)(6486002)(478600001)(966005)(2616005)(31696002)(41300700001)(66946007)(4326008)(66556008)(66476007)(8676002)(8936002)(83380400001)(86362001)(36756003)(6666004)(53546011)(31686004)(6506007)(38100700002)(2906002)(3450700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ykk3NjJlcFpSclhYczIvQWZpMWRxNklEVXA4TXR6cE5XNFdZMVZBcWpSZG1z?=
 =?utf-8?B?SDAvUFAxRGNPY2tBV3ROSjF6Q29NK0c2UWExOFJlZVJxMC9VZXB3MkVlSFFs?=
 =?utf-8?B?OE9EQzhZaWxvV0ovaklRZHRacy93cHFVaU5hQlJVbGRocGQvNzkrbVoxMGxS?=
 =?utf-8?B?SFp1cUNXbzNqd2ZHai9GZGpiQXBtclJEY0twQTlFcXZsU2JmZVZ2WFEvY1l4?=
 =?utf-8?B?aW5XWk82L2ZtVDJPemMvS0JBS0hJc2RsT3dBOEZWTzNHeDh5Ymd2K0JTaldh?=
 =?utf-8?B?WmplQnFRdzRaNi9TeHNoRnk4YXVsN1ZGVXhFMXB5ZlRLak9JZW9RRFFGZmVW?=
 =?utf-8?B?SzNLMG9aV0ROcHNTWWI2dCtrOWljd1ZZMjNYTWxvRW9RZ0xhKzlXZ1d0Skk5?=
 =?utf-8?B?WHpSMWl4eWtPR2liSVB3K1h6TDdKVnUzcXd6WXhadHBuaFZmOWZYb1lsd3pJ?=
 =?utf-8?B?UWtudkFEVGU3WHo1SW5FTzhicVZnanZPRlV3dWVaaXNQQ1N6aWxxQTlUOHpw?=
 =?utf-8?B?UFBwYk5tUWwzVk11VHF4VHl6akZ1MjhjemtYTWRBVGhkM1REU3d6WTE5aFhy?=
 =?utf-8?B?NSs4VGU0dXMyd2czK0NYS0ZkNENHZGh5RXJNaDlXSWhFZlF1RVJqTmR2VUxi?=
 =?utf-8?B?K0J6QXJGZC8vU3BwOVAvT1g4UXNseGtpNi9oMGplWEx5UzFJZ1ZaYktsS0VW?=
 =?utf-8?B?bmdwZVZwcGZVbkpZbG9ERm5acG0xaWozWmZlcnpPbFhOR3NmTkJJZmtxZkhx?=
 =?utf-8?B?enBidGxoMWkyT09GcTQ4dDJiWktQQ3B2dVdNY2JtNXdHVk83UytuWkNuRDlV?=
 =?utf-8?B?VWsranpJaU9CSDFsajlCRWNwTFdUNHRLMFBhRTQ4RkZPYUx2VWRtY2FkWnVB?=
 =?utf-8?B?NTY4eTI1M2ZlMzFkVU1YNFpUbjA1Ri9rTmhLcEhIaGFtOTQ1KytLdUdTM1Vi?=
 =?utf-8?B?NXR0V1lOckpnaEpHL0F5d1Nzd25ORll4N3hJTXI5OGdVVGEwZ3g2Q2ZCVGEz?=
 =?utf-8?B?aTdqUnJrdk5zR01MWk00cDdtQjVrak5wbm5JcVJMNlFQcTUyYzRTeEpTeUxy?=
 =?utf-8?B?YVNWNDBhYzBITWtiajZDQjcwM0lRVEJiM2VIYkZlTWI4VitSczZRai9ERTVV?=
 =?utf-8?B?SVd5emJTZDd2MzVLS3RsOFJmQk1CYy9EeVFVc1R4cE5DeWlFRFB6eks3TlNk?=
 =?utf-8?B?TVM0RGhXbGVVZHlQUGh1NjAyQURoOUk5MUtZRVdiOXJBVUJuR3BuT0ZpWEJS?=
 =?utf-8?B?UUwvekpseTlKRTRHREd0bnFHOGJGekc5QUErVEJHMHBnQUtSMUtJWUVKTEdX?=
 =?utf-8?B?UkdDT2c2NWJMeTJIaTJxN2VWeHVXSlVZWXBsQzdEK3NTVmRGVW1Lam1ZZUJC?=
 =?utf-8?B?L2lKc2dFS2lwWHpYTGNoSDd2eDJ2TGxnS0F1QlFmY2M5akEvKzRIR0UrQ1U5?=
 =?utf-8?B?VnRxUVZXaEpQd0R0NXZFTnFBa09pZ2JmRitUVERDYjlBQ2UyL0tMYzlaRUEz?=
 =?utf-8?B?SGUyZzJGaFI4L2orNUVrWS9uckg5VFU3eVJRbTNnUEJPS294aGVraEcxY3Y0?=
 =?utf-8?B?V0JsblQ2VlVxNjdLK2IzYzZiMEZEUlVHcW42S012Q0xvZmpHRmNuTjlmUlBE?=
 =?utf-8?B?V3R4dmYxRUFnK2p2U3YvRWZ2MXNLWHVHUkdLSzRwZW56VzVhS1U2eEMwL3h1?=
 =?utf-8?B?TVBucjQ4THpaUGUrOHNXVmtSVDlBWUUrTnZJRlh6NkIzRTR4REd6TjRNZFgr?=
 =?utf-8?B?Y0JtK0lpVkRaM1RQZGtHd2tTQWFDeTZPOGM3aXN6c3VPNVd3YytvWlN5SW5l?=
 =?utf-8?B?QlZ6ODA0SUxNRkY5RDh4eFg2dzFLN0ZEZmVQVzFLaDEwUThPUlBNeC9vUHNL?=
 =?utf-8?B?VmJiYThRR2dGbWFpNmxJcjNyVmkyYWt5dnVhU09wVS9kQkJ0d1pZVE5UOUtJ?=
 =?utf-8?B?cWtYcS81aURZVGY5R2o3MEVlemp2ZEkvbjVDZ0xVTC9xTDh6M29veENoRmZL?=
 =?utf-8?B?V1dFQ01OTmtxbUF0Nk9JRlFqZDVVTEFMWitEWk9tT0h1Z2E5dGxtQTFiM3ho?=
 =?utf-8?B?bCtNaFk4dFk0dHpvR2cxOGFHLy9pQ2x4UU1BZy9xNW1DTUUyMlAxN1VuTXBY?=
 =?utf-8?Q?g4PU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdacf26c-a357-40e3-3a8f-08daf323ba5a
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 16:00:00.5038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sU0QBYveQIU9+fq9+1JNKb5Ywj2POpbtHi5GHdplsk0Ho/eeRRwLABakQHRe7TkY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7673
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/20/22 10:41, Peter Newman wrote:
> When creating a new monitoring group, the RMID allocated for it may have
> been used by a group which was previously removed. In this case, the
> hardware counters will have non-zero values which should be deducted
> from what is reported in the new group's counts.
>
> resctrl_arch_reset_rmid() initializes the prev_msr value for counters to
> 0, causing the initial count to be charged to the new group. Resurrect
> __rmid_read() and use it to initialize prev_msr correctly.
>
> Unlike before, __rmid_read() checks for error bits in the MSR read so
> that callers don't need to.
>
> Fixes: 1d81d15db39c ("x86/resctrl: Move mbm_overflow_count() into resctrl_arch_rmid_read()")
> Signed-off-by: Peter Newman <peternewman@google.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> Cc: stable@vger.kernel.org
> ---
> v3:
>  - add changelog
>  - CC stable
> v2:
>  - move error bit processing into __rmid_read()
>
> v1: https://lore.kernel.org/lkml/20221207112924.3602960-1-peternewman@google.com/
> v2: https://lore.kernel.org/lkml/20221214160856.2164207-1-peternewman@google.com/
> ---
>  arch/x86/kernel/cpu/resctrl/monitor.c | 49 ++++++++++++++++++---------
>  1 file changed, 33 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index efe0c30d3a12..77538abeb72a 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -146,6 +146,30 @@ static inline struct rmid_entry *__rmid_entry(u32 rmid)
>  	return entry;
>  }
>  
> +static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
> +{
> +	u64 msr_val;
> +
> +	/*
> +	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
> +	 * with a valid event code for supported resource type and the bits
> +	 * IA32_QM_EVTSEL.RMID (bits 41:32) are configured with valid RMID,
> +	 * IA32_QM_CTR.data (bits 61:0) reports the monitored data.
> +	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
> +	 * are error bits.
> +	 */
> +	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
> +	rdmsrl(MSR_IA32_QM_CTR, msr_val);
> +
> +	if (msr_val & RMID_VAL_ERROR)
> +		return -EIO;
> +	if (msr_val & RMID_VAL_UNAVAIL)
> +		return -EINVAL;
> +
> +	*val = msr_val;
> +	return 0;
> +}
> +
>  static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_domain *hw_dom,
>  						 u32 rmid,
>  						 enum resctrl_event_id eventid)
> @@ -172,8 +196,12 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_domain *d,
>  	struct arch_mbm_state *am;
>  
>  	am = get_arch_mbm_state(hw_dom, rmid, eventid);
> -	if (am)
> +	if (am) {
>  		memset(am, 0, sizeof(*am));
> +
> +		/* Record any initial, non-zero count value. */
> +		__rmid_read(rmid, eventid, &am->prev_msr);
> +	}
>  }
>  
>  static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
> @@ -191,25 +219,14 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain *d,
>  	struct rdt_hw_domain *hw_dom = resctrl_to_arch_dom(d);
>  	struct arch_mbm_state *am;
>  	u64 msr_val, chunks;
> +	int ret;
>  
>  	if (!cpumask_test_cpu(smp_processor_id(), &d->cpu_mask))
>  		return -EINVAL;
>  
> -	/*
> -	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
> -	 * with a valid event code for supported resource type and the bits
> -	 * IA32_QM_EVTSEL.RMID (bits 41:32) are configured with valid RMID,
> -	 * IA32_QM_CTR.data (bits 61:0) reports the monitored data.
> -	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
> -	 * are error bits.
> -	 */
> -	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
> -	rdmsrl(MSR_IA32_QM_CTR, msr_val);
> -
> -	if (msr_val & RMID_VAL_ERROR)
> -		return -EIO;
> -	if (msr_val & RMID_VAL_UNAVAIL)
> -		return -EINVAL;
> +	ret = __rmid_read(rmid, eventid, &msr_val);
> +	if (ret)
> +		return ret;
>  
>  	am = get_arch_mbm_state(hw_dom, rmid, eventid);
>  	if (am) {
>
> base-commit: 830b3c68c1fb1e9176028d02ef86f3cf76aa2476

Tested the patches on AMD systems. Looks good.
Tested-by: Babu Moger <babu.moger@amd.com 

Thanks
Babu Moger

