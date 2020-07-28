Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F1B23118C
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 20:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732244AbgG1SWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 14:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgG1SWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 14:22:53 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB78C061794;
        Tue, 28 Jul 2020 11:22:53 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m22so12434073pgv.9;
        Tue, 28 Jul 2020 11:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pUZa3+G3QTRLDkLLI7oy+ohhkxM+0p6KnzTMW9AYh34=;
        b=g9ykeq1U0ZKS/eKtpPNsgRl/3jhTrKGFoOM2tmeu99UWCwKEXWpe4nz3W80sUZxORB
         gBo68RcUt8DDmLyZYL+xyx0byz/DvVYUjtwwYhzFs/DdGO23HZWf8QJSQ3sqq/wamrdH
         w8h8upNQYxg7B/j6BIyURmhqsqJr0MjcdkpB4JGGSH4yxC93Yaooacy9/y0nUP30oLSs
         NJu0RKE8v+IEOwl0lFSKZ3biLNT/cmHBbscM7an/2y5BNUyCimdYgm6ciLau7G6yDRoA
         toRlG/Em7e95a86uDzLAKx9C18dfg/KQMq7mVt/FAlBR9d0NXPoMvU5gIbN1zVJTtY/i
         Xjaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=pUZa3+G3QTRLDkLLI7oy+ohhkxM+0p6KnzTMW9AYh34=;
        b=BzwtVEku+6GXmpgJpn/lQMtsEzjnK1pONhc57+qtQ3zX2rcVa4yt+ntRGDROLPyY0k
         sipXSepbwbyWx9CMekwbZ0578DUbyhkpKW0RAU351bYrRjQ5iRZfotxH+ss8wIYTtl8e
         nLXjZDozcjcKg061VdWuWg5dpRowS5mmp7+yYx/YS4c1yWRBWGdOCUaNyDUC/EPYryxP
         LL3TKL/d563cHp3Me33sQDadCrOVWC0Admz0G4svwKEYmgNIk6EOseK1OEy61Cwqrjkq
         AtpxqHCLWTCFTlEsCE882RKZHJYyZN5ximJflcp+MPp4MMeD8wIy3kt/tLIOHZ0RzEzG
         Q7vA==
X-Gm-Message-State: AOAM531iAIUjSKVxR9EHx+dD7oMNnuG5/67LOATQVF4r4IWQHpxe76h6
        vcPUsfWKjBOmh1347Zr14S0=
X-Google-Smtp-Source: ABdhPJy4ntNOExsT8yH2pQ+o1+b2QGeI7+rTRUXX6+kBk+y3WmDEMGvxS5ukfW9PNljlKOwEjFitZA==
X-Received: by 2002:a62:7b4e:: with SMTP id w75mr12395755pfc.130.1595960573118;
        Tue, 28 Jul 2020 11:22:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b8sm3903671pjd.5.2020.07.28.11.22.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jul 2020 11:22:51 -0700 (PDT)
Date:   Tue, 28 Jul 2020 11:22:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/64] 4.14.190-rc1 review
Message-ID: <20200728182250.GA183563@roeck-us.net>
References: <20200727134911.020675249@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727134911.020675249@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 04:03:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.190 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Guenter
