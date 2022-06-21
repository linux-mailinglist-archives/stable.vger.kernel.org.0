Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A2D552EFF
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349415AbiFUJoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349499AbiFUJoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:44:14 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C389727B14;
        Tue, 21 Jun 2022 02:44:11 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o16so18100962wra.4;
        Tue, 21 Jun 2022 02:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jS1rEjLMcqfKzC2GqwuyA8mjgGxCKj8kM3xv8QlDsyM=;
        b=EWEmO3mSkOUv9ADbKI4Bz+hdff9y1BFIt132WuXO7afOJT89MGDJH4TPKMwf7Cct4S
         OrrmkiOTBFYHFDxLWHW26epdyRE0e/2JKnQ7AzpWWhOCk3Vuxs+tOnTaRpzO0Y1U4gTM
         Wj3RaRMeuEWvq4XqvXjquFSmQxijTK2ph8uGb/mAfbsNiyWf4YYDl4aiQVz2ewJkuylZ
         o6qKFDGNnqssx6NWii2k2wGb7nDm8sNzIiX+cTLF5s0NyQV2kbzHutmTaZfRsFv5rYkF
         cYoCm/QCZj4tOil89Z0I9LDWUAV/T56z4wcm7/F5/BzYd+idu2brnU/1yUo1UyXlhkG5
         DJaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jS1rEjLMcqfKzC2GqwuyA8mjgGxCKj8kM3xv8QlDsyM=;
        b=TtrKyoM1rE4Xl8+UcGn83KR59sNHygz+ZVthwvoXrzDIu9PC04+BpqJMEEgOROQYdZ
         2M9H17rVyeXBDriBaMta94LsW/DWZvqDdvshddx6CQ99CITjTWaW6+E1eocyQ4CAZQEx
         SGV7bfMaojvCqYh439c0T3cYlNEFj31u/GxT1XQZG6b/eIdiZVurkYD0ddJB6o9H6CoT
         Q9IF3WKmTtvX3hqvPW8kE6fvtYv/EovowbnTvPRoCw5svldsFhSZbwnJscHfaGFMPGrn
         x1FKT/IEe1D42EzFsVBaSknurd3vD4ZhMipIsiYCfKBp0AuGxMPv7CFevU/Vfy0LV9p8
         oQLg==
X-Gm-Message-State: AJIora+kGnk9bYc9JpRJ0udy5jOIxlqPjGjpQanqA+hQGfcfCx65qh/K
        sLYp4N4pSKRv0EE8z91c9BQ=
X-Google-Smtp-Source: AGRyM1tQlgwGlCsWKiiY9eL1XT0ZUNO3ukZmsa4jqqKKaaj82hubqdZ0U8oUhsWGmUeGofyO9Lo7WA==
X-Received: by 2002:a05:6000:186f:b0:213:4ece:4086 with SMTP id d15-20020a056000186f00b002134ece4086mr27973254wri.438.1655804650270;
        Tue, 21 Jun 2022 02:44:10 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id n8-20020a5d4008000000b00210352bf36fsm15377877wrp.33.2022.06.21.02.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:44:09 -0700 (PDT)
Date:   Tue, 21 Jun 2022 10:44:08 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/240] 5.4.200-rc1 review
Message-ID: <YrGS6BqGx7DkIqI2@debian>
References: <20220620124737.799371052@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
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

On Mon, Jun 20, 2022 at 02:48:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.200 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1360


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

