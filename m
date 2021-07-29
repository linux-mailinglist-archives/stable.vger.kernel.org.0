Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0753DAB4F
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 20:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhG2Srq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 14:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhG2Srq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 14:47:46 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5213C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 11:47:42 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id ec13so9018625edb.0
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 11:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tw2ySuf27aIpKmZnkUKHXOQm+nviWsB0DB5kepYXSf8=;
        b=MwK5J7u01LRaC5D6hltWl2iUAgfViOS7N+VvLxmPBY+juJZX9pZZLRoRSI33xdPs/X
         jXDeCAPJL3C7/yY1LktRNfogdV5F/HtUGEc7C1vRjGRBTfyczQ7fGtAOA3SWGdAIw/kw
         iI9EX9E/IYtDNAXPSmYBACK6r//IG6tB0QZpK7+gLKO7e6rvbPQhKnvz8q+g4GvXQvpe
         qIxQX5NlPvL9Ymeu/5EwhkMd4Yk6UMSR0ufra31hsLqGiL/dqqvfvqX5WjeaZanB3n9S
         wfehCqVdUzXuzyXyA0wywHBd9GqjGFaoAkTxKMK5mdCYkMTw067sGKqGXNPKQaOCI9+m
         VV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tw2ySuf27aIpKmZnkUKHXOQm+nviWsB0DB5kepYXSf8=;
        b=EHHRvrd/fVbs8R+cnOghJflMR3RRH3i+M/DYYL+0k5CMEzOtNkZaXFYk+5rQLtbL+V
         Th2AUADdqBMRp7H05q2Xh7gn/VtfWbrICpt+SWFzC6MqfkvKA7/3cPqBkl96y8oEDDbT
         3UsHUGPE8NoWQRZoKBbehx6rkoEm9a+1J4pUJLOdpHc4JSYMBKEg/oop3CMP7L+3xsyl
         ID7yQ21MiTsveah1ge8fMhyjpbWUzf6iRUYqaDjvWXolQVX1lMlKTBgKOrRItVEUJJWp
         Ulq0RgVhIx4OGeGRjvx2yvcdGajOkEg7RnoNwjRjNtxHijhPn6WloV6A4l4rgNl+jTnE
         JyWg==
X-Gm-Message-State: AOAM533R35c6YFcpFvYMfmbgH/6NzpUZdc3pqPZglcV9RaRM3lbS86uC
        66GWcasCgAho0NEo/5SL4+4jmxePnDraCGV7
X-Google-Smtp-Source: ABdhPJxzFUDMUtQeO4Ju7kIjBGZxm9dpRJfq4P8wj4rN87m8bS7wn9Qoro7UcNThE11DHzs0UuFrNg==
X-Received: by 2002:aa7:dcc5:: with SMTP id w5mr7799888edu.355.1627584461098;
        Thu, 29 Jul 2021 11:47:41 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id c14sm1250207ejb.78.2021.07.29.11.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 11:47:40 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 4.14 0/2] Backport fixes for 3226b158e67c
Date:   Thu, 29 Jul 2021 20:47:31 +0200
Message-Id: <20210729184733.3217814-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny skbs")
introduces a ~10% performance drop when using virtio-net drivers.

This commit has been backported to v4.14 in commit 40b95b92f1db and this
performance drop is also visible there.
Here at Tessares, we can also notice this drop with the MPTCP fork [1]
on top of the v4.14 kernel.

Eric Dumazet already fixed this issue a few months ago, see
commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head").

Unfortunately, this patch has not been backported to < v5.4 because it
caused issues [2]. Indeed, after having backported it, the kernel fails
to compile. Please refer to patch 1/2 for more details.

A new version of this patch is proposed here fixing the compilation
issue. It has been validated: it fixes the original issue on v4.14 as
well.

Please note that there is also a fix for the fix, see
commit 38ec4944b593 ("gro: ensure frag0 meets IP header alignment").

This second fix has also not been backported because it caused issues as
well [3]. Here, it was due to a conflict but also a compilation error
when the conflict has been resolved. Please refer to patch 2/2 for more
details.

One last note: It looks like it could be interesting to backport these
two patches to v4.9 and v4.4 as well but unfortunately, the backport of
these two patches fails with conflicts and I don't have any setup to
validate the performance drop and fix with v4.9 and v4.4 kernels.

[1] https://github.com/multipath-tcp/mptcp
[2] https://lore.kernel.org/stable/161806389310822@kroah.com/
[3] https://lore.kernel.org/stable/16187490172453@kroah.com/

Eric Dumazet (2):
  virtio_net: Do not pull payload in skb->head
  gro: ensure frag0 meets IP header alignment

 drivers/net/virtio_net.c   | 10 +++++++---
 include/linux/skbuff.h     |  9 +++++++++
 include/linux/virtio_net.h | 14 +++++++++-----
 net/core/dev.c             |  3 ++-
 4 files changed, 27 insertions(+), 9 deletions(-)

-- 
2.31.1

