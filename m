Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9001FCF47
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 16:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFQOQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 10:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgFQOQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 10:16:36 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B554C06174E;
        Wed, 17 Jun 2020 07:16:36 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id v11so1343995pgb.6;
        Wed, 17 Jun 2020 07:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1jrJ01mnojnEAomNxQCPzA0d3ZlyaYYOZjdx8HDbjY0=;
        b=oC695+tt69/rbg8R+PgmEvpcRxEymrNxUf14pAnrGv7ecLMZUGP9E2dKy8WJdC7o20
         wZiqu6B77EfZ/VxF1SLascVAA8E7iq0fgndPwGzE02dB4z1pVVDuQ5/zeXV0MsSgr8mf
         +DJfXdIIS9U+72UA1V8SYQRrsSrmO0iRlf815sXB4p5ynzQlXloixBdsxZU9ZCr+2Abx
         yID7rCt5OLgwxaSGS9jXXKvxxB+kzX8607BfLQJi79jTyjYFy/Ct7dcFO493oltFdhMx
         UrdClzamiAs3p5TxgEAf+ijciv+4pLeT4G1B23GZYtBp4BPPAcvdCHyxU4xg57it6lq1
         2GFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=1jrJ01mnojnEAomNxQCPzA0d3ZlyaYYOZjdx8HDbjY0=;
        b=AUI/9vUKaR5yEAGFClexx+nHtNi/xz+dTXaVTUyNRzppypD2VMctv+8fIp3mTtdCvy
         Ii0F0pWWmx9TqFl7dnljRRu2kxIt8P9fNbc9yEx4sXokoJVVMjHyf6iMr/WHE2O+MNQA
         Mi3vZ+WrOeIKHwrLGGMV9+/RP8CA/mP5gdbDGuGZKSgZKRqZgWK/11/9iUmYvmUA07mv
         irSOARAuVL0eXvUho1Wn5VD1aJPZxPI3qaS1V/4P5wpU2AkFHA6+6rb6NE4nUrA+bGNC
         GXCV+LP06Guy9xGPiZPvKPeRhj9snAzveH0onR76+geu/vptR7MTaEjVZywxOK3RkN3r
         X7DQ==
X-Gm-Message-State: AOAM533+jkW6fYZubiFpMJRW3G+kw3FkvpYTYGroBto1xjFFIKwaC+Cd
        fyGHpofpkw5EY64c4OuRZUM=
X-Google-Smtp-Source: ABdhPJxcgRI665YKaSXn7nuBYaeOQPDRKNGesy3yYUzqRmfZaFJ7VqHhnJY9mODQVN0ouYdGSxrZTQ==
X-Received: by 2002:a63:7c5e:: with SMTP id l30mr6557476pgn.276.1592403396254;
        Wed, 17 Jun 2020 07:16:36 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q92sm451288pjh.12.2020.06.17.07.16.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jun 2020 07:16:35 -0700 (PDT)
Date:   Wed, 17 Jun 2020 07:16:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/162] 5.7.3-rc2 review
Message-ID: <20200617141634.GC93431@roeck-us.net>
References: <20200616172615.453746383@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616172615.453746383@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 07:27:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.3 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2020 17:25:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
