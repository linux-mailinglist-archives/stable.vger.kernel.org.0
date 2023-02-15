Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6CA697594
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 05:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBOExg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 23:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbjBOEx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 23:53:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6DE34004;
        Tue, 14 Feb 2023 20:53:20 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31EL45xU027212;
        Wed, 15 Feb 2023 04:53:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=6YjuHe9RQGFWTCigdFV2KAsPM5VD37isRiL1qgPia54=;
 b=xjb0UreaXVHbUYTjRCZYT4TXB/Gmv/TeAwlyZYfSXdazh+oAmttPe8b2V7o+ldKtX7sg
 usyAwF/92m1oWg1za/eCdo6jo0S2QnwRPTr/1JFSogz43xAVU0NBAK857TZTpH6I0u+H
 qhKN+tBE7zvfvO6TJoMVMkZ8RzRYu+73fyy7qIxZ4zpFz+b5zp2OuWWMxs1ez7AMLYIF
 rQDBXCItQCXLzFJAA8DjcYPync43Xqh8CnEEJCMUqrh1iEJZfbXcA6uHy3QLXg5saKw/
 YZ6NO4a/Jg7wpIkoHlbnMZaBalG9Eyd3a9bBtVTSE4N9uAlho91ZIZq5v3BmxdkBdF/+ VQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xb799q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 04:53:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31F2mpUN013558;
        Wed, 15 Feb 2023 04:53:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f69sae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 04:53:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVa5XGMuyUzIyzROTdiG9eWzfpXvEVDblFqNG2jJRMT6iq5bIx4t8OiJJb5WRTx88NJOx0wbXrlY8wf3ntZ20HcxuSmyPznMMBBFSsuNKdwAt1bhD0GlXgeIp2AKjUtyFi1Y0VGqxi98J20Il4MeujTCvVjhDPVOGSL8/So0m7cvcV5Bm/R3VFGqyjQUmiQ7rkCoIKOjsx3vbORgQvyW/Nf4NvUR9g2joMBCSpK6wBr+oVEVAtcQ9XnnwfZVuCwQHBVfcBzp1A0st6KQ+TrGdwoNqlRsY7QFhfPc0lIAmjSMS5XP4uDj7Vq+/AltY9DiZt1IICXky8DtvaXVjkcr8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6YjuHe9RQGFWTCigdFV2KAsPM5VD37isRiL1qgPia54=;
 b=IWBgoVoeWncPrE4kW92BxrOim56xUMxOYuRobmiicRhoA88DHXZJg1B+ruFedpFuD/IFynhPrfra7QtEJaHzu+8N5EBLV4VzjnxZ2fdjiNNAjrAhHmjKdxeqAJuo1GHh/x+eJV4wo1XD4h9EaYmPWmdtSPC6lbF6lj5iH+rvyx6spiR9vytDu38sZQC4hFy+YNU1O9RQwVJ2Y+HahGlM6oFXhvli162BxicUuZJXttbAsxM1B/o+a+EWY4NUQ17Qb6y2cUm8onuiksOX6ox1G3Ggk+1E6LBKPUZDdXCV2mymAUmnDJiWop0BOKhEP0fJkhETulY99Q/Xoygec+KBtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YjuHe9RQGFWTCigdFV2KAsPM5VD37isRiL1qgPia54=;
 b=vxlVrwuCL6qdtd3yTW3bg2B7UH5/LVEY8foZj7mkxSrJENb+SleSvNv+N25RaZ3cKYLHHPp2G4ODzqLcay5CHqDGZ26eHXCyO3WX7k75I+2Ivrjut5sEfcPkB6r5WvtEzr1boeiPt0Bqq72v491CY40VncHIj3nDmAuY5m7aa+c=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by PH7PR10MB6554.namprd10.prod.outlook.com (2603:10b6:510:205::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Wed, 15 Feb
 2023 04:53:12 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::560e:9c52:a6bd:4036]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::560e:9c52:a6bd:4036%8]) with mapi id 15.20.6111.010; Wed, 15 Feb 2023
 04:53:12 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Daan De Meyer <daandemeyer@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH stable-5.4.y] btrfs: free device in btrfs_close_devices for a single device filesystem
Date:   Wed, 15 Feb 2023 12:53:03 +0800
Message-Id: <03596be514e296d87240c2b044b7088962ad9f1c.1676435839.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0171.jpnprd01.prod.outlook.com
 (2603:1096:400:2b2::17) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|PH7PR10MB6554:EE_
X-MS-Office365-Filtering-Correlation-Id: fecedb08-6ef0-4dfe-7098-08db0f108aca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GoYmNXKgP5wDza58kUM4J69l0FU68qOJYbkk+mw/RvVqhGh5SIYLvIKO8oF9oWnldGhp41JJvqf7tLo4ZwJQT2pYOpaSIEo7HZbi8zssYHcj4OFkuf8d+xTsYQ6OchBbPdlCdW5Fa835R8W63x50LoxTdz3D3xPpZxDdDmKzvFqB20PAZws0eUN/Aw7cCL+EQmaiZfTGARCR/cRNs4PyA0LCr3qDZGTj48OcTbLpWRspz/XuLjIQ1FDh7qg4Xh54xtXOnliuP2bNRfuiNkQWguJtKBr/Ixslym5gBfgxIveeWMxrnkhn0TyHkPJnNnQ80APEMfwVI7xl8y9AJB3FrUdFTo+0YcZpPvVHRr7p4r8S5p6R6zMP2HOWsBoPkQQVILYoFBYVqMKTgjo/EALgN/nyS7VyNdNsmWEnnvdvE0pMf/Z55nq6LWpC19MZKmb9HRXPbpSNz0TI352hjRM/K476A1sS3Zokh3fXUXwXIX3DY13VR2KBaI7QCVyRjrDQKAqaR+yXyRNoTY0Cw7Chv8lnACUKDRSffc6wCdreX9Gtxpm9xtEoqSPdqjONRRosJhmuAt+zWSwYZXnEhFS4PvYshZu9FTR0+43Sra8R1DtP9O+e+DoMmayaIK/iZOV7H31IP5AfXYnvnXsHnX07sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199018)(2906002)(6512007)(186003)(83380400001)(6666004)(6506007)(36756003)(2616005)(86362001)(478600001)(6486002)(8936002)(54906003)(316002)(41300700001)(8676002)(44832011)(4326008)(6916009)(66476007)(66556008)(38100700002)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?52cfngVacGJIu1YO5BsVTc5P8/O3ZX7avjHbac/h5iBG7ykoxJnq7yTTqHr0?=
 =?us-ascii?Q?es/ZsyyoVoL7mGe+YugRviO37LKOQXHxXq5Wah1a7zll89RD9nJTRnZ/f0xk?=
 =?us-ascii?Q?Btn4wyg+Ta3CtxT2YRlOYGjweaq3dj+rhfYMXY2VR40Hd9zW4IhIGLXt2FPq?=
 =?us-ascii?Q?rir/lQ3GCK1FhG8XhZsQp0mv166UY4i4VlbghueiaMna448xxQ5NvtfvOcTi?=
 =?us-ascii?Q?Y4JOx3c2RxS1ZdMIf9PgUjAmpFSgQbKCKsUyth/mJWNLE9Lzgt37Sx3ReqaM?=
 =?us-ascii?Q?gfTWM1oFOGttB6jUdTPgoU/x0CywCaiYlstcNyad2QMcpxKHCYBW35cQp3N+?=
 =?us-ascii?Q?f3xLq3uUzpWnxRGat/kBSm588F9uSLXRCj/jdgYwgy7VR2oGlBU7KGVGlreD?=
 =?us-ascii?Q?on8d1V00H4gblZk7LlhYXreJSbyy9Fi6JaoaKURK3/4EzBkGj+rKUtVg+9PF?=
 =?us-ascii?Q?b9QrkeiOvD1vtHfUgSyQUTHMja7qWmPo6xIOnX9GXrqdpXRpNQnwfyqBPrNs?=
 =?us-ascii?Q?MkBOmiDYoAxCP6fayrcZ+udxjDKRBR7qYpoK+cia8FKUW6VrOYF0hBzvj4hV?=
 =?us-ascii?Q?pfuxH1BdPJWcD/J2Sj+PrxS4iE2Ug3kUcFnXGzVNVliMytrW9+wxfB+24rfZ?=
 =?us-ascii?Q?wxd7UJedMGTHFdw5NqLKqj2wjpuoCDptf61z385JjGibDZlDTL6ouvTpHV0p?=
 =?us-ascii?Q?OWkTTmBRm0b7zPJxLtL+kjREiVdbOkaB4PwUs9QpMkt8Sa4zcaSfDG+9mYGq?=
 =?us-ascii?Q?uwH5T4OT/COPlcJw/5noQKzCTcuQnIxULyp43+HhmvWILRH8ZOs7FqngxTu0?=
 =?us-ascii?Q?k+AB9aybOMNFWUa4R8fGyq4y1cCjjanScPPa/rwqm/eco1epzrrvg/fGsXQj?=
 =?us-ascii?Q?hXwZNzwHZkzI/IHDIiK1PeGK7IajZNurwkXPuVemEJXxplVBYn/DDomsD/hJ?=
 =?us-ascii?Q?Hoclo8DjDGrRSPTA8YyC98Aj7OtLI6BAFQsPjI6r3GZWjyysCDjUioYAOzCc?=
 =?us-ascii?Q?swE6JY5V1OBhYbxsfoMsT4ok+tL9NR+vcJ5nermTLPWz/lZW5x871xcbo7Au?=
 =?us-ascii?Q?MOXz1fuf95RNMZNj6HqFLRNqUr4nYvLFdptEEBHvqk5z41KTUl7u/scO6fYp?=
 =?us-ascii?Q?HC+W3utAFODyyYBB2sWN05AGdbTrasfrmOuKSKyp3xq0U6f6Lh2ETdXrRCJ0?=
 =?us-ascii?Q?vkDw1YanMO3p7HnwEiJvFhqEiXEAdvSPhpfNWXwRX8PEzIRQfgnbVg07rwTB?=
 =?us-ascii?Q?0Lxf+1qqAZvQoSaf7AxcqltfFxZZ0V2jl5hOdBxXyayvha8LZjSke/z57GEN?=
 =?us-ascii?Q?RLQai07wDFJL/NBLKykiHwDaJwTpX423Edb3sBtVphLO8IWAdQ53ph5up7zo?=
 =?us-ascii?Q?z6LOHIMq5ts8zRNGBxKsLFzgZBVYLQx4EK9pub7pc+0rUZKsEoJuuiEuXELv?=
 =?us-ascii?Q?pZ/eDuRR4Gal/oJjd8LLAVBSVaPmaGISxZUyGdYSOe1dNK6vO8Iyr8oMzdae?=
 =?us-ascii?Q?ovGmvlFVrcDr4EbsDtyHS2bdPHH56I/AsAfFCyrOHq3rFNdharsROjZg5U3w?=
 =?us-ascii?Q?Hr+VGoI4QrTT7AY3kTbe4C53hKNb0KIE6jN+/BU+4MmbXEsAsDyEhkgPhx7V?=
 =?us-ascii?Q?ELo71L7jLP1csQRNDjJGz54=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: isEvJF7/yoxPfiM/SyIj29ukJqZa6rbFAsDHDoxIPKA/BFW0t4+maXZAdjZ4J6NApJ5bFWZEAVijSpzvqQfCk+Zt2u4kAuN33wuwWg3kXQBrAolwm6w3fwUEDs+psl4irqvBJYYZCsg79LtjDNzZz91SpXVrUFf3pe3iq+GqCHBKdRii82qP45fcoFb/Zc7ltbFieB7lgIU/59xYOt1w6nwj9TPUdArnp7jCVqbvQvYRccL4ia2egtkurChh3ZkL+RnV5LjjkNiy9UvERbBPfmvcc28ehSNtWl9kcdXHo443pom9VxV3D8riB8l1wsiWlaS1kWcAyF+OxzgGqdTiDitNDri4O1xW3dc4qZDW1rs0//QsvMrFDnZq9Vdq3EV2YjmU/Fua5EepYvJIXwQL+DcnCMGY6g7cH1MI0IGmvRGWwAlUH7keyromx6DUcsTKalDAT4rxdkCfBGDqcxHvMzWz5WpBo9eZMT9ds93BZ3220DyjeTTKo2GE6oP0BxdwWDcc54Tu+OKC2pAku+IZ0DyrFLppH6fRva4MUPH/Mk9//LzwsoJEw2S1sa1keImx0QgmPcqi38BjeFu/Wtaszq7+Zv6nsMTFw9Z363lKB7iycM6lAcScjwMxd/E9OaImSoBciaukl2j0oYl4SdtjvIyEONletx1UpwG9JOMNRS8+65S7dJaQBkvqvV0O8rpR225uSxXBPp9vXqDXjNzbtf1SE0h4RFONKo9DIiUm9yUBJCp+yaeVUq2e/J3N+3Lmdoeysbk+sHRPJ39JTYy2XyfThYS/mn+0eJJL/Z8ZV+0u2Cp3kU+s9u4OwWdQ29P2N9oVxYeDpYlb/LWnjNeWxA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fecedb08-6ef0-4dfe-7098-08db0f108aca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 04:53:12.8597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdDmw5NxKMddxpuVLRBDRXsmtYqg2h+8DRcRw3ZXfIPDmWeMApcAZlAOSdpIIklL5k27q/x+ya9ypsO9vrNgyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6554
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_02,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150044
X-Proofpoint-ORIG-GUID: esmLgSpzMThgFb0QeCKTC3_Iz5sZ9EUi
X-Proofpoint-GUID: esmLgSpzMThgFb0QeCKTC3_Iz5sZ9EUi
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5f58d783fd7823b2c2d5954d1126e702f94bfc4c upstream

We have this check to make sure we don't accidentally add older devices
that may have disappeared and re-appeared with an older generation from
being added to an fs_devices (such as a replace source device). This
makes sense, we don't want stale disks in our file system. However for
single disks this doesn't really make sense.

I've seen this in testing, but I was provided a reproducer from a
project that builds btrfs images on loopback devices. The loopback
device gets cached with the new generation, and then if it is re-used to
generate a new file system we'll fail to mount it because the new fs is
"older" than what we have in cache.

Fix this by freeing the cache when closing the device for a single device
filesystem. This will ensure that the mount command passed device path is
scanned successfully during the next mount.

CC: stable@vger.kernel.org # 5.10+
Reported-by: Daan De Meyer <daandemeyer@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
This patch has already been submitted for the LTS stable 5.10 and above.

 fs/btrfs/volumes.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 548de841cee5..dacaea61c2f7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -354,6 +354,7 @@ void btrfs_free_device(struct btrfs_device *device)
 static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device;
+
 	WARN_ON(fs_devices->opened);
 	while (!list_empty(&fs_devices->devices)) {
 		device = list_entry(fs_devices->devices.next,
@@ -1401,6 +1402,17 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 	if (!fs_devices->opened) {
 		seed_devices = fs_devices->seed;
 		fs_devices->seed = NULL;
+
+		/*
+		 * If the struct btrfs_fs_devices is not assembled with any
+		 * other device, it can be re-initialized during the next mount
+		 * without the needing device-scan step. Therefore, it can be
+		 * fully freed.
+		 */
+		if (fs_devices->num_devices == 1) {
+			list_del(&fs_devices->fs_list);
+			free_fs_devices(fs_devices);
+		}
 	}
 	mutex_unlock(&uuid_mutex);
 
-- 
2.31.1

