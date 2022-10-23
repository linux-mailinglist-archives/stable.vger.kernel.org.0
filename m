Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C7A6096FB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 00:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiJWWQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 18:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiJWWQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Oct 2022 18:16:10 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0965F5F9BA;
        Sun, 23 Oct 2022 15:16:08 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id g24so2031265plq.3;
        Sun, 23 Oct 2022 15:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n6AztAfjAets5ADpDV5TomceKF1j8qdGrso/DrhmPTg=;
        b=goQtL0QsLIiGPTcYVUUHEU6mO29AwG8k6ZlapUTCrltBSKsBNk7yPM/5GzRZJLGul7
         a1l0hacW5XXh3clIgwJWqXcX9Q45d+C2euIoz0aVnjEzXt87KmguKGQdeHX/wW2+4fcm
         QRWW5kwt6Vy56NlvoOW1ykLeZuEFNzEU0Bk/pYmWL6fyPrhkaOyw83nwF+qB91VlrUFD
         woz1U9muG3HxsVJB8pUrrl99tA1p/7fPbrvCUOJlPcIQQy3Su+eqmLOIpO1DowoA1GyX
         yqGlrCsCZjuU/pO+Kvt0UaAL9NBFSqOmfzkwBkqFuHFimFlNQbjkxeEPtVqptb35xBhM
         L4Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n6AztAfjAets5ADpDV5TomceKF1j8qdGrso/DrhmPTg=;
        b=CjYTAK077YyzwCTKeewaFthPiDFTEtDeNAbDPl90FydGDLgUr+JOLRD6aGw7NpCoAx
         eplPLJ+TnycnOQ4rRj4E669q/W+odemqz6HXv2qxJ2skX4ESFYGepWbelnxjT49Dq3hz
         O2mlt0CDmCYHt5DOLXLckzo9N6WW46iULfgfNXdzYG37N5TgvkvXQSOBTResqeUU7PoM
         JWIzZqwWnEbP5oXz2XWZqTOeMPHgET5/NB/XZSZgiWmNJtP/SITOPZatvAFDZSxhKPoy
         5Q6yKTAby/oiyPl+vStz6VNCkNy4IClmo+iObsQ06/IrDu5L3yrNVsgWTMtMWC6A/ADR
         +4cQ==
X-Gm-Message-State: ACrzQf0Uzjx+ZNvqazUqtxCZw6B9yOo5oPL+xNeC6HD8+900C7W/HfW6
        QWpIswsUWGVEDfDf6ZrGcW5u1Z4Nkfjmc87GL0w=
X-Google-Smtp-Source: AMsMyM4/nCeZ4G1vfioXR+kshi7I5DRImr1gsEVRXKZRO9KtFZU07weU0QBk0WzDdRkayItpdKPcocQCBzWSqrL2FF8=
X-Received: by 2002:a17:902:6a87:b0:181:c6c6:1d38 with SMTP id
 n7-20020a1709026a8700b00181c6c61d38mr30288289plk.74.1666563367577; Sun, 23
 Oct 2022 15:16:07 -0700 (PDT)
MIME-Version: 1.0
References: <20221022072415.034382448@linuxfoundation.org>
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Sun, 23 Oct 2022 15:15:56 -0700
Message-ID: <CAJq+SaA1pFBe6RZOV8NMjci=ZXtpsHc1=XbvU+tDgW5Sd4EYDA@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/717] 5.19.17-rc1 review
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

> This is the start of the stable review cycle for the 5.19.17 release.
> There are 717 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Note, this will be the LAST 5.19.y kernel to be released.  Please move
> to the 6.0.y kernel branch at this point in time, as after this is
> released, this branch will be end-of-life.
>
> Responses should be made by Mon, 24 Oct 2022 07:19:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

 Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions found.

Tested-by: Allen Pais <apais@linux.microsoft.com>
