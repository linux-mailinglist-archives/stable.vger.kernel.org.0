Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E521B841C
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 09:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDYHEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 03:04:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgDYHEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Apr 2020 03:04:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C30E520767;
        Sat, 25 Apr 2020 07:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587798252;
        bh=F2+6MvmGS8dTiCwdyXanmLMCmyfcjoCvYSppu0gTqLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s6yckjif2iVIYCwieYc6XK/kXtDa4ms7wVsnXpovmikGg041ItC2RRRfCt+lhzq7t
         eYy3b1CcB+dcu0SZCsrxXGkOBAt9uGqZ272pWzkhnaNOA8jmI+k5R9HpQq3BxhMcfz
         UBr8gvNAcAIcFCdZ/g9aUA4qVPnX2bwF6nKSPFgY=
Date:   Sat, 25 Apr 2020 09:04:08 +0200
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
Message-ID: <20200425070408.GB2042217@kroah.com>
References: <1587758766-3274-1-git-send-email-skomatineni@nvidia.com>
 <20200425014556.GD13035@sasha-vm>
 <81be9ca0-5c61-6e94-8398-85354764b429@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81be9ca0-5c61-6e94-8398-85354764b429@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 07:42:16PM -0700, Sowjanya Komatineni wrote:
> 
> On 4/24/20 6:45 PM, Sasha Levin wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On Fri, Apr 24, 2020 at 01:06:04PM -0700, Sowjanya Komatineni wrote:
> > > This series is to backport the upstream patches that fixes busy
> > > detection
> > > for long operation mmc commands by implementing Tegra specific timeout
> > > callback to switch between finite and infinite HW busy detection wait
> > > modes.
> > > 
> > > 
> > > Sowjanya Komatineni (2):
> > >  sdhci: tegra: Implement Tegra specific set_timeout callback
> > >  sdhci: tegra: Enable MMC_CAP_WAIT_WHILE_BUSY host capability
> > 
> > What regression do these patches fix?
> > 
> This isn't a regression as we don't have any known failures as of today with
> the specific mmc devices we are using on our platforms.

Have you read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
?

> But this patch fixes a long outstanding bug for sdhci-tegra to handle long
> busy wait for mmc command operations that may take longer than host max busy
> timeout. So, this is something that's missing from the beginning and good to
> have.

So it's a new feature?

