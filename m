Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7129190A
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 20:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfHRSrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 14:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbfHRSrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Aug 2019 14:47:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84531206C1;
        Sun, 18 Aug 2019 18:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566154067;
        bh=T+mFAJ7KMjNJPdKMUoqkNIWKEMSWxrlZiicQQOTUx6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WPE3wHYY19KqmbY16Vvn58J51piBHgeT9EuxAZhTXjDFsFCcuvXYjtBxxo9QUIq+2
         qFCuCr49o7gUl5q7CLNq29CHhKZxHYlaMZbr4GUHlJfxNOR6d2ZZJGKF0Ed/hPCzxH
         RZFjiElV8x3cP/yu3OgKDzug5nznpPdy9WZJsfm0=
Date:   Sun, 18 Aug 2019 20:47:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [5.2-stable][PATCH] arm64: KVM: regmap: Fix unexpected switch
 fall-through
Message-ID: <20190818184744.GC2791@kroah.com>
References: <20190818165529.835-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818165529.835-1-maz@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 05:55:29PM +0100, Marc Zyngier wrote:
> From: Anders Roxell <anders.roxell@linaro.org>
> 
> commit 3d584a3c85d6fe2cf878f220d4ad7145e7f89218 upstream.

Both patches now queued up, thanks!

greg k-h
