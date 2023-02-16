Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C6A698D8A
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 08:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjBPHB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 02:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBPHB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 02:01:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919AEEC52;
        Wed, 15 Feb 2023 23:01:54 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2KAcv025733;
        Thu, 16 Feb 2023 05:23:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mozkxJjbFacCJCysvqsfcD8fy23AGaXOBuE0v0/srAY=;
 b=OHuMZdB3HjuT7tMvU1NDNUpRVJlWaHVY1g+RWY3+DbDcZrI7RiaPTJ7KBvbryCpJnOiF
 +0ES9UIM/N0K6LCMqtMZ4K54u04TlH+X8ED/eEMbEJRzqPcHoy02IZ8MYGrZTs+LFV+4
 Nmh9rpmHVZeq3u3HqdjM2GW3R1A0bgPqPfCfqKWlAF3P+UyULyttM0O0Fx2iYouh+ziN
 RjrMHkHvQmjUUL3tRzmP+OIMmeFmIbHI7pJH4M63uj9PzbH7uzlk9a6K74TDTBMPL7vG
 xWTVWlvRupCvNuIsde3Xzoyncz6v7Xcs8B1CyFIG9GEBZ30jyEDBgJDNhi02OnpFUbTp og== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m12apx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:23:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2c7r9016784;
        Thu, 16 Feb 2023 05:23:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f85xjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:23:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgifoxePiZ2P3WV3CJbFkP+bzwEgSFXjy61drlQ87XVavIDaymoJuSsVpiW+gseN9e5/es4IXX9IwgTOgTPom3oL4A5eGLwYT/rX07sJw3m7/8w1j03TX8qKbswyhk9F3+oUA7BeeSCtK7NvOcNtbyRyX+4mFdlBvOjSZczAJ41By4KDmCIOQVpxQEqezBb1/TdfkNNZXEwVP1GP5J82Kkhtk7K6DJc49+gF3yLnJd2+YqA22vuAffSnrplLCUlMf79DObD67E7EBwO4veJBKXEHmAH4SrSgRHiDWF4NYL1MC6BVzKeSqR98cN6seCcDEelXT3P8y6/VFGjp+MYP8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mozkxJjbFacCJCysvqsfcD8fy23AGaXOBuE0v0/srAY=;
 b=Wrn240MLVM8F26+J7z0gcdjJW3CjU7wO/UpJANA/H8kzKqfLdhg+oGgJ5JMKZ3jGN82hzssgvFwXhKskfwhhZVu1VuzmlnYhGo9wqC+4fsd6djI+1eRzp50z2olrJz8V6m6Y9SNDdQQO/mjnJCNHH01bU/N/Ysa3sAZD4/TKkm471zh8LsvSTMHygfNeCwKosSf/NWl8RU1Et9BphbQBCPbAqoAArelJc6OEJKYirAfU74P6O9BOiRFYiklsRfDCzMjwrVVQif0/VWyYL73Frbc11t0LO/8BuzBIXCZcg6gSZdI4hFAOJVw0k/j92TEaAt5APmzMxhvgV/RE/K9DLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mozkxJjbFacCJCysvqsfcD8fy23AGaXOBuE0v0/srAY=;
 b=oyjwPrXsWCDObRGWBAi6OktJF/naPclyE6ULxEjb4xl1mZ+dXPNlU9cBd2IACL1OjYeRyLfyDy7stkzpgFgeHfSN8lCBsnYL0pLCuJLgJCKLZeGavvnioV6KTzyRcPNKKKRWhLug6Mggs9LKBUURtS0ral9yzNUQdA0tsMx8gUg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB6631.namprd10.prod.outlook.com (2603:10b6:303:22c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Thu, 16 Feb
 2023 05:23:22 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:23:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 24/25] xfs: prevent UAF in xfs_log_item_in_current_chkpt
Date:   Thu, 16 Feb 2023 10:50:18 +0530
Message-Id: <20230216052019.368896-25-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::16)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 07f5c094-030b-42ea-de27-08db0fddebc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wttHFiABbAp7BpiBfFDHdIwpvYnU9tsf92/T72bvUX8NRbWyhIqG7A/h5Tx+bRnn6vfvwqB3TVMT7UZ7I6JvfZy2L1EMa3UeZEPcykm3fJm8TjcmWJQlTc55nV2kYAnzXS84FQZg7Ap5QdxD9HgGLeiyzMvfHGfDfobkZd2J/eXEt8+41FM77AoymbF8YEGB8D1UrKeQ8rztnvFpHoWrWNpvyFBfuNxYhHuHj9GY90qJEMENecjggKlwHcBiLmD5e5FD3PwZywcmpjM8caIZpou+CBLbALC9hQ5eFv4n7aD0piJBJhunh4acJMccj8Pn0izHgox8OsEpEe8+pazKCHQwIU7EjTEILzNlgVVUUxL2pwz+4GjBRtIcMihThEohRXtv+54cdqaC4+qGA5uBRmUi/dUKT00WWWbLhyog718Bu4SVGcOQtkjh2JMaTdPOGW5aDuOnuwGS/GLpGU4yYY0jqboZocfMk0+lYvTvyeFJhHiZAwBeE4D7m3mdUgwEQuNrE7fE4BxbjkhcZKCeIC8dvJK0hRXrpALLhpKmVg5Jkh/zee0YK3IjAYt7bVd5mB55e62tKLo0IW5nMro9k7iotuUpymBjpU+DyCncY1ibhU/+cfAs7CX+UwbkNpkmpqmr6Qm4lBEl5hs7X1+Oig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(26005)(186003)(6666004)(1076003)(478600001)(38100700002)(5660300002)(2616005)(2906002)(6486002)(6506007)(86362001)(36756003)(8936002)(66556008)(83380400001)(6512007)(66476007)(41300700001)(316002)(6916009)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uGm2xB33Xawh+1Fw78Ppm2p7YBqDppj058M67LxWit+HHLi/Bpa3tpi9un0C?=
 =?us-ascii?Q?4Jw1u09JNjuTH+RxIvN1Hy2jbQdMpfmUL7BzgRVYf+lCRbR8PGmPJDhE0/DX?=
 =?us-ascii?Q?S8imMAXC+kTSahOA2okevoiFO1/voi8aJq0xNljdDPmvcF4B+N55Z0OGEAO+?=
 =?us-ascii?Q?3DWA0h9i2iiyLFXpKwEWDpIqlF359cHLmScdl/vn7XCUJ0PltjPq/NPu8ORS?=
 =?us-ascii?Q?iKlMLuEz95Xyj4718twoP8nWe1JHcZgkaOoz1XrqdlE11xknwtlSfQs+bsWn?=
 =?us-ascii?Q?15UKjV0UHOblopas6HKY9Lg/8X+HqzTRXOLmxSQz+B/vmtd+9P5ulTxOGbXG?=
 =?us-ascii?Q?5nkKKTC2CYOI+iUng4k+rYhqcsae4QTkcVu9YCnI6GfXRwjWcejX9cdBRNbh?=
 =?us-ascii?Q?qQsK+7uAN/lZcYR9267xR0QWHqViHz27AvVLCd5t0GiOcz5zsczo1gx3jDak?=
 =?us-ascii?Q?V0fnYSpAbtnaREJNDppBeJ03GAlOghz/5ne45E51hmy7mpvIfyRPi2rmRYk7?=
 =?us-ascii?Q?a+01Lir2Cb/qmFIiQmudJBPbHHQw4L4kXAVdEeYF0LzKNp3h3jw3RfIksG0L?=
 =?us-ascii?Q?UAPxGxVX5LUKQgOlpGiZgc0I7kw8cyocaI78FPDItfhAQX8Retd54czOMwjq?=
 =?us-ascii?Q?/k1wpW3rF7OEjVZrXprHxMOH2oJSyDZDw6FYzqT+fzFJTz+/J3eVqUFIp/BJ?=
 =?us-ascii?Q?ZAvLnp1+TTZ+XXxL5CdNGKzbve+NOHabQpK4Eu/Z3CSLlFjf/8/mha2MyXKi?=
 =?us-ascii?Q?YM9so26Q2kMAnl4gYt1hN1mjOoiUrtayAyEN8VmUg1CPUfW9Um2pbNOxT8wy?=
 =?us-ascii?Q?Y6+qphYiZd0M2TJ5rZcB4d6pQjqd3PL1MczmHLhmn2frZwZOCFL0qh9XYswZ?=
 =?us-ascii?Q?0UJOF6SG2hSmATbC+QzyJL85V4hzMd24zttCb5/K5JX1y6dFKwXSJKuZ+/ka?=
 =?us-ascii?Q?QC8XOF405tSeJuz/RFXF9/A9Ba1fB5xcdqYrqpzDAK67AGgyQ5fieAiOjJud?=
 =?us-ascii?Q?ShMdleA/YrwisBecyihR7bA3yn7tbYdpUUBIGoOfq4ufbZzQ7TdoKpsA0QVO?=
 =?us-ascii?Q?IZ4oh0fGDnfz19gSaCBDJkwfCRMpahyv7s4O46oY8J/MSleVp/Nrz1kAhHfV?=
 =?us-ascii?Q?c1zDnJxRHhqakvCl69V9UNc2SuyxSCA5MJFmDAXwLIWJpMV9KJHgsfqRqPD0?=
 =?us-ascii?Q?KZlHfrg5i5ZbgLhfBZl12YvrTUERc3emSp32ohrKhzTabUTRasS5+/ZDO8qq?=
 =?us-ascii?Q?HCa0aylMVK58srZGm2bb7xr5PbEh/A4Q8TMNnaT4iuKCKndbZrf8tef5axTG?=
 =?us-ascii?Q?1hB89bPfqdpzYqEKhNIhZLph0zcjh6pnB7dW21TFIkWYKLxzqB44yrfvd2dI?=
 =?us-ascii?Q?llyouqMwvOdUz8aA3OsmlUbgBUux5jaAN23k02zYGDPvaKbCJVEKSOCX9wNA?=
 =?us-ascii?Q?faBlLEkYrWdB7y7JaMV+l6r3vawXK7h4UKtZRXnUS2NSk8WvZXXGvt9xpBcP?=
 =?us-ascii?Q?fy3tJB4AksG0ykickn83rB8A300djb4RQ2PQq/7ohE/VnXX1zI+slv33Ps9u?=
 =?us-ascii?Q?sAJ2k8C4X9w0VljkSk347KAcnHxiS7dhmxkOKBG0v+0Wy3S34I8gQ6glB5LX?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: i5FB5V+xMb7p3qC/+xOjB72UiMgpISxprqu78k49Y/1lbNkTJBC2m4WRgJay5N5dz4DfLrj/E4nu7OVP8oiaBkOvvXGFZd1pnQZj8PJrtbkn/9agU3gqPWxiB7cL3qzeZjcO47wegIxN3kY+6EISB9gDKNSkuFAR4CTfDyaw9eeGLN/te3EIHAOLMaf9rbfcGH22tbdE2hqoAVQHUR/SffURRjmm87AQrBCoD4ONsfUanqx77mkMEc6s2UHxSeCGkssWaBGcbjeumM38Czl34PX5zMxOMC3qih824d0U0fl9kU7uTLJdrgZ1FI7Ucs/D4cj97dPWGpzh8TDncURlVlh70j6rFw9Id0JfbmuXr6kJwS8nYBVeV+fuyl3MxTy8LauFZXDYXJXVloXSFrLIvubgg53CuRlOd/1eh9RqltR1Fxnry2/+ydgnvmSBuXZrhTE2ElbxlUM4mP8tJc4TI82ZL64Yy7HNqP1FaoCPqbVRVhs+ulTjPab6X+KuAAMD+P+zSY6rfqHUJbwBt/6B8IDweN9JICDrowtpl2zg0Upg51L53mtTdDeT8Nd71Q5T18eK8biUFRKbQksDO5s0xPa/y3llRAx5+Dhgxq0n81MIb7rqXTRBkDVi3S7bjmegvXYQxnDir82Lx537IeyfH748Dmatv8t5kMwKyFfWz+7s9PtbzxFTK/F76jHGP60ObHQCDX/2XpcbvnwlrfVTB/KJrHKE3LXgaVo2hPR4D5Tgk2MxtogN0Dr1WYQM1aOy4nXDM62SScXudLKk4uCjlgNufL3btVBWCNSvF399ovDRYjLB5hAFiya0n7mFTKHG73CKotIJf3+XzZw0XBrrWjr/ko5XX0G3CE/p0qACrkGqd376oCVUajhKBfE2Zrm3
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07f5c094-030b-42ea-de27-08db0fddebc4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:23:22.1731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbbhVaPpMqdLIwIOo4SpIfHTvyf1zAECpRwFxNLX/3a2ucs7tsEcbq1PatZYe/iIZRoRKuBJb7enjr5PVr9LQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160044
X-Proofpoint-GUID: EkxsLf1tmDYvmIYOfFMsiEmgTnhV34W7
X-Proofpoint-ORIG-GUID: EkxsLf1tmDYvmIYOfFMsiEmgTnhV34W7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit f8d92a66e810acbef6ddbc0bd0cbd9b117ce8acd upstream.

[ Continue to interpret xfs_log_item->li_seq as an LSN rather than a CIL sequence
  number. ]

While I was running with KASAN and lockdep enabled, I stumbled upon an
KASAN report about a UAF to a freed CIL checkpoint.  Looking at the
comment for xfs_log_item_in_current_chkpt, it seems pretty obvious to me
that the original patch to xfs_defer_finish_noroll should have done
something to lock the CIL to prevent it from switching the CIL contexts
while the predicate runs.

For upper level code that needs to know if a given log item is new
enough not to need relogging, add a new wrapper that takes the CIL
context lock long enough to sample the current CIL context.  This is
kind of racy in that the CIL can switch the contexts immediately after
sampling, but that's ok because the consequence is that the defer ops
code is a little slow to relog items.

 ==================================================================
 BUG: KASAN: use-after-free in xfs_log_item_in_current_chkpt+0x139/0x160 [xfs]
 Read of size 8 at addr ffff88804ea5f608 by task fsstress/527999

 CPU: 1 PID: 527999 Comm: fsstress Tainted: G      D      5.16.0-rc4-xfsx #rc4
 Call Trace:
  <TASK>
  dump_stack_lvl+0x45/0x59
  print_address_description.constprop.0+0x1f/0x140
  kasan_report.cold+0x83/0xdf
  xfs_log_item_in_current_chkpt+0x139/0x160
  xfs_defer_finish_noroll+0x3bb/0x1e30
  __xfs_trans_commit+0x6c8/0xcf0
  xfs_reflink_remap_extent+0x66f/0x10e0
  xfs_reflink_remap_blocks+0x2dd/0xa90
  xfs_file_remap_range+0x27b/0xc30
  vfs_dedupe_file_range_one+0x368/0x420
  vfs_dedupe_file_range+0x37c/0x5d0
  do_vfs_ioctl+0x308/0x1260
  __x64_sys_ioctl+0xa1/0x170
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f2c71a2950b
 Code: 0f 1e fa 48 8b 05 85 39 0d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff
ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 55 39 0d 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffe8c0e03c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 00005600862a8740 RCX: 00007f2c71a2950b
 RDX: 00005600862a7be0 RSI: 00000000c0189436 RDI: 0000000000000004
 RBP: 000000000000000b R08: 0000000000000027 R09: 0000000000000003
 R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000005a
 R13: 00005600862804a8 R14: 0000000000016000 R15: 00005600862a8a20
  </TASK>

 Allocated by task 464064:
  kasan_save_stack+0x1e/0x50
  __kasan_kmalloc+0x81/0xa0
  kmem_alloc+0xcd/0x2c0 [xfs]
  xlog_cil_ctx_alloc+0x17/0x1e0 [xfs]
  xlog_cil_push_work+0x141/0x13d0 [xfs]
  process_one_work+0x7f6/0x1380
  worker_thread+0x59d/0x1040
  kthread+0x3b0/0x490
  ret_from_fork+0x1f/0x30

 Freed by task 51:
  kasan_save_stack+0x1e/0x50
  kasan_set_track+0x21/0x30
  kasan_set_free_info+0x20/0x30
  __kasan_slab_free+0xed/0x130
  slab_free_freelist_hook+0x7f/0x160
  kfree+0xde/0x340
  xlog_cil_committed+0xbfd/0xfe0 [xfs]
  xlog_cil_process_committed+0x103/0x1c0 [xfs]
  xlog_state_do_callback+0x45d/0xbd0 [xfs]
  xlog_ioend_work+0x116/0x1c0 [xfs]
  process_one_work+0x7f6/0x1380
  worker_thread+0x59d/0x1040
  kthread+0x3b0/0x490
  ret_from_fork+0x1f/0x30

 Last potentially related work creation:
  kasan_save_stack+0x1e/0x50
  __kasan_record_aux_stack+0xb7/0xc0
  insert_work+0x48/0x2e0
  __queue_work+0x4e7/0xda0
  queue_work_on+0x69/0x80
  xlog_cil_push_now.isra.0+0x16b/0x210 [xfs]
  xlog_cil_force_seq+0x1b7/0x850 [xfs]
  xfs_log_force_seq+0x1c7/0x670 [xfs]
  xfs_file_fsync+0x7c1/0xa60 [xfs]
  __x64_sys_fsync+0x52/0x80
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 The buggy address belongs to the object at ffff88804ea5f600
  which belongs to the cache kmalloc-256 of size 256
 The buggy address is located 8 bytes inside of
  256-byte region [ffff88804ea5f600, ffff88804ea5f700)
 The buggy address belongs to the page:
 page:ffffea00013a9780 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88804ea5ea00 pfn:0x4ea5e
 head:ffffea00013a9780 order:1 compound_mapcount:0
 flags: 0x4fff80000010200(slab|head|node=1|zone=1|lastcpupid=0xfff)
 raw: 04fff80000010200 ffffea0001245908 ffffea00011bd388 ffff888004c42b40
 raw: ffff88804ea5ea00 0000000000100009 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff88804ea5f500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88804ea5f580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 >ffff88804ea5f600: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                       ^
  ffff88804ea5f680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88804ea5f700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ==================================================================

Fixes: 4e919af7827a ("xfs: periodically relog deferred intent items")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 550fd5de2404..ae9b8efcfa54 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1178,21 +1178,19 @@ xlog_cil_force_lsn(
  */
 bool
 xfs_log_item_in_current_chkpt(
-	struct xfs_log_item *lip)
+	struct xfs_log_item	*lip)
 {
-	struct xfs_cil_ctx *ctx;
+	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
 
 	if (list_empty(&lip->li_cil))
 		return false;
 
-	ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
-
 	/*
 	 * li_seq is written on the first commit of a log item to record the
 	 * first checkpoint it is written to. Hence if it is different to the
 	 * current sequence, we're in a new checkpoint.
 	 */
-	if (XFS_LSN_CMP(lip->li_seq, ctx->sequence) != 0)
+	if (XFS_LSN_CMP(lip->li_seq, READ_ONCE(cil->xc_current_sequence)) != 0)
 		return false;
 	return true;
 }
-- 
2.35.1

