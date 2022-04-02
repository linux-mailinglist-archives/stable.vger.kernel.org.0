Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575124F0089
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348334AbiDBK3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239094AbiDBK3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:29:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3C71AA059;
        Sat,  2 Apr 2022 03:27:39 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2321i0bc024906;
        Sat, 2 Apr 2022 10:27:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=HuGfyFsPlSPlWrwhw45+9Dc4WjbxgSWTpY2S28+blls=;
 b=RDJdXo0ntr3QJ3vxOjO0hfrB5AopMSV9ROP6dpz8f+JcO7Q4tW3RKCD1JYFiHqlQQZhs
 uyOZbKrNrzibz6nB8lPQisVJwfiMsqas999v1oECoFHyZID4YbcKh7f7iUBfvapA3A4i
 jcoCchEaGkFqnPI1ZR/yVC1nLFcam3DZO//dlwebrD5CebOwPfH/0hk/mfaH88zaKzri
 X8y/QXeD8THGhWe4TixZqQ8/H26fq6j3qBH0ZR+BdGWeCM2gP6BkrKzURqn/dJWOtWel
 znQLDPzSt2KX//cXdTQvw+WuPtq9vl9QKe9GzXfzmjkJSyRrcmZd1M0lMSul2gWd5cYk fg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d318dsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232ALO3H024377;
        Sat, 2 Apr 2022 10:27:30 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx0xche-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UaG/bDAh4jL9iTklmrKEmB5Ai3AsxVyN3xieSrJGPwEv2DWPc+SFdh/tGl9GfjU5MGGrS/seUDu9pmBt6EsTBgAWzMfixmSxeB0+OOf6+cGrze9pOM8hz1eYpJJJBGoafvDQW0dMmXSlmxTuC2BQhd7/aYjVHpiUu4HUjrZFbunolUZDN8cT67Ye0dlwuwpx9U/3juwtW9QYXrK1lpHrl7FEeAA/BVFnQRKlyKuaPVRNO8zJGz9pu3LEMa4AJ8yIyD7zAKo0RcoeOUwBZ0+r3hCqrPMW322Y5zxAS2nZF8Lix2E/QO+Csi2TDVnjGzYBAyeMT8X3LqOTYbNKFLN8KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HuGfyFsPlSPlWrwhw45+9Dc4WjbxgSWTpY2S28+blls=;
 b=cpuJ9B3Ys5+Yo6SS0IpaBdXldzFhhXa2vBFdLTim+ijp5EGiC0Kkhi2EfMCC7pnJGe7+dykk6FWmlhURxHlKq04kNjtdYkanYXvUebbg+vf7BLSJTKzRVlsJ7iFzu5dx+ufW+UYHGVl6RkispbTWBmo8xNRnGACv2g5N+FtCaWe3SoCeKWr+y84JoHymyrK9s9Aqi5quSOY1QLqJSe26Qic3pgHy/UJdogqbcrOdBupE5B+g5vdpvdHHFt+w4e9NbK4bVDStQovkQM6vZQUkSrPefAQcWNuzXJa0W0JZeH15oQIrasR/l+pybxQ4j/8BDddDLLelsegISYlnd5gqRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuGfyFsPlSPlWrwhw45+9Dc4WjbxgSWTpY2S28+blls=;
 b=p2M9gPrZ70ouCZIrdDuAf2DFD3nTimKtwzr11EeRxUrRZfxrD3EBkCfbFtHxnbOW5+lesGRVjTbj4vCG+FEFoLnfdG+Kg3fB3X2IdQzld1fmjoYIYPkJJu7H0Xk0Mn4XwEZoReNRBg6fTtt06Vo0cM5p3vhfcGQnibASLvtjFAw=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:27:27 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:27:27 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 10/17 stable-5.15.y] iomap: Fix iomap_dio_rw return value for user copies
Date:   Sat,  2 Apr 2022 18:25:47 +0800
Message-Id: <3cc54281717dc26f34a15d0d27c91c28ccf9ebaa.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0200.apcprd04.prod.outlook.com
 (2603:1096:4:187::15) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d99349b-ddef-4ab9-cc73-08da149362c8
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3049F77B6C974D832E681A04E5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: da/RDM4NYI9KKAeq+Cr2CKET4OyCaEwIr2e6YXCkfIDJQkmVjEImJmJr9FTmF+QcMHmwduUTWK5mz61SG2+RqmhhHAWQax8hz30VQTo6EDJpJwLw/EpRl693vddPAtg1d/rv66zXZc+BxSUX0fmt8QIrAMLLLApHqQAX3I+N7Ywo64KVNso1I3AXE1JcvezPakH4WvYybhxwwF3lG0bhIXati3ebaPCLXTb6q6MqAEjByRs3H/xJw//c7Qg9lRw5io7AkPAqlvRC2OBGkHA3c+zztwD6/UPopiN+Ns7JnaI6qOAvC9SZSdgpNU9XOhDSK7ZuEMibUByts7fc25nOHlLBzfPJEGvZTpkHuVCTRleSozB6dGfr6c8/yAowkqtrDf7Z0+N6yYdqtA+OxNToQmdqNgeBi4/S+zvg9CZWP4nbIPDIjy/NZgI5G3QdmzJksmsq6R+dHnJZGZ88OZ/JRRzjlSs4bXm8WhrokzZ7oDm38dCSlbql8CZx82lRUterA09f0FwJVUylQMVLiQDRJkZKuQUFPrjTO/4+TU3zt61rzR8C0OviG18iruv/K64nd1bkpHfj1cKP3r7KPevrbZjOV8fEMuTsXM5ON6uz1s5mP8eTxRi74dkKQyNxv7X2f7Jy6DlrwZeJxNK04q9Y+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38100700002)(316002)(508600001)(6512007)(36756003)(86362001)(26005)(6486002)(44832011)(66476007)(6506007)(54906003)(2616005)(6666004)(4326008)(186003)(6916009)(66946007)(107886003)(66556008)(5660300002)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sb6R1ZxtEWLR3jNPj+gu0qr4vXwFhb3bpzXRnA5WPQj4kY1YCc5N4HVUPAZ6?=
 =?us-ascii?Q?qoENgSCgTcIole+brxnnJPwe8obLb/nWHNdBAg65wun5dWykS3pjOwbco+NX?=
 =?us-ascii?Q?Ss7iHUe9lcraIgFXezpWcpoeCoIO4/QORpfTWr+5oo9uqByj5fn7BidjvcQR?=
 =?us-ascii?Q?FL1BQG/SKnpVLXerKtGxtO0JAu0SnoOn6M1rM7wNRDDSQYE2BqejI4rcTY5T?=
 =?us-ascii?Q?QPnoHpjPErRkZH0cU7zm64QeGdH3mkYNwzoWmb2LJIJ2fopuXI/5yY7PAJAA?=
 =?us-ascii?Q?FyoXOATuzruDZgSzfFQ1W6wdsXKrQCDv+76qAOwqdrrFQCtil13DhkO+zmyt?=
 =?us-ascii?Q?J1KW08n77zv1j6xLmj3+xey0dCn2BMNzLqi8dkorSA2fU0/r+qxY1+FPZYmR?=
 =?us-ascii?Q?helr2VItqDoHQYI6Rl3WN1ROnW48yqSCeuA5zdVXLo67DWr8Cwg/PuMEDdc8?=
 =?us-ascii?Q?L7zjglXl4/DzqytnaDq9aHkw0yJIHdj9N0LHBt0BciUcovzGxWCFmvJpMF3e?=
 =?us-ascii?Q?IVx/eVoRa3vfKXACPnME6teJG/K2AaFZVWEdeAYgvwrv0DzqgNmWmUAr9lRv?=
 =?us-ascii?Q?D47RePzAfLND6dLnFP96NxgaYodlB3+FPvPQjDvjrIvljW9nRjKMWF+qDz5D?=
 =?us-ascii?Q?pT4sJgAgRQB9s6R3pvj9Bz6L8rR0JvYzx11vbCF4P5d18pGf/Kv9AhVcvKbh?=
 =?us-ascii?Q?O+DOLazXTGDpR9uERuei7gsjzTUKc88SdGdr9revAxJmT/MYYkDBo4OxhO9h?=
 =?us-ascii?Q?o/7ZyCsPIliTFZR7qRl6+qsuifTMrgoGWccIOARhhN1oRhX2wzEIzLk6rURQ?=
 =?us-ascii?Q?fy0Fo50R62mM3ReC3Sxtdv3nhr22Mk46cnooZfWZ1L1CQp0JVT7RGAVIuXnd?=
 =?us-ascii?Q?1BEuYQy8YyNpRHecdytxaxTrpmyxzA86bQ3vidWvZpQ6zXmQ/MtKnl9sm8A+?=
 =?us-ascii?Q?25gQi1SFhkbCqtjWCoDPWV8/+zl2nVnaTbNW+Us91E06QzbyESUavXv0gm4V?=
 =?us-ascii?Q?CmQDuunWcZcLohCuY9rztECrERIdMmYZqJZcRRFvmzcogrgw5uDqcUmDnxZV?=
 =?us-ascii?Q?25c7ZKw2nRc4YZJzmyeqmMSX3QpQmWrpe4FcwXfvyr2dJkm9txdYFu5nt0uO?=
 =?us-ascii?Q?qPm8M926IV1M8KRu167NaFgJktbNElMq0szfhdKYswGqAzXtcx00LEoM/na0?=
 =?us-ascii?Q?PCW0kT8zG/izBhxt67zlbCnjUq4YfWVIUYS4/iwzDTr0a0RH3fKVTAm1eOF+?=
 =?us-ascii?Q?kyEY3awQrEOIDPIjLuHlACBehE1z05y4HMbpY1pM8GtADPX8/Uoa6KOom3PK?=
 =?us-ascii?Q?YpoiRnOX8u6eSeB4Wz0DfNQXF7224vn4DZ2wT5wuaUomq7x6BWBkw6InJlKr?=
 =?us-ascii?Q?TO0AUTDBkc8oGOZvkZ2n/2CyaAhuchwroBjuB8BuSb5t/9Px0k7Fc7oJHrGw?=
 =?us-ascii?Q?83FZmSfoviR3T36oipEjTBFZBMhvVZiOS4aIlprEnE5vGPgxZ4KjlmZskDKN?=
 =?us-ascii?Q?FGWaBeyFMOvythDkcs+tINXhoUtPrpjy8xrbdMC2Jyf7u3n46zH2L32f5BRo?=
 =?us-ascii?Q?jQrPwQk4h1g6nISeFtyRLtBcqObMEkL3Sx2jbnOGrmWU4lN/s1ytjRgT3OVb?=
 =?us-ascii?Q?B1sHLLeAh2ckKovbani7hGaz5sb6Z2INByXd53WiRCmdScbkf7Lea2otG4Yt?=
 =?us-ascii?Q?GVN+m6hJEYVYxAAmQdKpA5x9ztnI7G5Z0XYhAeJrh1jgAWAaHzzOZCHblDaN?=
 =?us-ascii?Q?QqHLJ+cJplleHOsMFR/IyRdho/4upzE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d99349b-ddef-4ab9-cc73-08da149362c8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:27:27.7201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5YHY5xBcWXUYS+PWH1b5cEQDdeYewrOCvPgyzJNLAGSjuj4MN4HFhXwhO3+uzd0qIeEaLsThSwywFb2w93P2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-GUID: 3E6KGHL4AueeftTFDsdoaLDI-j3srjg4
X-Proofpoint-ORIG-GUID: 3E6KGHL4AueeftTFDsdoaLDI-j3srjg4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 42c498c18a94eed79896c50871889af52fa0822e upstream

When a user copy fails in one of the helpers of iomap_dio_rw, fail with
-EFAULT instead of returning 0.  This matches what iomap_dio_bio_actor
returns when it gets an -EFAULT from bio_iov_iter_get_pages.  With these
changes, iomap_dio_actor now consistently fails with -EFAULT when a user
page cannot be faulted in.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/iomap/direct-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 4ecd255e0511..a2a368e824c0 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -371,6 +371,8 @@ static loff_t iomap_dio_hole_iter(const struct iomap_iter *iter,
 	loff_t length = iov_iter_zero(iomap_length(iter), dio->submit.iter);
 
 	dio->size += length;
+	if (!length)
+		return -EFAULT;
 	return length;
 }
 
@@ -402,6 +404,8 @@ static loff_t iomap_dio_inline_iter(const struct iomap_iter *iomi,
 		copied = copy_to_iter(inline_data, length, iter);
 	}
 	dio->size += copied;
+	if (!copied)
+		return -EFAULT;
 	return copied;
 }
 
-- 
2.33.1

