Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF4A63254D
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 15:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiKUOOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 09:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiKUOOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 09:14:18 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2055.outbound.protection.outlook.com [40.107.21.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC86A1A3B6;
        Mon, 21 Nov 2022 06:13:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFKXemftMMeyHLiYhM4WyZo1uT0HtazJL+HY9Fff97ZGIZ32ufsfpyYyU2Jz4/QaNXhGKFhPCehB7z4JSNI0NQQ1oqVm1TBiGoDbndGCzYNCPUr3N/zwWerpyfiZ64hRFroM1XCvfP03SDyOdf8GjU5KhGAocEF5y8Gg69yynyiGXpP0Io4CSqjsNhi+vC+DL5Kzfqy5SxjkG2NRoW3wrsUGAzWf6z7LmwiindVmVkEGjNOU9XfcmOpjO0LU0Q/ihbdPFbHufkqVqomije4j45llw5ENCPqlalOOpYK/UdAq1CJGZ3jfO4KJREUBAi5sZAF/X36Lz7/NTqKu0wWKbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BiQfIr9QNmNdqzrWkESllByDiNlkhrvXBEeYIIgQsQM=;
 b=Ha0uzuo/sGC4a6ne9alxrilMi69Ct8A8F2VCHj75AL1JR2SMnKsjeoTNeXiOqsFuAj1KXfuXoii2sINCJhdcWh6EksOjP4M6NmX8rCf/NGnJNcofOvWVWFTVtPMrxLrOdckLqHQZYVaY/PEd4h+qNmY3poC7Ixo78E0ZBQLDp1Qpr7mn5gFj+07/lDZfTvEVU6ZUQbk4R8RDwaI9OT2/LhZjtEtRam9ycp3YEjbexprKu65LZifqa/3blymUwbsLKQNGcnvqmCGTBi7KzEpU4pJ0adjvloIgNLhvGVjqgO2n2NmUJby1nMW04WioYt6gU96W6QBlABahwF7H7W2Plw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BiQfIr9QNmNdqzrWkESllByDiNlkhrvXBEeYIIgQsQM=;
 b=zufbeLq24UbFuIu1RzIi4NyUZJRcxsiuLwLJqRCvOfmvdZW05xcU6wiDlUpb2mO98fbZDQYs4IN2LlzTQezMilzsa06lj+4GqHxs2tbtvHOKezlDjAACfV8bhHf6NqWPs7YWN+gDf39GJQPgsbVk6E37fZUh0s2BG+tfdrsIb+yMiGGZ9ZeFHgbwO+wNYaJalxcYAYXF1pWPJm5PxzDbL28wQtCUGz9jxXZg3W6j8VSKnPQK/I+n+iN9lELRc8e21KG5TKav7AemvEzlFp3/mAJrKjymxR5lws9kWIuab7SRkidhhUGb20FWCFjkXvzzQPvW/94U0X3UaSBkpctoAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AS8PR04MB9174.eurprd04.prod.outlook.com (2603:10a6:20b:449::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Mon, 21 Nov
 2022 14:13:24 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::4da2:ea8b:e71e:b8d8]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::4da2:ea8b:e71e:b8d8%4]) with mapi id 15.20.5834.011; Mon, 21 Nov 2022
 14:13:23 +0000
Message-ID: <c1cbc937-b155-9730-148c-94425b6b5a8a@suse.com>
Date:   Mon, 21 Nov 2022 15:13:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 2/3] acpi/processor: sanitize _PDC buffer bits when
 running as Xen dom0
Content-Language: en-US
From:   Jan Beulich <jbeulich@suse.com>
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
 <bac0ed0f-6772-450b-663c-fc0614efa100@suse.com>
In-Reply-To: <bac0ed0f-6772-450b-663c-fc0614efa100@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0199.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::16) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB6560:EE_|AS8PR04MB9174:EE_
X-MS-Office365-Filtering-Correlation-Id: ddb42abc-bc1d-4041-2cba-08dacbca8d1d
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RezsW0DTRb6OStLxb93IEjmwDCwXS7gu+sS5LvcYV1yqEobQnzL+eYrcVYvUvcVC2DejvDk8wdGkdt4jPC8dh6XU9ZxROw0KP8afiz8+F2ytd5Xch17Tlw+BvyKOozY6Mx0bS+nGSD6Vut+2IsjR6EXCtiYODkLwtdSOYhNE5YwfGEqEgRNn27L7NWHa4aU0fzwJnsRXzo7OZo+6oZqrEpknpKstZV0pmRT39k0VgIFV3+12SSHayRRq8iwzsyGs9EeUX6FbhaxOuXMGp1j970v3dtw88r0WGZ9Oy5Qxoca1E7cm377oOppnt2ymOUy+YLNB4u5oDdLNmoJj8LeqQDuLUmb1crb09t1ZfLYPU0Mez+yRw2qIUAQ5E3ObKORYU6ZA5H3blsBGglWZU3l2h2cDcDFOUEoPlWlvlw//kTvc+2VoO3uksWimwZgjfuO8rHJtcUJK+JBIE8KN0MkyTJOBnDlA+hrV22FVVDe7SkgkgPYLqwwRzas9lzbL1ddPxq/HO9hZlKmujThC8AxV3flQ+hwN4wJm9ehfJYd373KKxvKqASjkAfWi7UzOVIlScFHa1zJfpQjAtSNOAPS+BD3yiZrCoLjLXeozTqd0tTNik0KaKx82B0RlIBysP/82iBZSYixJaQ7Ocoh6jbNyHmqk+u5EjcmWmPjoPYr7JD2jsrcf/GTHsqAni/oazgiz+xDlJ7ZiFrmBvd5kair8RA7VGYKcW62F37BvIm995Zo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39850400004)(346002)(366004)(396003)(451199015)(186003)(6486002)(2616005)(83380400001)(66946007)(31696002)(86362001)(38100700002)(5660300002)(54906003)(4326008)(66556008)(8936002)(8676002)(66476007)(41300700001)(6916009)(316002)(7416002)(36756003)(31686004)(6512007)(26005)(53546011)(478600001)(6506007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGdLa1Y2TmxyNU1jNytwRWhueFBEZkZOdlkzRWtQdG4xVnVJeGw0TFdvMS93?=
 =?utf-8?B?eTlrb1M3bU5rRTVqZTFwWG82YjE0R2hLaW9ZSzc4UUpnRmQ5UTdvMnIrbkxn?=
 =?utf-8?B?UkNsRldXcStXNFJRUjVSUVE4TmxtV2NpYjNnWmMvVytILzVHZ3FHUDBqY2hk?=
 =?utf-8?B?SDFNV0ZFYlYwWE40d3k5ajc3R1NtTFMwZnA3UWs1K1FHWFhRMjJ5YmlxMUwx?=
 =?utf-8?B?NDNwMlluOWJmbFprY1gzR3dUeHpRMUNCbExiRDBISjU3a3k5bEFPZHp4bHFW?=
 =?utf-8?B?Q3RWa1ZIODFUenY1V2tHOXVvV1lkNXhONS9Ia0NNZHlzeUZ4T3pGNUwzZkNk?=
 =?utf-8?B?MmVTaXNXaHRQWFowUWdhVytlRXQyeUh2TEw4TGhOTHZGV2lZUW80TExZMWk0?=
 =?utf-8?B?M3F3SlZhVlVFakowV1hvWDdQTWkrQ1hjYm5ZR3BOaUF6KzUwelJVYzV2ZCtu?=
 =?utf-8?B?VzFDK1R3NDRoVEFKc3I5OGRaZFlqTWg2VXllOEhDZXcvN3F4aWdURFpIOVZZ?=
 =?utf-8?B?dmdSM00wY2c5VVFJR1l2MmliWXBhTmx4QVdjcnAyZTh5YzJHUmt1MkpadGdn?=
 =?utf-8?B?NS9VZFlSVElKNm1oTmw3UnlUWXAyY2lZZEg0WHNzZVNxR0N5QnV3UHN1RDdx?=
 =?utf-8?B?SW9PenpXSVM1aHhGZjFBakQ2ODNKMlN4L3RsVmdYUFg0QTk3RTZPMThnR2NB?=
 =?utf-8?B?TFBTUzFmZ3ArUm5xWHM5QzBFcm9GK05PQ1NyakttakM1K3BMeUlLNlkveVJC?=
 =?utf-8?B?NU51UlZRaDR2d29xdlFIYUl0RWNiU0xnZHdhc2VNRWUxZGk2NHpMYitQc0t1?=
 =?utf-8?B?L1JXNC9oclBIUVB3ZElIVHJvUC9TVitLQnhvbHVhVlZwT2lreVYySENjeGRY?=
 =?utf-8?B?K29CVnBwVTQ0ZDRwVEI4d0hlZHBQdVd6eU1aeHhYdkl2T2ZpR0NOUjU5czA3?=
 =?utf-8?B?ZU9CSlhncXlsRi9vRTlQOEpHajF0SU5YVUQ0VFZmajFZelgvNE5TSHNLZzVy?=
 =?utf-8?B?SGJsVndOUUY5WEF0SnE0ZU5mQ1VEYjY1bHNNUFBXZjZKSmVBd2ZCNkpPL2FI?=
 =?utf-8?B?OEdOekNaY2swcEtCdFZ2MGJIWnpMQi9Xam5xT0d5OWdSUnZ5NkJPeWZhQ2dF?=
 =?utf-8?B?L2xkRmQxRUhId3ZZY2czeFR2UGZUam5Qb240ei95SksvTnZ2bmN1MkY2SW1T?=
 =?utf-8?B?Y055ZFFJbzl6WnJzSU9sMXZNcHA5K1U1dE1LSEJ1UXBJL3FnL3A1ai9XSzc1?=
 =?utf-8?B?V0RJcVdpa3htdHQ0MnNFVFBEM01ZSDFsWGUyYUdXSG1uNSthQmxFekp5VjM1?=
 =?utf-8?B?eWt6bzNhTzNJWnRmL2tLblRRcWtKb1VIT2YxL09aZDdLSE1BWVF0OEtPTGs5?=
 =?utf-8?B?MzF4VHdvSGExeDFWZEtEUXllR0wycWNzaXFsblhqdmJqMjdUeE9kMzNkYXBm?=
 =?utf-8?B?NmpLMG1WaGNibDNLNk5ZWlV3Y1hxaWdmZEl0Y3hPUUdoZGMvcXdSYitiY2pO?=
 =?utf-8?B?ZmJtUEhCbFhaVnRsZjZ2K0EyWUVmUTdyNG0yQTEwM1VXQjdhdDlDL0FGRlly?=
 =?utf-8?B?QTZpWFhMa3R2N3JxRjJiY3hYY3NVSVBYZ04vVHFzdFkxLzQ3MkI0aERSVjhk?=
 =?utf-8?B?TkVDUm85aHlFNm0yZGJCUENxTzJ5bUdOUmlST2dNMDRxbVpWeDVlcU1kaTZS?=
 =?utf-8?B?YWh4T25GeXV0QkZadEI4bDhNVDMvU2U1dUllSWRzdk9sOE5aRUFXU0c0aGds?=
 =?utf-8?B?TDlibWcvckZWMGhCZmJIVmtJM2VzOWRqbXdsYzZhbWFXUGlUbnVIVkRZMXBy?=
 =?utf-8?B?bUJXdGlPTFdLaVoyNlVaaEdvUzJkM0FWeVBEaDgyQ3BGWS9kd0tKWFJUM0xZ?=
 =?utf-8?B?c3BzMEZ2K2VmRys3Zmd4WmRiRDZGd2ZYcjJOazd0MjBuMTY2VGRCOENIYVVn?=
 =?utf-8?B?azF1ekxjN1pZZG4wL3h0QVJCR2tVa2dXNGIxRmxySXhEKytRZmtGR0FBSmdE?=
 =?utf-8?B?aUY2dUt6QmtjSTViUTRKWFFGUkR4Z1RLZkNnbDJyVjNCc3VmWkpoVzIzSUVk?=
 =?utf-8?B?eEpDWkJUWXhJdXJ5SUsrYlNVMHB4MjNyd0ZNRUdSa29nWEFTaTA3Umh5c3VP?=
 =?utf-8?Q?gU/fBhhaLuFZ/LY7wJKQgckY/?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb42abc-bc1d-4041-2cba-08dacbca8d1d
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 14:13:23.9084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuN4G6hgcfp3p51OaU77D+qPd4ZiBrrs3WAqEsIzzE4dZ+SopKhWQb45u5gUkY2SQuWtvIFLh/TBUeE28uEVNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9174
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21.11.2022 15:10, Jan Beulich wrote:
> On 21.11.2022 11:21, Roger Pau Monne wrote:
>> --- a/drivers/acpi/processor_pdc.c
>> +++ b/drivers/acpi/processor_pdc.c
>> @@ -137,6 +137,14 @@ acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
>>  		buffer[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
>>  
>>  	}
>> +	if (xen_initial_domain())
>> +		/*
>> +		 * When Linux is running as Xen dom0 it's the hypervisor the
>> +		 * entity in charge of the processor power management, and so
>> +		 * Xen needs to check the OS capabilities reported in the _PDC
>> +		 * buffer matches what the hypervisor driver supports.
>> +		 */
>> +		xen_sanitize_pdc((uint32_t *)pdc_in->pointer->buffer.pointer);
>>  	status = acpi_evaluate_object(handle, "_PDC", pdc_in, NULL);
> 
> Again looking at our old XenoLinux forward port we had this inside the
> earlier if(), as an _alternative_ to the &= (I don't think it's valid
> to apply both the kernel's and Xen's adjustments). That would also let
> you use "buffer" rather than re-calculating it via yet another (risky
> from an abstract pov) cast.

Oh, I notice this can end up being misleading: Besides having it in the
earlier if() we had also #ifdef-ed out that if() itself (keeping just
the body). The equivalent of this here might then be

	if (boot_option_idle_override == IDLE_NOMWAIT || xen_initial_domain()) {

Jan
