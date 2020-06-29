Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5761120D824
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgF2Tgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:36:32 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:54693 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729305AbgF2TgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 15:36:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593459383; x=1624995383;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=b4/y29sI+1yiTQiF1xYesH4kt0pQMd5eSrVNTpeSPi4=;
  b=LhMrpjSDf/mnZHYhSrEDPKDmdrPwxiQfr1dbGMLPojkN6ps2Afa7AiEa
   Vg3gYnKcTSWGjSF2j8DBPkd7PVqE78er3SOTq6THG/PC0pHFD5xhJCVPf
   c5Zgpk2UuTgvDaEIoxB9kIq7GKpENd0xy7PTHSilfNgCtiOvzgmi4YkwW
   s=;
IronPort-SDR: 30ZfxPliLXRENJTl2hI0YJ7tElU9JTYqigHOFsbk/lUG7zcXVx6pI7nW0ogcDx+3yHCtxim+sP
 YCQMGiTTYanQ==
X-IronPort-AV: E=Sophos;i="5.75,295,1589241600"; 
   d="scan'208";a="39176521"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 29 Jun 2020 19:36:19 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id B7CFDA1C47;
        Mon, 29 Jun 2020 19:36:17 +0000 (UTC)
Received: from EX13D31EUA004.ant.amazon.com (10.43.165.161) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 29 Jun 2020 19:36:17 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.48) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 29 Jun 2020 19:36:12 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>
CC:     <sj38.park@gmail.com>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Upstream fixes not merged in 5.4.y
Date:   Mon, 29 Jun 2020 21:35:37 +0200
Message-ID: <20200629193537.21738-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.48]
X-ClientProxiedBy: EX13D04UWB001.ant.amazon.com (10.43.161.46) To
 EX13D31EUA004.ant.amazon.com (10.43.165.161)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,


With my little script, I found below commits in the mainline tree are more than
1 week old and fixing commits that back-ported in v5.4..v5.4.49 but not merged
in the stable/linux-5.4.y tree.  Are those need to be merged in but missed or
dealyed?

9210c075cef2 ("nvme-pci: avoid race between nvme_reap_pending_cqes() and nvme_poll()")
9fecd13202f5 ("btrfs: fix a block group ref counter leak after failure to remove block group")
9d964e1b82d8 ("fix a braino in "sparc32: fix register window handling in genregs32_[gs]et()"")
8ab3a3812aa9 ("drm/i915/gt: Incrementally check for rewinding")
6e2f83884c09 ("bnxt_en: Fix AER reset logic on 57500 chips.")
efb94790852a ("drm/panel-simple: fix connector type for LogicPD Type28 Display")
ff58bbc7b970 ("ALSA: usb-audio: Fix potential use-after-free of streams")
ff58bbc7b970 ("ALSA: usb-audio: Fix potential use-after-free of streams")
8dbe4c5d5e40 ("net: dsa: bcm_sf2: Fix node reference count")
ca8826095e4d ("selftests/net: report etf errors correctly")
5a8d7f126c97 ("of: of_mdio: Correct loop scanning logic")
d35d3660e065 ("binder: fix null deref of proc->context")

The script found several more commits but I exclude those here, because those
seems not applicable on 5.4.y or fixing trivial problems only.  If I'm not
following a proper process for this kind of reports, please let me know.


Thanks,
SeongJae Park
