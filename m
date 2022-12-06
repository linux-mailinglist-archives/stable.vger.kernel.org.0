Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C75F6449C8
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 17:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbiLFQ5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 11:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiLFQ5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 11:57:39 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2082.outbound.protection.outlook.com [40.107.15.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75545F53;
        Tue,  6 Dec 2022 08:57:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkHdj+1iD+rfZlEAipZY4JH6paS5f6Aiikxze64hXdgbbzGYLwjL8dJPahApYtWSj+Uml7xX4EOk+o5D8oOFy4GFUcPvMFBjRFwuiNj+2swZ9nA7MFPhjlPy8m32wyyKpNqESGjzQ3LIDqfnlNUoD556DS4tCt7oNPI5hw+mYArd+aq16DzbJZWHdb6PsAimRo5nmlB9/ULREYKHsXbRzoS0oTzn1SORDgn5pt9Fcz1loB1HVJAia2EX33IEhRy5/cwQIriRgcF9g/LYI8AUxWdvCqkEfEZ2AGVWXrwQSkWbJzFxOf6U2YfDilQta8v0VKZk2fKrUUnZrXKOu/tcUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnCrkItCe7Br8W7P/gdK3sVepl5bdYgNmhFRn7ZtHrA=;
 b=f7eyXPt9b6xvCw4UBolkaZ1805rd7pWXFHb0IbahSvhBWTY9xJdcHC55AxcDDkfSCYzs3qOlD3OmvAB8tHK1tB69Il5+p9ss8QTTFUJy3xBH/9w3YFnQmib2jJBF7HSJVVpSUngXhYIwxP4rXfsz9byANjKitoRPbxPdSfO7nrESjVZ1u0HnQcqlzAwJZ1lpTAdxbUcCMdkfhg0/JcCjT+e4nc8uzkvbf03elF/8LKEhoy0ijMI9cuBye4b+TX8e7yOm5UW/I1eTCeQdfU4rCBv/wwLJ+0KtMBzWACxCZFi0Pv1oBsZOse+9ipUgkPowWEK7IUUpFii2VlFmGHp0xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnCrkItCe7Br8W7P/gdK3sVepl5bdYgNmhFRn7ZtHrA=;
 b=ejWX7lwQw5eKTiCerPDa7ljCZN1pjDSZuoLEnuFl8bHtyAdtF7sBwIP0p9TEME3fgmOZtCWK+4XHgw3j6Iu+O6XfngBG186YD0wE65Ej1ogls2nyMOX57S2QWx8ifemI08eP9mhHJwq2xSL83f4r9QFDO4MxRl+McKDsC4keIIsSSE1brAx7PHm2DpMvzz1/3A4NHwu4wJkG7ghk3J5KHrEmsoyAWeUsstZ+Mr0mwiwAhAN4c0cQIGBxgRW0C+wK/Q9ywdVMOoDBNtQgsjOMqe7APrsx4Eqk1NJaRHJKAW9r8OLWiGXQnXY8U6mOKPpBMkmRP5LBOcZJAmZyBI1u4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27)
 by PA4PR04MB7744.eurprd04.prod.outlook.com (2603:10a6:102:c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Tue, 6 Dec
 2022 16:57:32 +0000
Received: from VI1PR0402MB3406.eurprd04.prod.outlook.com
 ([fe80::a207:31a9:1bfc:1d11]) by VI1PR0402MB3406.eurprd04.prod.outlook.com
 ([fe80::a207:31a9:1bfc:1d11%4]) with mapi id 15.20.5880.013; Tue, 6 Dec 2022
 16:57:31 +0000
Message-ID: <d528111b-4caa-e292-59f4-4ce1eab1f27c@suse.com>
Date:   Tue, 6 Dec 2022 17:57:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>
Cc:     mcgrof@kernel.org, prarit@redhat.com, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y45MXVrGNkY/bGSl@alley>
From:   Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <Y45MXVrGNkY/bGSl@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0108.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::11) To VI1PR0402MB3406.eurprd04.prod.outlook.com
 (2603:10a6:803:c::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:EE_|PA4PR04MB7744:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e3eec24-ec63-45f5-bfc2-08dad7aaf71e
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKAqReNiZcD/iri+1+lWq09Rc54hqBt9hZjznXTkgqpDgByX4td25RCFVZ0Nme2g2xzrDJIHSspakYovEFo6oTRM4+WiznhXb5AB0yc5zomcKpN4yw/+anoDoX5c40b8PMAcbTaajlT7EVhOuVtOZycr7Cb8MNGat2I64BJXAfsw1TYitqOf/v4NE+g/aurC73iDV6jM66+0MrMHIXD1TLCtvsVHrv65X419gmHVcxrmW8FQXTzAYhOP+kKbyMrykWiG6/wjTMaxH/64MfjyutXC/IGCSt4ymLgpyvKoGrdMAeGn2x2bVlR2zEhG7ODWHeXaEb2V33imgq/j7MG5iX+5qt1cLN41xZTANteZ+rELcXZA3/JZxP/jjh+dXl+8Tmr4GVEBacT1XbCUyR+uVs0dB1fQkGTs3PngKuDHXmEpNNUnkowRj656J1bdl3R3rk49HhyEU7NDHUvNdi35Hm19cwtyKqDVs2iKSutjzvXLHzNoVsMk6DyvM+ZY8m9nPsEeQkVWKZlvFtiAfgIpfoIRgA5N4L9ztHYdUiUkgfHXdvhv/q1eA47z0WfoP1aDFPtJmAvbphy0gan/0gCVw9EtXPk2M56FrdllOIK17H3Z8PyA3OfQSqPJQp6W238Hpo50EPiVk/45vv/W1/Gf9omgtO34l+mnqVeo74CQ981nB/N6vejH74UA/hCnXmWdwdeHNIul2Cgj9idpNRW3AanMmtDdneOJpKKcsyJ81s3XWtIFt4HWvGvV1s0BtGEH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3406.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(39860400002)(396003)(136003)(451199015)(36756003)(38100700002)(31696002)(86362001)(6862004)(41300700001)(8936002)(2906002)(4326008)(5660300002)(44832011)(83380400001)(478600001)(6486002)(6636002)(66476007)(37006003)(66946007)(2616005)(66556008)(31686004)(316002)(8676002)(53546011)(966005)(186003)(55236004)(26005)(6506007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Slh5eThjQ3o5eGtiNUYwZlBqaEtTK3g3ZTdSTlVXdXM3aWMzeHNiUkxzck9z?=
 =?utf-8?B?WFRQd0dHblNtdXhwcDJmR2xYUndGQ0R3UWRHTS9hTVlzSnhud1lHZEVCaXp1?=
 =?utf-8?B?TXp2NTJyVFpuWmlDdkNRbkNXK3FITk5DZDBpR2V6ZW5OcFlxNWVnaHlPbnBp?=
 =?utf-8?B?VVhxQ1UzS2JBQnoyWGl0Qmh2amYxKzliZVRFWmhsODJCSGczNzNhaUloWTVk?=
 =?utf-8?B?a1U4ckRCcE9tK0FKWEZvZGZHUVE5cytFT2ZXMlVVK2daL2RIaGd2QW5oSzZk?=
 =?utf-8?B?K1daRkdFRkhzQ1hIVGV6UUhHQ2s1ejJBVFVMUVJCRG1iSXdsNnIvMThIMU4r?=
 =?utf-8?B?RW9XTVhyYUErcXFWUWV6T2xGYzkzUUszd1p3R2NOSzV0WDYrKzJQRm1xTDI3?=
 =?utf-8?B?R2tIaUY5Rlk5RWE1K09qRXlhM0FUMmNyeHY0SkYzY3RpVUVjUktWbWlEV2xM?=
 =?utf-8?B?QTcrOGQyQ0JLL1Fnb1Q0V0ttZmN6djNoN3Iyd3hudTZXWTAwa3BkcFZoMUMx?=
 =?utf-8?B?dHNjb3V5N2lHOUlVNWF5N3JBSStqV3RFUGFlV1MzL1NUTkFsQ2pQc3RuUFZZ?=
 =?utf-8?B?ZWw3TTB1NUYwZjRZY1Q5VFV1TElMZERZZ3podEM3K0p0QVk5V3lkQ0FFRFBQ?=
 =?utf-8?B?ekNJcFFTZHBWYzhPK2hJb3Z2RzNncnJ6Wnk0bnpaaUdXWHcrWlloZHFYUEd4?=
 =?utf-8?B?T1JlMXRTeTRpa1RoUERlY3VNbFRVeTRjRXJCVXAxZWRWOTdLZzZQYTR6d2Zh?=
 =?utf-8?B?NUVHazF0VnNjcXRHWS9DTWxzaU1nTWJTUWNnNGFHRElLTmVSdWtvTXlOS1hr?=
 =?utf-8?B?ZXVZOXc2Z25hREJQYUQzTGRIcjJrdEZLRVVOOGFVWVJhNWV2Vjh5Y29OZktB?=
 =?utf-8?B?SFJSR1JUaHZYMUE5dHBnbUtwZHFkMFRNSjIwUHdKTW1QRk1OQnBPRlI0bDlo?=
 =?utf-8?B?UDd0RXJvSzFCQWFkK3J6OGx1cWVoeE1yYUt2czVxTWlVY0FFTEVuaFowcjlF?=
 =?utf-8?B?RTBObVA0TlhETUQ5RmRNMkxZMVZGcEVwaGF4TlFjZGpZN25PQ1huNTVVZ1Qy?=
 =?utf-8?B?d0RYbzJtenB0NTJpMUVpMnZlTUdrVWxqenV0RTZsd2djZmsvMWtPUjl2U0ly?=
 =?utf-8?B?WWs5WTNzNC9MdXZMNUNBOXJmdE5wdllveGJUZFQzTjhqL3pWdTVZbVpKYm5J?=
 =?utf-8?B?RElxS2daMU9hTTNnekEyekFQRUdUSWRadzBDS1JlaUdTZkRNUG9WSVhscW9Q?=
 =?utf-8?B?Rld2enFqaS9OWk1PR1MvQ2d0Q0g0TjA4MXNqMHhrUE5haXRwQ0txV2FuOGJQ?=
 =?utf-8?B?S3ZUK0FHR09jeHZyYm9oY09YWFQ5ejFiTC9KcFlFVUJYYjZJQndxVTZpelpZ?=
 =?utf-8?B?c0JXZGhRcDVrUWpXSkl4TzNFNC90MDN0akErNUlDcHpPc01CMEU1eG9YU2Y5?=
 =?utf-8?B?RmhoSXZQYnBQcloxS0hHSzl1dzlPL1Y0dU1GNlRCYmpMNlBYRnlpY2FqVzh3?=
 =?utf-8?B?b045czBXaGhha3htR29nVTVjM29RdXJiYWZLRVdWRzBZSHFDalN3VjBCTmhQ?=
 =?utf-8?B?WlBLT0tkZzFIekRBYzlKUFYzOGN1cDMvaFd0TDBrU0V5MWdqSktZMFNDRHgv?=
 =?utf-8?B?QkRFWTdNeHp0QjVSdEN5cWt5R05zL1VHT3IxQjRUTjhwSkMxRDMxT1g4dmtG?=
 =?utf-8?B?UjAyRGFXSXZZcnY2NFVWeE1ja2NRSjF4Q0g5WGt6RVBrK1h1dUFpa0h1cmdB?=
 =?utf-8?B?Y1ZKYitNRFBsNTZ6TGozOEhrSDhYNzNSQ3F0a2d6WFRhMUtNWitjaWVyOG5V?=
 =?utf-8?B?aHlxUGFrMlluQUEwVzVVdkI0cVZabUs3SHp3bkJPOVkzL1BPVzJKRStlajZI?=
 =?utf-8?B?ZWlxOHdyaGEvSnVMdUcxdE81VnByWmdvQmhnakdDVWdFWWdKRVJ6dS9OcEp1?=
 =?utf-8?B?ZG5QTHFXZVhrTVN5REdTRjRQZndJMGN6aTg3cjliV25WVm1TTnRmSjc0K0pi?=
 =?utf-8?B?ZEZ5K2VrMHp3ZCt3Z2ZNMmJLbEd3Rmh4Qm5nQ2RjcThjM2xEdTlMVEtOc0hH?=
 =?utf-8?B?emtGaDhkaCsrWlI0bHp0K2ttUUdjcGRpZmN4NHpiZEs3elZoOEdiQ3BaUDg1?=
 =?utf-8?Q?tE6uC2UXqD1rsBiBEGikLvh+1?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e3eec24-ec63-45f5-bfc2-08dad7aaf71e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3406.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 16:57:31.8621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wvkPiiOnXK5A3y+WfNoQjMOHKHz5ch5BJWpBBtJoY9F95oDaKHc2HsEDcqvB2xDJQgXUg49D/71T2F5yLgekrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7744
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 20:54, Petr Mladek wrote:
> On Mon 2022-12-05 11:35:57, Petr Pavlu wrote:
>> During a system boot, it can happen that the kernel receives a burst of
>> requests to insert the same module but loading it eventually fails
>> during its init call. For instance, udev can make a request to insert
>> a frequency module for each individual CPU when another frequency module
>> is already loaded which causes the init function of the new module to
>> return an error.
>>
>> Since commit 6e6de3dee51a ("kernel/module.c: Only return -EEXIST for
>> modules that have finished loading"), the kernel waits for modules in
>> MODULE_STATE_GOING state to finish unloading before making another
>> attempt to load the same module.
>>
>> This creates unnecessary work in the described scenario and delays the
>> boot. In the worst case, it can prevent udev from loading drivers for
>> other devices and might cause timeouts of services waiting on them and
>> subsequently a failed boot.
>>
>> This patch attempts a different solution for the problem 6e6de3dee51a
>> was trying to solve. Rather than waiting for the unloading to complete,
>> it returns a different error code (-EBUSY) for modules in the GOING
>> state. This should avoid the error situation that was described in
>> 6e6de3dee51a (user space attempting to load a dependent module because
>> the -EEXIST error code would suggest to user space that the first module
>> had been loaded successfully), while avoiding the delay situation too.
>>
>> Fixes: 6e6de3dee51a ("kernel/module.c: Only return -EEXIST for modules that have finished loading")
>> Co-developed-by: Martin Wilck <mwilck@suse.com>
>> Signed-off-by: Martin Wilck <mwilck@suse.com>
>> Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
>> Cc: stable@vger.kernel.org
>> ---
>>
>> Changes since v1 [1]:
>> - Don't attempt a new module initialization when a same-name module
>>   completely disappeared while waiting on it, which means it went
>>   through the GOING state implicitly already.
>>
>> [1] https://lore.kernel.org/linux-modules/20221123131226.24359-1-petr.pavlu@suse.com/
>>
>>  kernel/module/main.c | 26 +++++++++++++++++++++-----
>>  1 file changed, 21 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/module/main.c b/kernel/module/main.c
>> index d02d39c7174e..7a627345d4fd 100644
>> --- a/kernel/module/main.c
>> +++ b/kernel/module/main.c
>> @@ -2386,7 +2386,8 @@ static bool finished_loading(const char *name)
>>  	sched_annotate_sleep();
>>  	mutex_lock(&module_mutex);
>>  	mod = find_module_all(name, strlen(name), true);
>> -	ret = !mod || mod->state == MODULE_STATE_LIVE;
>> +	ret = !mod || mod->state == MODULE_STATE_LIVE
>> +		|| mod->state == MODULE_STATE_GOING;
> 
> There is a actually one more race.
> 
> This function is supposed to wait until load of a particular module
> finishes. But we might find some another module of the same name here.
> 
> Maybe, it is not that bad. If many modules of the same name are loaded
> in parallel then hopefully most of them would wait for the first one
> in add_unformed_module(). And they will never appear in the @modules
> list.

Good point, a load waiting in add_unformed_module() could miss that its older
parallel load already finished if another insert of the same module appears in
the modules list in the meantime. This requires that the new load happens to
arrive just after the old one finishes and before the waiting load makes its
check.

This is somewhat similar to the current state where new same-name insert
requests can skip and starve the ones already waiting in
add_unformed_module().

I think in practice the situation should occur very rarely and be cleared
soon, as long one doesn't continuously try to insert the same module.

> Anyway, to be on the safe side. We might want to pass the pointer
> to the @old module found in add_unformed_module() and make sure
> that we find the same module here. Something like:
> 
> /*
>  * @pending_mod: pointer to module that we are waiting for
>  * @name: name of the module; the string must stay even when
>  *	the pending module goes away completely
>  */
> static bool finished_loading(const struct module *pending_mod,
> 			    const char *name)
> {
> 	struct module *mod;
> 	bool ret = true;
> 
> 	/*
> 	 * The module_mutex should not be a heavily contended lock;
> 	 * if we get the occasional sleep here, we'll go an extra iteration
> 	 * in the wait_event_interruptible(), which is harmless.
> 	 */
> 	sched_annotate_sleep();
> 	mutex_lock(&module_mutex);
> 
> 	mod = find_module_all(name, strlen(name), true);
> 	/* Check if the pending module is still being loaded */
> 	if (mod == pending_mod &&
> 	    (mod->state == MODULE_STATE_UNFORMED ||
> 	       mod->state == MODULE_STATE_COMMING))
> 	       ret = false;
> 	mutex_unlock(&module_mutex);
> 
> 	return ret;
> }

The new pending_mod pointer has no ownership of the target module which can be
then destroyed at any time. While no dereference of pending_mod is made in
finished_loading(), this looks still problematic to me.

I think it is generally good to treat a pointer as invalid and its value as
indeterminate when the object it points to reaches the end of its lifetime.
One specific problem here is that nothing guarantees that a new module doesn't
get allocated at the exactly same address as the old one that got released and
the code is actually waiting on.

Improving this case then likely results in a more complex solution, similar
to the one that was discussed originally.

Thanks,
Petr
