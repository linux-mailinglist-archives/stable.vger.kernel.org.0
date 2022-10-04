Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC4A5F4203
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 13:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiJDLaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 07:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiJDLaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 07:30:23 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C893813F1F;
        Tue,  4 Oct 2022 04:30:22 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id w18so12119363wro.7;
        Tue, 04 Oct 2022 04:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=8WGNbK4B0qKTxutfrQ3EIsNMiF7ecOWgMD8vQW3LPN4=;
        b=CEYgHSMpmVp9cXIqQc15iUn1lEGrhZoflHTBMH7Cw1r5ccc6PkH2PSNC3BP5VGyzUt
         0TzBeVj18q4PNc5llnBzwBBqgEwYvBuTu4odOjQkbmw75T5gNU+u8jAjs7UW4p3prA3j
         OH3xnDBsMmRKyEmWBWRp4HHFVjTHYTl49dteZemVlLXYHV5UmRsq3rmj4yqzJlwP9vMu
         MxKI+Pe1dfb+E3nGT6X9eIAAkGDlzge3+JAKk6hORZKIRMAI0nX2ySzcynallCFzX58z
         cR4TDj0RzSS8M8oKT8PhcxZfB5s5XhpnXLTw96EHNcNOBo6fK4lgbB8fwNdNXk7Rs5et
         Gwhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8WGNbK4B0qKTxutfrQ3EIsNMiF7ecOWgMD8vQW3LPN4=;
        b=HuOB70md/dun1ryDMTOo/2x+h0oc4bXSvwRwqnFmGS0tvsCAQ7paXPv/0jCN5lmFrW
         Bl2eKazGG9AgbcT0q0Kcox+LO7MU51NR5YD8ZsSPk3G5yHg/HiRbxWKPAtoREfBBh7An
         1rRRhyNxOsgd4arstFX/hQwQhLdGf62+iYzxGdTzstT6rKcaQhSAJPIGV7msGv1ra/Al
         NtEmzqQJrYfWLPeqYEjlYMnNSfisBpgqdBdKLE1KmG8FidL8HRjTizVYZvNv/uHo4mNO
         6kfzgMcnUv5gdqK6ygkNSx82iCYbmi8vgUy/rQLFwv99O70CSPYvgyWClL46smFq8Fvt
         hT/Q==
X-Gm-Message-State: ACrzQf2GMv0m0zqMM+tu0H5Y8KNueVqmGiAzqzlWJXGivHjrJpuynoQa
        wdaLMin/PmWAs3kPnWWQc1ONv9witz8=
X-Google-Smtp-Source: AMsMyM4RTZYu7lJnRqNFX9kpgONVGs68WX98inEE/KLJeZhvVPmlM+Hvj3CS/aSmTVVIkni6PUm3WA==
X-Received: by 2002:a05:6000:70e:b0:22a:c7f5:c5f7 with SMTP id bs14-20020a056000070e00b0022ac7f5c5f7mr15992440wrb.333.1664883021402;
        Tue, 04 Oct 2022 04:30:21 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id u15-20020a05600c19cf00b003a2f2bb72d5sm26089123wmq.45.2022.10.04.04.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 04:30:21 -0700 (PDT)
Date:   Tue, 4 Oct 2022 12:30:19 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/30] 5.4.216-rc1 review
Message-ID: <YzwZS0T+UFB5mh6W@debian>
References: <20221003070716.269502440@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003070716.269502440@linuxfoundation.org>
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

On Mon, Oct 03, 2022 at 09:11:42AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.216 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220925):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1944


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
