Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6286D5528
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 01:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbjDCXV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 19:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbjDCXVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 19:21:55 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3CB211F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 16:21:51 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id fi11so120101edb.10
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 16:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112; t=1680564110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q+x6zT/m+dAsDwlmZTQ6fHnL7mfdbfX7S5L6qymWph8=;
        b=fGV2tUpkSYHP+auN5Tt9A0V8ABbv8FjjqQfuwUDI+bsm8v3WfKVEFJ4rM3kXuUugSr
         fDKSVo1cTp3qhHnQCkIjnIxMjXt8rFoJd2Kg17R0fvVKd8/u7Wb//I0gE51POVtMWPw1
         aiZkDQxhrXyzWZO/zw+UjXhSj9s9VdhqHhdp8cLOzu9ztMZO8bbxYOKxaqv4Ds8w5Q/b
         8C2zbNqzMl6LjEKk7Q4Vfz2NJFAoxLWtq/CJ7zFBugYpQGOzKAkEXAXyg4MI41LtPNQX
         7dJoRQ/kxzYad9pN+864gYPaWMN+gRgQWU32+Qvt5EZAhYT3yLOxLb1c3Wt13PNo60DO
         G3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680564110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q+x6zT/m+dAsDwlmZTQ6fHnL7mfdbfX7S5L6qymWph8=;
        b=EmPZU6/0h78Jt6LJeZTbBezh2xsXJ/Rf6aP99i+EHno/9zFcOFdDCW916qF7ABIR4t
         UIBW4sdpDDB0zc5Kr+sZ9f6DRx5cBuS6piJBjb2yntAbTTZi9zCBvkSpyxFaahJY3boy
         e42y2EYnjHw9Xq6aY4T4CjTM1YVfg/65h9x+WAkB0RgAQ/lPK4ivqwqAFohbtSW2uvjE
         CIzb7ndOB3PG/fxEerZdkHdXAqxSZzQpRLZatWvCATJa//A8cPWLUeVeApm0GE878uTV
         djXbumnsW5YLfe74SaHvdIpgo1yWfvDtIvxJhhw2c4PmWQX+I4sbfD9FFiOPkyVyu1d9
         IA/Q==
X-Gm-Message-State: AAQBX9fvV9XHEVv61Gqdb0UMnWvDKXEGNBCTVX/iQztABDeD2CSqozLd
        RP6UjwMtwGKoHDwH/zaKcrYH2d358idEwzVl6O0WRtcUC95bEgzU2o9+ZA==
X-Google-Smtp-Source: AKy350aXpJlmqvhrvqJFhN16BucqBU50gYr7+1E8+MZeJWTJQ5PXLP10MGd5hXpu+yN69jzS8zRSYDN3UQqsLoIFv2I=
X-Received: by 2002:a17:906:3590:b0:933:1967:a984 with SMTP id
 o16-20020a170906359000b009331967a984mr162732ejb.15.1680564109995; Mon, 03 Apr
 2023 16:21:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230403140415.090615502@linuxfoundation.org>
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Tue, 4 Apr 2023 08:21:39 +0900
Message-ID: <CAKL4bV61zb55_+uJb=XXUdJXMoR=DahQs8TLdzeeiMzHDFRL4A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

On Mon, Apr 3, 2023 at 11:35=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.23-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.23-rc1 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
