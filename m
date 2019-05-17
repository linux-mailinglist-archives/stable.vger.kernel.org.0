Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80941213C1
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 08:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfEQGdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 02:33:03 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:38578 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbfEQGdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 02:33:03 -0400
Received: by mail-it1-f195.google.com with SMTP id i63so10247677ita.3;
        Thu, 16 May 2019 23:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I6XGRwp+Dc9M8zI2ETBG/Sre5AGhZJfAsVgmhaFG05M=;
        b=GMduykPv6eI8shYSnXZOiT82hZQMC23TnercnCaYA/f8Mfm+fY2UEOlY20UhSLGFn3
         4PB7S7vV9sazR4mh9AxjRYJhrPJiXD/fKyv39rUDtJkEJ3cUipsI3NF1tWjiRQwjN96o
         gn24P0bBArld5YXTUtVUzQZ+hnmCjZsB88E+qqWwCvDnTd5aC+TKhJ1/QBSWFmWcDpvt
         KIF+43H2aIsuENO1xbKQSWcZ11pC7/0sL65wRjiecg1+m6tRucMlYwsmJ58HLimaWB0w
         9G3MZBa78ay2qOfZTESJQfMPiT0gIa/fLTYi21KzGLn3ACJGppPwKHoI2GXM20fYVu5W
         Xa8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I6XGRwp+Dc9M8zI2ETBG/Sre5AGhZJfAsVgmhaFG05M=;
        b=aIpL0fH3M0oIwDKZpOM7IezXxP1NYrKPj6X6zeVuS/P308tTCJVMu+QNmxL/uVum6/
         jhs7R6J9eOwkjj/EpF0V+KokdaZgUrMM0/sLGCUeTN2sje44oG+WeNIKQ7qXySObDlre
         eiZkZKHlZwQxVCZZ69ieu5fcTIydtZkw0FtI6zrY2lpfiGMHSVXNyVVVhpTCS36cp7QL
         SqpOAF0hAhsNLkNOUKHMmVPW/CtFwdDBd8+0YtNhR35c+th0Wkcr8XjlsMWqvWOv8bwm
         749mTcUFUwlU5zxotwbCxpyIyEXeM9BybHr30ZGWoNc0r5KhpiQWYiLNxB4y4YSnXB56
         ZUdw==
X-Gm-Message-State: APjAAAU9ZGlhlpeYfsrIc9bes9qoN37v9KO23kO1RlREW11S6e5phFn/
        Yjs9K10WEex7nQq6BjiSsW4ZCFPfejcjLQ==
X-Google-Smtp-Source: APXvYqw36mwoMV9a8ZQuF6j0qIMSNIEBAWSKLaKLUV//4LwuGtwYCXpNgZznA4fdEdE4lnH0ujsoPQ==
X-Received: by 2002:a02:c99a:: with SMTP id b26mr36647022jap.32.1558074782227;
        Thu, 16 May 2019 23:33:02 -0700 (PDT)
Received: from asus (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id l25sm2609438ioj.8.2019.05.16.23.33.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 May 2019 23:33:01 -0700 (PDT)
Date:   Fri, 17 May 2019 00:33:00 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/51] 4.9.177-stable review
Message-ID: <20190517063259.GA2378@asus>
References: <20190515090616.669619870@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 12:55:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.177 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:42 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.177-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted with no dmesg regressions on my system.

Cheers,
Kelsey

