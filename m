Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A402267730C
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 23:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjAVWyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 17:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjAVWye (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 17:54:34 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBDB18168
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:54:33 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id mg12so26343176ejc.5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bMkGNYI/fHgvu0vw4xYIcVeU8+WBV4ArAcWUlG7Zc2o=;
        b=PhbxiQNidA1tVM9zIsUxDzkyQt3k2tOeIFAwnqAZCHMBaURy8ctAh7ILXXj/0yVKri
         Wnkgyj0CH3noCfHnCIbGqpwuR1rGov1STqItytgKUxnmeyoc/CJsm7BSugtzTo87ps6A
         pRPvtIg/W3GWpJaqcdqCFDjxJ/+AyDHBcgalCQbkiAMuGykgKZk61PtZKiktPANY4nYI
         pVF04va2QHggKOzLDmsSloSXOA4Z5y06Cs63FaNZIwGf3OxH57V0PosDCHquEuais7OO
         pQ4kK5HVyY/4cq6mx9qyzuYpb+sB4cKgx/acsyK60rnxy8jZ1ZTYULwj026kUauUijNT
         aUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bMkGNYI/fHgvu0vw4xYIcVeU8+WBV4ArAcWUlG7Zc2o=;
        b=No74pQ3t1aC3iSHch4POfAiCL10Hh8alQr+2mspZ23bdA1/XLFNXiiCgRHsgyPIFkD
         0ZdLGTywMNhpRS3Uz8z0A4diAfARd/HDNpb9Vu2BlBV8ysytmVFsAPHIIeNfdUT5H/8e
         9CcQGOswan3/QxU2czBb84lG4cwiFrYOG0VLywjhFiFpTJFvs5K0ENQaDYAO0Oqq0elX
         aY96nbyb3Iq3eggRcBjQy89tYmYnj6zHn3XvohV/TqNdMEMqrw7BSIhXdzO7x/1Xzk8V
         3TkpnlWOp8lWFxxUKLzMORQ1l7N61pc5q7lBZR72b4N+4SGDL+l8nMtxTtYc1NxkFUAz
         OBSA==
X-Gm-Message-State: AFqh2kp0HOxJ4CajFghqHJUxZjlcIeTAryIEqWsawQKjxJwgjqGsZ9f8
        Zyr1OjNRow5PkvrMq1whbxp+oD/R028gk/bZDBq9WQ==
X-Google-Smtp-Source: AMrXdXtuKaI+bneEJSDWwLYwvpPi/J8MILQ3ySzWME8Ff5KKH//OwvdRHAbh7G4hAX7a5pt/RGPao3aXP7XV8QBdi+g=
X-Received: by 2002:a17:906:df49:b0:7c1:908e:709e with SMTP id
 if9-20020a170906df4900b007c1908e709emr1860050ejc.414.1674428071778; Sun, 22
 Jan 2023 14:54:31 -0800 (PST)
MIME-Version: 1.0
References: <20230122150246.321043584@linuxfoundation.org>
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Mon, 23 Jan 2023 07:54:20 +0900
Message-ID: <CAKL4bV4D+woPBzYXRhTws0S3zqgzuracc52bNT3EyHLV5zLkwQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
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

On Mon, Jan 23, 2023 at 12:22 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.8-rc1 tested.

x86_64

build successfully completed.
boot successfully completed.
No dmesg regressions.

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
