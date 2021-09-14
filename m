Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13CC40B3F6
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 17:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhINP7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 11:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbhINP7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 11:59:06 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1A8C061574;
        Tue, 14 Sep 2021 08:57:48 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id e206-20020a4a55d7000000b00291379cb2baso4806563oob.9;
        Tue, 14 Sep 2021 08:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PIZHHdiPcvwwFxluJ6AJCH6oUS126Lg1WBvwhbI7rgI=;
        b=LGK0+ce86mgDiAANAON2YuMVxapGHhcKbK47zz6YFnTL18T2jAmW5Fbww9fON6/K2n
         kcrWG94GIdh+5ugSzz0AWtIwPtAMuE1IAKXWSn9jTV03ejFaUlDUmqdslMeVscagyoD/
         d8UyV0FIzbL2S15FdOEAoJJG+3N/i5SCeLRhcoJX8wAo+SuV+bqVEXWAZLfyx472I2pN
         erbBRVFUkaimLmYpVSgOhoYBqgkl+0abw6rrqg34VRM7nbhmSYFkOnBX2/c7KO9O+dpD
         tHH9/iMjlSVlai6RYhg8f+FrfOX/MJtHggVQWxkvjrsNxaf4cjUZViqlcKYZyxAy7BMW
         4few==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=PIZHHdiPcvwwFxluJ6AJCH6oUS126Lg1WBvwhbI7rgI=;
        b=W/Mc7YW+wFejqF3vkVRS04DeQYX0yndvco8SYPPfNiSgaY8pgBoYqe31DY4IU7dwHZ
         uooeiHvyd2rvgzmuR6I5w/7/8efVGhkete19R/K4azLhYU5YxLN2bJ3laOYgpaW92DG2
         qTdFDU1yjd/p+MjNyIe7Us4Io8Grbm/Dkx1WtyTY85cJ6otIQgdaf+Zl3DX0VzgHNG9H
         uqEKBmKxefRNdnk6W0LsxCegYKyNQPlyvHeBQbhDz7T6rZYo9CmM4oRf8tTIvZIAH1uE
         rJb4SZviJwk/o+cnEuWdjvlYgfAfCHgIkpDPi1pkw0Ga6KeY5XfndJXMlLjRtXNfNzJa
         dJ9A==
X-Gm-Message-State: AOAM530M71MzG6EGwVyiVcYI3rF4trxfdwHurNimyf1Am7XUXZLaLUWr
        koEkuqRWOcDeffcsUaUgFw8=
X-Google-Smtp-Source: ABdhPJzk5at1/XJMOtuNWRphuCxxcdiaH9T25gGl81jj6UeytjwFnk4yVlPRxOPw+qz2jVz9eNz5lw==
X-Received: by 2002:a4a:e942:: with SMTP id v2mr14706329ood.96.1631635068300;
        Tue, 14 Sep 2021 08:57:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a13sm2730044oos.4.2021.09.14.08.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 08:57:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 14 Sep 2021 08:57:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/334] 5.14.4-rc1 review
Message-ID: <20210914155746.GD4074868@roeck-us.net>
References: <20210913131113.390368911@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 03:10:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.4 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
