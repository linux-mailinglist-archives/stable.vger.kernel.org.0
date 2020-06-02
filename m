Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA741EC279
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 21:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgFBTNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 15:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFBTNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 15:13:34 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852DAC08C5C0;
        Tue,  2 Jun 2020 12:13:34 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b201so1448380pfb.0;
        Tue, 02 Jun 2020 12:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bBG4XNBybUoM4M3ei5scz29DlPiLElWm3VARw3qwsl8=;
        b=IHYm7nxpfde1nubX2BBBTMWctUj1OAYz0dN+QhMqLdmyMsdDjnZjnw1DMW1Lyu9ecz
         P0AfRAM/rHKcurQZ9iWsJhK9WFMJYP/mZpAMyUwt4l0kF7ZqKVK5TtPBz3vGDR7X9tre
         s2heWkMPpJ9gzJ1yuE80OISbi/bc5ZrHKnBWzxwU1OpzeS4znSO3uYoOqQJ8W9RtodN2
         Hxife1Hi3Y/ZwRFhmo30CyOLnfzoT95Vw8eKrYoS34XncdP0WNMCNriIclDkNDbRHw4e
         GXR1pOPfj+tzMsG86Owh26Kq/ZpO8R3dLi5Ot8h4XQOh1j9Gy9NZHFW5p7vehgHQmoXP
         nulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=bBG4XNBybUoM4M3ei5scz29DlPiLElWm3VARw3qwsl8=;
        b=btiTpsietIu2rmU6NGA+DGmJ2f9jfHywGUzU/tvp795VsNP4r7DUE0MH/5/0G4t8/Z
         AOk4ppPcSB8XfR9sc0Qy0wR9ZMzT4lb/aOMJszhFiWBrpu/ZbnKC6ysQvsWbUUOP2TT+
         LvcPtPwTcaYX44Df+5omx5CSSi5xoGJJqOwr0RKTHq8LMBekbpLaN12sge3xoxkfmwIg
         0EKWPceF1MkpgFKJ43kno/HrxZeMnXeo8ZX4/RatHc8dFHlmS00Rc8QAFWpI32EaOKV1
         CcxEFY6vm67k4VaXR6DM1/a1Pk90vJCe6Gn+LABX0jQmGc7CVHAlKBxFVOtk6gXXKBoF
         vJ6A==
X-Gm-Message-State: AOAM533+OKg8ff7VD4uWr96xKYkhIV7NkpT67Z/4C5U6tP2F6q1CHwmP
        HxUogGWSu64fMFmjOMmc39Q=
X-Google-Smtp-Source: ABdhPJyrkQpTLAYkIf5OI+tlvqXQjRpTUum5kI7FUXXPqwokoc+8nlOQQipKFGJvCCnF3BYAurig/w==
X-Received: by 2002:a17:90b:195:: with SMTP id t21mr678421pjs.93.1591125214130;
        Tue, 02 Jun 2020 12:13:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t25sm2767529pgo.7.2020.06.02.12.13.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jun 2020 12:13:33 -0700 (PDT)
Date:   Tue, 2 Jun 2020 12:13:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/139] 5.4.44-rc2 review
Message-ID: <20200602191332.GD203031@roeck-us.net>
References: <20200602101919.871080962@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602101919.871080962@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 12:24:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.44 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
