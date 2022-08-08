Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD9958C293
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 06:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiHHEi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 00:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiHHEi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 00:38:26 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7ADDFD9;
        Sun,  7 Aug 2022 21:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1659933504; x=1691469504;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Df6WX/ZwH8Mi3Xg7D/7p8FRtLTDSkj+t7BXe3aOK+ao=;
  b=iLSKO3wEQOCeIPVlQazj2ikAM1FZ9pedidwCPBF8x9pmkD74CjCT3Tai
   pHBv9OgkYDWAZXoOL2Oz1SfvJbfzwf0YFX32RMQWd34X+/q5Ji8dI0LLb
   R2CZROTRqfnH2KSGeXk0cs0p5VgragcyWoL23k1K1SlX51b9hVhnVOg+f
   TwpIiP1jv3uZaF8psXyNPZ/r1I+6atMTs9sXzBBngzK7eIuj9FAFCYS+5
   mjSycpMrkdNN18zxJe1q4AoMDjcd/m2wi29CLOPKquDYnvhFNCkPYTU3C
   caRtw4Kf1745tKpNUGck0UFwAajmdsO4i6IKK4jokFQG9BDgVXlZ5BNyy
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,221,1654531200"; 
   d="scan'208";a="208100750"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2022 12:38:24 +0800
IronPort-SDR: OC0avRq+6wyD5sADQRE7WVWBzML2JvM7ult007nu/oi6j4iF/pY3zH+tLn7OVrtPNgzrbShyTb
 1Re6Ws2i6BoVpVy2Mams94GKtj9leiMXgtfmirGzirV1ErwJ2y2ShA75uJyBB+pdQNQ+dsPvVD
 7zPE0MRl+HHggRyaYp/Dkxd4SdlYnN5wnM8omh2+eFP+BkUmHMTy72tLi+JVnaVMVuD3SeW9uJ
 o51Zga9J4zrrY9BxU2GLhbQdqU8qR0XjoUnAgCze+3n+kYGCsRiyUx7BEcmOpLBt0r8Gr1jB9X
 2fCjI6JrpxjbvTrU7dJ2i2wp
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Aug 2022 20:54:06 -0700
IronPort-SDR: H5HBszcPr3gbVHHkYHZ+UyOIkY1Ro31t1y61abYrcUzTDiYeQaC/KIFLKMMs6PzH2YcNH49g1w
 kn79+P72Bi107zqfaCb/y8KXmn6oj2UJJ2xYGHRU1SVPImSy0Vl0CS2Pyy/D/vSX4GF4qXJ+Rx
 /smzgOc2llWutUGH38d6RrAMsYH9uFbRLjYzupMGlAJ7CoaoMMew63XrVi2Ma8t9lQhStNyKGS
 /1d+zMSLInWoKsVEY8WDZHmIyt4jzU4B3ltZnzTI28HjSbSJU3y1NWU1eXr0Va/g37v/l+7/Fo
 mRE=
WDCIronportException: Internal
Received: from ctl002.ad.shared (HELO naota-xeon.wdc.com) ([10.225.53.129])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Aug 2022 21:38:24 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH STABLE 5.15 0/2] btrfs: backport zoned mode fixes
Date:   Mon,  8 Aug 2022 13:38:16 +0900
Message-Id: <20220808043818.1183760-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series backport zoned mode related fixes to the 5.15 branch.

The patches are common among backport for 5.18.

https://lore.kernel.org/linux-btrfs/20220808020201.712924-1-naohiro.aota@wdc.com/T/

Naohiro Aota (2):
  btrfs: zoned: prevent allocation from previous data relocation BG
  btrfs: zoned: fix critical section of relocation inode writeback

 fs/btrfs/block-group.h |  1 +
 fs/btrfs/extent-tree.c | 20 ++++++++++++++++++--
 fs/btrfs/extent_io.c   |  3 ++-
 fs/btrfs/inode.c       |  2 ++
 fs/btrfs/zoned.c       | 27 +++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  5 +++++
 6 files changed, 55 insertions(+), 3 deletions(-)

-- 
2.35.1

