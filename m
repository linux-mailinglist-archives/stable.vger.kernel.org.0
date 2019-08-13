Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115688BBD1
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 16:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbfHMOoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 10:44:24 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39981 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbfHMOoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 10:44:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so49319306pla.7
        for <stable@vger.kernel.org>; Tue, 13 Aug 2019 07:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=XKUXA8eyW+BaQrw7w0qbUBRN/bnvPttZ1UXO1rs4J4c=;
        b=YJttE/9RWvcMqefXhYgIPeeC4h4DhPhCyq7DAqhgJnT4NeqYX33FdzkIXpYYQDYp2O
         YXxGxvKBXu+uFVIGpz2bEYuEzhl45raNm+FADwcVL/WQaOWGTdEcsBSAl8tBdpuQ6frH
         eKFf5NTX9WITSszxDRCrNitnYMsi+IfMYYZrNzvcXW5C2XekztyT4H1px4+BEUjF2F3Z
         jwPOvqxG4IEwd0f2S1jkL54zGLowbCTw8jT4WBpV5WpyLUQc3UGAKXEJop5daA72tSE9
         OCS1ij+lXO6ZqoFsleptE3lztOsU11WLD+6M2N5RPP7ew+aOVTbA6a7rAJwqbe4BpKk4
         8UoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=XKUXA8eyW+BaQrw7w0qbUBRN/bnvPttZ1UXO1rs4J4c=;
        b=XLJSRW99e+sPQyX7LZSBRWGEgAy016ZIK0yxjkd0ynB9D3JCAMYysEr12jR0xr7Y7p
         jbHCHhHFpL7YGOFPZ562WhQg2E7MlTCX1UtrQi574Arx8l0d9qfsM54z4qLdzlBSVTK3
         WVaGNlXQeeG8XRzqA072BQWvma85F0Rt6ytqHVyTbJp+RX5dXMiv++RZzUdKrOX+N7de
         ix+uEA9PqDc1VGuHhDh0zK/Ykrn/1WP/4R9F5gj+cyxBlcHq/qYtrw3Kv1BWryd6p+8n
         1DKIb0sIRnPrkqrr38gE/pZqOtHGYS9NpQFPVxTanCdo58OzhMmOxJeEsXOVmt+UWwUF
         42MQ==
X-Gm-Message-State: APjAAAUHtnlxNIDGImyi09fXRyduqju+Fq3Oa+wp9oscVg3xxr8ae4Fx
        0Eo+XTGSwA+6OSjROgEZbvsmf8T1U3ynVA==
X-Google-Smtp-Source: APXvYqyZJum8U+t53Mjh4x2zKudYcaUbDz9KuBq/6d7BWPPdIOsyFv8VBMCBvsYvsKsh6n0jliUGKg==
X-Received: by 2002:a17:902:be15:: with SMTP id r21mr36859002pls.293.1565707463024;
        Tue, 13 Aug 2019 07:44:23 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:5404:91ba:59dc:9400])
        by smtp.googlemail.com with ESMTPSA id o4sm5349667pje.28.2019.08.13.07.44.22
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 07:44:22 -0700 (PDT)
Subject: Re: [PATCH] Add flags option to get xattr method paired to
 __vfs_getxattr
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, Stephen Smalley <sds@tycho.nsa.gov>,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
References: <20190812193320.200472-1-salyzyn@android.com>
 <20190813124817.0B9EF2085A@mail.kernel.org>
From:   Mark Salyzyn <salyzyn@android.com>
Message-ID: <081260c7-17ff-a575-a706-4e181334d25f@android.com>
Date:   Tue, 13 Aug 2019 07:44:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813124817.0B9EF2085A@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/13/19 5:48 AM, Sasha Levin wrote:
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.2.8, v4.19.66, v4.14.138, v4.9.189, v4.4.189.
>
> v5.2.8: Build failed! Errors:
>      fs/afs/xattr.c:156:12: error: initialization of â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t,  int)â€™ {aka â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, long unsigned int,  int)â€™} from incompatible pointer type â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t)â€™ {aka â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, long unsigned int)â€™} [-Werror=incompatible-pointer-types]
>      fs/afs/xattr.c:327:9: error: initialization of â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t,  int)â€™ {aka â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, long unsigned int,  int)â€™} from incompatible pointer type â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t)â€™ {aka â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, long unsigned int)â€™} [-Werror=incompatible-pointer-types]
>      drivers/staging/erofs/xattr.c:492:9: error: initialization of â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t,  int)â€™ {aka â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, long unsigned int,  int)â€™} from incompatible pointer type â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t)â€™ {aka â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, long unsigned int)â€™} [-Werror=incompatible-pointer-types]
>      drivers/staging/erofs/xattr.c:499:9: error: initialization of â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t,  int)â€™ {aka â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, long unsigned int,  int)â€™} from incompatible pointer type â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t)â€™ {aka â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, long unsigned int)â€™} [-Werror=incompatible-pointer-types]
>      drivers/staging/erofs/xattr.c:506:9: error: initialization of â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t,  int)â€™ {aka â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, long unsigned int,  int)â€™} from incompatible pointer type â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t)â€™ {aka â€˜int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, long unsigned int)â€™} [-Werror=incompatible-pointer-types]
>
> v4.19.66: Failed to apply! Possible dependencies:
>      05895219627c ("kernfs: clean up struct kernfs_iattrs")
>      0ac6075a32fc ("kernfs: use simple_xattrs for security attributes")
>      1537ad15c9c5 ("kernfs: fix xattr name handling in LSM helpers")
>      426dcd4b600f ("hexagon: switch to NO_BOOTMEM")
>      57c8a661d95d ("mm: remove include/linux/bootmem.h")
>      6471f52af786 ("alpha: switch to NO_BOOTMEM")
>      b230d5aba2d1 ("LSM: add new hook for kernfs node initialization")
>      bcec54bf3118 ("mips: switch to NO_BOOTMEM")
>      d0c9c153b4bd ("kernfs: do not alloc iattrs in kernfs_xattr_get")
>      e0a9317d9004 ("hexagon: use generic dma_noncoherent_ops")
>      e262e32d6bde ("vfs: Suppress MS_* flag defs within the kernel unless explicitly enabled")
>      ec882da5cda9 ("selinux: implement the kernfs_init_security hook")
>      f406f222d4b2 ("hexagon: implement the sync_sg_for_device DMA operation")
>
> v4.14.138: Failed to apply! Possible dependencies:
>      05895219627c ("kernfs: clean up struct kernfs_iattrs")
>      067cae47771c ("bpf: Use char in prog and map name")
>      0ac6075a32fc ("kernfs: use simple_xattrs for security attributes")
>      1537ad15c9c5 ("kernfs: fix xattr name handling in LSM helpers")
>      488dee96bb62 ("kernfs: allow creating kernfs objects with arbitrary uid/gid")
>      5cf9dd55a0ec ("afs: Prospectively look up extra files when doing a single lookup")
>      88cda1c9da02 ("bpf: libbpf: Provide basic API support to specify BPF obj name")
>      95582b008388 ("vfs: change inode times to use struct timespec64")
>      ad5b177bd73f ("bpf: Add map_name to bpf_map_info")
>      afdb09c720b6 ("security: bpf: Add LSM hooks for bpf object related syscall")
>      b230d5aba2d1 ("LSM: add new hook for kernfs node initialization")
>      cb4d2b3f03d8 ("bpf: Add name, load_time, uid and map_ids to bpf_prog_info")
>      d0c9c153b4bd ("kernfs: do not alloc iattrs in kernfs_xattr_get")
>      dd9fbcb8e103 ("afs: Rearrange status mapping")
>      df0ce17331e2 ("security: convert security hooks to use hlist")
>      e45b2546e23c ("fuse: Ensure posix acls are translated outside of init_user_ns")
>
> v4.9.189: Failed to apply! Possible dependencies:
>      1537ad15c9c5 ("kernfs: fix xattr name handling in LSM helpers")
>      4eb5aaa3af8a ("sched/headers: Prepare for new header dependencies before moving code to <linux/sched/autogroup.h>")
>      4f17722c7256 ("sched/headers: Prepare for new header dependencies before moving code to <linux/sched/loadavg.h>")
>      5eca1c10cbaa ("sched/headers: Clean up <linux/sched.h>")
>      6e84f31522f9 ("sched/headers: Prepare for new header dependencies before moving code to <linux/sched/mm.h>")
>      91b467e0a3f5 ("afs: Make afs_readpages() fetch data in bulk")
>      944c74f472f9 ("afs: Distinguish mountpoints from symlinks by file mode alone")
>      acb04058de49 ("sched/clock: Fix hotplug crash")
>      ae7e81c077d6 ("sched/headers: Prepare for new header dependencies before moving code to <uapi/linux/sched/types.h>")
>      b230d5aba2d1 ("LSM: add new hook for kernfs node initialization")
>      b5a062344419 ("kernfs: Declare two local data structures static")
>      d3e3b7eac886 ("afs: Add metadata xattrs")
>      df0ce17331e2 ("security: convert security hooks to use hlist")
>      e45b2546e23c ("fuse: Ensure posix acls are translated outside of init_user_ns")
>      e4e55b47ed9a ("LSM: Revive security_task_alloc() hook and per "struct task_struct" security blob.")
>      e601757102cf ("sched/headers: Prepare for new header dependencies before moving code to <linux/sched/clock.h>")
>      ea8b1c4a6019 ("drivers: psci: PSCI checker module")
>      edd3ba94c4e5 ("afs: Convert to separately allocated bdi")
>      ee6a3d19f15b ("sched/headers: Remove the <linux/topology.h> include from <linux/sched.h>")
>      fd7712337ff0 ("sched/headers: Prepare to remove the <linux/gfp.h> include from <linux/sched.h>")
>
> v4.4.189: Failed to apply! Possible dependencies:
>      1182fca3bc00 ("Orangefs: kernel client part 5")
>      24c8d0804be0 ("Orangefs: Clean up pvfs2_devreq_read.")
>      274dcf55bd4a ("Orangefs: kernel client part 3")
>      2c590d5fb698 ("Orangefs: kernel client update 1.")
>      3c2fcfcb6858 ("orangefs: make wait_for_direct_io() take iov_iter")
>      4d1c44043b26 ("Orangefs: use iov_iter interface")
>      548049495cb4 ("Orangefs: fix some checkpatch.pl complaints that had creeped in.")
>      5c278228bbfe ("orangefs: explicitly pass the size to pvfs_bufmap_copy_to_iovec()")
>      5db11c21a929 ("Orangefs: kernel client part 2")
>      5f0e3c953fd9 ("orangefs: make postcopy_buffers() take iov_iter")
>      8092895f759e ("orangefs: validate the response in decode_dirents()")
>      84d02150dea7 ("Orangefs: sooth most sparse complaints")
>      88309aae3ddb ("Orangefs: fix dir_emit code in pvfs2_readdir.")
>      894ac432b48b ("Orangefs: Clean up error decoding.")
>      8bb8aefd5afb ("OrangeFS: Change almost all instances of the string PVFS2 to OrangeFS.")
>      9172abbcd371 ("btrfs: Use xattr handler infrastructure")
>      9be68b08719c ("orangefs: get rid of dec_string and enc_string")
>      a5c126a52269 ("orangefs: make precopy_buffers() take iov_iter")
>      b296821a7c42 ("xattr_handler: pass dentry and inode as separate arguments of ->get()")
>      ef4af94edcf8 ("orangefs: switch decode_dirents() to use of kcalloc()")
>      f0ed4418d46d ("Orangefs: Remove upcall trailers which are not used.")
>      f7ab093f74bf ("Orangefs: kernel client part 1")
>      f7be4ee07fb7 ("Orangefs: kernel client part 4")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>
> --
> Thanks,
> Sasha

Wait for upstream of course.

Given the conflicts, I can provide back-ports once upstream upon 
request. It should be noted that the backports should be mechanical and 
trivial (skip non-existent filesystems like orangfs, drop separate inode 
argument that did not exist in earlier kernels).

I will submit the next spin (missed a few filesystems, build errors) 
with references to the requested stable trees again, so noise will continue.

Sincerely -- Mark Salyzyn


