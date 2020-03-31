Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDDB199DBA
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 20:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgCaSIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 14:08:15 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34958 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgCaSIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 14:08:11 -0400
Received: by mail-lj1-f195.google.com with SMTP id k21so23043909ljh.2
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 11:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DVhNCBWWhqrmhwzD0I8O0Ic/nmsiw3He1JBWn/IFIGg=;
        b=J7MsCxfDvDHJSsVI38CazslySt+gUoXu/ZKBlY7htM/gc41yUSh7NR6xMRpLk8Q1LS
         2KxGk8DK45xbvzt+Q4HnbsAqM8xXnMFJlduwHtX1xaQXvUkiCVGB2wTzV8fXQbyJv+gy
         0JQ5wivKByI4/57Kq6VsJu066YQLmUH3re6fGu6Qmj8Sy8qQ6iZIyTUpBQTbH46QGNLu
         aGahdwVpDcXAxiF4x3XrW8bHuro/qOD5lk+5H/4LtlpaqSsRuy0lD/UqpptyLnO/L1sj
         j1HXetXm6wUKWmUe+qrhM0dtgwPwWn5DXUxg19VbWhiW1GSuslcggAPC2UeipIhsS+So
         7daQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DVhNCBWWhqrmhwzD0I8O0Ic/nmsiw3He1JBWn/IFIGg=;
        b=lPY5c5PsOWLTA/AinK6uehWG5wlNcqIofRU7DyKe7ktwDBuGVcUGScvxyDbo18rB8A
         wBTY7GTCfhCfeep4qCYD3fcAUQsFHeJ+bWwN61dU+C+K+235Hi1WQ8DcvtzTe2UrRGcS
         Z/gi95SdwdiJfVDl+HG0vWSDkG9ecgERLVKfduqxfhYoAszmDZ1zwgwJHns675nIiGIU
         UhwDr0fi4JuAxzFXUXqDTgXmLf8XzNN1cT3IL3Kca9Gq+5C8kIJ8wuj0mzJe6bcddDgZ
         b6Z7ubJECNApFcqjtm7ZDVFy8L1hDDtz0iTToGksjLqOX5JvgGKV/TR8wBdyUcOLsDu7
         i1JA==
X-Gm-Message-State: AGi0Pubv2gm+0CNKQQK6bVp1mDBm9VlR8hSqQk65qzr9y57vSYQkq1v4
        F62AzMdwv+APisTh4PSMXOgoQgcnbslen52w4IOYUQ==
X-Google-Smtp-Source: APiQypKyNWj02m6O2+eo7TowUgPoys1dqm6YlLWwR2nN0+0/VQMpY2mP/gmN+2nUCtyDoNjDn+QfgYtycQwmL3sZNiI=
X-Received: by 2002:a2e:8015:: with SMTP id j21mr10329966ljg.165.1585678087993;
 Tue, 31 Mar 2020 11:08:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200331085308.098696461@linuxfoundation.org>
In-Reply-To: <20200331085308.098696461@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 31 Mar 2020 23:37:56 +0530
Message-ID: <CA+G9fYsZjmf34pQT1DeLN_DDwvxCWEkbzBfF0q2VERHb25dfZQ@mail.gmail.com>
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 31 Mar 2020 at 14:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.1 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Apr 2020 08:50:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Perf build broken on Linux next and mainline and now on stable-rc-5.6 branch.
where as building kernel Image is successful on arm64, arm, x86_64, and i386.

I have reported this problem on March 25th
https://lore.kernel.org/linux-next/CA+G9fYtr+Je4=pLWUgUvPNzUSUmg04oXPJ8zFwTRKji_udcZzA@mail.gmail.com/T/#m7909c9746aceadd95d67accbbc9798ba1dd19157

-- 
https://lkft.org.linaro
Linaro LKFT
