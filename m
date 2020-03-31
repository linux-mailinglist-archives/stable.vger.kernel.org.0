Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F651199671
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 14:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgCaM0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 08:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730343AbgCaM0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 08:26:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AFE720848;
        Tue, 31 Mar 2020 12:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585657583;
        bh=LRNPIfNer2/ZXg6agR1rxzsrapcVYlRW6KHf/6lHOTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a/IKLglL+3d8+yzz2DY+FIiMuBy0M7DNRw9np3cly/Fd4u7r71QWnqObSAZHuIbwx
         Km4rEji1FNceHPfvLZI7PbdWrIaQmvu3HI2xNRz7oP4FcMkUcYKemHfNDJXWud1+tx
         FIXW7ekIE3s85gqmVB9OGDrOZQkTp4oCHICcX0Pk=
Date:   Tue, 31 Mar 2020 14:09:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dirk =?iso-8859-1?Q?M=FCller?= <dmueller@suse.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 5.5 102/170] scripts/dtc: Remove redundant YYLOC global
 declaration
Message-ID: <20200331120917.GA1617997@kroah.com>
References: <20200331085423.990189598@linuxfoundation.org>
 <20200331085435.053942582@linuxfoundation.org>
 <20200331095323.GA32667@ubuntu-m2-xlarge-x86>
 <20200331100238.GA1204199@kroah.com>
 <5B6493BE-F9FE-41A4-A88A-5E4DF5BCE098@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5B6493BE-F9FE-41A4-A88A-5E4DF5BCE098@suse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 01:45:09PM +0200, Dirk Müller wrote:
> Hi Greg,
> 
> >> $ sed -i 's;scripts/dtc/dtc-lexer.l;scripts/dtc/dtc-lexer.lex.c_shipped;g' \
> >> queue-{4.4,4.9,4.14}/scripts-dtc-remove-redundant-yyloc-global-declaration.patch
> >> If you would prefer a set of patches, let me know.
> > Should I just drop the patch from 4.4, 4.9, and 4.14 instead?
> 
> as the original author of the patch, I am not sure why it was backported to the LTS releases (unless enablement for gcc 10.x or
> other new toolchains is a requirement, which I'm not aware of). 

Keeping the older kernels building with newer compilers is something
that we do.  It's needed as our build systems "age-out" the older
compilers a lot :)

> However I think the sed above on the *patch* means that the patch will *only* modify the generated sources, not the input sources. I think
> it would be better to patch both *input* and *generated* sources, or backport the generate-at-runtime patch as well (which might be
> even further outside the stable policy). 

What do you mean by "input sources" here?

> Not knowing why it was backported, I would suggest to just dequeue the patch from the older trees. 

If I drop it for now, I'll have to add it back when gcc10 is pushed out
to my build systems and laptops :(

thanks,

greg k-h
