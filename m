Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE6A48F7EB
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 17:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbiAOQjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 11:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbiAOQjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 11:39:22 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF743C061574;
        Sat, 15 Jan 2022 08:39:21 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id x31-20020a056830245f00b00599111c8b20so572477otr.7;
        Sat, 15 Jan 2022 08:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OzMvMwi3IrGDZxizWVm/Wf4llnew0bif+qznZudf+NY=;
        b=mhky0YUhx8qRJWT3xhFPhPgzAVoBevghx/EGAyab4PyN2kF66JlpDJpFOkPdL1sF8v
         H/pPii3hy23f/Lgl20tyjDlBCEC4yU4cKovx5zpz6IzG4LuVjsfdMi0aH6tBk6Zfx8vi
         3D7JAte2RMVlIoxtMRGtCzvjLdMTrWy2cwg3OpFrh2twd0AbvA2e0tueYAKTK9Tm1ML2
         ECScfxCeBF/TuMa6BbBtZUMS05a6lHzGV0Djpa51+uAPLiCasrCwXllFpAWtjkzsyE67
         0StjjA6sclfQW5nDfoAdtcMpul6abMDq7jrpeWXnRwJ/ShrGDH9mA+bdz4ssHaTQXPxn
         XFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=OzMvMwi3IrGDZxizWVm/Wf4llnew0bif+qznZudf+NY=;
        b=WmrTtsnqtMD4N+wWr/D2rOvk2758TM/AF2DV+eppGopMYxR7DVIFP5+IViAcH5gyX0
         wxRChOLgPnquPO0vCwQfqRSLwcQH83NZ2IsXcIDKnWZn+YhB8gh6n5gJGfVgBGzhjA2C
         03YJsyLlVs5kB4km+siqZFvHFtHa/PbUoOR3U/XSbBuJRgiKxYdALuMS8PBRA3AsbSme
         zNrP65+Dzn5PP+lxbcHvIB6zudjvkyOoR/0H/Y97UuWf/tPOnH5UNJ+JukdexqBoKNmB
         x84miJk/oogrhvYPhSCFBwH8CdKgLZA23RBoAz1AvLSP2VqKDmNEfLgryiV8CpzwmAgY
         ULEQ==
X-Gm-Message-State: AOAM533heGLRUqIhy2NGnR2KNdZZWMBiNJz8eWp3ubKCe3xgoqeCFaUZ
        tIQxMcxk+6foHjRkeaD9WuPrXoB5FdA=
X-Google-Smtp-Source: ABdhPJxjrx4Jf3egqLKmtNzRX0WZnaQsZqvlPXnBVCgnJlI91Dg01uBsI+oEeCFnFtledsR285lEMg==
X-Received: by 2002:a9d:422:: with SMTP id 31mr5526241otc.296.1642264760282;
        Sat, 15 Jan 2022 08:39:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c4sm3464582ook.16.2022.01.15.08.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 08:39:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 15 Jan 2022 08:39:18 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/25] 5.10.92-rc1 review
Message-ID: <20220115163918.GB1744836@roeck-us.net>
References: <20220114081542.698002137@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 09:16:08AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.92 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 470 pass: 470 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
