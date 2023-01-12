Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AC2667239
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjALMaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjALM36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:29:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BC8A46E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 04:29:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F2D560A4A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82435C433D2;
        Thu, 12 Jan 2023 12:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673526596;
        bh=Azfu2PaDRFlL7vR1Xe0tVz+zhHnZpHN2QszA7BBaohI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m62W1Bi6ScFuSEgz/pgznRMrwhvtvn4HAk0a6Us1+DMRvdovSTApj4thxgavPCNMW
         ly8X2tPBIUJvRdUM2y5VUuEZRgL8FE0W6LiCLxhuj+yudvO6evQ8HPIs+Y71VLHUxM
         Oos7PWMX6PFH7gHYGf4zE94jhqjNqNdYUi2vdulQ=
Date:   Thu, 12 Jan 2023 13:29:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH stable 5.4.y] efi: random: combine bootloader provided
 RNG seed with RNG protocol output
Message-ID: <Y7/9Qq91/tjMy1Yn@kroah.com>
References: <CAHmME9oomMCxw=OQZpSp+hwLM78hZV+gNyn8ZPJgN99s2e=tuw@mail.gmail.com>
 <20230110194540.463983-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110194540.463983-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 08:45:40PM +0100, Jason A. Donenfeld wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> commit 196dff2712ca5a2e651977bb2fe6b05474111a83 upstream.
> 

Now queued up, thanks.

greg k-h
