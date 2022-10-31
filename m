Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D553F612F84
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 05:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJaEyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 00:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaEyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 00:54:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2E7DAD;
        Sun, 30 Oct 2022 21:54:08 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29V2TGKJ032140;
        Mon, 31 Oct 2022 04:54:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=91aNCSJh0/1PrlRF2Z4LBvQKhrLSY2nnsn52Rc16iEg=;
 b=eHkI7cM8uvXtmx92STO5Dez4bRPjHZJPqtg7zcp9PPcL4UUcrUHcxgPNlmDqZ837BP0K
 7JrB6eArUY59QwjmI4rhaI7SQgIcHHpDGJ3Vj1ZiEB/xsAAhSJvj0PZ9OGX2oM1IMhaS
 n3GcNTf+lVhPq4p88QTFb3SUMXNTBZ18U0PUxvflz4EU48RmQXiTkxvuXEmVgY/l+M8k
 B2vtfT7R7cADrauccFcEW6o4aRDYVKMIzaDItAxrJxwUEWeIs+Np9ojam890XV6fXx8f
 AiUmyyXiapEZg3n7hksLHrKX8FL05KCWLGoCjQ0o6ET49ThocfD8xDis0Al7279aMhrI mg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgv2aaaxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 04:54:03 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29V2YngC037634;
        Mon, 31 Oct 2022 04:54:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm94b88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 04:54:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSYCrQwbkJt7q4rFBK7aTI84wtS4qknXcfhFRXIpKtahQ5jd0ARrZdi4VobND+SMfL0Cqf9eBjgNgA1Icotgs62T3JbeiuK8NnalyyUsc5iCSN8m3gWGwGAD5zDijNbHLV+rvqqwUKHPnv3x66StrJJaZ5qZXelRIaCx5/9tOTH+VbEnCfl/oaGcRmjU6o4K9yAUIfO2c2Lir+rGjubeYddyX79AIsJ/5khaxiLwsgUAaeSl0uf86d6hpjjiMbaIEh1NtB0AUrd2iGcNs8RmtI5X8SGHAXun2JKoOSSLSR9P4RqhUNH39GRhyc5mUpWVxOUQa/yNQNcp1qIkUr50pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91aNCSJh0/1PrlRF2Z4LBvQKhrLSY2nnsn52Rc16iEg=;
 b=U4Ad5FkxT3VxkKQB5I8XvBHaLCb6rKAqWY6B21K/mbzfBLACDVflS3JHeDigkdZCrwgDwH4qDqe+RR7Z11Z8LXcpY+wBzDyFuViTz12Yx5WIQKMqUN/chreXITKu3M7Mx0eOtA1255RMWfrbJ4BPNOvkycjUu0PqEute6ZpRfG4pCWuh5BOzJs9HBO7mWY3OGuopik/t2Y4GwIV8GPg/PkjRNYtqRbUDxTjpnKlos/n4QONZzCJ2Oc0eiDsMOQYtYHyJNAph3JSvpLdhvE72LphisK9ktUMeA+rWnc8srxymv+DXpNg20jsdr48YJiW43wYSvighnWk4njzZ4zeiTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91aNCSJh0/1PrlRF2Z4LBvQKhrLSY2nnsn52Rc16iEg=;
 b=ezTUCgjKn/b9NuWc6ljh/UCdqYd6z68C3wLEP9Nlr/TWUQajQ4f5pBNLjlv4k7V3tKgiCpRF7Y9/fFxuKry7lA2/VyGjjWy1clPJeUzQ3Eon6p96Qs7v4vjV0dPL/0l/Q7sPOFzLZfvnagVnE3EuG/5VFW+mimE+qJbMXcH+R4M=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SN4PR10MB5623.namprd10.prod.outlook.com (2603:10b6:806:20a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.18; Mon, 31 Oct
 2022 04:54:00 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 04:54:00 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 0/3] xfs stable candidate patches for 5.4.y
Date:   Mon, 31 Oct 2022 10:23:51 +0530
Message-Id: <20221031045354.183020-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR03CA0023.apcprd03.prod.outlook.com
 (2603:1096:404:14::35) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SN4PR10MB5623:EE_
X-MS-Office365-Filtering-Correlation-Id: da4cc0b6-0c0f-4b14-39a5-08dabafbed07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GRjDEhfhm6wmQ1y+Uj21DmP5fRxLwo/r1OjibcYhrfjbaAXJmnHCyMSmiE1Q71HD7rPZi9aApaNuodk6QcvRxNyBPn8Hm7Eqg3NZBJGIPwaRNyGNCVr02x66lrPNQKcXCQ6yZsdqbpmeCaVh+QrjQiCa/Gp8ykFXNo0UZHMcP8d7KyOnf0mDoXymtFq5oVFkLeL4EVyfFk3z5wEe9jmVV0CDm7onDzEUGGYPDdfSsY8BlnojPNFqEIZ4KJ3xPOkCR2HA09kUHtqTJ7O3Wh501pp1DAfb3QQLAVzU/UEifcA//m8ZisTBQ1sVTqL0VtFFyqkDUhqSqr8Hdqv3mOZOmoJv/L0xMGBtavxgqcdnR4Unp/xsf5/wACHR1DbfryoeCxmtIOM3iFM0mkb+ibf9UaQKzTwwPWZN5rK7xCZGsQkStAu3SIypO014J6w3JhYvUX5MMF+m+aMKxIWWDmZZpCVDUXfugiwXgF8fnySlQmTVh25mnUgO2Jk+QbJq3dnI3ek4Ibn/6RbnFSK2MBpzd0IOe67zTQfTjnTxxPS9xP4XOhgk7iLaKFNatBOL0JuY7pJbted6k7BlbOvfYaZ0bI2EMAnUyLJ1SuYrPPpnMV2WIBQszyJqVd62zNwQqbrz23NMPN4I/pvnIr2dA/mjvXDI5cwuhZ7AaUP+D6w7hVIBeWy23OyrOxvuoxc08vG+oNfbGVbLB4LGiNKpJQAq1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(136003)(346002)(39860400002)(396003)(451199015)(36756003)(38100700002)(5660300002)(2906002)(83380400001)(86362001)(6916009)(26005)(2616005)(6666004)(186003)(1076003)(478600001)(8676002)(6486002)(4744005)(316002)(66556008)(4326008)(41300700001)(8936002)(66476007)(66946007)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oqmev75rnXSnz3HMxpqtKDvjNY0Ue/upAUxjL+SHvzTtNfK4AsrXeJDmRsby?=
 =?us-ascii?Q?dzeY1Byp2uSyCLfidfV44TENptU49poAxdzuayuAQ+fOyM30o+KPl2ILqLiD?=
 =?us-ascii?Q?igpHe4JXx9LSH3K/KXl5y/TU99u3dcKwuivuJ6IUYKh8VY3z/smpKAsqpMeT?=
 =?us-ascii?Q?kmiGc9+Ry8cCE7oWH+whLETK89jXNJDVE0YOjUEALWerzDcZOUEfBJFdnFVW?=
 =?us-ascii?Q?EzXuepVSH0F5730E2S3f2DqtrZ7Ua879tBKe6By26+RmXEDaV7Qm5OlhcOWT?=
 =?us-ascii?Q?l1MyR6s8BWu0AS55uepiCWFKzxAikb07erPx+WzBWWfFN5uv87nbG5aonOo4?=
 =?us-ascii?Q?tCyIT45NVzkez/8cyJFFP+juqy7pzRQ23HF6Lo/Vasb7KD1+a4MhsSWV2jBx?=
 =?us-ascii?Q?8WyA573i57OQWxbWbUYaxkfJaL9VPh/Ye/HD0hk6xXBrm5qQlAgEiZAxwevY?=
 =?us-ascii?Q?pJqbpNd1HebuWwn8Mvp4jkXfD/vVvvBoUSYoAZ+o1K9Ps5e5jGE2X0lBnetz?=
 =?us-ascii?Q?ANelr0Z0gvp4g3pT8C07t+0bXCFSZ1NmXswzwz0QkM3EGmECAe+IDJSRYVk7?=
 =?us-ascii?Q?r+RcBfyYazPVD5H/7aI7xmKKQkAv9mRrjKyA7Vt26QW32oKhIh0/B0+eoyjQ?=
 =?us-ascii?Q?g3rM7Ux93AxACyNyt2n9BwDHP5Pc4Oe4UdoKd1kNldjr/NpH6WOCMOOYdcA8?=
 =?us-ascii?Q?jj7QHLd1OLq9Szb1Ddlqes5Ytkdce0vMb1NW5Sr126Ksh8p0dntVaFWR9dHt?=
 =?us-ascii?Q?1Z8pizIF6UlC83QrjbN6wz6red1jpAPryK5zm3ySwUhhAkpyKbWrpCaRewJp?=
 =?us-ascii?Q?BaS3FDuZKwQ7TQh/mfXFhSMSgMO19ckMVOLUZeuCycjggOuIFlWl9wVaPvJ9?=
 =?us-ascii?Q?/iilT8CVh6EFK9a2Hy9gh04GhjX59IyjOiyiSQcV/d3zWLdxAVpCcs8DFE25?=
 =?us-ascii?Q?vqW032qRC/NfN5VK3vU/Hddv1PfOdDeAx4L7jvYI8SU+cz+wir7S593YT8Ar?=
 =?us-ascii?Q?OsLw38UowL7s1W8IVvhdCiKZkmzVU0ig5arHjABv9qh+s2ygaRTPL36rGfYY?=
 =?us-ascii?Q?xX48SvaykcO4X+GLyeOgR913A5PGgY08Br1lFXoc2rWqGky5npB5wa25T52p?=
 =?us-ascii?Q?7ecQ8Odp4OsJqL99IRNAeJT0in1z8EheGTU6FZOXr6GJMNvz9fsmywNQBUV3?=
 =?us-ascii?Q?I4ucexGzOiSEGvmo0otiE8DoPIPl3Rl/63/WjZqCvUyT9UJ1nxJBvi1jC8/r?=
 =?us-ascii?Q?EpRu490bX8HvSdLHJtZcaL0ilWm4ui0BE1YQu+enHqvhV0oSkUVopbNC+28M?=
 =?us-ascii?Q?CYcLFxTTWiEgRjX6IT1qgY9vlLxRV7vvpNQWb8jRO4qeGwU27pINSRFSQjLl?=
 =?us-ascii?Q?CcgT4gA68epPeQmdyWk3OYZagyLDA42l+q+Mxv+QQZzfdNR1qrbUvRzGMLTi?=
 =?us-ascii?Q?kTJY4T5fvMGoU4A8nuio6Ry0P9njA1dV78DMxuJO6Tz+ap4gaOhzQQhwVsMP?=
 =?us-ascii?Q?UBpFCOpoeotaGc1UJr395gaK4bl8FWYG6diTMhrepgvhggKF0RIw5y4GgJOY?=
 =?us-ascii?Q?brElJZ5NM5lojRayuFK1NS4s768Kc+AruFmvSEAa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da4cc0b6-0c0f-4b14-39a5-08dabafbed07
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 04:54:00.3515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: irAWmI2dL9TTw6NACuqCt3ZIU8AyxXb+1ujHkGa+BKFE7cu+eVkzPT8y2OXH2TzEs86b4A5BUA9S55QX8fWQ9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5623
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_02,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=953
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210310031
X-Proofpoint-ORIG-GUID: yeJNkR_HKJasMvz1f9_AT0mpLlEWpJfG
X-Proofpoint-GUID: yeJNkR_HKJasMvz1f9_AT0mpLlEWpJfG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This 5.4.y backport series contains patches which fix XFS bugs
introduced by patches which were recently backported from v5.7. The
patchset has been acked by Darrick.

Brian Foster (1):
  xfs: finish dfops on every insert range shift iteration

Darrick J. Wong (2):
  xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush
  xfs: force the log after remapping a synchronous-writes file

 fs/xfs/xfs_bmap_util.c |  2 +-
 fs/xfs/xfs_file.c      | 17 ++++++++++++++++-
 fs/xfs/xfs_qm.c        |  1 +
 3 files changed, 18 insertions(+), 2 deletions(-)

-- 
2.35.1

