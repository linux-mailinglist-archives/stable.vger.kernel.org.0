Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9958668338C
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 18:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbjAaRPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 12:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjAaRPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 12:15:25 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACEC59759;
        Tue, 31 Jan 2023 09:14:27 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id h9so7156514plf.9;
        Tue, 31 Jan 2023 09:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4nqIRb3CtIvsLWjhKFGitAAchcs6/A+iijKpPzMEf20=;
        b=esKZbkF+UfWixaDAie55c2MJdOTDm9oVih+CmeGPR7r3+csDzm7cpyFt2RCBUPYaVn
         i8zUgvvSZp+AegcSYhk+Rc4a+JpFelAY0p0+2nRY+40GyBDr1u5zjP2Me2LUvObX84Sy
         XsBiNcsNlnye0P3ASXAK25hIGSuBA6ZI9REwjq96/zf3GUyLLN/3Ko0iW59zbAukTk51
         hjrwkBWV5IbVqI9khnEn0q9GNyMdzRtg0Z6569B1ceCvlnmpRCV3JJ278TGoKoGgBEAw
         FtbwfqrqEp621R/SG2tcDTNd7SMRZTSeFv+vvHEUXYPEZr1v5iphUuJ9NsKB7OjzR5P/
         hYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4nqIRb3CtIvsLWjhKFGitAAchcs6/A+iijKpPzMEf20=;
        b=FAxSKClggaGPZBT/OMIBYKyubcRu5KRSARV8l0ZM1y/3DS/MI/lC+4wNsBcu0Uat61
         F7+4uD9WznjyDmsYxckkhvZlOhYXDchafooUvwq8pvFDF11WsvE6yILH/vVGeW+/tifH
         GiDfQGt5ysL5PFxJtH5bWI+9RPHCNVqrvZRQlibktmsnVFHK9PG76wumAcFThDCKnF2e
         WhryZ7ZuC9KxQp5DEAqeC+e/8XjYBBwPLogt8A6q3tTp49kGVaApkJeFpsuYZeYI1TKO
         KoykWVXJdvzBvotAK9joGyKmpCbRi48Bh5zaC0Oku6ph+MF6QAHcYMkg7TpTWr5euEFL
         rEjQ==
X-Gm-Message-State: AFqh2ko+Z2/oMmle1r1wFEMGjILBYzW4Ea8AdT2hYvpDyFBqOPZH2/JK
        iw+rKjdRZ/V8RYYVutpU4IJgjzjVS3KhVLJZCxc=
X-Google-Smtp-Source: AMrXdXtohwPAALWuxhqUE6eYe5s+7Zi2PXZvgqQm8RrpisbZQ8STLX/g8ewISBiT17eZ211IKbZFdJvRtobOqDr5Td4=
X-Received: by 2002:a17:90a:6342:b0:229:4c59:3eeb with SMTP id
 v2-20020a17090a634200b002294c593eebmr5783010pjs.51.1675185259668; Tue, 31 Jan
 2023 09:14:19 -0800 (PST)
MIME-Version: 1.0
References: <20230130134306.862721518@linuxfoundation.org>
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 31 Jan 2023 09:14:08 -0800
Message-ID: <CAJq+SaDC_NRoom_vdiVT=JoXuBqGurhbyNfo28qsFXQDZ3ipZQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/143] 5.10.166-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
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

> This is the start of the stable review cycle for the 5.10.166 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.166-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
