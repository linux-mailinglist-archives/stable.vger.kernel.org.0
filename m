Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E402B6A794D
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjCBCHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjCBCHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:07:23 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E1651F9E
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:07:23 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MiJxJ011049;
        Thu, 2 Mar 2023 02:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=SNTBVtGbfFCcpemLdlATpPH61qB2ICl9xb77FK5wc58=;
 b=w321jF1uld0QVH38P0qDTC+vn91toduu8LLWN1xJJLFg2iEjSLEdnZAsSX8ir18uFJ0v
 UVz0YJ+YbchMfD6ExXj8AQGm1HooMmdnH/T3jQzaS7UyTMAVHlLYiUD75zd755LAVM/1
 4JGM1gPn9K4zeCN90/9GzeSjxPHwv/FX9/akdOWss3EpOjEvaK/uTtYvzHoGtznRutwu
 AeRJI4q8ysh3dh65TM1F7wCyUsl9/c48ekn5q+8hAHZ9BxOpy0KV5NSMkdq0fXrNDYMU
 v08VTTHkp8xLzuLYk1n2555OI+/KsTwWQpd9FCZ5VViSX+riLkRQ8dJj7pcMjcFZYQz1 DA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nybb2jh4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3220HruL013112;
        Thu, 2 Mar 2023 02:07:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9cpsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ol3hIfkCeMR9nuTAxF4oLW0HjSZwYhpDkz8gdTQa1YvEFQMrJvRsWEB+I7yFflwZgq7rUNk5FpO1YWrZ/om7iHNrod6spgLsidvYVSTVBGzXgNgIpziJOtrAEAXRzgobhLMbEz+HtDWOWHbcAQpI9XBlG7J00usnL9Jl3GBmDtdu0cHGcFNFyUxFar14LnSECQR7hubJEtlIbkCJFIQv44kh11BWMTRAx16XiQeNvsYhiG/A782XnTGNGH9QbIr17xqJt4zNcrcex5H4biSictUCugDjosaoqCmFKOJBk2eHmxv7kAtlOzdyKBy79AQqcPQ2ar3peQ0mrkRNzowsIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SNTBVtGbfFCcpemLdlATpPH61qB2ICl9xb77FK5wc58=;
 b=Ju9MtVo5xlYh0qrU6p+ODQrdzmwL1GkzZNPc6ov2y+kvSyEhTiY/5L+bQTEhRxbIu12bGexqGgO8tYF7DhWuqhrPBDD5/3MhnnpwdZH6TATwbGZefqTzhDVoNjE4ldXsfdHpoKAfF5QC8bjuQwAZVQ+h8a9t5T2FPuk/nVUO2rdO9INcbWSPNZO7RV3nRimMoFewc+89Jcao8DIiqKMTX8c2j/nDpiOZpjrKwTtrZ5XYqleOJGTKELNPFDA8ryos5EMAYKCGFX1/TlzcdDiUrqUqzD3b//ojbfWfkCTkBSCAkEFnSoCi+3S3otiHnS9TnW6ALAMRDdmSeTqCNLgcgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNTBVtGbfFCcpemLdlATpPH61qB2ICl9xb77FK5wc58=;
 b=a4M1RAsNC8Z0BHVSwC3gml3ioX1BGBO4KUTuRmbFRYa4tiATAW0rnEEZg0vzRpIsIgQbXUE2vyD7cvsnjLou4xf3BoCggevV4ezwBRUdOIHA/yDVeqFj98wDVh7tRoY7T67dwPcDGRlkq8pu7cg4xFRnKXGeWK67m+g7Wc+q+uk=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DM6PR10MB4284.namprd10.prod.outlook.com (2603:10b6:5:21f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 02:07:15 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:07:15 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        "H.J. Lu" <hjl.tools@gmail.com>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 v3 1/6] x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISCARDS
Date:   Wed,  1 Mar 2023 19:06:59 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v3-1-122fc5440d4c@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0116.namprd05.prod.outlook.com
 (2603:10b6:a03:334::31) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DM6PR10MB4284:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c14f3c4-21bd-414b-3cbb-08db1ac2d7e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y9yXuAqt+KCgyWCFH0By005wCPtvv+g6Xkf7qTaFnQXsryeoj+J58EtaiCI8FFqpCz53nmIMoLI+vVtSCMTyBgJDC9nEPVXeLmLJ+2jXUw4cJdzvdS9umdT6HrNY7GqXklpjkdE09mAm9Kz5/SgA8XsibyNlH8I87WnvcUPCv5X/oVE/0uKtivj9dfKKBXmQsJyqJaENpMdHxM1vReJMEReNpXvVaijRu5tddNTnYhq1zR0APHLVKHENjVYmQCor1DWuQWngHfItAmpHxvXlvjXN9D36B7gj63ynztKrT08EYEEqGldGnWeNtRz/TGrZ4zjm0tg5EbquXzZ36JmRnOfTv46/U5ZjnsWDzwdITYSqdZKpo7qW/VEbPPSenbIOOOizA9LySeZDF7h0kWZpgI0ypBd+fwPDIPHT4eTuhlZGmagfe3+DKMoI0fbhpnqVo4fBDxXbH+1SvdcDNDze7s5fmgBRFhYQOAzVqZchRgHAbw0BVxDgHnFYVkcz/wfVh4FWcbU5rX2i5UGkvj3tTpz1uSLRCPLF7jfdDv7OI0yXkrFx+L1wqJOiFobPMUMMEJOB9SbEwT9kUsUgpoEs5jrXrR0RJe2ITHKHdGy4Q3uBrAQD9/JB1G6bQkjemweyZfyK0Tf/8gYmn69ELkaiNya3xpbCRn4CWkPcpXZjOOrSzeY2wjPXToQkXLjvqLpA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199018)(5660300002)(44832011)(83380400001)(41300700001)(4326008)(6916009)(66476007)(66556008)(8676002)(8936002)(66946007)(316002)(54906003)(38100700002)(966005)(36756003)(2906002)(6486002)(6512007)(86362001)(6506007)(26005)(186003)(6666004)(478600001)(2616005)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEVoZlBVbUEvQjhGWEI0bWZHMWdjY3dHNXlJMWczbDl5czRXS3loY0JEZlVZ?=
 =?utf-8?B?akZyR0ZvTkpOZUFzNmg4ZE42YWIxSEk3NHRnMmU2OUJUajZpU2pvZDVWbWs4?=
 =?utf-8?B?ejg2cnl4ak95NkVZeVQvMklGRDcxYU9Rc1hsOFUxbTdxV1NxTXRUZlZxeFAw?=
 =?utf-8?B?Y3VYWk0vTFMyQnYxN2pETnRUUFZGM3R6NERRV3ZUdVd5NkhyZjJVdFNoQm02?=
 =?utf-8?B?dWtzSHllWVprdVhnVTdmMkNnOVN6RkgwYmdQMVN2QlZCSkw4ajArVkp1MHpY?=
 =?utf-8?B?eTJZUlNZYTR2aGRJT0FKZk0yNmk3ZFVyUGVqcmNpUDhsMnhkTW9rTUNSdEd0?=
 =?utf-8?B?MTlKVGxBS29tQmVzRXpWL2wzMkRwVTk5NjQxb1pXSEd1SzlJQTRNcHQwRXhM?=
 =?utf-8?B?ZHl6Q1YwYWZjRWp2WnMzY3hKOUR3ZjhYYWFvMXdOSUU1YVNRSXN4bUVNdXlW?=
 =?utf-8?B?U0pKcGpUSm1CMVpYcVd5T09BRFhCcCtXMXRscDNzeDFlUmRVM0N6U1VpbW1W?=
 =?utf-8?B?bmJ1TGNaVHE1WS9CRytxMTIzeUgySS9LSWVGNW80d014emlnb2JHSHdWR0xY?=
 =?utf-8?B?QlFzN1FEOGRpRkx4U3RBTjFjczhQSFNZMkw5Z21OZlhVQUZFMXB1b0JjYVRK?=
 =?utf-8?B?eXc4MkR6T3JpV0hTc1lhQi9mdlUvOEROQTU3MmtLSHBYMm1sblIvbENDcTZt?=
 =?utf-8?B?dTdnd3NpeW1CeVBZbzFkTUN6eHFLT2Q4VkhLTVNDaWhyelRWTW1lVzRZbXZF?=
 =?utf-8?B?Ry9yaGZnYyt1clI5cjNXWDZHRG9ZcUxIaC9OV1hZbXRjNHFJQjJGL1Z0YlQ2?=
 =?utf-8?B?TlFkcDVkbElRUHVPejVLaGRhazhMYVJCaEJFTXJDZ21oK1MzamhvRmxZZ3Uw?=
 =?utf-8?B?ZTU3WDZBUE9uekpXT2J5UmdBUCtBUEhzZDJidDVRQlduZVJLOFhSUXYwN0s4?=
 =?utf-8?B?d3B4b01wTUltZHJCVDFBdG1zQVVBR0NqWXI4bHBveFRVMzhKcVBvODFMeDVx?=
 =?utf-8?B?OTdnWDJsb3N0NU5BS0o2NGUwalFQbjd2WDhZODd0ZVViSEtXSktpVWlHbjkx?=
 =?utf-8?B?VExOZ05zR09ldi92NTQ0Vjc1a0d0NlZTYXVBQ3NyS1FnTVVtby8yT0tMZHBr?=
 =?utf-8?B?K0doV1J0dE1LaFVITU12TVQ2bUwxd2RSZVlKRmd3bjhrQld0TnhCdkl4V0lZ?=
 =?utf-8?B?YzB6a2RPTTdFc3NRTnkzSmRicldtRC9MWWFiY3Q0dVJ6bUVIOUpuSW5yeFNj?=
 =?utf-8?B?WlFXVGI1TGVvczhpZ3NWNHlhRFpzSnJuNjdIVnJtS0NOTVFYelB1eVJJMTlZ?=
 =?utf-8?B?MWpBc0J4RjBYb21EMWliN2NweHpwSXpqV0tjMFlqdFpjRERvdTdhVmVqZ3Ft?=
 =?utf-8?B?K0RERWxjYnR5aFYrMDBiNWNTTG5SZXdRdkhqU0xzY0RrcTJyakhud0orMVkr?=
 =?utf-8?B?VGl0Q05nVlRNa1k0UmI3MzVlSUFSSXJPVmNyRm1NZU1sZUtEYUpsQnFHdGVM?=
 =?utf-8?B?a1hGZng1dHZuZVlwVWZnUzZCcis2VFhnc0c0YWVwTlo3bHR2bGJrNkpiaGtG?=
 =?utf-8?B?Q2lxUExzdVp3UFV1d0s1c0VsZFgxd1h5T1g1MVBRZk5iZ0FMNnhPaHp2eTN3?=
 =?utf-8?B?K1o2aE1pYUJ0RyswZmlBWjFIYm96VzA2RkNUS0h0bmV4NlBKZzFOM2kzUWZP?=
 =?utf-8?B?YW93LzJWdlFQb3cyWERzSDl1WVZWNnJpR1psTzN4ZFZ2SjRTSStxVjVCRGk2?=
 =?utf-8?B?OXhDY1hXY2lPSGxDTzRkeDhVbXJFRUt6TFlzQkxrWlFhZTBZc0FVRkhSclFv?=
 =?utf-8?B?azBoMEk3OTJUaGZTckUxemRVbmpHTTRwaTVwNnUwWXJzYWlWSWhieHc4cmNS?=
 =?utf-8?B?c0Z1blBHQ3g3L3JrUjE1cnI5cUJRVHdNYUE2bi9VUWJZTHl1YmNCMTdXUmkw?=
 =?utf-8?B?eFNkdHBMRzl3RFVpb3pua3lnLzZsejNmaDNBWERRUEQwU05ibVRsZUMzeG9i?=
 =?utf-8?B?RGZnTzYxcXN6bXVJSEZHSGlNd3lzbEk3c09uNG5wUVNUNW44M3NaZFlFYytt?=
 =?utf-8?B?Z2tIUjE5MkZTRHFwN1dWUnBMWHdRTTZxVmp1SzIzZCtiOCt1eDdBaERrRUlN?=
 =?utf-8?B?cGVVeGYzbVlyNVdFV1RTSm84RG9TUGh2bTZqNjZBUGlDUEVobXVrcWlRRlJM?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: z0rAGuxeSv9z0nHh7jABiggr+6gKF7CKGRuFJZ1yD+N3KQ6WgywPm3K2dMGWMX6Aqm36jVCF56ypHmnvVSTme9RmF7C+6hA2xsAtlaod6xMUPXwwtHdzO4CDjY9KaLIjXWcl5K5jaC/qLi4DMI0Vawv8XUP4cV7WuESn0jfLy4UZo1bZLXAi6jro31yLWxp1gs1ZNnXGkhy9mXN8nQ81VRkjK4nlAPGsF65WHpIR33JFUcpGb/pe75gdmxS9sVb/vC8O7F5b9IF4bb2vB6anMaU86PTkO/mK5MvcydjRs0hkyW/+Ke92kMrCrchlJETve1AW4r4toud5kTA5b71kmXp06FZJ/Q5bPOI9X68sNpVE6WR26gR+52wZyUnm3iTwFqk1rmhRrbyhuiM176Tjbwmqfp5BQoCOZaUgQc6NHpSTp4HnlUVyF5qC8eUKsWnx1wCyxZJKIcT7732dqXoBgRL+NDRP6561bzX9IH7OwFa+tr2/BQk128t5iMZrQnPpZbDzAyGgK4CH9ggES1qeKOWPO7vDM2JJDVecpUtljTqVmIfMmP5Ps26e+ex6lYiwl4uZpcoNlihLciJKI3eWRxRaHL8etAExaXOWIprTlpFcR4tvhJKWd0CgSvNm4dbC69zGBUepPFBef7C+aSUJozkn7F+DweH91NmD2zm6tulNp1sbsr6vGe+N+ggCmUvZ+whZ4epDo8D+arkuN8e1oRn4dH4+H5Aw9YxlLU83cigvKw54HwNb6scGT0pYqJbO3zZuA4UCCETY+02GFpTv9aejnb8hD0ERBWekGk9z6beuGF259jR33d+sMJEzLECLJah9tXDw0z8W06YU03doD9dUKgPZM14kdhE/sAzYdbnaAvOhteVsd+p/rq4quTmJmHF/CSB0DR9acir5Wt7WtQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c14f3c4-21bd-414b-3cbb-08db1ac2d7e8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:07:15.2918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PfKGomr9Dja2B0KldqKveE83kBWJaR0z7X0LYn6brTGA/+jCc8uCzWw7KOUaEnElZgX2Us/Q8vhHVdgJgEgMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4284
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020015
X-Proofpoint-GUID: LgVrB32hcVJct9o8OiIVICx5cfZLgdmR
X-Proofpoint-ORIG-GUID: LgVrB32hcVJct9o8OiIVICx5cfZLgdmR
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H.J. Lu" <hjl.tools@gmail.com>=0D
=0D
commit 84d5f77fc2ee4e010c2c037750e32f06e55224b0 upstream.=0D
=0D
In the x86 kernel, .exit.text and .exit.data sections are discarded at=0D
runtime, not by the linker. Add RUNTIME_DISCARD_EXIT to generic DISCARDS=0D
and define it in the x86 kernel linker script to keep them.=0D
=0D
The sections are added before the DISCARD directive so document here=0D
only the situation explicitly as this change doesn't have any effect on=0D
the generated kernel. Also, other architectures like ARM64 will use it=0D
too so generalize the approach with the RUNTIME_DISCARD_EXIT define.=0D
=0D
 [ bp: Massage and extend commit message. ]=0D
=0D
Signed-off-by: H.J. Lu <hjl.tools@gmail.com>=0D
Signed-off-by: Borislav Petkov <bp@suse.de>=0D
Reviewed-by: Kees Cook <keescook@chromium.org>=0D
Link: https://lkml.kernel.org/r/20200326193021.255002-1-hjl.tools@gmail.com=
=0D
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>=0D
---=0D
 arch/x86/kernel/vmlinux.lds.S     |  2 ++=0D
 include/asm-generic/vmlinux.lds.h | 11 +++++++++--=0D
 2 files changed, 11 insertions(+), 2 deletions(-)=0D
=0D
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S=
=0D
index 1afe211d7a7c..7e0e21082c93 100644=0D
--- a/arch/x86/kernel/vmlinux.lds.S=0D
+++ b/arch/x86/kernel/vmlinux.lds.S=0D
@@ -21,6 +21,8 @@=0D
 #define LOAD_OFFSET __START_KERNEL_map=0D
 #endif=0D
 =0D
+#define RUNTIME_DISCARD_EXIT=0D
+=0D
 #include <asm-generic/vmlinux.lds.h>=0D
 #include <asm/asm-offsets.h>=0D
 #include <asm/thread_info.h>=0D
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinu=
x.lds.h=0D
index c3bcac22c389..2d45d98773e2 100644=0D
--- a/include/asm-generic/vmlinux.lds.h=0D
+++ b/include/asm-generic/vmlinux.lds.h=0D
@@ -900,10 +900,17 @@=0D
  * section definitions so that such archs put those in earlier section=0D
  * definitions.=0D
  */=0D
+#ifdef RUNTIME_DISCARD_EXIT=0D
+#define EXIT_DISCARDS=0D
+#else=0D
+#define EXIT_DISCARDS							\=0D
+	EXIT_TEXT							\=0D
+	EXIT_DATA=0D
+#endif=0D
+=0D
 #define DISCARDS							\=0D
 	/DISCARD/ : {							\=0D
-	EXIT_TEXT							\=0D
-	EXIT_DATA							\=0D
+	EXIT_DISCARDS							\=0D
 	EXIT_CALL							\=0D
 	*(.discard)							\=0D
 	*(.discard.*)							\=0D
=0D
-- =0D
2.39.2=0D
=0D
