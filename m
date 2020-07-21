Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758282285CE
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgGUQgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 12:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbgGUQgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 12:36:25 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B3AC061794;
        Tue, 21 Jul 2020 09:36:25 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a23so9395060pfk.13;
        Tue, 21 Jul 2020 09:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=52rzyG1Drr5QC4Y31eZLh0zluoarWLduF0AH6jvK12k=;
        b=JN41PMVQGboDlgzvn9NN11ah0j49bkZVlnBrnlELbgetYJsJ5kYGccjX4w8PuWPLCV
         uiEjXGfgQvD/Pm+tfL+dtDp/Oon5kahATFrHWWRPJPejxFaztGbZnvQCQ/n/TeSdPCvL
         hZsZTdBwqtHfeaeWyYiErKiQWMjWFqcNS5pnNAjkrgIQPdPqC78TO7QZchXm3rJYAKxe
         zMVObNEI/o95gQ4IRQky5lawosj94wptSLYUWqTE0Ggqqg5L8CejZ5k5noT1TOmFa8iV
         w9DUEMml3JJpH3k5d2Ha2mFboPAgYy4idLjTSVRHAXOfGcn2mWGbhaBjQ2UTOB8UDmiE
         PTnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=52rzyG1Drr5QC4Y31eZLh0zluoarWLduF0AH6jvK12k=;
        b=erBxFMCY1D9s8wFiNybEuSpJImrdbQpeeV073c+jgJ7dFtABZN9zaQ8MMLhE67jciP
         BBw3lLrWw/alXkhkl7vorUbJtvCKFQBmjqzY2rn8rjJWFE5HXXzD06saUisgv7l9V0Gj
         GKwVzbomdJIRQJrGA21f061enZYVP/j8UvnkqVaeGYXg8g7QOlBf6JxsLzf/H0U+dBU/
         bVZmzyIHJvsc2Sp9eHeuFbnUoq889pTLgTUHDnkPOCAsDTbBH49Rw8tjRheRMKLq6qEf
         YB4NhYaWEKAYQ6YZBVHSFxpWcT395oAsPbFRkGNLN0/oGJVAQ57YgYyBrwFyNkZzKMLv
         MmUQ==
X-Gm-Message-State: AOAM530mNqoo7J40MOrxHqGHvlVj/aaeS4UncM0Hu7V0UTuGzhr34dDQ
        kDWbALX+qxqJCkQEil/NL/s=
X-Google-Smtp-Source: ABdhPJyA6AXybj1UmaA6oLcJ6j070WAmF/kwijaBXspRKyMNQ1+PKcGJNO/eWTwtIolBHofkIUbNgA==
X-Received: by 2002:aa7:9117:: with SMTP id 23mr24864613pfh.264.1595349384613;
        Tue, 21 Jul 2020 09:36:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d14sm3866736pjc.20.2020.07.21.09.36.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Jul 2020 09:36:23 -0700 (PDT)
Date:   Tue, 21 Jul 2020 09:36:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/58] 4.4.231-rc1 review
Message-ID: <20200721163622.GA239562@roeck-us.net>
References: <20200720152747.127988571@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 05:36:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.231 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 169 pass: 169 fail: 0
Qemu test results:
	total: 332 pass: 332 fail: 0

Guenter
