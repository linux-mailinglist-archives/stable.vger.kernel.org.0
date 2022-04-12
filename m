Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1866A4FCECB
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbiDLFTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345584AbiDLFT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:19:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEA434663;
        Mon, 11 Apr 2022 22:17:13 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C1kKno012649;
        Tue, 12 Apr 2022 05:17:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=9uzLC0RNS5lLuWjzCZuI4dVyBqgt1uGnSMgLjZYLMFE=;
 b=wFb7yn0UElD5ZwXtq53ZMcrHZz+UjSVIqt0gx9tSaQtiDyGvv7rM7hlAQBEmRqhdBPP8
 KBwaArtDnGHn/Ri/+Ij/oovAR8YwTcObpDZFmhxSmCgYSLgPPHCQ2z0TR8LI9pig6+uT
 aLdMpmWwnCoeIX6g1YrbAE7E9iRYlr8oiqO/0lbI8HkZfEonjZtcT3pfTx7/n9WQ8gLC
 X2BQ0GAkYIkgTubdAeLsZEQxL3/sKXYFeFIbh+zUWBB9Se0sXOJGxBAkSW+ATrWE44lx
 EldYz1GO1Pv/gr9IdzXgqqCM/HHsnFRqVVRqRsi1vhvt9pcKlDvGl0pPEuVJmIoYVmOt 5Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb2ptwnte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5BJs1023480;
        Tue, 12 Apr 2022 05:17:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2snv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJNAYkPLNqZmw0d6Iyby2wfnjE6cAkGMRLqKINGrzKhPD26gqJtP8XBZbAvpOiY55U85IbE3iCtnnb5UEPmq2mJBv0d1fx1GdlvGz+NNXV2JEo0R7uyiHx4TiOAyIk16qjQYQKIfQ+PEMd3c06frfO0yKywTR84Ko0rHxQcAeVkSMz160TiERjSig+QW1AJe9u6/no2j7J7YQ8cit+EUK1PzWYlKz5jGzxHaeJLOc+kJFu3clwy4sX4anT6HcZw/wZz0yBWVVvHnD59ADr/IhNM+qqpzs6gtpvcf80/yQLrYfvTYQLMRrPBHJZwGZAaOg6BSyAIyxIaXwgUEpADkDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9uzLC0RNS5lLuWjzCZuI4dVyBqgt1uGnSMgLjZYLMFE=;
 b=j4uYljw5WiqRg5NDjy7oNfli6sC/deLmxSJi+y0ptDcrSjJ10bs1wW9J0QmwgSOfVzaYSw424g+DKff26BCbG5f1HVjICpn0cYQAAyqWoYnd0WOAwQMLyXTGL79I6h53ENyj+V/dHvIwA5IaS4wsNqDCOUPOfVlO3VNrkg1Zulu/ECBUxkcES8k7Yl0O6mNneWD4aEL1TIhgNfylqas3xkxkfibYmSZKCCOImZR6k/JLwKjXvhWiZip5A+h7wQkdsg7KLKxwcY5wOaNL18zBMNIgyYQBB6W0Zoesnh5wOaTwblKsokALT7tgL5qoNXgzlkW1rzjPqD0sCcY8C8X7EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uzLC0RNS5lLuWjzCZuI4dVyBqgt1uGnSMgLjZYLMFE=;
 b=n2bnVycLfHQwWJuKQMW+7rUnVgTr1l6hhJ06iqoc+JPaoSwlAnjrCMfnv4rELpIHSpMg6vBHCu4PBR/kp8i19cLtDwqU+hJnBFV19yJnM4fO0ET5JPkmrjHVNgMg4ZkLm/PAIpn9Udnv1P+mvtqVK3d/fhbUeWm3IffyWg34kWM=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:17:08 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:17:08 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 13/18 stable-5.15.y] iov_iter: Introduce nofault flag to disable page faults
Date:   Tue, 12 Apr 2022 13:15:10 +0800
Message-Id: <dc59caee83d32911f719151b41d9fe2688cc0719.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0241.apcprd06.prod.outlook.com
 (2603:1096:4:ac::25) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1da42e34-7a81-45b8-ea2c-08da1c43b0d9
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3329CB8A054AA23F7EBA4CC4E5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nRDBMsBDX5Az7ad2U6kR4FO3zRvrGOSxXkP/8UsdU71mq66/Picdz6r60ONfnDxGwAhF8vH/TqWDNEUhszGb77ysojgpfrAyan5mnXGDSxp6cclumeZmN7OMzzVMPJLl+zGZbt6eFRMWhOKTORKXy+7MHdaJwvzxcGDGPTXqn3lMtbpuwfoJhUSXAakaQeqRNbHBQLhhWBMtDZ04PeUNPkIcp/nQs0Rxm0P+nNdZo+MCCuuIhowKwLrrNvWdja7eb5bxtpFYv2w/bpfJGDSgLYX9YQugWCu7HzUjrMS3wX8m/UMWVgnI+dJzD8hQCwZgkqZb5BaDgYWHZIVM31/yEnsJhboITzOMVl9a5zNe2aSwX1VxHJ0vGf/laBL5oHa+IhZum/unsB6Ipz61QvJ0XvhKXn8F91rHEWENa1Th7w83hwWy0tWE3famPH7+spiNobT3a5d9ecwFlyusn9sxYHcgBedmUhd/5huq0CTKdRBImdkgS6T/eZ4t71gJSs6K0c5KKdjSB/GPduToI+zySQmPeth4mmo4V0LTgHIBfV4RpIShdPlcWoQWmJnbaMHBRq2s3IJetofoyJWKSvVso3s50NgrPy3EZqsD3EHPJsLlh0WxRsZJuKkxAmIbEyh+L6h3U2++6Hpka4O2INifiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(6666004)(5660300002)(107886003)(2616005)(83380400001)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3/Zt0uhgUuKFbDWoPK+83p5c70wqSui74buM/95aRAngDs7DcXsGvILJA9ur?=
 =?us-ascii?Q?NVNO+5Od5QCMJx6G4387341+xVgD5vKgPSnd4vuqIXPnJrE0G+rqaHMXepo0?=
 =?us-ascii?Q?V/1R+itmohPzNMjFa+wMJra2kGs9L/9dpD5CBiGzUuStsiT+2WHnYEtrDa1X?=
 =?us-ascii?Q?E2lEgwaKqbJlfuJQjYjMoC636j80YagqNr9BNPchWb99gI6jrlv/K9Sb+8gl?=
 =?us-ascii?Q?xJQv3mM1Zp9RdEfi+0zhGgUH6Az1oX/WiD2ZrQDqm9hKrmJo8njNm46gVw6b?=
 =?us-ascii?Q?poJBb0TVbKegQfzQ4y3eR8lQSysQ09AigSS39WMJsx99bpB6fD0Kh7BKWtuQ?=
 =?us-ascii?Q?V/3mfWC8wMP2j9wOZCdviIedJ3tLf0wQzDR2jOKAl1eMu33BZyl4YB715Aza?=
 =?us-ascii?Q?Pp0FANCycFTtjVal4bOlz663yZps/3Cs3+IFPcIJ/03tENyWSMDY+VnEuFqj?=
 =?us-ascii?Q?UQE25QwCqR0+5BkVodQV8IpiYIr9eESR4YpZH6JTberU4eJdLLfd9nf6Oi9o?=
 =?us-ascii?Q?GN/i/PCZ5Iw0MrDqVjSOx3nbg2AXSflWMGDGJAc8zcUjGjQ93tcOZC2C33W2?=
 =?us-ascii?Q?OHLOlshNlX39lnxCI/5HTBmtYhd3nHb9J88+Pq2LTl8Z00mYaqzGTF67Fqqp?=
 =?us-ascii?Q?xsE6WIv1A+fDcvrgMyATrWXoQpzJrBtOc9s+Vet59tSsBZrRTNavPQAtGTNU?=
 =?us-ascii?Q?9Pw3soAEhzWYDoWm0OEyQvsqNsoyccnU2FdfnreC1Jth8fBaW41WdnWTO79g?=
 =?us-ascii?Q?SziVvrBqGHWZD2lGbIQQsq+nGyngz41c37lb71HcnkXPHMMOE8a62HNS08Po?=
 =?us-ascii?Q?/c57VJdP/Skn0sBENm0jZMK1H6v1rJc+8AYTveLWS7xK8bcK17v8SNvRHwRg?=
 =?us-ascii?Q?NwmVzjqutDvrlSC+1JABnOFyBCldNevGlUSF8Or4ij3vzIeFm+bEQHAmfoML?=
 =?us-ascii?Q?gwMbGb/MLDhvRJkWE0F0wUXvsj/Sj4hYqpNyMjvIcEl8bbCVS6nT3w9w3LNS?=
 =?us-ascii?Q?4QEG+g/b9HvCzkLcgc8UxCpwukj7UiTjrC6B5dRUyLFjmw3xKNTESCwVc2Hq?=
 =?us-ascii?Q?QE9qxpX1bokSl0+Y9hwYyz2kHyoDZa2L3++KbGXtwkvPihBsuBE0XnhRn/K1?=
 =?us-ascii?Q?q3CvoXeq4XoX2PBA2R0hGUDgH9CQTchHKhoOyg8bFHmVnUpsjSV4p4GuiPv/?=
 =?us-ascii?Q?R3fb1v+RmKVt+Im0oQ4nEU6cYvg+t6AQLwXR3b17AuLpPpyl9BBWl2m9zK1c?=
 =?us-ascii?Q?tDQWfAfg/GmatQcAunPPSrdnPw4Tkap6duuZGzyWX7o1tZSnUseJwF3PWEst?=
 =?us-ascii?Q?P38yVM0V9O2iYhC7HXg+hEWm6wUGxV2bAMumD7J6l2JGl60XpAs+KwkZTyU7?=
 =?us-ascii?Q?RRoyGCkjSxIySmcRohb041bEBwlVtoNROilLfUGriwXnCFogHzH70Bn/YZbr?=
 =?us-ascii?Q?XAsBC6MSa+ikj1aoqJAcdU57R7lPAAV3pcOAIhlctlfGB+moxhSz0uKojFTz?=
 =?us-ascii?Q?Z7FYSNADX8iNp20Hnu4keAKbhPeXzNACAucOPetBzgPDl+8Tng3Tw/qeRcsu?=
 =?us-ascii?Q?F82WkPux26y1np6MZKragdQhdIZeFmgEOCGFR7X0Nn2IltqOKYIPTu8kQ3xx?=
 =?us-ascii?Q?TOtD7eQH0bbijXk5XmWDk9uQw5pPWDBzDzU6zE6Cmqh1oO/4U3SXQwGV3Uzf?=
 =?us-ascii?Q?6sYUL7ar6kvBUzBK9NL2tt97sULf4hQdTPGVtrl5bi6HjM8Er6GxPdvWU2IB?=
 =?us-ascii?Q?0aJe6Ji1NYoljPFE5qYveMZ7CHGITuSuSqRpFb+JDUYfz0eh0bcy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da42e34-7a81-45b8-ea2c-08da1c43b0d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:17:08.4615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHvSZ3rgRXKFS55toB3y88Vuotqfk1W2eAZpZLPqdy1/OY7xFFaY3SADdQxfES0p9rM+01tvlpPJORCHHUlBLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120023
X-Proofpoint-ORIG-GUID: JJw9xkaS53jrvKYVbE0jePH2-TxmtJWC
X-Proofpoint-GUID: JJw9xkaS53jrvKYVbE0jePH2-TxmtJWC
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

commit 3337ab08d08b1a375f88471d9c8b1cac968cb054 upstream

Introduce a new nofault flag to indicate to iov_iter_get_pages not to
fault in user pages.

This is implemented by passing the FOLL_NOFAULT flag to get_user_pages,
which causes get_user_pages to fail when it would otherwise fault in a
page. We'll use the ->nofault flag to prevent iomap_dio_rw from faulting
in pages when page faults are not allowed.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/linux/uio.h |  1 +
 lib/iov_iter.c      | 20 +++++++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 25d1c24fd829..6350354f97e9 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -35,6 +35,7 @@ struct iov_iter_state {
 
 struct iov_iter {
 	u8 iter_type;
+	bool nofault;
 	bool data_source;
 	size_t iov_offset;
 	size_t count;
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index b137da9afd7a..6d146f77601d 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -514,6 +514,7 @@ void iov_iter_init(struct iov_iter *i, unsigned int direction,
 	WARN_ON(direction & ~(READ | WRITE));
 	*i = (struct iov_iter) {
 		.iter_type = ITER_IOVEC,
+		.nofault = false,
 		.data_source = direction,
 		.iov = iov,
 		.nr_segs = nr_segs,
@@ -1529,13 +1530,17 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 		return 0;
 
 	if (likely(iter_is_iovec(i))) {
+		unsigned int gup_flags = 0;
 		unsigned long addr;
 
+		if (iov_iter_rw(i) != WRITE)
+			gup_flags |= FOLL_WRITE;
+		if (i->nofault)
+			gup_flags |= FOLL_NOFAULT;
+
 		addr = first_iovec_segment(i, &len, start, maxsize, maxpages);
 		n = DIV_ROUND_UP(len, PAGE_SIZE);
-		res = get_user_pages_fast(addr, n,
-				iov_iter_rw(i) != WRITE ?  FOLL_WRITE : 0,
-				pages);
+		res = get_user_pages_fast(addr, n, gup_flags, pages);
 		if (unlikely(res <= 0))
 			return res;
 		return (res == n ? len : res * PAGE_SIZE) - *start;
@@ -1651,15 +1656,20 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 		return 0;
 
 	if (likely(iter_is_iovec(i))) {
+		unsigned int gup_flags = 0;
 		unsigned long addr;
 
+		if (iov_iter_rw(i) != WRITE)
+			gup_flags |= FOLL_WRITE;
+		if (i->nofault)
+			gup_flags |= FOLL_NOFAULT;
+
 		addr = first_iovec_segment(i, &len, start, maxsize, ~0U);
 		n = DIV_ROUND_UP(len, PAGE_SIZE);
 		p = get_pages_array(n);
 		if (!p)
 			return -ENOMEM;
-		res = get_user_pages_fast(addr, n,
-				iov_iter_rw(i) != WRITE ?  FOLL_WRITE : 0, p);
+		res = get_user_pages_fast(addr, n, gup_flags, p);
 		if (unlikely(res <= 0)) {
 			kvfree(p);
 			*pages = NULL;
-- 
2.33.1

