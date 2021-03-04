Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5221F32D432
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbhCDNa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:30:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237735AbhCDNaM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:30:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E7E964F21;
        Thu,  4 Mar 2021 13:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614864572;
        bh=P4YAVMP/bhPsLafEg8kyQD4NRQUKl82+bVRnFf+X36Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CosuPNh1D++y+aG9VpuNiB9APYL0JbMxwYXUO5s7bsayyH2jXtEZZ7JtS+OHCXwud
         8z8q35PXXaolgttWpQj9HGMYW5fsmingnzbnRbqWA4v2Vrai1IDwixclWnxYjcO9HS
         3q/qk3yDvuKRLzuQvwuAg9kApYeg1rIWysS0vmXE=
Date:   Thu, 4 Mar 2021 14:29:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH for 4.4.y] iwlwifi: pcie: fix to correct null check
Message-ID: <YEDgupxDS8BI3YhI@kroah.com>
References: <20210303075731.920687-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303075731.920687-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 04:57:31PM +0900, Nobuhiro Iwamatsu wrote:
> The fixes made in commit: 4ae5798004d8 ("iwlwifi: pcie: add a NULL check in
> iwl_pcie_txq_unmap") is not enough in 4.4.y tree.. This still have problems
> with null references. This provides the correct fix.
> Also, this is a problem only in 4.4.y. This patch has been applied to other
> LTS trees, but with the correct fixes.
> 
> Fixes: 4ae5798004d8 ("iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap")
> Cc: stable@vger.kernel.org
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/net/wireless/iwlwifi/pcie/tx.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Thanks for the fix, now queued up.

greg k-h
