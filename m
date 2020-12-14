Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06312D99DD
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgLNOZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:25:44 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:51101 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727084AbgLNOZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:25:37 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1B20A1942DC6;
        Mon, 14 Dec 2020 09:24:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 14 Dec 2020 09:24:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zB5yHP
        TxFwPFltU5UGyFwn4qFqLah+0InT3C0XiJO1s=; b=HyWBH0QRGo3Mj9Ed+1TSWP
        hS/elJHehiGEGxe0a6vUzrNPKRNGYm97GvXbTtLwEySV92fE+b9ko94rnaAncfY1
        dp3QyW0KAwv3AIVWUhhevpq1pVxv+0/NQSXh7uGw0Kvk0vMiGtLeD/Uyt5xKumZ8
        xlvxmp5bAQjHCQByN5UGNPq62xYNxaBtcO1Ki9hO6NP6f92Vj2mUuTAyUXcXpw95
        nqex/vVXKvq/HBJI/0lXFNfPcO3l7Rgplm8zcFQ/eIlPdo51e3YbfmVTKQmcUnzX
        Y0I3YgMUJKAd4YlWk+ReBjeRTcRjD6YrFtvn2j6HzFDUAzYBB/zNciu6GpOj0LVg
        ==
X-ME-Sender: <xms:rnXXXzRjwGYI-zlWDuRBU9v17cPU5F2P_2mMLczhjPTbBYAovGRNnw>
    <xme:rnXXX0wR8WzYqyOibhTISqFsDI46u62f38g3CHeqbyX48Zi3pCzF7txFaaOrr9gEq
    kfr_-PH4mqJ8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnheptdeuveeuudfhtdfftddvieetteekgefgueevtefgfe
    efueetffegvdeileduveeknecuffhomhgrihhnpehgihhthhhusgdrtghomhdpkhgvrhhn
    vghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:r3XXX439nskhSKAoqvma2VdGLNtPhbSFDxn0ubbzvC01E5LivTtpRw>
    <xmx:r3XXXzAPXvnRcidR6JxlZ_PtGTdn_JHk81S5nn7XZNIRwKz632RNHQ>
    <xmx:r3XXX8hbNYtFPFFvTbpdVsB8vg2eLksRAeak-K-x1ZwBkVsyY-6UvQ>
    <xmx:r3XXX4bQ1a2-bXNmLYJOlOlR60glDL9cU59Bl0397RZFYjMFzmvvag>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B7849108005B;
        Mon, 14 Dec 2020 09:24:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/resctrl: Fix incorrect local bandwidth when mba_sc is" failed to apply to 5.4-stable tree
To:     xiaochen.shen@intel.com, bp@suse.de, stable@vger.kernel.org,
        tony.luck@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:25:53 +0100
Message-ID: <1607955953140184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 06c5fe9b12dde1b62821f302f177c972bb1c81f9 Mon Sep 17 00:00:00 2001
From: Xiaochen Shen <xiaochen.shen@intel.com>
Date: Fri, 4 Dec 2020 14:27:59 +0800
Subject: [PATCH] x86/resctrl: Fix incorrect local bandwidth when mba_sc is
 enabled

The MBA software controller (mba_sc) is a feedback loop which
periodically reads MBM counters and tries to restrict the bandwidth
below a user-specified value. It tags along the MBM counter overflow
handler to do the updates with 1s interval in mbm_update() and
update_mba_bw().

The purpose of mbm_update() is to periodically read the MBM counters to
make sure that the hardware counter doesn't wrap around more than once
between user samplings. mbm_update() calls __mon_event_count() for local
bandwidth updating when mba_sc is not enabled, but calls mbm_bw_count()
instead when mba_sc is enabled. __mon_event_count() will not be called
for local bandwidth updating in MBM counter overflow handler, but it is
still called when reading MBM local bandwidth counter file
'mbm_local_bytes', the call path is as below:

  rdtgroup_mondata_show()
    mon_event_read()
      mon_event_count()
        __mon_event_count()

In __mon_event_count(), m->chunks is updated by delta chunks which is
calculated from previous MSR value (m->prev_msr) and current MSR value.
When mba_sc is enabled, m->chunks is also updated in mbm_update() by
mistake by the delta chunks which is calculated from m->prev_bw_msr
instead of m->prev_msr. But m->chunks is not used in update_mba_bw() in
the mba_sc feedback loop.

When reading MBM local bandwidth counter file, m->chunks was changed
unexpectedly by mbm_bw_count(). As a result, the incorrect local
bandwidth counter which calculated from incorrect m->chunks is shown to
the user.

Fix this by removing incorrect m->chunks updating in mbm_bw_count() in
MBM counter overflow handler, and always calling __mon_event_count() in
mbm_update() to make sure that the hardware local bandwidth counter
doesn't wrap around.

Test steps:
  # Run workload with aggressive memory bandwidth (e.g., 10 GB/s)
  git clone https://github.com/intel/intel-cmt-cat && cd intel-cmt-cat
  && make
  ./tools/membw/membw -c 0 -b 10000 --read

  # Enable MBA software controller
  mount -t resctrl resctrl -o mba_MBps /sys/fs/resctrl

  # Create control group c1
  mkdir /sys/fs/resctrl/c1

  # Set MB throttle to 6 GB/s
  echo "MB:0=6000;1=6000" > /sys/fs/resctrl/c1/schemata

  # Write PID of the workload to tasks file
  echo `pidof membw` > /sys/fs/resctrl/c1/tasks

  # Read local bytes counters twice with 1s interval, the calculated
  # local bandwidth is not as expected (approaching to 6 GB/s):
  local_1=`cat /sys/fs/resctrl/c1/mon_data/mon_L3_00/mbm_local_bytes`
  sleep 1
  local_2=`cat /sys/fs/resctrl/c1/mon_data/mon_L3_00/mbm_local_bytes`
  echo "local b/w (bytes/s):" `expr $local_2 - $local_1`

Before fix:
  local b/w (bytes/s): 11076796416

After fix:
  local b/w (bytes/s): 5465014272

Fixes: ba0f26d8529c (x86/intel_rdt/mba_sc: Prepare for feedback loop)
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/1607063279-19437-1-git-send-email-xiaochen.shen@intel.com

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 54dffe574e67..a98519a3a2e6 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -279,7 +279,6 @@ static void mbm_bw_count(u32 rmid, struct rmid_read *rr)
 		return;
 
 	chunks = mbm_overflow_count(m->prev_bw_msr, tval, rr->r->mbm_width);
-	m->chunks += chunks;
 	cur_bw = (chunks * r->mon_scale) >> 20;
 
 	if (m->delta_comp)
@@ -450,15 +449,14 @@ static void mbm_update(struct rdt_resource *r, struct rdt_domain *d, int rmid)
 	}
 	if (is_mbm_local_enabled()) {
 		rr.evtid = QOS_L3_MBM_LOCAL_EVENT_ID;
+		__mon_event_count(rmid, &rr);
 
 		/*
 		 * Call the MBA software controller only for the
 		 * control groups and when user has enabled
 		 * the software controller explicitly.
 		 */
-		if (!is_mba_sc(NULL))
-			__mon_event_count(rmid, &rr);
-		else
+		if (is_mba_sc(NULL))
 			mbm_bw_count(rmid, &rr);
 	}
 }

