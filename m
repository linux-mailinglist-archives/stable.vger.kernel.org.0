Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4529112FE1C
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 21:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgACUuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 15:50:32 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35352 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728373AbgACUuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 15:50:32 -0500
Received: by mail-qk1-f196.google.com with SMTP id z76so35146019qka.2
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 12:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NAwft+aLs7BO4WXzbFKCr7eb7xk7iXEk/fc2g9UNhBs=;
        b=fDZKDA2hAVeHkxnFds/LUnr1hHuDHbDmC0gEv7EHnyiVZ95vb59EHfH+6v5TWad+kX
         zlin2/b/9DEsvJX4+pcWnFGGEY1LggxRYvGFhax+dOwtwHF+1VX/vVP51agpkSFBeLf5
         YjIYFhFeTaESFMbWKoaZU/j8O0zQXGHFa1waeHP4vdyYVx+et3G25RYWJ36XUvlzQ+1f
         KIviiPsFsLYr9bayXbmKqKzW7Q6amqIc74TmFk3c2cjW+Yk31bscEDSvFR0odsYyc1ZJ
         Vye20YXZhBMMMUUDx3iZyqHmIjfJfkqd3wmFzkig4ZHzzvkADcMzO3eWWJwV3PWGPElZ
         Z/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NAwft+aLs7BO4WXzbFKCr7eb7xk7iXEk/fc2g9UNhBs=;
        b=eGS29c3nEyRNLcAPyZHz1tlrUyCLR7aV4tM/iSHJcF5Z00rSR8TGpuyYRKdFzOUHk+
         74W4H3KpARR9cQmtScLzJtnvYeLznwpybpy73keTZMNsY8bXATwyFidar80qCpe14P1w
         EWcsgu2YXXTS+uIyrTkd+/A87GGxyEFJevJbZxrSAYY8C02XX42M44qpG7NfXE00d4rY
         zLkLD1BZbgRD3fM5vqoVEVxFzfqis9RJNGjXkxAEo3vg0Ur4JxnzCJlPLGUjeDF0B0cT
         6s5rr2EOY8LbXJLWVVBGUhKRcWZFft0OP+3Fq7jI0sg/VIl+0hG117eQ73E71CJ7w6hH
         dzvg==
X-Gm-Message-State: APjAAAVIOltnbE14gFmjpmMCNniN8+TGgI2Kv5eLPO+ZjG9E1VYnnDqI
        TWn6pnz+VmdkSAdZCbMf3LKyOw==
X-Google-Smtp-Source: APXvYqzXPGh/oMJafIpLkljdKWL0BpGd22hgXNswPExWI1mKmHWDuqoROaeoqf0vqYdFR7E1qFAR/w==
X-Received: by 2002:a05:620a:102e:: with SMTP id a14mr70443923qkk.159.1578084630712;
        Fri, 03 Jan 2020 12:50:30 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id u4sm16822582qkh.59.2020.01.03.12.50.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Jan 2020 12:50:30 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1inTtt-0003CA-TP; Fri, 03 Jan 2020 16:50:29 -0400
Date:   Fri, 3 Jan 2020 16:50:29 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Subject: Re: [PATCH for-rc] IB/hfi1: Adjust flow PSN with the correct
 resync_psn
Message-ID: <20200103205029.GA12225@ziepe.ca>
References: <20191219231920.51069.37147.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219231920.51069.37147.stgit@awfm-01.aw.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 06:19:20PM -0500, Dennis Dalessandro wrote:
> From: Kaike Wan <kaike.wan@intel.com>
> 
> When a TID RDMA ACK to RESYNC request is received, the flow PSNs for
> pending TID RDMA WRITE segments will be adjusted with the next flow
> generation number, based on the resync_psn value extracted from the
> flow PSN of the TID RDMA ACK packet. The resync_psn value indicates
> the last flow PSN for which a TID RDMA WRITE DATA packet has been
> received by the responder and the requester should resend TID RDMA
> WRITE DATA packets, starting from the next flow PSN. However, if
> resync_psn points to the last flow PSN for a segment and the next
> segment flow PSN starts with a new generation number, use of the
> old resync_psn to adjust the flow PSN for the next segment will
> lead to miscalculation, resulting in WARN_ON and sge rewinding
> errors:
> [2419460.492485] WARNING: CPU: 4 PID: 146961 at /nfs/site/home/phcvs2/gitrepo/ifs-all/components/Drivers/tmp/rpmbuild/BUILD/ifs-kernel-updates-3.10.0_957.el7.x86_64/hfi1/tid_rdma.c:4764 hfi1_rc_rcv_tid_rdma_ack+0x8f6/0xa90 [hfi1]
> [2419460.514565] Modules linked in: ib_ipoib(OE) hfi1(OE) rdmavt(OE) rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfsv3 nfs_acl nfs lockd grace fscache iTCO_wdt iTCO_vendor_support skx_edac intel_powerclamp coretemp intel_rapl iosf_mbi kvm irqbypass crc32_pclmul ghash_clmulni_intel ib_isert iscsi_target_mod target_core_mod aesni_intel lrw gf128mul glue_helper ablk_helper cryptd rpcrdma sunrpc opa_vnic ast ttm ib_iser libiscsi drm_kms_helper scsi_transport_iscsi ipmi_ssif syscopyarea sysfillrect sysimgblt fb_sys_fops drm joydev ipmi_si pcspkr sg drm_panel_orientation_quirks ipmi_devintf lpc_ich i2c_i801 ipmi_msghandler wmi rdma_ucm ib_ucm ib_uverbs acpi_cpufreq acpi_power_meter ib_umad rdma_cm ib_cm iw_cm ip_tables ext4 mbcache jbd2 sd_mod crc_t10dif crct10dif_generic crct10dif_pclmul i2c_algo_bit crct10dif_common
> [2419460.594432]  crc32c_intel e1000e ib_core ahci libahci ptp libata pps_core nfit libnvdimm [last unloaded: rdmavt]
> [2419460.605645] CPU: 4 PID: 146961 Comm: kworker/4:0H Kdump: loaded Tainted: G        W  OE  ------------   3.10.0-957.el7.x86_64 #1
> [2419460.619424] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.0X.02.0117.040420182310 04/04/2018
> [2419460.631062] Workqueue: hfi0_0 _hfi1_do_tid_send [hfi1]
> [2419460.637423] Call Trace:
> [2419460.641044]  <IRQ>  [<ffffffff9e361dc1>] dump_stack+0x19/0x1b
> [2419460.647980]  [<ffffffff9dc97648>] __warn+0xd8/0x100
> [2419460.654023]  [<ffffffff9dc9778d>] warn_slowpath_null+0x1d/0x20
> [2419460.661025]  [<ffffffffc05d28c6>] hfi1_rc_rcv_tid_rdma_ack+0x8f6/0xa90 [hfi1]
> [2419460.669333]  [<ffffffffc05c21cc>] hfi1_kdeth_eager_rcv+0x1dc/0x210 [hfi1]
> [2419460.677295]  [<ffffffffc05c23ef>] ? hfi1_kdeth_expected_rcv+0x1ef/0x210 [hfi1]
> [2419460.685693]  [<ffffffffc0574f15>] kdeth_process_eager+0x35/0x90 [hfi1]
> [2419460.693394]  [<ffffffffc0575b5a>] handle_receive_interrupt_nodma_rtail+0x17a/0x2b0 [hfi1]
> [2419460.702745]  [<ffffffffc056a623>] receive_context_interrupt+0x23/0x40 [hfi1]
> [2419460.710963]  [<ffffffff9dd4a294>] __handle_irq_event_percpu+0x44/0x1c0
> [2419460.718659]  [<ffffffff9dd4a442>] handle_irq_event_percpu+0x32/0x80
> [2419460.726086]  [<ffffffff9dd4a4cc>] handle_irq_event+0x3c/0x60
> [2419460.732903]  [<ffffffff9dd4d27f>] handle_edge_irq+0x7f/0x150
> [2419460.739710]  [<ffffffff9dc2e554>] handle_irq+0xe4/0x1a0
> [2419460.746091]  [<ffffffff9e3795dd>] do_IRQ+0x4d/0xf0
> [2419460.752040]  [<ffffffff9e36b362>] common_interrupt+0x162/0x162
> [2419460.759029]  <EOI>  [<ffffffff9dfa0f79>] ? swiotlb_map_page+0x49/0x150
> [2419460.766758]  [<ffffffffc05c2ed1>] hfi1_verbs_send_dma+0x291/0xb70 [hfi1]
> [2419460.774637]  [<ffffffffc05c2c40>] ? hfi1_wait_kmem+0xf0/0xf0 [hfi1]
> [2419460.782080]  [<ffffffffc05c3f26>] hfi1_verbs_send+0x126/0x2b0 [hfi1]
> [2419460.789606]  [<ffffffffc05ce683>] _hfi1_do_tid_send+0x1d3/0x320 [hfi1]
> [2419460.797298]  [<ffffffff9dcb9d4f>] process_one_work+0x17f/0x440
> [2419460.804292]  [<ffffffff9dcbade6>] worker_thread+0x126/0x3c0
> [2419460.811025]  [<ffffffff9dcbacc0>] ? manage_workers.isra.25+0x2a0/0x2a0
> [2419460.818710]  [<ffffffff9dcc1c31>] kthread+0xd1/0xe0
> [2419460.824751]  [<ffffffff9dcc1b60>] ? insert_kthread_work+0x40/0x40
> [2419460.832013]  [<ffffffff9e374c1d>] ret_from_fork_nospec_begin+0x7/0x21
> [2419460.839611]  [<ffffffff9dcc1b60>] ? insert_kthread_work+0x40/0x40
> 
> This patch fixes the issue by adjusting the resync_psn first if the flow
> generation has been advanced for a pending segment.
> 
> Fixes: 9e93e967f7b4 ("IB/hfi1: Add a function to receive TID RDMA ACK packet")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Kaike Wan <kaike.wan@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>  drivers/infiniband/hw/hfi1/tid_rdma.c |    9 +++++++++
>  1 file changed, 9 insertions(+)

Applied to for-rc, thanks

Jason
