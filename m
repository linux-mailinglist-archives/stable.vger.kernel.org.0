Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D90B6C2E78
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 11:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCUKPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 06:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjCUKPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 06:15:18 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C776E84
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 03:15:15 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id i5so10602830eda.0
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 03:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112; t=1679393713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPZLwXOZRcorVd7q1GAEZgbB1jSiFy3d5LtXDMLqkRI=;
        b=cbNkG895Ge9ZG6hIzcUdiWc975KbpPoHxxRn6s0LR6QKaQInX7QA3FicGIE/Ebd/Eh
         dBFnlFDe6jJjlSkw/b7Ss6hWH6f+WWSsYSXyzBegp8OIb3T+ysm/9k2CZUyaqwBXhbPS
         Yw2loxVV2E8v2tlyYlBjeg6CzzIwoBrPR2BjFSo2w08Np7otnklbUN1ttVxQmThEK2ys
         9wQJ00i9bGNMmnuzmVMW2yaoIzeLPIn/2v06cJ5tyU9yhcam4k2k8Nua/U2NDT/LXItu
         AltEuPA2za8JMxSaybK0SaouOeP9FPXoyU/c2+sBh+BOS2uERyiA1dONuzAdE0daGYa4
         0ACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679393713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VPZLwXOZRcorVd7q1GAEZgbB1jSiFy3d5LtXDMLqkRI=;
        b=ndjuJQzH2CVZTHJbwibX7orxRBizO5hldCS09+M3wiSODBNHrqExHkZ/CrGUiBOoj4
         ciy8bpuE3h9pYmBLfMf5qPJ5FL1ePZgYiNctDPSspQz+S9EoWPKhU5phY0cT+gRCcJir
         YONMoXQbIAXVQz3qOM+Z95Qyswffyjc3NgsEx9m+nFkil1wEMAJB4nXxnkDbJJyym/fy
         0KsC4zfSNU1I2GHMaXUQG89oaa3tl8UMBW8U3Be6kskO+xCBHwYfFcgdpTxjY5sBJuA+
         jKl8HzdhTGdqNJAfm29VYNDnjc7bvnb5v12s1VN//0Pfxr0ZmCBNCL7dqQLR69fmVUsk
         NxEg==
X-Gm-Message-State: AO0yUKXMEssH+oaDcM3Qf8r+udAseBkBAnzulCwa6PyvEYPO4/uWwFn8
        w8+1QogRNHpYwXndNhbp+6lQN7fieZL1koyuRfC0Ng==
X-Google-Smtp-Source: AK7set/THFJZheYTOTejcWWnHCm6ePuf/4HAQH9Mt/K09wQzWDjcnxlvoDo7Vhr6Cce3pY2xwfRwy5fCgDija2Fier8=
X-Received: by 2002:a17:906:a054:b0:933:2bb9:7c98 with SMTP id
 bg20-20020a170906a05400b009332bb97c98mr1437532ejb.6.1679393713576; Tue, 21
 Mar 2023 03:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230321080705.245176209@linuxfoundation.org>
In-Reply-To: <20230321080705.245176209@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Tue, 21 Mar 2023 19:15:02 +0900
Message-ID: <CAKL4bV6TDsxGLtKSSWE+je6yK4Y-8v7Q-ymf6OSVW2CzJDNdpQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

On Tue, Mar 21, 2023 at 5:39=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 08:06:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.21-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.21-rc2 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
