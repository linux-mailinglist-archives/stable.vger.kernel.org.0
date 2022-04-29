Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC495146FC
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357715AbiD2Kql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357772AbiD2Kp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:45:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F51CC84B6;
        Fri, 29 Apr 2022 03:42:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8C9362325;
        Fri, 29 Apr 2022 10:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D54C385AF;
        Fri, 29 Apr 2022 10:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228943;
        bh=N70vpHwtSZMmTCxmNgAEjaI0uS0fBsx6POmU54uAECo=;
        h=From:To:Cc:Subject:Date:From;
        b=mEJzroUUuK6GnVQGQsxKvNEdL6Y8bqxuQcIP3Ba95o1KDcd1qNk5RJwXa698tfu4l
         sHwjuRaa4NBdAJvrwk8spd/5HsCswihFUpL4KGiHZ5pLhbrEEaLMxB1YxWL+KlDJbn
         h4cK/2tuDcj0kSf1h//u1vh2WyTlCplM4IuxrN70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 00/33] 5.15.37-rc1 review
Date:   Fri, 29 Apr 2022 12:41:47 +0200
Message-Id: <20220429104052.345760505@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.37-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.37-rc1
X-KernelTest-Deadline: 2022-05-01T10:40+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.37 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.37-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.37-rc1

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    selftests/bpf: Add test for reg2btf_ids out of bounds access

Linus Torvalds <torvalds@linux-foundation.org>
    mm: gup: make fault_in_safe_writeable() use fixup_user_fault()

Filipe Manana <fdmanana@suse.com>
    btrfs: fallback to blocking mode when doing async dio over multiple extents

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock due to page faults during direct IO reads and writes

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix mmap + page fault deadlocks for direct I/O

Andreas Gruenbacher <agruenba@redhat.com>
    iov_iter: Introduce nofault flag to disable page faults

Andreas Gruenbacher <agruenba@redhat.com>
    gup: Introduce FOLL_NOFAULT flag to disable page faults

Andreas Gruenbacher <agruenba@redhat.com>
    iomap: Add done_before argument to iomap_dio_rw

Andreas Gruenbacher <agruenba@redhat.com>
    iomap: Support partial direct I/O on user copy failures

Andreas Gruenbacher <agruenba@redhat.com>
    iomap: Fix iomap_dio_rw return value for user copies

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix mmap + page fault deadlocks for buffered I/O

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Eliminate ip->i_gh

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Move the inode glock locking to gfs2_file_buffered_write

Bob Peterson <rpeterso@redhat.com>
    gfs2: Introduce flag for glock holder auto-demotion

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Clean up function may_grant

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Add wrapper for iomap_file_buffered_write

Andreas Gruenbacher <agruenba@redhat.com>
    iov_iter: Introduce fault_in_iov_iter_writeable

Andreas Gruenbacher <agruenba@redhat.com>
    iov_iter: Turn iov_iter_fault_in_readable into fault_in_iov_iter_readable

Andreas Gruenbacher <agruenba@redhat.com>
    gup: Turn fault_in_pages_{readable,writeable} into fault_in_{readable,writeable}

Muchun Song <songmuchun@bytedance.com>
    mm: kfence: fix objcgs vector allocation

Dinh Nguyen <dinguyen@kernel.org>
    ARM: dts: socfpga: change qspi to "intel,socfpga-qspi"

Dinh Nguyen <dinguyen@kernel.org>
    spi: cadence-quadspi: fix write completion support

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fix crash due to out of bounds access into reg2btf_ids.

Hao Luo <haoluo@google.com>
    bpf/selftests: Test PTR_TO_RDONLY_MEM

Hao Luo <haoluo@google.com>
    bpf: Add MEM_RDONLY for helper args that are pointers to rdonly mem.

Hao Luo <haoluo@google.com>
    bpf: Make per_cpu_ptr return rdonly PTR_TO_MEM.

Hao Luo <haoluo@google.com>
    bpf: Convert PTR_TO_MEM_OR_NULL to composable types.

Hao Luo <haoluo@google.com>
    bpf: Introduce MEM_RDONLY flag

Hao Luo <haoluo@google.com>
    bpf: Replace PTR_TO_XXX_OR_NULL with PTR_TO_XXX | PTR_MAYBE_NULL

Hao Luo <haoluo@google.com>
    bpf: Replace RET_XXX_OR_NULL with RET_XXX | PTR_MAYBE_NULL

Hao Luo <haoluo@google.com>
    bpf: Replace ARG_XXX_OR_NULL with ARG_XXX | PTR_MAYBE_NULL

Hao Luo <haoluo@google.com>
    bpf: Introduce composable reg, ret and arg types.

Willy Tarreau <w@1wt.eu>
    floppy: disable FDRAWCMD by default


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/socfpga.dtsi                     |   2 +-
 arch/arm/boot/dts/socfpga_arria10.dtsi             |   2 +-
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi  |   2 +-
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi      |   2 +-
 arch/powerpc/kernel/kvm.c                          |   3 +-
 arch/powerpc/kernel/signal_32.c                    |   4 +-
 arch/powerpc/kernel/signal_64.c                    |   2 +-
 arch/x86/kernel/fpu/signal.c                       |   7 +-
 drivers/block/Kconfig                              |  16 +
 drivers/block/floppy.c                             |  43 +-
 drivers/gpu/drm/armada/armada_gem.c                |   7 +-
 drivers/spi/spi-cadence-quadspi.c                  |  24 +-
 fs/btrfs/file.c                                    | 142 +++++-
 fs/btrfs/inode.c                                   |  28 ++
 fs/btrfs/ioctl.c                                   |   5 +-
 fs/erofs/data.c                                    |   2 +-
 fs/ext4/file.c                                     |   5 +-
 fs/f2fs/file.c                                     |   2 +-
 fs/fuse/file.c                                     |   2 +-
 fs/gfs2/bmap.c                                     |  60 +--
 fs/gfs2/file.c                                     | 252 ++++++++++-
 fs/gfs2/glock.c                                    | 330 ++++++++++----
 fs/gfs2/glock.h                                    |  20 +
 fs/gfs2/incore.h                                   |   4 +-
 fs/iomap/buffered-io.c                             |   2 +-
 fs/iomap/direct-io.c                               |  29 +-
 fs/ntfs/file.c                                     |   2 +-
 fs/ntfs3/file.c                                    |   2 +-
 fs/xfs/xfs_file.c                                  |   6 +-
 fs/zonefs/super.c                                  |   4 +-
 include/linux/bpf.h                                | 101 ++++-
 include/linux/bpf_verifier.h                       |  18 +
 include/linux/iomap.h                              |  11 +-
 include/linux/mm.h                                 |   3 +-
 include/linux/pagemap.h                            |  58 +--
 include/linux/uio.h                                |   4 +-
 kernel/bpf/btf.c                                   |  16 +-
 kernel/bpf/cgroup.c                                |   2 +-
 kernel/bpf/helpers.c                               |  12 +-
 kernel/bpf/map_iter.c                              |   4 +-
 kernel/bpf/ringbuf.c                               |   2 +-
 kernel/bpf/syscall.c                               |   2 +-
 kernel/bpf/verifier.c                              | 488 ++++++++++-----------
 kernel/trace/bpf_trace.c                           |  22 +-
 lib/iov_iter.c                                     |  98 ++++-
 mm/filemap.c                                       |   4 +-
 mm/gup.c                                           | 120 ++++-
 mm/kfence/core.c                                   |  11 +-
 mm/kfence/kfence.h                                 |   3 +
 net/core/bpf_sk_storage.c                          |   2 +-
 net/core/filter.c                                  |  64 +--
 net/core/sock_map.c                                |   2 +-
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |  14 +
 .../bpf/progs/test_ksyms_btf_write_check.c         |  29 ++
 tools/testing/selftests/bpf/verifier/calls.c       |  19 +
 56 files changed, 1472 insertions(+), 652 deletions(-)


