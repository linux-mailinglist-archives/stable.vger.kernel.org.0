Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82634251FB8
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 21:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHYTT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 15:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHYTT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 15:19:59 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE91DC061574;
        Tue, 25 Aug 2020 12:19:58 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id g6so1608pjl.0;
        Tue, 25 Aug 2020 12:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rWYYUp5MIu9wxm0/9CIouQbFT3sbCMmmwTmM85UmO7M=;
        b=OQTa3JdDGa9zFrl8O6pglwnWEeTaJfULQoAR/r8xVHGN51o9aJW2BSE3YbDqXn9StV
         rz2GesZ3Q8G+n+nNxN63aSXeS6ZHCUHnSeyde2qpS5DuY6uxmRIN9f1qDO7fY4IvFMQw
         aujz4hEoT6OqjwSULL6KJN6+/DqPlI8aV6T08ZNOB7QluX77/lhuWkwZ3pcM8Zq4AECQ
         bAa0lz/yVNld8Dy5Vcc5nuYZ85imrowxsnqEJ5b66+uXdMhmX4UpS7gi9Rh10Rkp6SpB
         y0e4HybtHvqXl0qGQNipo4FnhLhVnZut5/6pJG9+iCG4cA9E02OQARU0Nf2APLDcg8dx
         9EyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=rWYYUp5MIu9wxm0/9CIouQbFT3sbCMmmwTmM85UmO7M=;
        b=NU/ltu9P2L4/AN4FxnKWMV4oqMNpOdZhZ85Pmaj5RhETOGRid/Nvk2DI5pwEjl95cP
         A4V+mp9f9QNqAxs2/xQjFmP5yddJMdib8od4k3H6msIuZ8I3DDdYAiDMIPfh05JwHo/Y
         glqlxAeOPHH89544vURLM0bZkSUO4XzQq177q/srrTi73RyLoqRloVMIhCedPz4+a4oS
         SIIriXPvqrxzq66iYYGDlorKcTL3u2Bsp52Oy3B/rHroHhwP8O8bBeYqqBdMv5X6+Z+b
         VIhZRLy37zHZxVyVpdZDeSuPi4j0uq7DRxFSi149OkkE5l1+Iv/pY6VXF54i8GiN4Zao
         V/NQ==
X-Gm-Message-State: AOAM532eRXBNdO/JIc0R1zHnSAzjIwdOX5kQaMabCmF/Ro6Xun4IvsWm
        yJ8RJmZhf+m4a2q94Nf2aiE=
X-Google-Smtp-Source: ABdhPJziQA6MAQFl8DfhoKgZaQp+FDbr+PbXFbWGMBem+hDjIkAqCDTAkdNgWl9g1nmLxWyx3zPSGw==
X-Received: by 2002:a17:90a:bb81:: with SMTP id v1mr2681062pjr.220.1598383198507;
        Tue, 25 Aug 2020 12:19:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j20sm9204829pfi.122.2020.08.25.12.19.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Aug 2020 12:19:57 -0700 (PDT)
Date:   Tue, 25 Aug 2020 12:19:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/51] 4.14.195-rc2 review
Message-ID: <20200825191956.GC36661@roeck-us.net>
References: <20200824164724.981131044@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824164724.981131044@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 06:49:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.195 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
