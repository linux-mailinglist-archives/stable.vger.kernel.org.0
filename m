Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821235F500E
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJEHCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiJEHB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:01:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655C16D57C;
        Wed,  5 Oct 2022 00:01:55 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2956hbc1004911;
        Wed, 5 Oct 2022 07:01:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=GuRFc6ohHbNGuErfYVDW5yQL8EdO2afwAK62w+r9xCg=;
 b=vTrw3aGpX6hh0Tsq6NVvCz8XXjzmC0b1bxfjW2YtVqNP8egH8D7igC1rf0O1MIS7vjMB
 nVchVmLqf7JptwxnTMjs4O6EC6/eiG6J52edxwJrGY35S+bWIOuLA3HhnGr2niH9uGEi
 M5E8UI31wzL3Ue95r8b/p3l4jghzfQRH5eNeKEgNqSoi9+MuY0tr1vC+/xZp+9qnMLoV
 18gam+py5ix9wmVlLtxd6oHiC9JVrx+dne7TH0y68cj/jbZA4n2Z4TRl7/aRYD4b+/w3
 0XhObNPQvra5PhCBHkMEdbySWlsCIFb19WcJDMbtHcQjAySqdTD1sjMcUuAUvMQ1iSZD Gw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn8580-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2952Ucsu028395;
        Wed, 5 Oct 2022 07:01:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc0awtp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3cFi8n5PfOskb2lGw4Ds1WXkVLlVXgeTqF6SX+p/xz37HE12XTnLPX9nPE7MURlQX+Fqt1goDIhw2C/APuKedxDKwmv3WAY9Mh1pwcQPNNWA3G0bclqoEMR5hqWyhMX9EJXq8tqJI1Gy6e/fOlFil1Izo16h8evynoY4tObrhib1cWvbhjadYBlhYGAL1SrVOMn7T4FHbMfe8x9tZa/g4IZghz33A/YmbT9U3jcLZ5LlT3GiGH6VJFJJ/uddLE+vtf+2+T0SgylhoKHoxq/xMDaNj3wA2J7S+pCMaLM56ICPASJNnqVFFMDt9oTROscx0d9j+w4uF/XRevnPjtmlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GuRFc6ohHbNGuErfYVDW5yQL8EdO2afwAK62w+r9xCg=;
 b=mlTrlt39KaHWT8Q/tN5P0dHWll7CoKcUwx9tbJQTVbKVxDDINT1YGI5+U2Z4Y7Ktji0ahoXadw/NzMJ9qczZUmtvM51cryU5E3kyvTWZ1WK/270XITFYj1/fB3FT4bfbAYH2yjqA60xgqbKPcoN1w5gP1Q00j36op8J8bN608Nv3YtPMt/7YWmhN4REbeP+FFVVt5ruZ/Q9I/n7yhb0bbR8DpHThvBwBtHN9YG02j1eNLdLSp+eXBwu6fG+14QxZnMzqdCBa4/CYttWXcAthoLsulNtGF60YcYtW0PYfZOrwBo2o7ONK3PpTI23SZR9tZ36WjifH/Eqds/5t+vfZfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GuRFc6ohHbNGuErfYVDW5yQL8EdO2afwAK62w+r9xCg=;
 b=E48eGdxH9uMymSiEjzc41tSuUrygDaxE9UpTJ5TUIhjUAzKwBcW9Dup6yQpx7ojhrhvfx5Sg4Oxtn0q1cW0Z4AJwviKMY3ouX6d/FGDmfkwjSw9pDepGTW2wBLjk2tuAhiJs0pMXJz7Jti435jD8btuQgyTAqRKg0EpGmK6yWF8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 07:01:48 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 07:01:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 05/11] xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read
Date:   Wed,  5 Oct 2022 12:30:59 +0530
Message-Id: <20221005070105.41929-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221005070105.41929-1-chandan.babu@oracle.com>
References: <20221005070105.41929-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0002.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f41bc3f-b092-490a-2206-08daa69f7899
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 81SLj/RBTTJ66PwMT7d70JsJQi8u0MFEVvvsxwxr5qFZXEmov46CNZdEBItULOhGv/NMIV4CvGnWd3dEdK/2R/toLHDtp35WQn4NehYAcJp3f3eFHT4b95K1Q8Web18tBTXODw9DQ0egeRMuNdMbkI5rzSh+1ypjlbakqhNZLYm+4mzEQ4gnmK9sLXjmk+Pn0oN8wQkh+t95+Y2eoouReP4Gzs1PNpw3ivxf9/0Z8xK9yV8NeLSmvbF1rnoxKTpYqdnRYzVSMBMcK5baSfAnYe5wkidCXELFYXXW+LrVQP4kG9lwNGVQU60JUATm41RrXHx0tyiJhZLaaMpHUl+f1iXPr+jWqT5OmTyPJ2iV4Ej5TzXI3uCiifFuiZhB/LmEx32b40DpZRs7D2NT7nwz3jSCR7+eDlI2yAMXwMVC1kRjNk7rh2EcxtAT8UrsBaQusvjU+7ijEVH4eJtwbAvGxLbi3FQbgV0UoQK/EAVI8ODQ/SHyLZ9Rsi/WlrLd0s7yTyXQfgRM5WQO5ztPhfDZNJvXUYXbycKBqBO8uGSE27JK1cKtPyjnLIXvNKblOrCemn1ZtDg2a+ijV9DOLZnI7hoPkHeUDABmu6Vz5kIAleQ+BdVFf7Cxto6nGLDx6sD9npYktY4wxk/AHUh34HAMHKdwpj4JWEF8T6mXc769qK6NXQTv2SdZ6hpw8jUxlH8bFWOMlPxV7FiiQC1mUHRPXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199015)(478600001)(6486002)(66556008)(6512007)(2906002)(66946007)(5660300002)(8936002)(2616005)(6666004)(4326008)(26005)(8676002)(6916009)(316002)(36756003)(6506007)(83380400001)(86362001)(66476007)(186003)(1076003)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X5o4k+zm16DFH0H6Ko1kaqdjvwo1JAN+OLvsoy1QgdSuhKlXonrXYxuN2OXP?=
 =?us-ascii?Q?7e6n64Isa/x8rQCYimf62v4h2IEw4mQRAWnZaYSHGZzAzau6VfJqJHe/VhIy?=
 =?us-ascii?Q?xWz2NZJbs3uYshTqh5sccTfNs+vpfoC2rYOA10krSgUH7iQLfK5kNGaAXjp5?=
 =?us-ascii?Q?QtwhQYeo03lPs4caWB5drsRr4mMegKj14Xo8vw4SFdfrib60hCUQeOM3QgoV?=
 =?us-ascii?Q?6qbDgnT36I26E1iAf+IyKvMYVkjaQLy35f3ieex1068yAjkahsb3hYK6FUs6?=
 =?us-ascii?Q?gxnPa2CbCd3+WOEpANhdyZYo3drm2HzgRSvtgM+fv66PdUdELTTAgDnFdV0q?=
 =?us-ascii?Q?OYz2rty6GHYiC/SbDeo61iksHwHaWgxYU6OASbeqyGIPoHUnV7r9BjNTB6x/?=
 =?us-ascii?Q?E5P+GrQMi+lIJjLGO7JFhX9/bINKcGZRNQlFDnOX6//0Or5E+J+GEQXcaWwa?=
 =?us-ascii?Q?TPtZD9MY+qDA1Ro8U67nu9yWSPzKF/rCJOnkOemMFS5012FErqXnoOrNiN5h?=
 =?us-ascii?Q?rOPWNJ0SGHFThVo3nuY79E5xxuiJG0qSpaIY7CZeJm09wgG1NcvPpzDymG6O?=
 =?us-ascii?Q?/R5VbxdGpWhvkYC96nF9uOFQtrof4WId0bUW0XW3lEogROBpEAS6sEVvnbbJ?=
 =?us-ascii?Q?xcWxKXywrNVM7JFJkqI+7bcvoeUW/P73rpj4c/px84IdSasGV0CTIc1gnLu4?=
 =?us-ascii?Q?PccEMv1mRWMZoNVECbkyXoAuO8vuXby2IwgVLpyWr2+E8aENTF9X+c8TwK8P?=
 =?us-ascii?Q?/tlRjinAajBx/b21PrmO1GvcrTD0kUeFotFCOsu40/z2+LuXq5+q+bMTGwrw?=
 =?us-ascii?Q?tUhBk3m7fbczQ2cuBaFCdB5xZqGEvvkQDQAaUPsl8h+GTG1KmFhZN4r3TeQo?=
 =?us-ascii?Q?0Itjlu3NDEp5btg6tx4ZTKZm5E6Fvb+GHPcUHQDoG8Shf3c43zLyUoV5rmMg?=
 =?us-ascii?Q?YHbbPl4RF0o+GNtwLCYEyDyZxR4RLp/ZLSfv5qAvDGvC5gKNbktLAyizYXae?=
 =?us-ascii?Q?4pNYUlg3JIFhuu642SePLpowsaNkW6FN3+oXeQQ6rQI5QfrQGvx8wV+7TamT?=
 =?us-ascii?Q?RuYm4uos6C1j5G29DVVvsmo6tHT6hpktJEIV5xqKy19aUMZ7gSydAExrUrTb?=
 =?us-ascii?Q?oVVyyT8iyNDUsEryibgG2z2Gb0d4GDlCGdBMiZiFkC/6WaigQ6YB7gPVlvwP?=
 =?us-ascii?Q?Y7MWSbTS74LbL8ZbIpXFlNmP4v0Y7Z8/iEdUczQED8RDfC9Smqr+96wpGZOg?=
 =?us-ascii?Q?YsBFFNDmUOSkaLFxZmFIgWibxWSJr9NfVoNpzFcHzVrHdi8BJ+w/I5dkcLKN?=
 =?us-ascii?Q?+6+vl+Xo3O6ZiZ6O/7e7Zw2znyw1ntITly8i2Fprn6gXUfFvL3ijeL5WvyV+?=
 =?us-ascii?Q?ntbEQhTcniV14lJlEzCIvQ6J5a7T/9CdgLXF1oV28QdnBWe3dnIzcD9jNfw6?=
 =?us-ascii?Q?ncdlkRY4TTSJCCXQPDmeNWLifZlLYrBQWpxosMDhKrwNpD9IlG/osigSBg1g?=
 =?us-ascii?Q?hd8WL7wNjc0d6z79qGgY2mrsfk2wxSsRfKWA5SoMEOaYHWNxb6nHU6dhguQL?=
 =?us-ascii?Q?PJo/0aDf3LZhqLCapHQAeoCcfoYeYYgX4yjIgT1MOtPl365FfcUTwGJrDbfv?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?uHmsEkm76J2KesT5STWS9W3g/s8t5oGFOi8gQkodxS+O68Q1JXh2DkIZgoqz?=
 =?us-ascii?Q?EZlvFABxgnEPiU1+aqj1EV1LZBZdE0wKV1H5sYE2D0kiJmsJUq8smC8QxbvD?=
 =?us-ascii?Q?OjyoPegLNL8ZAZOm913XOPYCKTrRDm2jpZ1lJ0HLHDdzbGQqcPA/wK1B/jMA?=
 =?us-ascii?Q?dTgKJ1J0btkex5jybFREnGhzr6ETQzsF/0J33I3SWXqM7KXRp0Rt17qh8irB?=
 =?us-ascii?Q?WkY0XPJJIqNxTfTzIFMFV1V4HdQqzEW7WQFSfk/Ue279KWFAlG+yEvp3DT23?=
 =?us-ascii?Q?sVxGAH4iHOi2qmyR4BhAKWpxIqsYzJXXS4BhHx7Po0+At+UqHc1ReTyS8V5f?=
 =?us-ascii?Q?6AvRBYd8Q8P/n/hh7423VdVtqEU11Dq4mLVMi1mWeUJ5Brwuqz/tEFq21xDs?=
 =?us-ascii?Q?KB1CCHKFrrferf3INr/keS2WqKhQ5NdgoLVfKvy6CFhTkxbKo5vn3arQqix4?=
 =?us-ascii?Q?EmKSvEjWapEtXz6zp+Zzl7wRyOP65IHO5wZucCPKOzi31jqME5aluHL/RiG3?=
 =?us-ascii?Q?658ic1K3xXH+P9ou6ENOwiiPaWvSQGu3fiuUaJJ7kBPet2qd82xrop2djrSz?=
 =?us-ascii?Q?JrGsREgLzODKLgEySZa6717RqoKLMQhDl1966t3Yt69cohGG+WEegO//YFfM?=
 =?us-ascii?Q?Bf2L7uReLigKyaHzbCrACm0HF0B4JcKJ6IQXTXJ7hXMDje+hrW/NlebEOVuZ?=
 =?us-ascii?Q?Mn+C39K5i5NSYVDcU+lH+kXfaJzUBoMyo397d+YZO+gdAzIhXMOaN0sEkmIK?=
 =?us-ascii?Q?B1GEdDUsmPAz8fzyQ8Cqazb8ceYHk5J3TZbmJk9yLrPZh0UV9ELRq08N49q5?=
 =?us-ascii?Q?ieT7f8Ib+q/rFMcFKSdusyIpjLGLBmW7LkfW2aw/lH/C0fK+OH92iKOQS+Wc?=
 =?us-ascii?Q?igRO0hRn6NJGCLA5Wi9u2IYIy4BIQYGqEd6GAlLV/FinGOYGV7tv7fn75f1P?=
 =?us-ascii?Q?eDBhFzVYJ2JL3ZHLjUOw/mF+6Vsb7h0EOvCt2vf7XlswJ8IG2aLP8NPnWFi5?=
 =?us-ascii?Q?K8/Y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f41bc3f-b092-490a-2206-08daa69f7899
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 07:01:48.2002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T70ZdIe78BE8u9+4EgBnZhp6j1eGMncFn4ngH0JhT1+GSXC27L4+IEcYU8fqsmpElsil3ErwDhfrNVlfoehScg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050043
X-Proofpoint-GUID: 0HbAhP2mt3RbzK1P3rb_Sum-9SfqrbsL
X-Proofpoint-ORIG-GUID: 0HbAhP2mt3RbzK1P3rb_Sum-9SfqrbsL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 7b53b868a1812a9a6ab5e69249394bd37f29ce2c upstream.

Direct I/O reads can also be used with RWF_NOWAIT & co.  Fix the inode
locking in xfs_file_dio_aio_read to take IOCB_NOWAIT into account.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_file.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 203065a64765..e41c13ffa5a4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -187,7 +187,12 @@ xfs_file_dio_aio_read(
 
 	file_accessed(iocb->ki_filp);
 
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
+			return -EAGAIN;
+	} else {
+		xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	}
 	ret = iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
-- 
2.35.1

