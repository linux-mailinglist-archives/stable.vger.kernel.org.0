Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5091B396AF
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 22:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbfFGUTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 16:19:18 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39569 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729482AbfFGUTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 16:19:18 -0400
Received: by mail-ot1-f66.google.com with SMTP id r21so3022044otq.6;
        Fri, 07 Jun 2019 13:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kF0tmcf4FmmtL8K1dOGyBR+41X7w1ud+CqhDS3uJjEo=;
        b=XZswRsbY0H61PsWRh+9xYhup0l2a15nOcU8S8/sZUSTxGcnuyyX6qJVYIL/sMJnm3W
         SVhoylqdvu+yEG4eJQRRM+LZgmslGdMKSCAyJK7h4JkRf2xg0vKF2VUDzlN7rWiBUDoL
         7AclwTIf/NZxwhwLF2mnQiRPv/vpT0OkKr56/QfOqWH5l8GPRRkixsyuODOmM+p4knCJ
         BPAiceO4343Tv+5XaZHAMGIh0qUQQxSWLyOvWPnQXl2EXLxsbC+7nLjm7Qe/+LSyUZf0
         bua2HIsRfUcjQlUdjm92uAg9f5ThuZTiPwRGTpSX9yQj3x/Bf1zCIy+NHBcCDMJKT6pi
         +YlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kF0tmcf4FmmtL8K1dOGyBR+41X7w1ud+CqhDS3uJjEo=;
        b=fnnmwEfMFbZObh9hyh/JspX4YNm8fe0uGrnKXCtBHrUIhvv9DGDobS/LknVmJsed3G
         dxqtACIUIrYHzK6ivAE5/7pmeBXUSreBO4skMxHzia3UAjMvLPLTo6F7ztMMTqPYcWpx
         1cJK3/98hIQ4xbuTh3xr3r0uABmDdxWRfU1cx9zOoL1nLT3Ph/PEQM0HptK5+BcuTnjj
         QeElLwPh4TAe+mVrMXdz/Y20AC5MxMQ+lBnH07IrH2qrNhN6Q67tc99HspPCtfIej9uW
         HfQYeNlexA4QeI4PIpmXYONB7n4Pc5o0yBUZ2/YL5ojFKOWIYCkYF/TNhv+p8r7o10cC
         bQfA==
X-Gm-Message-State: APjAAAXHkdWh/mDhYXYQ+WTfm2r1UJ1eQpUGMfosME5R4jBh7eqlBIho
        usrvrFzvwV/xMh2y1LJhmPU=
X-Google-Smtp-Source: APXvYqyqCjlw8sV6gwVwTFguJP1uZ5wRpA0bKh01kp3hm09dKwVt/FwB2cMARG7+b7oHLELGubb6Yw==
X-Received: by 2002:a9d:7745:: with SMTP id t5mr20087159otl.343.1559938757980;
        Fri, 07 Jun 2019 13:19:17 -0700 (PDT)
Received: from rYz3n ([2600:1700:210:3790::40])
        by smtp.gmail.com with ESMTPSA id f4sm1248352oih.39.2019.06.07.13.19.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 13:19:17 -0700 (PDT)
Date:   Fri, 7 Jun 2019 15:19:17 -0500
From:   Jiunn Chang <c0d1n61at3@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/85] 5.1.8-stable review
Message-ID: <20190607201916.soitroxwy7ji523d@rYz3n>
References: <20190607153849.101321647@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 05:38:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.8 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 09 Jun 2019 03:37:09 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

Compiled and booted.  No regessions on x86_64.

THX
