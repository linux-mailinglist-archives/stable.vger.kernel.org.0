Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1B2355C6
	for <lists+stable@lfdr.de>; Sun,  2 Aug 2020 09:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgHBHEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Aug 2020 03:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgHBHEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 Aug 2020 03:04:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F093207DF;
        Sun,  2 Aug 2020 07:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596351863;
        bh=4NN+E0oM8rDTtNLA3DrafNlW4yEua6pcSF2ObfX7baI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GIvQrhMr/lYbh51/Pyh3QmjJh2kx81W4Q/9xofKIonvSJs1MVgSKUp2eGbqaU4Jm2
         iII0JwdvtL5IQzioi7frBVqUqRD5RJGPYAhL+6O2ih9jOEiJOqSUFFGUSQEXQA/Oa8
         EHSDTdf1LeGH59eWK1qe4dfCQbvT48Bso/xU162E=
Date:   Sun, 2 Aug 2020 09:04:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rolf Eike Beer <eb@emlix.com>
Cc:     stable@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH 4.9.y 2/2] install several missing uapi headers
Message-ID: <20200802070407.GB3889624@kroah.com>
References: <2225723.ZPmVZEtQ53@devpool35>
 <2892097.ECyh5nn9PN@devpool35>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2892097.ECyh5nn9PN@devpool35>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 03:01:45PM +0200, Rolf Eike Beer wrote:
> Commit fcc8487d477a3452a1d0ccbdd4c5e0e1e3cb8bed ("uapi: export all headers
> under uapi directories") changed the default to install all headers not marked
> to be conditional. This takes the list of headers listed in the commit message
> and manually adds an export for those that are already present in this kernel
> version.
> 
> Found during an attempt to build mtd-utils 2.1.2 as it wants hash_info.h, which
> exists since 3.13 but has not been installed until the above mentioned commit,
> which ended up in 4.12.
> 
> Signed-off-by: Rolf Eike Beer <eb@emlix.com>
> ---
>  arch/mips/include/uapi/asm/Kbuild    |  3 +++
>  arch/powerpc/include/uapi/asm/Kbuild |  1 +
>  include/uapi/drm/Kbuild              |  3 +++
>  include/uapi/linux/Kbuild            | 20 ++++++++++++++++++++
>  include/uapi/linux/cifs/Kbuild       |  2 ++
>  include/uapi/linux/genwqe/Kbuild     |  2 ++
>  6 files changed, 31 insertions(+)
>  create mode 100644 include/uapi/linux/cifs/Kbuild
>  create mode 100644 include/uapi/linux/genwqe/Kbuild

I doubt many people are hitting this old issue on 4.9, but oh well, it
looks correct, so now queued up :)

greg k-h
