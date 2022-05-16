Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A373F528469
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 14:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbiEPMrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 08:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236219AbiEPMrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 08:47:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CAE38BDF
        for <stable@vger.kernel.org>; Mon, 16 May 2022 05:47:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4C4C6120D
        for <stable@vger.kernel.org>; Mon, 16 May 2022 12:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBF5C385AA;
        Mon, 16 May 2022 12:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652705235;
        bh=Mm/nOc1mISIhnmSZAdhmR4RYnC71qymq11swnS6kGsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MoZsYYWoheW+GRffMT/7J1vwWMpjwObmF3KgVQmFUa9Tw9PhkywkbIF0SG0u0ZfIz
         iW7B5JwJNnoQnNzfa2h1LgfSI1WKS0GQzCz/Opyzc9XPRvC37YLNzHgK8nSxNf2tnz
         tghJDXxREnucZWS6grxglECZOHGDuDTDAr/Edfs4=
Date:   Mon, 16 May 2022 14:47:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     rppt@kernel.org, akpm@linux-foundation.org, ardb@kernel.org,
        bot@kernelci.org, broonie@kernel.org, catalin.marinas@arm.com,
        linux@armlinux.org.uk, mark-pk.tsai@mediatek.com,
        stable@vger.kernel.org, tony@atomide.com, will@kernel.org
Subject: Re: FAILED: patch "[PATCH] arm[64]/memremap: don't abuse pfn_valid()
 to ensure presence" failed to apply to 5.10-stable tree
Message-ID: <YoJHyzxf2q+G5fiU@kroah.com>
References: <165268901815650@kroah.com>
 <YoIjoM96TItpIT8U@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoIjoM96TItpIT8U@linux.ibm.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 01:12:48PM +0300, Mike Rapoport wrote:
> Hi Greg,
> 
> On Mon, May 16, 2022 at 10:16:58AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> The patch below applies to 5.10.y and 5.4.y.
> 
> As for 4.19.y and older kernels, the issue this patch fixes won't reproduce
> because these kernels don't have backports of pfn_valid() implementation.

Now queued up, thanks.

greg k-h
