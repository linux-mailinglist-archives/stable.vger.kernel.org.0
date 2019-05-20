Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39753230A6
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 11:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbfETJty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 05:49:54 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38175 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730353AbfETJty (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 05:49:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E5C9424574;
        Mon, 20 May 2019 05:49:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 20 May 2019 05:49:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=C
        1sepVsVX9R0sUwMSr9tcIjd0xGsqGQ5crxHcPHp6Qo=; b=vFq0epEZ2ibXxjQqG
        nzNC/6JOBQtKkEguOI5mvf5SZOCkEIHDiem/MghQGYYKnrK0A8PkFefJw8XuEBwt
        T3Zhmp1a5xyrJGOV6hFOFxk5YwThWUHMBUVmUo5wZ6oNeWqcP6QIR03JfMx3Maxa
        RPq+TmwbLloFgD0p0BjxRuoGt+PlVJ9HfrACGTQyt6Bq/J+e3VU01kXK5ouHq2zE
        cOAhrZMlardlq1LByaYoK14IVAlS2rOK49cDQOUeBuGA2Zhb27c/sd+iBvA0c6qR
        MmRIpPTuH4TmA0tJoBr2GQGQXF/h1/AUJFD7dPsGSfTRkJXIXpamqNRcZSu73syK
        Ls2Uw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=C1sepVsVX9R0sUwMSr9tcIjd0xGsqGQ5crxHcPHp6
        Qo=; b=T6CpdkPtLdT1uSj1UCbzWfMV3nmTHKZe2l7FqatPzEd6N7khKNK5wka/T
        YfjE5RWZYZidef1NZcgLtZ/MwqeAmYLKaK0ua+6bGtymdgPAKdhELzmyQ2pJTqjY
        YT0dR5j43ehBrUXsekGFvI3/KJ5UhWeAY2RUQXj4snnvNtz32nixMk/2i6tfGaHw
        HUd3PM0APdP+jyOj/lVxUASm5DcR+X96YmljZeDXEBKTjuBc3OL91dVe5LkUNGRn
        3/5T6ZpqGJ8G/lp0WaeAmmrDUZQ62/WhHu+GU2uh5aXx/0a3v+xd+5IC9Nr9+j6B
        YbOwytjxG17R+oHYtahxsFIu9CnJA==
X-ME-Sender: <xms:PnjiXCtyit7_aj9_Ed-KkxckV4STUjIRhEArsk47xyqrGWxTj9--cw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtkedgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtreejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:PnjiXBhJE0YJDNVYIONxbjvYTSVQuZsKr50t2URAtOKWcc00nMfsBg>
    <xmx:PnjiXCv7q2nvDKOVoQifENRHw8oWdppSEFgXYEb9nudz5M--lKhM-A>
    <xmx:PnjiXE92dNEIj-D3Th--k2WWNasFuUXsZvgo1ReR5IObTNGvxmP-4Q>
    <xmx:PnjiXKnmkdqiZvVHX8KbBcBS2F1moParQx6sMdXb-RrWMGFgFGmaYA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DDC1B10378;
        Mon, 20 May 2019 05:49:49 -0400 (EDT)
Date:   Mon, 20 May 2019 11:49:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org,
        tj@kernel.org, stable@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 RESEND] fs/writeback: use rcu_barrier() to wait for
 inflight wb switches going into workqueue when umount
Message-ID: <20190520094948.GB23521@kroah.com>
References: <20190429024108.54150-1-jiufei.xue@linux.alibaba.com>
 <20190430103201.9C2D92080C@mail.kernel.org>
 <499a7630-551e-70a1-7a4f-c5848030461d@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <499a7630-551e-70a1-7a4f-c5848030461d@linux.alibaba.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 05, 2019 at 08:09:01PM +0800, Jiufei Xue wrote:
> 
> 
> On 2019/4/30 下午6:32, Sasha Levin wrote:
> > Hi,
> > 
> > [This is an automated email]
> > 
> > This commit has been processed because it contains a -stable tag.
> > The stable tag indicates that it's relevant for the following trees: all.
> > 
> > The bot has tested the following trees: v5.0.10, v4.19.37, v4.14.114, v4.9.171, v4.4.179, v3.18.139.
> > 
> > v5.0.10: Build OK!
> > v4.19.37: Build OK!
> > v4.14.114: Build OK!
> > v4.9.171: Failed to apply! Possible dependencies:
> >     113c60970cf4 ("x86/intel_rdt: Add Haswell feature discovery")
> >     2264d9c74dda ("x86/intel_rdt: Build structures for each resource based on cache topology")
> >     3ee7e8697d58 ("bdi: Fix another oops in wb_workfn()")
> >     4f341a5e4844 ("x86/intel_rdt: Add scheduler hook")
> >     5318ce7d4686 ("bdi: Shutdown writeback on all cgwbs in cgwb_bdi_destroy()")
> >     5b825c3af1d8 ("sched/headers: Prepare to remove <linux/cred.h> inclusion from <linux/sched.h>")
> >     5dd43ce2f69d ("sched/wait: Split out the wait_bit*() APIs from <linux/wait.h> into <linux/wait_bit.h>")
> >     5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
> >     60cf5e101fd4 ("x86/intel_rdt: Add mkdir to resctrl file system")
> >     60ec2440c63d ("x86/intel_rdt: Add schemata file")
> >     6b2bb7265f0b ("sched/wait: Introduce wait_var_event()")
> >     78e99b4a2b9a ("x86/intel_rdt: Add CONFIG, Makefile, and basic initialization")
> >     7fc5854f8c6e ("writeback: synchronize sync(2) against cgroup writeback membership switches")
> >     8236b0ae31c8 ("bdi: wake up concurrent wb_shutdown() callers.")
> >     c1c7c3f9d6bb ("x86/intel_rdt: Pick up L3/L2 RDT parameters from CPUID")
> > 
> > v4.4.179: Failed to apply! Possible dependencies:
> >     0007bccc3cfd ("x86: Replace RDRAND forced-reseed with simple sanity check")
> >     113c60970cf4 ("x86/intel_rdt: Add Haswell feature discovery")
> >     1b74dde7c47c ("x86/cpu: Convert printk(KERN_<LEVEL> ...) to pr_<level>(...)")
> >     27f6d22b037b ("perf/x86: Move perf_event.h to its new home")
> >     39b0332a2158 ("perf/x86: Move perf_event_amd.c ........... => x86/events/amd/core.c")
> >     3ee7e8697d58 ("bdi: Fix another oops in wb_workfn()")
> >     4f341a5e4844 ("x86/intel_rdt: Add scheduler hook")
> >     5318ce7d4686 ("bdi: Shutdown writeback on all cgwbs in cgwb_bdi_destroy()")
> >     5b825c3af1d8 ("sched/headers: Prepare to remove <linux/cred.h> inclusion from <linux/sched.h>")
> >     5dd43ce2f69d ("sched/wait: Split out the wait_bit*() APIs from <linux/wait.h> into <linux/wait_bit.h>")
> >     6b2bb7265f0b ("sched/wait: Introduce wait_var_event()")
> >     724697648eec ("perf/x86: Use INST_RETIRED.PREC_DIST for cycles: ppp")
> >     7fc5854f8c6e ("writeback: synchronize sync(2) against cgroup writeback membership switches")
> >     8236b0ae31c8 ("bdi: wake up concurrent wb_shutdown() callers.")
> >     fa9cbf320e99 ("perf/x86: Move perf_event.c ............... => x86/events/core.c")
> > 
> > v3.18.139: Failed to apply! Possible dependencies:
> >     0ae45f63d4ef ("vfs: add support for a lazytime mount option")
> >     4452226ea276 ("writeback: move backing_dev_info->state into bdi_writeback")
> >     52ebea749aae ("writeback: make backing_dev_info host cgroup-specific bdi_writebacks")
> >     66114cad64bf ("writeback: separate out include/linux/backing-dev-defs.h")
> >     682aa8e1a6a1 ("writeback: implement unlocked_inode_to_wb transaction and use it for stat updates")
> >     87e1d789bf55 ("writeback: implement [locked_]inode_to_wb_and_lock_list()")
> >     a3816ab0e8fe ("fs: Convert show_fdinfo functions to void")
> >     b16b1deb553a ("writeback: make writeback_control track the inode being written back")
> >     b4caecd48005 ("fs: introduce f_op->mmap_capabilities for nommu mmap support")
> >     bafc0dba1e20 ("buffer, writeback: make __block_write_full_page() honor cgroup writeback")
> > 
> > 
> > How should we proceed with this patch?
> > 
> > --
> 
> I am sorry that I forgot to mention that the patch should be applied to stable
> since v4.4.
> 
> v4.4.179 and v4.9.171 depend on the commit 7fc5854f8c6e ("writeback: synchronize sync(2) against cgroup writeback membership switches"). 
> On these two versions we can just inc isw_nr_in_flight before return.

Thanks, I've just backported 7fc5854f8c6e to those kernels now and then
this applied.

greg k-h
