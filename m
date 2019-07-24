Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7444172E5E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 14:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfGXMEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 08:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbfGXMEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 08:04:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50625229ED;
        Wed, 24 Jul 2019 12:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563969859;
        bh=CdooaFb7VKgoaeL59t55xZg06X/TtYU4qn+WVSgIKpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GZ5iuyEXW8a5ULnBdPmGTj1+2fn1SPnt8wcKTEBkXfNUKlWLR5ADqmrDwDDkHI+zZ
         BrNoja6MFQ7Kju7DL486bj9+zWW1JfwwYkm+j6mDCh3WyNEWtRKDsVWuRCHKsqvZZo
         vjtLsou4r3SCdR3c1xt/lAJbRfnFtguZH5004Hqw=
Date:   Wed, 24 Jul 2019 14:04:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 4.9] crypto: caam - limit output IV to CBC to work around
 CTR mode DMA issue
Message-ID: <20190724120417.GE3244@kroah.com>
References: <20190723131947.27871-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190723131947.27871-1-horia.geanta@nxp.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 23, 2019 at 04:19:47PM +0300, Horia Geantă wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> commit ed527b13d800dd515a9e6c582f0a73eca65b2e1b upstream.

Now applied, along with the 4.14.y and 4.19.y versions.

thanks,

greg k-h
