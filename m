Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7878FB73
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 08:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfHPGxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 02:53:20 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35930 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHPGxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 02:53:20 -0400
Received: by mail-lf1-f67.google.com with SMTP id j17so3371700lfp.3;
        Thu, 15 Aug 2019 23:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zT4JOIGsXpFVUAhQEf+itDDg4yp68LDeV7+PEewSdfA=;
        b=rJMxQY+SL6oPvQ+KYJMb++iMR5yzHM0RKoiQocqO0oO2WktqZDKdL5K6A42X2bjUIh
         tU466qTbraR1n/EM1zDa34cIkNEU1hx9ioFjjg84jFbqoOeVyFl7yJS6S15IyN4xXFLe
         5PHqQXk01NKI+q8RcrtBUX6ViRvT+7ILXkqG5swa7qOHW7rW99B0sVfCsSAQ9WApJI8X
         alHf9BFgxeCjVXdI+LSs1+NE8onS/lX3NDxh5FB2AakS2BcNVTUWTNnsWJEPDfYPUrVM
         oaZF5sTushiml5Ib5fm2YOQo+q8x6bnYxqjcLgyRN67VyRBUmRfzhXY2IrRi2p0gDCfx
         6czg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zT4JOIGsXpFVUAhQEf+itDDg4yp68LDeV7+PEewSdfA=;
        b=ZI4Uj3rrrg4OnER0ROJMtsgSgUV+A18lI/VXQ1up8lF0FNYNscyLNKs4nQPyOMufI2
         IO9I41zRjzpc9T2BU4QnvBkC5Xoj/SFAsMGMoQ7EOtyHcHcHwtNWUImxrkdlBDshEFsK
         Xzwurx7Z0AOrUeHwUsxwy0u879/UZeN9g7Q9vJdyYDFkhpaNNZR+nLn1FCKBP5u2yrCp
         RW9jp7w//4USndAfsEYGiPpBEXEPvaFUE3i1BJrhxBwFMuuICs08fzfI1sRSqOreL99+
         LDYMoIwUf5+7FeE2ry6YO1rkkVAt07t1KMqFKtCCwSld7eC5pO/XM8yrdJf9ciJi9v/K
         kw3Q==
X-Gm-Message-State: APjAAAX/BjooymjJnsqBRBl62RhauLGeJtT67DGmPUOItInJH3N2ILqx
        8cFGQz19JlkLzlQ+UTthcKyNACyXpRwUGu5WUGGrpg==
X-Google-Smtp-Source: APXvYqz/Y6LD/RPYfGCUfQ1tX77wFIf2tKOskpUPv3WkAX9brFBOdvL4MJwTrOpyzk8wfbjp8HO4jsMeKDGIuh70njA=
X-Received: by 2002:a19:5503:: with SMTP id n3mr4329911lfe.168.1565938398289;
 Thu, 15 Aug 2019 23:53:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190814165748.991235624@linuxfoundation.org>
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
From:   Jinpu Wang <jinpuwang@gmail.com>
Date:   Fri, 16 Aug 2019 08:53:07 +0200
Message-ID: <CAD9gYJLZpBfS3tt8EYNTd9CkfN=dsi3e54gWOABOpib_3kqvJw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/91] 4.19.67-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        "v3.14+, only the raid10 part" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2019=E5=B9=B48=E6=
=9C=8814=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=887:10=E5=86=99=E9=81=
=93=EF=BC=9A
>
> This is the start of the stable review cycle for the 4.19.67 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.67-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Merged and tested on my x86_64 machines, no regression, all works fine.

Regards,
Jack Wang
