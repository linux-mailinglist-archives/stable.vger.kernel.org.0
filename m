Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540E85472B3
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 09:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiFKHtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 03:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiFKHs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 03:48:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1D5629CA3
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 00:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654933736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=qyk9g0ELjVAhO4lsyGp9C9P5YSNZEspWcN+xPCYvwJY=;
        b=bj+MYL2j5TwpOUPlKRSlCp585JtnbDXvqih5LqBen+jEtrZtPIYloCGHrZkZqsGVV63GSC
        +NyCpgBW+2XqBHYZ99vKieluSQn4lPCAjA35l63dIKuYWJNk2qvmqBuU7heifUTJdnnrE9
        FJIy7Q0cPMoxhaIfcGR1/aAHqjPaIFo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-kqd5e8QhNRS1Pf8hHpXKSw-1; Sat, 11 Jun 2022 03:48:54 -0400
X-MC-Unique: kqd5e8QhNRS1Pf8hHpXKSw-1
Received: by mail-ed1-f72.google.com with SMTP id a4-20020a056402168400b0042dc5b94da6so951635edv.10
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 00:48:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=qyk9g0ELjVAhO4lsyGp9C9P5YSNZEspWcN+xPCYvwJY=;
        b=eYHmV692gyZoyvNkDix9mTSY5YoPpIXjjLpKFYKzgVMjHQkGMkBLy29GOPVla4CjO9
         NBR6ovn02AobOSk1ZIJjpeIbD9UBsoZ/o8Ccq6umjXP4mCtjMqm/ntdFEHNh0nJT26le
         NGV3cNxcNmvv1BUEQeIs4aV3AznkyiKESmkvYoyMYuoUXLzwYrrK6Q2X4V98rNjtqPeI
         n/nRlHC0R+qzncIM1qfbaGQGbcs/ZAn+r6mRztBFEx3ld5BqJnh3e2oUNjvEQCgvg2H7
         scUWHeweOPwT0OyuxoLcr76eaWzxgiCP0QyU+NIg7zzq7Cc+MCERW1zW7ok/oNssoXnX
         Sp6g==
X-Gm-Message-State: AOAM5310lRQaB+MHxg/HtXFMztwCpuTQE2n5CaE4pGOMDhrzd0FPxA1G
        AxAGG+jCjx1ugEgWWjsfEVSJli6H8YipzFbjgxHgG9aAuS7085M0ASR5bAtEfWAbw3PKkwO03Uk
        Ro/nCZH1G1KjwmY2O
X-Received: by 2002:a05:6402:2553:b0:431:6e08:56de with SMTP id l19-20020a056402255300b004316e0856demr31201073edb.406.1654933733336;
        Sat, 11 Jun 2022 00:48:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwLx5bFdq30xI5P4i3ZyKGrtOytrp9e+V51+s6ADqB5Q4i9rEt7pLobi3Np6OXDutzcfAAxQ==
X-Received: by 2002:a05:6402:2553:b0:431:6e08:56de with SMTP id l19-20020a056402255300b004316e0856demr31201044edb.406.1654933733098;
        Sat, 11 Jun 2022 00:48:53 -0700 (PDT)
Received: from redhat.com ([212.116.178.142])
        by smtp.gmail.com with ESMTPSA id zj11-20020a170907338b00b006ff0fe78cb7sm664853ejb.133.2022.06.11.00.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jun 2022 00:48:52 -0700 (PDT)
Date:   Sat, 11 Jun 2022 03:48:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, elic@nvidia.com, fam.zheng@bytedance.com,
        gautam.dawar@xilinx.com, jasowang@redhat.com,
        johannes@sipsolutions.net, liubo03@inspur.com, mst@redhat.com,
        oliver.sang@intel.com, pilgrimtao@gmail.com, si-wei.liu@oracle.com,
        stable@vger.kernel.org,
        syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com,
        vincent.whitchurch@axis.com, wangxiang@cdjrlc.com,
        xieyongji@bytedance.com
Subject: [GIT PULL] virtio,vdpa: fixes
Message-ID: <20220611034848-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following changes since commit f2906aa863381afb0015a9eb7fefad885d4e5a56:

  Linux 5.19-rc1 (2022-06-05 17:18:54 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to eacea844594ff338db06437806707313210d4865:

  um: virt-pci: set device ready in probe() (2022-06-10 20:38:06 -0400)

----------------------------------------------------------------
virtio,vdpa: fixes

Fixes all over the place, most notably fixes for latent
bugs in drivers that got exposed by suppressing
interrupts before DRIVER_OK, which in turn has been
done by 8b4ec69d7e09 ("virtio: harden vring IRQ").

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Bo Liu (1):
      virtio: Fix all occurences of the "the the" typo

Dan Carpenter (2):
      vdpa/mlx5: fix error code for deleting vlan
      vdpa/mlx5: clean up indenting in handle_ctrl_vlan()

Jason Wang (2):
      virtio-rng: make device ready before making request
      vdpa: make get_vq_group and set_group_asid optional

Vincent Whitchurch (1):
      um: virt-pci: set device ready in probe()

Xiang wangx (1):
      vdpa/mlx5: Fix syntax errors in comments

Xie Yongji (2):
      vringh: Fix loop descriptors check in the indirect cases
      vduse: Fix NULL pointer dereference on sysfs access

chengkaitao (1):
      virtio-mmio: fix missing put_device() when vm_cmdline_parent registration failed

 arch/um/drivers/virt-pci.c             |  7 ++++++-
 drivers/char/hw_random/virtio-rng.c    |  2 ++
 drivers/vdpa/mlx5/net/mlx5_vnet.c      |  9 +++++----
 drivers/vdpa/vdpa_user/vduse_dev.c     |  7 +++----
 drivers/vhost/vdpa.c                   |  2 ++
 drivers/vhost/vringh.c                 | 10 ++++++++--
 drivers/virtio/virtio_mmio.c           |  3 ++-
 drivers/virtio/virtio_pci_modern_dev.c |  2 +-
 include/linux/vdpa.h                   |  5 +++--
 9 files changed, 32 insertions(+), 15 deletions(-)

