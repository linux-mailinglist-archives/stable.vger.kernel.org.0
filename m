Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D316D613
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 22:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfGRUzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 16:55:07 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41784 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRUzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 16:55:06 -0400
Received: by mail-io1-f66.google.com with SMTP id j5so49693859ioj.8;
        Thu, 18 Jul 2019 13:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2lHvCLHsVCIqQeBhGfBlVgWdPAk01p9AcqlSJ4fZdDg=;
        b=tY5mTvi0v8MkXwTv/P+m5ZI+EmMJRSXze9zzDfp2ScagUylxPKJCEyO3PA7A2bZr0G
         2XYBkb1AdBtf++CiFRD/q9/UUHHxERwzpqprO2Arlw72FrZ1pDsJcIPOOxUcXuCPriDN
         UsUTXPJjiOy/JgAgfW5fQ/PYbon9lH2auzOKHOofIbr/eWgvGpNUfRoCNCdTw1KnVJOQ
         s8hGjzY75MnU+aHAy/yt9BBob4ghwKfENx2F44KeWIscxmIKLGt/bUKW2sU2XSYU4mpt
         X1+z9rBLFb6OFSG1d6flOeqmuVu04PuJCVXtFpMFaeNSMntni/Tq/bpHF53tVDXoZ/Zd
         m4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2lHvCLHsVCIqQeBhGfBlVgWdPAk01p9AcqlSJ4fZdDg=;
        b=uZjw7FbU6x9qmGvyh53K0f1/aEtIY4P5n/r9JM4xKU5ps/Q599zk42+gMqioye9342
         DchLLQBL8TPz7ZZen4zyYOXkKx7+u9JpSQeGDC5vLoZLEh/JOs2EhRb91LNlvIBlH/+O
         8xv5/FlnF/uU5dGdUyvKTWMkByVNQLB1/GfGmpgIWOn3xxdJvevfO6TAVJk57gbEoRbn
         7f6HRQiku9IUM1dKPWwj2lc8SkGYdSleZZGSklpL6m94xqfsyS4NXIKl2chi2q7sYz4y
         bmXPEY+ceIgdCt9AstWUD1RjqOwGsiBbkw7nQTijku7gfOpLcg+F2h2wUgpNFLpHX3aN
         0oOA==
X-Gm-Message-State: APjAAAWNfP9Tka3FxOQ7QHlVhtm9zl/m5Hu9Qo2vSxI3ez9zbS7deiRF
        IWwY/bpOhWTszTbNB2HmHR8=
X-Google-Smtp-Source: APXvYqwWJMPn1O6OYImPQF/nNomMHRLkkYUT7yn9aJUpxE32yRvcxQP5OYXSfVfTF9T3GezwAzpJYg==
X-Received: by 2002:a5d:8c97:: with SMTP id g23mr8471905ion.250.1563483306010;
        Thu, 18 Jul 2019 13:55:06 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id e26sm24082254iod.10.2019.07.18.13.55.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 13:55:05 -0700 (PDT)
Date:   Thu, 18 Jul 2019 14:55:03 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/80] 4.14.134-stable review
Message-ID: <20190718205503.GA6020@JATN>
References: <20190718030058.615992480@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:00:51PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.134 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.134-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted with no regressions on my system.

-Kelsey
