Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85AD533463
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 02:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiEYAml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 20:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiEYAmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 20:42:40 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBA852E4D;
        Tue, 24 May 2022 17:42:40 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id y8so178215iof.10;
        Tue, 24 May 2022 17:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M/vA5r8vB9NIZuGH+3Gn4tx8CmzZqeLKwScmkVCbeQk=;
        b=n2L99c5Shgph/DR4WjewPD48c09R9zz3I8cw0ztfDD3Qh3KdpF2X3OZ38KlVnxSUAN
         kpo/2TMLVAzYEXW0k6vU8Cfg6ZwGyVajhQCC89eqssVL9jT/7B/wKVFwpopOKd9n1vge
         U5lj/KVZ/aJgAEfSNDdQySzim8oMeEkI9oeeNDHlt05gK3ndEgO3j4EYcx1I/PUeV/0v
         /0haj6FterVuqzvw7uRaX90uJjGIFXYjY6w+ax9HYSzt9Bc9yXVThVUUonujD6vnekxK
         FW3OZQzIYRdJvSjYdRa8YR1JsceQj+ppA5OVBEDOsta0rZPzPwGcRLkSRMZPs9ial9Sh
         3SeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M/vA5r8vB9NIZuGH+3Gn4tx8CmzZqeLKwScmkVCbeQk=;
        b=IACcZ5sHB73TSIdCtsch7mtxhx+kvXpNe78p5IrA7jK+UYZkc+HnKK951duMips3Sv
         geut/XXRRKBTH4fcBIWV4Af6+4HFJqu/HBRpyr3gplML3MSRO2hEXoTe4YsAgK76RUsf
         LzBClZxBxYF40clRPk0sLJWh0fI5gN4N25sILYyZ7KAGT6RL2x7ShYqwJdO2UzDrdoP5
         3+xqPwfaLoqhy27UwB9oWgC/FZVDrsl7bznK7xDVjwPGz4SmhvQ4hgtRxoJgJnS6DsPT
         X6CQjfhCNRVpAlIbCTkqG0xJ0c1UqOsm3Nwexk0yr159yFF9qPlZBabTVQAlkMHg13KV
         oJSQ==
X-Gm-Message-State: AOAM530q4j/W0QHU9exrwK//sXRzztdpqAJPrswUU/OmQQIuqGEvS3Xt
        1BAy/r7CnxU3PjB7LbuPG8a19rZYVRJi5S8mlrM=
X-Google-Smtp-Source: ABdhPJzHA9OmUKmEMxk3iOzuQs9Yj/N8YCthYnmMrHZK4bJTZB35BW1J5JCBoPuJtgua05+Ixu/Zamn5iVZuj8b+sxA=
X-Received: by 2002:a05:6602:1801:b0:662:37bb:c722 with SMTP id
 t1-20020a056602180100b0066237bbc722mr6750290ioh.202.1653439359362; Tue, 24
 May 2022 17:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220523165802.500642349@linuxfoundation.org>
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
From:   Khalid Masum <khalid.masum.92@gmail.com>
Date:   Wed, 25 May 2022 06:42:29 +0600
Message-ID: <CAABMjtGTdZAAwr8Kxy1fxXJdYo1WuoiwE_MrSbdimNaQEcxCRA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/68] 5.4.196-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 11:08 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.196 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.196-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my arch x86_64 system. No dmesg regressions.

Tested-by: Khalid Masum<khalid.masum.92 at gmail.com>

thanks,
-- Khalid Masum
