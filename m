Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C66C5ABE8C
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 12:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiICKlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 06:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiICKlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 06:41:22 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2EC2CCB2;
        Sat,  3 Sep 2022 03:41:20 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id bp20so4706716wrb.9;
        Sat, 03 Sep 2022 03:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=VHxvMSygKVD9CKnhhsxoMpTwOE8lJNgN8OaQ16IexB4=;
        b=ctnp1WprFkV18F3xytmry0sIi7rKDFIVUO824H+qHvRr7wxcSHVRvwLtGIb6ncEWWr
         C/XO+ldnyCP250vNpwviyPO0SV9LTKlYntdM/UMzNKkiWMhEcrADMiDdBqWrYd8j9qr8
         kha3u3xC4zdzjToU2lXuYNyWipirjgs//+ol83zyh1JZ6BO5uq0UwNbcbRZHSfRnpedH
         HgkJzN6LJFUimOS3LR9dAwJjbJdk/r6GqrAj6xDFF8OU4Bo+mslgEvmfxSLX7cXaEsaT
         K5N1ZxJrh6T3sXXTHopxmlAozhrXijg0Esjg6yh/4AHc5cBtzjhcVxjI+tE42bcVba8c
         b0Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=VHxvMSygKVD9CKnhhsxoMpTwOE8lJNgN8OaQ16IexB4=;
        b=nvk9+jNlwHekqjW6S32cWfeD1jPhn4dfW4rMWMS180QilPJizFqPvI+IdQUDZRonvb
         jgsH68iBL2w8zAl8O9qMrQgPfHWeFsVEwlnC0k1cpBej7prfz6Hn7rwYqYDzw7Xn4HGz
         atLy0TJEFYYQRk28eLUIurs28TAoiMl7FipXUh6x/isfcmwBYfbGuuJsVWtmCaHjtbvL
         3VTsRn5lLYmUI5tUklysIPN8AsjZj9oT7V8az6669742Z1rJbw4j3A+ZVwMxIbyEH9Xo
         T2QvjDPLynOLP2l7NUbj0WAvMaXiwmr98HXwYCbuSwCQvo8/F067UmR9ER4mhtIeZP6+
         v1FA==
X-Gm-Message-State: ACgBeo2q8SjQOEVWpiqkGQLqrjp5MQQpt+vWf5lBFrpj7uC7QItD0Gsx
        Q9E8r4q6scjLOJBPwAVof1BrRPHAAk0=
X-Google-Smtp-Source: AA6agR76Eu5mo+Zm0caU9G80qHna7ylj1fTzEz1r05vmIY+gDmAKnH56VOKEGNgZcwhYnBeFSwE6ZA==
X-Received: by 2002:adf:e902:0:b0:225:5462:94db with SMTP id f2-20020adfe902000000b00225546294dbmr19247305wrm.481.1662201678922;
        Sat, 03 Sep 2022 03:41:18 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id j5-20020a5d6185000000b0022533c4fa48sm3444256wru.55.2022.09.03.03.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 03:41:18 -0700 (PDT)
Date:   Sat, 3 Sep 2022 11:41:16 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/56] 4.19.257-rc1 review
Message-ID: <YxMvTB3wl0cKDrt+@debian>
References: <20220902121400.219861128@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
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

On Fri, Sep 02, 2022 at 02:18:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.257 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1754


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
