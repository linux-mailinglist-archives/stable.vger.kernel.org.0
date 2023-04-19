Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFCA6E78C8
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 13:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbjDSLmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 07:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbjDSLm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 07:42:29 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D525AAF32
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 04:42:25 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-94a34a14a54so745359566b.1
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 04:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1681904544; x=1684496544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNUneFO36EMGgpFGvSKh1YgQtMZL/u95T4yzh5WEVwE=;
        b=tTIyhcoZiyzSpOmvKVu6Nw4iyn+8mShIqJ1HUcKjqNllaenIU3HQOylLz0FlHboUXJ
         60w5btKGQtH23SZLjKXHBy2ZqHpfD16S2aorrxmYD/tZwHw9tLjJLjYP2aUXeFK6ejxw
         LEZumoeVk+amIjYftPK5sNgk6HPjYd1fQTuaQtSShdZ8BHphyHRHh+Wlsr40qNnQ9p5x
         W2QB/3NdIBwijxmDfXIZnh1bULkQS9ZdO3Q011Ju7uOZ0PRMRfYKZjcJ+G713ZVNSGjM
         VIaz0V9WUa8+iRSNN00Y85IDBMwFzcs5+h9bpjr0RxnRDVk5Bl5UFEsVPZRLcd5tdV/U
         0rSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681904544; x=1684496544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNUneFO36EMGgpFGvSKh1YgQtMZL/u95T4yzh5WEVwE=;
        b=ZyMvJ6deWa2sz71ztsLqQ6JYY1oQXXy4xy8y/Bd4eLJsK12wF0SN9Rgps9yA5zCqRc
         FGxiwO5euthTCXPYe/gWUT8TGZJ/lm7HcyVXpB0zr4LgEihw0pDG8teS3AQ+sdP8XKZP
         PqHzB6OKav8UbacGW/4zEWV2L0hacjnRU4RNNCG9vGGTIETmdjidtkpLjmDKVJxqHlBx
         9lewJCoSW6dmO3kyXrfKwvsOW8WXpWK2X1KPwqvnbq4vqfb7HX0kv9FUnVk6UK3z0jF5
         ZBL09/x0C3pv1HQJyBwAPDNP1NbRu1OkAB44CwhGyW+aesiAw/nED3iPLJS71fJfUKM/
         /o8Q==
X-Gm-Message-State: AAQBX9fVl3rX8tvj2jNZkXwozTySvW9XBPydgAiCqe33XlBhWLELH3C9
        5cpKyxhQcLC2ot6jimxwk9Fcc19Sw+jBA73BDQt1ZOP/s9BaxI+iFqKDGXgl
X-Google-Smtp-Source: AKy350Z0BKGtWEHQNPnNTgs6F98br+BbHXUIkVgXLc87hMhdFHV/c24jnfgdGtSJaF9tGHT+ngMrIWq0joid5b4YMbM=
X-Received: by 2002:aa7:ccd2:0:b0:506:996a:6721 with SMTP id
 y18-20020aa7ccd2000000b00506996a6721mr4861246edt.24.1681904544112; Wed, 19
 Apr 2023 04:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230419093701.194867488@linuxfoundation.org>
In-Reply-To: <20230419093701.194867488@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Wed, 19 Apr 2023 20:42:13 +0900
Message-ID: <CAKL4bV4Y5m2KcdDNwqehfmZX3ic0t00e+nbrbftiMibtcLoJFA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/132] 6.1.25-rc2 review
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

On Wed, Apr 19, 2023 at 6:41=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Apr 2023 09:36:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.25-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.25-rc2 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
