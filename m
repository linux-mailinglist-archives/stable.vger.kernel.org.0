Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EB04FEBEF
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 02:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiDMAc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 20:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiDMAcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 20:32:55 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3D8140AA;
        Tue, 12 Apr 2022 17:30:34 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 2so353081pjw.2;
        Tue, 12 Apr 2022 17:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rms/5X4c41PJ+vCUzdvr+lYt5qjjUA2FJHiAGsamMv4=;
        b=S6XCaBPjXc3GITrLB6wojOr7rPVLDmmJUQsiahD7teXiZhvqxCSZ7OVk+9ygByedPy
         UF0WEvZJ3Ob448+KULEgeD1DFcDWjFZUAa0WptkI1G76FddVVr9f1PoNyhuXSzX497UI
         j88C//dJ6v/rXpLZ+HXgmf/kxeZ61CW8R6oAIE78kzu8Crq7qY4IdsMs6qljy4EJb9hl
         O642GyRKWQncEc8GMgELZW5bVGwF45xNrRcBRJOjCpebxTho7jTAbJlFY/vOLEz7j4dK
         aUkoZQQY03CfWE5E+IhuRRH7uwLKNHZodxFghOcFFjdffWdvd+gshlbZ0JeHlmklewWg
         mdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rms/5X4c41PJ+vCUzdvr+lYt5qjjUA2FJHiAGsamMv4=;
        b=CNRTgOCKIi0US6I6YODCDSnaiqhShA/lWwHc/4ElWntWN89LFMvmMG2bRz4irIxWqZ
         hVy2LkjtcGQogTNC1MJoGbX317Xk4Y9112b+78HhVuTkcZq1JvIliDS062mFxP3if9dx
         MKV12/nOdBc0u6MgEIDsTH4+r9b1uTyCiCeuskr3Neei2Rt4BrQeYIGfBPyWhb0zpVkY
         CRJeJ52sXFfEZ6vADbAjfu/5aO0j8K0A9hjVZ9gzo7sDjwfUOq95PvDjC1ukgTqFXJDf
         qJmKvg5EsHxnpqwwAj2lzysVGoUyjBF9RkZlJPbof9aOWBQ/RZoV42IBlTm2Z2VAJ2EB
         8LIQ==
X-Gm-Message-State: AOAM530wS6pXAOlZVse+go8dycvnmkP/5ExdhsKnscNWBksz494luzON
        JQZypRY4BtFLhqzwyAIKGXAxA0dzOc8K9GG8BYWv/o2OZ6s=
X-Google-Smtp-Source: ABdhPJzkcGNCPR6N6YHDn+bUDXtmU0mqtP/6zbJ42XT8dKm/G3fJAXiY+ZBektmqaWPX5kAvARjgacv5siqV1LDppgA=
X-Received: by 2002:a17:90b:1886:b0:1cb:8e79:8ebb with SMTP id
 mn6-20020a17090b188600b001cb8e798ebbmr7772932pjb.176.1649809834070; Tue, 12
 Apr 2022 17:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220412062951.095765152@linuxfoundation.org>
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Tue, 12 Apr 2022 18:30:22 -0600
Message-ID: <CAFU3qoa3DjYPHXCurQrCMPBDxUGZBLz=SdQTBevep5R3Cayq=w@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/343] 5.17.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 8:49 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.3 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

./perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 0.447 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 11.259 [sec]

      11.259176 usecs/op
          88816 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
