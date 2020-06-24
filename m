Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B7F2076FB
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404209AbgFXPOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404153AbgFXPOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:14:23 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E39C061573;
        Wed, 24 Jun 2020 08:14:23 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u8so1284874pje.4;
        Wed, 24 Jun 2020 08:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=d515eO6duXFStupTeGuNjUnQm1koisIuxY+/K7o72do=;
        b=IDxyoBn3kl/ClsV3jmX05cGnCY8T1p7Ta/HsP+sbHSOaOXIlgbn3LseCSPG/L9bJjj
         5cPDdBS9SnVHGE45s1Y39qgU6GH6LVMBKHRCLfiTCyVy71k6JdY121jlTVIDMjCxIG0P
         2I8aYWTtq6yxacfoG9U2bD8++ZsSsG6IaAqFo/WWllOae6yXwkfQXqDHWgkMOpEM4Umz
         tQUwUiO2RjxtKh7WulZscIbUGcKlFN12S3sMtJYdPYlkria0j5leq5TRxrU2YptY9qWe
         bVp3eoy57z0gBECP0ejMkhoMI6WKE//vD02iKmXbN2cRigMn36R19jdDWqTJUghv/7Cb
         SweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=d515eO6duXFStupTeGuNjUnQm1koisIuxY+/K7o72do=;
        b=EsSdZDsrFRg2WVoBmr/UzZ/lrKQHnXx2JrBTau/ma/5JWd0SFp0V4kyHGOQDvsO9Fj
         ow+lTy2MB8PhDI6eUwydTA7xywBk1NPDmtt8fvWt1kl7sPDTuePc5lK0IF3t6cxQXHzi
         sWJE6cS42qhbPudXClIBx0+eloUEbfIMVIQm5wuCPBT7zuPi7JthwdZdgUE4Ff5YxLA5
         lZFnf8M9xLsp+YwAgU3654bADIjhZ712lj2tiyV2xwV/cJrfTkk7t1bNWpUDoYhVGLcr
         YOZFeRVJm0BwowI0Anc8XpdcSlczLH0rvD8qrc3orZid8u8rL1S+adq4UiiwWe5LsNvy
         qw6w==
X-Gm-Message-State: AOAM533JkbQOB1+xRBhN/+3qP3qPslDjr1XvecT8Rl9+DsSlwb6eozjA
        7zq15QZIMCUpFJVR2HMV+Y4=
X-Google-Smtp-Source: ABdhPJyHWAz/oRabjNfVLLvZz/zfJEipRBFFfc735qRzo3RzYhSVy4VU38lkZV/q5Vzqe42LQvohAw==
X-Received: by 2002:a17:90a:39ce:: with SMTP id k14mr28663275pjf.39.1593011662735;
        Wed, 24 Jun 2020 08:14:22 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q6sm19965617pff.79.2020.06.24.08.14.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Jun 2020 08:14:22 -0700 (PDT)
Date:   Wed, 24 Jun 2020 08:14:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/311] 5.4.49-rc2 review
Message-ID: <20200624151421.GC54105@roeck-us.net>
References: <20200624055926.651441497@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624055926.651441497@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 08:10:19AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.49 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Jun 2020 05:58:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
