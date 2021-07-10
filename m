Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBE63C369E
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 21:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhGJTz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 15:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhGJTz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 15:55:27 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53625C0613DD;
        Sat, 10 Jul 2021 12:52:42 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id u11so17468722oiv.1;
        Sat, 10 Jul 2021 12:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=msdBhLerC34QV6kEqtNPSusos1tuVPV571JN2k3P3g0=;
        b=G1dqWE38Gb16Wmf8LOyg65St3bgzXsT1vrM8N8GlozaQhas9LVSlLfPVJuMpk35MIK
         HfeDlMu+M2jlZr3w5bEjH7c42M4rhVYyBXb5aIoNayLP+m/eRftiqRpplt/X3vFLAMM0
         rwuJWH7XbfNwp8Ud07mUnIHNtNSiUd/gZNxgF4rxowqCeOiwXkFqUhHTxj3nXGx97vhp
         aJODkWkHMEOKlLzHHF/nF/AUuipmAhylBQwP7f5JzQBIZMHKnFQqZZvDEK41ZKw7jmcK
         LQ6imhb1aDk+BAzuvEu3XUba7hIYXaK9tUL5LMMhEZ9MhAilksFp17Q9DeYDtmrGkxEP
         MhRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=msdBhLerC34QV6kEqtNPSusos1tuVPV571JN2k3P3g0=;
        b=TpKGWfzzTrL8496yeFqOxMRvz+9Jn471IrjLNmO2tfWs2olt6WPwrtgF7fbMIsr/lJ
         W3jZQJ7S4dDEgN4ipmxZPs75/oTQB25NH/sNJyiLJ97GuA6KEN+JMJAt85ezHyL8+o2l
         cUqa/1SMUI6ZIQX3nrS4fpJEEaT4UnAw+i1TjJVe6tJNGnqQgPViXwZZz66QaIydXhAn
         8q+3wWOSRscEiGxWae/JEcjbuLaN3epOOmU+NE8GQrXQDOwShnLfR7MvG+JmK32DQbNh
         9xdEvvkw6TZHUHsYin9INwG2rwThjLAOn5jLqwpK8Gl6VdQ73D062pauL6bsDx3/uwR9
         OWUA==
X-Gm-Message-State: AOAM531sYkpELVHaPuRiuFVWN16TD2EPJuPRliyOoH921IsEHyS3L9mo
        GnmwAXgd/EpmzbyXaMxdEno=
X-Google-Smtp-Source: ABdhPJzKfKT3JSbF7Fd/LWjA5pNjuS9w597e4xuUtDGGjPwryps8fProec6e99qiZTPI25eK+YskPw==
X-Received: by 2002:aca:c7cb:: with SMTP id x194mr2323856oif.119.1625946761762;
        Sat, 10 Jul 2021 12:52:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n14sm856656ota.57.2021.07.10.12.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 12:52:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 10 Jul 2021 12:52:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/6] 5.10.49-rc1 review
Message-ID: <20210710195239.GF2105551@roeck-us.net>
References: <20210709131537.035851348@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709131537.035851348@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 03:21:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.49 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
