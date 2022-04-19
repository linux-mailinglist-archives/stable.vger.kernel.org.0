Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784C5506BCE
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 14:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352127AbiDSMKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 08:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352085AbiDSMIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 08:08:18 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C92CBCAB;
        Tue, 19 Apr 2022 05:04:36 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id g13so4692806ejb.4;
        Tue, 19 Apr 2022 05:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9FV7klbf+RsSn0x8QE5iq8Fvm7yQ6Ge2whXajnkbVjQ=;
        b=DXWNxKfkgL2BWIgyumZpPk/BVgi2KlI+8JwSYINiWZw1/nI1vzQNm0j1EmIftp1NcE
         Xww5Kx3LZ1F4SCbmDLCt0NbKuFB9NTnR4rrCbBZrJfuxQrvzu3HzcCgbpZTgQjklk2zq
         xHKINJ71u/OGh/Ib9tht6V4SYsvpm654aWoh18yoJ8q1yasC6VoRDFKPnxAZ456a5/+0
         wjeYILWSXvqs46HzbKVTQX5/ERZnxhB7udi2irDq9yyjftlxQJ1nF9qNlGZGuc/50Hrn
         QcYhZS8xb8JmmSTC8ss6XADpMyvPVKcwDCofF9dZzyWBXPd6Ib9MueV3NbUiZUxVAy8K
         pybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9FV7klbf+RsSn0x8QE5iq8Fvm7yQ6Ge2whXajnkbVjQ=;
        b=B4WbzzCBOsfO4tmkGtr+ijR/DgTz4J/4ydIl4EQejvzoU4/awdi/LOBw81k9G4RNmR
         kEz94qLEpqJui6VpIW8hfwJWWCJe0tMcRjWJnhVaghvHB+30nJbImrZesV4jYpfe+fWl
         my6Qau3wzyOG5kv927197qjgF86vks+5vbLobQBmXZTbFIi4u4+cYZvwgilYg/tXyy8M
         AE+jQ9zByaEbsE9x+nd0/uBjpX9B1d3RLfXXlc6LasDwFqbnKPoV/x7aLV64gpStDsrE
         3gEIo6sfF7W7Kh2DIzQOjVhnWcUyxOwWaBRSwvK6KT1j9ZFPu272oE6LTktEb2OUy1BP
         rmTg==
X-Gm-Message-State: AOAM531fs+7/5d73anqEQx4sdy930JwWbM5gfQ4ZY6DZtFmkMBJihp2l
        dwF0ntHlAFZqxjsYuccMRoI=
X-Google-Smtp-Source: ABdhPJx06spmK7i6+GtlDsE9rl2JG1fx4/hTNYuMXa/AmQvk8c0yTFjmI19cWzmF6JolaO/cvjrT4g==
X-Received: by 2002:a17:906:f0e:b0:6ef:ee4c:b558 with SMTP id z14-20020a1709060f0e00b006efee4cb558mr972626eji.104.1650369875127;
        Tue, 19 Apr 2022 05:04:35 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id gy10-20020a170906f24a00b006e894144707sm5651563ejb.53.2022.04.19.05.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 05:04:34 -0700 (PDT)
Date:   Tue, 19 Apr 2022 13:04:32 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/105] 5.10.112-rc1 review
Message-ID: <Yl6lUF8pnO/piCFB@debian>
References: <20220418121145.140991388@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
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

On Mon, Apr 18, 2022 at 02:12:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.112 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 63 configs -> no failure
arm (gcc version 11.2.1 20220314): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1036
[2]. https://openqa.qa.codethink.co.uk/tests/1037


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
