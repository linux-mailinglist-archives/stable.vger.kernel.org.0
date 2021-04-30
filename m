Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7070F36F577
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 07:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhD3Fqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 01:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3Fqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 01:46:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DBFC613E1;
        Fri, 30 Apr 2021 05:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619761558;
        bh=HCY6rgMAQL0Jmq5O361EYartF2zDgEk2xO1zcef/Rgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hik4YkqyCQqVNhXImbR8GYGuYGRQL5sIDTSPPLf4aReAmNNHQ4Oj0S1XbNgCpQbVt
         D2KMPjS75fPkCuELOgn/vjle0xtGjtmfG0CMrGQfFIQiTfuwcOjoqon96eTANQZRTr
         V/9lQkPqVp1Jal8KmX0R4inz/XCKhckrs0np6LA0=
Date:   Fri, 30 Apr 2021 07:45:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5.12 -stable] iwlwifi: Fix softirq/hardirq disabling in
 iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <YIuZlLFR/bISKQe8@kroah.com>
References: <nycvar.YFH.7.76.2104292345080.18270@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.2104292345080.18270@cbobk.fhfr.pm>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 29, 2021 at 11:46:56PM +0200, Jiri Kosina wrote:
> 
> [ commit e7020bb068d8be50a92f48e36b236a1a1ef9282e upstream ]
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> Analogically to what we did in 2800aadc18a6 ("iwlwifi: Fix softirq/hardirq 
> disabling in iwl_pcie_enqueue_hcmd()"), we must apply the same fix to 
> iwl_pcie_gen2_enqueue_hcmd(), as it's being called from exactly the same 
> contexts.
> 
> Reported-by: Heiner Kallweit <hkallweit1@gmail.com
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Link: https://lore.kernel.org/r/nycvar.YFH.7.76.2104171112390.18270@cbobk.fhfr.pm
> ---
> 
> This fix unfortunately didn't make it upstream in time.

Thanks, also added to 5.10.y and 5.11.y as I think it is needed there
too, right?

greg k-h
