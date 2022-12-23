Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6249655036
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 13:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiLWMPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 07:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236010AbiLWMPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 07:15:48 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92082C6C;
        Fri, 23 Dec 2022 04:15:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kwiijt7itVYy2SrNG6lWm0xu3LmtO1SOH/0vI5j4XQJM54pRNDrXD0crsaajma8em4XYj7Z7c77uwKW4h2SZV8c5GF8igV4CxcY7dYI2BrUoSEZH6J45GSGutEspMFSOtZjq46Gczz7i5fx7PnGzaJKTCG0cXCifRws+Dl3iYEG8yS5uT70XvFaG5zwISLgMWoI2LrPceKG/JKpqfPv51RJ+317yBlRcAxzd+NFWJAOafIDp8w5ewwfrdxnnCTd9hSEvMrC5wY39Q3yFZxeAigp7JBxe2r+SU3cV9gL5upGs0U0aglXzzKP6gj5SM7rrDA6YXdC3rktxc9EYSov1fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9QEOCsM1mB5wZ0e+pisJrx/smqF/Do8t92VIQ2cXv+0=;
 b=kLILnYAcNaBKyjkPm3jUpsQXMQTatVrJa4IjqF4wHkjAoZhK/Oa+5oFTxixeFm2hjHITxA0hIr6Y9JNrkkV4xKH8+vJS9uCReP0UfEncDRXE5B0aJz1RFpFai4j4sUtTZXPLjNn1sV0/aTERAVvPB4ffDZLHrB3XjvHKTtvg6NxnbXdN2+Kx/hLDA0+mM89gAGeWaSdP95fuQY9Ff0NQEmrkAHikYZkikV0D/ks5xX0A0TJBpwoTHoAfSYRuplIP79q5WmJSTi7h1rEsUh9sHdBCY59+fJ5mG2Ii8YOG/560RxbIpB+xuS4PVo5GqfFI6kMJFzuLJh/j1l1pSb0wvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QEOCsM1mB5wZ0e+pisJrx/smqF/Do8t92VIQ2cXv+0=;
 b=scv2TkTIVZ2FCd0oqtt5CD+URetfkdSIUz8j3lojtnYRpdXOdu5QZ5oZ3RcD6HMiV5y65vGCLPJl5R8AVj8NPL4cJbpchyJY+yhLIXx5HgCMIL0/HPdyJ6imajAOtNm12slfMUZQ+k1srDx56dZX5MbVt2eD1H+qDQwVtI4Tl9E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH0PR12MB5346.namprd12.prod.outlook.com (2603:10b6:610:d5::24)
 by SA1PR12MB7150.namprd12.prod.outlook.com (2603:10b6:806:2b4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.12; Fri, 23 Dec
 2022 12:15:38 +0000
Received: from CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::90bb:a277:ad67:6881]) by CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::90bb:a277:ad67:6881%5]) with mapi id 15.20.5924.016; Fri, 23 Dec 2022
 12:15:38 +0000
Message-ID: <5771ea99-eef7-7321-dd67-4c42c0cbb721@amd.com>
Date:   Fri, 23 Dec 2022 17:45:24 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] crypto: ccp - Allocate TEE ring and cmd buffer using
 DMA APIs
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        Mythri PK <Mythri.Pandeshwarakrishna@amd.com>,
        Jeshwanth <JESHWANTHKUMAR.NK@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        stable@vger.kernel.org, Jens Wiklander <jens.wiklander@linaro.org>
References: <651349f55060767a9a51316c966c1e5daa57a644.1670919979.git.Rijo-john.Thomas@amd.com>
 <20221215132917.GA11061@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Content-Language: en-US
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
In-Reply-To: <20221215132917.GA11061@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0139.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::24) To CH0PR12MB5346.namprd12.prod.outlook.com
 (2603:10b6:610:d5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5346:EE_|SA1PR12MB7150:EE_
X-MS-Office365-Filtering-Correlation-Id: 24867849-0cad-4b78-00e8-08dae4df66c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zW//ikBFuSmOKjnnfeNyfx1CCWPIv12OkX6M0l0IBKPwYEOTrhUndGOFUlPmwEG/xtscnty3+5/L1GbXVFfz/C6m1m3v2UT4iNouqzK5bngWWstGzVXYpJhZ8MLMM67Vw86DunHBSWHhTz0vA08XaSxb/Oam5UDRdWvZ1SlVZ0/SqubCR7M0caZMglX7bJzGJ5mwQtVQ7NS7uZlPYbElyhnVllcQsEKLd+tViB2o/TILQ9xgZiHgahWXDrKnevAkYjRiRp091Z68DrT+kEymVNRraMX5uoO7v3SuaoegtNJ+bwfynL35TQYdj3pmx/UntRqXn05Qzha/Mc4opXAHZ6u+zQv2A0yctQSrwwJE6Gj9gk9S/rbtmMsXAAt7YLqw0Hzr+iCHFFeiCMBlwHlcAlVCCt7ZXPOpn9dlaX0FXBe0FUrSd4MrM+p7uLZ5xH64I5x+VbLLMlR4IbMY/tLlC7PieIlsmgZi+AEqpHdAjTQvS9cAfoa1qE5oOyf5jODETn/LNJnMb0Zzcg4216I+nzd6aPPkYlvSROTiaNSBSoUmhTwW5huRjULung4hN+M1tAJsaTc3z9QVvMGATyA5FLJj5eIQUJJflwmCuiZ10yMwELOmneax7zET5rvcLYJf4EODLe39YAXqFa0G6LC5HmmT82mN8rroGCuVZBWox37Uj/PIhlKoNOBh9AXZ3K3yu+v8zrgdDnicjU5U8O1cFTmKPLHOQ2C+oYU54fNLTWc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5346.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(451199015)(36756003)(6486002)(2616005)(478600001)(8936002)(5660300002)(7416002)(38100700002)(2906002)(316002)(83380400001)(54906003)(41300700001)(31696002)(6916009)(86362001)(66946007)(66556008)(66476007)(4326008)(8676002)(53546011)(6506007)(26005)(186003)(6512007)(31686004)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3k3eHF5K2N3Nmgvb29xWlJFMUlDZ1JoVEZXei9CNTlPWXdtYWdyRnAwRE0z?=
 =?utf-8?B?U0FISTgwdEJKMjNpOWhsSFJrMWViNElxQ3N1d2UwbzhEanVhV2xiSytzTGlx?=
 =?utf-8?B?Y3JTYm9RS0Z0bldUVjNBcEZBcFNNUmtZcU1BUGxpZGFhbkJXV0FLMHlhOEFx?=
 =?utf-8?B?ME8yZkNPbWQ2anJWWTFwaVBaNVRGalVWWTJYeDF3Nmg5VnMvaEFOMzd2VW02?=
 =?utf-8?B?ZkRzWXJxSVpQeFlNdW5ta0RMVG43QTZLcE8wamsxcWxmUlFYNHFaRjNzRHV1?=
 =?utf-8?B?NjVYdHpwclZTQmo1MDNpRmUyVkFqeGNqVXcwKzdUZ0EyT1VLUkRoTHczaEpn?=
 =?utf-8?B?R0JpdEM1QS9IbTRyc29FQitoUXRiQy82bXhPWDlkSSt5NWNUa3NVMVJlcE40?=
 =?utf-8?B?cFd4bDBHYTJ2SXF1VmlTa3hCOUM1MnhnclYvZEhWNDY4azlHRTZWcHhjOTI1?=
 =?utf-8?B?TzhmRmZoL1BubVRkZUdQVW95MytmYllpbWJYeTM0Y2J4U2trbDIrcTgxWUZu?=
 =?utf-8?B?d0NtMUp6NnBUSDdhd2ZGZUJxSGUyaVlyL0VwSjkwYVliNDY5Y0Q3TGNXeGM2?=
 =?utf-8?B?Zkkyek5JUzJ6TVViNHY0MW1PSjQ0SFN2eXVZSTg4eVV1UFJlK3YrSGFRRzhC?=
 =?utf-8?B?Vno5VThIQ0x3WDZYYk84K1lUcGg0OGdLRGQ1eEh3cTJDemRGNTVXKzlmWVFT?=
 =?utf-8?B?aW10WW1YOFBsN0UrVFgreTVqTEZVVi9lRmJ0bzAxZndmMFZNQjdLMzVJQnF6?=
 =?utf-8?B?SUVraC83aGdtenQyRi9EcjRYbjRmMGRySHVzUHlRdWlVOWpFd0xjay9xcklt?=
 =?utf-8?B?dFlBaHBkbUNwY1MweE4zWDIxWUt0ejVsblJ1QTFJSXpxUjZoUy9DWnFOckZK?=
 =?utf-8?B?OWVpYU1HendEcmNxbGQ1VVMvMEdnaU94emhvWnQ1cm5veUlJQStqMmtTRG1n?=
 =?utf-8?B?VXR5QTJKMVV3SlZsdEpVb1cxZEFJK0svQnFGME1XcERiaktMZFEvR2hiSDZL?=
 =?utf-8?B?MXZ0TEwzS0RDOERJODdiYUtmcVU3WFJtb1VNM1RORVQ0K2ZwUmhoSmlPTjZw?=
 =?utf-8?B?a2VHNWJEdDh4RVMzaHI5L1VnRml2N0pnSWFmVHVvMVYyYU5ZdGF0cktYR1VK?=
 =?utf-8?B?ajZqUkZiYjhEMGFwYkVtOWVNQXAvc2xVTUZkM1piSzJQeGRTNXpUV09kS1lu?=
 =?utf-8?B?ekw0amRvb0VMWHF3cDNLR1R6Z01ucHd0ZDc1UVpGWmlIVTRnbmNwOEZHNDh3?=
 =?utf-8?B?NE1RdEtvT2lLR2xXVEdZWWpFaVJnc1F5SzhieGs4K2pLcmpEY2MvN2NFaHVD?=
 =?utf-8?B?QnhCRUxxKzRWTFJCMlcwWVRvQmszZkNxeTVhQ1dsWHVrOStndWZaaXNwK1RF?=
 =?utf-8?B?RkttVTl4cnFES2dEd3pOektSUXQrM1YzNjZMR29uR2FtSExXejdOR1ZWMlRx?=
 =?utf-8?B?ckdHSExkL0JnYnFIdElCNW9TcjVESTQvdTQ2TjJNb3VsT3hJRzlCeXU3UXRN?=
 =?utf-8?B?QzNkZWRNcW1ON014Z210WEZrSWJxbUwydjVpSXdNV1Z1V3BVaWFScWplZjBy?=
 =?utf-8?B?VzJTQnZieDFxQThqM0I2aFZZK1lGNTNCanREcHQxWEFXR2l0dnJrQStKSWJn?=
 =?utf-8?B?K2JYMG1qclo1c211WW1IdmVPakxiVUJJNlBDRll0ZVhZV3FSaWV0SW9XVGtx?=
 =?utf-8?B?ZmtVak1Pci93elVtZ090elZ1alFXa1NUVnBFWGVjVTFBeHdWWTFzRDFmbEZB?=
 =?utf-8?B?TndJWnUrVVluWkdKTkp6Sm1kN094YTJEZ0VjdmxQRm9vblRORUYzSUlKc25N?=
 =?utf-8?B?aGkvdTlIZXVqWjd4dHVjV083MVVmQmJNMFZmQ3piU2FBMnRTcUh5R0kxWkdH?=
 =?utf-8?B?TmR2Wkl0cjRENlFkakhUc3hMUS9OLzl4dDBWd3Q5TGRoc1djOTcvYkQ2TTdi?=
 =?utf-8?B?Sy9QbWlxN1lrZllyQWkrRDB2MTB3S0QzbHdKTVd4TjhTcXhEa2NRYjEyZmhE?=
 =?utf-8?B?N1pZclpaUS95LzhrVFpXamE4Qk40elBrR3g2VTYveFZBaStLQXRsSTJ4WmQx?=
 =?utf-8?B?OXJzUTdpZ2xZTUdzazlaNjUraS9VNDJ6cWUzcTFibUQ3TWo2N0N5SXY3QjJI?=
 =?utf-8?Q?qhLAIG9C56ZDHGMt6ULD+KEM2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24867849-0cad-4b78-00e8-08dae4df66c8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5346.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2022 12:15:38.4256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqAa8Ib5d8VxlUU64jhrdTWvSbnmNtTyhlVzBM187JlcXlGPJacPSoUotbx8W+w1URJ8nJavwZE6npYhCkwBdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7150
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/15/2022 6:59 PM, Jeremi Piotrowski wrote:
> On Tue, Dec 13, 2022 at 04:40:27PM +0530, Rijo Thomas wrote:
>> For AMD Secure Processor (ASP) to map and access TEE ring buffer, the
>> ring buffer address sent by host to ASP must be a real physical
>> address and the pages must be physically contiguous.
>>
>> In a virtualized environment though, when the driver is running in a
>> guest VM, the pages allocated by __get_free_pages() may not be
>> contiguous in the host (or machine) physical address space. Guests
>> will see a guest (or pseudo) physical address and not the actual host
>> (or machine) physical address. The TEE running on ASP cannot decipher
>> pseudo physical addresses. It needs host or machine physical address.
>>
>> To resolve this problem, use DMA APIs for allocating buffers that must
>> be shared with TEE. This will ensure that the pages are contiguous in
>> host (or machine) address space. If the DMA handle is an IOVA,
>> translate it into a physical address before sending it to ASP.
>>
>> This patch also exports two APIs (one for buffer allocation and
>> another to free the buffer). This API can be used by AMD-TEE driver to
>> share buffers with TEE.
>>
>> Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
>> Co-developed-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
>> Signed-off-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
>> Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
>> ---
>> v2:
>>  * Removed references to dma_buffer.
>>  * If psp_init() fails, clear reference to master device.
>>  * Handle gfp flags within psp_tee_alloc_buffer() instead of passing it as
>>    a function argument.
>>  * Added comments within psp_tee_alloc_buffer() to serve as future
>>    documentation.
>>
>>  drivers/crypto/ccp/psp-dev.c |  13 ++--
>>  drivers/crypto/ccp/tee-dev.c | 124 +++++++++++++++++++++++------------
>>  drivers/crypto/ccp/tee-dev.h |   9 +--
>>  include/linux/psp-tee.h      |  49 ++++++++++++++
>>  4 files changed, 142 insertions(+), 53 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
>> index c9c741ac8442..380f5caaa550 100644
>> --- a/drivers/crypto/ccp/psp-dev.c
>> +++ b/drivers/crypto/ccp/psp-dev.c
>> @@ -161,13 +161,13 @@ int psp_dev_init(struct sp_device *sp)
>>  		goto e_err;
>>  	}
>>
>> -	ret = psp_init(psp);
>> -	if (ret)
>> -		goto e_irq;
>> -
>>  	if (sp->set_psp_master_device)
>>  		sp->set_psp_master_device(sp);
>>
>> +	ret = psp_init(psp);
>> +	if (ret)
>> +		goto e_clear;
>> +
>>  	/* Enable interrupt */
>>  	iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
>>
>> @@ -175,7 +175,10 @@ int psp_dev_init(struct sp_device *sp)
>>
>>  	return 0;
>>
>> -e_irq:
>> +e_clear:
>> +	if (sp->clear_psp_master_device)
>> +		sp->clear_psp_master_device(sp);
>> +
>>  	sp_free_psp_irq(psp->sp, psp);
>>  e_err:
>>  	sp->psp_data = NULL;
>> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
>> index 5c9d47f3be37..5c43e6e166f1 100644
>> --- a/drivers/crypto/ccp/tee-dev.c
>> +++ b/drivers/crypto/ccp/tee-dev.c
>> @@ -12,8 +12,9 @@
>>  #include <linux/mutex.h>
>>  #include <linux/delay.h>
>>  #include <linux/slab.h>
>> +#include <linux/dma-direct.h>
>> +#include <linux/iommu.h>
>>  #include <linux/gfp.h>
>> -#include <linux/psp-sev.h>
>>  #include <linux/psp-tee.h>
>>
>>  #include "psp-dev.h"
>> @@ -21,25 +22,73 @@
>>
>>  static bool psp_dead;
>>
>> +struct psp_tee_buffer *psp_tee_alloc_buffer(unsigned long size)
>> +{
>> +	struct psp_device *psp = psp_get_master_device();
>> +	struct psp_tee_buffer *buf;
>> +	struct iommu_domain *dom;
>> +
>> +	if (!psp || !size)
>> +		return NULL;
>> +
>> +	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
>> +	if (!buf)
>> +		return NULL;
>> +
>> +	/* The pages allocated for PSP Trusted OS must be physically
>> +	 * contiguous in host (or machine) address space. Therefore,
>> +	 * use DMA API to allocate memory.
>> +	 */
>> +
>> +	buf->vaddr = dma_alloc_coherent(psp->dev, size, &buf->dma,
>> +					GFP_KERNEL | __GFP_ZERO);
> 
> dma_alloc_coherent memory is just as contiguous as __get_free_pages, and
> calling dma_alloc_coherent from a guest does not guarantee that the memory is
> contiguous in host memory either. The memory would look contiguous from the
> device point of view thanks to the IOMMU though (in both cases). So this is not
> about being contiguous but other properties that you might rely on (dma mask
> most likely, or coherent if you're not running this on x86?).
> 
> Can you confirm why this fixes things and update the comment to reflect that.
> 

I see what you are saying.

We verified this in Xen Dom0 PV guest, where dma_alloc_coherent() returned a memory
that is contiguous in machine address space, and the machine address was returned
in the dma handle (buf->dma).

>> +	if (!buf->vaddr || !buf->dma) {
>> +		kfree(buf);
>> +		return NULL;
>> +	}
>> +
>> +	buf->size = size;
>> +
>> +	/* Check whether IOMMU is present. If present, convert IOVA to
>> +	 * physical address. In the absence of IOMMU, the DMA address
>> +	 * is actually the physical address.
>> +	 */
>> +
>> +	dom = iommu_get_domain_for_dev(psp->dev);
>> +	if (dom)
>> +		buf->paddr = iommu_iova_to_phys(dom, buf->dma);
>> +	else
>> +		buf->paddr = buf->dma;
> 
> This is confusing: you're storing GPA for the guest and HPA in case of the
> host, to pass to the device. Let's talk about the host case.
> 
> a) the device is behind an IOMMU. The DMA API gives you an IOVA, and the device
> should be using the IOVA to access memory (because it's behind an IOMMU).
> b) the device is not behind an IOMMU. The DMA API gives you a PA, the device
> uses a PA.
> 
> But in case a) you're extracting the PA, which means your device can bypass the
> IOMMU, in which case the system should not think that it is behind an IOMMU. So
> how does this work?
> 

PSP Trusted OS maps memory without using IOMMU (it bypasses IOMMU). Hence, we need to pass system
physical address to PSP. That's why we cannot pass IOVA or GPA to PSP.

We are re-evaluating our solution to handle other scenarios as well (not just Xen Dom0 PV).

Thanks,
Rijo

> Jeremi
> 
>> +
>> +	return buf;
>> +}
>> +EXPORT_SYMBOL(psp_tee_alloc_buffer);
>> +
> 
