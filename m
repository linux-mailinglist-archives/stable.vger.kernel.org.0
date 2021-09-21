Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C894413B68
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 22:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhIUUdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 16:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234860AbhIUUdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 16:33:40 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6FBC061574;
        Tue, 21 Sep 2021 13:32:11 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 77-20020a9d0ed3000000b00546e10e6699so301681otj.2;
        Tue, 21 Sep 2021 13:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AkkAt+dQ3T9jNztoHzc3E2p8ULIaikQ4OKBBtO8eBss=;
        b=RaELevmcgkCiCsKZi8dpdfVSonYESwnY8dfIm1N2JhcbHc5584WJmO1rEtZ4Tjs0N2
         WlPUuuNXgN5xC93m9o4X4kY7Eoi4X1no7AxQJnYyyTwGo5AAgmUsoMYZ7SHg4DAW71LB
         Mw6W3RDPSt4ue3nfwZAIlD83xtOMvzUqEoHrKaw0JoDGeBPON673mtEwKfSWdJjjiIOW
         NGYw/yavH3DqbS6TCO0gL6lOPzNsw6+xdB9B7dFVpERQNwI463IUhsj2WgUOgRM2iZlU
         OOd6wzrMwwLtF0H6xTKAfwheBxVhX5GYD8U6egLNY6MuulDHfBGZ1mJzyXvl4ytlfk1m
         ajSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=AkkAt+dQ3T9jNztoHzc3E2p8ULIaikQ4OKBBtO8eBss=;
        b=H0RJIFBTB13jXuM7l89/THodlmbushaK0B75dA25A7jwYTM+uhgwMm6GXOmxF+shEz
         WNY8WaOFPBqHi0pYhioWc3gZTmFlIhZtUawaaTkC9OFtX7zINZlMjL0x1pI8BzUGzbP4
         5i6bMmg/LVkbP5djRUXZDFJ0MZXJlYVNUJQodVS+rrf2FE72C5oNSvo/b4gGZZa6NqaD
         SlGuIHkykpLuKKD5gAexDT/a+44JgLl8C7Idvp3KTyscj9GRdvtWV4zzDvslbH2NkNzT
         Gokiv7rmZwA1rYcLY/AlYtHRlIT/hqk4zAFysoHtRWJ2k9cSQuTShZf9oLO/S4Bmv4Mz
         cAbQ==
X-Gm-Message-State: AOAM530Veg5KzE2p8AEJt0+3BUW5to9OnIc2ynMp39UYp5etiUtZwI0J
        SEpVPxtWFLeOyNWDExu2Xe8=
X-Google-Smtp-Source: ABdhPJw6Y5+d3Ea/33P4NQdwotlM+qPBvgYG4+UaOajAIcLJscKmLAg/VfNdTBvcA61AMhNv6GahYQ==
X-Received: by 2002:a9d:7457:: with SMTP id p23mr4034989otk.336.1632256331059;
        Tue, 21 Sep 2021 13:32:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k5sm11721oik.38.2021.09.21.13.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 13:32:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Sep 2021 13:32:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/216] 4.14.247-rc2 review
Message-ID: <20210921203209.GC2363301@roeck-us.net>
References: <20210921124904.823196756@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921124904.823196756@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 02:49:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.247 release.
> There are 216 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Sep 2021 12:48:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenetr
