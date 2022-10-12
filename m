Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C334C5FC5AD
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 14:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiJLM5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 08:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJLM46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 08:56:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED49101C8;
        Wed, 12 Oct 2022 05:56:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 821171F38D;
        Wed, 12 Oct 2022 12:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1665579414;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qrA2CI8dDGDHD2Tp/B22Ukl2G8QcxU9FnPA/bcB+ldQ=;
        b=KkPas0QhlyfQvs3HBwNgpgxNyh4dCX6gqiG1t+JoNUKMnT/yoeWNkNnTdoWJbYziNJAMtN
        bkwrk/TB/wHfon1sRXyEeFKvjqHinPHvBgsLVMR4hyaE00olDEJgLEYoqK0T0tON3+w0q3
        daBBUd8dtPhEU0pSNdW2jjRBr3Fv5ao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1665579414;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qrA2CI8dDGDHD2Tp/B22Ukl2G8QcxU9FnPA/bcB+ldQ=;
        b=MiRd3Q0pPRx8b4tENbtbE8We1HgTmOCqaASy2Yee3Hw4FygwkGNUc5q4MXwGzW0Lz6cWHY
        5aJ+TaIYVz+KtcDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3AC3E13ACD;
        Wed, 12 Oct 2022 12:56:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mOP4DJa5RmM4agAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 12 Oct 2022 12:56:54 +0000
Date:   Wed, 12 Oct 2022 14:56:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        clm@fb.com, josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 38/46] btrfs: introduce
 BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN
Message-ID: <20221012125648.GX13389@suse.cz>
Reply-To: dsterba@suse.cz
References: <20221011145015.1622882-1-sashal@kernel.org>
 <20221011145015.1622882-38-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011145015.1622882-38-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 10:50:06AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit e562a8bdf652b010ce2525bcf15d145c9d3932bf ]
> 
> Introduce a new runtime flag, BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN,
> which will inform qgroup rescan to cancel its work asynchronously.
> 
> This is to address the window when an operation makes qgroup numbers
> inconsistent (like qgroup inheriting) while a qgroup rescan is running.
> 
> In that case, qgroup inconsistent flag will be cleared when qgroup
> rescan finishes.
> But we changed the ownership of some extents, which means the rescan is
> already meaningless, and the qgroup inconsistent flag should not be
> cleared.
> 
> With the new flag, each time we set INCONSISTENT flag, we also set this
> new flag to inform any running qgroup rescan to exit immediately, and
> leaving the INCONSISTENT flag there.
> 
> The new runtime flag can only be cleared when a new rescan is started.

Qu, does this patch make sense for stable on itself? It was part of a
series adding some new flags and the sysfs knob.  As I read it there's a
case where it can affect how the rescan is done and that it can be
cancelled but still am not sure if it's worth the backport.
