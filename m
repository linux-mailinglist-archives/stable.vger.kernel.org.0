Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3F252E555
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 08:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346024AbiETGuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 02:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346029AbiETGum (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 02:50:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9F814D78A;
        Thu, 19 May 2022 23:50:41 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K5TCu8002442;
        Fri, 20 May 2022 06:50:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=8QSlgsHmDK+0JkhJeaqXQ8bizJy3MI+HOBO07GkfNVY=;
 b=AVEjl//R0blkkvsu9e3gGp8ZS8vrThyt4ZDvPA+QUryV/rZNBYSPszt1MZ//Nf5HgdZ8
 J812seaxyWTCDN1L7MiihqeAvVIifff2oR454KfOWpYNu6g2uvX4a9G+Ucs7WnclYeNX
 ZHAtMoUDZll2SugOTxDrvstr7IuOjXxDPhdMReIUS9ZJry0+LM8WhFdMSgqqZjyvvVB/
 ReGuTF/wIX/EnCaHYLXr+AvdxQG4MvcjqKxivrYQxka4iKyE/VnV5t5gZBl9s104lY9Q
 YZHsobPPwSkd7ppeDdEXloMZF9O4jY18DJGjx3YZp347zY9/1/cfF8Uu1s+a9o4x/iLd zQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241se6n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 06:50:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24K6nrlv007310;
        Fri, 20 May 2022 06:50:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v66ss1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 06:50:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hn4Y4bQYMuXjGfbB7LkGE13dgTB8tdMthZ0atUkrJ/1/tTzdwGoY8Mjown8uvepN0oFyQGEUeJHMeNPzxWIXo1WvHrAWI9ppofRJGHN/fR/S/GJMezmWpoYQfM/bReg1AoqyFTMXNzhvbde5qXKvENnuFGpvuvrPLOsuj0SmLhr6kAlcPXIftZAEqEW9wm+b8fg/1zhgEF0wnhjkN+Sx0FgqStSVkww5hkfLOJUw5xM/3PM5+6gxVA7dd58otSQcZF339p2gmh6AhY3EbOY7PxKUgjxPFXW8RR8LwTNLQxgeqrktLCNKC40EtwMQaqurb4JRd0xpI8u1UB6Y6DEgAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QSlgsHmDK+0JkhJeaqXQ8bizJy3MI+HOBO07GkfNVY=;
 b=F3zaUGMlLPCSt2uPv7WW5vmAGJw2WT94f4aU7wHTvjoPAJZlmcKHLGlgpdV+BnFm+VavM3HIMU2QO5AMy3TTuoqXxo7XRN9pj7ghLVl8YqRnriDTDkQx3kD8UcBq0tX0OmyfhVME2YWxHRiq49ybIiXKMKjcRZtUmB172mq6XCPbc8OVPySg6U6vtYjguPMHnZtpyC3fQnl/3fLD9R2EEwDl/M1CZ6IAWtKbvnA+UJw42U6W9a9+krigSJdGbMgZdf04ecFaWdajUX7VsHoBwtzKHmGTdRb/F40XWBAQ3iDtOgRckuCfRbRALWbVv7fGzG5Z3wrwMqizOBeZ+cTonQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QSlgsHmDK+0JkhJeaqXQ8bizJy3MI+HOBO07GkfNVY=;
 b=u8vRFRQ1VeNJSngNb7SFpgC3jsZQPl2eTCCoxZZ4+bqK3v/uBHCu6FaDDDA5qg8mq/sPgLRFCBNV9d9m2Meq93CTXawhtYppfl3RirhR6lalDhohRZOK2vEyhcTRsFfDX3cDFAinb+YYuGgKtlArYEccULfH8PROc884I3kHRGk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM5PR1001MB2107.namprd10.prod.outlook.com
 (2603:10b6:4:2c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Fri, 20 May
 2022 06:50:34 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.014; Fri, 20 May 2022
 06:50:34 +0000
Date:   Fri, 20 May 2022 09:50:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH v2] nvmem: brcm_nvram: check for allocation failure
Message-ID: <20220520065023.GB23160@kadam>
References: <20220510093540.23259-1-srinivas.kandagatla@linaro.org>
 <YoZ2ozeju8bXzUyX@kroah.com>
 <5b219857-4fe9-2406-2c6f-0511e8c33765@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b219857-4fe9-2406-2c6f-0511e8c33765@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0116.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:50::34) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ebbc77e-54cd-40ef-f029-08da3a2d09db
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2107:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2107C614A5D1F6D9E55D05C48ED39@DM5PR1001MB2107.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mI8xltjwE7+EQzAsvWKVIs5nsiOk+BryZyKGlXmr8qG0O/ztb0zM92O2JMGqFqUOogwaz4cOXhSZdzqT7jhOISMkbULDJS2w+RYgZN/xeXzqQrcg/C5UwVpjyKkrxarIoRx2WDfkACduZcU6srnyKE8fXxofo4ez/AYouohQajsZ6NK5hvqGHz390XcEqrAMT/TeQ5QZVxTBapdGOZXzYg1FvYZEjLAVUWgHNuqcbbtwNKg2jLZJg5OH5mHqg8LSvMbSuuPiq1FK+fmGsleKdD2G4suo7Fujx+QXBkUGw87lwxNNBuWS2rB7Dmuw83ZDuJAxLFA/+nvEYLyMyWHLjHs9hRtMUaJ4b3vWQeI+wuWPPinhI3r2HssO30yHcSYGQrzWm1ph+Xt4JimUh5uYLkf6ujUt1ezoW7p4f/bJV7dCd1jolCznV0asT7MbhvuBVQ3iNQABP3yF2HX966igumHbTuDjyWBA0ra4BiTjjgjvEAacvnbYDsw+cd98KZ/aWVxr7drpnj2tRWyBCq2GAnNWvINWH9DMKAz2i4gSN6JIHxy/APGN9wm4Jq8xCbRHYx742h9KeMKplT+vxKIk+lepG2o2yxYtK+hNWVMpBKZIS0rnRJTAFfWBAh1HXbRRT8imLvI314F8FSVzau/Bj8mLH8W9DCpXAflSriFtmnSEeFEPmVfssC48eyZwf09NbDfyD59hUuCAPI65SAdGtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8936002)(6666004)(44832011)(38100700002)(6506007)(66946007)(4326008)(33656002)(33716001)(4744005)(186003)(66556008)(316002)(5660300002)(1076003)(6486002)(8676002)(86362001)(38350700002)(9686003)(26005)(2906002)(508600001)(66476007)(54906003)(52116002)(6916009)(53546011)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uji6UQknE6X3usSyJKi8w419IDuogGG2J/K2IuOhfOc3jZc59MzFXajSodQ/?=
 =?us-ascii?Q?8YQfgC3V2EyXe+XASbfz3Yv/IL0t2DtocwOhGnpJI84YIT4uRj6iFvniGJ7Z?=
 =?us-ascii?Q?t2a9OXOiNYU6+OR+YVNrTaP4iAzICffyuMXjZJA6V6gsc6QV7BJrZExVI7bT?=
 =?us-ascii?Q?x2iEiU/Gd7k7unFYYC9nn5aUbAUbiTgFEBiSzoBpIduLGfO1Z55xZHYR9zbP?=
 =?us-ascii?Q?GfpWPbwfL4LiKTk1W6rBbrGcEQwT+nCB61oC87qPTeEMF3IzIOzd0Vck5bgN?=
 =?us-ascii?Q?r7toDkv0v7lw9RAFOFqL+wQH1DCv8GIZO6l4fTcwaA50O1MMDky/VPBsXKLE?=
 =?us-ascii?Q?3LroedkhriOkvLAOh/1ib8KGbdAkQ/d5f9Ngso5FOpBrM/gcMRMKNjGbT8SW?=
 =?us-ascii?Q?haczTNPkRnL6wKDhau/ugJWJ5HPzSBp0qhGyu0SLtE0KiLnsHb5IxrzskYif?=
 =?us-ascii?Q?eLw0d3jKBLtfeCImA0OYyVma7RAvWHpuApXW0iTbXUsv4SN/eKulQ2N4hovZ?=
 =?us-ascii?Q?7Sd4RYwBPS6Zt7GDwzi6dieDzzkJM2gAmcLn/9C07xP7PYsCe3Oy6QiwNJmX?=
 =?us-ascii?Q?ws0jVcYjbVYNCicfyCwFADNLNpAK1KPOjznMHtAA1f8uRzK+Kr1DUfOzn5X7?=
 =?us-ascii?Q?J6DpZi3UbLBkjE4gG/mARxJjlyi9df354FlDwD2ohPWU11APrQk62u9O0uUf?=
 =?us-ascii?Q?Qpcv7HjPhBbzm9XABvJ0NVY/qZziUJ5TDELODFd8Uzxnd6fCZd6p8ZCRLduG?=
 =?us-ascii?Q?CmShCveWbhinN65E128ZF5GqslYBkLA+4SD8s5hOVAug+nA5O6CyTkA1cnmd?=
 =?us-ascii?Q?qUilP3KMZjrhWq8NYimDaWGj6O5YaZk3skffrKirTdZ51fOviTZkC7EbCqi2?=
 =?us-ascii?Q?/e8p83KjxhyQZrRGwvtHHw+NhkbJQPgP7eJ6gRn6g8Zrixz/67/wiG9okTUQ?=
 =?us-ascii?Q?RF60ku0eVHUFpeYqnYM3LKKUde6hO56vebS68Sc9eaLafYobMQpjQCsXFYGJ?=
 =?us-ascii?Q?8tdHKU8qm6Ncup+kDGV+2fSHe/QQNYGygbaWk4vtyI2CjcgEGNEosKyS1V8e?=
 =?us-ascii?Q?2YrldL+sYtdVc9wqaryaWbNw8cC2CBf8MFHding8XQvW6RIne8rgF3Hg8Guv?=
 =?us-ascii?Q?DCF0sKFVuU/m4C2LOelDXUXGP8sDNFuBIcsp9Fo29j7XvWeaoR1U13VxEmdG?=
 =?us-ascii?Q?dHwo2ZBD7moHltIDRL8v0TabnUKP8EvpaJ6qYIqkh+ZOUGJL78gHPasylu4c?=
 =?us-ascii?Q?rKUmWriI7bDsUIyKpnI4FUfZYbz0iBxm/KtZQE9CUocVIp99QlVuk229T0s3?=
 =?us-ascii?Q?zvuKCyCgfZ1jUsQCThxc1tXTKZH8atWJ5GQBZCqKnSEluy8AV8uzFkH1RHY1?=
 =?us-ascii?Q?aPKYi8o6pHxmZk78s/DhFtf/zodAcjNMZFG5gb/PdAC4pvMlne5M49TIWrkh?=
 =?us-ascii?Q?SjD7N2TMUijgskXWYxwQDeqRFCQn2WXEn4KzwgSm2n5nOzcVOanjPPphEr3E?=
 =?us-ascii?Q?srHyGMHjqEBS2k4jZ/wylAtUTIlit9Khmse9z58dN+5TjKiimXxmL8bEvFIm?=
 =?us-ascii?Q?Gl8e4hoxgoa4/cvB9DrR7jiL3w8fN43UKP25a/VvxIq82sRJ8IGOdB8mxe/2?=
 =?us-ascii?Q?+6QnSm6AWxoM7mJGw3x623qRDd0gl4nkRl+AeYjy1bYfh20dog+fgDQOU2lb?=
 =?us-ascii?Q?dgD158zrljdM1v++h+c76m5SVWAEoB1ZYQztuLGLMLK4u/eaPszPbK0Wgy06?=
 =?us-ascii?Q?lCvEX3zj2pwUczoNAXmvg97vFeJzKJA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ebbc77e-54cd-40ef-f029-08da3a2d09db
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 06:50:34.3444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P/K5DG2V0E+EDHt9jKOPZBNyscQ+XGFePYaAHH+SKnHY//Mn4oE4ubIpWCtvwMwAmkEmEWsX7RcOQAgK9P/Kf5Fmiz+cSajnIQdBFvvIt3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2107
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_02:2022-05-19,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200050
X-Proofpoint-GUID: o8YA8MOj_jjgq5p6TxEumobuDX8XxVTm
X-Proofpoint-ORIG-GUID: o8YA8MOj_jjgq5p6TxEumobuDX8XxVTm
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 19, 2022 at 06:03:56PM +0100, Srinivas Kandagatla wrote:
> 
> 
> On 19/05/2022 17:56, Greg KH wrote:
> > On Tue, May 10, 2022 at 10:35:40AM +0100, Srinivas Kandagatla wrote:
> > > From: Dan Carpenter <dan.carpenter@oracle.com>
> > > 
> > > Check for if the kcalloc() fails.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: 299dc152721f ("nvmem: brcm_nvram: parse NVRAM content into NVMEM cells")
> > 
> > This isn't a commit in any tree that I can see, are you sure it is
> > correct?
> Looks like the commit is not correct,
> It should be
> 
> Fixes: 6e977eaa8280 ("nvmem: brcm_nvram: parse NVRAM content into NVMEM
> cells")
> 
> 
> Dan, can you send this with fix to Fixes tag?

No problem.  Done.

The problem is that Fixes tags will change if you use email instead of
git pulls.  Or maybe someone used git and did a rebase?  The point is if
you just use git everywhere and don't rebase then the hashes are
immutable.

No stress though, we figured it out.

regards,
dan carpenter
