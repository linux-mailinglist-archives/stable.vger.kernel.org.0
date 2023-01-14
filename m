Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4098666ABCA
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 14:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjANNtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 08:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjANNtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 08:49:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61A74EF6;
        Sat, 14 Jan 2023 05:49:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52A9660B3D;
        Sat, 14 Jan 2023 13:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D383C433EF;
        Sat, 14 Jan 2023 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673704152;
        bh=VpGAr1saq4lvsgHwII8KzmddfI2fagasI2f7bdd3tGY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ujvXV1ZNhlLeMltDkHAhOC+F0rK7BifLpACSOGp8aTEqVCXhVGG+UnJbHFU3FBRwN
         K+xyAHLjzS0b1R8bc9CInxUcqJkTPYt2bvawTyAx4qNfgPRKQgLN10WkzKArYZsItJ
         EluENQR2jRCRSPcZ/ieGJcJq8fLJJZYyT+teCtyg=
Date:   Sat, 14 Jan 2023 14:49:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, Chun-Tse Shao <ctshao@google.com>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 5.15.y] kbuild: Allow kernel installation packaging to
 override pkg-config
Message-ID: <Y8Ky1UgT2yxFB2EB@kroah.com>
References: <20230113002149.3984494-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113002149.3984494-1-swboyd@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 04:21:49PM -0800, Stephen Boyd wrote:
> From: Chun-Tse Shao <ctshao@google.com>
> 
> commit d5ea4fece4508bf8e72b659cd22fa4840d8d61e5 upstream.
> 
> Add HOSTPKG_CONFIG to allow tooling that builds the kernel to override
> what pkg-config and parameters are used.
> 
> Signed-off-by: Chun-Tse Shao <ctshao@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> [swboyd@chromium.org: Drop certs/Makefile hunk that doesn't
> apply because pkg-config isn't used there, add dtc/Makefile hunk to
> fix dtb builds]
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> I need this to properly compile 5.15.y stable kernels in the chromeos
> build system.

Is this a new issue?  A regression?  This feels odd to add a new build
feature to an old kernel when nothing changed to require it other than
an external tool suddenly requiring something new?

confused,

greg k-h
