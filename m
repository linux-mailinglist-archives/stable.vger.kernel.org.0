Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1168B60F55E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbiJ0KeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235580AbiJ0Kdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:33:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5D6A3F53
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 03:33:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA4D0B82558
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C00C433C1;
        Thu, 27 Oct 2022 10:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666866818;
        bh=oRS2JbLnUGHEIGFpXpT4+mx+XXpT86+fg/dRm3+f+Wg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zhkLY9UK5S1gydJSNOlOqUvT9kFJqdwoooTFTqMsmtThtnc1UbcKdg19Phv0hhsym
         +rnLE/TFbpYo1v3U4JyxIcA1yb/eTLnTT5zpkWtSHrzBCHNKThiv+CztNQrsaNN51t
         LdPEw83WZDycVo457Qq4Xkyx2mAkdbH4yrshGEhs=
Date:   Thu, 27 Oct 2022 12:33:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        clang-built-linux <llvm@lists.linux.dev>,
        Alexey Alexandrov <aalexand@google.com>,
        Bill Wendling <morbo@google.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: backports of 32ef9e5054ec ("Makefile.debug: re-enable debug info
 for .S files")
Message-ID: <Y1pebfXQAj/cLbci@kroah.com>
References: <CAKwvOdneUW4e9==CABAk68uePCGNt7Sq6P-84tR41HRB23zFTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdneUW4e9==CABAk68uePCGNt7Sq6P-84tR41HRB23zFTA@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 02:06:52PM -0700, Nick Desaulniers wrote:
> Dear stable kernel maintainers,
> Our production kernel team and ChromeOS kernel teams are reporting
> that they are unable to symbolize addresses of symbols defined in
> assembly sources due to a regression I caused with
>     commit a66049e2cf0e ("Kbuild: make DWARF version a choice")
> I fixed this upstream with
>     commit 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
> but I think this is infeasible to backport through to 4.19.y.
> 
> Do the attached branch-specific variants look acceptable?

All now queued up, thanks.

greg k-h
