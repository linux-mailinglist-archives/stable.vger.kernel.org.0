Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277D6669BBB
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 16:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjAMPRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 10:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjAMPQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 10:16:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D3F83E3C;
        Fri, 13 Jan 2023 07:07:12 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30DC30TK012030;
        Fri, 13 Jan 2023 15:07:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=tsLnUvRa9r8DPeyp6h0pQ59xc3E2kdY9ziMBrrKJaIc=;
 b=ACqhpar6ZXBzwYXH4FXrdh9N/5PrcSFISeaixLsfDdRN9iAO74r583kKnuUYxHFjBY3b
 yuzLI5RQNweSXLBWPcrP4Obln77QDELzIXko+/GEh6ECcmIxhFggd/CHSYC9d4sU7yM1
 fIKVqEaaNLNyNB+Hthet1trDiVSuIA7T4f4USkKJ2tYsLTQpL8f7FzXzvft+ydVIfvMa
 Ta/zR2DpbhbQktGrChzpczevZ3dH7m2Z1isN+pL6VyjXHpId9r41s1gs9UbGtfxPD1jc
 sipIJeKzZPsKP9vbcIebgQ4L56ms3axjr0ciWASLdEPwEi9LC8V4k2FnGTjLvOqIkRwT wg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n362w8dc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 15:07:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30DDjr7u007273;
        Fri, 13 Jan 2023 15:06:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4cr5ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 15:06:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmPEWCrxrE/oUHvbYjd97Q4HhBmp9BKxHcGzBLFXRM2AXLwgBa3r/ZLqYAF2+/DmQ0b0M3hDr1mVv8xLhqikbgP05cDHE9e7otnUQQEZ6JYx5FHLSN8FUNIBaRU+vaJPbagu4UGP/rJUMwuM8T6WTsZEJ7t8pdoIFFz00dWugpAnG6dVsxuYPMFk2NAhHRkIkFwMErR1PyEM53x0O8jCqF0Cemw1Mfvl+pW4Csf/eTvhWjisV9vFxV9w2FtpfDmOkJfKz2SlnRQvoB92z/yIIRB4eZ5mki2gT/DN2Zu9f1WWwuCGWIIjAw27+kcH20k8KLoNzOnghx+zJSrbzT5VOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tsLnUvRa9r8DPeyp6h0pQ59xc3E2kdY9ziMBrrKJaIc=;
 b=H2dlVGaPA8sYp2IEMI6Jo0T0wP1PBaIPiv575qxE/jRB/5E1B2vngZ8tNwTDKw0U4s/OXnbfCAdZWq+mknxLgpP9r0D5g7zQ2u+PkqDqGwIah1EgRWwJqW2/YmYU/0fao0rY/xwT58BDFK/Gxw+/lWJsJJvBLlXvjW6W+dIWJMZyECdGr5f+RPH1CJwzcmImG6ci5CDEuQ2Vr9EUZb2Zslk37juVRo/QN7Wr0ElMGP5dvLD7INs0LeZJdLTlXrQiBaiBd4H4U12PrtK8BiLnQUTf/kx6vBYg1/GAT3PVPfTQfdvhIizHAhISe7ZPndI24Sj3LkZ9vr0i/LRarrx7uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsLnUvRa9r8DPeyp6h0pQ59xc3E2kdY9ziMBrrKJaIc=;
 b=vAo93uruOMTiXWQi9kBxCKRqHP+qtCVMumcyHyDdH7p15I6HETYMgIhPHtmdYV+A2NxqnWqH+BI7qcQD/C+ED3E9YsBlb1/KoGRBFSpRXFM4teaQ1mRbewOGzH7aZvFBn7rzcHpgSGq3rgiMuu6uZHOBa1FIRs0x6mqJMumuBac=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SA1PR10MB6567.namprd10.prod.outlook.com (2603:10b6:806:2bc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Fri, 13 Jan
 2023 15:06:57 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.6002.011; Fri, 13 Jan 2023
 15:06:57 +0000
Date:   Fri, 13 Jan 2023 09:06:54 -0600
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
Message-ID: <20230113150654.w4cbvtasoep5rscw@oracle.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <Y6M090tsVRIBNlNG@kroah.com>
 <20221221205210.6oolnwkzqo2d6q5h@oracle.com>
 <Y6Pyp+7Udn6x/UVg@kroah.com>
 <20230109183615.zxe7o7fowdpeqlj3@oracle.com>
 <Y7/2ef+JWO6BXGfC@kroah.com>
 <20230112212006.rnrbaby2imjlej4q@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112212006.rnrbaby2imjlej4q@oracle.com>
X-ClientProxiedBy: BYAPR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:40::26) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SA1PR10MB6567:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f3a7f10-56f6-4293-0b4c-08daf577d023
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UttMJJMaBmT6OMYo7Y0Tmeh9mOj1D2AA6io2fllOrCQiQ8aZ+uHIf+dmckn8pIH5tGV7eGc7T2dPNDh0dV8d3hA3aQFK6/FU8ZokJMOCNhk49Pxjowj4e4ACYY5XkokoHMYYwdPba2yws77LvgIEUFcB2RSII6qCRzm6T+nlzbNSTGeYEiOsiQVsU4c3h+xdF1LyaCbAFBUUxSpk+kA+rZtc3GphkFrGjT8bxsdQ2i2Yp5yCllCzdIsU2yXglvxCcXAisWvLVerhoRll8DyMGTg1z1Rt+R0cdLFreJ+VTWVWvYFynGwXJuFinv1HNz/7yqP5cS+461M4rkmC7cvqSUFJz6IwEjBWrG6Ub5LviQLT2kvGBH3iTSW2uKu2D2yd3JQF51qmurGf0zWrL0/kLVbYqWqC469mbJwe4Avy6G74rPMWbFWnfsG0viieBlaUY21SksGwEcLarGga9n+3e2Y/Jbtxc7mreM3+Z13tsUT12Wogy5+FDwknmq+RsgzYxSRho6KPQRMwXoX+mDN3euSeK/WkC9yENXsbIdFySy/qt2AGFm3ucRkLn0pMJhehcoxFt1s6kk2VREpceO8CVjvwiLXiuJHidCvefMqr3qAO3xWM035yV2VC7XpF9jsF1wM+jG6cISUw2/NudyF1AgvLTHl8smQGzXIHf0Z7fBYSX0Wh1YZHFbyCeH3c4B7fM+e+Z1+IiSw2j4U8oLcBDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199015)(4326008)(8676002)(8936002)(6916009)(66556008)(66946007)(6666004)(66476007)(41300700001)(54906003)(316002)(2616005)(1076003)(36756003)(44832011)(2906002)(5660300002)(86362001)(26005)(6486002)(966005)(6512007)(478600001)(186003)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AvOQtdde9e3eeu0o4833taxu5Q7lvbNgkQBqoEW6zfBR1D1bpQh5pGwh6x+A?=
 =?us-ascii?Q?Dn2KZh0q1iBQ04WfFha63vqxJ07tugc+vSLMM0lcbfCAdh/X2GmLw8gzuiXt?=
 =?us-ascii?Q?RMGHH9P5zuCmgeSoK/dGg22gcnifcL3rM77bUbnhgdlEQcFpe6JtcgUmOUXE?=
 =?us-ascii?Q?YTVDlNuKDBzzdnPks3iga4EYrWHcYqCU7BZBA7yeSzxzmRFwjkhrxIPv9HiA?=
 =?us-ascii?Q?gvedDXczmGUTjTeozN7wWLxLcVUnGYLPlcbM/na/zlRQ1Rkf0X7Hf24nPKQq?=
 =?us-ascii?Q?VPp3SMwmImiwrC+eldQQcBBvZHQMmNFoVNWmpMh4gJiE3c4jICm4kI+zt4Fe?=
 =?us-ascii?Q?yME2JZLIu8f9DUjZoXiBcePZ3vlAireIdnEOzVpSeeu++w5pHdOaSiaxBm8X?=
 =?us-ascii?Q?aFArVmzicpQWHp8O99Td1TCg6IYS/Mhg+Icxphq2G5a56A6VaGIFWJOqstdo?=
 =?us-ascii?Q?5d02WoTXeAJqvjPmXFkTiq6eNOJLAtqsAjmJNFHnyiYCPEWe4pSk6QRkAs/f?=
 =?us-ascii?Q?UYtKlh0z+MziTd5+r1D5oJfxY7voyWpQQmvk/EXLmxDePZlGv7eYA29tNise?=
 =?us-ascii?Q?8WPdDFbJwv3T5X2mD4qJRHDu9lwfCnTO0MOl6lzOon2D6oETB1OnCyGYSI2V?=
 =?us-ascii?Q?sb6isM+8KYhTLsxRxxyWtCs5zmAs3K+mO87xgY1wiByGZCuVO3bRVmb4Q09Y?=
 =?us-ascii?Q?0ubYDEj2F0rlu5tyoeJZDcftAwxEiwqlpnukUd5QfzgK5imdc74mlzO6UwQD?=
 =?us-ascii?Q?cY1EdEYgjHtMTDbaOvC+cGfCOf3GeQIgh0G68GQicZQScUi7prxzf8iI/WZ3?=
 =?us-ascii?Q?OVWv59vEQ5erM2Vzu5ZoCYoDk1MMABZFXwn/Cm622YKnp4LOUa0iSuUZjDoS?=
 =?us-ascii?Q?8m9yMs5iy+1kDb2yiSLSsoi/QlGDd6ejx363CNgGFyOAggp2ZGzfh4alOU0t?=
 =?us-ascii?Q?xMH/qn9tecWng26CRg/cnbZMbyJCCLLMq6IvMLl3AjUvMgSXbvWmuiytcJz7?=
 =?us-ascii?Q?zYT4qFS8TEcg0NEnyzaFF8es6rkP9u81jzhu2eULgaaoMDuSGGjqrr6QxfRM?=
 =?us-ascii?Q?DUddwk/NLETHFCt5WzT9XmS/3JYaqLp2N1skfTjKtxrO40GGvpBgnxxLph4j?=
 =?us-ascii?Q?e6Y7URz5UoSK87Eoj7UtHSG38uOUVf4ys3QXGhwEVSpqaxvLnOzhRlqjCyCW?=
 =?us-ascii?Q?iDM2+rEmTsiSGMzUO4VkIQ7HyGQAKZANLe/VOlInsch2Eoh8rv3cAOzhV8wT?=
 =?us-ascii?Q?QdsG6dDd7H4M6+iF39Fh6pXjgdOlVW6ZGTXJVGHKim8HmD1skmjPSgCh5/aZ?=
 =?us-ascii?Q?7s/iQBW5lXZZq7jTaQHIp2gXVbsYWlqdTv4QZ8pR/jcvXf16ZoU22pld05ej?=
 =?us-ascii?Q?TkdPbuJcQ29fOz+MueRbQtDCQwFwVZQV/ONNr5Gbch3bzBoM6L+zw/ui5unE?=
 =?us-ascii?Q?DwPdQcqvpZSYb4uQmScoGxRDfDXnQLB8w7EB5+fD7heAdN2Iz0J/Pb8u8HZA?=
 =?us-ascii?Q?eF6EMSGTSMuBDDy3DiJ0fbAvSM/Pcq91/TOnrXYpDICbaaGxR0/QkVrp5tRg?=
 =?us-ascii?Q?lKup+PwlevP91l14KhC0U/Nvt5DzWksCVLe6vSU6?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?LSDlExm7CV73fCbXsO9gLD86Y4aF3tRHlk60AQuZYta9V489nxH7XE/khAPP?=
 =?us-ascii?Q?5F73/Wx+RdfgZVlIAbzei2VwOG8waqFDsGgAaFDRAouEBlwX+d5ppmK6OTgZ?=
 =?us-ascii?Q?iGH8JPxOJ+aPD+8Ii9qX9WwbJpy567Qn7BywEhJECuDvyu3i3/gK3vg0GBMv?=
 =?us-ascii?Q?DUgWWMFKIDMyT9qoNhMvnkHkfIhfK/LYYS6oCi3OC5Sn0EyKjpSHiehPCiJ5?=
 =?us-ascii?Q?0anV6yM7KvqbQl+T6wzWNjXPU6vzTL4Q9VgzMwHwfHlvk9Fqr3NiBn8an+bz?=
 =?us-ascii?Q?fmOwKeamGoeQkOkbTPauC1UcaE3GewIVVV5L12tPA4kdHi9RSILSNr/9hOgf?=
 =?us-ascii?Q?kQwwBArWDrzOoSfENz5+Z6zA+pFBZNNZyV4pPJ2mL3rBi/UH+QOh8Lf6k1nL?=
 =?us-ascii?Q?9/D/KueLodKo+t8FuCMA2EUSxr/sBuc4TMmG81X6vrrXjCpNfnHIYdQXexx0?=
 =?us-ascii?Q?ucSkxuyfD6+PsLZabI4M86SjandAEJvjOJaYfLC5JwQUrR2sSwHus1AiB0Vs?=
 =?us-ascii?Q?+C6nw2h4EPw3tmjF9Z4zDVkRdE2fHhfgqDKTkoQpcP3l+b4pAH9pO7PAOIKd?=
 =?us-ascii?Q?9EivtGSY/dE9JNurCqXgYKH6JuXvWnI/dIoEAY9e0ibbFT/iyVObp0h8ZPNd?=
 =?us-ascii?Q?BF9FOfGeIXki32MxRSIGNat4TvdmZDn1o06k1uPAtbWrzxLL3x7+ZJ9eVewW?=
 =?us-ascii?Q?WFkhy3O6z5YijRFCM7gQkTZG/tM3qT610XlMGY1/itKyhn1dMhgf6aOiyzVN?=
 =?us-ascii?Q?8/GN02ChtcjUgi5NbJYqb1qLKHT9DINXQ/uTQrCfTDgwgp59jOEH9BZIsF9r?=
 =?us-ascii?Q?S4OQykEUnLeloSPxOgFBE19ZOuD1vQA2oX91TT+F3jKeWWkBQNWjh3NT63Sh?=
 =?us-ascii?Q?BCiqdAp7ouamg1SkIc9wRMT8DPS3DSFSlfollTJ/VWOVDXMTxmgUwv8SZnEf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f3a7f10-56f6-4293-0b4c-08daf577d023
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 15:06:57.1967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ukn7C/9hmeT5nHImjJZ7i/pjgP/hT5mXxuNcpC6q+5e9OTgcPEBLaBUq8Ghj11X4xDpBQ8iK9Ebed27/fSJ51g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_07,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301130099
X-Proofpoint-GUID: mrCJ5ac6zSb3nKTPasdpgS4xhhHTx8IM
X-Proofpoint-ORIG-GUID: mrCJ5ac6zSb3nKTPasdpgS4xhhHTx8IM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 03:20:11PM -0600, Tom Saeger wrote:
> On Thu, Jan 12, 2023 at 01:00:57PM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Jan 09, 2023 at 12:36:15PM -0600, Tom Saeger wrote:
> > > On Thu, Dec 22, 2022 at 07:01:11AM +0100, Greg Kroah-Hartman wrote:
> > > > On Wed, Dec 21, 2022 at 02:52:10PM -0600, Tom Saeger wrote:
> > > > > On Wed, Dec 21, 2022 at 05:31:51PM +0100, Greg Kroah-Hartman wrote:
> > > > > > On Thu, Dec 15, 2022 at 04:18:18PM -0700, Tom Saeger wrote:
> > > > > > > Backport of:
> > > > > > > commit 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> > > > > > > breaks arm64 Build ID when CONFIG_MODVERSIONS=y for all kernels
> > > > > > > from: commit e4484a495586 ("Merge tag 'kbuild-fixes-v5.0' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > > > > > until: commit df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > > > > > 
> > > > > > > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > > > > > > after df202b452fe6 which included:
> > > > > > > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> > > > > > 
> > > > > > Why can't we add this one instead of a custom change?
> > > > > 
> > > > > I quickly abandoned that route - there are too many dependencies.
> > > > 
> > > > How many?  Why?  Whenever we add a "this is not upstream" patch, 90% of
> > > > the time it is incorrect and causes problems (merge issues included.)
> > > > So please please please let's try to keep in sync with what is in
> > > > Linus's tree.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Ok - I spent some time on this.
> > > 
> > > The haystack I searched:
> > > 
> > >   git rev-list --grep="masahiroy/linux-kbuild" v5.15..v5.19-rc1 | while read -r CID ; do git rev-list "${CID}^-" ; done | wc -l
> > >   182
> > > 
> > > I have 54 of those 182 applied to 5.15.85, and this works in my
> > > limited build testing (x86_64 gcc, arm64 gcc, arm64 clang).
> > > 
> > > Specifically:
> > > 
> > > 
> > > cbfc9bf3223f genksyms: adjust the output format to modpost
> > > e7c9c2630e59 kbuild: stop merging *.symversions
> > > 1d788aa800c7 kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS
> > > 8a01c770955b modpost: extract symbol versions from *.cmd files
> > > a8ade6b33772 modpost: add sym_find_with_module() helper
> > > a9639fe6b516 modpost: change the license of EXPORT_SYMBOL to bool type
> > > 04804878f631 modpost: remove left-over cross_compile declaration
> > > 3388b8af9698 kbuild: record symbol versions in *.cmd files
> > > 4ff3946463a0 kbuild: generate a list of objects in vmlinux
> > > 074617e2ad6a modpost: move *.mod.c generation to write_mod_c_files()
> > > 81b78cb6e821 modpost: merge add_{intree_flag,retpoline,staging_flag} to add_header
> > > 9df4f00b53b4 modpost: split new_symbol() to symbol allocation and hash table addition
> > > 85728bcbc500 modpost: make sym_add_exported() always allocate a new symbol
> > > 82aa2b4d30af modpost: make multiple export error
> > > 6cc962f0a175 modpost: dump Module.symvers in the same order of modules.order
> > > 39db82cea373 modpost: traverse the namespace_list in order
> > > 45dc7b236dcb modpost: use doubly linked list for dump_lists
> > > 2a322506403a modpost: traverse unresolved symbols in order
> > > a85718443348 modpost: add sym_add_unresolved() helper
> > > 5c44b0f89c82 modpost: traverse modules in order
> > > a0b68f6655f2 modpost: import include/linux/list.h
> > > ce9f4d32be4e modpost: change mod->gpl_compatible to bool type
> > > f9fe36a515ca modpost: use bool type where appropriate
> > > 46f6334d7055 modpost: move struct namespace_list to modpost.c
> > > afa24c45af49 modpost: retrieve the module dependency and CRCs in check_exports()
> > > a8f687dc3ac2 modpost: add a separate error for exported symbols without definition
> > > f97f0e32b230 modpost: remove stale comment about sym_add_exported()
> > > 0af2ad9d11c3 modpost: do not write out any file when error occurred
> > > 09eac5681c02 modpost: use snprintf() instead of sprintf() for safety
> > > ee07380110f2 kbuild: read *.mod to get objects passed to $(LD) or $(AR)
> > > 97976e5c6d55 kbuild: make *.mod not depend on *.o
> > > 0d4368c8da07 kbuild: get rid of duplication in *.mod files
> > > 55f602f00903 kbuild: split the second line of *.mod into *.usyms
> > > ea9730eb0788 kbuild: reuse real-search to simplify cmd_mod
> > > 1eacf71f885a kbuild: make multi_depend work with targets in subdirectory
> > > 19c2b5b6f769 kbuild: reuse suffix-search to refactor multi_depend
> > > 75df07a9133d kbuild: refactor cmd_modversions_S
> > > 53257fbea174 kbuild: refactor cmd_modversions_c
> > > b6e50682c261 modpost: remove annoying namespace_from_kstrtabns()
> > > 1002d8f060b0 modpost: remove redundant initializes for static variables
> > > 921fbb7ab714 modpost: move export_from_secname() call to more relevant place
> > > f49c0989e01b modpost: remove useless export_from_sec()
> > > 7a98501a77db kbuild: do not remove empty *.symtypes explicitly
> > > 500f1b31c16f kbuild: factor out genksyms command from cmd_gensymtypes_{c,S}
> > > e04fcad29aa3 kallsyms: ignore all local labels prefixed by '.L'
> > > 9e01f7ef15d2 kbuild: drop $(size_append) from cmd_zstd
> > > 054133567480 kbuild: do not include include/config/auto.conf from shell scripts
> > > 34d14831eecb kbuild: stop using config_filename in scripts/Makefile.modsign
> > > 75155bda5498 kbuild: use more subdir- for visiting subdirectories while cleaning
> > > 1a3f00cd3be8 kbuild: reuse $(cmd_objtool) for cmd_cc_lto_link_modules
> > > 47704d10e997 kbuild: detect objtool update without using .SECONDEXPANSION
> > > 7a89d034ccc6 kbuild: factor out OBJECT_FILES_NON_STANDARD check into a macro
> > > 3cbbf4b9d188 kbuild: store the objtool command in *.cmd files
> > > 467f0d0aa6b4 kbuild: rename __objtool_obj and reuse it for cmd_cc_lto_link_modules
> > > 
> > > There may be a few more patches post v5.19-rc1 for Fixes.
> > > I haven't tried minimizing the 54.
> > > 
> > > Greg - is 54 too many?
> > 
> > Yes.
> > 
> > How about we just revert the original problem commit here to solve this
> > mess?  Wouldn't that be easier overall?
> > 
> > thanks,
> > 
> > greg k-h
> 
> What about a partial revert like:
> 
> diff --git a/Makefile b/Makefile
> index 9f5d2e87150e..aa0f7578653d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1083,7 +1083,9 @@ KBUILD_CFLAGS   += $(KCFLAGS)
>  KBUILD_LDFLAGS_MODULE += --build-id=sha1
>  LDFLAGS_vmlinux += --build-id=sha1
> 
> +ifneq ($(ARCH),$(filter $(ARCH),arm64))
>  KBUILD_LDFLAGS += -z noexecstack
> +endif
>  ifeq ($(CONFIG_LD_IS_BFD),y)
>  KBUILD_LDFLAGS += $(call ld-option,--no-warn-rwx-segments)
>  endif
> 
> 
> Only arm64 gcc/ld builds would need to change (with the option of adding
> other architectures if anyone reports same issue).
> 
> With a full revert we lose --no-warn-rwx-segments and warnings show-up
> with later versions of ld.
> 
> 
> I did open a bug against 'ld' as Nick requested:
> https://sourceware.org/bugzilla/show_bug.cgi?id=29994
> 
> If this is this is a better way to go - I can form up a v3 patch.
> 
> --Tom

nevermind

The patch discussed here fixes arm64 Build ID for 5.15, 5.10, and 5.4:

https://lore.kernel.org/all/CAMj1kXHqQoqoys83nEp=Q6oT68+-GpCuMjfnYK9pMy-X_+jjKw@mail.gmail.com/

Regards,

--Tom
