Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DB932D435
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238373AbhCDNbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:31:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233758AbhCDNbB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:31:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6301664F21;
        Thu,  4 Mar 2021 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614864621;
        bh=NDaaAIRJXd0C1Coaxum3osKHZcwAy9PpZspPKduJGcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kYmRUsD0RcvUZkjvDnOtV1nC1dq5xmJ5Q3xtApVYoT0Uvhe9Y12bmvYLQufjdU8mZ
         wZ7hKsqVL6wWdbfSAl1jw12LOpJ2H/XDBZHw2yJXZ0af2r2LWHa9dfJTe/lBJZfDfr
         hbtE8iO+j6tKYXuKKrC5BBxFZUmWJKrDAa72sTs0=
Date:   Thu, 4 Mar 2021 14:30:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.11] iwlwifi: add new cards for So and Qu family
Message-ID: <YEDg6oiPxM5/295d@kroah.com>
References: <20210302145600.47207-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302145600.47207-1-luca@coelho.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 04:56:00PM +0200, Luca Coelho wrote:
> From: Ihab Zhaika <ihab.zhaika@intel.com>
> 
> commit 410f758529bc227b186ba0846bcc75ac0700ffb2 upstream.
> 
> add few PCI ID'S for So with Hr and Qu with Hr in AX family.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Link: https://lore.kernel.org/r/iwlwifi.20210206130110.6f0c1849f7dc.I647b4d22f9468c2f34b777a4bfa445912c6f04f0@changeid
> ---
>  .../net/wireless/intel/iwlwifi/cfg/22000.c    | 18 +++++++++++++
>  .../net/wireless/intel/iwlwifi/iwl-config.h   |  3 +++
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 26 +++++++++++++++++++
>  3 files changed, 47 insertions(+)

Now applied, thanks.

greg k-h
