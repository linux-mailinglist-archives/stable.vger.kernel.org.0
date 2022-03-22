Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCEB4E3B4F
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 09:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiCVJAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 05:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiCVJAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 05:00:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE95BE97
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 01:58:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22M7HVW1011651;
        Tue, 22 Mar 2022 08:58:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tgnGLhetsdkujUjxx36AS1OVlJemREktU8YZt5kjXG4=;
 b=oyVPdKJ4zk9xq2zMM5pGYN01IxTaApMo5Fj9C2r+YIiuIkN0JDdsL15X01rCeNc/QiEh
 mxVoO/A0rJJSGs+FdgsuvvGYnbMN8VfUmbw18kbs8WuYtoDis6rJt3hk74X802MHk9B+
 H8jie9NXa2tCGY/7MfGBbLjqrpy2uldHMmDONdjQJjTzNl17ZaY9bKYmdbinNB30ruff
 8Qn3/qJfnKruXz8JK3zjQZwPk50Vrq+0FYpID3Tz1T2tYuir5DnvMrEtGw0FgGL5psrr
 ES58U/HnryMAQZUZwf0DEJpNJf2JmCHmRI4B+B93UiGol7iMRrVKE2thx9y3TTxzICkb jw== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss5q3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 08:58:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22M8vF8r004649;
        Tue, 22 Mar 2022 08:58:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 3ew578u52g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 08:58:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XjCyI8Ad/3aFjYCEeLZYd+8fguyyI2RpKu2CKChU9zRC8Y+3Qm5KXRm/eD7XkIgPPc+f6U3leiFENWEIGoDElWtTtT9wEBJJ3OK6M8aQNO30YfeFFK3Rx2C01W1yWLlEIEQ0hBox87Yba6ZkIdXqTXWC4bOOQOWp7YOGuVtzKkNSqBnxVx7A52a5WPVPRyHlr2h8jbcIOVVemERXL/zT/IEd+3+yq9XPp3zRxcnRyvSz8XDZZi8Y5EpqrqPB8qOGV7sNFe/FRoy8ocwZQJ/Nw5aXIRK1ombVwZ4RRTI4yBXBaWJ2yc2eKcyvx8v1VN6VJnbi3fIITSkvX8kL0+3mGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tgnGLhetsdkujUjxx36AS1OVlJemREktU8YZt5kjXG4=;
 b=Ss027UqWqY2xT1sIVolFWRoVqdAqT/D7ReKAVQu7YlcCQjV4hg45mUii6VFPjPdbJmQpkMlr3hB7vljL1UIn1gfGPjkrk248GlkP0GdEuMZI4NmeFFaxKF1zwp5Rl6FGDWH5HSOBa7CeZCWhDauKc8WdDGmvSSl0HTRlYqdCVSAPm3VQuBKiQfwCbf2TCmnXPhPjMdJ6WYk2MyMKZjv+59AvU/cOXDSBsmEF+5nUdz9HeCunkezGpXKkhzpN2oaTJPb+wV8m3aFymGjj8zEGOq1IKwUGMtARdyujzs6sggRjsWkkl5HP39FUw4iRkECbDCmCCYJmRsYpKPJ60P2Adw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgnGLhetsdkujUjxx36AS1OVlJemREktU8YZt5kjXG4=;
 b=qhRUFTqAZZuXP2yBMAy7uD8fmOCzKjZIo6wYBcx4OM043xlbJ4M3xapmjiKp1Y21pSQzcyRHvE6FcCGdcCrKvbaSxlJS2D4lQTPH3Qu6jq6Y5snbfIWEmXYFPX/bP70kBgxSzabd1aouAxvwtmlHfalA3GQBZhQJXbVdnU9GESI=
Received: from CO1PR10MB4627.namprd10.prod.outlook.com (2603:10b6:303:9d::24)
 by BY5PR10MB3921.namprd10.prod.outlook.com (2603:10b6:a03:1ff::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Tue, 22 Mar
 2022 08:58:12 +0000
Received: from CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::407d:30f6:5f26:5ce8]) by CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::407d:30f6:5f26:5ce8%5]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 08:58:12 +0000
Message-ID: <c5bd1f13-e106-77ef-8fdb-ea95d78baeeb@oracle.com>
Date:   Tue, 22 Mar 2022 11:58:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [External] : Re: [PATCH] nfc: st21nfca: Fix potential buffer
 overflows in EVT_TRANSACTION
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jordy Zomer <jordy@pwning.systems>, stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
References: <20220111164451.3232987-1-jordy@pwning.systems>
 <20220321174006.47972-1-denis.e.efremov@oracle.com>
 <Yjl2pJ5zL4kw+5eT@kroah.com>
From:   Denis Efremov <denis.e.efremov@oracle.com>
In-Reply-To: <Yjl2pJ5zL4kw+5eT@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: OL1P279CA0020.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:e10:13::7) To CO1PR10MB4627.namprd10.prod.outlook.com
 (2603:10b6:303:9d::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85e310a6-e64d-447a-0d25-08da0be21838
X-MS-TrafficTypeDiagnostic: BY5PR10MB3921:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB39216066CCF7064E3EDC1285D3179@BY5PR10MB3921.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+GlnuSVuEag6Cylf/M8YJ4dvZDdhQ3Kq4n9VQkODf/tR9+zVyh1fFYbzaoXvDj53WcaVJJaWIhDN2RgRuJCcJWzhPPWMr8NHfUeL51QFExt9evAhafKWzFS1KRbBV1ggqiGudxTszoxUusuSubTwLqxAwmqdSvZKlg/fPET0z9laKfbCKhJVB9mV23Jnhdk1LWjgOMjk1tz4VqoUHD7/TtMC0EvFUGh3SFOMw4o7+DHscMYfXt5Ff4GsNBKjhoYQy0XI26ATvqp5eRqCxmchjsyMoXKlSFk888tpwKCFq/AILYKEIRXA1bkeeJEKCqvYLZ9O5W8juIGzO/CI+LMq7W2hZ5FiOc5drK2PS1B/e81KI6BgGEnAnytUy1CIvszLkbqBiiAMR3c6zOtM79wyQ8pHmq74ynuvp2CfVkZJWr0z3E4T/7Dstc9YlmAnWE4NF9hqzS5e+KBIl1QbSk43/3j0sGRyDZIjrFE1yYg2/uX1qVvLZ0/4SjMuNTMz17UkBbm4dTJQWwggEsdq3hkX/zFQsapuSxOCylR0tVK1D0s89Tkdbi2wHgbsT6fjpAr6lIQ76u+4YXPt3SFFVPo2DG+vIxPvWYGEwTohjaM1+2GuXGx4waxSiZz1TbAhW092OusfuGxfreafGKjcxn9m7n73Dbd/bjWKhx9jIGMYYbvQue1/qbx9AsVYOt3fqCldapHg+R4KdpCoWCzb/qWP+C1hCznyb4iaPGg0lZ5IWM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4627.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(316002)(4744005)(5660300002)(186003)(6486002)(26005)(6506007)(38100700002)(6666004)(86362001)(31696002)(2906002)(6512007)(31686004)(36756003)(4326008)(508600001)(8676002)(8936002)(2616005)(66946007)(83380400001)(53546011)(66556008)(66476007)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGVxQnJ3eTVZNURBT1p0UTNVbzJRbllSNG5JcnRZN1dNNVQ4MkY5TkhkczIz?=
 =?utf-8?B?NnRwTlVTaWw5ZURoZFNYYTUxR1I2L2QzS2QxOTcyOUdtdjhUVmZPbStCSGpR?=
 =?utf-8?B?VUkzemRCNmFkODNvd0UzZzd4OUxwcVZmSWM5NUZFQS95UTlWL1JxTmdTczR2?=
 =?utf-8?B?QmcyVDFzcWhXeGhCMTduWGtteDdSVm8vZjZMRW4zczR4NzdwZHVCT3VDMFBU?=
 =?utf-8?B?d2tnRHNtd1RoQUV5RGZ3YUNDOGFLaXM1d0VGQSthZkVkTXlZYzFYamxOZkVC?=
 =?utf-8?B?aHFjek1Ea1pZTm15VXFWcWZJUG9xSWtlUTdGNWJlckMyUnBIa0NjZzQvcUtL?=
 =?utf-8?B?UitsMFFnNllmcDA4TUh0SmNmd0ZzWG5mTWQwbzErUUZJcm5mc3g5b2cwcE54?=
 =?utf-8?B?WDg1WTgzWDVFTEIrQ3hTeDZONXhiSWJ1Y3V3UVN6ZWk1Q1ZXVGFFVzFBVTRG?=
 =?utf-8?B?cVcxdHBtdkJQMnhsdi9seHIzaDh4UmVCWWxscU9XeGpXaDZxcllJWDlVWVMz?=
 =?utf-8?B?eFc1d1ZRcXNlMnNsMzExcWowVVpKdkJGOGpqTmh2UTVFdFA0bFg4ZXZ0SU9X?=
 =?utf-8?B?WjJja3pOc0sxL0drMkkvWjQxZndBakVDRDlQSzBTSEI2ZlFFT2lSTHc1cHVQ?=
 =?utf-8?B?T2Q2dk5DU1dkUURVMnJJcTU3aUUreTk0SDVzdFBEREJRT2Q1bW1jWkJZd01Z?=
 =?utf-8?B?czJGUjg0eGlyVGdnUDVPNy80Z2VXcmZYc2E1QklXK3RpN3VmaFgvNlVuQ042?=
 =?utf-8?B?Mk9ZU0ZwOXRWd3V1eWZEbGMwR2pFLzg1aG96VjFXTlVZMHdLOWd6bHlKcmFw?=
 =?utf-8?B?MDlaaXh5eWJJWFBDNDZTNlczWnBtUjhVbGt2U2U2Q0FLVTl5OFNlRXljWXhO?=
 =?utf-8?B?dHFSN2ZZZEtuTFFlRGovQXdkYk5qZHUyQ0FOcmswREJxV0taM0JyNUxuYUl6?=
 =?utf-8?B?bW5QY0xFMmlnUU1FRE85bnRweWpwRCtkWnBLWWJNUnhFSlY2MHAwNlA1SW5v?=
 =?utf-8?B?NEFWTmdLY3JIeStSQm9TWldMYVBNaGVDc0ZhdDNQS1FOa0p1amNuZVRkaWlG?=
 =?utf-8?B?VTNlNm9nblBRR1ZmNGJVelhHNVBnaVF1b3RzdW5kakx6MGtKK3BVK0VFQnV6?=
 =?utf-8?B?K3JDcVEzUG8zT01OL0VlekFhRnNFTEYvTTRWa1BEMzlVbUlVZHB4ZkpFTUdI?=
 =?utf-8?B?UG0zYW1wWk5heVZyeURzeklKblBGaTF3dWFINnJ3VW9CdVZsb3ZicUVkYmFE?=
 =?utf-8?B?N3orY0RTeXA5K2hwVDRtN3RRa09PWml6S2syM2tiSU4wK3U0L3BzNUhVNEk3?=
 =?utf-8?B?UjdUQjNEU2xLRmF1WjNPU3kxc3IrME51eDh5RmIrZzZ2Qkh6R0lvTWhGaGRt?=
 =?utf-8?B?RUN1b0s3Q2JhakdQNGE3djVuNUpzdUJQWGkxOWpBVlBtMHRneEZkSnpjZk84?=
 =?utf-8?B?dC9peHJJRVIwaFBIUjJvL24yZ1RhQVU2SXplZmUyZ2JqVEFzaUdKeGp4YnJL?=
 =?utf-8?B?SGt0KzdONGxkNkpPejEvVnhBVFhIS0RORGpJYktqMXR0bTQ0bEFJNG0zaXox?=
 =?utf-8?B?V1RhdXV1UCt1dDh5VnlIMkpRNFExdHNiVEIxZWN6a0xYUTJ5cnpiZ0ZRdmJr?=
 =?utf-8?B?MStIOW5IQ0hFbVRrenFoSmw0RHBFWHA5WjdYek9QUHZncU5sNUlVV3VETGVs?=
 =?utf-8?B?REZQNktpUFdZeWd6WVpmRyswSmMyaThhekloSjVyZ3o5WFJXTCtYclpYZHA5?=
 =?utf-8?B?T0hUYUdsRkRDVUhhOEhrQXNvRUkxNTM2UXFadkxXdW4xd2RsazFtUHVBYVk3?=
 =?utf-8?B?clFsN010MTZhUzVJbkM1M3ZnejdFMjdYWFA4ZTd6VTBWUHIwaXNpcWViZkdP?=
 =?utf-8?B?Skl3WmpVN09wdGdSL2Q2Zmk0aUhjR0hEUVBCUnB0S1RVZ1MrWTZUM0NBQmY4?=
 =?utf-8?B?cEplejBSdEEzU2RTcENOWUV4WDNOUy9nLytMZ2RnRjVWaDhZdWlHT3l1Ylc5?=
 =?utf-8?B?WXZUamorL2RBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85e310a6-e64d-447a-0d25-08da0be21838
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4627.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2022 08:58:12.6792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Slhw4/aS/0PryKu0/NIThtTbsDaOFuHEuqfbefY1Zk3m+FbtBQr7V4rJGT5eBq2osSCxLoZ7O0NVyiSodja44IWwZ2rrBFMcg+q7DBCXvWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3921
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10293 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=971 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220054
X-Proofpoint-ORIG-GUID: 2MQUSs9bxph7kioiCkXlX3wigt4_ZB8A
X-Proofpoint-GUID: 2MQUSs9bxph7kioiCkXlX3wigt4_ZB8A
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/22/22 10:11, Greg KH wrote:
> On Mon, Mar 21, 2022 at 08:40:06PM +0300, Denis Efremov wrote:

>> CVE-2022-26490 was assigned to this patch. It looks like it's not in
>> the stable trees yet. I only added Link:/Fixes:/Cc: stable... to the
>> commit's message.
>>
>>  drivers/nfc/st21nfca/se.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
> 
> What is the git commit id of this patch in Linus's tree?
> 

commit 4fbcc1a4cb20fe26ad0225679c536c80f1648221 upstream.

Thanks,
Denis
