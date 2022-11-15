Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28B26297BB
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 12:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiKOLt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 06:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiKOLt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 06:49:56 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D8CCE0A
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 03:49:54 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso16675808pjg.5
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 03:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y6nI90SEnhZlekShgEiB+0Ge8+V2Jx/PCkyDouTkqJA=;
        b=BaPv0r2Q29YXpFOYUPcwU17sK2mQRunwxxauGsy1K8ZxRsNAjexFESeb0wF57irnTo
         5hH0uFnR781W8tCXDWRVi2oSH0V7gn7eJOvNEIzmjnWQs+mr/fKH2+Y3B93Hl+/FDugd
         WcPPtDmjyv7NvFLiSxuOiNW2lxfu5x5/f9l8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6nI90SEnhZlekShgEiB+0Ge8+V2Jx/PCkyDouTkqJA=;
        b=5VHPloeJoWZ3SJ9yS8h+sIxUpTxzUzqGii092f6yHQQE2TolEESa96MaIhi9xBGoQD
         L7bagsrMYr/pszjxFY9XE6jiiGJtTwkrDh0Zcw5A93O0UyfBYmohg5VDfnyD6qlfE+7p
         P+MO1gNj2TJBdpgt3JhyhnTMrzN/uUkXDA7r/4bI0k/vGHFUiu5VjiIFyJMy0u0lDjmd
         16i/7+C8/DZayxdqsibG3FY1YCipubyQcBEwa0at2XUT4dM3WHgZPez1kWgMkVNJJrVE
         Ktl70O1Y9FFt3L3J56lrwOT9EpJxSqHhEQMqbcPlChav/qx1GFxfV+0LbhOslyo4XT+9
         PHwQ==
X-Gm-Message-State: ANoB5pm3joaQmZAqIieLfyDXEd0hPCvdt/M47It9s4sPFAzVduQrPsO0
        lIj8spYwZeglNGg6AmjPmrIKpQ==
X-Google-Smtp-Source: AA0mqf5tN98HeEjOYKzpslHF/AITY8OfQ0nYfgBTm0Z0n9DM4DAQ7jFzAYnaNkPwY2ogoQ0Y2vnKAA==
X-Received: by 2002:a17:902:c389:b0:186:99e3:c077 with SMTP id g9-20020a170902c38900b0018699e3c077mr3560983plg.161.1668512993983;
        Tue, 15 Nov 2022 03:49:53 -0800 (PST)
Received: from d5d3ab63aed3 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id w193-20020a627bca000000b00571bdf45888sm7524215pfc.154.2022.11.15.03.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 03:49:53 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:49:45 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/95] 5.10.155-rc1 review
Message-ID: <20221115114945.GA279@d5d3ab63aed3>
References: <20221114124442.530286937@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 01:44:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.155 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.155-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
