Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B62B407554
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 08:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbhIKG2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 02:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhIKG2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 02:28:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F1E161041;
        Sat, 11 Sep 2021 06:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631341615;
        bh=NeUYiVhOQwpZm3ExnBCh7KWs6RR3b4ruKESX10oOK0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tkG8GIbo1nkVYp2Vk9AaMVoHxyzGvY/2TvaXMeh6XE3uVR6JN46tMcZCYA4evTayk
         DUEOg4D7w0VrqpcnHF9+bDXnL5xqsoilJWseDSC2vLV4A4YuHLbukYvJRz5FbKgrSm
         SBqBkovZT8iv5plH3j7BgArGsYBCYes8gxeOgyOY=
Date:   Sat, 11 Sep 2021 08:26:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Justin M. Forbes" <jforbes@fedoraproject.org>
Cc:     stable@vger.kernel.org, Jaehoon Chung <jh80.chung@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book
 Flex2 Alpha
Message-ID: <YTxMGjwtCvH/ANfk@kroah.com>
References: <20210910153735.2791941-1-jforbes@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910153735.2791941-1-jforbes@fedoraproject.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 10:37:35AM -0500, Justin M. Forbes wrote:
> The Samsung Galaxy Book Flex2 Alpha uses an ax201 with the ID a0f0/6074.
> This works fine with the existing driver once it knows to claim it.
> Simple patch to add the device.
> 
> Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
> Reviewed-by: Jaehoon Chung <jh80.chung@samsung.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Link: https://lore.kernel.org/r/20210702223155.1981510-1-jforbes@fedoraproject.org
> ---
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
>  1 file changed, 1 insertion(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
