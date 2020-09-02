Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CA325B1FA
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 18:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgIBQqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 12:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgIBQqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 12:46:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FFBC061244;
        Wed,  2 Sep 2020 09:46:44 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y6so8641plk.10;
        Wed, 02 Sep 2020 09:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0ZMMy6wqvXj9OuVy4nyvAWN+OkctrTdFBpA34bYM/So=;
        b=IZ9wWGRYyjx80i8MI7iuEIzDtlNuzMcLC8Pdell3Qhp9837z0Cx554sukao2YgWprl
         s4vMbH+0l4HH/Q4mt5MWR701T4Kr2IsHe7v4bPSsp67lPIK+srus6PuYp7Wz4W+LjNM6
         /0ArZhcVUcg+FT5mZ8PmYl4oIv+woJVXC4U0sWBCnLSgG64z1+WxWwsz8uMzzA8DSG0d
         jtPdO9jS0OzuqCY8LFTMVTnGifPkZUdAl4k4B/bLVM8dqyeGldUR61l27369qb7ws1g+
         m7zKOrOBC87+sG63Ndhb7eNS4/y0YGDRcIy9N0wUmaN+Gq58ExTGeHun5VpeBS+0n+pw
         nWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=0ZMMy6wqvXj9OuVy4nyvAWN+OkctrTdFBpA34bYM/So=;
        b=g+g9IAf/EJycsDVUL3UjDK7jvYbajKA/emcSQD96sJc681MUjchEslRivxKnTKRdjm
         5fZV4zUcNFDSbEcvXqYlk9waOHHkErxK8V7BnNUGK0ph5KxAI16SPCfHQ9lJ2IhwUUm4
         d9J1UvbAmgihm5fajNGfT6py+cULhX6EvlKMFOaQcFmo9Ttj12xp7KkcM3c5hIWwIKeZ
         y2ogvzQ2pia3G7+OCb55hIsRuDgWYOdw2rZt24XMRetd0ic4isOJGA2CIvyqBWjL5Dbt
         XrQNjqzjFHNqnAT4s2XkerEalFl75bLI2Ao4ODGLOhHFmSvzpdnY0vLYt1dAPdL7dd/2
         zi+Q==
X-Gm-Message-State: AOAM531f3L/dMm6L882jn+PZMMO43jLO1iVb/QCJWUfBcwWd+VRm/Kae
        lJocIxof2pGy0NLI6MgvrZs=
X-Google-Smtp-Source: ABdhPJyOVlSE7hFjKu97fxQdq9B3e5Q+ryVGrIiu4WxsUI9jViDUgvWOiqCF01T2HL7tH9DZl5NCPg==
X-Received: by 2002:a17:90a:f407:: with SMTP id ch7mr2931105pjb.142.1599065203864;
        Wed, 02 Sep 2020 09:46:43 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 25sm11773pfj.73.2020.09.02.09.46.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 02 Sep 2020 09:46:43 -0700 (PDT)
Date:   Wed, 2 Sep 2020 09:46:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/91] 4.14.196-rc1 review
Message-ID: <20200902164642.GC56237@roeck-us.net>
References: <20200901150928.096174795@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 05:09:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.196 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
