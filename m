Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB547BD0B
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfGaJ0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:26:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728848AbfGaJ0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:26:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5756F20693;
        Wed, 31 Jul 2019 09:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564565198;
        bh=R8lpKhyWkYxsq+7x13Rs1JiBJHCEhfHv9KM2WT19r0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hh12xkAy2L9Wa1+OPksHH8smFw14LPsCUaKSzYM7fEW4uKljhJw+YDPGfG2wJGNXh
         fEFGYlczVwU8Wch01t0QrU0Gas93huPOiVrjxwfraZqNsDJNAB1V/Qu/5E39dXH8lT
         2jh8/y7Ij7c/VkpX3S++HMCVccpU7vEdwVYeKxLo=
Date:   Wed, 31 Jul 2019 11:26:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: Request vsock and hv_sock patches to be backported for
 linux-5.2.y, linux-4.19.y and linux-4.14.y
Message-ID: <20190731092636.GB18269@kroah.com>
References: <PU1P153MB0169AD4EB10548EACCED82C2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PU1P153MB0169AD4EB10548EACCED82C2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 06:41:10AM +0000, Dexuan Cui wrote:
> For linux-4.14.y (currently it's v4.14.134), 4 patches are missing.
> The mainline commit IDs are:
>         3b4477d2dcf2 ("VSOCK: use TCP state constants for sk_state")

That commit is too much to backport, sorry.  Other people have
referenced it in 4.14, so if you "need" it, you can do what they did in
the past with the backport.

thanks,

greg k-h
