Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A721636A3C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 20:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbiKWTzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 14:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239054AbiKWTz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 14:55:26 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA77266A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 11:54:45 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANJeVhV025076;
        Wed, 23 Nov 2022 19:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=sflJeV2wVdwMlYQjHBj0SDRMKKm7Vvcf9pXWfqqZHi4=;
 b=rV1TdDtLwPoLWookHAIwy8QkJXbr1pCHtM1UT1LVK1QLyHrcSnhATpj3VF1QOcgH97h9
 aINT72XgiKlSC5xNlShJXs76+odgDqYOQ+X84yUVESniaUzYVVRAIhDmTCpzH2XrCHIN
 Yl6RkhMBl7V2sZUI/kR+X+8KLGhmCU5mhAe4tLjoinS1xJRqldgoHA3AvAuHmiBXiw49
 KQYto2QAhxz1ECN383sGA1ExB+QQKTSEiFz2Xc6iX1Oe7lDDk3Obj5pXxsrzrGlynfYu
 rTXbg/+rALOWVHkC++1jDQ+JhMz669JlJGOARYCsIdclnPHopfVvmv+8k0pvovw2RXN0 2g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1svgg13h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ANJMRHa034540;
        Wed, 23 Nov 2022 19:54:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkd3rvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xj/xgNxNscs4NRolLxqbVHApxXANwHgo6Dkufej+54lt25sqwQWDUaBPjGdwIW7DQbGh0bQROEGSyT558J/DIeZwrX4J20IBOmVL2c7sOZ7wbXKZjs1nDHMibz6nekdcoX6bknhWJZrQ6Sb4oD3h2UhG+b0/heym9BmEKRc0mx9z2taAeEYG9GVkP4G9gZT4TmLfJLnOnP3dMbN+h7J50SMQ7HYJCpZI7hJrFk5ZGzyT3e47q9CkalgGZLVxQGOLpgbGeEsKbEvBSZdWxqnOg71TlA67TjCWyY1boZ6bTyGHn93x7hIrcS88hENJiIKCXz09NlXK4xlU6rG85X3nyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sflJeV2wVdwMlYQjHBj0SDRMKKm7Vvcf9pXWfqqZHi4=;
 b=icaG9zjkBtGpXgzav4Wz/7AfhK3YZFhpCvLp4v+UbdccfkzkFMBomfmxcVTd0hyUvp29hsaDpCXzCBR8Ylq35Gs/4yoq1wOpPLbbMicP9b7LvDTWgn71He8tx57IrY2xnZBXdLkkRIGiR4VcMkJLy+0wj0ZHxT1FS46bEMrY31mXcfnv0M7rRwyMMK6ylvprDkUONltOaNOJoIQ0OUfSaCmbZd1DgGu9juKm+28TpMxbboE461L0kVceHZ2HIeVKmjh4jbkocO7JPDocNii/G6B7iI9g9WXPHD9WrW3bBGNt1Q4m5E+I27Aua9ySOnsHP67kKcCdW/U8UUeeODHFAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sflJeV2wVdwMlYQjHBj0SDRMKKm7Vvcf9pXWfqqZHi4=;
 b=luv8GtXgNxHkJoOSSUiIKnUTxfcvyQ65JHCVjn0k9Tyw9E+5yXEjrZrPc8OG/we1HJxZRq+aMAHw4xrvkxFwS8bC1cekw7p+FXcBIIFq5BRt7dLb3lqg3jNTttxFkg5dVblHkGCyO+w1hrXspkggy0rATrgA21eq8ka3JnoqXPA=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CO1PR10MB4753.namprd10.prod.outlook.com (2603:10b6:303:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Wed, 23 Nov
 2022 19:54:14 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 19:54:14 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     stable@vger.kernel.org, linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Oscar Salvador <osalvador@suse.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/6] mm: hwpoison: refactor refcount check handling
Date:   Wed, 23 Nov 2022 11:54:05 -0800
Message-Id: <20221123195408.135161-4-mike.kravetz@oracle.com>
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
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CO1PR10MB4753:EE_
X-MS-Office365-Filtering-Correlation-Id: 65b87bff-6824-4564-22c5-08dacd8c7f70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dLGvijTuox9Laxcu5WLjolJkHACsaD1IPu6ZPYXC7RqBrGxoCk3Mg0ySuCnfW+l/Y7bMa8BYTr9ixkBjKjUwm0lQu2lOlrr2j935899yKqlin1KP4Q/v2iB1W3sDLR9DrUEJv3iyc1Ij40EhcXX5b1qxueZnFMkZ6gwCJLTYPfVuHeBrDRj2rbmC9aDqqosZZy1ZEt7sBvbb4KcNazSO0aJwQ2Why8PmX9li6qvY76hiZ4YckAB3t6DgIJV0IsH8yoCVyBjvGYhAzb9jbG8ObaQbZedimJBJkLbCJ3r0zz6aaN4xVcIyEeM0yJigtbZAEZI7eqoqcVSsByVR4mvalp3+swGPcsWtTwO3xqcVuo70FvAYXxcGHfV+iU2oytxXsEHzeCm/AfCjvvqtwJqiERcYMNC3NVH6/E17vKjr6SwBQVgB6mPzZ+BE1cg0JOCaq61v6IrvCGpvRwcDCtqujcFULbmAwS60DToujBGeuoqWfjsilLHaCFBuL4Xs+HL55ZzarXWZBoxhBpwjiDEAMrB27rP5JmAhXuqXybc2bbxYygBYxQiV/uXIZVWYxWUQ+YxKmzAeTFklxtURhDKnb9V+Gsk1dC7OZLPRyxcJIDwm017aEI30Z5V8pYrFNp89bJMUo6OZC1gv3BxsXUAiEvBqJyiDLpe+lSPqAbgk844=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199015)(44832011)(5660300002)(66946007)(66476007)(6512007)(36756003)(8676002)(66556008)(26005)(186003)(54906003)(1076003)(2616005)(316002)(6506007)(41300700001)(8936002)(38100700002)(4326008)(83380400001)(2906002)(86362001)(6486002)(966005)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6h6+q42av9DUrLqa5OBrvjrLtKbHacik7y6eP7HwUVZtzkTgfaZyNOZxwqy1?=
 =?us-ascii?Q?Va66aQHReO4Z0469c9+lRgFyMKXfIquSVdrGB4oNQX6X620Ll0cXv/sexe9w?=
 =?us-ascii?Q?775z/6x+/sxD8LynkxYXmpQRncbplpFs7z7CZVtVpkTrm7Ta6TOiifa8Xpo5?=
 =?us-ascii?Q?smXsRHE2Q7eZJLxwjL6Z3uUhl/iJjbUm+eUyukGn4GlCnWgO63A2dImqyOYZ?=
 =?us-ascii?Q?lQ3g0tIzHQzKloDpo1z6SQu415ByztoTxXi4TPgRUGxfAAUI0FiM2GWxAGER?=
 =?us-ascii?Q?DI8yrj2ngb5qtS7tFmsTlT39cwQB4GjtEtWgeL+e0JJJgwBY37VwSZWhjiz2?=
 =?us-ascii?Q?vhoTTb2aU9lJj4v3goX6t30s0Mwi/af7ZsV6G9VvrgGXRZQCWXz96OccMk9H?=
 =?us-ascii?Q?52tyx6kOASBpWcEob/r6h72qcCPJLY96z7Qlr65VpgtcSNMbq8Y+sLtDD3e/?=
 =?us-ascii?Q?4iyH/2s2guoOsXwFNbZD9Xtb1HzOpMkuPjcvrTGu7fcT4+bgxMY9h3Pe2cuR?=
 =?us-ascii?Q?cxOcxXPuNvGjy7AEhGPqfvhrSDdS1rtI8BCOx1d8fC3kpgUucOmourrKqRmT?=
 =?us-ascii?Q?ZavkfOhBZ99pv4BsP4HzSxhgZ7TmAG8+N/0GhUGFBKl+nm2+8aWp8ncMTMQx?=
 =?us-ascii?Q?7fcyfCkt7sOccwKN3K0myjFbr7lFZb+hcppneJD7FcfTTkJDJ+kF9yCLXl81?=
 =?us-ascii?Q?SL0oYd9uFgDDcNaasDAXV7/8vxBfxe8UouJGQ3dEPK8R26keQEXQ2SpcGjT6?=
 =?us-ascii?Q?8Z8WU6vEEA18QCznAZ7buFpfzffoVcTcGcUciwOX4oGZkb3plWkHhTUL+yms?=
 =?us-ascii?Q?baomrNxEcquIg9jIpgvVFhD8NlaWSMCzKNqTehuBqe47jzpuR2QA3ZwDtRUr?=
 =?us-ascii?Q?HR/aDXSCR/zYdNE7xG5/owisZt7m2mV9gM6G7WL48ju1QFq+bZu2rsrwEtdz?=
 =?us-ascii?Q?7BeOvWyo8PqyBtuqFZSFNfYqBKDa3YsC7V3lZYujAtCmvV+qmc6HCnEYUSHj?=
 =?us-ascii?Q?Xm5OhzRPxR/LUXzfM0thmAZ7EQk3gU1ExQ0SJTag63MR0cdJZL3NhCZM/Xbx?=
 =?us-ascii?Q?McTtFC1X8Rjy8P6B0K964jxGrAkxdAaGIY74G39ckY/5wVuUq5Xx7r4scjh5?=
 =?us-ascii?Q?CCqvhgA2N63D1//4V0aAoc0rx3FxU+JNxpF6bQJaF41SsHIlTy8fzUmTDUkA?=
 =?us-ascii?Q?8ItQlzmgNTYa+WWuueRWUDcqyD0NyBFazmC6hQ0ehiLu72lMdWGhW9vj6IW8?=
 =?us-ascii?Q?yNwipkpELsWpGFfFh+T/T+iarDTm990FLKrKxAfhGqG0MTpnOYlbFLVYpk+z?=
 =?us-ascii?Q?JOmmiO/b46dGl9G3oFW3Qi/rVzAlTxx/9rE7+2girG3iABSvh2IXrP6O4WMc?=
 =?us-ascii?Q?qSfDdgmhTCOyBsjz4JIIFacVC/tC0FLbSvV7RGxcZTM8zURgwQetiQpUkR9r?=
 =?us-ascii?Q?M8G4akE/YTV2JhACHeUvUdgUELb4tJnW3zpwNdPD8yDFgHIe71FMO6oJyUV8?=
 =?us-ascii?Q?E6PSVVbdc6RTNvUjmSv6Mj4lt/5W4LQ72RPDk1PnQyuC6NA4B51hJN4FSOU1?=
 =?us-ascii?Q?yMLv0NjynRJV1AsHDFnNhXuTRdoUkbxklNtlR1FHhj6ZKuSOV1VYNAU0imFL?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?h+hTF1UKvY8sM4E+Kf+t9+8Gal5iYPatBlypwDsE+mMt+Y1TGCcjjVyW+T7e?=
 =?us-ascii?Q?8kX+mt9tW7rB73/ZGw5x7rmJpF4lRcqMlO4fuMxlYazC7yV90jwzwBJEGLIj?=
 =?us-ascii?Q?UbREENAlEdvWykTzo7jtolHCW6Op+/w9rBQLfyZsBsRkOapsSPfMwU74oc7p?=
 =?us-ascii?Q?9aoGw2xU9cmmWxeIhBZP29CmdGwcu5u6dISq2ddwpev1vknGEGO2NCnUv89D?=
 =?us-ascii?Q?rvCJmLz0dl6NZSO4RHKd7Ionml27yWwY+EHR1AVEGyukmTx3GQnNJIUBjRCn?=
 =?us-ascii?Q?glcZOVFa8d/KjK4jND5ewppug0D/W2Vfhw4kQ9FmCpHVuI9I++KEMD6lqZWt?=
 =?us-ascii?Q?SX5BPc5moKwtdGRm8aEWYi482RrHMYvtoxtFvaINT4QOWWH8f75qeBXDJ6lF?=
 =?us-ascii?Q?x5zA5CCmk9m2QARrLPqVSucwgpo0pa/KGv/BlbVzT5NTdw586ZS+p4a9x0yS?=
 =?us-ascii?Q?08QIq+S5IZXWOH8+o0sOpjfb3T2eIxHK8PjcOmFG7fyk4nrMPabE6kCCNcek?=
 =?us-ascii?Q?hv8SPxpMCOSw1Fj+JjzPG9HTL0cEahHitiRkals+AWOE41iwpTi9ABVj8QKr?=
 =?us-ascii?Q?MbmAWgPjKNZO7XYfmvdQf8cQiVjF6XF8TU+4tJXfqz0OvUX9nfZDl5y5zWnB?=
 =?us-ascii?Q?iH9sBvnlUAQZEMB0H+jdkhNbJ3pxP6NKVW0B+dSSXnqLaC0sacssBu0CEhJB?=
 =?us-ascii?Q?tA2l14Fz7djVw7Pg/sRSo5c7VPEvlLBoJm6uhcdqpKNZG97ItHwL/KT8OCRH?=
 =?us-ascii?Q?TITpaYI4pA+ivMMxTgkaS6AdnmKb794dzgT2eumx5QYAlsydRaNdxvZOB4oZ?=
 =?us-ascii?Q?ExMAGwVYbu4RKSGIwja6y5nQYVGb9ORjxtpXvoKfB2K30QMaqkq0dx6547va?=
 =?us-ascii?Q?VCljzn8ZxY6VCCdgk5J7FSQuEFESIiCUXCb294S3eN/n3UxUOrUsgmxwF4EX?=
 =?us-ascii?Q?Ln5bNiSnIxn7tCQuG1QCePeLPRmbQ4DvxSrAPOhD/imdTAphcEP5q3n9wnom?=
 =?us-ascii?Q?1aDKuMco0WzayeQVf3sdPk7sPA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b87bff-6824-4564-22c5-08dacd8c7f70
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 19:54:14.5860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdpQQRrUD3fnN886AAj2I2oyIfIyy8V9N9SnXIlSz3oQvbkRYhBv17ORKHHJjirdDY/W0QA0Ngj4ueMJiRZe9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4753
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_11,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230147
X-Proofpoint-GUID: k_b8goxUQzNKjstAFDGcU8qvB_ESdO5j
X-Proofpoint-ORIG-GUID: k_b8goxUQzNKjstAFDGcU8qvB_ESdO5j
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

commit dd0f230a0a80ff396c7ce587f16429f2a8131344 upstream.

Memory failure will report failure if the page still has extra pinned
refcount other than from hwpoison after the handler is done.  Actually
the check is not necessary for all handlers, so move the check into
specific handlers.  This would make the following keeping shmem page in
page cache patch easier.

There may be expected extra pin for some cases, for example, when the
page is dirty and in swapcache.

Link: https://lkml.kernel.org/r/20211020210755.23964-5-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/memory-failure.c | 107 +++++++++++++++++++++++++++++---------------
 1 file changed, 72 insertions(+), 35 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b6ab841d1db7..0f77ec1985dc 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -650,12 +650,42 @@ static int truncate_error_page(struct page *p, unsigned long pfn,
 	return ret;
 }
 
+struct page_state {
+	unsigned long mask;
+	unsigned long res;
+	enum mf_action_page_type type;
+	int (*action)(struct page_state *ps, struct page *p);
+};
+
+/*
+ * Return true if page is still referenced by others, otherwise return
+ * false.
+ *
+ * The extra_pins is true when one extra refcount is expected.
+ */
+static bool has_extra_refcount(struct page_state *ps, struct page *p,
+			       bool extra_pins)
+{
+	int count = page_count(p) - 1;
+
+	if (extra_pins)
+		count -= 1;
+
+	if (count > 0) {
+		pr_err("%#lx: %s still referenced by %d users\n",
+		       page_to_pfn(p), action_page_types[ps->type], count);
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Error hit kernel page.
  * Do nothing, try to be lucky and not touch this instead. For a few cases we
  * could be more sophisticated.
  */
-static int me_kernel(struct page *p, unsigned long pfn)
+static int me_kernel(struct page_state *ps, struct page *p)
 {
 	return MF_IGNORED;
 }
@@ -663,18 +693,19 @@ static int me_kernel(struct page *p, unsigned long pfn)
 /*
  * Page in unknown state. Do nothing.
  */
-static int me_unknown(struct page *p, unsigned long pfn)
+static int me_unknown(struct page_state *ps, struct page *p)
 {
-	pr_err("Memory failure: %#lx: Unknown page state\n", pfn);
+	pr_err("Memory failure: %#lx: Unknown page state\n", page_to_pfn(p));
 	return MF_FAILED;
 }
 
 /*
  * Clean (or cleaned) page cache page.
  */
-static int me_pagecache_clean(struct page *p, unsigned long pfn)
+static int me_pagecache_clean(struct page_state *ps, struct page *p)
 {
 	struct address_space *mapping;
+	int ret;
 
 	delete_from_lru_cache(p);
 
@@ -705,7 +736,12 @@ static int me_pagecache_clean(struct page *p, unsigned long pfn)
 	 *
 	 * Open: to take i_mutex or not for this? Right now we don't.
 	 */
-	return truncate_error_page(p, pfn, mapping);
+	ret = truncate_error_page(p, page_to_pfn(p), mapping);
+
+	if (has_extra_refcount(ps, p, false))
+		ret = MF_FAILED;
+
+	return ret;
 }
 
 /*
@@ -713,7 +749,7 @@ static int me_pagecache_clean(struct page *p, unsigned long pfn)
  * Issues: when the error hit a hole page the error is not properly
  * propagated.
  */
-static int me_pagecache_dirty(struct page *p, unsigned long pfn)
+static int me_pagecache_dirty(struct page_state *ps, struct page *p)
 {
 	struct address_space *mapping = page_mapping(p);
 
@@ -757,7 +793,7 @@ static int me_pagecache_dirty(struct page *p, unsigned long pfn)
 		mapping_set_error(mapping, -EIO);
 	}
 
-	return me_pagecache_clean(p, pfn);
+	return me_pagecache_clean(ps, p);
 }
 
 /*
@@ -779,26 +815,38 @@ static int me_pagecache_dirty(struct page *p, unsigned long pfn)
  * Clean swap cache pages can be directly isolated. A later page fault will
  * bring in the known good data from disk.
  */
-static int me_swapcache_dirty(struct page *p, unsigned long pfn)
+static int me_swapcache_dirty(struct page_state *ps, struct page *p)
 {
+	bool extra_pins = false;
+	int ret;
+
 	ClearPageDirty(p);
 	/* Trigger EIO in shmem: */
 	ClearPageUptodate(p);
 
-	if (!delete_from_lru_cache(p))
-		return MF_DELAYED;
-	else
-		return MF_FAILED;
+	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_DELAYED;
+
+	if (ret == MF_DELAYED)
+		extra_pins = true;
+
+	if (has_extra_refcount(ps, p, extra_pins))
+		ret = MF_FAILED;
+
+	return ret;
 }
 
-static int me_swapcache_clean(struct page *p, unsigned long pfn)
+static int me_swapcache_clean(struct page_state *ps, struct page *p)
 {
+	int ret;
+
 	delete_from_swap_cache(p);
 
-	if (!delete_from_lru_cache(p))
-		return MF_RECOVERED;
-	else
-		return MF_FAILED;
+	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_RECOVERED;
+
+	if (has_extra_refcount(ps, p, false))
+		ret = MF_FAILED;
+
+	return ret;
 }
 
 /*
@@ -807,7 +855,7 @@ static int me_swapcache_clean(struct page *p, unsigned long pfn)
  * - Error on hugepage is contained in hugepage unit (not in raw page unit.)
  *   To narrow down kill region to one page, we need to break up pmd.
  */
-static int me_huge_page(struct page *p, unsigned long pfn)
+static int me_huge_page(struct page_state *ps, struct page *p)
 {
 	int res = 0;
 	struct page *hpage = compound_head(p);
@@ -818,7 +866,7 @@ static int me_huge_page(struct page *p, unsigned long pfn)
 
 	mapping = page_mapping(hpage);
 	if (mapping) {
-		res = truncate_error_page(hpage, pfn, mapping);
+		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
 	} else {
 		unlock_page(hpage);
 		/*
@@ -833,6 +881,9 @@ static int me_huge_page(struct page *p, unsigned long pfn)
 		lock_page(hpage);
 	}
 
+	if (has_extra_refcount(ps, p, false))
+		res = MF_FAILED;
+
 	return res;
 }
 
@@ -858,12 +909,7 @@ static int me_huge_page(struct page *p, unsigned long pfn)
 #define slab		(1UL << PG_slab)
 #define reserved	(1UL << PG_reserved)
 
-static struct page_state {
-	unsigned long mask;
-	unsigned long res;
-	enum mf_action_page_type type;
-	int (*action)(struct page *p, unsigned long pfn);
-} error_states[] = {
+static struct page_state error_states[] = {
 	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
 	/*
 	 * free pages are specially detected outside this table:
@@ -923,18 +969,9 @@ static int page_action(struct page_state *ps, struct page *p,
 			unsigned long pfn)
 {
 	int result;
-	int count;
 
-	result = ps->action(p, pfn);
+	result = ps->action(ps, p);
 
-	count = page_count(p) - 1;
-	if (ps->action == me_swapcache_dirty && result == MF_DELAYED)
-		count--;
-	if (count > 0) {
-		pr_err("Memory failure: %#lx: %s still referenced by %d users\n",
-		       pfn, action_page_types[ps->type], count);
-		result = MF_FAILED;
-	}
 	action_result(pfn, ps->type, result);
 
 	/* Could do more checks here if page looks ok */
-- 
2.38.1

