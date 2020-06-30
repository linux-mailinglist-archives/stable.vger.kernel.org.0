Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627CA20FA74
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 19:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390265AbgF3RW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 13:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387782AbgF3RW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 13:22:26 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24F5C061755;
        Tue, 30 Jun 2020 10:22:25 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b92so9759541pjc.4;
        Tue, 30 Jun 2020 10:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F2lf+CvZXzo41EGYppN4I1uDWhlvk6K8xTySOyupCtg=;
        b=oUdTvk82VenNNZ0aDoTBUftLEIjravG25OfHcmo2hM//D2rwatLutN0pfJwNaWH2pC
         MCCUlZyv9EcW69uIfsLt3BEqBGdWDD4GRZMiJf2NNQux7enocZqY7PLO97HZ2pzVq93O
         9b0+LEEEpRjRXg9kmQQNpHpeFGFX0kW3rHWtupkadJK+AVsNcn02Xkjrevr+WCISMK2q
         ieL2q8rPGq97SUut79PevpqjxVWAVIvAIwCDmD6eWgPf+EmVmS56A4qOCYuDxM5dHeW1
         MdvvV4jGLpWQwjeuM3L/UIxreZsoeKZoAOQxfaCbyX1svt/6dmlE+IQn8uFkx5Dm0vB1
         V27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=F2lf+CvZXzo41EGYppN4I1uDWhlvk6K8xTySOyupCtg=;
        b=h60idGHHO9dUqKH3uUWVd+CiCuyxHbK2xnbN9H1CcjUUhCCiikkg8lWcy1QdNdbGYw
         JDtNqdIO7EQ0D+bSPNg0EPX+xzK/6Nq+0VU7Weq+T2697q9UIYLMqqB1oPRfGFIMgNEs
         LIVDk4Y2FYME8vGMoDy4+tdAzDBRHF6VE8ri2fRD1nhnCoKsBI4ZVNyyLM/l+DTgOYjn
         +E24kfaNqRvE2A0feP31C5mPi3RsNeYIM0CBOLjrdljXhqpg4tX5UkyvqvtcXSwYmOLl
         ppxtBAIWggRSbLN442p1+7VOIumCkNl8ysirzPNrUS2H+whmIzRSQx8C93U04l75YA0p
         6uRw==
X-Gm-Message-State: AOAM533Lm/tXryDvPoYK6xBn4I7KCEv1tvFrH0ZfkNw4t8rXaeQnA/IH
        H9ycfqd3qfHeVRIHijZuWUg=
X-Google-Smtp-Source: ABdhPJwewAGnE/23Zorupvu8LHq8fnUVKM27oWKy81Yg4w96clYRBk5brkjXuLeHLHShGqyT5ordOw==
X-Received: by 2002:a17:902:d20c:: with SMTP id t12mr18570714ply.291.1593537745601;
        Tue, 30 Jun 2020 10:22:25 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h8sm3165239pgm.16.2020.06.30.10.22.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Jun 2020 10:22:25 -0700 (PDT)
Date:   Tue, 30 Jun 2020 10:22:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.4 000/178] 5.4.50-rc1 review
Message-ID: <20200630172224.GE629@roeck-us.net>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 11:22:25AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.4.50 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 01 Jul 2020 03:25:02 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
