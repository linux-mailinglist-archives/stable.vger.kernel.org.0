Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7136C59B11E
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 03:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbiHUA6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 20:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbiHUA63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 20:58:29 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08410E09A;
        Sat, 20 Aug 2022 17:58:28 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id w7so804545pjq.5;
        Sat, 20 Aug 2022 17:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=gJJPIO5dNxW6EyfA695WG3TfAG/Ru+2Vzl8NFbsY9NI=;
        b=geFufmwjEU+kVZPJlMFz4m+CZtZc0/bwMIQExscCof/C059rW8A2aYYebgQQEuTg5i
         9dCugfGejzCbLYGFJalfc987UCf27fJEzDBbyHVmFfwUkBoHRZz+nrPcC6dTszLeyWy1
         PSXLJWTFoNL/5g6YbnHmb0KG72R9KfXM7gBFE2CXw/ljKyUpp1fRnJRqJNFfLe6stNeA
         3LEac0/4ZCcMsffGaWztBaJCl0/3tts4JlYpRMODxz0rmCapkWQorcmxbjGwZULolLzb
         WnGLLHFQz3k8a79UGXrj6qESLNo1gVZK8vVc0WrKrYZMHnaVSw1ABBwwO5pHcBGK1mz5
         l3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=gJJPIO5dNxW6EyfA695WG3TfAG/Ru+2Vzl8NFbsY9NI=;
        b=Yir3aTG8IP5948uxL13Cr81U4CHMt2A4ctWf8Azd5qEnGsEVbzu/qVq1ZzujvNITwF
         s1H5FR0X8VXm/60ibMLr3KDFpUeo/zP9GlcuIJhpBlBKP6Yn8H1KWCjVTjkIY50Cfn/C
         fHGIg3f4mJX3pCcxe0pupPewH5HisyVVGGxY7idKoz6ySrVEUbriUMlF27qLmNbmAPiP
         PDUUI0YII5A81HIF9Q5k2Cefn2y7V2m7CHmJXz6INo/u8jEuq/COWIpiSacOqb2+36ML
         4EFuWNMRBD6mVfjgLW+WDatStVbuC7PixsfhzPFAfazP4Zy4QTlkG9QffIfo/SI0nn2a
         mxwQ==
X-Gm-Message-State: ACgBeo2HR7KDmeydH5lW5yFkCzB7EwYwg9UNGiHyMLBvPC2C2iR1RNEY
        E+zRJhnmlJNmNOiQrVAE2Tc=
X-Google-Smtp-Source: AA6agR5zrYq5Wcy7HhYVrNdbR7A6OfKKIBJ0uMGnkaMIBySdducy19i17oDojhmWxNyKeeL0LPRoOw==
X-Received: by 2002:a17:902:cf4c:b0:170:5b7a:8f89 with SMTP id e12-20020a170902cf4c00b001705b7a8f89mr13801780plg.121.1661043507519;
        Sat, 20 Aug 2022 17:58:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u15-20020a170902714f00b001714853e503sm5524481plm.36.2022.08.20.17.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 17:58:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 20 Aug 2022 17:58:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 0/6] 5.18.19-rc1 review
Message-ID: <20220821005826.GA990405@roeck-us.net>
References: <20220819153710.430046927@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819153710.430046927@linuxfoundation.org>
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

On Fri, Aug 19, 2022 at 05:40:12PM +0200, Greg Kroah-Hartman wrote:
> -------------------
> NOTE, this is the LAST 5.18.y stable release.  This tree will be
> end-of-life after this one.  Please move to 5.19.y at this point in time
> or let us know why that is not possible.
> -------------------
> 
> This is the start of the stable review cycle for the 5.18.19 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 487 pass: 486 fail: 1
Failed tests:
	arm:bletchley-bmc:aspeed_g5_defconfig:notests:usb0:net,nic:aspeed-bmc-facebook-bletchley:rootfs

No new failures. As with v5.15.y, I did not receive this e-mail and had
to copy it from lore instead.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
