Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC034CFF5F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 14:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242433AbiCGNB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 08:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235487AbiCGNB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 08:01:26 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FF28A32E
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 05:00:30 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id u61so30708315ybi.11
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 05:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cV/iRWpEISoBT8RqYrC9Loyzy60WPxJLdJrpUBpn9N4=;
        b=LVb++RVBZfne8vu4GpNufR3TESTWg0xLaPgW4a8mWdgu+RsfCq0eSp7KjWLVehEZMi
         Nqc9VQ04sWEuTzePC1BAc92teVEUvdGyPyD24J9VgfOlza/1uyEZeVS4Rz+ev0Kg+g+w
         mVMXXPm1QDuom6dMCjngUykQ4yCV1nwKEqJwjVs8PmDIVYk7pJ+0X9Fc1Ucm82OLgzKY
         rFrdY08sjABSAp4mH5xB7Jz6UfirJs2eorbxcisS7cxmYySScStHT7AH6YMGEz0Mv4jA
         x4/UXhyzWP0afg9vP2AQLMwR4es9LiI26n22K0Fn0iAsm4g/NOcto86FXEk64Rn1bgyX
         7uHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cV/iRWpEISoBT8RqYrC9Loyzy60WPxJLdJrpUBpn9N4=;
        b=iVVB10cN7HdtKytOJN4vHtOMp7V+EbO3jQij9lKirw04Jw8VHHESJse8LrAROaaRhA
         hRaQrmbyG3nvX3+59FFI82HczRNqMQbm3Z7Fwc+/G5HNWxvJsPWyNQr0o7AROyR0cTjV
         PCLvFVg55wgf0pZ8oAR/k5J8gSlR2kMwMfvGRszpygdl3EusjWd4nmhGEOPiNpdxp8ug
         k2rtDQcbLWAX6UlTKatO1Rgd97M0qRYZQaL2kUCnp6LXx1CoTBIur/ZYMDllNlTHQAaq
         nbw4AEKlj6wB4AwmNfd10LNGU1d1+dHcKVlYInd27gwse/72l88VJ1hKAfg2rn8gkLUU
         qzWw==
X-Gm-Message-State: AOAM531vZKCAVELEQ7SEC/VqXiiSwzUj3TTlKzX6TePnerL8WssOpwzp
        CiChK6nALT2wVK1Xw0IsnqQBUDMdNbNnydVBLHYdrA==
X-Google-Smtp-Source: ABdhPJz7y/I54piNlQLkLmG1TBL8cO2TtZqqA/3TeporXhO/Ll4av+9Oeyrz2ZsqrqwcxxAf9U2afKUDEFHXjPyXHVY=
X-Received: by 2002:a25:5090:0:b0:628:b76b:b9d3 with SMTP id
 e138-20020a255090000000b00628b76bb9d3mr7938482ybb.128.1646658029569; Mon, 07
 Mar 2022 05:00:29 -0800 (PST)
MIME-Version: 1.0
References: <20220307091702.378509770@linuxfoundation.org>
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 7 Mar 2022 18:30:18 +0530
Message-ID: <CA+G9fYtXE1TvxtXZPw++ZkGAUZ4f1rD1tBkMsDb33jsm-C1OZw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/262] 5.15.27-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, dri-devel@lists.freedesktop.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Hou Tao <houtao1@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 7 Mar 2022 at 15:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.27 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.27-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Following build errors/warnings noticed on arm64.


arch/arm64/net/bpf_jit_comp.c: In function 'build_insn':
arch/arm64/net/bpf_jit_comp.c:791:21: error: implicit declaration of
function 'bpf_pseudo_func' [-Werror=implicit-function-declaration]
  791 |                 if (bpf_pseudo_func(insn))
      |                     ^~~~~~~~~~~~~~~
cc1: some warnings being treated as errors


drivers/gpu/drm/mediatek/mtk_dsi.c: In function 'mtk_dsi_host_attach':
drivers/gpu/drm/mediatek/mtk_dsi.c:858:28: error: implicit declaration
of function 'devm_drm_of_get_bridge'; did you mean
'devm_drm_panel_bridge_add'? [-Werror=implicit-function-declaration]
  858 |         dsi->next_bridge = devm_drm_of_get_bridge(dev,
dev->of_node, 0, 0);
      |                            ^~~~~~~~~~~~~~~~~~~~~~
      |                            devm_drm_panel_bridge_add
drivers/gpu/drm/mediatek/mtk_dsi.c:858:26: warning: assignment to
'struct drm_bridge *' from 'int' makes pointer from integer without a
cast [-Wint-conversion]
  858 |         dsi->next_bridge = devm_drm_of_get_bridge(dev,
dev->of_node, 0, 0);
      |                          ^
cc1: some warnings being treated as errors

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log [1].

--
Linaro LKFT
https://lkft.linaro.org

[1] https://builds.tuxbuild.com/263ZKyWWLLcPGRbiZwIEZw3wvXX/
