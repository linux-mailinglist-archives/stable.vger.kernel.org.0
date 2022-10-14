Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C655FE615
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 02:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiJNAOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 20:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiJNAOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 20:14:42 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3AF1118
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 17:14:40 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f23so3267634plr.6
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 17:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3hEsVzl2mPfZikJJ+GugbYLLfUX4FJPQXF7xSGEyd5o=;
        b=Dp/14j7Bo1vfjBC/qnxG+8ChjuwBPtGt8zy2qnn4mAbNuNAtFa6vo3KRsiZYmrTNml
         FAT4pEDBkAL6Aak/DLnilaYGmeECFZI6lMj58olet/bqUeopuArVY6KRWozai0WoE+dj
         OnfSHbdBR1R3khd70J8inM1FsojcOFDMFQh5Pw3UpFUEKnXQ//Ny6HG2I4Uu6o+zcVmY
         fkodVAUkiv0OcPS/lUH26ZY9Q2+ruY0vQ8R+r6jYvEyKBHJrEutKoQ4aVrRlmlZrTPDj
         IBCarJ/jTz2JSgI/o32a46jdS3ElEFTLuGt660RVpMr5K+fmQ/u3R9JMMBVX5gsBuKgs
         li+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3hEsVzl2mPfZikJJ+GugbYLLfUX4FJPQXF7xSGEyd5o=;
        b=TmYKdgwXkE4ovJHxsxPyqGArApAAEwDS4nrrcG1yYmQ45R2Pdavg8J/ULxhdfkMvtv
         H7zA5NjaTbx4jAYkngduYpEeQ7la7ZFYi/ZK8h+ERZE5V/yYU36QuuX2rutpDEXQvVBr
         X61FeqD7Ae086eye+b1nCdcVB85NhdRLfSzj95lqCop7h7zlMEkFKC495o2xGnwTf9ku
         Y7PEoNHXi1RtZxWZ7Apy5jRvqsyK5ehGe0e1T7rhTxwSoCm71tgcTnP3nbPIB/QdBSGQ
         SouDS+2BNVO69bXxZ5vvdmNhJ1Sz8Y9dM5AuuB9ESI7t32tAW0Tg+4h1T7rmnSFNhV6A
         55YQ==
X-Gm-Message-State: ACrzQf0u8nwtvRIQfShUgioLFy147wrAhxSjAPQRWT3pGwa5VruPZb/0
        cRD98+tZ7IGKZEn6TmhSaOCO/cyw/dRYLEAA42OPL+Zhxqbm1DS4060=
X-Google-Smtp-Source: AMsMyM4+MM6OJPx1zDU9dqpRcKVGy2/SStyfVBsUd8XF4rpwBs2a9LkTwU9UfC6CE1M07PTK8nit+n0fR3J0GR2Ca/E=
X-Received: by 2002:a17:90a:bd87:b0:20b:1cb4:2c92 with SMTP id
 z7-20020a17090abd8700b0020b1cb42c92mr2664453pjr.210.1665706480329; Thu, 13
 Oct 2022 17:14:40 -0700 (PDT)
MIME-Version: 1.0
References: <20221013175145.236739253@linuxfoundation.org>
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Thu, 13 Oct 2022 20:14:28 -0400
Message-ID: <CA+pv=HPH5Ge0wXMxvO5hey65Be+Zc5L2jc4-7ZQi8yn-QhVwOQ@mail.gmail.com>
Subject: Re: [PATCH 5.19 00/33] 5.19.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 1:59 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.16 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.

Greg,
5.19.16-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-srw
