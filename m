Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6545F5012
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiJEHCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiJEHCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:02:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7472B72EE7;
        Wed,  5 Oct 2022 00:02:02 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2956hcTE000567;
        Wed, 5 Oct 2022 07:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=WM2JsGMlHCb4RaotgOC/SKqZ2o8DQ+c1pxJwQci++cs=;
 b=LttQqDeN4oNUO2uOwxJpSXokrQPPF1lkTz2iMETW1kfQQ+i+MuRIWC0zdghvvKYdGvha
 Epfdtx1fxxzjB+3jyqAXsNa30YOSWtO0unuWkV/A+mRjk1NJGKz/pM2nGZ5bPaWHda1C
 +nFHibP7LYg58+/1mJrhq0JhQKt7/WvDW7i3B6Xq5GP2DIqAX3P6a7SloG8Z+mR+1QSj
 eRvBBBVgHWhJJuVXunJhVWcjindzaMkRhkwGxAfuE0UCGf9ZO/PmV9UxD31j6O8xIx2L
 lOViOfD2durojqSIMaA3ECiHg7HPIgFd4SGV1C/w2ijwkjoZrVa52CWucYev+CRpNQQu kw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5tga8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2952p4Jl033872;
        Wed, 5 Oct 2022 07:01:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc04wpjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AilFlRWR/KIDYqVzkXlm2VXIV74hFHglZV2ITTi3w4Yn+0RIn95Etm99Lluc/fj8pWua8vVE9iB7wDzKtZJoUidWlU2/QIEBarBER9elCJ9j7nPjWGwfWZvnSqYtlCbIvVckoaSfySm0GWKV40UzxzqaOTDNUhEpWjjB9wrs1CyPPv3v64QoXWIv99tnbImG3onw+pHPintDhHv864VVjsnxSr/Y7VEHWCYPkRB3CbstQCSpfdkKSzPgglJfQyUaxAhGTlbbaObw437pdDmBkeLEi2fV4AFG0LI6P3Ut5TB4gl8zhGcP6VIwlp+aFY6XVkxF1CjE1deuSBMMz4dWHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WM2JsGMlHCb4RaotgOC/SKqZ2o8DQ+c1pxJwQci++cs=;
 b=ec5Au8q+KAVdOA7ZpHhJedn72XKAhVAgvOigDml2wJMLVsjEm47jUsaSQROwT7MB9C60ww/WlzngHeodOimTmlTXilkCnDQOoTzCBKQfK9krGwA64A1wd5/Eck6I9If7lCTlP6Yrr43SxanxhgMy+/MOqloDyw9V9+vGQq+EvpZ+jh4eQZvur6IjwZA/u+57jfHyTztWFrIg85J2UfxWneIDgZ5OANf3IFmL8heiSBl7pHD4wcqMIkT6QRUKpDv5aX9jAHZw153PWWfbvvC2n1IWI/CsCR/HwYqDLviYwvJLNRZeTWz6w3j32EloRBMm0dCb4zYTIZb8Yn3IneFH2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WM2JsGMlHCb4RaotgOC/SKqZ2o8DQ+c1pxJwQci++cs=;
 b=KPixC8YApXtWumYc4fBAe65josa8Ikx+OvQxpT4pks4LtGhdxzU3shlc8VWSkaFEHW6E65SZjlbCLR8DxQRcY47Ts7vFtyT3kZCwSoREif/RhS2NI9tqzZ3UPpYsyN/gZ4u1o95Z8BW2pq++kdbRYE3luAaO2RYOXUgNn+s/KL0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 07:01:55 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 07:01:55 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 06/11] xfs: refactor remote attr value buffer invalidation
Date:   Wed,  5 Oct 2022 12:31:00 +0530
Message-Id: <20221005070105.41929-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221005070105.41929-1-chandan.babu@oracle.com>
References: <20221005070105.41929-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0066.jpnprd01.prod.outlook.com
 (2603:1096:403:a::36) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d459a79-8ff0-4df5-2abb-08daa69f7cd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nywf5tyZeJtEYOqiBuMDBu/IweGBc3pDHdfB9qmAXKU44jSmoH6xQKQQx+VhrBFNRe9GY8wZNriqy1aoTKvzE3GfusXm2suG4HBdag43EQx3BkO3fQwUFAe6gFXS8V5RAwBhG25h430Ut78s0ZoOGPXq8dmjrJRQdnns/3rRE9UQSLMrEcDcwqy4CHTEBh/slkaOcrOTld7R8iicNFr+9ITADts19psmRPRJU6BXy9AUk80+mUoSee7bsenluBHBZZl7wy4BM9C4uzizX8G7OFCdgGDWmmj3bjqHBoGIs1x6tcypwpSEcM8L9/U7ue7JIsqa30BwqLGgP5XVeF3tE3gPuFa/JGb6qwVSaEd/spETSbsZEE69msv6U5jyuUNQYoXGjnm3IVhPQ1hKrZmi1p3MhN/8XzTlAKGt45ABrrsHC/FkJ8npdvjkbSp01T8kQ9dVsS+4nKYRGFKPGaQ7AfkLEjK20QyuanbcJGPrIMLUFOIsTHCB4Si4g8Evbjpwtop3GnjNEY3CJCuybXuy8eVaruWCb+x/cT+t1XJPZjVsfzAmOwUNkxPqBe4JfvcU4c+DVrHpY6mgmZgA7ovtJJXh0jMATeZgvfumjqAAC31XwLI57HPLoRZEu2/RvcvwfUimh5/GsJxaGbcDZ0PxouPV+4SyOvHaMG/aGEJIH7pdJXuw1hqyIpkNiBN3Mn0EDf0yB+8Er2Q8hqXcXLEq3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199015)(478600001)(6486002)(66556008)(6512007)(2906002)(66946007)(5660300002)(8936002)(2616005)(6666004)(4326008)(26005)(8676002)(6916009)(316002)(36756003)(6506007)(83380400001)(86362001)(66476007)(186003)(1076003)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I1BdN8XGYfZ/iZa1ttHzpxsrPVlRV7ZDhnH+U4R5Xoj+VmDuIZ9IpT2Li9zG?=
 =?us-ascii?Q?fJRAimv9azHjNFF2wETtoSHWOO89H0WRIhKUsZt63w2LFzOWqm49zW1nkneC?=
 =?us-ascii?Q?F8X7eem1K9/5Lwbt0ryagyDZ/D4IKWG9vFOhQxPFVShLwM0kQ5095xYuGc2r?=
 =?us-ascii?Q?E78hSLWtfIIGFUX+hSRqhYlLunKr2UnKPlraq7iP7ZUsu9AoFFZieHVrDvfk?=
 =?us-ascii?Q?8eDquiz8dTkMbmtUcgbkpYGLhLs9qzD89bf3cmmjw2Jq+iKhZRGj2vYsJXBI?=
 =?us-ascii?Q?Lb7l08x9hvdsYpmZWRLe3vB+Xvz9aDPvloIdXH/w379a7NRoFb7uwNxC0JAF?=
 =?us-ascii?Q?ed0e1ML00zan5HclsMnnb7dEDuyLuh5/2mauNEnNpeRCQqlBskE0sC6U5m4f?=
 =?us-ascii?Q?/UqxgoqGBNIGDRMuPdIAII0bux82rRxVCN5EGzkmn/ziBW7cAdWjzuF6oWZq?=
 =?us-ascii?Q?1Y5hV/UQjhCXaaNRtrHLbkUlFu9NNMMxN9nNnQ2IatLGQzrFbpLO8TldmnrZ?=
 =?us-ascii?Q?gu5Vd/H+TE4Bg14/qr/ZtuUfvjXTrrKQlOJNjjNYfOEXOam5LjCNBix545ZZ?=
 =?us-ascii?Q?iWvo8aR+4dyEC2VR5T0t9hSLVET876M4QY4W8B2Dq8Fd0AZcs4rmme7KB2ES?=
 =?us-ascii?Q?yb/dEigRO4nsJMdwzKF1/9BImOcgwSpLjP68yKeFfTw83bGCY2IAoqkLirK2?=
 =?us-ascii?Q?acKIDnbNzd+gTzBVfNQN6T3lhsqbUbTkLelpEbce5EXE0OAPt8A74hStv2/x?=
 =?us-ascii?Q?uy9Fp349KMAxcFvHQjNkRkqIr41kJawniGVDWmgw7byevJs4VJWEnytzDFje?=
 =?us-ascii?Q?hfxE6TtxlkH4ehcoCyuk0tN2FPltAhWdxyZ5w/RQjG2vlRsB5tjQxTJ1Kjqu?=
 =?us-ascii?Q?WuFLpUhv2sOLHXoWU29gDHgTIlg0lQqUvg6ldGgolHCgjXfKGGSBgfjqSn/P?=
 =?us-ascii?Q?U4olDdEx3PJkFMR7yt5q7N+o/TLAzAwLhzsTLgqp/GEfaw+ZJrGcUVTNBAlw?=
 =?us-ascii?Q?9uQkUcqxo+081tyQMDnTXLPTzXlyRFs2wytOyosM99I78BACNC1sYA5Z1XJQ?=
 =?us-ascii?Q?RKqu/MyKNEJlF+R+nl+KH+GvoglbDZ9ywOafkrq9LjUrlXYJZfCxJdN9YxBa?=
 =?us-ascii?Q?OOLK8F1X+MNr1FiU50cveMSXaz0lVO0h8hLinRiH4gL5TcTZP8tMDEcy8GDY?=
 =?us-ascii?Q?52qITGhQipLu6ws/TeRfKEaLw62AgtdHuXFFfPqrn2JthudGYrcSc2qcyUPv?=
 =?us-ascii?Q?PPLcfQFbJXUld9IXUWBcwT7nXXwH2M60divsTtllxKhYeRaXg2UVVd/GEYTG?=
 =?us-ascii?Q?YjKme1Hm8WnDKvTMOhFdafh+1g20eEnJzhlSx3REw+ysIFnyqFCLiI0cOzAh?=
 =?us-ascii?Q?yj4nqnoLZaRUPvyr9LMZJBgCQ6IfEpf6Z5BTdr8qmJJDIedUMOPTX1XmSMBU?=
 =?us-ascii?Q?dXPRxoF4pczsmiumUDrWPJG86220s9E7K5dCFN5p0MGFi46IF7BcEH1UbAH9?=
 =?us-ascii?Q?GAU/DuqeSLzccjkwt/7V5U34ultIiBCW4lYWO3+7HyT7WREUax9GokFSPJV8?=
 =?us-ascii?Q?wCklGEAk9I22Tmv+11XHba/VrXL7sTIoaLoC3o753krOYl6Sbyzy7fWG9WMk?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?zEJyAkbvGNHm1aLj+VwfAnWLkh1wTIC1KHQmYXaM3edehKW8nEeqQsUplGhb?=
 =?us-ascii?Q?0pME/elpU1XcT0T/c6B8qPvfFzpO0+i4jqdVeYeXX1F0MC/gS/NtbGvcuPyd?=
 =?us-ascii?Q?c3ub9WQwHKO5yNElOB5j8orJj+H0bHv73uH8i/LzIxdOpS3wWPiwgL4R5gCp?=
 =?us-ascii?Q?OQ7wrS7ryrk2B1CMNzRHLawh1jE0MpBcWoM4/OHl5pCWo13Mb3YmUxb1FyXo?=
 =?us-ascii?Q?JnA9MaXzLmlJ1nvIwKwt2V+DdF5RQuOarxKBO2t5+ftc/lQXVfetxnqvheo5?=
 =?us-ascii?Q?Kelcn344TeLHmr7h2+QlrWyjKOoWL6pwa/OenR2tZZdDX5Ky7ojUXJH1EYc9?=
 =?us-ascii?Q?y265fiIpfhXDRt2lSvmg1q4UjGx5OPX1mBI9c7+AYAschzyTzs+TfcLDW92e?=
 =?us-ascii?Q?AvHM+KqMIOhM3GQ2cBTZzp1erJdvdRKSbNsAEmr7GUgNzxPd+lsSpksdbOfs?=
 =?us-ascii?Q?K090KQ5rvqaxUwGMBp65diXfVfRUwFkxdiPWocnTptFBT9Nw47O6kflUaUQu?=
 =?us-ascii?Q?R7qtXO044392F9Ol0gK6ral3RKDIk67q/80Uj22HUcOKXUn/15mK1eRUJfzv?=
 =?us-ascii?Q?ryM2ux4fTBoKb+0t0UUk6+obPUYcjd3Evu1YoZ1Q4MqzSh9qGROHAZ+bX5Hk?=
 =?us-ascii?Q?C9ZNmFcPkmjkEV5VCLhu/S/ymQ+eukXphu/dIct0Baeq70SOMXT08pvrHZis?=
 =?us-ascii?Q?CTkWCUP8wIlEqRjv9d7HFotYkyHCrUsCsR3iTpknLXDuiZMv9jvRL8ssoTU1?=
 =?us-ascii?Q?0zybrGyXqS9OhveN+zAE8C5DJ70tiIVhIptHYNzR7s9aZ9xmGCZeocv1QVRx?=
 =?us-ascii?Q?F/AXwiTKZfnZNbkGHEMUMyV3Zjq5SV7b64E19h6mxFUfMoLbe4tPGJiv5Me/?=
 =?us-ascii?Q?rEIgqSfKxXi8Zr2Q+zjUxg7oVeAKPQ8EWu3PB8YOKS7/7pCp53v5mmJtTpDR?=
 =?us-ascii?Q?Xd2b/Mh0dqSH8YDC5zkMUB9f0CdDcV9mnHLz0Vmq/CfUsecbpIKrTf0G62v8?=
 =?us-ascii?Q?W+kd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d459a79-8ff0-4df5-2abb-08daa69f7cd4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 07:01:55.2667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pJz76PMWuIo6RkgIAOTeB/z4Ck0v90aAaLNLSRdhQjtOrnPtEAyw2SbG8yIuwQn/64anwn0I2oWFJXEqIUH52A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=829 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050043
X-Proofpoint-ORIG-GUID: aN-2SQaz08JEHo0309o2A1SoGorUFVr5
X-Proofpoint-GUID: aN-2SQaz08JEHo0309o2A1SoGorUFVr5
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

commit 8edbb26b06023de31ad7d4c9b984d99f66577929 upstream.

[Replaced XFS_IS_CORRUPT() calls with ASSERT() for 5.4.y backport]

Hoist the code that invalidates remote extended attribute value buffers
into a separate helper function.  This prepares us for a memory
corruption fix in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 48 ++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_attr_remote.h |  2 ++
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 3e39b7d40f25..4e5579edcf8c 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -551,6 +551,32 @@ xfs_attr_rmtval_set(
 	return 0;
 }
 
+/* Mark stale any incore buffers for the remote value. */
+int
+xfs_attr_rmtval_stale(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*map,
+	xfs_buf_flags_t		incore_flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buf		*bp;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+	       (map->br_startblock != HOLESTARTBLOCK));
+
+	bp = xfs_buf_incore(mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(mp, map->br_startblock),
+			XFS_FSB_TO_BB(mp, map->br_blockcount), incore_flags);
+	if (bp) {
+		xfs_buf_stale(bp);
+		xfs_buf_relse(bp);
+	}
+
+	return 0;
+}
+
 /*
  * Remove the value associated with an attribute by deleting the
  * out-of-line buffer that it is stored on.
@@ -559,7 +585,6 @@ int
 xfs_attr_rmtval_remove(
 	struct xfs_da_args	*args)
 {
-	struct xfs_mount	*mp = args->dp->i_mount;
 	xfs_dablk_t		lblkno;
 	int			blkcnt;
 	int			error;
@@ -574,9 +599,6 @@ xfs_attr_rmtval_remove(
 	blkcnt = args->rmtblkcnt;
 	while (blkcnt > 0) {
 		struct xfs_bmbt_irec	map;
-		struct xfs_buf		*bp;
-		xfs_daddr_t		dblkno;
-		int			dblkcnt;
 		int			nmap;
 
 		/*
@@ -588,21 +610,9 @@ xfs_attr_rmtval_remove(
 		if (error)
 			return error;
 		ASSERT(nmap == 1);
-		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
-		       (map.br_startblock != HOLESTARTBLOCK));
-
-		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
-		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
-
-		/*
-		 * If the "remote" value is in the cache, remove it.
-		 */
-		bp = xfs_buf_incore(mp->m_ddev_targp, dblkno, dblkcnt, XBF_TRYLOCK);
-		if (bp) {
-			xfs_buf_stale(bp);
-			xfs_buf_relse(bp);
-			bp = NULL;
-		}
+		error = xfs_attr_rmtval_stale(args->dp, &map, XBF_TRYLOCK);
+		if (error)
+			return error;
 
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9d20b66ad379..6fb4572845ce 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -11,5 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
+		xfs_buf_flags_t incore_flags);
 
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.35.1

