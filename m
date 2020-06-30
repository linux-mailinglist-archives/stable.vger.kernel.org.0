Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDB020FA6D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 19:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390220AbgF3RV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 13:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388325AbgF3RV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 13:21:28 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D266C061755;
        Tue, 30 Jun 2020 10:21:28 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g67so9356243pgc.8;
        Tue, 30 Jun 2020 10:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=L0617XHrqC6MpH/h3Hi83it9OW/oPeD4tYhs3ErwU0g=;
        b=GIRPKyipYNNArKiRwOaT3z0BzsuNqnboFmoI9h+XzBvLFFWDMvjTX6vjxtThMp5FMU
         57gXKmpmyvECed2n0RwZ15h5XqDz0H0jjhRxtq7uVRYNauW0hH5w5s9k3hDfDHEeRhz5
         XpujekTcbHe2p/5DGWsVxVgU7SlUyNSJbHtkARj4G4C9npPlYQ9C4d2Zpa+EUM+L4wOd
         KPydOQzotBj1L8qJ9b0WqlBbisTCnduq3hISdORGTYgCsqIsJb5EWKmcaWXDM/HQImbB
         MD1fMuIz7lvdh2ZDF+j5UYasFuzxQMc0QZ6SOZDc3UKfXwvBYdoTqPlJCyOyPqv8HHJr
         OsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=L0617XHrqC6MpH/h3Hi83it9OW/oPeD4tYhs3ErwU0g=;
        b=MSpztse8X1ZkuTMYse+9WFnm2Lg4JlTyKRzLR4e9ISQ338JWj3M8vxl/rhZDefazar
         cHI6LII0l9dal+s7yb9+ixkfYIBr6U9H61wfXd0RLr9GuZQqQKQNOVMCq00f9dU/YFWG
         Iz5xRCHAg8gq/ANbOFShuLqKRPCaPgdV18GlNHQ2JlLGWP52ys0qGKg4ntBYNbyvqgzu
         6C96hd4hhaozl6OJ/2xipFFn8fGfbZgKoXaF32cHmyJKcNvK9lBUqNTo4cDudn3bL7jd
         ixMmJmocv37tQpGorrt8cKvtwHRX5o6A7BD02g0ofSzr+lQ5ucSg8fM17km7noMk3KJo
         ewnw==
X-Gm-Message-State: AOAM533cudD4y7Zw2IMmEu6yI1kMyVkxwk7nIvnI6Qqt7Sl9Jd0udHMM
        xtp9DudId0PzjhYj7Po7348=
X-Google-Smtp-Source: ABdhPJzP8bhzP3zZ7LAVHtOMGidgzyyApGLSOGmeoEScmdCYmCv6SimEtA7LHy6Yrtz2Rv/NfNkBOA==
X-Received: by 2002:a62:1ad6:: with SMTP id a205mr19496127pfa.109.1593537687932;
        Tue, 30 Jun 2020 10:21:27 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h6sm3184962pfo.123.2020.06.30.10.21.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Jun 2020 10:21:27 -0700 (PDT)
Date:   Tue, 30 Jun 2020 10:21:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.14 00/78] 4.14.186-rc1 review
Message-ID: <20200630172126.GC629@roeck-us.net>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 11:36:48AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.14.186 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 01 Jul 2020 03:38:04 PM UTC.
> Anything received after that time might be too late.
> 

For v4.14.186-78-g27e703a:

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Guenter
