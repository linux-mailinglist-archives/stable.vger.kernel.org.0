Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36A64B3D58
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 17:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfIPPNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 11:13:11 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:51477 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728343AbfIPPNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 11:13:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A33C450E;
        Mon, 16 Sep 2019 11:13:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 16 Sep 2019 11:13:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=EG4m9wsCy5Il4PLqsND14M6MiZl
        NNX5ApCtMbjAc9GE=; b=kggUYPZLaV7Hfn8RUIXKUB2j7Q4slPp0rB+Of6TtAcj
        +Qka/zYiC/02YF4kfILh0iKaVJKgOkay/dxiKpZCrfKHWf2V/626O/BfkDKgwYZT
        ttFzW/0FNSdKHSlk2zCqOMfU6gmaTYRwH48T8VlsAABlziHrMmguwjRUGXLMdvia
        jKliVTb4AQXgcGlvOX1VM4ZKcf+COHwOXCvVlN5vTZkYEB/4XEbqHTJukQcy/jb2
        3N282af4BDSKZbc3l43eNCWTTXhuDY7KZfpWID1gJNv0KkYMQsbmwQbS76/IH34K
        bJK6V8qfs0zrvPfdabAey5wjzExAwqKiTOdUMUmB0RQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EG4m9w
        sCy5Il4PLqsND14M6MiZlNNX5ApCtMbjAc9GE=; b=0w0xJct0EYp1kFDfMwnNBe
        xut90IMtavfgJIxzW0cm3x2LNOE2l0TOukjyWfmOZfvqNvKq+LmlzWo0pJXVQMxy
        0Pnc1Sjw4ZFsmpBcPLeqUEw1XHXjhSQyzQ3dM873zIyFS45//Mm0QusfDejtbgDO
        4WCmiagmGY5KhSgrhGuShRMmq5cmjgoThvBP36nWepO/zbgeJ26aaKfNIUSOPI/U
        iRsCBKD5+OsyiLn/4bQ1maBuoa9XtPpJuLvH02/BT1MDUBz0jxiis8+U/WgPG7Nz
        IUIBeCnh66hPKzMjGjmTJI1k8NNp2FmyDq9e0o/TPWOAfMgp/yYNazM9Plkvbt5A
        ==
X-ME-Sender: <xms:haZ_XZI0lk2ug6Zu3YVHftijmPhO6RNaXNNEsv82j4kgJhRdc0MF0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudefgdekiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:haZ_XSXDd-I4MzHsGd4r8t2Dd4jakUZPN1UC84RPxg_RHQq55JZEWA>
    <xmx:haZ_XaSicJdmh1Tt-_mq9KsGvknf1070iWnATCPYX8cJKarEfPMn2w>
    <xmx:haZ_XaA1gI6hAHqR6Zv5dtZNQ-U3A53jRTfPsq4Mn3DvEOaXTiLNLg>
    <xmx:haZ_XRU0T1LoPjbP3EqZwKBhFUnS6DTEoKT6oqxL3phtUWwlWBfITg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A06A580060;
        Mon, 16 Sep 2019 11:13:08 -0400 (EDT)
Date:   Mon, 16 Sep 2019 17:13:07 +0200
From:   Greg KH <greg@kroah.com>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, Filipe Manana <fdmanana@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix assertion failure during fsync and use of
 stale transaction
Message-ID: <20190916151307.GB1645163@kroah.com>
References: <20190910142649.19808-1-fdmanana@kernel.org>
 <20190912073046.47C2020830@mail.kernel.org>
 <CAL3q7H5FgTfsq=uhj_=YyjogPAq=L4Dy0vaRXUK4t4PcEak5Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H5FgTfsq=uhj_=YyjogPAq=L4Dy0vaRXUK4t4PcEak5Ew@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 16, 2019 at 01:59:47PM +0100, Filipe Manana wrote:
> On Thu, Sep 12, 2019 at 8:32 AM Sasha Levin <sashal@kernel.org> wrote:
> >
> > Hi,
> >
> > [This is an automated email]
> >
> > This commit has been processed because it contains a -stable tag.
> > The stable tag indicates that it's relevant for the following trees: 4.4+
> >
> > The bot has tested the following trees: v5.2.14, v4.19.72, v4.14.143, v4.9.192, v4.4.192.
> >
> > v5.2.14: Build OK!
> > v4.19.72: Failed to apply! Possible dependencies:
> >     6b5fc433a7ad ("Btrfs: fix fsync after succession of renames of different files")
> >     a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlink/rmdir")
> >     b8aa330d2acb ("Btrfs: improve performance on fsync of files with multiple hardlinks")
> >
> > v4.14.143: Failed to apply! Possible dependencies:
> >     0d836392cadd ("Btrfs: fix mount failure after fsync due to hard link recreation")
> >     1f250e929a9c ("Btrfs: fix log replay failure after unlink and link combination")
> >     6b5fc433a7ad ("Btrfs: fix fsync after succession of renames of different files")
> >     8d9e220ca084 ("btrfs: simplify IS_ERR/PTR_ERR checks")
> >     a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlink/rmdir")
> >     b8aa330d2acb ("Btrfs: improve performance on fsync of files with multiple hardlinks")
> >
> > v4.9.192: Failed to apply! Possible dependencies:
> >     0b246afa62b0 ("btrfs: root->fs_info cleanup, add fs_info convenience variables")
> >     0d836392cadd ("Btrfs: fix mount failure after fsync due to hard link recreation")
> >     1f250e929a9c ("Btrfs: fix log replay failure after unlink and link combination")
> >     4791c8f19c45 ("btrfs: Make btrfs_check_ref_name_override take btrfs_inode")
> >     6b5fc433a7ad ("Btrfs: fix fsync after succession of renames of different files")
> >     a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlink/rmdir")
> >     cf8cddd38bab ("btrfs: don't abuse REQ_OP_* flags for btrfs_map_block")
> >     da17066c4047 ("btrfs: pull node/sector/stripe sizes out of root and into fs_info")
> >     db0a669fb002 ("btrfs: Make btrfs_add_link take btrfs_inode")
> >     de143792253e ("btrfs: struct btrfsic_state->root should be an fs_info")
> >     fb456252d3d9 ("btrfs: root->fs_info cleanup, use fs_info->dev_root everywhere")
> >
> > v4.4.192: Failed to apply! Possible dependencies:
> >     0132761017e0 ("btrfs: fix string and comment grammatical issues and typos")
> >     09cbfeaf1a5a ("mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,release} macros")
> >     0b246afa62b0 ("btrfs: root->fs_info cleanup, add fs_info convenience variables")
> >     0d836392cadd ("Btrfs: fix mount failure after fsync due to hard link recreation")
> >     0e749e54244e ("dax: increase granularity of dax_clear_blocks() operations")
> >     1f250e929a9c ("Btrfs: fix log replay failure after unlink and link combination")
> >     44f714dae50a ("Btrfs: improve performance on fsync against new inode after rename/unlink")
> >     4791c8f19c45 ("btrfs: Make btrfs_check_ref_name_override take btrfs_inode")
> >     52db400fcd50 ("pmem, dax: clean up clear_pmem()")
> >     6b5fc433a7ad ("Btrfs: fix fsync after succession of renames of different files")
> >     781feef7e6be ("Btrfs: fix lockdep warning about log_mutex")
> >     a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlink/rmdir")
> >     b2e0d1625e19 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
> >     bb7ab3b92e46 ("btrfs: Fix misspellings in comments.")
> >     cf8cddd38bab ("btrfs: don't abuse REQ_OP_* flags for btrfs_map_block")
> >     d1a5f2b4d8a1 ("block: use DAX for partition table reads")
> >     db0a669fb002 ("btrfs: Make btrfs_add_link take btrfs_inode")
> >     de143792253e ("btrfs: struct btrfsic_state->root should be an fs_info")
> >
> >
> > NOTE: The patch will not be queued to stable trees until it is upstream.
> >
> > How should we proceed with this patch?
> 
> So here follows, as attachments, patches for the following stable
> versions: 4.4.193, 4.9.193, 4.14.144 and 4.19.73.

Thanks for these backports, now queued up!

greg k-h
