Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07DF3B71C9
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 14:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhF2MNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 08:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbhF2MNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 08:13:32 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C4CC061760;
        Tue, 29 Jun 2021 05:11:05 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id j34so767644wms.5;
        Tue, 29 Jun 2021 05:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YqxtB5Y3V+92NvVntBozgvLmvEngSpBor7LRZm3A0pA=;
        b=Vbr0T0rkHysN1aHeH+lnk/2vgrze0i8uQHF55f3eTlXJ6XVN7XmiZigouxzfWrtpZT
         +mRbf8jbGfOZv4Ys9GTtRKhYUTAEQh/tItZaP8W1w70GXVuocODr1S1FFrMxUDlatwdR
         FW8rksuKCmrRqZ2Y4VvYB9bIeHSH10LJtQ99+aJ/Y3DZVW6BOGMdHvGne/wi6EfM1ynl
         LBJtaF613J0EWsm9cEmnzWK1yT12RrJjdy5AR/Vzhs2srLY2pmnfAQhb/1cF7GQakmRs
         OeIxBYmKac3eUf2GzK0n1OIVKBveVB7Al/iHcCBTU2DJxT6h4fXbECGEKncsYYPTlOei
         4goA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YqxtB5Y3V+92NvVntBozgvLmvEngSpBor7LRZm3A0pA=;
        b=Rosbussof2DoFaQg8EmztXlC55Q2fvtHphQZUAyfsjRfOIcQe7IXeP4wFH2nTqDiNk
         Te4TgiJL/iEb++mnGMVbAyBA0s+hutxCHXCmPm8VhxtQ47ercLvrs1XKjr/LBTxMMDd3
         o0GVjqMrHXA1OtbJduAFMb37Nievjw4Hh3XsD/IYJIDWnjtbQ5GD0yNQSGUl4Cc0g2Iv
         dKp8ry3oAxXOemk6n1vK793yA206beKuNAwGOFKWO/OyvKgJVsk82nzgBbzdh8E04tsz
         Nc/ahyFAm0hxEhg3SRFYIZ6XtYcyCRsA+QNprjfB+1lT8BSjoJys7Kns4W0JVYnc5Gh/
         rkXw==
X-Gm-Message-State: AOAM531RSpmd4/ufUVCwbA5Ncu2OIMZQsa5fxBMYTwgztDId3BBzBNlq
        Jta2CltwusxOt2ZNEcXU2vs=
X-Google-Smtp-Source: ABdhPJwN5Xetb0LdxXcWEMJrZ48/m9P/NWuNbeZ/mQ8dGvFNeICVapOaSF7YP5wEtTdqTfPIHRAotw==
X-Received: by 2002:a05:600c:4f07:: with SMTP id l7mr32535007wmq.50.1624968664136;
        Tue, 29 Jun 2021 05:11:04 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id p9sm5990437wrx.59.2021.06.29.05.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 05:11:03 -0700 (PDT)
Date:   Tue, 29 Jun 2021 13:11:01 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.19 000/109] 4.19.196-rc1 review
Message-ID: <YNsN1TljaCQkx+fS@debian>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Jun 28, 2021 at 10:31:16AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.19.196 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:32:48 PM UTC.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210615): 63 configs -> no failure
arm (gcc version 11.1.1 20210615): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210615): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
