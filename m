Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82685670E9D
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 01:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjARA37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 19:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjARA3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 19:29:41 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A003E59B52
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 15:52:53 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id vm8so79275099ejc.2
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 15:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y/mZXU7qRI/V/MvZX6ht1aHbNSJYEFnEgfMHUHtp4/4=;
        b=2yW38aMpSX0exFi22UXZave3cYZHK1JoeAf4qPlGJesusL7W1YvUXhuBbJAYP+wqtv
         DQOn5zLJjpN2gtinBz+vLvTwfT3F4KV9rx2EKDiuU/UMoT7/jbQsYH1pHCrm1ORaDMdq
         ur2eNlrMJcsJ/T+IEaGbx73/H6q0nXlPV8qrFK8KXSRkrWup2yi4qro0I1Bssn5TXdhi
         LUqZc3mrrQ6kOLOXH/IhCtaOQdqc0rPA4xC/CbdGTqckuqmudqKMJD7f9K91FKh3C5hf
         jojWsdAb9bAUiitwevT9sX+Khg5DXK9K9Hb3tSJEO+A8MYd7g9zFpLD9BC8SQjzcXh48
         fHnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y/mZXU7qRI/V/MvZX6ht1aHbNSJYEFnEgfMHUHtp4/4=;
        b=E75SzlncKWP78h6tpS8twT6sTPFI6WPHNe1h84SDm3lv0FIEeLFcstT8s2VESA3Z4F
         FVLEl/GJC+gAQFNDEjFHsw3I4pIS9p9MfYaw5mgpylSUxQbcPyDYeyJLrKFBlBYFoei2
         vV6IvFohdARcTtPg0Cog+QpRE7GHIvuBTeInugfezRmm+sOjgMDQs4pLIoZtTlztJ+vN
         EamGp1ZGNhYNOY/1QRceoGz3HvDSHktTkUQZ9EIQXd1XrRyDdIhKecAjQcFfbFJoiPla
         iqQC74/ePnTM60BUvWj+7SYLTsnlbrLIkOiIR5UkpOfeeD3+dTDN/7bRuI1yueJaxfX9
         1QSg==
X-Gm-Message-State: AFqh2kq4ngHpU/1pubGScE6j4olsIgYZw+FHV/9AyFlmFjeXna0e1Po6
        wf5gQ0aLCSLd7UyQc7g2O1qajvLgIGJQekmhAHTgoGIalXy1QlffB6Y=
X-Google-Smtp-Source: AMrXdXsls82t2PILkD7G2zbDyv1/54e4DjMDxXCi0cPvCotauoy67Z1f1l0rg9+LbNztFvQ1Za9slpIPhArg47hL3F0=
X-Received: by 2002:a17:906:80da:b0:872:618e:b01c with SMTP id
 a26-20020a17090680da00b00872618eb01cmr350888ejx.275.1673999571245; Tue, 17
 Jan 2023 15:52:51 -0800 (PST)
MIME-Version: 1.0
References: <20230117124546.116438951@linuxfoundation.org>
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Wed, 18 Jan 2023 08:52:39 +0900
Message-ID: <CAKL4bV52YzXBFhjNQO32iyv9N1Ybe5m_EWus6EQSqP=c1QNOXQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

On Tue, Jan 17, 2023 at 9:48 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.7-rc2 tested.

x86_64

build successfully completed.
boot successfully completed.
No dmesg regressions.

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
