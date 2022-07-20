Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC0857B0F8
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 08:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239620AbiGTGUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 02:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239237AbiGTGUj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 02:20:39 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE7D30F78;
        Tue, 19 Jul 2022 23:20:37 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r186so15524696pgr.2;
        Tue, 19 Jul 2022 23:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VgdNRP+l0jUFBmCVopJXx7BzBCZ8qxw+V1nJ5I7FpQs=;
        b=kM0bp6f6xf/QgiYrqts+pqjUTH1w/qfbRAry2M2uBWHT2VEQ/fJdhlYOdRafFMqwMX
         gKGniGI1HmAe6mu2yOUDMlNicLOUthdKXrpltDWmD2XXe3TnjZaRvn0me9pNSMSfDzV8
         u9yeP5+fQtp7UJo4GlqCXRooL6TG2JgZxc4gqlTmDmHLSw/U03lm0QBciNkYwQW0YXAg
         Y6BE9vKgEt0qll0zNzT7gUDW9tXoxBYxp+XTDaW18EwJU7u6S15wMXFE+fHpMgNlW1zB
         8WrNHgISGsDQkIba5koFSQtVX9jNdLi3yoQw1Ib7B9Zu8sbhx+ily7WX67Mw1t9mHVdm
         abMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=VgdNRP+l0jUFBmCVopJXx7BzBCZ8qxw+V1nJ5I7FpQs=;
        b=4NLihlVuPqinyZm6vyxrxmYn/av3BBy0GK6jAnjYdOAm/tyH+FSUsPtS85iDIcT8w1
         VmLzFk8+3hKT62LtKqXnV357fEaU/APW0h7PyOU8+3dpYVzNt+2Fw3RaJ30DelahPY9G
         SzRZlFuW6vUkm35wU4hTCOZf+vr2DEMFx3tkQPBS0Q0d7cctG47JIrmNdWTbCRDY1hGc
         8OB2rvUX0kAp9KxrwFkSRW07fgtkKNHaCc5MbgWABMHeytqtTc/qC27iG6ut/aXOqBE1
         Y4Y4qV8RDeRjvDyeY5cSWdWCWnqIoQ5Ii+LnSWNimMU43BXuY/SsqZJY0pLzo0ahOCJF
         5geA==
X-Gm-Message-State: AJIora+VH2ecLmWc9JSQjJ20vREMx/P3xoXOmMWngNHe6qAxCph2HoSr
        1jclpTLMUQ/sAtaGFo/AVW8=
X-Google-Smtp-Source: AGRyM1sdJJzRgLZGz0sL+a9qp4fsmZfTcE7REpjPDHEpiOZvKOLkFG45cL4qaJhyGCxVQNE0huRLZA==
X-Received: by 2002:a05:6a00:1a94:b0:52b:21a0:afbc with SMTP id e20-20020a056a001a9400b0052b21a0afbcmr31404502pfv.13.1658298037221;
        Tue, 19 Jul 2022 23:20:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z10-20020a170903018a00b0016c46ff1973sm12898182plg.228.2022.07.19.23.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 23:20:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Jul 2022 23:20:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Message-ID: <20220720062035.GG4107175@roeck-us.net>
References: <20220719114714.247441733@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 01:51:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 151 fail: 3
Failed builds:
	i386:defconfig
	i386:allyesconfig
	i386:allmodconfig
Qemu test results:
	total: 489 pass: 461 fail: 28
Failed tests:
	<all i386>

The problem has already been reported, so I don't need to elaborate
further.

Guenter
