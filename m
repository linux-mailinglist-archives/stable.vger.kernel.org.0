Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D10F6ED0F4
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 17:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjDXPI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 11:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbjDXPIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 11:08:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5EE10C3
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 08:08:49 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33OBYiMu015037;
        Mon, 24 Apr 2023 15:08:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=HNhUaL4egu/CFSeCAZ187DCVbA+NeZI6ica3zwiwsGc=;
 b=rlij3Bkp7WaIUFKUvYVetSeAjwBYlPu9JKkB0zD9L0NH8M3RDMSCxEOihRQVlfLzvayo
 H+p+tOOVrQWOcairDnPNUF1iPYVxsV4MxjQvcfC6jbjNZqZ8+VWn2MJm7vkjYj1eu3Ei
 S3ket6xAxOshwvOLk0igknTZSb8CIzNdmjjL9daIe30PwnAFkxqcpcydxpEflAQYJeTN
 YFuCJtipxZdYTWE7qDlxq/g/sEKn+C3B7HpI+VNdISXxuTnJr+9+1VH0ODZbz+TE6EZF
 kfeCIAYJ6fL9GX1fs38r+gnqvI+ES6LSIjr3/LJQCQwEgT0eLxfrDwy/YP5hO72N/HAg Vw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q47mcu4ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Apr 2023 15:08:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33OEpmZd007413;
        Mon, 24 Apr 2023 15:08:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3q461560dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Apr 2023 15:08:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2BW7N47SBD7u5ezPdepY5echoUR7wtuTxVKLlDVRaELjk5i3P0v2124+VBrt/nKDPFVl4Jc+kL1h4f/S3WetpiIouWdLuNiyCaLjtuv6Giw8frquVOUDATtsazFo4LqKaUGiXWotp67Y7IdGdzWpFlvZox4KqvDX7Efi1MFmvsN0VQ4LNc6xx2aETlSs/5vd1WyOYwujohYRn9Uj4mdnlbt7/gtpIjryD+TDTzMR5IxaInTZTEj+tkhEBzdKwB5ikvT4cC+mYO3sU3SA18utnBF+8ntTpGoGZLt4ihPTTz+IZgEpS9+9qsobDg5s1ml8dOfHm0IIgPZy29+oMiP8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNhUaL4egu/CFSeCAZ187DCVbA+NeZI6ica3zwiwsGc=;
 b=MP7N23m5U4s90MZTthv8+Ql8bqqtNXbun/yR9PHs8QVkQlaOaH/uv2/N+BqonGTNDNWz78CoCplYOB/dXsfQi/LCtc2WOMCXYqoiYEHUwFjsGbiY2URuuaNu2/T7wItYCHVNNHUtgJupGQ7PwHtchI6zy4wmT+FKw84553IKXpryBGDf5wgBJfx7sWT2xIiLTMtkAeJZc4k7p9SejdHlJo0N36hwD0u9BnvXTTJR75Lssjhbxwa0YePtuyqM7cfzsz+rP7EFNZfV5f082CLBicjL6fzb4slX4K2IRZalaf7+GIiPDpVeq7NM4MhWqicnszj4CKPJy9VrML8M6gKZHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNhUaL4egu/CFSeCAZ187DCVbA+NeZI6ica3zwiwsGc=;
 b=EbRKQQLZpZ05baHAlMAr7Ef/HNF/A6QCGkGlHlU5dVNlhESfVD5iS3AIWHnslOKzAUdHuL+TzJ6w9KSoP2UfyCQJphrxXxAbWsKzDvnHMauFshYqGR5XuhzoPD7hM8REd/duJBaVOxkWxeMIVepkWiVfNCLkzqfNMPFlWDkVO6c=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by MW4PR10MB5882.namprd10.prod.outlook.com (2603:10b6:303:18f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.28; Mon, 24 Apr
 2023 15:08:40 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6319.032; Mon, 24 Apr 2023
 15:08:40 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     stable@vger.kernel.org
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        syzbot+a7c1ec5b1d71ceaa5186@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1.y] mm/mempolicy: fix use-after-free of VMA iterator
Date:   Mon, 24 Apr 2023 11:04:24 -0400
Message-Id: <20230424150424.3278348-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <2023042436-smile-upwind-5931@gregkh>
References: <2023042436-smile-upwind-5931@gregkh>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0137.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::16) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|MW4PR10MB5882:EE_
X-MS-Office365-Filtering-Correlation-Id: cabbd16c-e33d-4254-3e76-08db44d5c9b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uTDIT1TOcP9JMd3rAT0KS/oYg/8rTMn0N6RIp78qOb0DnX5xJ+Z9hibnlO/pYOuKaJpOyJeUHrXI6M0C1hx7BijLpU/S63kE1sWbwM2vIUhZD4A7y/uFRuYz1XCXYxbmtyD0vNjEk0AJa7rtGQQTARLqH/Gaf9R+IAQdw3zE2Zjx6nVbr6LiZkD7Q/1jfCMOf8F5641QC8++FfwR9EdJ2xROHYT41FO8eMwBQowFw7JKQJF1C6si1Gz625YD7MtgcbDTKmIS1LqD3fIrj8UdeGjGi46HohQfSuoe85dru3xha5P3RBSeOezQy6ps9M81HpdTbIFStImz/72E68RAkhR9B+GwaAehLb1Y6OZRykRWExpcAF0JSwz/bsWHlm8TIM5sMdH0pfwdWN2wspCjUF0nBXaytOXz/rTFVlRgiJdhdmzvxQ7HRiVV9//SC5L5XUvi5/WGw4qw8S7OqfGdtK8xFInpA1hfn4lgN74StpHQt4+/LNIvzf/cAjlPZwDyo2qntSZPnY35cbVpUemKJ8qKGhHgexrQZz09sgi/JOuwHasmF3MlMhjgGAQKKV9vfZd3Dr0FBE2/EY3gUTYulQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(366004)(376002)(396003)(451199021)(2616005)(83380400001)(5660300002)(2906002)(8676002)(186003)(26005)(6506007)(1076003)(6512007)(38100700002)(8936002)(6666004)(41300700001)(966005)(86362001)(66946007)(6486002)(36756003)(478600001)(54906003)(6916009)(4326008)(66556008)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sneQwMiODt3+OYUnTFhzK/kzygkJV4RYaUM2Jyeo4p1AbNNu0wCZYw5FhHOW?=
 =?us-ascii?Q?/bcUFzojOyATc/BjYSp5B2eSXWcp/9I7LyCUT92CMDW4nUGG3+G19VFeMfHt?=
 =?us-ascii?Q?ZZDp99WP9bXZqpbrjhfjpA8jeodceaO8p9cNRKYfdMR9gAWTVGQltByoxPrU?=
 =?us-ascii?Q?Lu3ZUAvhaiZEDu1g30ihRIK1qmigNUj0gFQiHYaiQIX50VESzOD/Keu9z4Aa?=
 =?us-ascii?Q?HgTD0K+FEbXgkTtd98kyGhdFm/28oDMOzb0qRZzlV/jlRZ1QQYsIZ/xcOcra?=
 =?us-ascii?Q?xKdAtAFC8ITmMjD8SdRAMccYot/HuEsIUn6rwD60s5WNjdhzJQQkq3aBu1XD?=
 =?us-ascii?Q?VDvzrF9BBmBM8jxXGRGpJQHe29OX4UCjYN783F5KtzG0BRobsNO0Ktiy5ik7?=
 =?us-ascii?Q?WiO5Dv/uGvS1OSxFl/LZOwE2s06cWqm+QMOLLBJufQ+pxmbSp8tX/t/X9dZI?=
 =?us-ascii?Q?sQhMlLAW0D9LX6SATGHleHYSoVWK2Yqk1HpQcmOxnXYO4bdwG3tACfXB05ev?=
 =?us-ascii?Q?nYsKa5GGEEJAWpRXUVE0nXie47OpQCt8bzUXq5/1sbVJPZElnTIJrk7Xl5CC?=
 =?us-ascii?Q?esV9N3okKOSx4a4E6Kze7h6rZ5qLEF1MKxeAsw5oVecfe7NtJyDXAzM7uoak?=
 =?us-ascii?Q?F11TQhoHhHbmJsCGikEWjd+DnOkrgnfab1unvkp9AYVcNQWV2oWlIIuWRQfT?=
 =?us-ascii?Q?TB5wZJId0fwICd3W0eojDQaypOJqvBBJGOutgMasSHQf64p7cBM8JguPtPG5?=
 =?us-ascii?Q?GkXZwWC58Lw5KjADndghGdu+pK1aUPnB94MtZRE2wnykSXZruwdXi3QYPs7m?=
 =?us-ascii?Q?axaJ+V1CAohDehgpZNhRgttWrH2uy/ulZnFCKSmz/TSZm1qLb/OuWyTwilYo?=
 =?us-ascii?Q?flXIfeOimz3DvIMWHtsWL1/XHqZzS2y564rxKysjz8hQ4T3ZuPEv77jDuYet?=
 =?us-ascii?Q?Go8H30xYt/6ll2sgsPZcAMQYAGIz4ahee2JkAZ8/y5UxMUuOqpgva3U40QDu?=
 =?us-ascii?Q?T0TlKrZqWzjv0clrSp7y2RUaEDK4+KALXz0Zp8GaPXMJLUd0iMv2G5UxCKwk?=
 =?us-ascii?Q?s85ZaL0gpDwEE1rrAQsZiCpxHKXXZwb/vot0ubEWDJ7+TZ4kpJXa7kk07+HM?=
 =?us-ascii?Q?1a7u0C/tanqKv4bv+cYF5dr6wyvCouhb+aKpYFNjl7T0g8eV4jsJfjdvHxVk?=
 =?us-ascii?Q?5HO9ZGFMZQ3n9Pk6HkZ6znr/qeBr33m8A69OGNeR2WsLnq2+K9GYmgparGUw?=
 =?us-ascii?Q?1A400NNd3LNidpyhtuQQx/i80Tf+r4HlPgC8EcqWyTcPwrhVKQR0WeoRdT2X?=
 =?us-ascii?Q?2+QWTR2jcQL6jtkTZ7V0pdPCbExDBU0tHxsgZNkfetpgscdYw8WXO3i+2Hce?=
 =?us-ascii?Q?E5Hob+SeBr1Cz15n99FTh9fDSAXpjw6abC/qpKrnTeJYvulGQKYn1U78wwqt?=
 =?us-ascii?Q?eBJlgjcRWYtGZ2oHdsPGK2ftwXhUowWicMZBChJrvqEQaUxaVtQXJI7g2sKA?=
 =?us-ascii?Q?/1h+LNCVtRHejKYnBH+VY22bEJSxfoubUqlFJBHTwunaMJ7Kknrq8UHk/uc7?=
 =?us-ascii?Q?v542F+lbea6nMgKRu55hiFCHD4c4bU9aayrJR01he4ooeQWhgqmSML5inR9Y?=
 =?us-ascii?Q?1g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: f+esPF6dLt6NRN0wRCXY6XJecdgueRatSI9HRddlLsFlq9q1GwD45af78XbQg9dmLBwsw7Q86w1XSN5laYv4K2ZQ4LCaC7KxI9RO+2g3kTYTqm1w9JV2Lv5vFnO5/uQQSy4W4WBkS1uYJdYyZiOQF2LFDN2OnmPJ/LRIhdIjXC+RzumQgbZpHJfibb7yn+gIu81ilEuMl57QyN0Atv1HfHXx8Cb4Ei0TVMo74yNlf8NuVG7KKZ/rVwx+ipmQaHhF+56MZCnA1CWOsKg7WKBTctMdyS1ooWIReXQNXSBxxinZzJc/YlWkYFjhCvjI7XCpAfIkJwBNqxoUhMXqLp3gnTe3jWJV7kUy2QaWXs3Lt71sasOUPg2e157lMRLGTaynxv+oIv9BxoKhU5D06bYSXqc+27g/V7A6rtxnnfrUxc0sLwCqafXcEXrkxb81+PDgr9ag9gJts17K+c33WerfN4iCx81Ihpwm3k9/mgS9MRA3uuxYnhBsMuzZjLbUIespgNGPwGEl6c5Gep7f9imZMq0UbAbW9H/kC99fAJcodsBuIC+iPp+RBtKih+tpS1R8efpR3G7tuEiePb4JtD+YXNpn+WrAeO8gjR9t6B4XNqld/mV8yCXWXnlAtzXEIIdutHSOvYdrKKr4CzFQdVZmscSZZ5ncAQfZieFV4Z0ElXc2K/oRtpcKe7On72Wf07Fyajp7umOsdxjvqpjysgHu+OHfhK3B0FnjHTzzHVqS7USsczDEcKrV8PArLhXs/eBzyalJ59p1f691pC4KuPiVzkB9gmDhYwqyJHC8iGN+JgGmqnKBSzGA2gNOGi1GPhi1UZM2WTzBnTQIEoB+Md6vCAm2iU1pzffNR07wXftwoPvvI6T++E5gTWJeWae1i5Iu
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cabbd16c-e33d-4254-3e76-08db44d5c9b4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 15:08:40.7083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BXIfck8s3a2xqsVh9wV/HbF3Bcraxe2vODA7i17tDG4WTSNxfMUTtDLnlt39fvJgCreQs30lS8lzJkU4gJF/Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5882
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-24_09,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304240137
X-Proofpoint-GUID: XHIf1FAZxbacJOlVA4lZQDSnMzoxcn3r
X-Proofpoint-ORIG-GUID: XHIf1FAZxbacJOlVA4lZQDSnMzoxcn3r
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f4e9e0e69468583c2c6d9d5c7bfc975e292bf188 ]

set_mempolicy_home_node() iterates over a list of VMAs and calls
mbind_range() on each VMA, which also iterates over the singular list of
the VMA passed in and potentially splits the VMA.  Since the VMA iterator
is not passed through, set_mempolicy_home_node() may now point to a stale
node in the VMA tree.  This can result in a UAF as reported by syzbot.

Avoid the stale maple tree node by passing the VMA iterator through to the
underlying call to split_vma().

mbind_range() is also overly complicated, since there are two calling
functions and one already handles iterating over the VMAs.  Simplify
mbind_range() to only handle merging and splitting of the VMAs.

Align the new loop in do_mbind() and existing loop in
set_mempolicy_home_node() to use the reduced mbind_range() function.  This
allows for a single location of the range calculation and avoids
constantly looking up the previous VMA (since this is a loop over the
VMAs).

Link: https://lore.kernel.org/linux-mm/000000000000c93feb05f87e24ad@google.com/
Fixes: 66850be55e8e ("mm/mempolicy: use vma iterator & maple state instead of vma linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+a7c1ec5b1d71ceaa5186@syzkaller.appspotmail.com
  Link: https://lkml.kernel.org/r/20230410152205.2294819-1-Liam.Howlett@oracle.com
Tested-by: syzbot+a7c1ec5b1d71ceaa5186@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit f4e9e0e69468583c2c6d9d5c7bfc975e292bf188)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mempolicy.c | 115 +++++++++++++++++++++++--------------------------
 1 file changed, 53 insertions(+), 62 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index f940395667c82..e132f70a059e8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -784,70 +784,56 @@ static int vma_replace_policy(struct vm_area_struct *vma,
 	return err;
 }
 
-/* Step 2: apply policy to a range and do splits. */
-static int mbind_range(struct mm_struct *mm, unsigned long start,
-		       unsigned long end, struct mempolicy *new_pol)
+/* Split or merge the VMA (if required) and apply the new policy */
+static int mbind_range(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		struct vm_area_struct **prev, unsigned long start,
+		unsigned long end, struct mempolicy *new_pol)
 {
-	MA_STATE(mas, &mm->mm_mt, start, start);
-	struct vm_area_struct *prev;
-	struct vm_area_struct *vma;
-	int err = 0;
+	struct vm_area_struct *merged;
+	unsigned long vmstart, vmend;
 	pgoff_t pgoff;
+	int err;
 
-	prev = mas_prev(&mas, 0);
-	if (unlikely(!prev))
-		mas_set(&mas, start);
+	vmend = min(end, vma->vm_end);
+	if (start > vma->vm_start) {
+		*prev = vma;
+		vmstart = start;
+	} else {
+		vmstart = vma->vm_start;
+	}
 
-	vma = mas_find(&mas, end - 1);
-	if (WARN_ON(!vma))
+	if (mpol_equal(vma_policy(vma), new_pol))
 		return 0;
 
-	if (start > vma->vm_start)
-		prev = vma;
-
-	for (; vma; vma = mas_next(&mas, end - 1)) {
-		unsigned long vmstart = max(start, vma->vm_start);
-		unsigned long vmend = min(end, vma->vm_end);
-
-		if (mpol_equal(vma_policy(vma), new_pol))
-			goto next;
-
-		pgoff = vma->vm_pgoff +
-			((vmstart - vma->vm_start) >> PAGE_SHIFT);
-		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
-				 vma->anon_vma, vma->vm_file, pgoff,
-				 new_pol, vma->vm_userfaultfd_ctx,
-				 anon_vma_name(vma));
-		if (prev) {
-			/* vma_merge() invalidated the mas */
-			mas_pause(&mas);
-			vma = prev;
-			goto replace;
-		}
-		if (vma->vm_start != vmstart) {
-			err = split_vma(vma->vm_mm, vma, vmstart, 1);
-			if (err)
-				goto out;
-			/* split_vma() invalidated the mas */
-			mas_pause(&mas);
-		}
-		if (vma->vm_end != vmend) {
-			err = split_vma(vma->vm_mm, vma, vmend, 0);
-			if (err)
-				goto out;
-			/* split_vma() invalidated the mas */
-			mas_pause(&mas);
-		}
-replace:
-		err = vma_replace_policy(vma, new_pol);
+	pgoff = vma->vm_pgoff + ((vmstart - vma->vm_start) >> PAGE_SHIFT);
+	merged = vma_merge(vma->vm_mm, *prev, vmstart, vmend, vma->vm_flags,
+			   vma->anon_vma, vma->vm_file, pgoff, new_pol,
+			   vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+	if (merged) {
+		*prev = merged;
+		/* vma_merge() invalidated the mas */
+		mas_pause(&vmi->mas);
+		return vma_replace_policy(merged, new_pol);
+	}
+
+	if (vma->vm_start != vmstart) {
+		err = split_vma(vma->vm_mm, vma, vmstart, 1);
 		if (err)
-			goto out;
-next:
-		prev = vma;
+			return err;
+		/* split_vma() invalidated the mas */
+		mas_pause(&vmi->mas);
 	}
 
-out:
-	return err;
+	if (vma->vm_end != vmend) {
+		err = split_vma(vma->vm_mm, vma, vmend, 0);
+		if (err)
+			return err;
+		/* split_vma() invalidated the mas */
+		mas_pause(&vmi->mas);
+	}
+
+	*prev = vma;
+	return vma_replace_policy(vma, new_pol);
 }
 
 /* Set the process memory policy */
@@ -1259,6 +1245,8 @@ static long do_mbind(unsigned long start, unsigned long len,
 		     nodemask_t *nmask, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma, *prev;
+	struct vma_iterator vmi;
 	struct mempolicy *new;
 	unsigned long end;
 	int err;
@@ -1328,7 +1316,13 @@ static long do_mbind(unsigned long start, unsigned long len,
 		goto up_out;
 	}
 
-	err = mbind_range(mm, start, end, new);
+	vma_iter_init(&vmi, mm, start);
+	prev = vma_prev(&vmi);
+	for_each_vma_range(vmi, vma, end) {
+		err = mbind_range(&vmi, vma, &prev, start, end, new);
+		if (err)
+			break;
+	}
 
 	if (!err) {
 		int nr_failed = 0;
@@ -1489,10 +1483,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		unsigned long, home_node, unsigned long, flags)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma, *prev;
 	struct mempolicy *new;
-	unsigned long vmstart;
-	unsigned long vmend;
 	unsigned long end;
 	int err = -ENOENT;
 	VMA_ITERATOR(vmi, mm, start);
@@ -1521,9 +1513,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 	if (end == start)
 		return 0;
 	mmap_write_lock(mm);
+	prev = vma_prev(&vmi);
 	for_each_vma_range(vmi, vma, end) {
-		vmstart = max(start, vma->vm_start);
-		vmend   = min(end, vma->vm_end);
 		new = mpol_dup(vma_policy(vma));
 		if (IS_ERR(new)) {
 			err = PTR_ERR(new);
@@ -1547,7 +1538,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		}
 
 		new->home_node = home_node;
-		err = mbind_range(mm, vmstart, vmend, new);
+		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		mpol_put(new);
 		if (err)
 			break;
-- 
2.39.2

