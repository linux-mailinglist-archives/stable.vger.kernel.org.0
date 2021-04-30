Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711C437038F
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 00:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhD3Wga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 18:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhD3Wga (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 18:36:30 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4D4C06174A;
        Fri, 30 Apr 2021 15:35:41 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id m9so59445853wrx.3;
        Fri, 30 Apr 2021 15:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k8/CPR1SQtlFQpLNUDP14fmqtgx55einIYItpasXTqg=;
        b=iG8SKKfONgy7uKrCADoMrZ2eDreAD/s4qQcQyOunygqgIE9uYA8o0KL6bkSwuNxrEp
         8Eb2Em4Sf5WI+45tlj3iagowuy/uSE5IDFZ5SekxcqaqFQadX9xgjvIsncp/t8thSWbI
         BuIsLXsmMv6XgfjwQlj5JcN8xSDYTMMHYKDsUuDZWsyafZ9jLCjArofVIVCDpBieqt0t
         odIo0E2G1avp/bZgjPCkOcDQJVMBygQpVit8HI9n4F4qEVn9WxgczzDJJitoPonPi3uH
         2NWjgCnAcuyiw8yz6f2/wC8qUMK1z+d4HRYe9B/KlKmsFBY5DQX0/coczTr+/GoLFBWA
         3P3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k8/CPR1SQtlFQpLNUDP14fmqtgx55einIYItpasXTqg=;
        b=XJeCqO+BgtuM0PgnoPLsQOkLnG6HonOVaUtSmM7Jy8t24XinlmX+gCQeIdKOs1Y2sZ
         ZumJFBTiqGaVpMHIAVNbzgo9BcduVI/6WtF6BHlT1SYA3HaUmSwneqElJs8cb1NZItAe
         M7uGHjfBgRUGFU3kFSYBFzG/9dAJ7hJS8b1Zd9vlh+W3XnhMFmVFDFFirQhEN+HaSBHV
         0e3ajLGnSk2uoPMYUxazhJo3fG4l6YvCxxSjkbiT3wJmxj817sqaRd8ZWlby17fXNVY5
         tG1Zz3cOqOSRRyzzaSEyyKvCYWVXo2zoXQGH0V/ZXPL8DSspizJsHzmgBAHltFlPI05k
         bsLA==
X-Gm-Message-State: AOAM530MSZHvSu7idvb4l8NqkzyWgMQWnSdoxxKLBjmNI7oYNnmuucja
        NHHNi/ldCpVQkUbQcvuCdCg=
X-Google-Smtp-Source: ABdhPJw1KaXz0C27H1d58N3hesq9rUoflPJQV3JocmKo80txGZBWBQuqHR/7dvmkUct5M1yzKl6eeQ==
X-Received: by 2002:adf:eb0a:: with SMTP id s10mr10124984wrn.6.1619822140327;
        Fri, 30 Apr 2021 15:35:40 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id h10sm3926309wrt.40.2021.04.30.15.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 15:35:39 -0700 (PDT)
Date:   Fri, 30 Apr 2021 23:35:38 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] 5.10.34-rc1 review
Message-ID: <YIyGOn7ucPFZf/dp@debian>
References: <20210430141910.473289618@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430141910.473289618@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Apr 30, 2021 at 04:20:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.34 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 63 configs -> no new failure
arm (gcc version 11.1.1 20210430): 105 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm: Booted on rpi3b. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
