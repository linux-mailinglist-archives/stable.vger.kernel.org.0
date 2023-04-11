Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E666DDF44
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjDKPNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjDKPNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:13:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2B46182;
        Tue, 11 Apr 2023 08:12:19 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BF1NOL018057;
        Tue, 11 Apr 2023 15:11:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=7IzFpQHbhMFR2jvJUXKGwCFDQ7UBaF9JNyoesl1gmJc=;
 b=W0TUsOiaL0DjPT6+GYoPEqLC0naYd5Xk2rEU4kZLiuZcx1/RpZSk1hlptCeHhYzo2636
 4i02csdURbRLNSXzjpWe61toz+b71419dt3OgM/Yh3dS998DAO3SMsOtSVZUcwftgL6b
 iwRYsinax/lz5y49NLjorkZTELCjwMTdHtKco42sIb8KnaysPVpx//ZLeRQcIymLx5nK
 qVVfEyRM/4MCGHM+SCaLVTwgWVvR/IKGPRESN5v4SXsc8WufUmp4Mqjogx/asjKj1YOY
 YMnhhpe/tuHs4+SywHVIoJI+MsTbOE3ggAOG6hMB+j6aWHQJasl+spkSk9jqu9ZkL3pq aQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0etnnuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEO7qR012831;
        Tue, 11 Apr 2023 15:11:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdp0y23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BL+Pu/joXANlO9FIY4XCuTepAczUI8Pw8sSnl1CG45O0DODuqmK13QJxSjkRDxF3RpFiBLfGcfE8fNZw5zMb1OLBGLtL7W9m0JPX4HSJWCdTM9McfCtwje6CYfLpHg0Sc6VTdq8rR0fZyoLcRTReBpaFeA88P5igybavVxxZmHJKHcWziMorGNDTTuHTTkOa3f6xUHX+sJ8/9/UDU07wGy2hSIuHkzY99MLcp8V6fg44RNkEvc+9QPDDPGYlJWn5vkegk5xdsro9a8M67CEaB5yDfMjr1YWyAYWGZc9UQ9B0MUHziOBUyIX4kMqZt6OPD7e1VRUhaycsQNbo1hcl/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7IzFpQHbhMFR2jvJUXKGwCFDQ7UBaF9JNyoesl1gmJc=;
 b=m/uZp0Olw22DQSjOp5gF2ynN3m32eUMAbimi4VS9o7y8rRFHizPzpOYZ6jRFoM34VOQAtoal3PzUGEKVctY4YWt+2nrcDU0YqWO59arB9TesTfMl9gwVUoGSBNbu6H0LPtITM1psHMYi5J5fqVrhy56x7uytL46T0VPPFP6aaU5CZJkzCtHmmDTo3akExWVuk1A20XsCwYsn3Ym8XTpfq+vL6+Bdh5qioHyF7VZXxZ69ZSn184B0VoBChCXXAWpvyZ3CJT4CzjwqVly8dDAzRRDBlBq+phMhepXmbJzdZRxJ2xGU3OYHduVg+9JDCvo+i30Ls+VmqLKrpxgOWIs/hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7IzFpQHbhMFR2jvJUXKGwCFDQ7UBaF9JNyoesl1gmJc=;
 b=TT3U3lXFLYYN3ZtV+qhgl0x6KavCAKjJvSmv+X17hFaLpaosbr/CIQqTABFSBTLzuYFB7/1I++kmKnbxoOA/sIRIwNwaSjtYedaWcuDjowcjX3angWZglv80US5SupYp+YRvZ5r3O9XxBRDTKbkLJSuh3+WRpz8DfTpZYCxI2wU=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SJ0PR10MB4718.namprd10.prod.outlook.com (2603:10b6:a03:2dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 15:11:35 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:35 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Snild Dolkow <snild@sony.com>,
        Peng Zhang <zhangpeng.00@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 06/14] maple_tree: fix mas_skip_node() end slot detection
Date:   Tue, 11 Apr 2023 11:10:47 -0400
Message-Id: <20230411151055.2910579-7-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::31) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SJ0PR10MB4718:EE_
X-MS-Office365-Filtering-Correlation-Id: eba02011-8ace-434e-cc6a-08db3a9f0aa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vJrh0+DPC773epiiSfgPJ7r58z85tEmkls4VTelvlJCnZ/8iwsZxjlvPS8gJbmV+ZVaGPxt7e7MBKlt0Z5SGjnpyUPyHS14JBpyhU/fXABCvsfBIQxcksjeeUuSujNnQypLaAhh8a3Npu7fqB5K89jPiIbp9W7rHDJ5V/BGvtrnIMh+QoYETjePCKln7q9tA/mx/lT7HFt10aKGo51fExqVl25oZVGypZrgMI4uhXOD5HOEXzFl6MiFBtmYIDKMo80M2SBSLTjGEOGvWudk4iYss1lyTGDUUeWefwSO0L8M069iWrJmskYSbWBG/fwTlsSGHIdvcGUuwgTA+mcVexonPpN6p2YYr0mZst4FgbFjAN/J6CAP/G1SwOPwa1q79JZQWdvM5CL+3qIcFNujA4kyPM4eqq21AgoYdNi+25ZVv3V0tnl59u81BY9HgDHdEUtEsQEVAE7hk8jtQnBQFLp0jGLU1Jnwd/Tc9UhQKS+S1B4OMKIREFL38TQIOtouEe0euakrSWOMqZxKwR5QS7VqFV5Tthrn+JxRp+mNo5XjliOygJSgRyAhNS8Q28WVYXz0AK5R5PdPEWFnMT83BeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(38100700002)(6512007)(6506007)(186003)(6666004)(26005)(1076003)(2616005)(8676002)(83380400001)(2906002)(6486002)(5660300002)(8936002)(966005)(36756003)(478600001)(4326008)(86362001)(316002)(66476007)(41300700001)(66556008)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5CsOkmSeTUMaxblAmBse1ZH2PFBRGG7IqUSZpxBltK4xebb4bdgqJ/lkqM8f?=
 =?us-ascii?Q?Pjx52j8KR5TQxSc9gXCZyWiZHDruYppSBLuDLlJxvWFbS/AAX6O/vlhLT2sZ?=
 =?us-ascii?Q?x4lL0E53dooqzJKMA5rFO4I2qFRrP9D05KaHD842HO0z1eywoMQyVIdopA+6?=
 =?us-ascii?Q?HsZKQ2kGfdeaa7QLizrTI/OiZvzDU1y0RrTxMPf+wlSFVZjrD2JmZfUaRoMU?=
 =?us-ascii?Q?eMY/DVNOmcRuVGPzB5XZfo4DF7gI9KHLYj5ljaCOpqkkAUdZp4mIEt7Srz97?=
 =?us-ascii?Q?54DUF6nbpQKpDmNXbHlgZ88eU5O0nr9SjR171BFapI54HZGh5njgXVMhhSz5?=
 =?us-ascii?Q?6vn4c/exue7eQpn64Me3im5hEBt9VJzdIN0VeP9DUp/7u6do0hWfvbVj/LLh?=
 =?us-ascii?Q?Puaf9/RpYE//hmwr/vdC7a8WpGBYqZ9N1ZZfO67MvE81O93o3awYCW/SwW8z?=
 =?us-ascii?Q?4g5p7KCkYxZ151CFvikoe6qQTnIZk/yO3o7ll2eAK//UQ1xYVQ2lNirxhK4c?=
 =?us-ascii?Q?LmBxYODhXmT0iy6+X5YXPdsQPRfHKFyZcfG6VrrYGZkXXt5J3eOsWRmkuFqz?=
 =?us-ascii?Q?syEDmEgPekiGKZSqQeCb4xjtbiL0ZtVSRUJyQPHqO+XCeHtYN8JjXVMbFDLq?=
 =?us-ascii?Q?IWu2q4ePnNoWGQt8cK4kjA7wIL1SzbLq/F61hE5Ha+5q5h2xnc+DV3AclIrS?=
 =?us-ascii?Q?eLf4bdn/szmYRckkdyndiR4WYgMasyoH6ISUDhun79pA1DN2hAP9g9Qo4exc?=
 =?us-ascii?Q?AWoIquVq1xTvcXwDjG8TpLhIsnLhbwGHp05s/eKbDaiZaii3JMvTG83eeoLO?=
 =?us-ascii?Q?FoUHmYmHKlYkujDdzDM499VxKI1DCHAmlpMD6nzxbLJ6Wu1tu3g/4plR/S5p?=
 =?us-ascii?Q?VwsX6DiJ49FcjkP0CvT8NVQpvgsuREsOsoVy/aTRp+Y1gRS9UO/OwmD0gpiV?=
 =?us-ascii?Q?BoqntM99H2uL/jSbX3rlY+7Ok+DT43/BkNqX8hkKhUNA5STg9zTp9WqRwjoG?=
 =?us-ascii?Q?L5swdrrK66tYnkYtqMXZ8KAGsowxTsiMtNMa6lMVg4jR7bb+ioSYP7kFe0QZ?=
 =?us-ascii?Q?C9niUf3riKdwvffZtnQ66E69YZDmcfGBzSZkn0qkAOO6+gYSfdJOOAcpEEmR?=
 =?us-ascii?Q?HZB0sS74kw6OINIR+xSe9RJXk24FbbxjxK57AKoMchUhmWH0wg6E5KWah5SC?=
 =?us-ascii?Q?9fMFd75+tUFSGdOEsxC84gcamcW58ZLJQNQP4Nbv4XJITPmQBzf1F0RDepTC?=
 =?us-ascii?Q?kP7iY4neYzCsLgCiMC7UkMNlZ8utzfkKEBcbFiqikEacNfqCM42RFf3qUOZ7?=
 =?us-ascii?Q?mYWp9fAKOrqJCXSvzN/PNSN9O9tTAdZeYhWeuw9yxSsQymDiMPv+52JRoZRq?=
 =?us-ascii?Q?QePO3D4p554z8r15I/+uatP4ZF6cAU36q8850qwZX9hbhI91zSH3uRsTbrBF?=
 =?us-ascii?Q?gT9msoNUO1J74LxoIU/vz2zblUxKbxBxZ70gju8/WuflHf7ERdi3Ry2dugHR?=
 =?us-ascii?Q?Lll0OAgwauqif4mAClPuOfRow5VSgwZWwY2QPboXKVPalbBdvFLVUid7CrIo?=
 =?us-ascii?Q?dY3nZOmu+dK63h0/EftqI6XE5tMzbnfK77TiokHz9sWa7YtT/C6fQe3BtGPk?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?XYGwJEsCKs5Rn4hLw2H30eEqq83L+7EM7llFK8iVznOf1UimNsAPpHNZrYfB?=
 =?us-ascii?Q?oSVoJ73UvdYfgsX7azc/KG1CnQEdyhJXlmLRIrR057o1Tyg4pSWMhIa9Ir3r?=
 =?us-ascii?Q?W4UGC2L4+HjCgVGOP/Bd+JVeDzWOYmfoTEFk52VEBnCyp+rBk/p7fxE+cF89?=
 =?us-ascii?Q?MIjMIenaaK3dbVgpvn3t/uclVkphzQMXqwGlRpJK+JjV+NOck1jsh9tmA0UT?=
 =?us-ascii?Q?k+L0qVU04dUkiSdb1DRL7yaO1iEky3pSgaqcuMuViaIjlN+hvdAzc8NcLUaM?=
 =?us-ascii?Q?fQ1N/c9ZDnhFdd34qtpxWP+cqn+VewIhf+ydjjWHuxU8zq5LhFyakfmCvK7Y?=
 =?us-ascii?Q?w/em29uiZtUTaR+6prM6/QkWHhMnREYjLGlkcU3SBBZWEj7TTs+xrveVM9HD?=
 =?us-ascii?Q?w7AxqzRPB3NekzAaIU2gVtP9Xy1i31wiQfThVnRrA28Wq5BS0bA2Zdgt4noZ?=
 =?us-ascii?Q?PyppU/9WL2b3VNsmMOO/hjddduWm5xF+kovp26BPvfbCWSkC2EtF18DPjfnu?=
 =?us-ascii?Q?I3aDeBdvrXUsDvzyqcwDm8HUpU9uyv2UMFnx0oio8IMeX0/p7jbLvyqFiWvX?=
 =?us-ascii?Q?XZOyDNuftw/V9/28v7jzCysAXUJg6uLucFyA3X77emS0H0UYE89DIQVozIAJ?=
 =?us-ascii?Q?s8Qgbzy2pKDngQrpcdC2oTUHx6dhj54f1szMZTiyWRoWqf0yElTQ/0rFnD8l?=
 =?us-ascii?Q?LueoFYbfJlTrMv9zk5jz2wl+VNnwukdIDQ7hwV4+sWhIsWzNeAxQfK3/Ui0X?=
 =?us-ascii?Q?FwA3rpegiAQsVttkFEh65ZLsaLTrqNJyIouL+0f2we0F3suK5SYvk7/LWPxH?=
 =?us-ascii?Q?oyZjEpfgg1Upv/wH/1mDh0n0N9a3C7eiDrtJjZBXeE+Y8j/Mg72/soz1skoc?=
 =?us-ascii?Q?s1Z0z1wePF9LM/URSWZ6wcXP9Uhf+yUnNTL2ZlXk5NqGLek3niI2swrodX65?=
 =?us-ascii?Q?EK6jw2flPWpKiRMq+P6gNlvodOiRnEbHUkwkeHlC8a1q2teWkWbW3uAH/UtV?=
 =?us-ascii?Q?1/Eb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eba02011-8ace-434e-cc6a-08db3a9f0aa0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:35.6995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dcG9uJQZzqQve0AAYGMKRhBF/CcdZQjb2/eAsVIjaIwZSJVqaCyUcSETejBCyL37n9HmL0k4zEUAlzOjYx7zfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110138
X-Proofpoint-GUID: Yml7GVUvBqtyMrgnU1N7r1iLqE8eFbJI
X-Proofpoint-ORIG-GUID: Yml7GVUvBqtyMrgnU1N7r1iLqE8eFbJI
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 0fa99fdfe1b38da396d0b2d1496a823bcd0ebea0 upstream.

mas_skip_node() is used to move the maple state to the node with a higher
limit.  It does this by walking up the tree and increasing the slot count.
Since slot count may not be able to be increased, it may need to walk up
multiple times to find room to walk right to a higher limit node.  The
limit of slots that was being used was the node limit and not the last
location of data in the node.  This would cause the maple state to be
shifted outside actual data and enter an error state, thus returning
-EBUSY.

The result of the incorrect error state means that mas_awalk() would
return an error instead of finding the allocation space.

The fix is to use mas_data_end() in mas_skip_node() to detect the nodes
data end point and continue walking the tree up until it is safe to move
to a node with a higher limit.

The walk up the tree also sets the maple state limits so remove the buggy
code from mas_skip_node().  Setting the limits had the unfortunate side
effect of triggering another bug if the parent node was full and the there
was no suitable gap in the second last child, but room in the next child.

mas_skip_node() may also be passed a maple state in an error state from
mas_anode_descend() when no allocations are available.  Return on such an
error state immediately.

Link: https://lkml.kernel.org/r/20230307180247.2220303-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230307180247.2220303-2-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Snild Dolkow <snild@sony.com>
  Link: https://lore.kernel.org/linux-mm/cb8dc31a-fef2-1d09-f133-e9f7b9f9e77a@sony.com/
Tested-by: Snild Dolkow <snild@sony.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 lib/maple_tree.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index fc3e22cff642..c50646fcb8ca 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5097,35 +5097,21 @@ static inline bool mas_rewind_node(struct ma_state *mas)
  */
 static inline bool mas_skip_node(struct ma_state *mas)
 {
-	unsigned char slot, slot_count;
-	unsigned long *pivots;
-	enum maple_type mt;
+	if (mas_is_err(mas))
+		return false;
 
-	mt = mte_node_type(mas->node);
-	slot_count = mt_slots[mt] - 1;
 	do {
 		if (mte_is_root(mas->node)) {
-			slot = mas->offset;
-			if (slot > slot_count) {
+			if (mas->offset >= mas_data_end(mas)) {
 				mas_set_err(mas, -EBUSY);
 				return false;
 			}
 		} else {
 			mas_ascend(mas);
-			slot = mas->offset;
-			mt = mte_node_type(mas->node);
-			slot_count = mt_slots[mt] - 1;
 		}
-	} while (slot > slot_count);
-
-	mas->offset = ++slot;
-	pivots = ma_pivots(mas_mn(mas), mt);
-	if (slot > 0)
-		mas->min = pivots[slot - 1] + 1;
-
-	if (slot <= slot_count)
-		mas->max = pivots[slot];
+	} while (mas->offset >= mas_data_end(mas));
 
+	mas->offset++;
 	return true;
 }
 
-- 
2.39.2

