Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2646570F40
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 03:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiGLBLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 21:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbiGLBLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 21:11:35 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBFE3ED5A;
        Mon, 11 Jul 2022 18:11:34 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id e16so6176013pfm.11;
        Mon, 11 Jul 2022 18:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cUG7EpIXhx0wnuQNzXMv2sJvGVph3F6oE2vl69PXnZg=;
        b=XrTmhdav6KjxRpfSt+R+LgfONHrU71yyge8HG4aL717gn8TQv8nEbrQYeLzcenp9cm
         yIcFCmfrDHyPCrQDGId5ZgoiHVSf80L8GmEG3RObSYb8SNqmQw6i8JX1yGhm7qQNU9Cd
         4SsB6QlkerYHYTC8vxjF7WdRtnLAEov54NPmWr+6boX04rOV3jNvAnh/2s4MBRpXvFo7
         pL8XNqETkAZGYtk/sbcv+ee2TbwsmcBhWk/qocTfnCG2vAa5vD4+x+GHKMXf0iFN5BLp
         pi+CN3/FS6nek/mAf64B6Ne8gMOwOeoy5LPQLWlMV05hm/3ZMujsw4UY/AgV1PH0/kN4
         zngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=cUG7EpIXhx0wnuQNzXMv2sJvGVph3F6oE2vl69PXnZg=;
        b=hn6uqvGI1Tl4T7JDY4KKw31mXFZLXEPUeq1JRTvPXOPOHJydRkJQnV9KbfCZ67B3zy
         gzN5ZzrhMu2poR6L1RorbzttUr9dS/+ZLkqijllgPtKE+nSRZ4mmxvdA4rHzhBHww1CG
         40slsSDnmAdezNVS2UzQeErPlsriY1AkLjQjs4rhDm51kQ6evL4qIaWdDDOugBBsHt3Q
         K24AwcB9zqjHS27+8rKhQLrSXCl6YnEvy3HmTDaBDo2bVx/UcG/iCCqsEmk3Z7csRM8o
         gs2CUFdp5kjqw7X71DRgYZEq8qBRXrP7T9F/iSfgVRenwa9B0cGP2aJllAti02eLgF0j
         5v5g==
X-Gm-Message-State: AJIora8FldLT6/o5yXgGllTDW+HHkgIUFC1fjDxxt3smcAC8CUaXJS1Y
        +PpB1pqjd7ZJXimONxpIjrk=
X-Google-Smtp-Source: AGRyM1s9RSwFLYgm25df7Hvi5/YEZ8VstOfcPJw+O0qXIIkV99C3JYh7bBl79NFHpkjHo0opxdtcyg==
X-Received: by 2002:a65:4d47:0:b0:415:d875:328d with SMTP id j7-20020a654d47000000b00415d875328dmr12206288pgt.80.1657588293636;
        Mon, 11 Jul 2022 18:11:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id rj9-20020a17090b3e8900b001ef8ea89a33sm7720355pjb.2.2022.07.11.18.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 18:11:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jul 2022 18:11:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/17] 4.14.288-rc1 review
Message-ID: <20220712011132.GB2305683@roeck-us.net>
References: <20220711090536.245939953@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711090536.245939953@linuxfoundation.org>
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

On Mon, Jul 11, 2022 at 11:06:25AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.288 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
