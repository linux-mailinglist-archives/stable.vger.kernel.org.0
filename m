Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148C45FF2FD
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 19:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiJNRa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 13:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJNRa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 13:30:56 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA2BF9848
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 10:30:53 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id l6so4884883pgu.7
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 10:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6zlBNdTdlxMcvkm7mdonCst9reseXr6z7t+NceA2Aks=;
        b=nFSDXaNtHMFhC53odDFrgdQQdPkqkzamzRceb+Jofn+9BLdkd8I0qTbfHHdK1+pdNg
         kXRigXwyfjF/10h3iTz63kWJiHScF/0MxJsDMTFRCgoG3GNo5tV7yd5Y6y2PInf8B1OW
         pmdQNG6kyFH63+DoW+2cuTs20q9BEdSAUTg+fcq95iXdnGhGGEq3EBEe52q8kO5gBTwY
         JKEuA8LxzOpylMhVtx9gSJKWF/POa+jSqdgfS1KITKl/C1fsCOfhS/d56y8V7j0JKD9Q
         dIKrMqUMtEuV33euJiKnKaDWRBbYs6EwdisUxXXEHJNXLpOjDW5H6jg89UYQxz+TDHsU
         tPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6zlBNdTdlxMcvkm7mdonCst9reseXr6z7t+NceA2Aks=;
        b=WqvDF0Ekt40OTqYTYP9u1dFxNdHS7jIVW9d0bDJDtKTD6f7PJZkIBwlbz4/Jqa0toX
         WPuB5QmW9oMK2NHcRIiqS6NFRSI7zFdT7VPcU0woaHfBEd93yhmfxHgTQWUBZcCBNFcr
         f7Q4Kg+Qgg8FAmsQQmsusK5RJFqKi1ufuV+a4f4/4inhmdFct0rEsqr3NjpZ7j84Zpu/
         u7OGLfZbY0lkANO4gu0LCnLnZ5rod83jbMTrppeXJEsIw0CjlU0xup77Tqf68WtQ8PA+
         yB+HfgKFQslL+mm0+l0EC4fBkqWNw/k/jyCovDrB00yt+hOpXntn2qwI4bqnJgYLbJCG
         /Q1Q==
X-Gm-Message-State: ACrzQf3WXlL6HaXcquWqIp1lmrOgSsdNJhWQvJMq11OKPMyK6rttcJfa
        BwjmJARvyEBRefowoClWMIwY3mtqg4XTcTOevc5E/Q==
X-Google-Smtp-Source: AMsMyM7sRP0V7FxlKLvZjXrrPtNX4QNAqKB0Xh+lwS1OJ5WwcD1A9xArUaKzAtuIjLjelgOTlw7ur4kli5Z1cXucv5o=
X-Received: by 2002:a05:6a00:3202:b0:565:c863:78a1 with SMTP id
 bm2-20020a056a00320200b00565c86378a1mr6576286pfb.7.1665768652236; Fri, 14 Oct
 2022 10:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <20221014082515.704103805@linuxfoundation.org>
In-Reply-To: <20221014082515.704103805@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Fri, 14 Oct 2022 13:30:40 -0400
Message-ID: <CA+pv=HOaE3hRCfvF8YUXMtsArgOEYznxoWROrXLbkJU0fYdksw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/33] 5.15.74-rc2 review
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

On Fri, Oct 14, 2022 at 4:25 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.74 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 16 Oct 2022 08:25:00 +0000.
> Anything received after that time might be too late.

5.15.74-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-srw
