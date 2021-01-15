Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3542F8783
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 22:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbhAOVT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 16:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbhAOVTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 16:19:25 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B82C0613C1;
        Fri, 15 Jan 2021 13:18:45 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id p5so11001504oif.7;
        Fri, 15 Jan 2021 13:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w0FYbQbi/cnv9hM2bJgjlS+4DuOEl52JGRzKI/B535A=;
        b=R/owblsqyr+CAzpxey56oACKbPxELcQ9r4SrPQygQKSuyxmai04PKGyGleydUk+c5D
         dWbBJ56NezVm1zGzrJFSN+uIEc17LLNWeNL7dXZDY9kh2SAAN5gSwG5MA5LmnG5WMqdB
         BurdhSdzfwTeWBFA1YKSFfxdIE/f+06QI9G9BI9EL1Ic+EZjWAHIXHgXnv0mZ5liyxik
         9Mrv4uG792weNP7/0PpzonBn+9gaL77q4ItNE/iNP7d38EGtdNI+p6LSfNKqY8iAnST5
         DSF5XKueLX+F6RCIkJF0p6IfsZ18TAdR4oaxyLTsLuq15ZjFtXp81hwgEeZASSLoi/ma
         a3HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=w0FYbQbi/cnv9hM2bJgjlS+4DuOEl52JGRzKI/B535A=;
        b=XP8rQf2GV15TPpj64ubIGVrZ9eacC7Fyq+2+7P5LSeonBhhqbVUu6jYczD4GC6o6T/
         fpJ9cMs2ImZN+ZENfE8xCE5MCzjHx5Gue5H6d9aIP0s2k7Hfe9ah+FuNhB583q9JquPY
         nouhsTxu0Xk6WZ1YSGI09YkGAljl06EfYLihKQZWpPFqQEHSIvrRR/XyLA1LCkBWdqNf
         HbOrJEc03iPNivBRSm9XOGfxCbaU9NgdEBAzcKrO3bG9k9sDdM8iQbB7E6mNMlFm5T9V
         vdk6knVNTCwr7ryRnLfEHb/lF2F2WRX4Lrs8tJFyg1v5sgV4n/9tJaS6asV0AHFaa7/e
         7Tfw==
X-Gm-Message-State: AOAM532pC0VcymbSaCkFOCzUenDkdFqtpsYEKACKJlThbfMm+mxT4mqC
        e7fCM7mcBLj3dzOZOUI/yOw=
X-Google-Smtp-Source: ABdhPJyyX1Krj+zmlNX8CopkI9w0YESs+WFRTXxnjHJ/MEO+cB95gdMFKKt54r+j+h+BqNlV17THcg==
X-Received: by 2002:aca:c1d6:: with SMTP id r205mr6977844oif.37.1610745524916;
        Fri, 15 Jan 2021 13:18:44 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a52sm2102898otc.46.2021.01.15.13.18.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Jan 2021 13:18:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Jan 2021 13:18:42 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/43] 4.19.168-rc1 review
Message-ID: <20210115211842.GD128727@roeck-us.net>
References: <20210115121957.037407908@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 01:27:30PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.168 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
