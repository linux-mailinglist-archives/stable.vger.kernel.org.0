Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02638267856
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 08:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgILGtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 02:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgILGtE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Sep 2020 02:49:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FD5B214D8;
        Sat, 12 Sep 2020 06:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599893344;
        bh=H5QLO5t2OyR6Esoq8FXYgazAadJEqcGK/5dN4M9Wuhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cq8cbeVF4/v2jlYDOnyNTzv99+d3JrRL8Pjqny/g2dEgcLSDIiMedkL1hY/ZRcFHH
         pKqP1TdIy8YFvL/R+HoP3McqKR8inZt8rYlM6jgpUmc/x7mVddG0LR+6RraZylrD3o
         plFCvLzB5gTPJNrRkwQRLUhqHe8J8i+oC1K3guTk=
Date:   Sat, 12 Sep 2020 08:49:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Hung <alex.hung@canonical.com>
Cc:     rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        All applicable <stable@vger.kernel.org>
Subject: Re: [PATCH] ACPI: video: use ACPI backlight for HP 635 Notebook
Message-ID: <20200912064900.GB558156@kroah.com>
References: <20200911221420.21692-1-alex.hung@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911221420.21692-1-alex.hung@canonical.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 11, 2020 at 04:14:20PM -0600, Alex Hung wrote:
> Default backlight interface is AMD's radeon_bl0 which does not work on
> this system. As a result, let's for ACPI backlight interface for this
> system.
> 
> BugLink: https://bugs.launchpad.net/bugs/1894667
> 
> Cc: All applicable <stable@vger.kernel.org>
> Signed-off-by: Alex Hung <alex.hung@canonical.com>
> ---
>  drivers/acpi/video_detect.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
> index 2499d7e..05047a3 100644
> --- a/drivers/acpi/video_detect.c
> +++ b/drivers/acpi/video_detect.c
> @@ -282,6 +282,15 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
>  		DMI_MATCH(DMI_PRODUCT_NAME, "530U4E/540U4E"),
>  		},
>  	},
> +	/* https://bugs.launchpad.net/bugs/1894667 */
> +	{
> +	 .callback = video_detect_force_video,
> +	 .ident = "HP 635 Notebook",
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "HP 635 Notebook PC"),
> +		},
> +	},
>  
>  	/* Non win8 machines which need native backlight nevertheless */
>  	{
> -- 
> 2.7.4
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
