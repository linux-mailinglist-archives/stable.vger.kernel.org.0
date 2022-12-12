Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD99649D91
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 12:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiLLL3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 06:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiLLL3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 06:29:10 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2058.outbound.protection.outlook.com [40.107.21.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AD36150;
        Mon, 12 Dec 2022 03:29:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGx1G8RSODkc18w2m89mtAOcLg33mzcieUxUbdTBZYJiBOLt6l5sfYw99w+0+xVq8nsgeOV0iNgxgS4LSwYW7drgMFIAX28wxGnDW67890h9DwlVBFG2sz8wBUlxTXpPWwD5xRS3+nKHl2l9z480Pn7Ir4MRojIePBm2+ov7vpEcD/1yeIKLACI9S1Qud3wrabM0byZFv5acV0usDOaeQsb+hy8rNd7bj6O9zd24Q6RG3PZiU5MYCzhC/V3bUwO8aG0bcMM92pOzTNA0R6DVViD0AEfAXin3bHl8ejahk3DgYectwZJj9nbP5PuiYDicx+EQY3lzgx7xVaOkfQ8GPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrznfvaM441JLNM06CUhZscrrGOtr+K4JhU28928eFk=;
 b=LM861kERW9KsEJXU+TuYyGMGzkaglqVYkh7+Q8fpAxzrsbDiZ+cc5h+30WxbilW9fQJqEa93UWpqphnA/Qh7hPItCZyPlGzWwGdbSzEOtk7r2YNgYIEltXHUNcWZ8sXT4VedlTMz8Il1Ngah7ilAoJQfCHfG3BpSAsV4EBzGTnm9RBjR5Y498jP80B/Cm6rJAsefEoWEgV4DP06wzU+7GXPzCKxrIFw45vgbDMEgKqR6wiUmcV9pA7yqlPKd6yKIVZ69SVUq3M/qTVrtEdRUdOrY4kAzk8s9/fMorVB43lfm4PnBRDYS5oCImUhf5OmG7sR6GPCQNuFgqwItA6TVag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrznfvaM441JLNM06CUhZscrrGOtr+K4JhU28928eFk=;
 b=hm26aea9D1toqK5gTgBW8F4aCZzCtnJQbu//eQ7T4yJG0eY/1lR0gswvcfm2vM9Gwsgw+v+ogpp6ysxekgc5ixcNvtkuV9QjoSDQc/RITmbcXaiJVRgJ1cF1RhAa52CTX0LPiSf5a1FOtI9QETUvyNGcwGNi6W6Vzr1DsELBkBnjYkdG6iYj8A4aeEVKC7FM0jaklaR4zwAqBFMZudh5sjHGMUGBd2iEAqMcwEbiKm6MCIz6ZOI/HoSN0UlfXR3U6Wilr+glXIYrOY3vQqkHHy4O/pBfLWjxlWWQja/ns3l6o3Xp41Eu/Sxuu8jEnojsciiUwWvp7QkDqv/YP6EeEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27)
 by PAXPR04MB9642.eurprd04.prod.outlook.com (2603:10a6:102:240::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 11:29:05 +0000
Received: from VI1PR0402MB3406.eurprd04.prod.outlook.com
 ([fe80::a207:31a9:1bfc:1d11]) by VI1PR0402MB3406.eurprd04.prod.outlook.com
 ([fe80::a207:31a9:1bfc:1d11%4]) with mapi id 15.20.5880.013; Mon, 12 Dec 2022
 11:29:05 +0000
Message-ID: <0017c9ce-7e92-6010-7bc9-716131a25ec5@suse.com>
Date:   Mon, 12 Dec 2022 12:29:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>, david@redhat.com,
        Petr Mladek <pmladek@suse.com>
Cc:     prarit@redhat.com, mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y45MXVrGNkY/bGSl@alley> <d528111b-4caa-e292-59f4-4ce1eab1f27c@suse.com>
 <Y5CuCVe02W5Ni/Fc@alley> <Y5FPkEgEbDlVXkRK@bombadil.infradead.org>
From:   Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <Y5FPkEgEbDlVXkRK@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0129.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::15) To VI1PR0402MB3406.eurprd04.prod.outlook.com
 (2603:10a6:803:c::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:EE_|PAXPR04MB9642:EE_
X-MS-Office365-Filtering-Correlation-Id: 6abeb8ba-79ba-4098-d538-08dadc3412e6
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EnQduroqrYSQtRpJMpzfrQ00X+CQk1IaOV6+DA0eSMuITzPzlcg9yB4VNOcHda+mJXGwAucXKREGwqeEhrqWadjqrAZJt2kyDIsnyyq50vfedDlTjc3ze5geWLWzF0Faasocv5PH1QWZdpUcsT0OTRAqp5+TbJsxIRDlsU9PcqvHduqsCQmUZJ5Cylx0tRhu/BM9O1ALk7tORtNdTw02pMc/O5brsOyniV2rUPrTXW0Xhd0K2XwhsXuydS/yCwGa5AvPN0VFueUMuJ8K5v/9+soP0KjHsqoIWRphI28L2ifeU5HLZxvLDbXUgbm8Ml2Kyj+uiGb64IYvwvIDHW/mk0h25rsxWqji4PQJ9kq0b6XvRWnuJywGfPYrJ9uL2XBup7pcYKl6k3Fkk++1x2cqYKknyYaXCAyMMe+MnyAjzfb6jJy9BrmG+j9dSUF/1iuqTbZgQWp0BYmefjpvxWEwP1vo05M/cbv8bvUQQV6yY5kCnI5u8kZHZ6HszRZ1nS673HpyoFBcGWHhClYijOhC9n2qYfqofpyHzF1Sy79UWoomo6HB9bGeNVMHs9cqkWqhsaK+50zg9GNaLJvYysQjZ35s7PDjJRg9k9Oy0KATdRkpys6EtQCUKpyjEkp62nmEd7faRRQ6yybuKviVIErJR0ZrKSescxMwclgsfHmS5DG2KkCk8qrWjNzmsnZwkWdLeaMFUpZZVt2RKPV35OFdEgbPrP3pOVlD9PxWX5537DSOA1+TOmYmZbcZQD7GZBK+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3406.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199015)(966005)(478600001)(6666004)(66899015)(6486002)(31686004)(26005)(6506007)(55236004)(53546011)(6512007)(186003)(6636002)(316002)(2906002)(5660300002)(36756003)(66946007)(4326008)(2616005)(8676002)(110136005)(66476007)(66556008)(8936002)(31696002)(44832011)(86362001)(41300700001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REZ1a1VPTDNzN3MwTmZzT0xxS0pTZEE0SzliMkNlNXdlazVQSG9EQmprd1lz?=
 =?utf-8?B?VlpZK045Zk4wOHltVWc1SWdUK0FZdzhsTUprUDZUaEIrYm10QTg0c1BrTm9N?=
 =?utf-8?B?RzR0bE1saWZwOEhCUkRpT0Q1T3BTckhIQVZEZUlnK0YwSmRsaWdJcVJKaHZt?=
 =?utf-8?B?ZTRxTkJsRXZwcUdaak9hZHQ2OTdDaFR3cGpPVkpSMjlPajNPbjlDR1ZLS1dD?=
 =?utf-8?B?TUJsM0RMMy82UXdzWm5VV2wvOC9Jelgwcmp3RXNnU3pNWnhhRkJFWEJKblNU?=
 =?utf-8?B?bG9iS0J4OEtYcGtXZUNiNEQ1cThlUjhDUEU5VjhQUCsyQS9oNm1kOWhTQU9w?=
 =?utf-8?B?QVd1YWFicGErMzRLRG96VHJlQ0dYZ0dYQS9JVmxyUkN2UWJER0dYeHpwVlBw?=
 =?utf-8?B?RzM4c2RJOEpDb2NHdy90UnFkVHlldWtDYW1rUmJwWis4enFyaXFWSlBWMXFR?=
 =?utf-8?B?elgrcXBTN2U1RTRHcE1VZGRCa0ZINEMvQklGYm1WQTdqTmhKTEI3NFUxUlQ1?=
 =?utf-8?B?ZDByQ2RRMGZNd1FTRlpJZXlBcmpiSG9FSlM0cFVMYk5GNmdnc3ZLV3BQQUZE?=
 =?utf-8?B?UWFBaGlFTVRQTERFSkh3ZTlKWkJNZlBEajh1by9KeTFpaHptMVRUUmpVSysv?=
 =?utf-8?B?dCtMa3JZbGxWcllwVTkvYU83ZzNSODAreTNWV1NOTDNjaFpqZEs4aVlkUHpr?=
 =?utf-8?B?aTRlbjBqNHBoRVBmdzlPVGtjWVcxWERERzIrZTVhUmJ4N29YU3BxT2hTZDNV?=
 =?utf-8?B?WHE5djdPVVBTZEI1UE82TGlCTS9HOWpJMlBvZjQyYUxYQjZ6QTh1bVhvZ1Uz?=
 =?utf-8?B?ZTJwWWhFczRjWktZazE4aThTQmpVOTBnd1djV3ZZMkt6d1ZhU244V2xxejhT?=
 =?utf-8?B?UFZ2VGQ0RW0raFNBZDAvY2tadTZXcFR3enU0QTU2ZVVIbGcwa3NQbXJMaGdP?=
 =?utf-8?B?SUpEN3VsS05wbVI5anFCYnRhaFhTbGxkcHNtTHNkZE5wcWhta3JCbCtSTm5G?=
 =?utf-8?B?b0pySXVlVlNReXZqaSt2TTl1c3Q0eElYcmRXWk1GMDRRSjhpeldEZkFzTGQw?=
 =?utf-8?B?N01XQ2I3WlZqR05UVmw0Uk9TMVpzM0RSanlFUHVPcEJmaTJnMjZtdVNudEo0?=
 =?utf-8?B?SVdXUnhEUDREUWM5RU1NZENPNGZyMm50dWg2bWtaNGpGRWRYenc1WUw5UVhT?=
 =?utf-8?B?eGxQR1huMCtTdXRDc0RycjlVNWhDTFdnTzNxMDluQkZ1Z0JRTHlML3A1YytT?=
 =?utf-8?B?SmhQVnBNVEZ4Z0ZCUGd3Kzh0SVJSeEhvVFpIN2dncWhEbUMvcjJ6L25iRUZv?=
 =?utf-8?B?dG9sNlFBcmw0ZEw3ZW14eDc0UklQQ3pZeStnQkpjZW9NR3JKS09HL2lRWTNF?=
 =?utf-8?B?Y044eUwwOUVndVFsMmlmLy93dEFxckgwMDd3TzBBaEdwK0lIczF0eVBEVG16?=
 =?utf-8?B?WTZHY0lXeFpxZys2SU9vcUpreTJBM1RXMUt2S2lxN1pJMnliMVFFMmdaZHFr?=
 =?utf-8?B?cXFiMDN5RHZ0V29TdmpsakNwU0JwcGJENUdtVkpHZmlURnBXRXpIbS95Y1JV?=
 =?utf-8?B?QmhQTHQrTTdBRlF2K0NwZHFhWFA2MnhoVzBxcFZyYWtMSjJiWE44aXRtbE1O?=
 =?utf-8?B?UmhTOGJ4MStyYlhFU1dTL2ZVRkJzV2FFL3I4YlBTczI3SnJaYnM0enlMRkZS?=
 =?utf-8?B?UlpjbG8wLzNlRDZiVlpmMTNQc1Arc0pySmtCbGRuRStIMEJXbis4NEtMWUZD?=
 =?utf-8?B?SzFJUFdWTm1TTkR1WTlCVXJ1ZUQ3SzVvZkk5K0s3YU8rRFFiS1d6VTZGNmdp?=
 =?utf-8?B?ZS9Bcms5UlN4dnFkOWk4KzRQTGtQWW1aZUYrZ1hzL2tRMHZrY0tGKzY1VFB3?=
 =?utf-8?B?SUFZNWlXL2hDd013NVVWcFRYK3crZUhyNjg4ZUtEcmdxOG41KzBmeTB3ZDRB?=
 =?utf-8?B?R2M3YmF5SWw3OFBwdTlhbisrL1pwZ3hOekFZZWhGS2lzWm4vc1ZyQ2l4Uzcw?=
 =?utf-8?B?RGhQTDBuWXUzQTZDU0ZONUxBMDVpNzVxcDkxa0F0dGw5RmRJd0tlUis1TnVn?=
 =?utf-8?B?UENKWE1tSVhYdDdtcFZGbHpwWDRzWktRWE1uK2p3V0lXVUREeDFERTRUVVcy?=
 =?utf-8?Q?m5MO1YH7NdDn3GttnRQ5401cO?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abeb8ba-79ba-4098-d538-08dadc3412e6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3406.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 11:29:04.9404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWuryBier6gZrapXEDiACKQLuigGi3Ps9gtK8z86KII1XFkTBTq8iALqjAQs7/te7uDxrLK6KNGypKcCSNqwpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9642
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/8/22 03:44, Luis Chamberlain wrote:
> On Wed, Dec 07, 2022 at 04:15:21PM +0100, Petr Mladek wrote:
>> Reviewed-by: Petr Mladek <pmladek@suse.com>
> 
> Queued onto modules-next.

Thanks both.

>> Of course, the ideal solution would be to avoid the multiple
>> loads in the first place. AFAIK, everything starts in the kernel
>> that sends the same udev events for each CPU...
> 
> Fixes go first, *then we can address enhancements. I have some old
> fixes I can send after htis is merged. I believe folks have others.

This simpler fix should be sufficient and so the original more complex
approach can be scraped. My plan is then to only progress the additional
developed patches: a test case for the issue, minor clean-up patches, and an
ACPI change to load acpi_cpufreq/pcc_cpufreq only once.

Note that none of this work now addresses the problem that David Hildenbrand
encountered with vmap allocation issues [1]. That needs to be fixed
separately.

[1] https://lore.kernel.org/linux-modules/20221013180518.217405-1-david@redhat.com/

Cheers,
Petr
