Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB0B53D6BD
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 14:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbiFDMVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 08:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiFDMVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 08:21:41 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F75252A5;
        Sat,  4 Jun 2022 05:21:40 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id v1so9884723ejg.13;
        Sat, 04 Jun 2022 05:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pmqso9zIMOVaKENg8ixYQEEuwrjJspTf8LoDXmCw5dM=;
        b=WZ9lkgiCH/Jl8fMueoWmZKjP081sYv1dNAqNA/yAd+BYS9IIS/pVfWi4FpYLtbwMw6
         UmSsOB7+Up1DXb+WZVs7m0KZ03vzx4BZAbp7q7JGaxOMTfucA6DbZZgndtF4neYN3j/F
         wX8ScIEYoUpJSiaejw7FKahhZF7SfHLWvo5/bvzWqKn5lHs+nGL4SHRh7I08jB0my1og
         Uj90zJF700W+ObiYm+NKpyrtUnJUdPw00xt4vqzPQ9zhK/xx7+mTSY9jBV3H4iW2v+Bd
         AD/QwZ7ZMw3a55DOJ3M75C6HNV/gcv9b1Ne2RsrvVDQSXTj02ej+gi60crLb25F5dmND
         /U+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pmqso9zIMOVaKENg8ixYQEEuwrjJspTf8LoDXmCw5dM=;
        b=bi/eUq144Omo2tGTpwNjhhyFst6tbNlVGCOlkNYmpDfTJmgUcxfLBZjCYMus9FCrXb
         Po5k/vug3lCIc6HtgjkfeRVX9qAXHYx3v6u2DVtwCpcNxdyk5xgdhN67P7NXwUE++Fx/
         Lh1UuDY4gIE7SenedZBFSxdCTflVZIQH6PAiKKuVrT/lFUWJdVooZvIyx8kks3zjHC+2
         f4O3t8H7Yycu1Kwe4nlwWhLRfiTJXVZfiZQm3sF95KhWdyRnYRiR+haOeY79QFmPDBtN
         eqdSMZeO1BFZWIUriCL8FpDJVwH5MSPZrERtHBbtnb3prXxcXBigztsSdWYqYdUvudfA
         pbBw==
X-Gm-Message-State: AOAM532Mk0MvboH+90i59HkbPLVCegYAF5PLNmCK+zDmOPV1O+mKR+bw
        bE6lMGmNiwzwZV+aqpPhzAU=
X-Google-Smtp-Source: ABdhPJwCRIoFb8c5LH04yGuVClr9DRYThD8wKRym+cVnE8sgx2DAltEr8J0zxYVpSw+uCDfZ0B6QHQ==
X-Received: by 2002:a17:906:824a:b0:70f:4c58:6ec6 with SMTP id f10-20020a170906824a00b0070f4c586ec6mr5783890ejx.648.1654345298588;
        Sat, 04 Jun 2022 05:21:38 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id h15-20020a170906590f00b007081c5ce04dsm3700293ejq.58.2022.06.04.05.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 05:21:38 -0700 (PDT)
Date:   Sat, 4 Jun 2022 13:21:35 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/34] 5.4.197-rc1 review
Message-ID: <YptOTzY1eToSgHvB@debian>
References: <20220603173815.990072516@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173815.990072516@linuxfoundation.org>
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

On Fri, Jun 03, 2022 at 07:42:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.197 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.3.1 20220531): 65 configs -> no failure
arm (gcc version 11.3.1 20220531): 106 configs -> no failure
arm64 (gcc version 11.3.1 20220531): 2 configs -> no failure
x86_64 (gcc version 11.3.1 20220531): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1264


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

