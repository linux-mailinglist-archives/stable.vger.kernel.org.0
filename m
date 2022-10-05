Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF235F501A
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiJEHC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiJEHCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:02:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8409474B93;
        Wed,  5 Oct 2022 00:02:21 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2956hmEl005015;
        Wed, 5 Oct 2022 07:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=O6e4vs93jXrGzuWy9TzP+Cb1Go+m+RR4re72l7NY3eM=;
 b=mhi+5NDzsBbQIeGtzt8PoMjFkka/znoJrD/MwC5vF34eDIMGO1TRaKrKYeEgnVsn8Q/I
 RUsXiZBjFkQOJs/OiwsWRTZU8WSYHe4KL9BFxPtObHmleZLKHY8j4AWftCQ/JyHtsuhc
 StT1NcSTC9A7yGTDp5Z6TIsmRkTuVT2CDoOuWwWhv07NS8xkGvSG+LC5AyREV6UXxLVq
 kx33mdXxWFOpHYZiMBc+c7z9XZbmP/haXvf08aTot2MmSfiuJSzmCZ0hq59KHriMfakM
 JX5fWzXuHyaKnmNMxsf65fFnXrE69tMHPe5jwf52brGNdajBLwQ+LzP11ErPJnFaYYGU qA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxe3trmjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:02:16 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2951jDHY005709;
        Wed, 5 Oct 2022 07:02:16 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc04mspa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:02:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8UO+uJ8GpfIi6nqF8gpeedfu/uxC4Ak1GOHWW+fqBZuD/8hER2JF5zhsRe++dVQ6aFrABMxix/h0ETBc9ai4iiXyLUFr3qrkZUlikXT6IgZ+AXRUaFtTVNeSGPoJbxx+4rZQMwLCrsKe1EWdsryF04/945+Zf/ZhupdFAg6wYvD8IEO3aVbMFvhWdHG5+VDnls9aXWEVmQ24mPiObbk0DrAIONww6dvhow7+WVCR8zyC10W+e9S/pnWuwzHHR0TZ1TIeteYdIbryzgDIfhs6J3DqHJFfCFqdAxNyF4Q5MP5fQQlOPl72GLZyM9UxGoOFh84tZPlFFQ3N/mZeEPO8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6e4vs93jXrGzuWy9TzP+Cb1Go+m+RR4re72l7NY3eM=;
 b=kwYDUOF6d67CkfB/lE7EZUtYhkyPxCCJAtboFpokbkkL9ehuIPP6pl9IAoD2dOr8hY3LrTpVl+4Hxj+ySpSBWD6qfr1nyVKdtM5Q0V167mtNElapvIyRIecZajKVBwkjwbDIEHFTPtuJoAqmDIO8KmOYVNOHEHK0jyvPm2hjyn7VJdX4OT4d4pAmt7eGu9WKs61M1Q/AbAfy2uVgFXv+KXxTpWQaJaKHPBJmPIatDrOLnohjnyXW3BAqR5wf5KOgO4sCcFg0WgE7sjWIme6npdAGjcrG8P5PLGZWAWlGp6qxMF9nzhHO2+w3cpQl3xKArkVR6mZ6vrLMnYDeLATC3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6e4vs93jXrGzuWy9TzP+Cb1Go+m+RR4re72l7NY3eM=;
 b=vaOvky3hwku/DU4YS1vtkDPqpIl6pITeMHeTK9TNMG/Vs53QUZs2Ne07JGQSjDgkt5zg8PZpFBFzNN/Q+UDh4W3bYtWKvqyFg/PA2C2kzJ0HG+rghfHN6PUlIFkqztBTBFaur31REtHKcZda3l9uZZDvvIQfDMiERhV57kNCVtI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 07:02:14 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 07:02:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 09/11] xfs: streamline xfs_attr3_leaf_inactive
Date:   Wed,  5 Oct 2022 12:31:03 +0530
Message-Id: <20221005070105.41929-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221005070105.41929-1-chandan.babu@oracle.com>
References: <20221005070105.41929-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0009.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: 9195e402-11c1-413e-ce90-08daa69f882c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OftIjkYTyfKtbEdxitsdpyBTu/uovD1qcRKeCAc1KCkNX49Q3saFI1GmjUFBIdPJ6mNUl8t9ULyz9ep2tBSpT2vyx/f2UgdwJBIv12oBYYDb4VyhNCKaFzlClRE3ZU+KXIMnlxONsKL27zL2x0Nys88+Lj4Aa/oKHN9fAnleCdeWL7h8bLD8yv/ouuMTXzRBxaM8CPLnQ90OKKKoYy7NNxQ7lyY2aCKhkIya3K7uhW00YtW0ZbQ2G2P0x6jyoOFWebup6fwhFIymvph3VxFzzMgMJYZh8ebyHg0yWAMihMuAD3kaQpVXoI55SRTdMgxkOzlTWmiJwBtPw6IGjhOyBFlBdIXVP3a6SJ+POFPcdZLHk0PfWaXRbkS3UZ9g9F165+uw3HUnycdcGwvYEszObB5S0Hl3lkwX+frHmBi/S8Ys5c72VLezx9HXQNDijJJ/yU4dhzPRtAOhHti5rWFud0MgttV4NRkiBHidaDOgW6pVjgXB9sxX7+JozI7X3CwVQNtRujgaGUmvm0N8O6TmQEddr+QHSBeUl/hYyxnp95C1cK+OrA2pkWC7MiFgljMvtvPlO9Ob6fK/V7Wb3RDgLRQHAvUXYS8qJIwOZEIs/h8BegodLSM8bu74ZyRnZbCc6xfvhpuhVk5I0X3RtNaR1r9qnBYZe3Zh+ezIrbKgLt0hbGo/Zpkzydtze+9RYtFOYa0G1YauFDXkoCRJJ/RcmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199015)(478600001)(6486002)(66556008)(6512007)(2906002)(66946007)(5660300002)(8936002)(2616005)(6666004)(4326008)(26005)(8676002)(6916009)(316002)(36756003)(6506007)(83380400001)(86362001)(66476007)(186003)(1076003)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gY4RMMjWRFP4VJ5MmaHzjNUzSS1h7RLRkI4+fb8cpmT0iaCOwZPDjZTPyBZ7?=
 =?us-ascii?Q?OJLtBvNcVeDeZcdsjpTppiTsp2u5A486b7rVAOqEMdV5MmVrUbUhOJcp1A5D?=
 =?us-ascii?Q?4oUg0bVT/dbbHQ6CWkLR8X+evFVGXb1rkWJRkU66AV1O9F1uORz9Kajgimi9?=
 =?us-ascii?Q?sx/cmn0T8DJsG48543XvrnU9WBEbi+fimmbxfsra481qIqH3AueJ1J+gjU/6?=
 =?us-ascii?Q?81OrXlHIqrJYOiwuZbPOnn9tIVwbl/+i1Dt21GAo7Kiel6c50ZALOXM/QYx+?=
 =?us-ascii?Q?RSZZ0xxXgZUmsvgnNmpmQ8QzL6fj0lqpgNJTw3NkfQ2Lj/wWCUPtdU8+CVD5?=
 =?us-ascii?Q?G40mVOkEyPctNkp/1zMAzJs9eQ/BKB+WVLwEv3L25x6pLEI1BytUew2qr9Nf?=
 =?us-ascii?Q?SjCHFPbdQaB801g3hg2NgphhMsvEniwXTxHpTvFQCmF9kviUipzgZ3xKkvPV?=
 =?us-ascii?Q?KrYlTKY7NYDC2a1qfWjpCpJP/VtCClT5YEOzgY+7BaUfVukseP41Vw4+EEWZ?=
 =?us-ascii?Q?70dwmbs3J95EYUJRYT1naMhj3G3vleuxXpV2RLRSp/7NMjU8H+hAtdgfFQWy?=
 =?us-ascii?Q?eHOF6O0Mel50Xo8KUvdTSPgE4tQI34KWPN1XxGwR3O4zP88jyh5PQdd7Ue6i?=
 =?us-ascii?Q?wH8+T7NyDmDU85/q6bNkEam7klTY4Rpiesi1jL75MMFH0AgramlH44Mo4F6w?=
 =?us-ascii?Q?v4tKlO1yqZkgXKP7wLfi4cJKUrPFqMGal/BeLkibBgv/UwzpG7ZWs/WAt9hA?=
 =?us-ascii?Q?pCaoSTq4AchK+BncYeAXU6w6y1MReSFmQHf8Os+3p8KliuQb7JVAW5eBm2fT?=
 =?us-ascii?Q?Qk2UDCriDySiOxvYgKBVdh/Go/W0xshNcq9bbbGXlsGWl7k/Jp79VbmvjwtY?=
 =?us-ascii?Q?G2+V7s7dvrX+S101SWLanO0uf227zOjknOzwC6em42i1wCNafXGGYMlrmR0t?=
 =?us-ascii?Q?WtpfUGunR2J1m9GDfs/Jrn4xsJzP48qD7Y0xCCfNwPvyD5LYyH2po3S+f7Uy?=
 =?us-ascii?Q?GLS2kQnelhbslAYNwvNSNAgqQOQnhH3Ph2Q9PljcN76UCn7oqGJHgXAnHrDJ?=
 =?us-ascii?Q?Gh7np+1DAbp1sQltsIIgCwYTLZY3HhRJJgVRcLXjNJFovm5FbwppS9B37mH3?=
 =?us-ascii?Q?9e7tgSzIIItPEv43v33JH5V8Qr0pdTSOmUxW14wm1oGI6HVWbriv7ZGFZ8lo?=
 =?us-ascii?Q?KfJAxljHUr1Qsbg1Oa9UHeW9ud03CxG1MqwoXYn+Jb7BwWm/R7UbbrhodMQT?=
 =?us-ascii?Q?H/Ne0qZOwCCwBCA/KoNLciRsN/NQALCRzWByvWHMYkB3k3moa/lnmR9YU8M+?=
 =?us-ascii?Q?0OGl/8b36xL/CiEUiFgpna5o/+ZdAXOwX9fOQayi9Jb1M0li37JDvQh1gw3t?=
 =?us-ascii?Q?79k9IayccpoakmuSCPyV83v0TqPqiYcPtNK7Vq+0YmBbkIsQnX80qcIm0GEK?=
 =?us-ascii?Q?JdZG4I1PUVpFLPosIrgloax1+LF82he0iNQ/hyH6pUbMjOhlMGQESJH9nUzX?=
 =?us-ascii?Q?FtQAMS9cT77Fr+/ZoQ2+dl6VTED8drEVE/sknzsYuVB5ytYCM3fRxQWbOiiG?=
 =?us-ascii?Q?YowumuL5RcuXI5fGBwTDZgjIfzo2I4S47vv/OBmss2JFeQF21JNtyykw8AmH?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?bauGvSz9HDrGUufTf/iPxX+H4TzLQutP+2wfRBTS47iTKH6puC5+v7Ou7CKr?=
 =?us-ascii?Q?qFf+kJMOaqJvrQej7nG2T/m9dH1f/Z3Ca8asJJMx2xRDbp8GbNIu8XSlhpxb?=
 =?us-ascii?Q?I64fs0W+b2ms1S7+4bqSpaNLBVpFygWgnUzB75rshEBrllxvAO+Wv5FWsv90?=
 =?us-ascii?Q?Q9fer6Ah6rt3iEgLgHLHEkA4SYl9qPp44Tw3E345eU9DCggdmr1Ck+zWutoi?=
 =?us-ascii?Q?47cDswu6zrGb9UpXr0t8b5BG8OF9Jgn5yE/84KAg+xOTwghvSxgUA0XhJu2l?=
 =?us-ascii?Q?3DU9BElHIBmt5xTriJdlb48wvZIfBN+q3f0JBSa98cXyp0zdwIegN+gNyFic?=
 =?us-ascii?Q?vA3V9lMoTqQKbva7JFbKES1NG3G850QX2fnnFUUXzxB3hrLFay6xFGK+AwBv?=
 =?us-ascii?Q?JBMrqJ3rLzVJMv3DOAkgWAxPW9yqh7I6YBFq7FErwjz8Y0BVwlhmPZVpGI5c?=
 =?us-ascii?Q?CPVU9SI6ySWiw2nQGVfNFcIvnt01tTwWXmxcNLcXNd8dpjJTfXz8W9PmbaHv?=
 =?us-ascii?Q?szedIu2Zqe6qHA0WfExW88vXkbz67Cx98tV8DSRPYjfP/xvdKjjvJoaY1lYl?=
 =?us-ascii?Q?rPG6k/M+6JFunje6SKac1vNpItJ3l+saVf+EIMICavvP4mBZLlqF/CIr+IJc?=
 =?us-ascii?Q?J8OHw4J+EpnGIrm/tC+y0sFf3hIyGWKTznaAiEfGgPR/6vtMon15+6C/L0WP?=
 =?us-ascii?Q?mq2uURoIjrzDhFOX5rAWb7AO/NRn9WfZf7+uEcBarZyjuoYIohGSrlX1whQk?=
 =?us-ascii?Q?V5aSbvqjNjkIH1oEDfHeHZRXEkz5WBFKoKUmy0pWj4oZxQe4itzXqOKlMaD/?=
 =?us-ascii?Q?sPRrMCXLi/GrET2h1tcq4FUR6hE7j3oVXN0Tgjv+84CqlyETmgfJvfbX1lQ4?=
 =?us-ascii?Q?5vUOOuF6DqudwNKjO49hdFWca45GXP/zI1bbPgevWdBPojEyWy8iavM3aQpj?=
 =?us-ascii?Q?Yzdx8A8sWG1JscyGBFGtAF0h2+YCSNYmEffo+e4l5zySCJjR0WQA444zCO/x?=
 =?us-ascii?Q?vsQ1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9195e402-11c1-413e-ce90-08daa69f882c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 07:02:14.3195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: utYUR9E6IowqDZm7e+Zk+D/77B2K6mT4+xp2xFbyH7ElxiT08TueQbrG3WqywevZZ7XSFy73LycSUd4FUWiS6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050043
X-Proofpoint-ORIG-GUID: RuUzsthUKX3oe4SD_8aoVNx_869Yu_mR
X-Proofpoint-GUID: RuUzsthUKX3oe4SD_8aoVNx_869Yu_mR
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 0bb9d159bd018b271e783d3b2d3bc82fa0727321 upstream.

Now that we know we don't have to take a transaction to stale the incore
buffers for a remote value, get rid of the unnecessary memory allocation
in the leaf walker and call the rmt_stale function directly.  Flatten
the loop while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.h |   9 ---
 fs/xfs/xfs_attr_inactive.c    | 101 ++++++++++------------------------
 2 files changed, 29 insertions(+), 81 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 23dd84200e09..38c05d6ae2aa 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -39,15 +39,6 @@ struct xfs_attr3_icleaf_hdr {
 	} freemap[XFS_ATTR_LEAF_MAPSIZE];
 };
 
-/*
- * Used to keep a list of "remote value" extents when unlinking an inode.
- */
-typedef struct xfs_attr_inactive_list {
-	xfs_dablk_t	valueblk;	/* block number of value bytes */
-	int		valuelen;	/* number of bytes in value */
-} xfs_attr_inactive_list_t;
-
-
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 9d5c27db1239..1f331d51a901 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -37,8 +37,6 @@ xfs_attr3_rmt_stale(
 	int			blkcnt)
 {
 	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		tblkno;
-	int			tblkcnt;
 	int			nmap;
 	int			error;
 
@@ -46,14 +44,12 @@ xfs_attr3_rmt_stale(
 	 * Roll through the "value", invalidating the attribute value's
 	 * blocks.
 	 */
-	tblkno = blkno;
-	tblkcnt = blkcnt;
-	while (tblkcnt > 0) {
+	while (blkcnt > 0) {
 		/*
 		 * Try to remember where we decided to put the value.
 		 */
 		nmap = 1;
-		error = xfs_bmapi_read(dp, (xfs_fileoff_t)tblkno, tblkcnt,
+		error = xfs_bmapi_read(dp, (xfs_fileoff_t)blkno, blkcnt,
 				       &map, &nmap, XFS_BMAPI_ATTRFORK);
 		if (error)
 			return error;
@@ -68,8 +64,8 @@ xfs_attr3_rmt_stale(
 		if (error)
 			return error;
 
-		tblkno += map.br_blockcount;
-		tblkcnt -= map.br_blockcount;
+		blkno += map.br_blockcount;
+		blkcnt -= map.br_blockcount;
 	}
 
 	return 0;
@@ -83,84 +79,45 @@ xfs_attr3_rmt_stale(
  */
 STATIC int
 xfs_attr3_leaf_inactive(
-	struct xfs_trans	**trans,
-	struct xfs_inode	*dp,
-	struct xfs_buf		*bp)
+	struct xfs_trans		**trans,
+	struct xfs_inode		*dp,
+	struct xfs_buf			*bp)
 {
-	struct xfs_attr_leafblock *leaf;
-	struct xfs_attr3_icleaf_hdr ichdr;
-	struct xfs_attr_leaf_entry *entry;
+	struct xfs_attr3_icleaf_hdr	ichdr;
+	struct xfs_mount		*mp = bp->b_mount;
+	struct xfs_attr_leafblock	*leaf = bp->b_addr;
+	struct xfs_attr_leaf_entry	*entry;
 	struct xfs_attr_leaf_name_remote *name_rmt;
-	struct xfs_attr_inactive_list *list;
-	struct xfs_attr_inactive_list *lp;
-	int			error;
-	int			count;
-	int			size;
-	int			tmp;
-	int			i;
-	struct xfs_mount	*mp = bp->b_mount;
+	int				error;
+	int				i;
 
-	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
 	/*
-	 * Count the number of "remote" value extents.
+	 * Find the remote value extents for this leaf and invalidate their
+	 * incore buffers.
 	 */
-	count = 0;
 	entry = xfs_attr3_leaf_entryp(leaf);
 	for (i = 0; i < ichdr.count; entry++, i++) {
-		if (be16_to_cpu(entry->nameidx) &&
-		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
-			if (name_rmt->valueblk)
-				count++;
-		}
-	}
-
-	/*
-	 * If there are no "remote" values, we're done.
-	 */
-	if (count == 0) {
-		xfs_trans_brelse(*trans, bp);
-		return 0;
-	}
+		int		blkcnt;
 
-	/*
-	 * Allocate storage for a list of all the "remote" value extents.
-	 */
-	size = count * sizeof(xfs_attr_inactive_list_t);
-	list = kmem_alloc(size, 0);
+		if (!entry->nameidx || (entry->flags & XFS_ATTR_LOCAL))
+			continue;
 
-	/*
-	 * Identify each of the "remote" value extents.
-	 */
-	lp = list;
-	entry = xfs_attr3_leaf_entryp(leaf);
-	for (i = 0; i < ichdr.count; entry++, i++) {
-		if (be16_to_cpu(entry->nameidx) &&
-		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
-			if (name_rmt->valueblk) {
-				lp->valueblk = be32_to_cpu(name_rmt->valueblk);
-				lp->valuelen = xfs_attr3_rmt_blocks(dp->i_mount,
-						    be32_to_cpu(name_rmt->valuelen));
-				lp++;
-			}
-		}
-	}
-	xfs_trans_brelse(*trans, bp);	/* unlock for trans. in freextent() */
+		name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+		if (!name_rmt->valueblk)
+			continue;
 
-	/*
-	 * Invalidate each of the "remote" value extents.
-	 */
-	error = 0;
-	for (lp = list, i = 0; i < count; i++, lp++) {
-		tmp = xfs_attr3_rmt_stale(dp, lp->valueblk, lp->valuelen);
-		if (error == 0)
-			error = tmp;	/* save only the 1st errno */
+		blkcnt = xfs_attr3_rmt_blocks(dp->i_mount,
+				be32_to_cpu(name_rmt->valuelen));
+		error = xfs_attr3_rmt_stale(dp,
+				be32_to_cpu(name_rmt->valueblk), blkcnt);
+		if (error)
+			goto err;
 	}
 
-	kmem_free(list);
+	xfs_trans_brelse(*trans, bp);
+err:
 	return error;
 }
 
-- 
2.35.1

