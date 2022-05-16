Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F882528437
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 14:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbiEPMbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 08:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiEPMbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 08:31:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC5231223
        for <stable@vger.kernel.org>; Mon, 16 May 2022 05:31:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C5ABDCE12FB
        for <stable@vger.kernel.org>; Mon, 16 May 2022 12:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90805C385B8;
        Mon, 16 May 2022 12:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652704303;
        bh=fFqTh1KZUhp6fbzR0NvgWlbSjhmsg3kFtEFWHAfhe0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2wNi1N0lEbz0JKdvu1D5cD4xrxYVDsGdGBTzUQghG1jBtkyly79I4iMtwIgDVd7sz
         KgaRNRuM73ap6tk7xvBbQU72Wi9JdiI/ZH4v4f1bETcP0PMXSpNT/uvgtu3F7qnThv
         3QSdhkce/fY+R4yEsbob6mpdBVk6fJLlDydveO7M=
Date:   Mon, 16 May 2022 14:31:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19] MIPS: fix allmodconfig build with latest mkimage
Message-ID: <YoJEK4PUlfIcIld7@kroah.com>
References: <20220514153414.6190-1-sudip.mukherjee@sifive.com>
 <YoAZLPxTYsqEypGP@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoAZLPxTYsqEypGP@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 14, 2022 at 02:03:40PM -0700, Nathan Chancellor wrote:
> On Sat, May 14, 2022 at 04:34:14PM +0100, Sudip Mukherjee wrote:
> > From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> > 
> > With the latest mkimage from U-Boot 2021.04+ the allmodconfig build
> > fails. 822564cd3aa1 ("MIPS: generic: Update node names to avoid unit
> > addresses") was applied for similar build failure, but it was not
> > applied to 'arch/mips/generic/board-ocelot_pcb123.its.S' as that was
> > removed from upstream when the patch was applied.
> > 
> > Fixes: 822564cd3aa1 ("MIPS: generic: Update node names to avoid unit addresses")
> 
> Ah, fair enough. I missed this because the board file was renamed and
> updated as part of commit 39249d776ca7 ("MIPS: mscc: add PCB120 to the
> ocelot fitImage"), which was a part of 4.20... :) the upstream change
> has this properly fixed and this diff matches so:
> 
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>

Now queued up, thanks.

greg k-h
