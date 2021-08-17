Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AA33EED95
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 15:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237178AbhHQNmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 09:42:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30212 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236635AbhHQNiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 09:38:23 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HDa8Ft014757;
        Tue, 17 Aug 2021 13:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=p/v3jc5rAMLn7tvRvmzXUMgJr+NjF5ueZcCnB6bC72Y=;
 b=hYTNrmqICSzpQgj/eR0JirBpM5EAL+x7vs+cBGCJ7TWqDbcECirZvw/qblwDrBYwhEq2
 FVuDbXEyTO21EADUNadlfiTh3GoyNziZAHPoIw24zkoZ/B0FcHquhB9O1jJn+B3YrMMQ
 itKdJOD25vvXDSgfw7urDAh6+ZwlTco0IuU0QSO1svlBUzHWB+udNAofQKFSlRW+fb/x
 dZ+VLFzA1otJLCKTynYKND8hmfCdUl1GJsXxpZrDUpyeSMq5gf3wSJhMOHmv0wd99sHJ
 gUcoEFEC7J663fcvi7lLSt+zgaGavKdN1AAEIuFqSi5u6i1Ryq+91kB1TS3kL+w7SzkP FA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=p/v3jc5rAMLn7tvRvmzXUMgJr+NjF5ueZcCnB6bC72Y=;
 b=eGd3o84qPE6bFP15fXFKewOxH8g+hhkBgQN3biJpq9O4Y9fSLO+waGcQTYrsKLUE+w35
 IWJA8SwNx3E+qMe3P0jcVhbdwKPZML7DnWjPqXOtKiOvl/hNbZ5F6y+OyG9bdmbLD1ci
 H9VL+CQ+WzXs/GljxT4z8g30QSSj2h4xqgurcTlaP6wafHOhB695N7zZHItNPldEPHJT
 GAdPPX6ZhDS9uQsg0CNaWsDEi8s6gxqEjHfhPC4704dKPuK5TktnVJGTBzBPWo0tV3qx
 Rlf+3Gxr7JjffE6ChHyfnwhjBxdoHHAsvLQ3CJOlxdqbgaW1oSMzYowvbVGBoyZBbC49 jA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3af3kxvqc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 13:37:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17HDWuOE016760;
        Tue, 17 Aug 2021 13:37:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by aserp3030.oracle.com with ESMTP id 3ae3vfk9g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 13:37:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkYvuEcioWDji59DybSJfavCemgmijwleHsM6XrpL7OpWhe3MpN4XGXPMO8ob/QU+MZVT3UGUiBvJlBTwDjqgxAjyTiPuP87H/QUm8SlwJRg/UKL9zT2YkSakQQhii4N6agWigvRW2iz+T2sRyy5l+jb12XF7tPkFRg/3F1k5I59F3TXsq73vvtpXox/Tj2AmycFxzzrIpVue6dQlw6QyUJNUEehlv0Nq1PdV8qb6Jjbqbe+wKa8I3m+zsLGAQlRFuhK8MCGjdygrPi22+Qw8ehgETAae3dnTQfSuMHi08RbPy70F5tR4dAe16JIyPayMBCzxxU1c8Cg4MbFLDJ9Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/v3jc5rAMLn7tvRvmzXUMgJr+NjF5ueZcCnB6bC72Y=;
 b=RRCXa9zB7rfE9taC3VM4jS2dv5eeM3hW2XMG4z7YhPzB08voizaT39vWmr5r598e0BqDeq7asF0Yi6kNXESM8uEduC3jaAUmvcecVLsmH3ZQ0cForXocY6CQE11UXD5cHbtA/iE0PCaqpec70SeItL0oJNCtxBBwafgCPX0Llub+RFGVE1j9LbXVcHGgCkd/AuVn4zoQ2gur5TYS2IylPwJgr3toU05m8iunQ4rh+NErZaw9DONuoIBuTdN5cl5CSxvw0ddNeOymF01J7LovJyJqRj5p4riYzmNqs38EZ9cUzowVya8kfwVZnK2VEWiOTWYA80H2wD5IkcGAyyDPdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/v3jc5rAMLn7tvRvmzXUMgJr+NjF5ueZcCnB6bC72Y=;
 b=Nhza6TlWVe+zeHQXNmOz517ceBG7k+5kzoohxyORRXEKAFS+Rbm/+BXa4I0BrNyWjvvCArTSm2LAvUaFXwBXiKQ6n9sFEZdZbeNqN0017hudP2zmd9xOgNfUuQeQJ9AQ347aKJFy0ap1OPtY+U5xPTmRJSRN3Q6EBhpNJx0QRU8=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN0PR10MB5205.namprd10.prod.outlook.com (2603:10b6:408:116::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 13:37:06 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4551:a5b4:f2ec:daf]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4551:a5b4:f2ec:daf%7]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 13:37:06 +0000
Subject: Re: [PATCH 5.4.y 0/2] 5.4.y missing upstream commits 7beb691f and
 51f644b4, causing: WARNING in vkms_vblank_simulate
To:     Greg KH <gregkh@linuxfoundation.org>, tzimmermann@suse.de
Cc:     stable@vger.kernel.org, daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        robdclark@gmail.com, sean@poorly.run, tomi.valkeinen@ti.com,
        vegard.nossum@oracle.com, dhaval.giani@oracle.com,
        dan.carpenter@oracle.com, dvyukov@google.com,
        dri-devel@lists.freedesktop.org
References: <1621630400-22972-1-git-send-email-george.kennedy@oracle.com>
 <YLTP5/8h4BsqnTL9@kroah.com>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
Message-ID: <cc388554-7f83-c967-0fb7-14b71c0032a1@oracle.com>
Date:   Tue, 17 Aug 2021 09:37:00 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <YLTP5/8h4BsqnTL9@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0501CA0004.namprd05.prod.outlook.com
 (2603:10b6:803:40::17) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.39.229.28] (138.3.201.28) by SN4PR0501CA0004.namprd05.prod.outlook.com (2603:10b6:803:40::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Tue, 17 Aug 2021 13:37:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64ee5274-2e6b-4c46-b3ab-08d961841a82
X-MS-TrafficTypeDiagnostic: BN0PR10MB5205:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5205666D02A42DA0640D1E88E6FE9@BN0PR10MB5205.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aqhr0w9a4GmT+BYmG8M+7Zs+ITS0T5o/UIWyXkIpI1VYbOKrRrMZ7CdwUVM1KsnneKtmddUy1j74rbV1gvhiqufgnhOglJpavppPVHIiCJfJW/2HwXZ/jqkMsYf5CZPaFhU2dEHn+iGQ6Oi9Aw1a+SOz0oo6Ke4UlQETAo0wGqczYZeH7St9yoljRVMScS52EXW3ckzin1Z19e0Aj04Q4fkL142D540F4OvpPDYAf9+wTAaw5K0t2vP4ffjhr6js8QTZk1svLLULKmLIo6QXrG/a7VOTJ4EIukYATLhlsQcywOE7QkLITOSgvpu6MIj8hh97fVCn/8xnRUs3RuX50JlSjklcur4sKguKMr/9r6n74/NSFBkRodh8wSY4umYFOWaEAcF50FFrhyKpJhTaRbD7Q/6+N/2waswPCnzi/qmo71lCXfBzlKk13dYdm7V1MTmQmTbWL9MzEwNwU8DA5xTRmZVjrBA11s09PowQI8UMknPXZsPwzrSxQAkKJTdKKasz+EdLl20qvWE6LKj2V+YnjaKz/o5zk/rgTaybdpr9d0QnkAssm53PsE/M7Honro/NKOBckRkvrxu2CloFGvD8a5WPcft4GGqeBlyLdTCHLkwSNHjjt6dOEoNenYnVtiZbDkii4pOsIX54OavjcqqtQga5FcrlXSyESUyaDw1NVR4A2NGiwkVg37pvYoml0CKmhurMeWRL8wuDoZ0gLvuz+GsJ0KVcsra1m8Ny8vB83Zt/fJKg9F1OuQZUWzXYtcSqD9e4TVfFLJm8bsZ3TRBnxIKhUWTyCIWACWDh3Yy61+axjCk61Mc9lOggnPaogE2sLMwfqsoiMF1ghuGYkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(66556008)(508600001)(83380400001)(53546011)(966005)(6486002)(7416002)(44832011)(86362001)(186003)(8936002)(4326008)(5660300002)(2906002)(31696002)(36916002)(16576012)(38100700002)(36756003)(45080400002)(316002)(2616005)(66946007)(8676002)(956004)(26005)(66476007)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZG1tb3A5MlhkU3RJNGlBMEY0RzQyazBhQ2lmZFpmMVJVZmZTRHEzVllxeGNW?=
 =?utf-8?B?TDlKRHNjL0JxdW50eSsrVnBVZS9HMVhKL3cvaTNFeFlGek42ZzBJMVVxRjg4?=
 =?utf-8?B?aEcvQVBxRWkrK2g2U0VEQkdCWDR4STBtaEhZR1pXMkFGUE94QXRmY3dNTGJL?=
 =?utf-8?B?SmJIYUdiVzB1RDJVcGJZSmVYUS9pbkNDckRJMHZ4ZEcwR044dVczK0FSU3BR?=
 =?utf-8?B?ZVhEMnJrQllaRzl3OUJHWkVTVUpITzA2ZHhGNjlueXZOWWZsdmtDTnFhcjlh?=
 =?utf-8?B?Mjk0TTRMVkk0OW5MbVV1djRpNG52NjJlNkV6Z1VQZExoMkVaejh1TmNFWW96?=
 =?utf-8?B?OU9mN2xMMVBxVTg5L1ZxWElnS1lIVlRUNWFlc1ZRREMwTU1QQnplZ1N6eFBY?=
 =?utf-8?B?c1ZsQ2M0clpXNDFxTmdkVGM5YkNRWDIvYXhHR2hCclR0Y056VFkySmlMQ2pM?=
 =?utf-8?B?eEF0THg2ZG5BK09pSWNqT0p1MmdOb000bndRdW9lVXB4M2d5NnZqZDJBV2Rl?=
 =?utf-8?B?WUhMU2ZlUjhqUEE1b1ZVN3NRNml5NzNVc3RpUTY3amRqSUdHaFhUcEx5Y0k4?=
 =?utf-8?B?cWRhcjBSVXRydDVVdGd3dFJPcDB1dFRGMTBRdElRZlVoVEV3ZFVLSk1STTFB?=
 =?utf-8?B?ZCtYemJpNG9kM3lWQXJDWVdZU2pENUpIeVd3bXNNNUtwd0pOQmhQRkV1Y0hS?=
 =?utf-8?B?UjB1OG15K1FJQmVJOFZMdmdaNFVXb2RRWU9tYWdzNkJKaDdpK3h3N2pqK2pY?=
 =?utf-8?B?SzEreDhqL29NQ2Nncmg0RndsR3dpN2xGYlRoNFNjcUlqUG1wd2RPWmtGN2FL?=
 =?utf-8?B?NjhJdTZWbU1Mb0VPMGh4VVpPUmEwOS9FRTFuK1k0S3hZcjhtVTd5NVo3L0lY?=
 =?utf-8?B?eVFNVnY3YjVSSWFUazJPNEFFTDdkT29UcnBzc2I5cUE3SkNUNm4veUhyU1Nq?=
 =?utf-8?B?ZU55NWt1d205R204aXJxS25OczVTMUtQWDN4S0pJMTJQVFJRWGFueGxoUWFB?=
 =?utf-8?B?d3c1VFhyL05RUGk1WWliL3lIZVFpZmptQWE2K0xJK3B6SWNoUnJUaXBBeXU1?=
 =?utf-8?B?RStTL0xjS2pQNXZjdXJnczloNjBmRFUzR0RHSE5PaVpFWTNZeTkrSEhvdmZx?=
 =?utf-8?B?REZmVUpCaWpQNHY4QWI5ZTZoSzJvdFVXUTRJNENKNzFZYXpWOHkzeXRKWVly?=
 =?utf-8?B?bi9zZ2YxY1hXRzhyU09IRGRFSkhoSTh3aVMxeTB4UFNwdGRyZFlxU2RhbHo4?=
 =?utf-8?B?QytYblZWcDR0REZDbklOaWVqVDlYUU5IZ28velg1U3djcDhMS0hCOHB6aXRz?=
 =?utf-8?B?aENlM01yaVRsOXQ3Qm9DcXZSQXlEd0w5OVBDa0ZrRW96M3NOd2IvYnJCRmVj?=
 =?utf-8?B?d29qVUpXeWNld0pTSXVHam8ybDAzbFNvYjQ3T2doZnhKa1pEb25SZklQY3R6?=
 =?utf-8?B?S1NmL2dMTWxDWE5KbzRGVFBxckZmNk5oNW11YmZNcHdNckFaQ0ZRaWtBT216?=
 =?utf-8?B?YXlKSjZwZG4xWTZBV2d2VzFVOFlsU0tldW96TzU1NmhwblRDZHM3dGV2RjN2?=
 =?utf-8?B?YUJIY2ROTDZ3bU9qM3RkTEYyQ3d4VllFT3ZXYld1dGd4R3FjVmpKekdpcTQw?=
 =?utf-8?B?TUhYQW5TYUxRUTdzWGRrakJqdmR3aE90OUFKUlhpeWgzVFM0UUlYRkdQTFlm?=
 =?utf-8?B?Y2UvajBpOG9xNnpPeGlhNFdqZmhVWlZXMlVJeG0vMG9JT3lGR1ZadTJHUCtm?=
 =?utf-8?Q?Uqm2tcQXn5Wp3aFPdbiY7hmgW3EzhpdVDKZrQr7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ee5274-2e6b-4c46-b3ab-08d961841a82
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 13:37:06.5393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 88E/dNa+xZVE/uJ/GheqnNkXb359kxa0UuOhc80hcNNutwNFSngxkdNAT5jUNsrjC4XRYCfA9lzx8KzftuuIXlmEmT61VaUuORJrsPf+wE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5205
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170081
X-Proofpoint-GUID: 5IRR0hBOvOCkIkXXKrFxZC3tcf_aogLn
X-Proofpoint-ORIG-GUID: 5IRR0hBOvOCkIkXXKrFxZC3tcf_aogLn
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Thomas,

I sent this backport request to stable@vger.kernel.org a while ago 
including the maintainers, but mistakenly did not CC you. Sorry about that.

Can you please review this backport request for 5.4.y? Greg is waiting 
to hear from the maintainers before accepting the backport request.

Thank you,
George

On 5/31/2021 8:00 AM, Greg KH wrote:
> On Fri, May 21, 2021 at 03:53:18PM -0500, George Kennedy wrote:
>> During Syzkaller reproducer testing on 5.4.y (5.4.121-rc1) the following warning occurred:
>>
>> WARNING in vkms_vblank_simulate
>> https://syzkaller.appspot.com//bug?id=0ba17d70d062b2595e1f061231474800f076c7cb
>>
>> These 2 upstream commits are needed to fix the warning:
>> 7beb691f drm: Initialize struct drm_crtc_state.no_vblank from device settings
>> 51f644b4 drm/atomic-helper: reset vblank on crtc reset
>>
>> 51f644b4 has conflicts (which were resolved).
>>
>> [  101.335429] ------------[ cut here ]------------
>> [  101.336576] WARNING: CPU: 1 PID: 0 at drivers/gpu/drm/vkms/vkms_crtc.c:91 vkms_get_vblank_timestamp+0x10a/0x140
>> [  101.338952] Modules linked in:
>> [  101.339701] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.4.121-rc1-syzk #1
>> [  101.344331] RIP: 0010:vkms_get_vblank_timestamp+0x10a/0x140
>> [  101.345660] Code: 03 80 3c 02 00 75 4f 4d 2b b5 80 10 00 00 4d 89 34 24 e8 d9 4e a7 fc b8 01 00 00 00 5b 41 5c 41 5d 41 5e 5d c3 e8 c6 4e a7 fc <0f> 0b eb e4 e8 3d a0 e6 fc e9 27 ff ff ff e8 33 a0 e6 fc eb 91 4c
>> [  101.351293] RAX: ffff888107a65d00 RBX: 000000179647991a RCX: ffffffff84cde2af
>> [  101.352976] RDX: 0000000000000100 RSI: ffffffff84cde2fa RDI: 0000000000000006
>> [  101.354662] RBP: ffff88810b289ba8 R08: ffff888107a65d00 R09: ffffed1021651398
>> [  101.356361] R10: ffffed1021651398 R11: 0000000000000003 R12: ffff88810b289cb0
>> [  101.358037] R13: ffff88810a89c000 R14: 000000179647991a R15: 0000000000004e20
>> [  101.359718] FS:  0000000000000000(0000) GS:ffff88810b280000(0000) knlGS:0000000000000000
>> [  101.361627] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  101.362992] CR2: 00007f82b0154000 CR3: 0000000109460000 CR4: 00000000000006e0
>> [  101.364684] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [  101.366369] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [  101.368043] Call Trace:
>> [  101.368652]  <IRQ>
>> [  101.369159]  ? vkms_crtc_atomic_flush+0x2d0/0x2d0
>> [  101.370296]  drm_get_last_vbltimestamp+0x106/0x1b0
>> [  101.371446]  ? drm_crtc_set_max_vblank_count+0x1a0/0x1a0
>> [  101.372715]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
>> [  101.374001]  drm_update_vblank_count+0x17a/0x800
>> [  101.375107]  ? store_vblank+0x1d0/0x1d0
>> [  101.376038]  ? __kasan_check_write+0x14/0x20
>> [  101.377071]  drm_vblank_disable_and_save+0x13a/0x3d0
>> [  101.378265]  ? vblank_disable_fn+0x101/0x180
>> [  101.379296]  vblank_disable_fn+0x14b/0x180
>> [  101.380282]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
>> [  101.381508]  call_timer_fn+0x50/0x310
>> [  101.382393]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
>> [  101.383621]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
>> [  101.384849]  run_timer_softirq+0x76f/0x13e0
>> [  101.385857]  ? del_timer_sync+0xb0/0xb0
>> [  101.386792]  ? irq_work_interrupt+0xf/0x20
>> [  101.387776]  ? irq_work_interrupt+0xa/0x20
>> [  101.388761]  __do_softirq+0x18d/0x623
>> [  101.389647]  irq_exit+0x1fc/0x220
>> [  101.390454]  smp_apic_timer_interrupt+0xf0/0x380
>> [  101.391565]  apic_timer_interrupt+0xf/0x20
>> [  101.392547]  </IRQ>
>> [  101.393073] RIP: 0010:native_safe_halt+0x12/0x20
>> [  101.394178] Code: 96 fe ff ff 48 89 df e8 ac c1 fc f3 eb 92 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 e9 07 00 00 00 0f 00 2d 10 ee 50 00 fb f4 <5d> c3 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 e9 07 00 00
>> [  101.398541] RSP: 0018:ffff888107aafd48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
>> [  101.400326] RAX: ffffffff8db7b830 RBX: ffff888107a65d00 RCX: ffffffff8db7c532
>> [  101.402004] RDX: 1ffff11020f4cba0 RSI: 0000000000000008 RDI: ffff888107a65d00
>> [  101.403680] RBP: ffff888107aafd48 R08: ffffed1020f4cba1 R09: ffffed1020f4cba1
>> [  101.405361] R10: ffffed1020f4cba0 R11: ffff888107a65d07 R12: 0000000000000001
>> [  101.407041] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
>> [  101.408729]  ? __cpuidle_text_start+0x8/0x8
>> [  101.409735]  ? default_idle_call+0x32/0x70
>> [  101.410722]  default_idle+0x24/0x2c0
>> [  101.411589]  arch_cpu_idle+0x15/0x20
>> [  101.412459]  default_idle_call+0x5f/0x70
>> [  101.413405]  do_idle+0x30f/0x3d0
>> [  101.414185]  ? arch_cpu_idle_exit+0x40/0x40
>> [  101.415188]  ? complete+0x67/0x80
>> [  101.415992]  cpu_startup_entry+0x1d/0x20
>> [  101.416937]  start_secondary+0x2ec/0x3d0
>> [  101.417879]  ? set_cpu_sibling_map+0x2620/0x2620
>> [  101.418986]  secondary_startup_64+0xb6/0xc0
>> [  101.420001] ---[ end trace 6143b67a4d795a3a ]---
>>
>> Daniel Vetter (1):
>>    drm/atomic-helper: reset vblank on crtc reset
>>
>> Thomas Zimmermann (1):
>>    drm: Initialize struct drm_crtc_state.no_vblank from device settings
>>
>>   drivers/gpu/drm/arm/display/komeda/komeda_crtc.c |  7 ++---
>>   drivers/gpu/drm/arm/malidp_drv.c                 |  1 -
>>   drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c   |  7 ++---
>>   drivers/gpu/drm/drm_atomic_helper.c              | 10 ++++++-
>>   drivers/gpu/drm/drm_atomic_state_helper.c        |  4 +++
>>   drivers/gpu/drm/drm_vblank.c                     | 28 +++++++++++++++++++
>>   drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c        |  2 --
>>   drivers/gpu/drm/omapdrm/omap_crtc.c              |  8 +++---
>>   drivers/gpu/drm/omapdrm/omap_drv.c               |  4 ---
>>   drivers/gpu/drm/rcar-du/rcar_du_crtc.c           |  6 +----
>>   drivers/gpu/drm/tegra/dc.c                       |  1 -
>>   include/drm/drm_crtc.h                           | 34 +++++++++++++++++++-----
>>   include/drm/drm_simple_kms_helper.h              |  7 +++--
>>   include/drm/drm_vblank.h                         |  1 +
>>   14 files changed, 84 insertions(+), 36 deletions(-)
>>
>> -- 
>> 1.8.3.1
>>
> I need the drm developers/maintainers to ack these changes before I can
> take them into the stable tree...  {hint}

