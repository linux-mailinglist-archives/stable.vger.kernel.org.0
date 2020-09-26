Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26139279A6D
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 17:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgIZPn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 11:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZPn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Sep 2020 11:43:27 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E608EC0613CE;
        Sat, 26 Sep 2020 08:43:26 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id x69so6228258oia.8;
        Sat, 26 Sep 2020 08:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+SeT7wUN1TB/dvqKdvVk+ygBPhSXTlhLIxVtwsJf4bY=;
        b=OKZT44S9WCqHmvZqxw+DOsN/1fHlPLj4/N7aWlNKaec4vRJWeM/yeLdtaAFVNlFweT
         fZUMtQg5P2PtZhrEP8QCx2nmKnAwxbrlX1Kp3IE0MlNXj3V7mn7aIVZv5RFoYkLlXpTn
         LItEeA2K4201f3R/OpAKXDgcab7ysDCphOzIawh/8y4JPLiJVNyCBJm5mR91oLjGPllb
         QtfuUT031gV0jx6mVkAFkNMl5bEhnK7W0ziq2mNXJDQkwwxrtvqn55ueWzJCNyo0cTon
         YUyuwz77GZRL9bn/jjuZZhLSyqe00qU9u2YhLWLmI82vjc5b25P2i2iWBnS5RwkDwfuB
         Dfdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+SeT7wUN1TB/dvqKdvVk+ygBPhSXTlhLIxVtwsJf4bY=;
        b=LgPQJQ/B8pPue228E3/E4oFZK2VTXmGAl6Zanil5o2zwKaPvJ38jo8ZC/cfCvDOtsR
         BbNOKXr22SDI7lwI9NsWeTijJkCdnr9JcZyv5jFGvuS0coDHnr6BSIiq/unj2Zwmi4JX
         5bKawS/fa+3RaKOoq7n5pclUkdkRF+i9aym+hTiIIV1fc1oliskINyYhfOSwKTJAqcHH
         5ehQsHAj7hkr/ic5Aj8lJbQtK1UaJynnqcjeRCK34cWbTlvv/0Xv1lamVaQRLHtrjtTK
         V5ThCJOHTB/FJK7qqCZmDORA2nCf39m9cDq+gQmEp1AuNxj0Jiz48pUkg0uYhIm/fOMv
         54PA==
X-Gm-Message-State: AOAM530EV5bXBZsakVG9OFfOID7sNfT/evcizWn3AVi3cIwLThWji5o2
        HeGb/BB6KeNI6jK+GCqQa0g=
X-Google-Smtp-Source: ABdhPJzuZwbsZOfj+sf1UcxUGAf83FDev2mSlRpjY5Kq1NcfhA18O9XLVYHugjUbEriwfh8bch0A1A==
X-Received: by 2002:aca:4ec9:: with SMTP id c192mr1599984oib.2.1601135006336;
        Sat, 26 Sep 2020 08:43:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j34sm1489330otc.15.2020.09.26.08.43.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Sep 2020 08:43:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 26 Sep 2020 08:43:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/43] 5.4.68-rc1 review
Message-ID: <20200926154324.GB233060@roeck-us.net>
References: <20200925124723.575329814@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 25, 2020 at 02:48:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.68 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
