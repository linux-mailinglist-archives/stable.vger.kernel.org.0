Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D6A45E866
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 08:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352760AbhKZHWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 02:22:30 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47886 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359242AbhKZHUa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 02:20:30 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AQ56qjf022233;
        Fri, 26 Nov 2021 07:17:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=JDqflm2pqipBNvKnDOttMIF8pdjFIbcK1w4aajwL1KI=;
 b=aaaijbg8i2NK8E+6IKlndsJeqm/CafslHYviUoFEjozKxbupBe1PnjzAXI2z0MwfZ4hP
 4Z7N2M4954vGUZYT3kXQoOUbWdoDS9TmqxF1u7eQ4cWJJzwKs07wWBsUGZGETOoQRLJA
 +Gk9Xoa4Fjpy1y4VdivlaFNPhK7zkRE3hMOAFEpSq4e/rh3smS3qoDrdL3T+QPdrIlja
 LMmRj7BCo4kjYmUUlcf0B6P+LnkMzycb8g8VN/bjeOfkRmPyBO9MVxKn2PDbaNCcMMp2
 PcJT4vUAS0Wvm+aJet+4gpRK/ywO10F4+LJj5hOobQH23WREEZTZwlFbe4GnmcqxdAFk Tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3chpef10j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Nov 2021 07:17:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AQ7BVfp115720;
        Fri, 26 Nov 2021 07:17:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3020.oracle.com with ESMTP id 3chtx93n8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Nov 2021 07:17:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6Oh1DYS889G7/datr9GrWrFLs5S2ZqFpTKGZ8DuWp+ucLVhX70exkwxpzfqFEwQ3zXeCQheuudDraWBmWk+3FrmhKbNKHo0gj4NBSL2aN+FwoOj6SaavGvJPYREu1rONoKw3P/a3Fw6q1bHuMvy3I3o23yTeqhK9bMqQXpfuWo9LTuyC1we5nkSsoE5AXKaqtf/3TsefjMyvyErKvlSq0SdsSJZHmcPH66jzq1+3DiGgGbJVUj32pp5j1gaYqpGqHW1hKfqn/IYZ4aUyviV/UZiZ5DJxZ7BLcYSR9YCbZvxfj2K7RunTedZafknpCe4nMnlDB7E2E2ZB5kZsJ5zhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JDqflm2pqipBNvKnDOttMIF8pdjFIbcK1w4aajwL1KI=;
 b=gj4ywABqZscR9m44RWiD4FhRAO9CqVFAUkLgTDYH6FtBsrQWi/yHSwIgiJhlt37e7UvwSOI8u3JpK3UbWuPKRFDzNHY7nNQQVGFXNtbKROnvUN4caR/R/pG6IDKNMW6Bc34Xk+LtYxIHr074ozeuH883QdLLrTpAfE+GEVQgNl0NlQMLX129AktgdtjWE3BhGXDkAXHgVE/wSEkGZ2APoE2mseJh6+l5a0m7WOeUYlBikgi9mC7MCJ3jLURUzR6Tb8cdKsN1POjOrj/mjSgA6bObe/x0CpYBoFNYl5dHIZcOVEBpk1vWLUZbFgy2INYBY7tzpwXllIXXdlmbvp/a1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDqflm2pqipBNvKnDOttMIF8pdjFIbcK1w4aajwL1KI=;
 b=DT7uT738d3wGA7SzhY3Sii05TCgq3AG3xjjBa5twJFg440j9fdlLxkYrM+jLfFuThw1Uy02/37atuIlodWfc59BxfVw2xet0kM8Suf8KK2NzKCd+NS6mQEYkILCqlAgOE6SD+xCxDNQo9HfoMwNi+AiHfEIMkJ+AI7ojvQdYlnc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1824.namprd10.prod.outlook.com
 (2603:10b6:300:10a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Fri, 26 Nov
 2021 07:17:06 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 07:17:06 +0000
Date:   Fri, 26 Nov 2021 10:16:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     devel@driverdev.osuosl.org, riandrews@android.com,
        stable@vger.kernel.org, arve@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <20211126071641.GO6514@kadam>
References: <20211125142004.686650-1-lee.jones@linaro.org>
 <20211125145004.GN6514@kadam>
 <YZ+muS7vC5iNs/kq@google.com>
 <20211125151822.GJ18178@kadam>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125151822.GJ18178@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0035.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::19)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0035.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21 via Frontend Transport; Fri, 26 Nov 2021 07:16:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c0084e0-d386-4dcd-573a-08d9b0acc06b
X-MS-TrafficTypeDiagnostic: MWHPR10MB1824:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1824E1868A64EF4FB8C708838E639@MWHPR10MB1824.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sOExFVqkY6JbDs4d/aOexeLCRq6JSpaeySxTaqIni4Z5Nnubm3pLXAe0+h1wy5SeKluGWIDnmbIqSQ2Dr9vkGKcqFIF9Rd/fVRwOyvyuyBsd8QFJhaR9i7dOJkScXvFe6n+B5qoYBSUr/9OkSSxZ6S8L1/qtJfKugXQ9RC+CZzR3xpYBJ/o6hCY8cM1FBaOSxwFqk1DFgGi4nF0Qg0Ce7CD2JyLEl382FQf0rX083kK1awNd8tl0QPF+ytFNHLSvcaq4Fgr5ZqqUQeE6pMm23QuVczJ9uTMQqY4I8nBB/bLDuYM3D+pMjeD1Fi60G3pRKFEWP7hy4K4LE9OpO4H1hb0SM/gJgpBfBX0f5Rj6s3FWxRoExcq4KMbcFEg3UrM+fnIsZqC0EGEX5/zjICZRBIw9YYTxw0lU1mEYi9VUR5W7MnZrjTaF+8xL6NUlMeXAgIfqpbxCzIAHDPM3n/xSeP1Lt94GzX5MHU/fjtegYnmmaZqXwMBScdd9VZx8kpBq7witOAn6qSOLvV4FRXYAUSJyZoYBW4tDqprifrlN6CTycncYPksWPtytnuRnV9XerhUrcLqNxksVWxMbMEwKCXhNSXRkquePWWALp0AzJh7cvCvhIWwJt+6Xz9lenlWFV7K+BeLUHwoD2lTU77exWHt+eOVkceaG8vxox720Eye7LIHvIHCSUZAJzLNY61z4PvlXm557Hnk2eWg3PV9r5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(9576002)(186003)(9686003)(6666004)(8676002)(1076003)(5660300002)(316002)(8936002)(6916009)(2906002)(4326008)(33716001)(44832011)(86362001)(6496006)(66556008)(66476007)(38350700002)(38100700002)(55016003)(508600001)(26005)(52116002)(33656002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?in+ItrshQWAoSpzTVMDJ9WT81pX4J6kCWLu9bkQ2+K9dUM2qK+r6Od1l8tBL?=
 =?us-ascii?Q?keL97TN5gkozCB74Y9IdwGzDaQCayCkxkmdSzOzYWgIgiZlyQPD8jdzogeaU?=
 =?us-ascii?Q?Ox0ZHrvWunepdegny9qDj17hsoXjA/cnTX4SHcnj0FE72e0k8ZeMuuIrqv57?=
 =?us-ascii?Q?brBj9E7ZBQOXXw3hX4RxZVJtjmyfym5O3vk2wYhw7FR/rvoe55wfNuhCP+9V?=
 =?us-ascii?Q?4FIbR4FJTJlxxcPsGjrOCKG3toMsTOULdUpgFTPHdiOXgGTxqAlNd9yWHxHT?=
 =?us-ascii?Q?9qkkXfhQ006mjbJzBzytqNbCKsCljR0zPE5ut/vIB66Rw3Zyf7ZOEtLpA4fC?=
 =?us-ascii?Q?I0pfOFj9ZCOjvolZdGmpUHohfKNRCk3LnnRyqJzkSNO47z/pO1XNZIWuMMHJ?=
 =?us-ascii?Q?8UKirjU0/EmkCc8dK/N7TRTBCQLlPw9eZJ/WUoj8Scm9OE+a/Fyp4wrkKW1F?=
 =?us-ascii?Q?SK2yFh8C16Y3dl02FcrhNMJYpNyoO5uB+mv+VZBufcGbcjKEvq1D91X9q+z5?=
 =?us-ascii?Q?jocxO0pQxkPkJr6FtkD07r6tbjgImeTo1Jv3l5P5xmX7K1U617ImRlWCRkyT?=
 =?us-ascii?Q?zMGw5T7fUbeL1k6lRmCevtY645fyKR9yeJtKiotgdaHf1sPYH93JI9Nr+ULT?=
 =?us-ascii?Q?01xkiOzQbN2DKq99AOOnKKYS32wZMvq0zg3epZ1jXaLMqr5Eu0avDA4MTDjD?=
 =?us-ascii?Q?D4q6/4IP8myaU6pxXVXv2Z/fpfdwAkNXrlJ+cYY7phonLu6nPhwI0ug2b39z?=
 =?us-ascii?Q?PTjQcKp5IojozknXdojummTZ398KalAtko7SUZf9lr9c1mxnmmYbNTxsookD?=
 =?us-ascii?Q?y33kXmoBVMJs8CL6+30YVlPCxmWbZvD/PIQkvG0hkxFriB0HNSOH33dITTal?=
 =?us-ascii?Q?ZKXoDp/azhU9np/HqQWBCtctkknJP0fS7bjhWK/UAtnK+6pNJxNOyVAFRKnc?=
 =?us-ascii?Q?4I8pJDPTm+uM+I98efEMZEWfA/rxUEEMJLl7Dx/oQyexYywEo6uv88hSZ+px?=
 =?us-ascii?Q?ojUx3L/gGa0BvoyZSeeX2lSfrYkYbfGtMMQ2UPylBTWnbIFuR7cf0GF+Z7je?=
 =?us-ascii?Q?TQpf5I4Qg6jHug8Qaz8toBjy/LXcwjBEW/PVsLx5sYt/5ZXXlBE6nwYqYca7?=
 =?us-ascii?Q?zOaU3NMqinRekGVgdzBFLoEbZaafmBsEhc6VXbhgGA1WiBM9zKd+qCoDtfSd?=
 =?us-ascii?Q?7c2wanlHmVHmDeqeXgEJn4VESFtYfgpadwatbo27bWEiseoEkeAVnHEbCKFv?=
 =?us-ascii?Q?BncykbRUftx/QeQSFcNyraH+BzewARXjAQ20+LuYGkRbkMO7E8tlW0o0Prri?=
 =?us-ascii?Q?ZWhhaMCyFa8+v+1v2qRR0wDy0vn6Mhn20elWiqmaGu1oZZD0Yh1hAam0f4nK?=
 =?us-ascii?Q?sv7WevIeIKpG0zUHy6Pew9urXNISIs0IeU3tZfbkEt743FGBuwI4HgB+KgOS?=
 =?us-ascii?Q?BqJ/cBjdwMBgUt5c5MwlAsFhSuixDEegCD++iu6Fo9FjELhoFZiTk6h4GqqD?=
 =?us-ascii?Q?2+OWfaY612j473rCD+TQ3fJMytIqiEgX4oQyTGQQFhTMkGpqooyVu0A+Dwe+?=
 =?us-ascii?Q?IsIBbdtG9+GFzVgqhK2+SdjzD4IdlQdN9fq4l5L99V8LlLCQNBHgEb52zp2w?=
 =?us-ascii?Q?4J0Cx0vURK0UHczfGP/GtVcjEgoti87T/RuEZibz7IlXrMerpdu8+lFya7Sb?=
 =?us-ascii?Q?8PxHpmK89x6/S7YqQiQ6SNx5xJQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0084e0-d386-4dcd-573a-08d9b0acc06b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 07:17:06.1008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H626ALXYNIsUMDU8vk6cYVlcN5/SaMGjEiGhXa4G3B0WKVNiftZLOx91fU2laWvJzIwXaOC0wtasUgkxMBiST67XxVT6vyWAh+LDD/0nwpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1824
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10179 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111260041
X-Proofpoint-GUID: _BFSuGDG57hwch7DTXQY7pf_6EYgtvmy
X-Proofpoint-ORIG-GUID: _BFSuGDG57hwch7DTXQY7pf_6EYgtvmy
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 06:18:22PM +0300, Dan Carpenter wrote:
> I had thought that ->kmap_cnt was a regular int and not an unsigned
> int, but I would have to pull a stable tree to see where I misread the
> code.

I was looking at (struct ion_buffer)->kmap_cnt but this is
(struct ion_handle)->kmap_cnt.  I'm not sure how those are related but
it makes me nervous that one can go higher than the other.  Also both
probably need overflow protection.

So I guess I would just do something like:

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 806e9b30b9dc8..e8846279b33b5 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -489,6 +489,8 @@ static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
 	void *vaddr;
 
 	if (buffer->kmap_cnt) {
+		if (buffer->kmap_cnt == INT_MAX)
+			return ERR_PTR(-EOVERFLOW);
 		buffer->kmap_cnt++;
 		return buffer->vaddr;
 	}
@@ -509,6 +511,8 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
 	void *vaddr;
 
 	if (handle->kmap_cnt) {
+		if (handle->kmap_cnt == INT_MAX)
+			return ERR_PTR(-EOVERFLOW);
 		handle->kmap_cnt++;
 		return buffer->vaddr;
 	}
