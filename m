Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC472749FE
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 22:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIVUSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 16:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVUSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 16:18:55 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372E1C061755;
        Tue, 22 Sep 2020 13:18:55 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id a3so22496147oib.4;
        Tue, 22 Sep 2020 13:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KWu8KpwDcYXyK3PBSIS7WOFzZ7j5CDMVHlJ7vSdpP64=;
        b=kyV4zlJGlaOMSZU5g7QguhUsyBEY0mJKm7l218h4qxVKB6FiQqz+DpCXI6aVCnLisY
         NzzC3kyFr+Tk5L69Ble7gKEXMxyCu5MTHHF+8Dsbl8jTE5R3B7z0hoWPceqKY5SsdLnC
         Sa2CrhW/c9+LOeqsN6NJUJnWXnjkiesv1R2Swm4jz7oPImGixbfOu4TF+HJRmQ2STskx
         Ye/lzpAL7IJ2jvwtfeeQfOyn5ozOT3V/9fALu9hq69cAFpgJkmnzH5EllllXM1V5Lh1D
         qgKDI60qvke8H1BJGNMunEPaVoc19xjGuIoSIjdZrX8SIxcK42UPDI9X51vBibLiFxUP
         yI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=KWu8KpwDcYXyK3PBSIS7WOFzZ7j5CDMVHlJ7vSdpP64=;
        b=R4WmC3xko8XARi113jALpOu8UPam8s00UEiXWTtIBktcL1vn5L4errx6jREu9PAefy
         ZQQFoiD177RBRv6j22i/zSQt1VrsxqKFkANAdBOuVcFoJKCGFbcRQfliGKZfzdB7lsea
         RTA/RT1gaU1yTBnn3T7Smwii3ZvmIybQXxLs+HznjcnUKYs/HHdGh3UiHatkHXTU2MoP
         Q1GMTxt+4lmht1S9TnQTEdUzffw88pGXtHQzdoE7P6K22ITqEm4gAA/H8rhnOGt0wiYN
         0j5yXPWNpnm5lq5kfru77Y4MCrDdZKharQ/qbZoshKfTVND9Hc8dAG6SSEIzyxyEuDKM
         CUug==
X-Gm-Message-State: AOAM530FmamTVCXpmefIa5oyWoDap8pAllHkxB56e5J3rblghrtlmuwf
        5GI576oMUw+L25iFm5xXtqg=
X-Google-Smtp-Source: ABdhPJwo/bWQDKOkuhNHA8C8rt+TlaXDGjwF4Z/O0/nCMQ7jrdW/Y4BdFAb1pUZmxwYQ5t8uEy9uTw==
X-Received: by 2002:aca:2205:: with SMTP id b5mr3724240oic.117.1600805934652;
        Tue, 22 Sep 2020 13:18:54 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v76sm7449813oif.58.2020.09.22.13.18.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Sep 2020 13:18:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 22 Sep 2020 13:18:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/49] 4.19.147-rc1 review
Message-ID: <20200922201853.GD127538@roeck-us.net>
References: <20200921162034.660953761@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 06:27:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.147 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
