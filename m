Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49103E9C4A
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 14:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfJ3Nay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 09:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbfJ3Nay (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 09:30:54 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4648C2080F;
        Wed, 30 Oct 2019 13:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572442253;
        bh=sXC6aQC73bN/ggouEGbBJC/jj6LPBeLEgM5aqpPsX8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z4BpNPx3v5lCFX79mKh17lbTKjRPwb3xSMFIIeQ8mMoCZjFEMR0reD9eLrz8AiJDQ
         pYYlihvMqlig0/E9cAO6oI7suQCejCwtqgh4y3qhy3Tmmxfk6XHCM84dqRqDcE3c3G
         La0id6n+tgKAX0Cdd6SKvLW/wARBA6FpaLZHl+tQ=
Date:   Wed, 30 Oct 2019 14:30:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     horms@verge.net.au, linux-pci@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "PCI: rcar: Fix missing MACCTLR register
 setting in rcar_pcie_hw_init()"
Message-ID: <20191030133051.GB703854@kroah.com>
References: <1572434824-1850-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572434824-1850-2-git-send-email-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572434824-1850-2-git-send-email-yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 30, 2019 at 08:27:03PM +0900, Yoshihiro Shimoda wrote:
> This reverts commit 175cc093888ee74a17c4dd5f99ba9a6bc86de5be.
> 
> The commit description/code don't follow the manual accurately,
> it's difficult to understand. So, this patch reverts the commit.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/pci/controller/pcie-rcar.c | 4 ----
>  1 file changed, 4 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
