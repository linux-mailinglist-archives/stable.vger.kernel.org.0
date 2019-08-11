Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD70189035
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 09:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfHKHhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 03:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfHKHhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Aug 2019 03:37:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 120EB2173C;
        Sun, 11 Aug 2019 07:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565509064;
        bh=1aJWrC9FVYSWGkg762KUaxBFfF9qWrcly3JUdP0J+Zs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YxqSeW3L1goM/+SJ6qse8hK9W4CrbjQw3o2AeyCp/77yJOVF1dNt/PDnefPivctq9
         Z9UMlf3t1zE4q2KzIgb0r2SKwlkGYx/i06gPScV1qr/P8n0RSW26uP3djdJFL0LreN
         0E9er2te7+5PNlsS2g0E+VSjclpZCOO6yvNLfW1M=
Date:   Sun, 11 Aug 2019 09:37:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/32] 4.9.189-stable review
Message-ID: <20190811073741.GB3034@kroah.com>
References: <20190809133922.945349906@linuxfoundation.org>
 <20190810154528.GB11992@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190810154528.GB11992@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 10, 2019 at 08:45:28AM -0700, Guenter Roeck wrote:
> On Fri, Aug 09, 2019 at 03:45:03PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.189 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 11 Aug 2019 01:38:45 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 172 pass: 172 fail: 0
> Qemu test results:
> 	total: 356 pass: 356 fail: 0

Thanks for testing both of these and letting me know.

greg k-h
