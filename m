Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9957F79043
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 18:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfG2QER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 12:04:17 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55524 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbfG2QER (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 12:04:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so54370596wmj.5;
        Mon, 29 Jul 2019 09:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZxCoxZNZqZ7BaNpp6YlaSGJX4F8d+cKr8ODCDAIBeo0=;
        b=so0RkHbQmktB6qvbzDiBKriLe/K5ptlYiSmQLEWl1HuGaXc5eKAH3MVFtwhZ3awKrZ
         blQZvJemfCUieBHxA0+RMJ0DcC9Aj5ClGQU2JDDQFl+b1iyHt1pxWfUD0EgInZgiwX17
         cNR99Ep+c2x/jHPQmsiCV+MjZY/dSNEFqAAdnwS+1IqeSu2HaHxyRFTrYnI9cbB0XDJD
         0Za/nyl2w1iJN3qQPuQZXqHL1/7cOtvfgjJWyJBLksgkHEur7WbXQDx5kp+4a8ViBHam
         9B0YBxc5+nRTMUslC2e2RJr0VedelGAChxO1iyzKp3DYnfLHbdu2LxE2eFUSwaj8VFzV
         khFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZxCoxZNZqZ7BaNpp6YlaSGJX4F8d+cKr8ODCDAIBeo0=;
        b=CB1kgX5ytURUi6S+ptZ9FPubVVvM4L/uysId5Oj8pnz56LSNA34Yh+PJt9XiSjIpRP
         g48rDB3NjDBkzuQ1KY087zvj+GR+IMCsa8hpgrkL8+sWosBl8lYPPcttdzUm3KsUBH1Y
         tTDB6tjOlneJWKsxC6L2dc6JIhBo9tUsE3foCK1Z+l9QBbOJvsP8xyRMGoH6qTWbi+cY
         U+SKRoil/PaSIFArNm1HxFe/CvtcmTgy4yUOUm1WEetLWP4URz3JtHpNTdRbmRQcrLPg
         8PPEVNBxgfrthTOlucIxknr5OVrv3//DZjzft957ebBQFWB4A3UcrY6bCA6L1jif0fz+
         hqnQ==
X-Gm-Message-State: APjAAAXbdThRHI5BbLUg5Au2updcSEsaZ9PefCd5WXiVZ/8dMna0NRRI
        fliueQOhebKs+rc3vxB+3Q8=
X-Google-Smtp-Source: APXvYqzGLKYdNwB2KW7FyW6D9ipox2XB2mdajXe63NXSkTQIYI4BlIbqGc0hBM3uIt5TS50fgN4EgA==
X-Received: by 2002:a7b:c144:: with SMTP id z4mr104465393wmi.50.1564416255100;
        Mon, 29 Jul 2019 09:04:15 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id a81sm63363187wmh.3.2019.07.29.09.04.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:04:14 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:04:12 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     linux-kbuild@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Michal Marek <michal.lkml@markovi.net>,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: initialize CLANG_FLAGS correctly in the top
 Makefile
Message-ID: <20190729160412.GA100132@archlinux-threadripper>
References: <20190729091517.5334-1-yamada.masahiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729091517.5334-1-yamada.masahiro@socionext.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 06:15:17PM +0900, Masahiro Yamada wrote:
> CLANG_FLAGS is initialized by the following line:
> 
>   CLANG_FLAGS     := --target=$(notdir $(CROSS_COMPILE:%-=%))
> 
> ..., which is run only when CROSS_COMPILE is set.
> 
> Some build targets (bindeb-pkg etc.) recurse to the top Makefile.
> 
> When you build the kernel with Clang but without CROSS_COMPILE,
> the same compiler flags such as -no-integrated-as are accumulated
> into CLANG_FLAGS.
> 
> If you run 'make CC=clang' and then 'make CC=clang bindeb-pkg',
> Kbuild will recompile everything needlessly due to the build command
> change.
> 
> Fix this by correctly initializing CLANG_FLAGS.
> 
> Fixes: 238bcbc4e07f ("kbuild: consolidate Clang compiler flags")
> Cc: <stable@vger.kernel.org> # v4.20+
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
