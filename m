Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540296A15A4
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 04:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjBXDsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 22:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBXDsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 22:48:00 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2619F10419
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 19:47:59 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id a7so7314402pfx.10
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 19:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YvnJfAXN7dbI96u1aUOT8Uz8u1lD2ldVL1eF7bXvzTA=;
        b=TZaziYMrTFJ/Emv9HOlF+iPYrj/mP7EZltBXnnJBhkLJXZlhenIFz0VeZuZxB6kNOo
         hsNE1TQy4Zvojni8+OMNjNgX8YE3a7YeU9BRzyWADX3MgGtD5x0feifjW8NFPRlLJipJ
         35ZyYOz6V9816hVGgZTm65Z0pComE9sGtvJ8YX9aL5aNFG3xZnWWTMa5umj/NcdNA29J
         UN0bnW5bRKeizDw8Mj54lALifB+gtHsIWqGwAeMppkVh/2NgrOd7i5amH2q6paQd4KIL
         Ik+nLrQ2Lyl7UvzoApnzEWXwYHjP1RV1608yPr3sydcuSK/g7tSOh7rPW3ouEksl3sUh
         O9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YvnJfAXN7dbI96u1aUOT8Uz8u1lD2ldVL1eF7bXvzTA=;
        b=AR6SC2rkI+PzowWlQsjgC4D+nMf4JKAvuYUjG2kr+cdI9tcjBuztEJKrcrnJ0qMzxV
         LxcrQ9eLsfqlsG5fd+H9JRCkNum6FP9/no3RP3U4hYHwqFZzz8g656u/mju4g11XsTVZ
         TbqaIkwzSPvc3I8ZVMu3loBdY0A61gdJS5UtFNiSINl1pkIELImPf059LShLVQMBwS9W
         azABydVywkvwHZxDkErtsz/J0vx1DuFdwRsX3LzirdRGhJo216Iy2iDlZkRiF6MRIf9t
         jN38+XvfgeogAGhYRn+nqV9D6bDco7O0i2pVCD3v9yebNvinOn62MKvcHeeeMq7Tk5SH
         vgcg==
X-Gm-Message-State: AO0yUKW9bSh3D7LRHaE9CtM+ueyYsD6YYli/NxEYxkURoXPPftEf11TJ
        /wpSjaIVzc1FNPWmVjJ4CBFiwOq1mQ+DxykpGWT/sg==
X-Google-Smtp-Source: AK7set+4E3qR7YRqGWtswOJsb0v1VH/9DZqSi2xOqMlQBKbZalsC7ksSWhaJHGLddEjfxmY1fXyfL1g8iqLGEjnpbCE=
X-Received: by 2002:a63:3ec3:0:b0:4ce:ca8b:ddc with SMTP id
 l186-20020a633ec3000000b004ceca8b0ddcmr2447500pga.1.1677210478555; Thu, 23
 Feb 2023 19:47:58 -0800 (PST)
MIME-Version: 1.0
References: <20230223141540.701637224@linuxfoundation.org>
In-Reply-To: <20230223141540.701637224@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Thu, 23 Feb 2023 22:47:47 -0500
Message-ID: <CA+pv=HN-M8Pp+qY7=nsi4tXOjtFuL5nhTyUQ3chtR+GZvDf3cg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/26] 5.10.170-rc2 review
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
> This is the start of the stable review cycle for the 5.10.170 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

5.10.170-rc2 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
