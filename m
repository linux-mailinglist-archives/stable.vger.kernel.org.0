Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E30E59053B
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbiHKQ7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbiHKQ7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:59:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABACDD768
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 09:30:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D395E615D5
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 16:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7010C433D6;
        Thu, 11 Aug 2022 16:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660235434;
        bh=rLzVf94CqJubYbC/2VyYRRoSKmauue7YjGK/f17crXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TbVIPNs7/xSOIORqRTxb8u0WgFtD16Pkl4PTBE7KwYDuyKk6i3ss9MJ7A2uo9huhx
         26/HymmPF5Y963AdF57mWU9K0QaFMVLTroTu6E6LIxliufpGI9BIIhkhPDPRY1ZFiw
         VyZv6AI1PpLGh+9dBKBXPoqUfLydqmf54ojH7IEE=
Date:   Thu, 11 Aug 2022 18:30:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason@zx2c4.com, mpe@ellerman.id.au, sachinp@linux.ibm.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc/powernv/kvm: Use darn for
 H_RANDOM on Power9" failed to apply to `gum-stable tree
Message-ID: <YvUup+VmtnYTHCuS@kroah.com>
References: <1660233744176225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1660233744176225@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 06:02:24PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the `gum-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Oops, my script went wrong for a bit, now fixed with the right kernel
versions.

thanks,

greg k-h
