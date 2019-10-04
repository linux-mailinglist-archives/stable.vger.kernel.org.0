Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC8ACBFD2
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 17:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390128AbfJDPzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 11:55:54 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45805 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390031AbfJDPzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 11:55:54 -0400
Received: by mail-pg1-f195.google.com with SMTP id q7so3960640pgi.12
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 08:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tKT3NphsS8aC+Hm20wz5BTowxyu8Cj2InabWiB0c0GY=;
        b=P9uryt8X7gX4iN8K3stEiJTJcM2cNtvg5fWgSYMUEnyNUbpf0ORwDeV01gZKcjRXCO
         VCwvJSIUMUzDCJGqe3vTdQ1hMWFKYBkDV4e2OYCKawfibi6tstydDPA3//MRuqJbtD4R
         z8UKcn4TKlwv5xv6uJJi8wck3MSYJwOu971ps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tKT3NphsS8aC+Hm20wz5BTowxyu8Cj2InabWiB0c0GY=;
        b=bLzYdQBkFJSTRJdD4P92O0XZ87EdsKWGFQV67OmGtDOi7TwVYb6mOKacgm9OI4MBYt
         HusMvJifvJVFqt5u0flYFB3HjTlS1wVNm1/6EBktWMVI6leGCCPRgeggsNfGnigM/b8O
         yGooRPSz7ZU3x2edKkqSaHVLgyYPNiiW6lC0b11VYxRQTJYnkFLfeC8qdPEG6F3dTRmI
         D2+0psBnr3xa/d4lgaVA92n+52NZ+QZ9dLT2GxrGypHJHuktvBvNaaAbBL75xuHX2RQp
         S4p3rfNrIWo4D45aGRy3PgYCC1FP0eN5soPiiXy5vArtws1kEPlRJjTlaUt+73X28nnz
         WWXg==
X-Gm-Message-State: APjAAAWZa6vhL8kpc4cNHMQMOjsTXOgkpbgXXriNvcjHEMlcXF8Js17q
        +eJOUjvFCj/ynHMy4U2jX+jYSw==
X-Google-Smtp-Source: APXvYqzseQzsIEYKPy2lca6iSmI4k9mLnTVGFyHajRsnq7Qjy0ko5OuaFD/y5oKMSoGkp+PZoeYkLQ==
X-Received: by 2002:a63:368a:: with SMTP id d132mr16009995pga.428.1570204552364;
        Fri, 04 Oct 2019 08:55:52 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z4sm5730004pjt.17.2019.10.04.08.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 08:55:51 -0700 (PDT)
Date:   Fri, 4 Oct 2019 08:55:50 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Will Deacon <will@kernel.org>
Cc:     linux-wireless@vger.kernel.org, nico@semmle.com,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] mac80211: Reject malformed SSID elements
Message-ID: <201910040855.8E8B4D7A@keescook>
References: <20191004095132.15777-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004095132.15777-1-will@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 10:51:31AM +0100, Will Deacon wrote:
> Although this shouldn't occur in practice, it's a good idea to bounds
> check the length field of the SSID element prior to using it for things
> like allocations or memcpy operations.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Kees Cook <keescook@chromium.org>
> Reported-by: Nicolas Waisman <nico@semmle.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  net/mac80211/mlme.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 26a2f49208b6..54dd8849d1cc 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2633,7 +2633,8 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
>  
>  	rcu_read_lock();
>  	ssid = ieee80211_bss_get_ie(cbss, WLAN_EID_SSID);
> -	if (WARN_ON_ONCE(ssid == NULL))
> +	if (WARN_ONCE(!ssid || ssid[1] > IEEE80211_MAX_SSID_LEN,
> +		      "invalid SSID element (len=%d)", ssid ? ssid[1] : -1))
>  		ssid_len = 0;
>  	else
>  		ssid_len = ssid[1];
> @@ -5233,7 +5234,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
>  
>  	rcu_read_lock();
>  	ssidie = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
> -	if (!ssidie) {
> +	if (!ssidie || ssidie[1] > sizeof(assoc_data->ssid)) {
>  		rcu_read_unlock();
>  		kfree(assoc_data);
>  		return -EINVAL;
> -- 
> 2.23.0.581.g78d2f28ef7-goog
> 

-- 
Kees Cook
