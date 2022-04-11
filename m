Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DAA4FB50A
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiDKHiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245523AbiDKHiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:38:09 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3BE3DA4E
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 00:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649662554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qP/rogQaWPDjsQzKdxTI0Pv4TRqQc4zOev7yHKZLpvI=;
        b=hNKEInc4F5lMiUi7/psy7xbyKLyvRaYSHLkte2VvfwyEtdZdDO3PvVVkSrwm1NjN1aL/fD
        CLFsToaua2yyz65FII6da+ozCXHbgYa9JcF5i4Ut26y/NScQRXcq4r4D4/01NEmYNt6Okf
        vGLvcWbiaRG26X9rWOgcOSG8ai48l8w=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-31-klMncQyuNcmvSu9QkwoEVA-1; Mon, 11 Apr 2022 09:35:53 +0200
X-MC-Unique: klMncQyuNcmvSu9QkwoEVA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ih+u3aGk6YfiMqmasMVKm04w02mtE6KoBiO2ukRJouQHKLiKzZ7Y2Sjsfd9Cqdmwg0/nm9yVAj+7719SLdNBumVt2QcBEr1ildZglOnyIBJXo3cmUU5NdWhcEp6sT/0HnJKc1wRPGVW9uYqXO3PSvDf5Ql1xB5otItcweQeV8PsZg/G+ewIR0hiN+MuPKkGxp9OUSoeJygRPh/Y7jVdjVM7JLigrW2b2ioggqxWFDPKDysDACP+Q6Pa8U2mLaLuMoTHzhIXZzYuy2fLmTk5shSmpMLQq6KRaxLEtHxNQQroqMNQ8d0HclLXCCJIExeE2oZcRt4FbHm5QtiLwsnaBLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qP/rogQaWPDjsQzKdxTI0Pv4TRqQc4zOev7yHKZLpvI=;
 b=jKWUyNOkiefRL6pur2JKt8MiywZmYyp0nkq7rjKuVLIuueEGySGodTfP4xC5iWNy8dX5k4I3oG93RbTMkxpms7Whk23LyD67uQLDlWDlCSbanG/t9nQiEyEVs2KI5/HQeKTgPWNvq1PCKMU7rng4f/QOAHTYuZIjXYEpQGt77hJUkKEPESucAaN0yLfITMtunGkIH9EVUIN+XbSjXU22IEB1nFS45yEqRk5R4+h8iL7G2HTPE9ikgKifg2eP9u1QB5FeW67NDO/CX0VQ+uYTeRTgK6mNXSGhHGGTBMPvp7enuAHGcxaM8ZGHBFHHCzM5psJ20lpvbXmuSgrofSyoXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB9426.eurprd04.prod.outlook.com (2603:10a6:10:36a::14)
 by AM9PR04MB8729.eurprd04.prod.outlook.com (2603:10a6:20b:43c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 07:35:52 +0000
Received: from DB9PR04MB9426.eurprd04.prod.outlook.com
 ([fe80::415f:1551:a6d5:face]) by DB9PR04MB9426.eurprd04.prod.outlook.com
 ([fe80::415f:1551:a6d5:face%7]) with mapi id 15.20.5144.022; Mon, 11 Apr 2022
 07:35:52 +0000
Message-ID: <298210b8-2b5d-543a-1e35-7f8888f2b414@suse.com>
Date:   Mon, 11 Apr 2022 15:35:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/4] btrfs: avoid double clean up when submit_one_bio()
 failed
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1649657016.git.wqu@suse.com>
 <6b8983dd0a3a28155fa7d786bae0a8bf932cdbab.1649657016.git.wqu@suse.com>
 <YlPVQtbeJ9qQVDzg@infradead.org>
 <63cca59f-5962-339c-db9d-c93255962a65@gmx.com>
 <YlPWkL4uYBah7Elo@infradead.org>
From:   Qu Wenruo <wqu@suse.com>
In-Reply-To: <YlPWkL4uYBah7Elo@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0074.jpnprd01.prod.outlook.com
 (2603:1096:405:3::14) To DB9PR04MB9426.eurprd04.prod.outlook.com
 (2603:10a6:10:36a::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b999808a-832f-4572-8631-08da1b8de7f0
X-MS-TrafficTypeDiagnostic: AM9PR04MB8729:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB872921D7C2643DFE96B6FA4ED6EA9@AM9PR04MB8729.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IIMN7n8/b4rRn45Z5y0fehPo9KabfignNWHDgxTOHXU6kM0PH04ctphwr5mXhGeMOkXh5NAzHWMjDLMwvK5KdnVc56CVV6bB9TN10oUm1/VeoXH3zgpRMj04LqqBe8e/Zmfw+SgOfFThUUvL0jUDtmMS+m2oIXKQ479i1JGGarnbnb8cSMBg8DGbVKwsG606Nn2/fmD+K2imlZ5nhrjfObbCVxWiJklgQ91QI+5JTGnKw/K6W2QPTwIrj+a2vPCHDzRr+iJrQXEjIZMomq7UM47GK1choyNQgbtEb5KmEbbXuAEtwnn6Kd1gKdzRgdS/0WhGhc4CpSw9F4fGNEpR/1TapT62leTHEirxG2v/ftJEA+1ipPFda8tZ32a9rtVo8B9z7aNv2HGb6gAKl1l4M+YvTQ+dT8K5zQ+FrFQntkw1eZA/43tTA/q8P0jUq72q/F5Pe0DIocJhJNWkExWrSGn/k2HQlu04KQATBRQM44enSFA+nEkGm3PM5i9eLwj2n/3CGy0yjs17Lt42e/4ITvMgzvl4vA4jtCPRQVUb+L1exdkM60jQsiFqRybAPpYJoBC1u8iZqCa2OmAj6Q5HxR7Ox+od3yaL8LOyrmdi5pYOcn+B01VbNlslgPHCL/MI/xwcW9EQzKZEVyPHCiXTlJXhM/bix9/akpUK6Y5ARaTljQYkaCezAvh6hc8tTUpZZDpf/q/UqInQ/iSBv5p3CadbSEkk5wlSdwTF+6CNZYw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB9426.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(110136005)(6486002)(186003)(2616005)(38100700002)(31686004)(36756003)(508600001)(4744005)(8936002)(4326008)(66476007)(66556008)(31696002)(5660300002)(2906002)(8676002)(66946007)(53546011)(6506007)(55236004)(6512007)(6666004)(316002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UnhZdGpDd1MwUDhGS2hmRDRXbyt2K0ZYNkhiMG0wTzhhUmc1TWlJdldvbnJY?=
 =?utf-8?B?anBlRGtVUmdnTUYyNkFJNjNOWDE2bVc3WTdObjBhb0FreUFJNlVETVNBcUQv?=
 =?utf-8?B?eCt4UDVWYlpNZTRDME84UlA4R25mWkgzS3hsWWVSQTM4a2RRUnZxQ05palBv?=
 =?utf-8?B?V2swZHQ1U2RlSXZPdkZSZzVVemxlcHJqM1ZNQXVtQnpMa2w3bzZYeCtKUmhm?=
 =?utf-8?B?LzRuVlNjcTNQT2hKRldQLzZzbVg5bVU0VjljUnhOenNjUXh5NlU2QitxNEkz?=
 =?utf-8?B?OSs3bVdVdTRvUWQzc2hKZUFXYkNhRFZYd2JJaVhPbmNaRHk5ZDk0T3NRZEcy?=
 =?utf-8?B?eDcrN0VER2RmQmxuam5UWWpWMmw1dlpCUnV1Z0tHQ1RvaHYxbGJFem5BWWNm?=
 =?utf-8?B?N0FkN1hnWHQ5YTlVUWp0TEpQQk1UancxUmUzQnhlMlEwMU0ySzIwTDR3YnJz?=
 =?utf-8?B?S1V1ZDd2bmhRRUczeWwzaktXVWJ4WHFvWSs5S0hKWTFKUDZLdmxyckVReVd6?=
 =?utf-8?B?VlRKWVdhb3VNNGUyZFp2YzlJQzJtdUFscmVVMlV2Rld6VkFvTDIzU0QxM1RQ?=
 =?utf-8?B?aXBGZnhDcmQxb2lDODdneW9KM3BjVCs1c0NYbTJIVXdvUmZaVXpEZmQ3UVky?=
 =?utf-8?B?MHhrcUFEZHdxS0Z4MENVdCtLRnZqSGIxcS81OFNJbzFmdDN0Zk1EaXQ1OGp3?=
 =?utf-8?B?UTRmVkxJWmZjcHpwbk40TzVnWXR4V2haZmZ1dWlLTjVDS0ZUNEw0SGlOamIz?=
 =?utf-8?B?Rk9UWGZKeWhOdU1JaEUzM0dEck9hU0ZHOHpuZU5OeHE2RFNuc0k3NHUwVFFq?=
 =?utf-8?B?V0E3RDNSeTBkOHkwOXhsbmg0UXR0eEI4eHVXNnJDaUN4L3hMdFB5R1BzMmtX?=
 =?utf-8?B?TjFGTWZMUkUra1BOUGQvN3V3K1V4am1yY1F6OVlOMGpkT2dBdi91Y1BpYlRy?=
 =?utf-8?B?N3ZUV2o0Rkxld1FENHlTQmJFRDMwZjBFUG5NZzlJcHYreFlxb2dsSU9Ib25q?=
 =?utf-8?B?WHczYXprKzJUekFHUXM3NXgvYkpnMEg2ZmhsbE9MUGNjRFVsMVpGdWQ2VEJQ?=
 =?utf-8?B?RUNiVGxkaWh3YTNoNFVXZFFhSTE0OFJCaGhuQlBPVDV5V1p2WWxZOGRLQmZR?=
 =?utf-8?B?TzVwcjBFcUoxeXFyQmp3M2lSUE5VVTlxdXBCZFgrbkZON3N6WForaVp0NGpv?=
 =?utf-8?B?dGhzS09hVGZVdFFXQ0x6aGNPS3RLaUlpSVVBaUxuRnE2Z1Joa0ZrMUhEYnRz?=
 =?utf-8?B?TWNRaldrQ3h0aEs1U1lNZDJBdDEzZ3Brc0dxZ3pQQ1N4cktBdWFTV0Y4bmtj?=
 =?utf-8?B?WWI3OWZReDZlV09HcU02MWR1d3I3ZGdPVmdXcVQ2dVpZMzBKbnBrcXNkU3NC?=
 =?utf-8?B?VHE0a1pFQlh4bXdMbkZucTg0QXd0WWE1WFowWGdLb3l2VS9xQUVOeVJwR0sr?=
 =?utf-8?B?SDRkMGVibTRrUXRYckduUGpNcUtTZ2lGUVNUQnM0ckNUc2NTU1pvTE5wbTRW?=
 =?utf-8?B?MjlwU01KRWpLdGxGZXJBclVPaThvRGtwcERmZkQ0YVNHa1pkRnZIT1VCVGlI?=
 =?utf-8?B?MFVKaTA0bXFEL0RxZm01YTZFTk1RSGhyY0NwdHBvcXluN1BWQ3pWdHFSYW5p?=
 =?utf-8?B?MVkyemhVaUNYcUNDYkRKRHpzdmVhNFcyUko4b3lRbXVrNXFoOTdUVW92QTBq?=
 =?utf-8?B?UUdKL0hQWkxIQUhoRmJHdUp2TkZZd2xEc1pPNC9hc3N2K21DNFN4ZHlXWm9q?=
 =?utf-8?B?NFNxZkc4RzQyTk1VcHFRTVl0WWYvUkhVQWlhT2RyZGFlWGhmVG5qY2VLVjIv?=
 =?utf-8?B?amc4Mno2cU4wbjZoTEVtaHAvL25MZHFIMXJ3aWtuMXlSSXJ0dmFIY3hJM0Rn?=
 =?utf-8?B?Sy9ZcUtLSHRDTXk3V2pOTksyS0FFSDNYak0rWXAzSThNaEk0Zkp6YVZtZGUr?=
 =?utf-8?B?T3JQTjh1S0cxaWwrM0JDbWRReEx1VDJJNG8yZWtNQWd4Um1pMWxWZ0UzZklo?=
 =?utf-8?B?akRsNGxDbUdoQzJkTWdqaENXc29EaW5EL2x2MmU3UGVQYWhHYU9pdUVvUGQ4?=
 =?utf-8?B?emhQSW1tU080aW8rWjl5VFBYOU5raU1reDRnQWJ5U2NSeG9vUGg4Q2VqejF0?=
 =?utf-8?B?emZ6OUh5RUxpVmZ0dnI4cldCV3NWUlFrWkI5b3ZPWjBuclBWRFB4N3dXNEFI?=
 =?utf-8?B?UmFCQW1Fa0FxU0w5L1F2SVRCcTBiNTlWSENHcnlFNU5ZYWQwMFlhYnlKendx?=
 =?utf-8?B?ZVJsUFFpN1QzUjRTdUFWeWFoQzF2SU1oWW1iWVdvb3EyM0ZiU0lrRko0ZTVo?=
 =?utf-8?Q?9GuC6GtpqFkjXGfW0k?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b999808a-832f-4572-8631-08da1b8de7f0
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9426.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 07:35:52.5578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QzmWT+DpdR2up4RjDUYMbG4lzEKXEjOsdAjfh8ZlybFhf2R+6Y2KGEFZIFgwSPmz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8729
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/4/11 15:19, Christoph Hellwig wrote:
> On Mon, Apr 11, 2022 at 03:15:23PM +0800, Qu Wenruo wrote:
>> This patch itself is for backport, thus I didn't change the return type
>> to make backport easier.
> 
> Umm, if you don't remove all that buggy error handling code in a
> backport you'll have to fix it.  So do the right thing here and just
> get rid of it ASAP including for the backport.
> 

I don't think there is much difference by making submit_one_bio() to 
always return 0, and backporting the full type change.

For btrfs development, no one will base their code on stable, thus what 
they see is the one returning void.

For vendor backports, I have left a comment on why we return 0 manually, 
it should be clear enough to solve any future conflicts.

I'll let David to determine the correct way, as small backport + proper 
cleanup policy for bug fixes is pretty common here AFAIK.

Thanks,
Qu

