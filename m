Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99847213C4
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 08:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfEQGeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 02:34:05 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37689 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbfEQGeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 02:34:05 -0400
Received: by mail-io1-f68.google.com with SMTP id u2so4623263ioc.4;
        Thu, 16 May 2019 23:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gM0dgMy3j04qEXEvFUzUZNI3t3+AhWnyFEXuULKmtXM=;
        b=uFIDH6nGPFL8W2iAnPYQgru/h4bJhEEN0veChSDUWztjNpmo7oO7YiAWBvlEgmLyGK
         kSUrU4CVpfeRfUHPEeTg3bTdbzedxJTyrGRkGSs1xDs3MzljpJTSzeUNj6JnL6duc139
         VlQ9ejL7RgR5gq5ECfJBXeutcvrJOBjQI4yWPPU0RQyc+b9H125nn/k5HCxHroiv7f+L
         91pkR2EcgdFUbQla6Xi8Stql1JBkdaPzoNrO458XYWaAIHX29mzKW/tuWosrrOxEyebu
         6eDwdEGk+NmnmzmecbbZtnoinamZIin1a0Qn7vtiG5ad0DyIKPNa/X9B984J4X2iqiMu
         8xDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gM0dgMy3j04qEXEvFUzUZNI3t3+AhWnyFEXuULKmtXM=;
        b=D5soYhF4T6GSQWbP+wDZ83zxG8DrnlDjbdxD40eW+bMJplpkyFwHjn3h2jed1vIuxN
         iNseShMFIzDGBiB4vMiuh9ml3O5pZHRlqCRTMEf5CL17P8yN7pYimZhlC4tjus+4KqWC
         vs4ly4QxZiaAMTE5LERqBpQIToE9Sea8FyIL8HKrFZ9OLA9/oHTASIhK1yT3N4c9ur3n
         7gm8K7VHg5yCF3ums1oQJjLydH0kqDapYYHxIavDML59M8HQy775QoXSg+8wLnZo90b3
         Ei/tR+iBFhbLDNF/+2I1V+inzshK65xSiDhuF1J7BeXOCxqF9tGpNBSDonJ1w7woHO+c
         NVQw==
X-Gm-Message-State: APjAAAURJOEVgnEaJY6qh+vIqSJzgJbTMAxnNrvp0P9k3b+MOUkDhTnJ
        uDJuaoy/IAuN17FxvqN1KKo=
X-Google-Smtp-Source: APXvYqwcEFq7tJpsX/GTn+kdUErvtXMI5avG7GlzEfks4Lb9S1stabjDoCRPfFqBWV5WEHbIg4g80w==
X-Received: by 2002:a6b:b415:: with SMTP id d21mr29019681iof.189.1558074844638;
        Thu, 16 May 2019 23:34:04 -0700 (PDT)
Received: from asus (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id s10sm2575455ioe.3.2019.05.16.23.34.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 May 2019 23:34:03 -0700 (PDT)
Date:   Fri, 17 May 2019 00:34:02 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/46] 5.1.3-stable review
Message-ID: <20190517063401.GB2378@asus>
References: <20190515090616.670410738@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 12:56:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.3 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:22 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted with no dmesg regressions on my system.

Cheers,
Kelsey

