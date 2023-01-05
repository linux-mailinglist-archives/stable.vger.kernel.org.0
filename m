Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E9365ECAD
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbjAENRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbjAENQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:16:56 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3C15DE6F
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:16:47 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 73F5B23F6A;
        Thu,  5 Jan 2023 13:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1672924606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wDNAPF1asuLG2UYEnwP1uh04gttyAK65zCJrgb/kDd8=;
        b=ZKzfrg4bqS82ra9OztyKvXcam9N/SiofAnMt/bmilOS9ktk2mQk+BWv3sYmyOqTcMvSXqZ
        CbLSf/FgxuLz9I9aI/toj1LHYgkIba5tSleA1iDzoMjgDkSEhR3ZDXIQEME53ZbogJZo4Z
        nv6eAWuvBK/9LuQLHUmfyQNqggVR2Ko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1672924606;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wDNAPF1asuLG2UYEnwP1uh04gttyAK65zCJrgb/kDd8=;
        b=RbQyZ14oIFas8ncaARG8iS7i1TmuDUPiUm5P87teAC3xmnWVShBryxpjGFvXdJfIFZEyFU
        iPqSpZmByMs6K3AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 63B5B138DF;
        Thu,  5 Jan 2023 13:16:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8htMGL7NtmPLZgAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 05 Jan 2023 13:16:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 9D838A0742; Thu,  5 Jan 2023 14:16:45 +0100 (CET)
Date:   Thu, 5 Jan 2023 14:16:45 +0100
From:   Jan Kara <jack@suse.cz>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     jack@suse.cz, gregkh@linuxfoundation.org, adilger@dilger.ca,
        t-lo@linux.microsoft.com, tytso@mit.edu, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ext4: fix deadlock due to mbcache entry
 corruption" failed to apply to 5.15-stable tree
Message-ID: <20230105131645.3qy5whio2v635xmz@quack3>
References: <1672844851195248@kroah.com>
 <20230105082813.GA3530@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105082813.GA3530@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jeremi!

On Thu 05-01-23 00:28:13, Jeremi Piotrowski wrote:
> On Wed, Jan 04, 2023 at 04:07:31PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > Possible dependencies:
> > 
> > a44e84a9b776 ("ext4: fix deadlock due to mbcache entry corruption")
> > 307af6c87937 ("mbcache: automatically delete entries from cache on freeing")
> > 65f8b80053a1 ("ext4: fix race when reusing xattr blocks")
> > fd48e9acdf26 ("ext4: unindent codeblock in ext4_xattr_block_set()")
> > 6bc0d63dad7f ("ext4: remove EA inode entry from mbcache on inode eviction")
> > 3dc96bba65f5 ("mbcache: add functions to delete entry if unused")
> > 58318914186c ("mbcache: don't reclaim used entries")
> > 4efd9f0d120c ("ext4: use kmemdup() to replace kmalloc + memcpy")
> > 
> 
> Hi Jan,
> 
> What do you think of the backport I shared here:
> https://lore.kernel.org/linux-ext4/20221122174807.GA9658@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net/
> 
> Or do you think it makes more sense to backport some of the other patches
> listed above?

The backport looks good. Please submit it to stable@vger.kernel.org
(mentioning upstream commit ID), CC me, I'll ack it and the patch can get
merged to stable kernels. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
