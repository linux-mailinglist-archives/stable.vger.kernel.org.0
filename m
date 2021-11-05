Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68863446583
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 16:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhKEPQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 11:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbhKEPQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 11:16:21 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE839C061714;
        Fri,  5 Nov 2021 08:13:41 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id r10-20020a056830448a00b0055ac7767f5eso13494907otv.3;
        Fri, 05 Nov 2021 08:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RORUwm1NAeL+yzUKj/ohBvizxJh+sAaTu0oCl3J92TI=;
        b=XMcADhC7Km99KcFbIivR1WYuIGmbYcKD6wK+VE16dyPg2TDZ5QiB4lDz26l4RtwkuP
         Q2hQEmZB12IzD4EitIDFSDLVh4/gsay5fuLtqcyvDBy+7pIqGO3zO1oXfQEOw9hvXMh/
         xnEQhpeJ9aQSCFrWYv8awSNN2IXGCOmYbEZHeXaJQd2dfnHUfN1bdt/oYxBiZj/8zgRg
         PQgsOxGo79zypCUYFYGJRo9uJm8f1VONgioYszoARXGW5kH9gOdpSJ5EnX4z5Nz+7dhV
         jII1UBTVDbLbFE4h2AURhpL2K3SoWoNWhBauYK/sfil3+HE2Pr7ydXpZ6+E3f4r5bJ3q
         NbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=RORUwm1NAeL+yzUKj/ohBvizxJh+sAaTu0oCl3J92TI=;
        b=X1/rNaVHkazTuxQLBoyQCmx1s2pg5rNq9HfW+K5JUSEBd9XJUpzblP+fGGOtjoG3fZ
         BFSTGrUFPA+EdNKXyROtkMXZ46ao586CloIgrzcpMBc6WiVbHdY6gwcCYduvUCNSyUeX
         ChIPa2k3vUMTIU1kBCdbirUQzyq7OFMpEid5rxgR4CPBlOKFmIO3Flio2Q8iryEpgbhO
         3c7r/IndFs+rPK9c1TYzDR6459NEQBNEN0wgCpVQyT1kjCM7KqQQq73lN9zafdGlkZuZ
         ZSFKMzmfL5T3e0X+/m8c+NSbBFWzoa0rOy4TjUSuaI5ijwJ/uUrlHvOX17diLrir7311
         DiKg==
X-Gm-Message-State: AOAM531FfNspFu3oWhYT0GI7IMv4ljd16QVHxTfdIEL6aaGgW/LoYWZZ
        MJjNjh4pmsdtypjOYGPM+I0=
X-Google-Smtp-Source: ABdhPJzDc3EVWKvDJ045PMJGXMeGLiFOCWjZk+2fgJK6wLGBWDPXJdJ6fbqpMsaKUE/+9SR9mcOoGQ==
X-Received: by 2002:a9d:220c:: with SMTP id o12mr45422878ota.250.1636125218483;
        Fri, 05 Nov 2021 08:13:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c1sm2572612otl.71.2021.11.05.08.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 08:13:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 5 Nov 2021 08:13:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 0/9] 5.4.158-rc1 review
Message-ID: <20211105151336.GC4027848@roeck-us.net>
References: <20211104141158.384397574@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104141158.384397574@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 03:12:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.158 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 446 pass: 446 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
