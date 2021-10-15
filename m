Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70A542FDD9
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 00:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243244AbhJOWJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 18:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238929AbhJOWJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 18:09:31 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47ACBC061762;
        Fri, 15 Oct 2021 15:07:24 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id o26-20020a4abe9a000000b002b74bffdef0so1964247oop.12;
        Fri, 15 Oct 2021 15:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eS8nHuHriNS5l6IN8PTWxa/Qc+6xmGafmB+qixDPI9s=;
        b=lJBJueFJOwJVKTCIolHk+n0wLeAROAduNFCVAOIHE4Qce8d5ZR/D3NeRhzGlsXauav
         TpEG4flMkndzhX9mIbayK9G7OyiTxPPWWUkSAW7myWE0XFPX1jfuf/SNH9rbQDb53b1J
         5s/TG4sOdWM0IhlQz4RhhGEJLQlTKO2Qp55VcVQlQxLGUOiciePIyerKlX5uI/oKXTfX
         ZsuwpALni/vapd/fvpdwDp+NC59uUMFYsia8gBJ8Aa+oMidz0aY47awv10ZOw3OEMvzF
         /ioqR+PTtAPQsa24YE2ipxRSXkqIyO2fG8nDShphXxsniBmlZnO1ScrNUYYv8ZvOZ9P6
         oMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=eS8nHuHriNS5l6IN8PTWxa/Qc+6xmGafmB+qixDPI9s=;
        b=jS1Upq55pPAFHF30eGcy3O6xBH0enZXy5hcgtx1l0+VKnlRtIQKsEzzpOG9Z6Dh6pj
         kgBZs5SeH9cUxXlZEh4R7sZsYEi6Fr1Wn6dRX27EHdF/sg38cAkDSHvZdrVoZQ7wWGnV
         Xa2Jcvy0UGSD9XJ4i8gS/DT3C1wpy51rEBMlOcxBvc6lCPCNgFYcJP9zG0ov2nurw69F
         LSwYMwvSrsrFcIcn+kVXIZq6N7r2dI7fmFS9chtj0ZHACc64T34wyVjZTnXyFXm891Hr
         zd02nOkOmxRqBdUWdDbKeNXw6L3QfFmx/4so4s4hkNUKK/LKP30KGW90XaZGooMICQ+L
         RAPw==
X-Gm-Message-State: AOAM533bqstkLqDRuebo749+I5DXzV6YkVameWbeExKPrE2GxItWWXoc
        /ziKBeISX24Kr05u7BA4AWE=
X-Google-Smtp-Source: ABdhPJx5E6UbozI8sMmBF5j329D5SHJ8hlb5KPUJ1JNj48+hxWSXjOjIJYbk2EhL9n0TAR0alsmrtg==
X-Received: by 2002:a4a:a68b:: with SMTP id f11mr11077512oom.16.1634335643667;
        Fri, 15 Oct 2021 15:07:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c9sm1440352otn.77.2021.10.15.15.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 15:07:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Oct 2021 15:07:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/22] 5.10.74-rc1 review
Message-ID: <20211015220721.GE1480361@roeck-us.net>
References: <20211014145207.979449962@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 14, 2021 at 04:54:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.74 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
