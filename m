Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13AC8587B98
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 13:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbiHBL2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 07:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbiHBL2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 07:28:16 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB1E2AE29
        for <stable@vger.kernel.org>; Tue,  2 Aug 2022 04:28:15 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v18so13146399plo.8
        for <stable@vger.kernel.org>; Tue, 02 Aug 2022 04:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=H7FLv+g+HrT2ruIOMeV4n5xPG1bX6rGXZvtrf3Y8n08=;
        b=Ud3dUUP9vNnB36t2HkbOVN0YSBsQwdk/4ZDmdhGHgWYSrUx37RcmrOAG0g8AZixVrH
         yMNODhYKywy819T5/opovgrSPbWVSrfPHg515gHHkVee8ptEfoW8228SfJ37eFyOCizv
         3wVip79nEatmhbGVsSUkh1buB3VLzeHccVg7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=H7FLv+g+HrT2ruIOMeV4n5xPG1bX6rGXZvtrf3Y8n08=;
        b=ddIhyoCAjYoLN4cHVjSx4LhmyOmI5Hwn19ZLz9vFzIWyEwey6VdBjW+0lsAFVN8hj3
         kBU6ONqx3wT2D0RIA8l1OL95+bi11hnAXLqkqOhgVYbP6ofMX+3+N5aHFUw3TvkyLMGn
         MXwhHyxOdwouq1P6ExvQ1wnz61oXC3OxANpM575QwvuuwOOH0H5lzbV2JRBwybRFKuZW
         JWZ/qeGi+ozuLWMXKlbXHQQejqMDM2ruSiQvqOfApWgTtZiCmHlAoyFz+PhkRB0U9gBq
         EEqAWHWUBdMS28mzFNRP7Y6rQPRUIiT6//U19Lzqy2tBVMyRwjdgmZ8oJffQEGjFG5J3
         aWtw==
X-Gm-Message-State: ACgBeo0vld620tFGscA9UcLU6PucOBcJcLyRO9NzwcFR5vitqktreg0i
        tuCCChNUIAF4koL7Ek2aBfoX+g==
X-Google-Smtp-Source: AA6agR4ihKSOfbQu2gENpRSO/07pyOkcoT3oYLHdxCfOdFGe0y8TB1AsbYtqMTko7eh1k4X5Qxe/NA==
X-Received: by 2002:a17:902:ab14:b0:16d:c234:2bb9 with SMTP id ik20-20020a170902ab1400b0016dc2342bb9mr20565143plb.83.1659439694733;
        Tue, 02 Aug 2022 04:28:14 -0700 (PDT)
Received: from 45f01dcb456f ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id o70-20020a17090a0a4c00b001e29ddf9f4fsm10702932pjo.3.2022.08.02.04.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 04:28:14 -0700 (PDT)
Date:   Tue, 2 Aug 2022 11:28:06 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/65] 5.10.135-rc1 review
Message-ID: <20220802112806.GA8@45f01dcb456f>
References: <20220801114133.641770326@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 01:46:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.135 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.135-rc1 tested.

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
