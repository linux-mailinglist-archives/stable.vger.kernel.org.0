Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638CB5FFF6D
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 15:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJPNDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 09:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJPNDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 09:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF7F39102
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 06:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD1A260B5C
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB21BC433D6;
        Sun, 16 Oct 2022 13:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665925413;
        bh=JY9MTSghZsCBk9g5JsDbOVMRgfy19GPXwrXNlSmJsWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d48gRXCculTo2kBZlqpZ5UoytCpgMSCO48eIBxxgb8cfkEbV0hxmh1HevRvzHd4bf
         lK0arrgUOTeTdrI3Lb7wDeUH0eguEKWfHfoaHD0i8RWeUe8hzUI1x6MpyjOUBvdBoh
         yWqzRv9lyYYMh75TIGbmARdVpIDhPvJ1y3adNhVQ=
Date:   Sun, 16 Oct 2022 15:04:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        llvm@lists.linux.dev, Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: Backport of 607e57c6c62c009 for 5.10 and 5.15
Message-ID: <Y0wBSkAgE3jsMT/t@kroah.com>
References: <Y0heKubSc1P6rbNB@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0heKubSc1P6rbNB@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 11:51:22AM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please find attached backports for commit 607e57c6c62c ("hardening:
> Remove Clang's enable flag for -ftrivial-auto-var-init=zero") along with
> prerequisite changes for 5.10 and 5.15. This change is necessary to keep
> CONFIG_INIT_STACK_ALL_ZERO working with clang-16. This change is already
> queued up for 5.19 and newer and it is not relevant for 5.4 and older
> (at least upstream, I'll be doing backports for older Android branches
> shortly). If there are any questions or problems, please let me know!

All now queued up, thanks.

gre gk-h
