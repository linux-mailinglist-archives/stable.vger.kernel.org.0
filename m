Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFCB5DA48
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 03:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfGCBHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 21:07:49 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42537 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbfGCBHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 21:07:48 -0400
Received: by mail-io1-f66.google.com with SMTP id u19so784448ior.9;
        Tue, 02 Jul 2019 18:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vLtFV7QdcKPiMrP0cqycBzD9PcFJ3VgNlGMx4ns+VN4=;
        b=EKHMxKvzvgGTNXwn/RBpbz6aIPmxjz3xQqiEf6ofrsoWvRfaX4SjLj18+5ZL2Byv2o
         3P5vZdXWBWg1r3QnYbgMIhCiTloWI9Ao7Xt9BiD3/0rlMJNWVZA/A7VqjsLcpTljrNYu
         4sJ/SXRzR5xb1oYT/qYHpIohRK4WHuK2SqWTzEPTL5oTdb2STMFMZCTGvALtCuUwEFNT
         xXRKkrfgx9+d4RTL2RC6mUR8+gSkQBB/zNr98tpGBREhAEorEsvFzklkmw1ssdfkH2Vp
         lYr4r2BgZ3bK4JWbzneA/PuzINBLUhsOPwTM3+bY52BjUQrJVrsncKI+P58blRrRlyIA
         Z0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vLtFV7QdcKPiMrP0cqycBzD9PcFJ3VgNlGMx4ns+VN4=;
        b=a+FiBEOkvL8h7c7xpRQAGX4MnkAWkm/QesNNO6cHLj75cCVdU6agddLbprru4zoo8x
         +I3QUQPoeWCbWu08WAbrk4x1wpj3nNg6OdkSzwAGZ9lxG+uNRgQYjZ20Ppt7/1PKMAAO
         NFAnBqcMXF/xkv6g63Ru4POD/f4b/TRhfRzmhZ1rXeiaCZsZs2JfjJP7DQvFtaDuJj8H
         PGSd0Yyw5eW1H20FaR3RJpO0plqF6dSr+JEf9xWMW7YeP86DznuWn2R60EChVHUKrCLc
         2sUA0XPWkzBQ1Fxmixo01PtjCxqnJSRpCXCP/j5S6IK9pT4sW1tE6IJCdlQGd5kdX4W0
         HPfg==
X-Gm-Message-State: APjAAAW8p5xskyF+MTAermB2IWPhC1D1JNlbRwhrskHhkZOZ/TA5IwZj
        TisWcLACf0UPvDu9Q3exjF4yK5SOGQUEMg==
X-Google-Smtp-Source: APXvYqwiCb0xm7iQRReoMsSVNFqrs90ckKeqF8zYFScw3R8LqDJuJm3bQ23aPAT4ifFGaqv3cYNmMg==
X-Received: by 2002:a5d:9bc6:: with SMTP id d6mr5061258ion.160.1562101850084;
        Tue, 02 Jul 2019 14:10:50 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id t5sm38951iol.55.2019.07.02.14.10.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 14:10:49 -0700 (PDT)
Date:   Tue, 2 Jul 2019 15:10:48 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/43] 4.14.132-stable review
Message-ID: <20190702211047.GC2368@JATN>
References: <20190702080123.904399496@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 10:01:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.132 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.132-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled, booted, and no regressions on my system.

Cheers,
Kelsey

