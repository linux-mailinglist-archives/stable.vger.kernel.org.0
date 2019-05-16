Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5461F201C6
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 10:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfEPIzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 04:55:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39946 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfEPIzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 04:55:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so2413973wre.7
        for <stable@vger.kernel.org>; Thu, 16 May 2019 01:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OLsZ+hLPJZHV1nyaQawQ/V1PxuKUZLaa9nweWq6GGwI=;
        b=dHkMtHjliK3n1yocMW8nNfa5GEGeKR0vDlEJv0lf0lohDCUzfXIscvCOU+KDFFwqeO
         zU+1iXoewd5HRiGiTBuIyMS3j9vnEoK0v1TXMRhYya5jX/iVS2xtFpWKmXlIjtDuDHb4
         I4uXTVDFDacOt8UejngSVcisOeVrlynrACNYs1+yEl9EnA2hKlNhs+2xpaMivPm80eej
         O0WJUIu3jNvyQnT9OyenB2Tu53KvfM2kLrTcfoh6ZML7n+bo2eV0saiYQ8LWugYkIGC5
         BkPrJHXzxdJsI1o5381oKDCDPJ1j3hmxXZqf4M8TfNdusHfT879J6qvckkud3wFSSjxi
         8Qpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OLsZ+hLPJZHV1nyaQawQ/V1PxuKUZLaa9nweWq6GGwI=;
        b=LnB+51/mBs14qoiG8egueKhtFKEfrswf2dD/Vz093/BojfJUYPf8aFvqrgPNSm5Wly
         MSHJcZBOPMiEHmGeYPySQcrJW4DEKm9k7vdMWv3YOq6k2srgET2hHqK11QKmZ/KNNt87
         4QLKGvzywAk6kjOUm1LNzrVKocqm+wu+I2l+iquk5eZm2c49HzSlMzbbnwoZ87ErJU+e
         njln8GmjatGSJdUVz9j2Nx7+NjB101mnzAcUhUfTLuwTZl9YBBgowP2ic89g/j0eSbsl
         a+abfCf7ljdgcpgP2eXC/9uqu9PKFuIkwQho6qCXMD0Nuaz2DM3eIG7g5sMpo/Hfhq4n
         S/jw==
X-Gm-Message-State: APjAAAXiFhI8lvd8YTkWZRX3ldVVCsomVeYUkDyxzJB3Y2/mxKolyq9F
        BXz+KgPkQiLqRl04NugNlSYOb66rHdV2IA==
X-Google-Smtp-Source: APXvYqx6Dr1giDKDQRTFaes3ubriwLNNQ2s2woqCL5RJ4eRhyOrFWRbDQHuQIMzz6ale032bOsiBXw==
X-Received: by 2002:a5d:554f:: with SMTP id g15mr1219379wrw.318.1557996894545;
        Thu, 16 May 2019 01:54:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f81sm4604645wmf.10.2019.05.16.01.54.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 01:54:53 -0700 (PDT)
Message-ID: <5cdd255d.1c69fb81.90fb5.9f00@mx.google.com>
Date:   Thu, 16 May 2019 01:54:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-3.18.y
X-Kernelci-Kernel: v3.18.140
Subject: stable/linux-3.18.y build: 189 builds: 8 failed, 181 passed, 42 errors,
 2910 warnings (v3.18.140)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-3.18.y build: 189 builds: 8 failed, 181 passed, 42 errors, 291=
0 warnings (v3.18.140)

Full Build Summary: https://kernelci.org/build/stable/branch/linux-3.18.y/k=
ernel/v3.18.140/

Tree: stable
Branch: linux-3.18.y
Git Describe: v3.18.140
Git Commit: 6b1ae527b1fdee86e81da0cb26ced75731c6c0fa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Built: 6 unique architectures

Build Failures Detected:

arc:
    allnoconfig: (gcc-8) FAIL
    fpga_defconfig: (gcc-8) FAIL
    fpga_noramfs_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

mips:
    bigsur_defconfig: (gcc-8) FAIL
    nlm_xlr_defconfig: (gcc-8) FAIL
    sb1250_swarm_defconfig: (gcc-8) FAIL
    sead3micro_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 3 errors, 205 warnings
    fpga_defconfig (gcc-8): 3 warnings
    fpga_noramfs_defconfig (gcc-8): 3 errors, 8 warnings
    tinyconfig (gcc-8): 1 error, 320 warnings

arm64:
    defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning

arm:
    acs5k_defconfig (gcc-8): 1 warning
    acs5k_tiny_defconfig (gcc-8): 1 warning
    am200epdkit_defconfig (gcc-8): 1 warning
    ape6evm_defconfig (gcc-8): 1 warning
    assabet_defconfig (gcc-8): 1 warning
    at91rm9200_defconfig (gcc-8): 1 warning
    at91sam9260_9g20_defconfig (gcc-8): 1 warning
    at91sam9261_9g10_defconfig (gcc-8): 1 warning
    at91sam9263_defconfig (gcc-8): 1 warning
    at91sam9rl_defconfig (gcc-8): 1 warning
    axm55xx_defconfig (gcc-8): 1 warning
    badge4_defconfig (gcc-8): 1 warning
    bcm_defconfig (gcc-8): 1 warning
    bockw_defconfig (gcc-8): 1 warning
    cerfcube_defconfig (gcc-8): 1 warning
    clps711x_defconfig (gcc-8): 1 warning
    cm_x2xx_defconfig (gcc-8): 1 warning
    cm_x300_defconfig (gcc-8): 1 warning
    colibri_pxa270_defconfig (gcc-8): 1 warning
    colibri_pxa300_defconfig (gcc-8): 1 warning
    collie_defconfig (gcc-8): 1 warning
    corgi_defconfig (gcc-8): 1 warning
    davinci_all_defconfig (gcc-8): 1 warning
    dove_defconfig (gcc-8): 1 warning
    ebsa110_defconfig (gcc-8): 1 warning
    em_x270_defconfig (gcc-8): 1 warning
    ep93xx_defconfig (gcc-8): 1 warning
    eseries_pxa_defconfig (gcc-8): 1 warning
    exynos_defconfig (gcc-8): 1 warning
    ezx_defconfig (gcc-8): 1 warning
    footbridge_defconfig (gcc-8): 1 warning
    h3600_defconfig (gcc-8): 1 warning
    h5000_defconfig (gcc-8): 1 warning
    hackkit_defconfig (gcc-8): 1 warning
    hisi_defconfig (gcc-8): 1 warning
    imote2_defconfig (gcc-8): 1 warning
    imx_v4_v5_defconfig (gcc-8): 1 warning
    imx_v6_v7_defconfig (gcc-8): 1 warning
    integrator_defconfig (gcc-8): 1 warning
    iop13xx_defconfig (gcc-8): 1 warning
    iop32x_defconfig (gcc-8): 1 warning
    iop33x_defconfig (gcc-8): 1 warning
    ixp4xx_defconfig (gcc-8): 1 warning
    jornada720_defconfig (gcc-8): 1 warning
    keystone_defconfig (gcc-8): 1 warning
    ks8695_defconfig (gcc-8): 1 warning
    kzm9g_defconfig (gcc-8): 8 warnings
    lart_defconfig (gcc-8): 1 warning
    lpd270_defconfig (gcc-8): 1 warning
    lubbock_defconfig (gcc-8): 1 warning
    mackerel_defconfig (gcc-8): 7 warnings
    magician_defconfig (gcc-8): 1 warning
    mainstone_defconfig (gcc-8): 1 warning
    marzen_defconfig (gcc-8): 1 warning
    mini2440_defconfig (gcc-8): 1 warning
    mmp2_defconfig (gcc-8): 1 warning
    moxart_defconfig (gcc-8): 1 warning
    msm_defconfig (gcc-8): 1 warning
    multi_v5_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 2 warnings
    mv78xx0_defconfig (gcc-8): 1 warning
    mvebu_v5_defconfig (gcc-8): 1 warning
    mvebu_v7_defconfig (gcc-8): 1 warning
    mxs_defconfig (gcc-8): 1 warning
    neponset_defconfig (gcc-8): 1 warning
    netwinder_defconfig (gcc-8): 1 warning
    netx_defconfig (gcc-8): 1 warning
    nhk8815_defconfig (gcc-8): 1 warning
    omap1_defconfig (gcc-8): 1 warning
    omap2plus_defconfig (gcc-8): 1 warning
    orion5x_defconfig (gcc-8): 1 warning
    palmz72_defconfig (gcc-8): 1 warning
    pcm027_defconfig (gcc-8): 1 warning
    pleb_defconfig (gcc-8): 1 warning
    pxa168_defconfig (gcc-8): 1 warning
    pxa255-idp_defconfig (gcc-8): 1 warning
    pxa3xx_defconfig (gcc-8): 1 warning
    pxa910_defconfig (gcc-8): 1 warning
    qcom_defconfig (gcc-8): 1 warning
    raumfeld_defconfig (gcc-8): 1 warning
    realview-smp_defconfig (gcc-8): 1 warning
    realview_defconfig (gcc-8): 1 warning
    rpc_defconfig (gcc-8): 1 warning
    s3c2410_defconfig (gcc-8): 1 warning
    sama5_defconfig (gcc-8): 1 warning
    shannon_defconfig (gcc-8): 1 warning
    simpad_defconfig (gcc-8): 1 warning
    socfpga_defconfig (gcc-8): 1 warning
    spear13xx_defconfig (gcc-8): 1 warning
    spear3xx_defconfig (gcc-8): 1 warning
    spear6xx_defconfig (gcc-8): 1 warning
    spitz_defconfig (gcc-8): 1 warning
    sunxi_defconfig (gcc-8): 1 warning
    tct_hammer_defconfig (gcc-8): 1 warning
    tegra_defconfig (gcc-8): 1 warning
    trizeps4_defconfig (gcc-8): 1 warning
    u8500_defconfig (gcc-8): 1 warning
    versatile_defconfig (gcc-8): 1 warning
    vexpress_defconfig (gcc-8): 1 warning
    viper_defconfig (gcc-8): 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 1 warning
    xcep_defconfig (gcc-8): 1 warning
    zeus_defconfig (gcc-8): 1 warning

i386:
    allnoconfig (gcc-8): 3 warnings
    i386_defconfig (gcc-8): 3 warnings
    tinyconfig (gcc-8): 3 warnings

mips:
    allnoconfig (gcc-8): 27 warnings
    ar7_defconfig (gcc-8): 27 warnings
    ath79_defconfig (gcc-8): 27 warnings
    bcm47xx_defconfig (gcc-8): 27 warnings
    bcm63xx_defconfig (gcc-8): 27 warnings
    bigsur_defconfig (gcc-8): 16 errors, 5 warnings
    capcella_defconfig (gcc-8): 27 warnings
    cavium_octeon_defconfig (gcc-8): 27 warnings
    cobalt_defconfig (gcc-8): 27 warnings
    db1xxx_defconfig (gcc-8): 27 warnings
    decstation_defconfig (gcc-8): 27 warnings
    e55_defconfig (gcc-8): 27 warnings
    fuloong2e_defconfig (gcc-8): 27 warnings
    gpr_defconfig (gcc-8): 27 warnings
    ip22_defconfig (gcc-8): 27 warnings
    ip27_defconfig (gcc-8): 27 warnings
    ip28_defconfig (gcc-8): 27 warnings
    ip32_defconfig (gcc-8): 27 warnings
    jazz_defconfig (gcc-8): 27 warnings
    jmr3927_defconfig (gcc-8): 27 warnings
    lasat_defconfig (gcc-8): 27 warnings
    lemote2f_defconfig (gcc-8): 27 warnings
    loongson3_defconfig (gcc-8): 27 warnings
    ls1b_defconfig (gcc-8): 27 warnings
    malta_defconfig (gcc-8): 27 warnings
    malta_kvm_defconfig (gcc-8): 27 warnings
    malta_kvm_guest_defconfig (gcc-8): 27 warnings
    maltaaprp_defconfig (gcc-8): 27 warnings
    maltasmvp_defconfig (gcc-8): 27 warnings
    maltasmvp_eva_defconfig (gcc-8): 27 warnings
    maltaup_defconfig (gcc-8): 27 warnings
    markeins_defconfig (gcc-8): 27 warnings
    mips_paravirt_defconfig (gcc-8): 27 warnings
    mpc30x_defconfig (gcc-8): 27 warnings
    msp71xx_defconfig (gcc-8): 27 warnings
    mtx1_defconfig (gcc-8): 27 warnings
    nlm_xlp_defconfig (gcc-8): 27 warnings
    nlm_xlr_defconfig (gcc-8): 1 error, 1 warning
    pnx8335_stb225_defconfig (gcc-8): 27 warnings
    qi_lb60_defconfig (gcc-8): 27 warnings
    rb532_defconfig (gcc-8): 27 warnings
    rbtx49xx_defconfig (gcc-8): 27 warnings
    rm200_defconfig (gcc-8): 27 warnings
    rt305x_defconfig (gcc-8): 27 warnings
    sb1250_swarm_defconfig (gcc-8): 16 errors, 5 warnings
    sead3_defconfig (gcc-8): 27 warnings
    sead3micro_defconfig (gcc-8): 2 errors
    tb0219_defconfig (gcc-8): 27 warnings
    tb0226_defconfig (gcc-8): 27 warnings
    tb0287_defconfig (gcc-8): 27 warnings
    tinyconfig (gcc-8): 27 warnings
    workpad_defconfig (gcc-8): 27 warnings
    xway_defconfig (gcc-8): 27 warnings

x86_64:
    allnoconfig (gcc-8): 215 warnings
    tinyconfig (gcc-8): 215 warnings
    x86_64_defconfig (gcc-8): 482 warnings

Errors summary:

    3    arch/arc/include/asm/uaccess.h:676:2: error: impossible constraint=
 in 'asm'
    2    include/linux/swiotlb.h:96:21: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:92:26: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:87:27: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:83:13: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:79:9: error: 'enum dma_data_direction' dec=
lared inside parameter list will not be visible outside of this definition =
or declaration [-Werror]
    2    include/linux/swiotlb.h:75:14: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:70:29: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:67:13: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:65:63: error: 'struct page' declared insid=
e parameter list will not be visible outside of this definition or declarat=
ion [-Werror]
    2    include/linux/swiotlb.h:53:27: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:49:28: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:45:13: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:113:20: error: expected '=3D', ',', ';', '=
asm' or '__attribute__' before 'swiotlb_free'
    2    include/linux/swiotlb.h:104:24: error: 'enum dma_data_direction' d=
eclared inside parameter list will not be visible outside of this definitio=
n or declaration [-Werror]
    2    include/linux/swiotlb.h:100:29: error: 'enum dma_data_direction' d=
eclared inside parameter list will not be visible outside of this definitio=
n or declaration [-Werror]
    2    arch/mips/sibyte/common/dma.c:11:13: error: expected '=3D', ',', '=
;', 'asm' or '__attribute__' before 'plat_swiotlb_setup'
    2    arch/arc/mm/tlbex.S:348: Error: unknown opcode 'lsl'
    2    arch/arc/mm/tlbex.S:291: Error: unknown opcode 'lsl'
    1    arch/mips/kernel/genex.S:234: Error: branch to a symbol in another=
 ISA mode
    1    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another=
 ISA mode
    1    arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise co=
mparison always evaluates to false [-Werror=3Dtautological-compare]

Warnings summary:

    1029  arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean exp=
ression [-Wbool-operation]
    294  arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expr=
ession [-Wbool-operation]
    269  arc-linux-gcc: warning: '-mno-mpy' is deprecated
    254  cc1: warning: '-mno-mpy' is deprecated
    104  net/socket.c:490:4: warning: 'strncpy' specified bound depends on =
the length of the source argument [-Wstringop-overflow=3D]
    14   include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) =
/ sizeof (void)' does not compute the number of array elements [-Wsizeof-po=
inter-div]
    8    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOT=
LB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (C=
AVIUM_OCTEON_SOC || MACH_LOONGSON && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_=
XLR_BOARD)
    4    include/linux/syscalls.h:195:18: warning: 'sys_close' alias betwee=
n functions of incompatible types 'long int(unsigned int)' and 'long int(lo=
ng int)' [-Wattribute-alias]
    3    mm/memory.c:581:7: warning: assignment to 'pgtable_t' {aka 'long u=
nsigned int'} from 'void *' makes integer from pointer without a cast [-Win=
t-conversion]
    3    lib/string_helpers.c:64:33: warning: '%03lld' directive output may=
 be truncated writing between 3 and 13 bytes into a region of size 7 [-Wfor=
mat-truncation=3D]
    3    kernel/workqueue.c:1720:40: warning: '%d' directive output may be =
truncated writing between 1 and 10 bytes into a region of size between 5 an=
d 14 [-Wformat-truncation=3D]
    3    include/linux/syscalls.h:195:18: warning: 'sys_writev' alias betwe=
en functions of incompatible types 'long int(long unsigned int,  const stru=
ct iovec *, long unsigned int)' and 'long int(long int,  long int,  long in=
t)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_write' alias betwee=
n functions of incompatible types 'long int(unsigned int,  const char *, si=
ze_t)' {aka 'long int(unsigned int,  const char *, long unsigned int)'} and=
 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_waitpid' alias betw=
een functions of incompatible types 'long int(pid_t,  int *, int)' {aka 'lo=
ng int(int,  int *, int)'} and 'long int(long int,  long int,  long int)' [=
-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_waitid' alias betwe=
en functions of incompatible types 'long int(int,  pid_t,  struct siginfo *=
, int,  struct rusage *)' {aka 'long int(int,  int,  struct siginfo *, int,=
  struct rusage *)'} and 'long int(long int,  long int,  long int,  long in=
t,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_wait4' alias betwee=
n functions of incompatible types 'long int(pid_t,  int *, int,  struct rus=
age *)' {aka 'long int(int,  int *, int,  struct rusage *)'} and 'long int(=
long int,  long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_vmsplice' alias bet=
ween functions of incompatible types 'long int(int,  const struct iovec *, =
long unsigned int,  unsigned int)' and 'long int(long int,  long int,  long=
 int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_utimes' alias betwe=
en functions of incompatible types 'long int(char *, struct timeval *)' and=
 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_utimensat' alias be=
tween functions of incompatible types 'long int(int,  const char *, struct =
timespec *, int)' and 'long int(long int,  long int,  long int,  long int)'=
 [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_utime' alias betwee=
n functions of incompatible types 'long int(char *, struct utimbuf *)' and =
'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_ustat' alias betwee=
n functions of incompatible types 'long int(unsigned int,  struct ustat *)'=
 and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_unshare' alias betw=
een functions of incompatible types 'long int(long unsigned int)' and 'long=
 int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_unlinkat' alias bet=
ween functions of incompatible types 'long int(int,  const char *, int)' an=
d 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_unlink' alias betwe=
en functions of incompatible types 'long int(const char *)' and 'long int(l=
ong int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_uname' alias betwee=
n functions of incompatible types 'long int(struct old_utsname *)' and 'lon=
g int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_umount' alias betwe=
en functions of incompatible types 'long int(char *, int)' and 'long int(lo=
ng int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_umask' alias betwee=
n functions of incompatible types 'long int(int)' and 'long int(long int)' =
[-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_truncate' alias bet=
ween functions of incompatible types 'long int(const char *, long int)' and=
 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_tkill' alias betwee=
n functions of incompatible types 'long int(pid_t,  int)' {aka 'long int(in=
t,  int)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_times' alias betwee=
n functions of incompatible types 'long int(struct tms *)' and 'long int(lo=
ng int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_timer_settime' alia=
s between functions of incompatible types 'long int(timer_t,  int,  const s=
truct itimerspec *, struct itimerspec *)' {aka 'long int(int,  int,  const =
struct itimerspec *, struct itimerspec *)'} and 'long int(long int,  long i=
nt,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_timer_gettime' alia=
s between functions of incompatible types 'long int(timer_t,  struct itimer=
spec *)' {aka 'long int(int,  struct itimerspec *)'} and 'long int(long int=
,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_timer_getoverrun' a=
lias between functions of incompatible types 'long int(timer_t)' {aka 'long=
 int(int)'} and 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_timer_delete' alias=
 between functions of incompatible types 'long int(timer_t)' {aka 'long int=
(int)'} and 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_timer_create' alias=
 between functions of incompatible types 'long int(const clockid_t,  struct=
 sigevent *, timer_t *)' {aka 'long int(const int,  struct sigevent *, int =
*)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_time' alias between=
 functions of incompatible types 'long int(time_t *)' {aka 'long int(long i=
nt *)'} and 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_tgkill' alias betwe=
en functions of incompatible types 'long int(pid_t,  pid_t,  int)' {aka 'lo=
ng int(int,  int,  int)'} and 'long int(long int,  long int,  long int)' [-=
Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_tee' alias between =
functions of incompatible types 'long int(int,  int,  size_t,  unsigned int=
)' {aka 'long int(int,  int,  long unsigned int,  unsigned int)'} and 'long=
 int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sysinfo' alias betw=
een functions of incompatible types 'long int(struct sysinfo *)' and 'long =
int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sysctl' alias betwe=
en functions of incompatible types 'long int(struct __sysctl_args *)' and '=
long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_syncfs' alias betwe=
en functions of incompatible types 'long int(int)' and 'long int(long int)'=
 [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sync_file_range2' a=
lias between functions of incompatible types 'long int(int,  unsigned int, =
 loff_t,  loff_t)' {aka 'long int(int,  unsigned int,  long long int,  long=
 long int)'} and 'long int(long int,  long int,  long long int,  long long =
int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sync_file_range' al=
ias between functions of incompatible types 'long int(int,  loff_t,  loff_t=
,  unsigned int)' {aka 'long int(int,  long long int,  long long int,  unsi=
gned int)'} and 'long int(long int,  long long int,  long long int,  long i=
nt)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_symlinkat' alias be=
tween functions of incompatible types 'long int(const char *, int,  const c=
har *)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_symlink' alias betw=
een functions of incompatible types 'long int(const char *, const char *)' =
and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_stime' alias betwee=
n functions of incompatible types 'long int(time_t *)' {aka 'long int(long =
int *)'} and 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_statfs64' alias bet=
ween functions of incompatible types 'long int(const char *, size_t,  struc=
t statfs64 *)' {aka 'long int(const char *, long unsigned int,  struct stat=
fs64 *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_statfs' alias betwe=
en functions of incompatible types 'long int(const char *, struct statfs *)=
' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_stat' alias between=
 functions of incompatible types 'long int(const char *, struct __old_kerne=
l_stat *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_splice' alias betwe=
en functions of incompatible types 'long int(int,  loff_t *, int,  loff_t *=
, size_t,  unsigned int)' {aka 'long int(int,  long long int *, int,  long =
long int *, long unsigned int,  unsigned int)'} and 'long int(long int,  lo=
ng int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sigprocmask' alias =
between functions of incompatible types 'long int(int,  old_sigset_t *, old=
_sigset_t *)' {aka 'long int(int,  long unsigned int *, long unsigned int *=
)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sigpending' alias b=
etween functions of incompatible types 'long int(old_sigset_t *)' {aka 'lon=
g int(long unsigned int *)'} and 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_signal' alias betwe=
en functions of incompatible types 'long int(int,  void (*)(int))' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sigaltstack' alias =
between functions of incompatible types 'long int(const stack_t *, stack_t =
*)' {aka 'long int(const struct sigaltstack *, struct sigaltstack *)'} and =
'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setxattr' alias bet=
ween functions of incompatible types 'long int(const char *, const char *, =
const void *, size_t,  int)' {aka 'long int(const char *, const char *, con=
st void *, long unsigned int,  int)'} and 'long int(long int,  long int,  l=
ong int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setuid' alias betwe=
en functions of incompatible types 'long int(uid_t)' {aka 'long int(unsigne=
d int)'} and 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_settimeofday' alias=
 between functions of incompatible types 'long int(struct timeval *, struct=
 timezone *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setrlimit' alias be=
tween functions of incompatible types 'long int(unsigned int,  struct rlimi=
t *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setreuid' alias bet=
ween functions of incompatible types 'long int(uid_t,  uid_t)' {aka 'long i=
nt(unsigned int,  unsigned int)'} and 'long int(long int,  long int)' [-Wat=
tribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setresuid' alias be=
tween functions of incompatible types 'long int(uid_t,  uid_t,  uid_t)' {ak=
a 'long int(unsigned int,  unsigned int,  unsigned int)'} and 'long int(lon=
g int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setresgid' alias be=
tween functions of incompatible types 'long int(gid_t,  gid_t,  gid_t)' {ak=
a 'long int(unsigned int,  unsigned int,  unsigned int)'} and 'long int(lon=
g int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setregid' alias bet=
ween functions of incompatible types 'long int(gid_t,  gid_t)' {aka 'long i=
nt(unsigned int,  unsigned int)'} and 'long int(long int,  long int)' [-Wat=
tribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setpriority' alias =
between functions of incompatible types 'long int(int,  int,  int)' and 'lo=
ng int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setpgid' alias betw=
een functions of incompatible types 'long int(pid_t,  pid_t)' {aka 'long in=
t(int,  int)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setns' alias betwee=
n functions of incompatible types 'long int(int,  int)' and 'long int(long =
int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setitimer' alias be=
tween functions of incompatible types 'long int(int,  struct itimerval *, s=
truct itimerval *)' and 'long int(long int,  long int,  long int)' [-Wattri=
bute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sethostname' alias =
between functions of incompatible types 'long int(char *, int)' and 'long i=
nt(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setgroups' alias be=
tween functions of incompatible types 'long int(int,  gid_t *)' {aka 'long =
int(int,  unsigned int *)'} and 'long int(long int,  long int)' [-Wattribut=
e-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setgid' alias betwe=
en functions of incompatible types 'long int(gid_t)' {aka 'long int(unsigne=
d int)'} and 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setfsuid' alias bet=
ween functions of incompatible types 'long int(uid_t)' {aka 'long int(unsig=
ned int)'} and 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setfsgid' alias bet=
ween functions of incompatible types 'long int(gid_t)' {aka 'long int(unsig=
ned int)'} and 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_setdomainname' alia=
s between functions of incompatible types 'long int(char *, int)' and 'long=
 int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_set_tid_address' al=
ias between functions of incompatible types 'long int(int *)' and 'long int=
(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sendfile64' alias b=
etween functions of incompatible types 'long int(int,  int,  loff_t *, size=
_t)' {aka 'long int(int,  int,  long long int *, long unsigned int)'} and '=
long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sendfile' alias bet=
ween functions of incompatible types 'long int(int,  int,  off_t *, size_t)=
' {aka 'long int(int,  int,  long int *, long unsigned int)'} and 'long int=
(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_select' alias betwe=
en functions of incompatible types 'long int(int,  fd_set *, fd_set *, fd_s=
et *, struct timeval *)' {aka 'long int(int,  struct <anonymous> *, struct =
<anonymous> *, struct <anonymous> *, struct timeval *)'} and 'long int(long=
 int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sched_setscheduler'=
 alias between functions of incompatible types 'long int(pid_t,  int,  stru=
ct sched_param *)' {aka 'long int(int,  int,  struct sched_param *)'} and '=
long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sched_setparam' ali=
as between functions of incompatible types 'long int(pid_t,  struct sched_p=
aram *)' {aka 'long int(int,  struct sched_param *)'} and 'long int(long in=
t,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sched_setattr' alia=
s between functions of incompatible types 'long int(pid_t,  struct sched_at=
tr *, unsigned int)' {aka 'long int(int,  struct sched_attr *, unsigned int=
)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sched_setaffinity' =
alias between functions of incompatible types 'long int(pid_t,  unsigned in=
t,  long unsigned int *)' {aka 'long int(int,  unsigned int,  long unsigned=
 int *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sched_rr_get_interv=
al' alias between functions of incompatible types 'long int(pid_t,  struct =
timespec *)' {aka 'long int(int,  struct timespec *)'} and 'long int(long i=
nt,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sched_getscheduler'=
 alias between functions of incompatible types 'long int(pid_t)' {aka 'long=
 int(int)'} and 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sched_getparam' ali=
as between functions of incompatible types 'long int(pid_t,  struct sched_p=
aram *)' {aka 'long int(int,  struct sched_param *)'} and 'long int(long in=
t,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sched_getattr' alia=
s between functions of incompatible types 'long int(pid_t,  struct sched_at=
tr *, unsigned int,  unsigned int)' {aka 'long int(int,  struct sched_attr =
*, unsigned int,  unsigned int)'} and 'long int(long int,  long int,  long =
int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sched_getaffinity' =
alias between functions of incompatible types 'long int(pid_t,  unsigned in=
t,  long unsigned int *)' {aka 'long int(int,  unsigned int,  long unsigned=
 int *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sched_get_priority_=
min' alias between functions of incompatible types 'long int(int)' and 'lon=
g int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_sched_get_priority_=
max' alias between functions of incompatible types 'long int(int)' and 'lon=
g int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_rt_tgsigqueueinfo' =
alias between functions of incompatible types 'long int(pid_t,  pid_t,  int=
,  siginfo_t *)' {aka 'long int(int,  int,  int,  struct siginfo *)'} and '=
long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigtimedwait' al=
ias between functions of incompatible types 'long int(const sigset_t *, sig=
info_t *, const struct timespec *, size_t)' {aka 'long int(const struct <an=
onymous> *, struct siginfo *, const struct timespec *, long unsigned int)'}=
 and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-ali=
as]
    3    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigsuspend' alia=
s between functions of incompatible types 'long int(sigset_t *, size_t)' {a=
ka 'long int(struct <anonymous> *, long unsigned int)'} and 'long int(long =
int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigqueueinfo' al=
ias between functions of incompatible types 'long int(pid_t,  int,  siginfo=
_t *)' {aka 'long int(int,  int,  struct siginfo *)'} and 'long int(long in=
t,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigprocmask' ali=
as between functions of incompatible types 'long int(int,  sigset_t *, sigs=
et_t *, size_t)' {aka 'long int(int,  struct <anonymous> *, struct <anonymo=
us> *, long unsigned int)'} and 'long int(long int,  long int,  long int,  =
long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigpending' alia=
s between functions of incompatible types 'long int(sigset_t *, size_t)' {a=
ka 'long int(struct <anonymous> *, long unsigned int)'} and 'long int(long =
int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigaction' alias=
 between functions of incompatible types 'long int(int,  const struct sigac=
tion *, struct sigaction *, size_t)' {aka 'long int(int,  const struct siga=
ction *, struct sigaction *, long unsigned int)'} and 'long int(long int,  =
long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_rmdir' alias betwee=
n functions of incompatible types 'long int(const char *)' and 'long int(lo=
ng int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_renameat2' alias be=
tween functions of incompatible types 'long int(int,  const char *, int,  c=
onst char *, unsigned int)' and 'long int(long int,  long int,  long int,  =
long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_renameat' alias bet=
ween functions of incompatible types 'long int(int,  const char *, int,  co=
nst char *)' and 'long int(long int,  long int,  long int,  long int)' [-Wa=
ttribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_rename' alias betwe=
en functions of incompatible types 'long int(const char *, const char *)' a=
nd 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_removexattr' alias =
between functions of incompatible types 'long int(const char *, const char =
*)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_remap_file_pages' a=
lias between functions of incompatible types 'long int(long unsigned int,  =
long unsigned int,  long unsigned int,  long unsigned int,  long unsigned i=
nt)' and 'long int(long int,  long int,  long int,  long int,  long int)' [=
-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_reboot' alias betwe=
en functions of incompatible types 'long int(int,  int,  unsigned int,  voi=
d *)' and 'long int(long int,  long int,  long int,  long int)' [-Wattribut=
e-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_readv' alias betwee=
n functions of incompatible types 'long int(long unsigned int,  const struc=
t iovec *, long unsigned int)' and 'long int(long int,  long int,  long int=
)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_readlinkat' alias b=
etween functions of incompatible types 'long int(int,  const char *, char *=
, int)' and 'long int(long int,  long int,  long int,  long int)' [-Wattrib=
ute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_readlink' alias bet=
ween functions of incompatible types 'long int(const char *, char *, int)' =
and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_readahead' alias be=
tween functions of incompatible types 'long int(int,  loff_t,  size_t)' {ak=
a 'long int(int,  long long int,  long unsigned int)'} and 'long int(long i=
nt,  long long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_read' alias between=
 functions of incompatible types 'long int(unsigned int,  char *, size_t)' =
{aka 'long int(unsigned int,  char *, long unsigned int)'} and 'long int(lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_pwritev' alias betw=
een functions of incompatible types 'long int(long unsigned int,  const str=
uct iovec *, long unsigned int,  long unsigned int,  long unsigned int)' an=
d 'long int(long int,  long int,  long int,  long int,  long int)' [-Wattri=
bute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_pwrite64' alias bet=
ween functions of incompatible types 'long int(unsigned int,  const char *,=
 size_t,  loff_t)' {aka 'long int(unsigned int,  const char *, long unsigne=
d int,  long long int)'} and 'long int(long int,  long int,  long int,  lon=
g long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_ptrace' alias betwe=
en functions of incompatible types 'long int(long int,  long int,  long uns=
igned int,  long unsigned int)' and 'long int(long int,  long int,  long in=
t,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_pselect6' alias bet=
ween functions of incompatible types 'long int(int,  fd_set *, fd_set *, fd=
_set *, struct timespec *, void *)' {aka 'long int(int,  struct <anonymous>=
 *, struct <anonymous> *, struct <anonymous> *, struct timespec *, void *)'=
} and 'long int(long int,  long int,  long int,  long int,  long int,  long=
 int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_prlimit64' alias be=
tween functions of incompatible types 'long int(pid_t,  unsigned int,  cons=
t struct rlimit64 *, struct rlimit64 *)' {aka 'long int(int,  unsigned int,=
  const struct rlimit64 *, struct rlimit64 *)'} and 'long int(long int,  lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_preadv' alias betwe=
en functions of incompatible types 'long int(long unsigned int,  const stru=
ct iovec *, long unsigned int,  long unsigned int,  long unsigned int)' and=
 'long int(long int,  long int,  long int,  long int,  long int)' [-Wattrib=
ute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_pread64' alias betw=
een functions of incompatible types 'long int(unsigned int,  char *, size_t=
,  loff_t)' {aka 'long int(unsigned int,  char *, long unsigned int,  long =
long int)'} and 'long int(long int,  long int,  long int,  long long int)' =
[-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_prctl' alias betwee=
n functions of incompatible types 'long int(int,  long unsigned int,  long =
unsigned int,  long unsigned int,  long unsigned int)' and 'long int(long i=
nt,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_ppoll' alias betwee=
n functions of incompatible types 'long int(struct pollfd *, unsigned int, =
 struct timespec *, const sigset_t *, size_t)' {aka 'long int(struct pollfd=
 *, unsigned int,  struct timespec *, const struct <anonymous> *, long unsi=
gned int)'} and 'long int(long int,  long int,  long int,  long int,  long =
int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_poll' alias between=
 functions of incompatible types 'long int(struct pollfd *, unsigned int,  =
int)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_pivot_root' alias b=
etween functions of incompatible types 'long int(const char *, const char *=
)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_pipe2' alias betwee=
n functions of incompatible types 'long int(int *, int)' and 'long int(long=
 int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_pipe' alias between=
 functions of incompatible types 'long int(int *)' and 'long int(long int)'=
 [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_personality' alias =
between functions of incompatible types 'long int(unsigned int)' and 'long =
int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_perf_event_open' al=
ias between functions of incompatible types 'long int(struct perf_event_att=
r *, pid_t,  int,  int,  long unsigned int)' {aka 'long int(struct perf_eve=
nt_attr *, int,  int,  int,  long unsigned int)'} and 'long int(long int,  =
long int,  long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_openat' alias betwe=
en functions of incompatible types 'long int(int,  const char *, int,  umod=
e_t)' {aka 'long int(int,  const char *, int,  short unsigned int)'} and 'l=
ong int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_open' alias between=
 functions of incompatible types 'long int(const char *, int,  umode_t)' {a=
ka 'long int(const char *, int,  short unsigned int)'} and 'long int(long i=
nt,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_olduname' alias bet=
ween functions of incompatible types 'long int(struct oldold_utsname *)' an=
d 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_oldumount' alias be=
tween functions of incompatible types 'long int(char *)' and 'long int(long=
 int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_old_readdir' alias =
between functions of incompatible types 'long int(unsigned int,  struct old=
_linux_dirent *, unsigned int)' and 'long int(long int,  long int,  long in=
t)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_old_getrlimit' alia=
s between functions of incompatible types 'long int(unsigned int,  struct r=
limit *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_nice' alias between=
 functions of incompatible types 'long int(int)' and 'long int(long int)' [=
-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_newuname' alias bet=
ween functions of incompatible types 'long int(struct new_utsname *)' and '=
long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_newstat' alias betw=
een functions of incompatible types 'long int(const char *, struct stat *)'=
 and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_newlstat' alias bet=
ween functions of incompatible types 'long int(const char *, struct stat *)=
' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_newfstatat' alias b=
etween functions of incompatible types 'long int(int,  const char *, struct=
 stat *, int)' and 'long int(long int,  long int,  long int,  long int)' [-=
Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_newfstat' alias bet=
ween functions of incompatible types 'long int(unsigned int,  struct stat *=
)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_nanosleep' alias be=
tween functions of incompatible types 'long int(struct timespec *, struct t=
imespec *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_munmap' alias betwe=
en functions of incompatible types 'long int(long unsigned int,  size_t)' {=
aka 'long int(long unsigned int,  long unsigned int)'} and 'long int(long i=
nt,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_munlock' alias betw=
een functions of incompatible types 'long int(long unsigned int,  size_t)' =
{aka 'long int(long unsigned int,  long unsigned int)'} and 'long int(long =
int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_msync' alias betwee=
n functions of incompatible types 'long int(long unsigned int,  size_t,  in=
t)' {aka 'long int(long unsigned int,  long unsigned int,  int)'} and 'long=
 int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_mremap' alias betwe=
en functions of incompatible types 'long int(long unsigned int,  long unsig=
ned int,  long unsigned int,  long unsigned int,  long unsigned int)' and '=
long int(long int,  long int,  long int,  long int,  long int)' [-Wattribut=
e-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_mprotect' alias bet=
ween functions of incompatible types 'long int(long unsigned int,  size_t, =
 long unsigned int)' {aka 'long int(long unsigned int,  long unsigned int, =
 long unsigned int)'} and 'long int(long int,  long int,  long int)' [-Watt=
ribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_mount' alias betwee=
n functions of incompatible types 'long int(char *, char *, char *, long un=
signed int,  void *)' and 'long int(long int,  long int,  long int,  long i=
nt,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_mmap_pgoff' alias b=
etween functions of incompatible types 'long int(long unsigned int,  long u=
nsigned int,  long unsigned int,  long unsigned int,  long unsigned int,  l=
ong unsigned int)' and 'long int(long int,  long int,  long int,  long int,=
  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_mmap' alias between=
 functions of incompatible types 'long int(long unsigned int,  long unsigne=
d int,  long unsigned int,  long unsigned int,  long unsigned int,  long un=
signed int)' and 'long int(long int,  long int,  long int,  long int,  long=
 int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_mlockall' alias bet=
ween functions of incompatible types 'long int(int)' and 'long int(long int=
)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_mlock' alias betwee=
n functions of incompatible types 'long int(long unsigned int,  size_t)' {a=
ka 'long int(long unsigned int,  long unsigned int)'} and 'long int(long in=
t,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_mknodat' alias betw=
een functions of incompatible types 'long int(int,  const char *, umode_t, =
 unsigned int)' {aka 'long int(int,  const char *, short unsigned int,  uns=
igned int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wa=
ttribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_mknod' alias betwee=
n functions of incompatible types 'long int(const char *, umode_t,  unsigne=
d int)' {aka 'long int(const char *, short unsigned int,  unsigned int)'} a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_mkdirat' alias betw=
een functions of incompatible types 'long int(int,  const char *, umode_t)'=
 {aka 'long int(int,  const char *, short unsigned int)'} and 'long int(lon=
g int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_mkdir' alias betwee=
n functions of incompatible types 'long int(const char *, umode_t)' {aka 'l=
ong int(const char *, short unsigned int)'} and 'long int(long int,  long i=
nt)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_mincore' alias betw=
een functions of incompatible types 'long int(long unsigned int,  size_t,  =
unsigned char *)' {aka 'long int(long unsigned int,  long unsigned int,  un=
signed char *)'} and 'long int(long int,  long int,  long int)' [-Wattribut=
e-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_lstat' alias betwee=
n functions of incompatible types 'long int(const char *, struct __old_kern=
el_stat *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_lsetxattr' alias be=
tween functions of incompatible types 'long int(const char *, const char *,=
 const void *, size_t,  int)' {aka 'long int(const char *, const char *, co=
nst void *, long unsigned int,  int)'} and 'long int(long int,  long int,  =
long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_lseek' alias betwee=
n functions of incompatible types 'long int(unsigned int,  off_t,  unsigned=
 int)' {aka 'long int(unsigned int,  long int,  unsigned int)'} and 'long i=
nt(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_lremovexattr' alias=
 between functions of incompatible types 'long int(const char *, const char=
 *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_llseek' alias betwe=
en functions of incompatible types 'long int(unsigned int,  long unsigned i=
nt,  long unsigned int,  loff_t *, unsigned int)' {aka 'long int(unsigned i=
nt,  long unsigned int,  long unsigned int,  long long int *, unsigned int)=
'} and 'long int(long int,  long int,  long int,  long int,  long int)' [-W=
attribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_llistxattr' alias b=
etween functions of incompatible types 'long int(const char *, char *, size=
_t)' {aka 'long int(const char *, char *, long unsigned int)'} and 'long in=
t(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_listxattr' alias be=
tween functions of incompatible types 'long int(const char *, char *, size_=
t)' {aka 'long int(const char *, char *, long unsigned int)'} and 'long int=
(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_linkat' alias betwe=
en functions of incompatible types 'long int(int,  const char *, int,  cons=
t char *, int)' and 'long int(long int,  long int,  long int,  long int,  l=
ong int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_link' alias between=
 functions of incompatible types 'long int(const char *, const char *)' and=
 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_lgetxattr' alias be=
tween functions of incompatible types 'long int(const char *, const char *,=
 void *, size_t)' {aka 'long int(const char *, const char *, void *, long u=
nsigned int)'} and 'long int(long int,  long int,  long int,  long int)' [-=
Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_lchown' alias betwe=
en functions of incompatible types 'long int(const char *, uid_t,  gid_t)' =
{aka 'long int(const char *, unsigned int,  unsigned int)'} and 'long int(l=
ong int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_kill' alias between=
 functions of incompatible types 'long int(pid_t,  int)' {aka 'long int(int=
,  int)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_iopl' alias between=
 functions of incompatible types 'long int(unsigned int)' and 'long int(lon=
g int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_ioctl' alias betwee=
n functions of incompatible types 'long int(unsigned int,  unsigned int,  l=
ong unsigned int)' and 'long int(long int,  long int,  long int)' [-Wattrib=
ute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getxattr' alias bet=
ween functions of incompatible types 'long int(const char *, const char *, =
void *, size_t)' {aka 'long int(const char *, const char *, void *, long un=
signed int)'} and 'long int(long int,  long int,  long int,  long int)' [-W=
attribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_gettimeofday' alias=
 between functions of incompatible types 'long int(struct timeval *, struct=
 timezone *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getsid' alias betwe=
en functions of incompatible types 'long int(pid_t)' {aka 'long int(int)'} =
and 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getrusage' alias be=
tween functions of incompatible types 'long int(int,  struct rusage *)' and=
 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getrlimit' alias be=
tween functions of incompatible types 'long int(unsigned int,  struct rlimi=
t *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getresuid' alias be=
tween functions of incompatible types 'long int(uid_t *, uid_t *, uid_t *)'=
 {aka 'long int(unsigned int *, unsigned int *, unsigned int *)'} and 'long=
 int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getresgid' alias be=
tween functions of incompatible types 'long int(gid_t *, gid_t *, gid_t *)'=
 {aka 'long int(unsigned int *, unsigned int *, unsigned int *)'} and 'long=
 int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getrandom' alias be=
tween functions of incompatible types 'long int(char *, size_t,  unsigned i=
nt)' {aka 'long int(char *, long unsigned int,  unsigned int)'} and 'long i=
nt(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getpriority' alias =
between functions of incompatible types 'long int(int,  int)' and 'long int=
(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getpgid' alias betw=
een functions of incompatible types 'long int(pid_t)' {aka 'long int(int)'}=
 and 'long int(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getitimer' alias be=
tween functions of incompatible types 'long int(int,  struct itimerval *)' =
and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_gethostname' alias =
between functions of incompatible types 'long int(char *, int)' and 'long i=
nt(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getgroups' alias be=
tween functions of incompatible types 'long int(int,  gid_t *)' {aka 'long =
int(int,  unsigned int *)'} and 'long int(long int,  long int)' [-Wattribut=
e-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getdents64' alias b=
etween functions of incompatible types 'long int(unsigned int,  struct linu=
x_dirent64 *, unsigned int)' and 'long int(long int,  long int,  long int)'=
 [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getdents' alias bet=
ween functions of incompatible types 'long int(unsigned int,  struct linux_=
dirent *, unsigned int)' and 'long int(long int,  long int,  long int)' [-W=
attribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getcwd' alias betwe=
en functions of incompatible types 'long int(char *, long unsigned int)' an=
d 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_getcpu' alias betwe=
en functions of incompatible types 'long int(unsigned int *, unsigned int *=
, struct getcpu_cache *)' and 'long int(long int,  long int,  long int)' [-=
Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_futimesat' alias be=
tween functions of incompatible types 'long int(int,  const char *, struct =
timeval *)' and 'long int(long int,  long int,  long int)' [-Wattribute-ali=
as]
    3    include/linux/syscalls.h:195:18: warning: 'sys_ftruncate' alias be=
tween functions of incompatible types 'long int(unsigned int,  long unsigne=
d int)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fsync' alias betwee=
n functions of incompatible types 'long int(unsigned int)' and 'long int(lo=
ng int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fstatfs64' alias be=
tween functions of incompatible types 'long int(unsigned int,  size_t,  str=
uct statfs64 *)' {aka 'long int(unsigned int,  long unsigned int,  struct s=
tatfs64 *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-al=
ias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fstatfs' alias betw=
een functions of incompatible types 'long int(unsigned int,  struct statfs =
*)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fstat' alias betwee=
n functions of incompatible types 'long int(unsigned int,  struct __old_ker=
nel_stat *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fsetxattr' alias be=
tween functions of incompatible types 'long int(int,  const char *, const v=
oid *, size_t,  int)' {aka 'long int(int,  const char *, const void *, long=
 unsigned int,  int)'} and 'long int(long int,  long int,  long int,  long =
int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fremovexattr' alias=
 between functions of incompatible types 'long int(int,  const char *)' and=
 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_flistxattr' alias b=
etween functions of incompatible types 'long int(int,  char *, size_t)' {ak=
a 'long int(int,  char *, long unsigned int)'} and 'long int(long int,  lon=
g int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fgetxattr' alias be=
tween functions of incompatible types 'long int(int,  const char *, void *,=
 size_t)' {aka 'long int(int,  const char *, void *, long unsigned int)'} a=
nd 'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fdatasync' alias be=
tween functions of incompatible types 'long int(unsigned int)' and 'long in=
t(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fcntl' alias betwee=
n functions of incompatible types 'long int(unsigned int,  unsigned int,  l=
ong unsigned int)' and 'long int(long int,  long int,  long int)' [-Wattrib=
ute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fchownat' alias bet=
ween functions of incompatible types 'long int(int,  const char *, uid_t,  =
gid_t,  int)' {aka 'long int(int,  const char *, unsigned int,  unsigned in=
t,  int)'} and 'long int(long int,  long int,  long int,  long int,  long i=
nt)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fchown' alias betwe=
en functions of incompatible types 'long int(unsigned int,  uid_t,  gid_t)'=
 {aka 'long int(unsigned int,  unsigned int,  unsigned int)'} and 'long int=
(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fchmodat' alias bet=
ween functions of incompatible types 'long int(int,  const char *, umode_t)=
' {aka 'long int(int,  const char *, short unsigned int)'} and 'long int(lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fchmod' alias betwe=
en functions of incompatible types 'long int(unsigned int,  umode_t)' {aka =
'long int(unsigned int,  short unsigned int)'} and 'long int(long int,  lon=
g int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fchdir' alias betwe=
en functions of incompatible types 'long int(unsigned int)' and 'long int(l=
ong int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_fallocate' alias be=
tween functions of incompatible types 'long int(int,  int,  loff_t,  loff_t=
)' {aka 'long int(int,  int,  long long int,  long long int)'} and 'long in=
t(long int,  long int,  long long int,  long long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_faccessat' alias be=
tween functions of incompatible types 'long int(int,  const char *, int)' a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_exit_group' alias b=
etween functions of incompatible types 'long int(int)' and 'long int(long i=
nt)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_exit' alias between=
 functions of incompatible types 'long int(int)' and 'long int(long int)' [=
-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_execve' alias betwe=
en functions of incompatible types 'long int(const char *, const char * con=
st*, const char * const*)' and 'long int(long int,  long int,  long int)' [=
-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_dup3' alias between=
 functions of incompatible types 'long int(unsigned int,  unsigned int,  in=
t)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_dup2' alias between=
 functions of incompatible types 'long int(unsigned int,  unsigned int)' an=
d 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_dup' alias between =
functions of incompatible types 'long int(unsigned int)' and 'long int(long=
 int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_creat' alias betwee=
n functions of incompatible types 'long int(const char *, umode_t)' {aka 'l=
ong int(const char *, short unsigned int)'} and 'long int(long int,  long i=
nt)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_clone' alias betwee=
n functions of incompatible types 'long int(long unsigned int,  long unsign=
ed int,  int *, int *, int)' and 'long int(long int,  long int,  long int, =
 long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_clock_settime' alia=
s between functions of incompatible types 'long int(const clockid_t,  const=
 struct timespec *)' {aka 'long int(const int,  const struct timespec *)'} =
and 'long int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_clock_nanosleep' al=
ias between functions of incompatible types 'long int(const clockid_t,  int=
,  const struct timespec *, struct timespec *)' {aka 'long int(const int,  =
int,  const struct timespec *, struct timespec *)'} and 'long int(long int,=
  long int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_clock_gettime' alia=
s between functions of incompatible types 'long int(const clockid_t,  struc=
t timespec *)' {aka 'long int(const int,  struct timespec *)'} and 'long in=
t(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_clock_getres' alias=
 between functions of incompatible types 'long int(const clockid_t,  struct=
 timespec *)' {aka 'long int(const int,  struct timespec *)'} and 'long int=
(long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_clock_adjtime' alia=
s between functions of incompatible types 'long int(const clockid_t,  struc=
t timex *)' {aka 'long int(const int,  struct timex *)'} and 'long int(long=
 int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_chroot' alias betwe=
en functions of incompatible types 'long int(const char *)' and 'long int(l=
ong int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_chown' alias betwee=
n functions of incompatible types 'long int(const char *, uid_t,  gid_t)' {=
aka 'long int(const char *, unsigned int,  unsigned int)'} and 'long int(lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_chmod' alias betwee=
n functions of incompatible types 'long int(const char *, umode_t)' {aka 'l=
ong int(const char *, short unsigned int)'} and 'long int(long int,  long i=
nt)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_chdir' alias betwee=
n functions of incompatible types 'long int(const char *)' and 'long int(lo=
ng int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_capset' alias betwe=
en functions of incompatible types 'long int(struct __user_cap_header_struc=
t *, struct __user_cap_data_struct * const)' and 'long int(long int,  long =
int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_capget' alias betwe=
en functions of incompatible types 'long int(struct __user_cap_header_struc=
t *, struct __user_cap_data_struct *)' and 'long int(long int,  long int)' =
[-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_brk' alias between =
functions of incompatible types 'long int(long unsigned int)' and 'long int=
(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_alarm' alias betwee=
n functions of incompatible types 'long int(unsigned int)' and 'long int(lo=
ng int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_adjtimex' alias bet=
ween functions of incompatible types 'long int(struct timex *)' and 'long i=
nt(long int)' [-Wattribute-alias]
    3    include/linux/syscalls.h:195:18: warning: 'sys_access' alias betwe=
en functions of incompatible types 'long int(const char *, int)' and 'long =
int(long int,  long int)' [-Wattribute-alias]
    3    include/linux/kernel.h:707:17: warning: comparison of distinct poi=
nter types lacks a cast
    3    cc1: all warnings being treated as errors
    3    arch/x86/vdso/vclock_gettime.c:352:5: warning: 'time' alias betwee=
n functions of incompatible types 'int(time_t *)' {aka 'int(long int *)'} a=
nd 'time_t(time_t *)' {aka 'long int(long int *)'} [-Wattribute-alias]
    3    arch/x86/kernel/head_32.S:679: Warning: ignoring fill value in sec=
tion `.bss..page_aligned'
    3    arch/x86/kernel/head_32.S:677: Warning: ignoring fill value in sec=
tion `.bss..page_aligned'
    3    arch/x86/kernel/head_32.S:672: Warning: ignoring fill value in sec=
tion `.bss..page_aligned'
    2    mm/mmap.c:684:2: warning: 'rb_parent' may be used uninitialized in=
 this function [-Wmaybe-uninitialized]
    2    mm/mmap.c:684:2: warning: 'rb_link' may be used uninitialized in t=
his function [-Wmaybe-uninitialized]
    2    mm/mmap.c:683:2: warning: 'prev' may be used uninitialized in this=
 function [-Wmaybe-uninitialized]
    2    include/linux/ftrace.h:632:36: warning: calling '__builtin_return_=
address' with a nonzero argument is unsafe [-Wframe-address]
    1    net/sunrpc/clnt.c:527:46: warning: '%s' directive output may be tr=
uncated writing up to 107 bytes into a region of size 48 [-Wformat-truncati=
on=3D]
    1    kernel/sched/core.c:2766:1: warning: control reaches end of non-vo=
id function [-Wreturn-type]
    1    kernel/relay.c:423:35: warning: 'snprintf' output may be truncated=
 before the last format character [-Wformat-truncation=3D]
    1    include/linux/syscalls.h:195:18: warning: 'sys_uselib' alias betwe=
en functions of incompatible types 'long int(const char *)' and 'long int(l=
ong int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_timerfd_settime' al=
ias between functions of incompatible types 'long int(int,  int,  const str=
uct itimerspec *, struct itimerspec *)' and 'long int(long int,  long int, =
 long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_timerfd_gettime' al=
ias between functions of incompatible types 'long int(int,  struct itimersp=
ec *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_timerfd_create' ali=
as between functions of incompatible types 'long int(int,  int)' and 'long =
int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_syslog' alias betwe=
en functions of incompatible types 'long int(int,  char *, int)' and 'long =
int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_sysfs' alias betwee=
n functions of incompatible types 'long int(int,  long unsigned int,  long =
unsigned int)' and 'long int(long int,  long int,  long int)' [-Wattribute-=
alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_swapon' alias betwe=
en functions of incompatible types 'long int(const char *, int)' and 'long =
int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_swapoff' alias betw=
een functions of incompatible types 'long int(const char *)' and 'long int(=
long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_ssetmask' alias bet=
ween functions of incompatible types 'long int(int)' and 'long int(long int=
)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_socketpair' alias b=
etween functions of incompatible types 'long int(int,  int,  int,  int *)' =
and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-alia=
s]
    1    include/linux/syscalls.h:195:18: warning: 'sys_socketcall' alias b=
etween functions of incompatible types 'long int(int,  long unsigned int *)=
' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_socket' alias betwe=
en functions of incompatible types 'long int(int,  int,  int)' and 'long in=
t(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_sigsuspend' alias b=
etween functions of incompatible types 'long int(int,  int,  old_sigset_t)'=
 {aka 'long int(int,  int,  long unsigned int)'} and 'long int(long int,  l=
ong int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_signalfd4' alias be=
tween functions of incompatible types 'long int(int,  sigset_t *, size_t,  =
int)' {aka 'long int(int,  struct <anonymous> *, long unsigned int,  int)'}=
 and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-ali=
as]
    1    include/linux/syscalls.h:195:18: warning: 'sys_signalfd' alias bet=
ween functions of incompatible types 'long int(int,  sigset_t *, size_t)' {=
aka 'long int(int,  struct <anonymous> *, long unsigned int)'} and 'long in=
t(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_shutdown' alias bet=
ween functions of incompatible types 'long int(int,  int)' and 'long int(lo=
ng int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_shmget' alias betwe=
en functions of incompatible types 'long int(key_t,  size_t,  int)' {aka 'l=
ong int(int,  long unsigned int,  int)'} and 'long int(long int,  long int,=
  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_shmdt' alias betwee=
n functions of incompatible types 'long int(char *)' and 'long int(long int=
)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_shmctl' alias betwe=
en functions of incompatible types 'long int(int,  int,  struct shmid_ds *)=
' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_shmat' alias betwee=
n functions of incompatible types 'long int(int,  char *, int)' and 'long i=
nt(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_setuid16' alias bet=
ween functions of incompatible types 'long int(old_uid_t)' {aka 'long int(s=
hort unsigned int)'} and 'long int(long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_setsockopt' alias b=
etween functions of incompatible types 'long int(int,  int,  int,  char *, =
int)' and 'long int(long int,  long int,  long int,  long int,  long int)' =
[-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_setreuid16' alias b=
etween functions of incompatible types 'long int(old_uid_t,  old_uid_t)' {a=
ka 'long int(short unsigned int,  short unsigned int)'} and 'long int(long =
int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_setresuid16' alias =
between functions of incompatible types 'long int(old_uid_t,  old_uid_t,  o=
ld_uid_t)' {aka 'long int(short unsigned int,  short unsigned int,  short u=
nsigned int)'} and 'long int(long int,  long int,  long int)' [-Wattribute-=
alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_setresgid16' alias =
between functions of incompatible types 'long int(old_gid_t,  old_gid_t,  o=
ld_gid_t)' {aka 'long int(short unsigned int,  short unsigned int,  short u=
nsigned int)'} and 'long int(long int,  long int,  long int)' [-Wattribute-=
alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_setregid16' alias b=
etween functions of incompatible types 'long int(old_gid_t,  old_gid_t)' {a=
ka 'long int(short unsigned int,  short unsigned int)'} and 'long int(long =
int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_setgroups16' alias =
between functions of incompatible types 'long int(int,  old_gid_t *)' {aka =
'long int(int,  short unsigned int *)'} and 'long int(long int,  long int)'=
 [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_setgid16' alias bet=
ween functions of incompatible types 'long int(old_gid_t)' {aka 'long int(s=
hort unsigned int)'} and 'long int(long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_setfsuid16' alias b=
etween functions of incompatible types 'long int(old_uid_t)' {aka 'long int=
(short unsigned int)'} and 'long int(long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_setfsgid16' alias b=
etween functions of incompatible types 'long int(old_gid_t)' {aka 'long int=
(short unsigned int)'} and 'long int(long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_set_thread_area' al=
ias between functions of incompatible types 'long int(struct user_desc *)' =
and 'long int(long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_set_robust_list' al=
ias between functions of incompatible types 'long int(struct robust_list_he=
ad *, size_t)' {aka 'long int(struct robust_list_head *, long unsigned int)=
'} and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_set_mempolicy' alia=
s between functions of incompatible types 'long int(int,  const long unsign=
ed int *, long unsigned int)' and 'long int(long int,  long int,  long int)=
' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_sendto' alias betwe=
en functions of incompatible types 'long int(int,  void *, size_t,  unsigne=
d int,  struct sockaddr *, int)' {aka 'long int(int,  void *, long unsigned=
 int,  unsigned int,  struct sockaddr *, int)'} and 'long int(long int,  lo=
ng int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_sendmsg' alias betw=
een functions of incompatible types 'long int(int,  struct msghdr *, unsign=
ed int)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_sendmmsg' alias bet=
ween functions of incompatible types 'long int(int,  struct mmsghdr *, unsi=
gned int,  unsigned int)' and 'long int(long int,  long int,  long int,  lo=
ng int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_send' alias between=
 functions of incompatible types 'long int(int,  void *, size_t,  unsigned =
int)' {aka 'long int(int,  void *, long unsigned int,  unsigned int)'} and =
'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_semtimedop' alias b=
etween functions of incompatible types 'long int(int,  struct sembuf *, uns=
igned int,  const struct timespec *)' and 'long int(long int,  long int,  l=
ong int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_semop' alias betwee=
n functions of incompatible types 'long int(int,  struct sembuf *, unsigned=
 int)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_semget' alias betwe=
en functions of incompatible types 'long int(key_t,  int,  int)' {aka 'long=
 int(int,  int,  int)'} and 'long int(long int,  long int,  long int)' [-Wa=
ttribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_semctl' alias betwe=
en functions of incompatible types 'long int(int,  int,  int,  long unsigne=
d int)' and 'long int(long int,  long int,  long int,  long int)' [-Wattrib=
ute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_seccomp' alias betw=
een functions of incompatible types 'long int(unsigned int,  unsigned int, =
 const char *)' and 'long int(long int,  long int,  long int)' [-Wattribute=
-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_request_key' alias =
between functions of incompatible types 'long int(const char *, const char =
*, const char *, key_serial_t)' {aka 'long int(const char *, const char *, =
const char *, int)'} and 'long int(long int,  long int,  long int,  long in=
t)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_recvmsg' alias betw=
een functions of incompatible types 'long int(int,  struct msghdr *, unsign=
ed int)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_recvmmsg' alias bet=
ween functions of incompatible types 'long int(int,  struct mmsghdr *, unsi=
gned int,  unsigned int,  struct timespec *)' and 'long int(long int,  long=
 int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_recvfrom' alias bet=
ween functions of incompatible types 'long int(int,  void *, size_t,  unsig=
ned int,  struct sockaddr *, int *)' {aka 'long int(int,  void *, long unsi=
gned int,  unsigned int,  struct sockaddr *, int *)'} and 'long int(long in=
t,  long int,  long int,  long int,  long int,  long int)' [-Wattribute-ali=
as]
    1    include/linux/syscalls.h:195:18: warning: 'sys_recv' alias between=
 functions of incompatible types 'long int(int,  void *, size_t,  unsigned =
int)' {aka 'long int(int,  void *, long unsigned int,  unsigned int)'} and =
'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_quotactl' alias bet=
ween functions of incompatible types 'long int(unsigned int,  const char *,=
 qid_t,  void *)' {aka 'long int(unsigned int,  const char *, unsigned int,=
  void *)'} and 'long int(long int,  long int,  long int,  long int)' [-Wat=
tribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_process_vm_writev' =
alias between functions of incompatible types 'long int(pid_t,  const struc=
t iovec *, long unsigned int,  const struct iovec *, long unsigned int,  lo=
ng unsigned int)' {aka 'long int(int,  const struct iovec *, long unsigned =
int,  const struct iovec *, long unsigned int,  long unsigned int)'} and 'l=
ong int(long int,  long int,  long int,  long int,  long int,  long int)' [=
-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_process_vm_readv' a=
lias between functions of incompatible types 'long int(pid_t,  const struct=
 iovec *, long unsigned int,  const struct iovec *, long unsigned int,  lon=
g unsigned int)' {aka 'long int(int,  const struct iovec *, long unsigned i=
nt,  const struct iovec *, long unsigned int,  long unsigned int)'} and 'lo=
ng int(long int,  long int,  long int,  long int,  long int,  long int)' [-=
Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_msgsnd' alias betwe=
en functions of incompatible types 'long int(int,  struct msgbuf *, size_t,=
  int)' {aka 'long int(int,  struct msgbuf *, long unsigned int,  int)'} an=
d 'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_msgrcv' alias betwe=
en functions of incompatible types 'long int(int,  struct msgbuf *, size_t,=
  long int,  int)' {aka 'long int(int,  struct msgbuf *, long unsigned int,=
  long int,  int)'} and 'long int(long int,  long int,  long int,  long int=
,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_msgget' alias betwe=
en functions of incompatible types 'long int(key_t,  int)' {aka 'long int(i=
nt,  int)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_msgctl' alias betwe=
en functions of incompatible types 'long int(int,  int,  struct msqid_ds *)=
' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_mq_unlink' alias be=
tween functions of incompatible types 'long int(const char *)' and 'long in=
t(long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_mq_timedsend' alias=
 between functions of incompatible types 'long int(mqd_t,  const char *, si=
ze_t,  unsigned int,  const struct timespec *)' {aka 'long int(int,  const =
char *, long unsigned int,  unsigned int,  const struct timespec *)'} and '=
long int(long int,  long int,  long int,  long int,  long int)' [-Wattribut=
e-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_mq_timedreceive' al=
ias between functions of incompatible types 'long int(mqd_t,  char *, size_=
t,  unsigned int *, const struct timespec *)' {aka 'long int(int,  char *, =
long unsigned int,  unsigned int *, const struct timespec *)'} and 'long in=
t(long int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_mq_open' alias betw=
een functions of incompatible types 'long int(const char *, int,  umode_t, =
 struct mq_attr *)' {aka 'long int(const char *, int,  short unsigned int, =
 struct mq_attr *)'} and 'long int(long int,  long int,  long int,  long in=
t)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_mq_notify' alias be=
tween functions of incompatible types 'long int(mqd_t,  const struct sigeve=
nt *)' {aka 'long int(int,  const struct sigevent *)'} and 'long int(long i=
nt,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_mq_getsetattr' alia=
s between functions of incompatible types 'long int(mqd_t,  const struct mq=
_attr *, struct mq_attr *)' {aka 'long int(int,  const struct mq_attr *, st=
ruct mq_attr *)'} and 'long int(long int,  long int,  long int)' [-Wattribu=
te-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_move_pages' alias b=
etween functions of incompatible types 'long int(pid_t,  long unsigned int,=
  const void **, const int *, int *, int)' {aka 'long int(int,  long unsign=
ed int,  const void **, const int *, int *, int)'} and 'long int(long int, =
 long int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_migrate_pages' alia=
s between functions of incompatible types 'long int(pid_t,  long unsigned i=
nt,  const long unsigned int *, const long unsigned int *)' {aka 'long int(=
int,  long unsigned int,  const long unsigned int *, const long unsigned in=
t *)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattribu=
te-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_memfd_create' alias=
 between functions of incompatible types 'long int(const char *, unsigned i=
nt)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_mbind' alias betwee=
n functions of incompatible types 'long int(long unsigned int,  long unsign=
ed int,  long unsigned int,  const long unsigned int *, long unsigned int, =
 unsigned int)' and 'long int(long int,  long int,  long int,  long int,  l=
ong int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_madvise' alias betw=
een functions of incompatible types 'long int(long unsigned int,  size_t,  =
int)' {aka 'long int(long unsigned int,  long unsigned int,  int)'} and 'lo=
ng int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_lookup_dcookie' ali=
as between functions of incompatible types 'long int(u64,  char *, size_t)'=
 {aka 'long int(long long unsigned int,  char *, long unsigned int)'} and '=
long int(long long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_listen' alias betwe=
en functions of incompatible types 'long int(int,  int)' and 'long int(long=
 int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_lchown16' alias bet=
ween functions of incompatible types 'long int(const char *, old_uid_t,  ol=
d_gid_t)' {aka 'long int(const char *, short unsigned int,  short unsigned =
int)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_keyctl' alias betwe=
en functions of incompatible types 'long int(int,  long unsigned int,  long=
 unsigned int,  long unsigned int,  long unsigned int)' and 'long int(long =
int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_kexec_load' alias b=
etween functions of incompatible types 'long int(long unsigned int,  long u=
nsigned int,  struct kexec_segment *, long unsigned int)' and 'long int(lon=
g int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_ioprio_set' alias b=
etween functions of incompatible types 'long int(int,  int,  int)' and 'lon=
g int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_ioprio_get' alias b=
etween functions of incompatible types 'long int(int,  int)' and 'long int(=
long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_io_submit' alias be=
tween functions of incompatible types 'long int(aio_context_t,  long int,  =
struct iocb **)' {aka 'long int(long unsigned int,  long int,  struct iocb =
**)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_io_setup' alias bet=
ween functions of incompatible types 'long int(unsigned int,  aio_context_t=
 *)' {aka 'long int(unsigned int,  long unsigned int *)'} and 'long int(lon=
g int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_io_getevents' alias=
 between functions of incompatible types 'long int(aio_context_t,  long int=
,  long int,  struct io_event *, struct timespec *)' {aka 'long int(long un=
signed int,  long int,  long int,  struct io_event *, struct timespec *)'} =
and 'long int(long int,  long int,  long int,  long int,  long int)' [-Watt=
ribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_io_destroy' alias b=
etween functions of incompatible types 'long int(aio_context_t)' {aka 'long=
 int(long unsigned int)'} and 'long int(long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_io_cancel' alias be=
tween functions of incompatible types 'long int(aio_context_t,  struct iocb=
 *, struct io_event *)' {aka 'long int(long unsigned int,  struct iocb *, s=
truct io_event *)'} and 'long int(long int,  long int,  long int)' [-Wattri=
bute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_inotify_rm_watch' a=
lias between functions of incompatible types 'long int(int,  __s32)' {aka '=
long int(int,  int)'} and 'long int(long int,  long int)' [-Wattribute-alia=
s]
    1    include/linux/syscalls.h:195:18: warning: 'sys_inotify_init1' alia=
s between functions of incompatible types 'long int(int)' and 'long int(lon=
g int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_inotify_add_watch' =
alias between functions of incompatible types 'long int(int,  const char *,=
 u32)' {aka 'long int(int,  const char *, unsigned int)'} and 'long int(lon=
g int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_init_module' alias =
between functions of incompatible types 'long int(void *, long unsigned int=
,  const char *)' and 'long int(long int,  long int,  long int)' [-Wattribu=
te-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_getsockopt' alias b=
etween functions of incompatible types 'long int(int,  int,  int,  char *, =
int *)' and 'long int(long int,  long int,  long int,  long int,  long int)=
' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_getsockname' alias =
between functions of incompatible types 'long int(int,  struct sockaddr *, =
int *)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_getresuid16' alias =
between functions of incompatible types 'long int(old_uid_t *, old_uid_t *,=
 old_uid_t *)' {aka 'long int(short unsigned int *, short unsigned int *, s=
hort unsigned int *)'} and 'long int(long int,  long int,  long int)' [-Wat=
tribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_getresgid16' alias =
between functions of incompatible types 'long int(old_gid_t *, old_gid_t *,=
 old_gid_t *)' {aka 'long int(short unsigned int *, short unsigned int *, s=
hort unsigned int *)'} and 'long int(long int,  long int,  long int)' [-Wat=
tribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_getpeername' alias =
between functions of incompatible types 'long int(int,  struct sockaddr *, =
int *)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_getgroups16' alias =
between functions of incompatible types 'long int(int,  old_gid_t *)' {aka =
'long int(int,  short unsigned int *)'} and 'long int(long int,  long int)'=
 [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_get_thread_area' al=
ias between functions of incompatible types 'long int(struct user_desc *)' =
and 'long int(long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_get_robust_list' al=
ias between functions of incompatible types 'long int(int,  struct robust_l=
ist_head **, size_t *)' {aka 'long int(int,  struct robust_list_head **, lo=
ng unsigned int *)'} and 'long int(long int,  long int,  long int)' [-Wattr=
ibute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_get_mempolicy' alia=
s between functions of incompatible types 'long int(int *, long unsigned in=
t *, long unsigned int,  long unsigned int,  long unsigned int)' and 'long =
int(long int,  long int,  long int,  long int,  long int)' [-Wattribute-ali=
as]
    1    include/linux/syscalls.h:195:18: warning: 'sys_futex' alias betwee=
n functions of incompatible types 'long int(u32 *, int,  u32,  struct times=
pec *, u32 *, u32)' {aka 'long int(unsigned int *, int,  unsigned int,  str=
uct timespec *, unsigned int *, unsigned int)'} and 'long int(long int,  lo=
ng int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_flock' alias betwee=
n functions of incompatible types 'long int(unsigned int,  unsigned int)' a=
nd 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_finit_module' alias=
 between functions of incompatible types 'long int(int,  const char *, int)=
' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_fchown16' alias bet=
ween functions of incompatible types 'long int(unsigned int,  old_uid_t,  o=
ld_gid_t)' {aka 'long int(unsigned int,  short unsigned int,  short unsigne=
d int)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_fadvise64_64' alias=
 between functions of incompatible types 'long int(int,  loff_t,  loff_t,  =
int)' {aka 'long int(int,  long long int,  long long int,  int)'} and 'long=
 int(long int,  long long int,  long long int,  long int)' [-Wattribute-ali=
as]
    1    include/linux/syscalls.h:195:18: warning: 'sys_fadvise64' alias be=
tween functions of incompatible types 'long int(int,  loff_t,  size_t,  int=
)' {aka 'long int(int,  long long int,  long unsigned int,  int)'} and 'lon=
g int(long int,  long long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_eventfd2' alias bet=
ween functions of incompatible types 'long int(unsigned int,  int)' and 'lo=
ng int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_eventfd' alias betw=
een functions of incompatible types 'long int(unsigned int)' and 'long int(=
long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_epoll_wait' alias b=
etween functions of incompatible types 'long int(int,  struct epoll_event *=
, int,  int)' and 'long int(long int,  long int,  long int,  long int)' [-W=
attribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_epoll_pwait' alias =
between functions of incompatible types 'long int(int,  struct epoll_event =
*, int,  int,  const sigset_t *, size_t)' {aka 'long int(int,  struct epoll=
_event *, int,  int,  const struct <anonymous> *, long unsigned int)'} and =
'long int(long int,  long int,  long int,  long int,  long int,  long int)'=
 [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_epoll_ctl' alias be=
tween functions of incompatible types 'long int(int,  int,  int,  struct ep=
oll_event *)' and 'long int(long int,  long int,  long int,  long int)' [-W=
attribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_epoll_create1' alia=
s between functions of incompatible types 'long int(int)' and 'long int(lon=
g int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_epoll_create' alias=
 between functions of incompatible types 'long int(int)' and 'long int(long=
 int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_delete_module' alia=
s between functions of incompatible types 'long int(const char *, unsigned =
int)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_connect' alias betw=
een functions of incompatible types 'long int(int,  struct sockaddr *, int)=
' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_chown16' alias betw=
een functions of incompatible types 'long int(const char *, old_uid_t,  old=
_gid_t)' {aka 'long int(const char *, short unsigned int,  short unsigned i=
nt)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_bind' alias between=
 functions of incompatible types 'long int(int,  struct sockaddr *, int)' a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_bdflush' alias betw=
een functions of incompatible types 'long int(int,  long int)' and 'long in=
t(long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_add_key' alias betw=
een functions of incompatible types 'long int(const char *, const char *, c=
onst void *, size_t,  key_serial_t)' {aka 'long int(const char *, const cha=
r *, const void *, long unsigned int,  int)'} and 'long int(long int,  long=
 int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_acct' alias between=
 functions of incompatible types 'long int(const char *)' and 'long int(lon=
g int)' [-Wattribute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_accept4' alias betw=
een functions of incompatible types 'long int(int,  struct sockaddr *, int =
*, int)' and 'long int(long int,  long int,  long int,  long int)' [-Wattri=
bute-alias]
    1    include/linux/syscalls.h:195:18: warning: 'sys_accept' alias betwe=
en functions of incompatible types 'long int(int,  struct sockaddr *, int *=
)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_writev' alias b=
etween functions of incompatible types 'long int(compat_ulong_t,  const str=
uct compat_iovec *, compat_ulong_t)' {aka 'long int(unsigned int,  const st=
ruct compat_iovec *, unsigned int)'} and 'long int(long int,  long int,  lo=
ng int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_waitid' alias b=
etween functions of incompatible types 'long int(int,  compat_pid_t,  struc=
t compat_siginfo *, int,  struct compat_rusage *)' {aka 'long int(int,  int=
,  struct compat_siginfo *, int,  struct compat_rusage *)'} and 'long int(l=
ong int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_wait4' alias be=
tween functions of incompatible types 'long int(compat_pid_t,  compat_uint_=
t *, int,  struct compat_rusage *)' {aka 'long int(int,  unsigned int *, in=
t,  struct compat_rusage *)'} and 'long int(long int,  long int,  long int,=
  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_vmsplice' alias=
 between functions of incompatible types 'long int(int,  const struct compa=
t_iovec *, unsigned int,  unsigned int)' and 'long int(long int,  long int,=
  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_utimes' alias b=
etween functions of incompatible types 'long int(const char *, struct compa=
t_timeval *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_utimensat' alia=
s between functions of incompatible types 'long int(unsigned int,  const ch=
ar *, struct compat_timespec *, int)' and 'long int(long int,  long int,  l=
ong int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_utime' alias be=
tween functions of incompatible types 'long int(const char *, struct compat=
_utimbuf *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_ustat' alias be=
tween functions of incompatible types 'long int(unsigned int,  struct compa=
t_ustat *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_truncate' alias=
 between functions of incompatible types 'long int(const char *, compat_off=
_t)' {aka 'long int(const char *, int)'} and 'long int(long int,  long int)=
' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_times' alias be=
tween functions of incompatible types 'long int(struct compat_tms *)' and '=
long int(long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_timerfd_settime=
' alias between functions of incompatible types 'long int(int,  int,  const=
 struct compat_itimerspec *, struct compat_itimerspec *)' and 'long int(lon=
g int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_timerfd_gettime=
' alias between functions of incompatible types 'long int(int,  struct comp=
at_itimerspec *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_timer_settime' =
alias between functions of incompatible types 'long int(timer_t,  int,  str=
uct compat_itimerspec *, struct compat_itimerspec *)' {aka 'long int(int,  =
int,  struct compat_itimerspec *, struct compat_itimerspec *)'} and 'long i=
nt(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_timer_gettime' =
alias between functions of incompatible types 'long int(timer_t,  struct co=
mpat_itimerspec *)' {aka 'long int(int,  struct compat_itimerspec *)'} and =
'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_timer_create' a=
lias between functions of incompatible types 'long int(clockid_t,  struct c=
ompat_sigevent *, timer_t *)' {aka 'long int(int,  struct compat_sigevent *=
, int *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alia=
s]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_time' alias bet=
ween functions of incompatible types 'long int(compat_time_t *)' {aka 'long=
 int(int *)'} and 'long int(long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sysinfo' alias =
between functions of incompatible types 'long int(struct compat_sysinfo *)'=
 and 'long int(long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sysctl' alias b=
etween functions of incompatible types 'long int(struct compat_sysctl_args =
*)' and 'long int(long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_stime' alias be=
tween functions of incompatible types 'long int(compat_time_t *)' {aka 'lon=
g int(int *)'} and 'long int(long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_statfs64' alias=
 between functions of incompatible types 'long int(const char *, compat_siz=
e_t,  struct compat_statfs64 *)' {aka 'long int(const char *, unsigned int,=
  struct compat_statfs64 *)'} and 'long int(long int,  long int,  long int)=
' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_statfs' alias b=
etween functions of incompatible types 'long int(const char *, struct compa=
t_statfs *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_socketcall' ali=
as between functions of incompatible types 'long int(int,  u32 *)' {aka 'lo=
ng int(int,  unsigned int *)'} and 'long int(long int,  long int)' [-Wattri=
bute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sigprocmask' al=
ias between functions of incompatible types 'long int(int,  compat_old_sigs=
et_t *, compat_old_sigset_t *)' {aka 'long int(int,  unsigned int *, unsign=
ed int *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-ali=
as]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sigpending' ali=
as between functions of incompatible types 'long int(compat_old_sigset_t *)=
' {aka 'long int(unsigned int *)'} and 'long int(long int)' [-Wattribute-al=
ias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_signalfd4' alia=
s between functions of incompatible types 'long int(int,  const compat_sigs=
et_t *, compat_size_t,  int)' {aka 'long int(int,  const struct <anonymous>=
 *, unsigned int,  int)'} and 'long int(long int,  long int,  long int,  lo=
ng int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_signalfd' alias=
 between functions of incompatible types 'long int(int,  const compat_sigse=
t_t *, compat_size_t)' {aka 'long int(int,  const struct <anonymous> *, uns=
igned int)'} and 'long int(long int,  long int,  long int)' [-Wattribute-al=
ias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sigaltstack' al=
ias between functions of incompatible types 'long int(const compat_stack_t =
*, compat_stack_t *)' {aka 'long int(const struct compat_sigaltstack *, str=
uct compat_sigaltstack *)'} and 'long int(long int,  long int)' [-Wattribut=
e-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sigaction' alia=
s between functions of incompatible types 'long int(int,  const struct comp=
at_old_sigaction *, struct compat_old_sigaction *)' and 'long int(long int,=
  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_shmctl' alias b=
etween functions of incompatible types 'long int(int,  int,  void *)' and '=
long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_shmat' alias be=
tween functions of incompatible types 'long int(int,  compat_uptr_t,  int)'=
 {aka 'long int(int,  unsigned int,  int)'} and 'long int(long int,  long i=
nt,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_settimeofday' a=
lias between functions of incompatible types 'long int(struct compat_timeva=
l *, struct timezone *)' and 'long int(long int,  long int)' [-Wattribute-a=
lias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_setsockopt' ali=
as between functions of incompatible types 'long int(int,  int,  int,  char=
 *, unsigned int)' and 'long int(long int,  long int,  long int,  long int,=
  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_setrlimit' alia=
s between functions of incompatible types 'long int(unsigned int,  struct c=
ompat_rlimit *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_setitimer' alia=
s between functions of incompatible types 'long int(int,  struct compat_iti=
merval *, struct compat_itimerval *)' and 'long int(long int,  long int,  l=
ong int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_set_robust_list=
' alias between functions of incompatible types 'long int(struct compat_rob=
ust_list_head *, compat_size_t)' {aka 'long int(struct compat_robust_list_h=
ead *, unsigned int)'} and 'long int(long int,  long int)' [-Wattribute-ali=
as]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_set_mempolicy' =
alias between functions of incompatible types 'long int(int,  compat_ulong_=
t *, compat_ulong_t)' {aka 'long int(int,  unsigned int *, unsigned int)'} =
and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sendmsg' alias =
between functions of incompatible types 'long int(int,  struct compat_msghd=
r *, unsigned int)' and 'long int(long int,  long int,  long int)' [-Wattri=
bute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sendmmsg' alias=
 between functions of incompatible types 'long int(int,  struct compat_mmsg=
hdr *, unsigned int,  unsigned int)' and 'long int(long int,  long int,  lo=
ng int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sendfile64' ali=
as between functions of incompatible types 'long int(int,  int,  compat_lof=
f_t *, compat_size_t)' {aka 'long int(int,  int,  long long int *, unsigned=
 int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattrib=
ute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sendfile' alias=
 between functions of incompatible types 'long int(int,  int,  compat_off_t=
 *, compat_size_t)' {aka 'long int(int,  int,  int *, unsigned int)'} and '=
long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_semtimedop' ali=
as between functions of incompatible types 'long int(int,  struct sembuf *,=
 unsigned int,  const struct compat_timespec *)' and 'long int(long int,  l=
ong int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_semctl' alias b=
etween functions of incompatible types 'long int(int,  int,  int,  int)' an=
d 'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_select' alias b=
etween functions of incompatible types 'long int(int,  compat_ulong_t *, co=
mpat_ulong_t *, compat_ulong_t *, struct compat_timeval *)' {aka 'long int(=
int,  unsigned int *, unsigned int *, unsigned int *, struct compat_timeval=
 *)'} and 'long int(long int,  long int,  long int,  long int,  long int)' =
[-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sched_setaffini=
ty' alias between functions of incompatible types 'long int(compat_pid_t,  =
unsigned int,  compat_ulong_t *)' {aka 'long int(int,  unsigned int,  unsig=
ned int *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-al=
ias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sched_rr_get_in=
terval' alias between functions of incompatible types 'long int(compat_pid_=
t,  struct compat_timespec *)' {aka 'long int(int,  struct compat_timespec =
*)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_sched_getaffini=
ty' alias between functions of incompatible types 'long int(compat_pid_t,  =
unsigned int,  compat_ulong_t *)' {aka 'long int(int,  unsigned int,  unsig=
ned int *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-al=
ias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_rt_tgsigqueuein=
fo' alias between functions of incompatible types 'long int(compat_pid_t,  =
compat_pid_t,  int,  struct compat_siginfo *)' {aka 'long int(int,  int,  i=
nt,  struct compat_siginfo *)'} and 'long int(long int,  long int,  long in=
t,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_rt_sigtimedwait=
' alias between functions of incompatible types 'long int(compat_sigset_t *=
, struct compat_siginfo *, struct compat_timespec *, compat_size_t)' {aka '=
long int(struct <anonymous> *, struct compat_siginfo *, struct compat_times=
pec *, unsigned int)'} and 'long int(long int,  long int,  long int,  long =
int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_rt_sigsuspend' =
alias between functions of incompatible types 'long int(compat_sigset_t *, =
compat_size_t)' {aka 'long int(struct <anonymous> *, unsigned int)'} and 'l=
ong int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_rt_sigqueueinfo=
' alias between functions of incompatible types 'long int(compat_pid_t,  in=
t,  struct compat_siginfo *)' {aka 'long int(int,  int,  struct compat_sigi=
nfo *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_rt_sigprocmask'=
 alias between functions of incompatible types 'long int(int,  compat_sigse=
t_t *, compat_sigset_t *, compat_size_t)' {aka 'long int(int,  struct <anon=
ymous> *, struct <anonymous> *, unsigned int)'} and 'long int(long int,  lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_rt_sigpending' =
alias between functions of incompatible types 'long int(compat_sigset_t *, =
compat_size_t)' {aka 'long int(struct <anonymous> *, unsigned int)'} and 'l=
ong int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_rt_sigaction' a=
lias between functions of incompatible types 'long int(int,  const struct c=
ompat_sigaction *, struct compat_sigaction *, compat_size_t)' {aka 'long in=
t(int,  const struct compat_sigaction *, struct compat_sigaction *, unsigne=
d int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattri=
bute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_recvmsg' alias =
between functions of incompatible types 'long int(int,  struct compat_msghd=
r *, unsigned int)' and 'long int(long int,  long int,  long int)' [-Wattri=
bute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_recvmmsg' alias=
 between functions of incompatible types 'long int(int,  struct compat_mmsg=
hdr *, unsigned int,  unsigned int,  struct compat_timespec *)' and 'long i=
nt(long int,  long int,  long int,  long int,  long int)' [-Wattribute-alia=
s]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_recvfrom' alias=
 between functions of incompatible types 'long int(int,  void *, compat_siz=
e_t,  unsigned int,  struct sockaddr *, int *)' {aka 'long int(int,  void *=
, unsigned int,  unsigned int,  struct sockaddr *, int *)'} and 'long int(l=
ong int,  long int,  long int,  long int,  long int,  long int)' [-Wattribu=
te-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_recv' alias bet=
ween functions of incompatible types 'long int(int,  void *, compat_size_t,=
  unsigned int)' {aka 'long int(int,  void *, unsigned int,  unsigned int)'=
} and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-al=
ias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_readv' alias be=
tween functions of incompatible types 'long int(compat_ulong_t,  const stru=
ct compat_iovec *, compat_ulong_t)' {aka 'long int(unsigned int,  const str=
uct compat_iovec *, unsigned int)'} and 'long int(long int,  long int,  lon=
g int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_pwritev64' alia=
s between functions of incompatible types 'long int(long unsigned int,  con=
st struct compat_iovec *, long unsigned int,  loff_t)' {aka 'long int(long =
unsigned int,  const struct compat_iovec *, long unsigned int,  long long i=
nt)'} and 'long int(long int,  long int,  long int,  long long int)' [-Watt=
ribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_pwritev' alias =
between functions of incompatible types 'long int(compat_ulong_t,  const st=
ruct compat_iovec *, compat_ulong_t,  u32,  u32)' {aka 'long int(unsigned i=
nt,  const struct compat_iovec *, unsigned int,  unsigned int,  unsigned in=
t)'} and 'long int(long int,  long int,  long int,  long int,  long int)' [=
-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_ptrace' alias b=
etween functions of incompatible types 'long int(compat_long_t,  compat_lon=
g_t,  compat_long_t,  compat_long_t)' {aka 'long int(int,  int,  int,  int)=
'} and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-a=
lias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_pselect6' alias=
 between functions of incompatible types 'long int(int,  compat_ulong_t *, =
compat_ulong_t *, compat_ulong_t *, struct compat_timespec *, void *)' {aka=
 'long int(int,  unsigned int *, unsigned int *, unsigned int *, struct com=
pat_timespec *, void *)'} and 'long int(long int,  long int,  long int,  lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_process_vm_writ=
ev' alias between functions of incompatible types 'long int(compat_pid_t,  =
const struct compat_iovec *, compat_ulong_t,  const struct compat_iovec *, =
compat_ulong_t,  compat_ulong_t)' {aka 'long int(int,  const struct compat_=
iovec *, unsigned int,  const struct compat_iovec *, unsigned int,  unsigne=
d int)'} and 'long int(long int,  long int,  long int,  long int,  long int=
,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_process_vm_read=
v' alias between functions of incompatible types 'long int(compat_pid_t,  c=
onst struct compat_iovec *, compat_ulong_t,  const struct compat_iovec *, c=
ompat_ulong_t,  compat_ulong_t)' {aka 'long int(int,  const struct compat_i=
ovec *, unsigned int,  const struct compat_iovec *, unsigned int,  unsigned=
 int)'} and 'long int(long int,  long int,  long int,  long int,  long int,=
  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_preadv64' alias=
 between functions of incompatible types 'long int(long unsigned int,  cons=
t struct compat_iovec *, long unsigned int,  loff_t)' {aka 'long int(long u=
nsigned int,  const struct compat_iovec *, long unsigned int,  long long in=
t)'} and 'long int(long int,  long int,  long int,  long long int)' [-Wattr=
ibute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_preadv' alias b=
etween functions of incompatible types 'long int(compat_ulong_t,  const str=
uct compat_iovec *, compat_ulong_t,  u32,  u32)' {aka 'long int(unsigned in=
t,  const struct compat_iovec *, unsigned int,  unsigned int,  unsigned int=
)'} and 'long int(long int,  long int,  long int,  long int,  long int)' [-=
Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_ppoll' alias be=
tween functions of incompatible types 'long int(struct pollfd *, unsigned i=
nt,  struct compat_timespec *, const compat_sigset_t *, compat_size_t)' {ak=
a 'long int(struct pollfd *, unsigned int,  struct compat_timespec *, const=
 struct <anonymous> *, unsigned int)'} and 'long int(long int,  long int,  =
long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_openat' alias b=
etween functions of incompatible types 'long int(int,  const char *, int,  =
umode_t)' {aka 'long int(int,  const char *, int,  short unsigned int)'} an=
d 'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_open' alias bet=
ween functions of incompatible types 'long int(const char *, int,  umode_t)=
' {aka 'long int(const char *, int,  short unsigned int)'} and 'long int(lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_old_select' ali=
as between functions of incompatible types 'long int(struct compat_sel_arg_=
struct *)' and 'long int(long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_old_readdir' al=
ias between functions of incompatible types 'long int(unsigned int,  struct=
 compat_old_linux_dirent *, unsigned int)' and 'long int(long int,  long in=
t,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_old_getrlimit' =
alias between functions of incompatible types 'long int(unsigned int,  stru=
ct compat_rlimit *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_newstat' alias =
between functions of incompatible types 'long int(const char *, struct comp=
at_stat *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_newlstat' alias=
 between functions of incompatible types 'long int(const char *, struct com=
pat_stat *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_newfstatat' ali=
as between functions of incompatible types 'long int(unsigned int,  const c=
har *, struct compat_stat *, int)' and 'long int(long int,  long int,  long=
 int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_newfstat' alias=
 between functions of incompatible types 'long int(unsigned int,  struct co=
mpat_stat *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_nanosleep' alia=
s between functions of incompatible types 'long int(struct compat_timespec =
*, struct compat_timespec *)' and 'long int(long int,  long int)' [-Wattrib=
ute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_msgsnd' alias b=
etween functions of incompatible types 'long int(int,  compat_uptr_t,  comp=
at_ssize_t,  int)' {aka 'long int(int,  unsigned int,  int,  int)'} and 'lo=
ng int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_msgrcv' alias b=
etween functions of incompatible types 'long int(int,  compat_uptr_t,  comp=
at_ssize_t,  compat_long_t,  int)' {aka 'long int(int,  unsigned int,  int,=
  int,  int)'} and 'long int(long int,  long int,  long int,  long int,  lo=
ng int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_msgctl' alias b=
etween functions of incompatible types 'long int(int,  int,  void *)' and '=
long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_mq_timedsend' a=
lias between functions of incompatible types 'long int(mqd_t,  const char *=
, compat_size_t,  unsigned int,  const struct compat_timespec *)' {aka 'lon=
g int(int,  const char *, unsigned int,  unsigned int,  const struct compat=
_timespec *)'} and 'long int(long int,  long int,  long int,  long int,  lo=
ng int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_mq_timedreceive=
' alias between functions of incompatible types 'long int(mqd_t,  char *, c=
ompat_size_t,  unsigned int *, const struct compat_timespec *)' {aka 'long =
int(int,  char *, unsigned int,  unsigned int *, const struct compat_timesp=
ec *)'} and 'long int(long int,  long int,  long int,  long int,  long int)=
' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_mq_open' alias =
between functions of incompatible types 'long int(const char *, int,  compa=
t_mode_t,  struct compat_mq_attr *)' {aka 'long int(const char *, int,  sho=
rt unsigned int,  struct compat_mq_attr *)'} and 'long int(long int,  long =
int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_mq_notify' alia=
s between functions of incompatible types 'long int(mqd_t,  const struct co=
mpat_sigevent *)' {aka 'long int(int,  const struct compat_sigevent *)'} an=
d 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_mq_getsetattr' =
alias between functions of incompatible types 'long int(mqd_t,  const struc=
t compat_mq_attr *, struct compat_mq_attr *)' {aka 'long int(int,  const st=
ruct compat_mq_attr *, struct compat_mq_attr *)'} and 'long int(long int,  =
long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_move_pages' ali=
as between functions of incompatible types 'long int(pid_t,  compat_ulong_t=
,  compat_uptr_t *, const int *, int *, int)' {aka 'long int(int,  unsigned=
 int,  unsigned int *, const int *, int *, int)'} and 'long int(long int,  =
long int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_mount' alias be=
tween functions of incompatible types 'long int(const char *, const char *,=
 const char *, compat_ulong_t,  const void *)' {aka 'long int(const char *,=
 const char *, const char *, unsigned int,  const void *)'} and 'long int(l=
ong int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_migrate_pages' =
alias between functions of incompatible types 'long int(compat_pid_t,  comp=
at_ulong_t,  const compat_ulong_t *, const compat_ulong_t *)' {aka 'long in=
t(int,  unsigned int,  const unsigned int *, const unsigned int *)'} and 'l=
ong int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_mbind' alias be=
tween functions of incompatible types 'long int(compat_ulong_t,  compat_ulo=
ng_t,  compat_ulong_t,  compat_ulong_t *, compat_ulong_t,  compat_ulong_t)'=
 {aka 'long int(unsigned int,  unsigned int,  unsigned int,  unsigned int *=
, unsigned int,  unsigned int)'} and 'long int(long int,  long int,  long i=
nt,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_lseek' alias be=
tween functions of incompatible types 'long int(unsigned int,  compat_off_t=
,  unsigned int)' {aka 'long int(unsigned int,  int,  unsigned int)'} and '=
long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_lookup_dcookie'=
 alias between functions of incompatible types 'long int(u32,  u32,  char *=
, compat_size_t)' {aka 'long int(unsigned int,  unsigned int,  char *, unsi=
gned int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wat=
tribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_keyctl' alias b=
etween functions of incompatible types 'long int(u32,  u32,  u32,  u32,  u3=
2)' {aka 'long int(unsigned int,  unsigned int,  unsigned int,  unsigned in=
t,  unsigned int)'} and 'long int(long int,  long int,  long int,  long int=
,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_kexec_load' ali=
as between functions of incompatible types 'long int(compat_ulong_t,  compa=
t_ulong_t,  struct compat_kexec_segment *, compat_ulong_t)' {aka 'long int(=
unsigned int,  unsigned int,  struct compat_kexec_segment *, unsigned int)'=
} and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-al=
ias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_ipc' alias betw=
een functions of incompatible types 'long int(u32,  int,  int,  u32,  compa=
t_uptr_t,  u32)' {aka 'long int(unsigned int,  int,  int,  unsigned int,  u=
nsigned int,  unsigned int)'} and 'long int(long int,  long int,  long int,=
  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_ioctl' alias be=
tween functions of incompatible types 'long int(unsigned int,  unsigned int=
,  compat_ulong_t)' {aka 'long int(unsigned int,  unsigned int,  unsigned i=
nt)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_io_submit' alia=
s between functions of incompatible types 'long int(compat_aio_context_t,  =
int,  u32 *)' {aka 'long int(unsigned int,  int,  unsigned int *)'} and 'lo=
ng int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_io_setup' alias=
 between functions of incompatible types 'long int(unsigned int,  u32 *)' {=
aka 'long int(unsigned int,  unsigned int *)'} and 'long int(long int,  lon=
g int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_io_getevents' a=
lias between functions of incompatible types 'long int(compat_aio_context_t=
,  compat_long_t,  compat_long_t,  struct io_event *, struct compat_timespe=
c *)' {aka 'long int(unsigned int,  int,  int,  struct io_event *, struct c=
ompat_timespec *)'} and 'long int(long int,  long int,  long int,  long int=
,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_gettimeofday' a=
lias between functions of incompatible types 'long int(struct compat_timeva=
l *, struct timezone *)' and 'long int(long int,  long int)' [-Wattribute-a=
lias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_getsockopt' ali=
as between functions of incompatible types 'long int(int,  int,  int,  char=
 *, int *)' and 'long int(long int,  long int,  long int,  long int,  long =
int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_getrusage' alia=
s between functions of incompatible types 'long int(int,  struct compat_rus=
age *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_getrlimit' alia=
s between functions of incompatible types 'long int(unsigned int,  struct c=
ompat_rlimit *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_getitimer' alia=
s between functions of incompatible types 'long int(int,  struct compat_iti=
merval *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_getdents64' ali=
as between functions of incompatible types 'long int(unsigned int,  struct =
linux_dirent64 *, unsigned int)' and 'long int(long int,  long int,  long i=
nt)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_getdents' alias=
 between functions of incompatible types 'long int(unsigned int,  struct co=
mpat_linux_dirent *, unsigned int)' and 'long int(long int,  long int,  lon=
g int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_get_robust_list=
' alias between functions of incompatible types 'long int(int,  compat_uptr=
_t *, compat_size_t *)' {aka 'long int(int,  unsigned int *, unsigned int *=
)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_get_mempolicy' =
alias between functions of incompatible types 'long int(int *, compat_ulong=
_t *, compat_ulong_t,  compat_ulong_t,  compat_ulong_t)' {aka 'long int(int=
 *, unsigned int *, unsigned int,  unsigned int,  unsigned int)'} and 'long=
 int(long int,  long int,  long int,  long int,  long int)' [-Wattribute-al=
ias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_futimesat' alia=
s between functions of incompatible types 'long int(unsigned int,  const ch=
ar *, struct compat_timeval *)' and 'long int(long int,  long int,  long in=
t)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_futex' alias be=
tween functions of incompatible types 'long int(u32 *, int,  u32,  struct c=
ompat_timespec *, u32 *, u32)' {aka 'long int(unsigned int *, int,  unsigne=
d int,  struct compat_timespec *, unsigned int *, unsigned int)'} and 'long=
 int(long int,  long int,  long int,  long int,  long int,  long int)' [-Wa=
ttribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_ftruncate' alia=
s between functions of incompatible types 'long int(unsigned int,  compat_u=
long_t)' {aka 'long int(unsigned int,  unsigned int)'} and 'long int(long i=
nt,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_fstatfs64' alia=
s between functions of incompatible types 'long int(unsigned int,  compat_s=
ize_t,  struct compat_statfs64 *)' {aka 'long int(unsigned int,  unsigned i=
nt,  struct compat_statfs64 *)'} and 'long int(long int,  long int,  long i=
nt)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_fstatfs' alias =
between functions of incompatible types 'long int(unsigned int,  struct com=
pat_statfs *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_fcntl64' alias =
between functions of incompatible types 'long int(unsigned int,  unsigned i=
nt,  compat_ulong_t)' {aka 'long int(unsigned int,  unsigned int,  unsigned=
 int)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_fcntl' alias be=
tween functions of incompatible types 'long int(unsigned int,  unsigned int=
,  compat_ulong_t)' {aka 'long int(unsigned int,  unsigned int,  unsigned i=
nt)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_execve' alias b=
etween functions of incompatible types 'long int(const char *, const compat=
_uptr_t *, const compat_uptr_t *)' {aka 'long int(const char *, const unsig=
ned int *, const unsigned int *)'} and 'long int(long int,  long int,  long=
 int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_epoll_pwait' al=
ias between functions of incompatible types 'long int(int,  struct epoll_ev=
ent *, int,  int,  const compat_sigset_t *, compat_size_t)' {aka 'long int(=
int,  struct epoll_event *, int,  int,  const struct <anonymous> *, unsigne=
d int)'} and 'long int(long int,  long int,  long int,  long int,  long int=
,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_clock_settime' =
alias between functions of incompatible types 'long int(clockid_t,  struct =
compat_timespec *)' {aka 'long int(int,  struct compat_timespec *)'} and 'l=
ong int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_clock_nanosleep=
' alias between functions of incompatible types 'long int(clockid_t,  int, =
 struct compat_timespec *, struct compat_timespec *)' {aka 'long int(int,  =
int,  struct compat_timespec *, struct compat_timespec *)'} and 'long int(l=
ong int,  long int,  long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_clock_gettime' =
alias between functions of incompatible types 'long int(clockid_t,  struct =
compat_timespec *)' {aka 'long int(int,  struct compat_timespec *)'} and 'l=
ong int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_clock_getres' a=
lias between functions of incompatible types 'long int(clockid_t,  struct c=
ompat_timespec *)' {aka 'long int(int,  struct compat_timespec *)'} and 'lo=
ng int(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_clock_adjtime' =
alias between functions of incompatible types 'long int(clockid_t,  struct =
compat_timex *)' {aka 'long int(int,  struct compat_timex *)'} and 'long in=
t(long int,  long int)' [-Wattribute-alias]
    1    include/linux/compat.h:48:18: warning: 'compat_sys_adjtimex' alias=
 between functions of incompatible types 'long int(struct compat_timex *)' =
and 'long int(long int)' [-Wattribute-alias]
    1    fs/nfs/client.c:1380:23: warning: '%u' directive output may be tru=
ncated writing between 1 and 7 bytes into a region of size between 3 and 6 =
[-Wformat-truncation=3D]
    1    drivers/video/fbdev/core/../edid.h:74:72: warning: '*' in boolean =
context, suggest '&&' instead [-Wint-in-bool-context]
    1    drivers/usb/core/usb.c:471:9: warning: '%d' directive output may b=
e truncated writing between 1 and 11 bytes into a region of size between 0 =
and 15 [-Wformat-truncation=3D]
    1    drivers/usb/core/hcd.c:450:34: warning: '%s' directive output may =
be truncated writing up to 64 bytes into a region of size between 35 and 99=
 [-Wformat-truncation=3D]
    1    drivers/net/ethernet/broadcom/tg3.c:11184:10: warning: '%d' direct=
ive output may be truncated writing between 1 and 11 bytes into a region of=
 size between 0 and 15 [-Wformat-truncation=3D]
    1    drivers/net/ethernet/broadcom/tg3.c:11181:9: warning: '-rx-' direc=
tive output may be truncated writing 4 bytes into a region of size between =
1 and 16 [-Wformat-truncation=3D]
    1    drivers/net/ethernet/broadcom/tg3.c:11178:9: warning: '-tx-' direc=
tive output may be truncated writing 4 bytes into a region of size between =
1 and 16 [-Wformat-truncation=3D]
    1    drivers/net/ethernet/broadcom/tg3.c:11175:9: warning: '-txrx-' dir=
ective output may be truncated writing 6 bytes into a region of size betwee=
n 1 and 16 [-Wformat-truncation=3D]
    1    drivers/mfd/omap-usb-tll.c:88:53: warning: overflow in conversion =
from 'int' to 'u8' {aka 'unsigned char'} changes value from 'i * 256 + 2070=
' to '22' [-Woverflow]
    1    drivers/input/mouse/psmouse-base.c:1466:52: warning: '/input0' dir=
ective output may be truncated writing 7 bytes into a region of size betwee=
n 1 and 32 [-Wformat-truncation=3D]
    1    drivers/input/mouse/lifebook.c:287:7: warning: '/input1' directive=
 output may be truncated writing 7 bytes into a region of size between 1 an=
d 32 [-Wformat-truncation=3D]
    1    drivers/input/mouse/alps.c:2418:46: warning: '/input1' directive o=
utput may be truncated writing 7 bytes into a region of size between 1 and =
32 [-Wformat-truncation=3D]
    1    drivers/input/keyboard/atkbd.c:1069:7: warning: '/input0' directiv=
e output may be truncated writing 7 bytes into a region of size between 1 a=
nd 32 [-Wformat-truncation=3D]
    1    drivers/ata/libata-eh.c:2442:45: warning: '%d' directive output ma=
y be truncated writing between 1 and 11 bytes into a region of size 4 [-Wfo=
rmat-truncation=3D]
    1    drivers/ata/libata-core.c:2970:30: warning: '*' in boolean context=
, suggest '&&' instead [-Wint-in-bool-context]
    1    drivers/ata/libata-core.c:2969:30: warning: '*' in boolean context=
, suggest '&&' instead [-Wint-in-bool-context]
    1    drivers/ata/libata-core.c:2968:35: warning: '*' in boolean context=
, suggest '&&' instead [-Wint-in-bool-context]
    1    drivers/ata/libata-core.c:2967:32: warning: '*' in boolean context=
, suggest '&&' instead [-Wint-in-bool-context]
    1    drivers/ata/libata-core.c:2966:31: warning: '*' in boolean context=
, suggest '&&' instead [-Wint-in-bool-context]
    1    drivers/ata/libata-core.c:2965:30: warning: '*' in boolean context=
, suggest '&&' instead [-Wint-in-bool-context]
    1    drivers/ata/libata-core.c:2964:30: warning: '*' in boolean context=
, suggest '&&' instead [-Wint-in-bool-context]
    1    drivers/ata/libata-core.c:2963:30: warning: '*' in boolean context=
, suggest '&&' instead [-Wint-in-bool-context]
    1    drivers/ata/libata-core.c:2962:30: warning: '*' in boolean context=
, suggest '&&' instead [-Wint-in-bool-context]
    1    drivers/ata/libata-core.c:2141:42: warning: '%d' directive output =
may be truncated writing between 1 and 2 bytes into a region of size betwee=
n 1 and 11 [-Wformat-truncation=3D]
    1    block/partition-generic.c:41:37: warning: 'snprintf' output may be=
 truncated before the last format character [-Wformat-truncation=3D]
    1    block/partition-generic.c:39:36: warning: '%d' directive output ma=
y be truncated writing between 1 and 11 bytes into a region of size between=
 0 and 31 [-Wformat-truncation=3D]
    1    block/elevator.c:841:14: warning: 'snprintf' output may be truncat=
ed before the last format character [-Wformat-truncation=3D]
    1    arch/x86/pci/mmconfig-shared.c:90:28: warning: '%02x' directive ou=
tput may be truncated writing between 2 and 8 bytes into a region of size b=
etween 3 and 7 [-Wformat-truncation=3D]
    1    arch/arm64/kernel/vdso.c:118:6: warning: 'memcmp' reading 4 bytes =
from a region of size 1 [-Wstringop-overflow=3D]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 FAIL, 3 errors, 205 warnings, 0 section =
mismatches

Errors:
    arch/arc/mm/tlbex.S:291: Error: unknown opcode 'lsl'
    arch/arc/mm/tlbex.S:348: Error: unknown opcode 'lsl'
    arch/arc/include/asm/uaccess.h:676:2: error: impossible constraint in '=
asm'

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    mm/memory.c:581:7: warning: assignment to 'pgtable_t' {aka 'long unsign=
ed int'} from 'void *' makes integer from pointer without a cast [-Wint-con=
version]
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    mm/mmap.c:684:2: warning: 'rb_link' may be used uninitialized in this f=
unction [-Wmaybe-uninitialized]
    mm/mmap.c:684:2: warning: 'rb_parent' may be used uninitialized in this=
 function [-Wmaybe-uninitialized]
    mm/mmap.c:683:2: warning: 'prev' may be used uninitialized in this func=
tion [-Wmaybe-uninitialized]
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    include/linux/kernel.h:707:17: warning: comparison of distinct pointer =
types lacks a cast
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 section =
mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 215 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/syscalls.h:195:18: warning: 'sys_set_tid_address' alias b=
etween functions of incompatible types 'long int(int *)' and 'long int(long=
 int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_unshare' alias between f=
unctions of incompatible types 'long int(long unsigned int)' and 'long int(=
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clone' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  long unsigned in=
t,  int *, int *, int)' and 'long int(long int,  long int,  long int,  long=
 int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_personality' alias betwe=
en functions of incompatible types 'long int(unsigned int)' and 'long int(l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_exit' alias between func=
tions of incompatible types 'long int(int)' and 'long int(long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_waitpid' alias between f=
unctions of incompatible types 'long int(pid_t,  int *, int)' {aka 'long in=
t(int,  int *, int)'} and 'long int(long int,  long int,  long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_wait4' alias between fun=
ctions of incompatible types 'long int(pid_t,  int *, int,  struct rusage *=
)' {aka 'long int(int,  int *, int,  struct rusage *)'} and 'long int(long =
int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_waitid' alias between fu=
nctions of incompatible types 'long int(int,  pid_t,  struct siginfo *, int=
,  struct rusage *)' {aka 'long int(int,  int,  struct siginfo *, int,  str=
uct rusage *)'} and 'long int(long int,  long int,  long int,  long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_exit_group' alias betwee=
n functions of incompatible types 'long int(int)' and 'long int(long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_iopl' alias between func=
tions of incompatible types 'long int(unsigned int)' and 'long int(long int=
)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_readahead' alias between=
 functions of incompatible types 'long int(int,  loff_t,  size_t)' {aka 'lo=
ng int(int,  long long int,  long unsigned int)'} and 'long int(long int,  =
long long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sysctl' alias between fu=
nctions of incompatible types 'long int(struct __sysctl_args *)' and 'long =
int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_capget' alias between fu=
nctions of incompatible types 'long int(struct __user_cap_header_struct *, =
struct __user_cap_data_struct *)' and 'long int(long int,  long int)' [-Wat=
tribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_capset' alias between fu=
nctions of incompatible types 'long int(struct __user_cap_header_struct *, =
struct __user_cap_data_struct * const)' and 'long int(long int,  long int)'=
 [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ptrace' alias between fu=
nctions of incompatible types 'long int(long int,  long int,  long unsigned=
 int,  long unsigned int)' and 'long int(long int,  long int,  long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setpriority' alias betwe=
en functions of incompatible types 'long int(int,  int,  int)' and 'long in=
t(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sysinfo' alias between f=
unctions of incompatible types 'long int(struct sysinfo *)' and 'long int(l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getcpu' alias between fu=
nctions of incompatible types 'long int(unsigned int *, unsigned int *, str=
uct getcpu_cache *)' and 'long int(long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_prctl' alias between fun=
ctions of incompatible types 'long int(int,  long unsigned int,  long unsig=
ned int,  long unsigned int,  long unsigned int)' and 'long int(long int,  =
long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_umask' alias between fun=
ctions of incompatible types 'long int(int)' and 'long int(long int)' [-Wat=
tribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getrusage' alias between=
 functions of incompatible types 'long int(int,  struct rusage *)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setrlimit' alias between=
 functions of incompatible types 'long int(unsigned int,  struct rlimit *)'=
 and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_prlimit64' alias between=
 functions of incompatible types 'long int(pid_t,  unsigned int,  const str=
uct rlimit64 *, struct rlimit64 *)' {aka 'long int(int,  unsigned int,  con=
st struct rlimit64 *, struct rlimit64 *)'} and 'long int(long int,  long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_old_getrlimit' alias bet=
ween functions of incompatible types 'long int(unsigned int,  struct rlimit=
 *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getrlimit' alias between=
 functions of incompatible types 'long int(unsigned int,  struct rlimit *)'=
 and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setdomainname' alias bet=
ween functions of incompatible types 'long int(char *, int)' and 'long int(=
long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_gethostname' alias betwe=
en functions of incompatible types 'long int(char *, int)' and 'long int(lo=
ng int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sethostname' alias betwe=
en functions of incompatible types 'long int(char *, int)' and 'long int(lo=
ng int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_olduname' alias between =
functions of incompatible types 'long int(struct oldold_utsname *)' and 'lo=
ng int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_uname' alias between fun=
ctions of incompatible types 'long int(struct old_utsname *)' and 'long int=
(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_newuname' alias between =
functions of incompatible types 'long int(struct new_utsname *)' and 'long =
int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getsid' alias between fu=
nctions of incompatible types 'long int(pid_t)' {aka 'long int(int)'} and '=
long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getpgid' alias between f=
unctions of incompatible types 'long int(pid_t)' {aka 'long int(int)'} and =
'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setpgid' alias between f=
unctions of incompatible types 'long int(pid_t,  pid_t)' {aka 'long int(int=
,  int)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_times' alias between fun=
ctions of incompatible types 'long int(struct tms *)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setfsgid' alias between =
functions of incompatible types 'long int(gid_t)' {aka 'long int(unsigned i=
nt)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setfsuid' alias between =
functions of incompatible types 'long int(uid_t)' {aka 'long int(unsigned i=
nt)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getresgid' alias between=
 functions of incompatible types 'long int(gid_t *, gid_t *, gid_t *)' {aka=
 'long int(unsigned int *, unsigned int *, unsigned int *)'} and 'long int(=
long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setresgid' alias between=
 functions of incompatible types 'long int(gid_t,  gid_t,  gid_t)' {aka 'lo=
ng int(unsigned int,  unsigned int,  unsigned int)'} and 'long int(long int=
,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getresuid' alias between=
 functions of incompatible types 'long int(uid_t *, uid_t *, uid_t *)' {aka=
 'long int(unsigned int *, unsigned int *, unsigned int *)'} and 'long int(=
long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setresuid' alias between=
 functions of incompatible types 'long int(uid_t,  uid_t,  uid_t)' {aka 'lo=
ng int(unsigned int,  unsigned int,  unsigned int)'} and 'long int(long int=
,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setuid' alias between fu=
nctions of incompatible types 'long int(uid_t)' {aka 'long int(unsigned int=
)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setreuid' alias between =
functions of incompatible types 'long int(uid_t,  uid_t)' {aka 'long int(un=
signed int,  unsigned int)'} and 'long int(long int,  long int)' [-Wattribu=
te-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setgid' alias between fu=
nctions of incompatible types 'long int(gid_t)' {aka 'long int(unsigned int=
)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setregid' alias between =
functions of incompatible types 'long int(gid_t,  gid_t)' {aka 'long int(un=
signed int,  unsigned int)'} and 'long int(long int,  long int)' [-Wattribu=
te-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getpriority' alias betwe=
en functions of incompatible types 'long int(int,  int)' and 'long int(long=
 int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigprocmask' alias be=
tween functions of incompatible types 'long int(int,  sigset_t *, sigset_t =
*, size_t)' {aka 'long int(int,  struct <anonymous> *, struct <anonymous> *=
, long unsigned int)'} and 'long int(long int,  long int,  long int,  long =
int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigsuspend' alias bet=
ween functions of incompatible types 'long int(sigset_t *, size_t)' {aka 'l=
ong int(struct <anonymous> *, long unsigned int)'} and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_signal' alias between fu=
nctions of incompatible types 'long int(int,  void (*)(int))' and 'long int=
(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigaction' alias betw=
een functions of incompatible types 'long int(int,  const struct sigaction =
*, struct sigaction *, size_t)' {aka 'long int(int,  const struct sigaction=
 *, struct sigaction *, long unsigned int)'} and 'long int(long int,  long =
int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sigprocmask' alias betwe=
en functions of incompatible types 'long int(int,  old_sigset_t *, old_sigs=
et_t *)' {aka 'long int(int,  long unsigned int *, long unsigned int *)'} a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sigpending' alias betwee=
n functions of incompatible types 'long int(old_sigset_t *)' {aka 'long int=
(long unsigned int *)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sigaltstack' alias betwe=
en functions of incompatible types 'long int(const stack_t *, stack_t *)' {=
aka 'long int(const struct sigaltstack *, struct sigaltstack *)'} and 'long=
 int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_tgsigqueueinfo' alias=
 between functions of incompatible types 'long int(pid_t,  pid_t,  int,  si=
ginfo_t *)' {aka 'long int(int,  int,  int,  struct siginfo *)'} and 'long =
int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigqueueinfo' alias b=
etween functions of incompatible types 'long int(pid_t,  int,  siginfo_t *)=
' {aka 'long int(int,  int,  struct siginfo *)'} and 'long int(long int,  l=
ong int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_tkill' alias between fun=
ctions of incompatible types 'long int(pid_t,  int)' {aka 'long int(int,  i=
nt)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_tgkill' alias between fu=
nctions of incompatible types 'long int(pid_t,  pid_t,  int)' {aka 'long in=
t(int,  int,  int)'} and 'long int(long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_kill' alias between func=
tions of incompatible types 'long int(pid_t,  int)' {aka 'long int(int,  in=
t)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigtimedwait' alias b=
etween functions of incompatible types 'long int(const sigset_t *, siginfo_=
t *, const struct timespec *, size_t)' {aka 'long int(const struct <anonymo=
us> *, struct siginfo *, const struct timespec *, long unsigned int)'} and =
'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigpending' alias bet=
ween functions of incompatible types 'long int(sigset_t *, size_t)' {aka 'l=
ong int(struct <anonymous> *, long unsigned int)'} and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mmap' alias between func=
tions of incompatible types 'long int(long unsigned int,  long unsigned int=
,  long unsigned int,  long unsigned int,  long unsigned int,  long unsigne=
d int)' and 'long int(long int,  long int,  long int,  long int,  long int,=
  long int)' [-Wattribute-alias]
    kernel/workqueue.c:1720:40: warning: '%d' directive output may be trunc=
ated writing between 1 and 10 bytes into a region of size between 5 and 14 =
[-Wformat-truncation=3D]
    include/linux/syscalls.h:195:18: warning: 'sys_setns' alias between fun=
ctions of incompatible types 'long int(int,  int)' and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_reboot' alias between fu=
nctions of incompatible types 'long int(int,  int,  unsigned int,  void *)'=
 and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_getgroups' alias between=
 functions of incompatible types 'long int(int,  gid_t *)' {aka 'long int(i=
nt,  unsigned int *)'} and 'long int(long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_setgroups' alias between=
 functions of incompatible types 'long int(int,  gid_t *)' {aka 'long int(i=
nt,  unsigned int *)'} and 'long int(long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_remap_file_pages' alias =
between functions of incompatible types 'long int(long unsigned int,  long =
unsigned int,  long unsigned int,  long unsigned int,  long unsigned int)' =
and 'long int(long int,  long int,  long int,  long int,  long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_truncate' alias between =
functions of incompatible types 'long int(const char *, long int)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_close' alias between fun=
ctions of incompatible types 'long int(unsigned int)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_creat' alias between fun=
ctions of incompatible types 'long int(const char *, umode_t)' {aka 'long i=
nt(const char *, short unsigned int)'} and 'long int(long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_openat' alias between fu=
nctions of incompatible types 'long int(int,  const char *, int,  umode_t)'=
 {aka 'long int(int,  const char *, int,  short unsigned int)'} and 'long i=
nt(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_open' alias between func=
tions of incompatible types 'long int(const char *, int,  umode_t)' {aka 'l=
ong int(const char *, int,  short unsigned int)'} and 'long int(long int,  =
long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchown' alias between fu=
nctions of incompatible types 'long int(unsigned int,  uid_t,  gid_t)' {aka=
 'long int(unsigned int,  unsigned int,  unsigned int)'} and 'long int(long=
 int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lchown' alias between fu=
nctions of incompatible types 'long int(const char *, uid_t,  gid_t)' {aka =
'long int(const char *, unsigned int,  unsigned int)'} and 'long int(long i=
nt,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chown' alias between fun=
ctions of incompatible types 'long int(const char *, uid_t,  gid_t)' {aka '=
long int(const char *, unsigned int,  unsigned int)'} and 'long int(long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchownat' alias between =
functions of incompatible types 'long int(int,  const char *, uid_t,  gid_t=
,  int)' {aka 'long int(int,  const char *, unsigned int,  unsigned int,  i=
nt)'} and 'long int(long int,  long int,  long int,  long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chmod' alias between fun=
ctions of incompatible types 'long int(const char *, umode_t)' {aka 'long i=
nt(const char *, short unsigned int)'} and 'long int(long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchmodat' alias between =
functions of incompatible types 'long int(int,  const char *, umode_t)' {ak=
a 'long int(int,  const char *, short unsigned int)'} and 'long int(long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchmod' alias between fu=
nctions of incompatible types 'long int(unsigned int,  umode_t)' {aka 'long=
 int(unsigned int,  short unsigned int)'} and 'long int(long int,  long int=
)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chroot' alias between fu=
nctions of incompatible types 'long int(const char *)' and 'long int(long i=
nt)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchdir' alias between fu=
nctions of incompatible types 'long int(unsigned int)' and 'long int(long i=
nt)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chdir' alias between fun=
ctions of incompatible types 'long int(const char *)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_access' alias between fu=
nctions of incompatible types 'long int(const char *, int)' and 'long int(l=
ong int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_faccessat' alias between=
 functions of incompatible types 'long int(int,  const char *, int)' and 'l=
ong int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fallocate' alias between=
 functions of incompatible types 'long int(int,  int,  loff_t,  loff_t)' {a=
ka 'long int(int,  int,  long long int,  long long int)'} and 'long int(lon=
g int,  long int,  long long int,  long long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ftruncate' alias between=
 functions of incompatible types 'long int(unsigned int,  long unsigned int=
)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lseek' alias between fun=
ctions of incompatible types 'long int(unsigned int,  off_t,  unsigned int)=
' {aka 'long int(unsigned int,  long int,  unsigned int)'} and 'long int(lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sendfile64' alias betwee=
n functions of incompatible types 'long int(int,  int,  loff_t *, size_t)' =
{aka 'long int(int,  int,  long long int *, long unsigned int)'} and 'long =
int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sendfile' alias between =
functions of incompatible types 'long int(int,  int,  off_t *, size_t)' {ak=
a 'long int(int,  int,  long int *, long unsigned int)'} and 'long int(long=
 int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pwritev' alias between f=
unctions of incompatible types 'long int(long unsigned int,  const struct i=
ovec *, long unsigned int,  long unsigned int,  long unsigned int)' and 'lo=
ng int(long int,  long int,  long int,  long int,  long int)' [-Wattribute-=
alias]
    include/linux/syscalls.h:195:18: warning: 'sys_preadv' alias between fu=
nctions of incompatible types 'long int(long unsigned int,  const struct io=
vec *, long unsigned int,  long unsigned int,  long unsigned int)' and 'lon=
g int(long int,  long int,  long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/syscalls.h:195:18: warning: 'sys_writev' alias between fu=
nctions of incompatible types 'long int(long unsigned int,  const struct io=
vec *, long unsigned int)' and 'long int(long int,  long int,  long int)' [=
-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_readv' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  const struct iov=
ec *, long unsigned int)' and 'long int(long int,  long int,  long int)' [-=
Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pwrite64' alias between =
functions of incompatible types 'long int(unsigned int,  const char *, size=
_t,  loff_t)' {aka 'long int(unsigned int,  const char *, long unsigned int=
,  long long int)'} and 'long int(long int,  long int,  long int,  long lon=
g int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pread64' alias between f=
unctions of incompatible types 'long int(unsigned int,  char *, size_t,  lo=
ff_t)' {aka 'long int(unsigned int,  char *, long unsigned int,  long long =
int)'} and 'long int(long int,  long int,  long int,  long long int)' [-Wat=
tribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_write' alias between fun=
ctions of incompatible types 'long int(unsigned int,  const char *, size_t)=
' {aka 'long int(unsigned int,  const char *, long unsigned int)'} and 'lon=
g int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_read' alias between func=
tions of incompatible types 'long int(unsigned int,  char *, size_t)' {aka =
'long int(unsigned int,  char *, long unsigned int)'} and 'long int(long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_llseek' alias between fu=
nctions of incompatible types 'long int(unsigned int,  long unsigned int,  =
long unsigned int,  loff_t *, unsigned int)' {aka 'long int(unsigned int,  =
long unsigned int,  long unsigned int,  long long int *, unsigned int)'} an=
d 'long int(long int,  long int,  long int,  long int,  long int)' [-Wattri=
bute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_perf_event_open' alias b=
etween functions of incompatible types 'long int(struct perf_event_attr *, =
pid_t,  int,  int,  long unsigned int)' {aka 'long int(struct perf_event_at=
tr *, int,  int,  int,  long unsigned int)'} and 'long int(long int,  long =
int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mincore' alias between f=
unctions of incompatible types 'long int(long unsigned int,  size_t,  unsig=
ned char *)' {aka 'long int(long unsigned int,  long unsigned int,  unsigne=
d char *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_mlock' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  size_t)' {aka 'l=
ong int(long unsigned int,  long unsigned int)'} and 'long int(long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mlockall' alias between =
functions of incompatible types 'long int(int)' and 'long int(long int)' [-=
Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_munlock' alias between f=
unctions of incompatible types 'long int(long unsigned int,  size_t)' {aka =
'long int(long unsigned int,  long unsigned int)'} and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_stat' alias between func=
tions of incompatible types 'long int(const char *, struct __old_kernel_sta=
t *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_readlink' alias between =
functions of incompatible types 'long int(const char *, char *, int)' and '=
long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_readlinkat' alias betwee=
n functions of incompatible types 'long int(int,  const char *, char *, int=
)' and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/syscalls.h:195:18: warning: 'sys_newfstat' alias between =
functions of incompatible types 'long int(unsigned int,  struct stat *)' an=
d 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_newfstatat' alias betwee=
n functions of incompatible types 'long int(int,  const char *, struct stat=
 *, int)' and 'long int(long int,  long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_newlstat' alias between =
functions of incompatible types 'long int(const char *, struct stat *)' and=
 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_newstat' alias between f=
unctions of incompatible types 'long int(const char *, struct stat *)' and =
'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fstat' alias between fun=
ctions of incompatible types 'long int(unsigned int,  struct __old_kernel_s=
tat *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lstat' alias between fun=
ctions of incompatible types 'long int(const char *, struct __old_kernel_st=
at *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_execve' alias between fu=
nctions of incompatible types 'long int(const char *, const char * const*, =
const char * const*)' and 'long int(long int,  long int,  long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_brk' alias between funct=
ions of incompatible types 'long int(long unsigned int)' and 'long int(long=
 int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_munmap' alias between fu=
nctions of incompatible types 'long int(long unsigned int,  size_t)' {aka '=
long int(long unsigned int,  long unsigned int)'} and 'long int(long int,  =
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mmap_pgoff' alias betwee=
n functions of incompatible types 'long int(long unsigned int,  long unsign=
ed int,  long unsigned int,  long unsigned int,  long unsigned int,  long u=
nsigned int)' and 'long int(long int,  long int,  long int,  long int,  lon=
g int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mprotect' alias between =
functions of incompatible types 'long int(long unsigned int,  size_t,  long=
 unsigned int)' {aka 'long int(long unsigned int,  long unsigned int,  long=
 unsigned int)'} and 'long int(long int,  long int,  long int)' [-Wattribut=
e-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pipe2' alias between fun=
ctions of incompatible types 'long int(int *, int)' and 'long int(long int,=
  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pipe' alias between func=
tions of incompatible types 'long int(int *)' and 'long int(long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mremap' alias between fu=
nctions of incompatible types 'long int(long unsigned int,  long unsigned i=
nt,  long unsigned int,  long unsigned int,  long unsigned int)' and 'long =
int(long int,  long int,  long int,  long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_msync' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  size_t,  int)' {=
aka 'long int(long unsigned int,  long unsigned int,  int)'} and 'long int(=
long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mknodat' alias between f=
unctions of incompatible types 'long int(int,  const char *, umode_t,  unsi=
gned int)' {aka 'long int(int,  const char *, short unsigned int,  unsigned=
 int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattrib=
ute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rename' alias between fu=
nctions of incompatible types 'long int(const char *, const char *)' and 'l=
ong int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_renameat' alias between =
functions of incompatible types 'long int(int,  const char *, int,  const c=
har *)' and 'long int(long int,  long int,  long int,  long int)' [-Wattrib=
ute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_renameat2' alias between=
 functions of incompatible types 'long int(int,  const char *, int,  const =
char *, unsigned int)' and 'long int(long int,  long int,  long int,  long =
int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_link' alias between func=
tions of incompatible types 'long int(const char *, const char *)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_linkat' alias between fu=
nctions of incompatible types 'long int(int,  const char *, int,  const cha=
r *, int)' and 'long int(long int,  long int,  long int,  long int,  long i=
nt)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_symlink' alias between f=
unctions of incompatible types 'long int(const char *, const char *)' and '=
long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_symlinkat' alias between=
 functions of incompatible types 'long int(const char *, int,  const char *=
)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_unlink' alias between fu=
nctions of incompatible types 'long int(const char *)' and 'long int(long i=
nt)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_unlinkat' alias between =
functions of incompatible types 'long int(int,  const char *, int)' and 'lo=
ng int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rmdir' alias between fun=
ctions of incompatible types 'long int(const char *)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mkdir' alias between fun=
ctions of incompatible types 'long int(const char *, umode_t)' {aka 'long i=
nt(const char *, short unsigned int)'} and 'long int(long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mkdirat' alias between f=
unctions of incompatible types 'long int(int,  const char *, umode_t)' {aka=
 'long int(int,  const char *, short unsigned int)'} and 'long int(long int=
,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mknod' alias between fun=
ctions of incompatible types 'long int(const char *, umode_t,  unsigned int=
)' {aka 'long int(const char *, short unsigned int,  unsigned int)'} and 'l=
ong int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fcntl' alias between fun=
ctions of incompatible types 'long int(unsigned int,  unsigned int,  long u=
nsigned int)' and 'long int(long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/syscalls.h:195:18: warning: 'sys_ioctl' alias between fun=
ctions of incompatible types 'long int(unsigned int,  unsigned int,  long u=
nsigned int)' and 'long int(long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/syscalls.h:195:18: warning: 'sys_old_readdir' alias betwe=
en functions of incompatible types 'long int(unsigned int,  struct old_linu=
x_dirent *, unsigned int)' and 'long int(long int,  long int,  long int)' [=
-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getdents64' alias betwee=
n functions of incompatible types 'long int(unsigned int,  struct linux_dir=
ent64 *, unsigned int)' and 'long int(long int,  long int,  long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getdents' alias between =
functions of incompatible types 'long int(unsigned int,  struct linux_diren=
t *, unsigned int)' and 'long int(long int,  long int,  long int)' [-Wattri=
bute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_select' alias between fu=
nctions of incompatible types 'long int(int,  fd_set *, fd_set *, fd_set *,=
 struct timeval *)' {aka 'long int(int,  struct <anonymous> *, struct <anon=
ymous> *, struct <anonymous> *, struct timeval *)'} and 'long int(long int,=
  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ppoll' alias between fun=
ctions of incompatible types 'long int(struct pollfd *, unsigned int,  stru=
ct timespec *, const sigset_t *, size_t)' {aka 'long int(struct pollfd *, u=
nsigned int,  struct timespec *, const struct <anonymous> *, long unsigned =
int)'} and 'long int(long int,  long int,  long int,  long int,  long int)'=
 [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_poll' alias between func=
tions of incompatible types 'long int(struct pollfd *, unsigned int,  int)'=
 and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pselect6' alias between =
functions of incompatible types 'long int(int,  fd_set *, fd_set *, fd_set =
*, struct timespec *, void *)' {aka 'long int(int,  struct <anonymous> *, s=
truct <anonymous> *, struct <anonymous> *, struct timespec *, void *)'} and=
 'long int(long int,  long int,  long int,  long int,  long int,  long int)=
' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getcwd' alias between fu=
nctions of incompatible types 'long int(char *, long unsigned int)' and 'lo=
ng int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_nice' alias between func=
tions of incompatible types 'long int(int)' and 'long int(long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_rr_get_interval' a=
lias between functions of incompatible types 'long int(pid_t,  struct times=
pec *)' {aka 'long int(int,  struct timespec *)'} and 'long int(long int,  =
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_get_priority_min' =
alias between functions of incompatible types 'long int(int)' and 'long int=
(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_get_priority_max' =
alias between functions of incompatible types 'long int(int)' and 'long int=
(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_getaffinity' alias=
 between functions of incompatible types 'long int(pid_t,  unsigned int,  l=
ong unsigned int *)' {aka 'long int(int,  unsigned int,  long unsigned int =
*)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_setaffinity' alias=
 between functions of incompatible types 'long int(pid_t,  unsigned int,  l=
ong unsigned int *)' {aka 'long int(int,  unsigned int,  long unsigned int =
*)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_getattr' alias bet=
ween functions of incompatible types 'long int(pid_t,  struct sched_attr *,=
 unsigned int,  unsigned int)' {aka 'long int(int,  struct sched_attr *, un=
signed int,  unsigned int)'} and 'long int(long int,  long int,  long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_getparam' alias be=
tween functions of incompatible types 'long int(pid_t,  struct sched_param =
*)' {aka 'long int(int,  struct sched_param *)'} and 'long int(long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_getscheduler' alia=
s between functions of incompatible types 'long int(pid_t)' {aka 'long int(=
int)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_setattr' alias bet=
ween functions of incompatible types 'long int(pid_t,  struct sched_attr *,=
 unsigned int)' {aka 'long int(int,  struct sched_attr *, unsigned int)'} a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_setparam' alias be=
tween functions of incompatible types 'long int(pid_t,  struct sched_param =
*)' {aka 'long int(int,  struct sched_param *)'} and 'long int(long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_setscheduler' alia=
s between functions of incompatible types 'long int(pid_t,  int,  struct sc=
hed_param *)' {aka 'long int(int,  int,  struct sched_param *)'} and 'long =
int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_dup3' alias between func=
tions of incompatible types 'long int(unsigned int,  unsigned int,  int)' a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_dup' alias between funct=
ions of incompatible types 'long int(unsigned int)' and 'long int(long int)=
' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_dup2' alias between func=
tions of incompatible types 'long int(unsigned int,  unsigned int)' and 'lo=
ng int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_umount' alias between fu=
nctions of incompatible types 'long int(char *, int)' and 'long int(long in=
t,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pivot_root' alias betwee=
n functions of incompatible types 'long int(const char *, const char *)' an=
d 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mount' alias between fun=
ctions of incompatible types 'long int(char *, char *, char *, long unsigne=
d int,  void *)' and 'long int(long int,  long int,  long int,  long int,  =
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_oldumount' alias between=
 functions of incompatible types 'long int(char *)' and 'long int(long int)=
' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setxattr' alias between =
functions of incompatible types 'long int(const char *, const char *, const=
 void *, size_t,  int)' {aka 'long int(const char *, const char *, const vo=
id *, long unsigned int,  int)'} and 'long int(long int,  long int,  long i=
nt,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fremovexattr' alias betw=
een functions of incompatible types 'long int(int,  const char *)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lremovexattr' alias betw=
een functions of incompatible types 'long int(const char *, const char *)' =
and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_removexattr' alias betwe=
en functions of incompatible types 'long int(const char *, const char *)' a=
nd 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_flistxattr' alias betwee=
n functions of incompatible types 'long int(int,  char *, size_t)' {aka 'lo=
ng int(int,  char *, long unsigned int)'} and 'long int(long int,  long int=
,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_llistxattr' alias betwee=
n functions of incompatible types 'long int(const char *, char *, size_t)' =
{aka 'long int(const char *, char *, long unsigned int)'} and 'long int(lon=
g int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_listxattr' alias between=
 functions of incompatible types 'long int(const char *, char *, size_t)' {=
aka 'long int(const char *, char *, long unsigned int)'} and 'long int(long=
 int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fgetxattr' alias between=
 functions of incompatible types 'long int(int,  const char *, void *, size=
_t)' {aka 'long int(int,  const char *, void *, long unsigned int)'} and 'l=
ong int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lgetxattr' alias between=
 functions of incompatible types 'long int(const char *, const char *, void=
 *, size_t)' {aka 'long int(const char *, const char *, void *, long unsign=
ed int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getxattr' alias between =
functions of incompatible types 'long int(const char *, const char *, void =
*, size_t)' {aka 'long int(const char *, const char *, void *, long unsigne=
d int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattri=
bute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fsetxattr' alias between=
 functions of incompatible types 'long int(int,  const char *, const void *=
, size_t,  int)' {aka 'long int(int,  const char *, const void *, long unsi=
gned int,  int)'} and 'long int(long int,  long int,  long int,  long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lsetxattr' alias between=
 functions of incompatible types 'long int(const char *, const char *, cons=
t void *, size_t,  int)' {aka 'long int(const char *, const char *, const v=
oid *, long unsigned int,  int)'} and 'long int(long int,  long int,  long =
int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_alarm' alias between fun=
ctions of incompatible types 'long int(unsigned int)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_nanosleep' alias between=
 functions of incompatible types 'long int(struct timespec *, struct timesp=
ec *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getitimer' alias between=
 functions of incompatible types 'long int(int,  struct itimerval *)' and '=
long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setitimer' alias between=
 functions of incompatible types 'long int(int,  struct itimerval *, struct=
 itimerval *)' and 'long int(long int,  long int,  long int)' [-Wattribute-=
alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_create' alias betw=
een functions of incompatible types 'long int(const clockid_t,  struct sige=
vent *, timer_t *)' {aka 'long int(const int,  struct sigevent *, int *)'} =
and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_nanosleep' alias b=
etween functions of incompatible types 'long int(const clockid_t,  int,  co=
nst struct timespec *, struct timespec *)' {aka 'long int(const int,  int, =
 const struct timespec *, struct timespec *)'} and 'long int(long int,  lon=
g int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_getres' alias betw=
een functions of incompatible types 'long int(const clockid_t,  struct time=
spec *)' {aka 'long int(const int,  struct timespec *)'} and 'long int(long=
 int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_adjtime' alias bet=
ween functions of incompatible types 'long int(const clockid_t,  struct tim=
ex *)' {aka 'long int(const int,  struct timex *)'} and 'long int(long int,=
  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_gettime' alias bet=
ween functions of incompatible types 'long int(const clockid_t,  struct tim=
espec *)' {aka 'long int(const int,  struct timespec *)'} and 'long int(lon=
g int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_settime' alias bet=
ween functions of incompatible types 'long int(const clockid_t,  const stru=
ct timespec *)' {aka 'long int(const int,  const struct timespec *)'} and '=
long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_delete' alias betw=
een functions of incompatible types 'long int(timer_t)' {aka 'long int(int)=
'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_settime' alias bet=
ween functions of incompatible types 'long int(timer_t,  int,  const struct=
 itimerspec *, struct itimerspec *)' {aka 'long int(int,  int,  const struc=
t itimerspec *, struct itimerspec *)'} and 'long int(long int,  long int,  =
long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_getoverrun' alias =
between functions of incompatible types 'long int(timer_t)' {aka 'long int(=
int)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_gettime' alias bet=
ween functions of incompatible types 'long int(timer_t,  struct itimerspec =
*)' {aka 'long int(int,  struct itimerspec *)'} and 'long int(long int,  lo=
ng int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_syncfs' alias between fu=
nctions of incompatible types 'long int(int)' and 'long int(long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sync_file_range2' alias =
between functions of incompatible types 'long int(int,  unsigned int,  loff=
_t,  loff_t)' {aka 'long int(int,  unsigned int,  long long int,  long long=
 int)'} and 'long int(long int,  long int,  long long int,  long long int)'=
 [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sync_file_range' alias b=
etween functions of incompatible types 'long int(int,  loff_t,  loff_t,  un=
signed int)' {aka 'long int(int,  long long int,  long long int,  unsigned =
int)'} and 'long int(long int,  long long int,  long long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fdatasync' alias between=
 functions of incompatible types 'long int(unsigned int)' and 'long int(lon=
g int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fsync' alias between fun=
ctions of incompatible types 'long int(unsigned int)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_vmsplice' alias between =
functions of incompatible types 'long int(int,  const struct iovec *, long =
unsigned int,  unsigned int)' and 'long int(long int,  long int,  long int,=
  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_tee' alias between funct=
ions of incompatible types 'long int(int,  int,  size_t,  unsigned int)' {a=
ka 'long int(int,  int,  long unsigned int,  unsigned int)'} and 'long int(=
long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_splice' alias between fu=
nctions of incompatible types 'long int(int,  loff_t *, int,  loff_t *, siz=
e_t,  unsigned int)' {aka 'long int(int,  long long int *, int,  long long =
int *, long unsigned int,  unsigned int)'} and 'long int(long int,  long in=
t,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_utime' alias between fun=
ctions of incompatible types 'long int(char *, struct utimbuf *)' and 'long=
 int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_utimes' alias between fu=
nctions of incompatible types 'long int(char *, struct timeval *)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_futimesat' alias between=
 functions of incompatible types 'long int(int,  const char *, struct timev=
al *)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_utimensat' alias between=
 functions of incompatible types 'long int(int,  const char *, struct times=
pec *, int)' and 'long int(long int,  long int,  long int,  long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_statfs' alias between fu=
nctions of incompatible types 'long int(const char *, struct statfs *)' and=
 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ustat' alias between fun=
ctions of incompatible types 'long int(unsigned int,  struct ustat *)' and =
'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fstatfs64' alias between=
 functions of incompatible types 'long int(unsigned int,  size_t,  struct s=
tatfs64 *)' {aka 'long int(unsigned int,  long unsigned int,  struct statfs=
64 *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fstatfs' alias between f=
unctions of incompatible types 'long int(unsigned int,  struct statfs *)' a=
nd 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_statfs64' alias between =
functions of incompatible types 'long int(const char *, size_t,  struct sta=
tfs64 *)' {aka 'long int(const char *, long unsigned int,  struct statfs64 =
*)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_time' alias between func=
tions of incompatible types 'long int(time_t *)' {aka 'long int(long int *)=
'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_adjtimex' alias between =
functions of incompatible types 'long int(struct timex *)' and 'long int(lo=
ng int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_settimeofday' alias betw=
een functions of incompatible types 'long int(struct timeval *, struct time=
zone *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_gettimeofday' alias betw=
een functions of incompatible types 'long int(struct timeval *, struct time=
zone *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_stime' alias between fun=
ctions of incompatible types 'long int(time_t *)' {aka 'long int(long int *=
)'} and 'long int(long int)' [-Wattribute-alias]
    arch/x86/vdso/vclock_gettime.c:352:5: warning: 'time' alias between fun=
ctions of incompatible types 'int(time_t *)' {aka 'int(long int *)'} and 't=
ime_t(time_t *)' {aka 'long int(long int *)'} [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getrandom' alias between=
 functions of incompatible types 'long int(char *, size_t,  unsigned int)' =
{aka 'long int(char *, long unsigned int,  unsigned int)'} and 'long int(lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    lib/string_helpers.c:64:33: warning: '%03lld' directive output may be t=
runcated writing between 3 and 13 bytes into a region of size 7 [-Wformat-t=
runcation=3D]

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section m=
ismatches

Warnings:
    arch/x86/kernel/head_32.S:672: Warning: ignoring fill value in section =
`.bss..page_aligned'
    arch/x86/kernel/head_32.S:677: Warning: ignoring fill value in section =
`.bss..page_aligned'
    arch/x86/kernel/head_32.S:679: Warning: ignoring fill value in section =
`.bss..page_aligned'

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
ape6evm_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sectio=
n mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
armadillo800eva_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
at91rm9200_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
at91sam9260_9g20_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
at91sam9261_9g10_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
at91sam9263_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
at91sam9g45_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
at91sam9rl_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
at91x40_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
bcm_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 5 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/swiotlb.h:45:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:49:28: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:53:27: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:67:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:65:63: error: 'struct page' declared inside par=
ameter list will not be visible outside of this definition or declaration [=
-Werror]
    include/linux/swiotlb.h:70:29: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:75:14: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:79:9: error: 'enum dma_data_direction' declared=
 inside parameter list will not be visible outside of this definition or de=
claration [-Werror]
    include/linux/swiotlb.h:83:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:87:27: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:92:26: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:96:21: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:100:29: error: 'enum dma_data_direction' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration [-Werror]
    include/linux/swiotlb.h:104:24: error: 'enum dma_data_direction' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration [-Werror]
    include/linux/swiotlb.h:113:20: error: expected '=3D', ',', ';', 'asm' =
or '__attribute__' before 'swiotlb_free'
    arch/mips/sibyte/common/dma.c:11:13: error: expected '=3D', ',', ';', '=
asm' or '__attribute__' before 'plat_swiotlb_setup'

Warnings:
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_B=
OARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_B=
OARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_B=
OARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_B=
OARD)
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
bockw_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings=
, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0=
 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sectio=
n mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
fpga_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings, 0 section=
 mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
fpga_noramfs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 3 errors, 8 warnings, 0=
 section mismatches

Errors:
    arch/arc/mm/tlbex.S:291: Error: unknown opcode 'lsl'
    arch/arc/mm/tlbex.S:348: Error: unknown opcode 'lsl'
    arch/arc/include/asm/uaccess.h:676:2: error: impossible constraint in '=
asm'

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    mm/memory.c:581:7: warning: assignment to 'pgtable_t' {aka 'long unsign=
ed int'} from 'void *' makes integer from pointer without a cast [-Wint-con=
version]
    mm/mmap.c:684:2: warning: 'rb_link' may be used uninitialized in this f=
unction [-Wmaybe-uninitialized]
    mm/mmap.c:684:2: warning: 'rb_parent' may be used uninitialized in this=
 function [-Wmaybe-uninitialized]
    mm/mmap.c:683:2: warning: 'prev' may be used uninitialized in this func=
tion [-Wmaybe-uninitialized]
    include/linux/kernel.h:707:17: warning: comparison of distinct pointer =
types lacks a cast

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sectio=
n mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sectio=
n mismatches

Warnings:
    arch/x86/kernel/head_32.S:672: Warning: ignoring fill value in section =
`.bss..page_aligned'
    arch/x86/kernel/head_32.S:677: Warning: ignoring fill value in section =
`.bss..page_aligned'
    arch/x86/kernel/head_32.S:679: Warning: ignoring fill value in section =
`.bss..page_aligned'

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
koelsch_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
kzm9g_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 8 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]

---------------------------------------------------------------------------=
-----
lager_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
ls1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
mackerel_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    include/linux/sh_intc.h:99:63: warning: division 'sizeof (void *) / siz=
eof (void)' does not compute the number of array elements [-Wsizeof-pointer=
-div]
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnin=
gs, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings=
, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
marzen_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings=
, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
msm_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]
    drivers/mfd/omap-usb-tll.c:88:53: warning: overflow in conversion from =
'int' to 'u8' {aka 'unsigned char'} changes value from 'i * 256 + 2070' to =
'22' [-Woverflow]

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise compari=
son always evaluates to false [-Werror=3Dtautological-compare]

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warning=
s, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
realview-smp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 5 warnings,=
 0 section mismatches

Errors:
    include/linux/swiotlb.h:45:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:49:28: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:53:27: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:67:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:65:63: error: 'struct page' declared inside par=
ameter list will not be visible outside of this definition or declaration [=
-Werror]
    include/linux/swiotlb.h:70:29: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:75:14: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:79:9: error: 'enum dma_data_direction' declared=
 inside parameter list will not be visible outside of this definition or de=
claration [-Werror]
    include/linux/swiotlb.h:83:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:87:27: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:92:26: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:96:21: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:100:29: error: 'enum dma_data_direction' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration [-Werror]
    include/linux/swiotlb.h:104:24: error: 'enum dma_data_direction' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration [-Werror]
    include/linux/swiotlb.h:113:20: error: expected '=3D', ',', ';', 'asm' =
or '__attribute__' before 'swiotlb_free'
    arch/mips/sibyte/common/dma.c:11:13: error: expected '=3D', ',', ';', '=
asm' or '__attribute__' before 'plat_swiotlb_setup'

Warnings:
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_B=
OARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_B=
OARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_B=
OARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_B=
OARD)
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
sead3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
sead3micro_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another ISA =
mode
    arch/mips/kernel/genex.S:234: Error: branch to a symbol in another ISA =
mode

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section mi=
smatches

Warnings:
    arch/x86/kernel/head_32.S:672: Warning: ignoring fill value in section =
`.bss..page_aligned'
    arch/x86/kernel/head_32.S:677: Warning: ignoring fill value in section =
`.bss..page_aligned'
    arch/x86/kernel/head_32.S:679: Warning: ignoring fill value in section =
`.bss..page_aligned'

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 215 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/syscalls.h:195:18: warning: 'sys_iopl' alias between func=
tions of incompatible types 'long int(unsigned int)' and 'long int(long int=
)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_personality' alias betwe=
en functions of incompatible types 'long int(unsigned int)' and 'long int(l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_set_tid_address' alias b=
etween functions of incompatible types 'long int(int *)' and 'long int(long=
 int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_unshare' alias between f=
unctions of incompatible types 'long int(long unsigned int)' and 'long int(=
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clone' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  long unsigned in=
t,  int *, int *, int)' and 'long int(long int,  long int,  long int,  long=
 int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_exit' alias between func=
tions of incompatible types 'long int(int)' and 'long int(long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_waitpid' alias between f=
unctions of incompatible types 'long int(pid_t,  int *, int)' {aka 'long in=
t(int,  int *, int)'} and 'long int(long int,  long int,  long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_wait4' alias between fun=
ctions of incompatible types 'long int(pid_t,  int *, int,  struct rusage *=
)' {aka 'long int(int,  int *, int,  struct rusage *)'} and 'long int(long =
int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_waitid' alias between fu=
nctions of incompatible types 'long int(int,  pid_t,  struct siginfo *, int=
,  struct rusage *)' {aka 'long int(int,  int,  struct siginfo *, int,  str=
uct rusage *)'} and 'long int(long int,  long int,  long int,  long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_exit_group' alias betwee=
n functions of incompatible types 'long int(int)' and 'long int(long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sysctl' alias between fu=
nctions of incompatible types 'long int(struct __sysctl_args *)' and 'long =
int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_capget' alias between fu=
nctions of incompatible types 'long int(struct __user_cap_header_struct *, =
struct __user_cap_data_struct *)' and 'long int(long int,  long int)' [-Wat=
tribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_capset' alias between fu=
nctions of incompatible types 'long int(struct __user_cap_header_struct *, =
struct __user_cap_data_struct * const)' and 'long int(long int,  long int)'=
 [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_readahead' alias between=
 functions of incompatible types 'long int(int,  loff_t,  size_t)' {aka 'lo=
ng int(int,  long long int,  long unsigned int)'} and 'long int(long int,  =
long long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mmap' alias between func=
tions of incompatible types 'long int(long unsigned int,  long unsigned int=
,  long unsigned int,  long unsigned int,  long unsigned int,  long unsigne=
d int)' and 'long int(long int,  long int,  long int,  long int,  long int,=
  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ptrace' alias between fu=
nctions of incompatible types 'long int(long int,  long int,  long unsigned=
 int,  long unsigned int)' and 'long int(long int,  long int,  long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigprocmask' alias be=
tween functions of incompatible types 'long int(int,  sigset_t *, sigset_t =
*, size_t)' {aka 'long int(int,  struct <anonymous> *, struct <anonymous> *=
, long unsigned int)'} and 'long int(long int,  long int,  long int,  long =
int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigsuspend' alias bet=
ween functions of incompatible types 'long int(sigset_t *, size_t)' {aka 'l=
ong int(struct <anonymous> *, long unsigned int)'} and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_signal' alias between fu=
nctions of incompatible types 'long int(int,  void (*)(int))' and 'long int=
(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigaction' alias betw=
een functions of incompatible types 'long int(int,  const struct sigaction =
*, struct sigaction *, size_t)' {aka 'long int(int,  const struct sigaction=
 *, struct sigaction *, long unsigned int)'} and 'long int(long int,  long =
int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sigprocmask' alias betwe=
en functions of incompatible types 'long int(int,  old_sigset_t *, old_sigs=
et_t *)' {aka 'long int(int,  long unsigned int *, long unsigned int *)'} a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sigpending' alias betwee=
n functions of incompatible types 'long int(old_sigset_t *)' {aka 'long int=
(long unsigned int *)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sigaltstack' alias betwe=
en functions of incompatible types 'long int(const stack_t *, stack_t *)' {=
aka 'long int(const struct sigaltstack *, struct sigaltstack *)'} and 'long=
 int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_tgsigqueueinfo' alias=
 between functions of incompatible types 'long int(pid_t,  pid_t,  int,  si=
ginfo_t *)' {aka 'long int(int,  int,  int,  struct siginfo *)'} and 'long =
int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigqueueinfo' alias b=
etween functions of incompatible types 'long int(pid_t,  int,  siginfo_t *)=
' {aka 'long int(int,  int,  struct siginfo *)'} and 'long int(long int,  l=
ong int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_tkill' alias between fun=
ctions of incompatible types 'long int(pid_t,  int)' {aka 'long int(int,  i=
nt)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_tgkill' alias between fu=
nctions of incompatible types 'long int(pid_t,  pid_t,  int)' {aka 'long in=
t(int,  int,  int)'} and 'long int(long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_kill' alias between func=
tions of incompatible types 'long int(pid_t,  int)' {aka 'long int(int,  in=
t)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigtimedwait' alias b=
etween functions of incompatible types 'long int(const sigset_t *, siginfo_=
t *, const struct timespec *, size_t)' {aka 'long int(const struct <anonymo=
us> *, struct siginfo *, const struct timespec *, long unsigned int)'} and =
'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigpending' alias bet=
ween functions of incompatible types 'long int(sigset_t *, size_t)' {aka 'l=
ong int(struct <anonymous> *, long unsigned int)'} and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setpriority' alias betwe=
en functions of incompatible types 'long int(int,  int,  int)' and 'long in=
t(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sysinfo' alias between f=
unctions of incompatible types 'long int(struct sysinfo *)' and 'long int(l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getcpu' alias between fu=
nctions of incompatible types 'long int(unsigned int *, unsigned int *, str=
uct getcpu_cache *)' and 'long int(long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_prctl' alias between fun=
ctions of incompatible types 'long int(int,  long unsigned int,  long unsig=
ned int,  long unsigned int,  long unsigned int)' and 'long int(long int,  =
long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_umask' alias between fun=
ctions of incompatible types 'long int(int)' and 'long int(long int)' [-Wat=
tribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getrusage' alias between=
 functions of incompatible types 'long int(int,  struct rusage *)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setrlimit' alias between=
 functions of incompatible types 'long int(unsigned int,  struct rlimit *)'=
 and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_prlimit64' alias between=
 functions of incompatible types 'long int(pid_t,  unsigned int,  const str=
uct rlimit64 *, struct rlimit64 *)' {aka 'long int(int,  unsigned int,  con=
st struct rlimit64 *, struct rlimit64 *)'} and 'long int(long int,  long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_old_getrlimit' alias bet=
ween functions of incompatible types 'long int(unsigned int,  struct rlimit=
 *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getrlimit' alias between=
 functions of incompatible types 'long int(unsigned int,  struct rlimit *)'=
 and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setdomainname' alias bet=
ween functions of incompatible types 'long int(char *, int)' and 'long int(=
long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_gethostname' alias betwe=
en functions of incompatible types 'long int(char *, int)' and 'long int(lo=
ng int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sethostname' alias betwe=
en functions of incompatible types 'long int(char *, int)' and 'long int(lo=
ng int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_olduname' alias between =
functions of incompatible types 'long int(struct oldold_utsname *)' and 'lo=
ng int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_uname' alias between fun=
ctions of incompatible types 'long int(struct old_utsname *)' and 'long int=
(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_newuname' alias between =
functions of incompatible types 'long int(struct new_utsname *)' and 'long =
int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getsid' alias between fu=
nctions of incompatible types 'long int(pid_t)' {aka 'long int(int)'} and '=
long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getpgid' alias between f=
unctions of incompatible types 'long int(pid_t)' {aka 'long int(int)'} and =
'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setpgid' alias between f=
unctions of incompatible types 'long int(pid_t,  pid_t)' {aka 'long int(int=
,  int)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_times' alias between fun=
ctions of incompatible types 'long int(struct tms *)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setfsgid' alias between =
functions of incompatible types 'long int(gid_t)' {aka 'long int(unsigned i=
nt)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setfsuid' alias between =
functions of incompatible types 'long int(uid_t)' {aka 'long int(unsigned i=
nt)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getresgid' alias between=
 functions of incompatible types 'long int(gid_t *, gid_t *, gid_t *)' {aka=
 'long int(unsigned int *, unsigned int *, unsigned int *)'} and 'long int(=
long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setresgid' alias between=
 functions of incompatible types 'long int(gid_t,  gid_t,  gid_t)' {aka 'lo=
ng int(unsigned int,  unsigned int,  unsigned int)'} and 'long int(long int=
,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getresuid' alias between=
 functions of incompatible types 'long int(uid_t *, uid_t *, uid_t *)' {aka=
 'long int(unsigned int *, unsigned int *, unsigned int *)'} and 'long int(=
long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setresuid' alias between=
 functions of incompatible types 'long int(uid_t,  uid_t,  uid_t)' {aka 'lo=
ng int(unsigned int,  unsigned int,  unsigned int)'} and 'long int(long int=
,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setuid' alias between fu=
nctions of incompatible types 'long int(uid_t)' {aka 'long int(unsigned int=
)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setreuid' alias between =
functions of incompatible types 'long int(uid_t,  uid_t)' {aka 'long int(un=
signed int,  unsigned int)'} and 'long int(long int,  long int)' [-Wattribu=
te-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setgid' alias between fu=
nctions of incompatible types 'long int(gid_t)' {aka 'long int(unsigned int=
)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setregid' alias between =
functions of incompatible types 'long int(gid_t,  gid_t)' {aka 'long int(un=
signed int,  unsigned int)'} and 'long int(long int,  long int)' [-Wattribu=
te-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getpriority' alias betwe=
en functions of incompatible types 'long int(int,  int)' and 'long int(long=
 int,  long int)' [-Wattribute-alias]
    kernel/workqueue.c:1720:40: warning: '%d' directive output may be trunc=
ated writing between 1 and 10 bytes into a region of size between 5 and 14 =
[-Wformat-truncation=3D]
    include/linux/syscalls.h:195:18: warning: 'sys_truncate' alias between =
functions of incompatible types 'long int(const char *, long int)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_close' alias between fun=
ctions of incompatible types 'long int(unsigned int)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_creat' alias between fun=
ctions of incompatible types 'long int(const char *, umode_t)' {aka 'long i=
nt(const char *, short unsigned int)'} and 'long int(long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_openat' alias between fu=
nctions of incompatible types 'long int(int,  const char *, int,  umode_t)'=
 {aka 'long int(int,  const char *, int,  short unsigned int)'} and 'long i=
nt(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_open' alias between func=
tions of incompatible types 'long int(const char *, int,  umode_t)' {aka 'l=
ong int(const char *, int,  short unsigned int)'} and 'long int(long int,  =
long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchown' alias between fu=
nctions of incompatible types 'long int(unsigned int,  uid_t,  gid_t)' {aka=
 'long int(unsigned int,  unsigned int,  unsigned int)'} and 'long int(long=
 int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lchown' alias between fu=
nctions of incompatible types 'long int(const char *, uid_t,  gid_t)' {aka =
'long int(const char *, unsigned int,  unsigned int)'} and 'long int(long i=
nt,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chown' alias between fun=
ctions of incompatible types 'long int(const char *, uid_t,  gid_t)' {aka '=
long int(const char *, unsigned int,  unsigned int)'} and 'long int(long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchownat' alias between =
functions of incompatible types 'long int(int,  const char *, uid_t,  gid_t=
,  int)' {aka 'long int(int,  const char *, unsigned int,  unsigned int,  i=
nt)'} and 'long int(long int,  long int,  long int,  long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chmod' alias between fun=
ctions of incompatible types 'long int(const char *, umode_t)' {aka 'long i=
nt(const char *, short unsigned int)'} and 'long int(long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchmodat' alias between =
functions of incompatible types 'long int(int,  const char *, umode_t)' {ak=
a 'long int(int,  const char *, short unsigned int)'} and 'long int(long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchmod' alias between fu=
nctions of incompatible types 'long int(unsigned int,  umode_t)' {aka 'long=
 int(unsigned int,  short unsigned int)'} and 'long int(long int,  long int=
)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chroot' alias between fu=
nctions of incompatible types 'long int(const char *)' and 'long int(long i=
nt)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchdir' alias between fu=
nctions of incompatible types 'long int(unsigned int)' and 'long int(long i=
nt)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chdir' alias between fun=
ctions of incompatible types 'long int(const char *)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_access' alias between fu=
nctions of incompatible types 'long int(const char *, int)' and 'long int(l=
ong int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_faccessat' alias between=
 functions of incompatible types 'long int(int,  const char *, int)' and 'l=
ong int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fallocate' alias between=
 functions of incompatible types 'long int(int,  int,  loff_t,  loff_t)' {a=
ka 'long int(int,  int,  long long int,  long long int)'} and 'long int(lon=
g int,  long int,  long long int,  long long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ftruncate' alias between=
 functions of incompatible types 'long int(unsigned int,  long unsigned int=
)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lseek' alias between fun=
ctions of incompatible types 'long int(unsigned int,  off_t,  unsigned int)=
' {aka 'long int(unsigned int,  long int,  unsigned int)'} and 'long int(lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sendfile64' alias betwee=
n functions of incompatible types 'long int(int,  int,  loff_t *, size_t)' =
{aka 'long int(int,  int,  long long int *, long unsigned int)'} and 'long =
int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sendfile' alias between =
functions of incompatible types 'long int(int,  int,  off_t *, size_t)' {ak=
a 'long int(int,  int,  long int *, long unsigned int)'} and 'long int(long=
 int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pwritev' alias between f=
unctions of incompatible types 'long int(long unsigned int,  const struct i=
ovec *, long unsigned int,  long unsigned int,  long unsigned int)' and 'lo=
ng int(long int,  long int,  long int,  long int,  long int)' [-Wattribute-=
alias]
    include/linux/syscalls.h:195:18: warning: 'sys_preadv' alias between fu=
nctions of incompatible types 'long int(long unsigned int,  const struct io=
vec *, long unsigned int,  long unsigned int,  long unsigned int)' and 'lon=
g int(long int,  long int,  long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/syscalls.h:195:18: warning: 'sys_writev' alias between fu=
nctions of incompatible types 'long int(long unsigned int,  const struct io=
vec *, long unsigned int)' and 'long int(long int,  long int,  long int)' [=
-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_readv' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  const struct iov=
ec *, long unsigned int)' and 'long int(long int,  long int,  long int)' [-=
Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pwrite64' alias between =
functions of incompatible types 'long int(unsigned int,  const char *, size=
_t,  loff_t)' {aka 'long int(unsigned int,  const char *, long unsigned int=
,  long long int)'} and 'long int(long int,  long int,  long int,  long lon=
g int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pread64' alias between f=
unctions of incompatible types 'long int(unsigned int,  char *, size_t,  lo=
ff_t)' {aka 'long int(unsigned int,  char *, long unsigned int,  long long =
int)'} and 'long int(long int,  long int,  long int,  long long int)' [-Wat=
tribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_write' alias between fun=
ctions of incompatible types 'long int(unsigned int,  const char *, size_t)=
' {aka 'long int(unsigned int,  const char *, long unsigned int)'} and 'lon=
g int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_read' alias between func=
tions of incompatible types 'long int(unsigned int,  char *, size_t)' {aka =
'long int(unsigned int,  char *, long unsigned int)'} and 'long int(long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_llseek' alias between fu=
nctions of incompatible types 'long int(unsigned int,  long unsigned int,  =
long unsigned int,  loff_t *, unsigned int)' {aka 'long int(unsigned int,  =
long unsigned int,  long unsigned int,  long long int *, unsigned int)'} an=
d 'long int(long int,  long int,  long int,  long int,  long int)' [-Wattri=
bute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setns' alias between fun=
ctions of incompatible types 'long int(int,  int)' and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_remap_file_pages' alias =
between functions of incompatible types 'long int(long unsigned int,  long =
unsigned int,  long unsigned int,  long unsigned int,  long unsigned int)' =
and 'long int(long int,  long int,  long int,  long int,  long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_stat' alias between func=
tions of incompatible types 'long int(const char *, struct __old_kernel_sta=
t *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_readlink' alias between =
functions of incompatible types 'long int(const char *, char *, int)' and '=
long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_readlinkat' alias betwee=
n functions of incompatible types 'long int(int,  const char *, char *, int=
)' and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/syscalls.h:195:18: warning: 'sys_newfstat' alias between =
functions of incompatible types 'long int(unsigned int,  struct stat *)' an=
d 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_newfstatat' alias betwee=
n functions of incompatible types 'long int(int,  const char *, struct stat=
 *, int)' and 'long int(long int,  long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_newlstat' alias between =
functions of incompatible types 'long int(const char *, struct stat *)' and=
 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_newstat' alias between f=
unctions of incompatible types 'long int(const char *, struct stat *)' and =
'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fstat' alias between fun=
ctions of incompatible types 'long int(unsigned int,  struct __old_kernel_s=
tat *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lstat' alias between fun=
ctions of incompatible types 'long int(const char *, struct __old_kernel_st=
at *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_reboot' alias between fu=
nctions of incompatible types 'long int(int,  int,  unsigned int,  void *)'=
 and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_execve' alias between fu=
nctions of incompatible types 'long int(const char *, const char * const*, =
const char * const*)' and 'long int(long int,  long int,  long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getgroups' alias between=
 functions of incompatible types 'long int(int,  gid_t *)' {aka 'long int(i=
nt,  unsigned int *)'} and 'long int(long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_setgroups' alias between=
 functions of incompatible types 'long int(int,  gid_t *)' {aka 'long int(i=
nt,  unsigned int *)'} and 'long int(long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_pipe2' alias between fun=
ctions of incompatible types 'long int(int *, int)' and 'long int(long int,=
  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pipe' alias between func=
tions of incompatible types 'long int(int *)' and 'long int(long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mincore' alias between f=
unctions of incompatible types 'long int(long unsigned int,  size_t,  unsig=
ned char *)' {aka 'long int(long unsigned int,  long unsigned int,  unsigne=
d char *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_mlock' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  size_t)' {aka 'l=
ong int(long unsigned int,  long unsigned int)'} and 'long int(long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mlockall' alias between =
functions of incompatible types 'long int(int)' and 'long int(long int)' [-=
Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_munlock' alias between f=
unctions of incompatible types 'long int(long unsigned int,  size_t)' {aka =
'long int(long unsigned int,  long unsigned int)'} and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mknodat' alias between f=
unctions of incompatible types 'long int(int,  const char *, umode_t,  unsi=
gned int)' {aka 'long int(int,  const char *, short unsigned int,  unsigned=
 int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattrib=
ute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rename' alias between fu=
nctions of incompatible types 'long int(const char *, const char *)' and 'l=
ong int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_renameat' alias between =
functions of incompatible types 'long int(int,  const char *, int,  const c=
har *)' and 'long int(long int,  long int,  long int,  long int)' [-Wattrib=
ute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_renameat2' alias between=
 functions of incompatible types 'long int(int,  const char *, int,  const =
char *, unsigned int)' and 'long int(long int,  long int,  long int,  long =
int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_link' alias between func=
tions of incompatible types 'long int(const char *, const char *)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_linkat' alias between fu=
nctions of incompatible types 'long int(int,  const char *, int,  const cha=
r *, int)' and 'long int(long int,  long int,  long int,  long int,  long i=
nt)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_symlink' alias between f=
unctions of incompatible types 'long int(const char *, const char *)' and '=
long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_symlinkat' alias between=
 functions of incompatible types 'long int(const char *, int,  const char *=
)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_unlink' alias between fu=
nctions of incompatible types 'long int(const char *)' and 'long int(long i=
nt)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_unlinkat' alias between =
functions of incompatible types 'long int(int,  const char *, int)' and 'lo=
ng int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rmdir' alias between fun=
ctions of incompatible types 'long int(const char *)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mkdir' alias between fun=
ctions of incompatible types 'long int(const char *, umode_t)' {aka 'long i=
nt(const char *, short unsigned int)'} and 'long int(long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mkdirat' alias between f=
unctions of incompatible types 'long int(int,  const char *, umode_t)' {aka=
 'long int(int,  const char *, short unsigned int)'} and 'long int(long int=
,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mknod' alias between fun=
ctions of incompatible types 'long int(const char *, umode_t,  unsigned int=
)' {aka 'long int(const char *, short unsigned int,  unsigned int)'} and 'l=
ong int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fcntl' alias between fun=
ctions of incompatible types 'long int(unsigned int,  unsigned int,  long u=
nsigned int)' and 'long int(long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/syscalls.h:195:18: warning: 'sys_perf_event_open' alias b=
etween functions of incompatible types 'long int(struct perf_event_attr *, =
pid_t,  int,  int,  long unsigned int)' {aka 'long int(struct perf_event_at=
tr *, int,  int,  int,  long unsigned int)'} and 'long int(long int,  long =
int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_brk' alias between funct=
ions of incompatible types 'long int(long unsigned int)' and 'long int(long=
 int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_munmap' alias between fu=
nctions of incompatible types 'long int(long unsigned int,  size_t)' {aka '=
long int(long unsigned int,  long unsigned int)'} and 'long int(long int,  =
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mmap_pgoff' alias betwee=
n functions of incompatible types 'long int(long unsigned int,  long unsign=
ed int,  long unsigned int,  long unsigned int,  long unsigned int,  long u=
nsigned int)' and 'long int(long int,  long int,  long int,  long int,  lon=
g int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ioctl' alias between fun=
ctions of incompatible types 'long int(unsigned int,  unsigned int,  long u=
nsigned int)' and 'long int(long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/syscalls.h:195:18: warning: 'sys_mprotect' alias between =
functions of incompatible types 'long int(long unsigned int,  size_t,  long=
 unsigned int)' {aka 'long int(long unsigned int,  long unsigned int,  long=
 unsigned int)'} and 'long int(long int,  long int,  long int)' [-Wattribut=
e-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_old_readdir' alias betwe=
en functions of incompatible types 'long int(unsigned int,  struct old_linu=
x_dirent *, unsigned int)' and 'long int(long int,  long int,  long int)' [=
-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getdents64' alias betwee=
n functions of incompatible types 'long int(unsigned int,  struct linux_dir=
ent64 *, unsigned int)' and 'long int(long int,  long int,  long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getdents' alias between =
functions of incompatible types 'long int(unsigned int,  struct linux_diren=
t *, unsigned int)' and 'long int(long int,  long int,  long int)' [-Wattri=
bute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mremap' alias between fu=
nctions of incompatible types 'long int(long unsigned int,  long unsigned i=
nt,  long unsigned int,  long unsigned int,  long unsigned int)' and 'long =
int(long int,  long int,  long int,  long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_msync' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  size_t,  int)' {=
aka 'long int(long unsigned int,  long unsigned int,  int)'} and 'long int(=
long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_select' alias between fu=
nctions of incompatible types 'long int(int,  fd_set *, fd_set *, fd_set *,=
 struct timeval *)' {aka 'long int(int,  struct <anonymous> *, struct <anon=
ymous> *, struct <anonymous> *, struct timeval *)'} and 'long int(long int,=
  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ppoll' alias between fun=
ctions of incompatible types 'long int(struct pollfd *, unsigned int,  stru=
ct timespec *, const sigset_t *, size_t)' {aka 'long int(struct pollfd *, u=
nsigned int,  struct timespec *, const struct <anonymous> *, long unsigned =
int)'} and 'long int(long int,  long int,  long int,  long int,  long int)'=
 [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_poll' alias between func=
tions of incompatible types 'long int(struct pollfd *, unsigned int,  int)'=
 and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pselect6' alias between =
functions of incompatible types 'long int(int,  fd_set *, fd_set *, fd_set =
*, struct timespec *, void *)' {aka 'long int(int,  struct <anonymous> *, s=
truct <anonymous> *, struct <anonymous> *, struct timespec *, void *)'} and=
 'long int(long int,  long int,  long int,  long int,  long int,  long int)=
' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getcwd' alias between fu=
nctions of incompatible types 'long int(char *, long unsigned int)' and 'lo=
ng int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_dup3' alias between func=
tions of incompatible types 'long int(unsigned int,  unsigned int,  int)' a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_dup' alias between funct=
ions of incompatible types 'long int(unsigned int)' and 'long int(long int)=
' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_dup2' alias between func=
tions of incompatible types 'long int(unsigned int,  unsigned int)' and 'lo=
ng int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_umount' alias between fu=
nctions of incompatible types 'long int(char *, int)' and 'long int(long in=
t,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pivot_root' alias betwee=
n functions of incompatible types 'long int(const char *, const char *)' an=
d 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mount' alias between fun=
ctions of incompatible types 'long int(char *, char *, char *, long unsigne=
d int,  void *)' and 'long int(long int,  long int,  long int,  long int,  =
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_oldumount' alias between=
 functions of incompatible types 'long int(char *)' and 'long int(long int)=
' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setxattr' alias between =
functions of incompatible types 'long int(const char *, const char *, const=
 void *, size_t,  int)' {aka 'long int(const char *, const char *, const vo=
id *, long unsigned int,  int)'} and 'long int(long int,  long int,  long i=
nt,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fremovexattr' alias betw=
een functions of incompatible types 'long int(int,  const char *)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lremovexattr' alias betw=
een functions of incompatible types 'long int(const char *, const char *)' =
and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_removexattr' alias betwe=
en functions of incompatible types 'long int(const char *, const char *)' a=
nd 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_flistxattr' alias betwee=
n functions of incompatible types 'long int(int,  char *, size_t)' {aka 'lo=
ng int(int,  char *, long unsigned int)'} and 'long int(long int,  long int=
,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_llistxattr' alias betwee=
n functions of incompatible types 'long int(const char *, char *, size_t)' =
{aka 'long int(const char *, char *, long unsigned int)'} and 'long int(lon=
g int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_listxattr' alias between=
 functions of incompatible types 'long int(const char *, char *, size_t)' {=
aka 'long int(const char *, char *, long unsigned int)'} and 'long int(long=
 int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fgetxattr' alias between=
 functions of incompatible types 'long int(int,  const char *, void *, size=
_t)' {aka 'long int(int,  const char *, void *, long unsigned int)'} and 'l=
ong int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lgetxattr' alias between=
 functions of incompatible types 'long int(const char *, const char *, void=
 *, size_t)' {aka 'long int(const char *, const char *, void *, long unsign=
ed int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getxattr' alias between =
functions of incompatible types 'long int(const char *, const char *, void =
*, size_t)' {aka 'long int(const char *, const char *, void *, long unsigne=
d int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattri=
bute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fsetxattr' alias between=
 functions of incompatible types 'long int(int,  const char *, const void *=
, size_t,  int)' {aka 'long int(int,  const char *, const void *, long unsi=
gned int,  int)'} and 'long int(long int,  long int,  long int,  long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lsetxattr' alias between=
 functions of incompatible types 'long int(const char *, const char *, cons=
t void *, size_t,  int)' {aka 'long int(const char *, const char *, const v=
oid *, long unsigned int,  int)'} and 'long int(long int,  long int,  long =
int,  long int,  long int)' [-Wattribute-alias]
    arch/x86/vdso/vclock_gettime.c:352:5: warning: 'time' alias between fun=
ctions of incompatible types 'int(time_t *)' {aka 'int(long int *)'} and 't=
ime_t(time_t *)' {aka 'long int(long int *)'} [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_nice' alias between func=
tions of incompatible types 'long int(int)' and 'long int(long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_rr_get_interval' a=
lias between functions of incompatible types 'long int(pid_t,  struct times=
pec *)' {aka 'long int(int,  struct timespec *)'} and 'long int(long int,  =
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_get_priority_min' =
alias between functions of incompatible types 'long int(int)' and 'long int=
(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_get_priority_max' =
alias between functions of incompatible types 'long int(int)' and 'long int=
(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_getaffinity' alias=
 between functions of incompatible types 'long int(pid_t,  unsigned int,  l=
ong unsigned int *)' {aka 'long int(int,  unsigned int,  long unsigned int =
*)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_setaffinity' alias=
 between functions of incompatible types 'long int(pid_t,  unsigned int,  l=
ong unsigned int *)' {aka 'long int(int,  unsigned int,  long unsigned int =
*)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_getattr' alias bet=
ween functions of incompatible types 'long int(pid_t,  struct sched_attr *,=
 unsigned int,  unsigned int)' {aka 'long int(int,  struct sched_attr *, un=
signed int,  unsigned int)'} and 'long int(long int,  long int,  long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_getparam' alias be=
tween functions of incompatible types 'long int(pid_t,  struct sched_param =
*)' {aka 'long int(int,  struct sched_param *)'} and 'long int(long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_getscheduler' alia=
s between functions of incompatible types 'long int(pid_t)' {aka 'long int(=
int)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_setattr' alias bet=
ween functions of incompatible types 'long int(pid_t,  struct sched_attr *,=
 unsigned int)' {aka 'long int(int,  struct sched_attr *, unsigned int)'} a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_setparam' alias be=
tween functions of incompatible types 'long int(pid_t,  struct sched_param =
*)' {aka 'long int(int,  struct sched_param *)'} and 'long int(long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_setscheduler' alia=
s between functions of incompatible types 'long int(pid_t,  int,  struct sc=
hed_param *)' {aka 'long int(int,  int,  struct sched_param *)'} and 'long =
int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_syncfs' alias between fu=
nctions of incompatible types 'long int(int)' and 'long int(long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sync_file_range2' alias =
between functions of incompatible types 'long int(int,  unsigned int,  loff=
_t,  loff_t)' {aka 'long int(int,  unsigned int,  long long int,  long long=
 int)'} and 'long int(long int,  long int,  long long int,  long long int)'=
 [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sync_file_range' alias b=
etween functions of incompatible types 'long int(int,  loff_t,  loff_t,  un=
signed int)' {aka 'long int(int,  long long int,  long long int,  unsigned =
int)'} and 'long int(long int,  long long int,  long long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fdatasync' alias between=
 functions of incompatible types 'long int(unsigned int)' and 'long int(lon=
g int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fsync' alias between fun=
ctions of incompatible types 'long int(unsigned int)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_vmsplice' alias between =
functions of incompatible types 'long int(int,  const struct iovec *, long =
unsigned int,  unsigned int)' and 'long int(long int,  long int,  long int,=
  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_tee' alias between funct=
ions of incompatible types 'long int(int,  int,  size_t,  unsigned int)' {a=
ka 'long int(int,  int,  long unsigned int,  unsigned int)'} and 'long int(=
long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_splice' alias between fu=
nctions of incompatible types 'long int(int,  loff_t *, int,  loff_t *, siz=
e_t,  unsigned int)' {aka 'long int(int,  long long int *, int,  long long =
int *, long unsigned int,  unsigned int)'} and 'long int(long int,  long in=
t,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_utime' alias between fun=
ctions of incompatible types 'long int(char *, struct utimbuf *)' and 'long=
 int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_utimes' alias between fu=
nctions of incompatible types 'long int(char *, struct timeval *)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_futimesat' alias between=
 functions of incompatible types 'long int(int,  const char *, struct timev=
al *)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_utimensat' alias between=
 functions of incompatible types 'long int(int,  const char *, struct times=
pec *, int)' and 'long int(long int,  long int,  long int,  long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_statfs' alias between fu=
nctions of incompatible types 'long int(const char *, struct statfs *)' and=
 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ustat' alias between fun=
ctions of incompatible types 'long int(unsigned int,  struct ustat *)' and =
'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fstatfs64' alias between=
 functions of incompatible types 'long int(unsigned int,  size_t,  struct s=
tatfs64 *)' {aka 'long int(unsigned int,  long unsigned int,  struct statfs=
64 *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fstatfs' alias between f=
unctions of incompatible types 'long int(unsigned int,  struct statfs *)' a=
nd 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_statfs64' alias between =
functions of incompatible types 'long int(const char *, size_t,  struct sta=
tfs64 *)' {aka 'long int(const char *, long unsigned int,  struct statfs64 =
*)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_alarm' alias between fun=
ctions of incompatible types 'long int(unsigned int)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_nanosleep' alias between=
 functions of incompatible types 'long int(struct timespec *, struct timesp=
ec *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getitimer' alias between=
 functions of incompatible types 'long int(int,  struct itimerval *)' and '=
long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setitimer' alias between=
 functions of incompatible types 'long int(int,  struct itimerval *, struct=
 itimerval *)' and 'long int(long int,  long int,  long int)' [-Wattribute-=
alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_create' alias betw=
een functions of incompatible types 'long int(const clockid_t,  struct sige=
vent *, timer_t *)' {aka 'long int(const int,  struct sigevent *, int *)'} =
and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_nanosleep' alias b=
etween functions of incompatible types 'long int(const clockid_t,  int,  co=
nst struct timespec *, struct timespec *)' {aka 'long int(const int,  int, =
 const struct timespec *, struct timespec *)'} and 'long int(long int,  lon=
g int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_getres' alias betw=
een functions of incompatible types 'long int(const clockid_t,  struct time=
spec *)' {aka 'long int(const int,  struct timespec *)'} and 'long int(long=
 int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_adjtime' alias bet=
ween functions of incompatible types 'long int(const clockid_t,  struct tim=
ex *)' {aka 'long int(const int,  struct timex *)'} and 'long int(long int,=
  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_gettime' alias bet=
ween functions of incompatible types 'long int(const clockid_t,  struct tim=
espec *)' {aka 'long int(const int,  struct timespec *)'} and 'long int(lon=
g int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_settime' alias bet=
ween functions of incompatible types 'long int(const clockid_t,  const stru=
ct timespec *)' {aka 'long int(const int,  const struct timespec *)'} and '=
long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_delete' alias betw=
een functions of incompatible types 'long int(timer_t)' {aka 'long int(int)=
'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_settime' alias bet=
ween functions of incompatible types 'long int(timer_t,  int,  const struct=
 itimerspec *, struct itimerspec *)' {aka 'long int(int,  int,  const struc=
t itimerspec *, struct itimerspec *)'} and 'long int(long int,  long int,  =
long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_getoverrun' alias =
between functions of incompatible types 'long int(timer_t)' {aka 'long int(=
int)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_gettime' alias bet=
ween functions of incompatible types 'long int(timer_t,  struct itimerspec =
*)' {aka 'long int(int,  struct itimerspec *)'} and 'long int(long int,  lo=
ng int)' [-Wattribute-alias]
    lib/string_helpers.c:64:33: warning: '%03lld' directive output may be t=
runcated writing between 3 and 13 bytes into a region of size 7 [-Wformat-t=
runcation=3D]
    include/linux/syscalls.h:195:18: warning: 'sys_getrandom' alias between=
 functions of incompatible types 'long int(char *, size_t,  unsigned int)' =
{aka 'long int(char *, long unsigned int,  unsigned int)'} and 'long int(lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_time' alias between func=
tions of incompatible types 'long int(time_t *)' {aka 'long int(long int *)=
'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_adjtimex' alias between =
functions of incompatible types 'long int(struct timex *)' and 'long int(lo=
ng int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_settimeofday' alias betw=
een functions of incompatible types 'long int(struct timeval *, struct time=
zone *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_gettimeofday' alias betw=
een functions of incompatible types 'long int(struct timeval *, struct time=
zone *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_stime' alias between fun=
ctions of incompatible types 'long int(time_t *)' {aka 'long int(long int *=
)'} and 'long int(long int)' [-Wattribute-alias]

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    arch/arm64/kernel/vdso.c:118:6: warning: 'memcmp' reading 4 bytes from =
a region of size 1 [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 section m=
ismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 320 warnings, 0 section mi=
smatches

Errors:
    arch/arc/include/asm/uaccess.h:676:2: error: impossible constraint in '=
asm'

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    mm/memory.c:581:7: warning: assignment to 'pgtable_t' {aka 'long unsign=
ed int'} from 'void *' makes integer from pointer without a cast [-Wint-con=
version]
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    kernel/sched/core.c:2766:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    include/linux/kernel.h:707:17: warning: comparison of distinct pointer =
types lacks a cast
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 482 warnings, 0 =
section mismatches

Warnings:
    include/linux/syscalls.h:195:18: warning: 'sys_set_tid_address' alias b=
etween functions of incompatible types 'long int(int *)' and 'long int(long=
 int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_unshare' alias between f=
unctions of incompatible types 'long int(long unsigned int)' and 'long int(=
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clone' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  long unsigned in=
t,  int *, int *, int)' and 'long int(long int,  long int,  long int,  long=
 int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_personality' alias betwe=
en functions of incompatible types 'long int(unsigned int)' and 'long int(l=
ong int)' [-Wattribute-alias]
    arch/x86/vdso/vclock_gettime.c:352:5: warning: 'time' alias between fun=
ctions of incompatible types 'int(time_t *)' {aka 'int(long int *)'} and 't=
ime_t(time_t *)' {aka 'long int(long int *)'} [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_iopl' alias between func=
tions of incompatible types 'long int(unsigned int)' and 'long int(long int=
)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_exit' alias between func=
tions of incompatible types 'long int(int)' and 'long int(long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_waitpid' alias between f=
unctions of incompatible types 'long int(pid_t,  int *, int)' {aka 'long in=
t(int,  int *, int)'} and 'long int(long int,  long int,  long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_wait4' alias between fun=
ctions of incompatible types 'long int(pid_t,  int *, int,  struct rusage *=
)' {aka 'long int(int,  int *, int,  struct rusage *)'} and 'long int(long =
int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_waitid' alias between fu=
nctions of incompatible types 'long int(int,  pid_t,  struct siginfo *, int=
,  struct rusage *)' {aka 'long int(int,  int,  struct siginfo *, int,  str=
uct rusage *)'} and 'long int(long int,  long int,  long int,  long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_exit_group' alias betwee=
n functions of incompatible types 'long int(int)' and 'long int(long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sysctl' alias between fu=
nctions of incompatible types 'long int(struct __sysctl_args *)' and 'long =
int(long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sysctl' alias betwee=
n functions of incompatible types 'long int(struct compat_sysctl_args *)' a=
nd 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_capget' alias between fu=
nctions of incompatible types 'long int(struct __user_cap_header_struct *, =
struct __user_cap_data_struct *)' and 'long int(long int,  long int)' [-Wat=
tribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_capset' alias between fu=
nctions of incompatible types 'long int(struct __user_cap_header_struct *, =
struct __user_cap_data_struct * const)' and 'long int(long int,  long int)'=
 [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ptrace' alias between fu=
nctions of incompatible types 'long int(long int,  long int,  long unsigned=
 int,  long unsigned int)' and 'long int(long int,  long int,  long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_ptrace' alias betwee=
n functions of incompatible types 'long int(compat_long_t,  compat_long_t, =
 compat_long_t,  compat_long_t)' {aka 'long int(int,  int,  int,  int)'} an=
d 'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mmap' alias between func=
tions of incompatible types 'long int(long unsigned int,  long unsigned int=
,  long unsigned int,  long unsigned int,  long unsigned int,  long unsigne=
d int)' and 'long int(long int,  long int,  long int,  long int,  long int,=
  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setpriority' alias betwe=
en functions of incompatible types 'long int(int,  int,  int)' and 'long in=
t(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sysinfo' alias betwe=
en functions of incompatible types 'long int(struct compat_sysinfo *)' and =
'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sysinfo' alias between f=
unctions of incompatible types 'long int(struct sysinfo *)' and 'long int(l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getcpu' alias between fu=
nctions of incompatible types 'long int(unsigned int *, unsigned int *, str=
uct getcpu_cache *)' and 'long int(long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_prctl' alias between fun=
ctions of incompatible types 'long int(int,  long unsigned int,  long unsig=
ned int,  long unsigned int,  long unsigned int)' and 'long int(long int,  =
long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_umask' alias between fun=
ctions of incompatible types 'long int(int)' and 'long int(long int)' [-Wat=
tribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_getrusage' alias bet=
ween functions of incompatible types 'long int(int,  struct compat_rusage *=
)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getrusage' alias between=
 functions of incompatible types 'long int(int,  struct rusage *)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setrlimit' alias between=
 functions of incompatible types 'long int(unsigned int,  struct rlimit *)'=
 and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_prlimit64' alias between=
 functions of incompatible types 'long int(pid_t,  unsigned int,  const str=
uct rlimit64 *, struct rlimit64 *)' {aka 'long int(int,  unsigned int,  con=
st struct rlimit64 *, struct rlimit64 *)'} and 'long int(long int,  long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_old_getrlimit' alias bet=
ween functions of incompatible types 'long int(unsigned int,  struct rlimit=
 *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getrlimit' alias between=
 functions of incompatible types 'long int(unsigned int,  struct rlimit *)'=
 and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setdomainname' alias bet=
ween functions of incompatible types 'long int(char *, int)' and 'long int(=
long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_gethostname' alias betwe=
en functions of incompatible types 'long int(char *, int)' and 'long int(lo=
ng int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sethostname' alias betwe=
en functions of incompatible types 'long int(char *, int)' and 'long int(lo=
ng int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_olduname' alias between =
functions of incompatible types 'long int(struct oldold_utsname *)' and 'lo=
ng int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_uname' alias between fun=
ctions of incompatible types 'long int(struct old_utsname *)' and 'long int=
(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_newuname' alias between =
functions of incompatible types 'long int(struct new_utsname *)' and 'long =
int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getsid' alias between fu=
nctions of incompatible types 'long int(pid_t)' {aka 'long int(int)'} and '=
long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getpgid' alias between f=
unctions of incompatible types 'long int(pid_t)' {aka 'long int(int)'} and =
'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setpgid' alias between f=
unctions of incompatible types 'long int(pid_t,  pid_t)' {aka 'long int(int=
,  int)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_times' alias between fun=
ctions of incompatible types 'long int(struct tms *)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setfsgid' alias between =
functions of incompatible types 'long int(gid_t)' {aka 'long int(unsigned i=
nt)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setfsuid' alias between =
functions of incompatible types 'long int(uid_t)' {aka 'long int(unsigned i=
nt)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getresgid' alias between=
 functions of incompatible types 'long int(gid_t *, gid_t *, gid_t *)' {aka=
 'long int(unsigned int *, unsigned int *, unsigned int *)'} and 'long int(=
long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setresgid' alias between=
 functions of incompatible types 'long int(gid_t,  gid_t,  gid_t)' {aka 'lo=
ng int(unsigned int,  unsigned int,  unsigned int)'} and 'long int(long int=
,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getresuid' alias between=
 functions of incompatible types 'long int(uid_t *, uid_t *, uid_t *)' {aka=
 'long int(unsigned int *, unsigned int *, unsigned int *)'} and 'long int(=
long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setresuid' alias between=
 functions of incompatible types 'long int(uid_t,  uid_t,  uid_t)' {aka 'lo=
ng int(unsigned int,  unsigned int,  unsigned int)'} and 'long int(long int=
,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setuid' alias between fu=
nctions of incompatible types 'long int(uid_t)' {aka 'long int(unsigned int=
)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setreuid' alias between =
functions of incompatible types 'long int(uid_t,  uid_t)' {aka 'long int(un=
signed int,  unsigned int)'} and 'long int(long int,  long int)' [-Wattribu=
te-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setgid' alias between fu=
nctions of incompatible types 'long int(gid_t)' {aka 'long int(unsigned int=
)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setregid' alias between =
functions of incompatible types 'long int(gid_t,  gid_t)' {aka 'long int(un=
signed int,  unsigned int)'} and 'long int(long int,  long int)' [-Wattribu=
te-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getpriority' alias betwe=
en functions of incompatible types 'long int(int,  int)' and 'long int(long=
 int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigprocmask' alias be=
tween functions of incompatible types 'long int(int,  sigset_t *, sigset_t =
*, size_t)' {aka 'long int(int,  struct <anonymous> *, struct <anonymous> *=
, long unsigned int)'} and 'long int(long int,  long int,  long int,  long =
int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sigsuspend' alias betwee=
n functions of incompatible types 'long int(int,  int,  old_sigset_t)' {aka=
 'long int(int,  int,  long unsigned int)'} and 'long int(long int,  long i=
nt,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_rt_sigsuspend' alias=
 between functions of incompatible types 'long int(compat_sigset_t *, compa=
t_size_t)' {aka 'long int(struct <anonymous> *, unsigned int)'} and 'long i=
nt(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigsuspend' alias bet=
ween functions of incompatible types 'long int(sigset_t *, size_t)' {aka 'l=
ong int(struct <anonymous> *, long unsigned int)'} and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_signal' alias between fu=
nctions of incompatible types 'long int(int,  void (*)(int))' and 'long int=
(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ssetmask' alias between =
functions of incompatible types 'long int(int)' and 'long int(long int)' [-=
Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sigaction' alias bet=
ween functions of incompatible types 'long int(int,  const struct compat_ol=
d_sigaction *, struct compat_old_sigaction *)' and 'long int(long int,  lon=
g int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_rt_sigaction' alias =
between functions of incompatible types 'long int(int,  const struct compat=
_sigaction *, struct compat_sigaction *, compat_size_t)' {aka 'long int(int=
,  const struct compat_sigaction *, struct compat_sigaction *, unsigned int=
)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-=
alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigaction' alias betw=
een functions of incompatible types 'long int(int,  const struct sigaction =
*, struct sigaction *, size_t)' {aka 'long int(int,  const struct sigaction=
 *, struct sigaction *, long unsigned int)'} and 'long int(long int,  long =
int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sigprocmask' alias betwe=
en functions of incompatible types 'long int(int,  old_sigset_t *, old_sigs=
et_t *)' {aka 'long int(int,  long unsigned int *, long unsigned int *)'} a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sigpending' alias betwee=
n functions of incompatible types 'long int(old_sigset_t *)' {aka 'long int=
(long unsigned int *)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sigaltstack' alias b=
etween functions of incompatible types 'long int(const compat_stack_t *, co=
mpat_stack_t *)' {aka 'long int(const struct compat_sigaltstack *, struct c=
ompat_sigaltstack *)'} and 'long int(long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_sigaltstack' alias betwe=
en functions of incompatible types 'long int(const stack_t *, stack_t *)' {=
aka 'long int(const struct sigaltstack *, struct sigaltstack *)'} and 'long=
 int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_rt_tgsigqueueinfo' a=
lias between functions of incompatible types 'long int(compat_pid_t,  compa=
t_pid_t,  int,  struct compat_siginfo *)' {aka 'long int(int,  int,  int,  =
struct compat_siginfo *)'} and 'long int(long int,  long int,  long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_tgsigqueueinfo' alias=
 between functions of incompatible types 'long int(pid_t,  pid_t,  int,  si=
ginfo_t *)' {aka 'long int(int,  int,  int,  struct siginfo *)'} and 'long =
int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_rt_sigqueueinfo' ali=
as between functions of incompatible types 'long int(compat_pid_t,  int,  s=
truct compat_siginfo *)' {aka 'long int(int,  int,  struct compat_siginfo *=
)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigqueueinfo' alias b=
etween functions of incompatible types 'long int(pid_t,  int,  siginfo_t *)=
' {aka 'long int(int,  int,  struct siginfo *)'} and 'long int(long int,  l=
ong int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_tkill' alias between fun=
ctions of incompatible types 'long int(pid_t,  int)' {aka 'long int(int,  i=
nt)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_tgkill' alias between fu=
nctions of incompatible types 'long int(pid_t,  pid_t,  int)' {aka 'long in=
t(int,  int,  int)'} and 'long int(long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_kill' alias between func=
tions of incompatible types 'long int(pid_t,  int)' {aka 'long int(int,  in=
t)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigtimedwait' alias b=
etween functions of incompatible types 'long int(const sigset_t *, siginfo_=
t *, const struct timespec *, size_t)' {aka 'long int(const struct <anonymo=
us> *, struct siginfo *, const struct timespec *, long unsigned int)'} and =
'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_rt_sigpending' alias=
 between functions of incompatible types 'long int(compat_sigset_t *, compa=
t_size_t)' {aka 'long int(struct <anonymous> *, unsigned int)'} and 'long i=
nt(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rt_sigpending' alias bet=
ween functions of incompatible types 'long int(sigset_t *, size_t)' {aka 'l=
ong int(struct <anonymous> *, long unsigned int)'} and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_rt_sigprocmask' alia=
s between functions of incompatible types 'long int(int,  compat_sigset_t *=
, compat_sigset_t *, compat_size_t)' {aka 'long int(int,  struct <anonymous=
> *, struct <anonymous> *, unsigned int)'} and 'long int(long int,  long in=
t,  long int,  long int)' [-Wattribute-alias]
    kernel/workqueue.c:1720:40: warning: '%d' directive output may be trunc=
ated writing between 1 and 10 bytes into a region of size between 5 and 14 =
[-Wformat-truncation=3D]
    include/linux/syscalls.h:195:18: warning: 'sys_setns' alias between fun=
ctions of incompatible types 'long int(int,  int)' and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_reboot' alias between fu=
nctions of incompatible types 'long int(int,  int,  unsigned int,  void *)'=
 and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_getgroups' alias between=
 functions of incompatible types 'long int(int,  gid_t *)' {aka 'long int(i=
nt,  unsigned int *)'} and 'long int(long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_setgroups' alias between=
 functions of incompatible types 'long int(int,  gid_t *)' {aka 'long int(i=
nt,  unsigned int *)'} and 'long int(long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_set_thread_area' alias b=
etween functions of incompatible types 'long int(struct user_desc *)' and '=
long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_get_thread_area' alias b=
etween functions of incompatible types 'long int(struct user_desc *)' and '=
long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_perf_event_open' alias b=
etween functions of incompatible types 'long int(struct perf_event_attr *, =
pid_t,  int,  int,  long unsigned int)' {aka 'long int(struct perf_event_at=
tr *, int,  int,  int,  long unsigned int)'} and 'long int(long int,  long =
int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_readahead' alias between=
 functions of incompatible types 'long int(int,  loff_t,  size_t)' {aka 'lo=
ng int(int,  long long int,  long unsigned int)'} and 'long int(long int,  =
long long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_truncate' alias between =
functions of incompatible types 'long int(const char *, long int)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_close' alias between fun=
ctions of incompatible types 'long int(unsigned int)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_close' alias between fun=
ctions of incompatible types 'long int(unsigned int)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_creat' alias between fun=
ctions of incompatible types 'long int(const char *, umode_t)' {aka 'long i=
nt(const char *, short unsigned int)'} and 'long int(long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_openat' alias between fu=
nctions of incompatible types 'long int(int,  const char *, int,  umode_t)'=
 {aka 'long int(int,  const char *, int,  short unsigned int)'} and 'long i=
nt(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_open' alias between func=
tions of incompatible types 'long int(const char *, int,  umode_t)' {aka 'l=
ong int(const char *, int,  short unsigned int)'} and 'long int(long int,  =
long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchown' alias between fu=
nctions of incompatible types 'long int(unsigned int,  uid_t,  gid_t)' {aka=
 'long int(unsigned int,  unsigned int,  unsigned int)'} and 'long int(long=
 int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lchown' alias between fu=
nctions of incompatible types 'long int(const char *, uid_t,  gid_t)' {aka =
'long int(const char *, unsigned int,  unsigned int)'} and 'long int(long i=
nt,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chown' alias between fun=
ctions of incompatible types 'long int(const char *, uid_t,  gid_t)' {aka '=
long int(const char *, unsigned int,  unsigned int)'} and 'long int(long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchownat' alias between =
functions of incompatible types 'long int(int,  const char *, uid_t,  gid_t=
,  int)' {aka 'long int(int,  const char *, unsigned int,  unsigned int,  i=
nt)'} and 'long int(long int,  long int,  long int,  long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chmod' alias between fun=
ctions of incompatible types 'long int(const char *, umode_t)' {aka 'long i=
nt(const char *, short unsigned int)'} and 'long int(long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchmodat' alias between =
functions of incompatible types 'long int(int,  const char *, umode_t)' {ak=
a 'long int(int,  const char *, short unsigned int)'} and 'long int(long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchmod' alias between fu=
nctions of incompatible types 'long int(unsigned int,  umode_t)' {aka 'long=
 int(unsigned int,  short unsigned int)'} and 'long int(long int,  long int=
)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chroot' alias between fu=
nctions of incompatible types 'long int(const char *)' and 'long int(long i=
nt)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchdir' alias between fu=
nctions of incompatible types 'long int(unsigned int)' and 'long int(long i=
nt)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chdir' alias between fun=
ctions of incompatible types 'long int(const char *)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_access' alias between fu=
nctions of incompatible types 'long int(const char *, int)' and 'long int(l=
ong int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_faccessat' alias between=
 functions of incompatible types 'long int(int,  const char *, int)' and 'l=
ong int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fallocate' alias between=
 functions of incompatible types 'long int(int,  int,  loff_t,  loff_t)' {a=
ka 'long int(int,  int,  long long int,  long long int)'} and 'long int(lon=
g int,  long int,  long long int,  long long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_ftruncate' alias bet=
ween functions of incompatible types 'long int(unsigned int,  compat_ulong_=
t)' {aka 'long int(unsigned int,  unsigned int)'} and 'long int(long int,  =
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ftruncate' alias between=
 functions of incompatible types 'long int(unsigned int,  long unsigned int=
)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_truncate' alias betw=
een functions of incompatible types 'long int(const char *, compat_off_t)' =
{aka 'long int(const char *, int)'} and 'long int(long int,  long int)' [-W=
attribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lseek' alias between fun=
ctions of incompatible types 'long int(unsigned int,  off_t,  unsigned int)=
' {aka 'long int(unsigned int,  long int,  unsigned int)'} and 'long int(lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sendfile64' alias be=
tween functions of incompatible types 'long int(int,  int,  compat_loff_t *=
, compat_size_t)' {aka 'long int(int,  int,  long long int *, unsigned int)=
'} and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sendfile' alias betw=
een functions of incompatible types 'long int(int,  int,  compat_off_t *, c=
ompat_size_t)' {aka 'long int(int,  int,  int *, unsigned int)'} and 'long =
int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sendfile64' alias betwee=
n functions of incompatible types 'long int(int,  int,  loff_t *, size_t)' =
{aka 'long int(int,  int,  long long int *, long unsigned int)'} and 'long =
int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sendfile' alias between =
functions of incompatible types 'long int(int,  int,  off_t *, size_t)' {ak=
a 'long int(int,  int,  long int *, long unsigned int)'} and 'long int(long=
 int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_pwritev' alias betwe=
en functions of incompatible types 'long int(compat_ulong_t,  const struct =
compat_iovec *, compat_ulong_t,  u32,  u32)' {aka 'long int(unsigned int,  =
const struct compat_iovec *, unsigned int,  unsigned int,  unsigned int)'} =
and 'long int(long int,  long int,  long int,  long int,  long int)' [-Watt=
ribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_pwritev64' alias bet=
ween functions of incompatible types 'long int(long unsigned int,  const st=
ruct compat_iovec *, long unsigned int,  loff_t)' {aka 'long int(long unsig=
ned int,  const struct compat_iovec *, long unsigned int,  long long int)'}=
 and 'long int(long int,  long int,  long int,  long long int)' [-Wattribut=
e-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_writev' alias betwee=
n functions of incompatible types 'long int(compat_ulong_t,  const struct c=
ompat_iovec *, compat_ulong_t)' {aka 'long int(unsigned int,  const struct =
compat_iovec *, unsigned int)'} and 'long int(long int,  long int,  long in=
t)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_preadv' alias betwee=
n functions of incompatible types 'long int(compat_ulong_t,  const struct c=
ompat_iovec *, compat_ulong_t,  u32,  u32)' {aka 'long int(unsigned int,  c=
onst struct compat_iovec *, unsigned int,  unsigned int,  unsigned int)'} a=
nd 'long int(long int,  long int,  long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_preadv64' alias betw=
een functions of incompatible types 'long int(long unsigned int,  const str=
uct compat_iovec *, long unsigned int,  loff_t)' {aka 'long int(long unsign=
ed int,  const struct compat_iovec *, long unsigned int,  long long int)'} =
and 'long int(long int,  long int,  long int,  long long int)' [-Wattribute=
-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_readv' alias between=
 functions of incompatible types 'long int(compat_ulong_t,  const struct co=
mpat_iovec *, compat_ulong_t)' {aka 'long int(unsigned int,  const struct c=
ompat_iovec *, unsigned int)'} and 'long int(long int,  long int,  long int=
)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pwritev' alias between f=
unctions of incompatible types 'long int(long unsigned int,  const struct i=
ovec *, long unsigned int,  long unsigned int,  long unsigned int)' and 'lo=
ng int(long int,  long int,  long int,  long int,  long int)' [-Wattribute-=
alias]
    include/linux/syscalls.h:195:18: warning: 'sys_preadv' alias between fu=
nctions of incompatible types 'long int(long unsigned int,  const struct io=
vec *, long unsigned int,  long unsigned int,  long unsigned int)' and 'lon=
g int(long int,  long int,  long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/syscalls.h:195:18: warning: 'sys_writev' alias between fu=
nctions of incompatible types 'long int(long unsigned int,  const struct io=
vec *, long unsigned int)' and 'long int(long int,  long int,  long int)' [=
-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_readv' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  const struct iov=
ec *, long unsigned int)' and 'long int(long int,  long int,  long int)' [-=
Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pwrite64' alias between =
functions of incompatible types 'long int(unsigned int,  const char *, size=
_t,  loff_t)' {aka 'long int(unsigned int,  const char *, long unsigned int=
,  long long int)'} and 'long int(long int,  long int,  long int,  long lon=
g int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pread64' alias between f=
unctions of incompatible types 'long int(unsigned int,  char *, size_t,  lo=
ff_t)' {aka 'long int(unsigned int,  char *, long unsigned int,  long long =
int)'} and 'long int(long int,  long int,  long int,  long long int)' [-Wat=
tribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_write' alias between fun=
ctions of incompatible types 'long int(unsigned int,  const char *, size_t)=
' {aka 'long int(unsigned int,  const char *, long unsigned int)'} and 'lon=
g int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_read' alias between func=
tions of incompatible types 'long int(unsigned int,  char *, size_t)' {aka =
'long int(unsigned int,  char *, long unsigned int)'} and 'long int(long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_llseek' alias between fu=
nctions of incompatible types 'long int(unsigned int,  long unsigned int,  =
long unsigned int,  loff_t *, unsigned int)' {aka 'long int(unsigned int,  =
long unsigned int,  long unsigned int,  long long int *, unsigned int)'} an=
d 'long int(long int,  long int,  long int,  long int,  long int)' [-Wattri=
bute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_lseek' alias between=
 functions of incompatible types 'long int(unsigned int,  compat_off_t,  un=
signed int)' {aka 'long int(unsigned int,  int,  unsigned int)'} and 'long =
int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_stat' alias between func=
tions of incompatible types 'long int(const char *, struct __old_kernel_sta=
t *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_readlink' alias between =
functions of incompatible types 'long int(const char *, char *, int)' and '=
long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_readlinkat' alias betwee=
n functions of incompatible types 'long int(int,  const char *, char *, int=
)' and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/syscalls.h:195:18: warning: 'sys_newfstat' alias between =
functions of incompatible types 'long int(unsigned int,  struct stat *)' an=
d 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_newfstatat' alias betwee=
n functions of incompatible types 'long int(int,  const char *, struct stat=
 *, int)' and 'long int(long int,  long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_newlstat' alias between =
functions of incompatible types 'long int(const char *, struct stat *)' and=
 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_newstat' alias between f=
unctions of incompatible types 'long int(const char *, struct stat *)' and =
'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fstat' alias between fun=
ctions of incompatible types 'long int(unsigned int,  struct __old_kernel_s=
tat *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lstat' alias between fun=
ctions of incompatible types 'long int(const char *, struct __old_kernel_st=
at *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_syslog' alias between fu=
nctions of incompatible types 'long int(int,  char *, int)' and 'long int(l=
ong int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_memfd_create' alias betw=
een functions of incompatible types 'long int(const char *, unsigned int)' =
and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_uselib' alias between fu=
nctions of incompatible types 'long int(const char *)' and 'long int(long i=
nt)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_execve' alias betwee=
n functions of incompatible types 'long int(const char *, const compat_uptr=
_t *, const compat_uptr_t *)' {aka 'long int(const char *, const unsigned i=
nt *, const unsigned int *)'} and 'long int(long int,  long int,  long int)=
' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_execve' alias between fu=
nctions of incompatible types 'long int(const char *, const char * const*, =
const char * const*)' and 'long int(long int,  long int,  long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pipe2' alias between fun=
ctions of incompatible types 'long int(int *, int)' and 'long int(long int,=
  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pipe' alias between func=
tions of incompatible types 'long int(int *)' and 'long int(long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mknodat' alias between f=
unctions of incompatible types 'long int(int,  const char *, umode_t,  unsi=
gned int)' {aka 'long int(int,  const char *, short unsigned int,  unsigned=
 int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattrib=
ute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rename' alias between fu=
nctions of incompatible types 'long int(const char *, const char *)' and 'l=
ong int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_renameat' alias between =
functions of incompatible types 'long int(int,  const char *, int,  const c=
har *)' and 'long int(long int,  long int,  long int,  long int)' [-Wattrib=
ute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_renameat2' alias between=
 functions of incompatible types 'long int(int,  const char *, int,  const =
char *, unsigned int)' and 'long int(long int,  long int,  long int,  long =
int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_link' alias between func=
tions of incompatible types 'long int(const char *, const char *)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_linkat' alias between fu=
nctions of incompatible types 'long int(int,  const char *, int,  const cha=
r *, int)' and 'long int(long int,  long int,  long int,  long int,  long i=
nt)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_symlink' alias between f=
unctions of incompatible types 'long int(const char *, const char *)' and '=
long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_symlinkat' alias between=
 functions of incompatible types 'long int(const char *, int,  const char *=
)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_unlink' alias between fu=
nctions of incompatible types 'long int(const char *)' and 'long int(long i=
nt)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_unlinkat' alias between =
functions of incompatible types 'long int(int,  const char *, int)' and 'lo=
ng int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_rmdir' alias between fun=
ctions of incompatible types 'long int(const char *)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mkdir' alias between fun=
ctions of incompatible types 'long int(const char *, umode_t)' {aka 'long i=
nt(const char *, short unsigned int)'} and 'long int(long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mkdirat' alias between f=
unctions of incompatible types 'long int(int,  const char *, umode_t)' {aka=
 'long int(int,  const char *, short unsigned int)'} and 'long int(long int=
,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mknod' alias between fun=
ctions of incompatible types 'long int(const char *, umode_t,  unsigned int=
)' {aka 'long int(const char *, short unsigned int,  unsigned int)'} and 'l=
ong int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fcntl' alias between fun=
ctions of incompatible types 'long int(unsigned int,  unsigned int,  long u=
nsigned int)' and 'long int(long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/syscalls.h:195:18: warning: 'sys_ioctl' alias between fun=
ctions of incompatible types 'long int(unsigned int,  unsigned int,  long u=
nsigned int)' and 'long int(long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/syscalls.h:195:18: warning: 'sys_old_readdir' alias betwe=
en functions of incompatible types 'long int(unsigned int,  struct old_linu=
x_dirent *, unsigned int)' and 'long int(long int,  long int,  long int)' [=
-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getdents64' alias betwee=
n functions of incompatible types 'long int(unsigned int,  struct linux_dir=
ent64 *, unsigned int)' and 'long int(long int,  long int,  long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getdents' alias between =
functions of incompatible types 'long int(unsigned int,  struct linux_diren=
t *, unsigned int)' and 'long int(long int,  long int,  long int)' [-Wattri=
bute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_nice' alias between func=
tions of incompatible types 'long int(int)' and 'long int(long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_rr_get_interval' a=
lias between functions of incompatible types 'long int(pid_t,  struct times=
pec *)' {aka 'long int(int,  struct timespec *)'} and 'long int(long int,  =
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_get_priority_min' =
alias between functions of incompatible types 'long int(int)' and 'long int=
(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_get_priority_max' =
alias between functions of incompatible types 'long int(int)' and 'long int=
(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_getaffinity' alias=
 between functions of incompatible types 'long int(pid_t,  unsigned int,  l=
ong unsigned int *)' {aka 'long int(int,  unsigned int,  long unsigned int =
*)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_setaffinity' alias=
 between functions of incompatible types 'long int(pid_t,  unsigned int,  l=
ong unsigned int *)' {aka 'long int(int,  unsigned int,  long unsigned int =
*)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_getattr' alias bet=
ween functions of incompatible types 'long int(pid_t,  struct sched_attr *,=
 unsigned int,  unsigned int)' {aka 'long int(int,  struct sched_attr *, un=
signed int,  unsigned int)'} and 'long int(long int,  long int,  long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_getparam' alias be=
tween functions of incompatible types 'long int(pid_t,  struct sched_param =
*)' {aka 'long int(int,  struct sched_param *)'} and 'long int(long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_getscheduler' alia=
s between functions of incompatible types 'long int(pid_t)' {aka 'long int(=
int)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_setattr' alias bet=
ween functions of incompatible types 'long int(pid_t,  struct sched_attr *,=
 unsigned int)' {aka 'long int(int,  struct sched_attr *, unsigned int)'} a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_setparam' alias be=
tween functions of incompatible types 'long int(pid_t,  struct sched_param =
*)' {aka 'long int(int,  struct sched_param *)'} and 'long int(long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sched_setscheduler' alia=
s between functions of incompatible types 'long int(pid_t,  int,  struct sc=
hed_param *)' {aka 'long int(int,  int,  struct sched_param *)'} and 'long =
int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/ftrace.h:632:36: warning: calling '__builtin_return_addre=
ss' with a nonzero argument is unsafe [-Wframe-address]
    include/linux/ftrace.h:632:36: warning: calling '__builtin_return_addre=
ss' with a nonzero argument is unsafe [-Wframe-address]
    include/linux/syscalls.h:195:18: warning: 'sys_select' alias between fu=
nctions of incompatible types 'long int(int,  fd_set *, fd_set *, fd_set *,=
 struct timeval *)' {aka 'long int(int,  struct <anonymous> *, struct <anon=
ymous> *, struct <anonymous> *, struct timeval *)'} and 'long int(long int,=
  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ppoll' alias between fun=
ctions of incompatible types 'long int(struct pollfd *, unsigned int,  stru=
ct timespec *, const sigset_t *, size_t)' {aka 'long int(struct pollfd *, u=
nsigned int,  struct timespec *, const struct <anonymous> *, long unsigned =
int)'} and 'long int(long int,  long int,  long int,  long int,  long int)'=
 [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_poll' alias between func=
tions of incompatible types 'long int(struct pollfd *, unsigned int,  int)'=
 and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pselect6' alias between =
functions of incompatible types 'long int(int,  fd_set *, fd_set *, fd_set =
*, struct timespec *, void *)' {aka 'long int(int,  struct <anonymous> *, s=
truct <anonymous> *, struct <anonymous> *, struct timespec *, void *)'} and=
 'long int(long int,  long int,  long int,  long int,  long int,  long int)=
' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getcwd' alias between fu=
nctions of incompatible types 'long int(char *, long unsigned int)' and 'lo=
ng int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sysfs' alias between fun=
ctions of incompatible types 'long int(int,  long unsigned int,  long unsig=
ned int)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_dup3' alias between func=
tions of incompatible types 'long int(unsigned int,  unsigned int,  int)' a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_dup' alias between funct=
ions of incompatible types 'long int(unsigned int)' and 'long int(long int)=
' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_dup2' alias between func=
tions of incompatible types 'long int(unsigned int,  unsigned int)' and 'lo=
ng int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_remap_file_pages' alias =
between functions of incompatible types 'long int(long unsigned int,  long =
unsigned int,  long unsigned int,  long unsigned int,  long unsigned int)' =
and 'long int(long int,  long int,  long int,  long int,  long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_umount' alias between fu=
nctions of incompatible types 'long int(char *, int)' and 'long int(long in=
t,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_pivot_root' alias betwee=
n functions of incompatible types 'long int(const char *, const char *)' an=
d 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mount' alias between fun=
ctions of incompatible types 'long int(char *, char *, char *, long unsigne=
d int,  void *)' and 'long int(long int,  long int,  long int,  long int,  =
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_oldumount' alias between=
 functions of incompatible types 'long int(char *)' and 'long int(long int)=
' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setxattr' alias between =
functions of incompatible types 'long int(const char *, const char *, const=
 void *, size_t,  int)' {aka 'long int(const char *, const char *, const vo=
id *, long unsigned int,  int)'} and 'long int(long int,  long int,  long i=
nt,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fremovexattr' alias betw=
een functions of incompatible types 'long int(int,  const char *)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lremovexattr' alias betw=
een functions of incompatible types 'long int(const char *, const char *)' =
and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_removexattr' alias betwe=
en functions of incompatible types 'long int(const char *, const char *)' a=
nd 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_flistxattr' alias betwee=
n functions of incompatible types 'long int(int,  char *, size_t)' {aka 'lo=
ng int(int,  char *, long unsigned int)'} and 'long int(long int,  long int=
,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_llistxattr' alias betwee=
n functions of incompatible types 'long int(const char *, char *, size_t)' =
{aka 'long int(const char *, char *, long unsigned int)'} and 'long int(lon=
g int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_listxattr' alias between=
 functions of incompatible types 'long int(const char *, char *, size_t)' {=
aka 'long int(const char *, char *, long unsigned int)'} and 'long int(long=
 int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fgetxattr' alias between=
 functions of incompatible types 'long int(int,  const char *, void *, size=
_t)' {aka 'long int(int,  const char *, void *, long unsigned int)'} and 'l=
ong int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lgetxattr' alias between=
 functions of incompatible types 'long int(const char *, const char *, void=
 *, size_t)' {aka 'long int(const char *, const char *, void *, long unsign=
ed int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getxattr' alias between =
functions of incompatible types 'long int(const char *, const char *, void =
*, size_t)' {aka 'long int(const char *, const char *, void *, long unsigne=
d int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattri=
bute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fsetxattr' alias between=
 functions of incompatible types 'long int(int,  const char *, const void *=
, size_t,  int)' {aka 'long int(int,  const char *, const void *, long unsi=
gned int,  int)'} and 'long int(long int,  long int,  long int,  long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lsetxattr' alias between=
 functions of incompatible types 'long int(const char *, const char *, cons=
t void *, size_t,  int)' {aka 'long int(const char *, const char *, const v=
oid *, long unsigned int,  int)'} and 'long int(long int,  long int,  long =
int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mincore' alias between f=
unctions of incompatible types 'long int(long unsigned int,  size_t,  unsig=
ned char *)' {aka 'long int(long unsigned int,  long unsigned int,  unsigne=
d char *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_mlock' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  size_t)' {aka 'l=
ong int(long unsigned int,  long unsigned int)'} and 'long int(long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mlockall' alias between =
functions of incompatible types 'long int(int)' and 'long int(long int)' [-=
Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_munlock' alias between f=
unctions of incompatible types 'long int(long unsigned int,  size_t)' {aka =
'long int(long unsigned int,  long unsigned int)'} and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_syncfs' alias between fu=
nctions of incompatible types 'long int(int)' and 'long int(long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sync_file_range2' alias =
between functions of incompatible types 'long int(int,  unsigned int,  loff=
_t,  loff_t)' {aka 'long int(int,  unsigned int,  long long int,  long long=
 int)'} and 'long int(long int,  long int,  long long int,  long long int)'=
 [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sync_file_range' alias b=
etween functions of incompatible types 'long int(int,  loff_t,  loff_t,  un=
signed int)' {aka 'long int(int,  long long int,  long long int,  unsigned =
int)'} and 'long int(long int,  long long int,  long long int,  long int)' =
[-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fdatasync' alias between=
 functions of incompatible types 'long int(unsigned int)' and 'long int(lon=
g int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fsync' alias between fun=
ctions of incompatible types 'long int(unsigned int)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_vmsplice' alias between =
functions of incompatible types 'long int(int,  const struct iovec *, long =
unsigned int,  unsigned int)' and 'long int(long int,  long int,  long int,=
  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_tee' alias between funct=
ions of incompatible types 'long int(int,  int,  size_t,  unsigned int)' {a=
ka 'long int(int,  int,  long unsigned int,  unsigned int)'} and 'long int(=
long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_splice' alias between fu=
nctions of incompatible types 'long int(int,  loff_t *, int,  loff_t *, siz=
e_t,  unsigned int)' {aka 'long int(int,  long long int *, int,  long long =
int *, long unsigned int,  unsigned int)'} and 'long int(long int,  long in=
t,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_vmsplice' alias betw=
een functions of incompatible types 'long int(int,  const struct compat_iov=
ec *, unsigned int,  unsigned int)' and 'long int(long int,  long int,  lon=
g int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_brk' alias between funct=
ions of incompatible types 'long int(long unsigned int)' and 'long int(long=
 int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_munmap' alias between fu=
nctions of incompatible types 'long int(long unsigned int,  size_t)' {aka '=
long int(long unsigned int,  long unsigned int)'} and 'long int(long int,  =
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mmap_pgoff' alias betwee=
n functions of incompatible types 'long int(long unsigned int,  long unsign=
ed int,  long unsigned int,  long unsigned int,  long unsigned int,  long u=
nsigned int)' and 'long int(long int,  long int,  long int,  long int,  lon=
g int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_utime' alias between fun=
ctions of incompatible types 'long int(char *, struct utimbuf *)' and 'long=
 int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_utimes' alias between fu=
nctions of incompatible types 'long int(char *, struct timeval *)' and 'lon=
g int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_futimesat' alias between=
 functions of incompatible types 'long int(int,  const char *, struct timev=
al *)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_utimensat' alias between=
 functions of incompatible types 'long int(int,  const char *, struct times=
pec *, int)' and 'long int(long int,  long int,  long int,  long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_alarm' alias between fun=
ctions of incompatible types 'long int(unsigned int)' and 'long int(long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_nanosleep' alias between=
 functions of incompatible types 'long int(struct timespec *, struct timesp=
ec *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mprotect' alias between =
functions of incompatible types 'long int(long unsigned int,  size_t,  long=
 unsigned int)' {aka 'long int(long unsigned int,  long unsigned int,  long=
 unsigned int)'} and 'long int(long int,  long int,  long int)' [-Wattribut=
e-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getitimer' alias between=
 functions of incompatible types 'long int(int,  struct itimerval *)' and '=
long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setitimer' alias between=
 functions of incompatible types 'long int(int,  struct itimerval *, struct=
 itimerval *)' and 'long int(long int,  long int,  long int)' [-Wattribute-=
alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mremap' alias between fu=
nctions of incompatible types 'long int(long unsigned int,  long unsigned i=
nt,  long unsigned int,  long unsigned int,  long unsigned int)' and 'long =
int(long int,  long int,  long int,  long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_statfs' alias between fu=
nctions of incompatible types 'long int(const char *, struct statfs *)' and=
 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ustat' alias between fun=
ctions of incompatible types 'long int(unsigned int,  struct ustat *)' and =
'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fstatfs64' alias between=
 functions of incompatible types 'long int(unsigned int,  size_t,  struct s=
tatfs64 *)' {aka 'long int(unsigned int,  long unsigned int,  struct statfs=
64 *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fstatfs' alias between f=
unctions of incompatible types 'long int(unsigned int,  struct statfs *)' a=
nd 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_statfs64' alias between =
functions of incompatible types 'long int(const char *, size_t,  struct sta=
tfs64 *)' {aka 'long int(const char *, long unsigned int,  struct statfs64 =
*)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_msync' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  size_t,  int)' {=
aka 'long int(long unsigned int,  long unsigned int,  int)'} and 'long int(=
long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_create' alias betw=
een functions of incompatible types 'long int(const clockid_t,  struct sige=
vent *, timer_t *)' {aka 'long int(const int,  struct sigevent *, int *)'} =
and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_nanosleep' alias b=
etween functions of incompatible types 'long int(const clockid_t,  int,  co=
nst struct timespec *, struct timespec *)' {aka 'long int(const int,  int, =
 const struct timespec *, struct timespec *)'} and 'long int(long int,  lon=
g int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_getres' alias betw=
een functions of incompatible types 'long int(const clockid_t,  struct time=
spec *)' {aka 'long int(const int,  struct timespec *)'} and 'long int(long=
 int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_adjtime' alias bet=
ween functions of incompatible types 'long int(const clockid_t,  struct tim=
ex *)' {aka 'long int(const int,  struct timex *)'} and 'long int(long int,=
  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_gettime' alias bet=
ween functions of incompatible types 'long int(const clockid_t,  struct tim=
espec *)' {aka 'long int(const int,  struct timespec *)'} and 'long int(lon=
g int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_clock_settime' alias bet=
ween functions of incompatible types 'long int(const clockid_t,  const stru=
ct timespec *)' {aka 'long int(const int,  const struct timespec *)'} and '=
long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_delete' alias betw=
een functions of incompatible types 'long int(timer_t)' {aka 'long int(int)=
'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_settime' alias bet=
ween functions of incompatible types 'long int(timer_t,  int,  const struct=
 itimerspec *, struct itimerspec *)' {aka 'long int(int,  int,  const struc=
t itimerspec *, struct itimerspec *)'} and 'long int(long int,  long int,  =
long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_getoverrun' alias =
between functions of incompatible types 'long int(timer_t)' {aka 'long int(=
int)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timer_gettime' alias bet=
ween functions of incompatible types 'long int(timer_t,  struct itimerspec =
*)' {aka 'long int(int,  struct itimerspec *)'} and 'long int(long int,  lo=
ng int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_bdflush' alias between f=
unctions of incompatible types 'long int(int,  long int)' and 'long int(lon=
g int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_process_vm_readv' alias =
between functions of incompatible types 'long int(pid_t,  const struct iove=
c *, long unsigned int,  const struct iovec *, long unsigned int,  long uns=
igned int)' {aka 'long int(int,  const struct iovec *, long unsigned int,  =
const struct iovec *, long unsigned int,  long unsigned int)'} and 'long in=
t(long int,  long int,  long int,  long int,  long int,  long int)' [-Wattr=
ibute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_process_vm_writev' a=
lias between functions of incompatible types 'long int(compat_pid_t,  const=
 struct compat_iovec *, compat_ulong_t,  const struct compat_iovec *, compa=
t_ulong_t,  compat_ulong_t)' {aka 'long int(int,  const struct compat_iovec=
 *, unsigned int,  const struct compat_iovec *, unsigned int,  unsigned int=
)'} and 'long int(long int,  long int,  long int,  long int,  long int,  lo=
ng int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_process_vm_readv' al=
ias between functions of incompatible types 'long int(compat_pid_t,  const =
struct compat_iovec *, compat_ulong_t,  const struct compat_iovec *, compat=
_ulong_t,  compat_ulong_t)' {aka 'long int(int,  const struct compat_iovec =
*, unsigned int,  const struct compat_iovec *, unsigned int,  unsigned int)=
'} and 'long int(long int,  long int,  long int,  long int,  long int,  lon=
g int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_process_vm_writev' alias=
 between functions of incompatible types 'long int(pid_t,  const struct iov=
ec *, long unsigned int,  const struct iovec *, long unsigned int,  long un=
signed int)' {aka 'long int(int,  const struct iovec *, long unsigned int, =
 const struct iovec *, long unsigned int,  long unsigned int)'} and 'long i=
nt(long int,  long int,  long int,  long int,  long int,  long int)' [-Watt=
ribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fadvise64_64' alias betw=
een functions of incompatible types 'long int(int,  loff_t,  loff_t,  int)'=
 {aka 'long int(int,  long long int,  long long int,  int)'} and 'long int(=
long int,  long long int,  long long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fadvise64' alias between=
 functions of incompatible types 'long int(int,  loff_t,  size_t,  int)' {a=
ka 'long int(int,  long long int,  long unsigned int,  int)'} and 'long int=
(long int,  long long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_madvise' alias between f=
unctions of incompatible types 'long int(long unsigned int,  size_t,  int)'=
 {aka 'long int(long unsigned int,  long unsigned int,  int)'} and 'long in=
t(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_swapoff' alias between f=
unctions of incompatible types 'long int(const char *)' and 'long int(long =
int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_swapon' alias between fu=
nctions of incompatible types 'long int(const char *, int)' and 'long int(l=
ong int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_time' alias between func=
tions of incompatible types 'long int(time_t *)' {aka 'long int(long int *)=
'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_adjtimex' alias between =
functions of incompatible types 'long int(struct timex *)' and 'long int(lo=
ng int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_settimeofday' alias betw=
een functions of incompatible types 'long int(struct timeval *, struct time=
zone *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_gettimeofday' alias betw=
een functions of incompatible types 'long int(struct timeval *, struct time=
zone *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_stime' alias between fun=
ctions of incompatible types 'long int(time_t *)' {aka 'long int(long int *=
)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mbind' alias between fun=
ctions of incompatible types 'long int(long unsigned int,  long unsigned in=
t,  long unsigned int,  const long unsigned int *, long unsigned int,  unsi=
gned int)' and 'long int(long int,  long int,  long int,  long int,  long i=
nt,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_mbind' alias between=
 functions of incompatible types 'long int(compat_ulong_t,  compat_ulong_t,=
  compat_ulong_t,  compat_ulong_t *, compat_ulong_t,  compat_ulong_t)' {aka=
 'long int(unsigned int,  unsigned int,  unsigned int,  unsigned int *, uns=
igned int,  unsigned int)'} and 'long int(long int,  long int,  long int,  =
long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_set_mempolicy' alias=
 between functions of incompatible types 'long int(int,  compat_ulong_t *, =
compat_ulong_t)' {aka 'long int(int,  unsigned int *, unsigned int)'} and '=
long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_get_mempolicy' alias=
 between functions of incompatible types 'long int(int *, compat_ulong_t *,=
 compat_ulong_t,  compat_ulong_t,  compat_ulong_t)' {aka 'long int(int *, u=
nsigned int *, unsigned int,  unsigned int,  unsigned int)'} and 'long int(=
long int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_get_mempolicy' alias bet=
ween functions of incompatible types 'long int(int *, long unsigned int *, =
long unsigned int,  long unsigned int,  long unsigned int)' and 'long int(l=
ong int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_migrate_pages' alias bet=
ween functions of incompatible types 'long int(pid_t,  long unsigned int,  =
const long unsigned int *, const long unsigned int *)' {aka 'long int(int, =
 long unsigned int,  const long unsigned int *, const long unsigned int *)'=
} and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-al=
ias]
    include/linux/syscalls.h:195:18: warning: 'sys_set_mempolicy' alias bet=
ween functions of incompatible types 'long int(int,  const long unsigned in=
t *, long unsigned int)' and 'long int(long int,  long int,  long int)' [-W=
attribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_set_robust_list' alias b=
etween functions of incompatible types 'long int(struct robust_list_head *,=
 size_t)' {aka 'long int(struct robust_list_head *, long unsigned int)'} an=
d 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_futex' alias between fun=
ctions of incompatible types 'long int(u32 *, int,  u32,  struct timespec *=
, u32 *, u32)' {aka 'long int(unsigned int *, int,  unsigned int,  struct t=
imespec *, unsigned int *, unsigned int)'} and 'long int(long int,  long in=
t,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_get_robust_list' alias b=
etween functions of incompatible types 'long int(int,  struct robust_list_h=
ead **, size_t *)' {aka 'long int(int,  struct robust_list_head **, long un=
signed int *)'} and 'long int(long int,  long int,  long int)' [-Wattribute=
-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_set_robust_list' ali=
as between functions of incompatible types 'long int(struct compat_robust_l=
ist_head *, compat_size_t)' {aka 'long int(struct compat_robust_list_head *=
, unsigned int)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_futex' alias between=
 functions of incompatible types 'long int(u32 *, int,  u32,  struct compat=
_timespec *, u32 *, u32)' {aka 'long int(unsigned int *, int,  unsigned int=
,  struct compat_timespec *, unsigned int *, unsigned int)'} and 'long int(=
long int,  long int,  long int,  long int,  long int,  long int)' [-Wattrib=
ute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_get_robust_list' ali=
as between functions of incompatible types 'long int(int,  compat_uptr_t *,=
 compat_size_t *)' {aka 'long int(int,  unsigned int *, unsigned int *)'} a=
nd 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_chown16' alias between f=
unctions of incompatible types 'long int(const char *, old_uid_t,  old_gid_=
t)' {aka 'long int(const char *, short unsigned int,  short unsigned int)'}=
 and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setgroups16' alias betwe=
en functions of incompatible types 'long int(int,  old_gid_t *)' {aka 'long=
 int(int,  short unsigned int *)'} and 'long int(long int,  long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getgroups16' alias betwe=
en functions of incompatible types 'long int(int,  old_gid_t *)' {aka 'long=
 int(int,  short unsigned int *)'} and 'long int(long int,  long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setfsgid16' alias betwee=
n functions of incompatible types 'long int(old_gid_t)' {aka 'long int(shor=
t unsigned int)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setfsuid16' alias betwee=
n functions of incompatible types 'long int(old_uid_t)' {aka 'long int(shor=
t unsigned int)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getresgid16' alias betwe=
en functions of incompatible types 'long int(old_gid_t *, old_gid_t *, old_=
gid_t *)' {aka 'long int(short unsigned int *, short unsigned int *, short =
unsigned int *)'} and 'long int(long int,  long int,  long int)' [-Wattribu=
te-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setresgid16' alias betwe=
en functions of incompatible types 'long int(old_gid_t,  old_gid_t,  old_gi=
d_t)' {aka 'long int(short unsigned int,  short unsigned int,  short unsign=
ed int)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getresuid16' alias betwe=
en functions of incompatible types 'long int(old_uid_t *, old_uid_t *, old_=
uid_t *)' {aka 'long int(short unsigned int *, short unsigned int *, short =
unsigned int *)'} and 'long int(long int,  long int,  long int)' [-Wattribu=
te-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setresuid16' alias betwe=
en functions of incompatible types 'long int(old_uid_t,  old_uid_t,  old_ui=
d_t)' {aka 'long int(short unsigned int,  short unsigned int,  short unsign=
ed int)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setuid16' alias between =
functions of incompatible types 'long int(old_uid_t)' {aka 'long int(short =
unsigned int)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setreuid16' alias betwee=
n functions of incompatible types 'long int(old_uid_t,  old_uid_t)' {aka 'l=
ong int(short unsigned int,  short unsigned int)'} and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setgid16' alias between =
functions of incompatible types 'long int(old_gid_t)' {aka 'long int(short =
unsigned int)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setregid16' alias betwee=
n functions of incompatible types 'long int(old_gid_t,  old_gid_t)' {aka 'l=
ong int(short unsigned int,  short unsigned int)'} and 'long int(long int, =
 long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_fchown16' alias between =
functions of incompatible types 'long int(unsigned int,  old_uid_t,  old_gi=
d_t)' {aka 'long int(unsigned int,  short unsigned int,  short unsigned int=
)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lchown16' alias between =
functions of incompatible types 'long int(const char *, old_uid_t,  old_gid=
_t)' {aka 'long int(const char *, short unsigned int,  short unsigned int)'=
} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_move_pages' alias betwee=
n functions of incompatible types 'long int(pid_t,  long unsigned int,  con=
st void **, const int *, int *, int)' {aka 'long int(int,  long unsigned in=
t,  const void **, const int *, int *, int)'} and 'long int(long int,  long=
 int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_delete_module' alias bet=
ween functions of incompatible types 'long int(const char *, unsigned int)'=
 and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_finit_module' alias betw=
een functions of incompatible types 'long int(int,  const char *, int)' and=
 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_init_module' alias betwe=
en functions of incompatible types 'long int(void *, long unsigned int,  co=
nst char *)' and 'long int(long int,  long int,  long int)' [-Wattribute-al=
ias]
    include/linux/compat.h:48:18: warning: 'compat_sys_ipc' alias between f=
unctions of incompatible types 'long int(u32,  int,  int,  u32,  compat_upt=
r_t,  u32)' {aka 'long int(unsigned int,  int,  int,  unsigned int,  unsign=
ed int,  unsigned int)'} and 'long int(long int,  long int,  long int,  lon=
g int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_semtimedop' alias be=
tween functions of incompatible types 'long int(int,  struct sembuf *, unsi=
gned int,  const struct compat_timespec *)' and 'long int(long int,  long i=
nt,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_shmctl' alias betwee=
n functions of incompatible types 'long int(int,  int,  void *)' and 'long =
int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_shmat' alias between=
 functions of incompatible types 'long int(int,  compat_uptr_t,  int)' {aka=
 'long int(int,  unsigned int,  int)'} and 'long int(long int,  long int,  =
long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_msgctl' alias betwee=
n functions of incompatible types 'long int(int,  int,  void *)' and 'long =
int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_msgrcv' alias betwee=
n functions of incompatible types 'long int(int,  compat_uptr_t,  compat_ss=
ize_t,  compat_long_t,  int)' {aka 'long int(int,  unsigned int,  int,  int=
,  int)'} and 'long int(long int,  long int,  long int,  long int,  long in=
t)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_msgsnd' alias betwee=
n functions of incompatible types 'long int(int,  compat_uptr_t,  compat_ss=
ize_t,  int)' {aka 'long int(int,  unsigned int,  int,  int)'} and 'long in=
t(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_semctl' alias betwee=
n functions of incompatible types 'long int(int,  int,  int,  int)' and 'lo=
ng int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_acct' alias between func=
tions of incompatible types 'long int(const char *)' and 'long int(long int=
)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_msgget' alias between fu=
nctions of incompatible types 'long int(key_t,  int)' {aka 'long int(int,  =
int)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_msgrcv' alias between fu=
nctions of incompatible types 'long int(int,  struct msgbuf *, size_t,  lon=
g int,  int)' {aka 'long int(int,  struct msgbuf *, long unsigned int,  lon=
g int,  int)'} and 'long int(long int,  long int,  long int,  long int,  lo=
ng int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_msgsnd' alias between fu=
nctions of incompatible types 'long int(int,  struct msgbuf *, size_t,  int=
)' {aka 'long int(int,  struct msgbuf *, long unsigned int,  int)'} and 'lo=
ng int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_msgctl' alias between fu=
nctions of incompatible types 'long int(int,  int,  struct msqid_ds *)' and=
 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_kexec_load' alias betwee=
n functions of incompatible types 'long int(long unsigned int,  long unsign=
ed int,  struct kexec_segment *, long unsigned int)' and 'long int(long int=
,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_kexec_load' alias be=
tween functions of incompatible types 'long int(compat_ulong_t,  compat_ulo=
ng_t,  struct compat_kexec_segment *, compat_ulong_t)' {aka 'long int(unsig=
ned int,  unsigned int,  struct compat_kexec_segment *, unsigned int)'} and=
 'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_semget' alias between fu=
nctions of incompatible types 'long int(key_t,  int,  int)' {aka 'long int(=
int,  int,  int)'} and 'long int(long int,  long int,  long int)' [-Wattrib=
ute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_semop' alias between fun=
ctions of incompatible types 'long int(int,  struct sembuf *, unsigned int)=
' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_semtimedop' alias betwee=
n functions of incompatible types 'long int(int,  struct sembuf *, unsigned=
 int,  const struct timespec *)' and 'long int(long int,  long int,  long i=
nt,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_semctl' alias between fu=
nctions of incompatible types 'long int(int,  int,  int,  long unsigned int=
)' and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-a=
lias]
    include/linux/compat.h:48:18: warning: 'compat_sys_gettimeofday' alias =
between functions of incompatible types 'long int(struct compat_timeval *, =
struct timezone *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sched_rr_get_interva=
l' alias between functions of incompatible types 'long int(compat_pid_t,  s=
truct compat_timespec *)' {aka 'long int(int,  struct compat_timespec *)'} =
and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_migrate_pages' alias=
 between functions of incompatible types 'long int(compat_pid_t,  compat_ul=
ong_t,  const compat_ulong_t *, const compat_ulong_t *)' {aka 'long int(int=
,  unsigned int,  const unsigned int *, const unsigned int *)'} and 'long i=
nt(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_move_pages' alias be=
tween functions of incompatible types 'long int(pid_t,  compat_ulong_t,  co=
mpat_uptr_t *, const int *, int *, int)' {aka 'long int(int,  unsigned int,=
  unsigned int *, const int *, int *, int)'} and 'long int(long int,  long =
int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_adjtimex' alias betw=
een functions of incompatible types 'long int(struct compat_timex *)' and '=
long int(long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_stime' alias between=
 functions of incompatible types 'long int(compat_time_t *)' {aka 'long int=
(int *)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_time' alias between =
functions of incompatible types 'long int(compat_time_t *)' {aka 'long int(=
int *)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_rt_sigtimedwait' ali=
as between functions of incompatible types 'long int(compat_sigset_t *, str=
uct compat_siginfo *, struct compat_timespec *, compat_size_t)' {aka 'long =
int(struct <anonymous> *, struct compat_siginfo *, struct compat_timespec *=
, unsigned int)'} and 'long int(long int,  long int,  long int,  long int)'=
 [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_clock_nanosleep' ali=
as between functions of incompatible types 'long int(clockid_t,  int,  stru=
ct compat_timespec *, struct compat_timespec *)' {aka 'long int(int,  int, =
 struct compat_timespec *, struct compat_timespec *)'} and 'long int(long i=
nt,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_clock_getres' alias =
between functions of incompatible types 'long int(clockid_t,  struct compat=
_timespec *)' {aka 'long int(int,  struct compat_timespec *)'} and 'long in=
t(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_clock_adjtime' alias=
 between functions of incompatible types 'long int(clockid_t,  struct compa=
t_timex *)' {aka 'long int(int,  struct compat_timex *)'} and 'long int(lon=
g int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_clock_gettime' alias=
 between functions of incompatible types 'long int(clockid_t,  struct compa=
t_timespec *)' {aka 'long int(int,  struct compat_timespec *)'} and 'long i=
nt(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_clock_settime' alias=
 between functions of incompatible types 'long int(clockid_t,  struct compa=
t_timespec *)' {aka 'long int(int,  struct compat_timespec *)'} and 'long i=
nt(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_timer_gettime' alias=
 between functions of incompatible types 'long int(timer_t,  struct compat_=
itimerspec *)' {aka 'long int(int,  struct compat_itimerspec *)'} and 'long=
 int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_timer_settime' alias=
 between functions of incompatible types 'long int(timer_t,  int,  struct c=
ompat_itimerspec *, struct compat_itimerspec *)' {aka 'long int(int,  int, =
 struct compat_itimerspec *, struct compat_itimerspec *)'} and 'long int(lo=
ng int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_timer_create' alias =
between functions of incompatible types 'long int(clockid_t,  struct compat=
_sigevent *, timer_t *)' {aka 'long int(int,  struct compat_sigevent *, int=
 *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sched_getaffinity' a=
lias between functions of incompatible types 'long int(compat_pid_t,  unsig=
ned int,  compat_ulong_t *)' {aka 'long int(int,  unsigned int,  unsigned i=
nt *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sched_setaffinity' a=
lias between functions of incompatible types 'long int(compat_pid_t,  unsig=
ned int,  compat_ulong_t *)' {aka 'long int(int,  unsigned int,  unsigned i=
nt *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_waitid' alias betwee=
n functions of incompatible types 'long int(int,  compat_pid_t,  struct com=
pat_siginfo *, int,  struct compat_rusage *)' {aka 'long int(int,  int,  st=
ruct compat_siginfo *, int,  struct compat_rusage *)'} and 'long int(long i=
nt,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_wait4' alias between=
 functions of incompatible types 'long int(compat_pid_t,  compat_uint_t *, =
int,  struct compat_rusage *)' {aka 'long int(int,  unsigned int *, int,  s=
truct compat_rusage *)'} and 'long int(long int,  long int,  long int,  lon=
g int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_getrlimit' alias bet=
ween functions of incompatible types 'long int(unsigned int,  struct compat=
_rlimit *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_old_getrlimit' alias=
 between functions of incompatible types 'long int(unsigned int,  struct co=
mpat_rlimit *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_setrlimit' alias bet=
ween functions of incompatible types 'long int(unsigned int,  struct compat=
_rlimit *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sigprocmask' alias b=
etween functions of incompatible types 'long int(int,  compat_old_sigset_t =
*, compat_old_sigset_t *)' {aka 'long int(int,  unsigned int *, unsigned in=
t *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sigpending' alias be=
tween functions of incompatible types 'long int(compat_old_sigset_t *)' {ak=
a 'long int(unsigned int *)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_times' alias between=
 functions of incompatible types 'long int(struct compat_tms *)' and 'long =
int(long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_setitimer' alias bet=
ween functions of incompatible types 'long int(int,  struct compat_itimerva=
l *, struct compat_itimerval *)' and 'long int(long int,  long int,  long i=
nt)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_getitimer' alias bet=
ween functions of incompatible types 'long int(int,  struct compat_itimerva=
l *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_nanosleep' alias bet=
ween functions of incompatible types 'long int(struct compat_timespec *, st=
ruct compat_timespec *)' and 'long int(long int,  long int)' [-Wattribute-a=
lias]
    include/linux/compat.h:48:18: warning: 'compat_sys_settimeofday' alias =
between functions of incompatible types 'long int(struct compat_timeval *, =
struct timezone *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_shmget' alias between fu=
nctions of incompatible types 'long int(key_t,  size_t,  int)' {aka 'long i=
nt(int,  long unsigned int,  int)'} and 'long int(long int,  long int,  lon=
g int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_shmdt' alias between fun=
ctions of incompatible types 'long int(char *)' and 'long int(long int)' [-=
Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_shmat' alias between fun=
ctions of incompatible types 'long int(int,  char *, int)' and 'long int(lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_shmctl' alias between fu=
nctions of incompatible types 'long int(int,  int,  struct shmid_ds *)' and=
 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mq_open' alias between f=
unctions of incompatible types 'long int(const char *, int,  umode_t,  stru=
ct mq_attr *)' {aka 'long int(const char *, int,  short unsigned int,  stru=
ct mq_attr *)'} and 'long int(long int,  long int,  long int,  long int)' [=
-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mq_getsetattr' alias bet=
ween functions of incompatible types 'long int(mqd_t,  const struct mq_attr=
 *, struct mq_attr *)' {aka 'long int(int,  const struct mq_attr *, struct =
mq_attr *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-al=
ias]
    include/linux/syscalls.h:195:18: warning: 'sys_mq_notify' alias between=
 functions of incompatible types 'long int(mqd_t,  const struct sigevent *)=
' {aka 'long int(int,  const struct sigevent *)'} and 'long int(long int,  =
long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mq_timedreceive' alias b=
etween functions of incompatible types 'long int(mqd_t,  char *, size_t,  u=
nsigned int *, const struct timespec *)' {aka 'long int(int,  char *, long =
unsigned int,  unsigned int *, const struct timespec *)'} and 'long int(lon=
g int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_mq_timedsend' alias betw=
een functions of incompatible types 'long int(mqd_t,  const char *, size_t,=
  unsigned int,  const struct timespec *)' {aka 'long int(int,  const char =
*, long unsigned int,  unsigned int,  const struct timespec *)'} and 'long =
int(long int,  long int,  long int,  long int,  long int)' [-Wattribute-ali=
as]
    include/linux/syscalls.h:195:18: warning: 'sys_mq_unlink' alias between=
 functions of incompatible types 'long int(const char *)' and 'long int(lon=
g int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_mq_open' alias betwe=
en functions of incompatible types 'long int(const char *, int,  compat_mod=
e_t,  struct compat_mq_attr *)' {aka 'long int(const char *, int,  short un=
signed int,  struct compat_mq_attr *)'} and 'long int(long int,  long int, =
 long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_mq_getsetattr' alias=
 between functions of incompatible types 'long int(mqd_t,  const struct com=
pat_mq_attr *, struct compat_mq_attr *)' {aka 'long int(int,  const struct =
compat_mq_attr *, struct compat_mq_attr *)'} and 'long int(long int,  long =
int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_mq_notify' alias bet=
ween functions of incompatible types 'long int(mqd_t,  const struct compat_=
sigevent *)' {aka 'long int(int,  const struct compat_sigevent *)'} and 'lo=
ng int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_mq_timedreceive' ali=
as between functions of incompatible types 'long int(mqd_t,  char *, compat=
_size_t,  unsigned int *, const struct compat_timespec *)' {aka 'long int(i=
nt,  char *, unsigned int,  unsigned int *, const struct compat_timespec *)=
'} and 'long int(long int,  long int,  long int,  long int,  long int)' [-W=
attribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_mq_timedsend' alias =
between functions of incompatible types 'long int(mqd_t,  const char *, com=
pat_size_t,  unsigned int,  const struct compat_timespec *)' {aka 'long int=
(int,  const char *, unsigned int,  unsigned int,  const struct compat_time=
spec *)'} and 'long int(long int,  long int,  long int,  long int,  long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_add_key' alias between f=
unctions of incompatible types 'long int(const char *, const char *, const =
void *, size_t,  key_serial_t)' {aka 'long int(const char *, const char *, =
const void *, long unsigned int,  int)'} and 'long int(long int,  long int,=
  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_keyctl' alias between fu=
nctions of incompatible types 'long int(int,  long unsigned int,  long unsi=
gned int,  long unsigned int,  long unsigned int)' and 'long int(long int, =
 long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_request_key' alias betwe=
en functions of incompatible types 'long int(const char *, const char *, co=
nst char *, key_serial_t)' {aka 'long int(const char *, const char *, const=
 char *, int)'} and 'long int(long int,  long int,  long int,  long int)' [=
-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_keyctl' alias betwee=
n functions of incompatible types 'long int(u32,  u32,  u32,  u32,  u32)' {=
aka 'long int(unsigned int,  unsigned int,  unsigned int,  unsigned int,  u=
nsigned int)'} and 'long int(long int,  long int,  long int,  long int,  lo=
ng int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_seccomp' alias between f=
unctions of incompatible types 'long int(unsigned int,  unsigned int,  cons=
t char *)' and 'long int(long int,  long int,  long int)' [-Wattribute-alia=
s]
    kernel/relay.c:423:35: warning: 'snprintf' output may be truncated befo=
re the last format character [-Wformat-truncation=3D]
    block/elevator.c:841:14: warning: 'snprintf' output may be truncated be=
fore the last format character [-Wformat-truncation=3D]
    block/partition-generic.c:41:37: warning: 'snprintf' output may be trun=
cated before the last format character [-Wformat-truncation=3D]
    block/partition-generic.c:39:36: warning: '%d' directive output may be =
truncated writing between 1 and 11 bytes into a region of size between 0 an=
d 31 [-Wformat-truncation=3D]
    fs/nfs/client.c:1380:23: warning: '%u' directive output may be truncate=
d writing between 1 and 7 bytes into a region of size between 3 and 6 [-Wfo=
rmat-truncation=3D]
    include/linux/syscalls.h:195:18: warning: 'sys_ioprio_set' alias betwee=
n functions of incompatible types 'long int(int,  int,  int)' and 'long int=
(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_ioprio_get' alias betwee=
n functions of incompatible types 'long int(int,  int)' and 'long int(long =
int,  long int)' [-Wattribute-alias]
    arch/x86/pci/mmconfig-shared.c:90:28: warning: '%02x' directive output =
may be truncated writing between 2 and 8 bytes into a region of size betwee=
n 3 and 7 [-Wformat-truncation=3D]
    include/linux/syscalls.h:195:18: warning: 'sys_socket' alias between fu=
nctions of incompatible types 'long int(int,  int,  int)' and 'long int(lon=
g int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_socketcall' alias betwee=
n functions of incompatible types 'long int(int,  long unsigned int *)' and=
 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_recvmmsg' alias between =
functions of incompatible types 'long int(int,  struct mmsghdr *, unsigned =
int,  unsigned int,  struct timespec *)' and 'long int(long int,  long int,=
  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_recvmsg' alias between f=
unctions of incompatible types 'long int(int,  struct msghdr *, unsigned in=
t)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sendmmsg' alias between =
functions of incompatible types 'long int(int,  struct mmsghdr *, unsigned =
int,  unsigned int)' and 'long int(long int,  long int,  long int,  long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sendmsg' alias between f=
unctions of incompatible types 'long int(int,  struct msghdr *, unsigned in=
t)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_shutdown' alias between =
functions of incompatible types 'long int(int,  int)' and 'long int(long in=
t,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getsockopt' alias betwee=
n functions of incompatible types 'long int(int,  int,  int,  char *, int *=
)' and 'long int(long int,  long int,  long int,  long int,  long int)' [-W=
attribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_setsockopt' alias betwee=
n functions of incompatible types 'long int(int,  int,  int,  char *, int)'=
 and 'long int(long int,  long int,  long int,  long int,  long int)' [-Wat=
tribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_recv' alias between func=
tions of incompatible types 'long int(int,  void *, size_t,  unsigned int)'=
 {aka 'long int(int,  void *, long unsigned int,  unsigned int)'} and 'long=
 int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_recvfrom' alias between =
functions of incompatible types 'long int(int,  void *, size_t,  unsigned i=
nt,  struct sockaddr *, int *)' {aka 'long int(int,  void *, long unsigned =
int,  unsigned int,  struct sockaddr *, int *)'} and 'long int(long int,  l=
ong int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_send' alias between func=
tions of incompatible types 'long int(int,  void *, size_t,  unsigned int)'=
 {aka 'long int(int,  void *, long unsigned int,  unsigned int)'} and 'long=
 int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_sendto' alias between fu=
nctions of incompatible types 'long int(int,  void *, size_t,  unsigned int=
,  struct sockaddr *, int)' {aka 'long int(int,  void *, long unsigned int,=
  unsigned int,  struct sockaddr *, int)'} and 'long int(long int,  long in=
t,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getpeername' alias betwe=
en functions of incompatible types 'long int(int,  struct sockaddr *, int *=
)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getsockname' alias betwe=
en functions of incompatible types 'long int(int,  struct sockaddr *, int *=
)' and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_connect' alias between f=
unctions of incompatible types 'long int(int,  struct sockaddr *, int)' and=
 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_accept' alias between fu=
nctions of incompatible types 'long int(int,  struct sockaddr *, int *)' an=
d 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_accept4' alias between f=
unctions of incompatible types 'long int(int,  struct sockaddr *, int *, in=
t)' and 'long int(long int,  long int,  long int,  long int)' [-Wattribute-=
alias]
    include/linux/syscalls.h:195:18: warning: 'sys_listen' alias between fu=
nctions of incompatible types 'long int(int,  int)' and 'long int(long int,=
  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_bind' alias between func=
tions of incompatible types 'long int(int,  struct sockaddr *, int)' and 'l=
ong int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_socketpair' alias betwee=
n functions of incompatible types 'long int(int,  int,  int,  int *)' and '=
long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]
    lib/string_helpers.c:64:33: warning: '%03lld' directive output may be t=
runcated writing between 3 and 13 bytes into a region of size 7 [-Wformat-t=
runcation=3D]
    include/linux/syscalls.h:195:18: warning: 'sys_inotify_init1' alias bet=
ween functions of incompatible types 'long int(int)' and 'long int(long int=
)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_inotify_rm_watch' alias =
between functions of incompatible types 'long int(int,  __s32)' {aka 'long =
int(int,  int)'} and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_inotify_add_watch' alias=
 between functions of incompatible types 'long int(int,  const char *, u32)=
' {aka 'long int(int,  const char *, unsigned int)'} and 'long int(long int=
,  long int,  long int)' [-Wattribute-alias]
    drivers/ata/libata-core.c:2962:30: warning: '*' in boolean context, sug=
gest '&&' instead [-Wint-in-bool-context]
    drivers/ata/libata-core.c:2963:30: warning: '*' in boolean context, sug=
gest '&&' instead [-Wint-in-bool-context]
    drivers/ata/libata-core.c:2964:30: warning: '*' in boolean context, sug=
gest '&&' instead [-Wint-in-bool-context]
    drivers/ata/libata-core.c:2965:30: warning: '*' in boolean context, sug=
gest '&&' instead [-Wint-in-bool-context]
    drivers/ata/libata-core.c:2966:31: warning: '*' in boolean context, sug=
gest '&&' instead [-Wint-in-bool-context]
    drivers/ata/libata-core.c:2967:32: warning: '*' in boolean context, sug=
gest '&&' instead [-Wint-in-bool-context]
    drivers/ata/libata-core.c:2968:35: warning: '*' in boolean context, sug=
gest '&&' instead [-Wint-in-bool-context]
    drivers/ata/libata-core.c:2969:30: warning: '*' in boolean context, sug=
gest '&&' instead [-Wint-in-bool-context]
    drivers/ata/libata-core.c:2970:30: warning: '*' in boolean context, sug=
gest '&&' instead [-Wint-in-bool-context]
    drivers/ata/libata-core.c:2141:42: warning: '%d' directive output may b=
e truncated writing between 1 and 2 bytes into a region of size between 1 a=
nd 11 [-Wformat-truncation=3D]
    drivers/ata/libata-eh.c:2442:45: warning: '%d' directive output may be =
truncated writing between 1 and 11 bytes into a region of size 4 [-Wformat-=
truncation=3D]
    include/linux/syscalls.h:195:18: warning: 'sys_quotactl' alias between =
functions of incompatible types 'long int(unsigned int,  const char *, qid_=
t,  void *)' {aka 'long int(unsigned int,  const char *, unsigned int,  voi=
d *)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattribu=
te-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_epoll_create1' alias bet=
ween functions of incompatible types 'long int(int)' and 'long int(long int=
)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_epoll_pwait' alias b=
etween functions of incompatible types 'long int(int,  struct epoll_event *=
, int,  int,  const compat_sigset_t *, compat_size_t)' {aka 'long int(int, =
 struct epoll_event *, int,  int,  const struct <anonymous> *, unsigned int=
)'} and 'long int(long int,  long int,  long int,  long int,  long int,  lo=
ng int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_epoll_pwait' alias betwe=
en functions of incompatible types 'long int(int,  struct epoll_event *, in=
t,  int,  const sigset_t *, size_t)' {aka 'long int(int,  struct epoll_even=
t *, int,  int,  const struct <anonymous> *, long unsigned int)'} and 'long=
 int(long int,  long int,  long int,  long int,  long int,  long int)' [-Wa=
ttribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_epoll_wait' alias betwee=
n functions of incompatible types 'long int(int,  struct epoll_event *, int=
,  int)' and 'long int(long int,  long int,  long int,  long int)' [-Wattri=
bute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_epoll_ctl' alias between=
 functions of incompatible types 'long int(int,  int,  int,  struct epoll_e=
vent *)' and 'long int(long int,  long int,  long int,  long int)' [-Wattri=
bute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_epoll_create' alias betw=
een functions of incompatible types 'long int(int)' and 'long int(long int)=
' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_signalfd4' alias between=
 functions of incompatible types 'long int(int,  sigset_t *, size_t,  int)'=
 {aka 'long int(int,  struct <anonymous> *, long unsigned int,  int)'} and =
'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_signalfd' alias betw=
een functions of incompatible types 'long int(int,  const compat_sigset_t *=
, compat_size_t)' {aka 'long int(int,  const struct <anonymous> *, unsigned=
 int)'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_signalfd4' alias bet=
ween functions of incompatible types 'long int(int,  const compat_sigset_t =
*, compat_size_t,  int)' {aka 'long int(int,  const struct <anonymous> *, u=
nsigned int,  int)'} and 'long int(long int,  long int,  long int,  long in=
t)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_signalfd' alias between =
functions of incompatible types 'long int(int,  sigset_t *, size_t)' {aka '=
long int(int,  struct <anonymous> *, long unsigned int)'} and 'long int(lon=
g int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timerfd_create' alias be=
tween functions of incompatible types 'long int(int,  int)' and 'long int(l=
ong int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_timerfd_gettime' ali=
as between functions of incompatible types 'long int(int,  struct compat_it=
imerspec *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_timerfd_settime' ali=
as between functions of incompatible types 'long int(int,  int,  const stru=
ct compat_itimerspec *, struct compat_itimerspec *)' and 'long int(long int=
,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timerfd_gettime' alias b=
etween functions of incompatible types 'long int(int,  struct itimerspec *)=
' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_timerfd_settime' alias b=
etween functions of incompatible types 'long int(int,  int,  const struct i=
timerspec *, struct itimerspec *)' and 'long int(long int,  long int,  long=
 int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_eventfd2' alias between =
functions of incompatible types 'long int(unsigned int,  int)' and 'long in=
t(long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_eventfd' alias between f=
unctions of incompatible types 'long int(unsigned int)' and 'long int(long =
int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_io_setup' alias between =
functions of incompatible types 'long int(unsigned int,  aio_context_t *)' =
{aka 'long int(unsigned int,  long unsigned int *)'} and 'long int(long int=
,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_io_getevents' alias betw=
een functions of incompatible types 'long int(aio_context_t,  long int,  lo=
ng int,  struct io_event *, struct timespec *)' {aka 'long int(long unsigne=
d int,  long int,  long int,  struct io_event *, struct timespec *)'} and '=
long int(long int,  long int,  long int,  long int,  long int)' [-Wattribut=
e-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_io_cancel' alias between=
 functions of incompatible types 'long int(aio_context_t,  struct iocb *, s=
truct io_event *)' {aka 'long int(long unsigned int,  struct iocb *, struct=
 io_event *)'} and 'long int(long int,  long int,  long int)' [-Wattribute-=
alias]
    include/linux/syscalls.h:195:18: warning: 'sys_io_submit' alias between=
 functions of incompatible types 'long int(aio_context_t,  long int,  struc=
t iocb **)' {aka 'long int(long unsigned int,  long int,  struct iocb **)'}=
 and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_io_destroy' alias betwee=
n functions of incompatible types 'long int(aio_context_t)' {aka 'long int(=
long unsigned int)'} and 'long int(long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_flock' alias between fun=
ctions of incompatible types 'long int(unsigned int,  unsigned int)' and 'l=
ong int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_utime' alias between=
 functions of incompatible types 'long int(const char *, struct compat_utim=
buf *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_ppoll' alias between=
 functions of incompatible types 'long int(struct pollfd *, unsigned int,  =
struct compat_timespec *, const compat_sigset_t *, compat_size_t)' {aka 'lo=
ng int(struct pollfd *, unsigned int,  struct compat_timespec *, const stru=
ct <anonymous> *, unsigned int)'} and 'long int(long int,  long int,  long =
int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_pselect6' alias betw=
een functions of incompatible types 'long int(int,  compat_ulong_t *, compa=
t_ulong_t *, compat_ulong_t *, struct compat_timespec *, void *)' {aka 'lon=
g int(int,  unsigned int *, unsigned int *, unsigned int *, struct compat_t=
imespec *, void *)'} and 'long int(long int,  long int,  long int,  long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_old_select' alias be=
tween functions of incompatible types 'long int(struct compat_sel_arg_struc=
t *)' and 'long int(long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_select' alias betwee=
n functions of incompatible types 'long int(int,  compat_ulong_t *, compat_=
ulong_t *, compat_ulong_t *, struct compat_timeval *)' {aka 'long int(int, =
 unsigned int *, unsigned int *, unsigned int *, struct compat_timeval *)'}=
 and 'long int(long int,  long int,  long int,  long int,  long int)' [-Wat=
tribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_openat' alias betwee=
n functions of incompatible types 'long int(int,  const char *, int,  umode=
_t)' {aka 'long int(int,  const char *, int,  short unsigned int)'} and 'lo=
ng int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_open' alias between =
functions of incompatible types 'long int(const char *, int,  umode_t)' {ak=
a 'long int(const char *, int,  short unsigned int)'} and 'long int(long in=
t,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_getdents64' alias be=
tween functions of incompatible types 'long int(unsigned int,  struct linux=
_dirent64 *, unsigned int)' and 'long int(long int,  long int,  long int)' =
[-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_getdents' alias betw=
een functions of incompatible types 'long int(unsigned int,  struct compat_=
linux_dirent *, unsigned int)' and 'long int(long int,  long int,  long int=
)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_old_readdir' alias b=
etween functions of incompatible types 'long int(unsigned int,  struct comp=
at_old_linux_dirent *, unsigned int)' and 'long int(long int,  long int,  l=
ong int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_mount' alias between=
 functions of incompatible types 'long int(const char *, const char *, cons=
t char *, compat_ulong_t,  const void *)' {aka 'long int(const char *, cons=
t char *, const char *, unsigned int,  const void *)'} and 'long int(long i=
nt,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_io_submit' alias bet=
ween functions of incompatible types 'long int(compat_aio_context_t,  int, =
 u32 *)' {aka 'long int(unsigned int,  int,  unsigned int *)'} and 'long in=
t(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_io_getevents' alias =
between functions of incompatible types 'long int(compat_aio_context_t,  co=
mpat_long_t,  compat_long_t,  struct io_event *, struct compat_timespec *)'=
 {aka 'long int(unsigned int,  int,  int,  struct io_event *, struct compat=
_timespec *)'} and 'long int(long int,  long int,  long int,  long int,  lo=
ng int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_io_setup' alias betw=
een functions of incompatible types 'long int(unsigned int,  u32 *)' {aka '=
long int(unsigned int,  unsigned int *)'} and 'long int(long int,  long int=
)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_fcntl' alias between=
 functions of incompatible types 'long int(unsigned int,  unsigned int,  co=
mpat_ulong_t)' {aka 'long int(unsigned int,  unsigned int,  unsigned int)'}=
 and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_fcntl64' alias betwe=
en functions of incompatible types 'long int(unsigned int,  unsigned int,  =
compat_ulong_t)' {aka 'long int(unsigned int,  unsigned int,  unsigned int)=
'} and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_ustat' alias between=
 functions of incompatible types 'long int(unsigned int,  struct compat_ust=
at *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_fstatfs64' alias bet=
ween functions of incompatible types 'long int(unsigned int,  compat_size_t=
,  struct compat_statfs64 *)' {aka 'long int(unsigned int,  unsigned int,  =
struct compat_statfs64 *)'} and 'long int(long int,  long int,  long int)' =
[-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_statfs64' alias betw=
een functions of incompatible types 'long int(const char *, compat_size_t, =
 struct compat_statfs64 *)' {aka 'long int(const char *, unsigned int,  str=
uct compat_statfs64 *)'} and 'long int(long int,  long int,  long int)' [-W=
attribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_fstatfs' alias betwe=
en functions of incompatible types 'long int(unsigned int,  struct compat_s=
tatfs *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_statfs' alias betwee=
n functions of incompatible types 'long int(const char *, struct compat_sta=
tfs *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_newfstat' alias betw=
een functions of incompatible types 'long int(unsigned int,  struct compat_=
stat *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_newfstatat' alias be=
tween functions of incompatible types 'long int(unsigned int,  const char *=
, struct compat_stat *, int)' and 'long int(long int,  long int,  long int,=
  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_newlstat' alias betw=
een functions of incompatible types 'long int(const char *, struct compat_s=
tat *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_newstat' alias betwe=
en functions of incompatible types 'long int(const char *, struct compat_st=
at *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_utimes' alias betwee=
n functions of incompatible types 'long int(const char *, struct compat_tim=
eval *)' and 'long int(long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_futimesat' alias bet=
ween functions of incompatible types 'long int(unsigned int,  const char *,=
 struct compat_timeval *)' and 'long int(long int,  long int,  long int)' [=
-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_utimensat' alias bet=
ween functions of incompatible types 'long int(unsigned int,  const char *,=
 struct compat_timespec *, int)' and 'long int(long int,  long int,  long i=
nt,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_ioctl' alias between=
 functions of incompatible types 'long int(unsigned int,  unsigned int,  co=
mpat_ulong_t)' {aka 'long int(unsigned int,  unsigned int,  unsigned int)'}=
 and 'long int(long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_lookup_dcookie' alias be=
tween functions of incompatible types 'long int(u64,  char *, size_t)' {aka=
 'long int(long long unsigned int,  char *, long unsigned int)'} and 'long =
int(long long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_lookup_dcookie' alia=
s between functions of incompatible types 'long int(u32,  u32,  char *, com=
pat_size_t)' {aka 'long int(unsigned int,  unsigned int,  char *, unsigned =
int)'} and 'long int(long int,  long int,  long int,  long int)' [-Wattribu=
te-alias]
    include/linux/syscalls.h:195:18: warning: 'sys_getrandom' alias between=
 functions of incompatible types 'long int(char *, size_t,  unsigned int)' =
{aka 'long int(char *, long unsigned int,  unsigned int)'} and 'long int(lo=
ng int,  long int,  long int)' [-Wattribute-alias]
    drivers/input/keyboard/atkbd.c:1069:7: warning: '/input0' directive out=
put may be truncated writing 7 bytes into a region of size between 1 and 32=
 [-Wformat-truncation=3D]
    drivers/input/mouse/psmouse-base.c:1466:52: warning: '/input0' directiv=
e output may be truncated writing 7 bytes into a region of size between 1 a=
nd 32 [-Wformat-truncation=3D]
    drivers/input/mouse/alps.c:2418:46: warning: '/input1' directive output=
 may be truncated writing 7 bytes into a region of size between 1 and 32 [-=
Wformat-truncation=3D]
    drivers/input/mouse/lifebook.c:287:7: warning: '/input1' directive outp=
ut may be truncated writing 7 bytes into a region of size between 1 and 32 =
[-Wformat-truncation=3D]
    drivers/net/ethernet/broadcom/tg3.c:11184:10: warning: '%d' directive o=
utput may be truncated writing between 1 and 11 bytes into a region of size=
 between 0 and 15 [-Wformat-truncation=3D]
    drivers/net/ethernet/broadcom/tg3.c:11181:9: warning: '-rx-' directive =
output may be truncated writing 4 bytes into a region of size between 1 and=
 16 [-Wformat-truncation=3D]
    drivers/net/ethernet/broadcom/tg3.c:11178:9: warning: '-tx-' directive =
output may be truncated writing 4 bytes into a region of size between 1 and=
 16 [-Wformat-truncation=3D]
    drivers/net/ethernet/broadcom/tg3.c:11175:9: warning: '-txrx-' directiv=
e output may be truncated writing 6 bytes into a region of size between 1 a=
nd 16 [-Wformat-truncation=3D]
    net/sunrpc/clnt.c:527:46: warning: '%s' directive output may be truncat=
ed writing up to 107 bytes into a region of size 48 [-Wformat-truncation=3D]
    drivers/usb/core/usb.c:471:9: warning: '%d' directive output may be tru=
ncated writing between 1 and 11 bytes into a region of size between 0 and 1=
5 [-Wformat-truncation=3D]
    drivers/usb/core/hcd.c:450:34: warning: '%s' directive output may be tr=
uncated writing up to 64 bytes into a region of size between 35 and 99 [-Wf=
ormat-truncation=3D]
    include/linux/compat.h:48:18: warning: 'compat_sys_setsockopt' alias be=
tween functions of incompatible types 'long int(int,  int,  int,  char *, u=
nsigned int)' and 'long int(long int,  long int,  long int,  long int,  lon=
g int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_socketcall' alias be=
tween functions of incompatible types 'long int(int,  u32 *)' {aka 'long in=
t(int,  unsigned int *)'} and 'long int(long int,  long int)' [-Wattribute-=
alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_recvmmsg' alias betw=
een functions of incompatible types 'long int(int,  struct compat_mmsghdr *=
, unsigned int,  unsigned int,  struct compat_timespec *)' and 'long int(lo=
ng int,  long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_recvfrom' alias betw=
een functions of incompatible types 'long int(int,  void *, compat_size_t, =
 unsigned int,  struct sockaddr *, int *)' {aka 'long int(int,  void *, uns=
igned int,  unsigned int,  struct sockaddr *, int *)'} and 'long int(long i=
nt,  long int,  long int,  long int,  long int,  long int)' [-Wattribute-al=
ias]
    include/linux/compat.h:48:18: warning: 'compat_sys_recv' alias between =
functions of incompatible types 'long int(int,  void *, compat_size_t,  uns=
igned int)' {aka 'long int(int,  void *, unsigned int,  unsigned int)'} and=
 'long int(long int,  long int,  long int,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_recvmsg' alias betwe=
en functions of incompatible types 'long int(int,  struct compat_msghdr *, =
unsigned int)' and 'long int(long int,  long int,  long int)' [-Wattribute-=
alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sendmmsg' alias betw=
een functions of incompatible types 'long int(int,  struct compat_mmsghdr *=
, unsigned int,  unsigned int)' and 'long int(long int,  long int,  long in=
t,  long int)' [-Wattribute-alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_sendmsg' alias betwe=
en functions of incompatible types 'long int(int,  struct compat_msghdr *, =
unsigned int)' and 'long int(long int,  long int,  long int)' [-Wattribute-=
alias]
    include/linux/compat.h:48:18: warning: 'compat_sys_getsockopt' alias be=
tween functions of incompatible types 'long int(int,  int,  int,  char *, i=
nt *)' and 'long int(long int,  long int,  long int,  long int,  long int)'=
 [-Wattribute-alias]
    drivers/video/fbdev/core/../edid.h:74:72: warning: '*' in boolean conte=
xt, suggest '&&' instead [-Wint-in-bool-context]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 27 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    net/socket.c:490:4: warning: 'strncpy' specified bound depends on the l=
ength of the source argument [-Wstringop-overflow=3D]

---
For more info write to <info@kernelci.org>
