Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374914D9B52
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 13:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241959AbiCOMfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 08:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240188AbiCOMfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 08:35:18 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52CB1C136;
        Tue, 15 Mar 2022 05:34:06 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id g7so100830wrb.4;
        Tue, 15 Mar 2022 05:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OSk/YlEnlvlXd1IJOQwCIF74Dp2eMfDimTf/EIilKN0=;
        b=VwLT0D+WxdDubWlkKRRtL3VQNnUBIfeyGoz846ggc7Z2LKTxgeEICvsuUY8LyZyR9x
         cw2iwihaJaF3SqMuwTXSGZwWysbIfnMqhsXW1ZhM9uiruoVmv+8lp7sPph+OX31mTe+g
         5MxbFDQEI+zuIKRE8zoo/lndTNNZgYkzqsRR79bpCkT2JbVzGvJ29ufrpS7CbZEKoVgg
         +D27AeTnvUYMOthu8lvCYYfgRnOdv9VFfltmLXnLQNVOeJItbPIsx3tYAUWlAQ8lvi09
         XAJU7XWqUin52eA5TjDyGU2vo3KWQyDPZu9fv1zSQXT1J8rzhtAOUvsKPFPkdv8uV+Cs
         GHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OSk/YlEnlvlXd1IJOQwCIF74Dp2eMfDimTf/EIilKN0=;
        b=UjlMLNqJ6qfrN2W56bvCNIZZGTHmCSKNQ6iWSMUFFg+pq+U6MVKo3qIgWmxIH8Cl+f
         oQb+JIrR403ttH4TfMeecZxunQx+StO+8uK+jv1cYpNtOttWZTG9BWlqvuepViAg4WLX
         5sgfjrM/hsrdF8WvIkpOVvSb6DpWTD1pstQPRF4/oIb0/wTisz7MxE63Fxarkd8ccYrw
         Wn5z7h8M+DnjrJUOd/EFAZpSFMpWg6Il/mfUyTVW5uQRH7L5gJ1k+h2cjqvg7BPWNXMf
         +MkC2vc46eH/z+oLuu8FEltbz+LKzjWMfCcI7E31wKmNRmYhm1tHk/l0+7+yHhEwun1t
         miLA==
X-Gm-Message-State: AOAM530yid/UzE5xCHuxYMEMo1Pz+/FLj0gxbxRzVaGzuEINcpkroFB3
        57CJE3VHDT6dlsKtyEVFEi8=
X-Google-Smtp-Source: ABdhPJwwIsLCt5pN17CU4+q/ov69MDWdjn4InO7WqEeet8OAS+6jfOWnOGGkiJHNRvHjSEgRKr5ATw==
X-Received: by 2002:a05:6000:1e03:b0:203:d8d8:a999 with SMTP id bj3-20020a0560001e0300b00203d8d8a999mr1326181wrb.264.1647347645406;
        Tue, 15 Mar 2022 05:34:05 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id f15-20020a0560001a8f00b0020397ea11d2sm10816000wry.20.2022.03.15.05.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 05:34:05 -0700 (PDT)
Date:   Tue, 15 Mar 2022 12:34:03 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/71] 5.10.106-rc1 review
Message-ID: <YjCHu42YS/4CfqJN@debian>
References: <20220314112737.929694832@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
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

On Mon, Mar 14, 2022 at 12:52:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.106 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 63 configs -> no new failure
arm (gcc version 11.2.1 20220301): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/882
[2]. https://openqa.qa.codethink.co.uk/tests/885


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

