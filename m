Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88612DA04A
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440567AbgLNTWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441042AbgLNTWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 14:22:03 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266CFC0613D3
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 11:21:23 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id r3so17590966wrt.2
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 11:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+X7iw70TrrJxQc0dtfaHnv3RrOdb5AVxhDktjnDDcDE=;
        b=qQ+dsVRunDvjCAy0g/PnviSLuz4UDPfhKtiURuMqkym1ibI5zIuhbd3M0VGwHZPu/Q
         x3jWZmCn6itNfE1MZ4rlSfnvEfPdJXIPDDLFIJl/tA2TdaHsaMjaWM71GLTRl8PwmJzJ
         0Y2QXwvLeUYgKrZSHl1hYz096HY8+3jyFLIqnE1l0zhwZ2PLdROciNgcKetkvn80cs/s
         oVsFJsoZQPK1xmSIscod9HitHPDj9/S7QzWdKHO+/zE1eR4oyMrYehlvM7Qkhzkd5LKP
         f74HXQ60E+DbvXtNRLzSKe9z/pa9Ylx5+pO5r/yfCr3zSdxBv6wYPBZJbX3+5sEV229U
         h7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+X7iw70TrrJxQc0dtfaHnv3RrOdb5AVxhDktjnDDcDE=;
        b=XdlLv759n6wCqX3djz0MGUfIihN2fJIxMbJ5M6y7G1YlPV0v+8/ovKI0xITKA6vXh7
         Shcr089HpICIlbpvg3YVld0jbRoxCcE2vd5yvq0C2ns9U22tMCajcXhlTY0B7I4btiBl
         2zvAiL8ASyj0iF9Uq8d3uEOnf3+48ZN8czfGJZiXCr6dLC49s02Kf4Z7zSVjiJc86Tt3
         16QSMmyWK1wObfL9FYDh/eaLaO/76W4WaH513tF2ebyZt2Olgj1vLpFvTKKbX/HcA0QZ
         ts1sxZ8cINsY/H5acPQ5jb88qxCIRXFZJ8wK2NZXmYQvvef7AxwX4UsLuoGMtqHyKhR2
         0iJw==
X-Gm-Message-State: AOAM530TlLSWwqymSVI0inSRE6mNlBGgLLL9LFhKj1dttrpLxB07PWxj
        GH2GNIN+vAcr+WpWjZfUi+9cvsEV9DOjew==
X-Google-Smtp-Source: ABdhPJwyP32c6WblyG416wg8CB9UTMee0Or/DSMzEDPmVL+lxB6koNBLAfA34C6AUhlnA+hlhhPg6w==
X-Received: by 2002:a5d:5604:: with SMTP id l4mr30177409wrv.127.1607973681844;
        Mon, 14 Dec 2020 11:21:21 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id l8sm32418053wmf.35.2020.12.14.11.21.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 11:21:20 -0800 (PST)
Date:   Mon, 14 Dec 2020 19:21:18 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     xiaochen.shen@intel.com, bp@suse.de, stable@vger.kernel.org,
        tony.luck@intel.com
Subject: Re: FAILED: patch "[PATCH] x86/resctrl: Fix incorrect local
 bandwidth when mba_sc is" failed to apply to 5.4-stable tree
Message-ID: <20201214192118.xae2vqn5y5qlcquy@debian>
References: <1607955953140184@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2g5p6rywedvgbt4i"
Content-Disposition: inline
In-Reply-To: <1607955953140184@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2g5p6rywedvgbt4i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 14, 2020 at 03:25:53PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport with abe8f12b4425 ("x86/resctrl: Remove unused struct mbm_state::chunks_bw")
which makes the backport easy.

--
Regards
Sudip

--2g5p6rywedvgbt4i
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-x86-resctrl-Remove-unused-struct-mbm_state-chunks_bw.patch"

From 588bb4819bd29978d16081fd50f6c1d99d95b234 Mon Sep 17 00:00:00 2001
From: James Morse <james.morse@arm.com>
Date: Wed, 8 Jul 2020 16:39:20 +0000
Subject: [PATCH 1/2] x86/resctrl: Remove unused struct mbm_state::chunks_bw

commit abe8f12b44250d02937665033a8b750c1bfeb26e upstream

Nothing reads struct mbm_states's chunks_bw value, its a copy of
chunks. Remove it.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lkml.kernel.org/r/20200708163929.2783-2-james.morse@arm.com
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h | 2 --
 arch/x86/kernel/cpu/resctrl/monitor.c  | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 17095435c875..499cb2e727a0 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -276,7 +276,6 @@ struct rftype {
  * struct mbm_state - status for each MBM counter in each domain
  * @chunks:	Total data moved (multiply by rdt_group.mon_scale to get bytes)
  * @prev_msr	Value of IA32_QM_CTR for this RMID last time we read it
- * @chunks_bw	Total local data moved. Used for bandwidth calculation
  * @prev_bw_msr:Value of previous IA32_QM_CTR for bandwidth counting
  * @prev_bw	The most recent bandwidth in MBps
  * @delta_bw	Difference between the current and previous bandwidth
@@ -285,7 +284,6 @@ struct rftype {
 struct mbm_state {
 	u64	chunks;
 	u64	prev_msr;
-	u64	chunks_bw;
 	u64	prev_bw_msr;
 	u32	prev_bw;
 	u32	delta_bw;
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 0cf4f87f6012..f62db1353945 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -280,8 +280,7 @@ static void mbm_bw_count(u32 rmid, struct rmid_read *rr)
 		return;
 
 	chunks = mbm_overflow_count(m->prev_bw_msr, tval);
-	m->chunks_bw += chunks;
-	m->chunks = m->chunks_bw;
+	m->chunks += chunks;
 	cur_bw = (chunks * r->mon_scale) >> 20;
 
 	if (m->delta_comp)
-- 
2.11.0


--2g5p6rywedvgbt4i
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-x86-resctrl-Fix-incorrect-local-bandwidth-when-mba_s.patch"

From 6e4bf9f372b1c0fa200ac473979456db8c104d0d Mon Sep 17 00:00:00 2001
From: Xiaochen Shen <xiaochen.shen@intel.com>
Date: Fri, 4 Dec 2020 14:27:59 +0800
Subject: [PATCH 2/2] x86/resctrl: Fix incorrect local bandwidth when mba_sc is enabled

commit 06c5fe9b12dde1b62821f302f177c972bb1c81f9 upstream

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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index f62db1353945..50f683ecd2c6 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -280,7 +280,6 @@ static void mbm_bw_count(u32 rmid, struct rmid_read *rr)
 		return;
 
 	chunks = mbm_overflow_count(m->prev_bw_msr, tval);
-	m->chunks += chunks;
 	cur_bw = (chunks * r->mon_scale) >> 20;
 
 	if (m->delta_comp)
@@ -450,15 +449,14 @@ static void mbm_update(struct rdt_domain *d, int rmid)
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
-- 
2.11.0


--2g5p6rywedvgbt4i--
