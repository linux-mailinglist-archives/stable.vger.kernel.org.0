Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB94390B71
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 23:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhEYV2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 17:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbhEYV2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 17:28:45 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358A3C061574;
        Tue, 25 May 2021 14:27:15 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id z3so31645585oib.5;
        Tue, 25 May 2021 14:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aRHZONKde4r8Wdfy+wGNtIGSNvdJ9+mf9WOYH/E0mZk=;
        b=ca/k2bY2zA2TDYmgS4bFwdkRDxEsuvHeDeE37VILdzOSxVGcQ9R/Jm7UmmO5vP2InV
         M43UbX3D4Ip2rOhaK7axjxOiQfbSIBNNSvUm3ftnrPMyWn0Vms+Y5hTYitbfvgx+NwnK
         Zd3C8JD4JbQnvLQ6vWsuyGBUL22egm2RmJVjvjiH7z6JM2nVNaJ/iNsg0NGkvQFcYJle
         D09+qwzRbgaPR43ORtPn6h6l9JnZDnp2ku0sbPYvQ3IHJT/9MV23RydAHE0G8epPWgWN
         OOwEmryh4k8dg1Z2d66BmnpprWjv5O+W404Ar2MnghP0cE1DiZ9k9lnHx6hamQRZIhxX
         jgpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=aRHZONKde4r8Wdfy+wGNtIGSNvdJ9+mf9WOYH/E0mZk=;
        b=GjEj+2GWTPVOHDj9WdY2HgSkymnEN+2rHMsJ5RX9Lf6+iYHJiG1m+ezdCo8CgYbEcV
         c/sBRAqVMC916PMixlv7BmCPvBLTgyixm0W/jcA37Biuaf0btN6EK6QcjxB2/ySTeKQg
         HH8K74CCYiiWhGUUhz/WTKuc530PgPSJjCGSdzU/BfLDxDRgIQFnrQ5KIZSynPHrYdSW
         yoy5xWnGhf5soIerRp6/1kj31n1GAHYJkddJ91vCo9yvAWeY8M+rfmgPEorKs7r8t9zj
         KTbdp6QJTL95OqFQIY+xQF+eGfnxCDRPLvgNhYHBdl9TwW52qMoJXGVBXL5LthDsFBIV
         lu4g==
X-Gm-Message-State: AOAM533R/WTMu4xQ3FVhKEMmydL3HmNCdbXiKGK8jQ8vnwMm+nglojOQ
        NnELEISYSamLrpbHKefSCXM=
X-Google-Smtp-Source: ABdhPJxNDQYMOLJ2Gk+4AUKhyQG8W3xqqNx6+HOUU9zVBZXpzxwkHlNxjEOQ+fjbXMBap5zOlKTYgA==
X-Received: by 2002:aca:f5c5:: with SMTP id t188mr15458202oih.25.1621978034630;
        Tue, 25 May 2021 14:27:14 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z9sm4061386oti.37.2021.05.25.14.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 14:27:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 25 May 2021 14:27:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/127] 5.12.7-rc1 review
Message-ID: <20210525212713.GG921026@roeck-us.net>
References: <20210524152334.857620285@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 05:25:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.7 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
