Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD1D1B235C
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 11:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgDUJzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 05:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbgDUJzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 05:55:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87BE720CC7;
        Tue, 21 Apr 2020 09:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587462937;
        bh=qN3VdcMXSW/pnQYsAozCukyle359PmG/WR7OI9Mzmdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1a/uKoE3wgXF7N9TYFrIYssxjDF6zwKR9VpouBoCpWpmaYW5jDZMPsp7RH/UuZF4I
         USoQdTEPKr5E1FTmhoXkEKvYOVY31NKvYiXEgmOZDbVRtzR2K+mnMQl0/6oNUFqlFS
         2mcwag2fzWxFwU2C7DCxWsOaecQXkrZxqk8W0msI=
Date:   Tue, 21 Apr 2020 11:55:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 00/71] 5.6.6-rc1 review
Message-ID: <20200421095534.GB727481@kroah.com>
References: <20200420121508.491252919@linuxfoundation.org>
 <f0a24f34-e3c8-2945-2e89-27ac243212d1@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0a24f34-e3c8-2945-2e89-27ac243212d1@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 12:53:29PM -0700, Guenter Roeck wrote:
> On 4/20/20 5:38 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.6 release.
> > There are 71 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 22 Apr 2020 12:10:36 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 428 pass: 428 fail: 0

Great, thanks for testing all of these and letting me know.

greg k-h
