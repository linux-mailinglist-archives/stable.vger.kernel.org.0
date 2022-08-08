Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7705558C185
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 04:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242489AbiHHCYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 22:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243793AbiHHCYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 22:24:30 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E291145F;
        Sun,  7 Aug 2022 19:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1659924146; x=1691460146;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rYvw8wQnwsQt9UPNT2uO9umpF+i3+lvgLIKw/BwgAh4=;
  b=CFy57R56OYN3e+8H4yKmixojhDnggwplwvEqVcDOz8AkHSAXqrR2aIdr
   6JY4tX08uxNzicfTryq+St96O7SwBU/45jPz3GTcRJqQH7UgBBHP5G25R
   cVzE9Ky5cuveZFr/5R0vUGgaeA3JIjSR1ix7ScCoCNICCFPH8oAGfFapC
   XSNvKjLRwHdapY7WnpxsfvLlp5sUeUN2RWfD8RGb4i9xECbB5yAnNiAhO
   O3HYzIJzupTeXwimCsR9BJ+/ME3XjemKvZzeHZcT2z9BXvakGxwAFC6b8
   dNKER1dCpk4tXhH/u2XyN3R1yyrEO5b5lF0VYa/eFAjUnEETTAlnmsmBj
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,221,1654531200"; 
   d="scan'208";a="320182407"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2022 10:02:26 +0800
IronPort-SDR: 0QGGploBRPX+vZdhp4qRktpAqNPDwMbfI8YCbo4tNycWy2QnU48oYmdiqQY4ZzRasgCxvwkhBh
 KPP+Y1WKo2smYrtF5+q2+kI1oc4qGU1CuAxuIc+yX7LvP2PhY69iQyFZGPDQVFUWka0HtUPwQ0
 TRQcFGjCB29XX+bL6qF/vsdHxB8++ZgOt2DS7pCwn6y6fOMsCl/+jHCZBIKPl2M7/FRCUsVLcr
 b52rZ5955vkbgXQEARHCmh3lElk5zBD8X8VCoMqxbHuv3CZgq9Y4tcYCWyU19e6NJL/hRuCsxV
 W49Vhq7cGGjkGzuGjPLZu5kx
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Aug 2022 18:18:08 -0700
IronPort-SDR: /DU3K7jtiGdDduu1pD3YZsugp/arDcqTKK5lcuQphC/ZP9pi7K/7dYVyiPeV4FITbD0HVSNd9B
 A4g+t3XBJ8Tc9baLs+cexwumcyMwBaZZcxrlaqCwdcZUATzxowa781Uo3onDyXlmNdGMfoRitP
 JRqYupPfqJqWVCr9yxe3ThJsQEgCrYCFojgx8xlVID7KvcueTV6zFBq9qehduMS0tO98B48FOh
 VRiUVidkxQpd6xhHcb+aEXzsUFoROvG5nKgs73nImeEIiUGNnra+yZtxDMqpT/1t1wM07TiGJQ
 lOA=
WDCIronportException: Internal
Received: from ctl002.ad.shared (HELO naota-xeon.wdc.com) ([10.225.53.129])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Aug 2022 19:02:26 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH STABLE 5.18 v2 0/3] btrfs: backport zoned mode fixes
Date:   Mon,  8 Aug 2022 11:01:58 +0900
Message-Id: <20220808020201.712924-1-naohiro.aota@wdc.com>
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

These patches are backport for the 5.18 branch.

They all fixes zoned mode related issued on btrfs.

The patch 3 looks different from upstream commit b3a3b0255797 ("btrfs:
zoned: drop optimization of zone finish") as a refactoring patch is not
picked into the stable branch. But, essentially, they do the same thing
which always zone finish the zones after (nearly) full write.

The v2 just amend a line to add a missing variable declaration.

Naohiro Aota (3):
  btrfs: zoned: prevent allocation from previous data relocation BG
  btrfs: zoned: fix critical section of relocation inode writeback
  btrfs: zoned: drop optimization of zone finish

 fs/btrfs/block-group.h |  1 +
 fs/btrfs/extent-tree.c | 20 +++++++++++++++--
 fs/btrfs/extent_io.c   |  3 ++-
 fs/btrfs/inode.c       |  2 ++
 fs/btrfs/zoned.c       | 50 +++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/zoned.h       |  5 +++++
 6 files changed, 73 insertions(+), 8 deletions(-)

-- 
2.35.1

