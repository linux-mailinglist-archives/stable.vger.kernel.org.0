Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06E252DB06
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 19:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242357AbiESRRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 13:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242364AbiESRRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 13:17:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6E830F79;
        Thu, 19 May 2022 10:17:00 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JFGLG7005123;
        Thu, 19 May 2022 17:16:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=i+ou2OYqgoNzZD3fRiCat4ugvHSSK3lO8dGpFL41kUg=;
 b=zgQbSsGtdjLOaA87SPwteqy3YHUNfVXsXqT5YAGTMP5opBhIN4vjTUdT+EzM29By+mWL
 /8PVkgSmeTwH2Kzz4mqgHQghIsFQCBOIZMZDjIeHetn4FwDRom0bKK8lNrxRoVlqmG63
 aAVtl7/auq8Cn+iEvOBSEGZ+di+y32Gn825RrTfPq50y6CEL+tAE+NqyHNlP+3iouDqk
 Lr+TzzBC3mmqR1QyfoY7LfRAIFer629C4XvQt/pXIalGCgvgaO7fn7tIzH6b1182+6eJ
 ZgPaas/s7Vd7Qv4F3OECMSdnSTZwjYPcuLlpVoMszCVGL3MkCFr56COZw79SxjmLN7Ux Wg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytvyur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 17:16:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24JH9m9P037296;
        Thu, 19 May 2022 17:16:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crn6gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 17:16:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dEv56o/7kGCXr+HwPa6BB97FOQxwrKOcgyWIfiFFqMMTxpKioF8XKttD0DyK4Ee9mlXglyQe4IVXzgXzCYG+A8ddLExcHcgsC5eFjw80AeUuORW/9mqIDmv1Yq9T5cOd/pXPYaniUmzHVpKhRt3pqh1VocerbCno/4HvNxUIgug01W7FIQJ3vfLnsDv+9+eAyjrKqnfdYg0bkDpvCxdouinAgfmE33lhkcdsw8zCpOjlN9YpY4F6uihkvnxDQpika0S10MuBheTjxvKf154nSBR20xX4nvGTMxwZsgwFFpViU49DIhAwqNT50BbjCsPO7wLA/9gNtAi0iU2T+DClvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+ou2OYqgoNzZD3fRiCat4ugvHSSK3lO8dGpFL41kUg=;
 b=ZFdnxYNnreaUzoAUQ7uyE34duyBsPj30m3a205t4PgKWw75pikqaICt2vBKnsnNSxOgO/dQbdEjECiJKOZJR4R/UNI6teQF3A/988gaMJ+ABQxK474iETlL3HPpx/gkimLUSxkAN/7eUCj0qhGI+OwDiU3kGieViU0aVXmZLefqD5FvmtMVmEMbjWzzAuMW33Mu0h4GUuIIE24WqS0+G/d2m1d5mCJIvlkjmGXB/kFdLe4FFk3ufckk0AGnpgCvBEtc64HjL3K5ivCckqYgFHFbL+jopuJbAKGXA2GrsxCWVBcqUmzG9uJBaRb4fsjhhOkFOZdgCM2Nbe6TB5JAOlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+ou2OYqgoNzZD3fRiCat4ugvHSSK3lO8dGpFL41kUg=;
 b=keWKqVHkYiSxTIDyIIOozT9BD8bjvrjxbo9z/eGZjWYWWivRnvOkyNLuGXkz0KCZjE2n1BH7n1oVeNE7YQsQzPW9IdONI/c/bg1iqE519icnR56Vu3Cb6/DwdviZlyqeJFXB97PVQOwITpEIm/MfjoQUJ9mYlSRKS6nSE3jgHro=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB5577.namprd10.prod.outlook.com
 (2603:10b6:510:f0::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Thu, 19 May
 2022 17:16:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 17:16:49 +0000
Date:   Thu, 19 May 2022 20:16:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Denis Efremov <denis.e.efremov@oracle.com>,
        Larry.Finger@lwfinger.net, phil@philpotter.co.uk,
        straube.linux@gmail.com, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] staging: r8188eu: prevent ->Ssid overflow in
 rtw_wx_set_scan()
Message-ID: <20220519171628.GW4009@kadam>
References: <YEHymwsnHewzoam7@mwanda>
 <20220518070052.108287-1-denis.e.efremov@oracle.com>
 <YoZmG98rI7oK5qgf@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoZmG98rI7oK5qgf@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0040.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::28)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 641115bf-cf39-4de2-8304-08da39bb5b92
X-MS-TrafficTypeDiagnostic: PH0PR10MB5577:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5577F1C197DC3B78BB0855308ED09@PH0PR10MB5577.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UVvnjZhzBWmGfwGRFwto18nVEc6ucQMDwI+8Rmlxu/gSD1RqFxZVSA+X+1IBvIru1f4vuBJZswAGiwbc3OzV1hJGLOI7MM64MTsl1ELoVbBeFDD+sATmFue3PYH9tDUtn/pn5c+gGHLFWAM7E4+5jAVOzziFw53mJXTZEjQkjnVKAAt/RMHdz1WBmfbeYUAlXDhNtod2RGmu2iME5kgm3MDulCFn6tw5h1DCZQCOf5Y264R6M6MgDqJOmlad4D9NuNPhrIgnUGVPTguMfntPQg301tHvgoKDBl0PpMhMWlmuHNZ5wE2KVyKWWfYuSVmvfCuNE956lAC/m2cUw6DOwjKB0QfMncdY6JfcTovHGBQcpOc5ms8ANMz2vWx1exmavG7u355LuRZW9dd2zsvhi1LRiHDDHpHKNp6MZhr2HQy5pMd5g8f6uVwlCgWLX78LEyAPUok7iQJ20SG0msZ6kBtEC57xDTkafWkfrrRB5qtA6jgoFFTJUnNz/zJvIAcn0T2c8fprmsujyXRwFbiw095eaboFx1OH1PqvUw8QzarwTtnq01mcfdl0jFu1MREuzoT3S3xwWYZTM3vgwvsoKXhNue97srMGzpIrdyz2zrdm5IOR5VoTewu5btFWdzlI8MK5VIBDAQhuMwapwXOnwmdTMEwpgdQCH+SdXSrrsIgxPwjILA3/4ssm/4qPyJEe/elQUaL4OXpv4DNa8jy4Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(186003)(1076003)(86362001)(38350700002)(316002)(6916009)(5660300002)(8676002)(4326008)(66556008)(66476007)(33716001)(6512007)(66946007)(38100700002)(6506007)(33656002)(2906002)(54906003)(508600001)(6486002)(26005)(8936002)(4744005)(9686003)(52116002)(6666004)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eHVGUuXGrNd8WxdHwumr2xwvVbp6Qu/r8cj8sBct8/oXx9L5cTfS3m/MhLYj?=
 =?us-ascii?Q?9z6EBg96wdgK9Tvgr1E6xJUFm0zIscd5cAqnhIItz/8/d9MzFbE3sKC3Mx2X?=
 =?us-ascii?Q?yzx2TYHgd11S2YqX3N0/eJ5c2iqlMZNt1vFLVDVCP2Zus8cK3lqqNxGuMDCe?=
 =?us-ascii?Q?Smg/i+Fa3e8p1pfcL2/fupGUCu28YVq29ptZDIlcbCMC9cO4InJHnHsS5TTo?=
 =?us-ascii?Q?cQ1YmPMsH1hupp1FX+0+rpS3t0Aax2+e7ysii2AJyeSxC7wvUXFOCnzpyyPf?=
 =?us-ascii?Q?G6HMFPbj5Z7x5ciVPOP461Nc49Ta3byl5Bv22OSSyifhkyXERA0jfagg6dm1?=
 =?us-ascii?Q?wdFgCw+qpW16xZ2LK2Ox1jd/KEn5JXp6fizo97tC6il1qFjVbb3jtLoUFvpX?=
 =?us-ascii?Q?yscUDVI4gjt1tqPqZyQ4IbWKCaCsd99ofKbHZ1zSZk9AKfmDYfrnuQnJOPpg?=
 =?us-ascii?Q?GV9H16mYHK3BPm8CfgvlzaQmSfcVuYot4Nlc2A4xnJ+9/C/sWnToxhQIe4pH?=
 =?us-ascii?Q?q0koUYLl1i6UHtJI8HeFwDqdZM4r1gvwk8yA3x+MOX1KxKGWhbnEne2EEr2e?=
 =?us-ascii?Q?KINcC8M1lmBzeH3sKGnVnHAaGxHTBGB5FuN1k+HG2eNfZrYKSnu5GwySZrK1?=
 =?us-ascii?Q?hfeyuExahqJhfrtmOdzbvSWwo08cnPYe/mK9viSNsHM00cJVILORe01u15jL?=
 =?us-ascii?Q?4/N4J9kNbYAQ9o7uAyB2FlSrNOBz621EpmdJgM7E+MzQdT/VgQlmFfem4ifX?=
 =?us-ascii?Q?Cd8YYEx15K4Tj4hyNurt8YV815/ZVN7RXNe6pO48McJ0RZLiAVAWrfLioiRh?=
 =?us-ascii?Q?A6lCbeoeH1jmgK6nQib8/ALeY6n+bP6HlhfDhDcax6unPN9r2Y068+vPm3/9?=
 =?us-ascii?Q?37tQ9Hsxnn1YQXWB8Fr8MMNCaS371KFa7WgaAEkdPYoC8tUwzerx15Oy0V8k?=
 =?us-ascii?Q?Pjn7tqc4n0R4w2g0y+SSjDwbj5wOh8exdjBlNSxFKgRwP3heXtag+p4VVpsU?=
 =?us-ascii?Q?jx5bueoQuYXR+4UlaZftP8xW07rzLnJyWkENqEuZ9UzSFFPs9v+JUbRk2OE2?=
 =?us-ascii?Q?Ox5afUaeFcWEhlavXw2Cbda+iYJJuEL80EIFYDdailc7Sd490K4eqNjtPppF?=
 =?us-ascii?Q?eZziAOO/IEIN93745Lq2PqUTqEYmZvnYL8bqwbDcpm4SsI3RChPtqQiWYO9d?=
 =?us-ascii?Q?FC29VLl50Zcgq9ijgBFp3fTb7xsLhicqHxkLojRz5hzomc6tKqoKz2f24ap5?=
 =?us-ascii?Q?8e9ZuyiUgIDsZaTrIdwzF33tEwo6U2Q3EYpk3oplumT9TzJFm3/OP0SyrL/u?=
 =?us-ascii?Q?H0xshblWdc/bJajPkdkZrYs8zCUFEVMARR+SJn1JcqtWg1Wg3LEWFoshnhiy?=
 =?us-ascii?Q?jT0p+3cAX/XgQZAkKhCqZiw/ICK2dimG/o/yxod1hfyaQNPZttnPKau3QO+F?=
 =?us-ascii?Q?8vdSP25C8gzgjrkq7WNZ7P26Sgdf93ZscyZFBbnlEXsQwMRSQlJhBFTqRr23?=
 =?us-ascii?Q?nVjDJ+kTouXINEfw+om/+ZdaK905QUxmND2Jj9WkSF97tmcqimYbqFS73zcy?=
 =?us-ascii?Q?OyMic/Ibs04epKsJL/NxRp9BI+dLOcTb5OZ8zwbEN3AWaUiWpLcWwgMqM3+Y?=
 =?us-ascii?Q?i+xkpOCoQTS9NzU6letvJPDmoqi4fvGfIoRjHrj4js6NFpoAkdZr1bqHYB63?=
 =?us-ascii?Q?WRFUvJ3dhuEq5GKqI339Ki1C4713lFivJwIxDBOtD2YgxvplmbHrXSaXOxLS?=
 =?us-ascii?Q?7VMeOyocg1cAHL0Hbyf6OKD0qgPMQK4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 641115bf-cf39-4de2-8304-08da39bb5b92
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 17:16:49.0436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1gH5fwEE8zvtk16iOcxi+Kz2s/N/2PL4YO7rj2gWZuXEdOBDxwuGjyKHaJ/P0Cp5loThn7eP9AvAKkY3AJJxrxkwcbFuBS+zcvbOi2f6ceM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5577
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-19_05:2022-05-19,2022-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=959 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190100
X-Proofpoint-GUID: 8wEfMrfKT-NecsXDjhcBcQwcBrLM3VpL
X-Proofpoint-ORIG-GUID: 8wEfMrfKT-NecsXDjhcBcQwcBrLM3VpL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 19, 2022 at 05:45:31PM +0200, Greg KH wrote:
> On Wed, May 18, 2022 at 11:00:52AM +0400, Denis Efremov wrote:
> > This code has a check to prevent read overflow but it needs another
> > check to prevent writing beyond the end of the ->Ssid[] array.
> > 
> > Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
> > ---
> > 
> > This patch is a copy of Dan's 74b6b20df8cf (CVE-2021-28660).
> > Drivers r8188eu and rtl8188eu share the same code.
> 
> This does not apply to my tree at all. This file is not present anymore,
> what tree did you make it against?
> 

That's weird.  It applies fine for me on today's linux-next.

regards,
dan carpenter

