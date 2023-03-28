Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FB06CCE01
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 01:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjC1X0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 19:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC1X0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 19:26:12 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A60BE
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 16:26:11 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id ek18so56286063edb.6
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 16:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112; t=1680045969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JqJjGxekriimV9ccPGWfHqw8XlwO9y93gHUtXAwGvHU=;
        b=nYCwAj4W7zUziLOb6Zi0KzhrnwaLIW1MgtHawRrNX52hiCKS81ir7BICobZMfMamJh
         q859LHoVnCi2Ih722KHvSx+qeIDxkmS2T6okixg8OjPI6VW6Rv957bCItLJd+0gkxGBK
         tt0MNiSqTpgvcOPf0FxQwQHPqnRrvMQsV8OFS1bVMQkWs7mvQ8rSmHdleCCn9BkmC8EG
         TClrzff1H8Jny1Pn1P8jhzfrP6Ku00MlRRCGRkjK0eJS4E2cqJO49niumfJk6+F10Eqn
         Bx9UNkj52EFMFh4D18kLIi/Eo2b6SxDU+ZunnSQw6GZmAYqndJnx6a10s93//jZjPQav
         puDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680045969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JqJjGxekriimV9ccPGWfHqw8XlwO9y93gHUtXAwGvHU=;
        b=A982lz5MwFdMZlH6G2Ua46fhYaTwgyvjF5/Fe1/Yyfk9we3T3c8ecwluvt+pnWh3F3
         ZUHjmO0hCJpe3f6oPQ8jstBvOB/6bpt8QLZRHVCmYD17eEwDwR6Z5eAWdukSj6mRE0eh
         mIh6o707deSYvXfzc349vBq31ZDGhWijs3K1zRsssqMdhN8bInXMAoYX1lDGYAHu5UZj
         b7/sABtHsNeKt9W3Z2Ky4iPrSbIJ7CePWrau1qUC8b8ih1LcxRBJ4g/GREi7sQeIiCMw
         2JnEL8aBTpsMfPdRohvgi6FO6BlJdTMaBgq1jrmixp+6X9KAt96AOSCNldPCXOks/fbb
         VhNQ==
X-Gm-Message-State: AAQBX9dFPcTEnXSW7cnNwWWiQfnWq2kzDUChih6Ah3W6WKB9du7gfmVn
        XbJkKan91fGVoUzWRmGn8tJetik56Mj4cuvzd1B0ug==
X-Google-Smtp-Source: AKy350Y/XwgdIF0TqePlNgKFLudXFBOEt6S7AOADn9TlZPl1X9r+dMLlrQVvznif+aA6/FL8QqqAkWz6iuS3LYHTXfI=
X-Received: by 2002:a05:6402:4306:b0:4af:6e95:85e9 with SMTP id
 m6-20020a056402430600b004af6e9585e9mr209005edc.4.1680045969456; Tue, 28 Mar
 2023 16:26:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230328142617.205414124@linuxfoundation.org>
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Wed, 29 Mar 2023 08:25:56 +0900
Message-ID: <CAKL4bV5YVTD8H2vKeqTEzUksffBuaKusmUeLw9kTKSr9hHUK_A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
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

On Tue, Mar 28, 2023 at 11:56=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.22-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.22-rc1 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
