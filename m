Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105443015F9
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 15:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbhAWOgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 09:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbhAWOgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 09:36:43 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868E8C0613D6;
        Sat, 23 Jan 2021 06:36:03 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id r199so2162921oor.2;
        Sat, 23 Jan 2021 06:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=62YbK6sxiL9a7wX0QJ2VUfwwuvTcoj/mUseJuK68oXM=;
        b=ktUgO1G7mcGD1aiixWrWNZEoXMe1o2BiIOLLBCP40+6AAVfSwH+w/2L1zkVIwftJ0E
         hehVhCvE5XiNwPe1GOCT2QUcOg0zl45aJWPjTWqGpW5Z/RqjlU6SA9fKIYxTHk4tCT9x
         BvSO07w+qo4sf01EadiYdUzXviFkEg8YnRR7L0NWz6+3iLLL19CF2m0CmK2pV78nqBHB
         4RBK/4tNLTwo2Ies90VvCqc7OMEojQAYgjF0HcavinQwK/6O85T9hpPJYGFCCXktV6ne
         +tj7Xs1PAOSUS5pbiAlUIktvqT+ZCVyE0Z1QIXn6mJ96XgAcyAkeQnC3iVGI4ccuhVBd
         tzFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=62YbK6sxiL9a7wX0QJ2VUfwwuvTcoj/mUseJuK68oXM=;
        b=OFFK54xWKxGuv8Ot0gE88Cw/nypXPB/euDkVsL8PpxAyIVpVmC/1Ml+r0eXN3Xd1u2
         ttDuos77VW67naPijpIC6+epYvC4BEh1recoKl98La+5zgHGdVgSwmbf8fWNEzDqcHRy
         H4ZQQgzAw836jzwKC7lfXjwvQHVkviohURVQnz8LPT7NTlDKriGjv9T0EVsreqPfPlsl
         mLY4+GgTnwoHFdLfYnB84O4KGbajQd0uwDNDmI9f1LurKH21Q+AqeQ22Tv2jLvLG8cIx
         4BTrmKxl5WAL+7JDHHiEZhBFkdEyaLXoUVUpaS0J+RrS34Txa0O3Mw2FBgQ0LmHfwMel
         f0KA==
X-Gm-Message-State: AOAM532GxSd70ZqGG7ePiHizx4mAI/M9yRD6KpIydkKxHnuVsP1AY/3p
        2SI1O2EN2qfG3HCXyW82flI=
X-Google-Smtp-Source: ABdhPJxBFtfkIiHjdPNFqK32aLfmqGo66FLCZ291rE6E+30BJIj2JGPLTGZA2mVehqycIb+BM/6svQ==
X-Received: by 2002:a4a:d148:: with SMTP id o8mr7158665oor.16.1611412562957;
        Sat, 23 Jan 2021 06:36:02 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w129sm2340052oig.23.2021.01.23.06.36.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Jan 2021 06:36:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 23 Jan 2021 06:36:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/43] 5.10.10-rc1 review
Message-ID: <20210123143601.GE87927@roeck-us.net>
References: <20210122135735.652681690@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 03:12:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.10 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
