Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1318EB1CA6
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 13:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfIMLxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 07:53:10 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47139 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727540AbfIMLxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 07:53:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D59C21236;
        Fri, 13 Sep 2019 07:53:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 13 Sep 2019 07:53:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=kkdg3QNRaVwWkDr3MP+jAn87bWt
        COl2T6KzNWH6YBO0=; b=aOcbbhakeev7AgJHcgSOuTwBoUGPqCzf2TxoMZNP8m6
        OMuL46Bros0Rrc4YiobOCbL2SvjXzAtb5ZSnyQ0zxnLP+nmXxF5fZkpjgdOjj85o
        yo4Sn9xCgGTOa0AaZWzRILImQky0y68wtC66bNI4D4EVC1lrnZncZqdYOn8iEG6C
        wm2PiRn7VbLhgFSY3wpsIARAlSVgG1MRCV41yerWM60XBnmN74BZLkCSyY3ZThNT
        sPoXyAqo1eZ/DxOmckw3Db43o18XM7fhNF1ImhOLzd2a+3M1A9NlEmBCHghrwUXB
        eBfJJxl7+JdrQiNKiNvpfXAbCRQ6C1A6/fdZBMbxucQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kkdg3Q
        NRaVwWkDr3MP+jAn87bWtCOl2T6KzNWH6YBO0=; b=rQyT1Y91u716HdreK3B9a0
        kMrye+yQQxn91ef2dgx428AVPOdTcIeEYrJgpBw7jkCbXqQnA0GF98LeieDXlFux
        7cjVh8ST21dpxlxbVk4AlIsNS5ukzIw4OFQKy/nvAhu71titdTXU4ZKu9/tUrTyM
        2SoH93Cgx2ILwRN+9cLeLD1KY9BVnN1biwhcRsF/0xaE+cxLOsRhNnt90q6q9BvQ
        VMB0B2vKP2JziKF1zReOLo93JvQSVbrP+DO1fNBuzeyl7N+H/sT0t+ddOpumPGRJ
        lG57JBapffpd56BBI9rTEIUSw50PicWRthUdxweucRVU0yiUFoA9ND7fUNn294tw
        ==
X-ME-Sender: <xms:I4N7XR0sJ6J0zfrpjOO28UF5dLY8uvNMKs6TsbE2iZtSyNhsYcWuYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtdejgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeelrddvtdehrddufeekrd
    ejvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:JIN7XULpIA-7nxOuNQlEs47CLLjDQrEqYFlCDs_4n3NLbyVRHQl8rQ>
    <xmx:JIN7XbSjCXXGS2V4ZNja81ccyrNi8VcwKAaI28_LFl0rnuxS4DtZSQ>
    <xmx:JIN7XXBCtkNWW9NbIF4Ulvb2rop7eGymLaJ5KXQPn1BSqpi4H0xYWw>
    <xmx:JIN7XbsM27JFYYMd99Q065VU5qgTm21pWS5BmDzfC_GvoApzK_ul6g>
Received: from localhost (unknown [89.205.138.72])
        by mail.messagingengine.com (Postfix) with ESMTPA id 853E6D6005D;
        Fri, 13 Sep 2019 07:53:07 -0400 (EDT)
Date:   Fri, 13 Sep 2019 12:53:05 +0100
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH for-4.19.x ] btrfs: correctly validate compression type
Message-ID: <20190913115305.GA292815@kroah.com>
References: <20190912100259.7784-1-jthumshirn@suse.de>
 <20190912105215.GC1546@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912105215.GC1546@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 12, 2019 at 06:52:15AM -0400, Sasha Levin wrote:
> On Thu, Sep 12, 2019 at 12:02:59PM +0200, Johannes Thumshirn wrote:
> > [ Upstream commit aa53e3bfac7205fb3a8815ac1c937fd6ed01b41e ]
> > 
> > Nikolay reported the following KASAN splat when running btrfs/048:
> > 
> > [ 1843.470920] ==================================================================
> > [ 1843.471971] BUG: KASAN: slab-out-of-bounds in strncmp+0x66/0xb0
> > [ 1843.472775] Read of size 1 at addr ffff888111e369e2 by task btrfs/3979
> > 
> > [ 1843.473904] CPU: 3 PID: 3979 Comm: btrfs Not tainted 5.2.0-rc3-default #536
> > [ 1843.475009] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> > [ 1843.476322] Call Trace:
> > [ 1843.476674]  dump_stack+0x7c/0xbb
> > [ 1843.477132]  ? strncmp+0x66/0xb0
> > [ 1843.477587]  print_address_description+0x114/0x320
> > [ 1843.478256]  ? strncmp+0x66/0xb0
> > [ 1843.478740]  ? strncmp+0x66/0xb0
> > [ 1843.479185]  __kasan_report+0x14e/0x192
> > [ 1843.479759]  ? strncmp+0x66/0xb0
> > [ 1843.480209]  kasan_report+0xe/0x20
> > [ 1843.480679]  strncmp+0x66/0xb0
> > [ 1843.481105]  prop_compression_validate+0x24/0x70
> > [ 1843.481798]  btrfs_xattr_handler_set_prop+0x65/0x160
> > [ 1843.482509]  __vfs_setxattr+0x71/0x90
> > [ 1843.483012]  __vfs_setxattr_noperm+0x84/0x130
> > [ 1843.483606]  vfs_setxattr+0xac/0xb0
> > [ 1843.484085]  setxattr+0x18c/0x230
> > [ 1843.484546]  ? vfs_setxattr+0xb0/0xb0
> > [ 1843.485048]  ? __mod_node_page_state+0x1f/0xa0
> > [ 1843.485672]  ? _raw_spin_unlock+0x24/0x40
> > [ 1843.486233]  ? __handle_mm_fault+0x988/0x1290
> > [ 1843.486823]  ? lock_acquire+0xb4/0x1e0
> > [ 1843.487330]  ? lock_acquire+0xb4/0x1e0
> > [ 1843.487842]  ? mnt_want_write_file+0x3c/0x80
> > [ 1843.488442]  ? debug_lockdep_rcu_enabled+0x22/0x40
> > [ 1843.489089]  ? rcu_sync_lockdep_assert+0xe/0x70
> > [ 1843.489707]  ? __sb_start_write+0x158/0x200
> > [ 1843.490278]  ? mnt_want_write_file+0x3c/0x80
> > [ 1843.490855]  ? __mnt_want_write+0x98/0xe0
> > [ 1843.491397]  __x64_sys_fsetxattr+0xba/0xe0
> > [ 1843.492201]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> > [ 1843.493201]  do_syscall_64+0x6c/0x230
> > [ 1843.493988]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > [ 1843.495041] RIP: 0033:0x7fa7a8a7707a
> > [ 1843.495819] Code: 48 8b 0d 21 de 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 be 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ee dd 2b 00 f7 d8 64 89 01 48
> > [ 1843.499203] RSP: 002b:00007ffcb73bca38 EFLAGS: 00000202 ORIG_RAX: 00000000000000be
> > [ 1843.500210] RAX: ffffffffffffffda RBX: 00007ffcb73bda9d RCX: 00007fa7a8a7707a
> > [ 1843.501170] RDX: 00007ffcb73bda9d RSI: 00000000006dc050 RDI: 0000000000000003
> > [ 1843.502152] RBP: 00000000006dc050 R08: 0000000000000000 R09: 0000000000000000
> > [ 1843.503109] R10: 0000000000000002 R11: 0000000000000202 R12: 00007ffcb73bda91
> > [ 1843.504055] R13: 0000000000000003 R14: 00007ffcb73bda82 R15: ffffffffffffffff
> > 
> > [ 1843.505268] Allocated by task 3979:
> > [ 1843.505771]  save_stack+0x19/0x80
> > [ 1843.506211]  __kasan_kmalloc.constprop.5+0xa0/0xd0
> > [ 1843.506836]  setxattr+0xeb/0x230
> > [ 1843.507264]  __x64_sys_fsetxattr+0xba/0xe0
> > [ 1843.507886]  do_syscall_64+0x6c/0x230
> > [ 1843.508429]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> > [ 1843.509558] Freed by task 0:
> > [ 1843.510188] (stack is not available)
> > 
> > [ 1843.511309] The buggy address belongs to the object at ffff888111e369e0
> >                which belongs to the cache kmalloc-8 of size 8
> > [ 1843.514095] The buggy address is located 2 bytes inside of
> >                8-byte region [ffff888111e369e0, ffff888111e369e8)
> > [ 1843.516524] The buggy address belongs to the page:
> > [ 1843.517561] page:ffff88813f478d80 refcount:1 mapcount:0 mapping:ffff88811940c300 index:0xffff888111e373b8 compound_mapcount: 0
> > [ 1843.519993] flags: 0x4404000010200(slab|head)
> > [ 1843.520951] raw: 0004404000010200 ffff88813f48b008 ffff888119403d50 ffff88811940c300
> > [ 1843.522616] raw: ffff888111e373b8 000000000016000f 00000001ffffffff 0000000000000000
> > [ 1843.524281] page dumped because: kasan: bad access detected
> > 
> > [ 1843.525936] Memory state around the buggy address:
> > [ 1843.526975]  ffff888111e36880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > [ 1843.528479]  ffff888111e36900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > [ 1843.530138] >ffff888111e36980: fc fc fc fc fc fc fc fc fc fc fc fc 02 fc fc fc
> > [ 1843.531877]                                                        ^
> > [ 1843.533287]  ffff888111e36a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > [ 1843.534874]  ffff888111e36a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > [ 1843.536468] ==================================================================
> > 
> > This is caused by supplying a too short compression value ('lz') in the
> > test-case and comparing it to 'lzo' with strncmp() and a length of 3.
> > strncmp() read past the 'lz' when looking for the 'o' and thus caused an
> > out-of-bounds read.
> > 
> > Introduce a new check 'btrfs_compress_is_valid_type()' which not only
> > checks the user-supplied value against known compression types, but also
> > employs checks for too short values.
> > 
> > Reported-by: Nikolay Borisov <nborisov@suse.com>
> > Fixes: 272e5326c783 ("btrfs: prop: fix vanished compression property after failed set")
> > CC: stable@vger.kernel.org # 5.1+
> > Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > Reviewed-by: David Sterba <dsterba@suse.com>
> > Signed-off-by: David Sterba <dsterba@suse.com>
> 
> It's already sitting in the queue, thank you :)

We also need this for 4.14.y, let me see if it is easy to backport...
