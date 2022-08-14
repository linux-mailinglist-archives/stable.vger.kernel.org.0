Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6174B591FF4
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 15:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiHNN7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 09:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiHNN7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 09:59:12 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39631F633
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 06:59:09 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27EDx61X015263;
        Sun, 14 Aug 2022 13:59:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=cRRL7QQHXiIJ7R526CW4b1uQKblltg59R9lkBkDff0Y=;
 b=YtA15lPtBKneUVgOzXkCwmSK7w4Wnh6c1ryqHw6CY/ZTnZmZ6CQmsW1qRzvN+z/S1ciE
 AmOqOkrWLqRSHMH8vy9vSs/xjTzs0brai9V8QpZjWOshkAy0mmlV8O36drc5iqkpcbCh
 sJ4GWafxMqnyyBEjekJZZUEnD3d384ZpmSjkFk82m0ipfKTrCVqA1acvj9hkfhpFFnPK
 RUafyssN4Gs94aDxFnx4Sg5jB/e9wqOipJRE6xQ4CXSgPhaw/rX3n4kYK+Thn8GPn2Ti
 CRD30Wy2G6orEqDGlz2YhKOaBAxXs0HBWUBLwUs1d03SRl+Aakk0r7zbZDfMKSjzmBb8 wA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hx2x8gx6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Aug 2022 13:59:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PM/ebY1zi9j8x/yPrmq+2ao5Xmxf/irUqDEXPgfFToesKxSD0D0hkEg6rw7xyv0w1J7z9g1tVpC5Vh8s/MRLejZ0k/bREzXwqEgqcptJfOSlhySG9d3DtXSnF9JXpXN7WRIEv+Zm+JV6tbYPpfc62heFntLL8+4f972qbCbtcFDbKnwVjOiauLIBDojrECd9KoCexM8BgqYHOZguuqd46t9NmyBkvf+UXaxtMXUrqjMUzT0spdjL15HkYfrSoo0HLfIMiO+GpPfSIUO9jxma93POygiTh70tV2WreV68jo20Vee6WlkT6D4XOqz3ymRTrNdz97pSW5M9fIGzXPaUsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cRRL7QQHXiIJ7R526CW4b1uQKblltg59R9lkBkDff0Y=;
 b=cmovwkF6BdN3EC/7PhLOrzFwU4nkkc0kkIvJda4xP13HUlk7kNIzOTLfZFXbQiq8ch45l2txfE8Odz1hONiaGEDPohY8hhW6qrjd/F34ZeuWJQu5E9B/nNsRz841IM3UvJljCLXwqkWk+mYVCAgVV0GVIIDrcmyKFMNpgw94ZovWFORTAbHtGcQjzSLP2hPRMpqMHFnDwnO5NFHBtmSsSOmq0hNlX/+tkZ7Hojn+LRvJBOQ3PunuGPj8Yhi4lW/xokZQDADTIvK5miXR4DWORvpDclFfD3nXqrlfy633PXk+rWat3X+btqxDhIq9v9kZfHuDamc1GPlRs/TPN7QJWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SJ0PR11MB5583.namprd11.prod.outlook.com (2603:10b6:a03:3bb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Sun, 14 Aug
 2022 13:59:03 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5504.027; Sun, 14 Aug 2022
 13:59:02 +0000
Message-ID: <ae246cb9-989d-9b41-89b3-fcb953add65d@windriver.com>
Date:   Sun, 14 Aug 2022 16:58:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.19 1/4] selftests/bpf: add selftest part of "bpf: Fix
 the off-by-two error in range markings"
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>
References: <20220809073947.33804-1-ovidiu.panait@windriver.com>
 <20220809073947.33804-2-ovidiu.panait@windriver.com>
 <Yvei3RLnHqGgb9yp@kroah.com>
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
In-Reply-To: <Yvei3RLnHqGgb9yp@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0047.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::8) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7882ab44-498d-440d-ebca-08da7dfd24d8
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5583:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KnvDD7uIuquLeT7yk2WDF5OCGlTkTBwNIf3ImEM33lED5bMPvD+H/X0sL1UPq5xn29fFCcjZNdcgWZuCeZDM4IGnh5kqGsV6TbE08F0y/2C77XQZ22YqrOgvjkvQNiPrCEMKFsZhj1L9b6gFeMhyNMN0diIrr+2OvIDnuTrs9vIU3/3n8l+W2hIqW5CH04P7wHy1WDADwUbX8NftJFdU4xdcMlaufekQcYiN8INEk4/nDkTilBJLl9YHjNm29wVEbmUA1PBkEeObkMQze0bqBTd683neIp1B36Ao9jnKqg5Ls4ufFzEueCxjVkrPF7pFxs+m65fPhniJVNbqfD1em65obiqCPl6dlzzPe36bQ09yde3VTEqniYBaJmNsRQjGLsZdacCS8n/qIyTLLY1s49ooQV/pRDpBolb5/fE+Pf7Fvmjpg56LvWQyiba5cOzoAvHofMcqgxwLOLGVjTPdGeHilbrr9IuguWU5SgLEhIye8LlmBRO7JkP04hew+a/ctyhece3Z+nuXvVBtG7qwZqIa1r879xxPHQgBcizb3rnYoKIxhJPr3LoMhrjoauQMJJeKCW12ylfETxKJcetMDimO0rvyn85iyISuwFuDyCxcye/tgP7nmATlk1kNXyG1lzOesvQKhHscwtWgqndkTj4GKQll1V2VCRHh18Z2n2/4fzBYuabkFh78eTsLNjLvAfYmYEtBMy+Sw7/pMjfrrDQCBQ+cR1rN8CwZzlUBUHY+cqBHjrnaQM8MZtCfiohGJUulknRiE9CTByaYZ4N1X1+J+kq1jaeiTURnnMP3JJGX/0NhL+z7+Zk/W0gILWGTvwvR43FdVKroZ5PZ6QVLarOMiktva4L7+xOk1s43Mikexyj5nCtBdFuk8GxFzY/p3QBHzdhgO4VJ/BcRyFB6AQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(39840400004)(136003)(396003)(86362001)(478600001)(53546011)(2616005)(6512007)(6506007)(6666004)(41300700001)(31696002)(83380400001)(8936002)(186003)(38100700002)(5660300002)(36756003)(2906002)(8676002)(4326008)(66476007)(66556008)(31686004)(6486002)(316002)(44832011)(6916009)(966005)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1BtckUwcHJPMzV3c1Bpa3lLSitFMnRETEtvclJtYzNIaWJrRjNKVGoxbWh3?=
 =?utf-8?B?VGxiaTdYUTJsOWQ2em9wTUFWa3ZxTndMQ2g4aDRXUzFUTXUyMHo0WCtuTUxD?=
 =?utf-8?B?RlJqSDRDNHowRnFtdTIzbEk5OHVLVUlQTW9lRWF2bEkrNWsxNFhMVTdOZ3Y3?=
 =?utf-8?B?MEpnZ0xtblFYMkJSV3VvWGRKOVNla0VjYUx0ZXRianBYdzFFYkRuY3NBZ0dt?=
 =?utf-8?B?SmxIckVOejR5a1I1S1NpNkErMDk5TGhlaVZRbDducnFMK1JqTVFUZnUxODJ0?=
 =?utf-8?B?RlpVdGtHRmUvekZ6U1B1U2R2OXF1a2pIMUF2U3ZWRGxQM3VzbkI4SEUwSlpv?=
 =?utf-8?B?TXZFdm9tUDJhSzFVbUk3NFZlU01GODZicHExUzBoc0UzN3VmeFR0ZGlxQVRH?=
 =?utf-8?B?SkVvN1Y4YVJ1dlNrTlVlYlFNOGJRRUt1SG9BeVdUeklmWEhEdTBwYnpnaW9J?=
 =?utf-8?B?UkdYQ2hJRGlMbnFGSjJOY1VWR2x4UFd3bHNYZGptWWJOaURQTmtGQUQzR29u?=
 =?utf-8?B?YUl3SDErTm8vOU1KaEFqZElhZmFVbDRxbEdiVVM4dTBZdHAxbTZybUZmTzBY?=
 =?utf-8?B?MllUaTRwbnJ1MVFSa0xrMHprRjBHaHF5RVF3T04xT09XUmQxRmVxYnkyaDlE?=
 =?utf-8?B?T204SG51cFUrMjVFSHh0a3pqeGpPZDQrNnhtcUw0dFNqZEVTNC9ZcUZtQWtj?=
 =?utf-8?B?d1FqV2g4UEY2TUE5VTBTbS9Rd1V4QUhjWlVkYjhtU21zYmtTQWdxcytUeklE?=
 =?utf-8?B?bXhxVW52R3ZmZkw5Rlg4ci9xUzVESDNyekNxdk0xWTY5ZWpSc3VKTHIvWkZD?=
 =?utf-8?B?c3Fpa1NYSU1Pejlqd1ZMUnRSTlJiSzFvclNZTkUyVnEzNUhTVkJydVd4bjJr?=
 =?utf-8?B?OEdnUUtLQUdsQ0cyMVJ0My9La3FubmtISE54VFlmUW82a1l2ZFgwVlhTRnAw?=
 =?utf-8?B?eHVRVzkvN1JtcTkrNWR4N3pZYlNCRVYyZHkvNmEwNGVZVitKa3VyY1dyaWZ0?=
 =?utf-8?B?T2JLMWZKbDVkR1RvbUNIRzE1d3Z3aC9Oc29xdW50a3ZJRHZuditTa3FBUzVp?=
 =?utf-8?B?UVNFcVc4cTlvRndQS29PaDhRaGxJK2g0KzJVVThlKyszVTFTaXpBSWNPTzJ6?=
 =?utf-8?B?MlFjN0daNi9FTFRBUzl3R0Nrc3daMVhEUnorbTRMUlVWd3ZYYy9NYkhwbkFD?=
 =?utf-8?B?ZGw0c2NqYWRrTXA2alI0aTVLcDUyZjJvTm1oSE5sdXZpemI2TWhMQnJIbTVD?=
 =?utf-8?B?NGxBV2UzdS85NHdiUCtJU3o2OHVWcHFlcGhxZWdXSG1SVHpRT1JKcTMwRU1P?=
 =?utf-8?B?TGdiOURHdUNvYVpORXdLakljR3RPWDJMYU5SWVZzMzAyMkU5V2RRWndkZFNG?=
 =?utf-8?B?TnJnYVlLeHhZeldDVDkxbDN3clFXVCtReHZBbC9UNi8wa1FLVDhMNm5qVUYw?=
 =?utf-8?B?NEhtY1BtNlVpMy9DdHl4SU1TL1JyYW9tUFIvRnVoV1NCQXpMNUdUTVFSOTZZ?=
 =?utf-8?B?VmNoaFpFQzlKUlZaWFJaTDFBcGxMQTRnOEJ4Z2FPUXNJY3I3bURMNm5GTlM1?=
 =?utf-8?B?RzlPcjA0VGdSYmxxZ21IWUluZGNDeThrclNMWVczcUJnMEpDMVFPR3FWNnpx?=
 =?utf-8?B?NVo2eUVLa3I4OGV3cURlbnA4VHpPVW0rZlJnSHlZb2VXeU9hVm9FRzhsTVND?=
 =?utf-8?B?dk1oUTg4YUZTM0RRM25zK28yRkRnaUlUVXdLQ0JnSlVHQnNZUWkxcEFReWJV?=
 =?utf-8?B?d3Z0cGFKWGJPMlN3VWYxREtpUGJjZk1ZSmxibFlTM3FZRUdKWk9UOE85c09J?=
 =?utf-8?B?RkhoVDhKN1BxSXRnTThEaFMrcFFVeHQyOVdLS2plUDM5RHAzM3pMbnVLRXc5?=
 =?utf-8?B?QUIwTVhocE1rS2thNTFtcFUxUmRPaytLbXJjYnFqQk5WZlRCcjZCeFZCUlBh?=
 =?utf-8?B?S2txbUxqZ0xOcUpUVFRGdjVzMmFYcTBOVnBoUkYwRmEvaWw0Q3BkOEV3TkVI?=
 =?utf-8?B?M3NtY3hVQkRwd2JIMXgyV3oxZ0VwS1BWbXlJVFlYYVBiaUtNYjl4V215bHhU?=
 =?utf-8?B?UlBIWFVxL0R4VVVaS2R5Qnh4QmdnMDZvUUFSOGZGTUt1VnF5KzZkNnVYSGR5?=
 =?utf-8?B?a3NZMWFZODJxMWdzZGJ3dDY0OHhTZ1EyUjVqdFo2NGdLTWxTWkM0d0ZxNWdz?=
 =?utf-8?B?QXpDQ2docDlhT3NmOVFqUTlVT0xLYVVkTzZLNTdNaVp4U0dKbjlQa3pubStQ?=
 =?utf-8?B?WUc2bjI0Qk9FVE42bmc2MXRuWEFnPT0=?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7882ab44-498d-440d-ebca-08da7dfd24d8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2022 13:59:02.7239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lCki25rjYT9RtHEqJ6N1ctkoyc38zYK4/bT53VbV2n+UH9oTnPbAzbvsiqJ1a4pEXLywVADucqmbiTB61XsQ+Py/VGVI4v1Bkp7VIiKsgKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5583
X-Proofpoint-ORIG-GUID: MsGgt_COjkuQhwvpjVUbxJkw1c2nI2Cg
X-Proofpoint-GUID: MsGgt_COjkuQhwvpjVUbxJkw1c2nI2Cg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-14_09,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 malwarescore=0 bulkscore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=941 adultscore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208140062
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 8/13/22 16:10, Greg KH wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> On Tue, Aug 09, 2022 at 10:39:44AM +0300, Ovidiu Panait wrote:
>> From: Maxim Mikityanskiy <maximmi@nvidia.com>
>>
>> The 4.19 backport of upstream commit 2fa7d94afc1a ("bpf: Fix the off-by-two
>> error in range markings") did not include the selftest changes, so currently
>> there are 8 verifier selftests that are failing:
>>   # root@intel-x86-64:~# ./test_verifier
>>   ...
>>   #495/p XDP pkt read, pkt_end > pkt_data', bad access 1 FAIL
>>   #498/p XDP pkt read, pkt_data' < pkt_end, bad access 1 FAIL
>>   #504/p XDP pkt read, pkt_data' >= pkt_end, bad access 1 FAIL
>>   #513/p XDP pkt read, pkt_end <= pkt_data', bad access 1 FAIL
>>   #519/p XDP pkt read, pkt_data > pkt_meta', bad access 1 FAIL
>>   #522/p XDP pkt read, pkt_meta' < pkt_data, bad access 1 FAIL
>>   #528/p XDP pkt read, pkt_meta' >= pkt_data, bad access 1 FAIL
>>   #537/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 FAIL
>>   Summary: 924 PASSED, 0 SKIPPED, 8 FAILED
>>
>> Cherry-pick the selftest changes to fix these.
> What specific "selftest changes" are you cherry-picking here?  I can't
> take this commit without that reference.

This patch includes the selftest part of upstream commit:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=2fa7d94afc1a


The 4.19 backport of the above commit did not include the selftest updates:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=c315bd962528


Ovidiu

> thanks,
>
> greg k-h
