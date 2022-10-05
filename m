Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341185F5017
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJEHCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiJEHCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:02:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64BA74CDC;
        Wed,  5 Oct 2022 00:02:16 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2956hnU5005020;
        Wed, 5 Oct 2022 07:02:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=GJx2+MceMZNSWIojKgOweIYYPY4tZFFGrqTEQZF+7ag=;
 b=QEktfGBYWAZFJl5vPB/23Hb9GWoaIcX0OZH0O2tpVLC8oAyn+qo7YCg5R19W7Obq38ef
 seVP9Pjawwwrjkvhq1p3iXBzuHgWefWV6n2cpUEWz/MUqYGvYQ6jTvuixI1LFilm/Eyw
 BckP6FuMH0Kqx0sytHLaOwWv65jpLf/v7kcQKrYcMzgvA3wzGGw0B7pSivrk73CSBgYu
 6uMeWAGT8HYS+NZYEWs40zcU8ezeeyBy5b7ECt4QpTgd+OyDu8dxWfAL2HqX+qDIZ8Ch
 QZnZdxPFEEo4YkNyJuutqtPxhqW97J8VgNcDCEHg9R6995J6L/odfqTGxnrpEdJD+BLA NQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxe3trmje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:02:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2953WGBD019975;
        Wed, 5 Oct 2022 07:02:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc0b5sj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:02:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kqs1Za7Yvclfcbz++UvHRUQwtU0re9GDrpy6QI8lnVBn71zzVFVhheDSaEDbwwT5pPTxC9b1xadhHUCZi3mo5wt50uLGgjjrztSJ+gda9w+LwF+nfoMBr484quArnoAE1zUF5quTvlstCybd8bkfW1AAM+iAJNIufLhAcCtbjiFEvs7agHnDgBSoVwZhdt86PsGd+AyqZYejJwTFX/mm9y0B4CCH5K7Uqs9d4H9cEpVSfyMUJtpro1xDKQDisf2R2EkMdfwidoZNOHe/yxY1E7YHo0A5gdBgd1V021VFC/ekKWbcUBByIcpgJzeUfvnSecrZ6O8qRhX74UzEUifdwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJx2+MceMZNSWIojKgOweIYYPY4tZFFGrqTEQZF+7ag=;
 b=oS9qY4SSMBGxAtaFBhmR8aDAjoyz5HiiQUCZYyDDToRRJpn9CuCVE/NBlRntXf19owT9Atcn3LOVu1yPLvSGIXLjTySFo/dlvKwCZ9iM2iw++uRdNbnluW+4QlVgMaXcGNnS6RY8kU3sQoR/9+L69sSML+RKcCkai0qSUz2gKGToRwzIv8/0ztPsZMNbzw3BjH7A9/zKlEcRWQ/A7RPNZzNJ2yLvwUxO+LoaxPYUlLZq/MPgd5GGgppBfcgvefPDmcSfaPm/1jrJGw99bSL/Y5uqDyfc8OTUhi7sHNztterCJfkXCNXRZVDzbUMSJQ/SLCn4hSjhjwo4Pj/LKEYUiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJx2+MceMZNSWIojKgOweIYYPY4tZFFGrqTEQZF+7ag=;
 b=LapIIbziHNyMnfVZQ5bTCMhiAXk2MWli/+JqBqxJc53MYpSMDdyAJtTPXMbyZo88P2Xk1jISCPhhfHmt77oY4UepVHFteRj84ehUGAeLFqehS6x+qAQolajVimDIyVN/sVourcW0HFiGiElLGApRZaiOPD/zOnUutxo0445SpQ4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 07:02:07 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 07:02:07 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 08/11] xfs: move incore structures out of xfs_da_format.h
Date:   Wed,  5 Oct 2022 12:31:02 +0530
Message-Id: <20221005070105.41929-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221005070105.41929-1-chandan.babu@oracle.com>
References: <20221005070105.41929-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0179.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: d1ae864d-cc26-4549-36bd-08daa69f8424
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xpuwBiYpx/VyfUDy08jCo/2f2BDNbMm3hxCJM1leQgK1AnqSMqQ7ECqALvkuMnZioyDSAfGulwlF6HCT43ln77ysBO1D/UuHP+9FaBr6hkmyGk37W0iIjNrxXyB+Ez3KoDTazCd6Y62sDTa0G7GZmzyRJQn0jE9bECBPyZoMbEOKuOhi7BsvErSCXDlPi7AcP/DxnpY7+9ExG+byO8ATlRtpnDWQUuz+Jn8RsjVYeXuogv0LEfjQEp2q8VxVuXq25eXS9s/7Z7oejkO4T8pepgfqyY0ZmG6+HtBlqgkm8WM22qgF0F6YZMkDQKl9onEUEwiezIPm8CHbBKq8Gsj3Q7BHvqYd6hQ5qMrVjof7l1nKfptFzOOTcSKVt58res7buxrTod+1n0p4+YkCUGHFum4sKY7AFY9cOcKFw8a1NKG8IvGfi/GJHI10XR9lMYC63fF0aIlFiVVIrdeykRLH4454nTebmCGUP7iUjVwcT6VGDYj71A0mvRCmHkl0SNloigyAF7x8YfcAMSfTFoxjzEbu/+AmzlwKZeZXffh/E5MU7PiICdN7eBf0Af5zUkzk1CXQoGNkCzr6zlEttRuFpDkfD2YwZDuCygbI5qqlpT7aW5Cbv1vOAz52oarY4ATbOXUfU/7SxLpERbVc/fe3N5M+Ql3rFOUdnPkfC7TXpQuvPKb7VUzhiyqmWJsP7OK6Acv9cFSVKdVM5fF0w9XEwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199015)(478600001)(6486002)(66556008)(6512007)(2906002)(66946007)(5660300002)(8936002)(2616005)(6666004)(4326008)(26005)(8676002)(6916009)(316002)(36756003)(6506007)(83380400001)(86362001)(66476007)(186003)(1076003)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sOX1uX9UrjqTjvZYtFolqz2j6CVQ1FnXrrKS3I6tZIdEl67jYc8uLT8efVJQ?=
 =?us-ascii?Q?akqeYdw0Z7xllLxB9Y5wW/xfzrUi38LVpsPyilFCGIH4s0ZrhqYi0dQUQ7Km?=
 =?us-ascii?Q?P22lGe4d2ftAG7srCXnJrX8pWZ3bnsk2qt1jRQjE3iJEnXmWV5qImOkKnt2X?=
 =?us-ascii?Q?IbSIpNlgkK1+gGUtwgRs3cihThVvFQCGX+jeTEBUevUcLf5qkIyQx8D6ge5c?=
 =?us-ascii?Q?i7saYSZAEL+Nd+nSwSU4g99i52rqhz72JlYjU2NPibQRGkLRvzJWxtWvXUM0?=
 =?us-ascii?Q?WZrPVIxA198uULj3DIOvs2BbVL+JnC5enNZsTDxZA8/GOMSzteJ5b9iBDybM?=
 =?us-ascii?Q?n7LgZesPizzhh1VgQfFNbi6nEg1MDwHWejTzzgZu7Wjtn82e5kb9Upm/NKN5?=
 =?us-ascii?Q?bOSMdHgAJAxNRC8ZvyrSEZ4Kjp/OryoYsmTmyRQW59M9H/X6GA4rFtUb0EI8?=
 =?us-ascii?Q?I84V6cr1izv99GX18ttCZmbtpVCXRaNaZsZG1pvFaj0MbpVvrex20uKbEZ6C?=
 =?us-ascii?Q?6xBhVEJaoZXvjloB9nRgvOy+s0h2ierJjtA1ol67TKnuhYZMqwqJm1h/JuLC?=
 =?us-ascii?Q?+xs8MVithzkwZYQ7SUmB4q2VQ65ExDosqflHb1VMuEwgkKkSrdW/6S/2iMjt?=
 =?us-ascii?Q?gfT0OQ8wiaINZAfV2vFi5uo7zk1MRvi0h0mM1Pc6+yF8Y3uwpd+lSXvHkZRw?=
 =?us-ascii?Q?TOk7bUk+xRoUgumM8Ts45HxCeW9DRAnkQBFX7jpgAaRglDC2tLdI3fciqqgP?=
 =?us-ascii?Q?f/RIj0VOOTP9Beux+Qu0URYhAL0ChAo5tJ09GvQIpaz0CnACMEpkpGFgNZKE?=
 =?us-ascii?Q?WdLoVNmAGsv668/WNn3ARVvldLmsIBokoMjyIyIHghUyyDNjwadFTScYrTHS?=
 =?us-ascii?Q?zIp+f63rRDzZKdo+3zMXt6HZOrcpSUf6bBzTldKj8ZVK+OFSPDsutZZhnIqC?=
 =?us-ascii?Q?4e2HrtzJaZC4RVPxIurnFXkYw3dr0BwNwYCvqF2pMv1pIgiKA/wkVx8Ws+Hr?=
 =?us-ascii?Q?r+MzAOyOCArdOR7kOPrnnpgzgF/659WbZwiI0EW4I5t19OrCf3AMWRResG/S?=
 =?us-ascii?Q?WtiOY8tbAgVmbWFSicrQuPnsjjULLl+PpJ9plfhR3Qi9Op+x7Pb2UtbrIb/k?=
 =?us-ascii?Q?png0vSpnLsuQjKCRoPKLrpSN9jGDorzgzBdiNn0ax7RrQDDW5LU0nGctq3HA?=
 =?us-ascii?Q?HGhhO6LibdneFoWaYFZYfIHjXHDU8uztB7uQrqx7G0y6s+pG8s3nHoyruJvz?=
 =?us-ascii?Q?wpO+pl+EhFJY5zO1gGdfzgmjcpe0VLRU4I0bSyHT+50Q6ZYWZdUg61PLEsS1?=
 =?us-ascii?Q?rHF/TPruOKLNyKSuGoByone10HGSx9ai+Zis7KbHJR6uwYyUwr5dlV+BE2/c?=
 =?us-ascii?Q?3u796CxHUmzFJ8osyL+mmhvU7G/HqG9D+CvxAbLxnbF2jx3gFD5IqQeP2Vkb?=
 =?us-ascii?Q?SkgflPsj9taQkhdkCkVi18WNR5UThPJ9uX+ln0hiByUTY/lK9hHWGWXfs2r1?=
 =?us-ascii?Q?bDE9DhyVq/jLbgAoo+pusKuUYYu6VduAmT4gvv/KdlD3HWAx/z9U+zJ2nNt+?=
 =?us-ascii?Q?zqjlNI/zYf6u3UA9KQ+nqM1QiRDdzdUXJNM4gWf9bLe5DavvzlYnFUF0Rhyf?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?r2AicX396kglql+M1C4HIyYeAh6n8yrlmnzuTQRPwiICcjN8C4+N1kDSX2bf?=
 =?us-ascii?Q?7BE5kh/0xm+yCcC2zwX78RfCB+aU54tbIUlSwQfdg9TAxWcVXDarHn3cHZGc?=
 =?us-ascii?Q?GUtwgDas72yqIKZ3UsLT1mtO4daSnzSgqQCn+vY23Z5DTzE6LkR7s+8ImKLa?=
 =?us-ascii?Q?GRfFScSANgqemul7M8xLwB/k8NldCdrCvjTXFpykzpN10lFqjzNdS+2FjCKB?=
 =?us-ascii?Q?ofu2bZDRlubrTuSHln2kywjVLFsmibzJomaPZ0LdV5a9H3roXj6aqpdUytbC?=
 =?us-ascii?Q?VTPwF1OTF39CBZbyJNgzMh8NY+dVzFZ6qe04ZIuX2k6tjNL20HYhGt67KeVx?=
 =?us-ascii?Q?0HrSaA2PrR2ZhhHxolf+Z5OBxzDz2S46kipmWfiwk9ktM40fB5SMnLRe21WO?=
 =?us-ascii?Q?dAnbw7rjeu5POWyz0hVVNf0QauKax/DWvP6YGFZ2YPLPO50zcoh1Py4+QSCp?=
 =?us-ascii?Q?FpAcTSLCTRX2Yf0QFsk4qCYctdF/O7piPS5cdIJXgP/+ih3sOttD2GMjY1io?=
 =?us-ascii?Q?IX9XidL4BgHqysXgwQKq1jncBcCUp0JwY79x+WMPjExMtSfVBlCXRHtfPFjR?=
 =?us-ascii?Q?bR7TXskp5Twcn+pt8f7w09nOMFVTQ8Zqu+9l779tGZNwIB/cn7WGPGUEQXyj?=
 =?us-ascii?Q?STrTNL23p1CTeBcYRAYxP+B9sqT1g74mUg0ArFlopkeMIlILfBS59qt19edy?=
 =?us-ascii?Q?N/mJodegAueFfAp6NtDkNn1Tmaz7Q6oyLb/Zr8gT1JaZGUl8zFXDhlCrzW2W?=
 =?us-ascii?Q?xHO1NWofrFl+AyKrzoHef0AWyZstyJkYbRb6qfZt+31e0o960Xq0lpPVarhA?=
 =?us-ascii?Q?7/L7hpZkEznuX2vC73Tgr1kg3TE9wGpcf8ZZMHjM5IUeuN23AnEecVwU1bmv?=
 =?us-ascii?Q?HYiTc2DSLlR+FJCiJiAbhRPWiKHkMrRG7NdIEqxX84vV+BzWiDNL1siOeyao?=
 =?us-ascii?Q?hwPclzL+f6Zj6miNor7rg0LYsT71ipyagQajf1rkvG7bRtV+Pfz8lxnQTos3?=
 =?us-ascii?Q?/Zvr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ae864d-cc26-4549-36bd-08daa69f8424
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 07:02:07.6291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7PqLyKErATZjtdgxLgegoqHpNVquiNcJhhtSNklVE2TASxmkOKPSM7JHEhf3Ftn3XhbMxdKRhEv+W0b9UpfOJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050043
X-Proofpoint-ORIG-GUID: wTIAfdt-QESTZyXn1uhpxyBnn_EBdXZe
X-Proofpoint-GUID: wTIAfdt-QESTZyXn1uhpxyBnn_EBdXZe
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

commit a39f089a25e75c3d17b955d8eb8bc781f23364f3 upstream.

Move the abstract in-memory version of various btree block headers
out of xfs_da_format.h as they aren't on-disk formats.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.h | 23 ++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h  | 13 ++++++++
 fs/xfs/libxfs/xfs_da_format.c |  1 +
 fs/xfs/libxfs/xfs_da_format.h | 57 -----------------------------------
 fs/xfs/libxfs/xfs_dir2.h      |  2 ++
 fs/xfs/libxfs/xfs_dir2_priv.h | 19 ++++++++++++
 6 files changed, 58 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 7b74e18becff..23dd84200e09 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -16,6 +16,29 @@ struct xfs_da_state_blk;
 struct xfs_inode;
 struct xfs_trans;
 
+/*
+ * Incore version of the attribute leaf header.
+ */
+struct xfs_attr3_icleaf_hdr {
+	uint32_t	forw;
+	uint32_t	back;
+	uint16_t	magic;
+	uint16_t	count;
+	uint16_t	usedbytes;
+	/*
+	 * Firstused is 32-bit here instead of 16-bit like the on-disk variant
+	 * to support maximum fsb size of 64k without overflow issues throughout
+	 * the attr code. Instead, the overflow condition is handled on
+	 * conversion to/from disk.
+	 */
+	uint32_t	firstused;
+	__u8		holes;
+	struct {
+		uint16_t	base;
+		uint16_t	size;
+	} freemap[XFS_ATTR_LEAF_MAPSIZE];
+};
+
 /*
  * Used to keep a list of "remote value" extents when unlinking an inode.
  */
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index eebbc66f4c05..588e4674e931 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -126,6 +126,19 @@ typedef struct xfs_da_state {
 						/* for dirv2 extrablk is data */
 } xfs_da_state_t;
 
+/*
+ * In-core version of the node header to abstract the differences in the v2 and
+ * v3 disk format of the headers. Callers need to convert to/from disk format as
+ * appropriate.
+ */
+struct xfs_da3_icnode_hdr {
+	uint32_t		forw;
+	uint32_t		back;
+	uint16_t		magic;
+	uint16_t		count;
+	uint16_t		level;
+};
+
 /*
  * Utility macros to aid in logging changed structure fields.
  */
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index b1ae572496b6..31bb250c1899 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -13,6 +13,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
 
 /*
  * Shortform directory ops
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index cda10902df1e..222ee48da5e8 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -93,19 +93,6 @@ struct xfs_da3_intnode {
 	struct xfs_da_node_entry __btree[];
 };
 
-/*
- * In-core version of the node header to abstract the differences in the v2 and
- * v3 disk format of the headers. Callers need to convert to/from disk format as
- * appropriate.
- */
-struct xfs_da3_icnode_hdr {
-	uint32_t	forw;
-	uint32_t	back;
-	uint16_t	magic;
-	uint16_t	count;
-	uint16_t	level;
-};
-
 /*
  * Directory version 2.
  *
@@ -434,14 +421,6 @@ struct xfs_dir3_leaf_hdr {
 	__be32			pad;		/* 64 bit alignment */
 };
 
-struct xfs_dir3_icleaf_hdr {
-	uint32_t		forw;
-	uint32_t		back;
-	uint16_t		magic;
-	uint16_t		count;
-	uint16_t		stale;
-};
-
 /*
  * Leaf block entry.
  */
@@ -520,19 +499,6 @@ struct xfs_dir3_free {
 
 #define XFS_DIR3_FREE_CRC_OFF  offsetof(struct xfs_dir3_free, hdr.hdr.crc)
 
-/*
- * In core version of the free block header, abstracted away from on-disk format
- * differences. Use this in the code, and convert to/from the disk version using
- * xfs_dir3_free_hdr_from_disk/xfs_dir3_free_hdr_to_disk.
- */
-struct xfs_dir3_icfree_hdr {
-	uint32_t	magic;
-	uint32_t	firstdb;
-	uint32_t	nvalid;
-	uint32_t	nused;
-
-};
-
 /*
  * Single block format.
  *
@@ -709,29 +675,6 @@ struct xfs_attr3_leafblock {
 	 */
 };
 
-/*
- * incore, neutral version of the attribute leaf header
- */
-struct xfs_attr3_icleaf_hdr {
-	uint32_t	forw;
-	uint32_t	back;
-	uint16_t	magic;
-	uint16_t	count;
-	uint16_t	usedbytes;
-	/*
-	 * firstused is 32-bit here instead of 16-bit like the on-disk variant
-	 * to support maximum fsb size of 64k without overflow issues throughout
-	 * the attr code. Instead, the overflow condition is handled on
-	 * conversion to/from disk.
-	 */
-	uint32_t	firstused;
-	__u8		holes;
-	struct {
-		uint16_t	base;
-		uint16_t	size;
-	} freemap[XFS_ATTR_LEAF_MAPSIZE];
-};
-
 /*
  * Special value to represent fs block size in the leaf header firstused field.
  * Only used when block size overflows the 2-bytes available on disk.
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f54244779492..e170792c0acc 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -18,6 +18,8 @@ struct xfs_dir2_sf_entry;
 struct xfs_dir2_data_hdr;
 struct xfs_dir2_data_entry;
 struct xfs_dir2_data_unused;
+struct xfs_dir3_icfree_hdr;
+struct xfs_dir3_icleaf_hdr;
 
 extern struct xfs_name	xfs_name_dotdot;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 59f9fb2241a5..d2eaea663e7f 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -8,6 +8,25 @@
 
 struct dir_context;
 
+/*
+ * In-core version of the leaf and free block headers to abstract the
+ * differences in the v2 and v3 disk format of the headers.
+ */
+struct xfs_dir3_icleaf_hdr {
+	uint32_t		forw;
+	uint32_t		back;
+	uint16_t		magic;
+	uint16_t		count;
+	uint16_t		stale;
+};
+
+struct xfs_dir3_icfree_hdr {
+	uint32_t		magic;
+	uint32_t		firstdb;
+	uint32_t		nvalid;
+	uint32_t		nused;
+};
+
 /* xfs_dir2.c */
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);
-- 
2.35.1

