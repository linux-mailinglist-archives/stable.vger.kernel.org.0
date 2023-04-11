Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96696DDF3D
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjDKPNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjDKPMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:12:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364C75BAC;
        Tue, 11 Apr 2023 08:12:16 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEwu5G022973;
        Tue, 11 Apr 2023 15:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=70WhY/iq4hVIgzn5mnWWfTDRC8B2eF1U3/aQ9O7MvDI=;
 b=Nt/9lQGWr2s0aSfo5j7j1whv4To+jX/PCjDSYkTLJzTa0HmjM8pEOY7FoQo26bThcM42
 jQizf6E6qrnFUY4S7I499KD3BN9zhmTBR3/HOkD4ri6QpcvoyqIkxBGoa9PfxliUJUfO
 eitcZ4JsOJNTbuX22rf7IORLNRWduj3SAy9bGeRkpm6bl+p4fxmZOg5nwCT3BxAGuxb9
 keRijE8wtZP+XQ/HamMd0o6ul/CSFGKiDOHwmPXLpK0qucj2+BBXLgQBhOSqTkB1FqIL
 LUFQ4M0DFDJ+IaGEy5LvjC76+j9ENFb+mMGbztMkiHkQqGMfVvzUvA5aSqvW51lqxxxx eg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bwdrx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEStdU030608;
        Tue, 11 Apr 2023 15:11:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw918dr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWJz3CBGCUwEBKNIX6EOUaPEbcaSDUy/go7WWSesaUt7uv47D71zq0DkEa1uCOOLez86FmA50FwhfXmwCvKxrHrPe21lhpTOC2UHSv5MGdG0hKsOw7X+sqp2mbdlePkXbuby4OAY/RiavyolI+6aIx0XPm7Yd+iWQ2dj9zBmmRJCug6ePSieMyTBfHSpcDYvHHhuiZg4C5E6DmbTl72yPBFkEMMg0zm8Vsact7mEbE9htUZwpmsaQQiaMsnqxuTUcEE1KHSAhDEWKy1M140EOe5oKYMUDg4P74QmErHWrUpJRBypUiE17BnmcXXwUqgajiBTHDzlck1BpNKYnZsmVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=70WhY/iq4hVIgzn5mnWWfTDRC8B2eF1U3/aQ9O7MvDI=;
 b=GUx92sEljHQDI4KO0kcjcF6EbRijoSZ3ebMjNiZcv3UjmzZrw+SCE8Li06Cmu8otg/590rV08Pz0K3JdpTyWncfMgo23aO8xAiow8mnloZFV3QkA2nRvvG3auqeu4Xiot6CHJgZMC1veLL0663S4g0CkJBj8XLHLR8VtAjd3ZwiPO/0URdfDNuGL7AjCS34q07jTYvKRudRnzIvdUZ0ba/Y9s2DNTTCXVLatRihzjz7E26jyltlRn2PFZuJLijHN0698Q86Xa/g2cyktBG+OZghoCh411VMPbXbhKgTDmOUZXyVjIjd0e+g6o6JfN+yq/j69O16JSoYHvwX8Pr3Mgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70WhY/iq4hVIgzn5mnWWfTDRC8B2eF1U3/aQ9O7MvDI=;
 b=h7/VlL1BvYaWT9DVnaszhRBpjPHCe3kse3C15MZbBJBinUlTWW0oOVVZfmA24BqiCyJEdNZfRYWQR0fI1URtlFgNidGpowVip5da+VYNkltnsJ+EGWPwC6UhAqnxXLLZUMjq3Qx3bT0gZC0ypSbcIyAmWLq1FlRRNQsWTp41yR4=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SJ0PR10MB4718.namprd10.prod.outlook.com (2603:10b6:a03:2dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 15:11:52 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:52 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 13/14] maple_tree: add RCU lock checking to rcu callback functions
Date:   Tue, 11 Apr 2023 11:10:54 -0400
Message-Id: <20230411151055.2910579-14-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0067.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::22) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SJ0PR10MB4718:EE_
X-MS-Office365-Filtering-Correlation-Id: 047467f1-c50c-484b-6880-08db3a9f146a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KBCHEVpx8RIybaWGLBhwtWxc+xprB9MGMUCgqi5FYYtg4JRCxi9SlUNhM+/Xgw031FGdwCu6yssNVjDkM0lYnHXG8IGyz2vnOcDrzlRNEKVWr7mvrHY3GWUzvJp/3l3AgniKMald3LDASFiWONNFSj8LMj7Qfh6LxAkgYnUzQCsiQop5GthHDvvjmYcQIZSLbFqUKqVkuDqnHDWU7bq4bqSFnIv+3NPQN/K3sEg0VOWhynKOex4dtAdnDByda+TMFnze7pky11tFBfV0U0t+M4Q6nlfbdbKbUF2hvd7IKxX+vQu7aDyU5sx7Rh6JokGUJotoh/aI1dQxnRWcZnkYiLYBbq8oKuxP6zyE4ygmLZ4LHPSQFVkrtuQ2HFkTrI+p3yQRtGJ8fXXbtKoWa2SCLC7qusTUi9tL02z0EDsF1ZoyNaoLJC/EuXzWR4mbNnjpMxvFU68K6G0Wm5A+VGL2dDM0owD/EV7xAnsAD+OkadBCqGxsegRJrAp3jGTosZPsDLEU2UJj65QwXDa/ol84KzD2WO8/bokS+mXYEL+Lsy0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(38100700002)(6512007)(30864003)(6506007)(186003)(26005)(1076003)(107886003)(2616005)(8676002)(83380400001)(2906002)(6486002)(5660300002)(8936002)(966005)(36756003)(478600001)(4326008)(86362001)(316002)(66476007)(41300700001)(66556008)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?loKj/4ArXykzEwrjPHZ8MD0tP9Di3lrDsp2xdLl75MHTkQCarv8bd5lLqrdB?=
 =?us-ascii?Q?Vwf+rG7b5oTMEU7qWal5/Jd63ACpltWgN+Hsqdxzl/e6uSvY4Y1cGHiVeqrl?=
 =?us-ascii?Q?EHY7kywc2V4vNzJYRpLt+bv9ONte2l/GhI2RPu/QtcywbnZ64uCH3ciPtjFT?=
 =?us-ascii?Q?m/TzdelrQE2GXUFCQFRKglw5J8TFQR/DysHck7mz1JVrZSlBscYsdi40T/as?=
 =?us-ascii?Q?Kl6nNFMCupg6ErOXrmk2viSJa7XnGpYUWb6KPQgSDhgp4b3VcrYfz3DlmlbM?=
 =?us-ascii?Q?5Zkixq73YH8+c9sqG2WKoOq4hGSeUaiyRhI/rYw1ZgOJCxOP6wcFYoFAKdrU?=
 =?us-ascii?Q?dq9barv+EmWQrO797gI5Eu2kcAAMpT2KmjhSZOJbZzpRFWXNYIWdurUsf3uG?=
 =?us-ascii?Q?Tgr9rVrk/cOkZwtCyUTR04ew2j2ny3OxuDiRVKh/SvUroR9tmlGQTrL9U33f?=
 =?us-ascii?Q?fFAk2jwGYyobEVhY4mikz3CwfSVPBC9whm8dvsrNzFML+xaQ6SsLWisTD9At?=
 =?us-ascii?Q?iKPpL9zQ3ufZJqeLwpLeKSLVWLfmEUdEJKt4rzovwkrXidxEBX+3YJ9tZAG/?=
 =?us-ascii?Q?eN0kdSvQWSqB7DyVYtDLNc+G3LkgCJ041Pwhe1XlirAtiwNN0lw7HUOkpUzp?=
 =?us-ascii?Q?2X1XBNTpV53jC6BVtceB/E6DoB7JOhLsy0NxtA/4IlN+cPb3dqRpWwXg7+uc?=
 =?us-ascii?Q?il1J38wyhcN7/L5qKDPCxkzq98cknuOUuPDWewBweARdGOn+ba3TEeqt7E8j?=
 =?us-ascii?Q?6oCCsyfpEj+ttLVF1XLqMgL/z+3gaAPuaDIqB1dIl3kssG1fj7VOjTVVSEVT?=
 =?us-ascii?Q?BH5SK44uzUTd4VIcOOuxU5+zaTKApQ19DyfJrH+BzsiP51fKa3H3Zrvrk5VS?=
 =?us-ascii?Q?88JNmzFN8Ua1OiJYl7Hbs0lPmbWujIrzbMe726qkFyDhF48qStXsCr2wr3fm?=
 =?us-ascii?Q?vwHTQ2j96qBxtSR602t7DzushPW+uH745ZJfNmmdPVmN1c113ORr+jnZ5K3t?=
 =?us-ascii?Q?KtgJZE24PQs/MZnsMw5kY2l409eQrTESrnwYoSOb9XMqYqRGhyQ0ITRpKYrd?=
 =?us-ascii?Q?c8r284yHvX1iyxk2qZ1y7EHuF4zuEG/x06GCoUl9MUPVYGQg0YlOpTUs2Otr?=
 =?us-ascii?Q?gc+UDjj7p/DZE62/WekKer3m80ctLYbe7ykDJC7YwltrTHawkNTkd6NwFMpI?=
 =?us-ascii?Q?RElcTkUwzgcbHXrIp/hB6Bi/q5svvtNBIWF2MY/Lk6z9UC9bgkM3FM8v0F0E?=
 =?us-ascii?Q?fmVYIvr6MYq98OcVB2DgpSvJue4ydWt4yjVW9Lh+fATJZ6Qp8VcjVEUumYAw?=
 =?us-ascii?Q?NPGuq66E2W6SJ2JQT07mXF4bUu2hDA62YIgh1DcRiaNnYx1i8JjtNPc/DSoc?=
 =?us-ascii?Q?xRkgJlY4D6e7o2usJbCNKr0sE/0/ISslJWSL2eTpgqH7ZB0RRZ1nn8npdFcy?=
 =?us-ascii?Q?BAfAGWwf+ZDIHL1StgW2ayrtPvW8EFnW+jp4ZFTdNXonSmeewwgJCUfIETG8?=
 =?us-ascii?Q?zdcOR19m0RpMfnXIioHcvLLgk5/x5PBt13YkP/sjVypWyNBzaam/DDGik1+z?=
 =?us-ascii?Q?1uR+J7NfPjipxyVELhZ8juX+uqg0+MCxUXegdMBw/sosvyVVl7Wcdb8yJkRT?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tjqavJt4Pq7zw9IV0oxgUnvVR8msKJCZzbOSpKBoHeYxXL99PRCCuRnyvjFUsXDpnpeuYSuqp7rDGTld9snDnWcNfuw2EaxLDYVkJorYJP+86OzE1S3+av54ZT7moAShWnED81505kAoicfwXm/bcjavLRJjKgoVlAglMMDEGLjCpyYbu3FxVkkm4Rgm2ixCp4ueaeVG20Krt7VwMVNz7Ozde//U7UJRBHp1WXtVERR9iEVMnH/cfIACYuQW5+ET3JNinAHFUBoeEPHIoIsWfbCgrr6N1spJ5sv+cNGaHGchHVfrTwaoc8CdS4MoYRwUxdR3NOlHVTXpB57lrC5iihUEI4In2oTpMPpfyPjAwQdof5rrkun5xF2Tn77jN1SbY4mzZ+IPAWg1CVN6eZf8OtrjPxtVyi4H378ok0Eox1lOpj5YHaDyw4/jNRuqa1l8AICVo4ai7+q44ajBongdOv/tObCO29PtYGWX8bhfDXrqKSPqCDB31bKUQr/mfZYQkq4X55bYifd3qOMHC69EwuzzzXsBXIC4hZmmsvZLt2OPnW7yAW/qzycMWhbc3Bor0prlvtDhMyTmmriWaTIhLAfN+C641Rwf9ujejZnTkzTAuCy25VuRjrv3gBBfh7pO5HngM/vSzLQGu9Du0aBRpUjU9NbHEmW5w6kMk00H+WTy4n33NNEfh6SvppwQV4bWe8tbloQYsrIVc0OhkvW5fEFqTo4ppfsgG6DOzCcFptTr0ashI3LTJRm4WvFHrp4xI7DQfXlzQjapZbPV3eu0TEqyc5yZXl9eOEO+SvpVZw8wWrTjoKB9pxAiJnlp5ZWYgQG1zLjAdNOoBch2YTdv/vRVNbUQdutwGQZ9Hfhfn3Btl6rdvyD1p6ZNNPKcl220Zo36Fjdzm/3yudj3tthzxOWfi8ypyNCjKqJlouNs+b8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 047467f1-c50c-484b-6880-08db3a9f146a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:52.1256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZfLRLJ1kClu9Xsxs1PXRi3elWScfssYFKjj2wWR3+5gD5qZyLDo/dAj2ZXOb3TVn556JLJjflGn7to0F2/yhew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110138
X-Proofpoint-ORIG-GUID: aSCaMUxqfSbgSz_lc2FdydzCgLLMBPWE
X-Proofpoint-GUID: aSCaMUxqfSbgSz_lc2FdydzCgLLMBPWE
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

commit 790e1fa86b340c2bd4a327e01c161f7a1ad885f6 upstream.

Dereferencing RCU objects within the RCU callback without the RCU check
has caused lockdep to complain.  Fix the RCU dereferencing by using the
RCU callback lock to ensure the operation is safe.

Also stop creating a new lock to use for dereferencing during destruction
of the tree or subtree.  Instead, pass through a pointer to the tree that
has the lock that is held for RCU dereferencing checking.  It also does
not make sense to use the maple state in the freeing scenario as the tree
walk is a special case where the tree no longer has the normal encodings
and parent pointers.

Link: https://lkml.kernel.org/r/20230227173632.3292573-8-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: stable@vger.kernel.org
Reported-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 188 ++++++++++++++++++++++++-----------------------
 1 file changed, 96 insertions(+), 92 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 2f9af64edad9..b6e29081d2cc 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -814,6 +814,11 @@ static inline void *mt_slot(const struct maple_tree *mt,
 	return rcu_dereference_check(slots[offset], mt_locked(mt));
 }
 
+static inline void *mt_slot_locked(struct maple_tree *mt, void __rcu **slots,
+				   unsigned char offset)
+{
+	return rcu_dereference_protected(slots[offset], mt_locked(mt));
+}
 /*
  * mas_slot_locked() - Get the slot value when holding the maple tree lock.
  * @mas: The maple state
@@ -825,7 +830,7 @@ static inline void *mt_slot(const struct maple_tree *mt,
 static inline void *mas_slot_locked(struct ma_state *mas, void __rcu **slots,
 				       unsigned char offset)
 {
-	return rcu_dereference_protected(slots[offset], mt_locked(mas->tree));
+	return mt_slot_locked(mas->tree, slots, offset);
 }
 
 /*
@@ -897,34 +902,35 @@ static inline void ma_set_meta(struct maple_node *mn, enum maple_type mt,
 }
 
 /*
- * mas_clear_meta() - clear the metadata information of a node, if it exists
- * @mas: The maple state
+ * mt_clear_meta() - clear the metadata information of a node, if it exists
+ * @mt: The maple tree
  * @mn: The maple node
- * @mt: The maple node type
+ * @type: The maple node type
  * @offset: The offset of the highest sub-gap in this node.
  * @end: The end of the data in this node.
  */
-static inline void mas_clear_meta(struct ma_state *mas, struct maple_node *mn,
-				  enum maple_type mt)
+static inline void mt_clear_meta(struct maple_tree *mt, struct maple_node *mn,
+				  enum maple_type type)
 {
 	struct maple_metadata *meta;
 	unsigned long *pivots;
 	void __rcu **slots;
 	void *next;
 
-	switch (mt) {
+	switch (type) {
 	case maple_range_64:
 		pivots = mn->mr64.pivot;
 		if (unlikely(pivots[MAPLE_RANGE64_SLOTS - 2])) {
 			slots = mn->mr64.slot;
-			next = mas_slot_locked(mas, slots,
-					       MAPLE_RANGE64_SLOTS - 1);
-			if (unlikely((mte_to_node(next) && mte_node_type(next))))
-				return; /* The last slot is a node, no metadata */
+			next = mt_slot_locked(mt, slots,
+					      MAPLE_RANGE64_SLOTS - 1);
+			if (unlikely((mte_to_node(next) &&
+				      mte_node_type(next))))
+				return; /* no metadata, could be node */
 		}
 		fallthrough;
 	case maple_arange_64:
-		meta = ma_meta(mn, mt);
+		meta = ma_meta(mn, type);
 		break;
 	default:
 		return;
@@ -5478,7 +5484,7 @@ static inline int mas_rev_alloc(struct ma_state *mas, unsigned long min,
 }
 
 /*
- * mas_dead_leaves() - Mark all leaves of a node as dead.
+ * mte_dead_leaves() - Mark all leaves of a node as dead.
  * @mas: The maple state
  * @slots: Pointer to the slot array
  * @type: The maple node type
@@ -5488,16 +5494,16 @@ static inline int mas_rev_alloc(struct ma_state *mas, unsigned long min,
  * Return: The number of leaves marked as dead.
  */
 static inline
-unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots,
-			      enum maple_type mt)
+unsigned char mte_dead_leaves(struct maple_enode *enode, struct maple_tree *mt,
+			      void __rcu **slots)
 {
 	struct maple_node *node;
 	enum maple_type type;
 	void *entry;
 	int offset;
 
-	for (offset = 0; offset < mt_slots[mt]; offset++) {
-		entry = mas_slot_locked(mas, slots, offset);
+	for (offset = 0; offset < mt_slot_count(enode); offset++) {
+		entry = mt_slot(mt, slots, offset);
 		type = mte_node_type(entry);
 		node = mte_to_node(entry);
 		/* Use both node and type to catch LE & BE metadata */
@@ -5512,162 +5518,160 @@ unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots,
 	return offset;
 }
 
-static void __rcu **mas_dead_walk(struct ma_state *mas, unsigned char offset)
+/**
+ * mte_dead_walk() - Walk down a dead tree to just before the leaves
+ * @enode: The maple encoded node
+ * @offset: The starting offset
+ *
+ * Note: This can only be used from the RCU callback context.
+ */
+static void __rcu **mte_dead_walk(struct maple_enode **enode, unsigned char offset)
 {
-	struct maple_node *next;
+	struct maple_node *node, *next;
 	void __rcu **slots = NULL;
 
-	next = mas_mn(mas);
+	next = mte_to_node(*enode);
 	do {
-		mas->node = mt_mk_node(next, next->type);
-		slots = ma_slots(next, next->type);
-		next = mas_slot_locked(mas, slots, offset);
+		*enode = ma_enode_ptr(next);
+		node = mte_to_node(*enode);
+		slots = ma_slots(node, node->type);
+		next = rcu_dereference_protected(slots[offset],
+					lock_is_held(&rcu_callback_map));
 		offset = 0;
 	} while (!ma_is_leaf(next->type));
 
 	return slots;
 }
 
+/**
+ * mt_free_walk() - Walk & free a tree in the RCU callback context
+ * @head: The RCU head that's within the node.
+ *
+ * Note: This can only be used from the RCU callback context.
+ */
 static void mt_free_walk(struct rcu_head *head)
 {
 	void __rcu **slots;
 	struct maple_node *node, *start;
-	struct maple_tree mt;
+	struct maple_enode *enode;
 	unsigned char offset;
 	enum maple_type type;
-	MA_STATE(mas, &mt, 0, 0);
 
 	node = container_of(head, struct maple_node, rcu);
 
 	if (ma_is_leaf(node->type))
 		goto free_leaf;
 
-	mt_init_flags(&mt, node->ma_flags);
-	mas_lock(&mas);
 	start = node;
-	mas.node = mt_mk_node(node, node->type);
-	slots = mas_dead_walk(&mas, 0);
-	node = mas_mn(&mas);
+	enode = mt_mk_node(node, node->type);
+	slots = mte_dead_walk(&enode, 0);
+	node = mte_to_node(enode);
 	do {
 		mt_free_bulk(node->slot_len, slots);
 		offset = node->parent_slot + 1;
-		mas.node = node->piv_parent;
-		if (mas_mn(&mas) == node)
-			goto start_slots_free;
-
-		type = mte_node_type(mas.node);
-		slots = ma_slots(mte_to_node(mas.node), type);
-		if ((offset < mt_slots[type]) && (slots[offset]))
-			slots = mas_dead_walk(&mas, offset);
-
-		node = mas_mn(&mas);
+		enode = node->piv_parent;
+		if (mte_to_node(enode) == node)
+			goto free_leaf;
+
+		type = mte_node_type(enode);
+		slots = ma_slots(mte_to_node(enode), type);
+		if ((offset < mt_slots[type]) &&
+		    rcu_dereference_protected(slots[offset],
+					      lock_is_held(&rcu_callback_map)))
+			slots = mte_dead_walk(&enode, offset);
+		node = mte_to_node(enode);
 	} while ((node != start) || (node->slot_len < offset));
 
 	slots = ma_slots(node, node->type);
 	mt_free_bulk(node->slot_len, slots);
 
-start_slots_free:
-	mas_unlock(&mas);
 free_leaf:
 	mt_free_rcu(&node->rcu);
 }
 
-static inline void __rcu **mas_destroy_descend(struct ma_state *mas,
-			struct maple_enode *prev, unsigned char offset)
+static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
+	struct maple_tree *mt, struct maple_enode *prev, unsigned char offset)
 {
 	struct maple_node *node;
-	struct maple_enode *next = mas->node;
+	struct maple_enode *next = *enode;
 	void __rcu **slots = NULL;
+	enum maple_type type;
+	unsigned char next_offset = 0;
 
 	do {
-		mas->node = next;
-		node = mas_mn(mas);
-		slots = ma_slots(node, mte_node_type(mas->node));
-		next = mas_slot_locked(mas, slots, 0);
-		if ((mte_dead_node(next))) {
-			mte_to_node(next)->type = mte_node_type(next);
-			next = mas_slot_locked(mas, slots, 1);
-		}
+		*enode = next;
+		node = mte_to_node(*enode);
+		type = mte_node_type(*enode);
+		slots = ma_slots(node, type);
+		next = mt_slot_locked(mt, slots, next_offset);
+		if ((mte_dead_node(next)))
+			next = mt_slot_locked(mt, slots, ++next_offset);
 
-		mte_set_node_dead(mas->node);
-		node->type = mte_node_type(mas->node);
-		mas_clear_meta(mas, node, node->type);
+		mte_set_node_dead(*enode);
+		node->type = type;
 		node->piv_parent = prev;
 		node->parent_slot = offset;
-		offset = 0;
-		prev = mas->node;
+		offset = next_offset;
+		next_offset = 0;
+		prev = *enode;
 	} while (!mte_is_leaf(next));
 
 	return slots;
 }
 
-static void mt_destroy_walk(struct maple_enode *enode, unsigned char ma_flags,
+static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 			    bool free)
 {
 	void __rcu **slots;
 	struct maple_node *node = mte_to_node(enode);
 	struct maple_enode *start;
-	struct maple_tree mt;
-
-	MA_STATE(mas, &mt, 0, 0);
 
-	mas.node = enode;
 	if (mte_is_leaf(enode)) {
 		node->type = mte_node_type(enode);
 		goto free_leaf;
 	}
 
-	ma_flags &= ~MT_FLAGS_LOCK_MASK;
-	mt_init_flags(&mt, ma_flags);
-	mas_lock(&mas);
-
-	mte_to_node(enode)->ma_flags = ma_flags;
 	start = enode;
-	slots = mas_destroy_descend(&mas, start, 0);
-	node = mas_mn(&mas);
+	slots = mte_destroy_descend(&enode, mt, start, 0);
+	node = mte_to_node(enode); // Updated in the above call.
 	do {
 		enum maple_type type;
 		unsigned char offset;
 		struct maple_enode *parent, *tmp;
 
-		node->type = mte_node_type(mas.node);
-		node->slot_len = mas_dead_leaves(&mas, slots, node->type);
+		node->slot_len = mte_dead_leaves(enode, mt, slots);
 		if (free)
 			mt_free_bulk(node->slot_len, slots);
 		offset = node->parent_slot + 1;
-		mas.node = node->piv_parent;
-		if (mas_mn(&mas) == node)
-			goto start_slots_free;
+		enode = node->piv_parent;
+		if (mte_to_node(enode) == node)
+			goto free_leaf;
 
-		type = mte_node_type(mas.node);
-		slots = ma_slots(mte_to_node(mas.node), type);
+		type = mte_node_type(enode);
+		slots = ma_slots(mte_to_node(enode), type);
 		if (offset >= mt_slots[type])
 			goto next;
 
-		tmp = mas_slot_locked(&mas, slots, offset);
+		tmp = mt_slot_locked(mt, slots, offset);
 		if (mte_node_type(tmp) && mte_to_node(tmp)) {
-			parent = mas.node;
-			mas.node = tmp;
-			slots = mas_destroy_descend(&mas, parent, offset);
+			parent = enode;
+			enode = tmp;
+			slots = mte_destroy_descend(&enode, mt, parent, offset);
 		}
 next:
-		node = mas_mn(&mas);
-	} while (start != mas.node);
+		node = mte_to_node(enode);
+	} while (start != enode);
 
-	node = mas_mn(&mas);
-	node->type = mte_node_type(mas.node);
-	node->slot_len = mas_dead_leaves(&mas, slots, node->type);
+	node = mte_to_node(enode);
+	node->slot_len = mte_dead_leaves(enode, mt, slots);
 	if (free)
 		mt_free_bulk(node->slot_len, slots);
 
-start_slots_free:
-	mas_unlock(&mas);
-
 free_leaf:
 	if (free)
 		mt_free_rcu(&node->rcu);
 	else
-		mas_clear_meta(&mas, node, node->type);
+		mt_clear_meta(mt, node, node->type);
 }
 
 /*
@@ -5683,10 +5687,10 @@ static inline void mte_destroy_walk(struct maple_enode *enode,
 	struct maple_node *node = mte_to_node(enode);
 
 	if (mt_in_rcu(mt)) {
-		mt_destroy_walk(enode, mt->ma_flags, false);
+		mt_destroy_walk(enode, mt, false);
 		call_rcu(&node->rcu, mt_free_walk);
 	} else {
-		mt_destroy_walk(enode, mt->ma_flags, true);
+		mt_destroy_walk(enode, mt, true);
 	}
 }
 
-- 
2.39.2

