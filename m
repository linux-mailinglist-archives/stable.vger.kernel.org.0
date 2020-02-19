Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F1E164D56
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 19:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgBSSJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 13:09:23 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44840 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgBSSJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 13:09:23 -0500
Received: by mail-pf1-f195.google.com with SMTP id y5so440343pfb.11;
        Wed, 19 Feb 2020 10:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t6dEq8D3tF3M1Mz7rQwfHLp7+Z4wQM2qVRt9Tmnom90=;
        b=u6Ycm8av39pN/W6R6jUZKg8+L5rqCO8y2bxXeznhIJiBOEssskqT+mzE1SxtJt/W3n
         iPYUiebDeiVXgUp6S49PkcgfuAl35WPkufWbiWzL7/bG0SaeHnWRtTT3QHwYk1JuHBo7
         +4F3O6s7OGNQhSl3oiPZmhFDE/svvGbwec2T0UMOuDOld4IUMjlL434ZvMO+auya68MX
         VTDYz4eRlpBSKxRY/M2RTgnFT7DjwxSnpBGbOAacmXNauT1iV3Tqk3dilVIqyVhq8Bo3
         gMmlsh7z47OTqIz9Ds7EGbU6ljExMWeWMh8yNUJSCa6aBVHrJSUJ2NFtgZ/qzauVG3Bq
         Rmjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=t6dEq8D3tF3M1Mz7rQwfHLp7+Z4wQM2qVRt9Tmnom90=;
        b=gwvNY+7q6S22aHDQiq68/7+pcpHCE5WFyIa/KwZqM7K8+KBiPuu5YmQ9rP4v5O7YLQ
         eWbnoYmjUfY+CQsqEhBstYB4erkQN2UWTwM3zSf837wgBys4KCDaQ6ZhAxhPSi6EGVE8
         xNgHXPkbJQrXsz6TL15+PrJaVmcRapC0AKNVNXudggUAw90gDlX7vYxS8ugC6vA3Xv/o
         nlCIqEHU1c1atWkVVHQ9GB9b4WtK180Sqs0hzrlaNLCft4TIguOfCmEOQbA/gbpBn3JR
         6UWiP6ZNCZouzz8e+W5rpe36tgOnJ4wIsfpt4V0fR5GzSTAPJ08/uZazH9WkVxg9tHvP
         DYeA==
X-Gm-Message-State: APjAAAUJ6I58b3JWHiBtQo05YLvaF4Twav2gOD05ROW6/KQFrPdCblvm
        YF3msTHe/YM+tswFgKd9NlE=
X-Google-Smtp-Source: APXvYqwZHgjjEZoEeeBrxbp01Ie/gF5sP2WniFKIzwzwZ85V1Ity+IISL6JNXUrnsZ/RYQHB93mBsQ==
X-Received: by 2002:aa7:8610:: with SMTP id p16mr28429565pfn.28.1582135762503;
        Wed, 19 Feb 2020 10:09:22 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f3sm280158pfg.115.2020.02.19.10.09.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Feb 2020 10:09:21 -0800 (PST)
Date:   Wed, 19 Feb 2020 10:09:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/66] 5.4.21-stable review
Message-ID: <20200219180920.GB26169@roeck-us.net>
References: <20200218190428.035153861@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 08:54:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.21 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 411 pass: 411 fail: 0

Guenter
