Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A9C66A1B2
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 19:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbjAMSPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 13:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjAMSPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 13:15:23 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBC561478;
        Fri, 13 Jan 2023 10:06:24 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c6so24221774pls.4;
        Fri, 13 Jan 2023 10:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sa2g7FJOgJR5lztIY27+SRQnR070J0QWIXiIFM842Yc=;
        b=SSS1hANJ+OPfjusrDqstBBfJDVq1449DfXw6jgJZp1raIrNZXxztfQ6KWj3NIGgAi9
         uSFXQXNj4IqHMlGHaYQFf4JtHwpb96wv5aOUQm+27xfnC2dyLW8hQG/OJOOnfvuUMWjo
         5gruHRDXptgsUP8Gj1pvD5bzFfMiLxjVnuT8yoZdTv6M0sQt5K6vVgVQyegWJzojgnl7
         gFtzUtNcS6nxHQnPpluY3jbn2d/oFVgXVBi58P98vZwEd5XA1JT2Y6LdgxSceTS+mvqi
         06oIBl1EG3oHsyqrIe9IsuAd36wL8TEuAOH92aWwd0HM/+5nVyhKq85sxgRD3p0DHtF9
         EWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sa2g7FJOgJR5lztIY27+SRQnR070J0QWIXiIFM842Yc=;
        b=wIfRYq/l0Huk06cNWrATH9/rUbBwlkJtVWQUSpeKKxqPJ2BwiGvY0jYhnAk0v0zD/I
         YfCEbG1TuAkNH4r7oH8/WOR1cIv9Shp48M/JWiBkEtXRmkCykEiHyyyitPmZuG8uCN+6
         Mx+mzVNn8dO2vcTNwQ+UJYtQhRyBgZgQ6I9ab1LWDhWc2wr8WFt14Q/oRyJWTPzCw4/N
         te8rDfR/oH72DNTpqMTOvwIJRXcgramNsJn7DDott8vgHCOm1m5DM1iR+v0J8BtDsb8h
         28qcXfiYqNWYM/zX9sytxJkz4qfJKB+xTik/qRj98Bg2+B09pkJIq5diJ5Gzs0e7uNl3
         LLyw==
X-Gm-Message-State: AFqh2koBgoVcU0vLNUdXLFg2FMuHEWBEmA/kw7NVANLLaw+Zj5R0edMY
        19o/BJ7qVfe6I87+PnMzCWB+Pp85xaQUzrKF25XSc8MTuDQ=
X-Google-Smtp-Source: AMrXdXtCLU1w6j+YIuF5eLVVD9LMwU9ohKdWtVdLTpdZcYdIeGCUgVE62yLP0VCBdU1VmbhiYQ+0ATQox+2xfMAcWh0=
X-Received: by 2002:a17:902:9a4a:b0:192:c6ad:4c35 with SMTP id
 x10-20020a1709029a4a00b00192c6ad4c35mr42031plv.15.1673633184164; Fri, 13 Jan
 2023 10:06:24 -0800 (PST)
MIME-Version: 1.0
References: <20230112135326.981869724@linuxfoundation.org>
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Fri, 13 Jan 2023 10:06:13 -0800
Message-ID: <CAJq+SaCui9zajxTs=wjm7mNx3yzOSZ9Rh5UtJ-XDbK31AY_zHQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
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

> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
