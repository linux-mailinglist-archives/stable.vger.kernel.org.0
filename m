Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85693454E98
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 21:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhKQUfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 15:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhKQUff (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 15:35:35 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF08AC061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 12:32:35 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z5so16666015edd.3
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 12:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3VbfFqE7aOuN/sCqRs4or4hz5ONPnwKGBkM9LBZN8Oo=;
        b=GdVFwu+M8eBU73oya80QPWRFq5mfpklLLLXnilcVcd2W8IFWLtu2bnE0xIngTDidYI
         vL29U7dk7E/FIQ9vsRV4c99f3zzuxMFwXBzDZsznEFTS8Yu+kSxlusogaiUsAyX/IkO/
         8adxhkdoyv3uv1wzbrsFtkr0c0OoMl3OxujDPWshxMuZnxYjCGf+ELkeiaJijWhPSsGU
         MCI5a0yziN3lGd/ut3kpa/wfRNoxLgrlz33ITir6r0/KJGjdYc9v19ftfaupFDVQjsSM
         W/mdlaum1WEP9NgAxL0dqYhJAS3tMXHJdsZwZQxX5Q4XGaYdwYIYLOLkMx/yTVAceSJA
         0pnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3VbfFqE7aOuN/sCqRs4or4hz5ONPnwKGBkM9LBZN8Oo=;
        b=aGJlnTas1Uak2UykP/F+lKRF1I1KjY/gJivGygLDpZrcSMm9dy/huXvVdWdvBso4P8
         HhETWE5r3bj76+hgvaKfFp65SdCG13zTvWRtKyLyGO/pvlyfQOxu/a2+jXihu4TDun0B
         Tgh8TWJB280PUWBpMqq8japEG8KmmFihwnxL0sqdj+xEd+xqAVq8sF1BR4CXW4gffXwh
         daCCYQczpsQ2hpNn8RjM+agLzGZuhdsrB9cVhu3DTKOLYQ7Qc6o45yiXrn7XYTmP+nUS
         iTTgw9hCYvCmnHTbay97I7kSxxxgzua6UGk6w2PU3Mr3eUGZVXqS97HnV1Z3d9gAocTR
         YC5w==
X-Gm-Message-State: AOAM530yvuX/ORDSXJVdEF1CVACLQtliip8q3XRZM2PQ8O41iLWFC6FK
        wrJ0etGmpRYZ8jaW9n/WmxqjWeFyIFLJp2ELfwd3gA==
X-Google-Smtp-Source: ABdhPJwztp/6Qag/b4iOS5BaKVujm7YBggmL9LyNJBPFx78WNKc/WeRKIZ1Z4ZU30b9YhYy5OInZFOp2KGAIdyOuS8M=
X-Received: by 2002:a17:906:168e:: with SMTP id s14mr25079239ejd.340.1637181154237;
 Wed, 17 Nov 2021 12:32:34 -0800 (PST)
MIME-Version: 1.0
References: <20211117101457.890809587@linuxfoundation.org>
In-Reply-To: <20211117101457.890809587@linuxfoundation.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Wed, 17 Nov 2021 21:32:22 +0100
Message-ID: <CADYN=9LNevXvdmgkCC06FFxQEq3JHHb4k=0DfiGLpW3viBzojA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/577] 5.10.80-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Nov 2021 at 11:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 577 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Nov 2021 10:11:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.80-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.10.80-rc3
>
> Borislav Petkov <bp@suse.de>
>     x86/sev: Make the #VC exception stacks part of the default stacks sto=
rage
>
> Tom Lendacky <thomas.lendacky@amd.com>
>     x86/sev: Add an x86 version of cc_platform_has()
>
> Tom Lendacky <thomas.lendacky@amd.com>
>     arch/cc: Introduce a function to check for confidential computing fea=
tures
>
> Dan Carpenter <dan.carpenter@oracle.com>
>     ataflop: fix off by one in ataflop_probe()
>
> Andrii Nakryiko <andrii@kernel.org>
>     selftests/bpf: Fix also no-alu32 strobemeta selftest
>
> Colin Ian King <colin.king@canonical.com>
>     mmc: moxart: Fix null pointer dereference on pointer host
>
> Arnd Bergmann <arnd@arndb.de>
>     ath10k: fix invalid dma_addr_t token assignment
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     SUNRPC: Partial revert of commit 6f9f17287e78
>
> Pali Roh=C3=A1r <pali@kernel.org>
>     PCI: aardvark: Fix PCIe Max Payload Size setting
>
> Pali Roh=C3=A1r <pali@kernel.org>
>     PCI: Add PCI_EXP_DEVCTL_PAYLOAD_* macros
>
> Jernej Skrabec <jernej.skrabec@gmail.com>
>     drm/sun4i: Fix macros in sun8i_csc.h
>
> Xiaoming Ni <nixiaoming@huawei.com>
>     powerpc/85xx: fix timebase sync issue when CONFIG_HOTPLUG_CPU=3Dn
>
> Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
>     powerpc/powernv/prd: Unregister OPAL_MSG_PRD2 notifier during module =
unload
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: rawnand: au1550nd: Keep the driver compatible with on-die ECC en=
gines
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: rawnand: plat_nand: Keep the driver compatible with on-die ECC e=
ngines
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: rawnand: orion: Keep the driver compatible with on-die ECC engin=
es
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: rawnand: pasemi: Keep the driver compatible with on-die ECC engi=
nes
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: rawnand: gpio: Keep the driver compatible with on-die ECC engine=
s
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: rawnand: mpc5121: Keep the driver compatible with on-die ECC eng=
ines
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: rawnand: xway: Keep the driver compatible with on-die ECC engine=
s
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: rawnand: ams-delta: Keep the driver compatible with on-die ECC e=
ngines
>
> Halil Pasic <pasic@linux.ibm.com>
>     s390/cio: make ccw_device_dma_* more robust
>
> Harald Freudenberger <freude@linux.ibm.com>
>     s390/ap: Fix hanging ioctl caused by orphaned replies
>
> Sven Schnelle <svens@linux.ibm.com>
>     s390/tape: fix timer initialization in tape_std_assign()
>
> Vineeth Vijayan <vneethv@linux.ibm.com>
>     s390/cio: check the subchannel validity for dev_busid
>
> Marek Vasut <marex@denx.de>
>     video: backlight: Drop maximum brightness override for brightness zer=
o
>
> Jack Andersen <jackoalan@gmail.com>
>     mfd: dln2: Add cell for initializing DLN2 ADC
>
> Michal Hocko <mhocko@suse.com>
>     mm, oom: do not trigger out_of_memory from the #PF
>
> Vasily Averin <vvs@virtuozzo.com>
>     mm, oom: pagefault_out_of_memory: don't force global OOM for dying ta=
sks
>
> Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>     powerpc/bpf: Emit stf barrier instruction sequences for BPF_NOSPEC
>
> Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>     powerpc/security: Add a helper to query stf_barrier type
>
> Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>     powerpc/bpf: Validate branch ranges
>
> Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>     powerpc/lib: Add helper to check if offset is within conditional bran=
ch range
>
> Vasily Averin <vvs@virtuozzo.com>
>     memcg: prohibit unconditional exceeding the limit of dying tasks
>
> Dominique Martinet <asmadeus@codewreck.org>
>     9p/net: fix missing error check in p9_check_errors
>
> Daniel Borkmann <daniel@iogearbox.net>
>     net, neigh: Enable state migration between NUD_PERMANENT and NTF_USE
>
> Jaegeuk Kim <jaegeuk@kernel.org>
>     f2fs: should use GFP_NOFS for directory inodes
>
> Guo Ren <guoren@linux.alibaba.com>
>     irqchip/sifive-plic: Fixup EOI failed when masked
>
> Michael Pratt <mpratt@google.com>
>     posix-cpu-timers: Clear task::posix_cputimers_work in copy_process()
>
> Dave Jones <davej@codemonkey.org.uk>
>     x86/mce: Add errata workaround for Skylake SKX37
>
> Maciej W. Rozycki <macro@orcam.me.uk>
>     MIPS: Fix assembly error from MIPSr2 code used within MIPS_ISA_ARCH_L=
EVEL
>
> Helge Deller <deller@gmx.de>
>     parisc: Fix backtrace to always include init funtion names
>
> Arnd Bergmann <arnd@arndb.de>
>     ARM: 9156/1: drop cc-option fallbacks for architecture selection
>
> Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>
>     ARM: 9155/1: fix early early_iounmap()
>
> Willem de Bruijn <willemb@google.com>
>     selftests/net: udpgso_bench_rx: fix port argument
>
> Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
>     cxgb4: fix eeprom len when diagnostics not implemented
>
> Dust Li <dust.li@linux.alibaba.com>
>     net/smc: fix sk_refcnt underflow on linkdown and fallback
>
> Eiichi Tsukata <eiichi.tsukata@nutanix.com>
>     vsock: prevent unnecessary refcnt inc for nonblocking connect
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net: stmmac: allow a tc-taprio base-time of zero
>
> Guangbin Huang <huangguangbin2@huawei.com>
>     net: hns3: allow configure ETS bandwidth of all TCs
>
> Yufeng Mo <moyufeng@huawei.com>
>     net: hns3: fix kernel crash when unload VF while it is being reset
>
> Eric Dumazet <edumazet@google.com>
>     net/sched: sch_taprio: fix undefined behavior in ktime_mono_to_any
>
> Muchun Song <songmuchun@bytedance.com>
>     seq_file: fix passing wrong private data
>
> Dan Carpenter <dan.carpenter@oracle.com>
>     gve: Fix off by one in gve_tx_timeout()
>
> John Fastabend <john.fastabend@gmail.com>
>     bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and collidi=
ng
>
> John Fastabend <john.fastabend@gmail.com>
>     bpf, sockmap: Remove unhash handler for BPF sockmap usage
>
> Arnd Bergmann <arnd@arndb.de>
>     arm64: pgtable: make __pte_to_phys/__phys_to_pte_val inline functions
>
> Chengfeng Ye <cyeaa@connect.ust.hk>
>     nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails
>
> Eric Dumazet <edumazet@google.com>
>     llc: fix out-of-bound array index in llc_sk_dev_hash()
>
> Ian Rogers <irogers@google.com>
>     perf bpf: Add missing free to bpf_event__print_bpf_prog_info()
>
> Dan Carpenter <dan.carpenter@oracle.com>
>     zram: off by one in read_block_state()
>
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/zsmalloc.c: close race window between zs_pool_dec_isolated() and z=
s_unregister_migration()
>
> Marc Kleine-Budde <mkl@pengutronix.de>
>     can: mcp251xfd: mcp251xfd_chip_start(): fix error handling for mcp251=
xfd_chip_rx_int_enable()
>
> Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>     mfd: core: Add missing of_node_put for loop iteration
>
> Huang Guobin <huangguobin4@huawei.com>
>     bonding: Fix a use-after-free problem when bond_sysfs_slave_add() fai=
led
>
> Heiner Kallweit <hkallweit1@gmail.com>
>     net: phy: fix duplex out of sync problem while changing settings
>
> Luis Chamberlain <mcgrof@kernel.org>
>     block/ataflop: provide a helper for cleanup up an atari disk
>
> Luis Chamberlain <mcgrof@kernel.org>
>     block/ataflop: add registration bool before calling del_gendisk()
>
> Luis Chamberlain <mcgrof@kernel.org>
>     block/ataflop: use the blk_cleanup_disk() helper
>
> Chenyuan Mi <cymi20@fudan.edu.cn>
>     drm/nouveau/svm: Fix refcount leak bug and missing check against null=
 bug
>
> Hans de Goede <hdegoede@redhat.com>
>     ACPI: PMIC: Fix intel_pmic_regs_handler() read accesses
>
> Brett Creeley <brett.creeley@intel.com>
>     ice: Fix not stopping Tx queues for VFs
>
> Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
>     ice: Fix replacing VF hardware MAC to existing MAC filter
>
> Ziyang Xuan <william.xuanziyang@huawei.com>
>     net: vlan: fix a UAF in vlan_dev_real_dev()
>
> Stafford Horne <shorne@gmail.com>
>     openrisc: fix SMP tlb flush NULL pointer dereference
>
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: fix ethtool msg len calculation for pause stats
>
> Maxim Kiselev <bigunclemax@gmail.com>
>     net: davinci_emac: Fix interrupt pacing disable
>
> YueHaibing <yuehaibing@huawei.com>
>     xen-pciback: Fix return in pm_ctrl_init()
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     i2c: xlr: Fix a resource leak in the error handling path of 'xlr_i2c_=
probe()'
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFSv4: Fix a regression in nfs_set_open_stateid_locked()
>
> Quinn Tran <qutran@marvell.com>
>     scsi: qla2xxx: Turn off target reset during issue_lip
>
> Quinn Tran <qutran@marvell.com>
>     scsi: qla2xxx: Fix gnl list corruption
>
> Quinn Tran <qutran@marvell.com>
>     scsi: qla2xxx: Relogin during fabric disturbance
>
> Saurav Kashyap <skashyap@marvell.com>
>     scsi: qla2xxx: Changes to support FCP2 Target
>
> Jackie Liu <liuyun01@kylinos.cn>
>     ar7: fix kernel builds for compiler test
>
> Ahmad Fatoum <a.fatoum@pengutronix.de>
>     watchdog: f71808e_wdt: fix inaccurate report in WDIOC_GETTIMEOUT
>
> Randy Dunlap <rdunlap@infradead.org>
>     m68k: set a default value for MEMORY_RESERVE
>
> Eric W. Biederman <ebiederm@xmission.com>
>     signal/sh: Use force_sig(SIGKILL) instead of do_group_exit(SIGKILL)
>
> Lars-Peter Clausen <lars@metafoo.de>
>     dmaengine: dmaengine_desc_callback_valid(): Check for `callback_resul=
t`
>
> Florian Westphal <fw@strlen.de>
>     netfilter: nfnetlink_queue: fix OOB when mac header was cleared
>
> Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
>     soc: fsl: dpaa2-console: free buffer before returning from dpaa2_cons=
ole_read
>
> Geert Uytterhoeven <geert@linux-m68k.org>
>     auxdisplay: ht16k33: Fix frame buffer device blanking
>
> Geert Uytterhoeven <geert@linux-m68k.org>
>     auxdisplay: ht16k33: Connect backlight to fbdev
>
> Geert Uytterhoeven <geert@linux-m68k.org>
>     auxdisplay: img-ascii-lcd: Fix lock-up when displaying empty string
>
> Alexey Gladkov <legion@kernel.org>
>     Fix user namespace leak
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Fix an Oops in pnfs_mark_request_commit()
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Fix up commit deadlocks
>
> Claudiu Beznea <claudiu.beznea@microchip.com>
>     dmaengine: at_xdmac: fix AT_XDMAC_CC_PERID() macro
>
> Dan Carpenter <dan.carpenter@oracle.com>
>     rtc: rv3032: fix error handling in rv3032_clkout_set_rate()
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     remoteproc: Fix a memory leak in an error handling path in 'rproc_han=
dle_vdev()'
>
> Zev Weiss <zev@bewilderbeest.net>
>     mtd: core: don't remove debugfs directory if device is in use
>
> Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>     PCI: uniphier: Serialize INTx masking/unmasking and fix the bit opera=
tion
>
> Evgeny Novikov <novikov@ispras.ru>
>     mtd: spi-nor: hisi-sfc: Remove excessive clk_disable_unprepare()
>
> Jia-Ju Bai <baijiaju1990@gmail.com>
>     fs: orangefs: fix error return code of orangefs_revalidate_lookup()
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Fix deadlocks in nfs_scan_commit_list()
>
> YueHaibing <yuehaibing@huawei.com>
>     opp: Fix return in _opp_add_static_v2()
>
> Pali Roh=C3=A1r <pali@kernel.org>
>     PCI: aardvark: Fix preserving PCI_EXP_RTCTL_CRSSVE flag on emulated b=
ridge
>
> Marek Beh=C3=BAn <kabel@kernel.org>
>     PCI: aardvark: Don't spam about PIO Response Status
>
> Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
>     drm/plane-helper: fix uninitialized variable reference
>
> Baptiste Lepers <baptiste.lepers@gmail.com>
>     pnfs/flexfiles: Fix misplaced barrier in nfs4_ff_layout_prepare_ds
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Fix dentry verifier races
>
> Kewei Xu <kewei.xu@mediatek.com>
>     i2c: mediatek: fixing the incorrect register offset
>
> J. Bruce Fields <bfields@redhat.com>
>     nfsd: don't alloc under spinlock in rpc_parse_scope_id
>
> Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
>     rpmsg: Fix rpmsg_create_ept return when RPMSG config is not defined
>
> Tom Rix <trix@redhat.com>
>     apparmor: fix error check
>
> Hans de Goede <hdegoede@redhat.com>
>     power: supply: bq27xxx: Fix kernel crash on IRQ handler register erro=
r
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     mips: cm: Convert to bitfield API to fix out-of-bounds access
>
> Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>     virtio_ring: check desc =3D=3D NULL when using indirect with packed
>
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ASoC: cs42l42: Correct configuring of switch inversion from ts-inv
>
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ASoC: cs42l42: Use device_property API instead of of_property
>
> Lucas Tanure <tanureal@opensource.cirrus.com>
>     ASoC: cs42l42: Disable regulators if probe fails
>
> Bixuan Cui <cuibixuan@linux.alibaba.com>
>     powerpc/44x/fsp2: add missing of_node_put
>
> Andrej Shadura <andrew.shadura@collabora.co.uk>
>     HID: u2fzero: properly handle timeouts in usb_submit_urb
>
> Andrej Shadura <andrew.shadura@collabora.co.uk>
>     HID: u2fzero: clarify error check and length calculations
>
> Claudiu Beznea <claudiu.beznea@microchip.com>
>     clk: at91: sam9x60-pll: use DIV_ROUND_CLOSEST_ULL
>
> Anssi Hannula <anssi.hannula@bitwise.fi>
>     serial: xilinx_uartps: Fix race condition causing stuck TX
>
> Sandeep Maheswaram <quic_c_sanm@quicinc.com>
>     phy: qcom-snps: Correct the FSEL_MASK
>
> Dan Carpenter <dan.carpenter@oracle.com>
>     phy: ti: gmii-sel: check of_get_address() for failure
>
> Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>     phy: qcom-qusb2: Fix a memory leak on probe
>
> Rahul Tanwar <rtanwar@maxlinear.com>
>     pinctrl: equilibrium: Fix function addition in multiple groups
>
> Wan Jiabing <wanjiabing@vivo.com>
>     soc: qcom: apr: Add of_node_put() before return
>
> Guru Das Srinagesh <quic_gurus@quicinc.com>
>     firmware: qcom_scm: Fix error retval in __qcom_scm_is_call_available(=
)
>
> Amelie Delaunay <amelie.delaunay@foss.st.com>
>     usb: dwc2: drd: reset current session before setting the new one
>
> Amelie Delaunay <amelie.delaunay@foss.st.com>
>     usb: dwc2: drd: fix dwc2_drd_role_sw_set when clock could be disabled
>
> Amelie Delaunay <amelie.delaunay@foss.st.com>
>     usb: dwc2: drd: fix dwc2_force_mode call in dwc2_ovr_init
>
> Stefan Agner <stefan@agner.ch>
>     serial: imx: fix detach/attach of serial console
>
> Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>     scsi: ufs: ufshcd-pltfrm: Fix memory leak due to probe defer
>
> Can Guo <cang@codeaurora.org>
>     scsi: ufs: Refactor ufshcd_setup_clocks() to remove skip_ref_clk
>
> Nuno S=C3=A1 <nuno.sa@analog.com>
>     iio: adis: do not disabe IRQs in 'adis_init()'
>
> Randy Dunlap <rdunlap@infradead.org>
>     usb: typec: STUSB160X should select REGMAP_I2C
>
> Bjorn Andersson <bjorn.andersson@linaro.org>
>     soc: qcom: rpmhpd: Make power_on actually enable the domain
>
> Lee Jones <lee.jones@linaro.org>
>     soc: qcom: rpmhpd: Provide some missing struct member descriptions
>
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ASoC: cs42l42: Defer probe if request_threaded_irq() returns EPROBE_D=
EFER
>
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ASoC: cs42l42: Correct some register default values
>
> Olivier Moysan <olivier.moysan@foss.st.com>
>     ARM: dts: stm32: fix AV96 board SAI2 pin muxing on stm32mp15
>
> Olivier Moysan <olivier.moysan@foss.st.com>
>     ARM: dts: stm32: fix SAI sub nodes register range
>
> Marek Vasut <marex@denx.de>
>     ARM: dts: stm32: Reduce DHCOR SPI NOR frequency to 50 MHz
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     pinctrl: renesas: checker: Fix off-by-one bug in drive register check
>
> Vegard Nossum <vegard.nossum@oracle.com>
>     staging: ks7010: select CRYPTO_HASH/CRYPTO_MICHAEL_MIC
>
> Nikita Yushchenko <nikita.yoush@cogentembedded.com>
>     staging: most: dim2: do not double-register the same device
>
> Randy Dunlap <rdunlap@infradead.org>
>     usb: musb: select GENERIC_PHY instead of depending on it
>
> Leon Romanovsky <leon@kernel.org>
>     RDMA/mlx4: Return missed an error if device doesn't support steering
>
> Dan Carpenter <dan.carpenter@oracle.com>
>     scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()
>
> Yang Yingliang <yangyingliang@huawei.com>
>     power: supply: max17040: fix null-ptr-deref in max17040_probe()
>
> Jakob Hauser <jahau@rocketmail.com>
>     power: supply: rt5033_battery: Change voltage values to =C2=B5V
>
> Dan Carpenter <dan.carpenter@oracle.com>
>     usb: gadget: hid: fix error code in do_config()
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     serial: 8250_dw: Drop wrong use of ACPI_PTR()
>
> Nathan Lynch <nathanl@linux.ibm.com>
>     powerpc: fix unbalanced node refcount in check_kvm_guest()
>
> Michael Ellerman <mpe@ellerman.id.au>
>     powerpc: Fix is_kvm_guest() / kvm_para_available()
>
> Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>     powerpc: Reintroduce is_kvm_guest() as a fast-path check
>
> Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>     powerpc: Rename is_kvm_guest() to check_kvm_guest()
>
> Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>     powerpc: Refactor is_kvm_guest() declaration to new header
>
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     video: fbdev: chipsfb: use memset_io() instead of memset()
>
> Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
>     clk: at91: check pmc node status before registering syscore ops
>
> Dongliang Mu <mudongliangabcd@gmail.com>
>     memory: fsl_ifc: fix leak of irq and nand_irq in fsl_ifc_ctrl_probe
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     soc/tegra: Fix an error handling path in tegra_powergate_power_up()

With this patch applied the following waring shows up:

make --silent --keep-going --jobs=3D32
O=3D/home/anders/.cache/tuxmake/builds/current ARCH=3Darm64
CROSS_COMPILE=3Daarch64-linux-gnu-
                                drivers/soc/tegra/pmc.c: In function
'tegra_powergate_power_up':
drivers/soc/tegra/pmc.c:726:1: warning: label 'powergate_off' defined
but not used [-Wunused-label]   726 | powergate_off:
        | ^~~~~~~~~~~~~

If I cherry pick 19221e308302 ("soc/tegra: pmc: Fix imbalanced clock
disabling in error code path")
the wraning goes away.

Cheers,
Anders
