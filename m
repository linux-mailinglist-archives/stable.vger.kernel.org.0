Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEED59ED4C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 22:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiHWU3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 16:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiHWU3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 16:29:18 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7758169A;
        Tue, 23 Aug 2022 13:04:12 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NHwk6O027127;
        Tue, 23 Aug 2022 13:04:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=NGCuTUQb6Sdc3x5/IS19tllJd6wFw5wi9wCkBphKMQA=;
 b=GqjjKYbJi7zJu32rLFxGvuArD1TD6gXhBfdtPtyLiLGnWk3j88A8gTsGdtwodsdqw1xr
 EZsfLG3+O1N9BtowCvk7gb3hrigZ1uGH1AjBgGaufG9V/kqzGSkYxfrz6A5A6dsLG/Rr
 +D4rmpNKlcz3+MWYWxg1X1Kw835PK4D/dKEYiVAo+EEvEKge+E3bGBBlqtj2hrEzz5Km
 x+UPDfJGRob/dNudTYgbQ25g4uNhPAtm7yQ5AirT8jwDIl8XCo6No4FdOlvRKVUDcNbg
 moB68ar46uE+da8ATlxYxdCjhJQ5RMeTGRcWKhTsnIS8aYqxcMAJHaLmjBt2lpQ4eyiU Wg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3j53rvg31g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 13:04:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxEYgc1mrU7VPxyI0u/vmIkPGJbK0bHUDPfrswyieas59e3z2xaphnSf3RvS855Vk6xtXCfE/2TNCm3LemdhyZJ16tNsC4zd+oOz8mWVsMAeZPkSegDZcSMOHDMo11oCz234tLM3sh4Xnf4n1pcW1rFoBt6qQyBUz66zNKlRAMbhDDIHF0ATGbpUnBZKVIxJK5I1abLYa3o9igOcnZfMmjTmzrYpFojqRMAY+Q+RP644z1UAiuyhSP4d9L6r9z+W3g43w3WVDNpI1pJ4x5Fh2LZQYFFqro8gt2xn4xxycsc4aA9d8Ttkf6JItsRkWWpMpvYdtnOd3vBgfIjK8br7NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGCuTUQb6Sdc3x5/IS19tllJd6wFw5wi9wCkBphKMQA=;
 b=aSNm/uiN9fWa2yyel0YJXXC2wHA3OPrn/R2YJJcHhoP8EfFW/Uf+LzQR4o+9d6tfxEOmlkH1Rguy31dgke0srhF0XKqnspkQ1+dYXblf3PkovQeGdeehl1/++rmOgFuLjhQD1eutbkaDQ+8kTWwPRxHYjbpoPpHXy6zj3IOQGuuw+ZbBVCu83Sk/lDlggJYJciYgpX3soxOT3uhF0MmzaDU4pDp9KAmx8MhKEN/vAvpP0wE4W1/anie7QU4omqF3C7MR1/CA4uL7kqa9qzwHpRunn1poXmFgyIemk6ZQklWvbwdTO3wLDyEmtiFsSHNvlNRRHhfHdgt4eOQCi8h2aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from BN9PR11MB5321.namprd11.prod.outlook.com (2603:10b6:408:136::8)
 by MN2PR11MB4013.namprd11.prod.outlook.com (2603:10b6:208:13e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Tue, 23 Aug
 2022 20:04:04 +0000
Received: from BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::ed13:fff0:803d:3866]) by BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::ed13:fff0:803d:3866%4]) with mapi id 15.20.5546.022; Tue, 23 Aug 2022
 20:04:04 +0000
Message-ID: <c91f0e66-8b36-7a1c-d7a2-4d5bf61bfe1a@windriver.com>
Date:   Tue, 23 Aug 2022 23:03:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: bpf selftest failed in 5.4.210 kernel
Content-Language: en-US
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        RAJESH DASARI <raajeshdasari@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexei.starovoitov@gmail.com,
        john.fastabend@gmail.com
References: <CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com>
 <Yv3M8wqMkLwlaHxa@kroah.com> <Yv3wZLuPEL9B/h83@myrica>
 <Yv9shQ3i49efHG6f@kroah.com>
 <CAPXMrf8VsNMKNLxFjdytk57mk_9ZC0avg1qCGLSMOZNirpdboQ@mail.gmail.com>
 <YwCGoRt6ifOC6mCD@kroah.com>
 <CAPXMrf-Gc-Mv1goZrk59GG96OLPxEUC-FKT6Dwo6TU6D7po=gw@mail.gmail.com>
 <YwR76AVTOsdXNpxh@kroah.com>
 <CAPXMrf-XUHnfQtnCMs6pbpM+2LUBLqE2c1Z-UwsM-mU1KdoOUA@mail.gmail.com>
 <YwUdyiK16jz1W5Aa@myrica>
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
In-Reply-To: <YwUdyiK16jz1W5Aa@myrica>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR08CA0198.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::28) To BN9PR11MB5321.namprd11.prod.outlook.com
 (2603:10b6:408:136::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f691729-3f64-49ac-2f57-08da8542a102
X-MS-TrafficTypeDiagnostic: MN2PR11MB4013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9YoqLgPrDqGpsKaAFMhxSBl4Jfl4Miw4fRUKSJRgdzx4Xl62AWztlIPhZXfpPij1AkeGxurVagrXZpgda9HoW6CTP7Au76qD7xyKX5ImwwYKp58XaEHc1p/m+IquIZ+XuE/365MHeQneh/ZDkNPsjAnN/OGcAAseMYvvRrFGkdpYbW0k8kgaz0+ItIvEdS7Elq9hWzxxapR3JlagcjiCmUOCL4azv9oDIHCbCTjZ8qAFch5dvchCwhU1RJGhtyVXca1tNI+yPo6semUUvJZ3+nfZa2sb2czCM+vjanUK4OlL+OEJGUGDn6Wb4FWd7GgmfcvmESA0W8+CvSX+YO6PEXmX4Afah1BYfCpMU1eTYGFYPYM4A8llFXMbk/tzrF8FGSDD2G5YLvYnPED1+8hfJrMpD0d8DidxuBx2Ln3yQtV7PvSwY+hUfSgFGkTl1AjqYyXPhM2ygxHsuGTo8SZXS+hTWcGNz14t5p8aPfwz6kr/XqpMpiGZKb8tEgopO+bdwEVQpfMXOdnO74ZyznoX+6imteKzS4qhzSDzlltMUVyTOb+/5XdEQ4ToI1ISqhMoVsMByG7mNF+3VccVU3IB+0+tv55znsO7JLcYDXtND/kd/cn/nFEywTPoj+KdIIEYNnqAdNYoZ3NJUl1BN5VN6i6w8jBxhEC4uFOkmQDrn14u5+h44S4OULDeIbLD0umcLb3LfNptDnpqtdRfe3cMUnp1uYutuincz9LIyylup8SkDEM8yU1tEHAGv9/YqI/1VkTGZ7wVY15hWWS3qI+ac2xoJjT39a5Zl4p3+bclnpB9wTtkAEFoYCkRgt/a1Jci
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5321.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(376002)(346002)(39850400004)(31696002)(316002)(110136005)(4326008)(8676002)(38100700002)(66946007)(66476007)(86362001)(66556008)(186003)(41300700001)(53546011)(6506007)(6512007)(6666004)(2616005)(966005)(478600001)(6486002)(8936002)(2906002)(44832011)(5660300002)(36756003)(31686004)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3luUDRaV1N2a1Y1eWttU0Z0SEwza0d6S0hLbjlQWEVhUDgyMmxGTnY4WTh6?=
 =?utf-8?B?ZDhaaFNZaVZWZVZCdk9qKzh4M2lIVVJOYWNUeGZtQXRRZFBJYjh3K2RMeGly?=
 =?utf-8?B?WHFmczFYT3VubUhUVGZpaHB4cGpmWXZVS1o3ZjBzR1E1Wm5kQkFybzgrbEta?=
 =?utf-8?B?QWlVL3dsOXI3REpiSGxyOWc0MEN0WExrV01BaXBPNk8vdkhxamF4V2hvTlVT?=
 =?utf-8?B?VU94RTJvVS9kcHF6OFdhdFc2TnVNQVZhbjlnbGZIWGtySXI4bEpab3hNR2VF?=
 =?utf-8?B?SUM2U2g5V1QvMVlPc2dhMndlNXVmOTRZcTNYQWpicFFPbjIyTkZ3QldQSnRC?=
 =?utf-8?B?VFpaTHkrTlkzWVRpZklQNlp4Nk5SKzNweHhuWlVjS3UrWjNlZ0hhMGNRM0VU?=
 =?utf-8?B?bU0ydUpYU3JFRlhONkI2S0ZQOHhHLzJMRFZEZWcxSHV1dHhIcUdLYVVHL0k0?=
 =?utf-8?B?UGxxc29ZWTh3NWlnRzVxcitVZFlzaVFCQnNkME9JalFsTXcxVkIzcGFKM0gw?=
 =?utf-8?B?Q3JacUkwRTZ5VEtuZHJaSDd0Kzk5SkxXZ3BpVGlybC9tWm9ERTE0M0NaSUtj?=
 =?utf-8?B?S3lLS0pheU5YWVNLTm9MbVdsUHBuWHgzYVZ5RzV1MEppVUJZWk1TT3VsSHh6?=
 =?utf-8?B?YWdSa0pLYjYyTlVYQ0kxVDZ1cmQ0TU9nanRaWEZEV2xzRVFJemxtcXZuYlVL?=
 =?utf-8?B?NWxkV1FZK3hVdkdsMU9HT3pQUmptbUhVT2lHVmRuQUFhcCtCZGdoSFlHeS9r?=
 =?utf-8?B?bzU0Y3daNndPQUxnOVN3d1dnNzJ3cldvR0hydHlWL0Fqa3JaMVBObG1sb1Vh?=
 =?utf-8?B?OFU2Z0g1ZDJhTkVnOVFUaytSc2grWTM0ZVF3b3BiTGhESytkc1pxUlBUTWNm?=
 =?utf-8?B?WE5YTnJGcjRnZWxweDY3MGdidTRoUDhHemFHM1N6U3ZkNnQ4S3lGUUR5Sjhr?=
 =?utf-8?B?c21uM1NFbmxneG5MUUh6eWVOdjdGUzRUVGdnQkxLWHBRSUxNOSt6QjlFZXNQ?=
 =?utf-8?B?R04xVVN0SDBUeHp6MnNXbjZGcUVYajNWOUtkS3FYclVHa2pwSUIyMXdFcllO?=
 =?utf-8?B?SWZxaUw1SzF3MC9PemZyWlprVVpWUTZGVkx1M2dJWFE2WlFwaHBodjd1NEtj?=
 =?utf-8?B?ZzBiMHdCN0ZNcmVPWUxOM0UrM2ljaWdxd0U3ckNqOTlocTRraTZhQllRUlp5?=
 =?utf-8?B?aHdoTG9lSHJIQitvbkI3UWtVZHBGQ2s0aStZNlA0cDNMMU1ZUVBWdTFxL2NU?=
 =?utf-8?B?eXpKam9RQ1BzZExvUzc1TklHMEZEVXNaczRaMnNhbTZmdXc2Q2ZyUkU4aGFZ?=
 =?utf-8?B?M3gwMy9Xd0xHNDVONHpvR2JlUEd1OWRwOTF4cTdrdFcyMkpLMkpvVWlua1J5?=
 =?utf-8?B?MXpCTmxBZkZneWU4bkpXN3hZK2pWeHRFNC9jcHRvVDlFbEhQVzArdng4ZTBo?=
 =?utf-8?B?cktDUXpvQ2pNTUpiQThWcWdWVVorV2VmVEUwVFZpYmhLQVRSY0g4ZzlQUXZu?=
 =?utf-8?B?OXBHZm5weWhmQU4xbUtZaTNZSk14SEorNDkwNzJBRkpOS1p6Y3BnOCtTek5B?=
 =?utf-8?B?YmRBOTI0THczUlRpSnBuK2hrREdIQ3lXLzBodHAzVGo5QlVkcTdmKzF4UVRh?=
 =?utf-8?B?ZlNCdVhEb1EyT0podmo1MGhNajE5d0twZi9LRVN6VTd3ZkJmNUFSQlF0YnNr?=
 =?utf-8?B?RGhMVzh5MDZnN3hYaUZKMDFscDdueUF6YzVhNWNORUpvUms3Njd6cUNyVWlS?=
 =?utf-8?B?KzdFb2t2NUxQaVVWT2tzQjJqYUZXOU9kYnJxeEZtTmExQUpuQWhFMHJiWllX?=
 =?utf-8?B?YnBzK1FvVG55MDdsalRSMkg5Zit1bDFncFhyOVRIK3VTOVNsWFVabWxXZy90?=
 =?utf-8?B?K2tqNnltaU91V0FVeWE4ek16QWV3WmhpdjRucnZQTzRxYUNEb1cwQnZ4d3NB?=
 =?utf-8?B?ZVpGaG1KTFRlM0lidW0xTnJUTjhSY1ZKWktYMzFoMEZMNFQzTld5clBsOUF5?=
 =?utf-8?B?K0FKd3F4MnJ5cll6Rjh0aDBFVWtnN1UybkVCNS9MQmxBVkxjUGVpQ0ZsSlA1?=
 =?utf-8?B?U2VEK3RWYTN6NnlMbmlKbkhNQzJUd0oxWWR3Q2xWeStZTjRGRWxTWUhHQzhW?=
 =?utf-8?B?ZWdVQWgwUFI4OEYrRXFMVTVpd2NkcFpOT2hkQ0hwSGVSWXBPNklvRlpnMHB0?=
 =?utf-8?B?NVNEeGkzQWpUNFk4YjRERWg0d1dTMTljUlVIQjR5RUI3bkhHNldUNWsyajF4?=
 =?utf-8?B?NGRlN2ZHTWRGK1VYN1lsSVZ6SmNBPT0=?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f691729-3f64-49ac-2f57-08da8542a102
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5321.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 20:04:04.4144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jyN+FM3f0ewC2Y1n/egf1vZK+dk23bx4uA0MO+XEwtJ9AaSJ4X48SeNDh1JBpUVfX/XvN+gnk2s9sZScQVzw9cTUX0CMWnA8lGxvc8I6eao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4013
X-Proofpoint-GUID: qwRrisqAJRB3mspxEMVen0UAXL1NCLI6
X-Proofpoint-ORIG-GUID: qwRrisqAJRB3mspxEMVen0UAXL1NCLI6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230075
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jean-Philippe,

On 8/23/22 21:34, Jean-Philippe Brucker wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> On Tue, Aug 23, 2022 at 10:31:40AM +0300, RAJESH DASARI wrote:
>> Sorry for the confusion, results are indeed confusing to me .
>> If I try with git bisect I get
>>
>> git bisect bad
>> 9d6f67365d9cdb389fbdac2bb5b00e59e345930e is the first bad commit
> For me bisecting points to:
>
> (A)     7c1134c7da99 ("bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()")
>
> This changes the BPF verifier output and (as expected) breaks the
> test_align selftest. That's why in the same series [1] another patch fixed
> test_align. In v5.4.y, that patch is:
>
> (B)     6a9b3f0f3bad ("selftests/bpf: Fix test_align verifier log patterns")
>
> Unfortunately commit (B) addresses multiple verifier changes, not solely
> (A). My guess is those changes were in series [1] and haven't been
> backported to v5.4. So multiple solutions:
>
> * Partially revert (B), only keeping the changes needed by (A)
> * Revert (A) and (B)
> * Add the missing commits that (B) also addresses
>
> I don't know which, I suppose it depends on the intent behind backporting
> (A). Ovidiu?

The intent behind backporting 7c1134c7da99 ("bpf: Verifer, 
adjust_scalar_min_max_vals to always call update_reg_bounds()") was to 
fix CVE-2021-4159.

If we revert test 11 changes brought in by 6a9b3f0f3bad ("selftests/bpf: 
Fix test_align verifier log patterns") backport, all test_align 
testcases pass on my side:

diff --git a/tools/testing/selftests/bpf/test_align.c 
b/tools/testing/selftests/bpf/test_align.c
index c9c9bdce9d6d..4726e3eca9b2 100644
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -580,18 +580,18 @@ static struct bpf_align_test tests[] = {
                         /* Adding 14 makes R6 be (4n+2) */
                         {11, 
"R6_w=inv(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c))"},
                         /* Subtracting from packet pointer overflows 
ubounds */
-                       {13, 
"R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 
0x7c)"},
+                       {13, 
"R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 
0x7c))"},
                         /* New unknown value in R7 is (4n), >= 76 */
                         {15, 
"R7_w=inv(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc))"},
                         /* Adding it to packet pointer gives nice 
bounds again */
-                       {16, 
"R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 
0xfffffffc)"},
+                       {16, 
"R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 
0x7fc))"},
                         /* At the time the word size load is performed 
from R5,
                          * its total fixed offset is NET_IP_ALIGN + 
reg->off (0)
                          * which is 2.  Then the variable offset is 
(4n+2), so
                          * the total offset is 4-byte aligned and meets the
                          * load's requirements.
                          */
-                       {20, 
"R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 
0xfffffffc)"},
+                       {20, 
"R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc))"},
                 },
         },
  };

root@intel-x86-64:~/bpf# ./test_align
Test   0: mov ... PASS
Test   1: shift ... PASS
Test   2: addsub ... PASS
Test   3: mul ... PASS
Test   4: unknown shift ... PASS
Test   5: unknown mul ... PASS
Test   6: packet const offset ... PASS
Test   7: packet variable offset ... PASS
Test   8: packet variable offset 2 ... PASS
Test   9: dubious pointer arithmetic ... PASS
Test  10: variable subtraction ... PASS
Test  11: pointer variable subtraction ... PASS
Results: 12 pass 0 fail

> In any case 6098562ed9df ("selftests/bpf: Fix "dubious pointer arithmetic"
> test") can be reverted, I can send that once we figure out the rest.

In my testing, with [1] and [2] applied, but without [3], the following 
test_align selftest would still fail:

Test   9: dubious pointer arithmetic ... Failed to find match 9: 
R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 
0x7fffffff7ffffffc)


[1] 7c1134c7da99 ("bpf: Verifer, adjust_scalar_min_max_vals to always 
call update_reg_bounds()")

[2] 6a9b3f0f3bad ("selftests/bpf: Fix test_align verifier log patterns")

[3] 6098562ed9df ("selftests/bpf: Fix "dubious pointer arithmetic" test")

> Thanks,
> Jean
>
> [1] https://lore.kernel.org/bpf/158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower/
>
>> If I  try to test myself with multiple test scenarios(I have mentioned
>> in  the previous mails) for the bad commits , I see that bad commits
>> are
>> bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()
>> selftests/bpf: Fix test_align verifier log patterns
>> selftests/bpf: Fix "dubious pointer arithmetic" test
>>
>> Thanks,
>> Rajesh Dasari.
>>
>> On Tue, Aug 23, 2022 at 10:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Mon, Aug 22, 2022 at 10:23:02PM +0300, RAJESH DASARI wrote:
>>>> Hi,
>>>>
>>>> Please find the test scenarios which I have tried.
>>>>
>>>> Test 1:
>>>>
>>>> Running system Kernel version (tag/commit) :  v5.4.210
>>>> Kernel source code checkout : v5.4.210
>>>> test_align test case execution status : Failure
>>>>
>>>> Test 2:
>>>>
>>>> Running system Kernel version (tag/commit) : v5.4.210
>>>> Kernel source code checkout : v5.4.209
>>>> test_align test case execution status : Failure
>>>>
>>>> Test 3:
>>>>
>>>> Running system Kernel version (tag/commit) : v5.4.209
>>>> Kernel source code checkout : v5.4.209
>>>> test_align test case execution status : Success
>>>>
>>>> Test 4:
>>>>
>>>> Running system Kernel version (tag/commit) : ACPI: APEI: Better fix to
>>>> avoid spamming the console with old error logs ( Kernel compiled at
>>>> this commit  and system is booted with this change)
>>>> Kernel source code checkout : v5.4.210 but reverted selftests/bpf: Fix
>>>> test_align verifier log patterns and selftests/bpf: Fix "dubious
>>>> pointer arithmetic" test. If I revert only the Fix "dubious pointer
>>>> arithmetic" test, the testcase still fails.
>>>> test_align test case execution status : Success
>>>>
>>>> Test 5:
>>>>
>>>> Running system Kernel version (tag/commit) :  v5.4.210 but reverted
>>>> commit (bpf: Verifer, adjust_scalar_min_max_vals to always call
>>>> update_reg_bounds() )
>>>> Kernel source code checkout : v5.4.210 but reverted selftests/bpf: Fix
>>>> test_align verifier log patterns and selftests/bpf: Fix "dubious
>>>> pointer arithmetic" test.
>>>> test_align test case execution status : Success
>>>>
>>>> Test 6 :
>>>>
>>>> Running system Kernel version (tag/commit) : bpf: Test_verifier, #70
>>>> error message updates for 32-bit right shift( Kernel compiled at this
>>>> commit  and system is booted with this change)
>>>> Kernel source code checkout : v5.4.209 or v5.4.210
>>>> test_align test case execution status : Failure
>>> I'm sorry, but I don't know what to do with this report at all.
>>>
>>> Is there some failure somewhere?  If you use 'git bisect' do you find
>>> the offending commit?
>>>
>>> confused,
>>>
>>> greg k-h
