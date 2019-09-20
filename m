Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A940B974B
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 20:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392655AbfITShJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 14:37:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42425 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389097AbfITShJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 14:37:09 -0400
Received: by mail-pf1-f196.google.com with SMTP id q12so5059373pff.9;
        Fri, 20 Sep 2019 11:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7M8oYQqc60rYrCzWz8Z+oBQTjw/qULJOJ5IToaUVfhM=;
        b=K1CleYy5dMYvToYevYNJWDfGBfWS7LjSfhKM0vmWSYt7BMwgnr77CJLcv4ItiGZiOX
         C1LLLK1iy9MlG3x5grUHx8pbBegtY9JEBN+U8K903IJDu2ZPqx5SE4QmYGEmZW7nnNYu
         7hzf/RCSL+p5TUg/2WWZoI75V7yMGeRjFjrkEeoQleRV4abdTzX1uNzq2UlLq36+hlOc
         cqUQacyUandBkD9u+wuNaii1y/xxJ9fZ9MurIw/R+5Gnpwz/E8k7JQIrSUi4qzOc6nT9
         oCI45syQRAO5h6wLNEJ+eAsoCxXCHZd/cTeTd8D50jjm8+CaTSWxLkrFrTbrt50/T9MU
         wPHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7M8oYQqc60rYrCzWz8Z+oBQTjw/qULJOJ5IToaUVfhM=;
        b=cfCRaznAA0HZ7GMHQxE5beV7A1K6iuYlWwFwxIKVZkh3WCSUgJNMEjvQY9b8F40V8U
         kG+B4ZZ6D/ODsQDIxApKEyM59T7/gmMgEdFMXFLgWZsTGhnqaO8WuXwNyPuQ8oi2hMoO
         yT67XzE8cAtdWEybwS2tF/R90sZKkmZXHumdwQWbkwDiVm1/Ue3kie/vyqL2K4RJDccn
         L1n1nCzMxfZvsP9duSpV30E4XuPBSW7XLK7FyJA3leyiJw9fJv8zKgnNnWUqVIGUxEjH
         f3sCezJ/zOxtu44qiW+ok+22HWFtUEJdLK894mhLQoXxi0Ssr2PMyrX0JNnx0KYh1CoR
         kYIQ==
X-Gm-Message-State: APjAAAUoxV741PKlh0J8M3v+yQ5+L0qHhkaz8y2OFeIVl2PLx3Wutnt9
        QXlO6TF8qRuSxRseRjcfNe4=
X-Google-Smtp-Source: APXvYqwv7VIaND+VELuxPSFBcejFgBdLWfe6JVOvr+dsBBP/TQ+d/f/1oc53Wi73VpkkcXYeEkx22w==
X-Received: by 2002:a63:682:: with SMTP id 124mr16443819pgg.102.1569004628419;
        Fri, 20 Sep 2019 11:37:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t13sm2986173pfe.69.2019.09.20.11.37.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Sep 2019 11:37:07 -0700 (PDT)
Date:   Fri, 20 Sep 2019 11:37:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/79] 4.19.75-stable review
Message-ID: <20190920183706.GB22818@roeck-us.net>
References: <20190919214807.612593061@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 12:02:45AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.75 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
