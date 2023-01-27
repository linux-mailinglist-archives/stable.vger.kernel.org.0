Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C35D67EFC7
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 21:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjA0Uku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 15:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjA0Ukh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 15:40:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D831DB82;
        Fri, 27 Jan 2023 12:40:17 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RESge3022484;
        Fri, 27 Jan 2023 20:39:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CeCiDvFqoroZ+/6q+j2twNZ+6BumE63fnf6aTYkt65w=;
 b=L411uNlj+1juYsQAk55wz8K5+AcCno4hlJeTNxELeGamQm2YJvu31CVSCfkemKKfbqBA
 VQttQohBy4ezs0YFiTm1xkr8447DeYgSk9OuR+PgK4X8LEoOPeOVOGei6MYB6vr4P5PQ
 MsxPWXWZTqERAo0q1esqP/FNH4U4sctyWvhvFLFrti707bJruzZnvKrpH+19ANxe55SY
 lzeDXH9QZiINQEBv/mZs9iQ3MvWqIxJGUUkbQ0hRRQFeo64XfHoH+lBe2bX+xAO+rl/X
 M0tIu7WkYcqvMqLJxvgz7ATzBkoWF/pzohVEQwAdtQat6PkblY/l7OnoEySlaLnihgZp zw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87ntdq9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:39:49 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RKFp5E037858;
        Fri, 27 Jan 2023 20:39:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g9pq3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:39:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfQev1BDTdQlxDizJiYVIjWuAoWlK6tvr6YcmE9ALxWMh6nyNSjlwfDhNXjh/ui1+A6TWmKU4alwePag+eQw6y566c1q06U24sv+rwRg5RIPFkvuieTEZCCaXsxbGaEsPyxEmG0TzFBiMw00+abFLTvbzZ+KDMXHdPI8HoN8rydKQ9sB16vk0eFqtKEbzsR4i8eP8+5fg6CEsdP2XM1dhPm7UcYrSPijNMsFmE51QfogssCtuRnpw8owCJewaugtzgLCQDQMAZBZyu2/lLEDaC5A3GowcWDQfNbxcYPT1Pjtlv1ce7edbvPH/GtZ6h/KXoRgOBgWfntWLmIOawH0iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CeCiDvFqoroZ+/6q+j2twNZ+6BumE63fnf6aTYkt65w=;
 b=fac4J7f4rbsII/FrdHfiWm0ef0IH6Ck11+i+HBve0u/okC9LlQxWJdXZJI3CWLLBBHLJdkmL9tsGQ349JbYVEQaLnOnyy0LlEQp1Co4aJXY4rNXYni8xUvNXVxd/NSy4jd6+BCSbTh0R4C73CYzQ7Sq4XeDlheq4ULyZfgh8fUi98ND+aSgoz3wmd8MuzJ2l6Wiybi0SFmzvIq1+Fum92/oetHfpo9t6Xf88RKSP7KUE4UOtEFr46tuSbHCu73dP+hSPfG8DPbD9ounAX3GCIzN77l2i0ilCUQtWqznhhj2qQyJZSR97rzUmOwVWRuvjFXPFp8sFd5vcHMUIdaU2Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeCiDvFqoroZ+/6q+j2twNZ+6BumE63fnf6aTYkt65w=;
 b=LrcI95eg2pZ8sjR7o5G5OCCN3TSxEiFsdrGJf2fhMN9ZzKt6L3Ma3vGoNS9iE6DuV80N54AeHx1uto8+D92eGf2pVRQXCGaXGx9ZFlkLfSccZaKRVTsEyDgGcSshUrBzYLJA7jT2QVwaMPEl6s/gUd3zg0NgQO1+xUeOwK/qfJs=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB4605.namprd10.prod.outlook.com (2603:10b6:a03:2d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 20:39:46 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 20:39:46 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.10 fix build id for arm64 4/5] s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
Date:   Fri, 27 Jan 2023 13:39:26 -0700
Message-Id: <f10e62052b7108bfbb05bc286ac33620af190047.1674850666.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674850666.git.tom.saeger@oracle.com>
References: <cover.1674850666.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0283.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::18) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB4605:EE_
X-MS-Office365-Filtering-Correlation-Id: d0aab767-4531-4b5f-18ca-08db00a6a04b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kmzr0DlKhgdEkrXA8n5kARgoMvnmXtkLNYw/98fizEB2uCcSY1xIkzhmApxcJmN7Iyu/drfyJAq+Tx7FNrXJj6nLKRM0Mm/WZPQOkjon0ZB7fNYptmZSW5DzYwbMfPSW8H61lnSVmZjC2vyd6takPa182hzCHKwK28PVVKyIsXr9ms0HYnwvQ/SSOD/yC/eeY9ZwUMHAWjD77NgJlSLeSfqvpSK6dRXPBW4NEwrx2g4OW7TQYuHjiqcnpUoHYDBI7WQf1ASYCOSis37ir3mhgpR1Vg8RF374UJDrelcIJA3Kw/1AbwWudCgauqjeNXvod0x4L0JEmiUzteTeHTRRzzmSl3QcyuisDPivolEdUc/qe366GhePBlNLP7ht1R2QEw5PI/cAm4TC5k+0aiaVdQXDu2wJ/MaNZfNlJLgG0D4KwhQ3xq9se45b1aYPPIfj6vlf5iBuyDa6KaKWXH8gOpzy71170+4HgODjo7ZfTgMui3zyRfsUMQG4vAqUyYHfPPcmUJiqkirrbf/8MSSea2vwSB8cWXNmq3PXhUe0G160Pu2Y/R8JXRaDVQihjskKPN1oqGeY+k+a10RoRTJeSrA50LDGy74tYYLsoOZWkdYkV6yXN7ES9jXwreJMRA6Eq8XNzrHMAzvyj1dpOkrhfcUXUrYn0+sA+TcVP2ikHgDqme5SFyYfNpCeGMweIaxrhWyIvBdCp0YVf9xmHqiUMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199018)(2906002)(8936002)(7416002)(5660300002)(44832011)(41300700001)(6916009)(4326008)(8676002)(316002)(6666004)(66899018)(54906003)(6506007)(6486002)(966005)(478600001)(6512007)(2616005)(186003)(66946007)(66476007)(66556008)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yypb+3VO9CTQgCqhbe9clhskolaizucFOl5U6YlZsipUzlwKQBmf9ynAQtRw?=
 =?us-ascii?Q?R+T7wyr2sRVGu96OMuMArR+IZ/X0tj/ftEwPkEb+UIV4jxM+KegPAaAiMZmf?=
 =?us-ascii?Q?9okQix4MmGdWNvWSUMGxmzW0WAwCfeL6LtenOz227a+bjx/SA8M3sRl0aUha?=
 =?us-ascii?Q?MijtgnH+xOKeQxE5nyUyZjmSaLIsiOUnGEvp8N0Fax4h2+cCKhQc39L7uYxM?=
 =?us-ascii?Q?SSReuCp4BvqlSsS32sZc1jeVR4ofn5Nat0cQUXPlNAtkh3jreA9Vv67chZtP?=
 =?us-ascii?Q?t1zKCOygUzwulAzYnNYkqy+hJQR3uQME+QSAG3w7UCcPcJAhFh+nFUO/r3KK?=
 =?us-ascii?Q?//QnO7MZs3lyFcRdr9XZqSzfaUfd2qZxQ/qAlofXqYawhI81IMEP4Yp3gxTM?=
 =?us-ascii?Q?AmHQKU7Gx12SA2QQ6Vc9yhgOITV3ZCby05DiVwKK1kdLpnqw+m4trX/dunR7?=
 =?us-ascii?Q?kHASeXydBQaRrq23VZbEeQTFkd4yxlKGyzuOXClC8hSVObU8zQ26vBwZAIEl?=
 =?us-ascii?Q?+iMuKfDobp1MSF7h3HANe9L4B0ZqbvW/3ZrvTi71CY3Za/1P4fedgvq5E2nm?=
 =?us-ascii?Q?CTf8QTfwczK2t3VoTDoLlxoJknuXrbLaJfuFB/MdphU/FBN4nw9evQ0et5D5?=
 =?us-ascii?Q?cmIz6mMDMSHV1PmQJ36fR0P0oJSH86mtPN4AKfzf5OM5pSk9Ejjlq9D+IDns?=
 =?us-ascii?Q?UM/2PUbcOZMYcvCrC8M1rLsri6b3dHOYsfsMHfqy/1dp7OHEESsGD0ahkyDA?=
 =?us-ascii?Q?sbPPA9c3nA93oJj1B8UKA8a0v8FVMJPgA8XJKq3VafhsiYUjpwj6zeNg4Y1L?=
 =?us-ascii?Q?Yskv6BjULBKN/itaKaZzGXe7Ljwj6R9YiWMja8GCI/pyLfmjBsBwAHUYVE4J?=
 =?us-ascii?Q?AKQ+UtRa0TYB9RivJVOvUpx6+MpPRxdO1qZBXOLnGJnN05MrSejBix6l8bqc?=
 =?us-ascii?Q?zDbI55GfN59GY8gQfgoOWkic064Az/BgpjOTxeI/ZO3sB/1QLzUaXqoNIzTI?=
 =?us-ascii?Q?XOpGT9SJEkCA+eDOzYIJb2GhvUn3pRjTAY2ftRzxft6MZRPK8wxIkI5P+SWn?=
 =?us-ascii?Q?mcgqvommcXWOF+h2ky0KJuCDbpkpb6ceRMUj+CyTy3hNDl3AsXW6MzJniOJu?=
 =?us-ascii?Q?1OCCI/LLaiWj5x+UctHDQRsSZTQvJLzjI4LuKsOxlHWQLNfvnUTee2KNYhef?=
 =?us-ascii?Q?V9hUT24YFxcRWyZk3FHaatDKmAWSIOpgyopzqsu2zeOdVIrdTTL5Ah6y3pbo?=
 =?us-ascii?Q?iA5pX94fCwzqMupI0B1tVTDliVGFy7gtFeIPRicNHENO1VFWcCJku+u5hL++?=
 =?us-ascii?Q?0TZycURY0VgC4a014lDNHpgG9u7e6/+BuaBQteKTLO4aNg8PZ3P+7FG/5C3y?=
 =?us-ascii?Q?NGzS2LDEW9j5O3kEJF6Jd/j79QBnWDsH3md6K6GdqmAY8f0aHTCNjJlSNmj1?=
 =?us-ascii?Q?/GYHP+LPsRZVRkfax75aTtSerH7F79LlRyt6vQdRHU5BZw6yrGFlcRbuSkNa?=
 =?us-ascii?Q?LdDuUjrIIJyMzBfyvvcEXp3NACdCsjNUTZQMTGS0gFESu2UcjeHdhlFvnnpp?=
 =?us-ascii?Q?WkOou/FWfbTBFLg4O6/ajYu7qzXQFj2032VuGhoqtc1M86eywXwVaWjiSKnn?=
 =?us-ascii?Q?nGsIYheQ5fYeN8aJl2RV1FU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?T4cZxI0gUe7L26d9Msi1AOnQh46zXEXaQu0etPqsK2qEABch717AhdByxyPl?=
 =?us-ascii?Q?VgN4h6MOqbDtYnx2kSFVke9p5Le68wJaTJx+55Ve3IIZd/7wQQzlPLqz4wfK?=
 =?us-ascii?Q?pDfwg5AAsMl63FRy+EX7A2cQN8rLtpJQyN7fHTjDaZV+/5wkuSfCDaGM6uC0?=
 =?us-ascii?Q?pGDpIwfUY3pYHYVi+Z+i8CLDmhqeW/enIhiqPL3bnaSj8nQ/qX6UMla3VLwa?=
 =?us-ascii?Q?YGtHV0nxCT+ANezgH+mYQaIUh7cphTgc7NuNN/peDNvUeCuhn5FHt/RNu6Dk?=
 =?us-ascii?Q?gx7HuhLKx/V4yYY3PuhAe1ZOrvTAc40oaj80rfrjVmSKdfoZkvgTcZ+V5eJu?=
 =?us-ascii?Q?zlaV4OiIFn0R4ws/4Rz51wIOrT5oEgvjOzcKuzLZqv7Lh/GNojOWH2lLlOLV?=
 =?us-ascii?Q?S8pPE7mWvU7Hht0/flA/85fUwT2yLBhzcUD78g8lS0FuCFd/0vchzRlo6svh?=
 =?us-ascii?Q?bUS/jZGGrOmjf88kworWq61GVZirauHMwitfSCM/KBNzVf6asiJ2K8PYg6k0?=
 =?us-ascii?Q?OPnC9FH0nAvBnNsJPbRtp93/r4AEACijiCTG44q53uCvZzueZq1RzyIDXpNT?=
 =?us-ascii?Q?KMZ/5XcVEPAwsZEdkut1KdO2AqVdbdU0m6kLlb096t8KnsI8X69haDTjqT31?=
 =?us-ascii?Q?g+a6kIdXEfLni/3F1ANPGlaZkuutjgj2eg0QYwG8riY+vXiC8Dwie3VbUZAn?=
 =?us-ascii?Q?JlKzdWkd0o7LvUUah/d+1FK2QmU0lJoocLRiUchXYuPqfnWoAn+oa8VEvsSh?=
 =?us-ascii?Q?otJ0bUFsDFiIxtEz81iEkwQk5hObxu+IN8hQbLnb3Ja+IRKluYrIv+0Ii2oz?=
 =?us-ascii?Q?YXzyiFzrbuYOwqyv5sjIGdxaUK8XAcbp3Cq4EVtvG9G5GKAPbXa+X1+Niy8s?=
 =?us-ascii?Q?0rhCvRtcJeX2v8PTLNGUOwev1z38ZWpr55At4A6B/LhL+7bbFsGXJGV4lLQf?=
 =?us-ascii?Q?pZD/Wsh2prearWzjFReZ4ExkYkpS7BSXiuJKGq0Zfq+9HDpL1+uLwR8m1YOC?=
 =?us-ascii?Q?6CCj6DuBLxzE2bti+1XM6izYlizbmBcdCLDugAKgPBvnYFxz0IFcNhUOo6qS?=
 =?us-ascii?Q?SuLFjsAimERbWW0ZUcz2d0cYqMrLOw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0aab767-4531-4b5f-18ca-08db00a6a04b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:39:45.9091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JTglB7pTZZCPEg7mYoQJY+mEZa0b61KBJ1ft2yzHG/qMrMMwU3jfsfSz+2gRg9bd8goArm5Zvo+8cXqLdO+Gzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301270190
X-Proofpoint-ORIG-GUID: LfMlQqGsXXVMFaImiGg5k6AlgAm_Yl_F
X-Proofpoint-GUID: LfMlQqGsXXVMFaImiGg5k6AlgAm_Yl_F
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit a494398bde273143c2352dd373cad8211f7d94b2 upstream.

Nathan Chancellor reports that the s390 vmlinux fails to link with
GNU ld < 2.36 since commit 99cb0d917ffa ("arch: fix broken BuildID
for arm64 and riscv").

It happens for defconfig, or more specifically for CONFIG_EXPOLINE=y.

  $ s390x-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- allnoconfig
  $ ./scripts/config -e CONFIG_EXPOLINE
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- olddefconfig
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu-
  `.exit.text' referenced in section `.s390_return_reg' of drivers/base/dd.o: defined in discarded section `.exit.text' of drivers/base/dd.o
  make[1]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make: *** [Makefile:1252: vmlinux] Error 2

arch/s390/kernel/vmlinux.lds.S wants to keep EXIT_TEXT:

        .exit.text : {
                EXIT_TEXT
        }

But, at the same time, EXIT_TEXT is thrown away by DISCARD because
s390 does not define RUNTIME_DISCARD_EXIT.

I still do not understand why the latter wins after 99cb0d917ffa,
but defining RUNTIME_DISCARD_EXIT seems correct because the comment
line in arch/s390/kernel/vmlinux.lds.S says:

        /*
         * .exit.text is discarded at runtime, not link time,
         * to deal with references from __bug_table
         */

Nathan also found that binutils commit 21401fc7bf67 ("Duplicate output
sections in scripts") cured this issue, so we cannot reproduce it with
binutils 2.36+, but it is better to not rely on it.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20230105031306.1455409-1-masahiroy@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/s390/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 9505bdb0aa54..137c805d6896 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -15,6 +15,8 @@
 /* Handle ro_after_init data on our own. */
 #define RO_AFTER_INIT_DATA
 
+#define RUNTIME_DISCARD_EXIT
+
 #define EMITS_PT_NOTE
 
 #include <asm-generic/vmlinux.lds.h>
-- 
2.39.1

