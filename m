Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DB44F7933
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 10:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbiDGIQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 04:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiDGIQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 04:16:25 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3513C1C404D;
        Thu,  7 Apr 2022 01:14:25 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id w4so6595916wrg.12;
        Thu, 07 Apr 2022 01:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KFIeVKLpdxuYvgcKFLrF9+DdKD62nPLRvcmnd9NEuo4=;
        b=YNVrDgNjIA3es9LFQ9IMl3Lo3tifGEVL5R2vM0dOgt4XLMzW892428a1genFSYqFFM
         H2QB/04wE+AAiFFtxMx5b6PD8J6rqAbm64DgrLEWUFsXNqLmIAQnIHZmb8II528ZfgOi
         ipziDfFUmsnI8FeAdIXWNGlUN3JBJv4cUuBavQVtZfELdIgK/wEthkP9ZrJ+hAJO8j1Q
         8RBcQwImD1tqV2B/c2XcSmGlvh74fc20MmnNymFSrc+gVfHwUleW64Yh3mVHNTBXli5J
         ki6BA+OPQwSltQbmqgYPkrIkH7wn9JUuypVYaunQfTXsFv+LAV2/d/HiWHWIsG3xt815
         V52Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KFIeVKLpdxuYvgcKFLrF9+DdKD62nPLRvcmnd9NEuo4=;
        b=Fa1nKWt2QXpwerbnd2z01JpP/d19d93b7RjmP4IUlqxmX6E41h0PsqXXzxr5/blJuk
         +a89G8NpByn2CRBM2VaS+vzdUEKtOcxpWwnBvW///JiIzze8KPAtOxp1/8YdGzYw9jkh
         rSUdtXW5ZuaKUe8PS7ApYMAzDcbFcaQ6fgISw3b/tEb9MRLNr3qnUQnlpIcVnhTOtt3K
         6EnzmFm8gQ0+RJ0NL53tQxCeCTYIxJysNcRl+jett6n92NyaCVzx8m9MwC71/VdU4D5c
         VXIZq49bKTeLFa1cAh3fOEdMTIV4OhdSaEs0eUsNTu+4ORtT0gWv8w+Za27lQMTDaL9t
         nBaw==
X-Gm-Message-State: AOAM531g3jiH2p4np2sQU60lQnEPZ1LwU3/yq40WF+jGY10EKKnRMATs
        yV1mdwgtYZfUpYYfJh0Q9Xc=
X-Google-Smtp-Source: ABdhPJwLE99vBsb5So6xKGgdj8h83b9nCEn42B6zUdz2PsCsj7Ko1BVTelzmiwCzjkcOPzIzUCjonQ==
X-Received: by 2002:a5d:47c8:0:b0:207:8b23:bfe6 with SMTP id o8-20020a5d47c8000000b002078b23bfe6mr1043997wrc.329.1649319263613;
        Thu, 07 Apr 2022 01:14:23 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id e13-20020a05600c4e4d00b0038e44e316c1sm6705916wmq.6.2022.04.07.01.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 01:14:22 -0700 (PDT)
Date:   Thu, 7 Apr 2022 09:14:20 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/911] 5.15.33-rc2 review
Message-ID: <Yk6dXAWiQEzr/iia@debian>
References: <20220406133055.820319940@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406133055.820319940@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Apr 06, 2022 at 03:44:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 911 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/989
[2]. https://openqa.qa.codethink.co.uk/tests/991
[3]. https://openqa.qa.codethink.co.uk/tests/993

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip


