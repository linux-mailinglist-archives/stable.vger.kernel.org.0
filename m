Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C629C7AA84
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 16:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbfG3OGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 10:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727787AbfG3OGH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 10:06:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E2B8206E0;
        Tue, 30 Jul 2019 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564495566;
        bh=J/b9I4zIh2nQcgEEakEPwUMi7XWdBncrC8zNpR2DFB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=orTGWnHldZG2G5eYOwsbArf7bMpZaVrT+3MseSKR9qCYCsD73t+lhDg0JKzp+sewc
         RMfdDpn/bxEmawQ1qpuUlvZ735pADXcnKjN3DzIQVGjrJ8AruonwKZX8rdIlFFGuo6
         Gpwl+IEjQ8JNK6w7ROXZUHvoE+xFrqlffWBAWToY=
Date:   Tue, 30 Jul 2019 16:06:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/215] 5.2.5-stable review
Message-ID: <20190730140604.GA31513@kroah.com>
References: <20190729190739.971253303@linuxfoundation.org>
 <23f2bcb1-aa1a-e4f2-0d18-e0c16de511de@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23f2bcb1-aa1a-e4f2-0d18-e0c16de511de@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 30, 2019 at 08:01:42AM -0600, shuah wrote:
> On 7/29/19 1:19 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.5 release.
> > There are 215 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 31 Jul 2019 07:05:01 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.5-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
