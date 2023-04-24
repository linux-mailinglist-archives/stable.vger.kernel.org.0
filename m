Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067896ED163
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 17:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjDXPbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 11:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjDXPbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 11:31:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFB33591
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 08:31:41 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33OBYdlw032061;
        Mon, 24 Apr 2023 15:31:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=2Edd2b/TEdUCHlj7b8vp72gyaAIsorOqWZeQ8Uwf4wM=;
 b=lW1JNmc5LsxfKebNvMozUvEhuPyo/y8mw+uX1IHob6jgOZYE367Gi5bBQJAFCSTESRnP
 PkoKsoyjE3NCPZH59hm02gIAxtiCOFy0/fU7grxdOeU4XmhmhAm8JwSwoBEUuxhN6W7s
 /QH3pyTI/iQ3mUi01iT9Z19cVlahOU8rr2TZaSNz3FnflRQWi5WAzNa4+oc4gOHlWOgG
 EBXRUZSBKu9Kfkx+ZLBzAJFwCRRqcsu4OJV4wi5nq4r3fzoTPBl7CQ/sZMuKVAMsfdoW
 Gkskn7/BVg5bx3j2Gy7llgLNMgo4GrHF0WpAZekUBulb3/IU/AA+IIfQUH1veahHcCa3 8w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q46gbk90v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Apr 2023 15:31:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33OF8qZA024874;
        Mon, 24 Apr 2023 15:31:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q461bew4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Apr 2023 15:31:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ua94z9oGX1xFAjEPLnwbTuGr4aAqd6LzLJNe7VX7Whp5Co3Phi+6FLS6gwHUjBGUAKq/Lym4TdWZply9qrjevLA2kIyczyUnU78ZY60hYSoV/peyKgXNyUmiLJ57oCqp9Zv3vxQ9Qtc89ZnyjRlBmOulZhO+aXcsr3+4riVL08avLpcogW2QDp+5jnqbPfDGgZM58QlYVTPWKeXMSKY2vtNn+Bprv3m7zS6g25pWGbU7I1Wo0/Aqdof0sVu0/NHRU4utJmw61MBtlB508F6C+cob9rQWYYTU8DQ4vHJoq+itQ8/fQJKMLuxmNi9veu3z4finIMqPCITR5UJTLkCI9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Edd2b/TEdUCHlj7b8vp72gyaAIsorOqWZeQ8Uwf4wM=;
 b=ZMQv5tfNc7YczdDwUxsAw1TeHqmwkZv50b8Cb1PS+IP1+QG23w3a4mu65wTLC/5ru87Vjh7Nhq9jRKK9Q+eqU066ffivDnJJm6vmJ0tJEVWJ0WWwizuc4prwvKw0FSJnB1ag4ptZwzUl9gz582E+h9/c7jP4gqRgHWnZStsRfOq8BSWb1GK8+o72+EVuOlLVnfIgB+a/rvO7RBGB//PujI2AI3S4Ntcvo9Eqd3LganDLN7YwQispG3E0lHXbVMpiTlPQf3uCoE9ThLCo715FHCw8h8O4L1PUrxjnFyqKoI+I56DshpiScjSiD/Gc+HtpNI1JMpgCRsyRXuWrlEMK/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Edd2b/TEdUCHlj7b8vp72gyaAIsorOqWZeQ8Uwf4wM=;
 b=a9mIvpXJ9W3lzzEQhSLCMVtDlFwTN+5jN0jKTuZLIEGF8gq33pxj1U/zSpzkZEe7TEtbhtA1cOX5kTSSm/jjQbSblJxx+barrRpiAH7sOff3VR+TrlelQckGqMiukZ5FXbcHxt/fPdWu5VMo3h7n+NvRbzJf8asjQfnvug3buHs=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by DM4PR10MB6088.namprd10.prod.outlook.com (2603:10b6:8:8a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.33; Mon, 24 Apr 2023 15:31:33 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6319.032; Mon, 24 Apr 2023
 15:31:33 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     stable@vger.kernel.org
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        syzbot+a7c1ec5b1d71ceaa5186@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2.y] mm/mempolicy: fix use-after-free of VMA iterator
Date:   Mon, 24 Apr 2023 11:31:08 -0400
Message-Id: <20230424153108.3354538-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <2023042253-speed-jolliness-682f@gregkh>
References: <2023042253-speed-jolliness-682f@gregkh>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0050.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::10) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|DM4PR10MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: a35bd3a7-faac-4acd-9c79-08db44d8fc13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tbP1uR/Swrx6TqFnRXddeE9kRV7pmIU2OO9nBENm+tCyJKloU/xXvPiuLUFfMf6JgJTAIJ8CEfIhHTqCyVaw/d7swwuwa9LzdQ7p+G/KnpJihP8gUonuWsWWo9rZ5Dj47IjIvOnZIBN7zWC9jAVz9vLvCUdPZprmtSLF/hfEvTKDFoiDa1iJTHb9BXYOT+FuPJK/uaTMsHD1Y0DumXkffigrrh+tqms3eAILJzd4MaaF+q3I0aRkb1iXtTVA7L686p4vGb5C1O+KNUldR0i8oQG4Zfph9QZ7SxWyQzOX60arcigYkqdtNCxxpvrngOr4FMrC6VWZdDp/QaaiChXgFbGeCgotyUxkNoy8+mpvRZs5XREXAO2YITyXPtPbH1Fr7mpb7Nnkhxajh9iFk6nArW4FeQgChghjFO4AzO2JEQ79km2wztzLio/ac1cat0ykqq+6F/5EbRpeCjhPKBCcEJG4oaDKdqnCIfWXmkKbm8MQ2GiZKfJmMqohTJvfJVEaG7yayrAYO5ZLDt6xGf1K0RyPOG+xNLoOscEJpHXWwB2RQQRI9Jk8Xxi0WmTc28sQbqNyMStCcnfALm0Fs5Ux/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(966005)(6506007)(1076003)(26005)(6512007)(2616005)(36756003)(83380400001)(186003)(38100700002)(66946007)(478600001)(86362001)(6916009)(66556008)(66476007)(8936002)(8676002)(54906003)(5660300002)(6486002)(41300700001)(2906002)(4326008)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9r6XSVVgHadG8n0Pb5nc2IK6r2Dcka4l3mr3GpuZJDLRf/YkEQSAEJfeT9pm?=
 =?us-ascii?Q?31Lw55RTgq65q1daCdBU2f1SJopHQk7aDjuoqTXh4vkQN1MM5LlQt/BpnKlp?=
 =?us-ascii?Q?5WnC7wW7z5RznQUC0/1aMZrvaHQEpAG3qzZDrC89PIr8y4pOtMQVMZ7x5EhQ?=
 =?us-ascii?Q?Nhyd1eytHvShXwLy0sulFe6SteqGUwVKIh31xPKsQx/dcn7mb07OvxVpAbu7?=
 =?us-ascii?Q?ycaoh2aUuYRmy9gwsLOzIUyHRXJ5jQRJJhoEr3q0KI1j018tsI8kMjQQeqL3?=
 =?us-ascii?Q?g58F/libh3CerZWAlYBPLSJHQAi6gQCTkDxTq4ZBmGupBFVdBTzI2flZ7tA1?=
 =?us-ascii?Q?1mQgXLoSg+8mU+wcaJ7zQq7JfUz32ljNOQauMaZq8GQIIHBTlXBBYYs6hKv9?=
 =?us-ascii?Q?ELO4mZr1QRbOdgmtLNcs+QL8C+YUS1NB4ZuWUtAcIZH/pNyCLu4mSsFG0OIX?=
 =?us-ascii?Q?HoVcBHBbcC0tZsc9xTuNzXKsqKhfuI6AwIe7kPUOy2y7lXd9T8PjfDh5ny1x?=
 =?us-ascii?Q?Dhvw/cXQkTuoAqniXfgiNGJ4YB1IwjHiGDFZdQFQWI3A7kKlr7ZKE6N7P40V?=
 =?us-ascii?Q?67HP+ttZTiCXG10YqvH4hOIHk06Sh6QZI9yiRO8mQ6GVIQKOyLT+4x/FNyyb?=
 =?us-ascii?Q?O//CEH4OfNv3gThEgKUvVc0G6NaEy21g4rWdHLIz1Qk9fRTnbn9OM8UD1szG?=
 =?us-ascii?Q?rV9FtQdfqfUZiI4zLRktTlD/eOiwAFKwa5/DA9oGjegSvMo9eQlyPQgOWa4o?=
 =?us-ascii?Q?e7pA1Ky7aHY/imgU+6JI1ubt+2DAxNhqToEYGylrFXFN4ppvaSJPlnLCizkn?=
 =?us-ascii?Q?kPRqPJRZbNs29q9te1mgVVaSeebOcjnP5sMlkgXPp8Ryi9/nIp6+tlu3REUp?=
 =?us-ascii?Q?DHSIonWMRpwpLV1sT4r6xbS0LmeLGFv2juSpw0xokj+Wz965pxFOSiGDUOph?=
 =?us-ascii?Q?eVw8XwF3jCCHt0ujqoKMBDLC3ymK0ngfCLDx0I5yfmUWqwiFVohLtagIPL5a?=
 =?us-ascii?Q?O7Cabqqpmp6j5RFlv8QsvS1LBsj7KaoxGoTx3DPxMEVKHfRrFpQajab0vLGO?=
 =?us-ascii?Q?Q61gX2qgNkGkVssvPVdFWnMg/OWOLlDEz9UYpB3Mw0qJzVu2XEPPVR3s93ec?=
 =?us-ascii?Q?mkPIR/e542xAqOz/trKU1oU9lNbvsjSFwFMV/9UNclWvd5wVe12C86YQoO4e?=
 =?us-ascii?Q?ERq4HDlPvdxuG/Hjrui3VfIhOzrK1jCGeevo+VGwmvcaOIK2Nrgt6cVyvmQu?=
 =?us-ascii?Q?Pmm/UcgAZFbBp7yBj6wK3odHKNZNIjufBeyl0+NT0KoWYO4kYsn/CmasyUL+?=
 =?us-ascii?Q?eBPbHjccm8MUXgklBZ7lHmZRstNcOyjIPG2UlkaeGQTnhpYKoSrtZDyp+HeT?=
 =?us-ascii?Q?Mil/AfdqyvTrkro+/o4j7EE5ooy0E7KWnm10fIRsh+qRwTA/QaPMPNIV9LR7?=
 =?us-ascii?Q?R9keLmED086rWRU3B6ydokO/+kJF32voMHg2KmeveGz7QU03DsrFxtI4UsoN?=
 =?us-ascii?Q?1UYK4iJt6p5wAY3FjxoFmwnJkLK8TJlHm7Mj1qoEIpX6dxSqPN58k7Tw3+Hv?=
 =?us-ascii?Q?w4x2ATj4GHyNL2kTnVNLX3RXtUdowSbfBLcSgVqT1XI8XPVQqm/p049et0oK?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: H7yFox2kHJzElSZggRNjAbZJVmxPpsraVxTCApBXmVMs1ZcxRExORshMxUGeFpiIKF+gpDtHh485Exaok+7qq6IPOlJ51uBi2Mwy5JN91ReMa8ylUV8L5XYlPvuUK8RfOULWC6hA44tzLJo9kReALDlGWe56vdiT50F88Cod9Km40ssdQDEz9pJCu/aJy7iRYqZo6DvmoM0DOboxir+HFdo3pQWD1G364HEN8VDtpfr+na4NquTa67Oq98VxCJgZTLf3Jg+++TZxKqRaGwhChLc4MH0IU7YaRXieOljHnbBOeY/gTjlTUPCwv9qzapQ5cNd3ae+sqJtfxUZifjIymJRB3jeBp7V8SzS38bOBAQVheprGrYFMYfUtjFbY4k5sKotRdBNLEJis3gZ1g8x42aOPc2mxhkwagd/IRMTehY+zMJaWL4oB4fK8kJTFDADPfvh4axWF0+zgy3ZbKbBtusTr9AYLPjY0K/vKDkmHPBOLDU30SyXL42dkNqbeip1hpWP59vDiPUAKpaj1vkoV5AGo8KPTE78w78BIMepOZCcFzfBGv4gxUBaNfe2ao9zHrmZTgIzmDqHsmYZDbvIAWJ/ab0ulvD1Prf9Lm1vrdk+zZij+eqh6rI/3MZmOkY+j3oDTtOXZCbHcshj6OpE/ZCXR33jX4aTuSLRKgPACOGc13+/qJIWeI+qm6QQ3j9k3gcsCe2ir3fsvLpQVZatyhQonzRmdnJ2FF8O3flbdHQu3JLO6iM9Eiihbz3Kb1hckUp4n//7pYpEdils3H44cQ9NYWpwL1/XkQEnb5dZk9Ajq2Ej80ZfYY6VDQM8Uv98FvjNR/GrORNS1+iRYYatEgnCqvheV0FpKq5n6MEgKhotoLgnlcNyr5+6D3PR/6+Et
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a35bd3a7-faac-4acd-9c79-08db44d8fc13
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 15:31:33.7171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E8aKDuQlLvNlJ5D6cikXW48pNfrwNHk7SWmytTzEClSgINlrpFmjs5LkAvumhbToY9SljeZDX9UI5Z0w2v6NOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6088
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-24_09,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304240140
X-Proofpoint-GUID: -xUTTigJIXsF4KrqFS5PuGwsr5k_xjY_
X-Proofpoint-ORIG-GUID: -xUTTigJIXsF4KrqFS5PuGwsr5k_xjY_
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
(cherry picked from commit 905e8727c6aca577a8151105a6e0912591649690)
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

