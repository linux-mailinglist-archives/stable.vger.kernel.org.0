Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1141D1D0C66
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgEMJhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbgEMJhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:37:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E4CC206B8;
        Wed, 13 May 2020 09:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589362673;
        bh=eWF7IegAvbnc7BD/BjzKhKKxtW8zOOtnyprMNpapXPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UNFbSMtOGX93R6ewcI5F/ToALRkUBVkWO19G2ZMoApWAl6UbA+J6WRtuQRlngE+AS
         ZzXc6nQuw+eQChZPs1naCofDbEd23H1zCog/dWk6fjCYZVIIwBdsdVbGgJVtST3tEu
         3jiJpUe4gEkkPL/ODZhL9eagbJ7DlrrbAoT125SQ=
Date:   Wed, 13 May 2020 11:37:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sowjanya Komatineni <skomatineni@nvidia.com>
Cc:     Sasha Levin <sashal@kernel.org>, adrian.hunter@intel.com,
        ulf.hansson@linaro.org, baolin.wang@linaro.org,
        kstewart@linuxfoundation.org, tglx@linutronix.de,
        bradleybolen@gmail.com, thierry.reding@gmail.com,
        jonathanh@nvidia.com, anrao@nvidia.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4.33 0/2] Fix for long operation cmds busy detection
Message-ID: <20200513093751.GA831267@kroah.com>
References: <1587758766-3274-1-git-send-email-skomatineni@nvidia.com>
 <20200425014556.GD13035@sasha-vm>
 <81be9ca0-5c61-6e94-8398-85354764b429@nvidia.com>
 <20200425070408.GB2042217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200425070408.GB2042217@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 25, 2020 at 09:04:08AM +0200, Greg KH wrote:
> On Fri, Apr 24, 2020 at 07:42:16PM -0700, Sowjanya Komatineni wrote:
> > 
> > On 4/24/20 6:45 PM, Sasha Levin wrote:
> > > External email: Use caution opening links or attachments
> > > 
> > > 
> > > On Fri, Apr 24, 2020 at 01:06:04PM -0700, Sowjanya Komatineni wrote:
> > > > This series is to backport the upstream patches that fixes busy
> > > > detection
> > > > for long operation mmc commands by implementing Tegra specific timeout
> > > > callback to switch between finite and infinite HW busy detection wait
> > > > modes.
> > > > 
> > > > 
> > > > Sowjanya Komatineni (2):
> > > >  sdhci: tegra: Implement Tegra specific set_timeout callback
> > > >  sdhci: tegra: Enable MMC_CAP_WAIT_WHILE_BUSY host capability
> > > 
> > > What regression do these patches fix?
> > > 
> > This isn't a regression as we don't have any known failures as of today with
> > the specific mmc devices we are using on our platforms.
> 
> Have you read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> ?
> 
> > But this patch fixes a long outstanding bug for sdhci-tegra to handle long
> > busy wait for mmc command operations that may take longer than host max busy
> > timeout. So, this is something that's missing from the beginning and good to
> > have.
> 
> So it's a new feature?
> 

Dropped from my queues due to lack of response.

greg k-h
