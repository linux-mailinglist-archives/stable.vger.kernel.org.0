Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083AE6A8CF8
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 00:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCBX0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 18:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCBXZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 18:25:59 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC3758B51
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 15:25:57 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id ky4so954486plb.3
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 15:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1677799557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EJebJkjcbH6lD9dZKQHxPTGnyvjfRr/WRlDMZGcswFY=;
        b=WGeot1XIgZ2Pt2nVRmzXPAFnvh9xNUBiRlbjTx51Cyiy1dSh80xz389Doc7zl4qK+6
         hOOeXnEuFF8M5eR9RToy9zoEq+iEUkmauHAFOO17XX6oQa5u3ZNfeJHkm8i3nZBRx2HN
         vZHKbLoBZhUuA7jisrnjGqVjj53Jugynnm7EE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677799557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJebJkjcbH6lD9dZKQHxPTGnyvjfRr/WRlDMZGcswFY=;
        b=Mg94/SLxbd3KVksr9ejOa858Rfcd1WAlk8y1qIP5JbUGUlZl5msjmMNIvCZ8ExNUHR
         uRGgvkdE32V0LmYdqPudMUlSH1VMyP4rhhsx+zKwZGdB/Dnjdajri4SBJviwoYzl/Z6h
         JdfgSGifgkyRZvbMVKA8x0hCU8rACZY3mWpvrYoCiWlDT7BCAhLeBCh9fxSCqXfkjWZ4
         Es3HNmHhuSfMBZLdjtl6ENxhoZAqDy+S88UgQC+cGnSh9bGN5F+yMCBCXKlDpO/ZD+/R
         xMb0K2bBW0WQz6evhzxzwkjYwbI5h/FhYJKR/up0POmvFb25io1Zaa6lJVOZ9jy+zhCB
         lVbA==
X-Gm-Message-State: AO0yUKVqK0yokvwtCwd42o8OtsvhhCFauGkJ+LPgWm/MEU693qXJXNkL
        uToBcCYEnxmXSl9AISb7UmP0+i7fQWkg5MCxecOpiQ==
X-Google-Smtp-Source: AK7set9Yx25dOoCsYZOTUD2EIBEROIjWHDqCnvpz/1WDl/+CEOOyfaXgH3GSCQrEXWN3y/EdcG0B9w==
X-Received: by 2002:a17:90b:1b4f:b0:237:c565:7bc6 with SMTP id nv15-20020a17090b1b4f00b00237c5657bc6mr12995431pjb.10.1677799556931;
        Thu, 02 Mar 2023 15:25:56 -0800 (PST)
Received: from f899b28bb789 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id om9-20020a17090b3a8900b002339195a47bsm2081257pjb.53.2023.03.02.15.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 15:25:56 -0800 (PST)
Date:   Thu, 2 Mar 2023 23:25:45 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <20230302232545.GA1559@f899b28bb789>
References: <20230301180657.003689969@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 07:08:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.15-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
