Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960C31F6979
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 15:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgFKN5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 09:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgFKN5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 09:57:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 306B7206C3;
        Thu, 11 Jun 2020 13:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591883854;
        bh=AfDuKbF9OtpsediGNO+3NynP+WMOL5HhOuy8v9ZFhPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vhHLcpTFHd5cdFwhK1QvbC2PJlU8vaMJ4jssfpO82j97kOmBjBzZXIrUNvMvYVbqM
         dN+AKheH9BbEQcFRN9rdXB3E0cg044n2CYS/iX7XfRVMLAJeQvK6AC4tIZHMDDo658
         pTChFlwMIZuZhdpEyUNYhd6nzJR3310o2lY98sDU=
Date:   Thu, 11 Jun 2020 15:57:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Su Kang Yin <cantona@cantona.net>
Cc:     linux-crypto@vger.kernel.org, christophe.leroy@c-s.fr,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] crypto: talitos - fix ECB and CBC algs ivsize
Message-ID: <20200611135727.GA1060798@kroah.com>
References: <cantona@cantona.net>
 <20200611115048.21677-1-cantona@cantona.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611115048.21677-1-cantona@cantona.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 07:50:47PM +0800, Su Kang Yin wrote:
> commit e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
> wrongly modified CBC algs ivsize instead of ECB aggs ivsize.
> 
> This restore the CBC algs original ivsize of removes ECB's ones.
> 
> Fixes: e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
> Signed-off-by: Su Kang Yin <cantona@cantona.net>
> ---
> Patch for 4.9 upstream.

Also seems to be an issue for the 4.14 and 4.19 backport, so I'll queue
it up there too, thanks!

greg k-h
