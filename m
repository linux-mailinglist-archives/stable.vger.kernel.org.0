Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCC75ABC85
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 05:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiICDP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 23:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbiICDP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 23:15:26 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB79349B4D
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 20:15:23 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s206so3513463pgs.3
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 20:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=2mva87qymCkSmzTt1Cco59vkyi5vRbd0EkFHPAgEW38=;
        b=NLYnYCeobipxUEx5TqOhxsRC7wgjXWDTPNcVUl0zT2T1Wn7EaGgHMHqsjue8hMNmWB
         hGTtU5uB4GeM2JH7qAZQytCYpUdVUNZrTR5G+DyXc5plW+XWSe6OGZp2w6sgC2tR49II
         1glwbVN74fLsgqGbxGuIRt0FuWGy5YLToJtbw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=2mva87qymCkSmzTt1Cco59vkyi5vRbd0EkFHPAgEW38=;
        b=7LD6HcL8q+BTKHAN5kwPpSDdtSn84TDpXMkKN7a9x6ZKnhPgM0XrhXAnJGNZW0nBms
         sXb/Yh2Bp6eu+3KIHtknaJJg5iVWs1c9EarR/MY/UywyEHwA/RK2usuvmX7o68Whmffk
         clc34MfEWQmiVKC7BZ1eOn/TYgt2pt3k3BKsRKijkWGUZy6IswQBFhIR2P1cujkCEAhu
         u2NinjwSzQHb0hxzUAHKMs/L8FPtEs2+mx+McbFLNIosIR0PIFd+YCutNhmjspXvsSJl
         qV3uI1zNoRbrtf7/pKGtcbf657x5Y3m4NV0y+Ylq9F1CQlrXYxE/0338/qfW/pkzgd68
         opeA==
X-Gm-Message-State: ACgBeo1uyd2Fb1W0+ZGSoOnKsswwDyZsbx6w5iZQg22CgtDmfNVm5sB2
        EgffWzTIECyoncphccNYbEC5Sw==
X-Google-Smtp-Source: AA6agR5G1oO4J7ZuGl6l2aWBtsEWlvj0t3kz7ILdjV5dsjNry9WKGFb3pdwTiyWCbdjvPEBqcMm4Gw==
X-Received: by 2002:aa7:9f82:0:b0:538:5e1e:86dc with SMTP id z2-20020aa79f82000000b005385e1e86dcmr24638858pfr.54.1662174923323;
        Fri, 02 Sep 2022 20:15:23 -0700 (PDT)
Received: from 26c9e2a7cf1e ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id t1-20020a1709028c8100b0016d295888e3sm2363190plo.241.2022.09.02.20.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 20:15:22 -0700 (PDT)
Date:   Sat, 3 Sep 2022 03:15:15 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/37] 5.10.141-rc1 review
Message-ID: <20220903031515.GA972134@26c9e2a7cf1e>
References: <20220902121359.177846782@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 02:19:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.141 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.141-rc1 tested.

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
