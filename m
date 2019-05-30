Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8698730332
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 22:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfE3US1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 16:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfE3US1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 16:18:27 -0400
Received: from localhost (unknown [207.225.69.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02D012614A;
        Thu, 30 May 2019 20:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559247507;
        bh=OqucyjSXEXzV37hBQSG/3DeyiLPZcq+zz41WjAJS4aU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ty2C//SsysgflSu23iJR/gR/QzlEDBbCJg04V3/PRETNDZTjXHe/GJ4QIyho/xoFI
         nZIwiQ10KNX1DqF0eIDGFqaz+4KywjY57dAc+tmkgCuw7yQnUjmzuED5XC9UbWi5ud
         GlY6NFooTdl6FnTariS3WRqitHUsq4vZJJ+NM8No=
Date:   Thu, 30 May 2019 13:18:26 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/405] 5.1.6-stable review
Message-ID: <20190530201826.GA816@kroah.com>
References: <20190530030540.291644921@linuxfoundation.org>
 <936fbe39-87c2-5922-5cac-245718b9fcef@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <936fbe39-87c2-5922-5cac-245718b9fcef@kernel.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 01:30:22PM -0600, shuah wrote:
> On 5/29/19 8:59 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.6 release.
> > There are 405 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 01 Jun 2019 03:01:59 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these (and 5.0 twice!) and letting me know.

greg k-h
