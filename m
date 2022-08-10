Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDD658ED27
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 15:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiHJN1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 09:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbiHJN1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 09:27:12 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E60D2ED7C;
        Wed, 10 Aug 2022 06:27:11 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id z16so17691560wrh.12;
        Wed, 10 Aug 2022 06:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=/M9dNxeM7iCKFSqwJ8lpTWkXqM4+aw3b+yIuV6QyGnk=;
        b=cpEQ0GvzFuRNTNuj8XzGzlzku03fhCsW4y+L5S/HD/aNnT9cBiTCgWWa/A9l/v6qk1
         rv4SAR4ayLX9E3xRsJUUcyA9ZFdVxOHvPU1Mc/KnYDeOehaT96Ays8TFX+wmK1gwI+7c
         tetjXMoqTWmJtb51B+gDM+mOajd8p/ZwqN66y1+xT3GPYZY45CvsBJJ8eDR20sePbvvL
         aZux+5cUYhNJh2YoRuHMIuojsBHiI93W71vewWfn5Vf7YRpBzNOnevU8PqnzpiNMHmvj
         r9fPhDtyecpTl91J3yQXFqFxFyckMVo4vmEU8jcL1P8p+AYdHLhYbZ/TzGpgOUVgr5Ix
         RvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/M9dNxeM7iCKFSqwJ8lpTWkXqM4+aw3b+yIuV6QyGnk=;
        b=6WSXTw48wzzFFn7nqxldeX4VTb+qFofpvS0ObRjixr6g7boUX9/1yecstCq/qLIZhu
         ZeQO+k2ZsdPvqBQdfywXur5HTXqDzw2aPadCz47clEawkKyedkF+hYHucn7LlFrgEicr
         Olce8SBwd+4DTYBppJMNsw7CLdi+uxu2o7ThWqchFJ4tzK059UUalsADbnUPg7E0AjJi
         BWBbdJN4IVNruM/v4D/usySgIHYNNercwOO+GwzpYv//yCb3xZYMrHMHbNVUnyLBy4zl
         0YQF0H1/dUIW3o4Ibkhyg6dGF3hsLjmr78ftROHP3l6Pomxmt/QzguaWCvj3cCMaz+w6
         oUig==
X-Gm-Message-State: ACgBeo0b1qSoiqAo1D5mSMWeGRTceUZWW2MquR14EJg5YDSrOvkrZiXa
        ErcRTeocmhrOVhcpSu+72wW6cfkRtQ8=
X-Google-Smtp-Source: AA6agR5Fjx3DXf9bA9A14zibremigrg2N9x6uL3A/sB/kH51wdox4bUAJd22EqOaaZYVlRVDMig+RA==
X-Received: by 2002:a5d:47c8:0:b0:221:61d0:c790 with SMTP id o8-20020a5d47c8000000b0022161d0c790mr15238655wrc.364.1660138030152;
        Wed, 10 Aug 2022 06:27:10 -0700 (PDT)
Received: from debian ([2405:201:8005:8149:e5c9:c0ac:4d82:e94b])
        by smtp.gmail.com with ESMTPSA id bg10-20020a05600c3c8a00b003a2e1883a27sm3084127wmb.18.2022.08.10.06.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:27:09 -0700 (PDT)
Date:   Wed, 10 Aug 2022 14:26:58 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/35] 5.18.17-rc1 review
Message-ID: <YvOyIns+X4vIbJxX@debian>
References: <20220809175515.046484486@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
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

On Tue, Aug 09, 2022 at 08:00:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.17 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.1.1 20220807):
mips: 59 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1620
[2]. https://openqa.qa.codethink.co.uk/tests/1627
[3]. https://openqa.qa.codethink.co.uk/tests/1628

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
