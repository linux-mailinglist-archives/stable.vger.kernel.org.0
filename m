Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC0CB9C61
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 07:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfIUFFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 01:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbfIUFFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 01:05:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CCA9206B6;
        Sat, 21 Sep 2019 05:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569042341;
        bh=P5VV7A9qj0nPr6EwUornSjOxlVlzhZmMs8XKj85XxJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oqEHpv1IL2VzV1yy1dBw+oJ1L4CO0QzZbWQ/O2DysxiykEkEAjBfueeZgzcAbnxXj
         csvSc7F1Dxf+jDcqaJlCS+Nzw8G7leoffXpPHugkA0i0DSS6wZmafGUje4+2p0L9V4
         LkwGKugqJIFcuvT8v2qXaTp8Y/5/qlRHBYRcgXq4=
Date:   Sat, 21 Sep 2019 07:05:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/124] 5.2.17-stable review
Message-ID: <20190921050538.GC991717@kroah.com>
References: <20190919214819.198419517@linuxfoundation.org>
 <20190920183738.GC22818@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920183738.GC22818@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 11:37:38AM -0700, Guenter Roeck wrote:
> On Fri, Sep 20, 2019 at 12:01:28AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.17 release.
> > There are 124 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Ok, here we are:
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 390 pass: 390 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
