Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A0E5A13F4
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 16:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242263AbiHYOiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 10:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242262AbiHYOhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 10:37:34 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70051.outbound.protection.outlook.com [40.107.7.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21738AD9A1;
        Thu, 25 Aug 2022 07:37:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmBzdAv7W2gE+J1G4lCAN2AyZSBgWGplJW9VZRbHvLrfFNtovlnOeESeNuVj5GZl2NSNwDvZst2LvaOtsz6VVKIu6w/mxevDIgEEgRDDC0L3am7rw8B8/FdYVZOfce9sesjC4osUfPHfR68JA7yKunfjaORKYDsnJVdsbbQ2phbnMTcIFsBKeXA5HwAHVaRrBlEIBaWeKAOi3+khjiM1H4QCN5K2Y6GXKpGIjaXbMYmQuT5GFfxVQdtUnyIThO6Y3JweaZYyEO/8fWPPDiEnc7r52L4ySwtw8Q3ZoeHJbsUNNC//r2N2VgZTJFpCu9H3ESclCt0AZEePYmM+uQ691g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIQleB1AFrnW7iHGEWMyVGryaLFdWb/L1obCm6gJ8cw=;
 b=YAlbwnSzSLgFeW5Nxswt1f8Q0glc5J4m8a+wTzDZefX7w2Ao64HmO2ZpItaNq3FHZj93DpR89cWv4q7WHwbf2PXED0K3XoDq15LzteLw/Hh5aHVYJDwQ8X+fX3TkRJP1zHtz84OD82LXDIAAt4H3y9grXvniB2G104p2lzVb5IiY+2akjAqWCeBDMEA5dS7rvG41iothI92sWyqnmxh6bkbntHfoiE+htxE46ZaYM+R/grH8g29eK3F/mJnmSnQgvMy5+DB/J+u/uGNwmz3cgzE9SIhUZENll3mX04pbJ91ZOK9iffjZzxUkS1JBIOUs5wZrmnamIixxiqiotsqZKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIQleB1AFrnW7iHGEWMyVGryaLFdWb/L1obCm6gJ8cw=;
 b=K50h+AbwGR+Yw/K6n7/nBFKfi4aq32U6LdsZMGv6Iv9TPqr4idbnK1tRJAXb89fCp2SGuQ4bXCNhkekD3OxJzGJQMnXEOYK4Ng2FQIT80SNVtvoi+hUvKvSpKs4db5ArW5L9oB3jX+lIO/uDgLLY86AuSFhhmQkDiqOdS4A/dORtt5p2EnQVD/Ofz4wooXYdlVUtSp/XZ+IBw81qtKlan0GT7sFgpig0RYn9OQyp6q7shEcI16oiHjzMCd3uLiqI+ucXhiBigrAjt8qJLGh/Yrwz/1n+jkqAwq1NjnUQ7da2CSiTXdNSLz8uGWl8XjRod/YqWk42do5rNVNsi5MkDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM8PR04MB7330.eurprd04.prod.outlook.com (2603:10a6:20b:1c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 14:37:29 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 14:37:29 +0000
Message-ID: <5a331923-e645-9265-75aa-dcca7e57a312@suse.com>
Date:   Thu, 25 Aug 2022 16:37:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v4] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20220825141918.3581-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20220825141918.3581-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0116.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::20) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 040b75bf-055c-45df-5d03-08da86a75670
X-MS-TrafficTypeDiagnostic: AM8PR04MB7330:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 806O5ZtevzZK+AM55UtLMstZmRVjrdWHksUiBUiz37d9Y1DJEfya0d04GgKrMoniV4xqSxQSlhiITrxi8ksJkxrmdd7p7b8Q/93yLeAHg89FQ5z4XaKcZltuDKi1zdauAMeZ/z45uSogHTaLe46BT/VVZNWjA+13T6VZ1ACp/6riFuAViCy1H3DTC5tIQPdAsBdBSOOjE3Pj6wivbw64Q5p3dY9k0cV0wTgPOSMTqFllIO22EuYZHLJ6mjRaOCXADnDvqoLJqH04xJhjW/MB2UA+Bw8xQkg3ODtF5aa9JFDi+8ojTvvlEv/qzSS6aXL/pb4yrgrVp2vvfN8JxJi0u8HOQ5ocb6YBHN0dbdEJAs90hbR0f7/cxn+QOWZTemsCsqf7GAm4OKBGIyse9kvR/xL/+93u3WazV7VxNNch/fMjsoBSsfm70BqaRst08XtjM1PDxwBvB28yrxke/eGKwJ4ZcY9YCSdlw/ycfXyMSTaTYU9drmV53i9/ATwG5d1LY1tBSmpCQnzB6hZrQwX54MUPIKDs0LMMq22FUEGX1UKj/X0W7iYa1isAujdOn6bHt8Du/FHr++iKYJPVaGGatRacIuuPQhxq9zIgnyDA4eGSjMz92MHx8e+wyNLo48VSjD31RBAPGRsv1ur/ZtlOP7ANIvWAcV24s+bNscgHN7xfy0SBQSGZ0vsukNbEQuawaU8+LRuJuzPFAgLRjVQJ3ochCSwAAn10F68epnGVpFNPaOUg0aK0VCbsKXs7KOyECHITkRPD1jf8ck4YgTgy58z3tX53uBjhnb7NVU1ut2E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(39860400002)(376002)(346002)(136003)(38100700002)(54906003)(31696002)(2906002)(37006003)(6636002)(31686004)(6506007)(36756003)(186003)(316002)(6862004)(6512007)(8936002)(6486002)(41300700001)(66946007)(5660300002)(26005)(83380400001)(8676002)(4744005)(66556008)(4326008)(478600001)(53546011)(2616005)(66476007)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmRtc0RqVW1HRDY3QytCbkdYdzBKNWtRRm9xbHZaSnV4Skk1WGNBdDloYmI0?=
 =?utf-8?B?RncycXZsSlNNOUE0NTdhejNLMzFPTlRtQ2lEYUN1ckFuVGxxaDVHbUIvc2My?=
 =?utf-8?B?dndiaVk4SVhSMUNwZFh5ZUtlRFI1R3lRR1k4clphU3gwamlwWW1BMm1GZ1o1?=
 =?utf-8?B?cE9zQUZPSEs2SHFIY0xZY3dMcXJhci81RkdURVdWeHFOYlY3NmRYb2RKTWJy?=
 =?utf-8?B?ejhyelpRTmZJQ1JlZDBRSGRSN29MNUtlZ3lvTThQTGNyTUdXd3NITnpwM3FT?=
 =?utf-8?B?OUJYajVoSzRBMkovMGV5U0drRnVjUG4yRUlYMEdWTFBEQWtVOVdydVBFWURD?=
 =?utf-8?B?aVAvN3F6czQybTQ5WDR5WnE5b1dPSUd5YlNGeVNPS3RBZTBZZGJ5ckJSRWM1?=
 =?utf-8?B?VkxvUmxGUkJLdVNXamtoZFRqdDRYdnhDU1V6NU5SUGhXR3FzSEVuTFJUZFl4?=
 =?utf-8?B?UmhpRUNCaVVPU0lMdHljeWlGb0lLVllROFBFdzA5QkRhWEp0MzBEaEJmYW83?=
 =?utf-8?B?SE54MWt3dUUzaWtUQVJaa245T3ZxUmRhTU5ic090SGlqaWFhWVFEZzFpVXdz?=
 =?utf-8?B?QnFiUnpUMkIrK2xJd0lUdEZXTnZFM3NUL1FjU1RTbjRIY1ZLWFJaM2JmZi9S?=
 =?utf-8?B?NVRhUEo3SWhwY1p3RU9WMHFjUFVMRTVCczJsdWZJSmd5eUV3NEFkRWNybFlF?=
 =?utf-8?B?MDRsNVlxRkF2WTRzbHZDMlFHZXYwSTBIUkduUnlIWUtBNUFpR216Vzg4U29T?=
 =?utf-8?B?cllxMHU0SWhqVmFqQzVPcXBzQ2krVmN5VTdwNHprSFBQaHhoRFZOb1JwaXdS?=
 =?utf-8?B?RkZXbXNMTElUNlhYVDJxTDMzMTVabTZtWU5FcERNYUJFNzVhZjFaaCsvK3Vu?=
 =?utf-8?B?dWNySG1HWkhQdlM3Rkl4dEoyOVdlVStsRDhoZ2hXM2ltWnM5QVd4Uisva3pP?=
 =?utf-8?B?dURBY3NQaFZTa1BvYWJieWVNOVc4Yy95VkJ2UDA3bUhId0psb3d0UVFNN21P?=
 =?utf-8?B?ZXNlUjE1SlcrL1phNVI2djdLbWJuMXlNdXZlR0E4aExEMWduRnJSditlRnJy?=
 =?utf-8?B?NWhuVWlQY2xjb0tuWit0R3NIWWg3a2tjKzRzWTFaL0MrdTh0dC9TZDRvSDN1?=
 =?utf-8?B?NnloZXRwNDgxcDRINzRVUW8wZDhzUmhKbDg3T2I4dWUwZUU0WEp4SVkvRVNX?=
 =?utf-8?B?SEdMb3llc2xFNFZEWGJRTGw4VUxkTmx6Z0xmZ1VGRXQyZWltUDZoSHRUR0VJ?=
 =?utf-8?B?UVVLd2NZNnRacURoS0NQK0dlc1NQMWhKREJ0ZGx6MmN5MFY0cHc0Nzc5VnRJ?=
 =?utf-8?B?bzc4OHpha0wzb0wwZ2xleDRWZHEyalBvY1NrT01pczc5VHJqMDcvcExCM3hX?=
 =?utf-8?B?Y1hxK2RZdXdLa2h2VWVtUDgySVZmWDNyc0JwNnQ3TWZEWHNHSDNuZWxKa3Nr?=
 =?utf-8?B?enNvTExnWmlGOE9QbmZPRC9xWml5b1dqQlN5eGRHcmNqcmJxVDZESStoMjVH?=
 =?utf-8?B?Mk9RS3VsVGZ2N3FrUzd6S1JjZW9ScjVFU0lFd2dmcC9McG5GdlphNytpR2hh?=
 =?utf-8?B?S1gzL2ZlTzU2dng3SkY0emZWWk5xK0RIN1lJV2NwRU5FOG1VZjNSTVU1cjZW?=
 =?utf-8?B?QlFXMkcwVldCSk1LZ2dSRE5vU0U2djdaNVhNaUI1YWp4VmkxSmlnMUR6UmZY?=
 =?utf-8?B?aXdmbWtYeWFTaFJ0a3I1NHRXMU1rVDE3NVVDQndxLzVMandaUjF4Yktpdm5v?=
 =?utf-8?B?Y05QUTNnNitOQi9tVEJmbVlQM1Jha0IxZnppY1RJcGw1VWRiMThqTmhtK29q?=
 =?utf-8?B?OTRhZHBqRzF0ZmJYK1FwRm1FWmNJN2RmWFdVcGUvWUtBTDl0TkFVcStVN1dG?=
 =?utf-8?B?ZHNsR0ozTkJGUHVnY3FSUFJxdVFrSnRld2RSTnF6MEhLRklLUk8rc3c0Ymd2?=
 =?utf-8?B?YldHT3JwZjI0NnRxK1pQci9hQkJhZHV3NEs0YUgrNUlsOTFYVHVsaFJnbnlq?=
 =?utf-8?B?OGZzZG0xTkhRWUkxbTl6UE85OGZmZ3pmbHFXMXNvMTB0SkRUMTUvVGNRZDFQ?=
 =?utf-8?B?Y1FWZW9OdU1LQmtYbEE0akxYRUxwMEp5OG9SNGlKN1lZeXBuOHBONUxOZlFH?=
 =?utf-8?Q?Hhf6I0hyuY2i5p/LQYI4Jeo17?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 040b75bf-055c-45df-5d03-08da86a75670
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 14:37:29.5305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H2Mdk89Q+rrRTNaFCI/Z97lF7E9cgDWXDtojCcs2EDN/r33kLSX2DCkAiRdUNUkKLpqwXw0Yo20iMCzyuhzJ9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7330
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.08.2022 16:19, Juergen Gross wrote:
> The error exit of privcmd_ioctl_dm_op() is calling unlock_pages()
> potentially with pages being NULL, leading to a NULL dereference.
> 
> Additionally lock_pages() doesn't check for pin_user_pages_fast()
> having been completely successful, resulting in potentially not
> locking all pages into memory. This could result in sporadic failures
> when using the related memory in user mode.
> 
> Fix all of that by calling unlock_pages() always with the real number
> of pinned pages, which will be zero in case pages being NULL, and by
> checking the number of pages pinned by pin_user_pages_fast() matching
> the expected number of pages.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: ab520be8cd5d ("xen/privcmd: Add IOCTL_PRIVCMD_DM_OP")
> Reported-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>
