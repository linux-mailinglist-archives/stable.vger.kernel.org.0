Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A073914CB02
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 13:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgA2M5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 07:57:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgA2M5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 07:57:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9933620716;
        Wed, 29 Jan 2020 12:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580302672;
        bh=5t9UhEXD3qw3kJC/YZY2e/10WCd7xRYsojeM9CyBOD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tv1kiJCXtNSwcu5EH3FWVId6hs482wRFXnypbYVo4zlWbJB9KHuutLnADHgJ/I0V+
         HOMWCz2wIVivdj22CnwoiSJro4CkQoWtPyU4q514yKIBFPo4gXlXDlKXaf1IJsfzjL
         V9EIChToSqBVZ1wru8xB8UEZ/rAq/WGEz5LV3XAM=
Date:   Wed, 29 Jan 2020 13:57:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/92] 4.19.100-stable review
Message-ID: <20200129125749.GA15245@kroah.com>
References: <20200128135809.344954797@linuxfoundation.org>
 <20200129113106.GA28178@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129113106.GA28178@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 29, 2020 at 12:31:06PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.100 release.
> > There are 92 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> > Anything received after that time might be too late.
> 
> It builds and basic tests work in our configurations.
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/112957173

That's nice to see, thanks for testing and letting me know.

greg k-h
