Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF2C612A38
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 11:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJ3Kxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 06:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJ3Kxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 06:53:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46706C35;
        Sun, 30 Oct 2022 03:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C36A960EC8;
        Sun, 30 Oct 2022 10:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73D6C433C1;
        Sun, 30 Oct 2022 10:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667127224;
        bh=iDAcLLHb8DOrTXSsIgPJgK3NQCUdFhDIG0Ljp7qy4Oc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WoRUntH09p13xA8KVw52ywH2dA/GBVXXg/uIz9vMyqkHy48enfOqGumm4g5XlP4ij
         qCvyfth5cP5au3OWhK42EbJALOUddq3P/qX33t70xkF9rNLWWl8zq3LWtEUAPNzbHs
         m7OB5A5Qshh1mf48q6AUuKQn5nux10+TTLv+0rkg=
Date:   Sun, 30 Oct 2022 11:54:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Trond Myklebust <trondmy@kernel.org>
Cc:     stable@vger.kernel.org, linux-nfs@vger.kernel.org,
        Anna Schumaker <Anna.Schumaker@netapp.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Scott Mayhew <smayhew@redhat.com>
Subject: Re: Stable patch for 5.15.x
Message-ID: <Y15X78hsDYWlSg6y@kroah.com>
References: <ed85737568bcecb5833130f10630c9fedbfa0336.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed85737568bcecb5833130f10630c9fedbfa0336.camel@kernel.org>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 10:58:05PM -0400, Trond Myklebust wrote:
> Hi Greg / Sasha,
> 
> Can we please pull commit c3ed222745d9 ("NFSv4: Fix free of
> uninitialized nfs4_label on referral lookup.") into the 5.15.x tree? As
> far as I can tell, it should apply cleanly on top of v5.15.75.
> 
> Unfortunately, that commit also contains a bug, which requires us to
> pull in commit 4f40a5b55446 ("NFSv4: Add an fattr allocation to
> _nfs4_discover_trunking()"), which does not apply cleanly. I've
> attached a backported version to this email.
> 
> I'm seeing the Oops that this commit fixes when I do a NFSv4.2 mount
> from a NFS client running a 5.15.75 kernel against a server that has
> referrals configured. The reason is that commit d755ad8dc752 ("NFS:
> Create a new nfs_alloc_fattr_with_label() function") got pulled into
> v5.15.46 apparently as part of a dependency.

Both now queued up, thanks.

greg k-h
