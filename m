Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4509E8075D
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 19:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbfHCRJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 13:09:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728098AbfHCRJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 13:09:57 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FF3A2073D;
        Sat,  3 Aug 2019 17:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564852196;
        bh=nnvxeM6zq1OXOD8GQEI8rkyzI6Ll6gVypTEPahNXz+o=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=B2Yc5WdbTnxrgfm82jc6U3BpxunWgcXNncLmxnQHTyNKE12k2+hS/plf0SPoBlwSd
         rxRS0tjG07ILYnbgkmVHvGCfKOEcdLmANUep+cBl52uT8wuogPP5Uszwo7EllEb3En
         6uBqkPCcIhAKEuJ9owFi/fMH+3sIf6jNTxLOvUqw=
Date:   Sat, 03 Aug 2019 17:09:55 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Trond Myklebust <trondmy@gmail.com>
To:     linux-nfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/8] NFSv4: Fix delegation state recovery
In-Reply-To: <20190803145826.15504-2-trond.myklebust@hammerspace.com>
References: <20190803145826.15504-2-trond.myklebust@hammerspace.com>
Message-Id: <20190803170956.3FF3A2073D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 24311f884189 NFSv4: Recovery of recalled read delegations is broken.

The bot has tested the following trees: v5.2.5, v4.19.63, v4.14.135, v4.9.186, v4.4.186.

v5.2.5: Build OK!
v4.19.63: Failed to apply! Possible dependencies:
    07d02a67b7fa ("SUNRPC: Simplify lookup code")
    79b181810285 ("SUNRPC: Convert auth creds to use refcount_t")
    8276c902bbe9 ("SUNRPC: remove uid and gid from struct auth_cred")
    95cd623250ad ("SUNRPC: Clean up the AUTH cache code")
    97f68c6b02e0 ("SUNRPC: add 'struct cred *' to auth_cred and rpc_cred")
    a52458b48af1 ("NFS/NFSD/SUNRPC: replace generic creds with 'struct cred'.")
    fc0664fd9bcc ("SUNRPC: remove groupinfo from struct auth_cred.")

v4.14.135: Failed to apply! Possible dependencies:
    07d02a67b7fa ("SUNRPC: Simplify lookup code")
    12f275cdd163 ("NFSv4: Retry CLOSE and DELEGRETURN on NFS4ERR_OLD_STATEID.")
    1eb5d98f16f6 ("nfs: convert to new i_version API")
    35156bfff3c0 ("NFSv4: Fix the nfs_inode_set_delegation() arguments")
    79b181810285 ("SUNRPC: Convert auth creds to use refcount_t")
    95cd623250ad ("SUNRPC: Clean up the AUTH cache code")
    97f68c6b02e0 ("SUNRPC: add 'struct cred *' to auth_cred and rpc_cred")
    a52458b48af1 ("NFS/NFSD/SUNRPC: replace generic creds with 'struct cred'.")
    b3dce6a2f060 ("pnfs/blocklayout: handle transient devices")
    fc0664fd9bcc ("SUNRPC: remove groupinfo from struct auth_cred.")

v4.9.186: Failed to apply! Possible dependencies:
    1eb5d98f16f6 ("nfs: convert to new i_version API")
    35156bfff3c0 ("NFSv4: Fix the nfs_inode_set_delegation() arguments")
    39bc88e5e38e ("arm64: Disable TTBR0_EL1 during normal kernel execution")
    7c0f6ba682b9 ("Replace <asm/uaccess.h> with <linux/uaccess.h> globally")
    9cf09d68b89a ("arm64: xen: Enable user access before a privcmd hvc call")
    a52458b48af1 ("NFS/NFSD/SUNRPC: replace generic creds with 'struct cred'.")
    b3dce6a2f060 ("pnfs/blocklayout: handle transient devices")
    bd38967d406f ("arm64: Factor out PAN enabling/disabling into separate uaccess_* macros")

v4.4.186: Failed to apply! Possible dependencies:
    0654cc726fc6 ("NFSv4.1/pNFS: Add a helper to mark the layout as returned")
    10335556c9e6 ("NFSv4.1/pNFS: pnfs_error_mark_layout_for_return() must always return layout")
    13c13a6ad71f ("pNFS: Fix missing layoutreturn calls")
    2454dfea0aef ("NFSv4.x/pnfs: Fix a race between layoutget and pnfs_destroy_layout")
    3982a6a2d0e6 ("pnfs: keep track of the return sequence number in pnfs_layout_hdr")
    4b0934baf931 ("NFSv4.1/pNFS: Fix a race in initiate_file_draining()")
    506c0d68269e ("NFSv4.1/pNFS: Cleanup constify struct pnfs_layout_range arguments")
    50f563ef5d41 ("NFSv4.1/pNFS: Use nfs4_stateid_copy for copying stateids")
    5c97f5de2c7c ("NFSv4.1/pNFS: pnfs_mark_matching_lsegs_return() should set the iomode")
    68d264cf02b0 ("NFS42: handle layoutstats stateid error")
    6d597e175012 ("pnfs: only tear down lsegs that precede seqid in LAYOUTRETURN args")
    71b39854a500 ("NFSv4.1/pNFS: Cleanup pnfs_mark_matching_lsegs_invalid()")
    9fd4b9fc7695 ("NFSv4.x/pnfs: Fix a race between layoutget and bulk recalls")
    a52458b48af1 ("NFS/NFSD/SUNRPC: replace generic creds with 'struct cred'.")
    b20135d0b243 ("NFSv4.1/pNFS: Don't queue up a new commit if the layout segment is invalid")
    b3dce6a2f060 ("pnfs/blocklayout: handle transient devices")
    e036f46453f2 ("NFS: pnfs_mark_matching_lsegs_return() should match the layout sequence id")
    e0d9243048fd ("NFSv4.1/pNFS: Don't return NFS4ERR_DELAY unnecessarily in CB_LAYOUTRECALL")
    ed429d6b934d ("NFSv4.1/pNFS: Don't pass stateids by value to pnfs_send_layoutreturn()")
    fc7ff36747b9 ("pNFS: If we have to delay the layout callback, mark the layout for return")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
