Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1989290C19
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 21:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393040AbgJPTIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 15:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390579AbgJPTIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 15:08:53 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D585C061755;
        Fri, 16 Oct 2020 12:08:52 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id q136so3599101oic.8;
        Fri, 16 Oct 2020 12:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MuaE4hO6bq+ijROR/m0uZ0eh0bV7cOVlRbgqwVBWT9g=;
        b=Cpam5yILFhb3Ogg5JoLdakhMvY5ExGYs5JMAkvIPt+XXS+euPwRuTu3X3X41zFkUCq
         /zPFoc2kZQN69FeQLlIs5sYSmhTfktOK4yfAW5cvyj5ECQRpqTtfxe1nFjmuDojjtOSY
         lWIeL0fcyZ6ZO87YMBg655pUzQDzN/D8aQs78gPR1CVSE7/6X2HpatpQhhifGwXosgbf
         5AsXRPNpwkikoV5f2/4FoS4KHEEyaarwPiQez1G2MFH1eEHf3DnB+Pn16ggofJcsuSKV
         OxTYOXyUNwLMu3PcqT9IIvoFLnfArbVxBYX2flZYCpu6QRSCwajb/vMHZ1bCtFLa853Q
         Ihnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MuaE4hO6bq+ijROR/m0uZ0eh0bV7cOVlRbgqwVBWT9g=;
        b=gQWm4UOBQg4RruIq+VxLuyrTayop4Ya4NImHGGep6U2/zZnsFS60oEvkPRQIz2QOJe
         zsB9kcf1qGd5K9y2j1AzSPt0dr750sE30Mwnk3cgwZ1TdjFZdramyIhOqJueeIcdbNEa
         BjGFFWoztaKf3tM+jio7ChVvGZ9+Dg28jyY1aIBfyLxsytkVCFoZlZy/UVmGw2/Rxi58
         bkG8xmbqOrPpu5/fQQI/CYMXujZ/CRYyiQ4iDOl7HX0/4LFTK/h/Zd/3SOHBmg9KHgRM
         AgRmlw8BXpW3ietgEHvWRmP98tiT4BGCMRPPdd0PEHdKU2YNkP76yvhCgr3vUShqq1cQ
         67GQ==
X-Gm-Message-State: AOAM533pSwzHCo8Er80VrHESxhwyv8PprlGsXYwwRSkkUTA17mqa2h64
        QY0Z860Pfw1QBBnh+62D8qQ=
X-Google-Smtp-Source: ABdhPJxvpBus0eQ7jL5ZttCjWEXpEDBOeayj5h2rY6AshqQq6lQ2S+xqWN88ZHDQCqXcz5xuSwMJPg==
X-Received: by 2002:aca:d804:: with SMTP id p4mr3359087oig.24.1602875331734;
        Fri, 16 Oct 2020 12:08:51 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f9sm1383489ooq.9.2020.10.16.12.08.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Oct 2020 12:08:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Oct 2020 12:08:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/14] 5.8.16-rc1 review
Message-ID: <20201016190850.GF32893@roeck-us.net>
References: <20201016090437.153175229@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016090437.153175229@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 11:07:45AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.16 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
