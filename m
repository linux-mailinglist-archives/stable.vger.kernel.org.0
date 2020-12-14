Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF19C2D9B57
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 16:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgLNPp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 10:45:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728570AbgLNPp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 10:45:26 -0500
Date:   Mon, 14 Dec 2020 16:45:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607960685;
        bh=nXuKMLaSsD/hk5QGXv6KpGF5eAMD3kQqPJ6KcpzrXxA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=UQ0SYgfiaanxwh+X+pbLa3mX79jWocJWsELfWckzG5uPJR710dCpARLdxnU+f4cXA
         rdAY7gAnCuRzUjVayBGmgwBq+5NJKreMnEZ7yUSHotjrtaJek13RlLZtv8akeByih8
         HAVHbFyAtdh9Xx4J8YIEg6lh6L7fFTnDCTp2ceY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: request for 4.9-stable and 4.4-stable: ddf75be47ca7 ("spi:
 Prevent adding devices below an unregistering controller")
Message-ID: <X9eIrnzXCKtH93uV@kroah.com>
References: <20201214135632.2qt4rokovnxjoujj@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214135632.2qt4rokovnxjoujj@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 01:56:32PM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> This was missing in 4.9-stable and 4.4-stable. Please apply to your queue.


Now queued up, thanks,.

greg k-h
