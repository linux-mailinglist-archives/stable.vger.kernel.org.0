Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1D95F34D8
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 19:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiJCRvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 13:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJCRvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 13:51:41 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9390D36089;
        Mon,  3 Oct 2022 10:51:40 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s206so10284151pgs.3;
        Mon, 03 Oct 2022 10:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=Y7a4rWV/u/Zjj0TMs8nkeDgGw81TAdJdW5nTJnSbKdw=;
        b=bNY4R7Eno+/JL4Flnf5xK3YnWZsVgHUAo4Iba55SPfyuA1N9oeuj4qBwfAYJHoe3/d
         n169G6++pKSSM+zWnLyIbn6WxMz0O1F4zZgkCIjqEcOZA+JBBydUk7Gn7kABA+o1eNzZ
         2F0A509iDyqZ29L8AB/UHrwVH444/IFhuVdb0jWjy6gvxUOrq0aJseI9MTYZAZ8M2Ulo
         dDgCO2gtamcTCFUVg7dWMlj53Cfxa0+/SFK+4Vt1rAoDM44Z+HLgS09a29hDCp+ciiPg
         /m8OiagrQamJiSBv+JrpcFcLpfi/TLen+INP90sXk+Oo9K40uQOfiPbl50h0K8tPXQOH
         c12g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Y7a4rWV/u/Zjj0TMs8nkeDgGw81TAdJdW5nTJnSbKdw=;
        b=zpcXTrpt24uvbOyvqiuw6OgMQLLybAfihsGul4sGQn8up9ASIx4gBNxZDKIiLgfiQB
         ETrlL3OfKPXXysogupg1MBFZh+1ioDbYGRwvKTJ4qWu06Shr/XVhb7j7WZ6+VVVrizzd
         k/MVYbmjsuJgVOvNmvdhm9/KYWeJz+CJQG8jhinGmcRRADdcL4a7XEbj01jRifMVlbQ2
         X5qT3IsNOGGa73iTIXnP1WlZSm2lecH0JDGbg1Js4Q250mGfBf9idlt1qy8wwtmr1IWC
         dvq9Ltcnv3DZU8kt5f+w5mLwwPsB2gO53XVzClN5p94N0PujWXyG/fD47Qyyb7VVdHsr
         cA1A==
X-Gm-Message-State: ACrzQf1O8FjH1mEQrWjS9l3cKq7REHRffZSX0Av03FK0Z2c4L+y3RDmp
        gm8xi9F4vcy2M2/KTjWpJshqFGLNzAlcWQ==
X-Google-Smtp-Source: AMsMyM7OMalNPy+cz7SWPFKcWvypzeYj+2JrGPsabBs0eU4fqYC5nWhdVZMokZx0kL2LFTLl/a2pIQ==
X-Received: by 2002:a65:4107:0:b0:439:54e1:8093 with SMTP id w7-20020a654107000000b0043954e18093mr19587375pgp.42.1664819500107;
        Mon, 03 Oct 2022 10:51:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902650400b00178b070416asm7468312plk.36.2022.10.03.10.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 10:51:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 3 Oct 2022 10:51:37 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.19 000/101] 5.19.13-rc1 review
Message-ID: <20221003175137.GA1022449@roeck-us.net>
References: <20221003070724.490989164@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 09:09:56AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.13 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 490 pass: 490 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
