Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486CD4F4613
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbiDEMds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383639AbiDEM0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 08:26:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B953DF4AD;
        Tue,  5 Apr 2022 04:33:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2359ZeZ3024455;
        Tue, 5 Apr 2022 11:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=F5uE6+SVEcGwYLsP7warrAcy3BG3RPO03eXfis/1LHI=;
 b=yi6wFe8vVF4gUZ5MyiV5eY/CQ00Uk0Syy2LjiXHpoCtj7WKTnLmNnMOZRcyhlRY60GrM
 Z02ew38zFw4F8BI6lwfS2nGnisCvNh41DI/A/XggdnOkPUrRxwrhrefydkxwblv+8pHq
 iRQuzvCTTIlRpmfadMCJTHcv0z3Alh7btxOtkfBxoItpeWRuomNhS+JqD09NdpNpao54
 h7sdgev6+o4rhQyq1yCphDf1ZfQ9nO1irCp1/+9F9q19B0dL+0mC1sCsNZNhCcfC4odz
 2lxFDOLs+oEx/bztOo7zsTn1VacL6UfCYnucs0RVI0wy9CMq2+U+gdkCdpxiMWmroyjJ BQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1t5sga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 11:33:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 235BWMgh013101;
        Tue, 5 Apr 2022 11:33:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx3d23j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 11:33:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFZUFD6TfHtCkABoJulJr14p8PRI5NbQqTVO5qaW2mMBnQ7oB7eSMA9OQ2D45GF97xr1tB7Gy79gUfsuJ+x9ijiJcgh+/C6w0TACSFOprUtoQKTY+T+BovEQ0cahSSHT1CSLcE+FfJTaEQNvp+o2O3HdwuKpK5DPr+h6eBij4WQe1cI7RPyVS2nnB8LtSeAwajjmIh/34YFaAMSKzjEPMHKg+xZp8XYNyb/uXtL0K3h75KhlVocZBs//jKO4y/9PiZrOcVZ52Jx/tXA5IGt84iVhkSf+5lQINS03OnYwJriTlc3HcQ7xUhElOkFxYg3c+SNs3CBINGd2RvvdMVbASQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5uE6+SVEcGwYLsP7warrAcy3BG3RPO03eXfis/1LHI=;
 b=NiHl7bSZQPh4UcSrbgFGA2rhYaq1lzvaMCROuIAnRj4+FCgIBG3PiMD8aSnwniDrdGnH2NC8IHLHfk+sE4ja+lgAaSEbbJgIU635L7SgSranCvaGqFEoR2L7l1NJLbFog6BthCID4NB+QGXibFHd802ky13GS5jnPgsCmDBFi8DXIxT+j9iHJCsg2HFaa5fhcuAwtw6irtoNE3cyi284m7+2GaJvXk6fUeUXq8AVCA0T5gpkuIb/JGr9wknAPy0V1dVIp0OR3aKCObDCjgAwyQ3LMTuDlz3aL0Td1vYkpN1suV2cLwhd3CJOwNhFvAIiJxUcT8xcCzSsxmEqMluiWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5uE6+SVEcGwYLsP7warrAcy3BG3RPO03eXfis/1LHI=;
 b=tjYfEndQQy6uDP+vIfKWqNx4nGKwXYFzNetFmHl8x7f89iaa9KttLXgafx5vtibSDWmb6l+uy84oUaz5kWDxnuUTMIOB6CqQUs76V+D+HWMQiz3t0tkYxEVdv831gPGFRm+l8RkCAbmgRSX7hG72n7RnoiJEylNyU8h0hqtKxWo=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MN2PR10MB3952.namprd10.prod.outlook.com (2603:10b6:208:1b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 11:33:25 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%9]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 11:33:23 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 0/2 stable-5.15.y] Fix mmap + page fault deadlocks part2
Date:   Tue,  5 Apr 2022 19:33:10 +0800
Message-Id: <cover.1649154880.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::30)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0341dfa-c178-4536-448d-08da16f817a8
X-MS-TrafficTypeDiagnostic: MN2PR10MB3952:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB395266091AD5DE6B89E8EFDBE5E49@MN2PR10MB3952.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aGKJhDL35OgRhqkYAHk9zHgYA+QTX3Yb3gPSwYtzDOJwra7fsSPZOe5guf+oDfQPBLBvFyglmQM/KgdDlvxNk7jdSctNo+UL4OboL9VackL8Tyjb6IIqoASJD1SJU9Y8ukVe5pSlwTWGOYERqY6vB2JlpH/phcmi41bjXOQ9Tu6qrznXFZHl1f8P58vF+TabnI4RTlcEWDJYI09TDltSH7ai2lGk1v4AOBfZx1JJqi+vM/ItOdG84yAwWCqC1XzKIr1780Db2g8LZsSpCW2JBZDIvhouyhfeOs5k9+SpZyHxwPe4xhhokJOOz31K3PPG9twlBHD7MXMyuZPG0wPB9CAZuy9j4+DZpiGdcYZ1Ov1uDQa2DjsET0mVm+SOYgPm8j46z+1i1Jf15ctiXtm1ClfSMWFPfAyJ9HDJxHKYWi41c2edG7OiZa9DlDWpCE6WNl7osqbN5LQVHHCeQQJoDM6wCe6CpVLmMHcimHdkapk1Db0Cdv3rCSAgwqkegqMNnvzVyY1yPqAz6S3VUm1xYcRlSywYVmvY03Y7t1ay/L2QQX2MDGPfSorMOfXM67EO4o/gZAGQSRurFPzo9Trij5+t8XRJQLA3V4OlDxBPlWW8d8PJWyNozxH9Q8O06Y7+sVVOwsKf76ij5QO27ljYArxgD3wLDcjG9boVwNH+IyMrBd7C9lgizLMBrtGuo9kdV9iOKsOIGDslwI7bo6tOea/J4Fejwi6vKEEgIfideGk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(450100002)(83380400001)(66476007)(508600001)(4326008)(316002)(6486002)(6506007)(86362001)(66946007)(66556008)(6512007)(6666004)(8676002)(966005)(6916009)(2616005)(107886003)(186003)(44832011)(36756003)(4744005)(26005)(2906002)(8936002)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o+BU6Yr0cw+4Ngs+AFvpeHNnVlAycV+JSsBawVyul2PxSkkOWcHo6DYUh582?=
 =?us-ascii?Q?Ho7hqgipf4GkF8O2Yo1U73uhLXCGRoPTAJVM8OSuIM5e4ib8zTY7LBAwLt9x?=
 =?us-ascii?Q?oaWLkSzHHUwmfT6nYbn3U8guWsYkphL4SC1c5ZbVxdwVi+Pas0U/TBYLZCn0?=
 =?us-ascii?Q?22Mq4f4EKh64t/3t5nDW+vkqA3Sol2hIY15x2q1UkVsdXSVgNw8KC2tseVWh?=
 =?us-ascii?Q?8buVPgSN7UJZLA5Lx0/szMf9Zv5rZ8wC4BKN6yBIxbEf/XHA7y6PfAOW0Wec?=
 =?us-ascii?Q?+iepfeDwlkrYw9355bnZqygp3mmwXaF50r+wzrkoQHKgnOQwpIpuDnlDz++w?=
 =?us-ascii?Q?SXbYJx+OzZUKuyxaSieJZbjtIOxYg+YPmfkayFGqgDFPk4/+kpSF3K9tmCjy?=
 =?us-ascii?Q?YQR3ADBc8hp2H16DdXssyGv0Gb0E6WuOmcMRbWDfXzrVnmoa6+44JiaMEaqv?=
 =?us-ascii?Q?X4eEGgzarPMC8fANkQ0JmahJMYXlffbsbtGCFaRCF6S/Y6bwpmIeZNGQrro+?=
 =?us-ascii?Q?S4JZhZ1THzRCpXxHUw7aqIzIstYfR4yZdL58TQ1LibR3r3DzWKOW8vutyyT3?=
 =?us-ascii?Q?Kzwt27VZiNSwXuski0wqgc2Ls3ZC57WT6/2MDvR8zBtVkBJivclDU78dRavo?=
 =?us-ascii?Q?g68f483mBWwrryw/EY5VSQysNaQZ6/SvER1RV9tkWLk22AtsYbGB9KU7jbsR?=
 =?us-ascii?Q?JkLEWD3HDXeCL3yu6MeyxPuB28DCSmZMqNfGopI+z8gKCYPPAeAvMOlpwkBw?=
 =?us-ascii?Q?ha5pcIjKavBdizSpqO0wzfPRSiQ2d2NSPtLaFYvGxZR5mNHK7kxxr6H3KdK5?=
 =?us-ascii?Q?gZucjGL4U6CmC8pjYDmmUKu9QD8w3KWMz2bwJUpi7YEY8zRYqCa7d/0UQ5L5?=
 =?us-ascii?Q?3ze7kwoaIQAM+YuDyVzIdNPE9Ibk5h94AHX/kHT0tcvVR8LjZ4b2mv7+QZRx?=
 =?us-ascii?Q?bEfaLexQ/W8xyVGWk+2OrNFYCk8oz2UZ7r+OQvCfX9lHsPOgZqVNkH5VAsdX?=
 =?us-ascii?Q?ieaJXM+0tLiLmbH4u3bzCgW/I92A4CILIQDsl9joixnpKoBOOgvuOGiEcn+x?=
 =?us-ascii?Q?RWKgQkcUekNEO9gs9rJybMJ6zcxmJtKEzthtBJuMcsps0Qmziy7AJB68WacX?=
 =?us-ascii?Q?FWPaZ6fNwMUpqq1LXoGMvFPfZFROLSVD81YfLA37s2DaWd61CJB+PQntuwa2?=
 =?us-ascii?Q?ATCTMdV7bDJnF/8AbTb7lP+kmJ+hGYaKuUkgA6eYObEsHj4ZCl/9nRdZxrNM?=
 =?us-ascii?Q?8HzvCJg58Aw+S75OKijzVcZEals0D65rpyFKdcnV+1afZwgPvzXwDqa8qDex?=
 =?us-ascii?Q?WxrdW35PT7Yo9Hab4qXMrQxBcaXwOtHBntM2GafidYRQJ/SqamK7GLtk3bmv?=
 =?us-ascii?Q?2Ryf2nqe6dDnF8XoRnAgIYgcTLfGVNQNGYGfrkqffZrXBpToxFa4JUNNibJG?=
 =?us-ascii?Q?UwimXnd6P2d6i4q6Vw2xeZ8JPZ+gQL+5hY9ZBM2Yv40O3i546GW5mhO7Yq/q?=
 =?us-ascii?Q?de4cAE++5ondSdseVcu4evHcMnQXorbnrKa+60JIsTmqKLAjUAUjVFSasI5A?=
 =?us-ascii?Q?bK07nxv/IhdUs6gqSbs8qPiO5Oe6Mrh2jJicx6Yu09rYraIgThS/ESnbIk8U?=
 =?us-ascii?Q?yVSxJsSusRoa4+e+Vb7M02NAvPUGyvyl+7L6MRcFKa+OhrmNvFgpC8aZKNV1?=
 =?us-ascii?Q?G3o8SKqr4I4Q/8aTMvvTxRqqx/nSEyLnN9FVUYCIuEzKKNe8fhNq1ivG4vV4?=
 =?us-ascii?Q?Wt2baVT4p8eMvGWMkizycumUFFResqY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0341dfa-c178-4536-448d-08da16f817a8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 11:33:23.2154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+hIU1rjGjKwZrdsFAVrl3Hj3+xRrlB05DOD5dNfEIkgOnEmtIdvrOaWG2/A4DDxveu1DWv9OGLjypb7XqJm9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3952
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-05_02:2022-04-04,2022-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204050068
X-Proofpoint-ORIG-GUID: ldbGRo5P-KEVVHi1pzOaHQXBrkEQE2Jc
X-Proofpoint-GUID: ldbGRo5P-KEVVHi1pzOaHQXBrkEQE2Jc
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patchset is the remaining patches (part2) of the series
'Fix mmap + page fault deadlocks' sent earlier [1].

[1] https://patchwork.kernel.org/project/linux-btrfs/list/?series=628427

These patches apply on the top of the above series.

Filipe Manana (1):
  btrfs: fallback to blocking mode when doing async dio over multiple
    extents

Linus Torvalds (1):
  mm: gup: make fault_in_safe_writeable() use fixup_user_fault()

 fs/btrfs/inode.c | 28 ++++++++++++++++++++++++
 mm/gup.c         | 57 ++++++++++++++++--------------------------------
 2 files changed, 47 insertions(+), 38 deletions(-)

-- 
2.33.1

