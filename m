Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0720313B1C2
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 19:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgANSOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 13:14:21 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37541 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANSOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 13:14:21 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so6961948pfn.4;
        Tue, 14 Jan 2020 10:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IkaLOQ3vGpDnLPLXbO8PKwjfKeCZnpWKJVvJP3P1NK4=;
        b=M7wQku+Vf+zSp8QzaHWXAychEckTzEPENnIRGy8fLIveUqYjwLTe13Q0v96516q8tT
         bmidfmPsk5JsCMMPGKs6FJDc7c+wGbBekpccpP2w23aqdVDo329oquAdeGfSrTIDb1px
         tqBp+Jriz/qhU5srNzaBY6voln50QTzRpSu39AYYG97riFKR7UxyfIBWvx5fICDU8p1x
         JKxENhPM9OmwHkZxQ49E2qME+NN5mjlT2It8qCuRMkuoQYkPyyDGUG+r15CiEqXHHB6A
         xHJ7inMgcdKnPpo8eL6EgT0uVDvE77agwUbHcBPjPXTANfJWfBtD5bHahs1VIWwqiGcs
         Vutw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=IkaLOQ3vGpDnLPLXbO8PKwjfKeCZnpWKJVvJP3P1NK4=;
        b=AcnXVr8folR/DCZvtzjGOhwgxbOXJvwi5BwL8wuwWIPkRUDCoVs6+tv+XOaNREpkP+
         MNFJP/cwyIBmBLl6wdnk0uvvetLnfoF7GgC+UyBxnnJ5i+xdVrBokpv5AfUiEffYhfe7
         u9okP9XSSJ/rwsXwwNmhmy8JpnVoEl5tRsjldZKlkEa04w3W9z23kLyTWf/b2bn00q0a
         DldBGVYicmtzaK9d5WsL5LmygJql8wgIOjZM7p8SxGfCXW5aBJfPY52e3ii4PTfJFjqV
         2ww+ViLa+/rX8SEFBe6qY1ptBvzvgYgads3rSB+kMs2i45mLWc9Yaf+3r8rNuXB8QEqW
         rGTA==
X-Gm-Message-State: APjAAAVQ80dE66YUpanvxyomsvJa5TQ7eKcY0vlvFADsBfsBUmrZm51N
        cgc8Dc6tN86e3D/UkLUJnFw=
X-Google-Smtp-Source: APXvYqzN4TDN+jboatk3ALPHlYJpoJkUNk9WAWCHIZVztE6jfKLgEctlYY8ZwFCdM3u4+BCO6AXBfA==
X-Received: by 2002:a63:1908:: with SMTP id z8mr28425288pgl.350.1579025660435;
        Tue, 14 Jan 2020 10:14:20 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z16sm19511367pff.125.2020.01.14.10.14.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jan 2020 10:14:19 -0800 (PST)
Date:   Tue, 14 Jan 2020 10:14:18 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/28] 4.4.210-stable review
Message-ID: <20200114181418.GA18872@roeck-us.net>
References: <20200114094336.845958665@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114094336.845958665@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 11:02:02AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.210 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 326 pass: 326 fail: 0

Guenter
