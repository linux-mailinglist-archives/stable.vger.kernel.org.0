Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA9365CCB8
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 07:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjADGAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 01:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjADGAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 01:00:30 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2083.outbound.protection.outlook.com [40.107.102.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3D7175B2;
        Tue,  3 Jan 2023 22:00:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTyJUF3wD0ekX4hJegEAejwdaaKgz8puX2UiFXSGpYwjtBrtuStu5hhsfO78aPvcrc4tPN/T7u2joebOgSDAftyPJiBGGTbTgk0zZf/2PQgeshqBiNdBzzs1EH3GXTOj+CQGVTGVsFC+6I66Yj8xZvNiQbniqMLUGYJGuwDYFf7fdrzHAtinGLIu2Jh/aGC2m3JJxIrOV8Sj+nrL/8w7aQPpKB63+mlR12YZDeseKlzOnBSSa4nhyVdEfYdilW4NwWgiTqouQ7PYwkG8yKeSl9VmtZX+/qnV1i+QRqok6M2YTrXVGRvWLk5RHuayTh54tt8f17raOaw1YPyo/ZKRIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckGsqiQm5DW85wcy3gc0I5fViwbr2oFsS03UZr394pI=;
 b=J7Jnqso/BU7/J+xtTIg8PkiNcPLOEbdb8BbUXL/5NNuCO0V/L/4KFv1EGX0Pmzukbwi9Crzpbr1Z6d9ls+229q+ygSczFN2GcMD3I7QvcFhfxO2HjSBxfrNwNZu/N9/hIiWFtc5KmH5d704Yww6xSuvc6FRPwmce7qzT+RlVXIcPUysnP8/cQNeesKu9XGJqhG3vJ6/bgwF/DaT7SCNcLnoSsEJR9q4PY+Q8FkVGOr1hNE4DXkZBtkzakKrOwujkulrL9eRPHL1+Od2jYilPhY3uYI6imcbVc8l+RFWEZn2Jf5w5AtH5l+ohzXSNrpfQYBZATBa/UFFzqKaabS8IaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckGsqiQm5DW85wcy3gc0I5fViwbr2oFsS03UZr394pI=;
 b=hf3foG5q8Fc2K/Ah/dLXt/Bfro/FPB5LUFMPhf6pIqKjlRkzqIohT4Eu+DJ8lplhVCWCEcjy+MWClHeHv77Wgs2Nap43qz/RlSLjZGBNAnvbq/qaMP3h95C3Q0Zvwg7dGGB/AVA/93kCeDnh/FuaRz+peWoJvkSlUaXlZOu2DXM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH0PR12MB5346.namprd12.prod.outlook.com (2603:10b6:610:d5::24)
 by BN9PR12MB5382.namprd12.prod.outlook.com (2603:10b6:408:103::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 06:00:27 +0000
Received: from CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::90bb:a277:ad67:6881]) by CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::90bb:a277:ad67:6881%5]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 06:00:27 +0000
Message-ID: <9d8e5548-cb5e-ffd7-72e3-b65dbcf74938@amd.com>
Date:   Wed, 4 Jan 2023 11:30:14 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] crypto: ccp - Allocate TEE ring and cmd buffer using
 DMA APIs
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
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
 <5771ea99-eef7-7321-dd67-4c42c0cbb721@amd.com>
 <Y66gTtjZf5ZT0lP0@gondor.apana.org.au>
Content-Language: en-US
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
In-Reply-To: <Y66gTtjZf5ZT0lP0@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0212.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::11) To CH0PR12MB5346.namprd12.prod.outlook.com
 (2603:10b6:610:d5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5346:EE_|BN9PR12MB5382:EE_
X-MS-Office365-Filtering-Correlation-Id: b086656b-d5ad-40f5-9667-08daee18fa34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bDfY8op8BBWlJs4yjPBe+Ypo56uLy5Xj6SABTN+8ckebfO6M/O0f19oUDDjkkGTN3bgBctFqUrCqs41wU3HCklOCD+KnkhFhd/ZW168QUtN2JqyMC2h1mKYWL+x7OhfNJp5R3Gho/XFGc/Ahqv2oets8wk26mroBXrDj+lqKlk9v6q0QFnNRGmp117g5KDpE/+QCkdrtkLO9azRqjVj5snj6g9SHkak0Ys5U+w2MCOJdfVUkovloCcY/fig4Qrgsc+ErcSkelWEJV3S1JETMgkmSJ+57sEfvslnERBSqmxuYSU1CaQ/JO22ENi0SwC+Esl8q7bMPZA5BoHE5juMm2skSRLLZjYl08tJG+d8MPE+XDMXVsTVfNf3ycP7n++OdfIDwXBovanH5+t6DOyQlu+nftLTZ+iAsRofQT1slgGcMt9wxZo+lUeSvz1LCEVXHgEOvSxTmjdXRk/3SdJAosLsR0Pvjg7M5r9Z3UTCk6j/WQWtQIska1iCpblDRud0vvJIxYTl69yfOciJbZLXy01pT6rZGJ4tVofMWDUpnjnA964KtzM/Pq76lMZLPk7VOB0h9nsI5dte8FiCvd0AUgcq0IV6/9qkscO/RPxvLo/0sYdkw+TO3t0xJgfLzEPnScytfTIyMDQvprAHjjdcZ144Ce2TZifFcZO1Tsf1zpzttbh/C+hDJrZQvU1sBtYEBvInys0agEkoCjcDWBUzqYTakpjfu9vGr5LI3AMdInHo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5346.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(451199015)(83380400001)(38100700002)(5660300002)(86362001)(2906002)(8936002)(7416002)(41300700001)(31696002)(6666004)(4326008)(6512007)(478600001)(53546011)(6506007)(186003)(316002)(26005)(8676002)(2616005)(6916009)(6486002)(66476007)(31686004)(66556008)(54906003)(66946007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjFtZHp4VDR2SWE5bjRaTXZjOXVUVGx2SmNIU3JNQVR4d1hpSWNpaHlEUXI0?=
 =?utf-8?B?QnEwWFNCeGRNVnpyN01PWW1EVW0vc1VmeEFQV1dmWVRMT25CRG9HR0dUL2RM?=
 =?utf-8?B?eDhKZXJIZDhTMnJ4b1JLa3NSekJ5ZGMzWGRxb05TdEZVVVc0YUZYNnFldGlp?=
 =?utf-8?B?M3BOY0FkbmFheFU2YjJER0lIRHBjRlJJNy9yMVNQd2JEWTN3VG1VTDRvYW52?=
 =?utf-8?B?Q2xTaUlEYU9aMVNGbXZOM3VlbUkxN3I2VjA2b3ZjTHM1SUpldmxxTVBXczc4?=
 =?utf-8?B?SXRnNmNHN1JJaHdlVTNQQkxxbDhmWjVaVjZqVS9sZDRROTNSWnIzdFlkWElz?=
 =?utf-8?B?ZzBjWUJmSTZsRnY1MVlHb0tlSFMwcGplOFI1TVF5ZjVCL2M2SDRDZGdSdks3?=
 =?utf-8?B?SnQxN1BBWFVZMTlVa1lYNkpMTDRJZHQzR2lxSEZHWU5sT2NwMU4rLy8yQW0x?=
 =?utf-8?B?ZDl2OVVmenUyYm4wQmtIcG5nY3NRZFNXeE43dXVVTk01WThjQ2dhNzMrM2tD?=
 =?utf-8?B?aFR4eDBvNCtYV1hCWi9pVW5NTWlwYlo0SFloS0RZZjhZOWxiMnQwVy90YVdH?=
 =?utf-8?B?S1VHU0VLTkUwVWozTmE3b3AyQ25YUWh0NTd2cklQN1FUNGNvWDZBcUFFQVNh?=
 =?utf-8?B?UzYrem9DMW1sY2ZIaDNVdlZ1MlFnazh5aXZ3VktHY3QxOTlDSkVnZ2llSFlE?=
 =?utf-8?B?RS9aTFBUekF4dHlzK2hWSXRXRm01NjdrSHQyUWJYTDh1Q2poTDRZVzhsOWZ0?=
 =?utf-8?B?MzBZMzdkL1FycHhnNWY4c3I4MUY3Uk1qMDh2RGFyQyt3WW13cy9iYkxiSHNq?=
 =?utf-8?B?Q20zN1ZaTFU3dEFmdTNjNTRSb3FBZFdWb3lMVjVMeDB0YXF5T1Z0dnoxTThs?=
 =?utf-8?B?ZFQyeE1nSXNWTnF3WHVkMFVxdnB1N2ZPNThzWmx1cVRMSHE0TXNFeDN3akxr?=
 =?utf-8?B?K28zVXpDaGhOWXBnaElNQTMvSkhnS1ZmVzJ4ekw3TjdnQXpPcGhuQmkvZFM3?=
 =?utf-8?B?ZTR2SFprNDNvd2lDREF4NXpUMCtIY2E0dnRUMkFTcHp2QXQ0S0Q4cjJxYUFh?=
 =?utf-8?B?SEdCSXZMb1JBTzBoVXBtTXpCODJDVFlSQ1lCbi93d1k3aVpNZ3c5cWttMDBa?=
 =?utf-8?B?WlhySnNWUFpGb0pCM1o1dHdqckdnMS92SEdXemwxRkp1by9LSU5JZlhsL1hp?=
 =?utf-8?B?OElmMlNQMENRTHNSa1JBR3pRdHI0YjhleVZiNVVxS1lwcWVNVjFOdWxmcTds?=
 =?utf-8?B?bUhlbHNrMGlKUlVjV3c5bDFFZmZzYjBkL2hwLzVVbUIyU0Q0cmZ5LzZnditT?=
 =?utf-8?B?WWJVSmRiTEthTUxTVk1DOVo3R2t2alBOZUxybU5BY2gvcW9Edm5VYTRpbldy?=
 =?utf-8?B?RXFhSnV0VG8vbXNnZ0g3b2lJeEVFZFduV3ZTVlZXbEVrRVFzZ3Z3K1B6Qjdv?=
 =?utf-8?B?MjFoRDIveTQvekl0MzRRVWpKcktsMGN4dW1zQS9ncU5FYTBlOWVWbThXVXEx?=
 =?utf-8?B?L04ycU5aRXA1Y2czVk82NG1wNStGZThHMThLVU1xcisxTVVlQXBtVktONll0?=
 =?utf-8?B?azRZS05xZHdDL3pUUHcxcy9BYVRra1VEdlBhZDNkTEFWNzRnSHZ0czRoRkVk?=
 =?utf-8?B?U1cyb1JFOXM1cG12QUVJU2hvK3h3amhybXM1VlFCalJVcTlCZzJuZjZIVy9Z?=
 =?utf-8?B?eGVNVDMwY2N6bm40M2VGRDcrRGphNlZEUEVqTnJxTUFXVWdwQU5iL0lXSFFk?=
 =?utf-8?B?R1J4blBsZVhpQ2w4Y1VlNzR0bjJyMVlaQmVGeS9BaDk4cUNHenpvZEZmdUto?=
 =?utf-8?B?Tkt3Z1l4RlMwb3JtZGMzQlVYdm5GdlNhcVcvQng3cGlMTWFaYmg3M2I3UHA3?=
 =?utf-8?B?QTllYkpkaUlQMjJiYWFndS9XQVhNK1Fud3ErTzdoNVlTWjRicFFJQ2g4QUhh?=
 =?utf-8?B?b2NTbE9UNE9vMDZaSGNLVGJMTXV1ZnlZNnIrQ08xL2l4ZkNmQzRYc2RrR1Fu?=
 =?utf-8?B?S2x5bXBsdzJKcDZsWnZkc1orajJsMnhHcWdOVCtFN2VnbGJWTjg2SFo1czJa?=
 =?utf-8?B?OFFNMzJUTkwzTjVvTDNXcmtXMGdkeUl5UTd1c3JDRkxGWXdQNlZMYlBhOEJ4?=
 =?utf-8?Q?I5q3t1iwHsxt9yRvvU3Ec0htZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b086656b-d5ad-40f5-9667-08daee18fa34
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5346.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 06:00:27.4315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +V1TbRXLxm9puRt/WlLtCxFwa3NIk71uuOxRpppgBdgE+TLyWUXPgXkBP5AsGnUZkK32bCze8zjV+p+t/c/G/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5382
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/30/2022 1:54 PM, Herbert Xu wrote:
> On Fri, Dec 23, 2022 at 05:45:24PM +0530, Rijo Thomas wrote:
>>
>>> dma_alloc_coherent memory is just as contiguous as __get_free_pages, and
>>> calling dma_alloc_coherent from a guest does not guarantee that the memory is
>>> contiguous in host memory either. The memory would look contiguous from the
>>> device point of view thanks to the IOMMU though (in both cases). So this is not
>>> about being contiguous but other properties that you might rely on (dma mask
>>> most likely, or coherent if you're not running this on x86?).
>>>
>>> Can you confirm why this fixes things and update the comment to reflect that.
>>
>> I see what you are saying.
>>
>> We verified this in Xen Dom0 PV guest, where dma_alloc_coherent() returned a memory
>> that is contiguous in machine address space, and the machine address was returned
>> in the dma handle (buf->dma).
> 
> So is this even relevant to the mainstream kernel or is this patch
> only needed for Xen Dom0?
> 
> Thanks,

Herbert,

This patch is no longer relevant to the mainstream kernel.

Thanks,
Rijo
