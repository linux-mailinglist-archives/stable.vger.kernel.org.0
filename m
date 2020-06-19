Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5C3201EC0
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 01:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbgFSXqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 19:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728606AbgFSXqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 19:46:54 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD4DC06174E;
        Fri, 19 Jun 2020 16:46:53 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u8so4752165pje.4;
        Fri, 19 Jun 2020 16:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kykNxEO5Pn0x0l/ePrKlMC5zXxDCv55eOkqLr6cksq4=;
        b=q71yqXU7139Y5IS8IZwxVU1jUHDEuoh+Pbm53lmviWrRr/R7JiGpU4z8whk8mIox5g
         ty7kXtag0+SjImZr/1dCHbZXS5ij/87JKtopHt2cBerP83lf0BlDYEtPnS4PfeRjmqN0
         qSJOgg1JOrB5bSicv+AHkzvF5bD6zp+XF/41FzJRYbmrYHYhmiW757YCG01Dhwu5s+V/
         LO5B1/y1oeyU2zyG5NoRB8Dz668UNyodoVhuibqC5rhkPs3qV8WCJBgH+E3CMS7YQSpg
         u1bTJsCiSnJS7JCsrk0DC+1Jkbmw3E3JeDo07fX2a4UV9nqZCd2PL2M9EOSbgeLvFW/Z
         xkxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=kykNxEO5Pn0x0l/ePrKlMC5zXxDCv55eOkqLr6cksq4=;
        b=T95DRGHWcls/jvlhgAvvYOUcezcxVzO/f2ZZgr5NbyP6AwuI4547RSY59/aKLZwsUN
         TplU+GALBoeXruaGZ3c/pnftDfJp/zIpVWjsGP8/4Il52RcmyYAXl7WzJIaisPJ5TePG
         j6i1CInM/GNtNkgX7VrsNwtK4BRQKzqPUqLrPx+7jR+qtXsVeM18i5bdZHZcEqoTExbM
         1HyfOO7R2hIy0kpue8CqVz7PfEa48g39yy9460J7hU4HKmUchRQ6HfN8BgZTFkE6Tby8
         Cr5nKHlgGiRueNiuTOy32Zg4oleaIMwtBbia2FR+Px4QtXZv89Fl3Znw+RudHkUflzRo
         rvqQ==
X-Gm-Message-State: AOAM533AobtTpbfFy8kB9G3D5EoSBWGYapmm1CWNuTvV0x0Q9pFn/LUy
        LvkjRbihKNvnuv/pfYWaJnI=
X-Google-Smtp-Source: ABdhPJwsnwqKyCblk0qVJ+3T2RZFbplKsZAec//iz03rHhysKXEtD0MDeeqUyb7uJf1jszrCt0ap2g==
X-Received: by 2002:a17:902:b493:: with SMTP id y19mr9848747plr.186.1592610413391;
        Fri, 19 Jun 2020 16:46:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a63sm5468131pfd.111.2020.06.19.16.46.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jun 2020 16:46:53 -0700 (PDT)
Date:   Fri, 19 Jun 2020 16:46:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/190] 4.14.185-rc1 review
Message-ID: <20200619234652.GC153942@roeck-us.net>
References: <20200619141633.446429600@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 04:30:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.185 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Guenter
