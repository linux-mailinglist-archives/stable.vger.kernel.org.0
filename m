Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8876AE67B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjCGQak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCGQaf (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 7 Mar 2023 11:30:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBAB7EA31;
        Tue,  7 Mar 2023 08:30:35 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327GQ0VW026261;
        Tue, 7 Mar 2023 16:29:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=H7MIhIYdtiVAGwVtuh4JzzuLxVvl12kYoFFUTvQfsJE=;
 b=YA9S/YAYmjDa0nxAmJDhE9YQqvoAWh/XiLXZNAwvmujJkTl4CyX6ckybB/cc4hcbZCB1
 08GYmXhXWj0SBOTph0o4T7ZuDn2YmItI4zazxdCLMORTL6vEYGxggQ/71Myq2qxW90nb
 ELWii2We5mZ6N85ECLR9Hy/EXCJNcOxzvC5ttnYlgaCDUtj25SHHSP+WMg4Yp3RWyucx
 ydcDfD2GVmEs+mEwErCZpZgBTDJ59ggEcd/xT0SsDWiEc27Og8oC8VH7M05TtI/A0Ol6
 s/iDFHeTeq1jgO9ZmnzXrOmMZXG7QcihK+Ct5/9Ja8z1p3mu8ZXeBn5N2hvcpZZLmkUi 4A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418xwyxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 16:29:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 327G0Pa5025353;
        Tue, 7 Mar 2023 16:29:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4ttk80mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 16:29:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mA7us6H2AbkrxvcGcSxuQKfparYtKD8FSSfX7zSbJaty+LuxbHeV/vmIGEOg/MQQgrYKlfeIWjnP0qEk9yoiaPtbzvZZMup8In0KTD1bKDlIVjGysmVveglbYNJ3X4eW86DeLfRwneq7+rEMf0Y3Q68CFBTSmhrxnYScSxXr0fbtEvMa4UZrjDGrWL7mi4yZR/T9iDpDFqNzsDl6KkIDnmuhayB6UDgIH8LCoQM0QFE5tWpgRQkqh+dFfSjh4SIWqBeqqEdSsLmeR2CHSMJ9oNbXfrbifUZS0GfrC3pUYiha+MCaB0dleAQXhORRVDAX1hdlbn9A0BYK1HUASD9pTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7MIhIYdtiVAGwVtuh4JzzuLxVvl12kYoFFUTvQfsJE=;
 b=URH3ghuGR1Yfvg2aOKHIWRtGUfhWCqk5vEepvjvEsJQn/F9b7cyLU9lNbKyl/HpPlmttwZjwvXEebRpFFwJqY0zu4RiOeT6SxKnPlg2uroKQDLwR6kEuWZCMpSFav2cT3iOVRK08YACGBDShgnLf/hRBoHQkB0t+xSAeL1pJy26Moki8QqshqI7QkzFjUu7mDAyTs8xJcdLqZR41dFLK45xMKF02KVrZ39jn9FbKpbnm5Bp5jt9fmZi6iGNrrTPEFbD4OE3gBwnU5ct/wd29X7Rd7h3PVIOufo/9/rAbqq8cRyb0pl8Bsozw0lk4sWCBQJKGv06P/E3ZuSl4t9Kgig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7MIhIYdtiVAGwVtuh4JzzuLxVvl12kYoFFUTvQfsJE=;
 b=gT8lpULSeGREXHWoArykvql5rY7+dep2fDUWnWVtJWBlA6GXYBc/Krq6PuudIV9ekAgMpjUDUZwGQhQk/oNx8OU95LTt61U36hEn5BREk7WNdZjA+GpW4YHFXWPTjEzUgnqdJenudNiO/jD9h67M2KmNkAX0rmlUqY17XTf3jxo=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 16:29:44 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319%7]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 16:29:44 +0000
Date:   Tue, 7 Mar 2023 11:29:41 -0500
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     Peng Zhang <zhangpeng.00@bytedance.com>
Cc:     Snild Dolkow <snild@sony.com>, Stable@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] maple_tree: Fix mas_skip_node() end slot detection
Message-ID: <20230307162941.jwxczm6fw4l722va@revolver>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Peng Zhang <zhangpeng.00@bytedance.com>,
        Snild Dolkow <snild@sony.com>, Stable@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20230303021540.1056603-1-Liam.Howlett@oracle.com>
 <cec2dec7-818a-b32c-3ad4-8b23fc1351f3@bytedance.com>
 <73971153-b46e-0332-aa4a-0dbe0a59fd22@sony.com>
 <d0d2f9f9-4ad0-65f8-96e7-39decbb6ac54@bytedance.com>
 <b8b2294c-c0aa-c4e9-10e1-f991799b4f02@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8b2294c-c0aa-c4e9-10e1-f991799b4f02@bytedance.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT4PR01CA0045.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::13) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: bbd0ec25-b5fb-482a-f37f-08db1f2928a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lewbmcF4M5SY5AcizmSHbVxs74vwZgJpSIL4+ewglYOCLRznFvcb9lcIi/BEQAXGEfZ7Qaz0+uFL7KKl7OcxuMIO3Ay2GaOcYD1F8CRVqltkB8ioX+LHEHJPPerDgP8btmdbgJBIg+C5RLtFywthp7kYvz0VPzGP/ZuLZOybwA8m2Ikm+1QC4WvFm0BcbBN/Lf73b3Mx/4/+79KbWg+BVxAp+AQRK58o+goNwlxqfJrgGAlMxhevqS0OIgMoZI0QFMmaxIR+O8e8nBEc3/ZQOirdCI3hjuz/zJ/ekDuWaBKEo3gHsW9dFXYkTpsA7VBkkyQf80sqWog00cgdP6NkfjQD9Z2bA7rBrJCikaZYWmM5kCMvDrQQ25GM/nGTEEnh3/RVSmuLYu6XTPQmsj6lES6GlgaiteOsLddpSalcSRdeHVmQ5fXR0qNe0U8OaEbpGk3ASPIaHJhkkLpo6+pzXvwBjcoGPkqZ9Ch9mwomoK5CZ9BUfWk3i+XLIPjp+Fccf0NYH6JV1nP2d6fJAtpn0WsZaFrUd49Gv6VclI5zVMG7+jbmqUq6KGpGD5mO80S/ydver/FmwQHUigH7nVuAYuIdBUhgBNnZtmEgHz+c7D4A3EcZqCf1JHUAJ3h8rIEz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199018)(33716001)(86362001)(38100700002)(316002)(54906003)(2906002)(6486002)(966005)(4744005)(8936002)(41300700001)(5660300002)(66946007)(66556008)(66476007)(6916009)(8676002)(4326008)(9686003)(186003)(6506007)(6512007)(478600001)(26005)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WY8Ye/v0PdDtgQ7LOKbHDfTr4/ifrhibS7O1ZALFKA1Ls6/A8LPb+NWv/n5t?=
 =?us-ascii?Q?e67dcI+OJJWut7uJGNuDfvslqUdjcUDIRcKTp13mfIXms+k2730bJSY+i/Zq?=
 =?us-ascii?Q?ij5pm1nIwrnKC2tRAXrO5ihYzlELZBTKtsmScGlA1Fno4+zBto0ARpupnOWW?=
 =?us-ascii?Q?RCLJ1bQOgP27DeKtuHMw/EdYBytFzQ2hS7A4NtcPeNbOdeoEEGHXPRzsShQx?=
 =?us-ascii?Q?lQWwLoBX3Jil8nAF/Nfb9iyLJTQR737fA1aiTpf5I9RA5OWI/Lu5cG06c/yh?=
 =?us-ascii?Q?nRyX0WMOwPwkrMWZLPFJ5g3AS7yCPwM+2IwYqOmRcFcBOZ548IWqR8tMerTa?=
 =?us-ascii?Q?RA5htwLrfvG4L3ts3RTjez7oCVY1klb5H8bu07Koy3DcLecHB3ART9XBbkHg?=
 =?us-ascii?Q?NUDMWMvUNLJxjsq7VfevkWBmnciRoqjaUKneMgybJrjjJGRCzabJtrxO7PX5?=
 =?us-ascii?Q?KOJEYj86HRNqNy+IHcwEdVrYMc1zADmQmHp79bsIQxT93P5qIsqvZ+zKCE9J?=
 =?us-ascii?Q?h68Zd1MHSVreloqsxYcu943vyTyoGuRxVCYuzqewA4ilJsoNK3yI44Mj7zat?=
 =?us-ascii?Q?bHm8bd9FlQk5NiL+sQQaEeu01bf3hg/25yHhBB5vBkXstUTGW5JT9PG3dPlz?=
 =?us-ascii?Q?CQ5AIwq2+A32J+nD9XOZ41ewFuzoGzMCD1wFjMIg9geYODbN1Ddw6gKDQZy1?=
 =?us-ascii?Q?S4GYTVv0CptNLV8tgiEmPQRjGoZTk1hEaS9oTjXV9JOip67Tu7EfHETeixTD?=
 =?us-ascii?Q?UQ66FYwET0ok5ruTARRf799vxz3iV8rCPsA3e2IsDLJ//25+g9vugLqFxsXB?=
 =?us-ascii?Q?j+gF7q5auyNWXMOu5Lq7YavYE5jTurDyky7QlzPp/cALy2QRuizAPjHr7cJY?=
 =?us-ascii?Q?tYVZD7XZDyAy/FFVuc6F6TE3qCG+hDIDHCahRzARXG+EkHPScwNvsCqc2ugW?=
 =?us-ascii?Q?dqsPeOWy5c1MyF8unbfD6bPbqYU+GofVufPFvWJC01loQeWe8N7NZemKPbnH?=
 =?us-ascii?Q?4oopbK2AnlFkizTQxl4kmatdNvny8njOHWIBKUbP8L4mxtzQFIZ4tGRnfMSb?=
 =?us-ascii?Q?Hb1k6u+pBSJBtFCL+ICRW3LqaEdPITb6DvCmPYrLIXVWrhlONQXEs4O3TUZE?=
 =?us-ascii?Q?FzxO8w/KavPwLmaaR1+1R+Fg/bMpos0UGyQb5UgYejCKjGCwmKa6QaqJv46n?=
 =?us-ascii?Q?GmuEfCSZQP4KkG0DFEktAD4Pi/T3tZ9qAU4kMhYPEFDe0SVuU9OfbZVOPcZS?=
 =?us-ascii?Q?Cza6JfAg1sgS75iDT8vpc7HNVNIOdxJPD68B4eR3m09/edPVF48Uh93t7HLn?=
 =?us-ascii?Q?t7qJBjntU9GyXKzcE89mQds9r3tt5QKzenk3KyBsMPh9tHle1ir6ow2gI/3S?=
 =?us-ascii?Q?J55vqmcrmElA9MXJmcSjXm5sGgc5cuI3dnvN8TmfEclpYqEuSa3mUS4fdzwT?=
 =?us-ascii?Q?Uv8lsKVaKA7n5/MXcJssj8sjiwkwBAYzwoQMtrlqwjSTUinmREz+KeBHFEgb?=
 =?us-ascii?Q?wr/GfwUz4g6s8lt8XXhzFGDekfGnbndiSEYYP7ajTm3vG7uuLl1sebgYwp2j?=
 =?us-ascii?Q?7i0khfhPzKUoCs4byGD0HuQtBZyfh72l5rIel73SSBLTkLevY+tOu9rGiCnc?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ZpqW2e0L/zcrSj67xMTWoyjF8feKHKrhKfyYYJ6fEd6qD4fv8wTKngCha5EU?=
 =?us-ascii?Q?p1+BhPBbAxG1mgVRKejH/54tq+F+rUZWqrXxgKJb4tE77CYYTtocwQJbAKJq?=
 =?us-ascii?Q?Cbl3EevI4TGVTRh+JCQQY/lfQLqixqc2U/mTfKdBFlSiNcOqoB98dNY1HVQu?=
 =?us-ascii?Q?zYP9t0iNl9theY0lHZ7PI7SANezyp97Szqa5b09xXswUYwbYqagbWcUMVQRe?=
 =?us-ascii?Q?757AsjwmOJwIrVQUWBF6d7No3/4MONWmTNP182Z6FAp3xO7wxx2NM4Cu0nWh?=
 =?us-ascii?Q?NKpWkchJ7XtT3GB5d6sS72p3KCyDqfkyZ3hBMeKqsPGzYSoPiKoz7smJUB9s?=
 =?us-ascii?Q?AMLtRghKqApEKiMmT6ipsDsQ/szVoJjBON/rMpNd9F+7AZSbbXK5dypuo8rk?=
 =?us-ascii?Q?FYxSs2ZkLMsQ2No9mh9DvMkwKy6kLqD9K0lLnxTm1DXk4zrkJn+Hg2t/r/TD?=
 =?us-ascii?Q?VHrJjqS/ascCmKzOrej4wBaKUkLeHy45+4Ujr/q4EtiM1b8u55KPmE4o9upd?=
 =?us-ascii?Q?Mm9lXzoREf3B9tpR+UWPT/b0AUJ5l3MeaDl06abK5XbaVdf5cOpbuoQeDE78?=
 =?us-ascii?Q?RLBTiYk2/Sw8FHh9XZbPf195YbhIxmADmIgnZrf8uLZtX5z6YkDv850EEKN6?=
 =?us-ascii?Q?jMJzE9jAyglw42SC03R6oRdbiLaZDQGPQXk12EzCvCbbP4Jtse8dERgaFUXc?=
 =?us-ascii?Q?/NGL9VCTPXyCUv4BeYY3TF6IIzQHpPOAIswpYQbxMWpjNldx4Am7POTsXqSx?=
 =?us-ascii?Q?BIhLt8/ZcTjN9b5MCtb/TaEs/4oarCM7dgWp7yQOgs+YWaOogXjfdpMpDTff?=
 =?us-ascii?Q?pgzHyk2wQDiGkgxFlXsFHzGTNL9m7LTRnxES7eKOWxh9Qp3Qza4wee+gJcKL?=
 =?us-ascii?Q?slJIjC6g9tTpy8tOuZM0B0Z62G1VQqwOCUxPVBqm0M5sTDbFK4ru32IqBSXZ?=
 =?us-ascii?Q?Xmq9RCm+VI8OBl3/pmbc/g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbd0ec25-b5fb-482a-f37f-08db1f2928a1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 16:29:44.0442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5dgRzqtssWGRJWAkhgxckRgaXpziuyrdKSHsBgzxtHX1iVYwZzl4DCjm3Z1Xi7dxXCQ8cpQk3rHAwZtZCqucA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_12,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=666 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070147
X-Proofpoint-GUID: GdgCt4EXmOqWXcMcil_DqIuLx82QpDHX
X-Proofpoint-ORIG-GUID: GdgCt4EXmOqWXcMcil_DqIuLx82QpDHX
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Peng Zhang <zhangpeng.00@bytedance.com> [230307 11:21]:
> Sorry I forgot to post the link, here it is:
> https://lore.kernel.org/lkml/20230307160340.57074-1-zhangpeng.00@bytedance.com/


I will roll this into V2 of my patch set.  It is exactly what I have,
but I need to come up with a testcase for this first.
