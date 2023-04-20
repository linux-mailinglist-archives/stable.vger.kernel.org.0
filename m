Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699A06E8E94
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 11:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbjDTJtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 05:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbjDTJtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 05:49:15 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF497A89
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 02:47:53 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-94f910ea993so46078966b.3
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 02:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1681984071; x=1684576071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EFE0QM7mSwfIIi0n4ixG0nvgw+870vPhmGd/YMAgiNg=;
        b=rh+4cQ02gYMRNIgC1lR9QsAyv/SgDTgHZGUqIKcQvtHspBSCCoxvYwMMuTV+RTg1Z3
         lq0OFXnAXGb4tVZ+moBCuAzSUtxkKbE+QEBDUqLyULbVAJqIJCAxzT2YC8U9LbKxfFe0
         dedlkwoH0h1uKPPwUChjqQyCaqoCJbH1TexskaT87M6M73ov0cbVWjNd4NAi7pmK9bw1
         U1YVZ+0G3zT5mMbAOBj2ON+3F3AU2Pq70xvy/1eJdQF+0hr6lMDmHd21Q0cPBnLH0rqF
         s2Km9WyYl33+yBXqI4+Q2e2gp0cVK858s2M6E9x7mDAGA5HxuvYWXrprAYvGlneK2ylc
         MBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681984071; x=1684576071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EFE0QM7mSwfIIi0n4ixG0nvgw+870vPhmGd/YMAgiNg=;
        b=FmTPvr4KAdEivZZ07hlOLPA/g6g4Zxd93c0MVVJcNBpiizfjm70wUnJAU8Ub5DaQdZ
         E2eEyaxspbSSxT+zEsev9PtpjQX5X9a56EkaFFk+5zWJjlc54PJSa4dWpVZGjQSbr+RK
         U0NteiuMCqr5hcuoapC3eAtj16z6kSeGjISrcvnJn5xAAeyXGkCHKEHk6YuIlWwsU0hp
         xKsVa2kAxafHKsH0YX8SM93GXQR00Z9mYdXdHd3BUZSL3K0fgGyMqKtZR3boZg0w9lK/
         ie3hsyy24I0XucVjXYHBI9vxiMjYfq4/6d6Lar1BSBOWkQ2hIGuWePt6NWeb1bXtODw0
         JtvQ==
X-Gm-Message-State: AAQBX9dh9TzJ7rX3LcTEGX+YPbjuIrRvaKU4p7uBGVNsEleMnD0G2gKc
        RITlg4gktKF8ubx2NYMYqxBRZeVXRMgf99ocWoWiHw==
X-Google-Smtp-Source: AKy350YJvNpW5QSC7jTldr8UPGORonfYjgpgwfmUvDNR1qGS6/mJylOeB7ZbcRaO/Vws6EHNhgjJMWngKccFh2NZors=
X-Received: by 2002:aa7:d686:0:b0:506:a44c:47e3 with SMTP id
 d6-20020aa7d686000000b00506a44c47e3mr1057724edr.16.1681984071407; Thu, 20 Apr
 2023 02:47:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230419132048.193275637@linuxfoundation.org>
In-Reply-To: <20230419132048.193275637@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Thu, 20 Apr 2023 18:47:40 +0900
Message-ID: <CAKL4bV6ebwfU120c4DxQ230_kggtO6KxruAuTO07xMfVXTA71w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/129] 6.1.25-rc3 review
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
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

On Wed, Apr 19, 2023 at 10:22=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Apr 2023 13:20:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.25-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.25-rc3 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
