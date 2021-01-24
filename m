Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7EE1301D8D
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 17:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbhAXQq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 11:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbhAXQq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 11:46:56 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08414C061573;
        Sun, 24 Jan 2021 08:46:16 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id j25so6730740oii.0;
        Sun, 24 Jan 2021 08:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UiTpXgmVqFrHSdksd6Jn05Y0HoKR56zNJyN5+XF3nCs=;
        b=Fw+JGRqwt19HNU2/fqZw9PWWTu0xTJ1b3IqyG75mQiaGieUCDIDG1ocXgC07bwp3Kw
         OX7TAeN7G4Zzeq/objdWirVByqKeJyYR/ts/Rnk1U96fz33uH3ghyMLcgM3wL1N3Gcdx
         yiOEZXKh1Tf0r3y1keYMReB+GrqfTi6liOS5Of3SJ92pgqNRAyL1Ax3NR3XFpDut42Ou
         ZK6mr6DOF0TPs0qCCK4APs0kkUUZHKZzwEAnsbTWy9iyjoNHJsFKFrdnOaEv9V/T9j72
         oV8i5bBdImxzIjuX+v0ZfliIpX0pZNSYmJ7+U2nvd3lFxzq099juJiEBm8Y0bWyaCeOO
         F5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=UiTpXgmVqFrHSdksd6Jn05Y0HoKR56zNJyN5+XF3nCs=;
        b=HXxvnBBW9GcAZNrP0JF0TCydvj5YkzUESv5IRYU4O3OpmWJlgRXXz6s/x1aXNche7W
         j9Ffl9+XkXbNMWJtT1dtVj90AOIo8PVaFH2wKNYlxO3dkE07O9cLZE54i4oApLcPUzLa
         bSg9UNPlXunlQpG7C5C2V3iVrqsUp3n38qN4DOeiEigFXVPIYYXbE/6ra2LRPWQd/E6f
         Xf4RYhGOGEcMBIZglGrXmG1nPVnuITo0fRCw6VadgIiXil6kPJOqtVuPmMN2bhRqc0hM
         o5UX/bUPdtAJ76l11vtUcoygAGhmoW8nWYXPvS4cFsEpVMzAABq5lI4DzyDudRLcU1rB
         jEIQ==
X-Gm-Message-State: AOAM530gJLxS/M4YKur6QWz/s+taw7KCWrYurKVr6oXi7TFrMsIdMX2d
        /ksY1ky17PNdNrmejb4eJao=
X-Google-Smtp-Source: ABdhPJxnJZMo/BCEeC7qhTl/foakowuDozCp3pXfrSEjihqt3hMw3AzneTvOsOjynkK2ZiQk1P/L7g==
X-Received: by 2002:aca:60d6:: with SMTP id u205mr937823oib.82.1611506774487;
        Sun, 24 Jan 2021 08:46:14 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q6sm3053243ota.44.2021.01.24.08.46.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 24 Jan 2021 08:46:13 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 24 Jan 2021 08:46:12 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Thomas Hebb <tommyhebb@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bob Hepple <bob.hepple@gmail.com>,
        Jean Delvare <jdelvare@suse.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        linux-hwmon@vger.kernel.org
Subject: Re: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control
 blacklist
Message-ID: <20210124164612.GA136698@roeck-us.net>
References: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 23, 2021 at 06:46:08PM -0800, Thomas Hebb wrote:
> It has been reported[0] that the Dell XPS 15 L502X exhibits similar
> freezing behavior to the other systems[1] on this blacklist. The issue
> was exposed by a prior change of mine to automatically load
> dell_smm_hwmon on a wider set of XPS models. To fix the regression, add
> this model to the blacklist.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=211081
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=195751
> 
> Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for all XPS models")
> Cc: stable@vger.kernel.org
> Reported-by: Bob Hepple <bob.hepple@gmail.com>
> Tested-by: Bob Hepple <bob.hepple@gmail.com>
> Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>

Applied.

Thanks,
Guenter

> ---
> 
>  drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
> index ec448f5f2dc3..73b9db9e3aab 100644
> --- a/drivers/hwmon/dell-smm-hwmon.c
> +++ b/drivers/hwmon/dell-smm-hwmon.c
> @@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blacklist_fan_support_dmi_table[] __initdata = {
>  			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS13 9333"),
>  		},
>  	},
> +	{
> +		.ident = "Dell XPS 15 L502X",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell System XPS L502X"),
> +		},
> +	},
>  	{ }
>  };
>  
