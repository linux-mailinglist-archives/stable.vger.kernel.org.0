Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D80219C49
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 11:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgGIJ3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 05:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbgGIJ3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 05:29:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52FCD206A1;
        Thu,  9 Jul 2020 09:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594286983;
        bh=gpkObb//2/k0Iy0WmqlzWU+vJjSNziglB/IVJFbeIMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JbrH5P0UfjfmLA22jpnIW4y1hcmj9RH8Pi3sXPv+zRe86ZDiJkbHqpwHa8QuILNRv
         GvQf5aE2zNDgJrdKkww5GMKqi2ipPIihF48pxLapCC2tmTWKTTDTmj2WssFco5/SU+
         H4gC9H2wKu4j8ZddiXt5CbnvZYQdoFrbDKzYKKVk=
Date:   Thu, 9 Jul 2020 11:29:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/112] 5.7.8-rc1 review
Message-ID: <20200709092950.GA46127@kroah.com>
References: <20200707145800.925304888@linuxfoundation.org>
 <20200708175339.GF224053@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708175339.GF224053@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 08, 2020 at 10:53:39AM -0700, Guenter Roeck wrote:
> On Tue, Jul 07, 2020 at 05:16:05PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.8 release.
> > There are 112 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 431 pass: 431 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
