Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A25A1B127D
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 19:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgDTRCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 13:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725784AbgDTRCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 13:02:38 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAB4C061A0C;
        Mon, 20 Apr 2020 10:02:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e6so112505pjt.4;
        Mon, 20 Apr 2020 10:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cf/km2LQ8BGElY96pcJs1P2A0G8KidSr2L1irxTBz1Y=;
        b=Vd9Lz2B1jj2XWNAbUWpqErWJmkRFVkUd3w1Ob23O+icO9jWUNUKekCIHtXGl2IjHiN
         iBH4ndbsIdq9FQhHX2n0iM57qhkPRoYneGdeTJiKLIoNzVAeYdfovcUHzqfZ6Bbka+7q
         K5jD7UFWIsQ52NMqXE1yunlOL1gQIJNYcVS6oddXCREvW0Pf692rMg6W+TiqxLZgTc3U
         1fWQHQl2PeBvRPne4wTWb2a5T5Xegg4N9tSChGyiY6hLkUrgGwnFLeTk0fNeIR1IiLZM
         t5gKY3fNj3m79blQgeLiC9AaaYoRSqFAmbeqG/zMozg3Wy4Fy5wYWl6O0Pq4ZLshfdhA
         jOQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cf/km2LQ8BGElY96pcJs1P2A0G8KidSr2L1irxTBz1Y=;
        b=R+2eA0WAHjE+T0POUdQsm0gVqlvsw6unpswjsXv4eS1xbedJb9j/zfsrJZ/+tkh4sI
         Vr+KJf+5bTyArCEniuCgEjHIuyxCwl8Ml6gP47iU/w1LtE35ghKeDoMLzWiHmintdJlP
         NexH2UgSN4hpDHDnNfM2OCS7TeBD56XsivUWjArklRQITz1VhYW6x8TfieqpKUK8xw/m
         hJWRhb+a1YSkX4aDQroIQwGkMfrIMVVooPQM73CfksEZBevTnltj2Zmqe+jHSaCEcfEG
         H78CUj7r9VUhAf+eHBDVL6CBdukoUjIZQ5TRS9ZVUjLB9vNGlg1xc8pqZXy0vhForB72
         zMHg==
X-Gm-Message-State: AGi0PuZqyT6ab30roCkiPMmjLT/uJVzaKo/cHSYCfMMVDdqZWwYLAAss
        rSOqBCiAK6xjY0OLafRcoSo=
X-Google-Smtp-Source: APiQypJsOMwi9kxH31+fLd1mo8hyYXlQEaTlSj0eOliud4MPlGzjybo99gD+IhUSl1UgTRnU4WsRYQ==
X-Received: by 2002:a17:902:fe06:: with SMTP id g6mr6883670plj.6.1587402157298;
        Mon, 20 Apr 2020 10:02:37 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3c2a:73a9:c2cf:7f45])
        by smtp.gmail.com with ESMTPSA id d7sm23673pfa.106.2020.04.20.10.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 10:02:36 -0700 (PDT)
Date:   Mon, 20 Apr 2020 10:02:34 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Kevin Locke <kevin@kevinlocke.name>
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Input: i8042 - add ThinkPad S230u to i8042 nomux list
Message-ID: <20200420170234.GN166864@dtor-ws>
References: <feb8a8339a67025dab3850e6377eb6f3a0e782ba.1587400635.git.kevin@kevinlocke.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <feb8a8339a67025dab3850e6377eb6f3a0e782ba.1587400635.git.kevin@kevinlocke.name>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 10:37:15AM -0600, Kevin Locke wrote:
> On the Lenovo ThinkPad Twist S230u (3347-4HU) with BIOS version
> "GDETC1WW (1.81 ) 06/27/2019", whether booted in UEFI or Legacy/CSM mode
> the keyboard, Synaptics TouchPad, and TrackPoint either do not function
> or stop functioning a few minutes after boot.  This problem has been
> noted before, perhaps only occurring on BIOS 1.57 and
> later.[1][2][3][4][5]
> 
> This model does not have an external PS/2 port, so mux does not appear
> to be useful.
> 
> Odds of a BIOS fix appear to be low: 1.57 was released over 6 years ago
> and although the [BIOS changelog] notes "Fixed an issue of UEFI
> touchpad/trackpoint/keyboard/touchscreen" in 1.58, it appears to be
> insufficient.
> 
> Adding 33474HU to the nomux list avoids the issue on my system.
> 
> [1]: https://bugs.launchpad.net/bugs/1210748
> [2]: https://bbs.archlinux.org/viewtopic.php?pid=1360425
> [3]: https://forums.linuxmint.com/viewtopic.php?f=46&t=41200
> [4]: https://forums.linuxmint.com/viewtopic.php?f=49&t=157115
> [5]: https://forums.lenovo.com/topic/findpost/27/1337119
> [BIOS changelog]: https://download.lenovo.com/pccbbs/mobiles/gduj33uc.txt
> 
> Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
> Cc: stable@vger.kernel.org

Applied, thank you.

> ---
>  drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index 08e919dbeb5d..5bbc9152731d 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -541,6 +541,13 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5738"),
>  		},
>  	},
> +	{
> +		/* Lenovo ThinkPad Twist S230u */
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "33474HU"),
> +		},
> +	},
>  	{ }
>  };
>  
> -- 
> 2.26.1
> 

-- 
Dmitry
