Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF872EF699
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 18:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbhAHRjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 12:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbhAHRjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 12:39:00 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E7AC0612FE;
        Fri,  8 Jan 2021 09:38:19 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id a109so10418753otc.1;
        Fri, 08 Jan 2021 09:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=um6t8M+o6HBwksZhHLbFxGpDJHWRcJuLFTb8HODxQF0=;
        b=cQhMalpXgOMSIebeLKx1EBHr70EIsaoy5iFSeQu663tMjwkb8dBFWgJ3D09l3LPHbD
         8+5UKMg0u7wOullqDmwKqwtonBDR7hIlJhRqP5iD9n5xcBVa1wmVHD1+AuAFIAfWBGes
         gA7V6JKNQCHoLboqhg10AId2KO2Y/1magXK/4ztwurWLKxkBqzD08UURYHIVH6bDtabw
         uF0fkXdqbB3miaNTKX6Vq6N2vH0ycn+xuqqMqDSSBR1DzqEWjNBm4BxsgndCsy2VxAqp
         tG3CKYejA2X2jUmJdYAv0R7cMTrq7gZb/m3zsfFHbFrdDFYRVVb5PD77yQv3Z9Z5ZAvr
         K5Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=um6t8M+o6HBwksZhHLbFxGpDJHWRcJuLFTb8HODxQF0=;
        b=tTnLOjJiQ/PoGIC78PDtzYPor7td9mxX9PqWNlA92SJORrNE8KAYhvCFEdTTktLY+M
         OBEZ1e51nMqQ4Zqcihqf40bCQo08CEYBGXv3RxyxQD7QEBslYF6sAUg1sm7It+Dj2NKr
         /bUG7DK7SdCmrmGMiwAps3+7j44ANU96v14Bs1yVh1X7EsZJNlA5CMritpAQQh7UZtu4
         2JmEMxlv9GgyTxgj8AvgQ087hFAZm/65krZKjz7Hs1VgbquNnkj6uMzI+yO8f9LAOs0x
         IJsjBWgdJb+ihQL5fCIjCT7D53KsUlKfXkg0OPtdnRErXxcSJuLeEGC7VKjKJAr2iTuw
         KbGw==
X-Gm-Message-State: AOAM533cdQrv+J6N4hcGCDbzGd9Ao9nSS5aJpO+ZqX97bpEMT8w1u3iv
        IzwW2VRdsTkbSjtA6Yn4cxg=
X-Google-Smtp-Source: ABdhPJz5bH21PcA2vTjiGWAzpuNRvDrJtcplbOLpfr/t5PoTPnyT2jdYXi78jE2W5aE66HHJKNLPBA==
X-Received: by 2002:a05:6830:20d7:: with SMTP id z23mr3414046otq.116.1610127499319;
        Fri, 08 Jan 2021 09:38:19 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h7sm1902354otq.21.2021.01.08.09.38.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Jan 2021 09:38:18 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Jan 2021 09:38:17 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/33] 4.9.250-rc2 review
Message-ID: <20210108173817.GB4528@roeck-us.net>
References: <20210107143053.692614974@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107143053.692614974@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 03:31:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.250 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
