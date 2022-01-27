Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E506849DD1C
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 09:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbiA0I6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 03:58:38 -0500
Received: from condef-02.nifty.com ([202.248.20.67]:21080 "EHLO
        condef-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiA0I6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 03:58:37 -0500
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2022 03:58:37 EST
Received: from conssluserg-05.nifty.com ([10.126.8.84])by condef-02.nifty.com with ESMTP id 20R8mA5D028597
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 17:48:10 +0900
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id 20R8liMw028664
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 17:47:44 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com 20R8liMw028664
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1643273264;
        bh=02HJ2YWh7IcTlvUfrypE1+pIxcQAnudHLV25ldGonnc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vZcgHt2eamUDyIuoQIlTWVg0MgSuVSazbbVKd28NsNbukAuX9phN8wbumpORx0L2X
         WPHngPyuGafLa6EzWlG7ym3xW9+Gdj7+yDf4aHy3e2pIeHloO5i0AL4sp+OjjlYkVN
         AelAP1hp8oR7AmKC9eVFJWuE6fLTIgeCRz976IDIkzGBNiUb8QwA2m+5bSS8dbU5Fh
         zFlRJ5jwxFZN0+t/TacKwmDQkFISVe+eWXQk1Kovrb5nX9Lpg5P+RKP7ZUUNLGlCz5
         ybuThE1vAGPKpASDxKPmy0TjuE0qDrLhE5R/qNbM6CZjDHSaqjv79pB+VZee+o+NVj
         iP5PgkfapLgWA==
X-Nifty-SrcIP: [209.85.216.49]
Received: by mail-pj1-f49.google.com with SMTP id r59so2243883pjg.4
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 00:47:44 -0800 (PST)
X-Gm-Message-State: AOAM532XzoRTd7VtvtnfC8S/YcIqAzpvO9x1EwKFj+MQiY+OY1HdrE6i
        r9KsVmPHAzVpGHtPmshRvW1WZWjQX00nhD2S8qw=
X-Google-Smtp-Source: ABdhPJz6Q+POV6S2SHwcsZILi4SvbUE9ddUtwDfUeZymIpaQxCvDr8YP95yyw5T5qj9LTj+eY41hLbVsmKqrjVldIBs=
X-Received: by 2002:a17:90b:1d01:: with SMTP id on1mr2271324pjb.77.1643273263620;
 Thu, 27 Jan 2022 00:47:43 -0800 (PST)
MIME-Version: 1.0
References: <164326987844214@kroah.com>
In-Reply-To: <164326987844214@kroah.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 27 Jan 2022 17:47:06 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQAJpu+_x-uy2+7gTGpeshnmGJv6OGDnSxB79DyVMgLSw@mail.gmail.com>
Message-ID: <CAK7LNAQAJpu+_x-uy2+7gTGpeshnmGJv6OGDnSxB79DyVMgLSw@mail.gmail.com>
Subject: Re: patch "kbuild: remove include/linux/cyclades.h from header file
 check" added to tty-linus
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kbuild test robot <lkp@intel.com>, macro@embecosm.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 4:51 PM <gregkh@linuxfoundation.org> wrote:
>
>
> This is a note to let you know that I've just added the patch titled
>
>     kbuild: remove include/linux/cyclades.h from header file check
>
> to my tty git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> in the tty-linus branch.
>
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
>
> The patch will hopefully also be merged in Linus's tree for the
> next -rc kernel release.
>
> If you have any questions about this process, please let me know.
>
>
> From d1ad2721b1eb05d54e81393a7ebc332d4a35c68f Mon Sep 17 00:00:00 2001
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date: Thu, 27 Jan 2022 08:33:04 +0100
> Subject: kbuild: remove include/linux/cyclades.h from header file check
>
> The file now rightfully throws up a big warning that it should never be
> included, so remove it from the header_check test.
>
> Fixes: f23653fe6447 ("tty: Partially revert the removal of the Cyclades public API")
> Cc: stable <stable@vger.kernel.org>
> Cc: Masahiro Yamada <masahiroy@kernel.org>


Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>



> Cc: "Maciej W. Rozycki" <macro@embecosm.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/r/20220127073304.42399-1-gregkh@linuxfoundation.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  usr/include/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/usr/include/Makefile b/usr/include/Makefile
> index 7be7468c177b..83822c33e9e7 100644
> --- a/usr/include/Makefile
> +++ b/usr/include/Makefile
> @@ -28,6 +28,7 @@ no-header-test += linux/am437x-vpfe.h
>  no-header-test += linux/android/binder.h
>  no-header-test += linux/android/binderfs.h
>  no-header-test += linux/coda.h
> +no-header-test += linux/cyclades.h
>  no-header-test += linux/errqueue.h
>  no-header-test += linux/fsmap.h
>  no-header-test += linux/hdlc/ioctl.h
> --
> 2.35.0
>
>


-- 
Best Regards
Masahiro Yamada
