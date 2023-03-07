Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A002F6AE609
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjCGQLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjCGQLY (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 7 Mar 2023 11:11:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45778C532;
        Tue,  7 Mar 2023 08:10:54 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327Fi4HA032103;
        Tue, 7 Mar 2023 16:10:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=+v53udx5rK6LUZPpAoobNZ0iRLglRdCKDMnZ7ilcQU8=;
 b=se2nYlqEHU0AIOuJ2rA2AyA2bsZHvA6XblvcBVAI27JOBQ8DPVQMFu8f0vjVRfj7aeYk
 MlkFUATTlnKZdwnZaWDFnwQCPMRuXc3T0VHC0uYu5X+9RpleZgANTBp8Y+Yz/5aHVqOp
 cuMgxlzaWqM8foOrMIZqdxwJeIjvTBGccAIgq0vV8+zjmmEfVm/tM/DY/6XxWZErcPl7
 7f45zyfqoWWrykIDV8DfHx2ta9AjUoenDYUlNyR8tYxwzB/PKePqKKotU2d6T0OBptch
 QCo1NXkf5R9zeNePYZShAgo7yxt6LFR9t3M+r2h2nqzyQ1LDoy/zzyQzXkWAByBHtzBR ew== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418xwx80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 16:10:30 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 327Fe4Ta023260;
        Tue, 7 Mar 2023 16:10:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u06evb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 16:10:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KxkGXGR2+W+7bmZc9DWSErTrCZlj9fmyrDqU8LUqXuwpSwEP0KOShHLi+mP942blSEzjFkDi482sMYFRL9aaYRYz9UbppfAb/qhxTp9oq2HN1DTvBzHb4SmN0vbrXpr31Pn1Pnl1OodE8DGackrDGr0KoomyuqgKOGkaEgEcMs916q2nEtGmoeHU/uS6i7Efr/kr2VxW0ufoUdaGRmu/JyaQ6qk8KACSTaxtczHQ18CadAGPmMYH22KWXlkoX0VXPLxS1deyDUcAXGRA//GiiiU79O1+nnwKVw1GW4gqIuHJwO62gLrtUnYGb/Xy+5Gpp+a3F5ff2AEUgI5vR/ovjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+v53udx5rK6LUZPpAoobNZ0iRLglRdCKDMnZ7ilcQU8=;
 b=Z9cXEfX/DDranPuwQCDw3eDMNeMk4EjDx7SDhLYAsgP27RMY97NiZ2kXk2xSGlKF/qqDCPDlAOnuj4UHbIOeOYGpW53uI7OSxWCcy/f0G+TF8y8t4CGV3CK3uUkmntOG7FR7noZGHcRSzZA9+en0B5TSabYBRKh11z+qYn5PNYx4iduyL5po8yXSkWz0a280iMEEyYOIWkZYyeoXTdTlXCDuR0UqFqJzCk4AeWkULKnF4PQ9YBiFi7ImX37PZukWCVmEs6OpvilXYCkej8DQKar3nVc55z2PhpbCGmHeU1MAr1LzZrVeYB0WmPEbt6rz8nV3m3hVXqGCUrlxbnUhWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+v53udx5rK6LUZPpAoobNZ0iRLglRdCKDMnZ7ilcQU8=;
 b=Z7NCK5XEa1Bp36DIDQVRC5rbmpp3mPKUOAE5Ssnv+iwtMhahLus5QUBCW1o2LeYks0rdFxOG2SfTX/61jxRcE5TuD6bmteV9TA+/9n8sT5aFk7oqGEaLQSCxM/hctkogTzb0DCggW5eCtkgBRIYGNHGV8V2tgeR/6Wt9xGr0RG0=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SJ0PR10MB5582.namprd10.prod.outlook.com (2603:10b6:a03:3db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 16:10:27 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319%7]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 16:10:26 +0000
Date:   Tue, 7 Mar 2023 11:10:23 -0500
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     Snild Dolkow <snild@sony.com>
Cc:     Peng Zhang <zhangpeng.00@bytedance.com>, Stable@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] maple_tree: Fix mas_skip_node() end slot detection
Message-ID: <20230307161023.qvqhbipeujqz3ckz@revolver>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Snild Dolkow <snild@sony.com>,
        Peng Zhang <zhangpeng.00@bytedance.com>, Stable@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20230303021540.1056603-1-Liam.Howlett@oracle.com>
 <cec2dec7-818a-b32c-3ad4-8b23fc1351f3@bytedance.com>
 <73971153-b46e-0332-aa4a-0dbe0a59fd22@sony.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <73971153-b46e-0332-aa4a-0dbe0a59fd22@sony.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT4PR01CA0048.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::9) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SJ0PR10MB5582:EE_
X-MS-Office365-Filtering-Correlation-Id: 90b148d3-489b-490e-76e6-08db1f2676e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OIhROxQwEDTjX7VPp1Jsd4OxWj+B1KCpMVpytf2ERr3FrSocYItiT12nMFsRLYfyW2mOEQemC00oucGFrIRqZJYd0uQ+OyqGcxZDDOuSCrEpEDyGNY/5Jz/Bkq0b4X2u9AHELsbpQt7NCCE6qEjmnl8yIE8wvsi8+vd07anaIJqTS1vu0GXQ8dyAihOlIqNTddmuxoOrW6hz2wwWoawZrgTdh/4GSrW/Uu1olgQCPmYDo9Y53xnepygFrIzGvsm4Y4fEOybpBAZcD4d6re/v/Zpb/YzmXeY9SwOHrijCJLogTt4DP4E7fmZN76VuTVChCZBNLYtOfnLcH60VEbnP3Pzj7VilHVxr22UFJHb5QzuUBwrNFnn+ZfQ5JMD3o7KjKunxi2fiSlFRHPcWsxJqfa9AY/7xnp735b6n/Ng7umTG/7aNJdpXcx8B646sig5FEgtLF61E45M82MDPh12MIMwPgbeqsJmtDeGzt2uqI83+YxyWMsYhHxU/OdQYcUHNV04jbE1c9TIHvsRJLBK3mt4qYKQOAMF4rVGHXiQRr1+GhFHpco8wjNWytINp8Jwwx/s51J8d8t4tBkSetf6tRQOwp2EfIIHzzN17NK/MkX21Q8MDLyYeqN5jnf6vgK6g6/bBQdKNEcOycplC0kfuHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199018)(83380400001)(2906002)(33716001)(5660300002)(66946007)(9686003)(4326008)(6916009)(8676002)(66476007)(66556008)(26005)(186003)(41300700001)(8936002)(1076003)(53546011)(6666004)(38100700002)(478600001)(6486002)(54906003)(6512007)(6506007)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?9mICVIoQQRrIcrq+2ytgNwzQRCrGmzeGv7b0SoGeU55W3FTtuD8/fZ/+Jz?=
 =?iso-8859-1?Q?S5tViXa1UJ9UUalWHks7L2+QETqogCu/Nexe+Al+AJ3V97EtccKNJN3yFE?=
 =?iso-8859-1?Q?ZhKl6eXdobxyqL+bqBoI9IxWlM68VJ1wztKM3QQow95yRenF557mcQZdTX?=
 =?iso-8859-1?Q?Ss4Qo3cAW2DtSSPyBtpaagPNLzAYsF0MrL4dZyM0ZqXSmSS7OLRDHLHaT2?=
 =?iso-8859-1?Q?uRdYHf3/sCVgN3YErAbNzEUQeYuXTQ0RYDwuh9PXmPoonG7/ONO18kTnAG?=
 =?iso-8859-1?Q?wRDSLDHT/ao1mRDZruOQjclJCqFQPLVFiVaTNX+AQsiVyAQW8m56ZauNLl?=
 =?iso-8859-1?Q?UOP/HcaB+uwcWgIUPKQ6WY+ZrXiQDVVVT5r9fTDrQZ6WtkJpxln06lpRnJ?=
 =?iso-8859-1?Q?pHQ0S4yt4sOkLeL7YaMwx2NjMSd1e1BwLigMrTP1G5kwLxiFPwZZyAK6d4?=
 =?iso-8859-1?Q?OnGpkx10OYAJK5PZPdDXm93hbAHzJzx4HO950pFbKChTzNUQsZNWAlW6p6?=
 =?iso-8859-1?Q?PX9BuVGjQTZfEcHLPJrYz9QxtYpGpWv85KyYREJNpikp7CSOAbpHHEgl8v?=
 =?iso-8859-1?Q?EuO5ql4/x+gjqknqEvlrSiZluCODZ6PLmqWQus+oyQuGgHk7Lbhe2AX/UP?=
 =?iso-8859-1?Q?5KjSxOoCPXwvMz+40tZjiBm4nXc5hpOSWF3Wkcw2fTrPZxA97Fl5/bPQSy?=
 =?iso-8859-1?Q?CMV68sN2uID+E118d7IU1cmZXy7x2C+Kf8VMFtoTn/7aip2kjE+Wg21Ec8?=
 =?iso-8859-1?Q?Axo4zGn0swFRBKHr66h3JwWIDja8DuZ+slxONwdniFWGZE58uxd7IEr6MO?=
 =?iso-8859-1?Q?NDeBRZr+cEGfwHcWxtrMVx2lGZ9La7oc42q2ZNhaoNA5fuNhqggOjl4N6l?=
 =?iso-8859-1?Q?lOotk+wM4si2TgriPEj5mD5OYO+2hYlz8D6IcyydxKe44iW3JjZ56tgHeQ?=
 =?iso-8859-1?Q?FMpJM5jC0HeWftqETEYzgvGy/Q7CcGastO14qg7Eg1jNkT33tbkqPhgl1N?=
 =?iso-8859-1?Q?53DnqrTvu37E/yiCA26loCvL5vMUZ5A0MWDkXsuA260nQHm3riGlFi3wmX?=
 =?iso-8859-1?Q?ZuhOBB+LstDlLBuYA3pZ+IB84eQir6T1pBM117q4UfBiTi6lVDprjc5Qm1?=
 =?iso-8859-1?Q?jil8/TpFACp+pdJtJyOLrckaCmx91zi4ggN7CjBzRaellbe0POKXCN0XAK?=
 =?iso-8859-1?Q?9pbw2t2/hpK1qLcmL1mqmT8A/ld7AaJtGaRg/F598nT03PGUIaW98sRExN?=
 =?iso-8859-1?Q?4YWAQlOJq8rffHlvejROKR1RjyK4TF5KY34B+C7guXVQqHkcek62neqkN2?=
 =?iso-8859-1?Q?XUDIz1wW4sJ5H29LDcE2N71tCpXhv5MuABPfUWS7bFVRPQPAKQazZ6h5EM?=
 =?iso-8859-1?Q?PMgwM+clANzinLTLNC0AQWeRXyIZiFiHD/3ZUFQFRZAyUOouQsoI6AmrBV?=
 =?iso-8859-1?Q?9yPz9cDYEYBvMIlELLXYObkDjWnQThiqIRKdiOdMpxGrLI2jAk3x84VT0I?=
 =?iso-8859-1?Q?Z99dYOIsV6og8JMxwsiro8e0jrvhsRlJcprSXKQkwjeM2sJ4Ji/CbOarHC?=
 =?iso-8859-1?Q?xdQXLXtrVEhVTeaSNn06hbD7/yCBsimZ/0lg49hE0o8e6y82ljGBKAR8on?=
 =?iso-8859-1?Q?htStpszWC3jZs4V5ogg/PDu8sq+Uzo9/vmE8/KffSPYSxWgjuH9EYPEw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-8859-1?Q?2a95WtgIP2a1r5ET6BBCFVLieLVbcnyO8+4k7q1dcZIM3y4M/aeHCx0TqU?=
 =?iso-8859-1?Q?i0cMM8iryaMlFjh7uV7RcCa95DMe5AFIRsBR/OlqXxjrMezvCCM8S2nraR?=
 =?iso-8859-1?Q?EnM3Popag3DKi6yVF300ZVMtnaBXegIG3nO9q/t9zjl7LVEOTp2k3ZR6XR?=
 =?iso-8859-1?Q?v7gRccny4PWucc3Hf8k3fQbAAIhGAkAK8vKvAErmQiP6ZVHyLnJCUAR5vQ?=
 =?iso-8859-1?Q?8ePnjlOlwNeOwV7WDpjSvxjuGgc8oUn1dylGWIwqRjGvlL0912EL3SL6QA?=
 =?iso-8859-1?Q?bTAr41DfDccInU1UWYuO+YL+0jRgyYL7KPZYquYXEzNfJCETg4p0pD+ozd?=
 =?iso-8859-1?Q?GlTnitTjyzZRWgjd6BtJ38SkQHYuyPlPKhuLjTBvtdCQalQnkXiq9DaRPD?=
 =?iso-8859-1?Q?qrjsRKZrLnJHFqoROitUiBksocX0FTObbr7gp6ofFTgq2qgkdimxypux7D?=
 =?iso-8859-1?Q?7WKDJaYr/hEcAbq6IVUsvLbkgJ5Z2z4K/Lja7sTD42d6TSnEL7t1NGxAX0?=
 =?iso-8859-1?Q?arZJ2SE8Mt4jrPfuI3OI5sXK5mjbPXw+Aqgn+TGKobX2Bx0ZFjQchgpqqs?=
 =?iso-8859-1?Q?LTG82tQLq8Es+0TSE/Aa3FUuXiBwn0WfbC0k3pJmPeZQjXrcUVfRWiyH+a?=
 =?iso-8859-1?Q?muuISMt301yVEooZXywFo3qSThDvlE1/eXMsYgxvkGjDT/ckrsAsN1uf2K?=
 =?iso-8859-1?Q?mRf7MToXZiztd4jeJOUClqnqoIPY1dVBRS25kShgc+bmMe18EwyB50f2Bs?=
 =?iso-8859-1?Q?MpGekIUYu3vZ1aNeq8mBGHebepso06+0ljKZ07NRyEimYiqdzsUr0nO6St?=
 =?iso-8859-1?Q?Uiy8OTlm7P1uw/YWF1nyFVHvDfdT2sOZq667jy5H+7pDc26nr9PAr2qIvm?=
 =?iso-8859-1?Q?6ql1EtkXixt0Awpf5QDyYXMl6zFTMcXqANHFyQnINM46J6QFjHMoplMd3B?=
 =?iso-8859-1?Q?v5VvFQIm4r+Aq493ASCPruNx0gENxVaz3UquoZngIHJFlsuduom9Pg=3D?=
 =?iso-8859-1?Q?=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b148d3-489b-490e-76e6-08db1f2676e0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 16:10:26.9666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rWYB8bG3xUo6d1RlQzUkP8Il5i4tzFbci+DIOC5FvyGWjxXUGM0up6YcaGcN0e1XQwD5Ap6K97DtKewLZgi4gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5582
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_11,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070145
X-Proofpoint-GUID: ZctF4ERfO2rxe-YgxYw0SPj_TXc8JaUq
X-Proofpoint-ORIG-GUID: ZctF4ERfO2rxe-YgxYw0SPj_TXc8JaUq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Snild Dolkow <snild@sony.com> [230307 09:31]:
> On 2023-03-07 14:05, Peng Zhang wrote:
> > Hi, Liam,
> > > -=A0=A0=A0 } while (slot > slot_count);
> > > +=A0=A0=A0 } while (mas->offset >=3D mas_data_end(mas));
> > > -=A0=A0=A0 mas->offset =3D ++slot;
> > > +=A0=A0=A0 mt =3D mte_node_type(mas->node);
> > > =A0=A0=A0=A0=A0 pivots =3D ma_pivots(mas_mn(mas), mt);
> > > -=A0=A0=A0 if (slot > 0)
> > > -=A0=A0=A0=A0=A0=A0=A0 mas->min =3D pivots[slot - 1] + 1;
> > > -
> > > -=A0=A0=A0 if (slot <=3D slot_count)
> > > -=A0=A0=A0=A0=A0=A0=A0 mas->max =3D pivots[slot];
> > > +=A0=A0=A0 mas->min =3D pivots[mas->offset] + 1;
> > > +=A0=A0=A0 mas->offset++;
> > > +=A0=A0=A0 if (mas->offset < mt_slots[mt])
> > > +=A0=A0=A0=A0=A0=A0=A0 mas->max =3D pivots[mas->offset];
> > There is a bug here, the assignment of mas->min and mas->max is wrong.
> > The assignment will make them represent the range of a child node, but
> > it should represent the range of the current node. After mas_ascend()
> > returns, mas-min and mas->max already represent the range of the curren=
t
> > node, so we should delete these assignments of mas->min and mas->max.
>=20
>=20
> Thanks for your suggestion, Peng. Applying it literally by removing only =
the
> min/max assignments:
>=20
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 6fc1ad42b409..9b6e581cf83f 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -5118,10 +5118,7 @@ static inline bool mas_skip_node
>=20
>         mt =3D mte_node_type(mas->node);
>         pivots =3D ma_pivots(mas_mn(mas), mt);
> -       mas->min =3D pivots[mas->offset] + 1;
>         mas->offset++;
> -       if (mas->offset < mt_slots[mt])
> -               mas->max =3D pivots[mas->offset];
>=20
>         return true;
>  }
>=20
>=20
> This allowed my test to pass 100/100 runs. Still in qemu with the test as
> init, so not really stressed in any way except that specific usecase.
>=20


Yes, I have a v2 that removes these lines and some extra unused lines.
I've been working on a recreation to add to the testing before I send v2
out.  I had 100% success running my testing over the weekend, but I
wanted to have a testcase before sending the change.

Thanks,
Liam
