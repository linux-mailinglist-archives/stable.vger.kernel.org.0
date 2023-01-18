Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA9D6723A6
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 17:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjARQku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 11:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjARQjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 11:39:35 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6044711E86;
        Wed, 18 Jan 2023 08:38:53 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id s3so24107500pfd.12;
        Wed, 18 Jan 2023 08:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ElQLm1bEEQyEGfnTuG8KWGBTmNlKMxnd1pxdVxQfdlc=;
        b=C9BK4foCMALXszUpeGRdyt/EPpDmXUmv9gUXHKhxhbNHvEt0pi9wx3/si71AntsU7Z
         xDaNR4xzWvkh+K8laG7LKl/RfCdLnTJQc73N46yGMbROy0wD/sPnNhYNb2OjrbQ7c+yp
         qDnifb++/ZwBcAaPlfbD7GKzXuqPQChZloivW/IDAM2QZMp1oJn5FlqKnVCr3B0sVkzh
         SbL8BjhVmIco2n4nWs/ZxNzPtKOXsWrrnYsgmGM8gtwdBDg44fFP65yf2WSk+KumCnWx
         5KQ1ihPFRAhMY0mTydlyUfRnsY1YidE6xs6Mf6nfleNxByeN3EYk9NSflpt1eYbMT+Gz
         +l1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ElQLm1bEEQyEGfnTuG8KWGBTmNlKMxnd1pxdVxQfdlc=;
        b=ZrHZoLVuYhZom/r9pDPYzvMesp/kfIyTQpQ0G9qP0EXEeGROWVLUK4Kxf1pLI95K4F
         wKDkBshiYmYJjzrDavdNlGwnhalQGcPQj955Is3fN9+iZR5qws5DBUV1Qk3cN+fpjpOD
         B52CW+bHZqLmjE+IPlVbuChI0q9PGzgujZlvqJOd+CVZv4u67twXaCifS3kLuFfgN/YH
         Yu6wMWaG4dsp0wxGJhLqBlwVpdBMr9YONykS8qHZnJJul+q+vnV0POjsn14X4up3N/1+
         sZZ5WnfhmbPUTT/biJQ6FnZoHvmh0aPW0YoNMPKGtNUns4feg2+wjRZfTplY9Omfjqw3
         hVJg==
X-Gm-Message-State: AFqh2kq97i3U60HcwW4iS1AhaPiDXqaU8Y2e69GOR14SQpR7y1ibz0HL
        8lzjMwbJlaj8BffHh8fiCtQRQPrVvngSUG4eVFtYoeASKIE=
X-Google-Smtp-Source: AMrXdXuj4Set7eAlseRnIV1xV5bdym0f6Rg+/GJ16smJ3j4Mf/IJPNpvWeGt2soVY5rmLrgtUpEhWPf7qjkb4uY3IfY=
X-Received: by 2002:a62:e40a:0:b0:580:8b92:ecff with SMTP id
 r10-20020a62e40a000000b005808b92ecffmr748474pfh.4.1674059932918; Wed, 18 Jan
 2023 08:38:52 -0800 (PST)
MIME-Version: 1.0
References: <20230117124526.766388541@linuxfoundation.org>
In-Reply-To: <20230117124526.766388541@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 18 Jan 2023 08:38:41 -0800
Message-ID: <CAJq+SaBwSL+chM14Dod7qZRSuYSS+KE4GAPrsQi89OpcOp-t6w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc2 review
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

> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.164-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
