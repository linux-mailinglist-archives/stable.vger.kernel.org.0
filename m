Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A484FBD0E
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 15:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346402AbiDKNbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 09:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346401AbiDKNbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 09:31:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB51A18F;
        Mon, 11 Apr 2022 06:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCE2260BBF;
        Mon, 11 Apr 2022 13:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FEEC385A4;
        Mon, 11 Apr 2022 13:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649683732;
        bh=TC0ZJSe2oB1L9uNa7i44bNF7FkAH5NEshanSOSJVJSE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BqCOa22gpra/JymKzjlJApCj3Ua7TxkeuayMdEOYjhzs6GMr26HGCAdbHwZt7xMFK
         mORd49l7ua9Nfb1+hSoKmFa7famg4xUU6kmE6yP6P1RKdstrU/YlzPNFBzNfwZQw+a
         xo/ruWE3Q64CAZ9W4RZiXsN140lD8HSzOjk+e9vQ=
Date:   Mon, 11 Apr 2022 15:28:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     stable@vger.kernel.org, yang.zhong@intel.com, bonzini@gnu.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][Rebased for 5.16] x86/fpu/xstate: Fix the
 ARCH_REQ_XCOMP_PERM implementation
Message-ID: <YlQtEVLZpPQata7q@kroah.com>
References: <164905801910825@kroah.com>
 <20220405110456.24877-1-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405110456.24877-1-chang.seok.bae@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 04:04:56AM -0700, Chang S. Bae wrote:
> From: Yang Zhong <yang.zhong@intel.com>
> 
> This is backport for 5.16
> 
> Upstream commit 063452fd94d153d4eb38ad58f210f3d37a09cca4
> 
> ARCH_REQ_XCOMP_PERM is supposed to add the requested feature to the
> permission bitmap of thread_group_leader()->fpu. But the code overwrites
> the bitmap with the requested feature bit only rather than adding it.
> 
> Fix the code to add the requested feature bit to the master bitmask.
> 
> Fixes: db8268df0983 ("x86/arch_prctl: Add controls for dynamic XSTATE components")
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paolo Bonzini <bonzini@gnu.org>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20220129173647.27981-2-chang.seok.bae@intel.com
> [chang: Backport for 5.16]
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> ---
>  arch/x86/kernel/fpu/xstate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
