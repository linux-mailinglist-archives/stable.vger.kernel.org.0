Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B583E5928
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 10:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfJZIAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 04:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfJZIAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 04:00:36 -0400
Received: from localhost (unknown [89.205.133.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFAB22084C;
        Sat, 26 Oct 2019 08:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572076835;
        bh=YXMQf5PUTMkCC2s+CE+39AbzWTqptkOht2Sq57tjNEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jwXBsxUR/7gmBK7NOUOjgaueLmoNE2diYy8YjeJgqoNIWycx6QKzpjKEuEqojwrqC
         Nr1pI/y9R1CAP2/Zl9Sa7kINANKmqdzvWoXP3sKFNRl6H1C3RAgnzvKO+Y6lNIKHi3
         jN7ECHpWhVJ5gS2cvFgmQWhbw23OHszHhFfgHg00=
Date:   Sat, 26 Oct 2019 10:00:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
Cc:     alexander.deucher@amd.com, stable@vger.kernel.org,
        amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH v3] drm/radeon: Fix EEH during kexec
Message-ID: <20191026080032.GA554748@kroah.com>
References: <1572036050-18945-1-git-send-email-kmahlkuc@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572036050-18945-1-git-send-email-kmahlkuc@linux.vnet.ibm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 25, 2019 at 03:40:50PM -0500, KyleMahlkuch wrote:
> From: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>
> 
> During kexec some adapters hit an EEH since they are not properly
> shut down in the radeon_pci_shutdown() function. Adding
> radeon_suspend_kms() fixes this issue.
> Enabled only on PPC because this patch causes issues on some other
> boards.
> 
> Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>
> ---
>  drivers/gpu/drm/radeon/radeon_drv.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
