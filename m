Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5036A2207
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 20:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBXTFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 14:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBXTFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 14:05:41 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811771B2F8;
        Fri, 24 Feb 2023 11:05:40 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 130so127496pgg.3;
        Fri, 24 Feb 2023 11:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HykiGP0bNNdihBWrRC8kDEBoQUKEGDmR5MQwZWpb6iM=;
        b=XmuEooqbVnFwDcjO2G4cLl9j4gn4PiEMo/wrSQ0reIrW5iDF+uD8sUnfI36tHs+AgH
         CJXhxOdal525riy1Nne8pwId0nugIFC9V6qd2gO3WadZAsKvCdetCpgxZmfPutuhzthU
         M9zLT9KehOfnZT3CPUjzmMcJGwfaudHe+3tmub9uLOIBfSiao6tdMqno70OsVWtFQz/o
         nw0J0/aN6Hr5DcBncwqhkDwNv3u3XdTdmii+ZwonEGQornlVLLP5ajOSU4RTWDMnh0Ij
         YU2JsI5A6itdFyMQPSiag+5UxfrI5ZlhpX/LE1JQx09gg8UZiVGtgXQoRdm30DA56QQo
         dojA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HykiGP0bNNdihBWrRC8kDEBoQUKEGDmR5MQwZWpb6iM=;
        b=FUosvF7Z0CypqJChEnE0er0Uhj9bRMXqRg0idGKyXAL5dhGzVsy02INNaLjC1v7tr7
         q/CoDOyq0qDh1UJDy1bWo8msV09ZYFUYxCwICVHP9kcDfhdL9GFidr0nycBxUxoIwqN/
         trhAxsvWlySfvItlmMtxAtegxrrVBd2Upxidshym2iNdJNt3IDqyq0SozI4J5QxTO7aA
         vcRqXScEMKiVgeqHXfJcJdyrM2wQiZO4/GHIRQ3xTWKZ8VQCmoQGJAqs7AEplYjQMNJz
         aZHdU+cVUmVUFUx6VjRM36l64V7XIVA7tmuZ7SA2l075TqVAi952uqocy+rjsktB95ZW
         E3QA==
X-Gm-Message-State: AO0yUKWzHwtcoASvvINQ49ICnuPYP9i6meeFt08zufYkfIPcDBG9NqoO
        6RY2CoS8ITXl7CyHDnox5NRsfNvt5r4NjHcLNrw=
X-Google-Smtp-Source: AK7set+Xd4sG2F75wprBCCONYAfJHr/dNcnLeof3gcRnFa+YIrlJ4neRUtfL7dxYgDlMGnSf9lJ7rMWhn9XAN1eXNqE=
X-Received: by 2002:a63:721d:0:b0:4fb:935c:67f with SMTP id
 n29-20020a63721d000000b004fb935c067fmr3226190pgc.0.1677265539938; Fri, 24 Feb
 2023 11:05:39 -0800 (PST)
MIME-Version: 1.0
References: <20230223141545.280864003@linuxfoundation.org>
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Fri, 24 Feb 2023 11:05:28 -0800
Message-ID: <CAJq+SaCAjsMBrcqAkQU4y=Noh4PvrCMdB5SUVhAsD71byFBWyA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
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

> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
