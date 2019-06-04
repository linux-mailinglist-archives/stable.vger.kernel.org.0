Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1D1341B3
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfFDIW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbfFDIW2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 04:22:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE3C523CCA;
        Tue,  4 Jun 2019 08:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559636548;
        bh=bWEJMOj0o2IDDGnopxojGRTCuxKBVcBfseHXoPLxNrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DgE8rGRpa2gcU/gaTojoM8Yz5p3LsybZTaXyJKkqYZG41iT6fz+dVZivSw7gsJbTd
         VqETMJ4IbXD07NK/pg+W4uvEgr86MRSFFlwjiLQ6Nl7DFpoX8qH5THrmKF7yKaLjnN
         EO8oLFrBobHMzwBufnrXL4O0fouNq9phnudteMps=
Date:   Tue, 4 Jun 2019 10:21:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.0.21
Message-ID: <20190604082159.GA25963@kroah.com>
References: <20190604073843.GA4985@kroah.com>
 <20190604081553.GB10154@Gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604081553.GB10154@Gentoo>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 01:45:53PM +0530, Bhaskar Chowdhury wrote:
> Heads up! this has reached an EOL ...so please move to 5.1 series.

That's exactly what I said.  Why repeat it in a top-post?

confused,

greg k-h
