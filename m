Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71963336816
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 00:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhCJXu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 18:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbhCJXu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 18:50:27 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C181AC061574;
        Wed, 10 Mar 2021 15:50:26 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id n23so12618408otq.1;
        Wed, 10 Mar 2021 15:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MNL5asoPdv8UwHAUz9s6a7wD7qq9PF25E8iQDVIHen8=;
        b=KJBN27NQxR/hjM5K0whr0TSLpFJfuPgSty6mqlf09E2VrHDDj9ZCGdtYqbeSFNU1o+
         omFmHQcoPO1bT0thQClVTJgmAm2prIgYXnUpjR6BwdF4ImzDt2FLRN3yuyDjOccPga5N
         epyhx2GRfm5Zl3BXBSNo/X4AbYZ/O2eKIbYUoNsR6ZYiHjXB9S2ROuIhgmChQzTLRFP1
         u/AnKO1BkyfsOe4kPnpwy0tz6VeSUPcdMdUJE8anmzwxVpcYo5GTtjXA8ZhhQKnpUJ1F
         zoqVqrQVLkgylhEnXqWOlWtRv4gFCMeIzlrTRdSp/waOSuku3P+bV+tk25Op4epIB8wo
         0oHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MNL5asoPdv8UwHAUz9s6a7wD7qq9PF25E8iQDVIHen8=;
        b=TZo+JuSHP2Qv5ThiKZk+3yucBJ/rCOZoSlfYwFmB04BxM+s86nMkK903+Ow5wIo3QH
         uItZWN2DIFRIEIB0JWDSm4UMzQOoUJsfn+LeeHMLImYMe/gr6elBzVrMtLPqTXj+XPXS
         /APJ0iVx5CVZ09bLAVaCwkx6JsO+WZbJTiqMBKd8OXnslP0pYUUWTy/vDVvjdMETnp8x
         xlC1v+YqZvqI5ZjeqraOq9tCWhqWfYIMLP9yDtGj2IE9DkYMufKdc8aGTE7SfWfaL7DH
         qdRe83XJf8lwiKUH/28hSZDvks/WK9VC5tXyeUu/owqQp4l6FSM/fBTYdQnMKT6C0vh0
         AvZw==
X-Gm-Message-State: AOAM5322hVAdTLfwquKi40yc/r+2bkxMVvIgopAFe3SPv7kT2eUmSg9U
        YEwl3aRuKezYEnkJxydC98RX6sVwyeY=
X-Google-Smtp-Source: ABdhPJwDs5OSWCrHEFp5eX/Wo28NnYYpL8Z+QKeKP4guQNb3mN1M8Rdgu+BRII++BQ3P3s7DnuYVIg==
X-Received: by 2002:a05:6830:90a:: with SMTP id v10mr4668020ott.364.1615420226130;
        Wed, 10 Mar 2021 15:50:26 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w7sm215493oie.7.2021.03.10.15.50.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 15:50:25 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Mar 2021 15:50:24 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 0/7] 4.4.261-rc1 review
Message-ID: <20210310235024.GA195769@roeck-us.net>
References: <20210310132319.155338551@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310132319.155338551@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:25:13PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.4.261 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 331 pass: 331 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
