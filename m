Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1905F52CB
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 12:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiJEKp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 06:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiJEKp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 06:45:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062F6193FE
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 03:45:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B5DDD1F388;
        Wed,  5 Oct 2022 10:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664966724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qVvI7juaZC3YcwsPRPuTKlNhHaOKJHNLE9O69OTxnsU=;
        b=Hs75b+aG9JMB2YoCpnQmsGCFDQ80s6aMvlA7GPkY6GY9DJYBmb6JwJjIs/DTOMuuV3CpLI
        AfwJ32vxW1v15zGK2y7RvU9bC+AKoVZLKGqfDj46Q9NC2fTXNDITBom/7op5L5nWAVVUli
        IhfMY/HAj+KaJfo4OqvZf7E4CAMHXhc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664966724;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qVvI7juaZC3YcwsPRPuTKlNhHaOKJHNLE9O69OTxnsU=;
        b=4Hu3vZR/AhgwlMDR/HLZej4SwUpgUj50tRgtQ6REubrAJUDSo6oH9phpMdE+qCFWWMPRNL
        DDi8VRtXcCUzjgBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AB7E913ABD;
        Wed,  5 Oct 2022 10:45:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ucvYKURgPWMZOgAAMHmgww
        (envelope-from <bp@suse.de>); Wed, 05 Oct 2022 10:45:24 +0000
Date:   Wed, 5 Oct 2022 12:45:19 +0200
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     ssengar@linux.microsoft.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/cacheinfo: Add a
 cpu_llc_shared_mask() UP variant" failed to apply to 5.15-stable tree
Message-ID: <Yz1gP2FLEbjLIL9y@zn.tnic>
References: <166477802792157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <166477802792157@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 08:20:27AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> df5b035b5683 ("x86/cacheinfo: Add a cpu_llc_shared_mask() UP variant")
> 66558b730f25 ("sched: Add cluster scheduler level for x86")

This is a fix for CONFIG_SMP=n kernels which was caught by testing this
explicitly by disabling SMP. IOW, I don't think anyone would be running
SMP=n kernels and thus maybe should not backport those...?

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
