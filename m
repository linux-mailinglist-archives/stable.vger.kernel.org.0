Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9044F45DCBA
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 15:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351085AbhKYOzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 09:55:46 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:62858 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349313AbhKYOxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 09:53:45 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1APDTOpx001227;
        Thu, 25 Nov 2021 14:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=EellO5LL9h2URAQRE7ZkwLUli1y2Z7R8O0GDffwwMBo=;
 b=qn7PlEwUjbUS0jrvQoaIXXTNO9stT555UOH1T6X2YotZDSJCgxemRFTz4BB2GLUcGZ8d
 LjmlRmmvDhn9OwWzN0xTXJ7tALOMQkUkqslw0E3xewd2rRqQdlFo4XJO9TuybiF1pQI4
 7823MwsldF3ybicSqw20CzeZp8GTk3pcwWBfwjM8tOyvP1RkvnNxM22l6Cy99lO9Wy1Y
 zzBW/ZdolgrS8rI5VYdluVO+rBHl0YDQLI1fEEb2c2bwyISWEmbcp/uZnIQyreNdCkmC
 X5KdXGzZAAJKbLfV0M3E4RZTb2A7r08Uj7zZozFoHhoj7PMM55AG03lmJQOg8N2Y+UQG vA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3chkfkfuuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Nov 2021 14:50:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1APEjJTf008772;
        Thu, 25 Nov 2021 14:50:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3030.oracle.com with ESMTP id 3ceq2hrkce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Nov 2021 14:50:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6hDlyR39Bx3gNi8Fljb936w9oEvOQewAVOKVmdpbiKgrAy/T971zoeE2kD8PazWW0u2kTXb+y3xbkHwuZBWbFtuXONDB6nNtoRBZRcrkeeJgq4ssgoU2QEUS8xDZkhbUn4y2O71k5b8nyosvx32DRozXYhLUCxoja7tmC5zFCGSqFV+M0Aw+ik74vmkxD48i+g/uDwI2AOAU1qGYA7NN/jjDuvXrT+57EfTgqtJEjUqohNIOfjzIPIP2D5eYcA6GvvLpOh/2UC9OYMzoGWOpY+uHZZ2eqJzmhhkU//Mt4ApNS1M+hWXaRILwl0SS2pdG8LUtyepMFDsRshn6p78ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EellO5LL9h2URAQRE7ZkwLUli1y2Z7R8O0GDffwwMBo=;
 b=N+ebzF1dAHozPdluWKKngLANd7r8mAS7kTg7di26G27D0zt8gAl4vvcv2oQ5z2oIqkoDB1Cyf+9CGBCJBI/BCI5Il+aoAzX+o3hybmZDyl9f54ixXI4ELo0oAiWEfFe8u0ZaeIzUXINOP4M6kvAdW9qKZ0zFzn0ACR9h/CdS7mV3Rtw7mF9l46QSAJobQm6F0WQeIgGPms9696R28yqCG66Vr8MXmrDkdVUbV1VwsVMp93GPxiPTEGcFSHRQrTQfoylM1CvYXOTqzCTEkwoXUdLabQ8ML+uTd+9K1FPSb+cINgjXCLnIL07FqOFldv8+jSAf2pt7uQDLVdG2JyCAyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EellO5LL9h2URAQRE7ZkwLUli1y2Z7R8O0GDffwwMBo=;
 b=RctvvXVIGDq+LEleo0Q1D5Ml1Oknp/IR2LUy2C75hNsnhuXinDZ63pVktUSw4HhM3W79kokPJDcyp2qk4w4B/H3DgxiPS5MX6W5RIlZwHY9tgil4IxPvR8KLof71ykvFPTaGF6vTDfUMbwlXxkCnXVK70rW14YzxzV5P//4ehpo=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2367.namprd10.prod.outlook.com
 (2603:10b6:301:30::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Thu, 25 Nov
 2021 14:50:25 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 14:50:25 +0000
Date:   Thu, 25 Nov 2021 17:50:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <20211125145004.GN6514@kadam>
References: <20211125142004.686650-1-lee.jones@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125142004.686650-1-lee.jones@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNXP275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Thu, 25 Nov 2021 14:50:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b104be38-1e53-44eb-d190-08d9b022e991
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2367:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB236729799EBD087AEA61E9708E629@MWHPR1001MB2367.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eecFozwHKnhakqib8X/wYurUEWMCbvS1fxHMWTjvEotb7caL9LeuRNbf5AzdP8sGu64aKRhcDUWFmVmTNEoqomqNAzC8/ns4psA4WurTvSWyq60+DTGNa2uw7/inFprOHnfvN+v5ufhBLYr4JTkoBoBp1ZZFhmNzmkSQ0AqyNqeUK75HUtRMoFnhiMjcB3yBg3cl25uznIg7PXssQQ/ND6i/haqkNGT8hT7Y0i3JGrmYjF0TnL2RFgOFvuwBhpox/YEpzXyJRoPJO0HrYsp1TK52SUtOGK0dFjbRn4xpV6CKymzXXeyWIqu2irNEHxqnlafPysJOvyNqRucRCV/NrpyvavfORn9k6/tGDYWIGcxksAQ7w/KHQYU5KoejgtMsX6xwzqszlMvcVCcnOYTDnHFilY4IjEWsWwbnGo34vAxMVfQq0g3tARMcnVjDawwwpkIbAv9Oi+oblBbpA3uI47Koqs0ZjEBvbQTpo66Jc2lCmYeM0WFW8C85iEX18b63ezGIjMMYzQxOwfoLH/W98iMx+jxvFbq14WG2arJlaLS6MekccFovRtzR+3NWb/olwqT6OB/NusVGlRYKPRVrJyulY/YCajS2mFV3pHkAYohXesNRsfNY+IZBlKk2Qf6eD0dCqy83YuhitdjIXRP+Hi9+8p5ZNn6treADduUBZ8AKIO/QGRbXYG9SpZVfFzMFoBGReqe1Xw5rGES0c2syBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(1076003)(8936002)(66476007)(66556008)(38350700002)(33716001)(52116002)(956004)(6496006)(5660300002)(4326008)(6666004)(33656002)(44832011)(6916009)(8676002)(508600001)(9686003)(316002)(9576002)(2906002)(83380400001)(55016003)(86362001)(26005)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?azIek1C4qOEjus5H2E8eABz1Y8vdKC9u+KlqJGAMSW3dpb68fB6Z0DFqxNJ/?=
 =?us-ascii?Q?6V2HCvBB2g2LmVijdEl4GFUZiQsxU9qL3WIgf1Ifp6SFG5o566i2tmglAS7S?=
 =?us-ascii?Q?WPIaY7W4wOpe83ECMXmAfFH2hV+yOA4Ro81CcLkrTeG9vzDYoK4kGa6f3PTK?=
 =?us-ascii?Q?6koYz8I5rT2zyMeou6RecoDd69z0bC6FucGIObtmCc+NTZY6Jr8hYJ+jBsy7?=
 =?us-ascii?Q?mPCuNL1LihHN7m28QhITbp8DyTjvkn3kFf9QQCKvL3BZaFp5nh6O5obyUsKr?=
 =?us-ascii?Q?t+D6tj6zcBFGkVs1GxkQayyXeAj/TvMkpiSOiyi0xyNfSqiQd6hdKScW0Fyr?=
 =?us-ascii?Q?SKgueCjIGQMasaBmXTv2MFvR2oRAzk/b+jtIYFWLxFtvGoAdMrzGJFHezF6C?=
 =?us-ascii?Q?4i8VW/Kli32PVT9vSjbgc1iP93/ITxyAKEkFTOOYv9ePkLyKlUMEYqVdlfSG?=
 =?us-ascii?Q?pBdEbfuj1K/SQedMBPI8aPk5yhL36eUVp+3daose3mhZxriZ7LAsdC9guTjE?=
 =?us-ascii?Q?Fg8eqhA4MIjnDuE/WOazYJ+zWY8dMzr5AgTx239EyX9+XqgdZ/A2AttaHc1h?=
 =?us-ascii?Q?XSUgaq2TrPAEH8B3S5UAG7wVfBUmKIRebM6NbmwhWh85lww+wJ6MLJEP4Z7P?=
 =?us-ascii?Q?33b7JmOSporH0X/6lO2JmCbXNWKV8afl5Rki5SK8eeVBcQKR2eAYO7aCIlRc?=
 =?us-ascii?Q?bFXjXLqb2KFGNGo2GowGestKhZq23PDEG3P44eoRh3stD7/slNY+SwAZWYQf?=
 =?us-ascii?Q?F3EPa5jlvM786JHADM0MqJ2c1shp8ojPk7eulg2k+N2lHPL6F20PBfzUiYy/?=
 =?us-ascii?Q?4OsB5t6M1oDcQey6Y/RAn5oCWTECikI17p2yim/iYXqA3wPvcObzeGMgewOI?=
 =?us-ascii?Q?ABhD/aBCpMJMAHmVdqP4aUGWkg1ZgHnUK5aVUjTGqz6mJI34KFZqS73P1Svv?=
 =?us-ascii?Q?dZGwGMwXzs3s7MmtNw4gsTuolkPfMkHukhUfloFmxqb6BmQqjJRjO8aVJZEL?=
 =?us-ascii?Q?RCbOIErIBvJw2oVX2sm0u1D84PmBAFcD6nq/0bgPpJ4OCu4/bPGKR3sJK3Yp?=
 =?us-ascii?Q?LpsWTIF2HzeEgc3PlxLabsV1NjCtuugH1DNiJgabA7aAHoWymwumV9pSbpeG?=
 =?us-ascii?Q?o4dVTRzAaCYLrh6IvSzsqzkmohjaTieZs9miBcLeHA3UEOK6r9mntM6xolQ3?=
 =?us-ascii?Q?HFeVPY7dYR/cYhF7k4jn5AAroz0MfbVlPnRRZNtz2Q2fKUFA5Wqi0XZOzvpt?=
 =?us-ascii?Q?3mT0Mzft1uINan474nom5OLczpB/JbLZ3dI5Z9hl3DUVTRiiDcIFJJTzEmkw?=
 =?us-ascii?Q?aF0WGm4vAMxSFtSnzaLD4qxLyQlUKHg4ZYT6M+B49HKwwauiBucb3SL6PSMm?=
 =?us-ascii?Q?Wd1Q1sonxbawX9MO2Pae1qLzUiTO7LnAnawyHSVAM6Tbog7re77KIwq3U5fe?=
 =?us-ascii?Q?fUw5JxXDAGF0to8ITxE/2PDXWNHqCANNHA40Q7ubejpYO1DM3s2IysdKlAD2?=
 =?us-ascii?Q?lvOkXzc1YhEWPD2+wcZqluRx+tz2bxUsH5zh+mAmPUUiBHHqnAT5Z42WA8FX?=
 =?us-ascii?Q?p3nJHWJ7eBbh3amZCuVkKmcBA4TVA+WTo8Bxp9jKWRcr5FQPrGagfJp7TKoA?=
 =?us-ascii?Q?gAPXsBAlh9ig79mfBiPpsE6s4EjBIJFfD+3HI/6R+I8Kpp8mVbRH5aNnjoxx?=
 =?us-ascii?Q?VvfjDqL99AFCO+CEDpCbJ4altQg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b104be38-1e53-44eb-d190-08d9b022e991
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 14:50:24.9476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrP4YCi0s7j5+H2UUZEKJuAlVgf82FStWIFbEkrrX8oIGFBCBTIoGSQwTpx189Xe7WmG09N7HAkDAo6OkArS1JWB8OxbtfCaxMrZWcYDx9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2367
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=963 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111250081
X-Proofpoint-GUID: GGcSdVqyfp_VcwxFQGBiWyolyhZWFQ3O
X-Proofpoint-ORIG-GUID: GGcSdVqyfp_VcwxFQGBiWyolyhZWFQ3O
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 02:20:04PM +0000, Lee Jones wrote:
> Supply additional checks in order to prevent unexpected results.
> 
> Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
> Should be back-ported from v4.9 and earlier.
> 
>  drivers/staging/android/ion/ion.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index 806e9b30b9dc8..402b74f5d7e69 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -29,6 +29,7 @@
>  #include <linux/export.h>
>  #include <linux/mm.h>
>  #include <linux/mm_types.h>
> +#include <linux/overflow.h>
>  #include <linux/rbtree.h>
>  #include <linux/slab.h>
>  #include <linux/seq_file.h>
> @@ -509,6 +510,10 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
>  	void *vaddr;
>  
>  	if (handle->kmap_cnt) {
> +		if (check_add_overflow(handle->kmap_cnt,
> +				       (unsigned int) 1, &handle->kmap_cnt))
                                                         ^^^^^^^^^^^^^^^^^

> +			return ERR_PTR(-EOVERFLOW);
> +
>  		handle->kmap_cnt++;
                ^^^^^^^^^^^^^^^^^^^
This will not do what you want at all.  It's a double increment on the
success path and it leave handle->kmap_cnt overflowed on failure path.

regards,
dan carpenter

