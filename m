Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7463688FB
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 00:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbhDVWVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 18:21:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238922AbhDVWVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 18:21:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619130022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=tgQyxuFNIWv2WFwGCh6y2wdSkYdHkTXHx4X2Bpzjy2I=;
        b=HP+d12yBLmHIipwN9ACa6yrY4L8RxDcVHWE90COWvMT2redh/FX55Bi0zrc5JXHZ6VR1nr
        WlOn5DhHGv+pU0Gn2Zhl8Z4oyConXdvnA+e/xYVMaT30mWABtfnvWMqDbpHc95xEYGQw2k
        JSvFdhahPm+WK4CChyH8Itj3fA5Y+d4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-PjXSggNsPruGM7kL8oevNQ-1; Thu, 22 Apr 2021 18:20:20 -0400
X-MC-Unique: PjXSggNsPruGM7kL8oevNQ-1
Received: by mail-ed1-f70.google.com with SMTP id h13-20020a05640250cdb02903790a9c55acso17478587edb.4
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 15:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=tgQyxuFNIWv2WFwGCh6y2wdSkYdHkTXHx4X2Bpzjy2I=;
        b=j5D9QcH71W0PI1THHwcYBgEZFO8wbskz6AHqw3WkfDkwkRg74rav24LuuLyk+Ax3my
         /m2hWB7dKUznhCPf92TTtX3bR0qrzNs8PSv6/8rOzC0y13PbWqcNpTEZOcx1ZG3OJpln
         YzOaPI303hkZtWVb/YLwMvfdIePgph0qZv7DYVbZhz5sGQ27DESb24dNBGqHL4Bzmjhj
         5kVk3PDW6zyjt9fgQe5Ds1ZRkoipN1Ct5Vh1I44JCUJqVCzU2XJsAK/85lRbFC3ZOhdJ
         WrAysa3fXPF6K3I3DL7LcXx0cJG55Ie20BhA2bMFcIIFGd43iToRtVKSDHzYBL9B/cjX
         PXgQ==
X-Gm-Message-State: AOAM533YoO2ATCju9efTkk+FbwfIGXrUV2oGf6Xn7Ymwzp2XV1aHNB7x
        ywGK3uAbLKsc7VgdLiVcGXEbyyVg+2uUbXCzUvb7swYovI6LSYkkTWzMe5sd0jYvZqbaY7b0hsr
        Mr2PZQCXdas9lRkiw
X-Received: by 2002:a05:6402:1912:: with SMTP id e18mr807277edz.184.1619130019727;
        Thu, 22 Apr 2021 15:20:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJy1AtNvC1yqgjKWu6Iev/lJ2pAgqjtkiG2OyAAr4aeu8ke3P5mSsVUhBCU4b2QDNeMyBTxQ==
X-Received: by 2002:a05:6402:1912:: with SMTP id e18mr807263edz.184.1619130019602;
        Thu, 22 Apr 2021 15:20:19 -0700 (PDT)
Received: from redhat.com (212.116.168.114.static.012.net.il. [212.116.168.114])
        by smtp.gmail.com with ESMTPSA id u1sm3177747edv.90.2021.04.22.15.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 15:20:18 -0700 (PDT)
Date:   Thu, 22 Apr 2021 18:20:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, elic@nvidia.com, jasowang@redhat.com,
        lkp@intel.com, mst@redhat.com, stable@vger.kernel.org,
        xieyongji@bytedance.com
Subject: [GIT PULL] virtio: last minute fixes
Message-ID: <20210422182016-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following changes since commit bc04d93ea30a0a8eb2a2648b848cef35d1f6f798:

  vdpa/mlx5: Fix suspend/resume index restoration (2021-04-09 12:08:28 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to be286f84e33da1a7f83142b64dbd86f600e73363:

  vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs fails (2021-04-22 18:15:31 -0400)

----------------------------------------------------------------
virtio: last minute fixes

Very late in the cycle but both risky if left unfixed and more or less
obvious..

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (1):
      vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs fails

Xie Yongji (1):
      vhost-vdpa: protect concurrent access to vhost device iotlb

 drivers/vdpa/mlx5/core/mr.c | 4 +++-
 drivers/vhost/vdpa.c        | 6 +++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

