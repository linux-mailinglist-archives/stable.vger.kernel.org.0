Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE14374D33
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 03:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhEFCA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 22:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhEFCAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 22:00:25 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505E4C061574;
        Wed,  5 May 2021 18:59:25 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id f75-20020a9d03d10000b0290280def9ab76so3531873otf.12;
        Wed, 05 May 2021 18:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9lACLQylxTNhoV+382sJLIS8tLV79pPOrWem8cDtSgc=;
        b=eHlBkLpN+MzZOLiFYlSVZkXcfq1MhfGofCNxMRrUtrJhj2g4p5G9pRm5AlOQlmwjif
         fhdxY0ARJOOzCfdvt250jYQGQFlA102Ka+danYMlTA7E4ufQeJnRff+B/6bRgJR6inCp
         dDZWAPsHXkV+VZO9LoQwmDnreI5C26UR7xqrEcF0SPxtcsLOVpFhV6Wti/hvx19jQfiA
         fTz1dLvrWvbrHBQRkM70bPPTNkaumaG04trWTbkjEJlL35ZI3pp73KR/e2hL+S2DcTvb
         NheEPG+TdDB+OlfHodO2i/qJ/cgbMklLVW5D62hudIASf8fkkcOXqOobQ1zqiaqWhZI+
         8kFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9lACLQylxTNhoV+382sJLIS8tLV79pPOrWem8cDtSgc=;
        b=aRMvCI7bws69TLC/eMdH1799XMlPbQjqjYo/BmW7PipZeom/Ux8Fb2dy3KH2IGr+Sh
         Xfy62Pu06KSoWhIo0hC6e8skr8HUZtLMbm/z+z7EbqfNBlo2vS3KclHaDFnOjLHZFJos
         iH1bdWD48BnS6rW3n/DIgeYfJkccTt1Ld+/K4EX//a34A+6wy8fBCGX1QF7IglsqqENf
         l7NuHo2NnnUBhVFL2cQxpND1N36Wl3454hcvRyI1Tmz/E1sHQbEfKuCTcjcZyS1cusFH
         eHpJ91NOCSR9VgPAwSL0Y1606KpR3nhuIKKAQT2O0JNSBhwD+ZsiXx4MwEfqroQfgEK7
         SoZA==
X-Gm-Message-State: AOAM530ms0r3d809jKBY0K7c+2Y/Ot8sl8n1WoMStsrA9ux23fAfbH04
        spJETTIDMkLZRxfP+3iJenMy0I+VbVo=
X-Google-Smtp-Source: ABdhPJyPfR7T79T64zoyIZd+axvXotDt114HDY8ee0QKfqUrxDAN5TNSPrXs7S3PxWaBpk3v0zkasg==
X-Received: by 2002:a05:6830:1555:: with SMTP id l21mr1381742otp.157.1620266364761;
        Wed, 05 May 2021 18:59:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u126sm197706oig.4.2021.05.05.18.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 18:59:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 5 May 2021 18:59:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 00/17] 5.12.2-rc1 review
Message-ID: <20210506015922.GF731872@roeck-us.net>
References: <20210505112324.956720416@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505112324.956720416@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 02:05:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.2 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
[ ... ]

> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak5558: Add MODULE_DEVICE_TABLE
> 
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak4458: Add MODULE_DEVICE_TABLE
> 

No, wait, those are both already in the tree, and both need to be removed.

$ git describe
v5.12.1-18-g77358801e46c
$ git log --oneline v5.10.. sound/soc/codecs/ak4458.c sound/soc/codecs/ak5558.c
a72a232ea459 ASoC: ak5558: Add MODULE_DEVICE_TABLE
20583d98df0c ASoC: ak4458: Add MODULE_DEVICE_TABLE
80cffd2468dd ASoC: ak5558: Add MODULE_DEVICE_TABLE
4ec5b96775a8 ASoC: ak4458: Add MODULE_DEVICE_TABLE
e953daeb68b1 ASoC: ak4458: correct reset polarity
9f34c0405723 ASoC: ak5558: mark OF related data as maybe unused

This applies to all branches.

Other than that,

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 461 pass: 461 fail: 0

Guenter
