Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF17A2E77E0
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 11:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgL3K4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 05:56:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgL3K4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 05:56:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67DA9221F8;
        Wed, 30 Dec 2020 10:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609325753;
        bh=Uzn0V6Ntq8wBMJ38D9siuQPSOSLHAmK6QaFPwF/UDlM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UfTfE35cLhRtiuwhjbR45VFGpcPXtKzIOpBiNdIMD7q+8EnwoljWXYH/SJIedLE4q
         wrz5twRqhDtPJGqYm+D7DaoM+e0HA45lf6rGnKJtz7dY4El92NK7JX0lGrl0cAGKNj
         KpWo9nrO9QNVU687valZ/hwUCRb0J6PVrw0YuZNg=
Date:   Wed, 30 Dec 2020 11:57:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/716] 5.10.4-rc2 review
Message-ID: <X+xdEGLe3liDNFu3@kroah.com>
References: <20201229103832.108495696@linuxfoundation.org>
 <20201229152525.GB49720@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201229152525.GB49720@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 07:25:25AM -0800, Guenter Roeck wrote:
> On Tue, Dec 29, 2020 at 11:52:58AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.4 release.
> > There are 716 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 31 Dec 2020 10:36:33 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for the testing and letting me know.

greg k-h
