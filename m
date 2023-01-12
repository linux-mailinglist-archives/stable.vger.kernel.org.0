Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB36E6672CF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjALND2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbjALNC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:02:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD5152C7F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:02:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE8A660AC4
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4561C433F0;
        Thu, 12 Jan 2023 13:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673528548;
        bh=Kaik6aE6PO7UbrXuYTQ478apYhgSWqSz6xJaFYJMAuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QDO+mHEotwJ1auOy4L0+H7nifHJN3j/0KnV7QvQ7vKi17kpyvz+soK9o20uBbSJZv
         3n847wy5g6Xoq5GVTM06VHnfVRH8bwVPjyl+l4k9NLAbwa+wksksqQUIKeelFii/Vi
         Cdj9bZPwxQcDFV7QKqcvzEF8QM/z9iVPVds3GPgI=
Date:   Thu, 12 Jan 2023 14:02:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: Re: [PATCH stable 5.4.y] efi: random: combine bootloader provided
 RNG seed with RNG protocol output
Message-ID: <Y8AE4djWgqWyQ3ik@kroah.com>
References: <CAHmME9oomMCxw=OQZpSp+hwLM78hZV+gNyn8ZPJgN99s2e=tuw@mail.gmail.com>
 <20230110194540.463983-1-Jason@zx2c4.com>
 <Y7/9Qq91/tjMy1Yn@kroah.com>
 <CAMj1kXECPUXHyB4Ub5d79uB7Y2LuJryench6oa++tFw8Bb-A4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXECPUXHyB4Ub5d79uB7Y2LuJryench6oa++tFw8Bb-A4g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 01:31:19PM +0100, Ard Biesheuvel wrote:
> On Thu, 12 Jan 2023 at 13:29, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jan 10, 2023 at 08:45:40PM +0100, Jason A. Donenfeld wrote:
> > > From: Ard Biesheuvel <ardb@kernel.org>
> > >
> > > commit 196dff2712ca5a2e651977bb2fe6b05474111a83 upstream.
> > >
> >
> > Now queued up, thanks.
> >
> 
> Queued up where? Not v5.4 I hope?

Ick, yes, I did that, I'll go drop this now, sorry for the noise.

greg "burried in patches" k-h
