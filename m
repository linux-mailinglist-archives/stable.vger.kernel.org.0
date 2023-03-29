Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9786CD7A7
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 12:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjC2K3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 06:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2K3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 06:29:35 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A791BFC
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680085773; x=1711621773;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ZfiAFX8XaZ4Y2SnEwE3frv4lf93lUmWwveHL0oa12/w=;
  b=N0fm0P+ykQD5I5qiVYD5g3/0imlVPer2xAcSNA9iT2tsv5F6KoZa/VkD
   3VZ/Ls25UyxKL0uboD5QFKWAdaU1PvVtTEngrkdf360rh1t/fj+R5qLEL
   iMrP0Kky3MTy7nEFiJP8YpPJPgxKLq2jHSQismW/2ZBfMkX9Gb6LSK1gg
   HqW7tN3dsYfCOZne+E2CUQTim58hm3lyRPVHrsWFoBPpc7+sBlSzWcBiL
   MUgbFOE0RCIvi9oC3Lh5mP+92+xpCuhwIZ2p3UloGO/ZrjWGrMjMEmgCm
   DyskK7yHAu4xnQet0+PPA42aX/juqM27FQ8sEY0zxFGwGHUT60D4z02HM
   w==;
X-IronPort-AV: E=Sophos;i="5.98,300,1673884800"; 
   d="scan'208";a="226777124"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Mar 2023 18:29:33 +0800
IronPort-SDR: tSV2GF4F6WR2yJ+GNfxm9pHPrFYrxEZcxOqQwlGUVh998LOiezSEpfbu6sd60SSmh3rZZRoqpX
 4qOQK8IAW8Z8kUmQRFXFj2neIqt+YNJd6q69yDrSIBvIgh8H+pG1Yt5MkNq6txTUfpvnjyBVWl
 NV43xLYjz74XxiH7oHufwl8Sfkdn6kGMB5EiRnVcLg9bQbqXXRIDQUNrdzbVYbpKGURcNHGCr+
 M2A1LpNt2yjZmghVxIkS04CLy1W53jIej5Wu+6UqSfdup/oaOvylzLs129re3ezfE0rUdfB6JU
 mbA=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 02:40:02 -0700
IronPort-SDR: tA/FvFUdvtiyzGjiDvf5WEQO6LJu8OGPLox2aoJb3zThMRjA99xGdr4afBFhQyUop8Wmnu8sLm
 w8HsV4EthhFF+eQn5bp3NBOpdNpTumfeYTEdhmvdzEGCwn6MBRioOivqR3EuaVyOip87MXIh56
 4bM5leY8JGMDpFnw7P+9D+5yrAA5Tc3CsgxfOKShHfLj7OxhDwWDQDHMkkwbzrUcFIVofdoIV5
 Ab8FSLU5BLGYr+XhqRva4Me9R4hdXdyygz5QinOazy0vW4Wn3igsHvIfx2+0evNJbMJTi2KvCJ
 wd4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 03:29:33 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PmjTn3fL9z1RtVn
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:29:33 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1680085773; x=1682677774; bh=ZfiAFX8XaZ4Y2SnEwE
        3frv4lf93lUmWwveHL0oa12/w=; b=tsQoSKw382fgToneNjvsoVASPVl1Rmdiib
        qikTiP8aIH1NIE4meu1HtcEN85hcF0sqo381nF73JNxzVLTCe+aIPSdoEFxNXVmC
        HLYd13uuyI1KJMPviy8JjSQhOPArhnj0pF1VEt2pkI75mxypLHqU3PCpI8XSp32z
        rB4u/HXCr1LcAATFr1jbKUj6Trk+fPgiUFUaJTIwDKbTk99rSPVO4EpT2g0H5+XF
        +6xXn1lphaYejs0SmmvwY7GqnrVcUL2GI5sy/8tbQpHT1pGXO2jnoiU/sWV3IUrq
        TkHUUQo00SuTwfFx2gCvdfFV/Jc7bHwrLsEp/NYx/NUoFU160zmg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 19r5r_sO9eWz for <stable@vger.kernel.org>;
        Wed, 29 Mar 2023 03:29:33 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PmjTm6J5Gz1RtVm
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:29:32 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     stable@vger.kernel.org
Subject: [PATCH 6.2.y] zonefs: Fix error message in zonefs_file_dio_append()
Date:   Wed, 29 Mar 2023 19:29:31 +0900
Message-Id: <20230329102931.1788623-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1680003625145213@kroah.com>
References: <1680003625145213@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 88b170088ad2c3e27086fe35769aa49f8a512564 upstream.

Since the expected write location in a sequential file is always at the
end of the file (append write), when an invalid write append location is
detected in zonefs_file_dio_append(), print the invalid written location
instead of the expected write location.

Fixes: a608da3bd730 ("zonefs: Detect append writes at invalid locations")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 fs/zonefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index a9c5c3f720ad..2d9027eb48a9 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -822,7 +822,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *i=
ocb, struct iov_iter *from)
 		if (bio->bi_iter.bi_sector !=3D wpsector) {
 			zonefs_warn(inode->i_sb,
 				"Corrupted write pointer %llu for zone at %llu\n",
-				wpsector, zi->i_zsector);
+				bio->bi_iter.bi_sector, zi->i_zsector);
 			ret =3D -EIO;
 		}
 	}
--=20
2.39.2

