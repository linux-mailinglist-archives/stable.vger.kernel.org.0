Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3056671BF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbjALMMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbjALMLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:11:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9796258
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 04:07:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 195476201A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054A7C433D2;
        Thu, 12 Jan 2023 12:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673525229;
        bh=aRnw56EBi6gBAFKu3+jn3vDGbM15qmYd+0I5cHmBiyM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TJApOmEQJ+aMOFzaiLXX+niYO+4sEM63alflXCgoR9Bs9vxs7VsThh3qHDVtPzrzr
         sQ6k0PkJw5U+hzTElsLG9N5XdXUYkdo8M5j799ICcF77ngEf+HiXCImApM3RxnTaUG
         ++aLo/hlQyFddgOgfPbbvZO9zr0ZYS7mnnkhCwZM=
Date:   Thu, 12 Jan 2023 13:07:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Helge Deller <deller@gmx.de>
Cc:     stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>
Subject: Re: [STABLE 4.14/4.19] [PATCH] parisc: Align parisc MADV_XXX
 constants with all other architectures
Message-ID: <Y7/36pGYaLUrQ3zQ@kroah.com>
References: <Y73Rjn7y35vQskE1@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y73Rjn7y35vQskE1@p100>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 09:58:54PM +0100, Helge Deller wrote:
> Hi Greg,
> 
> can you please consider adding this patch to the 4.14 and 4.19 stable kernels?
> It's a backport of upstream commit 71bdea6f798b425bc0003780b13e3fdecb16a010

All backports now queued up, thanks!

greg k-h
