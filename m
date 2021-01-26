Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C040F304C07
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbhAZV7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388619AbhAZT1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 14:27:54 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78FEC06178C;
        Tue, 26 Jan 2021 11:27:00 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id p5so19689012oif.7;
        Tue, 26 Jan 2021 11:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8Skwbs4KMXDLD9sx7bGcpth+Ga5p0osnO58bXAdBRV8=;
        b=lRbfo6nsvIXYs0DTQdWuUAvK7r16gdVq5fbYk1Aump8cF/ntDHa8m2nUWXEuN5UpBt
         iaoWJKCYe+IR6wA9ajAMzGCnSkjemh8VfdcPsT/6hQD/zgFM8GCNQu/Hg1mHE/jKdgKC
         L0opwSF8gkDo2F7fgvSSzoYiBT9+s/SoI7jMouOY9RvRbPp8G1nSXGgEtNYILLfLy6g4
         c6ckZhffa1rA3iPYgXSCPt5C2ncUizTYjsDqpE7ps28BQbaXzdEwZPi3w60nxTxhwlrP
         m9MkYnZb9J8s//LiJMbNJOVkd4GwncIy1RG6chnGZ5nJYIp2e62sxrTr9HfFzliNk9vC
         qcJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8Skwbs4KMXDLD9sx7bGcpth+Ga5p0osnO58bXAdBRV8=;
        b=OTopnUs/SlGMA/TrcDYmJoTjewvjKiIrPnvfYcEEWRQl4KXqnhKvHR5b0gvtbpkFpD
         Bs3pkbG55Yj2D5Afu2c4nLK4fAnuzORhVsemIgzApMRW5fU+zQ2p//opcFPp3pMopE4f
         Q7NiFZ0FFqFZSG3VNGBaD1LZ4RjHGOn5rvWM4zO0n2PXkae7zYG4VxVf21D7s/WEYuS7
         eHnBUAir0aLdI3VASI4JXqYFWUKF9bWPa+uyxTsJaj5KsU3v8RDf0ok0zsKVe+2GHRPs
         DHwzkckc4PeI2Wv8VKPzEgD4fjMw4a6CqxsaSKsnz/I29BcfBJWLOQpW9tHB8zDUtFbs
         xmOA==
X-Gm-Message-State: AOAM530fzG3ZEdz/h7q9z403CLXcNTC5UMGzYjggX0qL2ke12c1wic7s
        I1oVUwagRkrF3F9GP/117Bg=
X-Google-Smtp-Source: ABdhPJz1rHLW1pF55lwBQpdk1fK32T/JVyqjwHBWySbbu9UW4ysZ+BEo/vzA3bHrf5IOCzPL/eF1kA==
X-Received: by 2002:aca:cc15:: with SMTP id c21mr782791oig.154.1611689220161;
        Tue, 26 Jan 2021 11:27:00 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s8sm2861494ood.39.2021.01.26.11.26.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Jan 2021 11:26:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Jan 2021 11:26:58 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/203] 5.10.11-rc2 review
Message-ID: <20210126192658.GC31936@roeck-us.net>
References: <20210126094313.589480033@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126094313.589480033@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 11:03:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.11 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Jan 2021 09:42:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
