Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2DA1D0A19
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 09:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgEMHrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 03:47:22 -0400
Received: from mail.namespace.at ([213.208.148.235]:40310 "EHLO
        mail.namespace.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730593AbgEMHrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 03:47:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deduktiva.com; s=a; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0iI0/uRAjFtQ+88SEQRRl77awTmjBfR1eiQ8PWe8MT8=; b=w9j1ZgCEHJslAx8TTD7q+XLDxh
        ydvwHEQiIu3FNUoHHVikazBvk92O5sLYyzQDWZTUnvr9m0JKmbkaMXf3KY1Ei+ll0q0Et/t2Zf0hl
        LVINeoTxgs6RGOElZGnkWHfQ+V+9PX2ygxEIZWj8Kwiir+DZYX/8vMSj0/fxgPeTbB37xxko82JNd
        PP16SHEu+YEgKlv4YoMKKHdB5KjsWMfZXRAh/3rDzHCxkVtOF5Q03WQo7kOuIkdZpTiVARE3PTfg9
        5ykHKRGwZBLjAfaVxYsXnfh9k1tEoAFpLc/45+Tet7NPlRh6IGIK+iAHyHm7ktrVhAwNy3Yq9rClt
        uXdtbuiw==;
Date:   Wed, 13 May 2020 09:47:15 +0200
From:   Chris Hofstaedtler | Deduktiva <chris.hofstaedtler@deduktiva.com>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH 03/12] lpfc: Fix broken Credit Recovery after driver load
Message-ID: <20200513074715.77buhcvy5yrv4avz@zeha.at>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
 <20200128002312.16346-4-jsmart2021@gmail.com>
 <20200512212855.36q2ut2io2cdtagn@zeha.at>
 <f75f508a-deaf-f0d3-b394-c4377f7848b5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f75f508a-deaf-f0d3-b394-c4377f7848b5@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* James Smart <jsmart2021@gmail.com> [200513 02:00]:
> On 5/12/2020 2:28 PM, Chris Hofstaedtler wrote:
> > this commit, applied in Ubuntu's 5.4.0-30.34 tree as
> > 77d5805eafdb5c42bdfe78f058ad9c40ee1278b4, appears to cause our
> > HPE-branded 2-port 8Gb lpfcs to report FLOGI errors. Reverting it fixes target
> > discovery for me. See below for log messages and HW details.
..
> 
> I'm more interested in what other patches you do or do not have in your
> tree.

I'd imagine the patches come from LP#1855303.

Please find a short log of drivers/scsi/lpfc below.
As an additional info, before we were running off Ubuntu's
5.3.0-43.36 which had lpfc 12.2.0.3.

> This is the message that threw it to the left:
> 0237 Pending Link Event during Discovery
> 
> Let me look a little.

> -- james

Many thanks,
Chris


432bc5a9f5c1 scsi: lpfc: add RDF registration and Link Integrity FPIN logging
40953bf88d5f scsi: lpfc: Copyright updates for 12.6.0.4 patches
dbbf73335448 scsi: lpfc: Update lpfc version to 12.6.0.4
e8b80ff76088 scsi: lpfc: Clean up hba max_lun_queue_depth checks
3c011ebffaef scsi: lpfc: Remove handler for obsolete ELS - Read Port Status (RPS)
9b200f712004 scsi: lpfc: Fix coverity errors in fmdi attribute handling
0be9b30cd635 scsi: lpfc: Fix compiler warning on frame size
2f985fdbaec3 scsi: lpfc: Fix release of hwq to clear the eq relationship
5acd7d9f7eea scsi: lpfc: Fix registration of ELS type support in fdmi
77d5805eafdb scsi: lpfc: Fix broken Credit Recovery after driver load
6b5806410b8f scsi: lpfc: Fix lpfc_io_buf resource leak in lpfc_get_scsi_buf_s4 error path
fa9df073dbce scsi: lpfc: Fix RQ buffer leakage when no IOCBs available
c5198e2e539b scsi: lpfc: Update lpfc version to 12.6.0.3
390e6a77e06f scsi: lpfc: Fix improper flag check for IO type
e2200d875825 scsi: lpfc: Fix MDS Latency Diagnostics Err-drop rates
038e6643ac38 scsi: lpfc: Fix unmap of dpp bars affecting next driver load
42898fe98599 scsi: lpfc: Fix disablement of FC-AL on lpe35000 models
1b6e85b0950d scsi: lpfc: Fix ras_log via debugfs
8d291637e21c scsi: lpfc: Fix Fabric hostname registration if system hostname changes
c7f141b558f6 scsi: lpfc: Fix missing check for CSF in Write Object Mbox Rsp
107a9fe98ada scsi: lpfc: Fix incomplete NVME discovery when target
45dc4914d65f scsi: lpfc: size cpu map by last cpu id set
48d76e9b38a4 scsi: lpfc: Update lpfc version to 12.6.0.2
e667dc171fe4 scsi: lpfc: revise nvme max queues to be hdwq count
db8d6e2ab615 scsi: lpfc: Initialize cpu_map for not present cpus
d7b48a096eb7 scsi: lpfc: fix inlining of lpfc_sli4_cleanup_poll_list()
d0ff88ef8591 scsi: lpfc: Fix lpfc_cpumask_of_node_init()
a41d3723e398 scsi: lpfc: Fix a kernel warning triggered by lpfc_sli4_enable_intr()
723fabed8c5e scsi: lpfc: Update lpfc version to 12.6.0.1
8c708b2e7d79 scsi: lpfc: Add enablement of multiple adapter dumps
c50fd99a1fe9 scsi: lpfc: Change default IRQ model on AMD architectures
79d488b36a1e scsi: lpfc: Add registration for CPU Offline/Online events
328383a3f61b scsi: lpfc: Clarify FAWNN error message
e45f34740925 scsi: lpfc: Sync with FC-NVMe-2 SLER change to require Conf with SLER
eaeaddbfee55 scsi: lpfc: Fix dynamic fw log enablement check
e35dc794fcdd scsi: lpfc: Fix kernel crash at lpfc_nvme_info_show during remote port bounce
4f175d5b6bca scsi: lpfc: Fix configuration of BB credit recovery in service parameters
8b22efb072fc scsi: lpfc: Make lpfc_debugfs_ras_log_data static
3323028b62de scsi: lpfc: Fix NULL check before mempool_destroy is not needed
ae036af7d4f6 scsi: lpfc: fix spelling error in MAGIC_NUMER_xxx
18c38c2053fb scsi: lpfc: fix build error of lpfc_debugfs.c for vfree/vmalloc
0df2dcbaaa0d scsi: lpfc: lpfc_nvmet: Fix Use plain integer as NULL pointer
90c3f71713d5 scsi: lpfc: lpfc_attr: Fix Use plain integer as NULL pointer
a3babc0488ff scsi: lpfc: Update lpfc version to 12.6.0.0
d7d082705c12 scsi: lpfc: Add additional discovery log messages
24dc02b77a1a scsi: lpfc: Add FC-AL support to lpe32000 models
980ed57564f6 scsi: lpfc: Add FA-WWN Async Event reporting
6ac712225cca scsi: lpfc: Add log macros to allow print by serverity or verbosity setting
2c0bc5bbd84a scsi: lpfc: Make FW logging dynamically configurable
3965a40a4e75 scsi: lpfc: Revise interrupt coalescing for missing scenarios
5078750b034c scsi: lpfc: Remove lock contention target write path
8f82561d4ed4 scsi: lpfc: Slight fast-path performance optimizations
632e3ddb91dc scsi: lpfc: fix coverity error of dereference after null check
07a9248d7ea0 scsi: lpfc: Fix lockdep errors in sli_ringtx_put
10662b03cd9f scsi: lpfc: Fix reporting of read-only fw error errors
2c737f5a5c47 scsi: lpfc: fix lpfc_nvmet_mrq to be bound by hdw queue count
ce0e7ee555b1 scsi: lpfc: Make function lpfc_defer_pt2pt_acc static
035922837ebc scsi: lpfc: Update lpfc version to 12.4.0.1
c0e0637b5639 scsi: lpfc: cleanup: remove unused fcp_txcmlpq_cnt
f6f38dbe38dd scsi: lpfc: Complete removal of FCoE T10 PI support on SLI-4 adapters
87ba9f4e1e44 scsi: lpfc: Update async event logging
53aa87d8ac63 scsi: lpfc: Fix host hang at boot or slow boot
5df05a9d6459 scsi: lpfc: Fix coverity errors on NULL pointer checks
c01400547f7a scsi: lpfc: Fix NVMe ABTS in response to receiving an ABTS
e5c93b45be68 scsi: lpfc: Fix GPF on scsi command completion
55863d7f0b03 scsi: lpfc: Fix device recovery errors after PLOGI failures
9084ef6d5222 scsi: lpfc: Fix NVME io abort failures causing hangs
e3537e7f1fe8 scsi: lpfc: Fix miss of register read failure check
88764affd6e3 scsi: lpfc: Fix premature re-enabling of interrupts in lpfc_sli_host_down
fc99d4225045 scsi: lpfc: Fix pt2pt discovery on SLI3 HBAs
15e8455c4668 UBUNTU: SAUCE: Revert "nvme_fc: add module to ops template to allow module references"
190fa9115ac0 scsi: lpfc: Fix: Rework setting of fdmi symbolic node name registration
ebd66c10c8f0 scsi: lpfc: use hdwq assigned cpu for allocation
f42c518b6b1e scsi: lpfc: Fix a kernel warning triggered by lpfc_get_sgl_per_hdwq()
1a8ce116a003 scsi: lpfc: Fix hdwq sgl locks and irq handling
3815dd60ccda scsi: lpfc: Fix list corruption detected in lpfc_put_sgl_per_hdwq
644726cf4623 scsi: lpfc: fix: Coverity: lpfc_get_scsi_buf_s3(): Null pointer dereferences
15d7e5222908 scsi: lpfc: Fix rpi release when deleting vport
5b82af018796 scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func
a7441301b20d nvme_fc: add module to ops template to allow module references
ac173a225715 scsi: lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer dereferences
170cd3bb6108 scsi: lpfc: Fix duplicate unreg_rpi error in port offline flow
46dc7c48f754 scsi: lpfc: Fix unexpected error messages during RSCN handling
6182634f0d10 scsi: lpfc: Fix SLI3 hba in loop mode not discovering devices
4b4a2235f14f scsi: lpfc: Fix hardlockup in lpfc_abort_handler
d46f5c50c520 scsi: lpfc: Fix list corruption in lpfc_sli_get_iocbq
ba7d99a490e2 scsi: lpfc: Fix locking on mailbox command completion
763e1491d43a scsi: lpfc: Fix discovery failures when target device connectivity bounces
f027d0e29db4 scsi: lpfc: Fix spinlock_irq issues in lpfc_els_flush_cmd()
a3c51276ddfc scsi: lpfc: Fix bad ndlp ptr in xri aborted handling
f83e148a4100 Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
(this merge is in 5.4 mainline)

-- 
Chris Hofstaedtler / Deduktiva GmbH (FN 418592 b, HG Wien)
www.deduktiva.com / +43 1 353 1707
