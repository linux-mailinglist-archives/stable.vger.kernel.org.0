Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B3340B3ED
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbhINP6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 11:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbhINP5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 11:57:55 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F59C061767;
        Tue, 14 Sep 2021 08:56:37 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id bi4so19631963oib.9;
        Tue, 14 Sep 2021 08:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dNlAwuPywI+5AM1DYvjhKmGjZLBa6rlzRKd6qCEidx0=;
        b=I3KGflmFZsBbdU+FtMNhYt1u4uA6pcb6GE+DLusKd1W66yBv1Ph3MtK47xQcA2oXZp
         c7vEYu1Uxo8eE9mA+JDInQkXJ32iyAgw/SqH2Vl7yAFCtLV//vyrKaRZkmRrg362JEdK
         qkOW4Xw+Ck2Ggn/osL+ROVlR1UHeeQlG2KAvK0dm6u682z/WZaf8al+iurfm5hBpqzC7
         PWF+FOue77fgf6btJl1rGdedf3hLpClZ6Mjb4C5Qs8V+I88y9avDO6JJz/7T0c9CKCJz
         GtOH6wVLfAbjiU5ET5krMN/YV0c7mlM6Aao9KyuU7T//oc9JiN+bAb8AyUh4rNRiviRb
         X5Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=dNlAwuPywI+5AM1DYvjhKmGjZLBa6rlzRKd6qCEidx0=;
        b=yiLlWspy1lx02sKUg+rDDREH3RW0G9yvkNxeKXJ5F8olBP/UZANUuZnl4V5XmgjChF
         z8XEDyXYApD85MK5sXGYH1oU3cYjGGwktPBECaAH+zYdc8R9wHMv1f14UIHhtqvg2Ehw
         WsD8dsOaxe0Bdvh/Dw9QUKc+QP+PQBc5BO0uC4PooN1w2DM9ywZCy9CW0N1Pke2Y+1ZH
         EaO/lF3lwSVLYid1zTWKOvhFP+CtLDucQlXBa8KHMbi5vjkubY5oQEV3sfRDde1K+r6L
         9iMuLX0O83UuFTiDZJfde1UKZwJlOtg+6IEcXC5uHFID3SFTbeSXIGh/6lnOHMf3q7qM
         dFRg==
X-Gm-Message-State: AOAM533FGoxQhmpsE4ASgIKF4IMy3pM3aqe7LGrLyK9EkR2/tduGCr/+
        7SSckqjWGXFaxh3P44AAXVY=
X-Google-Smtp-Source: ABdhPJwC62QKkxLLgHglQiBUu2Vi0qZVvoLC9LEzcPm9J9mU13368KyBxOLvPO5euFaWPmmKbz4ucw==
X-Received: by 2002:a05:6808:19a:: with SMTP id w26mr2002090oic.80.1631634996866;
        Tue, 14 Sep 2021 08:56:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z25sm2517473oic.24.2021.09.14.08.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 08:56:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 14 Sep 2021 08:56:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/144] 5.4.146-rc1 review
Message-ID: <20210914155634.GA4074868@roeck-us.net>
References: <20210913131047.974309396@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 03:13:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.146 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
