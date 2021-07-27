Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D04B3D7D00
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhG0SBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbhG0SBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:01:33 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAE6C061757;
        Tue, 27 Jul 2021 11:01:32 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c9so9423339qkc.13;
        Tue, 27 Jul 2021 11:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C9JFZTd7epxUdjz5mjCcqtw1DnTZsiEL+OlgWPM6KCc=;
        b=IoaADvWZXTGElquatyuM1cZEFGGGzZWpRqIIK6tB6ehOKJQWjnvwefzWttbet79vt9
         iN17kvEVk5WSVP95WOCNgJRMZZlc/VPPkR0Wtc1/SqzEfcHm8GpyR0sNE4gphc8qKqEA
         QVPlOfM+L38cbzRX1rMG6SCybdw7JZo/MBmDpyed28u48s1Qbs71x9NXU24AfrYSXIVE
         6mmVDqth3aNBkLsFCP8TzUDOOBSCoL8pRlCmTsCIV8sKiqAbugFcC3NHMVJlr4tWa1Kl
         r/0B3SI0ukZFWC26dHwnj8AItbtw25FbVZkfROBpvdVyZoOCSPi8MA3ycB3CVvLsWaJZ
         ZfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=C9JFZTd7epxUdjz5mjCcqtw1DnTZsiEL+OlgWPM6KCc=;
        b=Wok76ul1cdnKw4R2HqkidcNkgZQRO/wmKJwzG9BFfZja6dp4aS71/y249YvppBmz8r
         jCSg5FmiLpXnz/Z69HDTJ0Cwo948J9nCVwlWeqXvED/FcFPi1JVfWEKwbiEngPaIZ/Re
         rcRygunWGVmHFJb5XExxoR5qJA9lZuIez20LJdN9XjhQn9mhXF8IyvB6PIkd/SZTFCxu
         CRmKTb/8LmTkR6hI6cRqHTVtwm8qNrFjzuAL6tps16q4PVIwPMkynm//cE0CypgMwO36
         u5pE2Aj49AwHYZ6iqzpkOHpqEVjaNIeJeaEof/fBxWKGXQPkponG3OL9/LdQ7f9WFHUK
         h4gQ==
X-Gm-Message-State: AOAM530bJ6PYNK5n4Z8NOTcXOwTXUbo+ba8b4WCFVfqWKkKNnQv/IEA4
        gGweso9KvkzvQvnU30PSSj0=
X-Google-Smtp-Source: ABdhPJxI3C6Ng5zNwARRpt0d+yL94eDevch4mT+Lz+u/PqLpEMU8aatQCQOffxCIXWzWiwNiTSxihA==
X-Received: by 2002:a37:a3cd:: with SMTP id m196mr23548500qke.121.1627408891461;
        Tue, 27 Jul 2021 11:01:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n5sm2134436qkp.116.2021.07.27.11.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:01:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Jul 2021 11:01:29 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/119] 4.19.199-rc3 review
Message-ID: <20210727180129.GD1721083@roeck-us.net>
References: <20210727112108.341674321@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727112108.341674321@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 01:21:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.199 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Jul 2021 11:20:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
