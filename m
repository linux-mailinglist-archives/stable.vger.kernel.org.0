Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3B31C2659
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 16:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgEBO42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 10:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgEBO41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 May 2020 10:56:27 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73027C061A0C;
        Sat,  2 May 2020 07:56:26 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s8so6063165pgq.1;
        Sat, 02 May 2020 07:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pRzpvXFQfpUu4prjLhXlIFLNHHLLgPpIym14GUmh3+U=;
        b=nBBCRJ+mlSxQHoebej92vDI6BN7SxomaatpdArKMdyaOxDhCJiACO5g3SX1Gj5kCYo
         OtopLThJ5kgxqAKHxjspnImrD/OxamF0R3LB/8Fjfo06H8xgPo6qwAoCh5imSpWi0wvC
         xspUP9bvyw8Lrh/qhN2hgQff/bJaGuZfALu9bD3nNsRzcBacpvjVGs1Vivx4G+g+L/Uj
         woMmvDZi9uPwipbE7SpoDndsu7hb52qLpG/vmNom+cV/ST8SbtF/rXVEylivtZhjegVa
         AZbR4Qi5lkKk5D/2blckBz5YdPexIxII9N4W25cCCRpuH4RModb2/b4Dr3O4RHq1poX5
         0OYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=pRzpvXFQfpUu4prjLhXlIFLNHHLLgPpIym14GUmh3+U=;
        b=N0YOFHiPSJuYnqccbHtdEWklDILo7pKrrLoeHwTmkmzzONvy3Y1h6MbIdsVigBhFCl
         NKSBcG0SexXIgWRud8+3jJY6Z77MRdA924JisrNEJ/Ro6wYKNjgmi/0cBm0eVZ4c9/C6
         0BQg+wDunBXvv49ipQeDFJHApMblzQuhzIQ07dJWXmuRhgDZWydiftXxjcxCc73D571C
         m4vmtToznZLX7R3fJ2p+LpHztb/ATlgYYvLsCEaS3Wp7C87bvtwQ9TOLbq+PBHoAX8MW
         N55StLlgiPngSp/A94drDxYu2aBvRjVYTLTj3JQldPKTfNPdI1zSQTMjL1g7Tx1VmxqA
         7kTw==
X-Gm-Message-State: AGi0PuZiGPBgF/UUYu18fUlkci2d8Ff9EvBAODYqdChWv2vFe/yAcr6D
        vNvyF3A9w1GZAtiUeUejLdM=
X-Google-Smtp-Source: APiQypJgtIianyD0LUyQMBj1vEaVZpf7uoVp8/LHFjJuC9VcEYFGgSfbwZHbQKeLPx8vsYFDPvxXXg==
X-Received: by 2002:a62:fc82:: with SMTP id e124mr9307789pfh.126.1588431386085;
        Sat, 02 May 2020 07:56:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d2sm3184829pfa.164.2020.05.02.07.56.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 02 May 2020 07:56:25 -0700 (PDT)
Date:   Sat, 2 May 2020 07:56:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/117] 4.14.178-rc2 review
Message-ID: <20200502145624.GC189389@roeck-us.net>
References: <20200502064301.079843206@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502064301.079843206@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 02, 2020 at 08:47:31AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.178 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 04 May 2020 06:40:34 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 405 pass: 405 fail: 0

Guenter
