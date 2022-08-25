Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769465A0DA7
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 12:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbiHYKOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 06:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbiHYKOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 06:14:47 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9249A982;
        Thu, 25 Aug 2022 03:14:41 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PA7aSZ022127;
        Thu, 25 Aug 2022 10:14:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=ilf9FdxqeXu/eWDmZobRwDufIDekJH1qCgWxjBqOeOk=;
 b=Au8GWG4Rc6ZxaMFndN8m37C9zzus68LF5rSCIuOr89ygysDEmUgUluSv9UEDgk0iVoub
 OmiLOdYXN6ZQJy5U8Mb8jvFh8+pFG8XLt3hGEYxyx8UQyj6CkAI9h1q216mcIxJmltRb
 iO30j5EFwm9wfbsw0HoNT4iW6eLy/EQkjRFM2rpqLI4N2oyAx5OgD4K5AONtgF8joj09
 XhvEL8mPabPz5J3yhrW+2XdOnopfjbaqSBX1WxAYMHt1aHboR35+uWTzbDQn3J3Vyrpj
 idnWRz9AMj02Fu74fz4ljriVqBNE2RY4j4fwyFcniRrbO2tGmplYUUbKxF+uDQ+BRxNW xQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3j53ryhk58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 10:14:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZeNZliyY95JH0tvSV7xZOoaiipFqrk4oqOcTQ/lv1k4O4H+PD87JHQ/Vdh4765EFmdWhubHHXy8AB4v6rwRVEPc6oAN/6ZAcQemLllyU4ApXPjlUsb3B8aD/5ngJ9c6XolTxVRHdzJwvT7hjHk6W4rT1zCz+qbYZIIVzDN0+5dugyHN8x1j+Mk8YGyHzlxMmYk/34qmMaw5EP8x0T7trNxdQ5K63Fln9RZRHl0WwkpSmoC6gJ2eIevAxijihuoWQOieeEpk/oAd3Rmw2NY+gkJyKAFaWPVsTajjPuNo0cY6RnuYjLEhSm3UNVSpv6Xnt1Tj1dyamBrRrhJ5knuqbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilf9FdxqeXu/eWDmZobRwDufIDekJH1qCgWxjBqOeOk=;
 b=WAdMLvfhAk09ZQjzTT2U7oOtyqqwdIkwQAsD+4ydi72O/M+g+0WKFBRT2CMYL4W8aylQpnS/Ki1aFxCh9SrS9cgn8aTCYFPtMuyR8egn5zFYsG+gVzRDwSGSzPDAsNvAPeTTQx2HEuH0Rctub2Y38kGl8ZRemi9OLyylx/QRpqy6bm6zBss+72e8V5HSntx3Mou4/RA7RqE/6UmJcmAzRrM7J09wkVWNkf+RtCU0fhKZtLEzHkuKtdV2lJwEi0vwbCvGi40IWqaiH2g5OJ6KZaHVXFpAmK2DH0HDCU+VbO1ZAeKHv85B8inQwpPYJXeU2mwE3DhuzBMIunwzmlsDSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB3087.namprd11.prod.outlook.com (2603:10b6:805:d3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 10:14:14 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd%5]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 10:14:14 +0000
Message-ID: <d99dcc9a-c50e-b482-0a09-7040a2031a08@windriver.com>
Date:   Thu, 25 Aug 2022 13:11:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.19 025/287] selftests/bpf: Fix test_align verifier log
 patterns
Content-Language: en-US
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20220823080100.268827165@linuxfoundation.org>
 <20220823080101.125479106@linuxfoundation.org> <YwZOQv/dqReP8XfU@myrica>
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
In-Reply-To: <YwZOQv/dqReP8XfU@myrica>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE0P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::9) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfb555d4-4450-4390-8cd1-08da86828fbc
X-MS-TrafficTypeDiagnostic: SN6PR11MB3087:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7/XGpyt1ZLtmu3YeibwZwl/7yoBbkN/Mok6DET6w8sGB4CRRToEeDN9V1+UB0cjXWYVn9pLNGM/AYBxV18Cbfd7JCbwF7y0H4vmTq4gXQLK1M/YAaRrCPaBcYqS9/4Co+Gpmz4nZ8PvMSpI26vNbAv9vB0cmak5G/0U6bW8u9ZcBnje3hmQp/GDadWgxNW0XZS1VpJ1+BB6SApW62C+nVVNU+5dp2L4xfeKenxkvNXyItYyWMiSC7qzKO4srJlwS1/ZsX7qbseSrYBDGARt0xew6vpH2B9O5wk1RY74wWEtWmlju2AZB19T9g23mcz6qsxqGzZiiKCYuPiaWwAmYBIbBmtHpAvkRcVw7vsYsxtMr0GWf0082ScwK7WWk6jdRX2lq/7MXWhe0u3EpeMSMb7+XX5UM7AIUnj1Yli6IFAaFQPqc+ep/ybb6qBEysiy04DTn6ModHW7qmUz8XMu1m+LPJVgmc4n11pEYUu73nYczpfuyj/42sLEVRfb9Y10pF22lBsNF0c9WFDu6778/4op6W8QolutB8jOIGSYKGBlMFGBHH5FcBnXmF7j4sV/jGcIDf6Ltnshx1zyYgE4rxYxwoHVnzTq8imJ0o2UtbkUEg6TDVBeZ/t3srCba2qPqjjbMR9scj9T9V5KXaPEWau2627OZ67ngjBkbNC9u8Oi+Cr5eNyfXpgGVPd15kFpbI1sBeQcZSP9GdqfXgyZwsOAt3PLdbNOy+Z7QR3ARZf8utL/ab0EnpTs7CA6dR/Cx4/hKZb+KSX0d7IBON2NWQ8YdZJAVpVRNhTVz7Gx9VFvklHpqY17t2CstwU/RQOAC3ln3mwX9AlqujRC/iiK5hhmZeFMrHSiPVIwmkCEY1yQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(346002)(39850400004)(136003)(31696002)(86362001)(54906003)(316002)(2616005)(66946007)(186003)(110136005)(2906002)(8936002)(36756003)(31686004)(4326008)(44832011)(66476007)(38100700002)(5660300002)(8676002)(6666004)(6486002)(478600001)(41300700001)(26005)(966005)(53546011)(6506007)(83380400001)(66556008)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXNXS3J1Q3Q0ZVUvZlgwMHcwSmZZeE9vbGFvb2lhejlNMHFzZFNSZ1BsdlVN?=
 =?utf-8?B?ek5GSUJkR0g5b2RmL2pGUzF0Ny9DcnlldDQ3KzhjUk4xTDR1REFjUmJtWkxp?=
 =?utf-8?B?SHBUY1FKcUxSUUt3VndDdzgxUnNubUJxamd1Z2o4Tmh2aXlVY25KV2UrcE1x?=
 =?utf-8?B?NDhhSzZZN1A2NWcxMEZiR3R0cVN4dVBKdEkydjgrMUtWNEtCS3ozYlVnK2M4?=
 =?utf-8?B?bWt3YjdER1VwS3dHUktlYzc0R0QrNTFhc2NPN1FrSVhtYitPZ2hzSXdHdzEv?=
 =?utf-8?B?eWNNVDFPQUhiT25UaGl5ajJvMG9OaWt0RlByWGtZdEh1N1ZTOFNmUEx6Yk1D?=
 =?utf-8?B?YmRxOGJVaHJIa3ZTV1czcGxKaWpsTW5hZjBwSTR0TWRJVnpMM1V2b0VLRTZm?=
 =?utf-8?B?MkpGTG1pTlFlRUNHbnZUR2o0WjJQK05tV1IzSHprRTNOenBNek4zS202Y1lh?=
 =?utf-8?B?TitXQmVRUS93VE4zOVFIM3dIZ1cwZnBBd0krQloyUjRiZ2tJaUd0ZktydW1j?=
 =?utf-8?B?TWRvWnA5STVNMkdhaTg3K2lDRHhsaFVYTHBnaFhvZkRRNGlYSk4xNjBKVlVH?=
 =?utf-8?B?RTFkQXlUVGFmWkVPd2tkNmJzdkt3ZHVIVkw2VGpXMmR3OWRQVEM3cW01Qlhk?=
 =?utf-8?B?QjB3akJ5TjRxSDlCSHRDVUFDL1VRbjlSQlRab2lieGVOOWtMVEMwWTExTlhB?=
 =?utf-8?B?OG56dmpBNmpJRmdnNkFKNENFM1A0UmQ5cXJabHFPWXhYWlVTVDVjeFViV0Vl?=
 =?utf-8?B?NVc1Q2xLa29zNVI4N1R3aDNRcFVuYVUyRlB2Y2pMRHk2VDNWZ25BSVQ2YWVq?=
 =?utf-8?B?cWVHdTVvamxjOGVuYkNmUkhsaFRJcnZPY2pHdmx2dGp6K0dvcC92Vk5JQkZJ?=
 =?utf-8?B?ZkZISUZHdXdOeitKRmVIVFVRbU5aSFVIVkhVK1FCUnJ6NTl4VnhwK3d0WEpO?=
 =?utf-8?B?T283RlNWb3FNS0hsVExBd2J0OUxqaFJVR3lheEJKdjI5b1BKSXlTQ2xkV05X?=
 =?utf-8?B?MEJST3lncE5UMjVtd3E2aXdRbXZGb0JOUHYwQ1lTVHBsNEt0ZTdScERyaU8y?=
 =?utf-8?B?a2p6NFlLQVhBMjhYMm1FUnB6NTRHTG5hN2hGVVF4VXRnTXBKZnk4ZUgwV0Y3?=
 =?utf-8?B?OVhETWxTN2pwanJ3aHViU3VUUTVGTXFLOXhHT2JSNzJzZ2FMSWxQSGw0RWd5?=
 =?utf-8?B?STJhelhRSndsUXV6cVRYRk5CMVBuNEtxcVl0YlZPb2YvZlNaempZd1hKWHdE?=
 =?utf-8?B?Q3hoemliOFF2aGdadGtHcjRDMVZBbkdUVEQwV3FmV3kzUmFXd1MwbGJpcHU1?=
 =?utf-8?B?ZEVnK2JHL2RjMUJlSUZQK0ZRcy9Mdmg1Y3g5ZXZVTkRJbkV1YnRHQmdyZWZn?=
 =?utf-8?B?U3VlNGdFWTVoMFRqcUhRelR3Qi9sdzlRY0s4RU1XMkR3L0puNmFQY1R4L3Y5?=
 =?utf-8?B?NmFyMUQwS28xcTBiSXFaNUVFbkQxV0s2NWJFWmI0YVJIaGpKMEZtdWF1bHV1?=
 =?utf-8?B?VjVRN1VIQ1JYN2Nia0djOGNNM3hrd1NQVUM0S3hyaVVtS2psV1doc216TTFJ?=
 =?utf-8?B?K2VLSlBibnJPTkc1STI0MlQrZElLbDg5Ri9GSWJJM1NTRFdxSUdycXVyRTRj?=
 =?utf-8?B?TmZVOWJJMGpzaUhkYUVRMnp4elpwQ3pXZW51ZXhFclZFUmVOVjJyaEpNVWFr?=
 =?utf-8?B?WW9MYjRROFRBV2JLS3BoSmZ1bjFlcGlzVTdCTzBsTUUxRmVQVjM2NlRrSzh0?=
 =?utf-8?B?Y0dOdmFBdEJEcHE1UWwyZkxseW9yTmgvNXRVbEFuWGVaTkFrejFlcWdTbzFy?=
 =?utf-8?B?UWVlcVlwdmRZN0FDSGdsMjhzMDNaNFhheHVwMzkwUUtuOVRadldqUXJGL0l4?=
 =?utf-8?B?bjdYL3ZRdjJ5V3dHR21TdEd2VldxeFlySTlDYUVxVno2eG13VHRPelc1T2s0?=
 =?utf-8?B?dFhHOXQ0UThQOXVQbnRodCtnZjkvV2Qya0NiWWt0aDExK0ZWV0pMRnptZEov?=
 =?utf-8?B?Tmk2b1Q0bzlJQVVyMlVQVTkvazFkQU5TRzc1bFl4TVc1ZHc0V2VyWjJrRWNP?=
 =?utf-8?B?Y3BHME1vYVFrMDFtbEtmZDBDbHc2Z3VUME5xRWZmQTlIdlNxYWdRSDNxL2Zs?=
 =?utf-8?B?Ulo1eVIvZDdUK213SkxWTjdXaGc1T2JTaEF3SjJYdHUwY3lKdENZNGZXSUFt?=
 =?utf-8?B?c0E9PQ==?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfb555d4-4450-4390-8cd1-08da86828fbc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 10:14:14.4371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iBQBnOQXvLvljKZNeXPsmuQBJB6ixSW9m2pHtCtLdJdgopnx9cFIUWRGuMT1vuOF3umUVUev+ShoWFDxMxLtUkvyivnU5lL1oxiJGtyUVh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3087
X-Proofpoint-GUID: I7rx1dv_aXy4FCQCahUiV4vV_8i9gZJy
X-Proofpoint-ORIG-GUID: I7rx1dv_aXy4FCQCahUiV4vV_8i9gZJy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208250040
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jean-Philippe,

On 24.08.2022 19:13, Jean-Philippe Brucker wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> Hi,
>
> On Tue, Aug 23, 2022 at 10:23:14AM +0200, Greg Kroah-Hartman wrote:
>> From: Ovidiu Panait <ovidiu.panait@windriver.com>
>>
>> From: Stanislav Fomichev <sdf@google.com>
>>
>> commit 5366d2269139ba8eb6a906d73a0819947e3e4e0a upstream.
>>
>> Commit 294f2fc6da27 ("bpf: Verifer, adjust_scalar_min_max_vals to always
>> call update_reg_bounds()") changed the way verifier logs some of its state,
>> adjust the test_align accordingly. Where possible, I tried to not copy-paste
>> the entire log line and resorted to dropping the last closing brace instead.
>>
>> Fixes: 294f2fc6da27 ("bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()")
>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> Link: https://lore.kernel.org/bpf/20200515194904.229296-1-sdf@google.com
>> [OP: adjust for 4.19 selftests]
>> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> I believe this one shouldn't be applied as-is either, only partially. See
> https://lore.kernel.org/stable/20220824144327.277365-1-jean-philippe@linaro.org/
>
> Ovidiu, do you want to resend this one with only the fixes for "bpf:
> Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()"?

Yes, I will resend the whole patchset with the selftests properly fixed.


Thanks,
Ovidiu
> Thanks,
> Jean
>
>
>> ---
>>   tools/testing/selftests/bpf/test_align.c |   41 +++++++++++++++----------------
>>   1 file changed, 21 insertions(+), 20 deletions(-)
>>
>> --- a/tools/testing/selftests/bpf/test_align.c
>> +++ b/tools/testing/selftests/bpf/test_align.c
>> @@ -359,15 +359,15 @@ static struct bpf_align_test tests[] = {
>>                         * is still (4n), fixed offset is not changed.
>>                         * Also, we create a new reg->id.
>>                         */
>> -                     {29, "R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc))"},
>> +                     {29, "R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc)"},
>>                        /* At the time the word size load is performed from R5,
>>                         * its total fixed offset is NET_IP_ALIGN + reg->off (18)
>>                         * which is 20.  Then the variable offset is (4n), so
>>                         * the total offset is 4-byte aligned and meets the
>>                         * load's requirements.
>>                         */
>> -                     {33, "R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc))"},
>> -                     {33, "R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc))"},
>> +                     {33, "R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
>> +                     {33, "R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
>>                },
>>        },
>>        {
>> @@ -410,15 +410,15 @@ static struct bpf_align_test tests[] = {
>>                        /* Adding 14 makes R6 be (4n+2) */
>>                        {9, "R6_w=inv(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
>>                        /* Packet pointer has (4n+2) offset */
>> -                     {11, "R5_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
>> -                     {13, "R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
>> +                     {11, "R5_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
>> +                     {13, "R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
>>                        /* At the time the word size load is performed from R5,
>>                         * its total fixed offset is NET_IP_ALIGN + reg->off (0)
>>                         * which is 2.  Then the variable offset is (4n+2), so
>>                         * the total offset is 4-byte aligned and meets the
>>                         * load's requirements.
>>                         */
>> -                     {15, "R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
>> +                     {15, "R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
>>                        /* Newly read value in R6 was shifted left by 2, so has
>>                         * known alignment of 4.
>>                         */
>> @@ -426,15 +426,15 @@ static struct bpf_align_test tests[] = {
>>                        /* Added (4n) to packet pointer's (4n+2) var_off, giving
>>                         * another (4n+2).
>>                         */
>> -                     {19, "R5_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
>> -                     {21, "R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
>> +                     {19, "R5_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
>> +                     {21, "R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
>>                        /* At the time the word size load is performed from R5,
>>                         * its total fixed offset is NET_IP_ALIGN + reg->off (0)
>>                         * which is 2.  Then the variable offset is (4n+2), so
>>                         * the total offset is 4-byte aligned and meets the
>>                         * load's requirements.
>>                         */
>> -                     {23, "R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
>> +                     {23, "R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
>>                },
>>        },
>>        {
>> @@ -469,16 +469,16 @@ static struct bpf_align_test tests[] = {
>>                .matches = {
>>                        {4, "R5_w=pkt_end(id=0,off=0,imm=0)"},
>>                        /* (ptr - ptr) << 2 == unknown, (4n) */
>> -                     {6, "R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc))"},
>> +                     {6, "R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc)"},
>>                        /* (4n) + 14 == (4n+2).  We blow our bounds, because
>>                         * the add could overflow.
>>                         */
>> -                     {7, "R5=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))"},
>> +                     {7, "R5=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
>>                        /* Checked s>=0 */
>> -                     {9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
>> +                     {9, "R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
>>                        /* packet pointer + nonnegative (4n+2) */
>> -                     {11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
>> -                     {13, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
>> +                     {11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
>> +                     {13, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
>>                        /* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
>>                         * We checked the bounds, but it might have been able
>>                         * to overflow if the packet pointer started in the
>> @@ -486,7 +486,7 @@ static struct bpf_align_test tests[] = {
>>                         * So we did not get a 'range' on R6, and the access
>>                         * attempt will fail.
>>                         */
>> -                     {15, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
>> +                     {15, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
>>                }
>>        },
>>        {
>> @@ -528,7 +528,7 @@ static struct bpf_align_test tests[] = {
>>                        /* New unknown value in R7 is (4n) */
>>                        {11, "R7_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
>>                        /* Subtracting it from R6 blows our unsigned bounds */
>> -                     {12, "R6=inv(id=0,smin_value=-1006,smax_value=1034,var_off=(0x2; 0xfffffffffffffffc))"},
>> +                     {12, "R6=inv(id=0,smin_value=-1006,smax_value=1034,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
>>                        /* Checked s>= 0 */
>>                        {14, "R6=inv(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc))"},
>>                        /* At the time the word size load is performed from R5,
>> @@ -537,7 +537,8 @@ static struct bpf_align_test tests[] = {
>>                         * the total offset is 4-byte aligned and meets the
>>                         * load's requirements.
>>                         */
>> -                     {20, "R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc))"},
>> +                     {20, "R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc)"},
>> +
>>                },
>>        },
>>        {
>> @@ -579,18 +580,18 @@ static struct bpf_align_test tests[] = {
>>                        /* Adding 14 makes R6 be (4n+2) */
>>                        {11, "R6_w=inv(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c))"},
>>                        /* Subtracting from packet pointer overflows ubounds */
>> -                     {13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c))"},
>> +                     {13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c)"},
>>                        /* New unknown value in R7 is (4n), >= 76 */
>>                        {15, "R7_w=inv(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc))"},
>>                        /* Adding it to packet pointer gives nice bounds again */
>> -                     {16, "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc))"},
>> +                     {16, "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
>>                        /* At the time the word size load is performed from R5,
>>                         * its total fixed offset is NET_IP_ALIGN + reg->off (0)
>>                         * which is 2.  Then the variable offset is (4n+2), so
>>                         * the total offset is 4-byte aligned and meets the
>>                         * load's requirements.
>>                         */
>> -                     {20, "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc))"},
>> +                     {20, "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
>>                },
>>        },
>>   };
>>
>>
>>
