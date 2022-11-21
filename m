Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861A5632538
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 15:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiKUOMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 09:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiKUOMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 09:12:10 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C7DFAE4;
        Mon, 21 Nov 2022 06:10:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PB64rKASW9TdovkFi0wr4fRwsBI2skZZzMhH8A2JQBSFF/qovhnXyYmeeJZ77YHRF6GhHSiaztMpoYsrg7TIe/SskbHjg9zShFpvVE2K2vX5yC3OW3B92lfIvYJiGhpQRb/1Fmwc39ICSXGoyy3VUm/CbBpGRT9wzz3dljzaf1Z9Y3YLD0/dN5rtlbQ5ureAVZqWIHpRaM8PdNoiV7GHx/aJDJjrN2WNIov+TgPZ3qKksRZzlLWFfEelZYiIL5lFLmS5GFMH9qOkWauHIyAOpvmxXW6dQDyILMxq/YR52PE/wPb/teliZ+Yo/XemAefK8vQDbcvh7E5vMYmQGi79uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uqGaJMZncYNRrX5y3Oe4JYlD/pqZ6PvqNDJzlD83cig=;
 b=GbD/q0CHH+ftQZuj16ES82UXhXRdH/q5YbjIB8Kn+60e3i21HdAcg1rz1oFFBOxawWcwttO1d2/EHYcY/BBSzSQIU+9NUKrFIJ5SqG6wXMlZIGA1ErFWCTg5a+wnVIGFzY9N3wndmAM0NOYA3SJNNTpww3F/w/uIMy9wm6k71aGdzVPG6oIsFmOL6XTXu080DiKYPNacVZnUWdrEptT+WG9947fCGnsXneDSRTvujj1TH97YASVAXNlVpOM4f914m5S9BP3ySl1lqIvi984trvdrVDF75P2/x75flnLrEuaW5z3Rg/P+B8fL53wUIRHv6BU70sISEBNvKqftiy2t6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqGaJMZncYNRrX5y3Oe4JYlD/pqZ6PvqNDJzlD83cig=;
 b=v6r3+Y4WEq2llyvtGv7JE0qpbLI7IOq0xCoZs8/cPdYEf5be1cmEcO36a5AnxwwGyIQeSgxlXAPizEu0vzW6VUtxO1vkSSS1ruGnCZzAHrb1fqGIKybuUp78Aqkxkf4e4Ov8nST6fT3NhHZOz96v4cgGqnVH5Dkb0ejYFVhll8JkR1vUQR3G/0I8S2vvW0cDiTSXgFOAeIUCOuIrm+4/v9LdplgdcTyUm0UZIdB6MtIfa1W9HefXKXE2GwAuNr+dlpsk9bikr1NUzYo7+kbag7RVTYPe37RkRRqaBgMFt1r8uNV0D9EotyMQxewD8p2qLMCcPVek6Tp3yt+28eLA4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by DB8PR04MB7147.eurprd04.prod.outlook.com (2603:10a6:10:126::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 14:10:38 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::4da2:ea8b:e71e:b8d8]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::4da2:ea8b:e71e:b8d8%4]) with mapi id 15.20.5834.011; Mon, 21 Nov 2022
 14:10:38 +0000
Message-ID: <bac0ed0f-6772-450b-663c-fc0614efa100@suse.com>
Date:   Mon, 21 Nov 2022 15:10:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 2/3] acpi/processor: sanitize _PDC buffer bits when
 running as Xen dom0
Content-Language: en-US
To:     Roger Pau Monne <roger.pau@citrix.com>
Cc:     xen-devel@lists.xenproject.org, jgross@suse.com,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221121102113.41893-1-roger.pau@citrix.com>
 <20221121102113.41893-3-roger.pau@citrix.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20221121102113.41893-3-roger.pau@citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0150.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::11) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB6560:EE_|DB8PR04MB7147:EE_
X-MS-Office365-Filtering-Correlation-Id: 28eacf66-2bab-47cf-dc74-08dacbca2a5c
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ArLkeVlyKAUsEP+nOPGBZSxFsigrfcNRh6/qrkllximvqxqq24T2Qr5XXBJk9geNdEF8KjmJ9qlBQmVQ0UNxAtHCUHs5jIjGUWZ2g4et7aslOWtbBCSLuSj5W4uoE6YMvkhkyAx/T4v6vP5ArKBeLNj8aUIBiZePVTnfoy62uKGgQGGcuM9XxFTIoelXmwsPjzAL6q0XT8Up2qWNpun3EgTz1jl0Mq0uyStH7avFKcZSWWz4CazpClxlfmW4fmjac71wJ20tSEldUE8aN4iVBoeyBHcsOM4jL9tUcbiJznCu42ThWah2/SKZY3uVZNv+flAmydZqmPQTbXEJrnPghwbZJmHSBJbQsKhZgtss1ApQs6GzWJxRW7kUR5yQTbZMZ3iXNVkvolrTyN9cglTc+SbNdMw+Pmz3Z1xJl8lLo+IpMDb8uFWcsI0TmYjmL3lRqBrEeI9LI/TltxfKFlHUUmUSbIxkBjOSaAnXg1bB1DNgluWVfxH+EnKEXL4NbNx+q8kirbEL3GwwoPjDgMYc0UmiTwQhnva05qxwoF3St+uSdDB4h6+hAoaItsiOWe88pvrgSueeWTvGCfSQXpiq4X8QyD9MsBhYeqplvPc9dEE2aogiMegR2FtFC4hb+jfW493UBs0897zQdzxev23KlJu1aeyG54e48OrxZNh9lNSjR2a9MCqWdGmTclnVIlC9WAr93iOvKYut4k9bT2QFWI4wKdHI/FtpJYZ8REvNH9k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199015)(31686004)(36756003)(86362001)(31696002)(26005)(38100700002)(2616005)(186003)(6916009)(6512007)(83380400001)(2906002)(54906003)(8936002)(7416002)(5660300002)(6506007)(478600001)(53546011)(6486002)(66476007)(41300700001)(316002)(4326008)(66556008)(66946007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXZMd2NMbm5lSnErdGZhTnlndUNkVWlKLzZSNmhwaFQ5Z0ZDc3ZmVVlPWkky?=
 =?utf-8?B?TFhDaHpCTllUYUFNOHFsQ1JLVnVJellRZWNiamsxWVNvRVdtMGZybnVoL3Ny?=
 =?utf-8?B?bS9NZkZ0cEpDaG5LemY4d3hKdTBvTmd3L0cvd1FjL2JjTW5DU3ZoL21IREtM?=
 =?utf-8?B?WDVzZ0orbnEzMjZUWkQwME5vVGdSbzFHejFDUVFVaThEdkhhUmErV1VWR0tn?=
 =?utf-8?B?dkVjeDIzUmovak1zZjA5U0REckJoOExMRkJuQVp3ZVZhSmdoT1czc0VZN1lN?=
 =?utf-8?B?dGdZSzBMSXZEbndGN1ZCWUNyYnNKT3VPRlA4TTZiN3NURWdZQTBGNUZQeGgz?=
 =?utf-8?B?SGl5aTEwUE9DalVFOVozdjlzb2RjYzhSSm1ZQ0gzdTZXU2o5ak4yK1FEWGlG?=
 =?utf-8?B?cUl4UVA2bDJ6bUxaRk5OQ2Z4cFdXZHpNMFU4Ri9MMk44d2YvS3RiVXU0ZktZ?=
 =?utf-8?B?S0gvb0c5a3ZNZHoyMjdPaG9ZMzNzbkJMc2tnRmY4Zk01eXRIVE9qWmRMTHhF?=
 =?utf-8?B?REsvamhwNUpSTzIvL056YndKZEVQWmdFN3IwRk5sUUVaUGlvR01HQm1uMmds?=
 =?utf-8?B?OUVYZ0Z2TVJkNTRoKzdyeDd0Z3lVaXJXTnJmdW8zWDl1ZEtsQWt4VXR0ODFl?=
 =?utf-8?B?d1hqQWp3a2pPakNDT2s0RkNhbzFmNFA4UVNNYWFidHRhb25mNUxFMjgyRmxj?=
 =?utf-8?B?Y1VzRk52L1dRbGlWMVEwM2l4NVpkMmVSQis1RGprR0EzL2tmSzVvNTF0MGNj?=
 =?utf-8?B?dmovNWVhc2tHQW15TXBONWdvT3JvT09GaTVWcXNMOHFud09vSE5oeWgzYVJE?=
 =?utf-8?B?U0dhNlVrMkpEMDk4Sk9ydWhsVjNScWI2WWg4bjl6dzVEWWhCck5ZSEVENFVP?=
 =?utf-8?B?bU1UeUN3Mlc3VVlROEZmaHlHT0U4ZUlhSnFHYUVLVEhoci93MkVFellpNHE3?=
 =?utf-8?B?bVVnekZtMElPQmxhaEs0TU03eHQ2Sm5BaDNDQWJxazRsTmQ5YmNISGVrblI1?=
 =?utf-8?B?V1drWEgxSGJtOC9ia3ZzbVNWT20rVEVTSGd6a0U4VXBHOVFJYjB5bEp1UTdn?=
 =?utf-8?B?NnFFeXBiQW5BblcxMHl0M0d3NHR0WEkrR05DS085RGlkQUdsQTJwdHF1K0ds?=
 =?utf-8?B?c1o0bWNDT0doR0grNUduNmVScUVRRGxwMDJObjJ4RFBiUmR6ZzhjVkxJVWd2?=
 =?utf-8?B?Y0V2dG9icE9SVkQwYkZ0TFgvOGJadk9tTDVBTTFlQ1lVdTdPTCtiWFhKTUJX?=
 =?utf-8?B?S0JJeXdJSXdaaExnRTBDOWMwNHRXK3pqVjBKd3lubXJTTUw2RGYvSkZIaytQ?=
 =?utf-8?B?YWRmUUI2VDRzVUJZYldWVTYrSEVKb2ZDMEZORHpFQjZuNy8vQk1VNVlWRjJ0?=
 =?utf-8?B?UkpHUFpwU3RPZU1nSE5KaS9Gc1J6VHNkUEJ5MjBkd3F4NE1LNHBsOXhnZWwy?=
 =?utf-8?B?MTNuU01xVkJ1ZG9xZDh5WHF2ZlR5WnNSc2xHaW9sUGNUKytGOXRTNEJtS2Zy?=
 =?utf-8?B?V0RyOGFHWkswZjlRaXptejhXdEpMbGdDaUo1bmR6ZlQ2SGo5VFoxbzVmbEdY?=
 =?utf-8?B?OWpXbjUyeFBzTDM3Um1ZYXdOSytVM2hCVTVsSVRJd0NWdnpEVVJudXhNK0dz?=
 =?utf-8?B?bHh6L0tPelNkQ1NWblp6T0RLSUhWaU53Vk55YytEVDZmNXFmUDR2WHhpL2cz?=
 =?utf-8?B?RTNkaitCYS9YRVFta0UybXNHZEhrV3V5RktiNzI4VXdnNThKeDVCaE83Rm50?=
 =?utf-8?B?YjRXZGpLQWFsbS9IeGxwTWoyaldkSTAybUFVcllTaEkwY1BrTlFLd3duODVq?=
 =?utf-8?B?R2FQeTJlN1JldGgwVEtYTFBsSUlFZ2ltWWpITkhUeURBYmpTbWh4dkJGTHdl?=
 =?utf-8?B?SDlCS1ZDeUIrKzg2K2h1V0hBTk5Yd3dGZFViV0Y1aXN6SHhYSnpwd2Y2UlE4?=
 =?utf-8?B?UVdMcTBoUmg5Y3dWdkVBK3FQT2RXam9ieW9NeEJ6MTcwcUtzamN5TnN2TDlZ?=
 =?utf-8?B?Y25pZzFFb3ZIZkRLNjlMQkNjNXhoczJZU0dZekNjaml1Sm1FNzR4YXVpell6?=
 =?utf-8?B?R3N6ZG9QN0hKSVNxWmk4cVZaR3FlTDB2Z0ZzSzBhZ0VBYVFLQy9BL0tzbzR3?=
 =?utf-8?Q?r1qIgfJcn8wgWIJC7iZpuwqsL?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28eacf66-2bab-47cf-dc74-08dacbca2a5c
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 14:10:38.1845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sZd0cmQLoRVHfnpNXcGJg6DZFF7f6gjZ3HwyAaRvOwfyrfDftB0Q0L8usms4R7hSOsh91o6FotJI6ZN8kRd89w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7147
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21.11.2022 11:21, Roger Pau Monne wrote:
> --- a/drivers/acpi/processor_pdc.c
> +++ b/drivers/acpi/processor_pdc.c
> @@ -137,6 +137,14 @@ acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
>  		buffer[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
>  
>  	}
> +	if (xen_initial_domain())
> +		/*
> +		 * When Linux is running as Xen dom0 it's the hypervisor the
> +		 * entity in charge of the processor power management, and so
> +		 * Xen needs to check the OS capabilities reported in the _PDC
> +		 * buffer matches what the hypervisor driver supports.
> +		 */
> +		xen_sanitize_pdc((uint32_t *)pdc_in->pointer->buffer.pointer);
>  	status = acpi_evaluate_object(handle, "_PDC", pdc_in, NULL);

Again looking at our old XenoLinux forward port we had this inside the
earlier if(), as an _alternative_ to the &= (I don't think it's valid
to apply both the kernel's and Xen's adjustments). That would also let
you use "buffer" rather than re-calculating it via yet another (risky
from an abstract pov) cast.

It was the very nature of requiring Xen-specific conditionals which I
understand was the reason why so far no attempt was made to get this
(incl the corresponding logic for patch 1) into any upstream kernel.

Jan
