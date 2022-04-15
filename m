Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5FF502D8D
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 18:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355758AbiDOQRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 12:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355821AbiDOQRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 12:17:45 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF71369F5
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:15:16 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FFwNBJ025644
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:15:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=x39+ZknzBNy1rOH2oSzW+dCT1fGesTFnYqNIISfylmA=;
 b=M+/Bk54XEX8eTUWbvlzWkW9IJkXyv3vRmRDMb2/oH6/eIMKFMf2P/uf4MeNYpQWU3Qqn
 E3Hw+Wn44S8trbIz5EDOqeDBngQzE9vBicc/iZ9zY80HFk7pGSNh11bAHLOP3FA6X3yu
 08sarcQ/88EnjqASAQGztiab7ezoIlrh304v7+iYUBgKitAnOy6VEMu/GanUDPtta+dA
 Wz/CVLANEfoOmgriwkLf9+D/x3cj3RklwpWSdK6pJaLaTgFwQtQBmyYyrYJG3T1Qo9Cg
 HcNn9prPsDR9UfL3uYBvDvVqzhSRM+WdeUCqSFFPgfh5OCNSFJMq+MGaDeXFh04NWES1 Zg== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jec5hv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:15:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRgvfhKPiVp0Fv/YvCJZyKz5IbYZo3Z9KIzjbA+wTJomnPwuTlCBICPcPj3AlQ1xz1LHuLaxjUSOtwp5l13s1imVD0ViEKhO475XHM8bDc74SBhqGhgw+6HsIBC/2D4EVTVqz+59aA2WB7UnCelzrOhmvTkKL7Cf3V6P6PaPSZxPJXx5jbZYueDwNzx/Z+LxYuVWWH/wEvcBhXnWHra+B2wKh8sPBquDpauz/3D8e3vccBNbrUx1FrRXFHRQT9T+ngAkn1lpBB6p3cuWe0GiT0RcHwB9GBdT7SgNgFMA8bHYjRbTQdhoJBfd/uT6iVjmDF4BCdGrNVycLjJqpXGhaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x39+ZknzBNy1rOH2oSzW+dCT1fGesTFnYqNIISfylmA=;
 b=H4OtN8fc0nvq4RAanf6h0FZ8414/UeeYWMGlNrK0/9raYxrAK5cmo1BW0htDrroQTs7QRbywnChlCa8bmqJNpkc2ZPKolemb9t0sR0OirRNw3Fjvt4fRvWOUy/SVR918IVVzVHZIs65YormZ40lNC4w76OvB5+8XX/eOc1RGfB0R4ysyc+O5oO2k03HlF/1/6j32uZoJPImxgcZ16uYNG96C+fx3o3Dl+ZGAfvXCh22pJnP8/Ze6Xti/5/hUuCSpGKAg84ubADcSieYXE34UVv3/FzBXPT1CXpAHI+hT0Dd4UYPhRzc19AJusBKGCgU0i46Jm7JrwhMoHMIgWJXZHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3626.namprd11.prod.outlook.com (2603:10b6:5:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 16:14:43 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 16:14:43 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 8/8] ax25: Fix UAF bugs in ax25 timers
Date:   Fri, 15 Apr 2022 19:14:22 +0300
Message-Id: <20220415161422.1016735-9-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415161422.1016735-1-ovidiu.panait@windriver.com>
References: <20220415161422.1016735-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0009.eurprd02.prod.outlook.com
 (2603:10a6:803:14::22) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a02f815-1365-4503-a32f-08da1efb0d5d
X-MS-TrafficTypeDiagnostic: DM6PR11MB3626:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB36263A9EEB9227F9B216C725FEEE9@DM6PR11MB3626.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHUt5WusoHNfVP8/3ZAD2FjPaQR0LONhB+rxHOSD5ftE27dd05qRl4oOgE2dJwTmcbTMmW1bAzWvTauo+mjouh1YpklAsQG9bXpBdjiCaJSVjc5qhd9gyIeBNyxwWKxa7cgnAaN+4GpRbP6J71dxMHl7OcSMKu9u8ZrWah3GGU+m649q2XFvH5Rf0BAeClmcxGmbyaKFspOofEKNPhSuAmMbbbOd95Z2pmEu7YiLPet/NcT7AiQZ6Vd88uQZFGnYnKfG8tgYUiKAJCrDq/XdGRsIFbi/uAcpHPbGGWQJzQG7xTaTXnIuRefiT0XdtiiHXX6HC4eOhEBN8wbiedlGOtfDzRkfHdZ66h10IMfzOUl/rhOOTTFoL252kDFXs9MRfad/ig9uPE2hm7soPFwqq9iC2m8xlP9NJydKIymK5RH9FOEpKi7yJKWj7YCHsOPx+oNjXs7Jlg25DFY8PJUHlUg7VHs3wwrw4noHEChXuAuXNuFEgDFEmtuLSnlBwks6oOJ2miJOfuvFAXnye/36lPezZqtgGLNhuw6/zA4XBgHz4O9+e1Lv1aKGsJeNo9s4K2WVJ2Qb928a8ohEjjRM9O23rRfB5lOQzM5eIyCcfgmnmxD5Y9Qn/bCM6+aWnP2NFDxFY8oymFauKVSPJKMyPhze5LG9ERzMuFISNCVe1bekVv3G1MKAWhHCY9uGu1E39sqDPGNG0qsAX6tCh1l2tA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(8936002)(38350700002)(1076003)(6506007)(26005)(186003)(2616005)(6916009)(52116002)(6666004)(508600001)(6486002)(6512007)(316002)(66556008)(66476007)(66946007)(8676002)(36756003)(2906002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JZSGbmgFHeYwbqWb740GFi6tZd4nz0x6kW9tZqqoLiMXBfxPIhrm2BOyOLsg?=
 =?us-ascii?Q?VdJieVb/nLTLZOb1SLVV69mmX53G7Kn8hxKytnLF9ul0PyIHOVQofCf/sTcm?=
 =?us-ascii?Q?79xt0uBnCOGy+Xsbis0jplsZhLSKU629+7UaJlnJE/tL83I5gS7gkDfDY3du?=
 =?us-ascii?Q?v/noJL7bEwrrOCgKubJP0LgfC1o4Pcj0sjIEDiFAwWUY2qMSa3dlwg6hpje8?=
 =?us-ascii?Q?o3aEtc0GgaRVDCTrqGqfDq54DGFYnVccMZpcZepE5HdkHugu5rNNyDotE3Ix?=
 =?us-ascii?Q?kwEYZJxZe71ZJSorOeSIbgY5RUzFcx0g5hgkp8Wh/4Xv/s9Qm2ANWznryw3g?=
 =?us-ascii?Q?nV8sGxbZ6F/saImIXxZjQrjPl6KC+9vM9oznUGypEVJTDPAqXnRyu0I1MrYP?=
 =?us-ascii?Q?I9/clGFmL5xO4PB8hNQ2lI8LJ2G+bCc+a1k5c+IavIU7drosypy2F6AF+o2z?=
 =?us-ascii?Q?Z+PVKQhn2J3KIfFkAzl3wshfTlZkVEyi7hcgvZyxX4cpFq0+8yHTDOkI96Gc?=
 =?us-ascii?Q?TaK6ZHUH74cqkfPR9IBa/0d/uScjxq9YK4aXBOQsse7YZ7UPVTjuM500UeuL?=
 =?us-ascii?Q?9UhSFzXYgfw1CWixlF+HTwfKIz17j2roLxLzMzY/Yr4UXdfHy/hH+VOdx1be?=
 =?us-ascii?Q?J976DeQSyHRlsbvEsRWlID0mf57Q80AJar4DgNecJby1b08s8f0dv5eRhAVi?=
 =?us-ascii?Q?36d4vus2n2zuf1I0Gf0up6y30FwerMV0qPjqA7Lng5tOfDXOHx6l6kfYfo8X?=
 =?us-ascii?Q?cvNhc8QEBiVg5M7JFDKHEeyK0M8k0J+w+ctowyf0Sul3EmGD9/0JRFliAeVM?=
 =?us-ascii?Q?AbT/ijsOh1eZTxxNhLRpGY76DvJuUO87HKeTMI3t/PAGhURQ1Q1WbK9DlUw5?=
 =?us-ascii?Q?Qkktg8Te8m8yWTbduIfNuBEifoO0MUc+CX7dpsmkMKel4hqIAhAZ5B44THwj?=
 =?us-ascii?Q?OfRB8S7AXPonv5YiCt31D6UfiBWUjL+YQLQa4Nrkz50MpQqThYuU9tgpZgon?=
 =?us-ascii?Q?iMNdt2CwEmW87Dzq0mjk5URtCX8k6QyoEbIJtJuiMjMvuqu0Ylj3V6UT+S+u?=
 =?us-ascii?Q?xDSqL7+82BnKoU3K5miraHe3K39UQnLU4VlswPdaabTgNNGPsaE3m1eqDufT?=
 =?us-ascii?Q?CP/+pj1L3F1GPq8+4D/9P52ZmizwapEAs0zSy9wxISe1uM+QY6kYwxLVImBR?=
 =?us-ascii?Q?qkRFn9gNR160YP69izMcCnZ8H6iEcimu2K1YCNcU1I3fahw2LOcqa1zkqa8J?=
 =?us-ascii?Q?wZ6i9sw2HSzqu3LTHfvCN+S4F4Scf2/FNxjc5/ztWHKQLUSY3s9OcIOuZju/?=
 =?us-ascii?Q?XMURU8YTzvsP6fZCvdxLB9K39EOW0STipLLY6m6gsT6koiDKVKhnsz18RHBV?=
 =?us-ascii?Q?sFz3RK9IPurYKjbH4ZmmfM7OUAE4NLY6CiwVFnrLGubV8o6TP2RLoIJBdb2b?=
 =?us-ascii?Q?kTsFzCaLLWa6Pqkxze8Fcz5cwLhjJSy5695iumIOCaDRY/H6gwIDuMs/qvS4?=
 =?us-ascii?Q?SFCdSp3+NixBDP6cV2ywHypfIpXS3EU44NOWkb6nAOhqDRZlWaWlGL09/nCp?=
 =?us-ascii?Q?eu+aQ/QXSu/gTrUfbErKWGa7+mf5PSdoNiJw5/YJq4ZbQNgn3fOdAfPWxrYK?=
 =?us-ascii?Q?sG2Nd0RRb/hAlbKsA0z3yTlpndWuMi2mXIER2ED53DPHBpzBahBJNF12ILUD?=
 =?us-ascii?Q?Nq/L3ut+UZLnSIB9b+f85ykSo681d1G0198nMLZ3zKB68UF20klpe1vPAw7i?=
 =?us-ascii?Q?xK5TLIntFDazUV7nn1QOBNVfmHjp9qE=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a02f815-1365-4503-a32f-08da1efb0d5d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 16:14:43.7148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxjVHxT2A7R4CzsLHSjrHdOrphJrUwWKKQ3Du3fKmhxSa29N/jhEescIn10U7WvCbCWj+6Gdpv4+m9dw6xOq2Bl+Q0B9R5cYiF9Sh81UQiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3626
X-Proofpoint-ORIG-GUID: 3JPU7ku2XSRzXgyVZJoQYQ3mf1dzP2Hu
X-Proofpoint-GUID: 3JPU7ku2XSRzXgyVZJoQYQ3mf1dzP2Hu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=631
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150092
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 82e31755e55fbcea6a9dfaae5fe4860ade17cbc0 upstream.

There are race conditions that may lead to UAF bugs in
ax25_heartbeat_expiry(), ax25_t1timer_expiry(), ax25_t2timer_expiry(),
ax25_t3timer_expiry() and ax25_idletimer_expiry(), when we call
ax25_release() to deallocate ax25_dev.

One of the UAF bugs caused by ax25_release() is shown below:

      (Thread 1)                    |      (Thread 2)
ax25_dev_device_up() //(1)          |
...                                 | ax25_kill_by_device()
ax25_bind()          //(2)          |
ax25_connect()                      | ...
 ax25_std_establish_data_link()     |
  ax25_start_t1timer()              | ax25_dev_device_down() //(3)
   mod_timer(&ax25->t1timer,..)     |
                                    | ax25_release()
   (wait a time)                    |  ...
                                    |  ax25_dev_put(ax25_dev) //(4)FREE
   ax25_t1timer_expiry()            |
    ax25->ax25_dev->values[..] //USE|  ...
     ...                            |

We increase the refcount of ax25_dev in position (1) and (2), and
decrease the refcount of ax25_dev in position (3) and (4).
The ax25_dev will be freed in position (4) and be used in
ax25_t1timer_expiry().

The fail log is shown below:
==============================================================

[  106.116942] BUG: KASAN: use-after-free in ax25_t1timer_expiry+0x1c/0x60
[  106.116942] Read of size 8 at addr ffff88800bda9028 by task swapper/0/0
[  106.116942] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-06123-g0905eec574
[  106.116942] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-14
[  106.116942] Call Trace:
...
[  106.116942]  ax25_t1timer_expiry+0x1c/0x60
[  106.116942]  call_timer_fn+0x122/0x3d0
[  106.116942]  __run_timers.part.0+0x3f6/0x520
[  106.116942]  run_timer_softirq+0x4f/0xb0
[  106.116942]  __do_softirq+0x1c2/0x651
...

This patch adds del_timer_sync() in ax25_release(), which could ensure
that all timers stop before we deallocate ax25_dev.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[OP: backport to 5.15: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 3116d8d1b5cf..7b69503dc46a 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1053,6 +1053,11 @@ static int ax25_release(struct socket *sock)
 		ax25_destroy_socket(ax25);
 	}
 	if (ax25_dev) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
 		dev_put(ax25_dev->dev);
 		ax25_dev_put(ax25_dev);
 	}
-- 
2.25.1

