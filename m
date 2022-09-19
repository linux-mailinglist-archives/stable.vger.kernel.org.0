Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41265BD69A
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 23:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiISVoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 17:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiISVoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 17:44:18 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0593FA2A
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 14:44:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDi6lTbPVuowBdHfW78xLnZIf0dbvuo31TU+IbiTOS+mVT82/6pjyrpvpjx74wsSiusY2n0hGzppgCqChaTNrDEU6L1VyCjoIjgHZLPjcqhlkFNPEYa0TDeEbc8KXgqOfBYw2BNt9L3RwlCUlct17XPvlA189F+HrcztrOr4miX25gEX2W31GUuM2IFEDnQ3E1ZQZmucY+0kb6gWnxA/KDKTwctvUt/HgrgV76qn0xGcKtuAyFndBgYbYqdOtJQWy2p5iVu2L6clu3pEGZVw818cfFUYiBs71QBdNbb7K0TiekXGVIJKzkSkrLUEMIk8ir44LNiM6q6mF4L5I9i1qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmx4XUK0ha8nF2FMkw4JegbwkJ+uKnXBd1JkPD/6+Qw=;
 b=FRqqjVsMsBX+NdUYTc09s1hE0wmWOezKp2LFixn1ILOIqyvDTNFyI4xPZE3DAVjlUuuOpGNps7/QH5AMgNrPePHmhucFPoRV/T3oqg1PzCo3/kfXcDtnRXd74P7uQqSAqY0WODc59ER4RPLbmA3roUn0jVGM/ZVDhVUJtRJ9fsPu3Kg8/DGvuFrKkmlaV0F8Oc8tyRDPTHCaiFXywSFOy8SxHYGCaDcKldGq1yPHFKXTSDQWA2V6ljZmjsaEmVS30wjOkKwqBrv3hr7ct1JhLlpPeSZKH2j1qTCG0zmLtJSIrs7mPleMcOuHXft+jmUWEdMqkHHTzHtSmEgxUJ3ugA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmx4XUK0ha8nF2FMkw4JegbwkJ+uKnXBd1JkPD/6+Qw=;
 b=CgMhbluMKAtdT1liX2ndvygQhY1vIpxa6FwPLF4/+T/rV3APGbVgusPkn+IAqPHiuZrmIqhmJ2wUF+HsAIL4v9AXLDMXVh5CGzLcZRxDh17tFmsy8ivwewYLfkOdG7DDwlpQYqRWyobrGaSe+6/woveP6yPtBio8rK5PGubWAPw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6203.namprd12.prod.outlook.com (2603:10b6:930:24::17)
 by IA1PR12MB6553.namprd12.prod.outlook.com (2603:10b6:208:3a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Mon, 19 Sep
 2022 21:44:15 +0000
Received: from CY5PR12MB6203.namprd12.prod.outlook.com
 ([fe80::7815:dac4:2a08:9a45]) by CY5PR12MB6203.namprd12.prod.outlook.com
 ([fe80::7815:dac4:2a08:9a45%6]) with mapi id 15.20.5632.017; Mon, 19 Sep 2022
 21:44:14 +0000
Message-ID: <2f13d9fa-4c33-eddc-e873-b84519ac241b@amd.com>
Date:   Mon, 19 Sep 2022 16:44:12 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: [PATCH 1/3] io_uring/rw: fix short rw error handling
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org,
        Beld Zhang <beldzhang@gmail.com>
References: <20220919201741.18519-1-avadnaik@amd.com>
 <ce458190-94b2-e7b7-3c93-36e52879fc93@kernel.dk>
From:   Avadhut Naik <avadnaik@amd.com>
In-Reply-To: <ce458190-94b2-e7b7-3c93-36e52879fc93@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0439.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::24) To CY5PR12MB6203.namprd12.prod.outlook.com
 (2603:10b6:930:24::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6203:EE_|IA1PR12MB6553:EE_
X-MS-Office365-Filtering-Correlation-Id: 13682e6f-e79a-465b-9c61-08da9a8818bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bQpX3FeHbiRrJXmAlry04Shb6GWW+VEM1P+1pJ5RBCgoyopQ6QgodrICIOieGJtDWVbTp8HtRfat3Iv56wjdLH15NHr15oxF4E9RKB7hD8c1rg36pXUXhFzTBUqrIkKuR3YbgPNxPmcHl3cV9WB2IUNCg3K3ZVm8zTR3kW7UGReMgnqOc5QXCLh71UdtWaDmM1s2He6pMsVNLqM00Aq6aF2KOWFIRe7OX8jakYeGWa4aln/Xmq56/Uq+pRbL3T59tUMWcdeCCVz0Y83YSpS120uN3V4xyi2LbkGAP9veYd263R0BO8yCpm1xIfE/dU6I8lL9XwE0ayPhH63fJhgiQnJ93HAWN4B4IVmUdlrR1GqNeWn2snD96mKjEtWFyqdM4xuGouISWQTQqa4O7TTk5XJEI+jTpQq8MskH8b371j1cSHU3IyJoduk4zSXaKD3eEg4kIk4tJEMEUGnU6pOz5jHH83mOYESUqCATqysfF0AusXFh48ua5/YmEgTv1k/7DLWyMRD7Ul1tf/OQqswHiZp0YsfAKHw+S24e9K/OKArH3tY7/UeSzHrHjr5/CbiYmFjRA5gt2OILx62W8CznstaEGchPPcCAH/XbyDTk9UucRc8jmt7J4ng85N4UGgenAYw0AU+UKdKCmkp+ezAZ4WFct6FxjgwnhHjBD0AcwZvZTObqs1KEw1yhhFA/0PoONpQv3g2lYT+3FVd1BLpSi49xXrhpnFJzO228umVaQ9XStRY3OPB9fdJnrrfazIrMaZrWl3b3m0RB3n9MY6NKnlVW4TSwOlkwONdZ5OeoyaA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6203.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199015)(6506007)(53546011)(41300700001)(31696002)(8936002)(26005)(4326008)(66476007)(186003)(66556008)(6486002)(478600001)(36756003)(66946007)(54906003)(6916009)(316002)(2616005)(6512007)(2906002)(5660300002)(38100700002)(8676002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aElROTFudkNzRUlyeDZUWXJVMkN5WXA1NGhyVVhRanRjRXJWVFd6NUUrZE00?=
 =?utf-8?B?ZHNnZXhSUTNLcXBMVGUyemY2T0xDbzBmUnFHTWV1T3djWFNWQXNIUzFuS0cw?=
 =?utf-8?B?ekdCSlZ3QnA5QU90OU9KQTFLMGxsVFFwMzBvZmN2aDQ4MWxpdHViVGZ2Qmp1?=
 =?utf-8?B?Vlk2eDV5dEIvNUxYMHg4QU10K3R3bDUyQ3BSVXNXVXpsOUVyVFQvT0tmM2ww?=
 =?utf-8?B?UFpOWTc1Z0NxSktnRmJPb1NqT1VXRWszdWVqWlVyemxTTkNvdG9DZll1QzR0?=
 =?utf-8?B?VVFsV1J3TVhtL1NxMk5Yc0phcXMwT1BoVVhWUUVqaUVTeDJ4RnA4YjlaVmxK?=
 =?utf-8?B?NkRxTmorVFhwK1RIN0w1d3N1M3AyNzlHbWhCZWxLTDlSMUk3Q1YvdXhFSkRw?=
 =?utf-8?B?UkVXcGxzTFBSZEFtRHZGeFUxaXRiMTVkbnpnRUZIZitNVXZPM0pLZFlRWGo2?=
 =?utf-8?B?ZGd5aU50ejhNS0VEWVo3OWpxcXBtM0ZaN2xIdWpLTEplZnNiekl1bFVub0ls?=
 =?utf-8?B?K05WeDZuUUlDcHY2MlZnWTZBN29yc1BYYitBYmdidmx3Rk1FSnpheVdsRWVD?=
 =?utf-8?B?dVd2K0l5ZjVkTzdtV1dEODBucytKUlUyRzFScG9QQTdRQ0h6UW5GQ243N1B6?=
 =?utf-8?B?UUdjc0RIdWFvaVhnWHovb2Zka2dwSWg3S1Z5TGhtWnBnUTN4OWlsL0tON1hX?=
 =?utf-8?B?ZkFLZ0lmNk41QmRvYVZCYUNXZUtHdDdHZ1Z2bWltVitCNjdxL2NDNVJwS2hs?=
 =?utf-8?B?amcxNDcxczE4amliQW94Ui8yamM4Y1dPb3ZJczZxbXUza3NrWnZhcCtkcVpo?=
 =?utf-8?B?VFNXYVJJZXlFT3Fpbng3QTNEM0ovMURxeWlJRHZwTEVjYzdtb0xCSEpIbWlv?=
 =?utf-8?B?MUZiTkxQZDhFTXVMUG9uU3QzcEltY0Y4UjR6NmdvbmwxUUs3Zi9ONmtjMjdK?=
 =?utf-8?B?SlE4UFYzNTZaQWdtUmxXaTBZRFRocDZ0bWxWcWVnOVBaUE80RmpKcTE4S2I1?=
 =?utf-8?B?L2o2bnJtNmI3a1BrZjgxL2Z4cDljd1RFMlFlcmJOc25xcjN4MWx1RS83VGtM?=
 =?utf-8?B?YjR1Y3RMRm1Rc3hrM0RRRVpRVERyeTF4UWUwYW0ySFMxRkR0TnJNL0QwQkhV?=
 =?utf-8?B?NmRZRDVta1ZrWU5RcGlNNjBycW9Sc2d6YVJwZG84UDVnYngrNEpPRVhvT0ZP?=
 =?utf-8?B?blYrY0lXSkVxdHlTOVpLc0hmRlg5cEZqRXV4dEx5WXlPaGhoTVhwbytqa3g4?=
 =?utf-8?B?ZVgzQ1BPVCtuMUUwMUpJU1JIL1g2aG0zTU9SQVdPRkNmdmNvQ3lxMjFKdlhr?=
 =?utf-8?B?Q0hoYnl0Vy9YcSt3T1piMnczdExsdmVzS3Z1Q1ZyblBWUFZmVVB1TXVvaUNa?=
 =?utf-8?B?c1JnY25ranpXT2oySWxnRUpBYmwrbWhhUG9WOVA1aG81NkVHcHdHL3VQVGFP?=
 =?utf-8?B?L0tWOFR5aTRWcjNTalB3cnJPb1hxbGlEZnpKWjJtZDNDSXZtSTdoZm8zUzNx?=
 =?utf-8?B?YndIUVhyTCtxemczVFFYcmVkQlpINjhnejF0b09VRFdzQzlxSnp5aWJDUEtI?=
 =?utf-8?B?bUd5Vnl3NWw3VHFSVlgyeVpjbFlpL0VSNW90R2xlVjBhc2tPcm9wRjBDdFFD?=
 =?utf-8?B?YUVvNW1SU0FYUSs5WkVuRWwyRXljd3ppYnBncnZNNDVGaEJEL2w4UUkzaFRy?=
 =?utf-8?B?ZWFDaVRrNjk1N3hvSUd5M3FrdEZvNTUzNlRSckJMOW5pY3ZraDJOSDF5OFZk?=
 =?utf-8?B?SGIzajNaNEdERDAwbHQvV3Y1b1FOVnFleFMxbzZaT1RLMUpQWWFxZk5aUC9Y?=
 =?utf-8?B?Q2liZTc0U2xjRk44U3poeENXTUZMUm1TQ1dTNU9uYm82dDlTU092a1F1b1Bq?=
 =?utf-8?B?SkhLaHArenppMDhEemN4Sm8xSU5yUmxJYXhEN2xDV2xCQ0JvU09URC9aUlpV?=
 =?utf-8?B?bEZkc1hxRWFEbjNOYUVrc3NXT24yVU5OYUFRWHJkK1c3WS9BT2RvUU0rU0JF?=
 =?utf-8?B?bG5WSUpGMmdacWU1bVovNHlIT2xsbnFLMEo2V3JGU0lxTWpqRGhtVnpKaTN0?=
 =?utf-8?B?YkN3MzlMbFJNcFNmOUFER0dIbHNrSThhT1pUdnZobzhPNlp6Z1RlNldTam1F?=
 =?utf-8?Q?lyaGV9Jo4T3sRVn94Iw1PI1OC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13682e6f-e79a-465b-9c61-08da9a8818bf
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6203.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 21:44:14.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PODZYyYXJTMZqHseOk3ISTeNtCnyUDtA8nm0WXa7LNh3nsBCk1qdpjZqjZcBEeDbjf8LrQm8qqo1Meuv7Z9RvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6553
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please ignore this email. It has been sent by mistake.
Wont happen again.

Sincerest apologies for the spam.

Thanks and Regards,
Avadhut Naik


On 9/19/2022 4:11 PM, Jens Axboe wrote:
> On 9/19/22 2:17 PM, Avadhut Naik wrote:
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> We have a couple of problems, first reports of unexpected link breakage
>> for reads when cqe->res indicates that the IO was done in full. The
>> reason here is partial IO with retries.
>>
>> TL;DR; we compare the result in __io_complete_rw_common() against
>> req->cqe.res, but req->cqe.res doesn't store the full length but rather
>> the length left to be done. So, when we pass the full corrected result
>> via kiocb_done() -> __io_complete_rw_common(), it fails.
>>
>> The second problem is that we don't try to correct res in
>> io_complete_rw(), which, for instance, might be a problem for O_DIRECT
>> but when a prefix of data was cached in the page cache. We also
>> definitely don't want to pass a corrected result into io_rw_done().
>>
>> The fix here is to leave __io_complete_rw_common() alone, always pass
>> not corrected result into it and fix it up as the last step just before
>> actually finishing the I/O.
> 
> I'm confused by this email, why is it being sent? And what are the 2-3/3
> patches?
> 
> And while this one should certainly go to stable, also note that:
> 
> commit 62bb0647b14646fa6c9aa25ecdf67ad18f13523c
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Tue Sep 13 13:21:23 2022 +0100
> 
>     io_uring/rw: fix error'ed retry return values
> 
> exists in Linus's tree and should go in alongside the parent as it
> fixes the parameter type.
> 
