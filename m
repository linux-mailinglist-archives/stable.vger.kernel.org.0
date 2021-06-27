Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F893B53AC
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 16:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhF0OWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 10:22:47 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:59245 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229973AbhF0OWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 10:22:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id E48EA19404EE;
        Sun, 27 Jun 2021 10:20:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 27 Jun 2021 10:20:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gktu8n
        fxfKIKNwJm9hxtR+yxPeyMimuGEKOUNvP7hxk=; b=PYCyT1tZhkq6+MYeTI0Xln
        qDupuyhuEGAIdd+P4xrDOr++V1lQPJKrNd2DHqMqt5qdoHsYrkt9BItX4mJ//u8w
        RCUvZ1cmcn8bhUH+3bdiJHHR+LZYP/W5kiaeCeiesXGSUiMtz9cGrFzFNGAlHLGj
        F4aXPw+AUDpRKG23AIuAMigkNqU0buByJWnXpBj4cr/huAfCXVZxvA6tTH+GULsY
        aI3gWxppI8FKCPoAkXPGWmes59dxOoSQJeaVhTzyojyWD5CzJkTfATYkrypaFBbt
        HkN2VO4G6tJ98ESjw6JUf6rb+tMUqrIMHHCEXLk/WuBUwlFWTyzbyKwdrQPBP7Ew
        ==
X-ME-Sender: <xms:JonYYFdKQJHmfPmP93Q6bWEaYe6IC-hoIF8qfMvr91Jc_4byWAeRWA>
    <xme:JonYYDPtU92vJm610s4E8vbgDq_4OoebO9pRQQtHSpjJz_g448NlosRiG6yHw8iAF
    xRzFrs2enQwbA>
X-ME-Received: <xmr:JonYYOgoPIAxNSUfVhgUNwi-KJ8-dDjbAD9Ryhb3rdfFK5OKdf0ka2SQ0kRxOqvrBn3n23kUVUJGbx_4j6JyZ19BFsrIFT3z>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehvddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:JonYYO9GIdHBGucsstGUHr5rudZ05h0mX6E3copEFecFMUOvH0vehQ>
    <xmx:JonYYBuyfdM6Xja0ipA61rXKfCQymAHQeu-osbXMJ38I0bCDHDwZZQ>
    <xmx:JonYYNGzUxbOAfsPF8afRVIlkU7aw2VL4l4Jn0Y09gfXcm3aCs1XSA>
    <xmx:JonYYLLDgve_CNRiOOSNam6uj26ebpz0dipM1thGidRaxmCARx3HxQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Jun 2021 10:20:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] s390/topology: clear thread/group maps for offline cpus" failed to apply to 5.10-stable tree
To:     svens@linux.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        mhillen@linux.ibm.com, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Jun 2021 16:20:20 +0200
Message-ID: <162480362021846@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9e3d62d55bf455d4f9fdf2ede5c8756410c64102 Mon Sep 17 00:00:00 2001
From: Sven Schnelle <svens@linux.ibm.com>
Date: Tue, 15 Jun 2021 15:05:22 +0200
Subject: [PATCH] s390/topology: clear thread/group maps for offline cpus

The current code doesn't clear the thread/group maps for offline
CPUs. This may cause kernel crashes like the one bewlow in common
code that assumes if a CPU has sibblings it is online.

Unable to handle kernel pointer dereference in virtual kernel address space

Call Trace:
 [<000000013a4b8c3c>] blk_mq_map_swqueue+0x10c/0x388
([<000000013a4b8bcc>] blk_mq_map_swqueue+0x9c/0x388)
 [<000000013a4b9300>] blk_mq_init_allocated_queue+0x448/0x478
 [<000000013a4b9416>] blk_mq_init_queue+0x4e/0x90
 [<000003ff8019d3e6>] loop_add+0x106/0x278 [loop]
 [<000003ff801b8148>] loop_init+0x148/0x1000 [loop]
 [<0000000139de4924>] do_one_initcall+0x3c/0x1e0
 [<0000000139ef449a>] do_init_module+0x6a/0x2a0
 [<0000000139ef61bc>] __do_sys_finit_module+0xa4/0xc0
 [<0000000139de9e6e>] do_syscall+0x7e/0xd0
 [<000000013a8e0aec>] __do_syscall+0xbc/0x110
 [<000000013a8ee2e8>] system_call+0x78/0xa0

Fixes: 52aeda7accb6 ("s390/topology: remove offline CPUs from CPU topology masks")
Cc: <stable@kernel.org> # 5.7+
Reported-by: Marius Hillenbrand <mhillen@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index bfcc327acc6b..26aa2614ee35 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -66,7 +66,10 @@ static void cpu_group_map(cpumask_t *dst, struct mask_info *info, unsigned int c
 {
 	static cpumask_t mask;
 
-	cpumask_copy(&mask, cpumask_of(cpu));
+	cpumask_clear(&mask);
+	if (!cpu_online(cpu))
+		goto out;
+	cpumask_set_cpu(cpu, &mask);
 	switch (topology_mode) {
 	case TOPOLOGY_MODE_HW:
 		while (info) {
@@ -83,10 +86,10 @@ static void cpu_group_map(cpumask_t *dst, struct mask_info *info, unsigned int c
 	default:
 		fallthrough;
 	case TOPOLOGY_MODE_SINGLE:
-		cpumask_copy(&mask, cpumask_of(cpu));
 		break;
 	}
 	cpumask_and(&mask, &mask, cpu_online_mask);
+out:
 	cpumask_copy(dst, &mask);
 }
 
@@ -95,7 +98,10 @@ static void cpu_thread_map(cpumask_t *dst, unsigned int cpu)
 	static cpumask_t mask;
 	int i;
 
-	cpumask_copy(&mask, cpumask_of(cpu));
+	cpumask_clear(&mask);
+	if (!cpu_online(cpu))
+		goto out;
+	cpumask_set_cpu(cpu, &mask);
 	if (topology_mode != TOPOLOGY_MODE_HW)
 		goto out;
 	cpu -= cpu % (smp_cpu_mtid + 1);

