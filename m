Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B0866857D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 22:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbjALVeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 16:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238228AbjALVd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 16:33:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216591DF30;
        Thu, 12 Jan 2023 13:20:27 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CJXp1X031544;
        Thu, 12 Jan 2023 21:20:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=042dmnNfxxbrzdX8kfj0CWi+4i1aysRcNcNjCIIHcH0=;
 b=o6fBv9ZyCIK4H5PtFRtuWZof28E5GmKpBMEWxSZLWsF0fFBon5NjNQ/Or7JWZIS4+x2u
 d0iMkU5BqC8HUJSg53BFGPEB5UiXZoTjqgD6TMBerCVzXetFAfP5dGAql5m44z8+5lFp
 TuASaVVRMVnm7sYExr9afGE5qX5PIi0jvI4leOr0Zw2ANMX7ZQM7p6AUJxH+6ZD4FNsp
 62jiqr5r+0yzl+JKGKveQnWdZ7TPEfazmX/LOZKab3IJ19q0slUNjm0hdTd+BJF+l7M+
 UyP/iBdsMdqX1AtUhUxfqzn+sVvmRuWoiMJz2+9HSS9fKJSYLAQec8XZzhmIEUjk7l3G 3A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0sckd82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 21:20:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30CKE28J005251;
        Thu, 12 Jan 2023 21:20:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4bt0c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 21:20:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXehRWBUcYgPziPL89CGc2jn85FHQe7HSA6nqS8VxOppX6A0d1KjOXATprIYPJMnwAih550jJCR5RMTNij6u2lOKFx+DB9ew+S2If5vs9btfYEXe4eguiLlIxeA9fWmYioX1+cAyq9Jbl7YCh8pi+tWJFriq5Vg/0Ss00aekJYVBLOzfAA2NIjnVaILgW1BsDr7fg60HPCnU34kQSgj4EiuVNuwRmvnsuQMkN2fBXQErUQMk5flMQ4f/NmD6IjVb2qecyoKq8pvbF8P0qANewYiNT7UNaqgT5OXK5xjDhLur+pi1bTi7INihVtu6Pjn5uuGBuRqdtzL/lCTNt8VojQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=042dmnNfxxbrzdX8kfj0CWi+4i1aysRcNcNjCIIHcH0=;
 b=FMCEwZ5B8uW+04zVbnCbF2j3wnHjtOyIAGjgMYKSR18bxcUk/2Pg5wnVH8Qy4LBWARaWUwF0ME/iBK+wPc+WFnc2vae3omiSk/cQofi0n25N+5oAs9vmDlYZbsNV/MlAMjjI6QvbimR4BUo+jfxo+chRBW+aG2Mm34/aF0KsIXeN1Yd8NUbJ0breZ1+Y/MyI/GV54WtG76+DteZFQqOjxfZr4NO5wYuoEO3nHIh6uD2efdPNoywaGpCIGUdxSP9SoFZadt1auPW5C0JZ7/4xgjg1OBSd0vQiGlhdwik2mndtgHQ/Lga4awzmjGZdPwqRaM6Heg1UowrYKTX5ve9bzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=042dmnNfxxbrzdX8kfj0CWi+4i1aysRcNcNjCIIHcH0=;
 b=PUeaCInvfMkJpFf4FqL0OEUVPYjQiRc23tuG2+NNc+4/qJzg58UP7DbZFeVnAW93RIb/fT1F/3FYR8WaGyE98xCZqOnKXzK5TxRsPyF7Bc9DjSHmQURNfNXHFelvCHrUZvsxZlwXCof2LSPCB/tY1IYydoVO64yju63f9cwwg7Y=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CY5PR10MB6192.namprd10.prod.outlook.com (2603:10b6:930:30::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Thu, 12 Jan
 2023 21:20:12 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 21:20:12 +0000
Date:   Thu, 12 Jan 2023 15:20:06 -0600
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
Message-ID: <20230112212006.rnrbaby2imjlej4q@oracle.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <Y6M090tsVRIBNlNG@kroah.com>
 <20221221205210.6oolnwkzqo2d6q5h@oracle.com>
 <Y6Pyp+7Udn6x/UVg@kroah.com>
 <20230109183615.zxe7o7fowdpeqlj3@oracle.com>
 <Y7/2ef+JWO6BXGfC@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7/2ef+JWO6BXGfC@kroah.com>
X-ClientProxiedBy: SA9P223CA0017.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::22) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CY5PR10MB6192:EE_
X-MS-Office365-Filtering-Correlation-Id: cf40cf11-03fe-4e4e-e189-08daf4e2ca08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sTy9i1zQZyzs3l5taUcLEHGGf+ldlM7kzB4uBSrcpwJ/yCZQ1QGR+asiE2EJ5ahPbZb3kmbBM8egJkwVj3TdUq5kpXcEcwV6dmuuViMou4gI9XC1HGcoo7orG2AJP9Wf97EsM43UuWbIKV7eFmFYKu0HCWZGVMAgrfoaDlBudhTqrP0cp5XehxJ9zk1G5O0/FvvqQmY1by1IcnGemyWJhyrI+hGJtL9e5n2zcZx2WniQT22PDbqkGh2SeVoBj6KRrzBIxXshzituKJM6BhkBnNAfRO44NJXYaHYYu2n0Jq+B2hetLE2BzSOOoGhIWN+rvjXCxHAPIm7Y+hlkKZ9ULdxUtAgdqYODBHZACq5LYH5nxpnMHnzPMVrFD1LSsVb4Ny++Qad/Shb7//2q0Qeuyt1avR9HaVnWhZg8wpHxaFPx+aUvzmnMMyk4sfP1fzHJoeqMtBbPcugm9ORLL2fYd80aMKruMHIsDdxBj+JSXSKYqlzotQg0wLQKQNtxyupb/gm9Ll1Lot4xRejVsj6ZOaGupglcpwLTfm1bvHBgSOf4Cqt0udvBuUKcwttHZVe91KVjSw1sYrpHKNQYtmjj2ajfX1heRefmmi3Nx0YVagnN+veBEgraB48K16d9VeIy/rQw8J047Tj0OOM2UviBKU/CEVFFhZMyRgdc87VEaEE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199015)(6486002)(478600001)(966005)(36756003)(6666004)(2906002)(38100700002)(86362001)(6512007)(1076003)(2616005)(83380400001)(6506007)(186003)(26005)(6916009)(66476007)(5660300002)(8676002)(66946007)(4326008)(41300700001)(66556008)(316002)(8936002)(54906003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3ARgZPvEw7mgfOOoeFn3J879RfJCVq2L3apGxvN2WuylO0zPhENnrGGlbuWW?=
 =?us-ascii?Q?PjStPxs9YvawafheUUia+BUfEGDXuol81q9pg/dy08M7t1k7HsR17wGF/QWc?=
 =?us-ascii?Q?K+mvUh7sMzfzjpDLAJOl3SaFzTOBo0uraW93DxMzeVip6KZeCtHEzcut4TP4?=
 =?us-ascii?Q?WNVbtZdye52jvJO4KEkctAvoGY8t502QhhZr0/VcI2DaCyqY521XIgSqee4O?=
 =?us-ascii?Q?/V6zl9hnUmhiGvliS/Qexuw5yM6Air4FHOtejQPFEcKw1O5GQxRml96iWn8d?=
 =?us-ascii?Q?Tt8nTQoXoej+bXTuyYKnL+BQeSa49IPfIYCgmV5n5i5zm8bUrxnZMdgZndtI?=
 =?us-ascii?Q?eHXN+oclASon/df22f38NqPJdAhta/9TgXkQY1toCc5xVe80tiRHkArhTv87?=
 =?us-ascii?Q?2mtyhASgwlXA7zuqtcVe0M8H9NqeaQOvbjLmuzVk8DxR/GhDth736qb5z6Nk?=
 =?us-ascii?Q?yPMl58c04WXoQKv9sPwwIsfnCwOQUcyzoPQaUbI2ZNLVOzFz/iJ7Bi8iD7by?=
 =?us-ascii?Q?gE81fQ+R4GjrWUnMluThbfHPxk7+1B6CcUWRQhqADJDkC7ZuU3vgHS6R6X5B?=
 =?us-ascii?Q?tuof1bFcO2aSQDx8UHO/3o+uz3g9mKUfJ2VM2tsaIhX3vywailJtq8NpPrms?=
 =?us-ascii?Q?eky2c0vk0WBqQWMF8b9KQNkfMJkghmcHOHhk5yDpEIjffbzmDF2A2JH4Mlzr?=
 =?us-ascii?Q?ztpSVu/1o9UQJXD9j7M8Yke0KJCt5u8IWej19WhvE8/OcOFgTlZ4XQJlwVr9?=
 =?us-ascii?Q?4BxfM0KNbWeqxyprV1kXJyoERes1QjkcWjxRIreNN/Yo5fx2Ch3sZxrve9fD?=
 =?us-ascii?Q?epAx9SHeX0lvYL2YP3c9QOxnPNZnR+JQkQsET5Xl6Jb9s0p7Hy8Q8ipqcs5a?=
 =?us-ascii?Q?vvQmBG6LOM21Ybx+x+rywYe8jh6s/U0VOdbwyrkyR5NeA95YpS2T0OsrHe/P?=
 =?us-ascii?Q?NDqMsYq1ZuhAGkvGknwZAyrOlAir6bZrWoEhyCOLqH0bAIMIkQufExugTDdj?=
 =?us-ascii?Q?7eJw5lSRC5jmBIJ7K/J3fFIwEWkksu0Ol1+wygzGsTaU0dySPMxfi9oGsJpP?=
 =?us-ascii?Q?VmEnqbdIu+dMjtpFd52sJNXHbOOVlWQNObI3LoPOi9Z3zFu382oxP5TiNT2p?=
 =?us-ascii?Q?WZg1mLMCf8Vw+PYiWgr+nqbqXgsg3coD7dws7zTgP9HITDZH9GZMHqvO3hl9?=
 =?us-ascii?Q?oP/i7B8R5r3YnorRpr89SkNsOpntqnu8PHIG46vWDe721nY71UuGBGbJJcPE?=
 =?us-ascii?Q?prVLkrTnBMKr+mcsDHMrMwhGOxrwJx+DG+8ShB/JnB6pY2c1QvWK2RQNLn4W?=
 =?us-ascii?Q?tDEGtCub2yUb+RTOOeCQnTzJcaftikQgNWN7pOQ/vk0AtZiBkLgG3GSdXa9h?=
 =?us-ascii?Q?hAa5EcBw21Zw0xgUbXBswtvUJV/1wazZVoecidpLtlfKELD+reDJQyPDQSyZ?=
 =?us-ascii?Q?sgzHo0WgTLGK8dvLW3OlGSYW2WGNxprb1mKCyyNNBFVNleIOgFy7aOA/588U?=
 =?us-ascii?Q?sRk6EIVgAqXEgfzv2pTY9JNIKHbkSGTW6JWtuWO8gNdpIchEbQNA5Lrfg8lJ?=
 =?us-ascii?Q?OeZSLenTDJCueW6piC5DMkUZpPq0pj1PGIE14e3n?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?U88p9ObpRttSMjYFIFm0KH9SdQB7pRb3NYOu7T9z6t8xbPuqx2sDJEibedam?=
 =?us-ascii?Q?zpW7NSDp0eQ+7CIwkJF3BWdB5tQRo4uteZ4CxSXYSVAd77ZXf9cbdf5kJlPh?=
 =?us-ascii?Q?i8hnip3p7n989oeGE0TTJR9d93hwt/GIQEH+vWftcaUZzg4l149IVygpla70?=
 =?us-ascii?Q?A1f5EiF2rl0560iCRlg3q7R71NHsCR2hJLtQ149CEnJM29sYgQYWa52XckyZ?=
 =?us-ascii?Q?WL94XSiFEp+doNDp19YIkHuMdnIs9nqZSmx9GCJGt7Ja2Khn1Gb7kZtmKVXd?=
 =?us-ascii?Q?ANIxuIslsimyPDlqlNeoC/gzHoskLXfCK+ZiTbJiwgRpslYr5gbowT2+N0YV?=
 =?us-ascii?Q?T6jHRWCbpMiHCcppL0Ba4J3MenCP0iIbSZfs69IQ5xMJz3shCPxbhdE/DUSo?=
 =?us-ascii?Q?pvxkloKeRiRYhLBR2hfsUUp49q23b/pe6HFYV7wRuSmJYNKo0l2cL3AwIiq1?=
 =?us-ascii?Q?8Ta3Ith8ByTXl8uVTthgOdHlgKShYIbKU0iVNa8MO9LM4yk5YUSxLm0Z8ryg?=
 =?us-ascii?Q?Xk2hNSVcWt2BmQXlrL0KLuUWJwxuBpFJpC2g4lElZaTsQEygFkvkk2GjG05y?=
 =?us-ascii?Q?Zpc9ceCItczdVUG4o7gFdFp3wI5zCbRlzj2uGFmjiYHV9EswUoo7RyN39juB?=
 =?us-ascii?Q?cbEvPB5zwdo+GU6Whe/of42turn14ggcHISWX9HIbkTGUadv0lNslYTz+j6z?=
 =?us-ascii?Q?t7TS8Io4U/2NmRzi3ei7MJXk/LVXJxL5IQIqcM+0yWD+r3r/9YItcz0mJ5EE?=
 =?us-ascii?Q?9J3d3BMWOSIloYG1xAZbD8XhrFfd03vqIV12ErxagolJceevUBgYbI+9u1vk?=
 =?us-ascii?Q?vMCNe85iz+p3JJxIrIpQEOoQFPQiJk4R/WtvOI/B/L0XR1tSMZrEDrCdCTFo?=
 =?us-ascii?Q?yEkiArckgpqjlJ992M9OYWVtVttXzV48fXrJa8HQt0SW3nQ6gzD5Yrrxurp+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf40cf11-03fe-4e4e-e189-08daf4e2ca08
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:20:11.9618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0JEZAFt1Y/1cVYhwLn8XzJ57DV146gkv5Ljcrnt7HpeseV2u+k1QrNrK7N6bArC3Xinl7lsQ0EUTYsigk7J6sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6192
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_12,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120152
X-Proofpoint-GUID: pFRvB8jb1Qt50BNpLARizyTGuTeBpA8b
X-Proofpoint-ORIG-GUID: pFRvB8jb1Qt50BNpLARizyTGuTeBpA8b
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 01:00:57PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Jan 09, 2023 at 12:36:15PM -0600, Tom Saeger wrote:
> > On Thu, Dec 22, 2022 at 07:01:11AM +0100, Greg Kroah-Hartman wrote:
> > > On Wed, Dec 21, 2022 at 02:52:10PM -0600, Tom Saeger wrote:
> > > > On Wed, Dec 21, 2022 at 05:31:51PM +0100, Greg Kroah-Hartman wrote:
> > > > > On Thu, Dec 15, 2022 at 04:18:18PM -0700, Tom Saeger wrote:
> > > > > > Backport of:
> > > > > > commit 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> > > > > > breaks arm64 Build ID when CONFIG_MODVERSIONS=y for all kernels
> > > > > > from: commit e4484a495586 ("Merge tag 'kbuild-fixes-v5.0' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > > > > until: commit df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > > > > 
> > > > > > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > > > > > after df202b452fe6 which included:
> > > > > > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> > > > > 
> > > > > Why can't we add this one instead of a custom change?
> > > > 
> > > > I quickly abandoned that route - there are too many dependencies.
> > > 
> > > How many?  Why?  Whenever we add a "this is not upstream" patch, 90% of
> > > the time it is incorrect and causes problems (merge issues included.)
> > > So please please please let's try to keep in sync with what is in
> > > Linus's tree.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Ok - I spent some time on this.
> > 
> > The haystack I searched:
> > 
> >   git rev-list --grep="masahiroy/linux-kbuild" v5.15..v5.19-rc1 | while read -r CID ; do git rev-list "${CID}^-" ; done | wc -l
> >   182
> > 
> > I have 54 of those 182 applied to 5.15.85, and this works in my
> > limited build testing (x86_64 gcc, arm64 gcc, arm64 clang).
> > 
> > Specifically:
> > 
> > 
> > cbfc9bf3223f genksyms: adjust the output format to modpost
> > e7c9c2630e59 kbuild: stop merging *.symversions
> > 1d788aa800c7 kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS
> > 8a01c770955b modpost: extract symbol versions from *.cmd files
> > a8ade6b33772 modpost: add sym_find_with_module() helper
> > a9639fe6b516 modpost: change the license of EXPORT_SYMBOL to bool type
> > 04804878f631 modpost: remove left-over cross_compile declaration
> > 3388b8af9698 kbuild: record symbol versions in *.cmd files
> > 4ff3946463a0 kbuild: generate a list of objects in vmlinux
> > 074617e2ad6a modpost: move *.mod.c generation to write_mod_c_files()
> > 81b78cb6e821 modpost: merge add_{intree_flag,retpoline,staging_flag} to add_header
> > 9df4f00b53b4 modpost: split new_symbol() to symbol allocation and hash table addition
> > 85728bcbc500 modpost: make sym_add_exported() always allocate a new symbol
> > 82aa2b4d30af modpost: make multiple export error
> > 6cc962f0a175 modpost: dump Module.symvers in the same order of modules.order
> > 39db82cea373 modpost: traverse the namespace_list in order
> > 45dc7b236dcb modpost: use doubly linked list for dump_lists
> > 2a322506403a modpost: traverse unresolved symbols in order
> > a85718443348 modpost: add sym_add_unresolved() helper
> > 5c44b0f89c82 modpost: traverse modules in order
> > a0b68f6655f2 modpost: import include/linux/list.h
> > ce9f4d32be4e modpost: change mod->gpl_compatible to bool type
> > f9fe36a515ca modpost: use bool type where appropriate
> > 46f6334d7055 modpost: move struct namespace_list to modpost.c
> > afa24c45af49 modpost: retrieve the module dependency and CRCs in check_exports()
> > a8f687dc3ac2 modpost: add a separate error for exported symbols without definition
> > f97f0e32b230 modpost: remove stale comment about sym_add_exported()
> > 0af2ad9d11c3 modpost: do not write out any file when error occurred
> > 09eac5681c02 modpost: use snprintf() instead of sprintf() for safety
> > ee07380110f2 kbuild: read *.mod to get objects passed to $(LD) or $(AR)
> > 97976e5c6d55 kbuild: make *.mod not depend on *.o
> > 0d4368c8da07 kbuild: get rid of duplication in *.mod files
> > 55f602f00903 kbuild: split the second line of *.mod into *.usyms
> > ea9730eb0788 kbuild: reuse real-search to simplify cmd_mod
> > 1eacf71f885a kbuild: make multi_depend work with targets in subdirectory
> > 19c2b5b6f769 kbuild: reuse suffix-search to refactor multi_depend
> > 75df07a9133d kbuild: refactor cmd_modversions_S
> > 53257fbea174 kbuild: refactor cmd_modversions_c
> > b6e50682c261 modpost: remove annoying namespace_from_kstrtabns()
> > 1002d8f060b0 modpost: remove redundant initializes for static variables
> > 921fbb7ab714 modpost: move export_from_secname() call to more relevant place
> > f49c0989e01b modpost: remove useless export_from_sec()
> > 7a98501a77db kbuild: do not remove empty *.symtypes explicitly
> > 500f1b31c16f kbuild: factor out genksyms command from cmd_gensymtypes_{c,S}
> > e04fcad29aa3 kallsyms: ignore all local labels prefixed by '.L'
> > 9e01f7ef15d2 kbuild: drop $(size_append) from cmd_zstd
> > 054133567480 kbuild: do not include include/config/auto.conf from shell scripts
> > 34d14831eecb kbuild: stop using config_filename in scripts/Makefile.modsign
> > 75155bda5498 kbuild: use more subdir- for visiting subdirectories while cleaning
> > 1a3f00cd3be8 kbuild: reuse $(cmd_objtool) for cmd_cc_lto_link_modules
> > 47704d10e997 kbuild: detect objtool update without using .SECONDEXPANSION
> > 7a89d034ccc6 kbuild: factor out OBJECT_FILES_NON_STANDARD check into a macro
> > 3cbbf4b9d188 kbuild: store the objtool command in *.cmd files
> > 467f0d0aa6b4 kbuild: rename __objtool_obj and reuse it for cmd_cc_lto_link_modules
> > 
> > There may be a few more patches post v5.19-rc1 for Fixes.
> > I haven't tried minimizing the 54.
> > 
> > Greg - is 54 too many?
> 
> Yes.
> 
> How about we just revert the original problem commit here to solve this
> mess?  Wouldn't that be easier overall?
> 
> thanks,
> 
> greg k-h

What about a partial revert like:

diff --git a/Makefile b/Makefile
index 9f5d2e87150e..aa0f7578653d 100644
--- a/Makefile
+++ b/Makefile
@@ -1083,7 +1083,9 @@ KBUILD_CFLAGS   += $(KCFLAGS)
 KBUILD_LDFLAGS_MODULE += --build-id=sha1
 LDFLAGS_vmlinux += --build-id=sha1

+ifneq ($(ARCH),$(filter $(ARCH),arm64))
 KBUILD_LDFLAGS += -z noexecstack
+endif
 ifeq ($(CONFIG_LD_IS_BFD),y)
 KBUILD_LDFLAGS += $(call ld-option,--no-warn-rwx-segments)
 endif


Only arm64 gcc/ld builds would need to change (with the option of adding
other architectures if anyone reports same issue).

With a full revert we lose --no-warn-rwx-segments and warnings show-up
with later versions of ld.


I did open a bug against 'ld' as Nick requested:
https://sourceware.org/bugzilla/show_bug.cgi?id=29994

If this is this is a better way to go - I can form up a v3 patch.

--Tom
