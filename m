Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E7A340BD
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfFDHxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbfFDHxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 03:53:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0F362423F;
        Tue,  4 Jun 2019 07:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559634814;
        bh=9emo8j3eiI3b+0WLGKEuRArCF2RDMpfdSz8HANQVqzQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M32pjFRfQYyLWTkEWr5wo6ABBmp2QAu72EhRgD4wPj74/08CIxpNhkbmguvsfiRWG
         VARX9jnH03vP7ps6uQc7dUoEKm4mIGAarfYbtrHiXYEe6dSa3/v3XRsUlNyGRMrdRA
         Rj+Y/v7E6/WusaOQSjmLF6sv0lIUGXkOLuC/EOBY=
Date:   Tue, 4 Jun 2019 09:53:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        blackgod016574@gmail.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net
Subject: Re: 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in
 ip_ra_control()")
Message-ID: <20190604075332.GE6840@kroah.com>
References: <20190603230239.GA168284@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603230239.GA168284@google.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 04:02:40PM -0700, Zubin Mithra wrote:
> Hello,
> 
> CVE-2019-12381 was fixed in the upstream linux kernel with the commit :-
> * 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in ip_ra_control()")
> 
> Could the patch be applied in order to v4.19.y, v4.14.y, v4.9.y and v4.4.y ?

Same comments here as on the ipv6 bug.

Should I just go create CVEs for every single stable kernel patches?

Actually, it's been often suggested that I should, just to drive the
point home...

thanks,

greg k-h
