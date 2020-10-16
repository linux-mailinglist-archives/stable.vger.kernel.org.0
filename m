Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6145C290BFD
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 21:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403952AbgJPTAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 15:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403821AbgJPTAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 15:00:33 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C65C061755;
        Fri, 16 Oct 2020 12:00:33 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id f37so3359251otf.12;
        Fri, 16 Oct 2020 12:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8LFx9ARUF5T3aJVjq0szLzngeXVnAE/ijqfj2qFA//E=;
        b=kp/4hSvLK+kLZYN7raFUlJtoy0D6zt1VbKWelI9tpDzvMuC5OVG+tlsXZ4YzCOeE/L
         iW5z6CrIp/6lAv6OofqMJrqyUxX/UcibMZrxS4HLLqQx/PIFqu9o+uYhI1gJaLjNGjjF
         x8nN1d1f4LAhOaHB7IEEz8OeuqEuioX4X4cNwvugqtjSE1gQeE0gTx5tanoX6YDw1OY8
         vCUFKGTQHvk6zZhBqKVmYleMeZ9VGmIujEnCc40PbzGaBei0/y0HzyZol9KKTKbgtjt7
         VW6dBpM69UxULf20MsC+CpzBCb7O/hYLb7S5nWOToNbx6UzAjR4J+VHOp4pibV5fEQl9
         A/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8LFx9ARUF5T3aJVjq0szLzngeXVnAE/ijqfj2qFA//E=;
        b=SG9mf18m+SsyjTuhXbJ2oNxU3uNVWmRl1dJVIH670JuUVz5li1lhGMfuTn9JWTNjHL
         O4zxMSgvNwg4J0PqQgMJd0RK6EfV4sITTFMLfLkqok1BjjBc0U8qYIzptqMdWM4zYFte
         oiK7xOOT8VCx0mx8jr6FB1Dth1Db3lByyGRmns3f35VFuPg+86CVDy7Z4k5h69VUisa4
         5kpo/L4xxSVz4CDR+7SWov02klM6thc5Zd1I0VQfoezRfTYfoBXWNG+9bdDfxStGO8dp
         y4GruZXAS9gE3GJbJNsnrdCj8hU7Ih7kpduLOk8R3OW64eJaYlxAx2yRx2t2zZ3wC7tH
         soAQ==
X-Gm-Message-State: AOAM5312Zid+de1lb8wxE/hP858gkPQ91pypER6MOGjGX8e8siwADw3Y
        D4yNax1A+CQbKCZS1i8kfI0=
X-Google-Smtp-Source: ABdhPJzV/nSxU8k7+iRi+BpKE/FvGGHcjOTxi4VMWo/XKW0PmeN7jgukuHFzwIMZ0sk9JbE4x0IpxA==
X-Received: by 2002:a9d:2384:: with SMTP id t4mr3468952otb.337.1602874832736;
        Fri, 16 Oct 2020 12:00:32 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l5sm247093ooj.16.2020.10.16.12.00.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Oct 2020 12:00:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Oct 2020 12:00:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/16] 4.4.240-rc1 review
Message-ID: <20201016190030.GA32893@roeck-us.net>
References: <20201016090435.423923738@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016090435.423923738@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 11:06:53AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.240 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 332 pass: 332 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
