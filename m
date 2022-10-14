Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3285FF3BB
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 20:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJNSjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 14:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJNSjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 14:39:19 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368A47297B;
        Fri, 14 Oct 2022 11:39:18 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s196so3745930pgs.3;
        Fri, 14 Oct 2022 11:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=005ujTHkQSN51VazCebo1ls5rej/w0AucMu6nYUSRXM=;
        b=o4t2w+YH/1nJHLH7BXzNaTv3Orix8ffZpNNLx/WjjfmLg7No16sZC0RxlFJdWuOpLK
         rc1XRTsex4bwI+NAXUunLEGZEAbjz05oD03isLg3pID+fd600mXK6CKiXJ+RIl8IHihI
         wfakY2AYeaBs+mghWMmUoPwKbUclIKAvKmd81cTJ54b1Upks+GDZD7Su9XXnEpB2C1Bs
         3/rLz74trX6YHPD/gUE1zYDhvy4qkibdr5WPHnGBeh1vA8QyRQtz8Ojtje8eOAevQTb5
         +REwKXfxxFt/HXB1MoM+MQF1qecxTZp0HdQ3CRQVSOWJrZg8iXEyZBXoVBC6JgWCqg/M
         a36w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=005ujTHkQSN51VazCebo1ls5rej/w0AucMu6nYUSRXM=;
        b=CVYf/ziqzrkHO+msGJSPiJBQP7Vdlwaoh1ltVZnDjdxyB8GgDIo64FzGyWyHesUHrO
         SlH52VOA1D6h9SEhzgfugss+iqtugFR0xdyDqa9MzwfcA7p4/s8LRlR7Nvp3IC7e2Fxt
         xm2fLzmQgrbQ9dPoiY/OOPBrmiNX43FZM6ubVd/wFOH0CuwnupyjjRDNwq7mZQPO7P1R
         NGwRbDwK6IS4bxT3CM9cHXGsL0XmeLx19ixlcFTANZcI1nfU7YVtT6xnwkl6ch+OMXOl
         wmGyBEfrDjPkk77vO3wOy9bYyBh4+zE0kQoR6A+jRglVGw2pmjvKlMu0oCJpGoToYWY0
         HmjQ==
X-Gm-Message-State: ACrzQf1p0mh7FQnld+QVkzvy2/J+p1F/rOekAf/rrhEMV0NyjtHI4a1z
        YnYUqcGuFR/6KqXExxj5OjJ+hIyuGF9N/fie3Ac=
X-Google-Smtp-Source: AMsMyM7TZLZw8Bo6gzBnKo+5x1m6W2VRG2URGbi55O0bBS8FcFGInciCzqzwKauSecZ43+yd2pH7Z/nM7tGX85Ip8lk=
X-Received: by 2002:a63:26c3:0:b0:46b:1dab:fd88 with SMTP id
 m186-20020a6326c3000000b0046b1dabfd88mr5744312pgm.251.1665772757743; Fri, 14
 Oct 2022 11:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <20221013175146.507746257@linuxfoundation.org>
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Fri, 14 Oct 2022 11:39:06 -0700
Message-ID: <CAJq+SaAPbBna2Otpna7yNAcyt8edX5GR5C=_dygYDyVVDXZsMg@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
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

> This is the start of the stable review cycle for the 6.0.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


6.0.2-rc1 compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@microsoft.com>

Thanks.
