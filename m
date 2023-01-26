Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69D967D858
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 23:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbjAZW2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 17:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbjAZW2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 17:28:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EBD1A943;
        Thu, 26 Jan 2023 14:28:00 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30QIStRv019276;
        Thu, 26 Jan 2023 22:27:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=yPwKqF+Ah00TGNaDmImLe7JY1l+qKcF5K5+8fxU99KM=;
 b=DNPjVDQsY4POz15sGkrp7DulyhMRF0WuHKGNev9zDfcwWTbaEpkytS+lVSaQKzvZ+qz8
 sfEzpG45bpGB34Urusczl9UvO2PqrahuNDDJEBg+8AQy44Kvz9bBDv06eEQJ3cbYQLX7
 D/7c5D3rzCxA9XldLxHg+d033AS3u9XbzKvdcKs8hY/oESuWp6A4lfhldcEbmKMlciwn
 NuHaBpeTj9XiQ5LV9bf1Wholck7kka1LWffdG/DwhLl4FGEMoyI0byclGaneWoHAHj1x
 W1loEwyVtCD2riyasMx2N6kOsX65Dhce0UEP+rOTd5anLpERAGlhGeQXjkLN20fBn98l 3g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86fcknse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Jan 2023 22:27:33 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30QLJJm9010591;
        Thu, 26 Jan 2023 22:27:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g8fm39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Jan 2023 22:27:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtuezZIQzBMmz6OkmyKBv6lyoefpuEqGBBSHx8gBYNThUFAvDxmP4uzW/naMZS/Im874ihZeodxUo4OxPqEQH8sM3G3IpoTK2gmossf4DcoGjeh8xvNO3CMjRyfo0MBTfrbsNyp7m1hhS/iQCsxeMBSmwQTarFkKBtETvP1WBb0RxcNkvHk+HW/OMcoy7ThAikjftfHR3aw+M89MHj/cd+zbvK6/VVUoledSiN8DfTkfXqdEuutdqlaMxSbINxSukCyR71N4JKsZXXqnR841i8SnQrGHTlC5+qa9kHd8amWrgwTbz//2RC6U4qXFEJqHUvtfFuhUuAqLk3THDCw6RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPwKqF+Ah00TGNaDmImLe7JY1l+qKcF5K5+8fxU99KM=;
 b=mKA4KehHaJTtln3jtZvKBJFH6xORw40ZAbP6X2QGjDi9zKvHLd9jrPcofKkmRLCMLEjcNiB9vjFWJLcm69y0N1p66HLzpppHYLdldC8mMP29V5cg0vgOvmAtpWVtCicC/SLa/KAYU2YPgFi7lqBFyUZMN0oMtKbT69lHxyH4OITHszT+lpO2M3alMdLA/WkYCZsL/esCWAuOVqygT6foJoEWrO/KDiom6V4j8r0tVhUdzK+xUeq5SfYg+SFCMtGbFLPpFaWDnFbnuidMNGT+Aj5INrWBbJbldYlEg1Temutty4IzpIROuhBpEc3UwBOo+Ok1hCFpWDDWwYztlDyr4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPwKqF+Ah00TGNaDmImLe7JY1l+qKcF5K5+8fxU99KM=;
 b=SGJ/vmYjkCcxa/DRiJ0MfcTWoJG67V7WfgEbS9q+qxBxbuvoeqExZoW6vBerPbVsEXQb7vXszGHYjcfWvBJTwfo62FX1el258fo5xMOaFa3n15Oxnpaksf8OJSITjCyfFTuxsYqp9VdeOSzV3q15Kur2XfIpv9rvlu5Wn/gF4d0=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 22:27:29 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%9]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 22:27:29 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>, Yang Shi <shy828301@gmail.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps
Date:   Thu, 26 Jan 2023 14:27:20 -0800
Message-Id: <20230126222721.222195-2-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126222721.222195-1-mike.kravetz@oracle.com>
References: <20230126222721.222195-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0298.namprd03.prod.outlook.com
 (2603:10b6:303:b5::33) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: d92fb469-94c3-452b-fce9-08daffec823d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rXrocklrZ3+ymGnJOGsIvGo5DyRNyUajKdnY3164u/1TAdRW8lblKsJrhar7Pcj3ENOavSc2JXYg0wcF1B0V4VA0gJcVBkhC2NaYjHrbLiFu296RukPOwSgxYT8f4YjmccOQFnEQlfHbPflPIt8I8Zi+iRgLhiHe1GaV73YzlvpgyFzX6KzU6AmHgFNlmEZ4gLDsFJIUgzbMurTgWpMotyD8PpSIJkHnKFLDHF5lX+eJkB3TfaaxxvOlJewzdoWrKyHYiXpzLXtLpOCg4v+EZ/ib0x5ThvtpzF0BFCYnk+c+qcMSBGo+fY6ebdTil/2hW5BmkCA45LpzaGGl0ftsgQIMsk6INS3bQJ1YTOkL5JvSY6gVrUNoKjHRzAC4P2q70/dK1MCw2wc4b1kgwFtD1NY2+m3z76BnAFCjOs02iBaZsmvrcISQU5QiwvS/lk1wgDw5tr7KrLDngd04Do/JQXiSGZ31X37SUCgBpSTDDdg9MpS4ulKqD4c4OMIIpwqhN+2GZnKcJkNsQv9HrPvSakS6XcdDOggPdaiXHGSBJ8iKQCXtR3EN8X7awIc62kbRiFrK2WA6uQnVidZO2Ni6d+K5DKBdSs1EpEYzu8Wq2cuYRxIs9ea2RPymUMX27LUM0SFDnjycKoJFWRN5J8fyWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199018)(186003)(54906003)(6512007)(26005)(6506007)(6666004)(478600001)(1076003)(36756003)(2616005)(83380400001)(86362001)(8676002)(66556008)(4326008)(66476007)(66946007)(7416002)(38100700002)(5660300002)(316002)(6486002)(2906002)(44832011)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6uB10rY9eChJktZtdNV6z0bMrifVaC3ZHAzkv3HS9B7tGWrFVDW+2+QPZiD4?=
 =?us-ascii?Q?87RtMMrIeuVZloYKjjjsl1qULz2zBBnJVq3+/zJkkqDK+pfIq+xBgaHhfq5F?=
 =?us-ascii?Q?qub/SpS5O98K+VxglCX1Iv6xJXCEQL7krdgqNsDLDEIryEj5bx5KQILQcLOQ?=
 =?us-ascii?Q?gEK41PbDKRour+xg8AIpJ4jgvqwUZj/j5zLYKoJWZpeBox9pWX2g17Rc1LvK?=
 =?us-ascii?Q?Hf4TiFKtGZw1bu5k0FC0Bs12yK45hrD9QsWCns6Um0YIhIPtIVqKgD1qqePN?=
 =?us-ascii?Q?8QUASesH3FoR3xfzB4F1Fo+h9hAE5ePLyxUeNwzpH/RHPxUfNoM6RgkO2iR2?=
 =?us-ascii?Q?Gw3NHo3olco1EXvW1sk2iqhPGq5FK4zCTM7KVMCsDKUwnqOWbbH8GEkyUE8x?=
 =?us-ascii?Q?GyjGIab1LwApPzHYq5TRGusLaJxyjtS0fBcp1EATTnwg4G3ekmgGjunldis/?=
 =?us-ascii?Q?Dz+Hx5s43Dh4Z1s4GiZiVdaR4Rb3AarHs1tvK86pDCSa/e6DAKRaqiBXAZ7D?=
 =?us-ascii?Q?mEs7kKaZPbls6RrGdQMMRU4pVh5F7CJjxpJqC/LpLX1y5Sf6sKBfBdhjk88J?=
 =?us-ascii?Q?QIrGEYkOy6Uwo6TYTue0jbph0O8tUtXvvwOP5vp6ylNSvDQvrncUXGO3Y3Mt?=
 =?us-ascii?Q?3MC+/+NLSzD7l/SaQLuu2xOVC+9mXaPD8Hx7weq/iITAJ8yxRkgX1Wxt9quq?=
 =?us-ascii?Q?V5IEu4SU51gtRV8BhYQZO6ePsA13WpXjt9Ej1zPcZrzjvaR4gR03FBIV439k?=
 =?us-ascii?Q?+pHFIQz3HFjpFxzMzZE2IDa9sb5gCfG4vUcP69z325YA8QGSaalM48853Hhg?=
 =?us-ascii?Q?uloVPBF81J1GxvlzORd7r7TcvdHTV1vKkK3RjyGGFXF9UqC46GlvaDd1XGZI?=
 =?us-ascii?Q?6XSmWqUw1WIfWOZtj1VbJQ8KdPf927v8ysGVpDeRt7DnMBNigEWo1ciqFUw2?=
 =?us-ascii?Q?0STRjPzFzi4C+oKWK0okC3GJ2FTFJFuVvrDhUMH+tlw/FUGt1mSgT+TKUzFP?=
 =?us-ascii?Q?e0iFXvtCy2f4jI3tLUAUqWwad09Ki4s9FtuGC3RnVSFK7RyHtWba2jr8te3x?=
 =?us-ascii?Q?C2VzY0PrMAytcajBoXnRXt4k6fWMlKQQHuoMIDF5Qt4WNXzwmp27kM+b2Snn?=
 =?us-ascii?Q?ofxz/OeIfavDvJRQOuKvnpowdSSC+bIcug5jv1gJBjPur58TyTgxLDpcBqAC?=
 =?us-ascii?Q?Qr6gRIAcdofYQLGj3lXipoZPJG8IAnm50mipLrFw/4SQiqBZsLbn+8im6Q81?=
 =?us-ascii?Q?hlewI7kIF1sCjU/7m5NTJMa1OYAIJuPwQY3GC3DrmPaFZCF2iCBoI5UKb4c8?=
 =?us-ascii?Q?ZCLwIeX7gpt/tARKb6bMuWKJbX2IuCVXZMphxxsrD9yFrRHOY7ztWaU/FdvT?=
 =?us-ascii?Q?W5je0u705kJl1lbl+lItur9vR14RDnwpHiJYe90AY/wTarwKKe5M91LgVv5s?=
 =?us-ascii?Q?7zbJhqUlXFCp/TBylAnZnd5rBhY49Ye1b2AqefLJUfzu59SoPPPwO+vjVDUE?=
 =?us-ascii?Q?GqssIBRGQbVLqsgf67mTcpEaXdnrhwgbkeKQZnBnBpc26MqvhbX9FThL4vET?=
 =?us-ascii?Q?1Bn6iQraLz5LZ4zeYP54ZIfn3lwX/8blWCqYdeC78l8qiZ8vEgJa8HnUqGQH?=
 =?us-ascii?Q?Mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?2uhHi4yHi9ERROP1AN7HDq6yCl3MJKwCfAlZKjruKe0z4mnho5uLpflhTkrH?=
 =?us-ascii?Q?xQddLbjdSnLo0Emz5xAZtDDkqb6i+M4GOkEOugeZ9Ba0SZCelrWPqGoOFXxR?=
 =?us-ascii?Q?G2OUxwl6rPWdMLY2WPwy3FevC8h63b1DXJA6LHMGLu2/b8aKBC59Ilyn3MWC?=
 =?us-ascii?Q?DPMdwveNbJHzpjhpU2d3d1h3uPDWVXkYzgQpWSGTXrVgvVNLI9TncIwu53t+?=
 =?us-ascii?Q?oQFMpupqBmMuTeCpJ3ZjCMQticfGVoMvZYizogfuhf9By/dnkdFRrX2c3L6Y?=
 =?us-ascii?Q?5KuPtsSYgQ+Q0dcGUFezlvPKPeKEgVSZn2+OdVForhvktz7XhAeVV7gULrKE?=
 =?us-ascii?Q?43TQ7OoigEftXLUOWWrV8wJYnxSoYt2CVI/CcAPf3rZfnAbewetCf4Zcx8qM?=
 =?us-ascii?Q?MpuYAMpsRgdCiIsiaojabj/RqquL66w2vWVjwF3P9DvB7FrN/JqBpo1slt+8?=
 =?us-ascii?Q?eN9xNdNn9BC0ocuHaGK0WmeRaTl8TNnr/oJrv5/yDqnJVVh6Y8AhtXaxMMdG?=
 =?us-ascii?Q?IPBhVSCDQU+iiUjolRKk+q6cM0JOGHLE9jTr6mkRYnykCoygo91/CVibZa0Y?=
 =?us-ascii?Q?71vTTYNk4ZRxm+SIihK7qz3OrdE/Jrkj/e0LqOQE7ZTBmOha4Dkp4ZLtgdWI?=
 =?us-ascii?Q?+rgvzEnVEMViCpptHNjJwEx06b5pUgJII+3DEMybasBErE7MH6cWEHkhG/fN?=
 =?us-ascii?Q?UUxtiAextYg3tnXpZpFYR5CAkCj7Xd7qy9ri6wCSFgBT88Ti61xqee7c7vu8?=
 =?us-ascii?Q?2/MWIBGn12GRyymENlupS76fFOVKBTzV6+3ioG6tc/FJMtQZMQtPPo8uiE9V?=
 =?us-ascii?Q?SfG83gejZ+cn8HED9XtR14YwFsLE6Xw5XsS72OxKrpnYgb6KUtE8dJrRxPFS?=
 =?us-ascii?Q?zuMiXs38xHT5ReMf+4cIXKXRrV+d1W+rnniMbpdl0pD0F1JUtiJimjLAwY3R?=
 =?us-ascii?Q?p+FZp+gN7cQDW2O1S/8kccUY1JckOo/XZWbaua/1C76YXH4LyPTxJxGLLkJ7?=
 =?us-ascii?Q?vvHK0nwUuuEy+8K/LCVIsbYvFmpfyFMcLdznftl+sY8xdP+qQhg/EgyJyapR?=
 =?us-ascii?Q?nWDeksua?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d92fb469-94c3-452b-fce9-08daffec823d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 22:27:28.9906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XIv6WiloDy5VMKzN2FTv1fgAmUtpjsr6/uEvgtwozGzWY2o6Znw6BXkcTODzNaOZKilho/osK1Jl45QivAEunA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_09,2023-01-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=943 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260209
X-Proofpoint-GUID: 9eHBX4WEkN-u7zP8NfcfjeZFpyBxCzHy
X-Proofpoint-ORIG-GUID: 9eHBX4WEkN-u7zP8NfcfjeZFpyBxCzHy
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A hugetlb page will have a mapcount of 1 if mapped by multiple processes
via a shared PMD.  This is because only the first process increases the
map count, and subsequent processes just add the shared PMD page to
their page table.

page_mapcount is being used to decide if a hugetlb page is shared or
private in /proc/PID/smaps.  Pages referenced via a shared PMD were
incorrectly being counted as private.

To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is
found count the hugetlb page as shared.  A new helper to check for a
shared PMD is added.

Fixes: 25ee01a2fca0 ("mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 fs/proc/task_mmu.c      | 10 ++++++++--
 include/linux/hugetlb.h | 12 ++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e35a0398db63..cb9539879402 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -749,8 +749,14 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 
 		if (mapcount >= 2)
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
-		else
-			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
+		else {
+			if (hugetlb_pmd_shared(pte))
+				mss->shared_hugetlb +=
+						huge_page_size(hstate_vma(vma));
+			else
+				mss->private_hugetlb +=
+						huge_page_size(hstate_vma(vma));
+		}
 	}
 	return 0;
 }
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index e3aa336df900..8e65920e4363 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1225,6 +1225,18 @@ static inline __init void hugetlb_cma_reserve(int order)
 }
 #endif
 
+#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+static inline bool hugetlb_pmd_shared(pte_t *pte)
+{
+	return page_count(virt_to_page(pte)) > 1;
+}
+#else
+static inline bool hugetlb_pmd_shared(pte_t *pte)
+{
+	return false;
+}
+#endif
+
 bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr);
 
 #ifndef __HAVE_ARCH_FLUSH_HUGETLB_TLB_RANGE
-- 
2.39.1

