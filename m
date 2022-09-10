Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC625B4766
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 17:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiIJP7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 11:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiIJP7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 11:59:05 -0400
Received: from GBR01-LO2-obe.outbound.protection.outlook.com (mail-lo2gbr01on2138.outbound.protection.outlook.com [40.107.10.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE61C402EB
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 08:59:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hD1dl2wU+AH6e3PYCnMIP1cfw1rXHOx35S8Cxu6zvvBwYACT72RJOpcugvQ9fRnuc5o5r0V5hg1/gJ50Hh49grd0k9J1nIG6AhQzCqmFXjRju2t0Eqy0aqP7iDZlRk7gWBb2wT7kUsbRlhzRXmnd3NTJWRFFNvOC9murZZEorBqE8/JLfuCbo9M2NoJmg45UPO+w1CNkMbQJMP+N31SJnQYoSyXWGapDvoRKLP21BV1FEArzUsYgNIIWAoX2FkAYZmTURRLWlej6ymJwb4KprGi2sc/nKKZfThpFbZLmZ7KC1DbBxW+++0A0YGsBYGS/q3k2zTUPIOCWgcEnChQd9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBPFa7MGeTYvYVqOcxXaITvG7/CL+n+Ks25/6RwPIXs=;
 b=eVynGXgDzweY/uW1mRKofoiV6jRUwR2BBEZc6y6jQhrGHP4v6N7945oVRm4oZhMkIckR3NRec5QTNbDWlnzgw/UJUhTd2vvZZ97B45RliufE50dMCtY7mrrVN0irIB+Vs0icgsKa4YK7yxBWXzmUx3HhLatOz+O3lKvscn8omQBQsOTlsi8Zw8dbfLOcsAOKKdSqa8SFv3BMzjUdd4YODA23fUTcdd0ZOEvd9yU9L/rj6W795zpqXbjN8tXsalpVxvgLylFmSBXMQKL72ZePkkYWabxPnfT+3sRcdzQdZdthVVaXehsup1OFETMGswQW2wv64dbtehxK6e72+MJY9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bywater.xyz; dmarc=pass action=none header.from=bywater.xyz;
 dkim=pass header.d=bywater.xyz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bywater.xyz;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBPFa7MGeTYvYVqOcxXaITvG7/CL+n+Ks25/6RwPIXs=;
 b=CfuDFue0cOOmqfQ8IrovyTf/KpvX4JxPcLfHE0vNCl6H05vUQ5ky7HinFDlsOdLgTwT6hOpzAJCs64cVxKVcwBxY65LJwYOm9hg9s0tn+BBX0z5y8pQPpSc7McGp5EAO7grFJZfcYv03rkj8oT5S4APv2Z5piMEPqGD80fJbqift81P6GssZJJ7pnbNySVblVR+MffQinPb6ypjQSTgehIo5eh1BOojMFv5YmLzkqT5SleJt1H04FrskYq5AH12wGXwBBd2IMbQ0Fhrgq65RTiVoaLogJB3p3F/JuzvSvO1SlIBnKAEbfkDDlnmrkdoCvdVxXMJM0hZakhQPixMFCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bywater.xyz;
Received: from LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1f2::7)
 by LO4P123MB6466.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:29a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Sat, 10 Sep
 2022 15:59:01 +0000
Received: from LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
 ([fe80::e11b:26a4:86c2:f2f5]) by LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
 ([fe80::e11b:26a4:86c2:f2f5%8]) with mapi id 15.20.5612.022; Sat, 10 Sep 2022
 15:59:01 +0000
From:   joseph@bywater.xyz
To:     joseph@intrigued.uk
Cc:     SeongJae Park <sj@kernel.org>, stable@vger.kernel.org,
        Juergen Gross <jgross@suse.com>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: [PATCH 01/50] xen-blkback: Advertise feature-persistent as user requested
Date:   Sat, 10 Sep 2022 16:58:04 +0100
Message-Id: <20220910155853.78392-1-joseph@bywater.xyz>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2978; i=joseph@bywater.xyz; h=from:subject; bh=Syz5fBkf9uFk91zwWvYU1UBBoe5BWbs10nFssg4xJaA=; b=owEBbQGS/pANAwAKAXxHkY8fXCH/AcsmYgBjHLQBqfmgr0+NAJdj/KA8RDpX/1kK5TeJsmhjY9bV v/+kk3SJATMEAAEKAB0WIQRiG5oO6weufXC5rRB8R5GPH1wh/wUCYxy0AQAKCRB8R5GPH1wh/wsnCA CFMbrLcb62pRtxqIt+Pf1Nvbzzjva5nBP1GJGNm7Qouui2vzscBhwH1Yc0hJdDtlBsfg5k45e9m1e6 lIUvEzJi90e6m2pJybcforRKbKnK1fzqkTifbCWN/1qk4PIDIyPk5FozqwNDJm40NoaVUuQpd3KBFE ORgbgOdhCXXdcj8iUvbbcxy1xf/PGQEVT0ZW4pbsjh99umD5JUf0VoAsloj62QcrWCF/MxAbqh2vjH drKT/k/o8y/HWaljA6AZmnQd2IszCJoh+4D3uokRPwKmJk59fZ8xhJP68dLQ83B2Gqjp+WOnU6XWHn 1nde4456EP6XD6dIxtVqWgZvkis7i0
X-Developer-Key: i=joseph@bywater.xyz; a=openpgp; fpr=621B9A0EEB07AE7D70B9AD107C47918F1F5C21FF
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0093.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::8) To LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1f2::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO4P123MB4995:EE_|LO4P123MB6466:EE_
X-MS-Office365-Filtering-Correlation-Id: e4eb84d3-4642-45b2-1de6-08da934560dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LpfrqMfJ95VPExKGtF3N2h2NpES23O2r0pN5KQsJg2A9JccD/B5Lv0ca20/YD8Z7GhwMshjx/bHcsm2F5Ps70TM6Men6oNzHyf81Ivdsvkv5rEVQf4R/dM2QgGrhkq9BnG0jVhMk2s08RoJMabYckd6UlHDkatB9gGNwSEOV36WBn0tLvIs5ghwWugJilD82GlttQGjh00MSvi7ZgB1dGyggHJwra/TaoPN0LQ4c7emko7rM2gR5sUPZL8+yhj8vZeEZS6YZaQQ8uYzrpW5lCE3Yrrw+erSTYzHtUzQTKmX/sZXl/IYhyj3JzCvZqHscjjc3hPshsrLo31itwxo5RgmnD/HxZfinPLX4emTIGi3ubsrxfgKa6mk4+be7OKkU5aTtKvemALZZ1JPzFxSGrJzW3fK8ySWxqhxOTw79RuwNvLg6arIxDnVkY/1PO70XXNqL1RT0siIx5qIP7qCzuMrSnzmJDamY1fmH/YoZEzaD2N+/4RPuV0pgxQyK1V4VOOF4XOX870+OSOznKB/5aDw9qDq+70EbHhh5ceNyUVVRCdkQiHyM9uu85h/fHuMSdMX3+y2eQLM7DrAjrNb0iGdNGM9jZJDkUY9x2uh2T6GKKVaKukEaIIP/hj0LK2AkmAuao0tKTbhV4SkFBdavBwB5wWVo1HXfa7pwHDOAbZtyGkMquLRgGa5Bqje+xJDseDVQnAkjsd8h3ng82auFh/iZs+g65XU1Po0JzLceLg3FKCzF1hSDmxk4fY1t4+S6s0ajsFP9fX/uyf88/Jg6UAcMFIAuHuQxLGCuRFfsdjA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(346002)(396003)(39830400003)(376002)(83380400001)(54906003)(966005)(316002)(6486002)(478600001)(36756003)(2616005)(2906002)(6512007)(9686003)(1076003)(6506007)(186003)(52116002)(86362001)(38100700002)(8676002)(4326008)(5660300002)(66946007)(66556008)(66476007)(8936002)(41300700001)(34206002)(4720100020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDloa3JjNllGbHJFY0IyM0I1L29DMENrQUhsaXFnUEFtVGo1a2l2bjhwdEJF?=
 =?utf-8?B?cGNYT3MxNmlIdzZKZk43STJBb3AveU1RYnJzODZpcmRsYkRzVmttT3NYSXBm?=
 =?utf-8?B?QUZaeW90UVY2aUxWbGMvUENtUzZqVDJtN3R6NEh5ZlpuUkRkd0kwK295QnRV?=
 =?utf-8?B?Sm9taEIzLzN2OGlwSVo0UWFiNnJrTWNlREFHQ3BqN1Rua29wa2JET2c4UjU3?=
 =?utf-8?B?OXVUdzlPU0tsdVB4NVJmMUo1bXpDVEVYUGVjazRPUXNlNDNYLzkvclg1RXp1?=
 =?utf-8?B?RWFlR0VPNllxdHdBR0V6OXdWN2k5NU4vMThzUDVYdWVWQnhEUU9jVDU1bnVV?=
 =?utf-8?B?S2V6d0pXTzZoOHQ0YlpNT0hTZGVKWFNFQXJpQlRocDdNUTEvREhpS0JQVkFE?=
 =?utf-8?B?bkcyWVRwVUdodFptdmNWRW51U2N6dDdER05ibkpNN2dTVEUrN1AwTVNEYlQ1?=
 =?utf-8?B?WFZWb29IcDFQcWdUdThQL3dYQjZkcW9IeUJCREFJNExzYk16cjhwaVMvaXBQ?=
 =?utf-8?B?cExSYi9KT1I0V0U4aXgraHZwK29qWTRUaDF6YW9sQ0dYenFmdW5EdzRvNkpw?=
 =?utf-8?B?SUZQZXNMaDR3ME9qaHZnRGE5aCtsNnFmNkwzaitOVGZBanU0U3FkTUdkNE5S?=
 =?utf-8?B?bjBQUTlYTGFyVzdwcHVFc1hlaUFKbURMVFJHTndWeUYrTno1YkVZK3o1N3RN?=
 =?utf-8?B?NkxabmdydHBLOG1Ea0xwYXY5OTAySG9ObzNpSmIxZ3ZNakh5SGxZdFlrV1d6?=
 =?utf-8?B?VG92ak9KU3k3L1phOHJWazY1TXJVTm1lNm50L0ZuMWVnQ0FPajdmaEVtQXFx?=
 =?utf-8?B?bnNVUE9JdjFWZUcrWjhZRS9TL2ZGb1pSN0hFR3VUV3o3cDJOTE0vOGVqcGo3?=
 =?utf-8?B?bFRHdTRDblVmTzVaODJRSXlwYU9kakZSdkpXb1pWbjQvc2U5YzhZaURFa1Bn?=
 =?utf-8?B?bjJKdWROR1hVY2hSK2VOTDhuQ0RkUkY4RnZCdlN2VEJ0bUQ3L0IvYTFMdDI0?=
 =?utf-8?B?NDNhVVl5UkN5cWE2RFRhNE5YaDJKai9OODlaZUxqTm9TS0RRR2NKbURQd0xP?=
 =?utf-8?B?N2NHWUxkay81VzVqMUxvRHdmN0JicXdoNWttaWR0U253QTVpN21RekNrSnBw?=
 =?utf-8?B?b0ZFMTlnYWsxY1JBS0dmK3JReS9TK25lR2NaMU1TT0ZJVG5UUmFxc3JZSm54?=
 =?utf-8?B?WVM5QkpzbWFDRW1WN3RyNDA1TVlOU3BUSVdPWDRRQ0QvUEozLzlicXEyVTRa?=
 =?utf-8?B?aHpPQkhyQUNjMnlnSE00ZWxIeUJHb2pxZC9WRjVHZDcrZHJCcmhqbmxkZWFK?=
 =?utf-8?B?a1RGNXFrRGVtOCtGK0VNM21TaHYyNDlEU1ZUbXRpc1Fadi8xNkRMTVUvQ21W?=
 =?utf-8?B?VmVaczZER3Jab2syQ2dYWXY3Ykd3WSs4cWZRejlqczY2YXpGeHd0bDdPc2p1?=
 =?utf-8?B?bnJIRlZVRE10cnE4MHJ1NVBEN2pJR3pQVS9KNUJkc1M5VDcrK3pGblVGd2ww?=
 =?utf-8?B?Y3hSb1ptWkJ1eWduTGlqekF1TmJPZFNlWmYwM2I2MjdwZEFKN0YvYnh2Wm8x?=
 =?utf-8?B?WGpKUDZIZ2hwWklpUE9JQ1Q3V1huSDZaUnNWdFY2dStmelZUdzA1SWp6cDRY?=
 =?utf-8?B?WjNGQVFXa2srQjBsTGM1OTB3cTdyZ1BrUlNWVU1peXkxam0xbjVlTmlSQlNW?=
 =?utf-8?B?L0FxcUg3SW9ScGVMN3JNRUxMdlZrT2pRYi9aRFNZZWRQZXNjNVlibzlKMDZr?=
 =?utf-8?B?WVc1amt2M3hmN1dLNEJUenhZUlFxTGFUdkJqTmUweWtvSU1TUE9ObkhlWFY4?=
 =?utf-8?B?WXQwUkZick4zVXplWk5zalNNUWpNR2lXMkhmVEtRb1RoWHRJTHRpKzVWQmJq?=
 =?utf-8?B?QVYwN1dWRW1mRjlua0wybE5kRUJkRlJ1K2Y2OTRSUUNwNE1HYnNiaTRRM3Fy?=
 =?utf-8?B?bVYxcDdoQk5Bc2FMT0NRb0RTNk5XY1BOcDU3MVRQRlQ1ZzZSN1BnOWtMenZ5?=
 =?utf-8?B?anlEM1pUZGRqdnRIWTNKSG43SjZqWk9Ea09UUmhwWkNsK2RNeTBBZUhRK1E1?=
 =?utf-8?B?U1A3aFNNY0w1bnBrYnVoRXpicXdqZFBMb2JWNlh6bDgyVnM1ZFBYQXR1OTY3?=
 =?utf-8?B?dFA0RTljOHNCMXZuMFBqck5rRTEzcDIrVTJSYUM5ZHNQeWE4b2FwbFg3cW43?=
 =?utf-8?Q?ugYO8Wv4/+fWCiYFv4NyjXSfK2DNELHiZvDT8d4CaBc9?=
X-OriginatorOrg: bywater.xyz
X-MS-Exchange-CrossTenant-Network-Message-Id: e4eb84d3-4642-45b2-1de6-08da934560dd
X-MS-Exchange-CrossTenant-AuthSource: LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2022 15:59:01.4727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 42dcc6dd-439a-483c-99c4-86bd4e2f0f10
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDPnmqju5E+PYZTcCKYzaag1wW+YIDtBw6nhkD/UjIoU1oqzam8Xom/dDq3mIs3il3K9yE3Z3lsI4bfMnry4kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO4P123MB6466
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>

The advertisement of the persistent grants feature (writing
'feature-persistent' to xenbus) should mean not the decision for using
the feature but only the availability of the feature.  However, commit
aac8a70db24b ("xen-blkback: add a parameter for disabling of persistent
grants") made a field of blkback, which was a place for saving only the
negotiation result, to be used for yet another purpose: caching of the
'feature_persistent' parameter value.  As a result, the advertisement,
which should follow only the parameter value, becomes inconsistent.

This commit fixes the misuse of the semantic by making blkback saves the
parameter value in a separate place and advertises the support based on
only the saved value.

Fixes: aac8a70db24b ("xen-blkback: add a parameter for disabling of persistent grants")
Cc: <stable@vger.kernel.org> # 5.10.x
Suggested-by: Juergen Gross <jgross@suse.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220831165824.94815-2-sj@kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/block/xen-blkback/common.h | 3 +++
 drivers/block/xen-blkback/xenbus.c | 6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index bda5c815e441..a28473470e66 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -226,6 +226,9 @@ struct xen_vbd {
 	sector_t		size;
 	unsigned int		flush_support:1;
 	unsigned int		discard_secure:1;
+	/* Connect-time cached feature_persistent parameter value */
+	unsigned int		feature_gnt_persistent_parm:1;
+	/* Persistent grants feature negotiation result */
 	unsigned int		feature_gnt_persistent:1;
 	unsigned int		overflow_max_grants:1;
 };
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index ee7ad2fb432d..c0227dfa4688 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -907,7 +907,7 @@ static void connect(struct backend_info *be)
 	xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
 
 	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
-			be->blkif->vbd.feature_gnt_persistent);
+			be->blkif->vbd.feature_gnt_persistent_parm);
 	if (err) {
 		xenbus_dev_fatal(dev, err, "writing %s/feature-persistent",
 				 dev->nodename);
@@ -1085,7 +1085,9 @@ static int connect_ring(struct backend_info *be)
 		return -ENOSYS;
 	}
 
-	blkif->vbd.feature_gnt_persistent = feature_persistent &&
+	blkif->vbd.feature_gnt_persistent_parm = feature_persistent;
+	blkif->vbd.feature_gnt_persistent =
+		blkif->vbd.feature_gnt_persistent_parm &&
 		xenbus_read_unsigned(dev->otherend, "feature-persistent", 0);
 
 	blkif->vbd.overflow_max_grants = 0;
-- 
2.34.1

