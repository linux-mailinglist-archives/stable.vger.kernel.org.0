Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8595A13B260
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 19:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgANSxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 13:53:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgANSxs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 13:53:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 577D02084D;
        Tue, 14 Jan 2020 18:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579028027;
        bh=8x3wjLAViI8vNS8ODIBLSznPokBqhlkRXzzyLftmXts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jA1wlZPAj9+Q1LuQ3z38wx7Ebb88+G3sTdfoTzuk7pFfcwXOjboWQTE1eaa1PDSi5
         jkL04YqMJ6ge49HYiFIBSNZt6USkQgLrBhNyrhu7ImMquE6cf/XoscQJIf+yZSZgyY
         IvXjZPKEWeh3rs7MfFQz0I06JZZDL1yBPuON3yq4=
Date:   Tue, 14 Jan 2020 19:53:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/78] 5.4.12-stable review
Message-ID: <20200114185344.GA2079595@kroah.com>
References: <20200114094352.428808181@linuxfoundation.org>
 <20200114181745.GD18872@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114181745.GD18872@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 10:17:45AM -0800, Guenter Roeck wrote:
> On Tue, Jan 14, 2020 at 11:00:34AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.12 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 389 pass: 389 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
