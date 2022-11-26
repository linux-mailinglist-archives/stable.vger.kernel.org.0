Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE3E639696
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 15:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiKZOnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Nov 2022 09:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiKZOnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Nov 2022 09:43:09 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2067.outbound.protection.outlook.com [40.107.241.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B7813CCF;
        Sat, 26 Nov 2022 06:43:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FX0lsvnxXD5varBy+vnx4hmwfEc53Hd3JM1AZCx90N5W6SOQLajwOI4u/hcJs85Q6PYa9Y9DhCTpjFqcztbOwuyU7wnIuRHCQjm7kChz3Yz8Wi7YbhRJI1Jhm094RX92fS8Sr1Nw35MbPmiDl/Bn6kWh0EKxbLBzAhMbxdcifljdi4zLMxS8xHMxd9SJSCpWARcoRRzvZWCfXsxHvWTKfLtFpTXv2gTE30b+y6MEssbbduf+01W3ugs/re9xN/NuYxnZ0RC+jIxqJlNY2dNPTB8ix3uWeRtk1ZoqwguAvMABWMfnhvyzyAnE+FgJyUSlKeteOtGbzDwEZgljYratlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+bqL0GdXCPkYXr9IoH7Zt3D/PyKa/KqO2ZdfsZ14ME=;
 b=BsP1uu557s9URRqr8/Yl5eVWLFt8dJE50l1QsvD8cpF0jbHOnRe5kV8Sf+FykiuioAfurVmgjbcqJX4yT72Zq1PfT0xsx8xMVxpCABJL6/3a/pnJoBy1LSYYPEpXYFS/AVLr71bJ/S4G24a8DDKeXUY3CBT57P5AJ7RYYGH1ZQWH2VcaDstjhGewJ8Y59yKGGaYFEyGcz2uqO5F7H1ObzdG77TakMMkBA6GHL54ZtFuNbgZnEBWhVCCLMHeanxBNlCKYhFloI8s81yaMNa25GVUNKYygKIvxylKMnN0nF562J5a7IzfXQD66SH85SniIkHS90dRUdUpXoNkp1LFzTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+bqL0GdXCPkYXr9IoH7Zt3D/PyKa/KqO2ZdfsZ14ME=;
 b=fqHymeWxx5m8clix+xavV0WuwpMIyquCt5fsdBtozu/cm1p+NHY4tlw2W0qf76jKNZ/Iprihp9bL76PsHFpCzf2JUVBPAhNLY2bmXysl7rLbv+iSRqTB7gS7J1kfTGrpZ2MvuAQn7mN7CKxJoqV0Po/2+8iimdiXpkMH3slT36Ew49Ayuc15xKBsBXS05qnCM4cnZa1hk/GlY8bpK5Oj8u5QHyKQfXWHle3WHQnpYno/gWzGDe1HmrFZrkfrcG8vPvF3TBTA2ycg+l6cIJuWh7ZPrNNszRT03E+13gy2yqtJ7M8PG0j/B9LJwX4sQGVtcJGM/y3bLCAR3GpCroJGYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR0402MB3395.eurprd04.prod.outlook.com
 (2603:10a6:208:1a::16) by AM0PR04MB7154.eurprd04.prod.outlook.com
 (2603:10a6:208:19f::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Sat, 26 Nov
 2022 14:43:05 +0000
Received: from AM0PR0402MB3395.eurprd04.prod.outlook.com
 ([fe80::14eb:6506:8510:875f]) by AM0PR0402MB3395.eurprd04.prod.outlook.com
 ([fe80::14eb:6506:8510:875f%7]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 14:43:05 +0000
Message-ID: <a26ed87f-9e4c-7c1f-515b-edaaff9140fd@suse.com>
Date:   Sat, 26 Nov 2022 15:43:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] module: Don't wait for GOING modules
Content-Language: en-US
To:     mcgrof@kernel.org, Petr Mladek <pmladek@suse.com>
Cc:     prarit@redhat.com, david@redhat.com, mwilck@suse.com,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20221123131226.24359-1-petr.pavlu@suse.com>
 <Y348QNmO2AHh3eNr@alley>
From:   Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <Y348QNmO2AHh3eNr@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0007.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::17) To AM0PR0402MB3395.eurprd04.prod.outlook.com
 (2603:10a6:208:1a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3395:EE_|AM0PR04MB7154:EE_
X-MS-Office365-Filtering-Correlation-Id: c6b883ed-84ae-4aa6-51e0-08dacfbc86a4
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fRk6qxC+5Aw/K5n4VKLJnoGVoSxEKHXv0f+i3JWCOOmZX2lS/6xux5tDLjrBnBT1WrjHfR4ihyE4AFl96RzMAUNfshDVSRwSy0EoitvGMN/+RO8czSenPczoPuvHaq+VK/qXZFko5Dk8KRnsGv5jWA2re3uXkSHqxuJrsD1gUV5jd4JodI/zA/llZoQRwVnSYr5ttm+i3tn8GGEKeXttfHnrXhK1VnE5n6ZKVN0WMUS0GJs7wzx4vK+uL2luiPgLlHKyCV2fFnBEWEigyaD1mfZ7XQWHbEwSnVErztz5IWCPK6QMIQ3Tws5JkcCV0V1mXMaA26Z/6eb/YjO7HpN9fo7XXjktFn9dptUtQR/YP3kXeUiQ/WAffSOn1QtWVN4oR9QPkq/dt9W55iusUOJuiXfJgLG3CnjqW17nivY6jacAUW2TrKU6RuEsZRhpcmbOurf5F13NO2AcTdzu2O6HmcsqYd2TeDRQdor6/nbWoMAtIMLcAFgaUMKUd7hwoWPUD+IBAbaxqKwrBRCkMK+freBkMpQTeEoNwOUPtviqcdqF2j70TyM0e8ucB4vZXhovqxE0u1OVBTm8SzPzM9NfgmGL6s+xpxvJOVhuwmNaBtbdxGDfSrSvqyE86pC2LPoFpMEnWYODckxiyY+qfa6ng9H9e/hTRJBrBBPk2g6BadI3pig4ro3VipTiEMq9tLQe1YhDx2wP9o/jPTLgXaRbmNkpoNmwlLXJJXpIFEMWke6BaoIfANY53FsC6xm86fJA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3395.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39850400004)(366004)(396003)(346002)(376002)(451199015)(31686004)(36756003)(38100700002)(4001150100001)(2906002)(41300700001)(44832011)(83380400001)(31696002)(86362001)(66946007)(66476007)(6636002)(37006003)(316002)(6486002)(966005)(8676002)(66556008)(2616005)(478600001)(8936002)(6862004)(5660300002)(55236004)(186003)(53546011)(6666004)(26005)(6512007)(4326008)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzNuYjhIUHdmV0Y4eDUwaUhLL25rOFJVMnk3SktNZmpHbzFCbHB3ZW9JVWpC?=
 =?utf-8?B?aUZ5MFp2TGxHWWVzdHdXdHpsUFA4cFk2MHNoU213L0pDK1ltTm9ZdmF3UU5E?=
 =?utf-8?B?dGxZVmo3akFKc1NlZjJTVUhVL0lXSEJ5T1BkT2xodUNZbDNyZEhHZmpOY2Vj?=
 =?utf-8?B?VVlNbjFkTzhlZEcxU241bjhMZlNMcnJPaTlNWkxXeDN0aE1Hd3dpVHFSMWtq?=
 =?utf-8?B?TnU5MDBkYTJDeWpISXFQdmZZTVlxcWJzaWtucHREWlRZS1ZYL0YxRlp2dnJS?=
 =?utf-8?B?UFJ4NTNvZllKSWRRMUt3Y2F1REJUSXA4UTdIN200c05oZHZ5cjV6cVVjbVJr?=
 =?utf-8?B?OHhOMXFwcGc4OEppYXY0T1ZMWEtmTXdYSllvRHFySnNEaU1xMnVhdi9sa1V0?=
 =?utf-8?B?c3N4L2d6c0R5anN1WnpDM1JCUmtmU1lpNjVwYVBDZmlWak1hOVlCVDVzVFQ5?=
 =?utf-8?B?TlVNaHRzYjZ2bVJmMWVjRWhRNlhQeXF3K1JiRTl5aG56Qy9xSU0wMjlGOVJ5?=
 =?utf-8?B?dkVnTk9vdDkrN0dUWitTcU1BMVBXYWdBVlFlZ1ovUVpRSzJqQ29ITldsRk51?=
 =?utf-8?B?NS9MYlcwbTlTMDh3bVpnQVRZdkwwYzl2WDVxbEpVRGl1K3BBTkNxbFBBL0RK?=
 =?utf-8?B?KysxZTUxUzcrVlArbyt5NDBqc3FGZVExS016dzVGbkxZTUpuT1Ntd3pXbGtR?=
 =?utf-8?B?cnpOdTVMaDIraHlUZ0ZwMW1JK3REbmppMnFMa09FUXRKaFhaOUt0S2NLWE9v?=
 =?utf-8?B?MkNUaGs2eCtUNFZiOXUxVnN3Q2JRM2ZrU1VpYmgrc2R5VkFDUzlBanQyYTRh?=
 =?utf-8?B?cmUvQm5vaGR3L1ljVmR3ZnE3cVpvZzU3VTBsb1V6ZUxCR2U2SUJsOTBHYThn?=
 =?utf-8?B?bHU3R3piQTc0RGE1N1FVcEFMOHN5emxoRXhpOExIRU4wdFh3NGlGM3ZIR205?=
 =?utf-8?B?bHQ2R05zK1RaTUwyYVZESUJLWEFWVThiVi9TQkpTQW1qZkRJVVJNTi9wMTA3?=
 =?utf-8?B?UDI1RzU5ZDdrcjdEQ0s5dGJEMjhaQzN0akNVMTNxWFBybUQ3enNsKzY2UGVM?=
 =?utf-8?B?MGQyMjZITWVpbno1SHZ0RzNkc2EyRXM2VW5uRUhlcEJMZjFUVGFGUnF4dzhX?=
 =?utf-8?B?ODV4QzhhajBKQUpNYmUweWcxbjc5V2VKN05XMnAvUHFrWnhqeGVYWEgrY0V4?=
 =?utf-8?B?TUZva2RqTUo0dmFSTnFNS0FKS2pHRlRuNk9Ld3ZmR05oREJmYzNvTXRNKytE?=
 =?utf-8?B?OElUdzNGUU9waGVtSnRVNlFpZUxPVWRoTEliZmRZZFZoVlJjSjJpV0pKdlEw?=
 =?utf-8?B?Q2VSVUdvOW1KWWdPbXhoYlhmcHNUMVVyWFRQTk03citTR1g2QWZzMFF4cmMz?=
 =?utf-8?B?WHl0dmM0TU53cEJZbUtGQkg0WE9NaXA2aFZUNzlKZ1JqVDVyZndRRm5KV1Va?=
 =?utf-8?B?KzBqQWZXOWJiaFFXaDkxSEUrMGM2OGpTUFZFTFFIMlloR0FJei9UTnkrRTRZ?=
 =?utf-8?B?bGdYdi83MWsvYVh5UTRWdHJEa1RtM3RLMzczRkVzRktnZmFqdGxFSjRpeUhO?=
 =?utf-8?B?R091ZFhyVjNpS2JJWUErNVd5bnJRTGF2bnpqSVhNN25EOWM4SFozWDcwZVZs?=
 =?utf-8?B?WXBRS0pGRUJzTTJNMVloamZTSmpvNHppQWd0ZnFqTHhwRi9uMnBqR1l5V2Na?=
 =?utf-8?B?VEw5SjgwNVRicVY1eDJ4SWIzWThXanpxeXc1bncxZUo1SExMYkRGN05XZTRx?=
 =?utf-8?B?d09IWkZxL3ZXSU9WNm9yQlk2ZUprcVNwaUNxNU1Td1dtQi81VVFBQndZQ0xB?=
 =?utf-8?B?Q0kweFp5dVBlSjdkNnBwWXd2aS9FQUx2ZFUwTDUxTm9TcnhkL1JQdy9IZ0l2?=
 =?utf-8?B?T01VSTBwUlBGQVBIYmhray9pV01zR25rRWI1Z2xsMVA0VmxjenZQbHVJT09P?=
 =?utf-8?B?OTloMDNlN0JYUVBMTVpDQzYvVnRaYTBCYThDZ2FlRW5jMkdwRDRwQkY3Tmw4?=
 =?utf-8?B?VURULzNKSWdNd1lReGNEOUlsVWFKYXdaZThibkROMXRGZTNPMVRqRk95Zzd5?=
 =?utf-8?B?Y2ZJaHhmMWl5Zmc0M00yY3pXVU9PUElMRGlSRzhFcm02RVZ5Qi9OUkVvbHVT?=
 =?utf-8?Q?dnO6umH8NiAchNWzD5Ikj46tV?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b883ed-84ae-4aa6-51e0-08dacfbc86a4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3395.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 14:43:04.8719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nUO3R1lMR4/TIh8qAvqqW9lwbXg8eAqZlWgXpSbbJLHvsDVXieZ+P2FEBBWWH7oGVqh0Q88auOF/QVg9S6G0Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/23/22 16:29, Petr Mladek wrote:
> On Wed 2022-11-23 14:12:26, Petr Pavlu wrote:
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
>> Notes:
>>     Sending this alternative patch per the discussion in
>>     https://lore.kernel.org/linux-modules/20220919123233.8538-1-petr.pavlu@suse.com/.
>>     The initial version comes internally from Martin, hence the co-developed tag.
>>
>>  kernel/module/main.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/module/main.c b/kernel/module/main.c
>> index d02d39c7174e..b7e08d1edc27 100644
>> --- a/kernel/module/main.c
>> +++ b/kernel/module/main.c
>> @@ -2386,7 +2386,8 @@ static bool finished_loading(const char *name)
>>  	sched_annotate_sleep();
>>  	mutex_lock(&module_mutex);
>>  	mod = find_module_all(name, strlen(name), true);
>> -	ret = !mod || mod->state == MODULE_STATE_LIVE;
>> +	ret = !mod || mod->state == MODULE_STATE_LIVE
>> +		|| mod->state == MODULE_STATE_GOING;
>>  	mutex_unlock(&module_mutex);
>>  
>>  	return ret;
>> @@ -2566,7 +2567,8 @@ static int add_unformed_module(struct module *mod)
>>  	mutex_lock(&module_mutex);
>>  	old = find_module_all(mod->name, strlen(mod->name), true);
>>  	if (old != NULL) {
>> -		if (old->state != MODULE_STATE_LIVE) {
>> +		if (old->state == MODULE_STATE_COMING
>> +		    || old->state == MODULE_STATE_UNFORMED) {
>>  			/* Wait in case it fails to load. */
>>  			mutex_unlock(&module_mutex);
>>  			err = wait_event_interruptible(module_wq,
>> @@ -2575,7 +2577,7 @@ static int add_unformed_module(struct module *mod)
>>  				goto out_unlocked;
>>  			goto again;
>>  		}
>> -		err = -EEXIST;
>> +		err = old->state != MODULE_STATE_LIVE ? -EBUSY : -EEXIST;
> 
> Hmm, this is not much reliable. It helps only when we manage to read
> the old module state before it is gone.
> 
> A better solution would be to always return when there was a parallel
> load. The older patch from Petr Pavlu was more precise because it
> stored result of the exact parallel load. The below code is easier
> and might be good enough.
> 
> static int add_unformed_module(struct module *mod)
> {
> 	int err;
> 	struct module *old;
> 
> 	mod->state = MODULE_STATE_UNFORMED;
> 
> 	mutex_lock(&module_mutex);
> 	old = find_module_all(mod->name, strlen(mod->name), true);
> 	if (old != NULL) {
> 		if (old->state == MODULE_STATE_COMING
> 		    || old->state == MODULE_STATE_UNFORMED) {
> 			/* Wait for the result of the parallel load. */
> 			mutex_unlock(&module_mutex);
> 			err = wait_event_interruptible(module_wq,
> 					       finished_loading(mod->name));
> 			if (err)
> 				goto out_unlocked;
> 		}
> 
> 		/* The module might have gone in the meantime. */
> 		mutex_lock(&module_mutex);
> 		old = find_module_all(mod->name, strlen(mod->name), true);
> 
> 		/*
> 		 * We are here only when the same module was being loaded.
> 		 * Do not try to load it again right now. It prevents
> 		 * long delays caused by serialized module load failures.
> 		 * It might happen when more devices of the same type trigger
> 		 * load of a particular module.
> 		 */
> 		if (old && old->state == MODULE_STATE_LIVE)
> 			err = -EXIST;
> 		else
> 			err = -EBUSY;
> 		goto out;
> 	}
> 	mod_update_bounds(mod);
> 	list_add_rcu(&mod->list, &modules);
> 	mod_tree_insert(mod);
> 	err = 0;
> 
> out:
> 	mutex_unlock(&module_mutex);
> out_unlocked:
> 	return err;
> }

I think this makes sense. The suggested code only needs to have the second
mutex_lock()+find_module_all() pair moved into the preceding if block to work
correctly. I will wait a bit if there is more feedback and post an updated
patch.

Thanks,
Petr
