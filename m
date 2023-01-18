Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7221B67140E
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 07:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjARG15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 01:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjARGZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 01:25:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101C9521DF;
        Tue, 17 Jan 2023 22:14:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A196A61648;
        Wed, 18 Jan 2023 06:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BD8C433EF;
        Wed, 18 Jan 2023 06:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674022450;
        bh=NpPVHi+rA6d/CMkeffuXNpgc4msokkYnNi1AFVaCwSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gv5FNTDjnuN/U9YRwsANt3dd+MwxzWBpwr/+sQQVALpZ7TKcnWW4ld/2HHzQAF8L4
         jnL8gGbiaW7QwYTV5NYzwTbjwqPhyrf7Yixc9H3444r4+jgPHnY046hhpASh/y/9Rh
         Jp4qKt4ZgjEs6NOlBvuY6nMQ3NVHQBwmOOrvc810=
Date:   Wed, 18 Jan 2023 07:14:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <Y8eOLt7fw+Hmicmy@kroah.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <Y6M090tsVRIBNlNG@kroah.com>
 <20221221205210.6oolnwkzqo2d6q5h@oracle.com>
 <Y6Pyp+7Udn6x/UVg@kroah.com>
 <20230109183615.zxe7o7fowdpeqlj3@oracle.com>
 <Y7/2ef+JWO6BXGfC@kroah.com>
 <20230112212006.rnrbaby2imjlej4q@oracle.com>
 <20230113150654.w4cbvtasoep5rscw@oracle.com>
 <Y8Kz8JwM/4GyN1um@kroah.com>
 <20230117235006.oishw5tlc3xnwwmd@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230117235006.oishw5tlc3xnwwmd@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 05:50:06PM -0600, Tom Saeger wrote:
> On Sat, Jan 14, 2023 at 02:53:52PM +0100, Greg Kroah-Hartman wrote:
>   Masahiroy's commit is already in Linus's tree.
> 
> ❯ git log -n1 --format=oneline 99cb0d917ffa
> 99cb0d917ffa1ab628bb67364ca9b162c07699b1 arch: fix broken BuildID for arm64 and riscv
> 
> ❯ git tag --contains=99cb0d917ffa
> v6.2-rc2
> v6.2-rc3
> v6.2-rc4

Using 'git tag' doesn't always show the best info, better is the
following:
	$ git describe --contains 99cb0d917ffa1ab628bb67364ca9b162c07699b1
	v6.2-rc2~5^2~6

Anyway, I'll look at this after the next round gets released, thanks!

greg k-h
