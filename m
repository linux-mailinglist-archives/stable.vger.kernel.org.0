Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7093221C4
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 22:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhBVVts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 16:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhBVVtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 16:49:47 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B100C061574;
        Mon, 22 Feb 2021 13:49:07 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id l19so2202041qvz.2;
        Mon, 22 Feb 2021 13:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Aaq1Eiu5nDnx4zbppH7vtiVUqHGdWOLrQOc9GIoC9xY=;
        b=YEdf9OVXSLNqy6njNfrO/y0eCw7XJcflWHOelwykD5c75MGxs0qQLiNfGy1uh/W22v
         76LPuJ+SD5uWPW3E64UbIauZF+M7CMKCROQvWyp9DhDrEp77K1JVHxOXehz2qCXu9a50
         cov9sHiAgSkkT2S83JZ48yq7TMyaxlc1TY1IbH5SnHdUQ/qPDJm03GSAUIVR66/5nCJu
         /NpjzBPHZYbyzVGa7Yq1yZ29PPXnQWQvgxbIzJBK34qEVDEwLE5wqgCTtdk27Z/lilvQ
         MUx169kh+NZc1BGjrpdEiOWAWiUNeMSpvpC6ldDJl6S5NISyh6ANb0AelPw1BVPDdh2l
         laRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Aaq1Eiu5nDnx4zbppH7vtiVUqHGdWOLrQOc9GIoC9xY=;
        b=d6Lxi5LNNuRCZGCNm/eeV7qUZDsnygLznQ1ATBy3FFV8ZXi0yHr2m+W/ZWcPpuN1hQ
         y7Pd0UZtP9Q+fXPeShYKR6/wOAd+kFXLyW+yZICmyse79MPcc+catjQOgz70lvZEfw4g
         f3b4AxVUHglpAq7vgGF3jEs7S1Wtcwuo5MQGHWH+WfvWtiuV8qjecwhexIz06RnRGut4
         e1Q+9naZ4KJVh6HwBwrbgQeo864OaIes2KsXNL4ZfS1cy9C0UO/GpMRogN/t5u15z3Tr
         lLLWM9dxXXPmrDSgcFuj8gmD94gou7dS6PcdH1LyWsx79k17dgs+XjK7mVEKXgIRWOnt
         XLRQ==
X-Gm-Message-State: AOAM532fLy9xZGmo5rfolgUOEUnU5kLZvy41wmbQCaPtIyn0mp8Hjqe3
        +u1DFLmxfEr8suiUtvfPpQM=
X-Google-Smtp-Source: ABdhPJxMCEhoXuMXSDp213/xdbcwGbv+bk+XnAxb3fEiXeEL2SpoXWUFmzWds1/zqTfvhokdZ+c59w==
X-Received: by 2002:a05:6214:bce:: with SMTP id ff14mr22396215qvb.26.1614030546456;
        Mon, 22 Feb 2021 13:49:06 -0800 (PST)
Received: from debian-vm ([189.120.76.30])
        by smtp.gmail.com with ESMTPSA id f26sm13175740qkh.80.2021.02.22.13.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 13:49:06 -0800 (PST)
From:   Igor <igormtorrente@gmail.com>
X-Google-Original-From: Igor <igor>
Date:   Mon, 22 Feb 2021 18:49:01 -0300
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org,
        skhan@linuxfoundation.org
Subject: Re: [PATCH 4.19 00/50] 4.19.177-rc1 review
Message-ID: <YDQmzefrMUZMnRPL@debian-vm>
References: <20210222121019.925481519@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 01:12:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.177 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.177-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my machine(x86_64) without any dmesg regression.
My compilation uses the default Debian 10 .config(From kernel
4.19.0-14-amd64), followed by olddefconfig.

Tested-by: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>

Best regards,
---
Igor Matheus Andrade Torrente

> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 4.19.177-rc1
> 
> Lai Jiangshan <laijs@linux.alibaba.com>
>     kvm: check tlbs_dirty directly
> 
> Arun Easi <aeasi@marvell.com>
>     scsi: qla2xxx: Fix crash during driver load on big endian machines
> 
> Jan Beulich <jbeulich@suse.com>
>     xen-blkback: fix error handling in xen_blkbk_map()
> 
> Jan Beulich <jbeulich@suse.com>
>     xen-scsiback: don't "handle" error by BUG()
> 
> Jan Beulich <jbeulich@suse.com>
>     xen-netback: don't "handle" error by BUG()
> 
> Jan Beulich <jbeulich@suse.com>
>     xen-blkback: don't "handle" error by BUG()
> 
> Stefano Stabellini <stefano.stabellini@xilinx.com>
>     xen/arm: don't ignore return errors from set_phys_to_machine
> 
> Jan Beulich <jbeulich@suse.com>
>     Xen/gntdev: correct error checking in gntdev_map_grant_pages()
> 
> Jan Beulich <jbeulich@suse.com>
>     Xen/gntdev: correct dev_bus_addr handling in gntdev_map_grant_pages()
> 
> Jan Beulich <jbeulich@suse.com>
>     Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()
> 
> Jan Beulich <jbeulich@suse.com>
>     Xen/x86: don't bail early from clear_foreign_p2m_mapping()
> 
> Loic Poulain <loic.poulain@linaro.org>
>     net: qrtr: Fix port ID for control messages
> 
> Paolo Bonzini <pbonzini@redhat.com>
>     KVM: SEV: fix double locking due to incorrect backport
> 
> Borislav Petkov <bp@suse.de>
>     x86/build: Disable CET instrumentation in the kernel for 32-bit too
> 
> Miklos Szeredi <mszeredi@redhat.com>
>     ovl: expand warning in ovl_d_real()
> 
> Sabyrzhan Tasbolatov <snovitoll@gmail.com>
>     net/qrtr: restrict user-controlled length in qrtr_tun_write_iter()
> 
> Sabyrzhan Tasbolatov <snovitoll@gmail.com>
>     net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS
> 
> Stefano Garzarella <sgarzare@redhat.com>
>     vsock: fix locking in vsock_shutdown()
> 
> Stefano Garzarella <sgarzare@redhat.com>
>     vsock/virtio: update credit only if socket is not closed
> 
> Edwin Peer <edwin.peer@broadcom.com>
>     net: watchdog: hold device global xmit lock during tx disable
> 
> Norbert Slusarek <nslusarek@gmx.net>
>     net/vmw_vsock: improve locking in vsock_connect_timeout()
> 
> NeilBrown <neilb@suse.de>
>     net: fix iteration for sctp transport seq_files
> 
> Serge Semin <Sergey.Semin@baikalelectronics.ru>
>     usb: dwc3: ulpi: Replace CPU-based busyloop with Protocol-based one
> 
> Felipe Balbi <balbi@kernel.org>
>     usb: dwc3: ulpi: fix checkpatch warning
> 
> Randy Dunlap <rdunlap@infradead.org>
>     h8300: fix PREEMPTION build, TI_PRE_COUNT undefined
> 
> Alain Volmat <alain.volmat@foss.st.com>
>     i2c: stm32f7: fix configuration of the digital filter
> 
> Fangrui Song <maskray@google.com>
>     firmware_loader: align .builtin_fw to 8
> 
> Yufeng Mo <moyufeng@huawei.com>
>     net: hns3: add a check for queue_id in hclge_reset_vf_queue()
> 
> Florian Westphal <fw@strlen.de>
>     netfilter: conntrack: skip identical origin tuple in same zone only
> 
> Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
>     net: stmmac: set TxQ mode back to DCB after disabling CBS
> 
> Juergen Gross <jgross@suse.com>
>     xen/netback: avoid race in xenvif_rx_ring_slots_available()
> 
> Sven Auhagen <sven.auhagen@voleatech.de>
>     netfilter: flowtable: fix tcp and udp header checksum update
> 
> Jozsef Kadlecsik <kadlec@mail.kfki.hu>
>     netfilter: xt_recent: Fix attempt to update deleted entry
> 
> Bui Quang Minh <minhquangbui99@gmail.com>
>     bpf: Check for integer overflow when using roundup_pow_of_two()
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: dma: fix a possible memory leak in mt76_add_fragment()
> 
> Russell King <rmk+kernel@armlinux.org.uk>
>     ARM: kexec: fix oops after TLB are invalidated
> 
> Russell King <rmk+kernel@armlinux.org.uk>
>     ARM: ensure the signal page contains defined contents
> 
> Alexandre Belloni <alexandre.belloni@bootlin.com>
>     ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL
> 
> Lin Feng <linf@wangsu.com>
>     bfq-iosched: Revert "bfq: Fix computation of shallow depth"
> 
> Alexandre Ghiti <alex@ghiti.fr>
>     riscv: virt_addr_valid must check the address belongs to linear mapping
> 
> Victor Lu <victorchengchi.lu@amd.com>
>     drm/amd/display: Free atomic state after drm_atomic_commit
> 
> Victor Lu <victorchengchi.lu@amd.com>
>     drm/amd/display: Fix dc_sink kref count in emulated_link_detect
> 
> Amir Goldstein <amir73il@gmail.com>
>     ovl: skip getxattr of security labels
> 
> Miklos Szeredi <mszeredi@redhat.com>
>     cap: fix conversions on getxattr
> 
> Miklos Szeredi <mszeredi@redhat.com>
>     ovl: perform vfs_getxattr() with mounter creds
> 
> Hans de Goede <hdegoede@redhat.com>
>     platform/x86: hp-wmi: Disable tablet-mode reporting by default
> 
> Marc Zyngier <maz@kernel.org>
>     arm64: dts: rockchip: Fix PCIe DT properties on rk3399
> 
> Julien Grall <jgrall@amazon.com>
>     arm/xen: Don't probe xenbus as part of an early initcall
> 
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>     tracing: Check length before giving out the filter buffer
> 
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>     tracing: Do not count ftrace events in top level enable output
> 
> 
> -------------
> 
> Diffstat:
> 
>  Makefile                                           |  4 +-
>  arch/arm/boot/dts/lpc32xx.dtsi                     |  3 -
>  arch/arm/include/asm/kexec-internal.h              | 12 ++++
>  arch/arm/kernel/asm-offsets.c                      |  5 ++
>  arch/arm/kernel/machine_kexec.c                    | 20 +++----
>  arch/arm/kernel/relocate_kernel.S                  | 38 ++++--------
>  arch/arm/kernel/signal.c                           | 14 +++--
>  arch/arm/xen/enlighten.c                           |  2 -
>  arch/arm/xen/p2m.c                                 |  6 +-
>  arch/arm64/boot/dts/rockchip/rk3399.dtsi           |  2 +-
>  arch/h8300/kernel/asm-offsets.c                    |  3 +
>  arch/riscv/include/asm/page.h                      |  5 +-
>  arch/x86/Makefile                                  |  6 +-
>  arch/x86/kvm/svm.c                                 |  1 -
>  arch/x86/xen/p2m.c                                 | 15 +++--
>  block/bfq-iosched.c                                |  8 +--
>  drivers/block/xen-blkback/blkback.c                | 30 +++++-----
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 18 +++---
>  drivers/i2c/busses/i2c-stm32f7.c                   | 11 +++-
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  7 +++
>  drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  7 ++-
>  drivers/net/wireless/mediatek/mt76/dma.c           |  8 ++-
>  drivers/net/xen-netback/netback.c                  |  4 +-
>  drivers/net/xen-netback/rx.c                       |  9 ++-
>  drivers/platform/x86/hp-wmi.c                      | 14 +++--
>  drivers/scsi/qla2xxx/qla_tmpl.c                    |  9 +--
>  drivers/scsi/qla2xxx/qla_tmpl.h                    |  2 +-
>  drivers/usb/dwc3/ulpi.c                            | 20 +++++--
>  drivers/xen/gntdev.c                               | 37 ++++++------
>  drivers/xen/xen-scsiback.c                         |  4 +-
>  drivers/xen/xenbus/xenbus.h                        |  1 -
>  drivers/xen/xenbus/xenbus_probe.c                  |  2 +-
>  fs/overlayfs/copy_up.c                             | 15 ++---
>  fs/overlayfs/inode.c                               |  2 +
>  fs/overlayfs/super.c                               | 13 +++--
>  include/asm-generic/vmlinux.lds.h                  |  2 +-
>  include/linux/netdevice.h                          |  2 +
>  include/xen/grant_table.h                          |  1 +
>  include/xen/xenbus.h                               |  2 -
>  kernel/bpf/stackmap.c                              |  2 +
>  kernel/trace/trace.c                               |  2 +-
>  kernel/trace/trace_events.c                        |  3 +-
>  net/netfilter/nf_conntrack_core.c                  |  3 +-
>  net/netfilter/nf_flow_table_core.c                 |  4 +-
>  net/netfilter/xt_recent.c                          | 12 +++-
>  net/qrtr/qrtr.c                                    |  2 +-
>  net/qrtr/tun.c                                     |  6 ++
>  net/rds/rdma.c                                     |  3 +
>  net/sctp/proc.c                                    | 16 ++++--
>  net/vmw_vsock/af_vsock.c                           | 13 ++---
>  net/vmw_vsock/hyperv_transport.c                   |  4 --
>  net/vmw_vsock/virtio_transport_common.c            |  4 +-
>  security/commoncap.c                               | 67 ++++++++++++++--------
>  virt/kvm/kvm_main.c                                |  3 +-
>  54 files changed, 303 insertions(+), 205 deletions(-)
> 
> 
