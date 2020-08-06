Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C09123E19A
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 20:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgHFS6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 14:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFS6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 14:58:38 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D33CC061574;
        Thu,  6 Aug 2020 11:58:38 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j21so8705901pgi.9;
        Thu, 06 Aug 2020 11:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LIb8GF/LyA2U1VeQeCOMxjGQTs4l5POP7DKBb2uPh4w=;
        b=QMwlCPoenWeXSFUHMU4gVUImqIufTwh7WWJW56YZrYk24wLyTxRnDgrBYZGP9+k9dl
         MbyW49jgt7AAkAl87XddbsP5o52cGIzlXjrfaKxcbJX2ZwevMXMU9SPySR2tDS/cX/Pr
         cQtPo1RcDYVhdScrH0iRHsjY4rVx/bZWLzykk5K4jTJGcme3iYRbLyYeLInUyIKwiINi
         BMWAX66t3qYC7jjUrbF8R8DOzb7T18ax8M6kzx4RDO/wC2kTcNbynOSSjMZcKs2i2CAu
         BbeQZrx2itiwTzeZSlOlaQpwYH8K4jXAqXvGMQa/vR2kgUabSrVxXTPHAwnlUMLxqHJD
         Ry+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=LIb8GF/LyA2U1VeQeCOMxjGQTs4l5POP7DKBb2uPh4w=;
        b=e5iJrnnajfwqtIFJKPY96gRXdTr9bEDv1X0hiGTWh2Gds0a6gvuCXmJVY+el1M3Vl5
         g7FtKxUZ6uDsc+Z0BGbNKjcQ1Qp79e2mP9dtHSKGpmp79iKpU6M4CrxS6WIxSYQCljBU
         KRaE/S5M7xLuwjNh8LImDUq7br8Pj4XRQCaJxDZBAkTy6678exK+RxBjQtXAZb0wQtna
         pZpPtqJNc/gyxPbdiMTjUMEsDuxgPVkKQedXUvagWH6HZCDH2SGGvGSFm+GdWMBce1Un
         pwA8l34MvZ8Ja91LXuwp43h2gwem8wDRv7YTnEysBuPH+bSvpHHGUsdRnYYxoR+O4tHS
         BqYQ==
X-Gm-Message-State: AOAM5334trioUfT3TqrnHyiU4wdZotPzENeLvV0Rz33FWI048KbM2slp
        R4smk0Mr6yTcDhqdsvjtjjY=
X-Google-Smtp-Source: ABdhPJwMYLhqFWj/k4ZbeKwKV5LRj4bjjY3PYEwwJ12TBKzbYAepwH8dkLaZKpq1WGeX2deK+WMDiA==
X-Received: by 2002:a63:5160:: with SMTP id r32mr3964424pgl.112.1596740317900;
        Thu, 06 Aug 2020 11:58:37 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o10sm7843701pjo.55.2020.08.06.11.58.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Aug 2020 11:58:37 -0700 (PDT)
Date:   Thu, 6 Aug 2020 11:58:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 0/7] 5.7.14-rc2 review
Message-ID: <20200806185836.GD236944@roeck-us.net>
References: <20200805195916.183355405@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805195916.183355405@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 09:59:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.14 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Aug 2020 19:59:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
