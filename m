Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0265097F2
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 08:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385091AbiDUGq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 02:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385153AbiDUGqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 02:46:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC6315A19
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 23:42:59 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L5lQMD025371;
        Thu, 21 Apr 2022 06:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=JI/OxNbe9GilHfJEtQLuh2yDtGSSLsOGHdURvKv2qVw=;
 b=rDwoSxlc6gw/gPJpmEdv+D78ttYLd/Idr91NU6KgTVKtVMklILa7EiZqX/Cb1pqAbRnJ
 sJyjB+JzFn3yjJS+V7ELXFUBMAbIs4dAfor+gtg/5SnqDPiAq9tNw1cdPbNNJ9NS1oCj
 JXK+UN39ewbbeb8o1ftPSJf5hP12aU48qY0ndeb81ArYzwXk0gZowh3vk5psu5YK3Lgj
 uGTwpDW0cAk6GJVUS563KPBTxs29MiRJEdownlHbrnD29ZM+UxDQdSnpuYkuECm6Xi0h
 eQBFO3mI66HZHUUUQPLJ8E1fH/P9J1alg6E1clTf6R/JZZLx6aXSSXvJFchK9nBlINmE BQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjf52f9t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 06:42:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23L6YIA0031100;
        Thu, 21 Apr 2022 06:42:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3ffn2hyd83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 06:42:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23L6go0l48300506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 06:42:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ACB642041;
        Thu, 21 Apr 2022 06:42:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25E754203F;
        Thu, 21 Apr 2022 06:42:38 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.8.1])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 21 Apr 2022 06:42:38 +0000 (GMT)
Date:   Thu, 21 Apr 2022 09:42:36 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Tony Lindgren <tony@atomide.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernelci-results@groups.io, bot@kernelci.org,
        gtucker@collabora.com, stable@vger.kernel.org
Subject: Re: stable-rc/linux-5.4.y bisection: baseline.login on
 qemu_arm-virt-gicv2-uefi
Message-ID: <YmD83PYEMhzqehXo@linux.ibm.com>
References: <625c8753.1c69fb81.b232.69bb@mx.google.com>
 <Yl65zxGgFzF1Okac@sirena.org.uk>
 <Yl/PzFKR6U0bH43T@linux.ibm.com>
 <Yl/3Z+QMCPbDafbC@sirena.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl/3Z+QMCPbDafbC@sirena.org.uk>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gtsQEVZ8Pw8Pvn5p2szYVZCANs1cBIVN
X-Proofpoint-ORIG-GUID: gtsQEVZ8Pw8Pvn5p2szYVZCANs1cBIVN
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 01:07:03PM +0100, Mark Brown wrote:
> On Wed, Apr 20, 2022 at 12:18:04PM +0300, Mike Rapoport wrote:
> 
> > I don't know how exactly kernel-ci runs qemu with UEFI, I've tried this:
> 
> > $QEMU -serial stdio -M virt-2.11,gic-version=2 -cpu cortex-a15 -m 1G \
> > -drive file=$QEMU_EFI,if=pflash,format=raw,unit=0,readonly=on \
> > -drive file=flash1.img,if=pflash,format=raw,unit=1,readonly=off \
> > -kernel $kernel \
> > -append "console=ttyAMA0" 
> 
> > with stable-rc/linux-5.4.y and I've got as far as to failure to mount
> > rootfs and the crash in dmu_setup() didn't reproduce for me.
> 
> The command should be something to the effect of:
> 
> qemu-system-aarch64 -cpu max -machine virt,gic-version=3,mte=on,accel=tcg -nographic -net nic,model=virtio,macaddr=52:54:00:12:34:58 -net user -m 512 -monitor none -bios /var/lib/lava/dispatcher/tmp/75061/deployimages-ptln1wlp/bios/QEMU_EFI.fd -kernel /var/lib/lava/dispatcher/tmp/75061/deployimages-ptln1wlp/kernel/Image -append "console=ttyAMA0,115200 root=/dev/ram0 debug verbose console_msg_format=syslog earlycon" -initrd /var/lib/lava/dispatcher/tmp/75061/deployimages-ptln1wlp/ramdisk/rootfs.cpio.gz -drive format=qcow2,file=/var/lib/lava/dispatcher/tmp/75061/apply-overlay-guest-6hyfr8ki/lava-guest.qcow2,media=disk,if=virtio,id=lavatest

I could reproduce with this, thanks!

The problem is that memremap() uses pfn_valid() to check if RAM resource can
be accessed via linear mapping and this check is wrong.
The problem does not manifest on more recent kernels because the way ARM
registers "System RAM" resources was updated so that it skipped NOMAP
memory.

Can you please give a whirl to the patch below? If it's Ok I'll extend it
to include arm64 and will send a formal patch.


diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 7a0596fcb2e7..2df7454be649 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -144,6 +144,10 @@ extern void __iomem * (*arch_ioremap_caller)(phys_addr_t, size_t,
 	unsigned int, void *);
 extern void (*arch_iounmap)(volatile void __iomem *);
 
+extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+					unsigned long flags);
+#define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
+
 /*
  * Bad read/write accesses...
  */
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 513c26b46db3..98f90cd5a948 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -42,6 +42,13 @@
 #include <asm/mach/pci.h>
 #include "mm.h"
 
+bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+				 unsigned long flags)
+{
+	unsigned long pfn = PHYS_PFN(offset);
+
+	return memblock_is_map_memory(pfn);
+}
 
 LIST_HEAD(static_vmlist);
 
diff --git a/kernel/iomem.c b/kernel/iomem.c
index 62c92e43aa0d..e85bed24c0a9 100644
--- a/kernel/iomem.c
+++ b/kernel/iomem.c
@@ -33,7 +33,7 @@ static void *try_ram_remap(resource_size_t offset, size_t size,
 	unsigned long pfn = PHYS_PFN(offset);
 
 	/* In the simple case just return the existing linear address */
-	if (pfn_valid(pfn) && !PageHighMem(pfn_to_page(pfn)) &&
+	if (!PageHighMem(pfn_to_page(pfn)) &&
 	    arch_memremap_can_ram_remap(offset, size, flags))
 		return __va(offset);
 
 
> (with different paths) where QEMU_EFI.fd is:
> 
>    http://storage.kernelci.org/images/uefi/edk2-stable202005/arm64/QEMU_EFI.fd
> 
> I didn't pull an exact job, sorry.  A full job showing the expected flow
> (for GICv3 which shows the same thing) is at:
> 
>    https://lava.sirena.org.uk/scheduler/job/75061



-- 
Sincerely yours,
Mike.
