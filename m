Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0D825D885
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 14:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgIDMVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 08:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729932AbgIDMVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 08:21:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B8F32087C;
        Fri,  4 Sep 2020 12:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599222079;
        bh=eOHearcKSmpIjWZvgrg1LlgSSv37rqoYwRrYtSc8bK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qzV0vizMGwZWk7Mtx67BxqNykK4EhUBCF+6wM8A+HY79QgvgKGZ9HPmNinY+Z0wwI
         NCyjp5BtjNazpvtnyNpuW++fDu+lzlcsiAJmOxYSpdsdjbX40a8OqkIH8twWtiyUr3
         8hie+u8awLMhaWRgzFqhiSTO5F0IKrrxubwTFlHU=
Date:   Fri, 4 Sep 2020 14:21:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Stefan Berger <stefanb@linux.vnet.ibm.com>, stable@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Subject: Re: [PATCH for-4.14] tpm: Unify the mismatching TPM space buffer
 sizes
Message-ID: <20200904122140.GA3150287@kroah.com>
References: <20200831185849.2696852-1-stefanb@linux.vnet.ibm.com>
 <20200904120529.GD39023@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904120529.GD39023@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 04, 2020 at 03:05:29PM +0300, Jarkko Sakkinen wrote:
> On Mon, Aug 31, 2020 at 02:58:49PM -0400, Stefan Berger wrote:
> > From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > 
> > The size of the buffers for storing context's and sessions can vary from
> > arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
> > maximum for PPC64). Define a fixed buffer size set to 16 kB. This should be
> > enough for most use with three handles (that is how many we allow at the
> > moment). Parametrize the buffer size while doing this, so that it is easier
> > to revisit this later on if required.
> > 
> > Cc: stable@vger.kernel.org
> > Reported-by: Stefan Berger <stefanb@linux.ibm.com>
> > Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
> > Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
> > Tested-by: Stefan Berger <stefanb@linux.ibm.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Thank you for doing this.
> 
> You are missing one thing from this.
> 
> You need to have this line before the long description:
> 
>   "commit <original commit ID> upstream"
> 
> It is documented over here:
> 
>    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

This is already merged :)
