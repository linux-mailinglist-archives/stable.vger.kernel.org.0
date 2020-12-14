Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7E22DA04F
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441101AbgLNTX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441014AbgLNTXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 14:23:12 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621F0C0613D3
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 11:22:32 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id g185so16305779wmf.3
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 11:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=coEqg7yoL806mnpT6oYjzfyM6SHCU4Sxsa/Eh/XCboY=;
        b=Ihvn3asSij2hw4GuW6woo5MvrgkClTvhwvdIxRby8ydaHA4jevSamNpn/S8KX5iZfG
         1OcRqfx1pjNQpgC/Y/s3pejz07wLEyppsEU//e/o/B+RPi3pbmf1MxI3u9MMXzlOAZks
         6NsrWrhG8tDVsxJz8XLMLPd/xXNiLatTQ0aUEtu4jYnFzFEA2X4KorNj1tZiTg92CtCJ
         nm6jJsHgE2UAtpGozO7bf/7VIaKM3S1SJvWHX+jcQnOqgldQYdtPHksHPtmxuWZLJQKQ
         qiWMuQQl6lSO4dUoXjXS9S2qxBbbrO4hWZRAXAi+qW1395PKekOXpJiMWMtZqSlYnD4E
         PA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=coEqg7yoL806mnpT6oYjzfyM6SHCU4Sxsa/Eh/XCboY=;
        b=NLNimV9L6W672tpPEeiIA10esa5m0pzxx90k4IaHpwYZpeSuH2J2ESJPEOmnKg/Y+j
         yphKSshgaCITovrX76JlmLqHlR5S74I/TW7S65Oq42LQhaujxpybNh95BfuiTJ9Wkz1K
         g+A6zqu3QaxXxv6DoLyMZwzpUbQV1wDuybL0u19TPq88aQcKucv0dPR3Pa3bNyUxDqFV
         Nk766jHrKu0VrxzM/k8Exm3FCQ0BYNem8w7PmtOeIhgPSF7FWTRJ378FXJdL7M7Z278S
         h52HXB/+bq4WcWj5JBq9V83TPf04HwQnSbPj9wS+3F1Dwr4UC0VIiG8i/DM8JKj2Qf2q
         k8ZA==
X-Gm-Message-State: AOAM531M7AxctY1fYUtPO4fxSQLkThkiExhk4pSZu9LagJGHM2xkITKB
        u9/G6zsbnkgmfYqUXAdn0HllaXa7Ip+IFA==
X-Google-Smtp-Source: ABdhPJyjKYDpGkiSd+ZMvEduzvanBlVwPppxqq4X2kXxw+6srJZ4n0NRVIIS4dCVoaauKfS/BFnguQ==
X-Received: by 2002:a1c:64c4:: with SMTP id y187mr25040028wmb.165.1607973751143;
        Mon, 14 Dec 2020 11:22:31 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id 138sm36377327wma.41.2020.12.14.11.22.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 11:22:30 -0800 (PST)
Date:   Mon, 14 Dec 2020 19:22:28 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     xiaochen.shen@intel.com, bp@suse.de, stable@vger.kernel.org,
        tony.luck@intel.com
Subject: Re: FAILED: patch "[PATCH] x86/resctrl: Fix incorrect local
 bandwidth when mba_sc is" failed to apply to 4.19-stable tree
Message-ID: <20201214192228.zbnruzdap67m4uxo@debian>
References: <1607955955252233@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bnylxes2qj3wn63a"
Content-Disposition: inline
In-Reply-To: <1607955955252233@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bnylxes2qj3wn63a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 14, 2020 at 03:25:55PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.


Here is the backport with abe8f12b4425 ("x86/resctrl: Remove unused struct mbm_state::chunks_bw")
which makes the backport easy.

--
Regards
Sudip

--bnylxes2qj3wn63a
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-x86-resctrl-Remove-unused-struct-mbm_state-chunks_bw.patch"

From 269df62e154d3f7a5bed22b81e0a6389530bf078 Mon Sep 17 00:00:00 2001
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
[sudip: manual backport to file at old path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/kernel/cpu/intel_rdt.h         | 2 --
 arch/x86/kernel/cpu/intel_rdt_monitor.c | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt.h b/arch/x86/kernel/cpu/intel_rdt.h
index 2b483b739cf1..8412234eabd3 100644
--- a/arch/x86/kernel/cpu/intel_rdt.h
+++ b/arch/x86/kernel/cpu/intel_rdt.h
@@ -251,7 +251,6 @@ struct rftype {
  * struct mbm_state - status for each MBM counter in each domain
  * @chunks:	Total data moved (multiply by rdt_group.mon_scale to get bytes)
  * @prev_msr	Value of IA32_QM_CTR for this RMID last time we read it
- * @chunks_bw	Total local data moved. Used for bandwidth calculation
  * @prev_bw_msr:Value of previous IA32_QM_CTR for bandwidth counting
  * @prev_bw	The most recent bandwidth in MBps
  * @delta_bw	Difference between the current and previous bandwidth
@@ -260,7 +259,6 @@ struct rftype {
 struct mbm_state {
 	u64	chunks;
 	u64	prev_msr;
-	u64	chunks_bw;
 	u64	prev_bw_msr;
 	u32	prev_bw;
 	u32	delta_bw;
diff --git a/arch/x86/kernel/cpu/intel_rdt_monitor.c b/arch/x86/kernel/cpu/intel_rdt_monitor.c
index 3d4ec80a6bb9..a9f25200fc0f 100644
--- a/arch/x86/kernel/cpu/intel_rdt_monitor.c
+++ b/arch/x86/kernel/cpu/intel_rdt_monitor.c
@@ -290,8 +290,7 @@ static void mbm_bw_count(u32 rmid, struct rmid_read *rr)
 		return;
 
 	chunks = mbm_overflow_count(m->prev_bw_msr, tval);
-	m->chunks_bw += chunks;
-	m->chunks = m->chunks_bw;
+	m->chunks += chunks;
 	cur_bw = (chunks * r->mon_scale) >> 20;
 
 	if (m->delta_comp)
-- 
2.11.0


--bnylxes2qj3wn63a
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-x86-resctrl-Fix-incorrect-local-bandwidth-when-mba_s.patch"

From 91dd29a5524e8c5547ff9dda0c858cc2aeb54ccc Mon Sep 17 00:00:00 2001
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
[sudip: manual backport to file at old path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/kernel/cpu/intel_rdt_monitor.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt_monitor.c b/arch/x86/kernel/cpu/intel_rdt_monitor.c
index a9f25200fc0f..5dfa5ab9a5ae 100644
--- a/arch/x86/kernel/cpu/intel_rdt_monitor.c
+++ b/arch/x86/kernel/cpu/intel_rdt_monitor.c
@@ -290,7 +290,6 @@ static void mbm_bw_count(u32 rmid, struct rmid_read *rr)
 		return;
 
 	chunks = mbm_overflow_count(m->prev_bw_msr, tval);
-	m->chunks += chunks;
 	cur_bw = (chunks * r->mon_scale) >> 20;
 
 	if (m->delta_comp)
@@ -460,15 +459,14 @@ static void mbm_update(struct rdt_domain *d, int rmid)
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


--bnylxes2qj3wn63a--
