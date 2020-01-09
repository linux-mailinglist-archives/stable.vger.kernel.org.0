Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20001358EF
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 13:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbgAIMMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 07:12:39 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54912 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729271AbgAIMMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 07:12:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id b19so2645321wmj.4;
        Thu, 09 Jan 2020 04:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vmqZFJI4/t85RaFWKz5wvUn4ieHdO2C5aUqRRhApoTs=;
        b=Ev1FaAh9td144Cu1v7keBhOynYEnTFkpToWUohtxFA5g0OIfDE00JgXHRc7obcaSri
         CXm/0ojD7YETpVqbk3KmNKF5JJ3SWg2ard4UocgrsmuOhRQ2pCFaqrX/BYA/Tpx6s0q7
         eSKZp7dhbFaQv5oMWFWKAxm5147VR8l40EVGVSMbDB/r4g0yBnU3VEMYOg0UlWIuX6xh
         Z1WpWXWrQQRQReyFnSy8JNNXc7IdvnXKph5KHtuYjogJSqQCIwfBMSWUdOcNx86xMqQS
         m3ULUE0Or1m3u7qm06dWivfVD7TJVDh81UL/jm1rlcOwTF9vNiGIuQE7k0SAJdNy+0HU
         JU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vmqZFJI4/t85RaFWKz5wvUn4ieHdO2C5aUqRRhApoTs=;
        b=qIh3WhWFQ+gM4JOeUTWh2XvZtEhUUdRzDArHN7j8eJVfML/XXsAyWIQsTsIifUjQSm
         RsnmO5OvWE32SQo8tZKcYG61Gd1dT9JBLJYBUBmKvh7Re83m1+qNTWneXdt+Tt8/o/e6
         G8bdD+QdeS4gj14howGHsqq4vipX9VQnsBzhZ0dTjtA/yjq/lHh19PpAZMNyR3ZSRV7G
         KcJ95II18DjHaSC42UCxBKgWrFvSXn1cQ/M/si/Vct4I3U6hZ7TVYWmYxUGuDGUWXSwF
         xBKAqT4jhyV27iu5UuO5eFmEQHILuMYmQMVPqeGFjA0BRWu3fVmN15ePEb7J52TpPIG/
         Fnjg==
X-Gm-Message-State: APjAAAXFmjQls+0Ni3EY/Qf09tgf8jqRDsYr+txqDBU2TPyaWIfCmiO2
        wbXWY5Nr/SOWBEF+jQ5JP7c=
X-Google-Smtp-Source: APXvYqzq8AVAOIYwTGyETf6kLYYP3jRdYYM9aTex29ImVwSr94DV5BUiEyFV0GeQX9zIEHLmdM8zCA==
X-Received: by 2002:a1c:7c18:: with SMTP id x24mr4592181wmc.21.1578571957387;
        Thu, 09 Jan 2020 04:12:37 -0800 (PST)
Received: from lorien (lorien.valinor.li. [2a01:4f8:192:61d5::2])
        by smtp.gmail.com with ESMTPSA id b17sm7852414wrx.15.2020.01.09.04.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 04:12:36 -0800 (PST)
Date:   Thu, 9 Jan 2020 13:12:35 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        huangwen <huangwenabc@gmail.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>
Subject: Re: [PATCH 3.16 62/63] mwifiex: fix possible heap overflow in
 mwifiex_process_country_ie()
Message-ID: <20200109121117.GB1270@lorien.valinor.li>
References: <lsq.1578512578.117275639@decadent.org.uk>
 <lsq.1578512578.718890478@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1578512578.718890478@decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ben,

On Wed, Jan 08, 2020 at 07:44:00PM +0000, Ben Hutchings wrote:
> 3.16.81-rc1 review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ganapathi Bhat <gbhat@marvell.com>
> 
> commit 3d94a4a8373bf5f45cf5f939e88b8354dbf2311b upstream.
> 
> mwifiex_process_country_ie() function parse elements of bss
> descriptor in beacon packet. When processing WLAN_EID_COUNTRY
> element, there is no upper limit check for country_ie_len before
> calling memcpy. The destination buffer domain_info->triplet is an
> array of length MWIFIEX_MAX_TRIPLET_802_11D(83). The remote
> attacker can build a fake AP with the same ssid as real AP, and
> send malicous beacon packet with long WLAN_EID_COUNTRY elemen
> (country_ie_len > 83). Attacker can  force STA connect to fake AP
> on a different channel. When the victim STA connects to fake AP,
> will trigger the heap buffer overflow. Fix this by checking for
> length and if found invalid, don not connect to the AP.
> 
> This fix addresses CVE-2019-14895.
> 
> Reported-by: huangwen <huangwenabc@gmail.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> [bwh: Backported to 3.16:
>  - Use wiphy_dbg() instead of mwifiex_dbg()
>  - Adjust filename]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/wireless/mwifiex/sta_ioctl.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> --- a/drivers/net/wireless/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
> @@ -223,6 +223,14 @@ static int mwifiex_process_country_ie(st
>  			  "11D: skip setting domain info in FW\n");
>  		return 0;
>  	}
> +
> +	if (country_ie_len >
> +	    (IEEE80211_COUNTRY_STRING_LEN + MWIFIEX_MAX_TRIPLET_802_11D)) {
> +		wiphy_dbg(priv->wdev->wiphy,
> +			  "11D: country_ie_len overflow!, deauth AP\n");
> +		return -EINVAL;
> +	}
> +
>  	memcpy(priv->adapter->country_code, &country_ie[2], 2);
>  
>  	domain_info->country_code[0] = country_ie[2];
> @@ -266,8 +274,9 @@ int mwifiex_bss_start(struct mwifiex_pri
>  	priv->scan_block = false;
>  
>  	if (bss) {
> -		if (adapter->region_code == 0x00)
> -			mwifiex_process_country_ie(priv, bss);
> +		if (adapter->region_code == 0x00 &&
> +		    mwifiex_process_country_ie(priv, bss))
> +			return -EINVAL;
>  
>  		/* Allocate and fill new bss descriptor */
>  		bss_desc = kzalloc(sizeof(struct mwifiex_bssdescriptor),
> 

Brian Norris noted that this commit has unbalanced locking and
submitted a followup as per:

https://lkml.kernel.org/linux-wireless/20200106224212.189763-1-briannorris@chromium.org/T/#u
https://patchwork.kernel.org/patch/11320227/

Regards,
Salvatore
