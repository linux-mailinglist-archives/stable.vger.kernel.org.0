Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE1355B00F
	for <lists+stable@lfdr.de>; Sun, 26 Jun 2022 09:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiFZHuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jun 2022 03:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbiFZHuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jun 2022 03:50:12 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EED9120AB
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 00:50:11 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q18so5593559pld.13
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 00:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=szddLrd25i6U/qAutufSCQ2QV6OuNtFw/2uiX/jXMh4=;
        b=frQpoe8ICsxbq/MTv7WGnraeh4/TfkGPi93p9PbqfAZdOUPTVZAgoXI797bfdn/YAY
         gJv4b22jjyPMwZk5FZ9H6AJ4rXbxggNwGN2lpDU5fGL+ymKSaJLjGXDKPOfc1H88HTSq
         upljifWvjf70kYZrddeip0InkVoyMNZHHpJkqA6kjbrNmysHSFIp9aLMAi7+MH7Y2d4w
         aEezmHOinJM3MHmJg0YuwIB4fYA1FYSdGp0g9e8/yJRIQQ6Xcvhph71b1IxjE4r2X8hC
         G8PH/+5MWzgcmQ7jA/khhRd7ZoxMKxakz+9ogF05cNP+WcQSivmMk0USE+CkPBQ0CB5A
         gMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=szddLrd25i6U/qAutufSCQ2QV6OuNtFw/2uiX/jXMh4=;
        b=jmZsCOgDjIsnlVx8fWAiKenw9p/tu9sfJgrXj2qT+mnfJwzhLe7mAVMFLvM7z+DjM7
         VKbeYFESE4O6BE0KO+wxktpEu+NeYELzyTQz5kV39yQdNdFEPIe8y8S9CF2XLC89aHyq
         knlb49wswnw++Wuw9oxLa0ZREY9EP4bgPwat16UI+13OxNh5AZeoGlR/fgaAOygzxcNd
         v+n9iIsWyjyrdeWikKuh7hAX+6U9sZztu60K876kNedf0tsJxQKp1fPYI5MRud2nxBN3
         tDxtgjc8yd7ZSO6T+7/M/3Aks8wsc5o1nBaih8/LHiWTZrLKdV4v9LEf5i3d5lzoCBQ/
         W2TQ==
X-Gm-Message-State: AJIora/3fk+ZHF1ltM8FMn6L/1rA51PZT2F10lKOKugCGM+lSwFQT5Gk
        K3f3wCjgD9WTaeKNcr5H4+LbbTWMiycwk660pcbHCSGbTqObDA==
X-Google-Smtp-Source: AGRyM1tdCN30W9IzWasfH6F+mORtmrDOJWVskcMA9e9OIc6YTzpBZ9LqUTT9Zlx1rEJ4T/seOwPAzC/EHBOxBImVHog=
X-Received: by 2002:a17:902:d5c3:b0:169:672:f897 with SMTP id
 g3-20020a170902d5c300b001690672f897mr8063721plh.71.1656229811096; Sun, 26 Jun
 2022 00:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <CADs9LoMEF86Fp2-0ji7d9CNA5F=8ArwPWnj09h_Cwo6poNsWVA@mail.gmail.com>
 <YqMdS+3qpYHfWN9f@kroah.com> <CADs9LoMAgCNU6Rx2y0t7kRMmLw-Qd06Ayq19qM2-PkOJUgdxig@mail.gmail.com>
 <Yrc7Z6R4iG26FkmD@kroah.com>
In-Reply-To: <Yrc7Z6R4iG26FkmD@kroah.com>
From:   Alex Natalsson <harmoniesworlds@gmail.com>
Date:   Sun, 26 Jun 2022 10:49:59 +0300
Message-ID: <CADs9LoNs=r90qtCwgQn2jKnYHCW7WnAWs39G37nbs+8RvpoVBg@mail.gmail.com>
Subject: Re: echo mem > /sys/power/state write error "Device or resource busy"
 on Amlogic A311D device
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        regressions@lists.linux.dev
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

> A: http://en.wikipedia.org/wiki/Top_post
> Q: Were do I find info about this thing called top-posting?
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
> A: No.
> Q: Should I include quotations after my reply?
>
> http://daringfireball.net/2007/07/on_top
Thanks))


> But this is 5.16.0, the commit you pointed to is in 5.17.
>
I don't understanding why so it... At present  HEAD points to 5.19-rc2...

commit b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3 (HEAD, tag: v5.19-rc2)
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jun 12 16:11:37 2022 -0700

    Linux 5.19-rc2

....but
leha@VIM3 ~/ArchlinuxVIM/linux-git-sound/src/linux $ make kernelrelease
5.16.0-rc1-ARCH+
leha@VIM3 ~/ArchlinuxVIM/linux-git-sound/src/linux $ make kernelversion
5.16.0-rc1
leha@VIM3 ~/ArchlinuxVIM/linux-git-sound/src/linux $ zcat
/proc/config.gz |head -n 5
#
# Automatically generated file; DO NOT EDIT.
# Linux/arm64 5.16.0-rc1 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc (GCC) 12.1.0"
leha@VIM3 ~/ArchlinuxVIM/linux-git-sound/src/linux $


> Can you send the info to the sound mailing list and cc the developers of
> that commit with your information?  That commit looks odd to be causing
> problems.
OK. I will be to try.
