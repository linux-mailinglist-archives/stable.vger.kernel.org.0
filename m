Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159D73A1D18
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhFISva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhFISv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 14:51:28 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A38CC061574;
        Wed,  9 Jun 2021 11:49:32 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id md2-20020a17090b23c2b029016de4440381so2028734pjb.1;
        Wed, 09 Jun 2021 11:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xcGiQnWOweOgU6iH7Jv0d7uTQqSYtIdSw1UMpk0yJOA=;
        b=aUmw8Xkj3hgwdSlhU4fuS4+cS7yDoUECOdkzp/ZFwoMjo93ahR6yK4B+wOXBYdW0Oc
         i0KchFU1v2ObYTV+iMuptzT6PwW5t32tcit60I9zKDh42Zw/F9gNooYbDmwW8M6Dunjh
         nG4KsWkkd2Xvo8aYAuAdzdhmXbJKHH7uwEQT4ZCBzLEVMqkRg0ntzlomP4EE4r7R7uWL
         UQ9iSGn6I8Bveg0AomfJRmns5gN9TtdRP/sxJuF/PTYtonAT+Bb6p2gAzGi+cCFzHKml
         QSn5pAg/So+hzZexoqZ3bNlUp4tiB7PqP5W7zZxqW22dd2yO04XkpQ6K26pjZlk0B2oT
         Ke8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xcGiQnWOweOgU6iH7Jv0d7uTQqSYtIdSw1UMpk0yJOA=;
        b=ZuRqpJzuyc2a1BNoVkB33X6BPdGOf8kxrog4pfmV86+Gxrt6DiOEAEpy3kcLsBylDh
         UUGPXXSQGAZh87lgjOh+04NaWa7M9Gk8QNC9wLUwa/rglDFWdJa7GeBtdRegqeW/ywLz
         nZSzfgEEN4eQezWuX6s+viwY7xLMBd31fVh5JmriJiP0bDLsdGuuL2DFNhNREGSZ1ILm
         prPFhAdxY9lvs0cC0W5hjnUFuZ3LrVNF+boQIEgxxGaVhZDUlxDO6ng9Vs7xrvMBY49U
         OADuOEfCMTTmKotctujxv47Usemu/pHIKGiqtDYyYC2PtYlYpzASTLTpvfWSmqQAKRsl
         5Oew==
X-Gm-Message-State: AOAM531wOhqEmrtBS0GjvGSkN2HGMPoGmFxkIMezs5R6iLZtrv0LTbuH
        EfBCSEKH6+tyrW/3Yf4oDIDEFeulCaY=
X-Google-Smtp-Source: ABdhPJxnvBUtk8PRLl7h4I+ay3Waacfvx4r5FDb8Kv1eAU4G80JU6t8hErzW0PS/qbYUef82fV/s/g==
X-Received: by 2002:a17:90a:bb13:: with SMTP id u19mr12229006pjr.92.1623264571205;
        Wed, 09 Jun 2021 11:49:31 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cq24sm5742216pjb.18.2021.06.09.11.49.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 11:49:30 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/137] 5.10.43-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210608175942.377073879@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8d646c47-afae-df04-f25a-3eeeffcc760e@gmail.com>
Date:   Wed, 9 Jun 2021 11:49:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/8/2021 11:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.43 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.43-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.10.43-rc1
> 
> David Ahern <dsahern@kernel.org>
>     neighbour: allow NUD_NOARP entries to be forced GCed
> 
> Roger Pau Monne <roger.pau@citrix.com>
>     xen-netback: take a reference to the RX task thread
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_tables: missing error reporting for not selected expressions
> 
> Roja Rani Yarubandi <rojay@codeaurora.org>
>     i2c: qcom-geni: Suspend and resume the bus during SYSTEM_SLEEP_PM ops
> 
> Gao Xiang <hsiangkao@redhat.com>
>     lib/lz4: explicitly support in-place decompression
> 
> Vitaly Kuznetsov <vkuznets@redhat.com>
>     x86/kvm: Disable all PV features on crash
> 
> Vitaly Kuznetsov <vkuznets@redhat.com>
>     x86/kvm: Disable kvmclock on all CPUs on shutdown
> 
> Vitaly Kuznetsov <vkuznets@redhat.com>
>     x86/kvm: Teardown PV features on boot CPU as well
> 
> Marc Zyngier <maz@kernel.org>
>     KVM: arm64: Fix debug register indexing
> 
> Sean Christopherson <seanjc@google.com>
>     KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode
> 
> Anand Jain <anand.jain@oracle.com>
>     btrfs: fix unmountable seed device after fstrim
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: always use mdp device to scale bandwidth
> 
> Mina Almasry <almasrymina@google.com>
>     mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY
> 
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix deadlock when cloning inline extents and low on available space
> 
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: abort in rename_exchange if we fail to insert the second ref
> 
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: fixup error handling in fixup_inode_link_counts
> 
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: return errors from btrfs_del_csums in cleanup_ref_head
> 
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: fix error handling in btrfs_del_csums
> 
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: mark ordered extent and inode with error if we fail to finish
> 
> Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>     powerpc/kprobes: Fix validation of prefixed instructions across page boundary
> 
> Thomas Gleixner <tglx@linutronix.de>
>     x86/apic: Mark _all_ legacy interrupts when IO/APIC is missing
> 
> Nirmoy Das <nirmoy.das@amd.com>
>     drm/amdgpu: make sure we unpin the UVD BO
> 
> Luben Tuikov <luben.tuikov@amd.com>
>     drm/amdgpu: Don't query CE and UE errors
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>     nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect
> 
> Pu Wen <puwen@hygon.cn>
>     x86/sev: Check SME/SEV support in CPUID first
> 
> Thomas Gleixner <tglx@linutronix.de>
>     x86/cpufeatures: Force disable X86_FEATURE_ENQCMD and remove update_pasid()
> 
> Ding Hui <dinghui@sangfor.com.cn>
>     mm/page_alloc: fix counting of free pages after take off from buddy
> 
> Gerald Schaefer <gerald.schaefer@linux.ibm.com>
>     mm/debug_vm_pgtable: fix alignment for pmd/pud_advanced_tests()
> 
> Junxiao Bi <junxiao.bi@oracle.com>
>     ocfs2: fix data corruption by fallocate
> 
> Mark Rutland <mark.rutland@arm.com>
>     pid: take a reference when initializing `cad_pid`
> 
> Phil Elwell <phil@raspberrypi.com>
>     usb: dwc2: Fix build in periphal-only mode
> 
> Ritesh Harjani <riteshh@linux.ibm.com>
>     ext4: fix accessing uninit percpu counter variable with fast_commit
> 
> Phillip Potter <phil@philpotter.co.uk>
>     ext4: fix memory leak in ext4_mb_init_backend on error path.
> 
> Harshad Shirwadkar <harshadshirwadkar@gmail.com>
>     ext4: fix fast commit alignment issues
> 
> Ye Bin <yebin10@huawei.com>
>     ext4: fix bug on in ext4_es_cache_extent as ext4_split_extent_at failed
> 
> Alexey Makhalov <amakhalov@vmware.com>
>     ext4: fix memory leak in ext4_fill_super
> 
> Marek Vasut <marex@denx.de>
>     ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators
> 
> Michal Vokáč <michal.vokac@ysoft.com>
>     ARM: dts: imx6dl-yapp4: Fix RGMII connection to QCA8334 switch
> 
> Hui Wang <hui.wang@canonical.com>
>     ALSA: hda: update the power_state during the direct-complete
> 
> Carlos M <carlos.marr.pz@gmail.com>
>     ALSA: hda: Fix for mute key LED for HP Pavilion 15-CK0xx
> 
> Takashi Iwai <tiwai@suse.de>
>     ALSA: timer: Fix master timer notification
> 
> Bob Peterson <rpeterso@redhat.com>
>     gfs2: fix scheduling while atomic bug in glocks
> 
> Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
>     HID: multitouch: require Finger field to mark Win8 reports as MT
> 
> Johan Hovold <johan@kernel.org>
>     HID: magicmouse: fix NULL-deref on disconnect
> 
> Johnny Chuang <johnny.chuang.emc@gmail.com>
>     HID: i2c-hid: Skip ELAN power-on command after reset
> 
> Pavel Skripkin <paskripkin@gmail.com>
>     net: caif: fix memory leak in cfusbl_device_notify
> 
> Pavel Skripkin <paskripkin@gmail.com>
>     net: caif: fix memory leak in caif_device_notify
> 
> Pavel Skripkin <paskripkin@gmail.com>
>     net: caif: add proper error handling
> 
> Pavel Skripkin <paskripkin@gmail.com>
>     net: caif: added cfserl_release function
> 
> Jason A. Donenfeld <Jason@zx2c4.com>
>     wireguard: allowedips: free empty intermediate nodes when removing single node
> 
> Jason A. Donenfeld <Jason@zx2c4.com>
>     wireguard: allowedips: allocate nodes in kmem_cache
> 
> Jason A. Donenfeld <Jason@zx2c4.com>
>     wireguard: allowedips: remove nodes in O(1)
> 
> Jason A. Donenfeld <Jason@zx2c4.com>
>     wireguard: allowedips: initialize list head in selftest
> 
> Jason A. Donenfeld <Jason@zx2c4.com>
>     wireguard: selftests: make sure rp_filter is disabled on vethc
> 
> Jason A. Donenfeld <Jason@zx2c4.com>
>     wireguard: selftests: remove old conntrack kconfig value
> 
> Jason A. Donenfeld <Jason@zx2c4.com>
>     wireguard: use synchronize_net rather than synchronize_rcu
> 
> Jason A. Donenfeld <Jason@zx2c4.com>
>     wireguard: peer: allocate in kmem_cache
> 
> Jason A. Donenfeld <Jason@zx2c4.com>
>     wireguard: do not use -O3
> 
> Lin Ma <linma@zju.edu.cn>
>     Bluetooth: use correct lock to prevent UAF of hdev object
> 
> Lin Ma <linma@zju.edu.cn>
>     Bluetooth: fix the erroneous flush_work() order
> 
> James Zhu <James.Zhu@amd.com>
>     drm/amdgpu/jpeg3: add cancel_delayed_work_sync before power gate
> 
> James Zhu <James.Zhu@amd.com>
>     drm/amdgpu/jpeg2.5: add cancel_delayed_work_sync before power gate
> 
> James Zhu <James.Zhu@amd.com>
>     drm/amdgpu/vcn3: add cancel_delayed_work_sync before power gate
> 
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring: use better types for cflags
> 
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring: fix link timeout refs
> 
> Jisheng Zhang <jszhang@kernel.org>
>     riscv: vdso: fix and clean-up Makefile
> 
> Johan Hovold <johan@kernel.org>
>     serial: stm32: fix threaded interrupt handling
> 
> Hoang Le <hoang.h.le@dektech.com.au>
>     tipc: fix unique bearer names sanity check
> 
> Hoang Le <hoang.h.le@dektech.com.au>
>     tipc: add extack messages for bearer/media failure
> 
> Tony Lindgren <tony@atomide.com>
>     bus: ti-sysc: Fix flakey idling of uarts and stop using swsup_sidle_act
> 
> Geert Uytterhoeven <geert+renesas@glider.be>
>     ARM: dts: imx: emcon-avari: Fix nxp,pca8574 #gpio-cells
> 
> Fabio Estevam <festevam@gmail.com>
>     ARM: dts: imx7d-pico: Fix the 'tuning-step' property
> 
> Fabio Estevam <festevam@gmail.com>
>     ARM: dts: imx7d-meerkat96: Fix the 'tuning-step' property
> 
> Michael Walle <michael@walle.cc>
>     arm64: dts: freescale: sl28: var4: fix RGMII clock and voltage
> 
> Lucas Stach <l.stach@pengutronix.de>
>     arm64: dts: zii-ultra: fix 12V_MAIN voltage
> 
> Michael Walle <michael@walle.cc>
>     arm64: dts: ls1028a: fix memory node
> 
> Tony Lindgren <tony@atomide.com>
>     bus: ti-sysc: Fix am335x resume hang for usb otg module
> 
> Jens Wiklander <jens.wiklander@linaro.org>
>     optee: use export_uuid() to copy client UUID
> 
> Vignesh Raghavendra <vigneshr@ti.com>
>     arm64: dts: ti: j7200-main: Mark Main NAVSS as dma-coherent
> 
> Magnus Karlsson <magnus.karlsson@intel.com>
>     ixgbe: add correct exception tracing for XDP
> 
> Magnus Karlsson <magnus.karlsson@intel.com>
>     ixgbe: optimize for XDP_REDIRECT in xsk path
> 
> Magnus Karlsson <magnus.karlsson@intel.com>
>     ice: add correct exception tracing for XDP
> 
> Magnus Karlsson <magnus.karlsson@intel.com>
>     ice: optimize for XDP_REDIRECT in xsk path
> 
> Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>     ice: simplify ice_run_xdp
> 
> Magnus Karlsson <magnus.karlsson@intel.com>
>     i40e: add correct exception tracing for XDP
> 
> Magnus Karlsson <magnus.karlsson@intel.com>
>     i40e: optimize for XDP_REDIRECT in xsk path
> 
> Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
>     cxgb4: avoid link re-train during TC-MQPRIO configuration
> 
> Roja Rani Yarubandi <rojay@codeaurora.org>
>     i2c: qcom-geni: Add shutdown callback for i2c
> 
> Dave Ertman <david.m.ertman@intel.com>
>     ice: Allow all LLDP packets from PF to Tx
> 
> Paul Greenwalt <paul.greenwalt@intel.com>
>     ice: report supported and advertised autoneg using PHY capabilities
> 
> Haiyue Wang <haiyue.wang@intel.com>
>     ice: handle the VF VSI rebuild failure
> 
> Brett Creeley <brett.creeley@intel.com>
>     ice: Fix VFR issues for AVF drivers that expect ATQLEN cleared
> 
> Brett Creeley <brett.creeley@intel.com>
>     ice: Fix allowing VF to request more/less queues via virtchnl
> 
> Coco Li <lixiaoyan@google.com>
>     ipv6: Fix KASAN: slab-out-of-bounds Read in fib6_nh_flush_exceptions
> 
> Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
>     cxgb4: fix regression with HASH tc prio value update
> 
> Magnus Karlsson <magnus.karlsson@intel.com>
>     ixgbevf: add correct exception tracing for XDP
> 
> Magnus Karlsson <magnus.karlsson@intel.com>
>     igb: add correct exception tracing for XDP
> 
> Wei Yongjun <weiyongjun1@huawei.com>
>     ieee802154: fix error return code in ieee802154_llsec_getparams()
> 
> Zhen Lei <thunder.leizhen@huawei.com>
>     ieee802154: fix error return code in ieee802154_add_iface()
> 
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf, lockdown, audit: Fix buggy SELinux lockdown permission checks
> 
> Tobias Klauser <tklauser@distanz.ch>
>     bpf: Simplify cases in bpf_base_func_proto
> 
> Zhihao Cheng <chengzhihao1@huawei.com>
>     drm/i915/selftests: Fix return value check in live_breadcrumbs_smoketest()
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_ct: skip expectations for confirmed conntrack
> 
> Max Gurtovoy <mgurtovoy@nvidia.com>
>     nvmet: fix freeing unallocated p2pmem
> 
> Yevgeny Kliteynik <kliteyn@nvidia.com>
>     net/mlx5: DR, Create multi-destination flow table with level less than 64
> 
> Roi Dayan <roid@nvidia.com>
>     net/mlx5e: Check for needed capability for cvlan matching
> 
> Moshe Shemesh <moshe@nvidia.com>
>     net/mlx5: Check firmware sync reset requested is set before trying to abort it
> 
> Aya Levin <ayal@nvidia.com>
>     net/mlx5e: Fix incompatible casting
> 
> Maxim Mikityanskiy <maximmi@nvidia.com>
>     net/tls: Fix use-after-free after the TLS device goes down and up
> 
> Maxim Mikityanskiy <maximmi@nvidia.com>
>     net/tls: Replace TLS_RX_SYNC_RUNNING with RCU
> 
> Alexander Aring <aahringo@redhat.com>
>     net: sock: fix in-kernel mark setting
> 
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net: dsa: tag_8021q: fix the VLAN IDs used for encoding sub-VLANs
> 
> Li Huafei <lihuafei1@huawei.com>
>     perf probe: Fix NULL pointer dereference in convert_variable_location()
> 
> Erik Kaneda <erik.kaneda@intel.com>
>     ACPICA: Clean up context mutex during object deletion
> 
> Sagi Grimberg <sagi@grimberg.me>
>     nvme-rdma: fix in-casule data send for chained sgls
> 
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: always parse mptcp options for MPC reqsk
> 
> Ariel Levkovich <lariel@nvidia.com>
>     net/sched: act_ct: Fix ct template allocation for zone 0
> 
> Paul Blakey <paulb@nvidia.com>
>     net/sched: act_ct: Offload connections with commit action
> 
> Parav Pandit <parav@nvidia.com>
>     devlink: Correct VIRTUAL port to not have phys_port attributes
> 
> Arnd Bergmann <arnd@arndb.de>
>     HID: i2c-hid: fix format string mismatch
> 
> Zhen Lei <thunder.leizhen@huawei.com>
>     HID: pidff: fix error return code in hid_pidff_init()
> 
> Tom Rix <trix@redhat.com>
>     HID: logitech-hidpp: initialize level variable
> 
> Julian Anastasov <ja@ssi.bg>
>     ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service
> 
> Max Gurtovoy <mgurtovoy@nvidia.com>
>     vfio/platform: fix module_put call in error flow
> 
> Wei Yongjun <weiyongjun1@huawei.com>
>     samples: vfio-mdev: fix error handing in mdpy_fb_probe()
> 
> Randy Dunlap <rdunlap@infradead.org>
>     vfio/pci: zap_vma_ptes() needs MMU
> 
> Zhen Lei <thunder.leizhen@huawei.com>
>     vfio/pci: Fix error return code in vfio_ecap_init()
> 
> Rasmus Villemoes <linux@rasmusvillemoes.dk>
>     efi: cper: fix snprintf() use in cper_dimm_err_location()
> 
> Dan Carpenter <dan.carpenter@oracle.com>
>     efi/libstub: prevent read overflow in find_file_option()
> 
> Heiner Kallweit <hkallweit1@gmail.com>
>     efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared
> 
> Changbin Du <changbin.du@intel.com>
>     efi/fdt: fix panic when no valid fdt found
> 
> Florian Westphal <fw@strlen.de>
>     netfilter: conntrack: unregister ipv4 sockopts on error unwind
> 
> Grant Peltier <grantpeltier93@gmail.com>
>     hwmon: (pmbus/isl68137) remove READ_TEMPERATURE_3 for RAA228228
> 
> Armin Wolf <W_Armin@gmx.de>
>     hwmon: (dell-smm-hwmon) Fix index values
> 
> Grant Grundler <grundler@chromium.org>
>     net: usb: cdc_ncm: don't spew notifications
> 
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: tree-checker: do not error out if extent ref hash doesn't match
> 
> 
> -------------
> 
> Diffstat:
> 
>  Makefile                                           |   4 +-
>  arch/arm/boot/dts/imx6dl-yapp4-common.dtsi         |   6 +-
>  arch/arm/boot/dts/imx6q-dhcom-som.dtsi             |  12 ++
>  arch/arm/boot/dts/imx6qdl-emcon-avari.dtsi         |   2 +-
>  arch/arm/boot/dts/imx7d-meerkat96.dts              |   2 +-
>  arch/arm/boot/dts/imx7d-pico.dtsi                  |   2 +-
>  .../freescale/fsl-ls1028a-kontron-sl28-var4.dts    |   5 +-
>  arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |   4 +-
>  .../arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi |   4 +-
>  arch/arm64/boot/dts/ti/k3-j7200-main.dtsi          |   2 +
>  arch/arm64/kvm/sys_regs.c                          |  42 ++---
>  arch/powerpc/kernel/kprobes.c                      |   4 +-
>  arch/riscv/kernel/vdso/Makefile                    |   4 +-
>  arch/x86/include/asm/apic.h                        |   1 +
>  arch/x86/include/asm/disabled-features.h           |   7 +-
>  arch/x86/include/asm/fpu/api.h                     |   6 +-
>  arch/x86/include/asm/fpu/internal.h                |   7 -
>  arch/x86/include/asm/kvm_para.h                    |  10 +-
>  arch/x86/kernel/apic/apic.c                        |   1 +
>  arch/x86/kernel/apic/vector.c                      |  20 +++
>  arch/x86/kernel/fpu/xstate.c                       |  57 -------
>  arch/x86/kernel/kvm.c                              |  92 +++++++---
>  arch/x86/kernel/kvmclock.c                         |  26 +--
>  arch/x86/kvm/svm/svm.c                             |   8 +-
>  arch/x86/mm/mem_encrypt_identity.c                 |  11 +-
>  drivers/acpi/acpica/utdelete.c                     |   8 +
>  drivers/bus/ti-sysc.c                              |  57 ++++++-
>  drivers/firmware/efi/cper.c                        |   4 +-
>  drivers/firmware/efi/fdtparams.c                   |   3 +
>  drivers/firmware/efi/libstub/file.c                |   2 +-
>  drivers/firmware/efi/memattr.c                     |   5 -
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |  16 --
>  drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |   4 +-
>  drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c             |   4 +-
>  drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c              |   1 +
>  drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   5 +-
>  drivers/gpu/drm/i915/selftests/i915_request.c      |   4 +-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   3 +-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c           |  51 +-----
>  drivers/hid/hid-logitech-hidpp.c                   |   1 +
>  drivers/hid/hid-magicmouse.c                       |   2 +-
>  drivers/hid/hid-multitouch.c                       |  10 +-
>  drivers/hid/i2c-hid/i2c-hid-core.c                 |  13 +-
>  drivers/hid/usbhid/hid-pidff.c                     |   1 +
>  drivers/hwmon/dell-smm-hwmon.c                     |   4 +-
>  drivers/hwmon/pmbus/isl68137.c                     |   4 +-
>  drivers/i2c/busses/i2c-qcom-geni.c                 |  21 ++-
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   2 -
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   4 +-
>  .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |  14 +-
>  .../net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c   |   9 +-
>  drivers/net/ethernet/chelsio/cxgb4/sge.c           |   6 +
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   7 +-
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  15 +-
>  drivers/net/ethernet/intel/ice/ice_ethtool.c       |  51 +-----
>  drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |   1 +
>  drivers/net/ethernet/intel/ice/ice_lib.c           |   2 +
>  drivers/net/ethernet/intel/ice/ice_txrx.c          |  24 +--
>  drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  19 ++-
>  drivers/net/ethernet/intel/ice/ice_xsk.c           |  16 +-
>  drivers/net/ethernet/intel/igb/igb_main.c          |  10 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  16 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  21 ++-
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   3 +
>  .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   5 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   9 +
>  drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   3 +
>  .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |   3 +-
>  drivers/net/usb/cdc_ncm.c                          |  12 +-
>  drivers/net/wireguard/Makefile                     |   3 +-
>  drivers/net/wireguard/allowedips.c                 | 189 +++++++++++----------
>  drivers/net/wireguard/allowedips.h                 |  14 +-
>  drivers/net/wireguard/main.c                       |  17 +-
>  drivers/net/wireguard/peer.c                       |  27 ++-
>  drivers/net/wireguard/peer.h                       |   3 +
>  drivers/net/wireguard/selftest/allowedips.c        | 165 +++++++++---------
>  drivers/net/wireguard/socket.c                     |   2 +-
>  drivers/net/xen-netback/interface.c                |   6 +
>  drivers/nvme/host/rdma.c                           |   5 +-
>  drivers/nvme/target/core.c                         |  33 ++--
>  drivers/tee/optee/call.c                           |   6 +-
>  drivers/tee/optee/optee_msg.h                      |   6 +-
>  drivers/tty/serial/stm32-usart.c                   |  22 +--
>  drivers/usb/dwc2/core_intr.c                       |   4 +
>  drivers/vfio/pci/Kconfig                           |   1 +
>  drivers/vfio/pci/vfio_pci_config.c                 |   2 +-
>  drivers/vfio/platform/vfio_platform_common.c       |   2 +-
>  fs/btrfs/extent-tree.c                             |  12 +-
>  fs/btrfs/file-item.c                               |  10 +-
>  fs/btrfs/inode.c                                   |  19 ++-
>  fs/btrfs/reflink.c                                 |  38 +++--
>  fs/btrfs/tree-checker.c                            |  16 +-
>  fs/btrfs/tree-log.c                                |  13 +-
>  fs/ext4/extents.c                                  |  43 ++---
>  fs/ext4/fast_commit.c                              | 182 ++++++++++----------
>  fs/ext4/fast_commit.h                              |   7 -
>  fs/ext4/ialloc.c                                   |   6 +-
>  fs/ext4/mballoc.c                                  |   2 +-
>  fs/ext4/super.c                                    |  11 +-
>  fs/gfs2/glock.c                                    |   2 +
>  fs/io_uring.c                                      |   6 +-
>  fs/ocfs2/file.c                                    |  55 +++++-
>  include/linux/mlx5/mlx5_ifc.h                      |   2 +
>  include/linux/platform_data/ti-sysc.h              |   1 +
>  include/linux/usb/usbnet.h                         |   2 +
>  include/net/caif/caif_dev.h                        |   2 +-
>  include/net/caif/cfcnfg.h                          |   2 +-
>  include/net/caif/cfserl.h                          |   1 +
>  include/net/tls.h                                  |  10 +-
>  init/main.c                                        |   2 +-
>  kernel/bpf/helpers.c                               |  19 +--
>  kernel/trace/bpf_trace.c                           |  32 ++--
>  lib/lz4/lz4_decompress.c                           |   6 +-
>  lib/lz4/lz4defs.h                                  |   1 +
>  mm/debug_vm_pgtable.c                              |   4 +-
>  mm/hugetlb.c                                       |  14 +-
>  mm/page_alloc.c                                    |   2 +
>  net/bluetooth/hci_core.c                           |   7 +-
>  net/bluetooth/hci_sock.c                           |   4 +-
>  net/caif/caif_dev.c                                |  13 +-
>  net/caif/caif_usb.c                                |  14 +-
>  net/caif/cfcnfg.c                                  |  16 +-
>  net/caif/cfserl.c                                  |   5 +
>  net/core/devlink.c                                 |   4 +-
>  net/core/neighbour.c                               |   1 +
>  net/core/sock.c                                    |  16 +-
>  net/dsa/tag_8021q.c                                |   2 +-
>  net/ieee802154/nl-mac.c                            |   4 +-
>  net/ieee802154/nl-phy.c                            |   4 +-
>  net/ipv6/route.c                                   |   8 +-
>  net/mptcp/subflow.c                                |  17 +-
>  net/netfilter/ipvs/ip_vs_ctl.c                     |   2 +-
>  net/netfilter/nf_conntrack_proto.c                 |   2 +-
>  net/netfilter/nf_tables_api.c                      |   4 +-
>  net/netfilter/nfnetlink_cthelper.c                 |   8 +-
>  net/netfilter/nft_ct.c                             |   2 +-
>  net/nfc/llcp_sock.c                                |   2 +
>  net/sched/act_ct.c                                 |  10 +-
>  net/tipc/bearer.c                                  |  94 +++++++---
>  net/tls/tls_device.c                               |  60 +++++--
>  net/tls/tls_device_fallback.c                      |   7 +
>  net/tls/tls_main.c                                 |   1 +
>  samples/vfio-mdev/mdpy-fb.c                        |  13 +-
>  sound/core/timer.c                                 |   3 +-
>  sound/pci/hda/hda_codec.c                          |   5 +
>  sound/pci/hda/patch_realtek.c                      |   1 +
>  tools/perf/util/dwarf-aux.c                        |   8 +-
>  tools/perf/util/probe-finder.c                     |   3 +
>  tools/testing/selftests/wireguard/netns.sh         |   1 +
>  .../testing/selftests/wireguard/qemu/kernel.config |   1 -
>  150 files changed, 1260 insertions(+), 925 deletions(-)
> 
> 

-- 
Florian
