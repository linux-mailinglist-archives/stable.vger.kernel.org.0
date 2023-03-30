Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A196D10D6
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 23:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjC3V1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 17:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjC3V1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 17:27:21 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B880219A6
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 14:27:20 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b20so81968770edd.1
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 14:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680211639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NhmmSvsykyt0zNv8btcNuApZ5gFiyTnj+UuFt0RFNI0=;
        b=H9rtE4fQFwuYbZQkhsSRtot064y3Jr1cKFnCL6aTHxeNE0W+PyAHiB8BUF87D8F08/
         CCruOdp5Po6B6ZFZEFnOcwj2+snViNoW4ZjQQ1xOOqByAzp/EO/opqTYDfkP8F10IZaY
         8UpOct/dDzvXsvxw1sKex4aCzAHXH9km0H0pxoiryErllZsNgwuYnWSlPyx+icxcdc+p
         vIqFTC0qPk1T3TdmZFY+cVniRw5+qwCpnAoQewf5fx9Pp7qq3EhdrxM6IeLdXtBaEvgq
         K7h2VA61pPKBd5sUcflbn8+8ZmBlC8Kvnlg2ZFw3j/tvJad6CYPuipOJQLBREOWJHSn0
         tiww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680211639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NhmmSvsykyt0zNv8btcNuApZ5gFiyTnj+UuFt0RFNI0=;
        b=3pS5AbzKSTNEBy35YH9DN8ndbgGf5o8a+iEMw//elyLOoAjCEt6Y9q2ex1q8vRFO8n
         40shIeHzray41CigiPYsfDo4iZBaypziztiTKKHrV5PVUJ2dOLBFgotdgATc3Mr5tpZe
         NzDb2nlGOEX1Vrmf5kI79m7V0/tlJbhiRiJJoqeadcLbwCYSEWJOZ9mW/T7oUtjyKFEC
         G34/cJ1VQCLdcYAS7TAZl0Jizd+jkQ69sPmk0Q1p7Qe1fi6LeLXiRjtBPf8Swm7mhg35
         S+06ZSPOG5SPR5rAbSV3lKdRrnH7kdYZUHnZOFmPhaMkukm2NPkAY5ZIYeKTlxU1uNBS
         TKyA==
X-Gm-Message-State: AAQBX9cDZEXOGJH41LPbiCci1J87ED10VQLvDv70UO0umyHHix0Thxi2
        2chqQ6eOiVrCawtVZiPMcxldvk6ZGcZOB4C7vyY=
X-Google-Smtp-Source: AKy350bD7Ewq8PidM6ZIfAJpy3X7LMJ8SHJsB1d+C9F6QFRg0Hu9HNwJkjtlhzBQdkcWc3NRRUo/RH+7NUc/N9gXcCk=
X-Received: by 2002:a50:8acf:0:b0:502:3a4b:1f1a with SMTP id
 k15-20020a508acf000000b005023a4b1f1amr9595716edk.4.1680211638741; Thu, 30 Mar
 2023 14:27:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230330111618.2889687-1-sashal@kernel.org>
In-Reply-To: <20230330111618.2889687-1-sashal@kernel.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 30 Mar 2023 23:27:07 +0200
Message-ID: <CAFBinCAvUURHmGrcmsmNQMvhSe4P_QOCOsrWttzW+3SfoZ7P1g@mail.gmail.com>
Subject: Re: Patch "drm/meson: Fix error handling when afbcd.ops->init fails"
 has been added to the 5.4-stable tree
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     Neil Armstrong <neil.armstrong@linaro.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Thu, Mar 30, 2023 at 1:16=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> This is a note to let you know that I've just added the patch titled
>
>     drm/meson: Fix error handling when afbcd.ops->init fails
>
> to the 5.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.g=
it;a=3Dsummary
>
> The filename of the patch is:
>      drm-meson-fix-error-handling-when-afbcd.ops-init-fai.patch
> and it can be found in the queue-5.4 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
I think this patch was added to allow backporting of another patch:
drm-meson-fix-missing-component-unbind-on-bind-error.patch

Unfortunately this breaks the build as old kernels (5.4 and older)
don't have AFBC support yet. That build failure has been:
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202303310016.tc4BlcbT-lkp@intel=
.com/

I think that there are few to no meson users on 5.4 or older kernels.
Can you please drop these patches from the 5.4 and 4.19 backport queue?


Thank you,
Martin
