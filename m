Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 591C767BEF
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 22:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfGMUjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 16:39:10 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33954 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbfGMUjK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 16:39:10 -0400
Received: by mail-lj1-f195.google.com with SMTP id p17so12530732ljg.1
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 13:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2hudEQHjzIIDaJX8IJzCoFevInejCk4mA2bRnNn7T+k=;
        b=QNH1SvgeDg0zOoNZErxPYHilcak6XtpCI9Wi+buNDLZzSAz2g4u/+52gWwsoJHk4Tk
         ioNhHHx7WbasGljUsDxPcN+4Cn22i75NuVF+EFAyLNiVJa2T+lbWALvIO3ecrwFGw6Fk
         EcY0LfbNX8wYOW37/VAOuW1FG0lv6GQBfVTkE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2hudEQHjzIIDaJX8IJzCoFevInejCk4mA2bRnNn7T+k=;
        b=rNHUDioae3zWTTh9vuLxwK7CIQU8TJSXC7zNfCoa55ZQLW4eDgu/8mtfzTzGntvNhw
         0H+MHSW87+aSaKJOKQYqrRvF12Jj3iT7N/LNQDbxngAQp1m1EPZ7LFJoPJ55kXzhASE/
         THPKNqO23Z6i+aL03xsVJSKJfFo6WQhs7/CfdnkDNjbWyeIgGSvxyq6o80/IdkSCrF3Q
         n2v7sdkcdB95CqmxTMIHhdzpW4W1Xuozqg27QOblPlzHV6HEIZx0ylTcrEWgWnH0qEIX
         IpV12XllcjQvVVNsmuDaDpmoyz9OySEd+4RkTRdiDwt6olzcE2IN8vbaGC3vC4JwLdpI
         +W9A==
X-Gm-Message-State: APjAAAX9kZh7kLOA+jzcKmp7F05WPzP0FIug2X7CadBGFdZYWGowT8ra
        VnayGFsUuSMwPutvuHQNg7wGwQ==
X-Google-Smtp-Source: APXvYqwyGbIK3PhfUJQ5rl2x2n1obAKiJkF5X364rlmrIWZbaJjQXawlTHxJtnHSLeokJWLKhYsC6A==
X-Received: by 2002:a2e:301a:: with SMTP id w26mr9321620ljw.76.1563050348306;
        Sat, 13 Jul 2019 13:39:08 -0700 (PDT)
Received: from luke-XPS-13 ([213.146.33.133])
        by smtp.gmail.com with ESMTPSA id d16sm2149165ljc.96.2019.07.13.13.39.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 13 Jul 2019 13:39:07 -0700 (PDT)
Date:   Sat, 13 Jul 2019 13:39:01 -0700
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/91] 4.19.59-stable review
Message-ID: <20190713203901.GB14762@luke-XPS-13>
References: <20190712121621.422224300@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 02:18:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.59 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.59-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my x86_64 system. No dmesg regressions. 

Thanks,

Luke
