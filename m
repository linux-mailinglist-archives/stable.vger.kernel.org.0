Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64125532C94
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 16:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238373AbiEXOvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 10:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiEXOvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 10:51:18 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C8E1901F;
        Tue, 24 May 2022 07:51:16 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id h19-20020a05600c351300b003975cedb52bso1086675wmq.1;
        Tue, 24 May 2022 07:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A65GoFYcm6DQ4llvUMUhGseX2zCfGwtwPKFwGEmKTeI=;
        b=f2YaW23LZ+T4D5Atsq96eFMCOd/uMwPTQB63En7fswG9ktA2R05gkrcf8py+pyMjf0
         GUe5KeCY6W3mJzBDmZ1qaTZu7613u0QcIHD2HO/98ZeafJUo1AAec/W+G+qGVh69jQVR
         dC/VKxSpyurlLdcaSRztY+nw5wgS+gZJIeTdI6z1EADr6FWJICZgpiQe1Nh0g5ZwmbJt
         Y5skIGmzPWh8rX63tDgiw8PPU048JnLjR6Ky7BPVv5oKoX36CMV0C7GPTrmZo8fqYE2x
         dWDOkyrPhxVW4DEEaScdKev4/sbGSOBRiG0R/ijp6dIVO8C0WYlON+CGetrb7mTpKXwE
         WelQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A65GoFYcm6DQ4llvUMUhGseX2zCfGwtwPKFwGEmKTeI=;
        b=1pXdUFbJA1LCYZfObmO7lk8r6zxAhag/hTUYbxZ/+CJt7d3duwa0XUbiT2dq3qPJUV
         /FfhlDo3Xmff2TBaBggrgwhtk55dJY7B0A8AwYOtVhGF6CD2Wf9yjnuldz5htYjgRj23
         wWPJN8Phsi41aQMM4GVzPzRr6A1KCf5etMgm5kFEB+Tgto1PGHkEibo4p/MRw8sUErFV
         OwRiFc1azONhVEP8+PxOkKFoekm6Th55zhbtNGuf4J6B892scbpius5dF6lC2JiwMfk+
         fjBu3NRpQuVdhQIc8MFrZtQHiGNUzXdDx5Ia9kz8l/JZ0MUbVkXE8wFaom+WOEzWpW2d
         2u+w==
X-Gm-Message-State: AOAM531eWUSGiLq7ZFa3fB4vDhcIZ8hnGsCj5uhiBuRctgLN69tOl71a
        THQhmyxuYsrEjpEQOUVHq/SzjdM2L1c=
X-Google-Smtp-Source: ABdhPJwAyUxZPwpeM0FDgaFI8XxaTHYf8jWa+ECpb6AiLtvexxHA7kvAEJAGCWLX6t2aQPMyEz4gig==
X-Received: by 2002:a05:600c:1c84:b0:394:5de0:245e with SMTP id k4-20020a05600c1c8400b003945de0245emr4216576wms.32.1653403875235;
        Tue, 24 May 2022 07:51:15 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id r4-20020a5d6c64000000b0020ff9802ee3sm1120157wrz.35.2022.05.24.07.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 07:51:14 -0700 (PDT)
Date:   Tue, 24 May 2022 15:51:12 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/44] 4.19.245-rc1 review
Message-ID: <Yozw4EEpf0OLzZ/D@debian>
References: <20220523165752.797318097@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523165752.797318097@linuxfoundation.org>
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

On Mon, May 23, 2022 at 07:04:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.245 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 12.1.0): 63 configs -> no  failure
arm (gcc version 12.1.0): 116 configs -> no new failure
arm64 (gcc version 12.1.0): 2 configs -> no failure
x86_64 (gcc version 12.1.0): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1194


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

