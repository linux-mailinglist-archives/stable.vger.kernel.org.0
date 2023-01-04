Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744A165DBDC
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 19:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbjADSHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 13:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240110AbjADSGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 13:06:32 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC9213DC4;
        Wed,  4 Jan 2023 10:06:17 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304FHAZh014724;
        Wed, 4 Jan 2023 18:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=OBGVQV66QeX2ByCHO7eXEmp2FLO4btaTrzBTS+20734=;
 b=IkRryT3bvqZbKNRGnPKZUWhK/hcD2X7qhzu4b1mIGhV03Byukmg2/wRXUe+oaHkazOCW
 x+hFCF/KQtRI4PlHqait9UhsNBHi0AGjOjtjny6DSRehxit5VuQGQ1ttSBGxhRaCa1qQ
 NbHmjtyAIoPFVSEUQvDCkhZjoQdwweV8PPprYo0+K9413G5d+jcg5WFs+duivZBUBG7G
 dYagfMfm171LaOKJlb6HUGZ8ZwJIqkBpBCbRaYisGhfKsE7JXdeW6Sko2Uj7Xs65H+6y
 eiuVbGKTCA4I+BusJpVGqoGbMMPVGmq/PJDNiCL8sScOOj5iRj84scSvCNlxQGZ8nz5p RQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3mtaa2jm3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 18:06:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WsJ/dxo5YDlBNQ49e+tEpr8uxqexBvU6SD0WTx8UsUsrY5Oja/Y2sUzxUnMKQooWlZQS57Y/6AsCbjRqGX8TCj6j/K1rkP6FTJsPZSRlyuSBKUTsU3NJ6JCJilgt3Ov8BxNqtScLMI8JzAFArj+5N4oELydc3eHx/wdOhxnZGJ/dc/Z8KFllLXFtXKIf/A+Lspb8dprv+N2CaP/6xab/EIvXaRWNSd2l7j0d878U9jVacr9PgFylXemVkv37kzjLRV14pWb/5cr36xBfixpGYr18ZVRLencd+St1kPaK9t8aJCb0qzGBh61HHprU+5LqFZFNnlw7V4JhO9CWq94eoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OBGVQV66QeX2ByCHO7eXEmp2FLO4btaTrzBTS+20734=;
 b=PNMVVhXirfpjMWiUHy6kXfRx4YXpJ4hEQ1aHvfW/oiROikhDT9Mp0jZLlSWYagXWv63HoQynu8SIiAUBphamlHYag4mAVmw2xU2qg725/5XiWOL7WRBBHMcp7x67c6VNulY8lPN2ygKiD//W1meDxl/fwCvFn4P8JS6gJenMbrhwZ083JLdYcjoR7iNqT++Qmfs6UWg+Hlz7mhtY+wSG2aZ//YxaFaGrCJ3jnVVj37hG9YRzejVTrnS/PyPKJ/ZxHNtz+6JtZLhgD0URSbCwiZ5g1FF0ivK1eduNZpYoDeA1j2rJOWSHDDsZIQVgYgzNVqug8JPVxBp6qS7gMuQuBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by PH7PR11MB7477.namprd11.prod.outlook.com (2603:10b6:510:279::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 18:06:03 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::52f4:f398:b983:2380]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::52f4:f398:b983:2380%7]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 18:06:03 +0000
Message-ID: <7c0cb998-d714-235e-8c2b-efe0315eed7f@windriver.com>
Date:   Wed, 4 Jan 2023 20:05:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.19 1/1] drm/amdkfd: Check for null pointer after calling
 kmemdup
To:     Greg KH <gregkh@linuxfoundation.org>,
        Alex Deucher <alexdeucher@gmail.com>
Cc:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        David Zhou <David1.Zhou@amd.com>,
        amd-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>
References: <20230103184308.511448-1-dragos.panait@windriver.com>
 <20230103184308.511448-2-dragos.panait@windriver.com>
 <Y7Vz8mm0X+1h844b@kroah.com> <a8c6859f-5876-08cf-5949-ecf88e6bb528@amd.com>
 <CADnq5_Ons+yMyGxcSaFaOb5uNXooHgH_4N=ThHOGYaW9Pb_Q8A@mail.gmail.com>
 <Y7WRq7MaFaIJ2uGF@kroah.com>
Content-Language: en-US
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
In-Reply-To: <Y7WRq7MaFaIJ2uGF@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P189CA0032.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::45) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|PH7PR11MB7477:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cf7c81a-4e75-4bd6-2d1f-08daee7e57ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SMauo8UJbk14nRp1acGPtoP7FSjUhYqcF0Vc9yF6Wg6vcsI84PMDLov9solZLaXyWbM4YXA9OPE3fT+9qTmDKbElPWe8NKQyMyKosBiOFZGnJAUKmd45fDxx6mgMSHUJKAAdGvrYYQNx9/Q0Xs4JZQirrEJ20nPgYxVmWfJJyLVCJtRHqCu9MhdtwGE9V9OIyhtSNcFQfhsAbaWbXbbVHM/sg/ZVEpprIvA1r89CLTIVgfgtmWhfsP/brO9kdMcrTFddfY45tr1nFo9k9DqRhHgE4bJuw5mxwDIM5ss5XdZoFAaKHYxoAQAkV7NNN5EQua1P+y0SnXGAh/b7ffdLhK+2OApjlBJoL9NOYSIkWMgoDXEDYRvNSs2hdDYs11pJYlWSG4JlNNY4Rf5Jq5z8Hi0g97NLzgqjfsHZkXtu2xRGpBOUm0xHsFGmxu9m+IV6Hhgwbz2MHf3WJJUghGKzEjl5VPUsfbDTvlBaArR01UB6OmyyzNcEICuWmQIvTOEsD2qHztBdnT9rbiqxT+pa2fm2R8btam3dgtoI4pDejsVtAOR3K8C05IoJcxPj1117rFp6/+HqUudTazG8Nz6KLiGkN0Di2VwLp/U3pmMtgnerzF/Np5qRipYwtFfGfoPLrd9DLu0JoWVYxF3vJDp/ynbaDB3nKn8GFyewILriZP2G19JFF0ohf555EvyFcVAJcm9+pssnqUeyTFRSIf2oq4tujfru9jRbqtbmCZfHAQ5QZNr+GZQeHFycwl2b1+uJOIkl0hAzOiN3ZkknTa51P5yYSmfUn9OjSWwP9k7IC6M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(396003)(366004)(346002)(376002)(136003)(451199015)(7416002)(41300700001)(66476007)(5660300002)(66556008)(8676002)(31686004)(2906002)(54906003)(8936002)(4326008)(110136005)(66946007)(6506007)(6666004)(478600001)(966005)(6486002)(53546011)(26005)(6512007)(186003)(31696002)(86362001)(83380400001)(2616005)(66574015)(36756003)(38100700002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWxicW10bW40V1dvejM0SFR0VkJWN2E1dVR0SS92ZFlOMEhsUWptVk92TE9j?=
 =?utf-8?B?RFh4OWU0eXFpT3VzNXVZYXh2ejJ2UEFITlZNWThLUDdvOStGUjVNU0NpMEVo?=
 =?utf-8?B?TkNJWGxTK2RkQW9KUmtYWUpFREJOYlVWRGl1dW9zTFBGa2d5SkRqemhwTDFZ?=
 =?utf-8?B?Ym13Y3c4Qm5admhBZnZUMWZGWGpTTGlQb1FNNm1LdmJyb0ltZE03TWQxTVgy?=
 =?utf-8?B?SUhQMGxpR1hsQWVDR2lDTVhDR2JXWVdFdXFPd3htWGtXbW9laGFMNTJqR3Bk?=
 =?utf-8?B?U0xGNXNwSWphYWIxQk1jNEZYemxVV3hoRSs2TlF0U29MSE1VMTlucW03bGla?=
 =?utf-8?B?VjV3d3N6ZTFGTTVsQVo2SDU5U3o4L0FvWEZEUGNKd2lwL011RlJVcTRFUE9l?=
 =?utf-8?B?WDdCVFZiWGl6YzNTanNiVnZsYjRCSU9aMHNrdnRiSlFXTFdKdlRzYWZHU0Vz?=
 =?utf-8?B?UUNtWTVvbzVqYkV0d25YRnkvWDc4cDRuUlJTWklIblFoQ01HRkFqdFhZbXd0?=
 =?utf-8?B?RnNLZHNpc3F5OTRIdUpuK3Zlb25hSXFLRzFjYmNLYWxQa2dROVVoQXJXL3Zv?=
 =?utf-8?B?aHdmL2NiMEszdGN0YzNVSE5YR3BvbjFmT0VFbkVzaGNWNi83K1lRNDdXVnNY?=
 =?utf-8?B?NXJ3WHgrL2J0c3RDOGVQWGFwQlV6MGJybStSOHYrOE9VWlUvaThGVGp4MkZW?=
 =?utf-8?B?L1hVMWFWZ3RQSTRvNU02QU8zSUNEb0Jyd09zZ1owbC9UTFg5SEFvUk43emxi?=
 =?utf-8?B?UitqeGlOL0NYQXdLbnJQeHlLcDU5U1IxdmduWTQzMTZ3M3llSkh0UFZFelQr?=
 =?utf-8?B?RFZMdnJDWlJhcnNMbG92b1ViT011MkQzNXBybzBiR3hzYnFKZ001dGtTWjVK?=
 =?utf-8?B?MWMwMFJVQ2s0eGpxbmFEVWlNOThRZUFOOWp0dDlyUzA3TE9TQjZOcFlncW16?=
 =?utf-8?B?cUR0TkI1eGhMR2NKV0Q0NmJyRTRUS1pMTDBleDc4VTV1WjRYeElTUlA4Z05E?=
 =?utf-8?B?R1piS0pYSWRnc010b2hTdzdObFBtSFVleGIrR1dNUjNKRDEvM09pTVZGb2NL?=
 =?utf-8?B?VGs3dUFNdjVBYnhZTko3UkttNFB1ZlJQZHdlL1FkSnYxTmpqb3RjWVdYMFpJ?=
 =?utf-8?B?czZ2U1piMzgxbVdQdlEwRFdDOVhJUmpJRENBMkpPaTF2Yk10ZytUM2RFTStN?=
 =?utf-8?B?SUpMckx5VnNTZUpyUWYxR3dzZk1kcUtYTm9CelVpcjhOK3lidlBKYjl4UWV0?=
 =?utf-8?B?TDViYVJRRStGbXV4RGI2RHhYaVZyTEtPSkpqbDRlcVNGNUVCNWYzeW85d3Na?=
 =?utf-8?B?Z21hK2sxRUJxWEE0b0ZHWXdWMmNQNTJvdk9BOVRHZzYxTno5cno1U1ZMUXds?=
 =?utf-8?B?UE1IcnFUb1V2aU00NHl5VjhkakJpM3NUYUZFZDl5aS90N3NhendGdUJTbUEy?=
 =?utf-8?B?eUFwV0VjODVWZXYzdDhtMS9lblFPM1VBM3BHTm16azUxVFcwbUsvbzluYW9h?=
 =?utf-8?B?RXlUek85TnlxeW01eW1VOUZsa09xMUlYUGczam5NLzRRVWh6RS9DWHhFdFIy?=
 =?utf-8?B?ZjMxZVVSNHRJa3lzWjU1ZFd3RW9VRWZlVUxSdEFyL3N5eFpTQXpTVGt4NG1J?=
 =?utf-8?B?MUhWU2VNR3FmbkJiMnRoL2RobmU2RmNoWmlBT3RadGEraTBTQ2tpYldXMHZG?=
 =?utf-8?B?d3VVSG0xTW1PZjNHdEhic08rUjNVbmdFSk9iNUl2NGVSNzNJU09Xb1EweUVn?=
 =?utf-8?B?RHdvR1VyT0F1K2FtYXNWcnF6WmVXemRmNFF1QWpUcERZTGtsVS9Ja0o0elNj?=
 =?utf-8?B?Ny8xckxmR3VXdlI3eUxPNjE0QXhrUjE1MWFNZXM1ZGJnNExQSEhOTWRRRFhP?=
 =?utf-8?B?V0wvVWJrWTVmV2Y2VzBlaTZFWWQ5dmlpNHo1THgyTXIwcXUwUDJQSnBZd2c3?=
 =?utf-8?B?THJybW1Cek5pOEpHVlZKZjJsV2ZrbU5YQzlvNmY1UmVTRzBkWUJTajZmdUk3?=
 =?utf-8?B?RmkvU2xQSVBYcVlXRTA5bU1KVHRqZGdSQ1JqY2JCYWxqcEpyajVpZEN3aEM2?=
 =?utf-8?B?Q3Q3c2RnUjFVOGI1azI1bXp4VDBOckZta1AvZndmM0NBMmZ6TXlBVUxNZ3pY?=
 =?utf-8?B?Nzk0VXM2eE5HZzFiUTAybElveTBINjVlYWZTYzVCem1HZm1kQzNPOGxBVm5w?=
 =?utf-8?B?WlE9PQ==?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf7c81a-4e75-4bd6-2d1f-08daee7e57ba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 18:06:03.5204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vjNzt4GW1expE9fpskY6QH25cJ9Piu8wi/Y0Pgnd98DPl0am6QQev9viGV+CUie0oXYpowvlVpSCUPVb511eG8J8XQcggZxFy2cFiOwo1vY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7477
X-Proofpoint-ORIG-GUID: 4hU8fyfVpb8SEhv92vbbXa3PrEa5WwTJ
X-Proofpoint-GUID: 4hU8fyfVpb8SEhv92vbbXa3PrEa5WwTJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301040150
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04.01.2023 16:48, Greg KH wrote:
> On Wed, Jan 04, 2023 at 09:35:03AM -0500, Alex Deucher wrote:
>> On Wed, Jan 4, 2023 at 8:23 AM Christian König <christian.koenig@amd.com> wrote:
>>> Am 04.01.23 um 13:41 schrieb Greg KH:
>>>> On Tue, Jan 03, 2023 at 08:43:08PM +0200, Dragos-Marian Panait wrote:
>>>>> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>>>>>
>>>>> [ Upstream commit abfaf0eee97925905e742aa3b0b72e04a918fa9e ]
>>>>>
>>>>> As the possible failure of the allocation, kmemdup() may return NULL
>>>>> pointer.
>>>>> Therefore, it should be better to check the 'props2' in order to prevent
>>>>> the dereference of NULL pointer.
>>>>>
>>>>> Fixes: 3a87177eb141 ("drm/amdkfd: Add topology support for dGPUs")
>>>>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>>>>> Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
>>>>> Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
>>>>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>>>> Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
>>>>> ---
>>>>>    drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 3 +++
>>>>>    1 file changed, 3 insertions(+)
>>>> For obvious reasons, I can't take a patch for 4.19.y and not newer
>>>> kernel releases, right?
>>>>
>>>> Please provide backports for all kernels if you really need to see this
>>>> merged.  And note, it's not a real bug at all, and given that a CVE was
>>>> allocated for it that makes me want to even more reject it to show the
>>>> whole folly of that mess.
>>> Well as far as I can see this is nonsense to back port.
>>>
>>> The code in question is only used only once during driver load and then
>>> never again, that exactly this allocation fails while tons of other are
>>> made before and after is extremely unlikely.
>>>
>>> It's nice to have it fixed in newer kernels, but not worth a backport
>>> and certainly not stuff for a CVE.
>> It's already fixed in Linus' tree:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=abfaf0eee97925905e742aa3b0b72e04a918fa9e
> Yes, that's what the above commit shows...
>
> confused,
>
> greg k-h
Just for completeness, I also sent out patches for 5.4 and 5.10 stable 
branches.
5.15 stable branch already has this change: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.15.y&id=5609b7803947eea1711516dd8659c7ed39f5a868

Dragos
