Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055AD6D850D
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 19:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbjDERmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 13:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbjDERmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 13:42:01 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2040.outbound.protection.outlook.com [40.107.104.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554BC6182;
        Wed,  5 Apr 2023 10:41:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSmeX4XxGsFlWoD9NVRefTOq1Eddp5efVZDORmLTyZXWXVSN538Hg+L79S/6adybI3a5Y19t0mmWCFR6zGbWaQyG6a9CosrEHYFIhoUfoun9C7HPfTZQn33qdFzLLTqYQ3CxYpH0+8sWBnWxsEfoBTndr5hVgMpsFi+chxC3nxSBaQEN1GT6S+aQX2d7vsO0m13qvzUaIcsNJVxK6lJ4TC8HfNRVC/CcLOYYvV5ukSE8UafShqxQeUyZM/lYT7LUizVzE0/bIPrtiWqsxGMl58gSaXRQjUX0SLtB7I+G3njUrzbdRXQMLHQFf7ztc/isv9geA/3gCudmTfMV+LLr/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0knarJXg4E3JdhNapT+unyF1fZPnIn90qdwlo7CchA=;
 b=boIx3YCZJQd5s1ly5hmCmTqzfupCI6kZRHTFu1G+SeSDRFVdWM/FKdDhlagKsN7D9ECGhIza4OgqglEgRtHBVzb58OAR9kPkMjmRFGjnd/Ok/DGOpvGDEg/WNgDnyhggtCgppxLwYuHcZmpcPOiF9I9E9CFrl+g2usTCq4JqPZkF5/meYc+tak1fXDQdIO/rO9jEFatilmbjLq9zXOgo2V9OfuOFVn0JkvMEYKAKs6qQAbZWcar4HHkcco3QTTVap+wTeGbay1zVCLAAxRD5//pB8t3OiFR3+EhIaiodogc1vtNVRKFk1MuYNprE9JOYvAx9pp1nmR5kbkMDAWxn9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0knarJXg4E3JdhNapT+unyF1fZPnIn90qdwlo7CchA=;
 b=bRq5CGlu/VKpNI6cNpBR6qkDSan99cYyxQta81OnJbKCjudjG0S7pn5g4+84IDViejRBh0UqrCLZ2GMBV52FOvunDXfQyAEo7QXfsAuOszu9v1voAfOpBaOh8gqI2+gfqjGJowsa5ILJv4/uyQwtn6L+wiWNQZUCkR3trXGyya0UlYV8poBTDIPF+NvdzIUPKuscQ/EoRuMeIiQZUg7ua+ZA70iOGxqdt/9T6e489PdADm889MgjNlxC4bkwVNfRK8JUZZaEVA/kaA1RfXvBZDakZkJy9dCFJBTJHb4H0e3YWOj0l09DyiD3i0WfgGA4g5WOZILAfxIjociFBa50ng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by PAXPR04MB8958.eurprd04.prod.outlook.com (2603:10a6:102:20d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Wed, 5 Apr
 2023 17:41:56 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::74bd:991c:527d:aa61]) by VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::74bd:991c:527d:aa61%9]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 17:41:55 +0000
Message-ID: <ddba44b4-5c5c-0085-2678-9f8151811494@suse.com>
Date:   Wed, 5 Apr 2023 19:41:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] usb: cdnsp: Fixes error: uninitialized symbol 'len'
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Pawel Laszczak <pawell@cadence.com>
Cc:     peter.chen@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230331090600.454674-1-pawell@cadence.com>
 <2023040514-outspoken-librarian-3cde@gregkh>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <2023040514-outspoken-librarian-3cde@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::14) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|PAXPR04MB8958:EE_
X-MS-Office365-Filtering-Correlation-Id: 36458cae-bafd-41df-1b1d-08db35fd0c27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oBqCzjH9rCNSNA53Sy1NLBVM2SyBryk05Drq4LP+ibp0HGewgeUDKLymxp4mVbiQd3KoUAHxRjeCc5L4akCUHqFV0BF+KhrPpTcV1dXX7kZLFSf8ZZ3FbXpHqiBvxBINXZCyh1ps8bsoB8pMbYVVgdo4p2TKfO8ANF0q9L2tbz90czH4w9r5sF4VSYJnLmqQU6r1dinvZ+gVZtdWnpteVMmpr2Gnk7K79WKGVF7Tlvhu7DcUSTSwbfyrV3xnY2eDnEWqJspICpU6w8i/ZE4LffUqSWkkSVPcRtkgUBoSrn/Pi3egYOkXs1d/iEAMCBV3I5u/att3sJ5LSAD1QUuFTKLu9/2m4Ze3cdQEfczePfD5bcfxXql86IJCcCuBewkQrPJZDPIF4oxklKwZHMcID47rqXed9MZD88wx4+wjofJMhU8prlJMIeqsxpzWh06CViC2o7zbjJX5QMy8jqDT1xHb0GHki+08Nc77+R3g46yGfUWyjfj49GvK5fJlMNVT+QgPI8wthv1dDCxIuK0xPfMtWQgfBRu4wtE3VKDJ5TYnt9kwo2/wAzdkXKtCaDTpqia/SesUuyM0HowJuaGpjH95+UNsPAZVI4laLGOQVfqplWolpOjUCcMjvCeEZ/OucGTfaAyi1L9+KFPiC4lrTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199021)(83380400001)(86362001)(31696002)(36756003)(2906002)(31686004)(6486002)(478600001)(53546011)(186003)(2616005)(6512007)(6506007)(66946007)(66556008)(41300700001)(66476007)(4326008)(8936002)(8676002)(110136005)(316002)(5660300002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDg4d1RmTUlla1NySmFxOUlFVEtmWmxGa3ptSUg5cVZwVTZUbDQ0cGs4bXRV?=
 =?utf-8?B?UXhrWjFGZXBPVFZ0Ym5WaElaRTZmS280cnMwYmFUbzFjNXNwQ0xvYXQ4VGY2?=
 =?utf-8?B?RGFRVWhRSzk3WExRSnY5bUNrd2NCUmovWUxSeFZXekxPVWVOQktMd0RiMm5a?=
 =?utf-8?B?RlBnWVhzV2tTUHBjQ3Q2U01tMXhkTmxjSUQ5ZldXbldvUTRVSzA0eE41dzBS?=
 =?utf-8?B?Mi9hdGRGdnNFT2FPR05FM1NZM2NVTndCWUxiUTA4UW80VGZMcTk0bkFIVDRq?=
 =?utf-8?B?ME84VWNHUGhNUWdTUkpReUFIT1VwUDA4cTlEbVZiK2crRjY4QUdja1l4Uldo?=
 =?utf-8?B?Z0tuSGh6UmhqUE9JUVMxNXI0V0d4UnlkOE8zTE1hN1JQN09mMzk3M0t6a1Vi?=
 =?utf-8?B?VGJDWnhzdDZpcE1LczNjbDJaYkUzRWtsM3pLc1A0RktnaTRpQ2xVY3diejlq?=
 =?utf-8?B?UmJtSVNTS3Rtcmp0cXNLS1ZZcm9DUC9CTHdzY2FyWGR0Ui96U3Z2ZGpTOVRL?=
 =?utf-8?B?MGNsOUtGekJhNkFWNE50T0tBdlJ0R0hFeGNPcEJwWTIrMjdJeEI0c0xDdU1U?=
 =?utf-8?B?VDlMV21rSE9yWnBKMk9qWFArMUJaN0pUOTRJRnZtbVZ0SlJMdzVPZkV3a0hr?=
 =?utf-8?B?RGJtV2NlWk5OTStGUUpjVWJGSDAvTHRZNVVCWStWQzNlRUdRa2NUSzlIQTdw?=
 =?utf-8?B?RmcyNVpibDJOclpSYjYzYUQ2VjN3VDJwUm84dzN3bU5FOGdGT2dkTW02dlZo?=
 =?utf-8?B?SXp6MmY3eWdpaWFGSlRJbmFyalhWNDVVNW05aksvLzVJU1NuOXNtWlJaN0Mv?=
 =?utf-8?B?ZUFWOVVkc3NkK2hiZXpDK0M5NkdyL1M5aUdOaWp5U1F0Q1lkQThuREtuamdF?=
 =?utf-8?B?anVUaTB5b1ZnNHJqSi96U1hpVFZuQ0dCOGlLaytxTG1wWHBCMUxXRjBsSVVP?=
 =?utf-8?B?UUNMc2FzbEVwWTQ0ZlVjV2w4M3krYlIwUXFRYlg4RXBoVFg3Ym40Vmx3WjNZ?=
 =?utf-8?B?ZXJsdHhBcnF4aURwUTFJUk94MDNoVkNYK3lDdVZEQWdNR0pLOHNUQnNmZmhL?=
 =?utf-8?B?RGJBMmhOd3kxaVc2aXFOWUcwcjdNMm0vS0Q1czNQMXpSd2wrRTRwYXRyNnc3?=
 =?utf-8?B?NjNzYkdBbzkraVdXZ3VaaE5NanNxc1JHVEh0UlU0dnVBRUlGakdHT3FsK01B?=
 =?utf-8?B?WittUzNHcWF2OTdUS0xDOTV4MjhyV0Zaa3pXVXdXSUlVTHgzZmdKUTgwRDNz?=
 =?utf-8?B?b2tSTXB6YmZ2YnFVZXFndzgzcTk5UlI3WWZnWnlqVzhrbk8xOFNLU29Bejdu?=
 =?utf-8?B?YTFNZkVrenBhUHBLbFdLQktxNEVJcldkdGI4bFFyQSs3R2hNbFdzYkMwTHc0?=
 =?utf-8?B?SkliVFk3b1VYV2xDd2NBYVpyczdIWllFNGdjM3RRN2RlVGpWa3RJYkpveENl?=
 =?utf-8?B?NEJMb2lzMUxBVTg4Q0Q4ZGZmTjlXdDAySC8zMldvYUdGOUZMRkN2WHB1Tytm?=
 =?utf-8?B?aFQwK3RkbE0yZXhKdjB6bmltQXBQeE5RL1JWcjArVnBLYXhwQmhjeFhid3pV?=
 =?utf-8?B?amlCaEh1cVE3RU1Qd0ZMTmZiME0rRXBhaDJ1ekZNeThnSXRBbkx3Z2tWSUYr?=
 =?utf-8?B?UStkQ0JNc3pIdmxqalErUlQ1QUU5NkdOZWplVHF5MVF3RlM5ZHozTlRqNFV0?=
 =?utf-8?B?Qk9Ec1UvTXljSHZ5bUhsWlhXc0NrQ3pXMm9HUHA0YUxCekRKRjAyejUyeFY2?=
 =?utf-8?B?RUR0L2QycnhKUUZQTWQ4bzF3ZmJBYmo0T0xkS1BRTU9hM2JPNVhsY0ZpQkFo?=
 =?utf-8?B?UTNaK1lwZHNkc2x0d202a3AvN2FDKzJtTGdxayt5UUlzQ2xHdkhubkRDT0NJ?=
 =?utf-8?B?bmRlVmw0bHFhd2swdHFvbktNR3pPRkQ3N1dodUZ0MmlzTVQwbjAydlh0WXZ5?=
 =?utf-8?B?bWdhYmY4dnd1WlRyUTJqMkFrVkxBMEdXemtodmdub2xtQjRoUVZENVdGa1JO?=
 =?utf-8?B?bDhxcWczalRFS2wveWFZbHVoeUFsVnhxY3RvSHFxeWdFa2RiYlhqSXk3MWJF?=
 =?utf-8?B?YlBvdG9iNnordmcwOC80aWNGaW1hQklmUW1UWFJ1aTAwa2ZSdjFvY3ZTeGI2?=
 =?utf-8?B?U1NsWDRXZE01dXFpdkVMZ0VDUkMwV2RkdGlsWk8wd1YvTjhMZVBlTWVodFo4?=
 =?utf-8?Q?jfLXVz67mahGp36aUri+PF/SBb145u51Rk7OfXFm+oXR?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36458cae-bafd-41df-1b1d-08db35fd0c27
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 17:41:55.3656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fV23C0t12Al+/dcGR+1eBLWTzlCQISr1s8UhZ/emZNjnJCaxAYcCAwdBVEDEtf8/7LZxZpTw4QDO39yQRshy4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8958
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.04.23 19:23, Greg KH wrote:
> On Fri, Mar 31, 2023 at 05:06:00AM -0400, Pawel Laszczak wrote:

>>   {
>>   	struct usb_ctrlrequest *ctrl = &pdev->setup;
>> -	int ret = 0;
>> +	int ret = -EINVAL;
>>   	u16 len;
>>   
>>   	trace_cdnsp_ctrl_req(ctrl);
>> @@ -424,7 +424,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
>>   
>>   	if (pdev->gadget.state == USB_STATE_NOTATTACHED) {
>>   		dev_err(pdev->dev, "ERR: Setup detected in unattached state\n");
>> -		ret = -EINVAL;
> 
> That's a nice change, but I don't see the original error here that you
> are saying this change fixes.
> 
> What am I missing?

The function has this check at its beginning:

        if (!pdev->gadget_driver)
                 goto out;

ret is initialized to 0 and len is uninitialized.
The jump goes to:

out:
         if (ret < 0)
                 cdnsp_ep0_stall(pdev);
         else if (!len && pdev->ep0_stage != CDNSP_STATUS_STAGE)
                 cdnsp_status_stage(pdev);


The compiler (and an analysis tool) can determine that len will be
evaluated in an uninitialized state. Setting ret to something
negative prevents that. I must say this is convoluted, even though
it is correct.

	HTH
		Oliver
