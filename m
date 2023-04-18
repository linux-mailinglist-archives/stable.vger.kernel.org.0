Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C5A6E5F0F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 12:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjDRKlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 06:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjDRKkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 06:40:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E14C5BA7;
        Tue, 18 Apr 2023 03:40:49 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33I9pm7v015770;
        Tue, 18 Apr 2023 10:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=9JDZgzQMpME4BEcsaCswRi9xZJAsmG2uoDgQxQqCaEo=;
 b=ZLa+SwS7nrWUVB5QWDlpGNmq9ChRzXTmK4KupBog99S9UrDV2jQuOvN2BLaJfwLKRoR8
 wXVywFVbrPnWUJGG7c02JwLIQb+1t9rZsj5oP2cAhF7BGVM+NFNUc4NIbmSctv7Yg82V
 RQFUB/0Nhso3D2IRNHew/7VkMaQ0+3fpjfTg91lEmR7XuMupmaywqJJMrneqQWLva/wv
 Cctb17gF4NU9phIBiNuI8h5+7rR5mgdILmVyfl3xPo8jRgHMT02EIdvusGT+ddvPDuvc
 MR4R48+kRvEc8yxJNCVZwnSdhhvuq1MoZG/eCIFpBB0WZHEvsTVIqH33rg4O/XY8/o7H Ow== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyjuc5ck8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 10:40:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33I98xMU007630;
        Tue, 18 Apr 2023 10:40:42 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcbbdty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 10:40:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/s8tD0V8oy1Khre9OwPDs5bV99Ey7diSWMkrw9Au18kdPvr3FD+1s2wYUtA3IkKNSAiOWeksTaETRbwppUZoqwrrbdwgq6JUMWK2Gg0AQkiM70BG2htA7AcwIv1MFQSKzxYHdpfCX33f/OKIT0Tn5s86SSM8YHaPha0K1IA4gqc7wO0ZKUBoQA1qOJryRTFVg/9tni4sbDSgOPWtS7x2La9WCBzs1Jn7vWpiBVOoEuQ37emw8NhrKu3EAvi6NlN2siS8m3rwPhbrQyHADWl6x0ywTWPcpx23gPiRPYMj2bU+nyJULfyZDPf1txg3O4AQ3uukRBPLhwGUg1RjHGVqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9JDZgzQMpME4BEcsaCswRi9xZJAsmG2uoDgQxQqCaEo=;
 b=FPQExVu6/22CZPrtoZcewobdAaHfaGr3fwHB6TPtVe9OI7/q8c81Y9ZV5AfbCCCZa6Hb81JXvuLuJKBugCoiqW7G9JVLDBXRCwhtKXQyCnz1Ded9i8ZjpknJmCb+SWhE++z/S6N1VoJYjXA5NxrUexFaFD+OIn4tE0yW8tkci8G8NNhF4qx3Oe+hPu6gLZH3YaKNhYKym9W/oeyCohjOfy7I5IqwG0wOVdz85UQFrEOgeqjcitdrjwmt3QBRKA3Y0USnnPNoQQYIQqcrONLammS7gz5rV0A1w/tizEhFsz5eaU1T9hNvxh6/s0aO7oaTnrQX+dr2fBVJEDnQsrJjuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JDZgzQMpME4BEcsaCswRi9xZJAsmG2uoDgQxQqCaEo=;
 b=gHG+iCwuYhKLMYQ5rTu3PAGnpCX3SwLB1xDzaHCCTBE/RItIJbEQv0DWdMO43QAs3VIGkyHkXH/9dSUkaq2vV08H01QqKfR5gySFBbAUkbhSqXkmbeIj8O/mJnyy46CCcKIGEpaVeDP/8Xz+XF+Hk/9OOIOLrg4K4aEMMleIGww=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM4PR10MB6064.namprd10.prod.outlook.com (2603:10b6:8:bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 10:40:40 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::bc67:ac75:2c91:757e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::bc67:ac75:2c91:757e%7]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 10:40:40 +0000
Message-ID: <2f337860-f215-615f-b24c-85ff4660d895@oracle.com>
Date:   Tue, 18 Apr 2023 18:40:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH pre-6.4] btrfs: dev-replace: error out if we have
 unrepaired metadata error during
Content-Language: en-US
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <4360e4f01d47cca45930ea74b02c5d734a9cbfbd.1681093106.git.wqu@suse.com>
 <e3d8c926-d4a4-cc3b-b845-211c40fe99a2@oracle.com>
 <d2de6696-3aa5-df0f-edb6-064e66d9e26f@gmx.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <d2de6696-3aa5-df0f-edb6-064e66d9e26f@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0081.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::8) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|DM4PR10MB6064:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e8f97d7-519b-4a39-6109-08db3ff95a69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mDStuuCsnai5eoVqo18SCeGIrdFQDn41MkRUi0SGKvYjaCSC34DBk/cqT07g78Yz7Xvbx0AKNkH7Yso1rs01hvpAf4K1uhxf+x9n8+KbN3pgA6TE4UoWX+21xSmfJs4l2WX71Tli14ycA2vmdnUuiTAcGDRXSuCpntYUjfFF/Ujx9NGZHf9bnga44oHuaSdh7ATlUJb7nzSES23Q4fvJDl/PTKFHVEGbEPoAEf12EEnRVkB8v+ArJij19EKuybBOFhivQOLdGHEEpFAhcdu13D19cGkKdQo4i3YT2kQ7XhQHKasQB5onKrK7/zP7+I5bnw/0I8obN6E3WScFekz/pi+6WSnXiusCDQPTK8GLUp+tsLhZXeuDELNQ/jd5ZifE57eqY7DgEsD+iGdkPwBUIWO+C0h20QvUIA9XJcxvK5O2vwveJ0b7T7KkAezQNmsjT8Tp04fOhrtlA/E/5X3KQbJHL18VJmLgHSQ1TtO1RDb+ChLVLko3fz7cxWdeu16o+sdEnkksu57UN6kiOBo5w05egNtsFmCTrURIjWGQ1HZ7zf2hCLLs0HkzDYf2Q+Hpuf3L3kbGIzZkF1EEmluMpZH3MNMuf1HivkGP9AnJy2VCxPDbairbYUM3ZNIFwbOzom5y/Jp3+XWxLwb8mY9bQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199021)(478600001)(6666004)(38100700002)(8936002)(8676002)(316002)(41300700001)(4326008)(66476007)(66556008)(66946007)(110136005)(186003)(2906002)(53546011)(36756003)(6506007)(6512007)(83380400001)(86362001)(31696002)(31686004)(2616005)(5660300002)(6486002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjNJdHprc2xwc3U3SUZNTHdWSkxxQXY2TXQ1VGZra2IyTFhybjh1NjA1dG1w?=
 =?utf-8?B?SnBUT1BXWFdIVlBsSFVLcitvWjdrazg2a090dlZ3eVNxeURuZTRaSUJYc3ZH?=
 =?utf-8?B?VzRsc1haZ0RDdkNzWlM4QTg3bkw0ZzFmM2ttUFR5azE1NnF1clM1c0ZOeEFI?=
 =?utf-8?B?eWQrYjdrR1R4ZU5PcldibUFOSVAxLzFJekJoS2t4cGlsQ3V4M3pHM2Z6eUZy?=
 =?utf-8?B?UG03RzFPSXoxZWlZTzJXVDRFV3dvOU9MM25FSmJqdkxIUFozNTgxNUIxQ3NP?=
 =?utf-8?B?cnVxcmF2VVo3UXJaZ1dTYzdpQ2x2eVdiQnQvbXE0L2tIRzdITmxmdjdOYUtQ?=
 =?utf-8?B?b3g3NzJYR1Q0SlBQZFJwV2xmR3lIRVFlR3g0QzNVSlpOOGZKcmwwNlMvSjUz?=
 =?utf-8?B?Q0UzVCtqb01qeFloQXJjeEVmcDBCNUM0V2NCTVZtY1p1LzVUWjd6b1lGZU55?=
 =?utf-8?B?RCtMaXZERldsMU1LUE1rUTZYNFFrVVk4ZVlGd1NiOHhsU0pJd0NhNU9ZYlEx?=
 =?utf-8?B?OHdGQ2x1eFc1Uk5EK1JzOHVPdXpHYXUycDE4OGYzWC80MEV6UE9oQTgxMTd6?=
 =?utf-8?B?dUJHMU9oNURyTHJnWEcvOWlDazRvZlJ2TzdIWXlZN0RGRnJZM3RzVWNsRTEz?=
 =?utf-8?B?SzhKZlhpTTRvNG42RTJpdWptTFhGWmtmMXZDaHpCYnA4U2x5L0poeWpNUCs1?=
 =?utf-8?B?NkQwMFNDWXRwSUl2T3QzaEcyd203RWZ4NldxMlZueFNuVUlBT2dkZnJySlU0?=
 =?utf-8?B?dTdrcmgzZnp0U1JodFNkWTFZWnFzOTFwTEgwMVFHNWNzcVlnRThtZ3NmS2ow?=
 =?utf-8?B?c3JxUi82eXdON1RLV0E2NlFaVVBiL1gyNFlIMkZZQ2xLaEpUQmwxNE1YZ2pT?=
 =?utf-8?B?ZDRteGVXcE5SZGFUZE8wVXFheUlSWXlHVWJwTzVEUEVTNEVpbnFQb3BHWDUw?=
 =?utf-8?B?MHoyVE1Xdmd0Qk9aWEp1VWRuaVBNNUxvOWxuSVZXK2ZYS3YzTERyQ2NQM3gz?=
 =?utf-8?B?K05FWU4wUjJKaTFIUVZ4TE9sSFBwakJYUi9LMUZHZkxMc1ZLQkdOa09PZlVw?=
 =?utf-8?B?bFFGL2NTcmE2T0R5UXcxZlYwOXBXcGtwWXlobUh6b0dOc3M1NjJGM2p2Znpl?=
 =?utf-8?B?UUVrKzJHRHkxY25HZmYrOTlSSCsybXg3RUEvSmNlS2hWMy9lUVk3YzlTcFdn?=
 =?utf-8?B?eFFEUTZzaGxBRk1zR3d4NXRSOUZlbWhQK1kzWnFLcVpieHh2UXFEbmVoQ29h?=
 =?utf-8?B?blRuZjVkY2lpTlRTWnd2UWp2VnlDenRybUdBT2t1QWU4eTFoRWtQU2s3MlUw?=
 =?utf-8?B?Sy8xdjZwV1hVNnZrZUkxVlhBazc0bXRuRkFFWkUxVWN1MnJzaDFwemxxZWNl?=
 =?utf-8?B?WWpuYy9BQnFZK1NSUytEeHRheHZwaWt2Tlh6bGdoR3Bkcm5HbW5kamVWaitt?=
 =?utf-8?B?MlBLSUpWU2ppdnBoMTNZWG9zYzh5anhVL2YxenQxUXVIREc0UG9LSnZIRGd3?=
 =?utf-8?B?aEJ2K2poN2F3REhidGYrSFQwMnYweXhCY2Q3SWZRajFFNGtiZHEveWVXYWgy?=
 =?utf-8?B?R3VxZ1IxMmZZNlhGT2FYV1g2bXduMEh4QzBNRFJUelJjNXd4MFdEWUpsQ3Vl?=
 =?utf-8?B?OXl4b3JPclhLZ1BuMG80ZkNHWjVMaHZXcDdQTkNrUTIzeGFpd2M4WmZwQ1NN?=
 =?utf-8?B?MHFka3hXU1NiSDlDdjdDLzlVbFJXckhHZTlBQ1hqdHU0RG4zcTRBUEcrSnkw?=
 =?utf-8?B?cm1WZEU3T0pvQmhLWWVEWnFER1FXSUlBaHZPanhMZDVDc01waFd4RFA0b0h0?=
 =?utf-8?B?L0FYNldqU2F5bVdSNDUvZmxSbGpwa2hFRGdGOFF5YTVJcXMxektYQ0tRNlgz?=
 =?utf-8?B?SXJ1QnNISjNKcUErMnVoWndYWXVMSW1OQWdKYmdXRjJVRTZ5ZTRMN2dlTVdE?=
 =?utf-8?B?SWx0eUREZU12MTNlTFJURnBHczdrTmQrc0ZaVDRPbSs2V0dqUnA3Z3NzcExq?=
 =?utf-8?B?cXJHSXFvRllaWDJBK0VXNjRzNjBMRm1LaFpIVUtFVmh0ZkthaWFSWUFtS3R0?=
 =?utf-8?B?N0p0ejMxVTJUSlhZaTdKSVNxNFFEUkE4NjM3ZDFEdVRWeTBNYW1MS1hzMG53?=
 =?utf-8?B?c21KWE1rc0lQeFB2dU1IUXZtRHl5NHl6Vk80bXNuSjMrR1grZUdvTmNtcjZr?=
 =?utf-8?Q?74eLN1hYQbk+Q1xdoHz64OStKYGzB5TB8Uc8fZDVkYsx?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: usTLCynbH6iwT1OMmqhZLc4g5d0RldHiWYktErr9qXz6Ieb/T/tbxBAz4BV83dPJjYbHn2+QAErkJM7Y9LEtJ5EyPbys8lcAWOaqbixzxlQhTzu5gGgX3HgsVzrTfYQ9l39YrMsvt3P24YAuV0yLCviTJmAsvflyJFOcDYrpB4AdawuIe7sKnBklHyEMUDECJHD4UixBVFnxxCBKT/83phSYhSsxxa8PLkGetStcxaLS70RQ2Dc/iIghm5AHn6HRD33BiMgF9bQ/6aSDTOKrd0S69Bl/JzW4UQntjv9IILpwhhWnyJHzRRsW0U0q5/vQD/0oXXpq4ZSsT55y/xkq9xedLbqO29So3I950LaGljwNfQE/ja9kiQtctSbm30OcNtu4RnLP3QBNRXHwKd5M4C5vclgmP9A2YL/N4IXpdv1q9Oyud8Cir3rVmiEu7NiDDOML2o27EUhh+kQXU3wmKCytbmAcgsVLzCiQjYRzFgYmo73rn+23OI6Ve2QU52Ej6bTLPZx/FgNutn8hgSmrqB2qaduHGzGoLlJ0gtUqCFBvQmyhaTGEc6E+AKYKwLGfPVOrheZam9rLgAPGKiDciAn+Bkrlb1SroU4vAa8ZT8OAkaM6NK7l0CHZ1TPRQkYE3PgIwRKsSKTWt1d4eJ+veWNzvAQgfSblKRWxiGUtBZBiyIHbkiR72jQmRpoUU22mLiKgjFI1foCdjQC90BgVzcQamdRK6XEupG+O6tNC1ilYtstCX7Qy29wqxnfbmS3jLMKkdYN0NcLeie0RWzrcMxJxKZV/NGDLvEY899848ksGqEkDtvLisxV8IXSnQTwx
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e8f97d7-519b-4a39-6109-08db3ff95a69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 10:40:40.3409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TlCFgeHpuc0HpX55g1uesqGMkDygjnfqI4wDY/jrGYZ7kD5TgHzS2hA2Qlv/A3PSRWiB20gXbBmgUrg6Cfiz3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6064
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_07,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304180092
X-Proofpoint-GUID: QJNaapHDVPwAT3N3KLwND3Qu9FP1Pcgy
X-Proofpoint-ORIG-GUID: QJNaapHDVPwAT3N3KLwND3Qu9FP1Pcgy
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/23 14:42, Qu Wenruo wrote:
> 
> 
> On 2023/4/10 12:20, Anand Jain wrote:
>> On 10/4/23 10:22, Qu Wenruo wrote:
>>> This is for pre-6.4 kernels, as scrub code goes through a huge rework.
>>>
>>> [BUG]
>>> Even before the scrub rework, if we have some corrupted metadata failed
>>> to be repaired during replace, we still continue replace and let it
>>> finish just as there is nothing wrong:
>>>
>>>   BTRFS info (device dm-4): dev_replace from 
>>> /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 started
>>>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad 
>>> csum, has 0x00000000 want 0xade80ca1
>>>   BTRFS warning (device dm-4): tree block 5578752 mirror 0 has bad 
>>> csum, has 0x00000000 want 0xade80ca1
>>>   BTRFS warning (device dm-4): checksum error at logical 5578752 on 
>>> dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 
>>> 0) in tree 5
>>>   BTRFS warning (device dm-4): checksum error at logical 5578752 on 
>>> dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 
>>> 0) in tree 5
>>>   BTRFS error (device dm-4): bdev /dev/mapper/test-scratch1 errs: wr 
>>> 0, rd 0, flush 0, corrupt 1, gen 0
>>>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad 
>>> bytenr, has 0 want 5578752
>>>   BTRFS error (device dm-4): unable to fixup (regular) error at 
>>> logical 5578752 on dev /dev/mapper/test-scratch1
>>>   BTRFS info (device dm-4): dev_replace from 
>>> /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 
>>> finished
>>>
>>> This can lead to unexpected problems for the result fs.
>>>
>>> [CAUSE]
>>> Btrfs reuses scrub code path for dev-replace to iterate all dev extents.
>>>
>>> But unlike scrub, dev-replace doesn't really bother to check the scrub
>>> progress, which records all the errors found during replace.
>>>
>>> And even if we checks the progress, we can not really determine which
>>> errors are minor, which are critical just by the plain numbers.
>>> (remember we don't treat metadata/data checksum error differently).
>>>
>>> This behavior is there from the very beginning.
>>>
>>> [FIX]
>>> Instead of continue the replace, just error out if we hit an unrepaired
>>> metadata sector.
>>>
>>> Now the dev-replace would be rejected with -EIO, to inform the user.
>>> Although it also means, the fs has some metadata error which can not be
>>> repaired, the user would be super upset anyway.
>>
>> IMO, the original design is fair as it does not capture scrub errors
>> during the replace. Because the purpose of the scrub is different from
>> the replace from the user POV.
> 
> The problem is, after such replace, the corrupted metadata would have 
> different content (we just don't do the writeback at all).
> Even worse, the end user is not even aware of the problem, unless dmesg 
> is manually checked.
> 
> This means we changed the result fs during the replace, which removes 
> the tiny chance to do a manual repair (aka, manually re-generate the 
> checksum).
My concern is, following this patch, the user will be able to replace
the device only if the filesystem is healthy (passes scrub). But, I got
it, there isn't any other choice.

Thanks, Anand

> 
>> However, after the replace, if scrubbed it will still capture any
>> errors? No?
> 
> It's not about scrub after scrub. Such replace should not even finish.
> 
> Thanks,
> Qu
>>
>> Thanks, Anand
>>
>>
>>>
>>> The new dmesg would look like this:
>>>
>>>   BTRFS info (device dm-4): dev_replace from 
>>> /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 started
>>>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad 
>>> csum, has 0x00000000 want 0xade80ca1
>>>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad 
>>> csum, has 0x00000000 want 0xade80ca1
>>>   BTRFS error (device dm-4): unable to fixup (regular) error at 
>>> logical 5570560 on dev /dev/mapper/test-scratch1 physical 5570560
>>>   BTRFS warning (device dm-4): header error at logical 5570560 on dev 
>>> /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) 
>>> in tree 5
>>>   BTRFS warning (device dm-4): header error at logical 5570560 on dev 
>>> /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) 
>>> in tree 5
>>>   BTRFS error (device dm-4): stripe 5570560 has unrepaired metadata 
>>> sector at 5578752
>>>   BTRFS error (device dm-4): 
>>> btrfs_scrub_dev(/dev/mapper/test-scratch1, 1, 
>>> /dev/mapper/test-scratch2) failed -5
>>>
>>> CC: stable@vger.kernel.org
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> I'm not sure how should we merge this patch.
>>>
>>> The misc-next is already merging the new scrub code, but the problem is
>>> there for all old kernels thus we need such fixes.
>>>
>>> Maybe we can merge this fix before the scrub rework, then the rework,
>>> and finally the better fix using reworked interface?
>>> ---
>>>   fs/btrfs/scrub.c | 9 +++++++++
>>>   1 file changed, 9 insertions(+)
>>>
>>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>>> index ef4046a2572c..71f64b9bcd9f 100644
>>> --- a/fs/btrfs/scrub.c
>>> +++ b/fs/btrfs/scrub.c
>>> @@ -195,6 +195,7 @@ struct scrub_ctx {
>>>       struct mutex            wr_lock;
>>>       struct btrfs_device     *wr_tgtdev;
>>>       bool                    flush_all_writes;
>>> +    bool            has_meta_failed;
>>>       /*
>>>        * statistics
>>> @@ -1380,6 +1381,8 @@ static int scrub_handle_errored_block(struct 
>>> scrub_block *sblock_to_check)
>>>           btrfs_err_rl_in_rcu(fs_info,
>>>               "unable to fixup (regular) error at logical %llu on dev 
>>> %s",
>>>               logical, btrfs_dev_name(dev));
>>> +        if (is_metadata)
>>> +            sctx->has_meta_failed = true;
>>>       }
>>>   out:
>>> @@ -3838,6 +3841,12 @@ static noinline_for_stack int 
>>> scrub_stripe(struct scrub_ctx *sctx,
>>>       blk_finish_plug(&plug);
>>> +    /*
>>> +     * If we have metadata unable to be repaired, we should error
>>> +     * out the dev-replace.
>>> +     */
>>> +    if (sctx->is_dev_replace && sctx->has_meta_failed && ret >= 0)
>>> +        ret = -EIO;
>>>       if (sctx->is_dev_replace && ret >= 0) {
>>>           int ret2;
>>

