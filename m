Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99BA4635A0
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 14:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhK3NmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 08:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhK3NmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 08:42:11 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC86C061574;
        Tue, 30 Nov 2021 05:38:52 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id c4so44484497wrd.9;
        Tue, 30 Nov 2021 05:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K8mP5TAS7JaLSQBB0OyAZaEHHalMAWxdT2nx3ZJkwG8=;
        b=kkCu7zgvx3brxbrhDfaSnqQKXLpxGmbjeo4fNvmLJhVaHrRibnBFhyqlLpLdEj3ytP
         0YtgrV3JrBsNDQiyRjQnAomAbu7W7zD0dMtVbqCow3c72rcwhQlTCAXl8mp9pPgqFk7B
         6tc6K1/TrdR7Dfz4054yFx+Iopkap2Mks7+g7IBmP1r90mZTkJ3igFCuUYiJ1+Jm8kNq
         YJ4J9EwvWZ/e8BgSy2Qxvxd+fZiG6Is8Y+fDDS8EUx4WUlV2bYVx2gQa0ExWT0msTM1A
         SRSpyeatOuebNshB3FSn/wIgBFDF/93bh4uuvX7vWCShT5s+BDINNBfNn8M7vWFpjIDj
         HoQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K8mP5TAS7JaLSQBB0OyAZaEHHalMAWxdT2nx3ZJkwG8=;
        b=ET94ykRQM04dPqz/nRULPopU6kHHa6K/ayBfTerMrVOIlC7bGzm5oG8jgDmyCJZSp3
         LdLn/VcLIqRLav40dUOE5LRcILtuYgEPM545cdQ7eufXWdE0juY5yhBjAY0BtTdLM4qL
         EBVBsR2btgYsq/3mGmtRkkl0JuykcEGlh71qnzEUp3cBuavt94W1uxM0MqhJEVLSykoV
         8vdxC39hyGHWyZm8Bbqbei72Rz8GPJ50rNIFTvHdbXi7rIKfH8XVvkUohxaEFOQ0RnO8
         8tjTCraZQqD9Dz7Jid/fXcSklPF5wBd/lCdj3y2w6iZOfvb6wENH2G3dmBAwBtD3JBPR
         Bx5w==
X-Gm-Message-State: AOAM533FXwzkwTvIcjVhugk7I+fuAZ082imDaMBaXtlKR2nODfi84agE
        e8FJEbg059dCqmIpLBq6t2RrYhi6Riw=
X-Google-Smtp-Source: ABdhPJx5joDaB9EYiUx0Qpsnde5lO14LKiax4gLb+qBq6wroWHgiO2zeK6k59BKggOJ/8zS6Ip0oNw==
X-Received: by 2002:a5d:6a47:: with SMTP id t7mr42401855wrw.367.1638279531128;
        Tue, 30 Nov 2021 05:38:51 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id r7sm16114610wrq.29.2021.11.30.05.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 05:38:50 -0800 (PST)
Date:   Tue, 30 Nov 2021 13:38:49 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/69] 4.19.219-rc1 review
Message-ID: <YaYpaekf7HWrZQj8@debian>
References: <20211129181703.670197996@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Nov 29, 2021 at 07:17:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.219 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 63 configs -> no failure
arm (gcc version 11.2.1 20211112): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/452


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

