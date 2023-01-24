Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7ED67A4BF
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 22:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbjAXVPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 16:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbjAXVPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 16:15:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9CC51411;
        Tue, 24 Jan 2023 13:15:21 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OKx4XV024824;
        Tue, 24 Jan 2023 21:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=hH24EBzOXS5wKwU3SClAqDOGMpEKsnD1DNzELvg7b+8=;
 b=bCOQQHPk3pTRp87XBaeo+JQ3Dn5kZ7ZkzqLd0pO/bQKFLVP0cx59HxW+KTgBp2eo9r/b
 D+B8JhqO51OfhoHFYficXd4EQqRkuFZbeR/hHj/EcJBO8vpcRx9OlPtB9a06r6LBYpxb
 Gz0lx5oT0G+I1ekRApYYUydw2RFgnz6XQTj+/loan5vFkvauQ9xJbjdDezyOV6fli0r3
 6IWPHMneQFPKQCuMcHTySVnKrbyxav2RbF1eK+gu7bf/htpdyeIbkxv83twyLCF4kyKD
 uElnqTEKtjKD8rvsnNuIOg3/e4+zZVcg32kFAxAd2Jy/0UsJl/fhBr2TWgbUUQwUvFBR DA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86n0xhnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OKnVGE021263;
        Tue, 24 Jan 2023 21:14:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g5hdp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KasW22sHpCk87GgIalIcRqT1jt2Jn5wUypkCQyO+Qv3MX66SxYpcvoMJMEMuC0mhQq13uLSwuNAtqXrD+K9ryL+N5NmA85NMyWsYnC7oFm/z2csPN8V3izJYITW1EL9IbuUEgjFxbaeQQmJcZjc4SB3rD3vGmi9fI5LisgwdxlvEMnvYyfjGzP0hlSq/mL2D6ouPJ31t8WfCfsbKvoW//SXSScMe+ERL4xTA91nZA/w9KUQBmpKzgkLBksNozb9S8XDh/oVfIiNtqkOmSB16pY5KE9EE/IMF0YH5/pqNy0GQSrpo9VMy9BWScJ4QheUKbq0N6Cf6y7G/ZteB5r7elw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hH24EBzOXS5wKwU3SClAqDOGMpEKsnD1DNzELvg7b+8=;
 b=VTSGzy9lVAAOvWn5KqNyMwA+veohBGgWEB2CgejtzjS0M9NeWkcX2Z1Yxd06sVlD5TpF86LWzwJC+OX5tdZKnxBP6dn+5eLFGE2wgz8P6Zm0P0jogl2/hsKAczl1gDeQYijj5XILKcOYhB90yhYV8+a/LuqD52+Bx+qdSuj62vDSFe/OZiFw33xpdrXRoYVFbSTps594HGKAwzcw9Qv46/uquyrwPVYhRWIs55YkPbQL7QeH+x4a2BHVzbqw45FAaYSXzEIJxNadbG/UJrgqdeY8xuS0R0wtoyYiMEOsKk0Nz8D7k7vGEmM6xBNJ6tkGOUF0AOZ7ueOxQO5CDzRufA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hH24EBzOXS5wKwU3SClAqDOGMpEKsnD1DNzELvg7b+8=;
 b=st8I1o65ELkUiP8SzrvY8UnWPbTMuvzelePM7pFwCxQ1ABw6TRBojUydgix7Qp7J/AzRAqPfpzIJHwzQlY3gx6V8TEFKJkIpAEbrrIr9zHAyUp/TX8f4c9k6q9Ep0UUWvltR6HxhZXy4H1eZ9KePBoYmIP7N/WKTZH4Nw217KG4=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH3PR10MB6836.namprd10.prod.outlook.com (2603:10b6:610:14f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 21:14:51 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.014; Tue, 24 Jan 2023
 21:14:51 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.4 fix build id for arm64 6/6] sh: define RUNTIME_DISCARD_EXIT
Date:   Tue, 24 Jan 2023 14:14:23 -0700
Message-Id: <7301d95edaf5bd0926bc93a67cb0cc1256549c95.1674588616.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674588616.git.tom.saeger@oracle.com>
References: <cover.1674588616.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0030.namprd05.prod.outlook.com
 (2603:10b6:803:40::43) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH3PR10MB6836:EE_
X-MS-Office365-Filtering-Correlation-Id: 2120322a-3f64-44c7-50c1-08dafe5007bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FyMH2DQ4y95kuhiMfeFLxZqZzatQVG+DAoT/dsEIeyfsCFay35/0MmOf+dFJIaNa4mppq9nxDMlikXrsB/laYMJ/oqG6KMLc7ex8dtCi8HDS0FiVHwvNJUyKYcaiFmU0uWeF+NgeBbIVZsdwiQNgIaasDbf7e1ienqpZgypbUDnjfw3i0Rz0VwA2WtrABpCQ6V5JoJnzV4QOOGjTHnb5N9pMXm4kEqylMGk3z+UaUaL1m7Brhp4ZmU9GSOxmp387Ko1+jAGIPHP1o3UNlsamO3IY1HjvPjT1qz1K0sQ9msNN1Gsy0Ju1LP+/gH4bJuVrO3GdeW6V+4qKL0z43nDTipHOe7hkOpYc06/b6FHwqN/T2mAYGMVwp3kwJTqC0a2qlTQcLNEXEKOw4gK2KbUsghfQKSAC9trgv45lFP+kn2Hpq2JA38h/pmg8Us/GSehLnZotqzou1eqMosLvPiNRH/fjMFG3Ph4WPRaGo3HgOgKpre9U0N7VGbx/vXVX3hDjQgeW0327xpvwuJaQfCoKiTlXY84n3tKDFY1Sw2CecCdDy0pJ4UTpGFtaM3CyNE6Do1hp1gd+vh1kjCzeE11BPwlvh6amnWCmsBUXdbcwOTLZi5PgJCnedtmL1goskTkKa/UhCVcwRoyL6odSEIBDr0bO9F4tjaYMTjZrXaNd8K8knfF4tjwzUnTYWOAqiR+UqXuhzzQGms0a7AmCejtkkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199018)(66899018)(86362001)(36756003)(478600001)(6916009)(54906003)(316002)(2906002)(5660300002)(6666004)(6486002)(7416002)(66556008)(66946007)(4326008)(8676002)(66476007)(41300700001)(8936002)(966005)(44832011)(6506007)(38100700002)(186003)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i2+MnUq9CX0L434diA3Szq3FqIydOuBIYFIUx8wr81ub799kQy8pl57e0M1H?=
 =?us-ascii?Q?OAku/VHFqCg/rvKFTtgzStT+py+uoLsizPf8F4JmrR04YJQF6zb90yjNkN1b?=
 =?us-ascii?Q?Am+cnsK4RjzLfDDXXLKbJI8pEUzOe4Rxh2s71Xn/1iut8SNFbecIswWDYY8v?=
 =?us-ascii?Q?mPhJjpwXwShnZecZPntJsu01Mb1HWvrmNtBzDJlF01q3sq3LMwEnu2MX5MNr?=
 =?us-ascii?Q?TS34zppv4BLbaJ8XlXeP0gqEQdMXWbnTHdVyhUg5uOzbz1NFTayTwl/NpmWt?=
 =?us-ascii?Q?mwXme4HnL5KNVubwY00Gd1M7XGCnRdO70ucBdTzRGp+NmyGPBMRAWTCvzdcz?=
 =?us-ascii?Q?KIAzYZlJXiFoIThMWLzASYWEuhX9aIeMESeiCSXmSuAgvCUQQTDz92fCh9cP?=
 =?us-ascii?Q?17omrXsCcANkir39E0Gwh5Hu4DWyAsFQjYZBgAfFbCsG5PBFDm+Ty5FCDwNV?=
 =?us-ascii?Q?zD1z3LV0kbieUAPjGeCkWbTiFHO/OeGkTVlZ2atBfNZXdDwOVhI+4XewrucT?=
 =?us-ascii?Q?s5/kvelJTM+P2fwj2SjY4ngeOJeDdoW236h0Of/xZ6j2QXMgAjVGx/mxVBt+?=
 =?us-ascii?Q?3r/JTlRaxdmq8oynAGi3xt1HE446XdHSf9oqX5XX+Sun5scUVggihMonrn0W?=
 =?us-ascii?Q?PIOYNtzzzqrLO/Hj6kdwSUb2T6v3hxEMsVvUiIV0Y1lS4Rwy2kpFEfFQTJeX?=
 =?us-ascii?Q?JQMJazb/oN05vwapyD7gNgPUHmedEo+dYoSyzt0sKXq0cXNDMjHlQI29Zvsp?=
 =?us-ascii?Q?y2OItR4RuTV/n5yCHlH1/TXzw5kFPdYS3vSxCTvcHGiO3qtoi1EoGqJWqabX?=
 =?us-ascii?Q?Et6+jZClG97M3rmDU3u2VbokMUx3dQg6YY1cV04n+0rgedzi5vP7PaALMVQd?=
 =?us-ascii?Q?xoaffohMUibGD2JBYsukrphP/pQJfeWftWtY5wWO94O10PT0P2eYXEphrCX2?=
 =?us-ascii?Q?Pg96dJnzZVTbGuvVgXJGtQGLwQ3RX28+N0yJr9pySXz2yjDCsx9IEICDCXRw?=
 =?us-ascii?Q?X6SnXcjAggwAsUJFNfNNiTP0u9TuAnF+rhLqUu2yDDWXTHFJQG66FFdthMuo?=
 =?us-ascii?Q?Lt/cMbUPEjDX5B9qEozYavpm0/L3A8UJaQ9m39I01A/PEkFaRivAkAk/cEAg?=
 =?us-ascii?Q?2aSZniiunw0DnzDO5MroglPMvQGnAzqbW6YKPPsOj9qHmfSOyndqLHm+Y2tl?=
 =?us-ascii?Q?qgDSokayHyomehpBb6GDeq3+nCokaYIhrWfv7UVAXFDJT0COxb5KiKbZC8w1?=
 =?us-ascii?Q?8G6jFWOz/AHW635csS87YSeVLW/B7xBxGKpY1RtH5egyo4AueZuKlxZQ0ThL?=
 =?us-ascii?Q?cSYQFtgPo8zV4CmDB4c/fr1FoZCYk5LUhggOhSkIeIUCwu+SV9cgUrkzn/KG?=
 =?us-ascii?Q?ZqpQntvSYp1huLRCY+iKv1eZ6d3DwxcCOC+bG2rpSVoknSl3RhxcocnF4coD?=
 =?us-ascii?Q?RFJvtc6QsxFTLnLXAMW9bD3NwaDMeS+Zy0Z2rSvbBgQi9tHuNC+XSt2/2NkT?=
 =?us-ascii?Q?cfKYxGZQ1BIb5OTTGZjNXUPO2O21b3oMDKVrHvI4dD//lAHncg6P8/QO0i9O?=
 =?us-ascii?Q?gzSJO4sIysZ+bAPvUFGv+PQeGTAAMztHPdANn+EtfRMfIdB2ZXw3u3LKSV5Y?=
 =?us-ascii?Q?2tZNJNBC2FdLBYQNdmvOyrM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?s4F1jMSSS2/hYokZ82kKICQG50cghHPkaRTn7lRcQkHHwAkqAYLOkaS0r9uQ?=
 =?us-ascii?Q?hUB/4gmcIOl2WEmai26J2G2r0eatQTvFSUNfDHTL2XKNshrSFXXad5VPAbWJ?=
 =?us-ascii?Q?wrf2QzOmkNHY46hSHvOo2tkcgCCgu3YhsB8D7subxuYBLvfXzlX2Mwk7qhES?=
 =?us-ascii?Q?KvLD+aqHKo6kr3lLkdkuvZE2vCNAERvR5TNx7v4FuwgI3HJQE4sT461nMuC4?=
 =?us-ascii?Q?0rFvYLD+KSGw4H0bAL4vlkxbg82KHLnxoxMY1sBacJrCugsHh6wCRUu4d6IU?=
 =?us-ascii?Q?LVvlvui+16ibCoF1vC7FSjIe6CUBYD1HepwHkXKvuu5LXTaKlENSwU8yspEz?=
 =?us-ascii?Q?wKmDqj1x76rsnZ13RKOBTgrw+Zu24OypNNiMeywfQnuRh5t2BKMXrFn9I50H?=
 =?us-ascii?Q?zw/+dDcGkOQmkACb4Ovawr85J5YbEKB/cPziWdrPd3yfhatNASIhVjxkif4S?=
 =?us-ascii?Q?TrEtShzCaRfjvwFaoOg31GvobSOk57qh4b0P1aPD1EdS8Jd54XJ8Fi/PKWKu?=
 =?us-ascii?Q?GpnQsk68f6h5UMeqOUtmjA/zQKl4uPp6BR1ae/BcNlPVaOPvmzGhW+HhxVlx?=
 =?us-ascii?Q?6a2T+AoAbCdBEx9bBiQaYIWu/UdNc2jBGxz0Capf2nDDtBSlUC83dgo2UVCd?=
 =?us-ascii?Q?lxDzxuCg0Fff1jGVd595fRJnNThEmFwDNBDulCEgxezbaX1MpCCdAsHBp46A?=
 =?us-ascii?Q?ALGvfvxzkwz9HdILgeVgRqENefk6lXIHjq3bB0lOpi1ukhyYOjNE5flHq7FG?=
 =?us-ascii?Q?On1drJEgTsoYwc/gRuKpd/ePENxfQcNJNxkJhwOp8majzqVv0dZ5IS4cIesK?=
 =?us-ascii?Q?/MaGNgDv4j+RAl0km4Dj5rwyUSRdd/HRVy/yL131QgefJSTgRDXe0eJ0wCmy?=
 =?us-ascii?Q?RxKj+gNW3tRMDEjsDNnndSFPbRmbP+wFzYZqvTlbzkWN/6j3tmvNfjD6/Jsa?=
 =?us-ascii?Q?AKRlERS7GtO7pB309BrS1/GXKfs3ZlGAhesXyCv42oe4RWvxFUyDAVxyuJ23?=
 =?us-ascii?Q?YNz+EcapEcnobhQ1dlaj1z9TdQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2120322a-3f64-44c7-50c1-08dafe5007bf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 21:14:50.8882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HEpIE6dVZdaX76C8ffLlAsxAU9W+T98CcpYFAW2LbPfq4udVO/rSm3bXzXypr7J3X3ohxKqIaJUIApHsmkdWGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6836
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_15,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240196
X-Proofpoint-GUID: WSRik6ZVs73JlTRWXfbpFdqI4Ou5GcNK
X-Proofpoint-ORIG-GUID: WSRik6ZVs73JlTRWXfbpFdqI4Ou5GcNK
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

sh vmlinux fails to link with GNU ld < 2.40 (likely < 2.36) since
commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv").

This is similar to fixes for powerpc and s390:
commit 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT").
commit a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
with GNU ld < 2.36").

  $ sh4-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2

  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu- microdev_defconfig
  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu-

  `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
  defined in discarded section `.exit.text' of crypto/algboss.o
  `.exit.text' referenced in section `__bug_table' of
  drivers/char/hw_random/core.o: defined in discarded section
  `.exit.text' of drivers/char/hw_random/core.o
  make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make[1]: *** [Makefile:1252: vmlinux] Error 2

arch/sh/kernel/vmlinux.lds.S keeps EXIT_TEXT:

	/*
	 * .exit.text is discarded at runtime, not link time, to deal with
	 * references from __bug_table
	 */
	.exit.text : AT(ADDR(.exit.text)) { EXIT_TEXT }

However, EXIT_TEXT is thrown away by
DISCARD(include/asm-generic/vmlinux.lds.h) because
sh does not define RUNTIME_DISCARD_EXIT.

GNU ld 2.40 does not have this issue and builds fine.
This corresponds with Masahiro's comments in a494398bde27:
"Nathan [Chancellor] also found that binutils
commit 21401fc7bf67 ("Duplicate output sections in scripts") cured this
issue, so we cannot reproduce it with binutils 2.36+, but it is better
to not rely on it."

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/sh/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 77a59d8c6b4d..ec3bae172b20 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -10,6 +10,7 @@ OUTPUT_ARCH(sh:sh5)
 #define LOAD_OFFSET	0
 OUTPUT_ARCH(sh)
 #endif
+#define RUNTIME_DISCARD_EXIT
 
 #include <asm/thread_info.h>
 #include <asm/cache.h>
-- 
2.39.1

