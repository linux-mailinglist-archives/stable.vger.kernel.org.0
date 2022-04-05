Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353DA4F47DC
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346304AbiDEVWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572962AbiDERbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 13:31:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F8C2314E
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 10:29:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C10AD1F38D;
        Tue,  5 Apr 2022 17:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649179743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JybmGzbwoKZsvJ4eJmGJ5UkX4hydsKW9KnzdyNc4ywI=;
        b=vx+otP3wmzRYVu8/PiPGgnSqpmOGgyuDriDnIue6bLqrUvgTBXCKCVdNJoMqeRYf6Ur3Sy
        +b4t+ScG3mtNtZClLjfJb4fbDBTyMvSdadz/VP53QlUhgR0ItTKhKZmHjgpe/qHiP4n016
        rjYOOL00lcT5jnDwWGeTfOlIcseHOrc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649179743;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JybmGzbwoKZsvJ4eJmGJ5UkX4hydsKW9KnzdyNc4ywI=;
        b=vQqU04ds6/0/i8Ou3HDiLDvmoJbUAPppOhLnYDYXXuWRgQm+RP9n+US3ilmn/1qycgs7OF
        UHtW8SMRUlvNj6Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B565A13A04;
        Tue,  5 Apr 2022 17:29:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dmI7LF98TGJ3JwAAMHmgww
        (envelope-from <bp@suse.de>); Tue, 05 Apr 2022 17:29:03 +0000
Date:   Tue, 5 Apr 2022 19:29:01 +0200
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     jroedel@suse.de, stable@vger.kernel.org, thomas.lendacky@amd.com
Subject: Re: FAILED: patch "[PATCH] x86/sev: Unroll string mmio with" failed
 to apply to 5.16-stable tree
Message-ID: <Ykx8XWViJCKf3nGQ@zn.tnic>
References: <1649058222102139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1649058222102139@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 09:43:42AM +0200, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.16-stable tree.

Really?

$ git checkout -b 5.16.y stable/linux-5.16.y
Updating files: 100% (19623/19623), done.
branch '5.16.y' set up to track 'stable/linux-5.16.y'.
$ git cherry-pick 4009a4ac82dd95b8cd2b62bd30019476983f0aff
[5.16.y 045eac1dbd58] x86/sev: Unroll string mmio with CC_ATTR_GUEST_UNROLL_STRING_IO
 Author: Joerg Roedel <jroedel@suse.de>
 Date: Mon Mar 21 10:33:51 2022 +0100
 1 file changed, 57 insertions(+), 8 deletions(-)
$ git status
On branch 5.16.y
Your branch is ahead of 'stable/linux-5.16.y' by 1 commit.
  (use "git push" to publish your local commits)

It works here...

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Ivo Totev, HRB 36809, AG Nürnberg
