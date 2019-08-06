Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08EA28361A
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 18:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732676AbfHFQCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 12:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbfHFQCB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 12:02:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 724DA20818;
        Tue,  6 Aug 2019 16:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565107319;
        bh=HOrSVJmekUuoCcV/AI4yIkSlnbHhBNxOYMrMq6QoUfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p1wdzBKALR62tUMD+QaTFEmzmEaW/8ZtLkwmt1k0SZpOfKlq8F7+00YtT0PDB671O
         6MCbL6mxtDPl/Pm1xnT3zD9QAOfdVoyNYCokwpqFYdpH7cNXhUex7HHgh++7A4cFhk
         kRXe/2bFa4GIKUztyTDJD0mY2eJ5H4q9xqTXxgWQ=
Date:   Tue, 6 Aug 2019 18:01:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/131] 5.2.7-stable review
Message-ID: <20190806160157.GA1988@kroah.com>
References: <20190805124951.453337465@linuxfoundation.org>
 <20190806155020.GE12156@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806155020.GE12156@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 08:50:20AM -0700, Guenter Roeck wrote:
> On Mon, Aug 05, 2019 at 03:01:27PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.7 release.
> > There are 131 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 364 pass: 364 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
