Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36881464A64
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 10:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbhLAJQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 04:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbhLAJQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 04:16:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E87C061574
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 01:13:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97EFEB81DF9
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 09:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5148C53FAD;
        Wed,  1 Dec 2021 09:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638349993;
        bh=7Mu+PYkJrhNXqsHs9lm00qVZlDKMkuXpNJiWDHF1dSU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=evzcN98mZSnD+hxPb/iiqI/J0cHWifZz81t2LoJEX4o2aPUbJ6ft1Dnw1hJForEZ7
         aOeZGfuGcSMZqgPJghbOXyohVa804ps7FsewUoW0YGLYyOipjveggSIl5v9oWLWs3q
         QwnjEd3CBodptlID+uNvJmC8HsoMt9Gycyr9yvh4=
Date:   Wed, 1 Dec 2021 10:13:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Coddington <bcodding@redhat.com>
Cc:     stable@vger.kernel.org, trond.myklebust@hammerspace.com
Subject: Re: Patches for upstream 3f015d89a47c NFS COPY/CLONE - stable
 versions follow
Message-ID: <Yac8plt+rTFhzJvo@kroah.com>
References: <cover.1638210409.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1638210409.git.bcodding@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 01:41:47PM -0500, Benjamin Coddington wrote:
> The five patches referencing this cover letter are backports of upstream
> fix "3f015d89a47c NFSv42: Fix pagecache invalidation after COPY/CLONE",
> which did not apply cleanly to longterm trees.
> 
> Note: while the upstream fix received extensive testing, these backports
> have been build-tested only.
> 
> Benjamin Coddington (1):
>   NFSv42: Fix pagecache invalidation after COPY/CLONE
> 
>  fs/nfs/nfs42proc.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> -- 
> 2.31.1
> 

All now queued up, thanks!

greg k-h
