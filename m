Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DF31F66A8
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 13:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgFKLah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 07:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgFKLah (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 07:30:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D32C020760;
        Thu, 11 Jun 2020 11:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591875037;
        bh=umLfLpE5cyOCyLq4pp0i2DgdRaUhWHxPKb4cPTpRGmI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sTaFX+js1RiIwIQ3ZSAT8qo54zTwAmFf7tv8/UlCj6du657P9AC7CyyNjxmqLUeI9
         pmnFICCM8r4mViBhBjSoGnxg18iN4NsrANWuhJtuxOZUwniR1DvxlTBO/grMkDSCUt
         VHIxE8OxH8PbxP0OqVvvtTOLheWx47sSCnPgzDdI=
Date:   Thu, 11 Jun 2020 13:30:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     cantona@cantona.net, stable@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, stable-commits@vger.kernel.org
Subject: Re: Patch "crypto: talitos - fix ECB and CBC algs ivsize" has been
 added to the 4.9-stable tree
Message-ID: <20200611113030.GA731261@kroah.com>
References: <1591874497241120@kroah.com>
 <b639a842-5654-d719-d28c-9791f8f9cbac@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b639a842-5654-d719-d28c-9791f8f9cbac@csgroup.eu>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 01:27:34PM +0200, Christophe Leroy wrote:
> 
> 
> Le 11/06/2020 à 13:21, gregkh@linuxfoundation.org a écrit :
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >      crypto: talitos - fix ECB and CBC algs ivsize
> > 
> > to the 4.9-stable tree which can be found at:
> >      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >       crypto-talitos-fix-ecb-and-cbc-algs-ivsize.patch
> > and it can be found in the queue-4.9 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> As far as I can see, the faulty commit e1de42fdfc6a ("crypto: talitos - fix
> ECB algs ivsize") only removed .ivsize = AES_BLOCK_SIZE at a wrong place.
> 
> The other changes (removal of .ivsize = DES_BLOCK_SIZE and .ivsize =
> DES3_EDE_BLOCK_SIZE) are not from the faulty patch.

Now dropped, sorry about that.

greg k-h
