Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA9E58EA08
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 11:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiHJJt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 05:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiHJJt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 05:49:27 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B5B61DA6
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 02:49:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id b4so14217461pji.4
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 02:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=L9x7qMrdSv/1wGcarUtleKFhAaRLeutGdrlwPnar7sc=;
        b=kFi3CyUKLvlytYERKFW0I2aDqRjirN1sZzeKUHmZnAax6a50F6ZMCZlY1NRr2iFsBO
         nTd4coKEOCNSfZU0U24AICfljEiGmXWNobm+7Eu0DPTzmgrBWUW30fpvFQieSOBQF/kz
         lPbV4RR9kpSHO1sMqwgCYV+B2vGvNr3ZWBMPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=L9x7qMrdSv/1wGcarUtleKFhAaRLeutGdrlwPnar7sc=;
        b=utFHmAA2ziRVxuzI6v5hK8SOHOnZib9Ho6hFHiPfoBG5B4ULHk6Ho6pHFoPAqki0p6
         Rep5TdqiDOS7trjoYKpNLCb4cXUEaizi6ohE2kuG7LCOxD7H8E9DkgwF2JOz7KGV3dum
         4Gq0s5QTADjNhL6J+hbAV+qImaN3EnscMAOVWhmMcc0eVFSCXDICh5kqYi4vQ88yGwFv
         Pw9o4kN7Hs4QzsHs2ZNeF+MS/mIIKc2eWolkGoKUBPB3RLbCjFRnOqNEVrA2M2bnJITu
         pUtdArSL6rhfF+GjqEOvJSUqVp2Z2RbICFAHiy5qqqVCY5xKSBKzZR7nsIN82HYUx1Ol
         NhRg==
X-Gm-Message-State: ACgBeo0pWrSJN+ydvhGiW25/WFicdEFFM7aVKmXqVgwv1yNhfHLAuZUX
        zrapYmhyziSpj/mICy11F2qPoA==
X-Google-Smtp-Source: AA6agR6wworkHximCc8qqj2fO9G9aj/eSYic7cFWhlJ+wSdHjgYZtAqDBMfJ8h9Ej8TDM0i8Yji7MA==
X-Received: by 2002:a17:902:c941:b0:16e:fe88:99e5 with SMTP id i1-20020a170902c94100b0016efe8899e5mr27788437pla.38.1660124965226;
        Wed, 10 Aug 2022 02:49:25 -0700 (PDT)
Received: from 0d2831aaf7e6 ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id y13-20020a1709027c8d00b0016ed52b79besm12228483pll.271.2022.08.10.02.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 02:49:24 -0700 (PDT)
Date:   Wed, 10 Aug 2022 09:49:16 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/23] 5.10.136-rc1 review
Message-ID: <20220810094916.GA109@0d2831aaf7e6>
References: <20220809175512.853274191@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175512.853274191@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 08:00:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.136 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.136-rc1 tested.

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
