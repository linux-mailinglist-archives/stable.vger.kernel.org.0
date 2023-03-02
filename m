Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7CC6A794B
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjCBCFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjCBCFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:05:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8150E48E33
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:05:43 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321NAto0028228;
        Thu, 2 Mar 2023 02:05:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=No7NvmYp4k9eTO3W+3aW1Gre3AWX0a65fxA/x5owjZg=;
 b=AdP090biV8IQSkBCAprFLDuYGGi/5XhMrrxplFqIsyYUXZmx/v4tc524xkWJN4EPLgdN
 4sXQ5wpFTKVF0wRAXjpoW3pwdsnT9b0FS2lmgYNthZDtWAzLb/XismQNIJ0NoSPxKl9y
 eSjcsVYXFVR7dsMp2CFwuo9P/uJyVgfsuaFIvNGJt36YnimXFFNkzyW6JmWKF8ftS7u0
 0nneZq/6aFyerT65x5QszTeP1I0s/q7Gham7WE4oEVvqvQfjpvHtYDU/EkctKQbarhrm
 j3RK7wxP1xW5o2fFzusGuL8pM5+FW9PBrXEkUKxhtAqE01bYJrDRXKCAOujiaVqwd6DB zQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb72jbk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:05:32 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3220PQXT032264;
        Thu, 2 Mar 2023 02:05:32 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2047.outbound.protection.outlook.com [104.47.51.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sg6u3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:05:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KobgviVWbCUsDG+BvOcIWh6oIhxdmMe8ewm7VtucwRMnATs0hpUtfokCmatHBbmj8C0OMlvDRjS7Xm/7RNW0raep0j8NMg6s7DB6x7PVSbXaUqShoWRwG25haGH1z4sMw8Nio2N8dBms1tPkM8G79/cdTxP2OYXqyYclOXmGKyGIba7E6ng+tu/ErPYKwfyOxd7OQixi2uyB/s/C8haFwsrGCqr7p3usZ7w6oF12DT2ExpuAO5pgKbVeitNsXGUV017rF4N0/nhBRdLa3VaVPRKD3mqcOGqeHBX/md98WNUAvWx45ysHxFi0qYQmSerEJAs7NxNc2+LQ+wArhelrAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=No7NvmYp4k9eTO3W+3aW1Gre3AWX0a65fxA/x5owjZg=;
 b=ampue7ulQiNaEJe3RCkFSwZdd2wu6teUtQTLI3EX6o5qU6ss0HD3e0FozGMiJq12pp+OdqCqWplYzTTcyc4/x3dzMH0CswjZqlH/FlvXhB1icd2NF7pfHg1zkDQe/jwBoSZy8ZX9X/2aGgGpxux6coPgVVfLZc+sqKJPEiyI4McWHDwDk8nA1aEr/6UgU3eZqLg2XTWbOYSm0sEG9dGmxdO0m4NeUdUPAAPwPdR04EZ6Xa1HZW/8EW3P6lHUaR1GKSzTxOXYnA14u7VQQWCNLBNM5OGjbzAPe+2uMYDqVc/B68e4ROQJ/vcwKbNn00odpGBooUn+od/gKUm9cehi0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=No7NvmYp4k9eTO3W+3aW1Gre3AWX0a65fxA/x5owjZg=;
 b=j+YibkVWgC/jbGnJ1VQ0x4I35BGa2fyKccPJ35Tew15BfvdpqA/oOJJO0IYvZA0nzB2l/5RMkGbWHyEWamYVB9ONH8guycFo+pb5M7/IN2h10BzfKOiKZ7jVY76BVmZG6b+aM+/QpK61ft2yIPtCFCVERaOveG/F0LiPILwbw24=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 02:05:30 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:05:30 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 v3 3/5] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
Date:   Wed,  1 Mar 2023 19:04:54 -0700
Message-Id: <20230210-tsaeger-upstream-linux-5-10-y-v3-3-f7f1b9e2196c@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-5-10-y-v3-0-f7f1b9e2196c@oracle.com>
References: <20230210-tsaeger-upstream-linux-5-10-y-v3-0-f7f1b9e2196c@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::13) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: 824fb182-8c31-42f1-ecfc-08db1ac2992f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XIMI2T94IFQe0pLAGrV0H5f8N93+N8Ua0ZyOGjHZtKXpT/enq86KmEoIw9dWvd9K4fy0S8AifTHDCZzELCpN83PZRHid47RJDhNh+jF5tKMSS39tYUMdqR/HpAC4MvhTyG5vPK/hu1Pe0yx9oe6nWzMbqgvfAKAjibrq+ZdZCLUoIuvb+gWI4ayoVJKes+/JqSmCszyMWuf0ItvLRLnCQTg8WOqTspOBjIOhAMM/qWBoSM4wW5fBxs/gUWbhLVwxmu72JZQ7FiQKTbohsBvuKzASPv33aAvmffnzeWAIWZbA1gZbpeNTXWbaivnsUQd+YCWyilg0o6YVQcTI5RVM5LcBkSCg8JL5OfKfUhElXE4RQjJq2JliH5rW1T5Bd6SLItmXM+e3+Vw3U7byFrOSO+EV/YpCaYXoKwk9hIIuCukt6OBsriPNR9jLIoiakCpdcUlAD1VzZCEn8rZFJLbKVRPP+NxJrGJHTM77jj41K7RxixMG938Oc8hJZsSJ5E2MJXWmIvLb2H0ppFGPXOzbn8e1tajKcESbyPJKv3e9n53DlY2Cw8iAF4hyIoB76xuswNqagwcMOTq/azqFbdq3upQ/xhmDHQocyq7omnwHvBbeVk+Rr5/rYLl6E8ZroUxT0132jhE8ipWBAwb9j9rolbNqivfaXNhvJmcYx1/J9VoaphuHehZqmlDLDEkhpGdp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(44832011)(83380400001)(41300700001)(4326008)(6916009)(8676002)(8936002)(66476007)(66556008)(66946007)(966005)(316002)(54906003)(38100700002)(36756003)(2906002)(6486002)(6512007)(478600001)(6506007)(86362001)(26005)(186003)(6666004)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnJaWkFpTHZlTlE0OFJzczhFZDkzVFVtc2NIZTkvSC8rbzRQam01VUYzK1lk?=
 =?utf-8?B?YlZuMFVWZGcwV1FhOTYxeXJSQmRYa1Z1YndlaHAwbFBzdUhLaE9vbDI0OThh?=
 =?utf-8?B?dThEcXk5YmEybkQ2M0hnU2VLeXZNRGFDZ1EvckxacFpEa2ZTNDBBUnNacmw3?=
 =?utf-8?B?aU5XSXcvWldNUGNzTStzcG0vd0dsQTI3aitzTXYrZ2F1cCtEbnc0V2FIWWJB?=
 =?utf-8?B?c0RleFVwNkhqczU2Wm1oMVViTDBLTk5EQWtISEhXaWFQTWtScVlFRVp4ZlJM?=
 =?utf-8?B?RU1wWnVlNStrMitycWoxTFVndVZwOWlIQWd1OGJLWGg3ZUNtMjl2U1NRekdC?=
 =?utf-8?B?QW54c0JNaFF6M3lXRWdsNEVxeG1DblExR2syMGFUak9lRVFzY0hSMmlMZUlT?=
 =?utf-8?B?ak1QY0lNK0draXp4elNxYXFnY2hFQzlpT0hSS0JTei9pOWlTd05kWFg3Nm4z?=
 =?utf-8?B?dTFBbEdUb0FzWCs1Ti8xWXJvYmJmQWVwTmhjYXZKdlJPTWZBbDBLbk5RMDVD?=
 =?utf-8?B?TnRLeFpBNTBKblFxMjJnRVNVeVgweXFVQUxodXgyczhpdlUzd0puR0tETmlI?=
 =?utf-8?B?c1hKZ0ZUdENKNDR4ZzVvQ2U4QXZwM1pSYW5VYUkvdjJLcGkycWR4eTBIY0Nr?=
 =?utf-8?B?QnVOeVE1bDN3SUwyd3pDYXV2ZGkreFNKdXMyVzk4OTJEV2lxaUE0bDM1K29H?=
 =?utf-8?B?WHV6REFROCt6M1RtVnRwdzJZY1p2T1paM2NGRW5KYlJjajkvRGxZRGxpOWxt?=
 =?utf-8?B?emx1ODlOR3BoekJtb2F4OGVNK21TaW5iQ1YrZzhDNlZVcWZRbzFjMGd3VDhH?=
 =?utf-8?B?ZUVQbVRweExjV1FzSExZL0Nsb1dHWEtPdWhEVXdNQVp1aU10VE1KYTZ0SktI?=
 =?utf-8?B?VTZiUFlFcGN2QTltZEkyVnBBaXkva29ONHlPRTVxSUxwMysvazBQZzI5OW1D?=
 =?utf-8?B?WTYxa3hQeFRLVGlLYzdOSWZaVnZpZ3RSRFJOaGI3bllkTVR4UFl2KzFoTFN1?=
 =?utf-8?B?Y3lLY2xHeXFZR0F6c2lRMFFYVlIvUGp0anRFSlU1dFcwakMzR0p1bTRmWjM0?=
 =?utf-8?B?S0QzUnFMQktwNmJBdkc0b1lqWWN3KytDQlNtQ2ZHQW1iTmd0Y3k5RUhSeUJm?=
 =?utf-8?B?amxFQkcvek5kSVlCR29teGxUZFJGcTl1TEEwS1F2MWloWXhGYWlpOVZmL2FV?=
 =?utf-8?B?eEJsbU1aanBoU1FwQURnTWRPT3cvb2xMWDRwT3hLOWV6RXVMTklWbFpxeGtP?=
 =?utf-8?B?NkszOTNBalRNdTByVXRrckZ3enpqeFNpUk10N1NkVjNjSkEzZXRHdGZ5SlhH?=
 =?utf-8?B?dnYrMXRqM2tOQnE2WjAwNjA3V1VqQjNHSG90cGRFV1pVQlZNTlRwYkRSVmkr?=
 =?utf-8?B?SzI0cnAwaFlqV01EVG5idk1GNkw2clN4aDBjVGJxMlNZNjBpcEM5ZUo2bkVo?=
 =?utf-8?B?b3M5bi8rSm9XR1QweE9YNHhEUGFLN3k3RDlFU1RuU3VZUUhmWkUzbnFya3pL?=
 =?utf-8?B?K203SE9yOWIyaTd5dXp5b3dyc3JqdnRJa1RzQkJHUmZwRFZWL1ZSSWF0Zkk0?=
 =?utf-8?B?SmR4TjFBZHJIWkIwbXZmVkxEbTNFdXhiZFMvL2V3akJvZVJXTzE4WkV3ajJq?=
 =?utf-8?B?TGxOZHJVS1JHWkpyZnJVQ1hOQzhqQktlQWtySExkeDdTRnZpdmowTlJpNmUy?=
 =?utf-8?B?Y1MrSDhsQno2bG9tdGozejVkWjg1MGc1L1A0Qm11clFHOEQyZjFoZXNCOWs0?=
 =?utf-8?B?UE1nalR2ak91ZzlPbk9qTWZCSXNnU1k1NjlVcXY3MlJLWjB1cmVHWjZ1eVV4?=
 =?utf-8?B?WS9YSW5WWUxLUjV6eUZ0MmRUK3pET3VKRk9ORURXNys2cS9DazMxRHVmZTBB?=
 =?utf-8?B?enBIeGEwTHNNN3JNS1pQKzk1eENsTGpDY3kvMHdKTFVNRzczWEJhTnAvWGZ0?=
 =?utf-8?B?eUY1bFZWcFVNRURaRWFxc1ZZQUN5Z21DWDV0M1B6dStyaURjank5RGFmbERo?=
 =?utf-8?B?d1plUGtZb2hFem5rWitOQUdjVFRhTExuVGRVY3RGREl4U2pVSHI1YXVza0VF?=
 =?utf-8?B?WlplZHlTb2F4a2JudHRXekF5RGhrVHM5SXFqODFJQkc4QjFTQ0hTZk1QY1Q3?=
 =?utf-8?B?THZzeHNYOXpKNnNIR3gzS2VuaUZOVXlwMDNIZncvZ1pUQ1YwVXFDci9JdUlF?=
 =?utf-8?B?VkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lzaYXabRnjsg6gS6xTrDK1JYbOi8aQDOiMpgTuRsJIR5qozxa24+bXLAMing5q+CSuXuTaNlIJTnpOqSL74ejMoAjHF8/90c4j4cZ26bOFVb16W3BP4x9DBjfq6MMKC3BAJBt4bYqvy8zYzTlh6n4B4wHWcCLCmQmz9w7CeXxRc4MgSZB85y7DGcU44cwMD7iqyOLuoLLTeD1mK8/siNCycKPQPIyqEGeOfDZY7Rtkk9mR/cz76xo3i9SsiDIDIxvmCxKY5K3owF4XrwsFklnTSJ9eEkDRMkvC5dVAdhDlNu09SLHd2+jLHMPKF3IweE6CQlnqrU6yQZMaxZYEuWwdSMtXmKURt6hvvA1kvFK81PaREHYuprpl966Y0gmvDa7xG6TpDkc0L2d+IOwpa/uvSDFQJp5byPNML2MlGSEgXt3To9k1+k6EcQP6a0l63Kz6XDZ7Pv1PMEBZhlunBM8slV2X1TMM6SrNn22krX1vzuux7xlYVizDmpjX0yOlwqkdVAFVKabe31xmeVGdO5t/QKJ7L0xPF3gZXGcMIsyje1Rkwcb7UsGJ82npsfAxrh1yq3zezuom0DRWf4DdMy+XB/NmGw26vbU24DzD+woryJ56BbJKoSd2r4qo7yCi4CHqVSOzOo8BILiiN25ljdF2sZSyYeiSpe30JbERh0T8s4ekNSr0iM9HF+iVf45ztrrNf9yd6rclGffMEvdgu4D6iJUMhb8f/M9F/7ijIi3inB75buVTB0DrinXXLix0CnEbBjj23BHKy7guyV7mJ7O8bLjYVH+EwD77YiRUOGxvDqqT06LLuI4unGjxcemDr2XV1eij0BRcFr+mIiAvsBwTyISpM0NGjSTKH2zHuWpYTOdcTTNqn5uoDmJKCcHBtt
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 824fb182-8c31-42f1-ecfc-08db1ac2992f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:05:30.1120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kA+yY0MAowlCDKse9wj0oXYWyjrk3PM2vdZbb+3AIrtS+kDqsa6KbMhyL1d+DQN/gJ0GMB+2nBMkyaU6XF7rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020015
X-Proofpoint-ORIG-GUID: gtTqM51d8lqvvdvhTMSI3mihxsRnF57X
X-Proofpoint-GUID: gtTqM51d8lqvvdvhTMSI3mihxsRnF57X
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 07b050f9290ee012a407a0f64151db902a1520f5 upstream.

Relocatable kernels must not discard relocations, they need to be
processed at runtime. As such they are included for CONFIG_RELOCATABLE
builds in the powerpc linker script (line 340).

However they are also unconditionally discarded later in the
script (line 414). Previously that worked because the earlier inclusion
superseded the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 137). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier, causing .rela* to
actually be discarded at link time, leading to build warnings and a
kernel that doesn't boot:

  ld: warning: discarding dynamic section .rela.init.rodata

Fix it by conditionally discarding .rela* only when CONFIG_RELOCATABLE
is disabled.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Link: https://lore.kernel.org/r/20230105132349.384666-2-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index e3984389f8ef..fabe6cf10bd2 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -379,9 +379,12 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .rela* .comment)
+		*(.glink .iplt .plt .comment)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)
+#ifndef CONFIG_RELOCATABLE
+		*(.rela*)
+#endif
 	}
 }

-- 
2.39.2

