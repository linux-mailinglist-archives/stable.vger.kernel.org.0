Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EB1362907
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 22:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242654AbhDPUFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 16:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236363AbhDPUFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 16:05:16 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA41C061574;
        Fri, 16 Apr 2021 13:04:50 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id o21-20020a1c4d150000b029012e52898006so5160009wmh.0;
        Fri, 16 Apr 2021 13:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oRE4pDPA9srfbLyb1s94kt5WhCv0WJOHou6rlqOgKsM=;
        b=BEFl+OoXqYfphkjXKQ1i01gVmICLjq/PwD2SXrE+kUwTBGZvKk9S7eCuV5B4bTQdr7
         meKeP1AYjKY0WQJaLhU0Zdsd/c5t5Tg5sMcDB+KRZ9XmO4L9ao7q9zXfzB3qq3Jzd4yz
         MMYFbnXo4PGQEDCYApmQqzr9F4zRNLhCPE/msevezCWipWPho1DqdPBUmwbmeGtgovax
         KGpjOKr3kTzP+UFVW2N2wAJ3H47aPjcVPXF7UtbkbmMwkwl8TdDc9Sr66SVEpB5gH0+R
         x9HOddmmQ+izfx5bX0pOfS9gZhGQ8XBjDXyjYe6gqjRfakCbciTayDY9RQ2sRqXgqSl1
         WaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oRE4pDPA9srfbLyb1s94kt5WhCv0WJOHou6rlqOgKsM=;
        b=pe7+N3MWEBorQ5uyLwe/5aXz7iSQyhS1n/t96vxxW7hbOIUcReerwXTlN5+qVKi12P
         LVWbcighUEj33dtEeli/rcAQxVFKMcFRer4clKLjaPsmmxXhv2VDn2oVvofm/EojPmz9
         bDJD/uUuRMkSyqeAUL9ZLXRucExLp2QAzymcN9o2PG7EkzmfjTNzES/fyvBhhs6rxR2/
         lg9NrzbaO1pqMq5OxRCeyVUlR3eH7UInjWD3z3aDz6OzWkK2nQF1aySq9iJ5nYqC92rp
         DdD2rts0rnOTZtofBXmeOy/wg48vLEj181eyfzHrjwpJxiidzutt25WbRf7ep1j2+xvS
         F0tQ==
X-Gm-Message-State: AOAM532GgvCgXVcXO02Xy7vDrSf1T8lfTmEswdmO6xUkG7MtxJHEgzFr
        MRav8llC1M0fWjYPsCeJJdk=
X-Google-Smtp-Source: ABdhPJzJ1umtIle/K+KuXdQeRHXWsdhjvU0kaLHteTY2DIHqfsgpNsCLkrUugDxm1VINFEtGccChHw==
X-Received: by 2002:a1c:6887:: with SMTP id d129mr10022531wmc.114.1618603489167;
        Fri, 16 Apr 2021 13:04:49 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id h9sm10520948wmb.35.2021.04.16.13.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 13:04:48 -0700 (PDT)
Date:   Fri, 16 Apr 2021 21:04:47 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/18] 5.4.113-rc1 review
Message-ID: <YHnt31TJGwza30Qf@debian>
References: <20210415144413.055232956@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415144413.055232956@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Apr 15, 2021 at 04:47:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.113 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 10.3.1 20210416): 65 configs -> no new failure
arm (gcc version 10.3.1 20210416): 107 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm: Booted on rpi3b. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
