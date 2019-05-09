Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674C6192DB
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfEITW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbfEITW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 15:22:57 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EA3D2085A;
        Thu,  9 May 2019 19:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557429775;
        bh=w4SRzGYQsBWgUHXqNv+wa752qvlww+0U/SNfkV/CKhI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yGbX4XtGMdC//IvntlHxFaLvcBK1BXISAnSzAK/++CzH3mkpKDGuD/ar+kqNc8MEp
         gjn96A8UYBWNCY3VUiJGSP1bNq7WLU7BASi7xw2KJE/dFL83Ry8dT4p3YTHbOCfhU3
         SgRf90CNWImfJdFgLYEh38NQyLoJ/vbFD2hovLKs=
Date:   Thu, 9 May 2019 12:22:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Fang =?utf-8?B?SG9uZ2ppZSjmlrnmtKrmnbAp?= 
        <hongjiefang@asrmicro.com>
Cc:     Sasha Levin <sashal@kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH V2] fscrypt: don't set policy for a dead directory
Message-ID: <20190509192252.GA42815@gmail.com>
References: <1557307654-673-1-git-send-email-hongjiefang@asrmicro.com>
 <20190508155604.1B59820989@mail.kernel.org>
 <a38236b96095470aa1da3960b113a5e2@mail2012.asrmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a38236b96095470aa1da3960b113a5e2@mail2012.asrmicro.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 11:04:50AM +0000, Fang Hongjie(方洪杰) wrote:
> 
> > From: Sasha Levin [mailto:sashal@kernel.org]
> > Sent: Wednesday, May 08, 2019 11:56 PM
> > To: Sasha Levin; Fang Hongjie(方洪杰); tytso@mit.edu; jaegeuk@kernel.org;
> > ebiggers@kernel.org
> > Cc: linux-fscrypt@vger.kernel.org; stable@vger.kernel.org
> > Subject: Re: [PATCH V2] fscrypt: don't set policy for a dead directory
> > 
> > Hi,
> > 
> > [This is an automated email]
> > 
> > This commit has been processed because it contains a "Fixes:" tag,
> > fixing commit: 9bd8212f981e ext4 crypto: add encryption policy and password salt
> > support.
> > 
> > The bot has tested the following trees: v5.0.13, v4.19.40, v4.14.116, v4.9.173, v4.4.179.
> > 
> > v5.0.13: Build OK!
> > v4.19.40: Build OK!
> > v4.14.116: Build OK!
> > v4.9.173: Failed to apply! Possible dependencies:
> >     Unable to calculate
> > 
> > v4.4.179: Failed to apply! Possible dependencies:
> >     002ced4be642 ("fscrypto: only allow setting encryption policy on directories")
> >     0b81d0779072 ("fs crypto: move per-file encryption from f2fs tree to fs/crypto")
> >     0cab80ee0c9e ("f2fs: fix to convert inline inode in ->setattr")
> >     0fac2d501b0d ("f2fs crypto: fix spelling typo in comment")
> >     0fd785eb931d ("f2fs: relocate is_merged_page")
> >     1dafa51d45c6 ("f2fs crypto: check for too-short encrypted file names")
> >     36b35a0dbe90 ("f2fs: support data flush in background")
> >     55d1cdb25a81 ("f2fs: relocate tracepoint of write_checkpoint")
> >     6b2553918d8b ("replace ->follow_link() with new method that could stay in
> > RCU mode")
> >     6beceb5427aa ("f2fs: introduce time and interval facility")
> >     8dc0d6a11e7d ("f2fs: early check broken symlink length in the encrypted case")
> >     922ec355f863 ("f2fs crypto: avoid unneeded memory allocation when
> > {en/de}crypting symlink")
> >     9e8925b67a80 ("locks: Allow disabling mandatory locking at compile time")
> >     a263669fa18f ("f2fs crypto: sync with ext4's fname padding")
> >     ae1086686487 ("f2fs crypto: handle unexpected lack of encryption keys")
> >     b9d777b85ff1 ("f2fs: check inline_data flag at converting time")
> >     ce855a3bd092 ("f2fs crypto: f2fs_page_crypto() doesn't need a encryption
> > context")
> >     d0239e1bf520 ("f2fs: detect idle time depending on user behavior")
> >     d323d005ac4a ("f2fs: support file defragment")
> >     dffd0cfa06d4 ("fscrypt: use ENOTDIR when setting encryption policy on
> > nondirectory")
> >     ed3360abbc04 ("f2fs crypto: make sure the encryption info is initialized on
> > opendir(2)")
> > 
> > 
> > How should we proceed with this patch?
> 
> There is not a "fs/crypto" directory for kernel v4.4.179.
> Perhaps it is not still necessary to test it on this tree.
> 

In 4.4 the code was in fs/ext4/ rather than fs/crypto/, so it will need to be
backported to there.

That's for *after* this patch is applied and reaches mainline, of course.
There's nothing to backport before then.

- Eric
