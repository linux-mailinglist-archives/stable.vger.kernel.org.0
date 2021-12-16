Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7438477B47
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 19:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbhLPSHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 13:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbhLPSHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 13:07:34 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCEDC061574;
        Thu, 16 Dec 2021 10:07:33 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so29912824otl.8;
        Thu, 16 Dec 2021 10:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=67oFozDOve4dKfdb70BahFEFBfo/ATx5QwEXJPsgiiw=;
        b=PcHszTBv0l1v4GfW978Y7HeFOgN4Sfj07uORzp2bG+lDtUrtUSKRbISPPAlMwJ6VVO
         pORAYpQ3q/4nytDnY4B9WCz+CWOHlwyWRJl+h2VGkVerocae/kZ+Vxjn46TdUxFtQ6hv
         pdtLTy5JusZGHapvk2vg8fqchOfZMPpkI6oJ84icNF0qj+m332BxHDEC5sIHgGOXpt2h
         XtiNClTdkqbz+1vZfGsxJf9ISgw41PqDZsYjlrBvgdsZSPUPKiJrRoVqoAl6mAwaj0K5
         9J9DkIwbztGOrQYIH8/jUfol5RstKDFJb+tJKkUQCoLncz7Qub3NXRmzM7UCo9kaJPnA
         5JQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=67oFozDOve4dKfdb70BahFEFBfo/ATx5QwEXJPsgiiw=;
        b=QvFnz3zZkHWxK+V0IoXIjxnBJKQlFX+YlZoxHB9r0D7MoEBBeAfBIh+ruc+73T52C9
         AcP5vQhNhRCFLm6S+oy6Rk7lGl3J8pWFZ2ElzBV1XWETfBaTeMEbddKnFvRbKa2sJChB
         E60LvzZUDcCN/IwZxql2qmG0dFZ8R6fLa8XPojRmjiELPBbfVWb5UXhpzD/XApvaL+AC
         HoFTA3jtAnhzbYIPkI/qRsqhD/kHYUD0ajpJmhDcrT6LX0WSUIUpBExNtKNTkKh4TVyw
         psC/P6ZukLAg1z6qxlizNxXLk8vH3EjKJf4cKt5Sh7nzqJ9AVmgOi8Jdk239tg2k5RAN
         9IIw==
X-Gm-Message-State: AOAM53344F3NZW3K8W0hPyTITqa+r3Rhzn8ob+dtYNLGSAeVewmHXggQ
        RSYR5IUs4+Cr3UHWNBWxL38=
X-Google-Smtp-Source: ABdhPJw5CWItpv+5rYTWuRx2/A/VK6L5AgzpDfEBLi4cgmiwngdVM6ILmM/I9chsaMsSh7OdSNb80w==
X-Received: by 2002:a9d:6854:: with SMTP id c20mr13950902oto.190.1639678053272;
        Thu, 16 Dec 2021 10:07:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r26sm1117003otn.15.2021.12.16.10.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 10:07:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 16 Dec 2021 10:07:30 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/18] 5.4.166-rc1 review
Message-ID: <20211216180730.GA1125270@roeck-us.net>
References: <20211215172022.795825673@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215172022.795825673@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 06:21:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.166 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
