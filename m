Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5EFF5FC48A
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 13:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJLLy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 07:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJLLy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 07:54:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36EFB277B;
        Wed, 12 Oct 2022 04:54:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7754B21C2B;
        Wed, 12 Oct 2022 11:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1665575665;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3zSpgWBUTLEADiWqyI4QhLUqGwSaF+lXEnhQbQY0U8U=;
        b=A5bcXFgEFjvk6f598N+eoADmwbueIEgZ0Pghde9GtseBeW0+OrnQAIHM7FOkGmhDlsjwOQ
        WL9C53wWyo/9t3RTbk94HMNnd45r4nNTTidD+TK1mnYRYrld6mgKaYjpCM0OAWjBeTP9SK
        w1zf5FNtJhcISMpntoAa2vyDE/PKouk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1665575665;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3zSpgWBUTLEADiWqyI4QhLUqGwSaF+lXEnhQbQY0U8U=;
        b=EUlk8H5n56NSFO3OVh8L62EUH2UMFWOizQMG+1CzCH7gnM8wzy8H6csM4R3owf/NnEY8FQ
        PePWXNQefNsvzWAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 00D7113A5C;
        Wed, 12 Oct 2022 11:54:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +tkfOvCqRmOoQgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 12 Oct 2022 11:54:24 +0000
Date:   Wed, 12 Oct 2022 13:54:18 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        zhang songyi <zhang.songyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 37/46] btrfs: remove the unnecessary result
 variables
Message-ID: <20221012115418.GW13389@suse.cz>
Reply-To: dsterba@suse.cz
References: <20221011145015.1622882-1-sashal@kernel.org>
 <20221011145015.1622882-37-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011145015.1622882-37-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 10:50:05AM -0400, Sasha Levin wrote:
> From: zhang songyi <zhang.songyi@zte.com.cn>
> 
> [ Upstream commit bd64f6221a98fb1857485c63fd3d8da8d47406c6 ]
> 
> Return the sysfs_emit() and iterate_object_props() directly instead of
> using unnecessary variables.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Reviewed-by: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/btrfs/props.c |  5 +----
>  fs/btrfs/sysfs.c | 10 ++--------
>  2 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index a2ec8ecae8de..055a631276ce 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -270,11 +270,8 @@ int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	u64 ino = btrfs_ino(BTRFS_I(inode));
> -	int ret;
> -
> -	ret = iterate_object_props(root, path, ino, inode_prop_iterator, inode);
>  
> -	return ret;
> +	return iterate_object_props(root, path, ino, inode_prop_iterator, inode);

Please drop the patch from stable queues, it's an obvious cleanup.
