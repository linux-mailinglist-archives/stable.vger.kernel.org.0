Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186FA1B9110
	for <lists+stable@lfdr.de>; Sun, 26 Apr 2020 17:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgDZPDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 11:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgDZPDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Apr 2020 11:03:42 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44DD22078E;
        Sun, 26 Apr 2020 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587913422;
        bh=SsoQogQnfS7x5qGNmSxYMuDAeo56TJgAWbuWD1a6jOQ=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=aMR2V5t6Xalm1jMWq8cI7IjxntLcPSIcMRwOfvSk/AeC3BlTmP3i/Iapsntutdf8q
         tQvRlYEqIAstTxJMrcbCsHCsodoTlEH/qkVzlm0WY/V9hp9SChkTN8gkKA6zCqUfyF
         kMcWUh/bc2i7Loxx4/vkS5BejPa/hP49149knro8=
Date:   Sun, 26 Apr 2020 15:03:41 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Olga Kornievskaia <olga.kornievskaia@gmail.com>
To:     trond.myklebust@hammerspace.com, anna.schumaker@netapp.com
Cc:     linux-nfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] NFSv4.1: fix handling of backchannel binding in BIND_CONN_TO_SESSION
In-Reply-To: <20200424214550.30462-1-olga.kornievskaia@gmail.com>
References: <20200424214550.30462-1-olga.kornievskaia@gmail.com>
Message-Id: <20200426150342.44DD22078E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.7, v5.4.35, v4.19.118, v4.14.177, v4.9.220, v4.4.220.

v5.6.7: Build OK!
v5.4.35: Failed to apply! Possible dependencies:
    Unable to calculate

v4.19.118: Failed to apply! Possible dependencies:
    07d02a67b7fa ("SUNRPC: Simplify lookup code")
    3453d5708b33 ("NFSv4.1: Avoid false retries when RPC calls are interrupted")
    5c441544f045 ("NFSv4.x: Handle bad/dead sessions correctly in nfs41_sequence_process()")
    79b181810285 ("SUNRPC: Convert auth creds to use refcount_t")
    8276c902bbe9 ("SUNRPC: remove uid and gid from struct auth_cred")
    95cd623250ad ("SUNRPC: Clean up the AUTH cache code")
    97f68c6b02e0 ("SUNRPC: add 'struct cred *' to auth_cred and rpc_cred")
    a52458b48af1 ("NFS/NFSD/SUNRPC: replace generic creds with 'struct cred'.")
    fc0664fd9bcc ("SUNRPC: remove groupinfo from struct auth_cred.")

v4.14.177: Failed to apply! Possible dependencies:
    07d02a67b7fa ("SUNRPC: Simplify lookup code")
    12f275cdd163 ("NFSv4: Retry CLOSE and DELEGRETURN on NFS4ERR_OLD_STATEID.")
    1eb5d98f16f6 ("nfs: convert to new i_version API")
    3453d5708b33 ("NFSv4.1: Avoid false retries when RPC calls are interrupted")
    35156bfff3c0 ("NFSv4: Fix the nfs_inode_set_delegation() arguments")
    5c441544f045 ("NFSv4.x: Handle bad/dead sessions correctly in nfs41_sequence_process()")
    79b181810285 ("SUNRPC: Convert auth creds to use refcount_t")
    95cd623250ad ("SUNRPC: Clean up the AUTH cache code")
    97f68c6b02e0 ("SUNRPC: add 'struct cred *' to auth_cred and rpc_cred")
    a52458b48af1 ("NFS/NFSD/SUNRPC: replace generic creds with 'struct cred'.")
    b3dce6a2f060 ("pnfs/blocklayout: handle transient devices")
    fc0664fd9bcc ("SUNRPC: remove groupinfo from struct auth_cred.")

v4.9.220: Failed to apply! Possible dependencies:
    172d9de15a0d ("NFS: Change nfs4_get_session() to take an nfs_client structure")
    3453d5708b33 ("NFSv4.1: Avoid false retries when RPC calls are interrupted")
    3be0f80b5fe9 ("NFSv4.1: Fix up replays of interrupted requests")
    42e1cca7e91e ("NFS: Change nfs4_setup_sequence() to take an nfs_client structure")
    5c441544f045 ("NFSv4.x: Handle bad/dead sessions correctly in nfs41_sequence_process()")
    6de7e12f53a1 ("NFS: Use nfs4_setup_sequence() everywhere")
    7981c8a65914 ("NFS: Create a single nfs4_setup_sequence() function")
    efc6f4aa742d ("NFS: Move nfs4_get_session() into nfs4_session.h")

v4.4.220: Failed to apply! Possible dependencies:
    172d9de15a0d ("NFS: Change nfs4_get_session() to take an nfs_client structure")
    3453d5708b33 ("NFSv4.1: Avoid false retries when RPC calls are interrupted")
    3be0f80b5fe9 ("NFSv4.1: Fix up replays of interrupted requests")
    42e1cca7e91e ("NFS: Change nfs4_setup_sequence() to take an nfs_client structure")
    5c441544f045 ("NFSv4.x: Handle bad/dead sessions correctly in nfs41_sequence_process()")
    5f83d86cf531 ("NFSv4.x: Fix wraparound issues when validing the callback sequence id")
    68d264cf02b0 ("NFS42: handle layoutstats stateid error")
    6de7e12f53a1 ("NFS: Use nfs4_setup_sequence() everywhere")
    80f9642724af ("NFSv4.x: Enforce the ca_maxresponsesize_cached on the back channel")
    810d82e68301 ("NFSv4.x: Allow multiple callbacks in flight")
    9a0fe86745b8 ("pNFS: Handle NFS4ERR_OLD_STATEID correctly in LAYOUTSTAT calls")
    efc6f4aa742d ("NFS: Move nfs4_get_session() into nfs4_session.h")
    f74a834a0e1b ("NFSv4.x: CB_SEQUENCE should return NFS4ERR_DELAY if still executing")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
