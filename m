Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B305F5005
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiJEHBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJEHBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:01:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A7758158;
        Wed,  5 Oct 2022 00:01:31 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2956hl6N016883;
        Wed, 5 Oct 2022 07:01:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=79njWmVrYiTBvcq+GngWOBIm7lKlzvns8Cn7dsuASjY=;
 b=1BssjkToJabDeCYkkkt491WTbZVRyxwSDCxhBiKQRPFlhX8qKjsK7Fd/IwAj9JDXS9KO
 95ab5J4v9+phIL0OcycdJi8hqrQ9C/ecByegrMNW9xrCA05d8GNpvmAAS0R3LtWi1qeq
 SwSHDr9QjzC88NYRnPDNkPRdTlIr2oITKtJMIzcdS0TdQCVUQP+Uavd0ERVsWTxjHHmZ
 kIAH1p41iAw+C72TwbU+sOoJJY7OCPckGWOFS6bWBI6c/sQ5VXEjkylSDwMpcnyw/7cG
 +R0PoCr0MEJenz/jmV8aNsWivG6kjW+snGbRo0/IO4Wfw4Jf4kkRUoRSowICiJ9Ci5hZ Ug== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxdea8gfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2952952P028347;
        Wed, 5 Oct 2022 07:01:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc0awtay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvTYMXtMBlJZ8R48GiSUwPCD4mT5zSelt+xDHAvB3zQf/2reMrqOfWBVWjn5GtWIyQccyoJhXNDFJucB0aFkQY59Fqr57xcw41bFG4j3JVzS+2k/rqK8mXNmOaVff8+gpUC4Hc98ZRNw9Shg0UNDfXQf41uXVerC4HR8ADRLP+pYH7E6V7p3Oyw5VW0YIqX1kYdN+E/CO3E6V1K4yWkV/RIXZirgK0zLm/FWGMUZHkBSFCEBXXyRqYsR3i8S2DQ4qLrHSgJkZN7NftMrzMuEDiqwrPLwzjWwQxhCP0lSebeBh52hTBTe4WEA3rXd8KAyaZd3XUjrXLQWSGWwigkq9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79njWmVrYiTBvcq+GngWOBIm7lKlzvns8Cn7dsuASjY=;
 b=Ljt2OsarAElnZOdy2Pg7ankCt/uOpq6Q2JdjgRlSfYVBtQ2exgwxGstfaExy06+8ZytFLTxD2UvO8kbodnNQ2Xw6ZRexVSf3R/lDKqlii3uCIVcXXDuEczdhFeygtXM8m1hxndawQRtPsVUhSaesDieR8d/y3JAXFDL6Xt2ttUb00HaOsb3z9DRHyHfWcUuGVBnBcxYu+g05z9uuD03UzvcPMMQqlwlQ45dOHlEeE/Z+Ak2/oS76+I+3qSxZWuVF7ZLDaTr2klGyd2ayEaN4F3/j8M9mKL1Q8CWHTKa93vE8lXK0KARkUQKlKxog1B1/GroE+dULR+yriwW97PecxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79njWmVrYiTBvcq+GngWOBIm7lKlzvns8Cn7dsuASjY=;
 b=APFIZuF/nbdkvCivd99VcOMVWP1OzGB+ClJbmNWawdiKGXL5qc86SsGHS9zNJZtx2Dg8nWPp9a6u3wb6D8u5Myf36Ad9jiI6qhtLXDoaZY+UrytBhwk1+ANSkvKvWvPC9jZ3rQBfsqLDKDYRk8tMaQAuiRGCAVpFaLJhtBWeyl0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.30; Wed, 5 Oct
 2022 07:01:20 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 07:01:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 01/11] xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag
Date:   Wed,  5 Oct 2022 12:30:55 +0530
Message-Id: <20221005070105.41929-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221005070105.41929-1-chandan.babu@oracle.com>
References: <20221005070105.41929-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0247.apcprd06.prod.outlook.com
 (2603:1096:4:ac::31) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: a4857727-a1fd-45ac-7b4e-08daa69f67e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFqYW+D/VmMhxab8icStAbnjIaupZhefinPniWCXpFlfbDIO8SjbIXOSI20wL5noCdA8+tfU4ce9hWErKxLNMbq+KYxmT4haG3vxYPyYRe1B/FaCcGg5hFhKtHz87Hb75vZPnrP/uf0aVHkmM0DKsBNh0+PBdPgZ+1ERpgPLZ9ZMOhCiJ/51+TmQoHC6tm00PfdKrqo7LBjC4lE5T/4h2DM3p+fldvibx7eoTZ0niEbDjTOKQwoPZh4KQfbHLHcq0EiYqiWedmpouR84VLONAj8tuDAZRYkF98j1GqU0ntKcTrDLB5ubhQBT7Is3Yxa/FteNNuE3ktbzP2Nj+DEMOATxm9Bjil0+mRXAr1BOTMdaj09hW0GNDRYBVlQttSTUINQa3ijnzMq7QXb1qyQHtb+p22LVyw+q2o/EcQxQYn/BjC7Q6P5zWfUFTVL7q0RxIajqub8m+sbfMQSP3JmWlVtwPoQ08rPPInBc4h85S3qOqv8wV2/Fm6t/NzshgCUtCmRNlm2D/8Chx0MGz/hLd1vL+tqsOA4TwTnESbocZXZrNJbm1DcATZY6XTTN3ewjKegpuVLPSU+KAPuvqqUeHjz0GX6nzWEocPpBy5QXsxE6OR3muNAfTLuyrs6u/ZhHWKaVXLTKh7dnnrnb8S0Bzddw4lTjMH2h95BWgO+Po4Tn/nMf5hbCcbvSIERsVHneWWsGeWUlK523vY03QcsJSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199015)(5660300002)(8936002)(8676002)(41300700001)(36756003)(6512007)(26005)(6486002)(66476007)(186003)(66556008)(1076003)(83380400001)(66946007)(4326008)(2906002)(6506007)(6916009)(2616005)(316002)(478600001)(38100700002)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RqsERxMHycOqh9+WTdzOK7BbV0DOlgubEbcPTlsVphywrtVyYzyQKa4EHO9N?=
 =?us-ascii?Q?KueFhFj4X0056yw4dfKg8xp6Ya2+VPhD2wBylYgnLRYZTJJCUSRQ3HCv8L4S?=
 =?us-ascii?Q?uLuJUWfl8y7s4LCASUf5lPCDAhfQ5oy3F2u1bRIIXSisSSFFKuMOoPvaANOb?=
 =?us-ascii?Q?nFwQxrM5TI8Ew2EXmFKfj78OM7ohjaY3wKw4JxPy6uJvEQymjwobRb5Ufkvh?=
 =?us-ascii?Q?p1Sm4xQ/RBnntJq3SGDyzOerMdK8cbn7owmcfIRjYy5xk2lYqJ1IpoK7WImr?=
 =?us-ascii?Q?uVcDkNdnxtI/1E86e9J8/jTjoEMtEu/sDlLjlUms172xxR+pffkVdG3Stgzx?=
 =?us-ascii?Q?gxEjhyZTRzsZX1rwdyzvQsH0M9+tFhRmcG+ewtj9CiqVMcerV0XOfj0Xfe1Y?=
 =?us-ascii?Q?YqXGa4df4+/X/H76m99F8DhkpUHTRAH1os2seCVmCLKQmOZMwx3E7/RlRkRc?=
 =?us-ascii?Q?QT0RZHakdaCE/iBkipj39NSuiflny2jjKjy0fwSl5CozruJKvp5d1Vuhi6LJ?=
 =?us-ascii?Q?aOOQ+QjKlEq30wTSLytgzP+OC92s5TC4ow0fLnOmrpZm5XmyGdWExRxA90Au?=
 =?us-ascii?Q?GLWgezr+5LWifB6/TWbMXO218bZTSW7v5d2U+1dgdbTYtHPxq/cUAE6dk7vy?=
 =?us-ascii?Q?Y+tAE+oMjOaNb4WEZ03XLMvJD6ml4Ik3/NcPtwntAHpfQ42BS0XwijI193H/?=
 =?us-ascii?Q?LT+NET3TmFm0kHjtHdwRvDopppRC7/EWCHV1jYqtj9DnFTfr4AEQt8qV9E5E?=
 =?us-ascii?Q?e0L5+UN9T9hskdViAEjeZsrATeZIYJuZWR1aGq7ct0o5ZIrJiRHpbmjDjQnP?=
 =?us-ascii?Q?8pguol+7/A6s6CgY8vvzlG6qdFKTsM166K28cFL7rWYZRiKvRAXf+WZwKHeH?=
 =?us-ascii?Q?ISC+wL0k40MKlzvDNxfzQdQlHuEd/g29yG4RiK4Dm4d7g7Fbc8JEydHk+jgq?=
 =?us-ascii?Q?c1yze1zZWS+AQNAUH7rTyYN+WJjFgDRGL2RIsL8Xz0XXFGxzO48dfE4rjJXU?=
 =?us-ascii?Q?Xc1q7UD0TXLIOoM+W4l1/Bl7JXctVluQqdAWpEvnqoBUVl6wJEDhvhLH0SFl?=
 =?us-ascii?Q?iWy7I6gNWsZpPLaa6nzvPwQ3iofHQ0mjH7aoiTht0Bw4RATWScRTQLjccLfy?=
 =?us-ascii?Q?POimGuM6ukP2Nq6IcIZa8p+h2P9Z3qjebielmDiSqNuRiX4uQdvccxNWrsV7?=
 =?us-ascii?Q?HuckPnUuJPW3St2Q4t1eyMBSx4Oc9187xO4bcPVzAygluMrHfJ0jDsPSqJYG?=
 =?us-ascii?Q?vRBAsOme89E/8lSrDzgQq69zM7i0KXCfMjVJvRqskp+FoPaSOW2NrAS2DvSf?=
 =?us-ascii?Q?XdmHMiZFKWKfKtt6c8klcTqkgauOmZvp0orGLvOr7aBQnXCK9CkvYtQ+RCWI?=
 =?us-ascii?Q?mlWxtDs8WGFUXmgCqFLeYC+LTEe4u0J7mDifBshgD2wDKRkT5z1YjtcxT+1x?=
 =?us-ascii?Q?3oxNomb8Kwq9z7uzSlONQJSR/181S07ZfjM7gboEGD4Lfg9UamHzJQDOykjt?=
 =?us-ascii?Q?tEFJBd6cv332rMJLtOrYoA9SD4sIskJZESxCeXosUiECD7xQN4HWY/MuEBxS?=
 =?us-ascii?Q?WPJGZwBLBcJYDKWS3z6HLIvwv0BTGeed1w/rxI4S8wb2Btu5V15uSSJvC3bC?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?yVzrnbQMQzNjoWJTGJUN6FvI7NapY6TBTwEqx3xZfiVBQU9kYq1lKIRxoftj?=
 =?us-ascii?Q?16yZCjhzKg4ap2JSoK082KICiTcdxNOyongJeRSygxEOL/buq0Wp2p6Wt/8L?=
 =?us-ascii?Q?YCZqdroIqeOt0ygmIoCi1kIxTh6lfFfcXvAfmXPwuzdLs/nzrv+Q34whDeOO?=
 =?us-ascii?Q?TFCtbYQ2nse4GAiJ6b5XRbFUp0t63YdBDamWpuI0xGMuTavmtlgVTfLvVTg0?=
 =?us-ascii?Q?AtLhlqW4x6lFeyiREZyxPvjJowVqET1TVzH6jiHvbj+rmxVmHeyNXSbMTbFH?=
 =?us-ascii?Q?flxODM8esMkjK/8EF1335JRLdsMbH0aWOwU5aZhbvkP750h9NVG+grXTGdRw?=
 =?us-ascii?Q?DCKBoYrXnZUuz9+kWZ4GFpZQv6Ulelu9qlMfJGYI3yvZwvq9U7Z3odW8sNb7?=
 =?us-ascii?Q?yBSrNavyth1WXZ9DYwbxgZKXfUpngIdztKQ+1xr76hkq6xswymCkYDib7jw2?=
 =?us-ascii?Q?m3VoBou27tf7NiRzH6HYJem2aK4AMpTZ+wOkg7ye25Zkj48iGYs7aqjIqqzf?=
 =?us-ascii?Q?bJ5rjEBIx+PbKateFoDyIY5RS+41MbneTo0qxd2cSrANjCW0Nu5VHVhpdcF1?=
 =?us-ascii?Q?cOyUEt7Yu6oJhlIGfGrrP7EFqZZJmEPrRDzu/asxM7hT7y5ZybOtXmTJafY6?=
 =?us-ascii?Q?tbsMF6oxQ189SE+XwTyISBOrL2StZwAOE9HDsYDKQrjmPd4SJPexcR6SG7+A?=
 =?us-ascii?Q?8QlJRdIo3fe0w16Hz8xw+fEV6HzptZty4BuZywqPYKi0t12O5VflYg9I4rC+?=
 =?us-ascii?Q?VE7D3UdnpazlRfmjn2XFXOHIfhyYoYFjl6OCcTl32JxTR5R7cl8bZ26v4Xs6?=
 =?us-ascii?Q?M6pJJUd7QwAbUtaTnz0QLMb8iOeWmpu8LH7PztFmKx8ziagLZLTrpBDChg0U?=
 =?us-ascii?Q?tQu9XyBNDGMbwBiHZAIW8ZqoCYKRk63FKetjYzCxQ0rWabVsyRGkP6kU0gMM?=
 =?us-ascii?Q?2IbqSDKv3fivSX2itDxHZroiEn5brUZ9LtvIfWfbVdThTT+0m5PUDw7DQKHM?=
 =?us-ascii?Q?Ozpc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4857727-a1fd-45ac-7b4e-08daa69f67e9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 07:01:20.2536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qzja5//rdNPtobvxYHTCF/UC74RRkOdqyfA75pirqPBPo9ts+DVLc+MY3FfCi6QowDD/hlSiLhEvYYG5QYnJLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050043
X-Proofpoint-GUID: 8NPMc63pMUnuERqgMjr2OOsxz6WRBEGo
X-Proofpoint-ORIG-GUID: 8NPMc63pMUnuERqgMjr2OOsxz6WRBEGo
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

commit 780d29057781d986cd87dbbe232cd02876ad430f upstream.

XFS_ATTR_INCOMPLETE is a flag in the on-disk attribute format, and thus
in a different namespace as the ATTR_* flags in xfs_da_args.flags.
Switch to using a XFS_DA_OP_INCOMPLETE flag in op_flags instead.  Without
this users might be able to inject this flag into operations using the
attr by handle ioctl.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c | 4 ++--
 fs/xfs/libxfs/xfs_da_btree.h  | 4 +++-
 fs/xfs/libxfs/xfs_da_format.h | 2 --
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 510ca6974604..c83ff610ecb6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1007,7 +1007,7 @@ xfs_attr_node_addname(
 		 * The INCOMPLETE flag means that we will find the "old"
 		 * attr, not the "new" one.
 		 */
-		args->flags |= XFS_ATTR_INCOMPLETE;
+		args->op_flags |= XFS_DA_OP_INCOMPLETE;
 		state = xfs_da_state_alloc();
 		state->args = args;
 		state->mp = mp;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 0c23127347ac..c86ddbf6d105 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2345,8 +2345,8 @@ xfs_attr3_leaf_lookup_int(
 		 * If we are looking for INCOMPLETE entries, show only those.
 		 * If we are looking for complete entries, show only those.
 		 */
-		if ((args->flags & XFS_ATTR_INCOMPLETE) !=
-		    (entry->flags & XFS_ATTR_INCOMPLETE)) {
+		if (!!(args->op_flags & XFS_DA_OP_INCOMPLETE) !=
+		    !!(entry->flags & XFS_ATTR_INCOMPLETE)) {
 			continue;
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ae0bbd20d9ca..eebbc66f4c05 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -82,6 +82,7 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
 #define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
+#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -89,7 +90,8 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }
+	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
+	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
 
 /*
  * Storage for holding state during Btree searches and split/join ops.
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index ae654e06b2fb..cda10902df1e 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -740,8 +740,6 @@ struct xfs_attr3_icleaf_hdr {
 
 /*
  * Flags used in the leaf_entry[i].flags field.
- * NOTE: the INCOMPLETE bit must not collide with the flags bits specified
- * on the system call, they are "or"ed together for various operations.
  */
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
-- 
2.35.1

