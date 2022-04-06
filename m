Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6960D4F5FEC
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 15:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiDFNXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 09:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiDFNWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 09:22:10 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809F3339FDD;
        Wed,  6 Apr 2022 03:11:00 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j12so2442389wrb.5;
        Wed, 06 Apr 2022 03:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rewLxARlDutpxZVy1V6PniivDPDX+d6Q7e/t7j2TQ9I=;
        b=iEF6Z7HX9oHKOuONDurK+PX+GZkKuDbAUOv3nt0bZXmaG/KOQ/z7viygxZtfshj80G
         b6JaS/IqzSx3HyQPdBTXpv7+buQ57SZKMSQ/Ud1jIh2viAnK709Gd2Y2NLoD1VtRg88I
         7zvnTY+u08EHLsH1RGKnT+wFNPglsJPcxvTQWpds+83+u/a0naZLcSmk9UqHThsPaLH0
         fW/6RVxQL7YyqRv8eLPPPxcscIYwg5/9BbKYWMvbWr8mvHmeq+sLv/9S9a453rgd1ATz
         yzkLVNQvDjzw7vMU1N9lK1MDgMT/Imt9Q9PsfV215kkJtCjFyco9sVDW2D5eypclsevz
         bkkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rewLxARlDutpxZVy1V6PniivDPDX+d6Q7e/t7j2TQ9I=;
        b=Ee1aZ2yG68v5oMsiWuQJOGeruMeldSqCheM8m105n/RsYlEMNH5AzsTJ99voIl8BAF
         D3fC7NYE0b5uMoXs5RSfLvuZSPqlVsvpPWdo+3LNO3uirYzmoZL5uBb+32g5NzTWajF0
         HdrHV9VdnZqeuRgVfJLCzsP+jr9wp37Gw95SE+DNTk/tYFLuOv0I+qVKRHniJbxAqWbt
         Gvyi7fEbXgIspX7kTkkkduc1WvHF/9Hp0JvwWheqixIyjgPHeeDKjnkxxT4Vf7xbhRve
         acEwRH+dOK7uCRhJ/v+e/g5gXN5Vo/aBIYa+cRguNcPsZTR95bDdogdFuAAG1xYQ8IJ4
         8cHA==
X-Gm-Message-State: AOAM531JxkUImI8+B+M73JjS3whVN2djPebhGAXXZfmQoh1+szktO9ki
        DaMqfcN812jlmFC75jLwXAdf0o+9QdU=
X-Google-Smtp-Source: ABdhPJzzesOXDC1OhYcnwzac5A07ZQHCzPcP/8TYpSFlUHv6bm9QjZrqaYLnytwddpSX8KlYSNYt4g==
X-Received: by 2002:adf:f390:0:b0:206:16e1:b020 with SMTP id m16-20020adff390000000b0020616e1b020mr5894842wro.194.1649239817444;
        Wed, 06 Apr 2022 03:10:17 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id s11-20020a5d6a8b000000b002060a8c810bsm10424560wru.24.2022.04.06.03.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 03:10:17 -0700 (PDT)
Date:   Wed, 6 Apr 2022 11:10:15 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/913] 5.15.33-rc1 review
Message-ID: <Yk1nB0pCLbjVsALE@debian>
References: <20220405070339.801210740@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Apr 05, 2022 at 09:17:42AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 913 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 62 configs -> no failure
arm (gcc version 11.2.1 20220314): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/980
[2]. https://openqa.qa.codethink.co.uk/tests/982
[3]. https://openqa.qa.codethink.co.uk/tests/984

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

