Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423FD48ADB2
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 13:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbiAKMhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 07:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiAKMhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 07:37:45 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F574C06173F;
        Tue, 11 Jan 2022 04:37:45 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id s1so32721866wra.6;
        Tue, 11 Jan 2022 04:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GZ6DhshfDzm+ZB/T6CYQ9YGfiX4LXvWGMl8Vl+aQSiI=;
        b=JIckljIl84PIGDwLhYEpm8wg7zvOyMYa/Zeon0dlGHuGfeFCoYFKfTw/jTdSgqs6+0
         milCxxlzeFre7YdY/nwsgPNQKf8DjPmTvRu4xmsut332o2oPjZbJwm/Zjx04zZyUeXTp
         jy4XhKYLz5OGOg3OFVPiI8kGiwq5Ffj9YzB1+ml3dIWy6agf9mQHwdPMgpBAh7QsCxLK
         fVK75t/UXgr64UE57VF37sgar3PdqZXn/VZkp2dXD8vQ2QAUDAP9hSQX/Wyg/lO/uabn
         LVApVqHL/4go+x/tk53FPeyQ9vFIBoA8RLG/LORar0V2wcguOCArtgdJHgkVW8k9PK7e
         QETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GZ6DhshfDzm+ZB/T6CYQ9YGfiX4LXvWGMl8Vl+aQSiI=;
        b=DIEh6IB9xCqoz/gax56/suSRu8QxoMxUpcoFWZSW+6Hd4UmfDJwQ/7yDF4TX9uTBT7
         +J8vo3mMTXcy4MqJK7IYmNHOW1IxVwLUKFlzAhvI4/mqzcUAxueOmsILFXcXpkXENLjo
         WFZ5M2Py9dMdJ0oNYMy0APvoiurFN6Rx+oqVBzaxX0ZiOkfiNCJ5KAfEyN8Pum2Ub8YQ
         0+X/qyc09ObTnU6JembhPvSo+3t1qGP3GWt/BgxsjQc5OQ5TyaPnlrL2OoxpwAcTzZGW
         Nj+VDYlFku/Og+ntuXKBXtJDuca9qL+MrZ2QOoS7Sh8Hp6zc88dUX3ovd8XrgwYzGrJG
         H3Dw==
X-Gm-Message-State: AOAM530XA39RIwm9cDuyRDakKp1hIOEouZBzDztYnXCeBXB/qkcRkxqt
        nq93JasgXrvnaXJNryEWch0=
X-Google-Smtp-Source: ABdhPJxIq++kEHfVU5Hz8ktHP1Ce2fGCcBgZv51SzzkOUBxQvZU3SMbVGJ26GzyzWlh3CKVIeIm/hA==
X-Received: by 2002:a5d:588c:: with SMTP id n12mr3640755wrf.363.1641904663886;
        Tue, 11 Jan 2022 04:37:43 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id q206sm1619938wme.8.2022.01.11.04.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 04:37:43 -0800 (PST)
Date:   Tue, 11 Jan 2022 12:37:41 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/43] 5.10.91-rc1 review
Message-ID: <Yd16FeBzGLNLXHUA@debian>
References: <20220110071817.337619922@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jan 10, 2022 at 08:22:57AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.91 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220106): 63 configs -> no new failure
arm (gcc version 11.2.1 20220106): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220106): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220106): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/611
[2]. https://openqa.qa.codethink.co.uk/tests/612


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

