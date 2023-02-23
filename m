Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB2B6A08B2
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 13:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbjBWMhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 07:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbjBWMhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 07:37:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BCB53EC7;
        Thu, 23 Feb 2023 04:36:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1979E616DB;
        Thu, 23 Feb 2023 12:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5269C433D2;
        Thu, 23 Feb 2023 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677155800;
        bh=crCujiFbcREGUzoUELRGDmsYDJFCCdYh87/bFtN6yng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PuNZRqIA/OrbkdZoXEP5PvjwTHv/u+Dz3oxP7HHLu++1vmF4guyR9tuAyn+hn7Txt
         wJrC7kqIvAOxdGQWBdHlZG/Bt1nQ6uVPTj1F6RRTbCcBoK5ii9r0L0S2QkDdsrhIW6
         poJOpl0+jZmD5MUd2jXKxNyKaoxqCVyrYTgMlByw=
Date:   Thu, 23 Feb 2023 13:36:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthias Maennich <maennich@google.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH v5.15 v2 0/4] Allow CONFIG_DEBUG_INFO_DWARF5=y +
 CONFIG_DEBUG_INFO_BTF=y
Message-ID: <Y/dd1S/pqq6hGVFg@kroah.com>
References: <20220201205624.652313-1-nathan@kernel.org>
 <20230223115351.1241401-1-maennich@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223115351.1241401-1-maennich@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 11:53:47AM +0000, Matthias Maennich wrote:
> Hi!
> 
> Can we please pick up the essential parts of this series for 5.15? I am
> particularly interested in the last patch to enable BTF + DWARF5, but
> the cleanup patches before are a very reasonable choice for stable@ as
> well as they simplify the pahole version calculation and allow future
> BTF/pahole related patches to apply cleanly as well.
> 
> Cheers,
> Matthias
> 
> Cc: <stable@vger.kernel.org> # v5.15+
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Matthias Maennich <maennich@google.com>
> 
> Nathan Chancellor (4):
>   kbuild: Add CONFIG_PAHOLE_VERSION
>   scripts/pahole-flags.sh: Use pahole-version.sh
>   lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
>   lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+
> 
>  MAINTAINERS               |  1 +
>  init/Kconfig              |  4 ++++
>  lib/Kconfig.debug         |  4 ++--
>  scripts/pahole-flags.sh   |  2 +-
>  scripts/pahole-version.sh | 13 +++++++++++++
>  5 files changed, 21 insertions(+), 3 deletions(-)
>  create mode 100755 scripts/pahole-version.sh

Thanks, all now queued up.  Hopefully quilt/git will handle the
permission of this file properly, sometimes it gets confused...

greg k-h
