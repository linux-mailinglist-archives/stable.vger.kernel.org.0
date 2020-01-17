Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62179140F8B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 18:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgAQRAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 12:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbgAQRAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 12:00:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 670B3206D5;
        Fri, 17 Jan 2020 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579280448;
        bh=r6ROqZMEQSvOfciMui0NSMaVXog6iji0U7ahbZsYmzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RlS9ZMgKgOj6n3QOSL0tZwJPAc95kyIaiR2dt3b5ZF0Wvtu9vGc9hXb50Il2sjhxx
         TQ+kYngBXiE9fzgLuj0m0AYTOoDtBpjMY3V0qlg3JWGDKpHihkp56ZmZ3lIHoY8Ycw
         f39Hmg9EYaRXi/D2X5NS+SniX5b3xd3h7MPn8exE=
Date:   Fri, 17 Jan 2020 18:00:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/203] 5.4.13-stable review
Message-ID: <20200117170046.GB1952110@kroah.com>
References: <20200116231745.218684830@linuxfoundation.org>
 <20200117160147.GC25706@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117160147.GC25706@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 08:01:47AM -0800, Guenter Roeck wrote:
> On Fri, Jan 17, 2020 at 12:15:17AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.13 release.
> > There are 203 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 389 pass: 389 fail: 0

Great, thanks for testing all of these and letting me know.

greg k-h
