Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342166A20E6
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 18:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjBXRyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 12:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjBXRyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 12:54:20 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DACFB760
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 09:54:19 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id a7so8572358pfx.10
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 09:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UoZ/TQWdeEYlMakdSAImOqOTB/EmUvCrkVRx5u+IHUY=;
        b=aXPwO1mklJNYlZDcoJYTxFGMIwDp4fYzv3AWcs5vdMwPTE/jXfTwpHJK+R6B+LDGOI
         yvfUa/8HrqtrhrgL+jOpmmyxypu7ixu4Zd+oJlDVkOGtj3w7VvqG0lUwwNl0JzJfk91u
         0npRCc/lMMaYPBvz6Pf2yCzQtogE2GXyqLApMyZUvZ479oVHidHTfMJqcq4c+vkfr3x2
         JDNVRHlh57SEhCzILYAfYpxM/EccOXEmc2O6XFI8HuWLsZpRSV3/KoKo16KF6QH1rOZs
         pPmva7PNCZMPnW5NY4rZCF+l5mF35nreQQgTH+uSj8jC1yi4w9so+DPb9HZgRjnh+RpT
         KwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UoZ/TQWdeEYlMakdSAImOqOTB/EmUvCrkVRx5u+IHUY=;
        b=NikssVz6x9yvy2KIBpjMwUuGkk+gdERa83pjESpI9cbY4Hyb9MMyIKlhEVKG2jUt4u
         H1TkEVnqVS+Ju1LezPLjel0YVDh/kSs7csiXPA/UM9HxydbUcEhwS/dijJFiOEq/Eu2V
         6IWTkyq3FuYuTJipCYqsQt0x4ITIoKK0TgQ8ueRI6uGgindRt3AMm0upET0wjyVEc1hG
         B7zcCeTl4Ubbb1YXTnpavaLgiwrlp7fKQvRdTGtBbl6i6sQ20jd0qovRNKd18P4nauX+
         uBAPFGbjtkCrCX7qTXD2q9wGKE7SANd2/eP9a4wKmsCJcsxGwaHop3paJKgDVIZkOyjs
         0oSg==
X-Gm-Message-State: AO0yUKUfwc85tjPS5SBYm59OTOH3hzkVEKRDq6mhC00ROSMsesi53yog
        U8nHMxrjL1m/Za/qEmq6vyGIMhmENg3ekJCY0aDoYZYslEKLNiX+W5KfWQ==
X-Google-Smtp-Source: AK7set8qzlAyQdNABBIcuKPWgCcVwkP+UNSeQIk036boMWnr5/Qx0DDVpDB88PdMX/eGoFBhUHX1E5s3+gGmJ+PBe/k=
X-Received: by 2002:a63:9255:0:b0:4fc:2058:fa29 with SMTP id
 s21-20020a639255000000b004fc2058fa29mr3203415pgn.1.1677261259075; Fri, 24 Feb
 2023 09:54:19 -0800 (PST)
MIME-Version: 1.0
References: <20230223141539.893173089@linuxfoundation.org>
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Fri, 24 Feb 2023 12:54:06 -0500
Message-ID: <CA+pv=HMWE_y9NGO0ujD3roH4pAqz-17X26HQOxO0xqyg=xmmCA@mail.gmail.com>
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, rwarsow@gmx.de
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

On Thu, Feb 23, 2023 at 9:16 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

6.2.1-rc2 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
