Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC5E457F9F
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 17:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbhKTQz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 11:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhKTQz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 11:55:29 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE67C061574;
        Sat, 20 Nov 2021 08:52:25 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id be32so28174914oib.11;
        Sat, 20 Nov 2021 08:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AkKwR2XODDVfHtfwQDAEOIUTOw6NLseXdpqXezl3GRk=;
        b=YnnoejXlo5n39roBr7t1QLfNxT1NIev0g/CwfbMjKY6YD1N86lrFk/yabMYmtgPnNu
         LTfiWDetHKhKaw6iQdVe+Aw1sZOcPk2uyPBUu2bCrAPLgC1FItYpSY63BjO4QB8J7Kia
         autXjz/OhkQMRH3szxTe1Jp4SW8ecXURWUjeN8AvXEUiDyGDFoTsEKsFl+je8Skhmg0q
         3+gH90KSFcpPzoUVThr2XXImXlXtrEj+dndvzJNE4X3ulWfwYFL+NoOzCm4ozN0oT/03
         ZFEmmYiSwG+wUey1VLZE4hk8h1VFk1nwcWiruu84//xf2Ud7zTq6UUrGVfAyK0Aw5Ggx
         F6HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=AkKwR2XODDVfHtfwQDAEOIUTOw6NLseXdpqXezl3GRk=;
        b=2tJhJXyPFXP2Ov+s6nyt0gVj4J4ngiDaybbnTf0w5lVewqudQJwmU8ijG9e8vV+x8R
         YviLPo7sz2TQQiwSdoWWeg5bQhPeDM+s94o42aBXS1V30jRtT0PdJdb8gjhPt5erE+DL
         oQvakkVa+9RX/tzComg4yHbt2m5tplpUJ0D3CSpzyLq2t4EudzPa/22w7PWTgtYq2CUW
         GTVEn0azOi0KiQI/HMRmJ2MaeEGCg8U1F8RoCf8ylUGTVfs4ux5nAEGiK/t/WUphfyQo
         yLVvfOZOgZGqGco475TM/04eSNdSfARCxrdY0UtJYtpO6OJWvtd2F4zs9tUDccSnnff2
         ey0w==
X-Gm-Message-State: AOAM533qQSQlGO8QQMwQRvaRCC6uvgW6n7KWziOJexySGNlOOO1OpN5e
        V6mK4pMXh6yMIx1G7fmOt7E=
X-Google-Smtp-Source: ABdhPJy3HT3pc2AzA3uzv7SoaXYO+5PDdFGaF2B9x8KyfkHAF/UWJ1SXdSzSdcOEGCpEMAgXYio9kw==
X-Received: by 2002:a05:6808:5c1:: with SMTP id d1mr8501670oij.141.1637427145014;
        Sat, 20 Nov 2021 08:52:25 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y1sm658693otu.58.2021.11.20.08.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 08:52:24 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 20 Nov 2021 08:52:22 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/15] 5.14.21-rc1 review
Message-ID: <20211120165222.GA1237134@roeck-us.net>
References: <20211119171443.724340448@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119171443.724340448@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 06:38:33PM +0100, Greg Kroah-Hartman wrote:
> --------------------
> 
> Note, this will be the LAST 5.14.y kernel release.  After this one it
> will be marked end-of-life.  Please move to the 5.15.y tree at this
> point in time.
> 
> --------------------
> 
> This is the start of the stable review cycle for the 5.14.21 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.

Build results:
total: 154 pass: 154 fail: 0
Qemu test results:
total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
