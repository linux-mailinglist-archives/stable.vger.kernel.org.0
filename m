Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E455B4C34
	for <lists+stable@lfdr.de>; Sun, 11 Sep 2022 07:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiIKFj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 01:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIKFj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 01:39:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E580F15FD2
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 22:39:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71D9660F03
        for <stable@vger.kernel.org>; Sun, 11 Sep 2022 05:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B01C433C1;
        Sun, 11 Sep 2022 05:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662874790;
        bh=mybsurrOWREMvkGSNhERfDf80wwy/PvQEsIMp7BiC4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CyvC7fIrBq7GTbK6ryPo5gZ8w6bIquzA9/Fkn3cM0sDr0I4V2kTqKZvB8vpeiHdYl
         HTRZ3fzqIkd5JlgvRxcTa7TAsxPCxDoWlA5WHlAzKw/OTOvc0ipXQehDgNIRutAi3e
         PuHzAw4YI03J7hfSx6BK76SJktopU+Y9z6goXSBI=
Date:   Sun, 11 Sep 2022 07:40:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: Apply 5c5c2baad2b55cc0a4b190266889959642298f79 to 5.10+
Message-ID: <Yx10s6a7dnOZ+uI0@kroah.com>
References: <Yxyga8k1jee5A9Vs@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxyga8k1jee5A9Vs@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 10, 2022 at 07:34:19AM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please apply commit 5c5c2baad2b5 ("ASoC: mchp-spdiftx: Fix clang
> -Wbitfield-constant-conversion") to 5.10 and newer, as it fixes a
> warning with tip of tree LLVM. There will be a minor conflict that can
> be resolved by taking commit 403fcb5118a0 ("ASoC: mchp-spdiftx: remove
> references to mchp_i2s_caps") before it, which seems reasonable to me.
> If that is not acceptable, I can send a backport with just 5c5c2baad2b5.

Both now queued up, thanks.

greg k-h
