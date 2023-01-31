Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE9168336D
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 18:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjAaRMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 12:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbjAaRM2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 12:12:28 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA8F530E6;
        Tue, 31 Jan 2023 09:12:15 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id jh15so6706805plb.8;
        Tue, 31 Jan 2023 09:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dKf5Ya064WBi5OgBkq2boKVDTlvDbMuuWdhqR5krYGY=;
        b=mqueMbfMP3IEhLybhAA8wG/50RMR8IPrnkkeeXekST9xj6SNcPnynFddM+QJjdzY9t
         wT59vqZuVUyOx9UnmEhpw51Di+HmojLtRq33Yx+AL4QzYPLm9MAeJ+D4BUhfaJuuETgT
         DbmlVtmd14YC/HixY3PQZBMux+c/4KNIThuphlvfNGFDIsQed4GpvEy+d5lBJT5XXEr5
         KI3s+rGNcZ3+ouAcDZ3SXgf8F3VhoM+UofmlEPCl/GEe64rcm1k/1rO00o+7CJYzYvoG
         09aE32nj09QjhpLh7DIFo/pK0F+hG0aQLLf0W3jJaRhx+RlvpAtPWbup8KSdts5zKX0S
         zQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dKf5Ya064WBi5OgBkq2boKVDTlvDbMuuWdhqR5krYGY=;
        b=lSWoSoWgy0qIx7Uw0XEGOp4XAN32rblD8WW/d2BUiqoMLMqiKo1UNFNLSN+Nd5dUz2
         pdfwxOqmggkrl7Unk8aEAxKPX1gNS5BhgMolaHBOPMXSvf5lG4cVzl4W1+BzP7uPK3xQ
         wnIXgmtQY+D1mnGPatLfuaBIfUdzNM17SWxV622beoiQcS6y8cNJc86WletuJsC6av7p
         MgltTiny4LMEYIhxHj5wMSDTuJn58h3VG8ClB2QQNBU9nyYpHw8aQjTqHP8mAvKqNJ5w
         njsnj1jQa2uXsNrvfd7+W11FwHkmb3KVnsNN1c3I3hZjdt4ov6CHoMM/lG5RNtwz1rgS
         V08Q==
X-Gm-Message-State: AFqh2kopuOcBkwJDPTF10nZ7HnzAADW+0TPrEo9FhJjhbed7Q4lg3m0z
        Qw64g9TeLslf8/ur3YlFfEXaWpWIb2oBPGyHRmQ=
X-Google-Smtp-Source: AMrXdXtC29gomKq5jmS7Tfuvvbo+9CTRB4gl4f4Ry4LIsjH2UKCed7susPKjMtgBInlgosqEbP85u2qV+fNMlB2cSlE=
X-Received: by 2002:a17:90a:6342:b0:229:4c59:3eeb with SMTP id
 v2-20020a17090a634200b002294c593eebmr5781742pjs.51.1675185135179; Tue, 31 Jan
 2023 09:12:15 -0800 (PST)
MIME-Version: 1.0
References: <20230130134316.327556078@linuxfoundation.org>
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 31 Jan 2023 09:12:04 -0800
Message-ID: <CAJq+SaAx2ripBHbmNN4QmdkmWVQ=ey3sBkO+yLRSqhWwp+bCOw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
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

> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.91-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
