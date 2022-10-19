Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25C1605065
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 21:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiJSTaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 15:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJSTaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 15:30:04 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F869DD99;
        Wed, 19 Oct 2022 12:30:03 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h185so17158279pgc.10;
        Wed, 19 Oct 2022 12:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=idjMQbP7XA0AQq1z/Q9pWMw/xMrVrlKLJiJJiIS914I=;
        b=ivAkRY8Ll5ShyEPBxQMVhJvQIPwlI8NHDLUVM2eWwslSMlyHEMvmkWO6h8BrSRa/Ip
         HeE3M1hCP839+YbNgBK37Ah+TWa5V9QikiY1VtMnno3daSz/Ia5tWqULekT02bQG5HTm
         7pDf1N84l4kOA5huh3rqdo3NYaFjdEJ/lNwJsfwryBIXOWAeQ4AGi976poWTO2tUtoB4
         GtbrnEiyjVP9WW8r5H61nbj/WJPTQT5LfWldizZxX6g8xzJDLL7K9hG0vsU75Di4LlfU
         PiYnuPBaVHb7qJG9sO+cKG4bXU7VtpKBJm/OonzW995Tauj9YI19SmiNQ3XGyV5jSkf1
         QLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=idjMQbP7XA0AQq1z/Q9pWMw/xMrVrlKLJiJJiIS914I=;
        b=PCOjX4NXyvZAQ+UK9wOjg8ZVlOKMTCpRNZkEcZvQKMTFIrgop/bk05ZwlNW52AiEuW
         gYaYllBQ/4KksaVPK8c8AKlG7irIzNuDFP8fMpvB0nOv51H96xHojN7NHAWSxfk/VjNE
         SXirqHy3y0tOG8dWUL2jnj5hL5nO2i3nNHcoTCNXwQfw85LbeOFZV2s/97HAsMMWvMra
         LKS5auakXbxicfi/MzAsTmYBL0t3tzALsesMRXRE+AfJnAxHRuXnRNUYs3vyQ6UtmcPu
         tbV9EHukuRtBFchCz8w2uejutMPe/kpdT25yHL/OmJbZ7VSvNtm79Lidm9VqRPniXHeT
         SOWg==
X-Gm-Message-State: ACrzQf2uIeizamegBqZcRqejk/FwKptk16L2R2mx0iLMLv9JbZ2BsInO
        FC6RK/N0q85sjs0XgTsXNxtjHr+xjjmw9euonqU=
X-Google-Smtp-Source: AMsMyM75pXTEiCBk/YM2sm3Nc/NOPU1Svm1rWZWimAEVAY+WgLB34YE+Vc9b2h5jH00sbZt/T3Dh5qYtrcjDjHfiXWI=
X-Received: by 2002:a63:26c3:0:b0:46b:1dab:fd88 with SMTP id
 m186-20020a6326c3000000b0046b1dabfd88mr8592667pgm.251.1666207802523; Wed, 19
 Oct 2022 12:30:02 -0700 (PDT)
MIME-Version: 1.0
References: <20221019083249.951566199@linuxfoundation.org>
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 19 Oct 2022 12:29:51 -0700
Message-ID: <CAJq+SaDFOZyz8ua_5SCUvAO0yXGGKZ8qqK5TTC09zotVy8oOtA@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 6.0.3 release.
> There are 862 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Oct 2022 08:30:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Boot tested on both x86 and ARM64 test systems, no regressions found

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
