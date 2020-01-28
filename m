Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C83C014BEF3
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 18:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgA1Rxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 12:53:30 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41419 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgA1Rxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 12:53:30 -0500
Received: by mail-yw1-f68.google.com with SMTP id l22so6888198ywc.8;
        Tue, 28 Jan 2020 09:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=vFyJr7I3RtKSi/+9bEd+9psaSCKsARUISp4FD57oPw4=;
        b=YigbInF9Zz9b1dZkO/S7Fh3wM6Xe3OOeyM0/WcjJ+nnAQWSNkNX5moBybOI55ElurM
         QKyXCahYel6ghz4Ifkn4VpJI094qeRFld7NvLofQMtDYbBrFUXupf2t0qFm7ejnMoXXi
         BDt6TxMFssN78amzMsxzubTEw8SldS/5yEnITymdMZEw12ErABXa+TXUhAx40mtXj7e/
         4jffcwRQE0AgYyJS69RFNG+EOXD7OPcN6Yt3wBmR93feFV6gKwA1qtrHD0u++nq0wuaF
         iR5QfLLgecFXjA/AZLi7AyPWYCrqDVgrEuXxLhxI4RAcdthvbDZRmMn/dvIuEhG4qXjT
         cWPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=vFyJr7I3RtKSi/+9bEd+9psaSCKsARUISp4FD57oPw4=;
        b=A0D04+d+MWDIuwAzAiZ6SM0h9dr1UV82qkuKtf8mlY/Xl4mhDbs4yxSZaOzLoksfh6
         WsRw8QL72H0wfNNXeGIsAisJ+mCL751Nv0KpLhWkMJxX0Vo+pI12eGKToS4V9tXN5Zco
         2XOpbI2et1Ezj7aLSIdTI1+tBQu37Yx4bhaCvfXYkqZ9Iv1hgcS9RiQ3ZAnpFycxEEVG
         1dSGPvD+8brF5vuKST3QWgaaI4JfGew0c0T3eVwj2H5f7ppy5L9yRbbFHl6U+lDVwL0S
         dJpWhX3FxSJTI+Vwq6Fp0S9OKn9J4zxWJRQGsaZkNHqf0dGmxead0NEsx6RMzxzvQjo1
         57zQ==
X-Gm-Message-State: APjAAAXpU1qwGvH4TrJH3FKM+8rSOUzOdzsOm2ZsutR4YEwFJ2tYNoQr
        WVBIsyhfCxVUxVGU/8jbHOo=
X-Google-Smtp-Source: APXvYqwonvPRpnR4JRS5z8YoULbG3+PT2//2Uhr6K0sqfhr39n32Z+gEA/6xB42XKPcpCastyoEPwg==
X-Received: by 2002:a0d:f844:: with SMTP id i65mr16236977ywf.341.1580234009762;
        Tue, 28 Jan 2020 09:53:29 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i127sm8423000ywe.65.2020.01.28.09.53.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 09:53:29 -0800 (PST)
Date:   Tue, 28 Jan 2020 09:53:23 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/271] 4.9.212-stable review
Message-ID: <20200128175323.GB8176@roeck-us.net>
References: <20200128135852.449088278@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 03:02:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.212 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
> 

v4.9.211-272-g8329c702312a:

arch/powerpc/kernel/cacheinfo.c: In function ‘cacheinfo_teardown’:
arch/powerpc/kernel/cacheinfo.c:875:2: error: implicit declaration of function ‘lockdep_assert_cpus_held’

Guenter
