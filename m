Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D295FA987
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 03:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiJKBAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 21:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiJKBAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 21:00:07 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21423E777;
        Mon, 10 Oct 2022 18:00:05 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id h13so10700460pfr.7;
        Mon, 10 Oct 2022 18:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m5jdZk8obbSaJk1bH2M6QI2skYoBtwC+QsNgs9uZZ/U=;
        b=KZjm64gR1mLPKhTTFoCyZX6FYqkbhHDPOjknfMn/jcen7TaHIMPu1csuB5GCshoaAE
         Q7qxa4j03VfTh34Gw0ZtSQWCmSB7j2dQYbLjckFmNqtaU4MdibACJGsoJXBibrPXOLWa
         fMIwL1whxssuU9ZFf6lvpHpMayIBdqEfH9988IU2YH/YXOznopTnXjYgz81AErxL3Eat
         IiNz75Uv+llnla9bytHyMaFx3PN1tqpOaV7xgUvJmoj6XZ+hBIaJnkh6m+eVgTOaxN2X
         QfxPObY5gYfaDZX8g25KCQemffXaRULGy8dApxfSa1NwIbPZBjE1zikqCRLpAk1IknuT
         Avcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m5jdZk8obbSaJk1bH2M6QI2skYoBtwC+QsNgs9uZZ/U=;
        b=RQhRwnYsD/8WPTNuJ6wOV8pDpi7Fdrytz5iassgDPGdDlnS9SQQxlryPFuwzjKCxwM
         Cf7oYSHpeMc3oJxcZo/PufApIfmqc+oXYKRTJHujeP6sUbulCwMPbPS/SAY7M3rPtpi0
         UCk+A9mofctzs2rThD0FKLNo60u3CTsFx6v+U4jvldymR9Xm7OzYQ53dMtIOzvE9pYNI
         zeKfZZGy9tRENVZgdxg4f2bixRpkZ1It62TlUZl9GM4xy2WAOvbPgjp2nD9xV18bi1E7
         eaVN4OmqN0W5TR3DtBsetEmyedAcjs08gfz078wlQ1J0GVUwN5JuJqJ8sazGlHIJ7Ayw
         E8Pw==
X-Gm-Message-State: ACrzQf24ofWti8zXa7ASNjlkrbw9t6uZRPQIuHpKDmH22hJQq2sbV+pT
        IgoYE90Kr4l8TcW15tscPwNnpA55HJKhDlsdBIx1jJWrhHM=
X-Google-Smtp-Source: AMsMyM7F5925acIpKQJbsIkmq+QDQhqZOYJ65KSP9J7/49DcWURvouoNunGQc/NwXvEV1XbSYeS98PWnvueYTuYThu4=
X-Received: by 2002:a05:6a00:1306:b0:555:6d3f:11ed with SMTP id
 j6-20020a056a00130600b005556d3f11edmr22166973pfu.55.1665450005071; Mon, 10
 Oct 2022 18:00:05 -0700 (PDT)
MIME-Version: 1.0
References: <20221010070330.159911806@linuxfoundation.org>
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 10 Oct 2022 18:59:53 -0600
Message-ID: <CAFU3qobC3_LwSXKnaMfmNY=Qce9ozT_hLg1LvSAjjgCKrcoh7Q@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 12:31 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

     Total time: 0.676 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 8.978 [sec]

       8.978893 usecs/op
         111372 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
