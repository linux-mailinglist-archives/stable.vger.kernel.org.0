Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED37536B8FD
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 20:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbhDZSeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 14:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbhDZSeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 14:34:02 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEC6C061574;
        Mon, 26 Apr 2021 11:33:20 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id z20-20020a0568301294b02902a52ecbaf18so661176otp.8;
        Mon, 26 Apr 2021 11:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Sge86uN5futi/kKAjxlBsQoKm42ZJKrBhqlqPWw7al8=;
        b=JihiStQdr8IaX0lo7/blRuti5r7WN16ku2SBNi4R71MwZdj1cbvi8598y7cBeqZCr1
         YU1Ru42cZjjac03w9YuXM36CATekhMCvyHmp4M8tFHczjQvMWjykLAE/QFaZOi1dMPGB
         I3VgtAisFSZTMPSCjNuPvUl4HLzX3ucRs9ddYz/A49GQMJBQEgFFjgBj+LkTCfABh+ur
         G5fGu0lD6Fj8sepc1eBdEh6ZT8kgRZ9ZQ+5CbFwWA4tHIVllgS8TTeCMKCK0YoB5Uini
         7M7EWrRMnSkEyzJ7w3oXeGxodS6TWKHy2m4inti+sIuBy3OEy+48xgGcX/IhcEv1dAqm
         asoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Sge86uN5futi/kKAjxlBsQoKm42ZJKrBhqlqPWw7al8=;
        b=Eo2iEQDYiGvho19lSmB034Vz2T+7QQVaKNAyEAgvtFvOu8TIqkzau4WXU8W7x32ihV
         CLAQxMmFSqXfAz/kAeKVsw4Iu8U4+oMcC8vPeGVrwHn+H+ykDmayZ2GebM/Zzrm+U8jM
         ov263vzSFqjtNDiXIuZFirJJKv53d5sJL6+y6zXiz6fzsp3c1MfLDqBUwQu2SsP1qs/D
         HkckfnlQddvo/Se1U5XYx4cqnkv1EXyOVSpt0S1SrIHWKQzARdgbrsSOl+5Yf2DAVA/l
         1ZtLDPUl4Q0Frt84TuaCmC1CikCh/XhZ4S+vl8xnIU9gXpydDpUk/rX4wvBJgqgB+xOM
         wy4w==
X-Gm-Message-State: AOAM532fer/iAvwp2b+iWWa7jBddOAxUQv/tgYo2ZiNlqEh/Qc5upJq5
        J8TrYrkLg8ku/i+LUZHQ1Rw=
X-Google-Smtp-Source: ABdhPJwrSi6dmUWhAhjJ1m5dja2P8bUHyEdVsdGqI+ONfLOrBQYSQBlbWAbyXlOZ+Qv+62cYpsAY+Q==
X-Received: by 2002:a9d:615a:: with SMTP id c26mr15853951otk.54.1619462000173;
        Mon, 26 Apr 2021 11:33:20 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j5sm89938oou.9.2021.04.26.11.33.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Apr 2021 11:33:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 26 Apr 2021 11:33:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/49] 4.14.232-rc1 review
Message-ID: <20210426183318.GC204131@roeck-us.net>
References: <20210426072819.721586742@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426072819.721586742@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 09:28:56AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.232 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 409 pass: 409 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
