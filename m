Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4619D304C06
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbhAZV7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391665AbhAZT1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 14:27:19 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491F2C061756;
        Tue, 26 Jan 2021 11:26:39 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id p5so19687748oif.7;
        Tue, 26 Jan 2021 11:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wgrz1dPVKupkhL+Fml0W2YtS2FbtQoFf8uzy5Hj48uU=;
        b=iEVPSohBydLz3bStc1ZClm1h6Gn4rAkU1H06ctzRhy2XlqNjMEe7MWeTaNeGDU2z/+
         8NPXuWniMeG9Rj8yVks108hYQAom/t/XvsJ/80bvyj8bVESkSRfNrtdT0N1o58k8RgVd
         6dSPYrRMu5zIP27ozm4OLxsSShyMKmZSqlD1WJBV6iDYYedbUAU+C2lqQXuS/rXS3UWN
         G3g2W1QtS7lQ4XgGiF87VKM/E+lRM7oPWxiE2ZSVBxsfNcpWmNCOJ91SUNK+MW7/dPIQ
         XT1BmC9Hp0yjvgp7iippUHPo6Ylknxed3eevYctPcDkitOFRCTtlnkZsyRB1EsfW30pC
         vIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=wgrz1dPVKupkhL+Fml0W2YtS2FbtQoFf8uzy5Hj48uU=;
        b=bLby1/uyA4szozUUs/0aHoaM9aZ39vhCSrdDDCf4VB654XskTNZud8eIXGjc1qLXnZ
         1hZCiPXk+iSoFqoSC5nPCpMa3nPQT02PNgsrbFpRD21qhlctQO9Ap+oR8RM3NQS23Rme
         KrwYFx1mx3jci6CK+cd6MCGeKa5Om0EC1H+35JVySmhwkxWWtzizwtRvsqYxxiYUBdLx
         XzM8snQTi9PBuJ8VWKLoOoHyPFRvqsZMoei+L24iJ8Y5nbLeSYnLtZGCKuNvmAaXVLQy
         4Hn7oj0XJTdy8yMJLh6lf456dtKO7/7m++MRx7Fhm+tyudQ3SZWfCKPVIVQGJA/+dz4x
         jkgw==
X-Gm-Message-State: AOAM533jfZGLSF9CqpcWSiLXQn6k4ded783NqHaHtRZ7mUyQRJmr4wOe
        bAliknxL4OmeoAjWZIGJabs=
X-Google-Smtp-Source: ABdhPJwIMYElqNmp6NnlP+XEpLUr098DzGBrpNErAsFBsO7guo5f3v+8lwMQsN285f/vjVv/3YT1Pw==
X-Received: by 2002:aca:180b:: with SMTP id h11mr819225oih.18.1611689198104;
        Tue, 26 Jan 2021 11:26:38 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m15sm4284985otl.11.2021.01.26.11.26.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Jan 2021 11:26:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Jan 2021 11:26:36 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/87] 5.4.93-rc3 review
Message-ID: <20210126192636.GB31936@roeck-us.net>
References: <20210126111748.320806573@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126111748.320806573@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 12:22:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.93 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Jan 2021 11:17:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
