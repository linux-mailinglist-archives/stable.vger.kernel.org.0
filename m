Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA376113AE
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 15:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJ1N4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 09:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiJ1N4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 09:56:06 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0914A1C2097
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 06:56:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso4532813pjc.5
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 06:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zFm9xq1TuqjUkOGgoKTO6KG604kBsjeVMKaXSBwq70g=;
        b=BgT2unWoRr1lc5bXspAu5oW1cRgbl9kXawGzoyVmNN5OA7sTzrz543Eq9EPkjShx20
         1FZwnBIaSjPsyY946p6omwNbNdByU5iW+m3LUOpj3/QDV7XaQt2yXPGQRnUs3hDoiAcM
         YMcRokJWeUjOHYIoBhQVkByYple/+QRPngGlI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zFm9xq1TuqjUkOGgoKTO6KG604kBsjeVMKaXSBwq70g=;
        b=Sx+hr5ssaLMDK+q0i9UwMlKZPNgDbKOeYk8S6JeG1uwADIFbDZSiWKCx4hk8ZCtEp0
         u3wU7Z3M3ug3uYDm2xJitrNHZGZvF1EwIGcUd861ZctkdRoU4wzJ6FoQu5Koiwo/n6Uk
         AQLhSXhrq3aQwkjLsfcX5iXv6AOJE75CGLpeNGVJwMhyj8N1g6RdF0Tuh1JyzW5CCHl0
         9UWfqisMpL9p0RSky9G75iTH4MGGizjIxiuiBxWMnYhafBKrmxZkEttEWmYErBZFbOZt
         NbSaolrsOMkiABJfAoEZ3qTxsp4VZCgGgNOMQihWWYYJj7HlOM90xVIfSFiQxs3lyaBD
         MlSQ==
X-Gm-Message-State: ACrzQf0uEmxJIevaqECsFmTyjZG3C3vJmEnk6IQqjVw8xMah/slO4KNB
        Yu6f3lsqS2F1OQLaTzX5hR6mMQ==
X-Google-Smtp-Source: AMsMyM5rpfY/PuNZgOMTGmOro1CmO/Q7My7E3N0aU2dbPMc2ot+ZJ7NjJ8IZIEScoXyDiN0n0HrLiw==
X-Received: by 2002:a17:90b:3ec4:b0:20d:93bc:32fb with SMTP id rm4-20020a17090b3ec400b0020d93bc32fbmr16328691pjb.124.1666965360373;
        Fri, 28 Oct 2022 06:56:00 -0700 (PDT)
Received: from 21e111714c80 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id y5-20020a17090a86c500b00213216a0d92sm2621382pjv.5.2022.10.28.06.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 06:55:59 -0700 (PDT)
Date:   Fri, 28 Oct 2022 13:55:51 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/73] 5.10.152-rc1 review
Message-ID: <20221028135551.GA950780@21e111714c80>
References: <20221028120232.344548477@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 02:02:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.152 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Oct 2022 12:02:13 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.152-rc1 tested.

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
