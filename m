Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347E5637B59
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 15:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiKXOVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 09:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKXOUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 09:20:54 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69EF238
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 06:20:52 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AOBUDhl021623;
        Thu, 24 Nov 2022 14:20:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VpZdg7gVWvxo9MgIXYgzCBkZg+7TB5KGENC4rXTzRiE=;
 b=qecoenrC3Dl32NOg8kYcqlMj5U4BaHW0fcAlzNsuoErCkZB5oY+NcpYaUWxk6SUDxFWQ
 aJ9AF2nZw+CWmY39Ma7GV5L06MsUDlB6nSieNaYGUhXcpGb0cJti3/hG9vz9iygWGPiU
 mRpq/JOmvcV9BZ/sngp+TxWohbS0iUpUBm73+1ngsqGKdfnSX0Q7ku6+q2Mxaz2Al+xv
 L/TcX+axZl0ghx0/TIrCxp9vmnwkZXRuscw57h89b0YlhgR4SPDhVKGkC3OjL7HvE2yt
 3/3//amBUrG29lH7p5eVbu18WzrnefQPJnpcDoD4hguYtdWofI3bK5SRJ1QxJcLf15AN dw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1nd8axxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 14:20:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AODl5JI001346;
        Thu, 24 Nov 2022 14:20:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnke2b1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 14:20:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/c+dOU/kB0zUdtuFlEBgHIAl6p1HZf9fFpVJjFlSTGgLfsH1yw9pxS4E2gZiQ2llQrRsMuyotwLhP87crkrtBQfD9vZuW2NBql3DvC0AwSoizdyAKv6y2wqEiGnZgmgvGDtzAm2QThhTqvXhDP7lVgpD80YItyj6Air7nLVG5esXiR5JuXXPus1q0GgyTjVB2rG91xTvVlx+1IE7ztSaTttgeMnB6SqfaXFvP0CRFa85J8WDNl+ahosJgEUwgPylzrAvjXiwZEwsoPri6zNoGyzhC4ZUQZiQqV7gkczG6VYzDIvCEG2CG/3tiFDxeBD8mdg3fHYUO2jm9dZvdTuNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VpZdg7gVWvxo9MgIXYgzCBkZg+7TB5KGENC4rXTzRiE=;
 b=adst+I3vyZ5iG7Kaj8jzUNbmk8ONM0t5YrJ2WGi7ycuLwPGCIk5dcpmRuqBG8K4noXBQQOuk6+te5N+57W3L3IqWrD931RTR0onu3Iks/+BnuFwNhYGl7+6XxIM3dh6ai+2M144WMGxv4tHXc4BJCNuiCqg+Zxwmh7YoBjE7TihcT339O3MQbDyF1/oIw66INsLwZKFfzyJecIkRtVZCBCMvLcNfEcNrSGszRgdMG//MBWBMPBXB7CoNJw9kuuD4ffd9ZXTJaXTkEKfvG8iTkR8K3GhXRD3KwyQ7HrF0U8Wecd4mKGc/0sjXo5aJpwmSMrb0vUBRQ40TVHSnueuwIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpZdg7gVWvxo9MgIXYgzCBkZg+7TB5KGENC4rXTzRiE=;
 b=PTwezV2g6Khv8arwhalBSlY1ChyasoJgmpBYcUgc4jBJ1xJctg+pHAEKGWwklxDfVPQWS4cfVACxNN0lORvBydmk8a25QXsghVBvSpjXVwnm9vxoeB4g3dcqJ+tWq7na2YTMCrUFJmUlVK1jafDZxV45/oYWjY/0ijTOxrNILbQ=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by BN0PR10MB4935.namprd10.prod.outlook.com (2603:10b6:408:128::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 14:20:43 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::1717:5a07:63ca:fdab]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::1717:5a07:63ca:fdab%7]) with mapi id 15.20.5857.019; Thu, 24 Nov 2022
 14:20:43 +0000
Message-ID: <0cc14849-dcfa-d59c-6738-9f4080d32153@oracle.com>
Date:   Thu, 24 Nov 2022 19:50:33 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 1/2] nvme: restrict management ioctls to admin
Content-Language: en-US
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
References: <20221122102245.3397604-1-ovidiu.panait@windriver.com>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20221122102245.3397604-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0129.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::21) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|BN0PR10MB4935:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c64bf47-567f-4eee-14e4-08dace27124f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kbDiMTh0MGduQ1jhaZuWVgl/0QJ7z4Xf3AitfxD/nEMnyXNKNSrm8Xs1/X4fdjV3dkowES7wLClpTP5qp1ZoFiTP5KzYzufOphtgzp4Fp28a+H/g7IMk9ZFXJ2TSv909xcIENyQK8GQnL8cKuPF84lew/Y9ipOKM71bY7wf7wYLuhdvHPpX+hylFsE9T79ch8uWCnru9DAZACyjMaTUQbu7lhPkz/qEFsyykce8YcAVz14I8PGbGvhddPT58CfABprhf7nmRRYeqq1F5aCFhJbT7EHCBtpf75OQB4ta+IZlPYnv91uZp+SHlfMv6rx/jUQO2ltHknthy4pVRlkRHbZ2pDUNXnzDJkvJJzX1c6J2w576g/rd7F1wKHYnpJMMWlO30n3RZqRz22dn3rUpl/58e7lz92Q7W/Kymk11rdCUgoNiIQIGvy24let8AIzBghWenE+rWNveY6XYKvVYMkijcTKb/c8sDlKDONY6xeTE9JIYGev1qICmBQll/j3VbRDSI3ZksYH0Fqedo8dhFz4eUsw5QxNL/Y5HF8QofHVDrf54Zhp9/1IQ1/hPYfj79FoRlQxVpilp/5Ukh+yOmow+FlknLUlaaBHYeLSjK7oZbP5O5HKNAaIPMrZvW8dhbFpibar4rOxQS0YKi6g9+7YdR+KYTjPESy6lUVhEY89I+SmdDNdcxXNexZ1whwNTFBG3mLtopbRwlnX1TEpUV/4n/VmH/gBxtAL466WN+nRc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199015)(5660300002)(2906002)(31686004)(83380400001)(66946007)(36756003)(66476007)(8676002)(66556008)(4326008)(54906003)(86362001)(31696002)(6916009)(316002)(8936002)(41300700001)(6486002)(478600001)(6506007)(26005)(6666004)(53546011)(6512007)(2616005)(186003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tm1MWTROeFB2NTdPU0tMMkUva3hNUU9Kd0dKdkZzbWxocGJXV3dFWXdlcFps?=
 =?utf-8?B?Vk9ZQVNyNWZFcVJEbmcwUTBUQ1cxSlJQMUdjL3FhK3IvUWYwVXh5ZEk2YTFp?=
 =?utf-8?B?T1NOcXplNjVWK0E5dm03LzJ1MmRNNFVHcmN2UGJBK2paOG0yUExtVzlRT3o2?=
 =?utf-8?B?OXdidGhNODl2WWwwcTdxWk52L0t2YlJEaXJrclorWFF2emZBdXRidTl1ekJa?=
 =?utf-8?B?cFVHcmt6aUdUd2NFczRIaW9QOGo4a2plRE9RYjlaVlE0RlFxM3ZLaDU3ejBB?=
 =?utf-8?B?QlR2Mk9jb1dxQk9tQ00vNStTeXZLemdZS2dVazJYd1pRbEVQK3pBNUYrTnVh?=
 =?utf-8?B?QUlyZVB6ZUNCTEh0RjdXR1RmaHVEVHlsdVNERXRPMVAwK2lPemlaUEpqWDhR?=
 =?utf-8?B?b1F6TGMzT3MzZDBtcjFtd2x0UFRRWVNwTjhSYlNsN3RQWENzYldDL3lzTDRT?=
 =?utf-8?B?SEhpOE5kZjhkYWRKVHJ1U2QvRUZTRk5GVk5LY2lieFdPb3N0bGJwUzZNZWdl?=
 =?utf-8?B?bEl2czlyRFpkSHVHZktna2lPeWFwWGJvVzFJcGtRSlR4QnIwQkdyM0c2UEZm?=
 =?utf-8?B?NW5hbzBJdmJZbVlLNytvRXkyNE9PTytIM0xwcjRZSDByc3l5NVY1bkFMZ2FB?=
 =?utf-8?B?N3VYS0JwREkrL1phMW9xMUZ1VW05ZCtsRUl3cGlCTktVWHVSTzQvazFDc0Zo?=
 =?utf-8?B?b1lXUXpUYUkzM0d0Rmk0WUdpL21JNlhsUFV0THpHUXR3dU1wWkxzakFtMlYx?=
 =?utf-8?B?eExkRTBnSlhoUVNVUVRrVGNFeWdjRERldTZHZGNiWk5ZUERJRGlGekMybXFv?=
 =?utf-8?B?UWhZdDYvOTd6U3o5TUJKRWFxTUplZnVOMktlVjd0SzdZK2VJT0dKYmRZVTFH?=
 =?utf-8?B?RkdOdUJGbHRaK2FyMWdycUhCVllSdCt3UGlvMG5TUHkxcXFFZjdDVGgxaFd6?=
 =?utf-8?B?SmtTM2lTQTZzbzdOVHQ0MlE5eHNrNHg5SFU0V1RzSTNPWVhyYVZTTTZLVFg3?=
 =?utf-8?B?WWY2YlFhZEk2Nm53QlhBZkdsQVg3dWZpVG9ocGJQcElvT2hCSlRCWVRBTlNT?=
 =?utf-8?B?M0ZPOTJEbVE2SzI0Mk1kVFcya2ZxNkYzRWFkaElZeXAyaWJrZlVrNy8xNGVR?=
 =?utf-8?B?Q2kzMSs1YkxyazY2SUFSVG1qUGwwaktXVUNYVmpSakQ0QXdsblZVVURVMFN5?=
 =?utf-8?B?QUVWNWVlVHV5ZXQwUjRmYm5uTDhsOTg5Tml0Vi95ZFJRNTFFNkluQ1crNHdu?=
 =?utf-8?B?dXRQdzRMR3kxSVVnUE93T3Z6blNRZ1QvN0crOGU5U0d3dzY1WFlIbDZlbk1K?=
 =?utf-8?B?TFlEUWE0WFl3bFl1OWZ0MjFwV05OVVVRenBGaXJiSitTQlMyR2lxbzJpYWJ6?=
 =?utf-8?B?ZjhoN2pjNWZRWG1ja200Zmc4SHF6SnMycTBxQnAyWkR6UFVHcmlhMHRvMytm?=
 =?utf-8?B?L3IrS284ZFF1MWIwZGgyWWwvOHpYbnZRNkJNNEtEUXFKd1ZHNEpwVWpFaWYw?=
 =?utf-8?B?R1NOVXZOSm5PaytsZExXQklmSjNaQk9GM3Qza0t0TGR6dWZmaUJqQUF1VU5P?=
 =?utf-8?B?UmJCb3VzcmFMRGNMMEUwcWx0MHdid2w2M3BKaTNSQnRaNlFQZFFYSEEwclFK?=
 =?utf-8?B?TGhFeUJQeGxqenh2YkkrM2FtOGxKS1d5aVhjWE1BcndYZ0xZOUZDMmFiT1Jo?=
 =?utf-8?B?RkVUYy9GVkRCV3ZLcGsrNWpRcWJJVVA1d1JVUFRJc2h1VllUYVkrS2pSaUht?=
 =?utf-8?B?THpsNGFJK2RDU3ZIZjlOL283SHJSUmw0WkRCK2xodnpKN2xLQS8zNFlBVFhx?=
 =?utf-8?B?MGdJK0FFaHNnT3ZOVjRaaFpvR3NXclgyU3FzM08yVURPVEZVT2RaSmJzeldF?=
 =?utf-8?B?b0h0ZExQakNCMUl3bEJ5NEJZMTg3MTV4QXlGcHRwZVhLMWZiWmVRQjFsanFJ?=
 =?utf-8?B?R252alJkNEVwQTJpZmFDamMzdU5PSnEvcXJtSXF1UWliZlMrYkliSUhCZVQv?=
 =?utf-8?B?eWR4ZXNUSHFWdUhVS3cxK21lNjlsK3FiQkJyL1krc0t3S1lnRXRxTkZhWlhs?=
 =?utf-8?B?Qml4ZXB5OUxBNVN2RGhvU1FxQ1N4MTBjRi9Zd2tIa2ZNanE5OFJGMURVUGRT?=
 =?utf-8?B?NTFNdzgrQ045U0FHMUFaL0dqZUMxSHM0OXhnSUlmZTNvSzRZMnhhMmdoY3JP?=
 =?utf-8?Q?eOquz54bGtG+rtUNRwgRQfc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mcu4Xmm/zHbC7ddHcDKdkpiYH9ciJKvAX7dVd8n8ZLSzYb5nog70QefhhI7PpvDKQUxGRfAUblHAU6QM8+Xnw5W6mEeRKcBSenDTQJllopIEHcUXn9r8R3CH4p/SNMZFu3FAZwUXiDfNA73KKjyff68S43Ho9rzbzgyFZi/BCPv4wo/RjRr7lFkyI6tSpA8rO5o7kABF/YGdNx6nrTQDJjQccAWfkaT9j1/idrEMwPOGE/uD3U73jILWZ/Rf3Hsjh6tWLDwn5RCweHEQpUwTVoigmAq2mRls/h0t7Z694oYJSazV+zIFDLS9LHL1wLkdHfzmcbXRdzE1IByr2zA/do20j6hyBwdKP4GVe2m41octBChsui+o7KFIAvG6redPptN50FItjSXcHFaIqcQId41MppKMxNlk1hFHaXHK/cTafPUMMU10nLOp2ZwPmf6B8tC18XrkCqddRZuqBhHTrQ++wCvfk15Lza7vcfkYoL0BDrX+KzlkwGoFTdKYtX/pFUIMdCxoMYx0WtDxulYWBg50+uNyVWOyQnUFGJn9d5ypPtZua8BMtZlyiXUfuk+cs7+/2JYcxEoTazwZiUWYYsC6npCTbHKq0sP9LZHjTIKJUdWXgwizih6+k1b97KntpOVpIMST4tgSTnnOdscHCyEj64N/aZIrk7LKlzp9XfCgCrErMeHe6D1tc6qz3WaOK2NIKtKgTT4hww1SrZNXNTsGqICRnCtyZP2D2ISPrs9XVQGDCQ7AoWuc1gxoZARv5ieaVCh7H8DxLgMj0+iHEuj3JM+0JTW0Z9Gqv4vwvTiuctf/Gr2LTgj1/sJdfZOTXu8y7/IC/O/Ct0QdBMpDPsCRrw+SgLARgbOuYK5ZCYs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c64bf47-567f-4eee-14e4-08dace27124f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 14:20:43.4908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tn8cs0x5KQhTWdx3wQk2w8AGRayTDA5asDBky5yL9BQQEA2ago+E8ocItGuvgDbV/2+Qn/JAkXpJIvPxPrqUcwqataKuSLmVM+EToejxZ9TOwIDXbX0uC8eVXGfBQe3s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4935
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_11,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240108
X-Proofpoint-GUID: 7c7FwqHTODHtGw6eKkWCVINu09roAF5S
X-Proofpoint-ORIG-GUID: 7c7FwqHTODHtGw6eKkWCVINu09roAF5S
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Ovidiu,

On 22/11/22 3:52 pm, Ovidiu Panait wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> commit 23e085b2dead13b51fe86d27069895b740f749c0 upstream.
> 
> The passthrough commands already have this restriction, but the other
> operations do not. Require the same capabilities for all users as all of
> these operations, which include resets and rescans, can be disruptive.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
> These backports are for CVE-2022-3169.
> 
>   drivers/nvme/host/core.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 3f106771d15b..d9c78fe85cb3 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -3330,11 +3330,17 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
>   	case NVME_IOCTL_IO_CMD:
>   		return nvme_dev_user_cmd(ctrl, argp);
>   	case NVME_IOCTL_RESET:
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EACCES;
>   		dev_warn(ctrl->device, "resetting controller\n");
>   		return nvme_reset_ctrl_sync(ctrl);
>   	case NVME_IOCTL_SUBSYS_RESET:
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EACCES;
>   		return nvme_reset_subsystem(ctrl);
>   	case NVME_IOCTL_RESCAN:
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EACCES;
>   		nvme_queue_scan(ctrl);
>   		return 0;
>   	default:

Should we apply this patch(1/2) to other stable releases as well, i.e. 
5.4, 4.19, 4.14 ?

This first patch applies cleanly there as well(5.4,4.19,4.14).

Thanks,
Harshit
