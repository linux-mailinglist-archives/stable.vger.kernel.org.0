Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78781253F30
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgH0HcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbgH0HcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 03:32:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46C1F207DF;
        Thu, 27 Aug 2020 07:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598513542;
        bh=UEAKiHeMBmBIB3F03OtpcveGL1krP0qA/9RjttHNw6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HZdIW5HBEu8CPrh7f9rusR/U2yj9FDcHHV2IdwpBHpobE8n8xm5MYM/HorkudIofG
         cRJj51iPAjxaWCYM3OiGr9LLSeIla9qKW61ULz9oB5XogIemIRCsbXbbccxmqjczSx
         CZ5IFGNczAcweqgNwokX6d6EpktgaQrpR8+94Uyg=
Date:   Thu, 27 Aug 2020 09:32:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/16] 5.8.5-rc1 review
Message-ID: <20200827073236.GB206189@kroah.com>
References: <20200826114911.216745274@linuxfoundation.org>
 <6f358f58-8fce-fdb4-5962-a2cbf8a5145a@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f358f58-8fce-fdb4-5962-a2cbf8a5145a@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 01:58:25PM -0700, Guenter Roeck wrote:
> On 8/26/20 5:02 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.5 release.
> > There are 16 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 28 Aug 2020 11:49:02 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Great, thanks for the quick testing and letting me know.

greg k-h
