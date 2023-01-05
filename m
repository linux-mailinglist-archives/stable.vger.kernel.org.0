Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA1D65F3D9
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 19:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbjAESim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 13:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbjAESil (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 13:38:41 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A6F5833D;
        Thu,  5 Jan 2023 10:38:38 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305IT0pX006625;
        Thu, 5 Jan 2023 18:37:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=KUWMGomMuXF9tI6SsY8poBzvu+IZTVGXBDR9YywW2oY=;
 b=K4Yx7HW5SJX239TYLjorMG+T4CqdkZ/zIgHxRhXdaXd/2ZteQ/cusAuITdeWoatzDXIp
 LFkqCA1PPct37Z1vAZgTAFDYXNjlu1qdpnJ/wHuT0abU9MQ8i3lGxhF3RHKTnEoYcmMd
 M4cxC0WPoC/ZpqTOFtPVdHl1pa2q0JQ4ZeK4M9pc02pFu25OaNkfwfMlb9gDk5xGSmvo
 Tyb4pHNUFemSKT9bido3Fb/tKE2UYj26iKE4WBnq5zSY7nQDrSW7nVxtee2eJASNCver
 ly39dzacCh2lzU0QXVOKTQ98D4SPJKFqCJG7HCFonaEVw5uqNoXt74EIY5bM2j2wrVZe PQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtcpt9j50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Jan 2023 18:37:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 305ICxvX027986;
        Thu, 5 Jan 2023 18:37:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mwft02jr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Jan 2023 18:37:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1ThhYeoydiisS4ho7xcUQw0jVrJfJm0O+RxGgA5nBWoK1BaVQ8S7hYv9GHrUCWiw0KBrXZ0fWPROkDTmEFKISFSrfRCmrtcu9nDMYAprDj5EzMwgK1OCGyVoMNUcFaPoI8KGLEvBH16+LEKpJPsW+eUAZ3sQmfcn6EnkQXmbMJknwX3GLneV3DE7gQpOBHuo3ekZz7mhxlPFp7Xc7HACsCP0ZJxnA8tN3abl7Ek9aqTvux+yt0OIfru0/CgirY17GC2Q0BM3w9NZ16cPv1hXHSEkiZilOwUKYiX7JQjSGedb33Da4jvsRcks0brbbgivRkGvb6T5CaMKoIsNPlu5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUWMGomMuXF9tI6SsY8poBzvu+IZTVGXBDR9YywW2oY=;
 b=cgk96ExK/rh/iXyl5No8lF6EEkTb3dnlrTGszpTQCYbEpq2JNId/5ZXpnDA/4sFQ8SBwVLWiDs1cmtvGhFA42NJlssM2vBrksIca6v+uUVHnKFoBD3RhztJ/ulnYkHtXpU2hE578JlIN9VXY5f5nrUq3b44VT9KJkGtXk6wOb7mnAgFT5jTdsu2s1rY96FLhtSgf9JPujmtg+pz8Lx8ftBXqppfjqK+TFE7RAEVZMooEK+WJk2/pTCkkeTtQyvzZSRTCX6CBcq0LnUIAxL2aV+D0YfPik8gm0Ft8Q8cUDdex5J5PKx4avCtl1CFoMxv2421jIgDoLf9c3oXreKtEgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUWMGomMuXF9tI6SsY8poBzvu+IZTVGXBDR9YywW2oY=;
 b=xSkBwjsuEiihuIldnRhorMus50jqaLHHwGWJczDggbRhi3GscMCFLPnH0xvrwbBD/AfyWzicMKr1rrsYFXAHwn9VrdGwuo4FR2V0b95clKL9pi0QahHPvYl/1XeZRMwBFPGjifOkgaemtYhx5JUBS7qAgA8RKtImzpmKlxCjcns=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CH2PR10MB4277.namprd10.prod.outlook.com (2603:10b6:610:7b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 18:37:45 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 18:37:45 +0000
Date:   Thu, 5 Jan 2023 10:37:41 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/3] mm/hugetlb: Pre-allocate pgtable pages for uffd
 wr-protects
Message-ID: <Y7cY9XHStZv60P+z@monkey>
References: <20230104225207.1066932-1-peterx@redhat.com>
 <20230104225207.1066932-2-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104225207.1066932-2-peterx@redhat.com>
X-ClientProxiedBy: MW4PR04CA0364.namprd04.prod.outlook.com
 (2603:10b6:303:81::9) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CH2PR10MB4277:EE_
X-MS-Office365-Filtering-Correlation-Id: aff75cac-e10e-42a2-c3bd-08daef4befa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dx/ZkUV98kYnSAc+fbtZVt3EJs0RZSFaucoqTseCeCMtKoDUaerlNVJCMUGHKLuD93gn0A4JQa2d8F1L1sfB8ZYWtsG5ZVgLTZstb2kHYBWen9bmsIdkJykk7QRw95jFb8hvRKQPDfrh5XA8FhgcvYqckvOcWlEx36zMtfwOHGpGhE5NMvjxuAMy6ufDHx+lZKHsERIVLzcljsWVpyEHHYlLDf86mi8jTy+YSz7kCLBicQf70Gpf1wkixniYgRVKaRtK3pV/zx+xRrddOHtvuUcyu6V58OPgsjMSwUAjaVuNMhsMezsJN6EKuE2aC7bqgTIn5M9MeTZsnhZes+k9TVWnBfbxGwTnfFAYNTkZmFiVqfE/X7EqexJpnz8ru2hjOLUbJn7jg2Doo4jLT57zUn2UXE+O46FPyxvlr7XkzDgtQoBrWanGTnVYmnP472QPbNR9ahXqYkmrndDrWheT4Qg8HyIpgwk31T4Spwj5FPzlwgi+S5qxv8WpjDvbMpLEWW07rvqXlt5QOnAs+wMGopb0s0YkdJx5OO+N4QT1g70CO/5IGqmIO9Od2epFFBOzenzhA+13sTQ8LtJg7JyggUijximAYeAfKws/Vr5CsBUsKIwLnIOvXf97/0qJj86yX6GqaKppmDoptOJrametkH67kdMjnMGdSBUMND3H/rYs7KdtjHwTCR7FXSrPYn6P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199015)(6512007)(478600001)(44832011)(9686003)(6486002)(5660300002)(38100700002)(7416002)(8936002)(6506007)(66946007)(33716001)(41300700001)(66899015)(66476007)(4326008)(66556008)(8676002)(53546011)(6666004)(316002)(26005)(6916009)(86362001)(54906003)(83380400001)(2906002)(186003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+bMAL7Xb7SIxOxttWc1TQ5XWwtlT9hg1VVB7EXxlhNcdGxCb8ikOPYuyWA8n?=
 =?us-ascii?Q?ULI+TbSSS9hqUKvMHq3StHjih4y+UHMrsPfTaQ95HVKWp1rpQa1uljxYJNXx?=
 =?us-ascii?Q?DHMk4qOIsGdUqFg3x31ld9PNwthgaKLnT+b0tXXIz0JyBliI4i1O1ofCnuSs?=
 =?us-ascii?Q?AAn6z5E3bBEwgCSPwVn9BX1WP6+dp9rO7OVBVFjXZC3h2O0IOiTup2dtQCCj?=
 =?us-ascii?Q?byNUjtGGEgI8NlUo9+Yi0lqEwsXTFzc9i8E4zRvYXo1pYngFdiAzgpeX9YDb?=
 =?us-ascii?Q?ggEPvzvUSe+eOYO7C6WzehXvhZ9UYODWOT9I+FS8LL/eLGnWf4FOCzqjb78f?=
 =?us-ascii?Q?aJ72J5qSvtzcpgwDjqiuPs+CON4+z4FcvpaoaJhjNLtwd8CNFk+7S/2p8ZlX?=
 =?us-ascii?Q?geTq1flyxZCS9gl0OqYGFwyKN5ohBYmZxzX9R+TI5LCd8C0FbYj22V+Z7K/j?=
 =?us-ascii?Q?N2XUfXC9lVlHnyTk+vk1zTpITnRQHbYT6daRI8EI+OyaKqe4UPlkb2TS+4HS?=
 =?us-ascii?Q?kJWTBd8MguwGEEoumsQ83KflHRgerxqJUSHDL+u4B6aK7QuqINz1CLg+Cmwq?=
 =?us-ascii?Q?vhJr3z8pv7fBIdHmcF9u1dEBJXr1+CAUt7BRlIaGfQCD7bcuRhBUO21Z7MSQ?=
 =?us-ascii?Q?vgw0FPKZmbnQ09RHPE4mvF+/FYlPpv9H6+kY1lZL3kxRuPgfhvgu2VvfZidt?=
 =?us-ascii?Q?0h49h1MVNUXSiDtOuGvpTW2xXNSBYlIepUwcc+VtXifUUpwb8vD+ER/CgNDH?=
 =?us-ascii?Q?zMuvzDxeSRB4MwI0H4+L+EJNGvENEUBrnwgAJ17YVZIcuJrEoma2U+QrCXlm?=
 =?us-ascii?Q?7afhOsD5kw4tCmaqhxk95VCJsYR2m96omtccyx+qGVobWm5eNogf9m93nawC?=
 =?us-ascii?Q?gqFooyn4c6YuHT3i+Coxb3cdhz6rtdkGJFldfaKSxqDIDyJJ/ihlacYXdeWL?=
 =?us-ascii?Q?+thbSOBs3WqQJ1RATxuCrJBUOE6MXdoyy5Yoctj7uXNYbwE6ekCDMawr6jo4?=
 =?us-ascii?Q?T1uWRmnIHasHQi7uPJm9tdI4XMMokOlegMw11J5+o4wzAljX5v0rvphhE6Ly?=
 =?us-ascii?Q?NkEWVvx+hdnEQfryoTtdMB62mEeXqIxvM2yVWxQPy9PkPZPhrqQle6A8Ea7K?=
 =?us-ascii?Q?Pcz6giDxy9E7MBl7RCb5auXGKLxOYU8ita5mDFOFQrbIFPoGoO5EibRJwW7+?=
 =?us-ascii?Q?A26sB2sU21TjCcq244lvWsBQjgIDzLuDFLHwygbgue5QFWqvqL2pqledP3O+?=
 =?us-ascii?Q?1tW8ve7WeElmADTEULHTmVc6VWuXm7Z06LI5s8Kn87dI2W5EAYfKL/Y2Oaa0?=
 =?us-ascii?Q?8aExaSPfv0szbQHYhF/bAsm8+wmxMDWjuIrtc01gXNjLgUlHGp5whhgmDBzQ?=
 =?us-ascii?Q?QuHINBRpGqZHKTIS+7YmlzqWfeOGCBH29/Ion+sgp6BsnkwWacApJaMnTnQT?=
 =?us-ascii?Q?khbW847SEP7DHdFSKZLmYDtjNDV6F8mLrSeOaH8tOi7z6C3M+p3cfs2X8RK9?=
 =?us-ascii?Q?xh73Jo8Dx8LOeGVow8Kn4HVlNIahxqBj/ntyRPk1hjpW8sJZYxGPM2yu10Od?=
 =?us-ascii?Q?q2xVGXz41+PavpBaRzx7oyBE/fUYQYg3waTTwJsidsaFgxBZdXAS68WxRc93?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?0aC7F4NxP8vLgu334HCPXAIkz2dJqnPo3oEw2wF2CKBNERNpPjaCh8UhWB2H?=
 =?us-ascii?Q?tKY5xUfFGw68IgbD0/sqSOZBnNJG1+zfD7ejF1ty2Uwr8s9nmqO+GpKSX9/e?=
 =?us-ascii?Q?R7NnzUxsMh+MqvsLpVms3wo0jaeYzCYNsMfu3RtmJRwZVamIA1x5rmG1SMk2?=
 =?us-ascii?Q?4t4qMD3JaoiSL6Pfx9mMXJC4bD5PVB2OWPG1KmX1vhYzwSyd4KVtxnka7MlL?=
 =?us-ascii?Q?1MPCbOKMp8blgkyao6jhPCtH6BqEp8Wq5UEEgRVT6bkk3pxF103JoFbdvLjW?=
 =?us-ascii?Q?lJcTIPDBT42DS5zwYtduUp7Zct9KSiVN4TvCCAd8LTyczYlegNWY1YWoNEp8?=
 =?us-ascii?Q?O6NNODnffWdtjMMDVeafxsg+uQoqB2MFR8QfwJk9AXhTzeFiYCxeJEFPQ4+z?=
 =?us-ascii?Q?Mc/e4CoLclregVwlCUYKj3zA6VrgBZx7JB0W+++ZJJLiciACsv0c1/D0MLmD?=
 =?us-ascii?Q?3/EI3Kttw4YkpsXRxVVxLKIxwXIYes/G0IRTlHC+Tco+yTBO782adzUfk3SU?=
 =?us-ascii?Q?noAKR18IBxexy0rMQiuTO++pBzxxOIFDxf8QCcrJUSb6d6afIxFXPcpnctIt?=
 =?us-ascii?Q?9TDec9RRmrlGUyR7x71QUqeo2zewsQ8smtvX63iZb9blvZQWr0m2TLsYKcg6?=
 =?us-ascii?Q?+DhznqrvKeYTu6rz1zgXFySAte1VFDzsvwdaoXyZa0oaxfnQOOU3cV7Nb/ys?=
 =?us-ascii?Q?bxQKX7AI3C37QEoTU3/1082GNANmtESWYuG2FwJnrM863EmDDZ4Jp4S0UB1v?=
 =?us-ascii?Q?ZCN+A/Y95nF8BMiwxBW9vOv0RYk60ya/lJcwGBVeiZ8kQo4W+6XGuxiac6Q9?=
 =?us-ascii?Q?lkPW40sesnHr9TZtkPsU5TUwipSIdaXMqTc+W8y0cLPwM6AGotQpp9Pt1+O6?=
 =?us-ascii?Q?zDluICvHpn1GJBzk4YsVQTI1ogtETztBiHL12yqXUwqMKXw/U+dgoRd7HSTA?=
 =?us-ascii?Q?6/0L6ZuVqcWifpt34my1e7fxAhzoWUwA6Qb+hZF7xgD8vSm++hYjog5V3TnP?=
 =?us-ascii?Q?196+sVlNQsWjONAC31R1tABdxLPq2iBERf61ZZMwIhMOl7RtHlftcHqKkyq0?=
 =?us-ascii?Q?4H37bENu6e3pDj5QBovnVj9T/aWa5Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aff75cac-e10e-42a2-c3bd-08daef4befa9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 18:37:45.1780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bRKnQWzgSsiMCQOslihvFNPukbJag8QQuPvXqydiha7FNcU8lvi2WIaYAjo8pPGh6OCsIf8i7XtEqIxD7BJsxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4277
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_10,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050146
X-Proofpoint-ORIG-GUID: _EfQqk_SsORFK8a33fYErqCKVRojCABx
X-Proofpoint-GUID: _EfQqk_SsORFK8a33fYErqCKVRojCABx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/04/23 17:52, Peter Xu wrote:
> Userfaultfd-wp uses pte markers to mark wr-protected pages for both shmem
> and hugetlb.  Shmem has pre-allocation ready for markers, but hugetlb path
> was overlooked.
> 
> Doing so by calling huge_pte_alloc() if the initial pgtable walk fails to
> find the huge ptep.  It's possible that huge_pte_alloc() can fail with high
> memory pressure, in that case stop the loop immediately and fail silently.
> This is not the most ideal solution but it matches with what we do with
> shmem meanwhile it avoids the splat in dmesg.
> 
> Cc: linux-stable <stable@vger.kernel.org> # 5.19+
> Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
> Reported-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/hugetlb.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Thanks Peter and James!

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz

> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index bf7a1f628357..017d9159cddf 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6649,8 +6649,17 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
>  		spinlock_t *ptl;
>  		ptep = hugetlb_walk(vma, address, psize);
>  		if (!ptep) {
> -			address |= last_addr_mask;
> -			continue;
> +			if (!uffd_wp) {
> +				address |= last_addr_mask;
> +				continue;
> +			}
> +			/*
> +			 * Userfaultfd wr-protect requires pgtable
> +			 * pre-allocations to install pte markers.
> +			 */
> +			ptep = huge_pte_alloc(mm, vma, address, psize);
> +			if (!ptep)
> +				break;
>  		}
>  		ptl = huge_pte_lock(h, mm, ptep);
>  		if (huge_pmd_unshare(mm, vma, address, ptep)) {
> -- 
> 2.37.3
> 
