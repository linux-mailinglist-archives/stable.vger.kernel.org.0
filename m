Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CEA6CADFE
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 20:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbjC0S4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 14:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjC0S4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 14:56:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CA91BC5;
        Mon, 27 Mar 2023 11:56:09 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RIjNB7007121;
        Mon, 27 Mar 2023 18:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=oqMjgSECbhb2ee2JdWQ9pJO51J5IQJ32f74Nn5k9DEs=;
 b=MryWMl8KmznXf0RDBWUh3j4dFjj5X6fVozqSIxMmS/Gp4lMUKZrtOdN1KWAbNUDS2MlO
 KiBTYULfzTH1mO3jEGpG1jF/R0D0QlDtOz2c4zo9Ip/IEhsbiK72SviKZ/t3IvVwsKzW
 YQZoZf7LRf8TKJZk+kOrp70YOgXNUPpRdzHr+Z3Ck9OTjw0s6pcBCRxhHRgobeuqqEbI
 wsTZ2usQrnBKrTBzENKfRlE8qRsdtZzTyCE/13LkibEc5qElSWRB0SsMK5KerRiNXMlt
 l4Jg89paqIsn+DMJSWqbMBqtACHdTmuwPbB+hTHi3QStyECXmfmz+KgBjyG3GV3+B7wk +Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkgpmr26k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 18:55:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32RIcRVv026831;
        Mon, 27 Mar 2023 18:55:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdbvywk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 18:55:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tc/vypS27vKDWYj7s/1C4DNccNZ0exxTQ2yyEqn9T3szwZuAJZ6IlOwla9RlLpHBFtZYol82f/TydLiqmx+aeI9zs5r2VSFuhCwjdC/qboqD9CGXFgjxyVgtkyyJwvxYdSZ0g3VoUW/FMuVAkLfPR9HrjYw87imKZzK0P67WFVcC6Py20bHA9rc1x0/FefI2Q/0okHJMi7LXurXdiAazbYfJTgJGVLi9NOpmRKngb2R58YSdaJRRa5dJWGbzF6eijDOjr9+mLNFDRNMwtqU1AVqKSGL4TJGpkh6SHEY34DLL5LNnZJT5OdZ+ht4yoBqSYSXQ67o9xnwUgfndNGXLew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqMjgSECbhb2ee2JdWQ9pJO51J5IQJ32f74Nn5k9DEs=;
 b=HSAR8jW9I0G2F5lrPOI4imsKXIXWdLjF3zhFbg9QQ4Ju1ZYW6qRHVSO8ATImlOES4YitBVlIV64V1FwJNe2wMpIYDRxSp+o3PmUQn740amKp5YwL11SRBSXlt2nq19NWW+HHO/eY1aKPkT52VPaJmEAB4udVAUiDNXse4dFM+LlIXTOEf5ylBRvCZqWJsjMFeKwsPIZe34uB8haYHw7aRio78bFArDFeOGQ+lS0BE5RgAmuQzKa0/BqoAZ94Xs7k//5fcyKruB8SUkWCs79egbKiD1Jc5PIeB2JNvwReITCj5n+rBVmlxDkywbqv+mPFcR60gGQqBz+eUEIC8XRYCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqMjgSECbhb2ee2JdWQ9pJO51J5IQJ32f74Nn5k9DEs=;
 b=JzE9gptEgPzkjyz5ZD739tT3VkB+KzpFL7LvSsHGsu19oEooWTbxxavA0Jco4pxRr5wgVfEZrEDFXXTGy0Pd1TGKE4h5tMXmxKTm0FRM9DgWRS8dHaYRVof/+peG/Z3p0PI88xMO7F0wOJbIR0UHJoMk6nQ27IINQQCDwzbtLzQ=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB5722.namprd10.prod.outlook.com (2603:10b6:510:126::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 18:55:55 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060%5]) with mapi id 15.20.6222.029; Mon, 27 Mar 2023
 18:55:55 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>
Cc:     "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        stable@vger.kernel.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
Subject: [PATCH 8/8] mm: enable maple tree RCU mode by default.
Date:   Mon, 27 Mar 2023 14:55:32 -0400
Message-Id: <20230327185532.2354250-9-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
References: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0089.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::20) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|PH7PR10MB5722:EE_
X-MS-Office365-Filtering-Correlation-Id: 6608797e-bcf7-47cc-94c2-08db2ef4e4b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3b4xqWDOETz46XBJJ1S2jHl8fuSd8So+0hx400NPHVXNr8EgMhM9WcBaghbRm/lghs0BYDm7JJg62lSaVhFQq/mYxmwSGSfsyXHc07pubm6EFgMq86kptOQuiFq0KdiJ6ICDOfcZ96OwMPBGlKgEPfJEIj08O8jkNHhaNFVAqHB8F96cPnU+X+pGhYhjzAThKEas9P5+HHHxfF+ov2GgwSXrZO9Fdt7vMWHzXsDZ7vVim/ifESZ+3hQ/i+G/4Yh/ScBFT33G3h4PPbooJenvaZTnjoGjIo1xBB6fTHp68VtgnKhVLSANBzZC+1aE9+C5PzN3KzUjHTXZh5xqAF4Coy0J6Mel665M4Pwh2SfEDY5yqW0FF7w92zTGlRJHid8RV7N+phSccX349FaiBXf7FH1S2gU4I1OHFFrP2mAxi7hArLM2LJjzpjceeIAaCFvxK9d3XLcExg25YYKCBc+uRamWtUwuRJG8PKAbbQF2oNUPh7TgY0miSmcc7u3uPgN9wi7Ck9YxQwjRNTdbJ800IaPlhOl/twKcuVAPZeKirURLOQiP3uQTG2z+02yt2kfkUI4vnc+YItLTIxQ0Rywh8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199021)(2906002)(38100700002)(83380400001)(36756003)(5660300002)(41300700001)(8936002)(86362001)(2616005)(6666004)(110136005)(54906003)(6506007)(1076003)(6512007)(26005)(316002)(6486002)(966005)(478600001)(186003)(4326008)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O7LXugZrmMHK6qfGDNwkmMBnlCVdpgBHW3OvNDPxh5peACG79WYhghZCDQnZ?=
 =?us-ascii?Q?GtzWtkFbUjZfKmcIfiNeW474bQ+IlQbmT5cWp7KiLrmR6n/LXXu1iw95ATc4?=
 =?us-ascii?Q?h8eVsiutstWptNIPWmweVD1UK3NYzGFRjz74AtKsoXK7t7IH0bNBS3iqrrhn?=
 =?us-ascii?Q?f5Uzz9rJipS09FMckG0ui+mXCvV56CtqwoXiUfePuTDo6XiYRMsOj+Cnkfmq?=
 =?us-ascii?Q?RQ0OvrEWATbKIMxMpOcIgD0XDLR9psF93QSRh2P7wosI7ha5xEPLtZTZjNng?=
 =?us-ascii?Q?Tiq+EW8TSXVgoe4jJjJs35G3rZaGqmWaBq9L40VDqq8vtVK8XyXWIrmLSUHe?=
 =?us-ascii?Q?SpU397vCBDOy01Qfdmvfdtext88ufmbiWDou2WH0ztjoaihBcwi86gJxxuhA?=
 =?us-ascii?Q?wup28ZjdSecgSNTjSUpagw8oLSrUDU6earr9V5u+AONSu4zTdjfT+oDQj20H?=
 =?us-ascii?Q?BLyT+14F0Qg0RCJCtsRW1O7pn9UiVH/ZysHRvjjUwmsf5LEgRjH/+IoI9R52?=
 =?us-ascii?Q?VU8GtXNu74LlHiJ1VjZCSInNZx4dtbEzieF6n39eG0pa1ROR7Hjn24S81lAT?=
 =?us-ascii?Q?koLZoduClCzkNVSzSDMICogHYQzDO39hNKuBjJd4N8kr5RpQ1/6zJ6qgyYxZ?=
 =?us-ascii?Q?hcyUkZZvtLL9iSprKC58X9lBPtapzukSs9RzOJTGAhpO4b1vrFKgyPLSgEDN?=
 =?us-ascii?Q?LTZb/Rx1Y9nrG4NXltDP5byqZs4XyTZ72YxOrGmsH3dXAQuaBhumuz4bU3S8?=
 =?us-ascii?Q?6wQVn8cETZymadhvRE9aO2zZOWdKvz4Gnq0C+ByYLT/S3JiA2qjXP2hlTZ2B?=
 =?us-ascii?Q?uhBTtHOJQ9iK8xHKUh91AcovSOiCZXux2W1Is2viqX0Wzo6E3acevFKwSdYi?=
 =?us-ascii?Q?QULrOnWIxHFXpN9I8jXdEBlNo6ZVkNWXwWp86NmBgQG2yfYpiGcRsrW5Opn0?=
 =?us-ascii?Q?bJZIq2XeeAANngfXYli/F7FN0VsAf0j9ZhyWQ12R33VDPyk3ebiTXo0C7ANO?=
 =?us-ascii?Q?uE9sBJRyXSGoqJY+jaZfZq8S6zabXb5AaMP+B+ErLuEh4idughuIeOh5sYHC?=
 =?us-ascii?Q?EqW9f2JWyb9IOK6WKPpIAIHquo0m/av95bPNUAix+YYp7ZozYx4kcMtI9n87?=
 =?us-ascii?Q?qjLrQcgsQUPhnlw94LM6c5sEB7QPBASASJf+XJFmQW9QJSnudzAWft+ikCa2?=
 =?us-ascii?Q?326H36TlOqi6g+yoNf0YBgn9hX5p3fzL8LbQVTx9H6PsUkPXfVRdISvyJXeq?=
 =?us-ascii?Q?2QvQP6eqzB9DK9HrIdgfSqmHmoxPd0gbdYv8N4XrqF9HePEsOcwyL4ZFqqzf?=
 =?us-ascii?Q?iMw7ubr0/RyjQtFfi6FtgfD0SI1osVYfn3ov34oIJOkOxtO7CnYvv/gOL/5P?=
 =?us-ascii?Q?bsw5mn7EY1VnzVNrKjGpqm0KDFlEwRfhYroZigOPgBw42RSRc8vq99xiBTsb?=
 =?us-ascii?Q?0pozZRPH4Jx3z9OdkzNMajyUGB98TxX33brcgRv/3tolId07S7ok/4zzea6E?=
 =?us-ascii?Q?djxnCSkQAdzUVAYK02PFluW1OimaoG6Bf9bYRw4AnqqJPF9AObMoZg4WM13x?=
 =?us-ascii?Q?5eFsEsBL20RTHaxSV4m207ap7MfpX7wnFyUknibplQbgEYON2hi5XF2FLJ8v?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?dGruqNlnqqEx5TK2EwswUyii8dTXcTjaYv0c/QYUrCqVnQs8vi9LDqfO/Htv?=
 =?us-ascii?Q?cJmNFW8YsiZ7ipMoYbDVo28yDHOTHbLucs6MZ135zN4WyHz5xIeF9lEK+nd7?=
 =?us-ascii?Q?Vtb6LYqpYeidMqJcQkGwEIC7qzuVPWfUypswifH4sZaStMnrBqBeGdG0UhUD?=
 =?us-ascii?Q?s7ocJlISwzG3PEZIIq13If0mwLqySNG5qyh3t/p3TdCcqSIUEfVxUnf0Mheq?=
 =?us-ascii?Q?5dZWoFLC7pPd4RQDn48sBByHCG+TRaNJm9lpUXuI/VfMUiZQRvXFFWu923TP?=
 =?us-ascii?Q?1acanrUBLumoZ2zAX5QFkkIgDelJFsBSoSLSBgAGQbhBnghQ+a26Iyy3r4T9?=
 =?us-ascii?Q?aPw6E5mx0qXuIEbewhLT2rtNNNlRpiHGwv49glbpg6uLX9hCo0BloVLRpyz2?=
 =?us-ascii?Q?W+FZnPwrImQqPJMKYmEPbOIbnYe9CWQNcRNEvUTfXUkdyjYVIOZfTKcpkVle?=
 =?us-ascii?Q?yHgcd0S2PyY39kdihClM80kFQ+a35TzndiZqtWKxBeHGC17cSSl7BqKwWXKW?=
 =?us-ascii?Q?B4xBWP3Xb07pRjCWyeDEcVgu8ZifmMhYPp0r1SMjms7OY1eUcA6GLQI5oumI?=
 =?us-ascii?Q?5mFFlJxQLuoK+wErrkXVwkuZeR5eZMNvlYrix55grOUIRVlw4KKf0bKZmojG?=
 =?us-ascii?Q?9gLLVGjrLR1HoJjZxgm90+20Hy21aaJ39t4QvJ68mQc3Ec3X5tVK/TW4G4sY?=
 =?us-ascii?Q?JAXnA7q8l+yNFMth0mtbScuGozXAILoetSRzYXhnd1dQHdF+AXWJDlUT9xk/?=
 =?us-ascii?Q?7Xd3Cssg/jrLGyHBqY0/oBmQ89Lc6F9QPmypkW0dRuJj4y0YXB2d0ES9UgnH?=
 =?us-ascii?Q?PSTSCkaFzBxaUGct4eJqrD0wKIbD+86UvVQsZp92pjsy/FHzUolYu5S/fUaA?=
 =?us-ascii?Q?6FM3xT3V1+8zSEHW9N+y5nTegaNVserD2zKPSNBHSbxdpv3c+cl9Hol3Yhct?=
 =?us-ascii?Q?KT1t2uqclC1G64SxTpMRg9+YQlJQRVSXbJby3HtY+LpfS2C9EGnzsb8h1MTU?=
 =?us-ascii?Q?dABuO6KRUmw05US8PQ+PtP8ddQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6608797e-bcf7-47cc-94c2-08db2ef4e4b9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 18:55:54.9055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bsvs+oCyozlh35lJ69iBDHCeM19ykRk3ToUb8sneOtdTcvJz1fspGecjup31rcRyUnFdp9F6+Cv279prOaJPlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5722
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=436 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270155
X-Proofpoint-GUID: 3R6cOwk1anQb4C3_qvpqgQRBQ5NbA7Ce
X-Proofpoint-ORIG-GUID: 3R6cOwk1anQb4C3_qvpqgQRBQ5NbA7Ce
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

Use the maple tree in RCU mode for VMA tracking.

The maple tree tracks the stack and is able to update the pivot
(lower/upper boundary) in-place to allow the page fault handler to write
to the tree while holding just the mmap read lock.  This is safe as the
writes to the stack have a guard VMA which ensures there will always be
a NULL in the direction of the growth and thus will only update a pivot.

It is possible, but not recommended, to have VMAs that grow up/down
without guard VMAs.  syzbot has constructed a testcase which sets up a
VMA to grow and consume the empty space.  Overwriting the entire NULL
entry causes the tree to be altered in a way that is not safe for
concurrent readers; the readers may see a node being rewritten or one
that does not match the maple state they are using.

Enabling RCU mode allows the concurrent readers to see a stable node and
will return the expected result.

Link: https://lkml.kernel.org/r/20230227173632.3292573-9-surenb@google.com
Link: https://lore.kernel.org/linux-mm/000000000000b0a65805f663ace6@google.com/
Cc: stable@vger.kernel.org
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
---
 include/linux/mm_types.h | 3 ++-
 kernel/fork.c            | 3 +++
 mm/mmap.c                | 3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 0722859c3647..a57e6ae78e65 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -774,7 +774,8 @@ struct mm_struct {
 	unsigned long cpu_bitmap[];
 };
 
-#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN)
+#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
+			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
diff --git a/kernel/fork.c b/kernel/fork.c
index d8cda4c6de6c..1bf31ba07e85 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -617,6 +617,7 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	if (retval)
 		goto out;
 
+	mt_clear_in_rcu(vmi.mas.tree);
 	for_each_vma(old_vmi, mpnt) {
 		struct file *file;
 
@@ -700,6 +701,8 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	retval = arch_dup_mmap(oldmm, mm);
 loop_out:
 	vma_iter_free(&vmi);
+	if (!retval)
+		mt_set_in_rcu(vmi.mas.tree);
 out:
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
diff --git a/mm/mmap.c b/mm/mmap.c
index 740b54be3ed4..16cbb83b3ec6 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2277,7 +2277,7 @@ do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	int count = 0;
 	int error = -ENOMEM;
 	MA_STATE(mas_detach, &mt_detach, 0, 0);
-	mt_init_flags(&mt_detach, MT_FLAGS_LOCK_EXTERN);
+	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
 	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
 
 	/*
@@ -3042,6 +3042,7 @@ void exit_mmap(struct mm_struct *mm)
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 	mmap_write_lock(mm);
+	mt_clear_in_rcu(&mm->mm_mt);
 	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
 		      USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb);
-- 
2.39.2

