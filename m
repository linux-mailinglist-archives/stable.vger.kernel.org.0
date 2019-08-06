Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F62B82C6E
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 09:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbfHFHRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 03:17:05 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37968 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731734AbfHFHRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 03:17:05 -0400
Received: by mail-lj1-f194.google.com with SMTP id r9so81366554ljg.5;
        Tue, 06 Aug 2019 00:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aCHExauS+6Dyffx1L1clQWEUIQT1dcM2oHQ+r37woEI=;
        b=SSctfUSLDVBcE+BumDkxvf5g4OG4yv2b/XASm8pEv6hiz85l5yQ9/mHyIHEewK4cls
         lLiBoOwJC4cK9Vjs4hxkOR4n43iR5leyuKaD828mwnckAYyn122x61daCbvKwybkBbJm
         WR+aQ+BdZxQguPF9GCmg8qzAh+wUxGGfkm0BsLaK1XU+wPWhk0sd5itkbJtmN73Tv4L5
         7Ew2dCFCQJlzSnjN7t5amb95rlzXNoqCqRCtMoMcBa6A3pV1dxG+x/uV/QpKfNEo1lK0
         ZYxTWysYcR1Iwny7zR0BhkT8ALNYy0nu31F3Iy46LSHm9D6gaE8Yp+JUbac5/n08cdUY
         OAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aCHExauS+6Dyffx1L1clQWEUIQT1dcM2oHQ+r37woEI=;
        b=Jg4q8kTv2P+OEBQrYlEMa5fVmDsQRNfzifRbbBGoGe3SHZFr0PpazNa0UQi2Uhagwi
         Cy8nPBWSBnxyVbM8rXTYyW/POcSJdOK3G9Egr9BuO+NjDvAKcG3SDXFoEH19f4JFxziE
         igoTj1FIk8yAyxPwGLJCpy8KdhrSFnv43QIEkrD/UaLU0nRWTHH3dKql5o1KMtCp6JzT
         EKcaKDmpZKAY4IdcxXe3uCzJ9F7Ro2M4iA2LCB3inax/byJO4aewVH2qxpYTAoabhHUN
         74dqDzqOC6PCaXMZWXXjuC5aYTyxq3ZAvGhBWVxOCY4Gxw1epLpPCPKKI5wEWcAjB/AE
         t/CQ==
X-Gm-Message-State: APjAAAX4wk0fr1YhY7SxN9INJaDjBWjK85/foTFtpnG7szfeUHbT9gq6
        MTCjYtf2rc8FpZGzX/zpaq+Y+s36JDGRW1hgG65BpWsg
X-Google-Smtp-Source: APXvYqwDzILiqd/Kd08oGGeNcSI+mkFtAyYu5xi0QPQbcuFVAFLUBmavrjVeYJeAfsHlOJ6q3lSmnS9ulQy82UL2j1w=
X-Received: by 2002:a2e:814e:: with SMTP id t14mr996325ljg.167.1565075823138;
 Tue, 06 Aug 2019 00:17:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190805124927.973499541@linuxfoundation.org>
In-Reply-To: <20190805124927.973499541@linuxfoundation.org>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Tue, 6 Aug 2019 09:16:51 +0200
Message-ID: <CA+res+QCH9gy0uJBTYd5uc_9uMGwb3STcox3Tw4ZqZgh=5o=WA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/53] 4.14.137-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2019=E5=B9=B48=E6=
=9C=885=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=883:14=E5=86=99=E9=81=93=
=EF=BC=9A
>
> This is the start of the stable review cycle for the 4.14.137 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.137-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Merge, and regression tested on my test machines,  all looks good!

Thanks,
Jack Wang
