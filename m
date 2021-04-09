Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C8635A79A
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbhDIUIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbhDIUIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:08:52 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007FFC061762;
        Fri,  9 Apr 2021 13:08:38 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id k18so2073469oik.1;
        Fri, 09 Apr 2021 13:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CG2UeEaJfXnJjy0LHb/qb4hlUM0XA4EtT428lPQQj4I=;
        b=Pnb9xOMsEko05SVqNNTRY3ot8YcJ0XdWmMedo+qz5m1kdEpWeffNYGFtSo1lqW6lST
         /dk1X3kG0d2vOMwbatSp6f/f5uKRbh7otyQSicYVgUMrGZuCWGi5Pe9WxNAS2JyVQfEC
         TSxi5M9OmOdOQrsWkgW4rtH6dibBGjO/iQXEwve1lfWz1+UNHAWeV523NV2438A4XK4/
         +K/XAmVhBDXZWZMSu6qXERjQpXMq4U+vUE1MjNlI99HvOeJ32jXISJm6s4CyaIQZvVIB
         FzYZUQB7AthPyJGcoAc53eq50AXQT0MfQIdTYnC6QZmaxlQClGbW7E7cUvLsDTQI1RSl
         GQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=CG2UeEaJfXnJjy0LHb/qb4hlUM0XA4EtT428lPQQj4I=;
        b=C/w+scSBov05S4sk861t3i5SMo0k4vYG8oUmDjNDq6nvvAhiqzYBLVYQ+0LAP15r9J
         H/kQjPtRATCKtGxB1uZ/asHLmwe9iGpNtzqBxd/yjscfe9LsaclCJRsUojFF7PJN5KUF
         IWSijuCD9ZfF+YioDbU02rK6j+S3FlEXlw+4CkeWwfId35tXDsrXSDmbmQXRACDk/R+i
         E8XkxRqhe+JS92AkTe4Y4enja8iTVCUIZ757ZrqFSntYKY/pjpE6/JBx6I6FQmeJLjfG
         gibcO66RlGjo+5tLIG1UiQYW8WFqfqbEwSiyKgXFJooj+vEWClxsysK/1SiJGUzJY4Ke
         JDfw==
X-Gm-Message-State: AOAM532XJgJRESUGlxKZ+kbftQWiejE5ETo3umGEmbSqrRODuSK0AQYc
        0fEf6bBii3We3xBCdUER6zc=
X-Google-Smtp-Source: ABdhPJx5HBTqP1gvd97fces7RKY3NB2VJdecRTmxbw8A8z45fb/bKEGNTsV6vV+Gbx6+XQesPdHvSw==
X-Received: by 2002:aca:df08:: with SMTP id w8mr11304188oig.126.1617998918457;
        Fri, 09 Apr 2021 13:08:38 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y2sm261524ooa.10.2021.04.09.13.08.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Apr 2021 13:08:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 9 Apr 2021 13:08:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/13] 4.9.266-rc1 review
Message-ID: <20210409200836.GB227412@roeck-us.net>
References: <20210409095259.624577828@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409095259.624577828@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 11:53:20AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.266 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
