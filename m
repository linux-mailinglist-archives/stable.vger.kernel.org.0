Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6A05164F7
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 17:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348008AbiEAPdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 11:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347877AbiEAPdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 11:33:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3483270C;
        Sun,  1 May 2022 08:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC7C760F0C;
        Sun,  1 May 2022 15:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B736C385AA;
        Sun,  1 May 2022 15:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651419024;
        bh=D+titBiPsLq3t7mWEkS40P2eI+ot2gfCkiZBuIC0Zks=;
        h=From:To:Cc:Subject:Date:From;
        b=UT8Sf4sZmzUbc6gNYvj57RdBhi1J4kBMMZfDxQd9vMl6C3DSfKxaOXsC5w47BbV+D
         zk/UkJEKIwkxh/NdLQe9wjvlzR7sec0/E7fKy+H5T1imYBBDDyAxcr0TFoaRMA8HuR
         Y9f7y8QnEE5bMJG2FHE4Br5mOvH3EzaN0syFZM4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.37
Date:   Sun,  1 May 2022 17:30:16 +0200
Message-Id: <1651419016222111@kroah.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.37 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm/boot/dts/socfpga.dtsi                                 |    2 
 arch/arm/boot/dts/socfpga_arria10.dtsi                         |    2 
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi              |    2 
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi                  |    2 
 arch/powerpc/kernel/kvm.c                                      |    3 
 arch/powerpc/kernel/signal_32.c                                |    4 
 arch/powerpc/kernel/signal_64.c                                |    2 
 arch/x86/kernel/fpu/signal.c                                   |    7 
 drivers/block/Kconfig                                          |   16 
 drivers/block/floppy.c                                         |   43 
 drivers/gpu/drm/armada/armada_gem.c                            |    7 
 drivers/spi/spi-cadence-quadspi.c                              |   24 
 fs/btrfs/file.c                                                |  142 ++
 fs/btrfs/inode.c                                               |   28 
 fs/btrfs/ioctl.c                                               |    5 
 fs/erofs/data.c                                                |    2 
 fs/ext4/file.c                                                 |    5 
 fs/f2fs/file.c                                                 |    2 
 fs/fuse/file.c                                                 |    2 
 fs/gfs2/bmap.c                                                 |   60 -
 fs/gfs2/file.c                                                 |  252 ++++-
 fs/gfs2/glock.c                                                |  330 +++++-
 fs/gfs2/glock.h                                                |   20 
 fs/gfs2/incore.h                                               |    4 
 fs/iomap/buffered-io.c                                         |    2 
 fs/iomap/direct-io.c                                           |   29 
 fs/ntfs/file.c                                                 |    2 
 fs/ntfs3/file.c                                                |    2 
 fs/xfs/xfs_file.c                                              |    6 
 fs/zonefs/super.c                                              |    4 
 include/linux/bpf.h                                            |  101 +-
 include/linux/bpf_verifier.h                                   |   18 
 include/linux/iomap.h                                          |   11 
 include/linux/mm.h                                             |    3 
 include/linux/pagemap.h                                        |   58 -
 include/linux/uio.h                                            |    4 
 kernel/bpf/btf.c                                               |   16 
 kernel/bpf/cgroup.c                                            |    2 
 kernel/bpf/helpers.c                                           |   12 
 kernel/bpf/map_iter.c                                          |    4 
 kernel/bpf/ringbuf.c                                           |    2 
 kernel/bpf/syscall.c                                           |    2 
 kernel/bpf/verifier.c                                          |  488 ++++------
 kernel/trace/bpf_trace.c                                       |   22 
 lib/iov_iter.c                                                 |   98 +-
 mm/filemap.c                                                   |    4 
 mm/gup.c                                                       |  120 ++
 mm/kfence/core.c                                               |   11 
 mm/kfence/kfence.h                                             |    3 
 net/core/bpf_sk_storage.c                                      |    2 
 net/core/filter.c                                              |   64 -
 net/core/sock_map.c                                            |    2 
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c             |   14 
 tools/testing/selftests/bpf/progs/test_ksyms_btf_write_check.c |   29 
 tools/testing/selftests/bpf/verifier/calls.c                   |   19 
 56 files changed, 1471 insertions(+), 651 deletions(-)

Andreas Gruenbacher (14):
      gup: Turn fault_in_pages_{readable,writeable} into fault_in_{readable,writeable}
      iov_iter: Turn iov_iter_fault_in_readable into fault_in_iov_iter_readable
      iov_iter: Introduce fault_in_iov_iter_writeable
      gfs2: Add wrapper for iomap_file_buffered_write
      gfs2: Clean up function may_grant
      gfs2: Move the inode glock locking to gfs2_file_buffered_write
      gfs2: Eliminate ip->i_gh
      gfs2: Fix mmap + page fault deadlocks for buffered I/O
      iomap: Fix iomap_dio_rw return value for user copies
      iomap: Support partial direct I/O on user copy failures
      iomap: Add done_before argument to iomap_dio_rw
      gup: Introduce FOLL_NOFAULT flag to disable page faults
      iov_iter: Introduce nofault flag to disable page faults
      gfs2: Fix mmap + page fault deadlocks for direct I/O

Bob Peterson (1):
      gfs2: Introduce flag for glock holder auto-demotion

Dinh Nguyen (2):
      spi: cadence-quadspi: fix write completion support
      ARM: dts: socfpga: change qspi to "intel,socfpga-qspi"

Filipe Manana (2):
      btrfs: fix deadlock due to page faults during direct IO reads and writes
      btrfs: fallback to blocking mode when doing async dio over multiple extents

Greg Kroah-Hartman (1):
      Linux 5.15.37

Hao Luo (9):
      bpf: Introduce composable reg, ret and arg types.
      bpf: Replace ARG_XXX_OR_NULL with ARG_XXX | PTR_MAYBE_NULL
      bpf: Replace RET_XXX_OR_NULL with RET_XXX | PTR_MAYBE_NULL
      bpf: Replace PTR_TO_XXX_OR_NULL with PTR_TO_XXX | PTR_MAYBE_NULL
      bpf: Introduce MEM_RDONLY flag
      bpf: Convert PTR_TO_MEM_OR_NULL to composable types.
      bpf: Make per_cpu_ptr return rdonly PTR_TO_MEM.
      bpf: Add MEM_RDONLY for helper args that are pointers to rdonly mem.
      bpf/selftests: Test PTR_TO_RDONLY_MEM

Kumar Kartikeya Dwivedi (2):
      bpf: Fix crash due to out of bounds access into reg2btf_ids.
      selftests/bpf: Add test for reg2btf_ids out of bounds access

Linus Torvalds (1):
      mm: gup: make fault_in_safe_writeable() use fixup_user_fault()

Muchun Song (1):
      mm: kfence: fix objcgs vector allocation

Willy Tarreau (1):
      floppy: disable FDRAWCMD by default

