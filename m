Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB7DDC1F9
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 11:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437930AbfJRJ7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 05:59:48 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43141 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403993AbfJRJ7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 05:59:47 -0400
Received: by mail-lf1-f68.google.com with SMTP id u3so4217841lfl.10;
        Fri, 18 Oct 2019 02:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bJg3jNvpJRg4akHGQqt+uAxmdK3BMBn9DV8iWt0S550=;
        b=Vznit7oF/obElt9maFemMAeuAj5grRJqiqIpqmgRZb1ZmgEZ5eJcZqNM3MFq5J1NSB
         bpwiF/ZzBNcqOvVPkKAdzEF1VQg/44+6r/Bs+8o/5bO9UXSDFaiBOcHPzsNC9ffhhGMx
         3aP1WmWWiVfY8UdHDMOLZRewCeyteAQHBQfebYJWzg8xWZz3Vp7nSIsF9yAII/quqi3k
         ZteSi/i6W2TH1Yao22WtdO3+LywMtfZaDnOeaQ4Vadj/RUQvFtB+QZpYhM9fywPeqfde
         KzQ9ozwPM/WNeMAfwliNoFaEQ0Is1eaiXvlbMHiH80pJ0E4PL3O4A7WAjjnh8HO8WoKj
         JYqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bJg3jNvpJRg4akHGQqt+uAxmdK3BMBn9DV8iWt0S550=;
        b=uQi4WCmYb9/gLJDtw83bLX6M2bwbQa5dOw9GZQBS8zgc2i2IFk0ZLg19S+RXAwjus7
         rpnHi+EJvJ4fCUqomqlmdAvKxxjI+jmsFEXP815UD3VbdNgtLfNbSzL09NyFd3KHBi7f
         k6v7Yy48RlLIUgcbdGeHJSTVPfPhWcnwcdftfd5rV7XmnKlkfby6ZlTvXO5P22vYzSP0
         dVQMP9wIiBNPX0YEJRWiZ0J4jLVU6Tl7L6bX51qmQC7l2V+NQv+9uk+poTXV3esT5SFv
         0fgkuTjyU4LbTBLmBtITvXa9wVo7QKmZly/RqOEZdK8gTrjgzlLQIRLgOsPcOLhVnJMx
         b8KQ==
X-Gm-Message-State: APjAAAU5CsuK+nss1oCR+q7ojpFEARisPpgFuEEn5yQJq/s5UCeHaxY/
        jSQsPHGfZbAZ/MZiFyQxutejgXCn3kgbp3nl4d45jA==
X-Google-Smtp-Source: APXvYqyt3OggiJPe5bTykOqvw5SeeUdFiRpOV7TqkG54H/OyX9D/ahuALvs02FlIs5Rcr1TBG/Ey3F8o9haumr2oSrM=
X-Received: by 2002:a19:7b08:: with SMTP id w8mr5374981lfc.95.1571392785565;
 Fri, 18 Oct 2019 02:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <20191016214756.457746573@linuxfoundation.org>
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
From:   Jinpu Wang <jinpuwang@gmail.com>
Date:   Fri, 18 Oct 2019 11:59:34 +0200
Message-ID: <CAD9gYJLpYYzbDb83aRZXugPiAQpa6Cbu0xzTJ7JuLGZEWx5aUQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/65] 4.14.150-stable review
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

Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2019=E5=B9=B410=E6=
=9C=8817=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=8811:56=E5=86=99=E9=81=
=93=EF=BC=9A
>
> This is the start of the stable review cycle for the 4.14.150 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.150-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Merged and tested on my test machines, no regression!

Thanks,
Jack Wang
