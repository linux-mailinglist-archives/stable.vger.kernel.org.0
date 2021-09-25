Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360D24184C8
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 23:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhIYVw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 17:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhIYVwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 17:52:55 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3E7C061570;
        Sat, 25 Sep 2021 14:51:20 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id t189so19841460oie.7;
        Sat, 25 Sep 2021 14:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xXE6tPFHGDsPsH+w+WO5WaNI+v7eeYjQLWzUD9Xd83E=;
        b=ODZtRkyZQ13i7Vio/IiY1nwAYNaxnbsb6tFCfAV6e6omhF9afdn1V9nESyKw+Tx4nt
         Wv5fiUVddccSvTaAmYpuR2Rx1Jvi4UYoVWmYCFCZ23gANyZE4VMVauDKTVBfG6kEJfKO
         qahHUVEEVyzPrRETzDQlsQRKLQMEfL5Ck4Ept9b2wlvRF3yazZsg3jz6kaOrJjmAvYbs
         EuZCUWjrdXfW40X1vqhznNBMNA2J9xSpiObCmCDwY/ew3cSY9WX8RG6jDsjgA4QKHxXz
         EJf6G4hR70HI4HhflfwJXWKri2UqUVYMJdZKEZG89iuz10WvB7qJzQi5/j5HyBl7ne6I
         g4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xXE6tPFHGDsPsH+w+WO5WaNI+v7eeYjQLWzUD9Xd83E=;
        b=2+gz2ysF7aCBuCVuaFt0G7Uy1/JvKyeWlVVLHUYkBQHVjNOfRAP+luMrxx+CZ/zpM2
         eMv7kgSMAnLvUSWgr5XdzOCb+SPhgTSfjrMwTrVFeT+b0TQRgGdT9+VSsxz1sJwUPtZj
         zUW7fjgffvDQVRh6FHsQwMj/oFq89s1fjELCzzxAh3Qh6NJCgE/BUyj/bliaqBCLiGJw
         teYPkmRnYOpF8a8dCODOvrNZFfyxYrBa07XNG0yQ8u8/2IzHFTAqm7W2fXe6/UijDlck
         8pZG0Hupx8Ki1b2YmCcehTn7zGUKeIXhDHwIMn+1sBT0LMdnTVztnpjpB/JsPwlLQosm
         RRsg==
X-Gm-Message-State: AOAM530cMzF/b9flkiKnrJCWBvJtkRx/hltWAYTVOLvwN/rTRowNfp8/
        FkJo9uxqbTbZkVszHSGCCmg=
X-Google-Smtp-Source: ABdhPJwi9R/RUixnA7k2JW9rjgPH4knq4380x+ZFzuH1hRfM5qsIdfqQ5BgMNwgnWNOKPcdhkivxqA==
X-Received: by 2002:aca:2415:: with SMTP id n21mr6417500oic.27.1632606679464;
        Sat, 25 Sep 2021 14:51:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u12sm3085320otq.20.2021.09.25.14.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 14:51:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 25 Sep 2021 14:51:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/98] 5.14.8-rc2 review
Message-ID: <20210925215117.GG563939@roeck-us.net>
References: <20210925120755.238551529@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925120755.238551529@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 25, 2021 at 02:14:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.8 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
