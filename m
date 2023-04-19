Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276DF6E70B8
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 03:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjDSB0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 21:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjDSB0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 21:26:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E94F83D9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 18:26:00 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-50674656309so3827831a12.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 18:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1681867559; x=1684459559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uxXITgakLQZjUNEWigiUIhamcKFCLzsMS5+jd7cbviE=;
        b=dN7EGNUqn24hjZ1K1ZiPbjvrPoZ7/E0JgBK1YZVnNP/D4euPBMQj6Wj1oTbBqElPhQ
         RDjPhyXDBm1cHvfDTjZ5kU+032R0OGuRJA7ImqR3lGc4gmNXrTFmOs7T9sVZoDFieeWQ
         3jGRKTgk0yiNRli0UH1rJb6WMxk1ZFGlcQW801v5nGv8ep+YtWq45RGzq35boFTBwjMh
         5yXO2Hb4nioc/Gyg968bN0ZWwdEC7AaliTSvDT6BipGowpBjNyeJHi+C8o1P5hTeRtkq
         HM7DZN2VvLJFNEVx5BhdPVEZLtV9o8dDYB3mw4zA7+5KNmxd2HG74nrSmzLvTdsqUD85
         bsLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681867559; x=1684459559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uxXITgakLQZjUNEWigiUIhamcKFCLzsMS5+jd7cbviE=;
        b=ahl2GRHce/U2p5Ck11gqC+/Qv49bbDOU+2WmRbJ41PfDYgAKhwp/q/CdAaI8xZ+UUJ
         YAiGpYKbw/os1mx4VJDS8ef2Mnko8Ct7JLF+VOanPvHNcbOJJJMMKMZX6m01J0Yb87Nn
         6ihkJ5062TRY8Ir7aY+bbCzYZJ4sFlmwJuipaB64Y0esCZeN/rHB3ehYBye/tOVBtTIZ
         3qap059BDpyg3uddq3QFFwSMhoZUwjHQ8kfT5PPWnzNItGEOEEirhb4dKSzecTye1QXI
         LffyMC79K/20bwcRC0yFu/j4XsGEKtBRNpZn1uw4h2pW42j4wmCN2j6pYJWeVpMNNhOw
         mhMw==
X-Gm-Message-State: AAQBX9dJNNeFRycI/a5E+wz11tcPxKDmx0MJij0Kp1HGYqfMCkWe14Qj
        WwVLiqVk0lI80q7zaLdudV28+jjhZpMUzzlw2HDySg==
X-Google-Smtp-Source: AKy350Z1r3MHtabcSD0aZjLFEKplpiH17REkLAHbs2RkjUZefY0gvuZrC2SMt/PEQWRJRyDn3SmxLfaORy73MLYbgsk=
X-Received: by 2002:a05:6402:c1:b0:504:ae78:89c5 with SMTP id
 i1-20020a05640200c100b00504ae7889c5mr3522250edu.28.1681867558993; Tue, 18 Apr
 2023 18:25:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230418120313.001025904@linuxfoundation.org>
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Wed, 19 Apr 2023 10:25:48 +0900
Message-ID: <CAKL4bV7sw7AWc14eXOh2azGH+=eHWni=wcisHJfPAra4xYUmuA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/134] 6.1.25-rc1 review
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
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

On Tue, Apr 18, 2023 at 9:42=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.25-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.25-rc1 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
