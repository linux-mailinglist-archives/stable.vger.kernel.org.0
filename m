Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004223A1D27
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFISwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:52:14 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:42717 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhFISwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 14:52:14 -0400
Received: by mail-oi1-f174.google.com with SMTP id s23so3697591oiw.9;
        Wed, 09 Jun 2021 11:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yOtPKNZ6kYpDXXCinHqgt6xSuEBl4ES+TxF9HV837Dk=;
        b=RlGqo0GQyV+ynXhh3Pr2YfUYpw+k/PCJfFl0pU9rRN7XtNa6vBSk71bWseVKPupdse
         c8dJ6K0Y9UpDnxdBpAom+qSjCJzsDf/iOVrl6T+FU+oRRUElxkJt8Tqnvn0zc3VQ5Xh1
         hbXufLQYj8eUL9m1p+cRx4j1p8e6Liua33XIe3kj8UUYD8OJUIyfwOAQx21x0ANi9Wzp
         zQSxMhmqQEfC9wA4Gn3zp+YAGE6/4WoCeJVcc1dxm3VoyVliACcbXD3l27aExTrlJpyD
         BJ+ru36lUARv+z0JzX7Q9UkgN+Y3p7aF72rkmVQDfTM8dPV0zA/Jc26SeE7rXdJQPwIC
         2sHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=yOtPKNZ6kYpDXXCinHqgt6xSuEBl4ES+TxF9HV837Dk=;
        b=VM+iIHkkymnnIdYI8jdCdrBBysxPkyFpptsuzmZE9DAUnYeiSvoSGy7GJf2qAiUNJi
         /K1JmKBeLreACv6KniqoZEVowbwz6Q+W9MuvgBsYXqzhHPtM2PGaZYgUGrSYUDlgQvF4
         TTPNgD0UCtEvkmSvp9hxf2v6Uxj7NvQ54jJLq4j1D/KqBw2tzQEq8ygGcmWZElS9lyD5
         +N1g+tXii2QdiaNt9FrfkrZ4GE7GV5bulh0VVlbPK4d4lKW+EbO0eOPvDZL2mlwRynjG
         SnpS+b9g4zQ7CJ9YkGxGOnGyGHn35oZjCLyfrcou4Dv1mhZzEDhVyDDam48EeTdq+E7+
         O4ZA==
X-Gm-Message-State: AOAM531GDhtqfTVDk0i0qcaH4bU93w1uJ4G4CfRP1N5ForDXKIdKVzmM
        19TSyrosJwC+/8X36n1UL/s=
X-Google-Smtp-Source: ABdhPJyVc5ZGFOPE+Ljb/Gj6wd+CAmsZPNJpA/5e9XUiR9WwFHgv+ghyHY9/e3mp/ZFYPQIvliwJTw==
X-Received: by 2002:aca:c046:: with SMTP id q67mr7581754oif.79.1623264559412;
        Wed, 09 Jun 2021 11:49:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l29sm161780ots.4.2021.06.09.11.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:49:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 9 Jun 2021 11:49:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/78] 5.4.125-rc1 review
Message-ID: <20210609184917.GE2531680@roeck-us.net>
References: <20210608175935.254388043@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 08:26:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.125 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
