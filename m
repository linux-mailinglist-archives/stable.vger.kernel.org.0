Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4665530FF8
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 15:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiEWMht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 08:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbiEWMhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 08:37:48 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA9A4CD79
        for <stable@vger.kernel.org>; Mon, 23 May 2022 05:37:46 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NCO9tX017331;
        Mon, 23 May 2022 05:37:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=XevORpDtO0gGtTxssAhNw8liPCNO0+mwu/4+q0CKip0=;
 b=lJu0q/oCRtrJABPah6RIN7B7Pjvp+FzDQbCdOe6FBm6YLVN6BwDANwPongDKpBZynYhl
 AvWT58WqRm6VKxBiPb15khlidO0UgaZJgZ6MHxPvxOG69bY6d/MjuZ61OnwsjVuv91PC
 mxDdrAc9i+Jj1QcZxqz2EDpRxoRAJj92j903EKC9eWtI4qgzP1J21fJuUaFK3XoDGK6x
 Q1DYz/CBBQ+cztQZqIrxCoIWqnmtVlFA4vE9dkmqpfQISwC98/cGy7tsAHqT3NROTvqL
 bCyBxMfIQcjidqgNVQj3eAxB2K8ppEhRo7XUU4NnG3XOkDRx5ZISCxJgkXSEs4CEclox 3w== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g6uc199nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 05:37:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZ/jwejO4eok2i2AG8VQgWvUiv82SsT+BUqw42mofexKVCIxOum8nuADXVVefEQmbiCN28Dzap9ljFDIroIklQExDXflK0bc+w/QZ8C146f5MN4dbgLFmZDR949brugl/8AwhQAx3HtSGfvuWhZcIPMSiPxu943K3Mz5EVStGLLxMa7kv4YjaLXSJYtukFZ2XD3ttMv1vYTv2ZwKUTMzu6udnXCSebbEWFSRwQNd/slFTZl6CSqkyiKDheHNcNoXzuzn7ksj5gsnAlLAuHK4pYEV7zBfaw5zn4LsI36FzvfCRXGGRnSRS/Ah5pzXmUXYatqOnRq5B7Ykml1/OeBBcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XevORpDtO0gGtTxssAhNw8liPCNO0+mwu/4+q0CKip0=;
 b=ZqcNN+sqhALF/hdaliYDnqU9lm/Cc1sdA0ePToUtB+qDexehA601HqnuoJmSPNsUus7fDIpY7Ps3ep8Dc0o3Q3+3DCTpgeuYUzkdQ4Qm1Rxf/3bP1H94jiCk0Ao9Ee8eMaUMOLGAl7RDmcwfoI+vVNd973JMpolnO7eQrKQzO3zIq2UtnokXcAssTVuu2mmGW5Q6qmnN4WE38XP8IEDFHB3bHIWSmvEqVc5U/4yrH6Q0FJUzasHZlVLumKhyJyLHQg82CaHq3qi8eIzbd4/kcKd+l2mqAKjCO5agkQwZuKN9TFkR8NHWtJytOHEyEl4JEkvlVrFMkqAfCR8jV5LKnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2268.namprd11.prod.outlook.com (2603:10b6:4:53::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Mon, 23 May
 2022 12:37:39 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 12:37:38 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 1/2] swiotlb: fix info leak with DMA_FROM_DEVICE
Date:   Mon, 23 May 2022 15:37:21 +0300
Message-Id: <20220523123722.439088-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8P250CA0004.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:330::9) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f017e91c-1917-42d8-0629-08da3cb905a7
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2268:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1101MB226805B56CE49E23C07CB7DAFED49@DM5PR1101MB2268.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XPueT3VwCIN5Vxkq/pDXa1nt8ZQ9OfbOKh7K8h4qio+ia4LNgHdIr3Lb57sXLahioEFg3p2puV5TnDPbzfNHHYIySKDGuPjaXJA7o6vRw5g+qAJ74buo2elf9/nBoUj6DqVn+cxauVIpmYknI89jvdTZLxL0IJRBkwXDRhT/wjOnRrjRF5LSuxyI6eHyfnS7LAvGK1HRydHFekWlnPWzjY4uCUPJPwwzHeUz2DIWHQP1htWA52KrN1rbeLWNNx1N95fNRtapGPdydweiUTc5I6FwCfGZ0Qa4VAWMc6Qlh9c2ceBURNhDisbtOfPIvjk5mV/CWMQgnq3OuY54H2HMSpY+KYjFjZ4PrfVSCR9Di/um40poGCGj8XRo+W7oGdueytHS7leXcnnUb0stEnUJY6sGXReXGVqdmB0C9WOuIFrZ8a3BsUYxgcZntVJyuO/hLm2BN4fk+jXUZZogL6jqNDPZf+v+6wyimAGqFKvxp54pKsofKK2+NHa6TRussYiKUCPPUcLlvNnLjShMDokVZ2/6Gp43uIriZ5a/2m/7mQESmgMKQvZYja2Hv9ltLfq7ln9d4ijtIHPeEtP9dGd3DCVMPyuadfLtsnDacUVSuwnvHfxTE1zMxkot1C+jP6bKS1rgIqXwZ8ZIlddjkc3xwCq5P57i+YX43i07PKO5io+oQTG1NwhcjbB0vaYEgntTpQnCUOMCRirBA4e0NvLjjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66946007)(8676002)(6512007)(86362001)(66556008)(66476007)(26005)(6506007)(36756003)(38100700002)(38350700002)(316002)(508600001)(52116002)(6486002)(6916009)(8936002)(54906003)(6666004)(1076003)(186003)(5660300002)(83380400001)(44832011)(2906002)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3wzE+bclLsmrcKDge+BiIxJSzBeqz/8nQBYbuy7D6szFT234QCZBtvJw9cx9?=
 =?us-ascii?Q?Gmb8VOaDWRMI/UKXr6CU4UYUOhmp2ccae2VEkambKaY8D/vbv4bfqnvnGNcT?=
 =?us-ascii?Q?QsTO8WIHu885LN7OW5dMb//risouW7uKR8wc80TCDD1rpTjXlXYnvTUIB5wL?=
 =?us-ascii?Q?LWLzhgr+miMaBrcjiSZD9VBgbGUrqdfItvmEln3+vtpbaWOHTvGDzQ0UKmez?=
 =?us-ascii?Q?8jvz6PnfYau1/gpdxDoIq15I7F6bM9nRUjhdrmwGVxgc/9OZWpXd8Geyxr0P?=
 =?us-ascii?Q?QH+N7i9QFSCLE7jO3ioIGyo/xpuy8cZNsGmrlZw0SrPZmxvbFDhbg3ecA/gd?=
 =?us-ascii?Q?R3JMCr28ec+PhlXaFA3+oz7lYgAN6eZ7BglaXu4F9gb8hxflO/lCOG59QbQU?=
 =?us-ascii?Q?0nfA7d6vPaOxHeePLOyCFj78w1rMPzhMiCZpYc+MBn1rkiTnupW8ssFF4Cga?=
 =?us-ascii?Q?XCb8s2cqgwHWJ6DcjnY2FhQr+QHCrwC7Hmwq3kET2u/0gclFf9pguNsIt1u4?=
 =?us-ascii?Q?xC7y4qtWdKRnNAZyUDo1Ng4KoSlJBHIqpaIEMJ80LSCfI+K1SkJfIl5jobyd?=
 =?us-ascii?Q?PzyBbYS8hrRv1j0usN/BSIt2tdYSwYNyniZeOoaLewmMz32lhYQ+w56DkCEd?=
 =?us-ascii?Q?SXE2s1SLMC8fwr+ce6XYO1fCmYYCG5MRFEZsXaIwYnBx6O70HXFwhR6+TDZD?=
 =?us-ascii?Q?FCDHP1JF8dIkF2aDtg+IEwpYL5DcC9TIghlKJzvRHOVMc+HYzFjTDKNth0xO?=
 =?us-ascii?Q?kbLrT279eqR2oW6grizTDqsbsUfcYpGuYwqtN+foDYbB82ZmYqGkBiD65uUn?=
 =?us-ascii?Q?jcZcJy49Q9duV7UKZKlT4k9eK8H+/TCM1kT5XRQkzw9mzZQqe9pqXD0DoWSp?=
 =?us-ascii?Q?cr3yvXW2M95jV0mwv1I92INGHMxb9/v/Vcipyye4E38TwZFCcK2Ofm62ri3F?=
 =?us-ascii?Q?eJkzkwegYcCwEhRpjrU961TyDvuJJ2RWxlGWl1JhsEEzmmFW4PGQJ/dYzuCE?=
 =?us-ascii?Q?Jh9OZUrtsWA9IJksj2cCoDuKrz0bTnEHE0Lvp1bCSm3GW5wQchfS8YDB663S?=
 =?us-ascii?Q?qZGqV+xWvgK30aetwAUf89IvD3z4T6DoUH8O54GTNqLmQRzOZbskvUT+hDSo?=
 =?us-ascii?Q?0KN9TvYmB5EiPaNbmI8cG53O55hIcm1t/Sntsw4ac0n9BCNMtxgJWV0b4y/1?=
 =?us-ascii?Q?pPSasxkjyrdlr7VZnVUaWg/iiHC981XdF+LQD+eZIp7e27qOJfj6HqbIqVMr?=
 =?us-ascii?Q?S8WeXEjHeibEY9J6lACdBf5DN/dFvbJSBSRZbbKegZyNc/8AxxO0OEqMkKBZ?=
 =?us-ascii?Q?s3AbMFofZSesDWDAa/5yKh/8w/Q/3Cb6B/im7hVhVNR8GWBaLq7D2vJV5Cdt?=
 =?us-ascii?Q?oBW7k2diWKJV7mISRrUeNuVh/bsCumPIeUxRcaKIqRgN4H4Vf9bA2OxskED1?=
 =?us-ascii?Q?ZMQWg3cUB8IfrQABubPxIdWzbZlmeWe78MVZIfKkcraDiIcN22Syqy/fEiih?=
 =?us-ascii?Q?W9l71yAnZeaNhNpHKTDmzQJwKBEoaHnzxmjaB6pvqSHaKjdC09MUWs2koFCm?=
 =?us-ascii?Q?BQxUf5RBDsSBG6mA5B7qAAdsqo1plZMfXkahLtGzOh7SW8Ew783J1GgezEXe?=
 =?us-ascii?Q?njOGgtnLQDC8H2bLszF5gKhBgUKddg5rt1hH371wVKtEr6nD81dSdNGIUt19?=
 =?us-ascii?Q?4UyD+hYZOldMiZJ8jWZHYY6SUVk+3b2URw9nXtEzXaRoaZue5+3wqwAFP2oO?=
 =?us-ascii?Q?h/9yvluzPZu3rYZ5XkXYnvDwwI0Yggw=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f017e91c-1917-42d8-0629-08da3cb905a7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 12:37:38.8889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sbzWO9maLdFpZiro9N1gCtTrnQzGbCIMmFHndeJa6ur1VZzt61uEksiCTy2xmo2NL66Moie5MT3e+dm8cwLsZ91wNvO3qDKcGkiFwzNzcAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2268
X-Proofpoint-GUID: yvYWdtsbuQc3t-87FlvegeEDegeKCRG3
X-Proofpoint-ORIG-GUID: yvYWdtsbuQc3t-87FlvegeEDegeKCRG3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230070
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

commit ddbd89deb7d32b1fbb879f48d68fda1a8ac58e8e upstream.

The problem I'm addressing was discovered by the LTP test covering
cve-2018-1000204.

A short description of what happens follows:
1) The test case issues a command code 00 (TEST UNIT READY) via the SG_IO
   interface with: dxfer_len == 524288, dxdfer_dir == SG_DXFER_FROM_DEV
   and a corresponding dxferp. The peculiar thing about this is that TUR
   is not reading from the device.
2) In sg_start_req() the invocation of blk_rq_map_user() effectively
   bounces the user-space buffer. As if the device was to transfer into
   it. Since commit a45b599ad808 ("scsi: sg: allocate with __GFP_ZERO in
   sg_build_indirect()") we make sure this first bounce buffer is
   allocated with GFP_ZERO.
3) For the rest of the story we keep ignoring that we have a TUR, so the
   device won't touch the buffer we prepare as if the we had a
   DMA_FROM_DEVICE type of situation. My setup uses a virtio-scsi device
   and the  buffer allocated by SG is mapped by the function
   virtqueue_add_split() which uses DMA_FROM_DEVICE for the "in" sgs (here
   scatter-gather and not scsi generics). This mapping involves bouncing
   via the swiotlb (we need swiotlb to do virtio in protected guest like
   s390 Secure Execution, or AMD SEV).
4) When the SCSI TUR is done, we first copy back the content of the second
   (that is swiotlb) bounce buffer (which most likely contains some
   previous IO data), to the first bounce buffer, which contains all
   zeros.  Then we copy back the content of the first bounce buffer to
   the user-space buffer.
5) The test case detects that the buffer, which it zero-initialized,
  ain't all zeros and fails.

One can argue that this is an swiotlb problem, because without swiotlb
we leak all zeros, and the swiotlb should be transparent in a sense that
it does not affect the outcome (if all other participants are well
behaved).

Copying the content of the original buffer into the swiotlb buffer is
the only way I can think of to make swiotlb transparent in such
scenarios. So let's do just that if in doubt, but allow the driver
to tell us that the whole mapped buffer is going to be overwritten,
in which case we can preserve the old behavior and avoid the performance
impact of the extra bounce.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
[OP: backport to 4.19: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 Documentation/DMA-attributes.txt | 10 ++++++++++
 include/linux/dma-mapping.h      |  8 ++++++++
 kernel/dma/swiotlb.c             |  3 ++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index 8f8d97f65d73..7193505a98ca 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -156,3 +156,13 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
+
+DMA_ATTR_PRIVILEGED
+-------------------
+
+Some advanced peripherals such as remote processors and GPUs perform
+accesses to DMA buffers in both privileged "supervisor" and unprivileged
+"user" modes.  This attribute is used to indicate to the DMA-mapping
+subsystem that the buffer is fully accessible at the elevated privilege
+level (and ideally inaccessible or at least read-only at the
+lesser-privileged levels).
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 669cde2fa872..a0ccba8ca1db 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -70,6 +70,14 @@
  */
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
+/*
+ * This is a hint to the DMA-mapping subsystem that the device is expected
+ * to overwrite the entire mapped size, thus the caller does not require any
+ * of the previous buffer contents to be preserved. This allows
+ * bounce-buffering implementations to optimise DMA_FROM_DEVICE transfers.
+ */
+#define DMA_ATTR_OVERWRITE		(1UL << 10)
+
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.
  * It can be given to a device to use as a DMA source or target.  A CPU cannot
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 6f7d4e977c5c..33bed537a64b 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -588,7 +588,8 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
+	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
+	    dir == DMA_BIDIRECTIONAL))
 		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
 
 	return tlb_addr;
-- 
2.36.1

