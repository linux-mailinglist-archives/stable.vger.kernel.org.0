Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2F62A4839
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbgKCOcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:32:23 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44919 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729286AbgKCOcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 09:32:22 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B379FB21;
        Tue,  3 Nov 2020 09:32:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:32:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eB3wp/
        IdGAkr5hiVV9yaq94VmCX+E+AnJMkEIYTIEeA=; b=pNZxsVLfmzWe/tNe6JtH/n
        UKsL/4OA04K3YFjYHt5FaqXfqHwOsIi60MQsxcVt49VUOvKqixmce2MAIKGdCVol
        BZFrd/G+Zz5yXRDCBw1o1/G/Ov1r4G4G63vin8iiHcH6M0twnrLchb/ZL/obWjgs
        i3Tm6x2Fl+GIkUJ7cGT0CH2viNGiJiNIK1lj1Feo2IVmiQDNdw7oYYpVsbKV4WVL
        NGJZy3KYVB/LpR0qLJR8VAo6ms7g53z1/Fh+uSrUrkoFiZZdndXOOW+ZGfYOtFqx
        B8nOM5VvN1J8Nc+QPpMkb2P30JwJsZyVCRlbIJG5ilYIIkTOiG7h3HWPuy7cRjtw
        ==
X-ME-Sender: <xms:82mhXxLYtgiEVjZ8X7VjOQA7axcgSZxozKFUCMa4R80Zwze9DKMeqQ>
    <xme:82mhX9JHiBCEwlZb6jQnAJERqsEQyEnJJQXqLR_Y3QOjHnCjSjknh6bG2h5ZCOWQZ
    ui9MXH_kjkbow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:82mhX5uYhcMoW_eiWVMEisTIR-uG5Ov9qyuCLAFpStKztqjhi7HZNQ>
    <xmx:82mhXyaoxKSAMUeFXWe6ZJovqHxa1vrqBwqoF7AbgQ_0dqnbeQhaOA>
    <xmx:82mhX4aAGQo-jHg3DQYa3nqam7X57nPc54-P29ZRPEHR1_9zrUf7Rw>
    <xmx:9WmhXzxSnmSY-fkXeTd_0Mnw0eizrvM2QKezDEo1Ah7dWroPbP8NmWTUJhg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 30146306467D;
        Tue,  3 Nov 2020 09:32:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc: Warn about use of smt_snooze_delay" failed to apply to 4.4-stable tree
To:     joel@jms.id.au, ego@linux.vnet.ibm.com, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:33:12 +0100
Message-ID: <1604413992206127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a02f6d42357acf6e5de6ffc728e6e77faf3ad217 Mon Sep 17 00:00:00 2001
From: Joel Stanley <joel@jms.id.au>
Date: Wed, 2 Sep 2020 09:30:11 +0930
Subject: [PATCH] powerpc: Warn about use of smt_snooze_delay

It's not done anything for a long time. Save the percpu variable, and
emit a warning to remind users to not expect it to do anything.

This uses pr_warn_once instead of pr_warn_ratelimit as testing
'ppc64_cpu --smt=off' on a 24 core / 4 SMT system showed the warning
to be noisy, as the online/offline loop is slow.

Fixes: 3fa8cad82b94 ("powerpc/pseries/cpuidle: smt-snooze-delay cleanup.")
Cc: stable@vger.kernel.org # v3.14
Signed-off-by: Joel Stanley <joel@jms.id.au>
Acked-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200902000012.3440389-1-joel@jms.id.au

diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index 46b4ebc33db7..5dea98fa2f93 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -32,29 +32,27 @@
 
 static DEFINE_PER_CPU(struct cpu, cpu_devices);
 
-/*
- * SMT snooze delay stuff, 64-bit only for now
- */
-
 #ifdef CONFIG_PPC64
 
-/* Time in microseconds we delay before sleeping in the idle loop */
-static DEFINE_PER_CPU(long, smt_snooze_delay) = { 100 };
+/*
+ * Snooze delay has not been hooked up since 3fa8cad82b94 ("powerpc/pseries/cpuidle:
+ * smt-snooze-delay cleanup.") and has been broken even longer. As was foretold in
+ * 2014:
+ *
+ *  "ppc64_util currently utilises it. Once we fix ppc64_util, propose to clean
+ *  up the kernel code."
+ *
+ * powerpc-utils stopped using it as of 1.3.8. At some point in the future this
+ * code should be removed.
+ */
 
 static ssize_t store_smt_snooze_delay(struct device *dev,
 				      struct device_attribute *attr,
 				      const char *buf,
 				      size_t count)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, dev);
-	ssize_t ret;
-	long snooze;
-
-	ret = sscanf(buf, "%ld", &snooze);
-	if (ret != 1)
-		return -EINVAL;
-
-	per_cpu(smt_snooze_delay, cpu->dev.id) = snooze;
+	pr_warn_once("%s (%d) stored to unsupported smt_snooze_delay, which has no effect.\n",
+		     current->comm, current->pid);
 	return count;
 }
 
@@ -62,9 +60,9 @@ static ssize_t show_smt_snooze_delay(struct device *dev,
 				     struct device_attribute *attr,
 				     char *buf)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, dev);
-
-	return sprintf(buf, "%ld\n", per_cpu(smt_snooze_delay, cpu->dev.id));
+	pr_warn_once("%s (%d) read from unsupported smt_snooze_delay\n",
+		     current->comm, current->pid);
+	return sprintf(buf, "100\n");
 }
 
 static DEVICE_ATTR(smt_snooze_delay, 0644, show_smt_snooze_delay,
@@ -72,16 +70,10 @@ static DEVICE_ATTR(smt_snooze_delay, 0644, show_smt_snooze_delay,
 
 static int __init setup_smt_snooze_delay(char *str)
 {
-	unsigned int cpu;
-	long snooze;
-
 	if (!cpu_has_feature(CPU_FTR_SMT))
 		return 1;
 
-	snooze = simple_strtol(str, NULL, 10);
-	for_each_possible_cpu(cpu)
-		per_cpu(smt_snooze_delay, cpu) = snooze;
-
+	pr_warn("smt-snooze-delay command line option has no effect\n");
 	return 1;
 }
 __setup("smt-snooze-delay=", setup_smt_snooze_delay);

