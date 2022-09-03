Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6BD5ABBD4
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 02:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiICAe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 20:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiICAe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 20:34:57 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952111B7B0;
        Fri,  2 Sep 2022 17:34:56 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c2so3392306plo.3;
        Fri, 02 Sep 2022 17:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=9+z+0Sjq3mm2KHbMZxAXXHeVPBp97Wpxg4Fu8ndUFSA=;
        b=KMcfs0xlHO8iG2ygili3Gq4TvP+YoIFMNkez8Eds1f9in/CzAAad20yAQsUe36lZ+5
         PBJJ/8ls+smJAT043MeOJHNARvdhMw7/beBtwBbPcaIOw1lB+xWj5aO9ZJM/t3pWcfyP
         q4Gev8sMoRWv80/CGmF4zHZbJAmB/N+27S2njveyoA8q9hNj2cxStxYzkkuEoxr0Tati
         a3M0wJ+nRyMdRw6K4booNex5pst2ciRmaeQ78UfUg5QzWXxNdR2POeGbwFSqM4Ts5MVa
         KOKko8LtAOYyIJCz6aBDgXI4cnEMJhWh7OId1QkkjoEPq9bprb4O9fN9F9tCaY7S7iP8
         XK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=9+z+0Sjq3mm2KHbMZxAXXHeVPBp97Wpxg4Fu8ndUFSA=;
        b=KJWOJPj9lQ0TLzV14nU3lNMoKR2Wo1DbAwyI/hBVioUkVIMlA8Pphoxkrjy/AoSRcM
         nxPkwXIEQ07KhuKbRd17pmuctuTKMP7vrpo0HYeN1rj+vjCqXdeRnQUlax/a3NZ81BNf
         7iEIYbLTRfm/hLBQGZJRZOQwNMStUeYd/jLRHdKX1Bny4htgNvK0Il4F1hiW/aSQmNwI
         35mcwAtDb/Kr6dlRod0iqD+TlZal+eZvVICnKMa5b7KsGDN1w8AhRN+FQY1qsZm8kce7
         mvTgfgsb3cCcjL+1X0aVzud89kpah6J58ioPiJoRx6sJbKc16WiRHckxXkyQbQX1gdHB
         Myzw==
X-Gm-Message-State: ACgBeo1VDx5S9JUrPWmizmsNEMNVhQ/ut/qV/PbkI3QywpjbEnUmYV3t
        6jmc5g0fngxEemCTnGiHmn8=
X-Google-Smtp-Source: AA6agR7WTAWqP3c2DuA7DsA2JUrq+Jd7olbBoSMCZmQ3BiWBkDrxamwfXdwIkadw17Y713iZC4Zh0w==
X-Received: by 2002:a17:902:7845:b0:16e:d647:a66c with SMTP id e5-20020a170902784500b0016ed647a66cmr36692341pln.64.1662165296141;
        Fri, 02 Sep 2022 17:34:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y123-20020a626481000000b0053a82bf2ae1sm2433551pfb.25.2022.09.02.17.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 17:34:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 2 Sep 2022 17:34:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/42] 4.14.292-rc1 review
Message-ID: <20220903003454.GB847372@roeck-us.net>
References: <20220902121358.773776406@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121358.773776406@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 02:18:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.292 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
