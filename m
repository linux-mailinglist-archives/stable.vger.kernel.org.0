Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF67D34D98F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 23:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhC2Vca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 17:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbhC2VcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 17:32:19 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36E8C061574;
        Mon, 29 Mar 2021 14:32:18 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id a8so14434045oic.11;
        Mon, 29 Mar 2021 14:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/5+UKt1UWgczJsl3yXTV7/bHuAecQqZZjJ4ZxnCabRY=;
        b=iWS6OB6ajqxA6IzfQyoAX+2jeytMtKA6Uf+IVIewOAVmksDBEkFXWcAO0rdOAC8+wo
         NcmPHyX5I/LAXSohKHdsK7aeN79NAsNHfY6QKsIsv6WshMedw8qCUPzZrB2uQ5GKRIYA
         f7Sfh/BMBjtog1FUiPK93dzszaegqiE4vn79DQofVTCAbEE8MFAR4hIE20AWD5rNtaaV
         Z1G5bZfh6L44D/9FIKb7vA0knLh2qHjnG6Tt1l4QQc6TJ6E3tXi+pZPEf6NzlQkIbeOO
         fbPDKWRilaWbooavSR9dPXf1KVO/KzXh5fp5Zsd5hvcVKFz+za9DgupyTjI2nYY+nP92
         awEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=/5+UKt1UWgczJsl3yXTV7/bHuAecQqZZjJ4ZxnCabRY=;
        b=cSWnExJM0ucDb5BR7aVsYNWpG6Wp3A0SiSoOdujlfsGx8mIO5axvWvurcUN9Es8WIx
         QsOCqV9L8DWQ8OS/LT8d1P6NtkTPbv0L8bIeLVw4v6PzTFNSGv3Zrk8sIoiArEmjHSyh
         HqU8Dif85orjdsQWkA3Aq5JerlGtQMiCByhbhlh3tGoca0TEGtjYools7DOEpddCbACD
         LSBTZHakkcTsYmrMZeQI8qMUEJdQ641JbGmwmUfVty+Vh5pPKpv+W69+PwzsLmSnzVcx
         H58yXja5g+bxGUByWJKNBpbVKBtA3GwxKW1Ii7u0RtokU4nM/rH0+Sc/Qv68Jv/fyicI
         dIkQ==
X-Gm-Message-State: AOAM533jlESKm/rbuehiOgrVlnLvLAQjuT7eE2skkLF1G5xNSx4V05am
        DXdXotwyiXmkCQUxu2B93Ffujgo+4eY=
X-Google-Smtp-Source: ABdhPJxbPM6enGPD19xuW7IfGk38oOSlxavEM6hfVE6hU2Ym7iA6ykrDTbYOyI0YHWg06EcGFZlDFw==
X-Received: by 2002:a54:4590:: with SMTP id z16mr851528oib.40.1617053538210;
        Mon, 29 Mar 2021 14:32:18 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e4sm3640461oie.23.2021.03.29.14.32.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 14:32:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 29 Mar 2021 14:32:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/33] 4.4.264-rc1 review
Message-ID: <20210329213216.GA220164@roeck-us.net>
References: <20210329075605.290845195@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329075605.290845195@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 09:57:45AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.264 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
