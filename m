Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B70B592053
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiHNPIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiHNPIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:08:38 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9521A074
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 08:08:37 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27EF2vRP027270;
        Sun, 14 Aug 2022 08:08:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=daKp/ea9xrvCxF0fVz/yZFvFxl+hGshr6nzBapctghE=;
 b=AXIjS9t0zkaqLAgQH38em5VrxPyLDlZ6YkvS3ZPWpAVeoaTaWzxM0G0X6QGNS16Wm0GX
 53JiNZI+aGyy/0VnGRB+AeCIw2U+B5akt8sv5nCCFKeZGzo2vN0yp+o0OeXgASyR5Gqo
 3Jj7i30+tqZt/EGSDuVzDYvRb6GwgGYHcpDezVcr7JdVwPvc7lFXl63aPlJ271rxLbWY
 gylIETbGNjO2Upg3DcPngQkC0B0q3noUaSrMfzjyNrEvFP1Dcn5iEBKq/WVH2S0YPOZz
 Uo40mDfdcCaCDPA+wWc3kFfGcTbCvHsIn493g5UJc2hMQDdRiNygOvUKBU+x6cudwJkq dg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hxbfjgput-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Aug 2022 08:08:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCnHoP7Mpvwqu2DrZYPgnyz8ohv2TmegMvV+5jZDv01lyzOy+ZRkUy9ImaAz52CIdgMPatOl4rbZPaaXGKu1fk61txuL1r+IVkNU0tRElwRCBYNAX5AR4CKaeRTWifsNtwUruScuuf4/Hh7bPUTGMvC4Qx1Jp/zPQ7+Ukbpyrx2F3fO3yNpay82HJMMBUF2AxN04P6IIoP63x3QrCp6rzTvlp14sR1D470INFIFj/ARhlM2uMnbL0Garcyq2b02tY/CBBF/dPKKR9QcIhFu05iS0rHTL/SlUBd6MhMgcB1SNTiA6WqF5jtFI4IePLQkMRYOeZ8EaDsw23WOFcKAIsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daKp/ea9xrvCxF0fVz/yZFvFxl+hGshr6nzBapctghE=;
 b=QpA6fx44LZ10mklobNi+tGe3MlUnKtp4Uqg9fcnQ2qDCw9YIbzRL6hU9Q7VfFGd92FdOm/BbG45sStG9sUxEIytcnO9VvQSbJNSEUptzca52FSXfu3cNFdxVnuOHlZpTxGoiVo3+O6dZvyK0xPeAeYjXyl6KOzIYu6Cw65m8QeNdbH/rdSjrzr8oOY2KHm+3v9OYCKjhlQx2LowWdJDBN+ypug10Ao3MaTt1amhDxxUY4LieLsCsGPIFcs0rnoMSD8xnVcP8k8vGsqEHnO5xjZVtUEOYdvpN//BGfhkjNtcSuOGGxSk4UNGy81yiRWK9ZT9BJl2FHVl/rpgQjC+28w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.11; Sun, 14 Aug 2022 15:08:32 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5504.027; Sun, 14 Aug 2022
 15:08:32 +0000
Message-ID: <029942ab-365d-0e69-7b5a-3b568518fd02@windriver.com>
Date:   Sun, 14 Aug 2022 18:08:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.19 1/4] selftests/bpf: add selftest part of "bpf: Fix
 the off-by-two error in range markings"
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20220809073947.33804-1-ovidiu.panait@windriver.com>
 <20220809073947.33804-2-ovidiu.panait@windriver.com>
 <Yvei3RLnHqGgb9yp@kroah.com>
 <ae246cb9-989d-9b41-89b3-fcb953add65d@windriver.com>
 <YvkKMEMC11MqZOqu@kroah.com>
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
In-Reply-To: <YvkKMEMC11MqZOqu@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR04CA0043.eurprd04.prod.outlook.com
 (2603:10a6:802:2::14) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cf977b5-f510-48a7-bd7a-08da7e06da72
X-MS-TrafficTypeDiagnostic: DS7PR11MB6038:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pHdo3oOm2s5vvB1yBtrf/gavy5JE/Kh0dz36HjenafOIRcIb69iTOXp/uZfBNJ+nKkpTU+D/jgTo9TIHzcRAFfZ05yUqBGBWYLC0qCMiHL3HgSivHvY7qt7Sb7+3qQoyGw+OtgCx+LJkQnO1mjvN+bZ0ZomzPFKvatymWHmsDZRTmcAMXwHzhAOsHy8gDupwsS8s4r1C7VEunq7LNOqL9xvE1szuckNbmfMAF52IH7X8jrSFblfiZG/L3rk7+nCHHdmy/XT36N/om6KYNvBENAdEnZNahrW0gcAZYpgVo2uDZ6/iLEnMDjjFmxMc4weUfBhG1p62jrf7RKCKIwdGXnZeCfD9XXDjl8R5wI3KFB+7uFGyK4WoX+icP5prxXmn9Rj3beq0L5ziUYSLDcI9f62Iihw2d2Vl0qspJ7LwrJAxylSzPJS5h7w2JRZAFTldSb76aakoeYtVW57BYIfdf9ktVrPngb73jsHsEK2n6C07o2+pQ4F5SIXZ/3UzpdDf5fh09sI321bf+/G0Vk8jOirfJL3o+plXbMr3fBO1IE/QBEWqy/7LgOChGr2hIwL8+MrKEkYZSZmgg0oDjaLteSw2BuGipS+t9A3kod4nXYzCcOQacfV/H9jMM8j4SBMMkFc2k3luacqoQDr6/fmDQXv0lats2eeixbtmSyowE+xpYvuQgQ7TlGP0d38J3CpkrIoB8hvNhkUjHlIFWs+/qqYTZunLDZaXaGU+YXUGFedPcNBUw1MlqOWD6fdlHOtYimZ4WsllygiHC8DRekStWfHdx1U6JTC8l/ve1SE0tT/9Vlg6pCLHGMA+g/dKxAdVcLC6Z2V0USbS1G3dw/tB2jln0uBZs0xrDRLTrxJXmNUcQvVhQNYrHDscDJpPiqa3agIqHtkDOaZ9rkqhLDv+/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39830400003)(366004)(136003)(6512007)(2616005)(6916009)(6666004)(186003)(41300700001)(31686004)(36756003)(2906002)(44832011)(66556008)(8676002)(4326008)(66476007)(66946007)(38100700002)(86362001)(316002)(31696002)(6486002)(83380400001)(53546011)(966005)(478600001)(5660300002)(6506007)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDFsdEMyUXd4eFgyeVB2K1pzMlR1Qi9QMUx3N2tjZVg1MmdoSWpYWGNTSGFm?=
 =?utf-8?B?Njh4eU84c2xjQVBMUUpiN3JNV0JXQ0R2eEx5OXZuNnE2M1YyZjA4SnpKbktk?=
 =?utf-8?B?aXNIczhHdmx5T0o4QzdEeWVDK2pLOTU2NlBycjh0a09Vd2FwN1ZHME9GaXJv?=
 =?utf-8?B?MHdUVUVDaWtQZXFFenFJTVJXWXI3V2dObUs0NGoyN3VhcVJOMVh0N1EybllE?=
 =?utf-8?B?ZERvN1hRd1c5Vnlicmp0QnprOUpIelVuSTRmdFhNV2xlNy9zZGw5RTJGT2Rx?=
 =?utf-8?B?MWNvWk52ZXpNOWVkcTYyTEtvKy94ZjEySUtuQnBPU1FuOXl4NWY1cEU3alZ1?=
 =?utf-8?B?WXBNLzJ0QnRjc2xhLzlPVWU4aTBRTjZ2M2ExUFdiOGJSUHovWFlMR0hhVmMv?=
 =?utf-8?B?WGI4QUlsSGQxVVAxajFxUFhja3plVjAxUUpTZXR5TTBHbVIzdmtWK3pwVmhH?=
 =?utf-8?B?WGY1NGs4TkdldWVtQkYvN1diTUlyMTI2amFPam1sQmE2U3RibEh3cDdTaWdj?=
 =?utf-8?B?V3pUdktING1JVmF2MDlLWVVkQW5qRlNDRmh4SnJkQUgxUXJsYVpmS0RlYlJl?=
 =?utf-8?B?cDhYbEhPbms4eUhMZHNnKzNVeSt0WEZxWlZ2U0U4SndhdFkwWU40TmxSVHFY?=
 =?utf-8?B?UzZUYXZieGp1ZEUyM2NZdVZOdklnUUN2aGlCZE8ycDQxVWpFN2JhNTdKcDBa?=
 =?utf-8?B?ZUNtVWd2TVdCWDlCV3NiYzk3aUxEMExDUTNPZm1zQmROWklzT3pWOEM0Z1dw?=
 =?utf-8?B?c0d5YmEyMTBCa09vL0Nvc3dnanFSWlFXam5qNnQzR3Q4cmxyaDJHMDY2ZjNL?=
 =?utf-8?B?Y25tVXlqcW14eU03dm5Uc0loSlg4N3VrM25Ja3NITlhBQldROENEeS84eFVN?=
 =?utf-8?B?cUgreUtydGJTM0hMeWlYOVlmQ3M2cFMxa2wxVFVyWmlRNEdhejNNb0l4ODNV?=
 =?utf-8?B?Y05jWUhrQ2hkR25QNDRIU051Tk1HTTdoL01LYmVyNWFEOVVZZmtaMnpuMVpD?=
 =?utf-8?B?QytraThtOGgyZXJ0MGVPZ29xQ2psaXBTelZ0OTlXb0ZPL3BJbStaVU8zU2pB?=
 =?utf-8?B?dkJnSFIza1ZmZWxobW5PVXdibTFscnA3TVB0dW1idk5ybElPU2pJRXFubUhZ?=
 =?utf-8?B?SGNhYkRrR2hyRlB3T0N4dkpYZnhsMElDVzNKMGpzdUhQSDJvd2tXZjNEcCtT?=
 =?utf-8?B?N2lCVUFhTG9hQkhINUk5WG9RZ1laTHIvL2dITlNCSE8xQnRoWGRNckZPanpp?=
 =?utf-8?B?VHdZT3F1SlBIaVc4alRoMGpjTlRiYzhxTkxONnk1Lzl6RDdyUUg1SXdqdi9p?=
 =?utf-8?B?c0NHc3UvZlRDZmRjOFZxMVhQdXd1UVpUVGlsaEN6RWlVOE8ydWVUYTdKOFk2?=
 =?utf-8?B?WCtBU3lZYis4T2ZEUXRXZUpOYW1ianV1Q2pXNmlvam90bFNFSzdPcGhkbVJp?=
 =?utf-8?B?Q0pEUmNtLzA3endLdG96SkNiMmI3UzgwQWlkT1NYREdlL2ZpZk9Gd0FMa2hj?=
 =?utf-8?B?SW1KVXNlVXphZkRHVmRWazZCcUVDVTBxTllMSllQQXpqaFJpWnF2WFhjMmRj?=
 =?utf-8?B?eVV2YVBlaktxYnFJbFRRcDBjOTJvMFkxNVJVcVIwVXpyUXh4TDBMWXBwcXgx?=
 =?utf-8?B?WkIrSzVvTnBzTzdUa2JZWnJTS1psT0ZJOEV2cExDc1ByY0Yzck42eVRqb29H?=
 =?utf-8?B?TW52enIwZ2Q2NFp5cnBOYTlHWUR2VGkvenVnb0pVR0UwSHJzeXBvT0QvQlpG?=
 =?utf-8?B?dndEOFBOUUlvbVJuVE8zOUQwQXBUZzBrQmkxTGhWazVUeTZnTGtVUmRiM1Js?=
 =?utf-8?B?cEMxNlhaaVpQa2pKL3NDR0toakRpL3RpYS9RU09DbVUzQnkyVXhwY1UzamJU?=
 =?utf-8?B?OUN0WFV5Z3QrV1U4bjFYZmM0WHhGSnlxaExKQnlJV0lpMXpJbzF2ZzNHQTRR?=
 =?utf-8?B?NGx3UzZYR1RQdTBJSnl4cDVzN1RKUkl3a285Nmx6bXRJbTVEaWMxYlFyWDRl?=
 =?utf-8?B?bVd3WjNpWXIwSUlSOXF1R2EzMFpqVEpLNkpKWlpBUml6anJ2MXRFNC85ajRq?=
 =?utf-8?B?akE5NVlESWtkU2ZWRy80UWdUVFVFUVBVd0pqMURXWGJma0tOd3ZTNUh3TGR4?=
 =?utf-8?B?TzJBK2tneVhyWFBnQldIdFUybktYNitUcldoVjNlSGRpUmZueDFZNzkxdlZZ?=
 =?utf-8?B?MUwwaHV1enk0TEFyaTFiQnVnYnZCeDQvSlltRnNDVzNNYW5pMHNzR0gvaGFV?=
 =?utf-8?B?dGpCbEF0SlgrRWZyQldzSjF5NlZRPT0=?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf977b5-f510-48a7-bd7a-08da7e06da72
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2022 15:08:32.6828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNFvr2aUMzKBUiydJ6NDdLyWCTOIBE+a0ux2xu2L4LrvFVPn/aItGN178lqWVPqbElxiFz3k5ieZR8saHdI+cN0Jf7xBKjvl/iPtFwEE1Tk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6038
X-Proofpoint-GUID: _wTAZfYHHDH6ixCOZTW9_S_dbsXRC9mK
X-Proofpoint-ORIG-GUID: _wTAZfYHHDH6ixCOZTW9_S_dbsXRC9mK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-14_09,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208140067
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 8/14/22 17:44, Greg KH wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> On Sun, Aug 14, 2022 at 04:58:56PM +0300, Ovidiu Panait wrote:
>> Hi Greg,
>>
>> On 8/13/22 16:10, Greg KH wrote:
>>> [Please note: This e-mail is from an EXTERNAL e-mail address]
>>>
>>> On Tue, Aug 09, 2022 at 10:39:44AM +0300, Ovidiu Panait wrote:
>>>> From: Maxim Mikityanskiy <maximmi@nvidia.com>
>>>>
>>>> The 4.19 backport of upstream commit 2fa7d94afc1a ("bpf: Fix the off-by-two
>>>> error in range markings") did not include the selftest changes, so currently
>>>> there are 8 verifier selftests that are failing:
>>>>    # root@intel-x86-64:~# ./test_verifier
>>>>    ...
>>>>    #495/p XDP pkt read, pkt_end > pkt_data', bad access 1 FAIL
>>>>    #498/p XDP pkt read, pkt_data' < pkt_end, bad access 1 FAIL
>>>>    #504/p XDP pkt read, pkt_data' >= pkt_end, bad access 1 FAIL
>>>>    #513/p XDP pkt read, pkt_end <= pkt_data', bad access 1 FAIL
>>>>    #519/p XDP pkt read, pkt_data > pkt_meta', bad access 1 FAIL
>>>>    #522/p XDP pkt read, pkt_meta' < pkt_data, bad access 1 FAIL
>>>>    #528/p XDP pkt read, pkt_meta' >= pkt_data, bad access 1 FAIL
>>>>    #537/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 FAIL
>>>>    Summary: 924 PASSED, 0 SKIPPED, 8 FAILED
>>>>
>>>> Cherry-pick the selftest changes to fix these.
>>> What specific "selftest changes" are you cherry-picking here?  I can't
>>> take this commit without that reference.
>> This patch includes the selftest part of upstream commit:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=2fa7d94afc1a
>>
>>
>> The 4.19 backport of the above commit did not include the selftest updates:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=c315bd962528
> I still do not understand, what commit is this coming from that matches
> it up with what is in Linus's tree?
The changes come from commit 2fa7d94afc1a ("bpf: Fix the off-by-two 
error in range markings") in Linus's tree.

Ovidiu

>
> confused,
>
> greg k-h
