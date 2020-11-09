Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E829F2AC903
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 00:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbgKIXEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 18:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729336AbgKIXEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 18:04:42 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBE2C0613CF;
        Mon,  9 Nov 2020 15:04:41 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id w145so12115564oie.9;
        Mon, 09 Nov 2020 15:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Fc3gSuLEfuu+dLsgaj7/ICbXeWCPvdy5EVNWmL9XULI=;
        b=kR5KgzIPdIMD/xHDbKcewWcT5ghZI1w084/AjSxmYeq2LCmUqAAT0vtM9YnMrrce48
         /pmHolCdUTQCZ02BDzVdV+QGsYyr0SpvTsIco7hjpaAxpsEtUmRqO9+HqmyvKcMFDNh7
         ynbYk9R01dA+UjfkF4ifLruVVJaCXtaSkFrGKmBvFPeAC5CwrYti5wfp6xZWmS3x87k3
         tta1K3uvYlys//AH0HFkmtno8n7GQXkrhF5PhzC4zSQVWfxCZFvfOpIU5Eq92A4ZIuxj
         9Ry5zxeHGak8agzuLzrYiDfea/N1Y39u+H0t1VY8j/271esDV/quPJzGHaLeq0JZfRBv
         7DsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Fc3gSuLEfuu+dLsgaj7/ICbXeWCPvdy5EVNWmL9XULI=;
        b=F5NxYu6WQtonWNC1NyXO2BQ4tY5/LSaID9cUWD0r9W0s0jh54QkzWNV0P2f0HDvzEs
         ekjF4u+rXqVIzdn2chlr8ie1RIPYtEoEs8VSVevb8Dok5tuifECrd37zANRm6s3G5kb8
         0nZG1239fj05YQWTUMxYYqtP2N3KAAELkghaIVXpsm1FJ8qPqEIBN6irHGUImElwmRYC
         qAcl0C0TdJSRl/3+DMl/qHAba/dwPrxVUA5hB8F+TYUF2rjAWl5DxrHBnz0+QB04wop/
         WeCodunGDWeYm6m4LTrOGkm46lJlUjqb8MVvXBq/uzK9CeXfjXADUyO9/YJ303AGQVyw
         ymHQ==
X-Gm-Message-State: AOAM530sgw8xxBB6IGXvQ4dbAb0WslU8+lXLHq8HUWh2HmHyZGZ2MldI
        8QvzXZa1ZYwRG/0uGjjE++Y=
X-Google-Smtp-Source: ABdhPJwzB696+0UOZvwLWEYhb3UkDxYo7AsMYMjgTkUUXNz2MraaimAI+h0jLOCtsbNl/GGDV708Sg==
X-Received: by 2002:aca:4b0d:: with SMTP id y13mr968786oia.160.1604963080512;
        Mon, 09 Nov 2020 15:04:40 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b13sm1587495otp.28.2020.11.09.15.04.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Nov 2020 15:04:40 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 9 Nov 2020 15:04:39 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/48] 4.14.205-rc1 review
Message-ID: <20201109230439.GB92773@roeck-us.net>
References: <20201109125016.734107741@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 01:55:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.205 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
