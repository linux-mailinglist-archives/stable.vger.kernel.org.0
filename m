Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516BA4E8146
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 15:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiCZODT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 10:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiCZODS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 10:03:18 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE94A138590;
        Sat, 26 Mar 2022 07:01:41 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id u16so14276902wru.4;
        Sat, 26 Mar 2022 07:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2j8Ri7xLUYDefCVJcUnV8/o8GOr4jF0zQNRPq876plI=;
        b=VdEocQScuWQuWOJ0qb3s5SxMmmZrNyCd29AyzIx81VJhoYcRfQsyWbvJejCdTeo3c0
         XNbIVw7pz1qSuiR5CV5Cpit85Knf5A+oAIMCwmaeHR9wlzaO/GRgeR+wvT/bV75uMheb
         kzaGcDgYA3HcBc1osCc56XR0wDvtMDgjKC4QNOqyanHrGtOKMnLqCm7/vfzEfkPpQI6c
         +oCkwFycD65HIm5Jg7J70od80QsdT52FojfqHsLQU1baIp/tUuEJKRhCAtFUg8C+crLa
         QLFY32B6iHU/kMiGoIIuQDWjdwbnbrebLyo0eJNYxiZ7E5GcXNrVCjhjJPwvuQdP2Vzh
         qr9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2j8Ri7xLUYDefCVJcUnV8/o8GOr4jF0zQNRPq876plI=;
        b=Q/MwQ1XOGfvoiuooUXeUULt1g8MJtYFDzNlli3tZ3mRzwtgnaIMVexmjPsSyQZi0zn
         GcpemQzrlC0Fke8AbPDZ2/1K37Lg0ETWaVJuamAO8anBr4QMwk2fVx0GY4/3wS5+LGjy
         xnpoyjydHJM0iecIiedchQvEE/2/ydVjlIjsrmlqnlic/8MmS+qepq0F22fjye6HBKle
         l19AHw/mhoTbRd4d1ZTg3O/10EiIdPD7BoOfyg/OOm6yO7WJWK0jinXdfUaceD1SitIB
         d4mWouTD3FPK2Ao/rUxqMcbRt+62WGyeg2G0rBCSn/J55NU377M9DwtQ1sMSW/8QuPGj
         7/LQ==
X-Gm-Message-State: AOAM5320E+VahLXLUf0ylFP6VL0BvbwKVcHAnrNyps+YKu41IPLiXltA
        eEtRcIVwr5ZRNi8x1IpNfS4=
X-Google-Smtp-Source: ABdhPJyqNPnJAYvlaoh+jNrXVGmjvn0bsNfbqqPlzEfTsiCZZ/o6AAoJyWqFY9zdhvKTgiRnjHN/9A==
X-Received: by 2002:adf:816e:0:b0:1e4:ad2b:cb24 with SMTP id 101-20020adf816e000000b001e4ad2bcb24mr13516563wrm.521.1648303300090;
        Sat, 26 Mar 2022 07:01:40 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id p11-20020a5d638b000000b002048a77636dsm7319713wru.97.2022.03.26.07.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 07:01:39 -0700 (PDT)
Date:   Sat, 26 Mar 2022 14:01:37 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/38] 5.10.109-rc1 review
Message-ID: <Yj8cwfWBAZg5UY0a@debian>
References: <20220325150419.757836392@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
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

On Fri, Mar 25, 2022 at 04:04:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.109 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 63 configs -> no new failure
arm (gcc version 11.2.1 20220314): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/942
[2]. https://openqa.qa.codethink.co.uk/tests/944


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

