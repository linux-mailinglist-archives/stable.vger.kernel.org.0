Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C5C662F58
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 19:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjAISjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 13:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237388AbjAISi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 13:38:57 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79471310;
        Mon,  9 Jan 2023 10:36:36 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309Hwh2g017043;
        Mon, 9 Jan 2023 18:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=pniqeqoQloj7fTySycChDeOZd4fn5GBwsSevhFUzxOM=;
 b=Taf2PIMU0jPGSdwoLWurMpo2NKoILIJMpQvirIf3IabqrGEA2iCyiZXximnNXYUbCu08
 j7/pt90vc/LvQjSvT35718IWzpDO1no76ciy+gKHLW7XW6bnw/cqJx9K5HsPYXRhajpo
 6RDqHGLMgF9/qWoBV2iDlhgX+QRsLcmkz06/oLhjPRMeECr10KKz77LG9ILBgHYni2gZ
 51MnW70GK731mHCE9xkmdcERYVMesJ4F6/DvBXrOmRq3p2RHr446NaxU5evosFw4Y8Ix
 +WzLTYygU01FOfLLs1wDsyrxt4pSucI/WcWWAdc/+MDZfVHggPhD9wV36QAaLfOtDFXZ HA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0scbfsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 18:36:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309IARST033079;
        Mon, 9 Jan 2023 18:36:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy64ce7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 18:36:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFRzQcBTDIoVQ2nN00/Yxmpcy0j0FccgzkP7O3PekVTTu9+rPEuNwHcXSGpJyXpsC52Y2csNgeuYHl8yjtpBam5YoBgMsx/5hn5CP5SXcJk7yaWTOTjB/4Unrz4B1OidVuXcyC0IU0X2W52APt8yrH29/gLaYww0ZZb0npL/pARE6ayqjDyFmtaAZI33UvrTcIDbiSJx836XXdvi7W4UkPYhVsjgruGBnFnkFZA0cV0NnR/9UWLgHNnIm0rMeTP6pyeDQPdR+m4lG4t7Z0j21FEpWvjC5dCPZopqLxpHdZlEIa9MJgvxhK3GHtReL8j0sxnGeLFikB89ephTslrXBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pniqeqoQloj7fTySycChDeOZd4fn5GBwsSevhFUzxOM=;
 b=QFvIcXpLjuc4vEX+zmZQb3wGkH4UghjZ3+aA21WIItiNNwq+q8f/7Z1YP22ti5G7bxmaVgCzCdWMCH+MVYxFU5c7bmgUugBtk7dSAhfHeAGSzMJYgS1yF+RfLCVUAAOPRuLQnRJbcMK8+11JDcRggyUPtwcf2RovWdTs6rfr4QjWMGE4N/AdwWc0BVv/cPoXneUp9nrx/6xcyaQxnKWP5HTqnrMVAIiqkHs1GxnhJTyu/DCOdOz4vR/Wiupgr5pB7w8qYkNvcA/mZJUTRDCxY6xc6XDaPoJSOvEb4wjefV9RVA6HUKyNKmn6RmhyvxoidWZy+COnemp7/3bkqM/1hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pniqeqoQloj7fTySycChDeOZd4fn5GBwsSevhFUzxOM=;
 b=D30sI1su7Do5MRl9JWJADEU5tdeXk6woEVXkONj7/hOe+d0+i8woSmC0+laXtaK0BoyNst26cvKKFeY/ZzMZh6cELcUJR50JreC7m3bRZl9o1sNHwkTgwVIXXsM7EUgUl4wSxGzC3JTF7qEt83SoUZJfWXaoflAFcswKmADehrY=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by PH7PR10MB6250.namprd10.prod.outlook.com (2603:10b6:510:212::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.11; Mon, 9 Jan
 2023 18:36:20 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.6002.011; Mon, 9 Jan 2023
 18:36:19 +0000
Date:   Mon, 9 Jan 2023 12:36:15 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <20230109183615.zxe7o7fowdpeqlj3@oracle.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <Y6M090tsVRIBNlNG@kroah.com>
 <20221221205210.6oolnwkzqo2d6q5h@oracle.com>
 <Y6Pyp+7Udn6x/UVg@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6Pyp+7Udn6x/UVg@kroah.com>
X-ClientProxiedBy: SA1P222CA0061.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::14) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|PH7PR10MB6250:EE_
X-MS-Office365-Filtering-Correlation-Id: 83cdd542-7288-43e3-14ce-08daf2706670
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GvNRe977gWPjGQeJy3k9utsjNw3TGBYyGr/x7So3XEAx/t157ui7HfvJ4fLPapCW5mLQx2mOiHf8Xi2OoPeuqGm6sW7UiAgjEGxFaiUtA3aeg+rZ8ops2RbiekdLP4WasjSJidgf5NH4ZzYY0PoXIIk8/AgjD4wE6YBTAQkn3/FsYXlJ+PSd9rC4xThio+bUiogc8Dhh+INWEdgXh5nAcWN0sYtetrqDC89fqDK/po/8qxMFkZEDagu+VGcraoBq8yeghpX4f0d9S46TgcqtKsQFT0OkAyJNj+zqW8K1Uilxx8hO42NG/B9DOZzyE7EC7pmlRPiM3T00Jrriu7SKkqjOVbXxINNXtOkdSOlRjs/2Ky2rEAFGhkIxAVfu12kS0g7YQMKDXNYieui0vf2QTvFzemzMbUyIUj/n9MEPKMEd+c9ZgfMdHodODCI0rvM77y5UHIjq7/HZLmDZEY6HTNXZ+sh0zrKpESESFSm6j9HOA01fJKBhzfdRALzvpy1XiDb53pn4utdp2FdR2E0RK0nsYPgH6nw22rwiWA9mcd4yBwsBLICtdDjZPNHnbar0dYvVttiEXnLYVnstVNHWWtXgA4W/286jK+1gR5Y6ebsCmQgKDTu4HN0fshVoNMN/RCA/cwT8AsI8m1chd5q89g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(2906002)(41300700001)(5660300002)(8936002)(38100700002)(86362001)(66946007)(2616005)(1076003)(6506007)(6666004)(54906003)(4326008)(6916009)(8676002)(66476007)(66556008)(36756003)(316002)(83380400001)(6486002)(478600001)(44832011)(26005)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vi+dUyL2Y0Mo9adYMVEJDt0PQHGXW4GkSKDe3YN2GKRb7rnd739U/QHnV3+I?=
 =?us-ascii?Q?5+SnCqKmMgeH99HO6gjf/JIGldUJu9cNDyOJdSspgt5rbNk3nf4hI+NArdvi?=
 =?us-ascii?Q?e1S81yQQwq6qnzomoPBPZLZ97LM7yo1X1JpyeUk8KCkF+mJK2yh/sDa94/R5?=
 =?us-ascii?Q?920+I0TgNXmyJWvojF+zV/8cGBq+AGlozMzLIpR4DACiUsRGR6eCw5x3rkZr?=
 =?us-ascii?Q?2YedhPcl5uNiMJr1f58ntbow5bBdJSyJwHXwzWFRNKGnDEsjGKStu8BDvzzO?=
 =?us-ascii?Q?aeWjJzA+0sc27S3WktSfitu35MuDg/NWM7VBWnmhFNZ0xTg0JCn2qnpjdmoI?=
 =?us-ascii?Q?yAZvg8MF0WxWEKdORxrS1Z1003cfoxt0CtYo+2CdHlToWGYc5GiJdW6DpOO3?=
 =?us-ascii?Q?XFxTTHMpdAN3eoCMTOtlwnVsR9iLbmbTLeMk4G9ddBIBxXlOOAxboZeJps47?=
 =?us-ascii?Q?q/2u2PD73ZT1WQXRRsSeoOMOOygHNeFKQxpfyetQBOXFdW/LWxrhNnd0h32L?=
 =?us-ascii?Q?db5u+FRwI0aFYrc8qsCNFNHVJJlFr4p0oFckittO9e8BwVuU1kNX+SvWdwBe?=
 =?us-ascii?Q?TtZHAqoMkDNEFOeV4LQI9SL5O+/RXwpXVjAirVWV+m1rexzNP5v9aP1UbVNf?=
 =?us-ascii?Q?aNZWCPCEpSj7Gs5Qbn+ZqRWVEPE1fsRISE/NEfjQKIc+OwJbo0NBhKd1VA42?=
 =?us-ascii?Q?H2CR4qj4CUMwsN/ZAIOb8fFgc64ItqP15XL2SW7tb2Vo5obt3yvazQwSeaXc?=
 =?us-ascii?Q?FmJcZ2Am6BIDeQ1BR/5ccTLI9dlQq1JmPwmJK+scZmfqdaR/e0ftIe1xavi6?=
 =?us-ascii?Q?SdxL5rF6ocTgj38faLDqOy+kqEmY30aNMCGxQqxNjxOTR+jE/WzLpdqHJ8df?=
 =?us-ascii?Q?jW8SrA+ffn4szH+rKOWq/dVUpZ0uU+HxWai98C1cDzyuhMiAp9rLnR42F6sw?=
 =?us-ascii?Q?JGX9aBJ78iy3Rs064KWZbGQ3t0ryIPNyeK+bA61Uzp0g4Pn4ex9NINVJwUDe?=
 =?us-ascii?Q?RyDLLMBFeaobXN8Ux5v4O0+fXB06mu/RwkIQKPx8AvqY8Fo/53/w0gVQ53DL?=
 =?us-ascii?Q?hfy08vdH/FODut/M1LSxJ/9mn7jBZHCdUj97/DqSF56lVnXoQIe62IvWqkXg?=
 =?us-ascii?Q?8yJjmYT75x67ryQm0VPzDBvhRSk3BJjFJfuEMcNctqLzAF+L4E+tcs/RQPg7?=
 =?us-ascii?Q?/R0tIdFcceVO0ZTZnaHo5J8FuOF+cq0/pfCl0jpfbkddSNEoG9Urws4FkYw4?=
 =?us-ascii?Q?n7lgDbAh/+QS5yKAkIGjbieYcKyeb+QuD0RoHhawKbHR0kSiHv/Nq4J1hqiz?=
 =?us-ascii?Q?t5woUP2Q+/nCdZjl+/fl2Dgc6a99ublbIUtalt3nwEzgfreo/nwp3avsBj7N?=
 =?us-ascii?Q?Z6sdjn1ti+PT22LyqmkmVEb1Rpte7BetKEFz6xYOjzviphozwBHS3RWX85dR?=
 =?us-ascii?Q?RnuHzCHtXZ3Kx/g5d0pUCMpli20y8ownshlr7feRBaLoojfOg5OoPJ0Zq9O9?=
 =?us-ascii?Q?QQtmm2Dp/3d8jwntNRMvD71Bv40kr3mtLEfdaqDmj0AnmFDvF53u33j7Wf82?=
 =?us-ascii?Q?zeh6Doto36aJ5hYjiHok6wCpu8opaxRy690y5ufu?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: i7FsqoXN4ZDVONoCZWhyo18HmwWwZyLJfOW8nA82fJLZvXRe5J5Oa80Ys0kmJcNXfFWuvtUOizq6eeg2JvJiDD8oeezHd01l3IlvXYfgOw7pdJAa3520WJNcnoEf+0T26SGLQpL+QIyDjAxNjoREsJ5Uek7cCK1EEt5AGF3uAPEX5biY6XplSMeiT/AOwxCa5yXbv8kQMQMWh6SLL3qvVI1QCvaOODhTtjqf/m74Sovb2/97P0jZe4uzfx82NlrbT4NHnj8H6A4pCHB1ZdAvDPRR31U71soxUjTh1HNAkzgNM9w/cCaojRng8eoDpTh3pJIBl2FYMP9EE9uK3jrv8podfy0BXQss4gY97AI5YhrJfNbi1CCp+krkmp8P8RKL8EF0zn6vnIOvsa+zC/gUg9oHrLbxNonDlR8ZRkIxKaQXy4fqJv0nxzvFa9eKZb7RE5xuFuLgul1YuG80ZoHojpuBZBRmPpSiNGuDJiP4owMZEZ07dWQ+aChw3JkpiOuVDHL28L53oq+1T7zLVc9Tfw9SB+GBuQT7b3HeVA6H5d4aCsp9YrNMlTvn5Ni8hVpCo1gqMEz468+ZWO0wYJS3BnE4LiDd8UTFpsr3v6LMKwuXLfVlUfslqcPJYfIPygpQ2d2AeQO29smRjD7BHFcv+gmZOiz0OOxWCeo5cVlSJ4TsfbxxDpTFs0HfFu3kN3dacSToHsFyy1HTF9Eit0uMf9yoRKnu9Fpz0cPqg513UVYPbRYl2cjRl4owgUUfId4vhhNdj6vLc2iXyixw2tv6PXAHVLeFenao1xBeLzKeP7PzQKg4s+L00SfP3okDNpfprKhgnqpeENW87a6kpu2klicW6mQMtRnUDIgAk4oTvWJL9nROOTcNU+pFbBEsuGPuKzN3YOfTxzB3aD+/i3co4PT+zN8AaAcd9XlIu3JukJY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83cdd542-7288-43e3-14ce-08daf2706670
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 18:36:19.8507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bHvxxDXrWr4WuP7+nxusGtK1nwmVp9e6GLNeIk798/b5pOTNh+2dwKSqHYsyxEmnTHT7bUGiNTIpWWTy0HZSbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6250
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_12,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090132
X-Proofpoint-GUID: qi8g2psrtGprBcPHar9bUKUb3Va0S5GN
X-Proofpoint-ORIG-GUID: qi8g2psrtGprBcPHar9bUKUb3Va0S5GN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 07:01:11AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Dec 21, 2022 at 02:52:10PM -0600, Tom Saeger wrote:
> > On Wed, Dec 21, 2022 at 05:31:51PM +0100, Greg Kroah-Hartman wrote:
> > > On Thu, Dec 15, 2022 at 04:18:18PM -0700, Tom Saeger wrote:
> > > > Backport of:
> > > > commit 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> > > > breaks arm64 Build ID when CONFIG_MODVERSIONS=y for all kernels
> > > > from: commit e4484a495586 ("Merge tag 'kbuild-fixes-v5.0' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > > until: commit df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > > 
> > > > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > > > after df202b452fe6 which included:
> > > > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> > > 
> > > Why can't we add this one instead of a custom change?
> > 
> > I quickly abandoned that route - there are too many dependencies.
> 
> How many?  Why?  Whenever we add a "this is not upstream" patch, 90% of
> the time it is incorrect and causes problems (merge issues included.)
> So please please please let's try to keep in sync with what is in
> Linus's tree.
> 
> thanks,
> 
> greg k-h

Ok - I spent some time on this.

The haystack I searched:

  git rev-list --grep="masahiroy/linux-kbuild" v5.15..v5.19-rc1 | while read -r CID ; do git rev-list "${CID}^-" ; done | wc -l
  182

I have 54 of those 182 applied to 5.15.85, and this works in my
limited build testing (x86_64 gcc, arm64 gcc, arm64 clang).

Specifically:


cbfc9bf3223f genksyms: adjust the output format to modpost
e7c9c2630e59 kbuild: stop merging *.symversions
1d788aa800c7 kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS
8a01c770955b modpost: extract symbol versions from *.cmd files
a8ade6b33772 modpost: add sym_find_with_module() helper
a9639fe6b516 modpost: change the license of EXPORT_SYMBOL to bool type
04804878f631 modpost: remove left-over cross_compile declaration
3388b8af9698 kbuild: record symbol versions in *.cmd files
4ff3946463a0 kbuild: generate a list of objects in vmlinux
074617e2ad6a modpost: move *.mod.c generation to write_mod_c_files()
81b78cb6e821 modpost: merge add_{intree_flag,retpoline,staging_flag} to add_header
9df4f00b53b4 modpost: split new_symbol() to symbol allocation and hash table addition
85728bcbc500 modpost: make sym_add_exported() always allocate a new symbol
82aa2b4d30af modpost: make multiple export error
6cc962f0a175 modpost: dump Module.symvers in the same order of modules.order
39db82cea373 modpost: traverse the namespace_list in order
45dc7b236dcb modpost: use doubly linked list for dump_lists
2a322506403a modpost: traverse unresolved symbols in order
a85718443348 modpost: add sym_add_unresolved() helper
5c44b0f89c82 modpost: traverse modules in order
a0b68f6655f2 modpost: import include/linux/list.h
ce9f4d32be4e modpost: change mod->gpl_compatible to bool type
f9fe36a515ca modpost: use bool type where appropriate
46f6334d7055 modpost: move struct namespace_list to modpost.c
afa24c45af49 modpost: retrieve the module dependency and CRCs in check_exports()
a8f687dc3ac2 modpost: add a separate error for exported symbols without definition
f97f0e32b230 modpost: remove stale comment about sym_add_exported()
0af2ad9d11c3 modpost: do not write out any file when error occurred
09eac5681c02 modpost: use snprintf() instead of sprintf() for safety
ee07380110f2 kbuild: read *.mod to get objects passed to $(LD) or $(AR)
97976e5c6d55 kbuild: make *.mod not depend on *.o
0d4368c8da07 kbuild: get rid of duplication in *.mod files
55f602f00903 kbuild: split the second line of *.mod into *.usyms
ea9730eb0788 kbuild: reuse real-search to simplify cmd_mod
1eacf71f885a kbuild: make multi_depend work with targets in subdirectory
19c2b5b6f769 kbuild: reuse suffix-search to refactor multi_depend
75df07a9133d kbuild: refactor cmd_modversions_S
53257fbea174 kbuild: refactor cmd_modversions_c
b6e50682c261 modpost: remove annoying namespace_from_kstrtabns()
1002d8f060b0 modpost: remove redundant initializes for static variables
921fbb7ab714 modpost: move export_from_secname() call to more relevant place
f49c0989e01b modpost: remove useless export_from_sec()
7a98501a77db kbuild: do not remove empty *.symtypes explicitly
500f1b31c16f kbuild: factor out genksyms command from cmd_gensymtypes_{c,S}
e04fcad29aa3 kallsyms: ignore all local labels prefixed by '.L'
9e01f7ef15d2 kbuild: drop $(size_append) from cmd_zstd
054133567480 kbuild: do not include include/config/auto.conf from shell scripts
34d14831eecb kbuild: stop using config_filename in scripts/Makefile.modsign
75155bda5498 kbuild: use more subdir- for visiting subdirectories while cleaning
1a3f00cd3be8 kbuild: reuse $(cmd_objtool) for cmd_cc_lto_link_modules
47704d10e997 kbuild: detect objtool update without using .SECONDEXPANSION
7a89d034ccc6 kbuild: factor out OBJECT_FILES_NON_STANDARD check into a macro
3cbbf4b9d188 kbuild: store the objtool command in *.cmd files
467f0d0aa6b4 kbuild: rename __objtool_obj and reuse it for cmd_cc_lto_link_modules

There may be a few more patches post v5.19-rc1 for Fixes.
I haven't tried minimizing the 54.

Greg - is 54 too many?

Regards,

--Tom
