Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650C3636A41
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 20:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238957AbiKWTzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 14:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239157AbiKWTzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 14:55:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C447226E1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 11:54:35 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANJdvjT024628;
        Wed, 23 Nov 2022 19:54:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=xm2gMD3T23PmdDrhDiJoTHFKsv2XmtVcmY0IcP7Q4Qc=;
 b=V5hCnPkCGDGo/racu7sqejLUjrlv/dJfkfZvIbv2rz3tw7nW6oYSe2gi7cbAPXrkUSYW
 QRMbKSge7nRCvn+xgsQwYUTgogoBogqGeittvtdGubMWwnCduxX+/zHdJg+dZdeVI7l7
 fN3gQ/AtEqJ4S30zY69XOofDrzJN4vAxkmzTOMmP52kZRXna4mfpwUZaRvoHaRNDGT/Z
 e4n5LhR3Vqa/3J2ZYkvwFJt5fVBj0oNrCO6Vd8e0i2PJA0IHnldFo8LeEPxka519nUux
 TFIZTgrB7HkArRhQfep4HPGRi6iJJys6PezpBVwJgmKEXj3z934BLfbldTg7J2cBvt16 hg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1svgg136-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:17 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ANJESJk009343;
        Wed, 23 Nov 2022 19:54:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnke3bqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTcATirmCZ34/ltlIvhHPhABseorj9xXkQFxk25Vcsme7XiMXNaITs8NsAmTnCwF3gNnFWgSxKdQAK+NCXqxwE35F/D7G8noHzcgesYO1TI5yv28oJhJPDuPlWLicui70Uob72fUPO+eEm0VYg2MSCQdBQb0ZVQyQNa1bPdUZt3+eJOaIsDOy4FAB/n6YVTdFWQA38WRjEYfN9NBtXMBjkPm/iA9Axfekxe3JYfjAX16VzdIO1+j5sHaT/6TK1+ySaEbWHT5fsbxMaL71qAT0poA4IYDPcrziH+t4y8BrwFat3Am4dJ0p7yYWyZUo6LoX/fZ8UBXbVOMhtr+4gdILQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xm2gMD3T23PmdDrhDiJoTHFKsv2XmtVcmY0IcP7Q4Qc=;
 b=Gme5pSyW3NNkTxFSgoEA0rKUCetjlD6BeH88cAkJZaCOTM0Ze4QDoj2xDSdsrxF/3bPnkq8NkHgxdEg2K8Xc1iCSWdqSQgK24fAs3ie8xFwy1c33KTxdu9mGtILQAutDcJ6LWTDkL5Nzk+9blAoFbgcRnV+5cPPpto8dJiH7kIkbm7dGGuNnYDvPMrHcsCrQOFUrAl4gFIaU49FYle1K1Srsy+YPrVTc7IrPbP4BP8CgS+7KrrwOCWtjZlLspp0gd0JqZLmZqx9JuTVud+6melIn9vlKUMK6J+h/OWTayQ0vZo2JW7heewhKDB+8JRNNI1KGy92CPmISDfkbW8FEKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xm2gMD3T23PmdDrhDiJoTHFKsv2XmtVcmY0IcP7Q4Qc=;
 b=JM0l9Vd23CLpHWOm9KP6rVZDqj5qjAcPVdwibhRImZeAFKgwF1EJDpPBHuVTK1zKpx4N06/MnlV6AB6CrEz8Sqy1xe6D00LXO6yyYtBfuYFV4XY+lYtQ0/U2Xr0JVETIOQNHyHKZJeeaCg0nTH6NB0fUZM0JTbJNxWYq/Tu50ag=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB5671.namprd10.prod.outlook.com (2603:10b6:a03:3ee::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 19:54:11 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 19:54:11 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     stable@vger.kernel.org, linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Oscar Salvador <osalvador@suse.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/6] mm: hwpoison: remove the unnecessary THP check
Date:   Wed, 23 Nov 2022 11:54:03 -0800
Message-Id: <20221123195408.135161-2-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123195408.135161-1-mike.kravetz@oracle.com>
References: <20221123195408.135161-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0200.namprd04.prod.outlook.com
 (2603:10b6:303:86::25) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SJ0PR10MB5671:EE_
X-MS-Office365-Filtering-Correlation-Id: 31760501-9d15-4cff-3b07-08dacd8c7db7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HXp+OGv/zdBSxvFBBancl+zA3MHe+MxTd1eRnpYd3xnALVTNx+PEzhZYwFEPX/xvkqr8xYSW6KRnWIoNaonIUG8wo+YuBPt+xoVodnv81k11gV7s0YSrIg1dFifDdiAWuDEhlwtYL7dfs0u8ZyIYv66x791FNl4e3MWUG5pWNdPW+em6kKyJ+816v0A5upZFUJdRVrB+z/Xe1DA81AWozA7cXFA+DIyqUO4xjhn/ARabDdW6EBiJjUo3Xsa/+R8FjFPC6Hzx9HOHBNQ22QmVn1RYw8BpSucO6rGpS/IMbOuNLERfUbs6P3fkoSvc944uxPsSK6WUisDZwSJNTwIDi+gVctStPeBPt70qDN+ssOiG4wBS8pS51kpU0zOW/Eb8rIOhjE+umTWbsJ8zMNpetED4SE8WiwgqhPTALb+IJqxbdL1qf63sShT2gt2TDHZ0JYokUk04720z0GFJDkHOaoqU85Xg6ijwEHPmXU5bLqERAiwenc2qNN910j2rHioytM0QDx7XTdJjjoJC9YPvQFyynz6cTeHX8Wd65BCxLmwFgWkFi2WB9fhqrHx3lXqEIFeoeIcEvGS3G6SXpF2sz8LLUMuSroFbwhoOlXtnES3j2vPeWser3kfF0dOsZB+n/06L4ZEl+GOZGXkVxqUrUFVsX5h1hZT1MplsEEU6L/o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199015)(86362001)(36756003)(66899015)(6666004)(6506007)(44832011)(966005)(478600001)(6486002)(8936002)(5660300002)(6512007)(26005)(83380400001)(2616005)(2906002)(38100700002)(1076003)(186003)(54906003)(66556008)(66476007)(4326008)(41300700001)(66946007)(316002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?19rcDtdIVJruGfmRqED0n8q7sOQsjERmi1w9r587HW6xL/+LHfd7wUEM3w2K?=
 =?us-ascii?Q?R3G+UzLDrH5WlQTBqTe1CwAEMJ6busEft9tSe8CJqGWbFXjO/aY4wC/2y+Ps?=
 =?us-ascii?Q?JWf/OyaXz/ay4wik8kQ+z+YLcUruewb1tYqUs9E6JNjhMW+SzcamQsP6znQ3?=
 =?us-ascii?Q?++A6KBtoKkMHRejqX+IDxSMxQog6DPK5Lgml/11enQJlmaPFe+OOi/LTRjET?=
 =?us-ascii?Q?7fKcB56ly6XhLQ45BdQqP6Uk0e4z8je10HET8LSgVFUnIR7xxO9vvPVs+Gua?=
 =?us-ascii?Q?i0Oz3cbsflL+8lTyc9QvIWiM9Vh00rjtdhEGM+/OfL7Wscs7DJgHUDtljwYS?=
 =?us-ascii?Q?VdyFUOU7QDxjtxE/riZWmNk2vjfz/VocfnXfAAY7ks353U99XYoPBn7u9T2p?=
 =?us-ascii?Q?S7ioX4oqA2Xw3Lecmt5fvKnGSL0B0UNIu5ZL5/0ovxo3INLQPM+WJgGnRatK?=
 =?us-ascii?Q?4aLcmr5Do6wDh5Ctj0/GjlLHnR8jxmQTfvNJhyPm345Hh/t9iKSVUPDck++w?=
 =?us-ascii?Q?4fTn87duIHm4TPsEYtliNBdBp2v/jHe/rZk1FahDiEHItRgPj8MSUHk3oBsJ?=
 =?us-ascii?Q?a6/goShSmlzvrPZmfcWHhhoaWiOOLg0HtOsFAynBBKGBCLHTz6TQ1KjLWiXn?=
 =?us-ascii?Q?V6N2HRJUyt1AUMDOomqwinRqTbma9b+1qmAoDx1h49fJ0dOJO869Ye4nEZVQ?=
 =?us-ascii?Q?7iEPmCFzWvJwD9Ef7l4yW37g7Y7rmLQk7Q8YGVHHLsRrzfQq4WAbfwoM7Y1P?=
 =?us-ascii?Q?MkWXCozcJVaFyQVfMbvH8jspDYPFOxxKyisMuIDeLnh7M/KpVY9Lv5bu0PPE?=
 =?us-ascii?Q?uTRYVbiH4of9ZOeEXhX0ASUXBp3d2rQykftST+Oh40dxHImsp9irg9e7+h8g?=
 =?us-ascii?Q?IosU+aUAo8QH9UG5q2FqfB7W2Mx9gdK5bWIzLqjkTvZP+Ivs1J4QgMAZzDnk?=
 =?us-ascii?Q?2SQBQxaU7F/N+vt/RzfbkZ9SIWf11D+ZXr07n67VBZ74L/4rdtFQEapl/Zas?=
 =?us-ascii?Q?zKkuzloF4mzRWi0Oc37Vycs4WTHHKM/KV/qYxrOgeiP9aNDAcZhh+aaaqBPS?=
 =?us-ascii?Q?sJPyL0oQyJz3SzSfdaEmK21mwTjImKHpeKmKgYr6VaXfeHtrtjpqKouHch0c?=
 =?us-ascii?Q?fifH9bRIz2NuWcnglre38NG+78WA4aaRL4uFscTV5+DdF70c5Es+J7RMYTTM?=
 =?us-ascii?Q?9J2NT2j/qQHM+0xiD2bNO8lz3nSFmG4hUqYZcHkrtNQvxrYMiCHpqpBf9+0W?=
 =?us-ascii?Q?DNRumgHTHb3+g/1MC88VjRhFzt8JzZV3XLod2KU9zIX2Bb7AyBPswkpv85wR?=
 =?us-ascii?Q?wTo/amArjkqTdA5pknTf/CsXfVsXGJk9cDwSaTokWu7yiAz3CWSsEOo+te02?=
 =?us-ascii?Q?psFT2gS7pUq4Y6C0b0sBb2TTFQLYkdGi/0P06pRKgo4LNe3HI4xg8ay8XetU?=
 =?us-ascii?Q?LiL/T4f5bSKwwTNmozkeZvdpckeHiXfn12mEWTTRvzxxjBW34TjEMkJC/afZ?=
 =?us-ascii?Q?WhRqJTqiUUYzpvIwySw8smz7jAON0pj/HrhR8EVYe+hgKmInVvzVNKvlm9Oi?=
 =?us-ascii?Q?OnMG/+OQItj4ypOJOgyvcD91Z0zGg1hg1pfgqXOYBZiPWM18BuH9p/i1RPNc?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?pIbcec3b2fsYPfMbNNChpPE2y4+rlb7BwJ35nOSZIQux37yCfLMiC3DhtXS9?=
 =?us-ascii?Q?rguy1vMeB65F/bXkBy1fqKUHnUafaPnG4gzOfQP/CZtZWgI4VcxnqXsE8sSd?=
 =?us-ascii?Q?nHD0/eqqPuYo2XrHk6U8IUGaxF9UiJTL5MAgphFHLSeUTAuym9iD/t/Pxorc?=
 =?us-ascii?Q?TIUbc+hzpOPJNUNLjjq8SP46suYJcf9Yn53Hr4jYqR3q4N9dHKFPuww3OtUt?=
 =?us-ascii?Q?Sw41bL+uf52JkuJjOTOboVmSWe1pwQMwcT5Vu35No9DkAYokzz0U7KV70kDd?=
 =?us-ascii?Q?NzFbkc4kDS4rBM/8P/uhHkMsEIUb55wkRSGkR5EtE+uE6oAlX4b536+1qb4t?=
 =?us-ascii?Q?2Q4BN/JSluAKzEHK2nGUuOH1VTTnWQq+3tli2EqrzLkwTA1wzLUFV9xil5fc?=
 =?us-ascii?Q?+M35kxgFVoJV6dTPb5pJCfstH1VpTgf/ro1AFXOeJNWQ+qOaSVAXer4fuxoy?=
 =?us-ascii?Q?HJA4fbAw2ns2ogXF8irQfOZeARbVPNW6MdEDS51/I5GxJL6mDegJhPUG6slE?=
 =?us-ascii?Q?7IYPOaBM1qznU8Ygoi23ZR6hmE7X7Khm0xCKQUGEKf2F2YUV7urDoB4Vd82N?=
 =?us-ascii?Q?mfW+biy25e/O96QtmkvJhIVH5ZRAIzbgobI6sggu6dn4ietZW+jQhHH5nhs0?=
 =?us-ascii?Q?NOqAOJzOqTC0969gChreySS0J7cu6LZb4GsiPAWK6TUFNjutINQgH33YwS5b?=
 =?us-ascii?Q?bIdru6qVAaosNfu1902WRWnkMNhGzYRXswUEjkDx8IRJYXl2asvLqxC1LZbw?=
 =?us-ascii?Q?gYyCyFYImivSoGuys+zAT+ZkzewHDfP6d0NALSZaJSEK6BgLtdTz3l6PsB4C?=
 =?us-ascii?Q?7h+WQiuQhD926mM88QHc2KdixZVetTuKru+Yy1mQvs3xkcq7Kd0zIQ1vPQ8v?=
 =?us-ascii?Q?Epqc9BnGe46iJVyiz1amVhyXIg9+D5OSRIFWFT0FVXz8R4mPsWrhuJAoKv3C?=
 =?us-ascii?Q?qr8vnqAeRVNhPDD88sp6lPm6tThKmlNMmWu4rMqTHVtAk+hpRhmeXxGBCFsf?=
 =?us-ascii?Q?m6dBnEEhDe6kPzPBYZmIt5OKsQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31760501-9d15-4cff-3b07-08dacd8c7db7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 19:54:11.6809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OK9Poo/nMxNMpsTb5VjFTtFL4d1kUyKvET+MnbElT3p9vZOX+QZty/87dH/6uh9ol6YtZd9S8QQ8Upsq+nH17w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5671
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_11,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230147
X-Proofpoint-GUID: 16-2cSbv-Pc-ZfGHpBc_v8lKDWh_xREv
X-Proofpoint-ORIG-GUID: 16-2cSbv-Pc-ZfGHpBc_v8lKDWh_xREv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

commit c7cb42e94473aafe553c0f2a3d8ca904599399ed upstream

When handling THP hwpoison checked if the THP is in allocation or free
stage since hwpoison may mistreat it as hugetlb page.  After commit
415c64c1453a ("mm/memory-failure: split thp earlier in memory error
handling") the problem has been fixed, so this check is no longer
needed.  Remove it.  The side effect of the removal is hwpoison may
report unsplit THP instead of unknown error for shmem THP.  It seems not
like a big deal.

The following patch "mm: filemap: check if THP has hwpoisoned subpage
for PMD page fault" depends on this, which fixes shmem THP with
hwpoisoned subpage(s) are mapped PMD wrongly.  So this patch needs to be
backported to -stable as well.

Link: https://lkml.kernel.org/r/20211020210755.23964-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/memory-failure.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index aef267c6a724..ae8b60e5f939 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -956,20 +956,6 @@ static int get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
 
-	if (!PageHuge(head) && PageTransHuge(head)) {
-		/*
-		 * Non anonymous thp exists only in allocation/free time. We
-		 * can't handle such a case correctly, so let's give it up.
-		 * This should be better than triggering BUG_ON when kernel
-		 * tries to touch the "partially handled" page.
-		 */
-		if (!PageAnon(head)) {
-			pr_err("Memory failure: %#lx: non anonymous thp\n",
-				page_to_pfn(page));
-			return 0;
-		}
-	}
-
 	if (get_page_unless_zero(head)) {
 		if (head == compound_head(page))
 			return 1;
-- 
2.38.1

