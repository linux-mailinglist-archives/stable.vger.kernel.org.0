Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA053D9C3F
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 05:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbhG2Dhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 23:37:46 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19230 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233775AbhG2Dhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 23:37:37 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3bHOP009545;
        Thu, 29 Jul 2021 03:37:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=m8pZdR/1R0ou17CvkqhbGXIovFiV8iT+8IELAJSObXA=;
 b=LA0hbzJctXOHGVnigyP0lGB+Te571SoJoGkJnJf85bKDvJVz5VQvwZ73yqlvoPSJmpXY
 x8OkpcqRBSNKUWvf1sh3wsd7wrm9fxh466FSvtIk7sxO7Kri9jjL7xRZiGAy4DIeSlNG
 BwBU2Mf3rKVFTQjYPE5jx499b4iOfd3sr9CNNjsCoIdiXQ6HFK7ABCONB6/KYh515oqw
 5Q5xnKUL5vOWNgfH7rCo/m1467KvgXVV8ugIbB3JDMIwD1h2KVOriHK1srkcpXokOciS
 DOU2+E8EQGh3UXJ4RhXM2KWE5gNd5M1eTygoYr5OZWobJwf7M2dTeOtneY8n+olUXONT +A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=m8pZdR/1R0ou17CvkqhbGXIovFiV8iT+8IELAJSObXA=;
 b=Rb/RaGEB8PF2ed67h1cBx4EyC7pgBkm4fVfWRBMQ0w8OZokH8ETVRqhl1WN9jviVxx70
 eAOMbO/Kj+0/JiZjvdPfG4/GWHotToj212CrMvYDbZe5COqGZPEAmdkBc5cKPWOLSwXq
 qh8LT4Z6vJdr3njrdiOZhf8rw15ptNN6a+SR+sVIYTMSR7szbk8QpfTTPg0DHm+FmPxg
 1bd/TZn53M3yYjgt4PyK8e0xxEKnmcZ9efELXlPfdgNV9K5eoHpWJeZ18QqywREcdC/d
 oK3xkS6foYDJiTYFR1WCFCkFM8aIoNS56dqPfebROgjuH51cF5SR+wBPsVkh/N+Uegkn 4g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2jkfcbj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3Tlob040950;
        Thu, 29 Jul 2021 03:37:23 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by aserp3030.oracle.com with ESMTP id 3a234dpce5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dB87Buv+Yf9YSa72FsurJM5kww2H8bZFTEH4d0a1IibPCvicmeLhBO9/ZCvuM38k+yk4jvTK8r8c62YLN08oAlPfix+o6KVCMPgPRu0Pp4GXRuWq3fcpLa3tnlfT2HSgXv387DdcuxIFYdYTchWcmYUP9f7jiZZoLuTKYVeEDu+1vvdjGDNnM9xPgyQWamr1xILexhQx1l7zr18w7rS4OWT099wcwAzYqFipmxowcDiGJQWTpGq+Qt/qr/NGMca8bYUoDoIb2D6man3g7fkhyJIw4StEK9cJNj5VD1anRBaf7Mv/7ZI/Ut9lHGWoiyVCHENn+acpZlQHQEX3SJwOMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8pZdR/1R0ou17CvkqhbGXIovFiV8iT+8IELAJSObXA=;
 b=AFN52paLN12jao43JWnG5lpgyvkC2vZgc2FbTPK3TWLF+8KToj9gj41qmo83RCtC2D2GRKrJU/anSHITT45zrSPPNz/nPjPlz9MFClIFdWrz1gwkZWDO1aXqSZPuVeb+mATbmKkP2Sk3nOpbVsORQMHnFX4y5uYisr904gDgffQDaXaz7jXJq8TvNml3mzgntyuKL7ztXZfXdwHHZfH+qKq4Z2u1nOtkN639kBWicpNUq9fU7rB1gvxsRn4TK60vL8FJkT/pdG79JhoF+IjJKw5eQqpS9Z31OzQymY3apedod+sOWs9kcXcCjRm874D5UbgJROiW5Sn0iXeUD+1AsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8pZdR/1R0ou17CvkqhbGXIovFiV8iT+8IELAJSObXA=;
 b=FN03+Gu0QcDMATu85oCq1hWacZZa2HRTPRP28o9ow+QTpax44gze2q6kvHywHAxY3+2TIzW2Pip1xYQIpTkKOLvj2Pjwd7xugDEVQicjft1tp+8jkPC5M9RXvLbyxqYexBxpZZpRxm3icnC8Pvr9IV2hYF/hW+JBUbK8XuI/Whc=
Authentication-Results: hansenpartnership.com; dkim=none (message not signed)
 header.d=none;hansenpartnership.com; dmarc=none action=none
 header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:37:21 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:37:21 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linuxppc-dev@lists.ozlabs.org, brking@linux.ibm.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] ibmvfc: fix command state accounting and stale response detection
Date:   Wed, 28 Jul 2021 23:37:07 -0400
Message-Id: <162752979292.3014.14406303368375387867.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210716205220.1101150-1-tyreld@linux.ibm.com>
References: <20210716205220.1101150-1-tyreld@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0121.namprd05.prod.outlook.com (2603:10b6:a03:33d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.9 via Frontend Transport; Thu, 29 Jul 2021 03:37:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fd41d7c-8d4d-4c69-7f31-08d952422c3a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB15498033320802AE1D08A00E8EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zASFQZSy30UqXxwzGUgrZ2wNjF28MJBj4juISKYxXydszEJB8ObZToH8fpJRdp6pQRlrQSCgyA6Jq0E6YdsZHnr1MlpnnsGaPsq072QdkI1ILCo/geXmiN4ZoJd1v8u4g6L0aBwN/vklzJhSBeTtXbQvlZ3m2tI0bmTgaeslwfWyjDD/pZdmzEo28f982XV9LpVIELA0vr9rg1c2c61FTysoFYUEMb/uQWRQyUQPxoLCmzeW5Ag1JOSPvmDjuaUz+RrxUdSAU6/4ndE8UbDeAxRPzVahiISFcUR6dc66sCu1npBapZoyQxWReTU9GQGzb/a7Oghc19rjJq3M46eRfoBPKLsrZG7f3vEgjRZQkSdxmnNnGxJieURu8ip6YJw9TyAgz3AFtFng0jU+tRWntA94Fbs+TVS65Rab/uxUdafzupSlqZ0qPI5nA8ZvZ8bKtg6QMXNmDgTqWhlVxBbVgPhasEjDrZjROZ/+lk5/3rkFCKRwtKWwcFoJlwZWDlv3djjz3JDYsb2xGJ0E97iKfIDY1TPzDIOca1afnGtNaND0k690SWB1nte5dkRlHAiuu86Wdgp97/SNk82XE8IGLZGg97provWn9QPLwb4i1efGe5eF52+3iJmn69KrjwsnK0RahI5x5Uo0Ipa60MSV54G5BRxqX01Ztc4cRdThfllsUQ6IdOdyAHfJdhA35Wcz2unjNHp17vQfwcHXxIYKm7Suy2hDH898z38Brp0CGzFd544l5FyoBCQFUDAjAnZhI5+v3CqcR+9GdKX65aXYvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(6486002)(26005)(2906002)(316002)(103116003)(6666004)(186003)(4326008)(38100700002)(38350700002)(5660300002)(36756003)(966005)(8676002)(508600001)(52116002)(7696005)(6916009)(83380400001)(2616005)(956004)(86362001)(15650500001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjZ6VGxCdmFpN0tObXdTYm1YZWRzWWt0WUNOMEwvRFFoa3JkeEZ6NVVCR09h?=
 =?utf-8?B?Y3VIQ0liZExjMUtuSk1RSUl3eG9hUHRUTEpDQ09VeEhZT2p4eEpXMnM2SEps?=
 =?utf-8?B?NG1GVzZJK3RRVzRDV1psUm8xVU1EWklpSUdEaWwwNEpUUGZ6di9OemE0RmE1?=
 =?utf-8?B?byt0WmF4bVlyOFlsaElEaGFwQnNnUks5RmVidTZhd0dORE13ZUFOV1o4SWZV?=
 =?utf-8?B?RmRCS3k2eUhkcFNKMVhhS1J4aG9CQjltYjRpOWxxRi9ETS9OemJMWXFXTTUw?=
 =?utf-8?B?alBmQU0zUFNnWXVtaG1CREhKVXJsWFdDbWdDeUtRUlp2UHozYVQ5S0llMDNz?=
 =?utf-8?B?U0JkT0hYKzZKdXh1WU9SQU1uKythYWZTVEdleFdmdWFjWkFUcjJKdXFhWHdl?=
 =?utf-8?B?Tk1aRVJSMXRIN0hWUUJoQ3Q2eUNlWFd6SHJhVHVxT3doa0E2emdONGJrZUJk?=
 =?utf-8?B?QWVONUJIYzQzRVlid2ZoVVRKTDZPajZqaVZ0L0xUb2ZXK1NyTEZhQWdJOU1r?=
 =?utf-8?B?Sk1FUXdtSGN0QlBWWDNESHQ1UUJKb3BuamlJcWVXKzdJTTJ6NlVRdzVjbmVZ?=
 =?utf-8?B?d0xWMzBiTVpuaUtyZVd2YklhalRONjhzTUxqTVNmd1NvNDVUeUN0WDVMMTI5?=
 =?utf-8?B?bjlkRjh1SjBSSzZGamlobjRhRWdnZWxrME1IalpveW56NVZ3dVpZRFJQd0VT?=
 =?utf-8?B?V1UzTVhraGw0SWlKZVJWYTFzMTVESXROUjNWK0FQRXZUREtFTnNodGpQMXJN?=
 =?utf-8?B?dU12RUZ4b2pqVXgzeHRQOGVJcG9uWGQzUkNtRVZKbnhtRnFObEoyZzdERWVk?=
 =?utf-8?B?YU9maFd3WU80YTJ1UkszUDRMVWxCb0pXRDZ4WVBGcXF0eTV2YTNKdThEVUw0?=
 =?utf-8?B?czdDSnZ0VFVmV2VPc3NGRjlpS2VjR1JXMTZaMjYzS3c1eUU1bXpBb3QvU2t1?=
 =?utf-8?B?bUJoVWpaV210anBudEdnSHZtaW1OUjlKNFVRMC9qQ0Z3bG9TUk1seTJPSGVX?=
 =?utf-8?B?VXU3NHREMG1rRDNXc0FVM004ZGtIUFlmK1ZUOUcxMWs3cnRRV2xtMTZaVEx3?=
 =?utf-8?B?N1MwQUZsaStxbllwVzFzTzVzb0tUakIwNm41cGZaVWdpUjJMM2xQUEhmdUhD?=
 =?utf-8?B?K3gwQnU5N1dkQXkvOEU4TWI4aXppck1vZjRqd0dHanVWVlgycS9iV1krWlhy?=
 =?utf-8?B?S0E5QWJsbVpzVGkvQ3UzTER6UTZmb2ZSRERQNlRsZlhUREFIcUM2UnVPcHBn?=
 =?utf-8?B?WTdlRUlwNkxvWHkxd2VDanRjVWU2WjlNY2xDd2puY2hlWkxBQzlsZ2lMNXFr?=
 =?utf-8?B?OTByWG5TalZab3pJVHgvWFEwR1Y5YlkrMWlScjhZT2huQ0lUUUYvWEthcXJy?=
 =?utf-8?B?QlZtNkdWOU1Dc1JXdHdlYkRPQVd1NXVaTTJkOG00bjVGcVQveGFRcDBOVVh3?=
 =?utf-8?B?d2VWWG5QS0RmVjdlSDNjOEZCT2gyWHVaZUlEY0RPRlZ4SlNvR1F2a2FHZlIr?=
 =?utf-8?B?Wi80bTBXWjVoYTRGMTZRUk1nZC90SHBaNE0zc0xreHhaQUMrYzlhb29Tck5M?=
 =?utf-8?B?SGEweGtyRXQzQUtLWm5xbTkwY1M5OXlLT0pJUkYzK3FjdnZ1cUVLRlFBZG5G?=
 =?utf-8?B?ODRJT2pjZzNNV3lUc3BObzJKeER2ZkdvVTV2Y3hzY09WZlVZd0lpN0lsVG9N?=
 =?utf-8?B?QzgzT3Bzdmt6Zmc4Q1gxaE1EMkZtaVpDSnFSdFo3WElONlR1SW5vSlZQMnJh?=
 =?utf-8?Q?QgVVPDjYOsrQSIG8QqBe0dLIolRIKPvJTpeIsx6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd41d7c-8d4d-4c69-7f31-08d952422c3a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:37:21.4857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OPfrnwPrL/0G9eIYQM2wVYKN3VPnC0JI5tRWKPG3H0wiXr+U8nl8jMtUHQ/awXxX3FAm2JOJIntl8wmdudI56Tw1kD0+D8yG+GyftV0bTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290020
X-Proofpoint-GUID: GpmBVKjnIYMkLDgQ7xbNljwTRnPGxyyC
X-Proofpoint-ORIG-GUID: GpmBVKjnIYMkLDgQ7xbNljwTRnPGxyyC
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Jul 2021 14:52:20 -0600, Tyrel Datwyler wrote:

> Prior to commit 1f4a4a19508d ("scsi: ibmvfc: Complete commands outside
> the host/queue lock") responses to commands were completed sequentially
> with the host lock held such that a command had a basic binary state of
> active or free. It was therefore a simple affair of ensuring the
> assocaiated ibmvfc_event to a VIOS response was valid by testing that it
> was not already free. The lock relexation work to complete commands
> outside the lock inadverdently made it a trinary command state such that
> a command is either in flight, received and being completed, or
> completed and now free. This breaks the stale command detection logic as
> a command may be still marked active and been placed on the delayed
> completion list when a second stale response for the same command
> arrives. This can lead to double completions and list corruption. This
> issue was exposed by a recent VIOS regression were a missing memory
> barrier could occasionally result in the ibmvfc client receiveing a
> duplicate response for the same command.
> 
> [...]

Applied to 5.14/scsi-fixes, thanks!

[1/1] ibmvfc: fix command state accounting and stale response detection
      https://git.kernel.org/mkp/scsi/c/73bfdf707d01

-- 
Martin K. Petersen	Oracle Linux Engineering
