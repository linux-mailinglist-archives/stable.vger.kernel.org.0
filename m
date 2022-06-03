Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E32A53CBB7
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 16:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243981AbiFCOpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 10:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiFCOpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 10:45:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F02843AD9;
        Fri,  3 Jun 2022 07:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9A4E617D2;
        Fri,  3 Jun 2022 14:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6CFC385A9;
        Fri,  3 Jun 2022 14:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654267540;
        bh=qgZ6/AFouFZNlHDq3we/rEMDrAR/urFfhfyaZ5Lf4eA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FkIVa7IDXQoKA4CLqyleWeWjZlNThrRbCEN7WP0Bbd9W3UIaYlTRDU96hbbSxJKGc
         6Bf7jjV7cAoVBIQI7HcGPaSM0QoW+Jl9gsYbKPtQmuenwo5OqYvP43R/VSD67LiiVu
         F0dxksEtEwiGxweUJqCPyGsZa0IbrcuFdB06Z7lk=
Date:   Fri, 3 Jun 2022 16:45:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dragos-Marian Panait <dragos.panait@windriver.com>
Cc:     stable@vger.kernel.org, Haimin Zhang <tcs.kernel@gmail.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14 0/1] block-map: backport fix for CVE-2022-0494
Message-ID: <YpoekNgtsCBi3yw5@kroah.com>
References: <20220602150157.2255674-1-dragos.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602150157.2255674-1-dragos.panait@windriver.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 02, 2022 at 06:01:56PM +0300, Dragos-Marian Panait wrote:
> The following commit is needed to fix CVE-2022-0494:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cc8f7fe1f5eab010191aa4570f27641876fa1267
> 
> Haimin Zhang (1):
>   block-map: add __GFP_ZERO flag for alloc_page in function
>     bio_copy_kern
> 
>  block/bio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> base-commit: 501eec4f9e138b958fc7438e7a745c0d6a7c68b3
> -- 
> 2.36.1
> 

All now queued up, thanks.

greg k-h
