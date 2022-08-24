Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFF759FBD3
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 15:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbiHXNoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 09:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238582AbiHXNmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 09:42:45 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB7889832
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 06:41:51 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 67so8330139pfv.2
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 06:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ok6BTmgx7Bk3qyjMZTGoGgyj9UUM/y6+7UqYvurHQD4=;
        b=PAde9oUKhlatOPG3MPo3S3oWahMuhh7pxf8GjmdnqnSkgoF8SVnUFtzjWp8u+7ZPMk
         tZOBmOnvertWphQBmXJAgvyhDlGn0JN+NXaoO/yXrwNTNStLot4DGRBQxSDa0c4Xkmc0
         w2l41xx6YrEJpdcdGN2/pg9vdfeOBLE+KjrWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ok6BTmgx7Bk3qyjMZTGoGgyj9UUM/y6+7UqYvurHQD4=;
        b=42jPz7DAaJHlTX04zQtv5CZlSF0o9mQN/KI2J847BXM7le27t6io6uYSqKAZ2eYC2Y
         E4LaHz8UthUJbJuIfPYASTux6S9RcPh+OVi2Q9I8cqavNCsvJkOdZ77EBN8tNtJ1TAQQ
         JLfx56MG/yKOvc6isoEullWY5HIHgtc/mk2Ehf/lqOMKen4LJThzZAgS7E5jbkrqmx1K
         KrLuRnaZLioFWOXbFJxRox/piow1k7JTBuZ2TR0A6azb+MHIV7M81w7aXA/QxApRSS4q
         1TsdmY9A83mXODw5zbn7i37uf6+eqq0INq0kCEIsSIAPRURX0RWhweXQQYxLz/SbLXQw
         dqtw==
X-Gm-Message-State: ACgBeo29U60yL4Nc6x1oRJEjyDcNNfBnBw635yJgBBNyqTbD9+YoJeqo
        aDi05/d+j0vWbnLbGj6ybyOZmA==
X-Google-Smtp-Source: AA6agR5CNgY3Asm/p0tgmzHKnt+tECPlAfzFc/ZnzpH/F9IlMnb9F8opAC97joPq+yLx8vGOWpGQNg==
X-Received: by 2002:a63:484b:0:b0:41d:9ddd:ade with SMTP id x11-20020a63484b000000b0041d9ddd0ademr23583966pgk.540.1661348510513;
        Wed, 24 Aug 2022 06:41:50 -0700 (PDT)
Received: from 2e380637d27a ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id f125-20020a625183000000b0052d9d95bb2bsm12903927pfb.180.2022.08.24.06.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 06:41:49 -0700 (PDT)
Date:   Wed, 24 Aug 2022 13:41:42 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/157] 5.10.138-rc3 review
Message-ID: <20220824134142.GA9@2e380637d27a>
References: <20220824065856.174558929@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824065856.174558929@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 09:00:52AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.138 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Aug 2022 06:58:27 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.138-rc3 tested.

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
