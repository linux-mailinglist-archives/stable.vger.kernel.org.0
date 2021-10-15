Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBB642F577
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 16:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240258AbhJOOfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 10:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237262AbhJOOfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 10:35:16 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1056CC061570;
        Fri, 15 Oct 2021 07:33:10 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 63-20020a1c0042000000b0030d60716239so3160714wma.4;
        Fri, 15 Oct 2021 07:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k7Wp2EqK8bhUnKcJNB409G/h7+B/pJ6VzA32GSiRSC0=;
        b=m39zq01SuN1Q5YL6zlc7thqX1Kq3BwRwbgrTVDaUOoQxt/X3oXtNFD1IjwPtmnSiEV
         ZLvlKPFT64RcF0NQx+vlm6BR/jrKTQLJZJN+yOFTpMusOaJjvTb/SZcge8vpj1VKHF5x
         PgWdB3CAwEuaOD7/vqsxwoAGnvRNcqOKaBfPAOo6jA0sp5FrZMqxPEOEXyZtFU/6zTKS
         gKK4/mpqUWIFhL/gk0R4Y/7NUt3/s4Gi+W8A47Cjy7bumWl+WPPF6TzIODGj1jHGs1MR
         KC5/FzDVtYmGcI5Dn4h6mQoN04uXb5+PWGsDDbKjQR8n4s3+mTPjxl8UK45oD024tZXK
         vt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k7Wp2EqK8bhUnKcJNB409G/h7+B/pJ6VzA32GSiRSC0=;
        b=rWy69XZzXVnB241R4310UCz5lhYliLBd1lbreH2PnaSKvIBQSKBasYuIL3lKxBpAvn
         MPa0Lcan5U4bI1vDWwB5LoQnEAihpKu7q+kSATghpdaamzZuryZL335LmyBoXq6daZPX
         C1yn/MjwKdM7IMACqkaTCekLbYMETDFdCEcA25oyRjK3Qejkp3MMXQpp+OT3Eauadtf0
         2+O2gC3UDuqK4I8qHlu2RF5bXK5Ds8GViQu3KwjLus39OlaXvgITVpIungRr9G0gt5aY
         PBgm7iP3FFJa9p3ndXY+WgD4jsHpQdpsfoykoalX1EsuC+/3fTLyXK9WmgDW2QDOyoOz
         xqVg==
X-Gm-Message-State: AOAM532E2W8VZW/smWSEXo3zcu0xFB6FLx4dNqQLGtTFIMrpTGR8vJIP
        3BrWsYu2BxkEo5+R1/Oosqs=
X-Google-Smtp-Source: ABdhPJyVAWXAcaSm230fzXtGY5V5PM5AQGYfz6RoP/IozoFGF1+hRYBXCQtbI89lqll7OKGNW7tzBA==
X-Received: by 2002:a05:600c:2c4a:: with SMTP id r10mr23787021wmg.166.1634308388668;
        Fri, 15 Oct 2021 07:33:08 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id p3sm10933334wmp.43.2021.10.15.07.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 07:33:08 -0700 (PDT)
Date:   Fri, 15 Oct 2021 15:33:06 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/12] 4.19.212-rc1 review
Message-ID: <YWmRIl2vtHE5HPXb@debian>
References: <20211014145206.566123760@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014145206.566123760@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Oct 14, 2021 at 04:54:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.212 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 63 configs -> no failure
arm (gcc version 11.2.1 20211012): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/265


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

