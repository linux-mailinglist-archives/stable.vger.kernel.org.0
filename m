Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5411ADE6D
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 15:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbgDQNiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 09:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730563AbgDQNiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 09:38:10 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9DAC061A0F
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 06:38:10 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id r17so1833360lff.2
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 06:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MgPH7nQj3vUC9GWiYpHTU8ETkQh/2ehYV0kXVa78P8I=;
        b=vACs4Zlp/VmjavGK5+GSgMzsaY9cT50/KVkg4V6uxD22YbDGw5fxhMFdvrYw0QfM/7
         rsjJymO+g/au5YA0c1dkq8ZIM6v5Z1f7jyTcU0tlpIgO9caWzDJ6mBCzNPvNwIXlrGyW
         QqNMIDIgISWqGadkczWzHWzaiAoVD8ngEpNmZ7iMZnFO7ACV3+FAL0wW/JUFlJEB2XnL
         i7WkthDRJKyF6EOT8ZskCrC2V5K4LJVZVAYGWvvYmlZRDXfXP5LtC3uJn6iNCwsBjIpQ
         xj1AW8f/1W8RMgpCCyjjO40zDekhifNmmmEzyQvwbE/Vw4/6gmjEBNx0so72bhrbFhCB
         Q+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MgPH7nQj3vUC9GWiYpHTU8ETkQh/2ehYV0kXVa78P8I=;
        b=YMmVMIN1BYJzEFC5Nx0FXxWvAN8Hc7YVfUAGmMPIiIQbMBO+gd7Uon2uuNq81b9RNs
         Svdq0L7FfWppmT2zoYCT/w9E+asnZialdHjCIV4mBPHIpWHyHzZz6xr9eDQR6WeQPRCd
         uN4Pu2XggA711h+ytlD/CL2SShOxERo9eQl1aaD4PhDzoC1LECJ9aUQ8WVdUhjXf9gs1
         sa3cvo5QfLguSdzFL8pjekNyagALQmbBxLZkQqDjcJDSPyS1MfNemk8tZ9oICXZsnQJN
         XaZ7nSNIV2UEOFahenzagUQhWuaQ3n5U+NhWDd0muYx/QW287txTrBf3OlU2QNYKwtcf
         VX3w==
X-Gm-Message-State: AGi0PuYNEAjQnIfPWkfRsuyUIbFfgI+gF5E1GbJCNPx4mWgaLm7F74j0
        xeujB8SkUMuP2R/w4TeKMEqUuo12DvWH77eY1AQdig==
X-Google-Smtp-Source: APiQypLWs7opaXAHqtF88lKjIM9gYEdIJBNHuwDMFnM7rXP7/kbD6FbknRESbUM7affJYzTMbTmq1mz5SEod+cikLns=
X-Received: by 2002:ac2:4143:: with SMTP id c3mr2125530lfi.131.1587130688648;
 Fri, 17 Apr 2020 06:38:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200416131242.353444678@linuxfoundation.org> <20200417123531.GA19028@duo.ucw.cz>
In-Reply-To: <20200417123531.GA19028@duo.ucw.cz>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Fri, 17 Apr 2020 08:37:56 -0500
Message-ID: <CAEUSe7-CBJsB6Kpsg52rjywN7jNeQRu4fU7tWSeJn0zF7xA2zQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/146] 4.19.116-rc1 review
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        chris.paterson2@renesas.com,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Fri, 17 Apr 2020 at 07:35, Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > This is the start of the stable review cycle for the 4.19.116 release.
> > There are 146 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.116-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> > and the diffstat can be found below.
>
> CIP project ran tests on this one, and we have de0-nano failure:
>
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/1=
36707029
>
> Detailed results should be at:
>
> https://lava.ciplatform.org/scheduler/job/14716
> https://lava.ciplatform.org/scheduler/job/14717
>
> ..but those results do not load for me (?).

Looks like the device failed its health job and went into bad state.
Jobs submitted for that device are still queued, hence the time out.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
