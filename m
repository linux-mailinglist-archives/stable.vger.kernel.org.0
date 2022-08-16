Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F31595E6A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 16:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbiHPOfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 10:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbiHPOff (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 10:35:35 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94447B283;
        Tue, 16 Aug 2022 07:35:33 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-32a17d3bba2so156009647b3.9;
        Tue, 16 Aug 2022 07:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=AVa022pwnZ5mzaFhhzDkpgooV1+P/jUmIITqX6kMWrY=;
        b=KZuvAVlxx8GbE5+ZnsGKrKs4eGlztTPHgQr0zW37u/TWSb+CmU6pFX+jywi8c7mBw3
         co79OsLD6wJtC87PYMfbKxG6VM1YGN7ptLbgKjEDstRDgG1lDuksw0q8DSFgoq/lFleG
         MhjD0QkfM1M2BumV28pvIlAZ8yjSF/JeimA4Svi38ya7rcc3qLxibAfSi+6Cl8LWvsF5
         eTClL7hIdx25fo3R1ggWbNvBa3bho2miWsSezY9J1ZbjbrrZb1lh+D5VCPY3zTxbL9gy
         9SVZRf1Ex4CR9WKe3lCQGCKrPuajWIGdUpH/bC/CWak+NFkN7ydsSpQLuejnOjiv7R5u
         TUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=AVa022pwnZ5mzaFhhzDkpgooV1+P/jUmIITqX6kMWrY=;
        b=VeiAcva1bqYtuh7pDXKLp7CCWiMp+mtyudbeFMhF3CcrIDTZyn50ELVua100/VBB49
         cVXdXs5KFmai+dwO6vE8MuRIBhalQ8xvYqM7X0lJyNu/YOFDa7FNXCe2LKkSihDz4W1D
         7ZFzTyyCZwJNJkbwLYiYiNCK5q/mq0x0qFiSOzLYqJob0AEG9gApdgEyXF9rKT7pJcMN
         dAmsCNlFo8vYZks+DpuAhoTGuZvs+Gq1HvBuWtSo7a6OQJBH69jR/v78MzxDPzei/a9n
         PaqOfz16mTJeGylJrg+bvIuTWRK2e/CewJ/R165NyIxEOoRkezz+EjDxLbS6d2sXXmGd
         5xTQ==
X-Gm-Message-State: ACgBeo1MTWCZrUuN68XquZLB+eBk8qX53pO34i0h+iwXU5LNLIGeMTxK
        r2BPHY7PgVnCjtSFARvOXxQ8HgoizaXamNbOg3c=
X-Google-Smtp-Source: AA6agR5tuRUZR0IlBO45g5ECD33dwG62ut1mSen52vtlh2X0vwlvPSvwabrS02/QtUxcihgS3/fWsBNfim3isW33hQA=
X-Received: by 2002:a25:2b01:0:b0:68a:6dff:4a87 with SMTP id
 r1-20020a252b01000000b0068a6dff4a87mr4907160ybr.364.1660660533045; Tue, 16
 Aug 2022 07:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220816124604.978842485@linuxfoundation.org>
In-Reply-To: <20220816124604.978842485@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 16 Aug 2022 15:34:56 +0100
Message-ID: <CADVatmPOCPfHQHEuwVmOb5oeN2HfWWMztVok3qvoq7Ndndb14A@mail.gmail.com>
Subject: Re: [PATCH 5.18 0000/1094] 5.18.18-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Aug 16, 2022 at 1:59 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.18 release.
> There are 1094 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Aug 2022 12:43:14 +0000.
> Anything received after that time might be too late.

The hung task problem I reported for v5.18.18-rc1 is not seen with rc2.

The drm warning is still there and a bisect pointed it to:
4b8701565b59 ("drm/vc4: hdmi: Move HDMI reset to
pm_resume")4b8701565b59 ("drm/vc4: hdmi: Move HDMI reset to
pm_resume")

I have not noticed earlier, the warning is there with mainline also. I
will verify tonight and send another mail for mainline.

Also, mips and csky allmodconfig build fails with gcc-12 due to
85d03e83bbfc ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
regression").
Mainline also has the same build failure reported at
https://lore.kernel.org/lkml/YvY4xdZEWAPosFdJ@debian/


-- 
Regards
Sudip
