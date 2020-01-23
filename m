Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B845214621D
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 07:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgAWGob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 01:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgAWGob (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 01:44:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D119A217F4;
        Thu, 23 Jan 2020 06:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579761871;
        bh=1GmUqOVj6mRzezmjr3zkqX9FlUTLHdkWD3uj6/AfuBA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VcOjgfj4AUGNLSGMKQtFpitQrnblyimWKHEepGlVPgtdBpDAQRH9Bmmi7BFBKiyxE
         NiJBPY6SoEHiNuMfKOK5our7jJ4oKKryVw2f+QXMEOCEHCZedS/8gdgCWgsmlIhNdR
         F3JRGjN5MdDmqTdkhbVQPt4SU9vZSpMll6YXnl5Q=
Date:   Thu, 23 Jan 2020 07:44:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/222] 5.4.14-stable review
Message-ID: <20200123064429.GC124954@kroah.com>
References: <20200122092833.339495161@linuxfoundation.org>
 <20200122190052.GE20093@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122190052.GE20093@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 11:00:52AM -0800, Guenter Roeck wrote:
> On Wed, Jan 22, 2020 at 10:26:26AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.14 release.
> > There are 222 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 389 pass: 389 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
