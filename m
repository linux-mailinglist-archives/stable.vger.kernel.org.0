Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E42634279D
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 22:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhCSVWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 17:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbhCSVW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 17:22:28 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873EEC06175F;
        Fri, 19 Mar 2021 14:22:28 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id y19-20020a0568301d93b02901b9f88a238eso9840958oti.11;
        Fri, 19 Mar 2021 14:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wHYp12MG6Uz7mmWnTneez9D3kWOc0B++ag5ffFKOV/0=;
        b=nfW8CLVxX9QwxY55hFt173nLup62uS8+EHC5Ck9x9vsm2juwUY4kcNnupQBQD67NUD
         DKvbKJ8tKGROhJO1u9rLWUcjV72MJUC2WUolOSv9ycLLjXxOlouB6CE4jldMadDbKaMn
         ayTml+745QuqSwOLTNGABawCDZ72p9KaD4IFKKTbKuvy0wWC5hE+LNk1auR9ttC8Efuw
         L0zXw4Srrpfk6MNcIGLWTB4Do/kGSncr7qal9ydjtOAcPjELZx6pevJY5rGHrRAgwe2w
         JBRewdzznXtF6R6gjd06jPzbsWkEPoFEicSYMWP22GvB+Q8Gfz+f3mmDZcFbbuJds1c0
         uY7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=wHYp12MG6Uz7mmWnTneez9D3kWOc0B++ag5ffFKOV/0=;
        b=uiIHbIzdHiE5UiSSffRODG61CwB+UcgAapmTU0m8HVhJOvPLm4iqXi6RTuZnXORjHO
         LSp1kONnKQCCDHziO8JGjjBcCRteelqTD+1c1EivKOyvHCgw8sC4tVkleQ2uPFtcP/60
         rUcsOEw4q4PUqhxy4hOjH6K2WE3Lw/7Ua36Xm9U8Dhp5RpnKeWQroYLchZMs6Kdnid6C
         ddevfgmiXxS75hpNGcaUi/dltdBcpuWaqL9ALtvzU9jYoKfhyyYxFmuPSbEnADjtOJOL
         t+w2S4y5USHKB+VnWrR7aFhB1lnLZwyYEDeW4waY8o7NS5SFLNznwsdJoJQLin7envWm
         cguA==
X-Gm-Message-State: AOAM533aXiVOFAm4A8/DfKI5FRWLkmE2VAi31K2R1w3CRCbAORLEXIYZ
        jX2MuwUeyYZJ+Gb9pE89Utbka+GMtFE=
X-Google-Smtp-Source: ABdhPJzPehmtVH/OKrcQuxKPIOt57rRXTO7cCHOR/1DxDSgNT7w1JIAszZqJ4+Mnjg5mvYCzX4IGsw==
X-Received: by 2002:a05:6830:13d9:: with SMTP id e25mr2598472otq.94.1616188947970;
        Fri, 19 Mar 2021 14:22:27 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a13sm1512520ooj.14.2021.03.19.14.22.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Mar 2021 14:22:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 19 Mar 2021 14:22:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/18] 5.4.107-rc1 review
Message-ID: <20210319212225.GB23228@roeck-us.net>
References: <20210319121745.449875976@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319121745.449875976@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 01:18:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.107 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
