Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F6F6522A1
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 15:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbiLTOcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 09:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbiLTOcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 09:32:02 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D302A1903F;
        Tue, 20 Dec 2022 06:31:57 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id bj12so29531502ejb.13;
        Tue, 20 Dec 2022 06:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kKA2m1GpNhmHLnfnQbZcy+sQ/FmMKp62G6SqfzzaR/M=;
        b=GDczp8FDlsiECF3tY8paH+ODlk3YQmcQFUEjE/Oa2vdD3wnxeYKa9SJqSCLsn+kB+K
         Tk3MEwBVsD5awvi2o5OLix9zX7WpBiC428wLOjBDVzB/gkY8mbD5GuzMWelCVN6EAWVu
         hezcxEreawPnKBIm4oUTx07+MJ6ku5nnwX61E9kHg/1O7TkLnXdFlYqOy6XKau+TFp6/
         9vFym2pLNuT3dRTXHZHlJ0KHABWb8/FXdXdFRZe55XI1PTqabwb31Xt9/Q+KEYjb+NO8
         9VgBPf4JscWb3Qu0gKJUbklaFUvRpgAfc/DH5eq3j1yNizPOQMfy9krmfkiTIVBuaoTh
         7yEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kKA2m1GpNhmHLnfnQbZcy+sQ/FmMKp62G6SqfzzaR/M=;
        b=Dd+EkwRQ4R2e3jlNZ7HjT6kcvCrnFb2rjV1PUhDCPqo6dkDJirMXW3NvQX0ERONlkf
         eshSCPGwYb3o9Hsgxc77RC4+vCwE0m4pJI7JSS3HnlvDlVpLqdq1zxzscpplYiOB4JVM
         fVjlKwoD01qA6GXikvtArXc09IHKzFJJHtOZPu60daG8HEDcFNtTmGeaGgNo7zb1D+rP
         PDAQZSRy5IHgvAY0SnIo5cwv4KNJ3davAZGyUcJfDHG8lv5A5JPMmrX3nWmn4ZNEU5dy
         BkyzUVbr2TFJwIpo2TD0bx71vUDL29Q7fQgf5P/9IS8kEKCecj9RXHwvlTXe4rC5sBKL
         MivA==
X-Gm-Message-State: ANoB5pnlUg27msjhTqbVtdjCoFluwV1y2tpwnJoio/MKdahYVXDYaZnT
        VGJRE2XvZ/cJJ7EjvMWLups7hlB9ySEXWH2oFSI=
X-Google-Smtp-Source: AA0mqf4Df+9Kirvr72XWWNGdIIHj0am8gCWMVFtNo1gKBiqkjG+h4fG/V2e23bwp/xaEEI/U1+5KQF9JWa50d/cJwm4=
X-Received: by 2002:a17:906:6d03:b0:78d:9d0b:a9f6 with SMTP id
 m3-20020a1709066d0300b0078d9d0ba9f6mr38397050ejr.661.1671546716154; Tue, 20
 Dec 2022 06:31:56 -0800 (PST)
MIME-Version: 1.0
References: <20221219182943.395169070@linuxfoundation.org> <Y6Gp25YJ/m+DcgWH@debian>
In-Reply-To: <Y6Gp25YJ/m+DcgWH@debian>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 20 Dec 2022 14:31:20 +0000
Message-ID: <CADVatmM9_d6gOo7VTM1ybVgNDM_w2+NdKM3DC67L9KjeWL7Ltg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
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

Hi Greg,

On Tue, 20 Dec 2022 at 12:26, Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.1 release.
> > There are 25 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > Anything received after that time might be too late.
>

<snip>

>
> Boot test:
> x86_64: Booted on my test laptop. No regression.
> x86_64: Booted on qemu. No regression. [1]
> arm64: Booted on rpi4b (4GB model). No regression. [2]
> mips: Booted on ci20 board. Regression.
>
> Note:
> networking.service is failing on mips ci20 boards. Issue seen on v6.1 also.
> Will report upstream after bisecting.

This has already been fixed in mainline by:
ca637c0ece14 ("MIPS: DTS: CI20: fix reset line polarity of the
ethernet controller")

I have tested 6.1.1-rc1 with the above commit cherry-picked and it has
fixed the issue.


-- 
Regards
Sudip
