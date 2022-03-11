Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD5E4D609C
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 12:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348248AbiCKLb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 06:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348241AbiCKLbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 06:31:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601FF1BA92B;
        Fri, 11 Mar 2022 03:30:53 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BAMQaZ004098;
        Fri, 11 Mar 2022 11:30:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=tq5qBKP12qa1xEBLrPEOAt0ZMKim5AtL1JadHMsSPNE=;
 b=qDBkb9iRSvYgeJCE9DdCm7BCrUmE1yApRex/GL5NqNhk6E8266X1Jm3uCvVx6mXbX43A
 pfvPX16X9MdI6qjJqG5xK7hQQQ2ueEA5g540yYLuaqzYug4JdVj7lT0BiODAJ2ST8azo
 +uYe2Mii+aQash3hybprveiU0Twal8GP3Yijb1sOKs20i2HstxRQ/tdFFJgtKvDUhJ/g
 RzHeYJgH+pH5oh1AvBgz+7g5IpZT22i4IyQd9Li5M1c3aQJ14ppJ1BRCQCakb9Rg5vpZ
 UNuzptETGldpcSWiW9BFa3AHyqxauXdTNV087L9ZLGUbcfPTOmNX2CJ8h8C8+WAAcINI CA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3em0du8sac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 11:30:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BBHL3S192676;
        Fri, 11 Mar 2022 11:30:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3020.oracle.com with ESMTP id 3envvp36u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 11:30:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9PpHPYRkK0BCdBZEtFiHf/W0v5d3mFy3Sl4RRW/rOilNJpavLxIo0X+Fr84a5atjS3PKTNT9R0RDnGLpWxP8OOQA7PjwmhyDNK2D9QUh4VdgV8/oB8DDkg98THPytzO++FukbTl+mGkVALM2H8d2KnEKdueYXIAs8gWZgJl636dM2lwke3cBDg0w5WK9L7OJxYuygGwstAZR7flocNG3cOec43ylaHYuCZv4lh5/YKF576Fj8dE7Cy9/bqqLbRE6Rk+41qvp0+YNISW2dMpKgjXmRH8LnB4xZOgRsYUNilixKs4NdNzL8Bq32iw7VINfa3n0HmSnTxnX1hJkMTxZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tq5qBKP12qa1xEBLrPEOAt0ZMKim5AtL1JadHMsSPNE=;
 b=VP7WUmuVq3oVbps6zJsQCLAGzG8dfepyM9gHbgcpf3aLRtGddlEToxF4UTG4By7eA31J86+nVl4xeTsnZ1KxCJhYzRJlmbqXU/syfRrbSPQ7EVvLl8VPFkzd7+5ZWATv9lTXT7yiu+D4UCg5Ui1mO9gkGvIlUiHofsEZEd35suA8WntEVq9fuHsOjon4CMVeUB6CpvzNQg2BTqq5exN4w39mnEIEOV08ccxSYtZUUUAmECsIaCyYQFNsWr/69pGfbRFjwKTzHhobCsPPCzKordlU6y+oN+Wpsk4voGQGUafVCASjSw6nN3ky18iBY8E+8P8xBn660UxBKsW2Dgdbag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tq5qBKP12qa1xEBLrPEOAt0ZMKim5AtL1JadHMsSPNE=;
 b=oEFwGcMyemYffNFhGh97CSy/h9G6ZovDvdH+/IhdvUz8E1RXSCAMOAvKYAkdL7aX2TT/X2eo0bwwo4cZx5PPkmBXG7qbiYurGvVfC4mu2UqGf5QULHEPbc32cIn74JS8LsK6h4wTuq3P9gRLJj+IEc+Z5uSLdqGt3yAyLwyt+4E=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by CY4PR10MB1430.namprd10.prod.outlook.com (2603:10b6:903:26::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Fri, 11 Mar
 2022 11:30:19 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::b9d4:8912:7bf8:14fb]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::b9d4:8912:7bf8:14fb%9]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 11:30:19 +0000
From:   Liam Merwick <liam.merwick@oracle.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, bp@alien8.de, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, krish.sadhukhan@oracle.com,
        liam.merwick@oracle.com
Subject: [PATCH 5.4 4/4] KVM: SVM: Don't flush cache if hardware enforces cache coherency across encryption domains
Date:   Fri, 11 Mar 2022 11:29:27 +0000
Message-Id: <20220311112927.8400-5-liam.merwick@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220311112927.8400-1-liam.merwick@oracle.com>
References: <20220311112927.8400-1-liam.merwick@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0088.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::7) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b20373c-d8ee-4083-38f1-08da035285fa
X-MS-TrafficTypeDiagnostic: CY4PR10MB1430:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1430079143A72B698A9AA051E80C9@CY4PR10MB1430.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k6aFsiJpAl2LawNZ57UGZomszPt7+2b16MCZ7xTB4LmgUykIi5ILA6XBh26Ojtzff7uSy6suCCjOeZtTEUr21898yHHRoHGcmgNYQzSUKfwX7l0uyNFxS1vXHR69GBonBO3Nyv2WVvYdb9ilvCXAxX3jlpy72+qs8BQg4f0LPquRJm9q2AhAW/r/DBpt+Vgo9xzOQkt2WxDfcI5uE/x/EhzsuoHDqVwij7GX07Gw/NSj0oBSF0Y488ohiQBLDpKb/ewIwINYvehjbuBfKatFyIsB87pvMgYWD2EjYZoopwFmBkkTIJz/d6PYnUifn52rloshqLolOe1uBkn/1vT8CaSJ9v+2hk8p6uHybFD2KmOPl+xaRGeXmO+b0qHeKUC9J+BXBbRC4vXESg0AgBmKL9HgxoNSFL0hs9QsRPMGP39//Tx87drJBuub4Gorey+b29N0XRTE6A6QF/+PdLQbswxfthsrJR6xB6JQWiGUjFcxpAO94/zzq8onJLnmkZXVTxJFpTUvL7/jN7v9+3QZrvTr28z9VTrz5LE3/ui4FL8n7OzOE8lHGYW7a9gzQ5DpQPIktUE3kLBNGWiXYUVqyU6SmlhPZCfUU5Dj6A1i7Ukz2oVUPb49zULYjcdMhqJhL/bRhS6HyBNGqBiPpjXSABJWOLPwOvV5ly76hksfFw4HCS8Z+nFroAhC6L14DqRDrFy/IzYt7tapXwDr4KJKd5vkhYz9CHlR+3Y+krnfCjJkaIl16DaBfTxtCDfAlGfnQMzU80x0tgI5xIhkodw1dcqRuyvmw8YvctGH6CEfVkc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(8936002)(4326008)(6666004)(5660300002)(8676002)(66556008)(66476007)(66946007)(508600001)(44832011)(316002)(52116002)(6512007)(6506007)(38350700002)(966005)(6486002)(107886003)(86362001)(1076003)(186003)(26005)(2616005)(36756003)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7gI9y8phHMD+jGmnS9v0KhU84FmuEnqtMEu4lP44UOP/AcYgPbFmNAXR4ytZ?=
 =?us-ascii?Q?+ahkGOwfuY/+aFjPNysF0em3civw18L/6gUS+GL1pkMZCvH/TUhZS8txKMBp?=
 =?us-ascii?Q?Ebv6bJsmXO8RMq8B3w0R33lsUw7tWDTm1YZ8z4zV4imhot53P3vO+2+wjim3?=
 =?us-ascii?Q?kHDjyUau7Rj/C29kDdU9fUdPmDrqd1h450ZJj5EQf1Oek3rm/lDVO5Qt3WaA?=
 =?us-ascii?Q?mYKrb9r6YcqnClTGwcHvcDES2nmp28jjC3gJXKR5QeFb15xSDGjTeADcnUzo?=
 =?us-ascii?Q?5tt1Jn7e2VO88EHV9eSSrEfzpjzzkeE/S02Nsp/d85uo382r0fU3FL7KxIqB?=
 =?us-ascii?Q?XLVvcv6iQntBJC78otzV3zl/Klrzz9zNuUYKiVfkhprZtLEYeOxAKTd4r1oP?=
 =?us-ascii?Q?sAe97alZCyw1L4NvooW22tSfiJteLIPytZQGqp3j7yOc+060thTtQwYMREFT?=
 =?us-ascii?Q?bQE95aozSpBNTTQXlmkuP+/W7W2MFl6mvt81PfBPQ9dugViLEcjpiV5VIQHN?=
 =?us-ascii?Q?37n6LhIUDmv/cVOQ2NTeaxf/8tqb6h0ADB8AJkpzT5emSNGygjhhcXSOc528?=
 =?us-ascii?Q?uFXO8emFLJeHFe04iWEBshA203EUM15aikcEr3uCAPZk9kNcbeCmEHQMCTDN?=
 =?us-ascii?Q?21ZhQTI5bgtVWhFtturvZfvz0aBaR1TVfKdQlILZ1TmJYRuIwaPlDv1gvBz0?=
 =?us-ascii?Q?CuCMXZ2u9qyrleG7r2W9P6zxFl0IAndTw+IfDLGdLvZO5MUpGjUHeMw4J3HO?=
 =?us-ascii?Q?dLKp/gzs3pXH3WDPoqD2uP4yOwcf3Uje2sg7J1fOVsu/6V6Bhcb+Zd3qyc+l?=
 =?us-ascii?Q?gk8+RKh7RPBGsCYAJVZJfPyctWcwf9q4Q5PbLhHH0hkpQDmo/v2//kBeMbBa?=
 =?us-ascii?Q?1MxgTqx3CK442EzmJL9eBsIXnB61RtKJClhKFR/ymXdq+Fc33cmZMlJ1NMvd?=
 =?us-ascii?Q?Dg+lAUtYFwL5ihtLvdEQKv3nfGu6FY3nzZ0aGO6pUrY51FqIK0/AgJ8mxspo?=
 =?us-ascii?Q?GAjuFsEAafmjRNOJNy7u+JOnBcanYoSswZyPxVhdy8IS/CYRwMnw+7v1flaB?=
 =?us-ascii?Q?rQBnhTLRUVE+DQdFd6FZDM5bUmNKINxqdFI/vnz3x5MYgK5Zql2M7Od04ohT?=
 =?us-ascii?Q?a5+Yf0E1ErjFxWLiVSv9KUjZT+BUF+E+2+otkb0krjIPAXg3+xpldRhOT9XP?=
 =?us-ascii?Q?bSXHar5MMjWc6QEPWSlouiXX4A+3uin3+/ApNOXYg8QRFOU1GWUjnokHelQN?=
 =?us-ascii?Q?cYYB5jgVdptGJbAxIEyeN6OZLgs6fHtSOvbD4azKEYAAEgBCiNS+5vxYtXA6?=
 =?us-ascii?Q?3mbxbLY6G4T/HGyqwN5lrtK5e+/m9eQNbL3RbfcKvicuSj4H/WDLO/0N1lYO?=
 =?us-ascii?Q?UDpKWPKN2Z6Lrquf0kgGvMAftPDqmqPpJ/Ny7etvb0wQpkHaN1oQ53p8jufF?=
 =?us-ascii?Q?lAoPrBz2KBjNcRqC4PpME996UcMst/eC3xjWhgUgnovo4sOXIVwi1luJPprL?=
 =?us-ascii?Q?olSlRLxqNS4YbNQtDYaFVm1/xcrttrTsky+Z4bC4oZMRtqWpq55zb4YBnbFU?=
 =?us-ascii?Q?n3O9fhr63yqGJyEePRz4XbbgAvZXS6DwBZIxFR+moac6FkW52yEMxnAVAcvQ?=
 =?us-ascii?Q?4sxk5s/d3qSbLZx0Jjg4TmA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b20373c-d8ee-4083-38f1-08da035285fa
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 11:30:19.8047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rV1Z1loqvLcA9JrBKPMN8RBi45ya+ctWeyXmARNfA3ro9i1iaBtfcqJgvEqxgy9ybTbaoYRkc4vPjTE4qGgl8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1430
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203110055
X-Proofpoint-ORIG-GUID: f5VO2VnAsKEXHoIqy-vdF6E1xC-IwR7x
X-Proofpoint-GUID: f5VO2VnAsKEXHoIqy-vdF6E1xC-IwR7x
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krish Sadhukhan <krish.sadhukhan@oracle.com>

commit e1ebb2b49048c4767cfa0d8466f9c701e549fa5e upstream.

In some hardware implementations, coherency between the encrypted and
unencrypted mappings of the same physical page in a VM is enforced. In
such a system, it is not required for software to flush the VM's page
from all CPU caches in the system prior to changing the value of the
C-bit for the page.

So check that bit before flushing the cache.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lkml.kernel.org/r/20200917212038.5090-4-krish.sadhukhan@oracle.com
Signed-off-by: Liam Merwick <liam.merwick@oracle.com>

Conflicts:
	arch/x86/kvm/svm/sev.c
[ The linux-5.4.y stable branch does not have the Linux 5.7 refactoring commit
  eaf78265a4ab ("KVM: SVM: Move SEV code to separate file") so the
  change was manually applied to sev_clflush_pages() in arch/x86/kvm/svm.c. ]
---
 arch/x86/kvm/svm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2f84509f2828..125970286f28 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1904,7 +1904,8 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 	uint8_t *page_virtual;
 	unsigned long i;
 
-	if (npages == 0 || pages == NULL)
+	if (this_cpu_has(X86_FEATURE_SME_COHERENT) || npages == 0 ||
+	    pages == NULL)
 		return;
 
 	for (i = 0; i < npages; i++) {
-- 
2.27.0

