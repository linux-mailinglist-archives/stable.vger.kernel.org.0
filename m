Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C056E3D24AD
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 15:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhGVMxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 08:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232032AbhGVMxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 08:53:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EF9560FF2;
        Thu, 22 Jul 2021 13:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626960866;
        bh=OHYiqLfkhpZ4QtRVpp9tmrY7O0GTi4T4TKcF8JqYiK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u9SwGqfeT6TnabwbH6vG2avpWSIVK/7HGx2AQjkidGiPB3chdXSRFnpk/pc7oH6Qv
         FEHfTd59IA8xTJDrnibhEdslzjilVJRNypJ16iEOaTWmb+pt0VP8ps+02tEuUoc9jg
         lYYsr4+ZSTUaW2u+W1ynhtZ/1mfHQYoK8TFE6FJM=
Date:   Thu, 22 Jul 2021 15:34:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org
Subject: Re: v4.4.276: Build failure for powerpc:mpc85xx_defconfig
Message-ID: <YPlz3ySsMDea24yW@kroah.com>
References: <20210721144845.GA3445926@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721144845.GA3445926@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 21, 2021 at 07:48:45AM -0700, Guenter Roeck wrote:
> Hi,
> 
> As of v4.4.276, linux-4.4.y fails to build powerpc:mpc85xx_defconfig and
> other powerpc images enabling the fsl_ifc driver.
> 
> drivers/memory/fsl_ifc.c: In function 'fsl_ifc_ctrl_probe':
> drivers/memory/fsl_ifc.c:308:28: error:
> 	'struct fsl_ifc_ctrl' has no member named 'gregs'; did you mean 'regs'?
> 
> Guenter

As much as I like the current field name, something got renamed after
4.4 so it's not "gregs" way back in 4.4.  I'll just go drop the
offending patch (well revert it at this point in time.)

Thanks for the report.

greg k-h
