Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAEF6DDF3C
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjDKPN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjDKPMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:12:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D912525E;
        Tue, 11 Apr 2023 08:12:12 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEwtCZ022960;
        Tue, 11 Apr 2023 15:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=jQXH3slFlwhM6CF0XD0xGd+nWcVRiCshDHSzp1JjNsw=;
 b=B+wS5ExbiB+yts5VISnvupGs7g1YvCChQjaFcpgu/eYKhha1TCC5/06Ssz4fFpiNpY9G
 wOtseVM2XBpgoL2Ph7Ng1mI9sOo4a0z/Rt9qwYEC185DM/AX/W3v/TGyY96nhXO9RfmQ
 S5daP0ksSTJwEOsemedI2KsWNl7aTEIL0p+jVK1IpS5jkKNxMxvrRvzrYyEpKunyz3Vt
 D6OKQN1KelXEfQyCI7IKekyc2jeqcOx9fav64D7Z8IjbcuUo/lZmESqk+Q2j24dZQwY5
 4cziQb/6iCFdDipZmt2OPwE8eMA9JRzPKGaxLJzCY+11x/N7TEnUYV0DBLBwQy2RBOOC Pg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bwdrwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEV6Au012913;
        Tue, 11 Apr 2023 15:11:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdp0yc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEml9e1cXFpktysoaEbL5MHugC9fYdiNtTGGQArpwQRIgFIpzjqW8gAiJHRskQrbQ142nC0jSTaFCIQ8EZNeEc60DonXKaaCOx/IAY4CSs/iM/746f07kS3wFwqK+lfnVBhpJOR2F6+rKRxOk8hCvbjne4/DI+hL9iDYWPlGTWimK1BdTeqSj2514D9zMSO+pKOw0beSS3io1dQ+RljcF48Th6v0zlXrHuBMaiJMb2142GqJbGn/D0tZBH2X6mtL0rSsCEWvatkPuKwSTrHtBy4SpUxRuhCtTvUifd+QXU+rXD/74upolmkguBREJ39GQUHDvkjCcbxYVKowioy3mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQXH3slFlwhM6CF0XD0xGd+nWcVRiCshDHSzp1JjNsw=;
 b=l17KLFEqVKbI4hmY+K9nD9VxYkzxM0wQurvspWJ1e6Ug6PbtMGLJg5/WQhKHziiMrEqikBCsW4nGpRGpOwLusdU7moC86NOkCyEBbj1ERz2hAQp/FYH6rhzg2SlfHowZuEHH4RwboocrN9W9WFppZL+bbIRa7f/NCslT8lJ4WlYd16Tf2oiryNZfPWGYq3Tx5UYX3zS3evq0C2xVlgfvpmS3egBmqo4t/8KZBBDzUd5h9SBFq0TnacoqaLjvIky5mrgdV+JEy5yTi6nLodTESdcPVjE7yEvvC9Mczwj3zJUGNdWwlvT57COrb23+7RI5p2QyQdPSAdi0NNVhT93pGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQXH3slFlwhM6CF0XD0xGd+nWcVRiCshDHSzp1JjNsw=;
 b=E/ri12hI6RO8V72i8EtpNmYUI1D5Iar0hfh0p2qZM87QO5OAQ2C3LPvz7PiCJhQLSFmZm46l+RkXiwkz+uPf8cwJldV5I7kXfYoAB5tIl47IWE9HCgIO6MuJlrhL4a/yVMpeBCn3UHtu0/o89IEzKX9YeBm4n/FDTURhPP0Wi14=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SJ0PR10MB4718.namprd10.prod.outlook.com (2603:10b6:a03:2dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 15:11:47 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:47 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Liam Howlett <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 11/14] maple_tree: remove extra smp_wmb() from mas_dead_leaves()
Date:   Tue, 11 Apr 2023 11:10:52 -0400
Message-Id: <20230411151055.2910579-12-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0006.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::11) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SJ0PR10MB4718:EE_
X-MS-Office365-Filtering-Correlation-Id: dc325e29-65a1-495b-8532-08db3a9f116f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lxvpAIJAqzL6hoGLc+KHdQ5j/p5Aipe2+xWZPVNzipLRyF3oGBS03cPKnTsSBJQTFCdCeIXiacr6+hjPp5CjNWNVUEo4RIo0EmstkQYF5HM5v1C1RLhvX6oYEwh1YW0e0dKu/dQoouaY+q0faCKwmGYc4+EnY/xvN+hvFt8EhMP2dP43LppU9gGJSAQWkgw3KCN+NVmZqebL6FippNCP9bLwFwG51tt2R7qW5ys7JmClzukoaOR0e2olUMAtj3wuuofwbXaiyMrER1DJ3pOhEMQJzuyyXTILv81skLUNxy0lPKERxkqiPcUtDco+IG3BmGaAP2iUtcyP/4Rv8nv+0M97R8nAFyr1D4H44d8cQE2tAsEv2LAsDLSlmgqbOmRab0JmsJyU3inrhBhKC4jw09ZqSh6WxS90lQ1BsRHjmrhZR0aVM//7CxXWr0ZJrTTi06jOHbyb064//icHfZQiNqxKVKMQG3A6NHfRxrWRCeqGh/VkfDfex47JYD233JE409t1jA+k+y7/LPcerctcJbMAHnqK8zaxMmUCbbabTmE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(38100700002)(6512007)(6506007)(186003)(6666004)(26005)(1076003)(107886003)(2616005)(4744005)(8676002)(83380400001)(2906002)(6486002)(5660300002)(8936002)(966005)(36756003)(478600001)(4326008)(86362001)(316002)(66476007)(41300700001)(66556008)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Si2e+AoqHgWxkk7+RC6XPWctCN2RxtU/Tg7Z0Cj01I0mR868DdUfks68jy7Y?=
 =?us-ascii?Q?4p7h01Xb3eY2d5zvAdcXvJQnmzHmDT04Xmkj5TzPiW36D9sX4qXlUxUI9hCk?=
 =?us-ascii?Q?1JiJC+dd4K9Gk5P+JHU8er/aNUz7LK6X7doqiOxDH6c5iTP+OQdqMHIN8lsD?=
 =?us-ascii?Q?V2JUTC6fr5ixUTAEfLmTOqjVAz3bwgsS5ksYzl0xga7L1QJK2qeSbPoPOuLP?=
 =?us-ascii?Q?dGEft+bBHhJ0hdt0AiwDXWKjOaBC60zFJrmqfsmxzOSJv205AsnkcH35LMXO?=
 =?us-ascii?Q?UaytZauhT4ybHzb986JApF5B5bsBCqy/tTc1IN/jjnwk879CtYlq30d8itwk?=
 =?us-ascii?Q?+XThX9JHJ8dWncAhZPjcyVlQUnP3LEOrmnPMm4Ax1RaWHqwyOMNDtet/c3/C?=
 =?us-ascii?Q?ZTA1gNTeAr1bsL+McQhRBRzNR8McsE57k0UkrTwqPAookqc0WAjcXOvZQFb0?=
 =?us-ascii?Q?yDtPmBOwNvYDg9YEpwBPGu6lL/IGQb07IX6RWkyhJXh3AVkFZCCGKd3B0poB?=
 =?us-ascii?Q?e8uCRFZOkP29fvIFx6/LbAiaUiRSrGg0RJLQiurN4LGLnGAS5DpvUf+W3MM3?=
 =?us-ascii?Q?DsV/Da6HW0nm+kAyrGM5RQZBNAV94gJxCsSHom/Gj582LvSyt22f6WcJ86rl?=
 =?us-ascii?Q?WF3v7LTUNGQ2gsfzVkoa7yC0+ZqRsnTs28ujl/co1np/qXISkyLhsSQO9gqf?=
 =?us-ascii?Q?8dxKALZ5R6xrJh3nsLd/x6C9QMUodpfmG9f6u9JDo+oUFm7dZDMiKydsbcl0?=
 =?us-ascii?Q?Ov8LnHAGWArgEAPdOjbP7R/CJcIeNZTnmaYatQozMTD5SZWdG2S4/BgOy+CV?=
 =?us-ascii?Q?B/hll2pRjWxLWkIS7RUwHsjxxfvJttVv/BSUk4BoMPncGmUKTi+1VLShzo17?=
 =?us-ascii?Q?p6QXEgS5rjqStAH+eCYFXISKgpw45RfgT9aEL8I8MUosObo0jBF3fwTpAYxS?=
 =?us-ascii?Q?R7rP1YjAzsHymv8MRlmyyp+t2Q7WVvAKvANP5xTSps1FgCGpxTuKQsiJKfd4?=
 =?us-ascii?Q?WvEPI49SPRY2aLpsghbtwkyDXgQUDOthWvbKqSQruK4iaxoj8PGgQaVejCl7?=
 =?us-ascii?Q?e78gIZZ7lBE0NJOec3E1QORa+T3CH9RymX1J3kYVtqcA21HiyC5ab24Usy6m?=
 =?us-ascii?Q?P3Hmp3v1G/+ziyKP6qXF0RtttUJT7NMns79U7CYcFS+WXhOtCuoZAqiN2kxQ?=
 =?us-ascii?Q?23adnmXCIixV2DtrZt/CK28scCUEC8nmZ6gLqkoMXDqd6CPg7awSW0Iz/Rmp?=
 =?us-ascii?Q?HvZxYOAt7Lwyb8gg6IOytlxtNcHHaXBPz9RNHhlgmSUCPr3aPKdDlaKX58yf?=
 =?us-ascii?Q?fP99CYFye6Un97Tie9mNpeRSMJAlVueO3p+AcYUhIkxRqJsbjI07fU+9Bs6C?=
 =?us-ascii?Q?MEOo8I4GY2COpQtlI1xcFHs2Dt16xSygQnqhOxqN9ROHz/bbA0ET1MI9MfpX?=
 =?us-ascii?Q?1Gd10bKtxvkbdS8ku1xwXmXs3Inl4Nwb9R/FzkIL8XLn2qnRjWulJRuFO+dO?=
 =?us-ascii?Q?iDHxF08OWYJTVQx9wR6YErHMmUcbX+NlcGY4Id3WEdKZ7NKlcMNyvj5/0yg6?=
 =?us-ascii?Q?kgxySsRdeJjRl86oDpN7bIdIa/WULA/hVI9maUvhNCPdrvbe1Ic9LlGgSPua?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ul+rmDbF4v/QtkrjdytlduULWjAM2XFr/Yil3JW0Ybj4RaMiKAS+qXdgcbN8PGkoW4NjqM2PcsZA5gqz37FkMPAacLfb+BS9UqzXfo0Z3uH1QBCsjgq3FkY8YIrPoxIE6bk9bSYIRyR9eDI3ZUTTwmqRmujp3Y9Gi7AjZCvd9QGTlNUEjBTBePhUyNnRgaMRcprcI5V6earb1oU2rA01x6ByIi51TvoXu8NHcEC/89s48c8BptXAIM3nNBX3UnxptKDAK2RfjPxL+t7ExbNFTSXg4kp3sz5sT0SdP/6abqnKQvHR1F775idylPs63RsJFXJrqd88JQbiJZD9y/TRAt6yyfuo5IRnSHEo8CdwUzqOW/zxMtwPkzxgwIT0ffEAduQoI0j9GCpiGOwOanOGax9KGyttKmQkkzb5pj8mm5mM3fxWrCPX+9K+fAh/mTAs+XbzeRTc9bJFLfFL54AVuwHo2oxYPG4PokLT6hwcenf1OIm0KQyK6VWd7GwbrbjkTptWIEAYj33o53V+ItcQCSgVgCf+6uRrpUr6h7cB+MbmsIPMPPsW+36+LVsqYP8czdZayWYv1q2Jtsl6AzKFEWJItf88S9VYmwe7MLmKWWkafF18XFL8aKO7f8DOBu25tClAAXK1acjsbTC8/qNXd+5JFcru18CMGJyyrr4xb/DpJszOn++jC/DFRXOXrZ1AoiJ1x0Ufz5emqqpiw24OR6XdBjQwC7PCak0d0xgDLd/SuodvJmKiELsjVyyWkr8GGHkhaI0bkAx3Sm/9l+8DtuIjo6O3y6dM8Q8Kk/OTwmrD/YZhNhPslD0fCbQNOsbEgWSDHSWO517boY8/eFxibgwg/Pnp2Te040a3DbiWPts51eFzCZtUhbErGClRP7sigR5VHHSBes9nuqqZPi7cVw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc325e29-65a1-495b-8532-08db3a9f116f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:47.1084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWDVSp7F8UlDT6O22aLHpZy4hpULHbCP6VW5jfPObhMwCZ/nc6Ji0RQl6zoj6o5R+HpqT6JSV1t3uimQuUmMHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110138
X-Proofpoint-ORIG-GUID: SjhcaOHj6L9RN9-2k1-xQA54gax6L52f
X-Proofpoint-GUID: SjhcaOHj6L9RN9-2k1-xQA54gax6L52f
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

commit 8372f4d83f96f35915106093cde4565836587123 upstream.

The call to mte_set_dead_node() before the smp_wmb() already calls
smp_wmb() so this is not needed.  This is an optimization for the RCU mode
of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-5-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: stable@vger.kernel.org
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 0f0a2d4850e8..281be0997e55 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5501,7 +5501,6 @@ unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots,
 			break;
 
 		mte_set_node_dead(entry);
-		smp_wmb(); /* Needed for RCU */
 		node->type = type;
 		rcu_assign_pointer(slots[offset], node);
 	}
-- 
2.39.2

