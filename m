Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A66D5EC05A
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 13:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiI0LDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 07:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiI0LCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 07:02:22 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAB95A81C;
        Tue, 27 Sep 2022 04:01:51 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t14so14389340wrx.8;
        Tue, 27 Sep 2022 04:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=2reUqdIRFgcRPEcMeMvzedhfWPPf1EFjIomaQIVguU4=;
        b=PYfn5q+xtghjKSxJvzwkajwxx9l+D/ql9u7tcY/fivEG1MwY8CEf+lh4REjSxDsqoy
         fdTeLivEeLL0srJd2M1kC82mNNJPkCvsmCVlK9KNyGiYbkoLI+it9oHSbJfGHv6Nu5n2
         wvwgKrRum9QgY4jDXYTBXLfxsjGumngXL6mufHMe2JfOuJki6+Kn1r7YqhEvJckZ2u5d
         6f/6sHfUqTXIUEw0DpVmX7cPz7jwzO02iIdZagUlUn84uDk5hLE0zgCKTYZLZ3E6Mh0V
         n78tmL9rUI7M3kEnc7iRnqA45cqigpdzNklJ82qq/d1cO92hy62m75Hubkon4F1ggdgl
         uTGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=2reUqdIRFgcRPEcMeMvzedhfWPPf1EFjIomaQIVguU4=;
        b=8LXUIndLi6hcO1hXR7akA85PSVc7ILzV1QPZ7P3TUe3y9Ijel3qk3MCQRcgVONjY2Y
         6gC2JN2wzSGccmdHo67VDSNxo5PrcNIhiAO1AAzdRJUYQzAqboef1JM7DwRppU9dtvcq
         T21IIvtuPBQHJE3AFMohU8Cj651sxV4EqQlt0CinK4DMKVzMYLs5OhOvS3re3L/rkZoX
         oqKsuAr3OobcaZSoenN4WPR8l7vzl8r+UaH1+qiZIaSLrDAKI+rzSl+oprkAMlk4rRf/
         I9JVYb1f1o5e/8NQnnW1dCIlCPVxyYSjsQ+ZaUk7+cQseoHEd9VBc7krs1rSQNZ9FT+V
         OL7Q==
X-Gm-Message-State: ACrzQf031vbuiZ7fDgCMikgyLDbdojC3h4UyHO4nuqe6PDpELnaJJWF4
        MQ7CSgaVW4banQ0PRiZUw7g=
X-Google-Smtp-Source: AMsMyM4tKkTbVp7eyXuaZS/S1+jxXUVB+AVUXyfJLP68ckv0ilsKESh4p221QsK2DN/X2GH8u3jW2g==
X-Received: by 2002:adf:cd0c:0:b0:22c:bf18:2cf6 with SMTP id w12-20020adfcd0c000000b0022cbf182cf6mr1335336wrm.170.1664276509968;
        Tue, 27 Sep 2022 04:01:49 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id r7-20020adfda47000000b0021e51c039c5sm1484799wrl.80.2022.09.27.04.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 04:01:49 -0700 (PDT)
Date:   Tue, 27 Sep 2022 12:01:46 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/115] 5.4.215-rc2 review
Message-ID: <YzLYGg1j7hPbhBhE@debian>
References: <20220926163546.791705298@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926163546.791705298@linuxfoundation.org>
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

On Mon, Sep 26, 2022 at 06:36:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.215 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/1904


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
