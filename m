Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCB6387604
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 12:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239454AbhERKHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 06:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241178AbhERKHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 06:07:13 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C934C061573;
        Tue, 18 May 2021 03:05:55 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j14so7792240wrq.5;
        Tue, 18 May 2021 03:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V7Ti7WJ2nzXe+Bb1Ba5zI+FwxdjEmUUPP1pWWO8icL0=;
        b=putMerDYNwU75ozlSzEJU837uiljGtrInMJs2kcFOIbd3pxgjwgUZ73fEXSmBf/aTe
         uByfvyIdTjeD41f5LplMlQOVc7a7cDBqNbwP33HPXVuYWgPo5wTWfF9WEV3Rb94Vv4Y0
         tEQW+TNx9TtRBCajbcaomjhZ/jaznX+Wpo6iWPXlQWgAaS5FUL0fmJIFWp0l6LTIfj4N
         cgIKuWp8WjwunUJFKi6K7JBvSU0TJNzE7l/QPYCby6oHetjCBsQXIdy7s3mT3pFgh6Jz
         wCiAO7IrFq1GIm09elz8mcIiK1ciZ9spEdkE08CyCD+C1Zp/x3qUJQRTrFkn2QB+ZCxs
         mJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V7Ti7WJ2nzXe+Bb1Ba5zI+FwxdjEmUUPP1pWWO8icL0=;
        b=IhkVHEpAStTUiBCfSpqMaoKPrnszL8w5pximqtEIK5q9M+qL69wRjUhNOwZTvoTziK
         NbBZM9APqva169vio6Jyznyt7u6UXMXJuTTlO3k4JTMcOG22+koYMAnDAuxt9A6dO7sN
         Qrdpqc4Qhzv5EckF7wOCC7Igk9CuZJN8XEmUClfE2oze3nx86lFTfCnaD7wQL1kvdmUb
         uzJqqeDdvRaQk5Dm+QWBHhIqugKo9UW3BfZP8U+vQzCj3UhHglvfFMEhG43/D9SssaZd
         6Pek4gieHSfGyol8+8fm7bN8NmRYLZHYravwcBf0TC7XG5l62y8l9dq5Vf6dDxVy7wDC
         tWmw==
X-Gm-Message-State: AOAM531QYgpKIyfrEDCJZkz3TYmUjzsF0MeePCnUhkdbxUrnI4Guc6HC
        O7vgsoxrCOdq3h5NLnmolH4=
X-Google-Smtp-Source: ABdhPJypoRWlIeu39qDbHGvht2rMA4uoan8wqMbhAaYO1RN0jrCjtOn7AlMKv+AbKgRxZFwhyk+61g==
X-Received: by 2002:a5d:63c4:: with SMTP id c4mr5794672wrw.287.1621332354162;
        Tue, 18 May 2021 03:05:54 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id d3sm21317120wri.75.2021.05.18.03.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 03:05:53 -0700 (PDT)
Date:   Tue, 18 May 2021 11:05:51 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/141] 5.4.120-rc1 review
Message-ID: <YKORf9Xw1DAFmO4q@debian>
References: <20210517140242.729269392@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 17, 2021 at 04:00:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.120 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:20 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 65 configs -> no failure
arm (gcc version 11.1.1 20210430): 107 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

