Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D3940B73E
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhINSzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhINSzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:55:25 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1CCC061574;
        Tue, 14 Sep 2021 11:54:07 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 196-20020a1c04cd000000b002fa489ffe1fso2920081wme.4;
        Tue, 14 Sep 2021 11:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LsGTlaQzTWws2sNOx8koEluc489AlRNu3fvWDuevqFU=;
        b=QVc3/txLV2Ypq7Ur83cuPCdQcMAy02DQbDR4wJl7fPZ+X1r+j7SBk5rx240v0CKkkQ
         t52bG1Zp481ianOCpsH5MwGsORzo7MKKtYhQLj6LB9LMlkzYZdjGIlrdQk8a8nimgFur
         DlyvPj20ZVrj1J+HRsD1HbZCp2YBRwtncC+hZNLHWMOoOXZkqeXTKd9J6phHnr4mqFW+
         AvFRtggd1b/3vMKHIYNSpP6nw9Ss4TpGdKALEqeacaSQue9g14HqeR2MyoNHdnTHH/Dv
         3/rR15fzZ+zLFxBGx8Zd011ST4Wc7Wwqf0AmmL/+1EIXwltz6owhz5BJ+x13HpqZgn/T
         NukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LsGTlaQzTWws2sNOx8koEluc489AlRNu3fvWDuevqFU=;
        b=nG6VuKp7yDESddiPGUBxWsvGDyjM3QMumxsPwg9Wq3F/zKcMZImbtF9sqOqB2GKXpc
         S6xuU2+Aa3Wz02byswF8ugXim/JpTYW2FGBU7snRWfwBjA9uB6nenRavwsDjkF/5zS3T
         hU4mMlr/FOdeabrlS66lIeb+4s42M4tP/HGhgtV1UyXnIIGLv5j8wOF8zreP8yXByCsI
         yvN1brLg81QVtYfOeJeMIHaflzJszoHKDp8iczHBq1rCV6P0zljV//KfFj2NZcTdH5RI
         8CaO3+HuBmJomPuOja3qfkwi6ghHP0PRpY2q+b5FCqs/6h6KfwG3iSeImA7/hd+meWAm
         oQbw==
X-Gm-Message-State: AOAM531EmaoblvGCmGz5yQonPup34QnWPH3rrJ+AqRKb1JUeLOZr0z8R
        d939lRChw7v8Bu7qJvf+qok=
X-Google-Smtp-Source: ABdhPJwHiJhAFykgznPlkoZAvI7X8xEz0hNGNmO01KJ5RCQ1hoHLCclhAriZ0RE1jLQWVj6eDah81A==
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr561589wmb.112.1631645646066;
        Tue, 14 Sep 2021 11:54:06 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id c7sm2087877wmq.13.2021.09.14.11.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 11:54:05 -0700 (PDT)
Date:   Tue, 14 Sep 2021 19:54:03 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/144] 5.4.146-rc1 review
Message-ID: <YUDvy0NN8zuZxSEw@debian>
References: <20210913131047.974309396@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Sep 13, 2021 at 03:13:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.146 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 65 configs -> no new failure
arm (gcc version 11.1.1 20210816): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/133


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
