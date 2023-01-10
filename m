Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB76666460C
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 17:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbjAJQ2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 11:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238801AbjAJQ2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 11:28:15 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A5D69B3A;
        Tue, 10 Jan 2023 08:28:13 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AGFifF013961;
        Tue, 10 Jan 2023 16:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=eC39X4YuWGtJ2LysIUNLwuGO81LWZuBJ3gmbd8w1lsM=;
 b=pmRYt+Uo/x06yZLxBXKGS19Ya6J5ZZ8meNZx8vkrT2t4GKmjjUH3+pHjUej7UZjZIHYZ
 Q1XU0O61Lx5N5VC4Ddq5hTYGvtX3k7J47arpiQzo50JfSlKdpznvprivq7pCVxn8b25L
 JKfZwmtKF9v6wzLI8sOTgkmFXLNuh0rpGZxAjDsq6k2+K0pSZ57E4aeoikAj8LYc4f0Z
 4GAr+ni4Z+uo5aQWJjuSVtNhzwNKm+FnOc2OorYWpt4drxwWZYFtsNICsDDkaIVNCRPx
 nMkLofGP0U9wMiM61s3jWtfiWNx2En82/wOpzrbdRYrQqaenjE5YszXcjQBy6Vd1NWqJ 2Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n14nf8yq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 16:27:54 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30AFmrZr004233;
        Tue, 10 Jan 2023 16:27:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1b07td4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 16:27:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJZbjKaHP5CbCEV6GgbkNlhGuJ4/+Yp7VoQv4j/MgMpi9g4ZKgyCGJMKLs8ybjCNspSOq+SfM8bF8Lu3bR2KWYu8vdOEdL7Z3ROaQ+RMcjGwE1VsyXL6pD7vVG0Anw1ct03B5wMrVxkpHC+Z1NFPQTX2dERDZelBPKIahkz5R21ljZtFuIg2LuPvnxgUpoq9/jwFY/K064Fzd6i/wQuNGb9BXVphwGZDMPS+4jFgybFEX7yF7yAqfsWg6HTXQBkgULlIuMHNQnGxA8oF7G510nUzn1uUv9vafYo1OO5hb2Y08Wv6kc3BpRwpyyGpNxMqTkvoeZ9z4f5eAVl2TBNhNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eC39X4YuWGtJ2LysIUNLwuGO81LWZuBJ3gmbd8w1lsM=;
 b=gZ4Fu34S2+CXuMSIqMJYxj+FoSnBNIG+UFTfvIoo29AUlHDam0ypGf0nQIzUFaGFx0y8SkgyiJS57d3y9LsCo/hIalbvmXV4p5TOHCBGg/tNUND4wNF5gh8ofP3PiWHjDfZ20/+xlTWwVkGyk7OqEy5Xf/+8e18duVB92L20MNKerbPCVoG+yL0bZ07SsE0fmsG6hM6/rNhd7+T0bhS3EJ4ZabeGYAXAgWJgcOnWmHr/NoZctE2QGcs322O8d37CWH6myL41S6oc14Q9OR3YDAmn+QagEjuQC/y6qP6AIm4TRoob8XbaeovMUWBQIHXZHDOEXPcPaC4o1HVgMy+JMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eC39X4YuWGtJ2LysIUNLwuGO81LWZuBJ3gmbd8w1lsM=;
 b=AtpfPVIO8YA2axJAzAUVdp1BcxSfFCZT4hi14r9uilVzRhk7opVw5pLU++z+SIfpmAJ6c5UdqngxQr87YC4hReDy23bMhqclK2fOVtt9btJrMxfyT0jqEd6XrwTkDXBqFOf6ykgoIArz6WF+fYv6pNIqb+59Yj02Z2F/hMO4VRk=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.11; Tue, 10 Jan
 2023 16:27:50 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.6002.011; Tue, 10 Jan 2023
 16:27:50 +0000
Date:   Tue, 10 Jan 2023 10:27:44 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <20230110162744.6ptgrkx7wqu4xwyr@oracle.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <Y6M090tsVRIBNlNG@kroah.com>
 <20221221205210.6oolnwkzqo2d6q5h@oracle.com>
 <Y6Pyp+7Udn6x/UVg@kroah.com>
 <20230109183615.zxe7o7fowdpeqlj3@oracle.com>
 <CAK7LNAT3NP2gH1JxjeX_m-bhu7kqqUcBMALr_ZpAh_FW6r35FA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAT3NP2gH1JxjeX_m-bhu7kqqUcBMALr_ZpAh_FW6r35FA@mail.gmail.com>
X-ClientProxiedBy: DM6PR13CA0064.namprd13.prod.outlook.com
 (2603:10b6:5:134::41) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO1PR10MB4577:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a415fff-624d-41e2-fce3-08daf3279db4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SBTs47XpA0QWEcq4JmhUhnYlDa/wchfp/XngZl31KfpfYSgBa6pbXWyPNPbUAeaXd1ynqhK/LDoIOc2Fm0DXnhv2mAV6L8MQoc0dXUdJSl93aDMDZHJXZaiezqzxKtl2AFdUkuaj/EL3Lfo0hEcJ03YmMw2oIfh9l6Io8/NbCvCDHrlRBITI7ZCaGDk4Nc0u3rsqxO4n8SXlGTGj53ufzpESwgyMQuEIQRY2nw5nccpyPkM8Xm9AxAKiLniMo10268C8Nl6cQuJaaOMEB7EyjrR+QMuiLpAIqOT3eMqwX7/CW1/RqwzZl8sN431pVwKgAfeOqg7uZa7TpzlVA8bKdU5fUcNTNYmkfKJ8+mrAS3PkPJc0dstEVoDmsBI2XZ/Bf8fnUrfNEAJo2ivekXvPn5OTJwmEJCGEUgJhl0GJAqpZDUv+kRpnEKrWaYh9rxMJlwgFWZFT+CYLxnVYuabOGhAFQxSBJpydWW/cpt+ktF+bNsTnrVIDr33ZwnWhLLl0BvEYfnF8u6BaMIVWAi2OW2MahV2N6Q3L2iVn1tR6JWGEI6SubyugcAwNN2JGyyLs8aPcYkUjDIikOULIdgnD4dQlpw2aSEIgi3YeIajZe0YOc9s/GfNbuGPww3zhdPCCayx+7+BuRE6twmPAQCWcYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199015)(83380400001)(38100700002)(86362001)(66556008)(8676002)(44832011)(6916009)(5660300002)(66476007)(2906002)(66946007)(8936002)(4326008)(41300700001)(6666004)(186003)(2616005)(6512007)(53546011)(26005)(6506007)(1076003)(316002)(6486002)(478600001)(54906003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v++occQFWpcZuZLea3kXejMcYA7S/0cV1Doa3XvImZ2kw0vdjtwUMPLM2wFc?=
 =?us-ascii?Q?M/n0GBuduhLuz5MDYOX5W6i/VYhVryB5DrvjjFaNDSjcbZBR66cYlps+DIkF?=
 =?us-ascii?Q?nlO+qCK9HJs3eoONlODBclQLCmKI8d2jEND20USu5MIGXKzYmbAxBtzZ3Ops?=
 =?us-ascii?Q?Oz2/0GS8/H81YQSHVoxNd4EzmJEOV6l6xGFLa1fGLNyTOCdf2dF56Lr2kuT5?=
 =?us-ascii?Q?zrFXh5KMinyKIyWkb3N3n7zu5wvuJxUe5FB4SFCxDupbMOmLe2gxMtMDZVto?=
 =?us-ascii?Q?bRYHQ1W5kFxUfDnYtmLuLkbAkIo3y/xUi6D7pTVsDj6BerpUMSJpN1Q/w7Dj?=
 =?us-ascii?Q?VIItWY3fmUO9lYk3Hp72bPA33krokMtOHDenetSG6FIgUH9kA2h7x7o3d8he?=
 =?us-ascii?Q?vni27Ztu76Tr+yVE6baJas6lwRBijQmt6pXrLBx9q699DyRaqGMPm+hXpwGx?=
 =?us-ascii?Q?7e9RelLXCrOT0fe0M17W226L5GDutx92/0ap+9DM4Y3pRBJrVhQocSKzM4fR?=
 =?us-ascii?Q?Szl/D/RXNhDMyx3U44Mk14zB9DYmCzoFUMzAN0zTi7X7QCLNQ8Q9qyIOJ604?=
 =?us-ascii?Q?0FGqqFdM1N78t1U8EBsHJ05LaFySpXS9WQ57Qm1v7GWdsDgpYAKGpGfCRclx?=
 =?us-ascii?Q?NyKL6ogB8cn6UntH63qPD/aYwPCqAeTQvmGG6yJuuSNX1B9yicrw7FjvbLcz?=
 =?us-ascii?Q?ACNFGWDVbmklXAyPbuT2OoR9Zjz/oZs2lMh7V5naBP68uE7H+w8wm8w4AUES?=
 =?us-ascii?Q?QFYgopW6ujclfqqpz/zUEuFDuz0YxwOMVmuDAKhwwwn6EW+5JrCfSMEeZJoO?=
 =?us-ascii?Q?FpyGBEtp/npW6hXDMdPNeRTRh4mpDFmj2goHz+QOvAvd+gHM7PwZt9XqgXnQ?=
 =?us-ascii?Q?R/Fax6rWH0JHKqYoot4lvU0bsBuNOw2DhSpf5ha5b6ZacUzMq3cbhyeI6Eg/?=
 =?us-ascii?Q?rkzg4lXjU1tQRQcbUwfRjfUPaj30WnokrMPCSpU5KY2cMmuAY/vGfQRrYkBM?=
 =?us-ascii?Q?kZQdNwNkP6ayNBDr6EEqJCK6CVPx2c2QGm0m5XcYOfPIUitEduSdvPdbp5Il?=
 =?us-ascii?Q?38WVmALylNd8m3x7AOVTtJH4nZWx+JTWtiOnF59vEk5nahQ1rOIgbbEEDkXg?=
 =?us-ascii?Q?XRnyHZ0pSVersO5Q28LW0OCKgkGNbgOFKF9HD3mPUxsmEzjrpRWo0EBNYNXo?=
 =?us-ascii?Q?Y08Nn3PGMcJBU0LhGEecDLdsryoZ4FNns+nq9cNTZwKk969Mti2hopF0jw1Z?=
 =?us-ascii?Q?3oWlMvzBOJFGNLkrEE9JRQizrH7jtoD2hqtJAG4sndlmiOFnEgqDvp17wvA+?=
 =?us-ascii?Q?CNUo5Up7v6MZrF/kaA1jXSqCCjyXaG+abjGS5Ol1wkGo12W9152TyEF/xPdZ?=
 =?us-ascii?Q?hox3OdN17CIizPtHb+bnksJAb4oT1w9dignVZfHCnntiVHlm8r7pbs9X6Ns3?=
 =?us-ascii?Q?/VglSIoOWyxkeE3TO0p+h5WjzDN7CwwtwKezDhG2g55pXkuRw1SqDUnPFzfK?=
 =?us-ascii?Q?fpPHNFlc6D25Qv6DaLsyTToiizPmhXEvDV3PnwiLZM/dCg+gGi4Xl7JGJcfr?=
 =?us-ascii?Q?UUcOfcaDi5hjBGUrmO0NTC34Wex5GNRLaba8wjD5?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?DeUNRCeaE7/5lcGOMBDabduy7uEBX5HD7a/w4A0Z4U8XYbkBBZr2O5VNwEE5?=
 =?us-ascii?Q?RbXWULvK8fiRT5rGQstXuStbmhtf7KDExn6oUGo+uWKouDiw8TAzyt2waSV7?=
 =?us-ascii?Q?EJIY27RScht0xH4LlxDwuaA2po2RNCrSL+0lw+2D/ExG7D7TbKgA7TVMhilS?=
 =?us-ascii?Q?1x2w1+mlWO+Fz2sBY1+pKJGltGGVp+65FNQd8yVwC59QWD9Q+enAbxtyHhN/?=
 =?us-ascii?Q?kLsFDJc5xuAcJLBiWBKIC7HkixqHC4714zqwLn1iKHjPd2RHYSENudlaWC+/?=
 =?us-ascii?Q?F7BMn0fEboGzGvUcG5uSqiESWk+Wr0aiMvkutemCZJ8SesyiTPZxP7TlDA9x?=
 =?us-ascii?Q?mUOeuACTp3jTTLxWs1+Fl7ph9JuFk5h15B0fIUsif/9332XhLkFcL7seiZtd?=
 =?us-ascii?Q?l4HVF0MgR/xBcE9b0W3ToXyktgLddoS8bxMQncK4cdkLNrRW///zrg1DAoKM?=
 =?us-ascii?Q?jRHS3KXh+MlrepV6e44OsJMwQHgyaGKm11eAaed0lUw7nm7rA9fAW+fBed9g?=
 =?us-ascii?Q?E6BtThAHUS+3F8FjBF4xFlUVHbF6K51OFdh3y+kmVkDfmdWFHTb/0dttcVmf?=
 =?us-ascii?Q?2xmieGm4kD26y3xJifsv0xHBxJt5Y4RlcWdOMp/fCqm9ubAmuk3rS4iARPFv?=
 =?us-ascii?Q?HrJqz00lC6JPd4dJeRuwU5uIdD0PMZnYGCmTYUgO5PqIfl6RSAQAsuAC/Eyi?=
 =?us-ascii?Q?vERMxjYRiLIGh7wMcan7PYV7wDxyKn281kKhjtLKd1rEvLLN2edlqRvJRGH3?=
 =?us-ascii?Q?ReDEBQWpc84HTwzMOolNOxa19lfdHpCOS6QUpNjgD5netY5gtR4l9K4jfWqf?=
 =?us-ascii?Q?Va8fPBDRbK3hBSMQjWzzWkmdsUVR1SmiepgHC+l+8ls44gt5lYlJ9DfiaIs2?=
 =?us-ascii?Q?kaxDdhKMzXplpn1fKQpEsYwFIQ5XKfYbTxiRPvDVTuRC0Wk6dIkQSp6BdUmD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a415fff-624d-41e2-fce3-08daf3279db4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 16:27:50.5098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yKBgIUwdcTTy8B/ceVLMKt7sTHFDz4SlWvPi2bdTCtD1lUFSkUBjGczyhNC3/pbeesCQ4lpfWjAOv/D7WbE65A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_06,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301100103
X-Proofpoint-ORIG-GUID: nCZWqw0EeaVI0ubJvNsuyS6bcHaQz7yA
X-Proofpoint-GUID: nCZWqw0EeaVI0ubJvNsuyS6bcHaQz7yA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 03:58:11PM +0900, Masahiro Yamada wrote:
> On Tue, Jan 10, 2023 at 3:36 AM Tom Saeger <tom.saeger@oracle.com> wrote:
> >
> > On Thu, Dec 22, 2022 at 07:01:11AM +0100, Greg Kroah-Hartman wrote:
> > > On Wed, Dec 21, 2022 at 02:52:10PM -0600, Tom Saeger wrote:
> > > > On Wed, Dec 21, 2022 at 05:31:51PM +0100, Greg Kroah-Hartman wrote:
> > > > > On Thu, Dec 15, 2022 at 04:18:18PM -0700, Tom Saeger wrote:
> > > > > > Backport of:
> > > > > > commit 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> > > > > > breaks arm64 Build ID when CONFIG_MODVERSIONS=y for all kernels
> > > > > > from: commit e4484a495586 ("Merge tag 'kbuild-fixes-v5.0' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > > > > until: commit df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > > > >
> > > > > > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > > > > > after df202b452fe6 which included:
> > > > > > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> > > > >
> > > > > Why can't we add this one instead of a custom change?
> > > >
> > > > I quickly abandoned that route - there are too many dependencies.
> > >
> > > How many?  Why?  Whenever we add a "this is not upstream" patch, 90% of
> > > the time it is incorrect and causes problems (merge issues included.)
> > > So please please please let's try to keep in sync with what is in
> > > Linus's tree.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Ok - I spent some time on this.
> >
> > The haystack I searched:
> >
> >   git rev-list --grep="masahiroy/linux-kbuild" v5.15..v5.19-rc1 | while read -r CID ; do git rev-list "${CID}^-" ; done | wc -l
> >   182
> >
> > I have 54 of those 182 applied to 5.15.85, and this works in my
> > limited build testing (x86_64 gcc, arm64 gcc, arm64 clang).
> >
> > Specifically:
> >
> >

It probably makes more sense to post the cherry-picked hashes:

5ce2176b81f7 genksyms: adjust the output format to modpost
7375cbcf2343 kbuild: stop merging *.symversions
7b4537199a4a kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS
f292d875d0dc modpost: extract symbol versions from *.cmd files
69c4cc99bbcb modpost: add sym_find_with_module() helper
2a66c3124afd modpost: change the license of EXPORT_SYMBOL to bool type
ce79c406a24c modpost: remove left-over cross_compile declaration
78e9e56af385 kbuild: record symbol versions in *.cmd files
e493f4727520 kbuild: generate a list of objects in vmlinux
a44abaca0e19 modpost: move *.mod.c generation to write_mod_c_files()
7fedac9698b3 modpost: merge add_{intree_flag,retpoline,staging_flag} to add_header
f18379a30271 modpost: split new_symbol() to symbol allocation and hash table addition
e76cc48d8e6d modpost: make sym_add_exported() always allocate a new symbol
b8422711080f modpost: make multiple export error
f841536e8c5b modpost: dump Module.symvers in the same order of modules.order
ab489d6002fc modpost: traverse the namespace_list in order
4484054816ca modpost: use doubly linked list for dump_lists
8a69152be9a8 modpost: traverse unresolved symbols in order
e882e89bcf1d modpost: add sym_add_unresolved() helper
325eba05e8ab modpost: traverse modules in order
97aa4aef532a modpost: import include/linux/list.h
5066743e4c2f modpost: change mod->gpl_compatible to bool type
58e01fcae18c modpost: use bool type where appropriate
70ddb48db4aa modpost: move struct namespace_list to modpost.c
4cae77ac582b modpost: retrieve the module dependency and CRCs in check_exports()
23beb44a0eff modpost: add a separate error for exported symbols without definition
594ade3eef3f modpost: remove stale comment about sym_add_exported()
c155a47d83ab modpost: do not write out any file when error occurred
15a28c7c7291 modpost: use snprintf() instead of sprintf() for safety
feb7d79fea1d kbuild: read *.mod to get objects passed to $(LD) or $(AR)
fc93a4cdce1d kbuild: make *.mod not depend on *.o
22f26f21774f kbuild: get rid of duplication in *.mod files
9413e7640564 kbuild: split the second line of *.mod into *.usyms
b3591e061919 kbuild: reuse real-search to simplify cmd_mod
f97cf399915b kbuild: make multi_depend work with targets in subdirectory
9eef99f7a335 kbuild: reuse suffix-search to refactor multi_depend
7cfa2fcbac16 kbuild: refactor cmd_modversions_S
8017ce50641c kbuild: refactor cmd_modversions_c
79f646e8654b modpost: remove annoying namespace_from_kstrtabns()
b5f1a52a59eb modpost: remove redundant initializes for static variables
535b3e05f435 modpost: move export_from_secname() call to more relevant place
7ce3e410e018 modpost: remove useless export_from_sec()
dc6dc3e7a73f kbuild: do not remove empty *.symtypes explicitly
f43e31d5cb78 kbuild: factor out genksyms command from cmd_gensymtypes_{c,S}
d4c858643263 kallsyms: ignore all local labels prefixed by '.L'
64d8aaa4ef38 kbuild: drop $(size_append) from cmd_zstd
7d153696e5db kbuild: do not include include/config/auto.conf from shell scripts
4db9c2e3d055 kbuild: stop using config_filename in scripts/Makefile.modsign
8212f8986d31 kbuild: use more subdir- for visiting subdirectories while cleaning
90a353491e9f kbuild: reuse $(cmd_objtool) for cmd_cc_lto_link_modules
ef62588c2c86 kbuild: detect objtool update without using .SECONDEXPANSION
918a6b7f6846 kbuild: factor out OBJECT_FILES_NON_STANDARD check into a macro
92594d569b6d kbuild: store the objtool command in *.cmd files
5c4859e77aa1 kbuild: rename __objtool_obj and reuse it for cmd_cc_lto_link_modules


> >
> > There may be a few more patches post v5.19-rc1 for Fixes.
> > I haven't tried minimizing the 54.
> 
> 
> It is up to Greg.
> 
> 
> Indeed, 7b4537199a4a requires a lot of prerequisite commits.
> I do not remember which ones are exactly mandatory.
> 
> 
> > Greg - is 54 too many?
> >
> > Regards,
> >
> > --Tom
> 
> 
> 
> -- 
> Best Regards
> Masahiro Yamada
