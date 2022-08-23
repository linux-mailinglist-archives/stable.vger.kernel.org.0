Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24D959EBAC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 20:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiHWS7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 14:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiHWS6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 14:58:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BEBAA4EE;
        Tue, 23 Aug 2022 10:28:16 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NHPSlK001959;
        Tue, 23 Aug 2022 17:25:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=B8OtPkQCqW4GY3t+wVQBjSAHRne1GVNAweZ0iiNNC/8=;
 b=mbubZknl2ssYg4XU11ocuX20xGHkVaTEstrwAHgfMR+gN5j7Tfv7BcJ0cZHNMHU81+d+
 8zgptuvc5gM/HM3OZ0EH/P68K3RvKnwAoEjWnoGxx14bptH5fJayv+0avqjihfrULCFq
 yUUjatLnInNI5+dAvbtPZNanRD/1wajLzwjkuhQ9l24PPvA0JKw3f6Ic64YVo0Et1YzT
 HIfB0Xono8TlhbHIczPWnBEKMf5VndFrhuc7mVBJD7LL35Y/uQOvSYRl3wkMlYe0ym5o
 llEn17G6dX1XbghSyNRdNGQ11VGXqejOXnDHLI9OdKUCYwCRvQajvUpJRkF+tYqKPXSP dA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4e8c2ywd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 17:25:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27NFvEF5036971;
        Tue, 23 Aug 2022 17:25:33 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mkhmggm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 17:25:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8VzvGzrXBqnHSk9LwMB0BcS+2Mifzqn7P8Nv/HeHNsAk2xIfj6LvgO1iUCdJCQXeEVMKB5BSAtYnU8TgFkgww6MXSSq7ibJC8Q3Sz9AJk/60VzwOPY4C/NKxW0KvLYF7i8wzaS4iFNB6yeo9y3sL/EGn2lHcy9XGW24S61jjjN8lp7l4xIlXco1ZRG+H0L34xYbYWw910HFBAnmAhlmCkD3jaojJt/5hbZBfizL/8veQZdyCBWdDDDW06rLEoZCFFLFW5mGHoJHjSHg/4Z0LP4yOQJP6isXWTHteU9r4OCZ57mWcGrhMwvIy8GygKzlAvh/GywGt5hCmeavDheVVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8OtPkQCqW4GY3t+wVQBjSAHRne1GVNAweZ0iiNNC/8=;
 b=HsowwjH7kdEvPiqkOgF3p/dBxp0LZVbZB6Lw2OrN9qsMKP2GM1n+jbCS6ErYaBHVsUR53G+RqwRoYL/kdVRGfG3VIsVX752MVU+OBtIpiu4YFoQUyLUc3ZDBVFUUd+qCcn0yMCkRyPhWpiisdnluWX8izhjqCwu2IGq5LX1pHHMVTT1j7SbacgPD9JtKGaaMbEshPAxqQG6zyosJsMqnaoJbxnAeBRTG56b4JMTydQb4FTnuo6qeZaGjzzKn1d4LEad0DoFQrOa35TwtKbruUC36u6ai16Yb/9cwvjigJDo31JlR9iOmJxD1gD3/lNawVFHqfxlkcm5nrPlNyK4Lpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8OtPkQCqW4GY3t+wVQBjSAHRne1GVNAweZ0iiNNC/8=;
 b=fsotHGHoeV3fsx+MXwIwelOOpWhlaJfN/GnSoOFXZ8JhKw/WDgiKaZltnzZuSmmiptXOnYX8VTV3xC3xrmHA0WZ8S+pzlxskvZflDdRItyM/DjwZe7XzjCI2h++IEcMOioqyr97gt9NApv+YBRnYBrETj+L+Q6u9WeTTuE8Iy/Q=
Received: from BN7PR10MB2659.namprd10.prod.outlook.com (2603:10b6:406:c5::18)
 by MN0PR10MB5936.namprd10.prod.outlook.com (2603:10b6:208:3cc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Tue, 23 Aug
 2022 17:25:31 +0000
Received: from BN7PR10MB2659.namprd10.prod.outlook.com
 ([fe80::e0f6:5b20:2ab3:fcce]) by BN7PR10MB2659.namprd10.prod.outlook.com
 ([fe80::e0f6:5b20:2ab3:fcce%4]) with mapi id 15.20.5546.019; Tue, 23 Aug 2022
 17:25:31 +0000
Subject: Re: [PATCH 5.19 319/365] swiotlb: panic if nslabs is too small
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Yu Zhao <yuzhao@google.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux.dev
References: <20220823080118.128342613@linuxfoundation.org>
 <20220823080131.532813281@linuxfoundation.org>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <c49d3b2b-9f5a-4257-9085-f7ac107cff40@oracle.com>
Date:   Tue, 23 Aug 2022 10:25:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20220823080131.532813281@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0050.namprd07.prod.outlook.com
 (2603:10b6:a03:60::27) To BN7PR10MB2659.namprd10.prod.outlook.com
 (2603:10b6:406:c5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c63b7082-fc8f-4912-1c3d-08da852c7a90
X-MS-TrafficTypeDiagnostic: MN0PR10MB5936:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tAcwmWHFevHCwQdOemD7vC+MzwX3gHMvATrkOtD761GUPW2o9xbgUQ5ivzrmesNDXA4CGlnJBjlvfryXBgdpoBDnC6dWB0VmwlFdIuFy7dXKELBFmWHyYVUNJ818hXQNgC3T+jNXAIo3LKdGcOU6vhd+496SNCOfN6Q1icmSGbv6559yR64s+UEGELWsgF6MqtpTN6rh27Jlzb5Xt/BBjKco4evcgqjdCEByxv3P9J9S35GoPEHvGh4lgagH0bRRfYy9RXgPx3NgX5eqoows9Rk0P4XylzTR2I+v5suMThalH+ijP9wYqQHujHHVLP7voqRVf6DcMoFZIJH7m9I7bf+122jiAJYRiK9fbkp7d9wZYqVjvWOcJKYpWlZEJHbFOIkRQi6DBAlTo5XzeQvC7nfPYMYLmPOyQ5QL4aSuCggTucNAPqvfuDG/Nkw6dl17zo5R7N+v8gxK1Np3kV4yl687TVu87W+JNrzvB1KFF9HN/cYPYoxpAVsGsaDw4Jk9RlUF9/eqMXn+tf/G57uz0334ULgGaMWYtl6KxozLDEMorByqAucgyaTzfNSqRST2Vp6vuJbTurfb/oTDUnKiEVvb8hiTToSFdDb/Am2Qdv0C21wTpdDus1mjwXj6zqrGVzhuhekNkKc8AVaxL/jKqjq9Ex2MJOx/nK7uH8vqXQtfpvMiO7Fws+duGeJUs93Z4pH1Rl3WuHxPDLU/n1d1se7KgGGBd3nV30EVeFacNSBFmeZPkwpkbd/VjzJnggWi2xo8v8ZUMQPELxKnZU4mYnoODMr7I4MM0GqjzDXMhrhrzTioW7nhOsJBSiL9SBBNd0jgXgreiMGJ7epeZWquUM1tZFnQb0u+r18ZWhPOWg18b4h0SnKggxfg3Aohhkeg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR10MB2659.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(366004)(136003)(396003)(346002)(36756003)(31696002)(66476007)(6666004)(41300700001)(66946007)(44832011)(4326008)(66556008)(8676002)(6486002)(316002)(478600001)(53546011)(6506007)(110136005)(966005)(31686004)(6512007)(2616005)(2906002)(38100700002)(186003)(86362001)(83380400001)(5660300002)(8936002)(160913001)(15963001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEJncXFPR08zbTg0Y1p1cjdNbXFBbFB2WlRMaTlCTjJPcDlSK2JIYTVLQVU0?=
 =?utf-8?B?UStNVkdiTnNwaVpVK2RYR0NmQThMRmlxMzQ1bGNsWGdLc2YrVlVTbUNxdnB5?=
 =?utf-8?B?ZWVZeDlJL0dqLzRUSzJGc2FVbDhIQ0tVS0FVNGVqQVM1RVRNUW1SM0gvYnht?=
 =?utf-8?B?UzlUMGt4TTMrUVpyRkw4TVFKOWhvS0lWSnVMazV2WStEaDNaRDlmUnpJbU9h?=
 =?utf-8?B?SG9XSjlPOWJZSDh3clU3VkRzcFlQK1NBVUt2UEVLYkxKcjM0SlBCSEdJcFVG?=
 =?utf-8?B?RDZtdkh1YndsSXVqckV3Z3JCMi92UmE1czE1MGdsd29rdWNjZ3BWQnIvNlhL?=
 =?utf-8?B?TE85QTQ2bFMwOURvb3VxRFZwYzNKZFpyMEJDM2dRS014cXpuZWF5S2JTd1Bs?=
 =?utf-8?B?azRIMjRVQkhibGVsNEI0S0lFbkpUVkRtYjV6L1dMQTVqN1pSQ29sSkg3eS93?=
 =?utf-8?B?YVlMMHIxbXVQWStZczdGdFJjQm1XM3ZaanhtZ1cvYUNoL1BqS1hSRWt6VG13?=
 =?utf-8?B?cjFNMzM0b0xzdnFXVzJ0N3ZISGZIay9nUk9FeXRQZzhaSGQ5QXFadUZnTnFF?=
 =?utf-8?B?V0pwN2R6cFIzV3crWGxnZGpFcjlMMnBXZmlNMXJkc1dVY1RyRUc4UWtvbnl0?=
 =?utf-8?B?UnlVcUlRVk0xVWxzQU4rNWVzaDZaUHJ5ckNBcUxCZDRPanBTYjErbThYVERi?=
 =?utf-8?B?VUV4cElTNnU2M3gvY041dVY2WVFlUXQ1eDlTV3NUcWpGUFB1WXZET1VHMWZq?=
 =?utf-8?B?QjZZVzhuQnhnOUlqM1NIKzZFS1FkSEtwaEZZVW1ldU1aMnFCK1VEaWJJZ09l?=
 =?utf-8?B?dHhWdENxYXptVy9IOUkxVHBtS3R4aG9WTmhUSmZvM1FMZlYvRjBQL01vRlZG?=
 =?utf-8?B?SVBtS0psWjNWKzg0Si8xc2tpanc3bVdtOHgzbGlRRDhBaGVqOVZTT0ZRY1hP?=
 =?utf-8?B?dUhDK2VCRXRBMkNBZlhMcUF5SjdFdkEzbFFDNDY2bjAzTlphOVZVK2I0SEF4?=
 =?utf-8?B?SUJhelRvUGxYdWZHbWpTdVFnem1ncW9jYmlZS043cFpmc1lENit4bWNvTjlX?=
 =?utf-8?B?Nzl5bzd0NVRUVWY5ZXovTzQxWG54ZFBZVWY2N1JOMEJHWlI5dzVYaGlYODBa?=
 =?utf-8?B?VmlQZ2k4YVJWbFhVYmVDRDVFc2ptMlhvOTQ1MlBNMGluckdSVWlCNkJydmlG?=
 =?utf-8?B?dEl5dy9zakJ5UmpuVzBzWHJHK0lyNlY1QnhOOS9jRjhsVEJxKy9hRzBsenc1?=
 =?utf-8?B?d2ZZZmhhRnYxWTc4OXBhbm5TdmJIMGpJZXhzblo1T2NiaXYvSmVJaEV4Q3VF?=
 =?utf-8?B?UTgvNWlYK2ZicHMxMy9sWXNuZkZsODBDYUFYam53UnRhMVMrQVJGcWRoN1pz?=
 =?utf-8?B?Q1cvZ0FzWDJXbXNUSzhMRzFjSzd4Rzdwa1ZNWGoweFNTbkszRm9XaFhnaXpG?=
 =?utf-8?B?d3BUSTl5eDFRcWFHcnpyaFJYb0tFQys3UnZBc3A2Zld1ejEzc20wbDJlNjVM?=
 =?utf-8?B?b1R3WlQ3YnZnblFnUU1XYTBlZmF4SVAyeXdUSlVrVHdwSUVqVjd3c0pxVzVw?=
 =?utf-8?B?QnA5M2ZMY014OEwwWDVNdGhWVk5aOWxpVjRPeEk5RWg4TUhWRXFCSDVKbW5q?=
 =?utf-8?B?NCt5MG9OQWVkOHo2TlhQWG8zMXRaR1h5RzZaS0tJZDJ5Q0gzM2R3TDF5cEgy?=
 =?utf-8?B?VmllVGJuTHNoL2ovS2VQYmttSU01MWRQck9kSmZIcHRhRGZpd28wSWlGanQ1?=
 =?utf-8?B?U2V1emNtYlByeHE5U04wRGR0a3E5Y0xta3cwaEhxZVRDNHQxUU44MDJ2Vyts?=
 =?utf-8?B?Zmx6N0F0QjBXU3hMaS9BVHBjNmVTZlVjMkkxUkdQd0l6eTZ6ZCtneXhHTGRk?=
 =?utf-8?B?TnNhb3ZaL2gyY3p5ZFljWWlmZzZzdVJQUTBkNFEwZEZiWkpLS2c2NHZGVktE?=
 =?utf-8?B?WWhOR3FXRjd2VHh1WkszMDY0ZksrWGRQc3Y3REZLMEUyYlMwclVMeitLS0g2?=
 =?utf-8?B?M0NCUExWUXQ4R211eTc2YndYZ3czQ1hlcldLZzcyL29GWC9aa0M1WG9XMWZl?=
 =?utf-8?B?MnpWa3FFdnJURXh2YTQ3UU1KcURicWMydTNNZVFzS2FlTFNQbllYaGxTdjFk?=
 =?utf-8?B?RVp4UE1leFByWVdQK0VvK2dtRm9ON1RseEFOaTFjT1VTRCtXYW5ORTdEdTl6?=
 =?utf-8?Q?dGu5blzqftnDt1AsJb8cZKE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c63b7082-fc8f-4912-1c3d-08da852c7a90
X-MS-Exchange-CrossTenant-AuthSource: BN7PR10MB2659.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 17:25:31.0010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hj2ComiIX7t+WMuPJDzp6B6l2bfm1cadY7cqeeMPqUrHSA3xWb0B1UwwkJgyWFW9na7+dR0+uMHFFD3OKOfAHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5936
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230069
X-Proofpoint-GUID: BkWyTMQmlpbAeNyTie5UEK-HlxKR38qV
X-Proofpoint-ORIG-GUID: BkWyTMQmlpbAeNyTie5UEK-HlxKR38qV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Adding Robin, Yu and swiotlb list.

Hi Greg,

There is an on-going discussion whether to revert this patch, because it breaks
a corner case in MIPS when many kernel CONFIGs are not enabled (related to PCI
and device). As a result, MIPS pre-allocates only PAGE_SIZE buffer as swiotlb.

https://lore.kernel.org/all/20220820012031.1285979-1-yuzhao@google.com/

However, the core idea of the patch is to panic on purpose if the swiotlb is
configured with <1MB memory, in order to sync with the remap failure handler in
swiotlb_init_remap().

Therefore, I am waiting for suggestion from Christoph whether (1) to revert this
patch, or (2) enforce the restriction to disallow <1MB allocation.

Thank you very much!

Dongli Zhang

On 8/23/22 1:03 AM, Greg Kroah-Hartman wrote:
> From: Dongli Zhang <dongli.zhang@oracle.com>
> 
> [ Upstream commit 0bf28fc40d89b1a3e00d1b79473bad4e9ca20ad1 ]
> 
> Panic on purpose if nslabs is too small, in order to sync with the remap
> retry logic.
> 
> In addition, print the number of bytes for tlb alloc failure.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/dma/swiotlb.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 5830dce6081b..f5304e2f6a35 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -242,6 +242,9 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
>  	if (swiotlb_force_disable)
>  		return;
>  
> +	if (nslabs < IO_TLB_MIN_SLABS)
> +		panic("%s: nslabs = %lu too small\n", __func__, nslabs);
> +
>  	/*
>  	 * By default allocate the bounce buffer memory from low memory, but
>  	 * allow to pick a location everywhere for hypervisors with guest
> @@ -254,7 +257,8 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
>  	else
>  		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
>  	if (!tlb) {
> -		pr_warn("%s: failed to allocate tlb structure\n", __func__);
> +		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n",
> +			__func__, bytes);
>  		return;
>  	}
>  
> 
