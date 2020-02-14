Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6AD15F001
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388769AbgBNRwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:52:04 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53046 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388660AbgBNP6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 10:58:42 -0500
Received: by mail-pj1-f65.google.com with SMTP id ep11so4050185pjb.2
        for <stable@vger.kernel.org>; Fri, 14 Feb 2020 07:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cISYdBXk2YHE0Hv5QeEUFIegtZb+aZP3D0K2PcFOxv0=;
        b=Wm9qOazSsBZqOW7bBRLJEkqORGDUsQVeYt23qm28055nc0seZE/6WvXTJ4ukn44RRS
         4sSlU44l7wArk/bgum3DqF5VvVRIzFSECMBntydVeAEtu9Wrj9Vqw0qnFJ5ngo+/u6IE
         wY3Q3qkaW6DOsmktiKfHxZSFzB54Z36SD8n+bQu88+CVA9TMr8q+gI5KNQSiE/CDWHew
         FO/GChYLjoOevw9YhiDOlQKk9r4cchbIe4BHKZuOBoXBKzOJPxdtLFfU3Q0XhJVe9hXT
         KUJNehz7NNMcSIqxbYBlqhBX2lXhwW4btQqe5UA9eB41aXFQ9iisFJNMM/dW7fvUET3o
         4BXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cISYdBXk2YHE0Hv5QeEUFIegtZb+aZP3D0K2PcFOxv0=;
        b=AGEFkpjWNfvQuTQiRhK5DGao/I5cc8zTULEgM2X1k5tZvcJKVM32FTYYI+4z5wXbjR
         XdRFrD7iKQps7o5MibjgjbWa6yFujK0meIi6VXC2aZqpg5iL9GfsAlBD8Ae7ye1qsNqN
         7qHUYq1wI6rnYtRReFky1JMYx/z+r7Ole6T6paMC5uqNZmvHZ366h/fL8X6hGz7OhRMv
         qwapwSsqwNCYb6nrG2PDSKxyBY5gt7tC2yN9nk3ScPjhmQpe88prZY6whd8UqDqWqfHZ
         0lPddCyPBrsfv8leXemq7X0UxcllmEMFsADOWBxBapjeACOqvrqTXcOhyWt2qkprX7ts
         pplA==
X-Gm-Message-State: APjAAAXzODO5iipYo5albuqoHPN7UVqO+xbqpwZA6WGS2zkrhUoUMvGJ
        CKK7dtEJUmVnNweipy0Qbsg+1g==
X-Google-Smtp-Source: APXvYqxwlJ0m6uM/kOjvrdm0keDywJW1dC1Cj1dLQ436kTE9gW8qeoO/r+EEjwjLZXI4sbqhe3ZUFg==
X-Received: by 2002:a17:902:7c02:: with SMTP id x2mr4126952pll.60.1581695921762;
        Fri, 14 Feb 2020 07:58:41 -0800 (PST)
Received: from debian ([122.164.201.151])
        by smtp.gmail.com with ESMTPSA id t11sm7016598pjo.21.2020.02.14.07.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 07:58:41 -0800 (PST)
Date:   Fri, 14 Feb 2020 21:28:34 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.5 000/120] 5.5.4-stable review
Message-ID: <20200214155834.GA6389@debian>
References: <20200213151901.039700531@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 07:19:56AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.4 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 

hello,

compiled and booted 5.5.4-rc1+ . No new errors according to "dmesg -l err"


--
software engineer
rajagiri school of engineering and technology
