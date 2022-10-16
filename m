Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2405FFF60
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 15:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJPNBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 09:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJPNBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 09:01:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C346739103
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 06:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1E4D8CE0D9A
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C67C433D6;
        Sun, 16 Oct 2022 13:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665925293;
        bh=CHv8Y8LZTQ/+NIwIFQXK13RUXCfSdHsuRY2MhIHYBQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UmW+xBeJvmAIi4pI8JtU5y5p6iIGEflliN6KdyobV0Ut4NjkEjKgaq6mxeYFx+KS4
         01XgfdLdSs3yYkLJhcMTgkBAw6U1eFzDPLNdMicfjqXD04/gnfIOv5pxlBxF3dWlxC
         QJs6+Ny7MNpts4qeKPi51eFxXDmpXX7+kkjUZRWQ=
Date:   Sun, 16 Oct 2022 15:02:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4.14 0/2] nilfs2 lockdep warning fixes
Message-ID: <Y0wA2+cgr1YI2SCn@kroah.com>
References: <20221014114826.21895-1-konishi.ryusuke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014114826.21895-1-konishi.ryusuke@gmail.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 08:48:24PM +0900, Ryusuke Konishi wrote:
> Hi Greg,
> 
> please apply the following two cc-stable patches to 4.14-stable.
> 
> Ryusuke Konishi (2):
>   nilfs2: fix lockdep warnings in page operations for btree nodes
>   nilfs2: fix lockdep warnings during disk space reclamation
> 
> During testing nilfs2 filesystem with stable trees, I encountered a
> lockdep warning followed by a kernel panic (by panic_on_warn) only in
> 4.14-stable.
> 
> I found that the cause was the lack of these patches which are applied
> to other newer stable trees.  I guess they were dropped since the
> first patch was not applicable as is due to a pagevec change.
> 
> After I manually applied them to 4.14, the panic and lockdep warning
> have gone.  So, I believe these should be backported to 4.14-stable as
> well.

All queued up, thanks.

greg k-h
