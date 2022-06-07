Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C08540269
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 17:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344045AbiFGPaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 11:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344031AbiFGPaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 11:30:20 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC370C6E6B;
        Tue,  7 Jun 2022 08:30:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AB73E21C18;
        Tue,  7 Jun 2022 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654615817;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3HFwAjcrpNdT9WsOGb53ZllR/O+OUsuf7sR4cWRnJHY=;
        b=bh6KBFCDZNgFoRZJrLE4zernO8quW5kHaKKdZfWEdXq4r9XPA09zAPO1lWximj+mVbZkq6
        uU+KrSWuEphQOYjOaOoTlb248JqEEN36rn4bXe+LR/YpeqxguADtFvtMf+5aPodIspOtHE
        RrFbjZO86f4TOdCyOqZMit8mcsfnvi0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654615817;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3HFwAjcrpNdT9WsOGb53ZllR/O+OUsuf7sR4cWRnJHY=;
        b=u3v7VY2GYYvmgBrn8erjAk13tU69QsfOAZW5t+3ZpLqlvOeFKamKOOjTv2aqU8fHs/CRx8
        YGCA37RXU+o0YBAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 86DDA13A88;
        Tue,  7 Jun 2022 15:30:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IerYHwlvn2IMYgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 07 Jun 2022 15:30:17 +0000
Date:   Tue, 7 Jun 2022 17:25:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: add error messages to all unrecognized mount
 options
Message-ID: <20220607152547.GJ20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
References: <20220606110819.3943-1-dsterba@suse.com>
 <80a1469f-e5ce-11e1-b637-dba40706ce80@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80a1469f-e5ce-11e1-b637-dba40706ce80@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 05:07:55PM +0530, Anand Jain wrote:
> 
> LGTM.
> Reviewed-by: Anand Jain <anand.jain@oracle.com>
> 
> While we are on this topic-
> Not all valid mount options get printed either.

Looking at the amount of other informative messages we already print, I
think it won't be that bad to add the mount/umount messages, but it
depends on the system, there was an argument that bind mounts can make a
loot of noise in the logs.

> I sent a patch a long 
> time back [1] to fix it. If there is enough interest, I could revive it.

As was mentioned in the VFS version, other filesystems also print that
so let's do it for btrfs too. Please update and resend the patch, we may
then discuss what exactly to print, I'm not convinced we need all the
internal stats like the refcounts but it would be better to have
something for start.
