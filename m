Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD7122C27F
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 11:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgGXJm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 05:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgGXJmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 05:42:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0164B206EB;
        Fri, 24 Jul 2020 09:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595583775;
        bh=gcicbzEsoqZGDCiDwp7yWjuSGQR3kEh2exJVp9X61s8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z0Aam/27R2h/LYn2OtUt0ltnP8FU4pkDHrbut9JjoryYvG8DPyRGyciq4bhbVYERH
         IJS4U/HXj0jqPCSTyakfxy+AQ8Rw2gDu6Ayd1dOLMFM7wjfWGv5EsjBC7hG3Sutglq
         XJK5XS93Bh75RCCJCv3m73Zl56sr09KRUESAzxsA=
Date:   Fri, 24 Jul 2020 11:42:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     'Sasha Levin' <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 5.7.y 0/4] exfat stable patches for 5.7.y
Message-ID: <20200724094257.GA4176508@kroah.com>
References: <CGME20200724002112epcas1p24c54808617a5baddef4e4a2f49722866@epcas1p2.samsung.com>
 <20200724001544.30862-1-namjae.jeon@samsung.com>
 <20200724035723.GF406581@sasha-vm>
 <016201d6616f$0983e030$1c8ba090$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <016201d6616f$0983e030$1c8ba090$@samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 24, 2020 at 01:00:58PM +0900, Namjae Jeon wrote:
> > 
> > On Fri, Jul 24, 2020 at 09:15:40AM +0900, Namjae Jeon wrote:
> > >Hi,
> > >
> > >Could you please pick up exfat stable patches ?
> > 
> Hi Sasha,
> > I see that the upstream commits already have stable tags and don't need modifications for backporting,
> > so there is no need to explicitly send them here - they will be picked up automatically.
> Okay, I see:)

As Sasha said, these will normally get picked up automatically.  We wait
until a patch is in a release from Linus (i.e. a -rc) before taking
them, but we can take them earilier if you ask for them.

You did include one patch in this series that was not marked for stable,
so I've taken that, and the other 3 now to make it easy.

thanks,

greg k-h
