Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1322A1D5B
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 11:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgKAKig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 05:38:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgKAKig (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 05:38:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61F502080A;
        Sun,  1 Nov 2020 10:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604227115;
        bh=kT4U+hpjwiXR7kNlPgarRqNhSt/kq7ZaLXhFmR2LbQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KwZghQSo6asyOSwAGcIuzY0UE8Ll7TcWerMF4HiY437wTMEeZMLuI4+ismHuP+O0B
         5sf5Bpkyc2MdV5C39/CcQGZpBrRfiKuj2XPnQFywZCi/nLoXJJFRlm0Dxn2xhbHTo9
         y1qhSdw37v3ZRWB6tH0DXiuEkOKdWX9SIyvhzzGE=
Date:   Sun, 1 Nov 2020 11:39:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH 4.19 0/5] backport some more fscrypt fixes to 4.19
Message-ID: <20201101103906.GA2689688@kroah.com>
References: <20201031220553.1085782-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031220553.1085782-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 03:05:48PM -0700, Eric Biggers wrote:
> Backport some fscrypt fixes from upstream 5.2 to 4.19-stable.
> 
> This is needed to get 'kvm-xfstests -c ext4,f2fs,ubifs -g encrypt' to
> fully pass on 4.19-stable.  Before, generic/397 and generic/429 failed
> on UBIFS due to missing "fscrypt: fix race where ->lookup() marks
> plaintext dentry as ciphertext".
> 
> This also fixes some bugs that aren't yet covered by the xfstests.
> E.g., "fs, fscrypt: clear DCACHE_ENCRYPTED_NAME when unaliasing
> directory" fixes a bug that caused real-world problems on Chrome OS.
> 
> Some relatively straightforward adjustments were needed to the patches,
> mainly due to the refactoring of fscrypt.h that was done in 5.1.

All now queued up, thanks!

greg k-h
