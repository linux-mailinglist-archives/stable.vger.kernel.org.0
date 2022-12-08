Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BC3646C13
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 10:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiLHJnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 04:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiLHJns (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 04:43:48 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7534D5B85A;
        Thu,  8 Dec 2022 01:43:47 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d1so922570wrs.12;
        Thu, 08 Dec 2022 01:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8JUeNam5dvHvh1KQ6VhNLFAWscAw3t5vWWL5maRGNHU=;
        b=ewC8hQcf3DXfoSrtasEwx4VwE+UXfcCdQkv+fgTtDeTgky4ckgjAfdMg0xpmOcpfpB
         GQb9TUfFAF1aBRu/qi8DoT2ytnyxlgZcmwEDAndO2lfrAg03BX4lbVA/woJRjKR2kDDU
         BWFtPt89JtaMV0FRGpdail2g8gA/6E6oVWWVwvINM6RE15+z+QRwrSIYJZpjQCktcl7K
         hVbIjHFQve6KgLaAgGc65/ZK8x4vSL2Oaxc0NFb7n7i9LqwmXS8FCAB5rHrLf/8qiAOb
         Hn94wyAMHt/LnNlfXz2BqPj7xY61x6KoyCsZKxlSURpCMFLnBJei2R9QmUDuFDuScitG
         d10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8JUeNam5dvHvh1KQ6VhNLFAWscAw3t5vWWL5maRGNHU=;
        b=g4TPfJkSO9TwNbr7GeKGWQWIFz1mEUbkFF6002UUQBzRW4Xl9ItHiN5lfnyN7fnztr
         4pdQPKeUYS46kFnFDhtDPhbCsUKgtvR5nKPz4pIBuZBhQHsLBr7LjbfFDeWx1j5eDN5B
         n64cMFjnzQxCAb6cwi1IAiwWPN7pOfFoE429VMqGy0WZyzooJLMHpBxlHNU1psGeB6w+
         yeINpsrfsa1MRRAO5MYrwqEcDceP/12ZqJfqJ+nbmqyS8yGCuH1aLQ+tSeqM2jaQUu3u
         ycBLU2Cev6Wfn20qbEWVHNEV1pKDijqNhFAbN9+WWf31ReeCS8HN8NcX4N93xxOzR99u
         7Yug==
X-Gm-Message-State: ANoB5pmakegLGFr4ihiy/GnxOsqn1TTng9dAqProNk5mb+wxbaI9hcV6
        dEO+AvYbd9/KZZ+9kL+Lf8Y=
X-Google-Smtp-Source: AA0mqf6m6PFe5W3vKH52VpJV47+i9WopzKgZOGvO13Ft4wLUDPbeYzrQ2i6bJU0jT5JoKjTmJT2LJg==
X-Received: by 2002:a5d:6a0c:0:b0:242:4bbe:2d20 with SMTP id m12-20020a5d6a0c000000b002424bbe2d20mr1052505wru.42.1670492625950;
        Thu, 08 Dec 2022 01:43:45 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id z6-20020adfec86000000b002368a6deaf8sm21408720wrn.57.2022.12.08.01.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 01:43:45 -0800 (PST)
Date:   Thu, 8 Dec 2022 09:43:43 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/110] 4.19.268-rc2 review
Message-ID: <Y5GxzzCJaY1xzefx@debian>
References: <20221206124049.108349681@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124049.108349681@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Dec 06, 2022 at 01:42:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.268 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2318


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
