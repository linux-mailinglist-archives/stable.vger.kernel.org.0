Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883D941AFBC
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 15:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240779AbhI1NRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 09:17:38 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:58940 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240803AbhI1NRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 09:17:37 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SCOXjB012884;
        Tue, 28 Sep 2021 06:15:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=FjQX8pmDwp8CaP6xwHafBMfENf3XuBFibefXdxo+r5c=;
 b=kBSwB8EVbGWH4KRLc6qMORq7YGIheGhrqcJ3JeOIvbPjWe4IeT+ZMH2o+mAMfhaxi/uT
 4o0Pxwy18u/fsZVn6MX6iWu62G0VSIGHaO+GGQy6Np9nNvLJ6NI+iW/rcEzRaS65T055
 B+0L1EtYBdLACcHzkcwG5Q5KkBe0gSmNyh6lX1GHQOAy0OeqNdAMf0P7Ut1MebHZ1eQZ
 SErFIynJvqO6+4R4qH6kqvfelIYh4wBmLEHmfYN2saApxsKYxRZVKZNZQMsWIYpuSgtl
 NDZI7PAVIjHIGXSVfBwT/49vpd/e5kWdoCCfwL1D7yRuAu6cqi1UvkrTpgX85ZrJ590N dg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bbhvd0qwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 06:15:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NR1SAkfJ1SRF9+PAq48kKi5O50DYdoOn82u5yqCq6rntJmwvQd28PkZUk39E4/u+PzrMwUHq0g9alcbboPB7U2GXw4t36z8XB0SvQQx5kLWwxVY7P0+N1Xxrk+StcyonlMaOEv3nMh3zRH/KqZ69/LOlVWX5iSJGriETk1PwGe1rQHM1OMw4ivufXdcbl0GfEWGkP5YdpPnIpMCyYuvJHfAPuCjIcyCaH2dx60JKDSJ/B8ioW1lrO4O9E4OCY+3a7jnn3NeJp+iuCCHdro+k/89aZSgFdaOe9vm9/+JjhroERjJOrJcoDv1O5fNjvbuTGoffN1Qf2u+j7QDCm7XGNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FjQX8pmDwp8CaP6xwHafBMfENf3XuBFibefXdxo+r5c=;
 b=VzGLzN+UluxRCav/3jTTe62KPi+1DXk+bpvbNsPaXMZuhdp0KC/1EsdXPpByAVdJvGejF3e99s6UX5Ozh7xG0mA8oj8QqoJpAX+A2yEKrMA+KY5st8rBhSclqruUmV7LcNIJAiQY5rYFO9rbEHCLduwBNzq5d/sbKuvg86BWofgJaaBEzIBWuBoYZO7kVP5ClGBVnPPB3QePzoiwd6lyEC3fo1RNuLQs2P7WKAMh5P8S2ENqyOna9400QLVDJukIGsGXic9tLc1IF1S6vbvX32PS0i7vHOomGgyURpfrJ21yX7eQ8C1uyp2DSzseF1maiqxQdD+oKnLZvFBPMj/YuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4561.namprd11.prod.outlook.com (2603:10b6:5:2ae::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 13:15:51 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 13:15:51 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com
Subject: [PATCH 5.4 1/3] hso: fix bailout in error case of probe
Date:   Tue, 28 Sep 2021 16:15:21 +0300
Message-Id: <20210928131523.2314252-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
References: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0801CA0073.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0801CA0073.eurprd08.prod.outlook.com (2603:10a6:800:7d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Tue, 28 Sep 2021 13:15:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2039bac-29a4-44c8-017a-08d98282176e
X-MS-TrafficTypeDiagnostic: DM6PR11MB4561:
X-Microsoft-Antispam-PRVS: <DM6PR11MB45618991D823A00247C7B559FEA89@DM6PR11MB4561.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:409;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xMTy8R8Mj3HcQKmW22UHdLvCgq7oYlp4JBysxdpBC6UsWpB0pl8e5yrHJib/8xH2++6W1vlqgaJBFsJqM1ALi1izDgRuRJ5vEpamZREzJXmcC6sTloTBQPSnqOpgPzVW23lsyVyf3nkOW40fcOhjrEfhTy1ED4ZPMQm8rtf3YjQdI0owgVa4LFp877MrP71KgKZ7CzN8nJ+QmuyygSocghHMbXQlS2uwmEcMeehCqUdidjpxbsE2wthXL9vQSANyrZf8QAp6MD2IN/yzRfXZb09QPHGyv7OjzMxk7EYoEPdCnw/+SY/84wCBiDQZ/wc2sg+/H768/jkuKOXRVXRlc20olgL6tDw7nNw3Yfe3uMTrjEtsfV6xP1tfbfaktw0fBge0IY8hXqxfB99f+skgrgjLYnd++C3p3A+HYiiM0wf6HCxjJsbNt1OepuEQ+q6BMj7E8EmN/z7+4fNtdhSrkWCBGw0oigl1YTZJA9v8mjBeNzYNtruhnV+Ec/dxeOpCoZugab2ztSJQYzrU+3RnpEVyFOyX3AUG0YWkN14o2cEv5X0dl3LK915BVb2Lb/6OH6U+lCNoNHLX8jNuCN+uBQv+ZaI4I2vU7XLFOPb1qTd9yl7o4K5Eg0iAJXpb9bBvCj5fDbE8UgJLN1akQPcsenOD0nBFs3XCiTNgTKjNbR/d7d779qL0ztEqbIdI8JfcazlIUVVvqHF4ucPUcTvEyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(2906002)(86362001)(66946007)(66556008)(8676002)(66476007)(26005)(5660300002)(6486002)(52116002)(6506007)(38350700002)(38100700002)(6916009)(44832011)(6666004)(186003)(8936002)(316002)(508600001)(6512007)(36756003)(83380400001)(4326008)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1IY4Y27DlXZuUniNTMao9gx0vtq01c9LC3yli8fQkBMjOIYMID/uKHqIJoAk?=
 =?us-ascii?Q?9TSXgPEM4bAbCBjvGQMTpKxKQTip/0Hi6mCct706tq+6oH7TUdC3Co3/9BCZ?=
 =?us-ascii?Q?GTZz0y2ZA6ZFGfhS4t+Rffrpc+zKGx5OfX+JI+zuelHHoZdkUJrsdDHbMUJ3?=
 =?us-ascii?Q?LnN5jGOE5i8PSKN0XypMo281EBMKyx/2s5Eb440ecFYhhGqO+VNJPqfIWyE9?=
 =?us-ascii?Q?gPIY2X3agtHBU4oIlBySSVTeCPnXjVU9ThmTENKuvtHjZF2REMpAmNcFjxR3?=
 =?us-ascii?Q?D5JHeMf1TD/oEpCd3A5aMhI4bI4FvHefhrG+wQCUew9eydJDCFtm5YIzBzje?=
 =?us-ascii?Q?Gg2i2AdRPOp7UR9KqKCGOmxbPJd3KrVhVz7dd13yOywOcjpggrj8xLy1yqlx?=
 =?us-ascii?Q?30zHxL1xAGOxAqE9apgKbJkfeqwrT7HNHu4LCLhorfOxwBVsrAjHF/fVALWT?=
 =?us-ascii?Q?agC6ASRPUg560vNRwjQwj8dBelAXv3pHqpTNcKoPhqLftYpKXCK9AS4eJNee?=
 =?us-ascii?Q?nS2uaEt4nKFv26YyQ4pA66NWM0S/8dxWi1TR2j9GnXnv94BEne4oLCD28OuP?=
 =?us-ascii?Q?teQm3kwHw1HhlsgYFd+UsKNcShqxaq8GOVQ/r9YlsMXwnCLKuWGgW+524T+S?=
 =?us-ascii?Q?8ASoHO4b4jMYJzeSFZdjzfJzc9c+myd8LgFZed2q04HgMRJuoPZLc0C3Ra2Q?=
 =?us-ascii?Q?gLQPCTkDOBC+uQs9L5fRGVPIA5iW8D7Sl60yaHYmeuDSJkhXsRp65q4OY5qA?=
 =?us-ascii?Q?87W/woVj007FnJePA3YK9gboRAYL71B8F1jpnS4jw1ll5W/vRrPH4xx7z8p7?=
 =?us-ascii?Q?QurHz03qJEq2nI4K60Lea/aAjKKgDaXYw6Q5n4ME1sit8NgeDt6YDfnuUw1D?=
 =?us-ascii?Q?m9VxK8cnGnfvkXJcbr7ek8P083KDgyXk/nsf/mTT0n7kx6RAgMFxe6tORGDC?=
 =?us-ascii?Q?CeeRDCKo6FshHi7kSgQZ+2I94fWqwfWr08F4v7UaUWnyMF29ty7yLifnI4oo?=
 =?us-ascii?Q?6KgiPXCqJRpj7x34qs8LNBfqI671OWry3wLDv0AKrjlHpMzqQKEdpQK2zY33?=
 =?us-ascii?Q?UIKYD+Wll0R/cf0s3VA1OrcIL71fQfdBX6I+zEpqVPFVaXVlGnxNjw9Tasjq?=
 =?us-ascii?Q?UpoaMx5vLOWdAdnRCu+38BfjI4q/c/KxSZ8WmtQB9TqbMl/p/P+CoCIm9Yno?=
 =?us-ascii?Q?fwpSVdy+mzW5ZZb6BOtkc9pDWWl0IonAeN9gBruked5tbTlFz1n6J4RcwCXh?=
 =?us-ascii?Q?1+rjoMppPalCMHh7LskhFbG4Vz5DOqukoX8Wrl1u0yU8aXuKAHOFM2jWEnKo?=
 =?us-ascii?Q?rxgKTUaGWyIVL5lg5JDwtr7O?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2039bac-29a4-44c8-017a-08d98282176e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 13:15:50.1882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zHxhDzaAo2va0tV1C1/8pbtQtEUj2ktg+Cqv8v8RQO400yMF4/JoUnRQVEomb0VbPKOC+5Vxt7BeHIzgJjblGLRs0Fb33WyfxOqBu0icZY8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4561
X-Proofpoint-ORIG-GUID: 68pv5Tcnf7WWvmrCW0s7IAZMqOrLlAKK
X-Proofpoint-GUID: 68pv5Tcnf7WWvmrCW0s7IAZMqOrLlAKK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 mlxlogscore=961 lowpriorityscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280076
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 5fcfb6d0bfcda17f0d0656e4e5b3710af2bbaae5 upstream.

The driver tries to reuse code for disconnect in case
of a failed probe.
If resources need to be freed after an error in probe, the
netdev must not be freed because it has never been registered.
Fix it by telling the helper which path we are in.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/net/usb/hso.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 22450c4a9225..fb8827dd5671 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2354,7 +2354,7 @@ static int remove_net_device(struct hso_device *hso_dev)
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev)
+static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2377,7 +2377,7 @@ static void hso_free_net_device(struct hso_device *hso_dev)
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net)
+	if (hso_net->net && !bailout)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -2553,7 +2553,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 
 	return hso_dev;
 exit:
-	hso_free_net_device(hso_dev);
+	hso_free_net_device(hso_dev, true);
 	return NULL;
 }
 
@@ -3122,7 +3122,7 @@ static void hso_free_interface(struct usb_interface *interface)
 				rfkill_unregister(rfk);
 				rfkill_destroy(rfk);
 			}
-			hso_free_net_device(network_table[i]);
+			hso_free_net_device(network_table[i], false);
 		}
 	}
 }
-- 
2.25.1

