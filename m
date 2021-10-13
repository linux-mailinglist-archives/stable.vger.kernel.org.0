Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8C742BCD5
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 12:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbhJMKcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 06:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239036AbhJMKcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 06:32:52 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50534C061570;
        Wed, 13 Oct 2021 03:30:49 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v17so6611306wrv.9;
        Wed, 13 Oct 2021 03:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zGInbL+PJQYpMOr1raJ7pJXi1nSy8DXAxDMHDzmS0O0=;
        b=DKFNzwr1Lo5R4tVSGHvmocdC2aoh8sgC9FiaMRgKEVcZfYoqAtcb/gGRZemltj/AhW
         w9K/wBsx3d1ex447aHR57z8USrwU8xJk/7ymQ1OF8YM7MiwgfSXqkIel9Jd6oujiWe9z
         C7kS19BYfweD4npCMLm+N7ydadMlFu/ugYCrFr6zEBndhxKNF48yMjNmNQw7HgQHET+i
         LVIq6TiGaI6gQr7iMiZRoNKk4K6oJ0+5yXsjaMq1fkzBdDbaN5UQqcQ+3q6EKDnJF7hA
         gRF0Nb7gAHKcea0aX14zDY/h7RnJ819lgNAuxXNPwnE5R6gru+BNPktJf8ZA4FZAsFLL
         AmbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zGInbL+PJQYpMOr1raJ7pJXi1nSy8DXAxDMHDzmS0O0=;
        b=sDxF0pqrxdip8JGRu6Fs0qZ8UShcvqbjg6inJxC+PRqhZ0TKxDoMrwwu3xLLBaufHe
         DHADNGVki0f12tXt+luFi8EhvJRPQT1uaIccTH/hf6EuOc/E7fwLacIYQlPa1Ou0pbXS
         dFGhnlNCJFHgdSFv0oTzSbT8G8/jA9o/5nNZjIt7sXUsgIVU+6CXSPsH5piNjZLxluS4
         qDLDjCycu+m6M34q87f4aTEqoILn88M5OM52j21ZXMyJEMTQfXLZ0edCfOBxO/FvXwRf
         5fLUJNkSrxNF9Kg11TozVTDIBm9WjRvefgtqw+pGkPFd50VkX0mixSyylfn/LyNExGs9
         MopQ==
X-Gm-Message-State: AOAM531ry925H3lZRFmc9kbnSofyILEMdnxdw0tWprjm0vxTZxyY9oem
        uwkYwGzFIT1c01jX0h/1tXM=
X-Google-Smtp-Source: ABdhPJw78G3tKjNnagGB2A04xXOmjJyJpJiq7bSBjovXQCwYfDfDJ7ykZSywcE3JmjM0XDrZbavkJA==
X-Received: by 2002:a5d:6d51:: with SMTP id k17mr28923969wri.233.1634121047691;
        Wed, 13 Oct 2021 03:30:47 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id u5sm13545527wrg.57.2021.10.13.03.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:30:47 -0700 (PDT)
Date:   Wed, 13 Oct 2021 11:30:45 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/27] 4.19.211-rc3 review
Message-ID: <YWa1VYf/wxJsKFbz@debian>
References: <20211012093340.313468813@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012093340.313468813@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Oct 12, 2021 at 11:36:57AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.211 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 63 configs -> no failure
arm (gcc version 11.2.1 20211012): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/252


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

