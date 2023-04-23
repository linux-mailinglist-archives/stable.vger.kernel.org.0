Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EA46EBFAE
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 15:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjDWNK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 09:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjDWNK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 09:10:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BD4171E
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 06:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A095260C89
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 13:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF43C433EF;
        Sun, 23 Apr 2023 13:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682255441;
        bh=Wg1qoFu8fORTFmKPKyB+iRxUGB9iyjRU2pUCXPlH7l8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mbad4fxFpTx5EhWm1aSkECAjRdortcwcXcKhIbB7jB9OXGkjYXrv4RXxwXucafgdN
         P6QN5cnrOh+Y8dVzehobpYktx7gNc1Vx1hmuw5Wj9fPYVpuZWz7zD+uk5V2EJrD7qn
         PslLmRkhm02MdpxgXROYMwjqx4KeYQ0p0e7jwHfU=
Date:   Sun, 23 Apr 2023 15:10:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alyssa Ross <hi@alyssa.is>
Cc:     stable@vger.kernel.org, Nick Cao <nickcao@nichi.co>,
        Ingo Molnar <mingo@kernel.org>,
        Pingfan Liu <kernelfans@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Steve Wahl <steve.wahl@hpe.com>, Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH v4.14] x86/purgatory: Don't generate debug info for
 purgatory.ro
Message-ID: <2023042328-prelaw-elastic-7d96@gregkh>
References: <20230421224048.1236703-1-hi@alyssa.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421224048.1236703-1-hi@alyssa.is>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 21, 2023 at 10:40:48PM +0000, Alyssa Ross wrote:
> From: Pingfan Liu <kernelfans@gmail.com>
> 
> Purgatory.ro is a standalone binary that is not linked against the rest of
> the kernel.  Its image is copied into an array that is linked to the
> kernel, and from there kexec relocates it wherever it desires.
> 
> Unlike the debug info for vmlinux, which can be used for analyzing crash
> such info is useless in purgatory.ro. And discarding them can save about
> 200K space.
> 
>  Original:
>    259080  kexec-purgatory.o
>  Stripped debug info:
>     29152  kexec-purgatory.o
> 
> Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
> Acked-by: Dave Young <dyoung@redhat.com>
> Link: https://lore.kernel.org/r/1596433788-3784-1-git-send-email-kernelfans@gmail.com
> (cherry picked from commit 52416ffcf823ee11aa19792715664ab94757f111)
> Signed-off-by: Alyssa Ross <hi@alyssa.is>
> ---
>  arch/x86/purgatory/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
>

All now queued up, thanks.

greg k-h
