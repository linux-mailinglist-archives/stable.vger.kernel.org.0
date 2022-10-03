Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58F65F33CE
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 18:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiJCQoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 12:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiJCQns (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 12:43:48 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F77936DEF;
        Mon,  3 Oct 2022 09:43:24 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d11so10170785pll.8;
        Mon, 03 Oct 2022 09:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Y3BHtGTWqn/OOMqptQ2pUSoCcCAdzn1fNUKR+gIYCIs=;
        b=ROdSN9OMcZH0iHQPWxryZOd5fX2vMEWRPZDayn8yozlUoUBzgO0u4dAsEhA1eVzx+s
         H9vEUx5Jm3rb5UxFrvdOrLNzOpnJSUgsaCUVDB2MzanQKLYqq6MNOh5IWZhJW94qPBTa
         bsWp0A7iGSSRfUhttCE+977YnofcqsrNiD3C1B2AzxvY8AkEdMFQ5iRW3Zhg/8reJFTO
         QyeBjli+OSTSehyOoU1eeH0dGWalpsC3DwiR5pdImEew84xWZtxv14nLj4LbzjAiOPeX
         kD1Q6a1Bz596yu3AQUf8lg6S2XT3q/4pfa8tYqXopV7XqU8FYJ4uGaS27Cnd9AVbfhal
         ed+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Y3BHtGTWqn/OOMqptQ2pUSoCcCAdzn1fNUKR+gIYCIs=;
        b=EvS5bHiKbTybva2Kd1dVlc2BLRfuMN2xYjF4mtaHABXyG5yBRB+aYRblZZRcqYx4/T
         aFJEi34eVDtWV1dSud5rKMpdJld97vFuqfzjnC+0hLrPTkPek7sh2Yelew5Oio3Kh53T
         JvB75xJZFXdqidzDX0b1yoKTqo1P0m7/xplk9qV4BuWKjYCXY5f9ZZUaVzZPaG6ferZq
         MteEcJEPmPT94W+7VCRQ9j2bCbp2yOu4x8LtgXfE4ZsSyxHCNqK1ZLHj/BamN5WBeOoP
         QZXOs/GId3k3iX/DdAxgPVXG7ssJQughBnu+IQVSa4/Qfei6aFoPDZv7JjJx6ndvb+Vh
         wdHA==
X-Gm-Message-State: ACrzQf3P3/ALZAuaUYTbO4ZJjKD5SQpkgwiTDbRAs3wIgmYqK+Rg7XRq
        FovfiuzLzV33SAcpa31g6XdKFas+J9BIhQrPZcyjZYTv
X-Google-Smtp-Source: AMsMyM58kwMi0ZoWpKAo6TKy+ZhLyoBWHajb9kwJpbIyvTIGmf11gKU4K9tDrpDvx10eouqiu/h6PHLsuDwPJKbz4E8=
X-Received: by 2002:a17:90b:1a90:b0:202:ff17:4a80 with SMTP id
 ng16-20020a17090b1a9000b00202ff174a80mr13188775pjb.213.1664815403630; Mon, 03
 Oct 2022 09:43:23 -0700 (PDT)
MIME-Version: 1.0
References: <20221003070718.687440096@linuxfoundation.org>
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Mon, 3 Oct 2022 09:43:12 -0700
Message-ID: <CAJq+SaDMMhU9e9bBFQqRF2Q1aD_=U+Dj6dy5LNA9daPAAzp=Ag@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/52] 5.10.147-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
> This is the start of the stable review cycle for the 5.10.147 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.147-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
