Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE18859AD1D
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 12:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344798AbiHTKFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 06:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344722AbiHTKFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 06:05:44 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAE35C9DD
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 03:05:42 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id v4so5490134pgi.10
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 03:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=DFOB75nREFyam4jv0rdX/qkwfHqx3sA+NhMOQuDv6iw=;
        b=Nv3KZN7UJW5oczoe5n5fnv8zXhzcdawc8LLJr3Sf4UFs3J4mV8ALEUD8v9Z6xcAt3t
         /doN6cSIjvpkL6C8PdsZ06d8N95ZkfVSBRtAmWPJbKyaE/VvcEjIoBfnQ0kHUg1h4lQu
         lEQ7eAyKdGGXHdiB4uXkgF3u34XhA66yL92Gc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=DFOB75nREFyam4jv0rdX/qkwfHqx3sA+NhMOQuDv6iw=;
        b=3IOEVV6KzjJcEPdK8DP8b56pq6vpeqU3xEac/vIVwUnSS9QP0kEStKoDc3aKOALxp6
         6vl/gyE36hj+fmBovhhzfQy+RXdIQ9GlGitRBwa7bMOftBGgTqhMyHSRtsq1nJMEquHg
         ShCQj637RMrxryn72Ow26lxRaP5RrhHZJ6Ufw1jgeeWjX1z4ppNTTkZzGINzmMWpT+Fn
         FxPsjksi7r761bqOfdPQLThfUqCwHoO0sSIB9M2jLGQOMo4WbLrcEpp63GYSBdcuptUX
         oQYenKqCt3EidHb8NkPklCZxZA8JK6/rdyjOOu7TEcRcmf83uJS3BpaXbpkjaeJusqxT
         bcmw==
X-Gm-Message-State: ACgBeo3rrP7xAbxWfo+yXzrEkFBXL8dkCCbXBCgQBTZ6a0Ex5+ceOmF0
        cJ3HD3M0GRBJ0znmTpbloxhKnQ==
X-Google-Smtp-Source: AA6agR7dKGuUKhGx2/lcPi0GmMBC7gbTx2cUzCsfSp/+oMsj9l1Xl4zY0TnYgigsr6KJasiNyeomqw==
X-Received: by 2002:a63:8b44:0:b0:41c:df4c:7275 with SMTP id j65-20020a638b44000000b0041cdf4c7275mr9814749pge.434.1660989942211;
        Sat, 20 Aug 2022 03:05:42 -0700 (PDT)
Received: from c29ccaf5f13c ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id nb16-20020a17090b35d000b001f516895294sm4530726pjb.40.2022.08.20.03.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 03:05:41 -0700 (PDT)
Date:   Sat, 20 Aug 2022 10:05:33 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/545] 5.10.137-rc1 review
Message-ID: <20220820100533.GA1012216@c29ccaf5f13c>
References: <20220819153829.135562864@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 05:36:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.137 release.
> There are 545 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.137-rc1 tested.

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
