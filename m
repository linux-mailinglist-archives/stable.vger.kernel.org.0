Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B81201EBE
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 01:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbgFSXqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 19:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728606AbgFSXqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 19:46:24 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89301C06174E;
        Fri, 19 Jun 2020 16:46:21 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y17so4583890plb.8;
        Fri, 19 Jun 2020 16:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=P7TO1D+dTNaA7Z/Ujr09zZXQoTTlJlGva3OpWYhX1V4=;
        b=luKB2FV2U0tgvDxyBsPgFLM5CJE954081IQAxpiZbboiGgln2LSxMk+FzmuiAx5klH
         tP2XDJfZIw3tnNQxcFTfdic/oImUdl67Oi/94jUUjZQcw4rrjCC+dOMYqlRrV/J2vTSk
         HUbByhYm2QxRltPOCGXjeSjOXk/9yg8BVO+YZHZxWQWb9NvDQ1MxPjVYP1DZUbZ2NFno
         6MFSCwV+NiKb8oGa+OCAnxO8RWY5ygTU++ktHUw0X8wvl4ryCfMI/BpG2OzTEl5SGUgc
         r+5Nl+ysxX0nZ8wo/SVvlR2UthLloiz1YbdwVPFpcuLNV4vgSgnf4LBypi2Phbqkp6QD
         9+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=P7TO1D+dTNaA7Z/Ujr09zZXQoTTlJlGva3OpWYhX1V4=;
        b=and5wYgZEqbGaRnltjmka5+GptA0giS8gzppQ7Fc201zdei8M4Xk502sIZ9WMKjQ5M
         kbnvkTL33fMaJaKZvCsl3pTGWXrINeP7Z0vbWp1k8YzR8dOlimA8xtFZztoAZq/N+uJ4
         +qFtYBYPc07Qldh3fferrwhQlqYcVXaALlWXksepcmoPIx1lOPNcpTISicbCo8h0ETO8
         6PaMyCTeLP122K4cUIEJcXp8gWc2E7q9VUP8jR3amgUsXG+UzrZ5cauu4xs4NjTddgtl
         TGGeu3P/n5UgWnBGJ800zgSbSfSwoOPNlZTKaofQnZAEDUgqv5FmM1md/Ardxqe+Q6ny
         Yp3w==
X-Gm-Message-State: AOAM530/vEFC5X8pmnuRfC6d4nhQH9PIfItG918uJtgb79hWEWL2nxt1
        N4IDYCZ1qLBHqXZtii+LHdpPSaK7
X-Google-Smtp-Source: ABdhPJwNlJhYbXFaZWJHJISUp9KiccyZcZB9Umjbp2hJQ/+RorVG4gRoqMN3F+foq9erVr5WrOSmrg==
X-Received: by 2002:a17:90b:4d06:: with SMTP id mw6mr6240639pjb.190.1592610381179;
        Fri, 19 Jun 2020 16:46:21 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u128sm6773226pfu.148.2020.06.19.16.46.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jun 2020 16:46:20 -0700 (PDT)
Date:   Fri, 19 Jun 2020 16:46:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/128] 4.9.228-rc1 review
Message-ID: <20200619234619.GB153942@roeck-us.net>
References: <20200619141620.148019466@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 04:31:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.228 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 169 fail: 2
Failed builds:
	powerpc:defconfig
	powerpc:allmodconfig
Qemu test results:
	total: 386 pass: 386 fail: 0

drivers/macintosh/windfarm_pm112.c: In function ‘create_cpu_loop’:
drivers/macintosh/windfarm_pm112.c:148:2: error: implicit declaration of function ‘kfree’

Guenter
