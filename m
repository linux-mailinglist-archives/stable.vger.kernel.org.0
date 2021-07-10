Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053523C3686
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 21:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhGJTxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 15:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhGJTxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 15:53:24 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B71DC0613DD;
        Sat, 10 Jul 2021 12:50:39 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id h9so17463744oih.4;
        Sat, 10 Jul 2021 12:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dDHDQLHqvl675NRQwxJcNRD6r+onAVUXcdMxGa7YTew=;
        b=Isg3ogfLyVDKzwkUcfVMEGS5zOhUNN8ti7pY3go0BIq2Df3lcWRK7uLwoS6737t9Zn
         W5QzoGHnq/CGk5fd0hMpOY6nUM6zWiBg7/A6peaVlZJAtw66OepDLGzfj+55Ix4Fvdix
         NX51EsN7kiGPZ3ESs0WVU9NVHbgEdh72rQTQTy/lUgnw3F5S8BRuybfG3p9kW65yY0TS
         DYUjpxgjdYoHjcIHu1OUpuFzMOa4cAg/I1IdDmuLQyGdE1QIikbG0RTqxzF5hnphq5/e
         RdAxViAlDbPe3Y5RUtvr5ONFVW6/8CxNcgpYZQKAi7JyEfJQv31h7N1qezFOsYtT0vov
         IXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=dDHDQLHqvl675NRQwxJcNRD6r+onAVUXcdMxGa7YTew=;
        b=rEU9t0vx95pTrg/4JEstAiX2VEjcTxBXuAb2Jo9ndHIl72jRVIWGU/Nc06A51akT4n
         vYjaqBKBbanxPIHyYmcGYASsqenqoLjTRcRB7X4eWRCKKyTbiWWAWvKIVvswNapSkXTb
         glEGwaPM05LpC9P6pApLc4pE5HLrQaPZpeJot7WYSyYD6fJEnHp9ZcUbtLsLNMeestnz
         HXoH5EnJE6GjRHZ6MQwK1DL0fjg8eIcuVtdxd8HiNcagPexnM4aahVcEls0caFgewLjx
         1eO61S3gt+eUXtojqjylEQWdbp/+Jy/mzDPn4+EMdzAjuxdOCf3tjSGy6jn149ksHmAz
         Fz4w==
X-Gm-Message-State: AOAM531zlR3a5WByQoYiVLLNCpX3NXDhg/URX7AVZcEnRLRCGZyeIDE3
        LQ2GNSLi1rVumnAV4VVtcnM=
X-Google-Smtp-Source: ABdhPJyE9hXejbsYhPzQ+I4bPKGKX2+58z7/dUwqEYp0FtS9VrLiyMnMz5U4pbn15+N8IHE89X9ImQ==
X-Received: by 2002:a05:6808:f14:: with SMTP id m20mr4427987oiw.92.1625946638779;
        Sat, 10 Jul 2021 12:50:38 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t10sm1695300oor.48.2021.07.10.12.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 12:50:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 10 Jul 2021 12:50:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 0/4] 4.4.275-rc1 review
Message-ID: <20210710195036.GA2105551@roeck-us.net>
References: <20210709131529.395072769@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709131529.395072769@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 03:18:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.275 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 326 pass: 326 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
