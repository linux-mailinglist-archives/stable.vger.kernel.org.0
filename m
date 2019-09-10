Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A68AAE6E7
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 11:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbfIJJ1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 05:27:51 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42232 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfIJJ1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 05:27:51 -0400
Received: by mail-lf1-f68.google.com with SMTP id u13so12857911lfm.9;
        Tue, 10 Sep 2019 02:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=des3FmaInciiDX/kbaTdrmt+UrXUSx/UL48o1MoSUCw=;
        b=ZihR0Lcy+n6XFpMb5D4I2FEed+J2lJt8NlNvxrbKPK3J9KVqxm0wo7JqYQytiXHaoM
         Ce4aNqnIzd0zgFVjy3YhK9j+Rm7kc5aWGau6so+/HcE0iXZGWJy1FfxZQWJd8cW+YQH6
         Wufg2wCDEhY+uyjJLJiSYreitqEfUFITKYwgSZV4Nc1zITc+qvBBO1CeKGRWxSl/ZgPo
         wgEMkvoL997lhw0xssuFvlnl+DdRmLxduSDNfAZ+bK8s27gzA+p16s5u5lu5RbaR1JVO
         9sjpF7Tj16QKJJMGR8JejxDhjtFBXyD04FZG4jd4n5cdKbvZnLvp/AlXU9AeApNEPvDG
         ZLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=des3FmaInciiDX/kbaTdrmt+UrXUSx/UL48o1MoSUCw=;
        b=sKsZL/wP/Et8zd6OXuBeH3vwWg5tN85HqQfXaSESdNAx6pUY1ON27g/atBIVDEDdrs
         UPsZXH+izBRVEAlrIMovD8/8eVyvVMvBWpcv2sg5gdHxlUa4H7LgQxB18eykfe0fR60P
         DEpI6ljBRaxBKkpD8xvhaP0HaxI6iNh3/4fuladCZySOPDIGU6GLDIre4LZKrhk5UxGz
         qryztLQY+7M2FPZdjV6mcv4knTlrNAaiEHKsk9AL40fWLcGggSLWTXaaxg1wxJ3yu5l6
         MgCLnlcuoXrU7TNt4mxJ/nIPWUaZ03BDECnwtr6LGv/UndR9VsIhRhruIKDfHtiWwy3P
         u0Lg==
X-Gm-Message-State: APjAAAXaHZgM4mqyg+T8E5lOtEc/vk7Jkan3A1vmiUl2VH+4YNEMkXGP
        ds/7NhGg27crJ8FU0/w3S0tfQeuwS7QOtCh21sg=
X-Google-Smtp-Source: APXvYqzjWn8TEGn9EE5XtRv3ypTFRh9wJOVVBhF9zpCW+d0Wzxqx4XRAEF8phlFcNLZjgobELXcdfXylWpqd2V7ryW4=
X-Received: by 2002:ac2:5399:: with SMTP id g25mr19561603lfh.178.1568107669389;
 Tue, 10 Sep 2019 02:27:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190908121125.608195329@linuxfoundation.org>
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Tue, 10 Sep 2019 11:27:38 +0200
Message-ID: <CA+res+ST4i0SHR78b7eyE5rUhS4vuwo6NzzsAyu27xeYtxeT6A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/57] 4.19.72-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        akpm@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        shuah@kernel.org, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2019=E5=B9=B49=E6=
=9C=889=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=8812:19=E5=86=99=E9=81=
=93=EF=BC=9A
>
> This is the start of the stable review cycle for the 4.19.72 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.72-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Merged, boot and tested on my testing machine, no regression found.

Thanks,
Jack Wang
