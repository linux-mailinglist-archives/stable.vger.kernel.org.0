Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1DA34521B
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 22:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCVVyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 17:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhCVVyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 17:54:12 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D26CC061574;
        Mon, 22 Mar 2021 14:54:12 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 31-20020a9d00220000b02901b64b9b50b1so17484161ota.9;
        Mon, 22 Mar 2021 14:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mkKaZEUw14JGRu3brjDjUQd7+5Djsg1t9hl87qbFrqs=;
        b=NYgssdOSyk0N56fRmxYAWnrkA9ajk+0ApRYjSyXKqruTMh8hOeSHT5KnXski0OuHD8
         xVitzyCivKlQNoz9AzTlN9fRY8xsPAxPnTXIRyNxSGu6ScUtvzm4yLwXKGv4MxNe62mY
         c8V2QsJUcb5BZsNAYblfFyI7RzpwmyxGGCitgX6/SmiLzUGOaqSTYGa3769wh4emOwCs
         4PR+iE86aetpQXTJQLpwm1oAynzk/L4dRDH+uFcmQ6WaQk9d2X0se44FbnUH/clm0kVI
         T4l4d3bBUFDz+0zNCWyfnahweFBDbvmHx2D28eTWqrRG819rsdUN2EmjjdP2YScbAhGj
         8Hjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mkKaZEUw14JGRu3brjDjUQd7+5Djsg1t9hl87qbFrqs=;
        b=W/6rbr4XdHQ0EOt6pzu055/ycPRfPntgPV08zBCH6O/O34R2nZ7UFXuWopfi+9Sazy
         COMG3pK2GsCPrPOxVaLezYVtNotZopZNfmTal4BrSxWq5gWoabDCSoxhUaqJ1csd5ZJl
         VJSbBWnL84YbrawcT2PCt8Wnu/N+3kxGZXNnXI678Dmx+rVVQrNlniDvqQuvWff+7UQi
         S4croeUJz6uISMs6qJAJfgMs6SIcnCwnQgGtC+C0cGHYjeGKMCKYI6opGkSXyyy/VROr
         lYPTyVXHXtF4WF2AMEwUrCedrqpzTwvkRg83kpMu5ynjHbC1AuiGRSBw4g2khlI2eWvP
         PgRg==
X-Gm-Message-State: AOAM530FUu0a72u/2w7U5VzTIP16g747ZjTWrdJiwOgRklweN0P8Y6ah
        vieZj13EhKqQ6lWMIZodwkE=
X-Google-Smtp-Source: ABdhPJyk2nRJAE2nhjKHYW678lf0Dwx963YNAd8vM3bFkAmFQ1xVY9CVnTlUkUraLv7K++Jhz33PpQ==
X-Received: by 2002:a05:6830:24a1:: with SMTP id v1mr1509281ots.119.1616450051590;
        Mon, 22 Mar 2021 14:54:11 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 44sm3649571otf.60.2021.03.22.14.54.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Mar 2021 14:54:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Mar 2021 14:54:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/43] 4.14.227-rc1 review
Message-ID: <20210322215409.GE51597@roeck-us.net>
References: <20210322121920.053255560@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 01:28:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.227 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
