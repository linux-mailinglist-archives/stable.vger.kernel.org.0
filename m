Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EF42B5CCD
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 11:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgKQK1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 05:27:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgKQK1K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 05:27:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63E6E22202;
        Tue, 17 Nov 2020 10:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605608830;
        bh=suTWvoLJ55Ut1FqBR7Xy/ItUlnZJmBkmEfCbJxX1yR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EkcUKO1bbVjQJmBvMV2pyTcBInGMm4m9iRqXrWXX5MRwMzD4VKEJWrR5yl0v5j9Sy
         Qa1rzwANDRKu7H4ErZmJG58j71EYDkX2HDFXurin6kop5cauF87/7wX2YozUgklB0a
         z2dJKsQwsSvH2ihf5/fVQEJrhFt13eByVTt2qwUU=
Date:   Tue, 17 Nov 2020 11:27:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH for 5.4] powerpc/603: Always fault when _PAGE_ACCESSED is
 not set
Message-ID: <X7OlrpFkRKBQMNQ8@kroah.com>
References: <9351d8a775f749d7c881c909388e69af944087b9.1604943353.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9351d8a775f749d7c881c909388e69af944087b9.1604943353.git.christophe.leroy@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 05:40:52PM +0000, Christophe Leroy wrote:
> [That is backport of 11522448e641e8f1690c9db06e01985e8e19b401 to linux 5.4]
> 
> The kernel expects pte_young() to work regardless of CONFIG_SWAP.
> 
> Make sure a minor fault is taken to set _PAGE_ACCESSED when it
> is not already set, regardless of the selection of CONFIG_SWAP.
> 
> Fixes: 84de6ab0e904 ("powerpc/603: don't handle PAGE_ACCESSED in TLB miss handlers.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/a44367744de54e2315b2f1a8cbbd7f88488072e0.1602342806.git.christophe.leroy@csgroup.eu
> ---
>  arch/powerpc/kernel/head_32.S | 12 ------------
>  1 file changed, 12 deletions(-)

Both backports now queued up, thanks.

greg k-h
