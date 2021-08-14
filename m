Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA933EC462
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 20:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238961AbhHNSQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 14:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238811AbhHNSQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 14:16:19 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112C6C061764;
        Sat, 14 Aug 2021 11:15:51 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id r5so20842866oiw.7;
        Sat, 14 Aug 2021 11:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vSffpD6F+f2JuT1enYdzS7/041fzdXJSyuy0LWDvSUg=;
        b=Gh2L5SVJP3aZrPGxO2kxitpsTbL/9MSIC/o4WwuPYz87SFT/rS8dnkXFmrZsiat/Lc
         IG3X2zHZHC4oCeVdpRMtaD6KxQz9ySve4cQoV9Uskdp0wq8Tt57gDkqtteeAAIIenH5v
         QKcf0Y+Y0mekpNa1L/TaY5bqVcNTJLcTl0qrzWvWQYcK+mKKSYGJuOGnsrSENcYZiPQ1
         ZY2LGWgAPeX+HrIUqvakmVGYpIUkixwbWy65JFxrG/0Z9PfS0h48pTiq4NAPxoVHxQOw
         C7ujEfTgLenYtesdBzbODb8DtJxAHLH6Y8/CxEoLzuyHyWJexM8jRXYYDhqC1Gtb1XWT
         u5Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=vSffpD6F+f2JuT1enYdzS7/041fzdXJSyuy0LWDvSUg=;
        b=AuX4EuadQQlCJ3DSwfCf4j2glfL26zXwSowVK4nYOEd3UUwe1Fxc2hNjoKG+s8Ov/y
         1yFdgnbv6M+iAblVUkOSOidUcyzpcYgfe1suZodkUWVC2uuFtxqBV0fP4qe9IuMkwBv5
         Ks49S1uV8XXTdvD4QKEMCtKEtCu9p/28FiCbnaVhndZ+3Vp+H6fdoy+Ld27thJ73Zuod
         wrDkVWWgh9qJqQk9iJQa3YJI90puJd+BJJespAEBBXYXK+yPdLPzyvThhkrzMUWsnQo7
         7xr3dLBs42n/rtv2yxI1ZWmRtSkEWtEjvcQztjhCoJWYEbaW2SXy3K7V85W5Gv3bw5Ui
         ZkHQ==
X-Gm-Message-State: AOAM533O7q3Ddib/cf1oc7UQ08B32Ked+dYoz1Py1pyaXtcIbeMAARfq
        uaN8JuXgGZgJRyIFoC+RF1w=
X-Google-Smtp-Source: ABdhPJz4r0xMfl8JbBE5Pm7OxZiZGoya5XT8CguxHfqs1jxsf0rDE+7vwAOHZldK51WkmI1EMMkybg==
X-Received: by 2002:a05:6808:140c:: with SMTP id w12mr6270740oiv.22.1628964950543;
        Sat, 14 Aug 2021 11:15:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p8sm1173216otk.22.2021.08.14.11.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 11:15:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 Aug 2021 11:15:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/27] 5.4.141-rc1 review
Message-ID: <20210814181549.GD2785521@roeck-us.net>
References: <20210813150523.364549385@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 05:06:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.141 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
