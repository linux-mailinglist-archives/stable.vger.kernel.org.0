Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC5329FAB8
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 02:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgJ3Btf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 21:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgJ3Bte (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 21:49:34 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF81C0613D2
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 18:49:33 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id g7so5134620ilr.12
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 18:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QOGBGZXS5bceVC+NjRYBtAxKU4B3mv4H3jVxrGPSN/g=;
        b=LK2Grv4vChKqCJRJ1Kod0+cee9jh4ylwn0U+n9c4DCm/Me8+h1GClDcBYasatJGQny
         pp710a2sn0q6cLfn22RgM87XIaQaPFaCmuG8mcu+KlOn1U70Dg89F+LX0KbS18n3KGcT
         8NDODfb3HbE/c/i3EreKxEG84Dd7NefhK+UW4cujh5Rt3dG9V0eIZYis2Zetievz1jRu
         awaiGvs6E/l0jZkSALOkI7Ri3oxwKE5YPz/CxEAG98r/G4IBVRMONhPfqwraJFtbNIFv
         J9lUpjohFi6AadRsL501S6VeEwQzbM4J5akNdmPskVoV3I4qZim+Qs+wv84BkIm1xXeu
         UDAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QOGBGZXS5bceVC+NjRYBtAxKU4B3mv4H3jVxrGPSN/g=;
        b=rK9bu2Ca2E/SD+vHpAvGIC2zwT0qnoB+veZ+/0IhSt6xm+h+92SfyuxSsihjAt0/L7
         wTk3al8lmwxzrDRboKmuz5swf5BBWe9QRD/939+bC6gznDYJLvW6uaSSPuHXI3QPp3uy
         d+1T4VlztyLM6mE28zxjrOnMTaUxkZRGS0y9/dWD0Urv9/F7lPc1KsTGeAhwnehmidMd
         QLRtN5GF5rIBKyKPJPVLm/kp9kE3iO7YjlSbTmVtEde8WKRAIBtZR2cs/WLLgBAEJt1T
         MJs0ygKbSXeR1AuK37EcjV5T5z7CbRDGe5ezQjAYj7i76UHeHa9Qullz06aC/c8CaJrT
         tX6g==
X-Gm-Message-State: AOAM533b9wL6W/EiSSXM1s3gxsR7Nh/xgQI1uGnOdwAFGdd7BQ5fHUw+
        SDecmKx1JQbWfS8DxP8uP8g=
X-Google-Smtp-Source: ABdhPJwWywAbQ8wA38n3wsKNhAwzY6lrJJXcDD0M5b2OQYfeQ6DNbgRBYbRCaicUZJxXd8CVcUOHZA==
X-Received: by 2002:a92:8e51:: with SMTP id k17mr235521ilh.270.1604022572586;
        Thu, 29 Oct 2020 18:49:32 -0700 (PDT)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id v88sm3997811ila.71.2020.10.29.18.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 18:49:31 -0700 (PDT)
Date:   Thu, 29 Oct 2020 18:49:30 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Jian Cai <jiancai@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Backport 44623b2818f4a442726639572f44fd9b6d0ef68c to kernel 5.4
Message-ID: <20201030014930.GB2519055@ubuntu-m3-large-x86>
References: <CA+SOCLLXnxcf=bTazCT1amY7B4_37HTEXL2OwHowVGCb8SLSQQ@mail.gmail.com>
 <20201029110153.GA3840801@kroah.com>
 <CAKwvOdkQ5M+ujYZgg7T80W-uNgsn_mmv8R+-15HJjPoPDpES1Q@mail.gmail.com>
 <20201029233635.GF87646@sasha-vm>
 <CAKwvOd=MLOKH-JoaiQcahz3bxXiCoH_hkfw2Q_Wu7514vP3zkg@mail.gmail.com>
 <20201030004124.GG87646@sasha-vm>
 <CA+SOCLJqVjy9QRssE9AZ1nQBwZB5mAcanpVTVOd4kO3=r5jrfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+SOCLJqVjy9QRssE9AZ1nQBwZB5mAcanpVTVOd4kO3=r5jrfA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jian,

On Thu, Oct 29, 2020 at 06:13:07PM -0700, 'Jian Cai' via Clang Built Linux wrote:
> Thanks @Nick Desaulniers <ndesaulniers@google.com>  and @Sasha Levin
> <sashal@kernel.org> for the tips. For this particular change, it seems we
> do not need to backport all the dependencies (if they have not been merged
> into 5.4 stable). @Greg KH <gregkh@linuxfoundation.org>, please find the
> custom backport as below. It has passed all the tests on ChromeOS (
> http://crrev.com/c/2504570).
> 
> Thanks,
> Jian

The below patch won't apply because it appears to be copy pasted into
this message:

Applying: Backport 44623b2818f4a442726639572f44fd9b6d0ef68c to kernel 5.4
error: git diff header lacks filename information when removing 1 leading pathname component (line 6)
Patch failed at 0001 Backport 44623b2818f4a442726639572f44fd9b6d0ef68c to kernel 5.4
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

I would recommend resending the patch with git send-email or attaching
the patch file created by 'git format-patch -1' to a future email for
proper application.

> From 60891062750a39d8bba9710d500e381a26c11f75 Mon Sep 17 00:00:00 2001
> From: Jian Cai <jiancai@google.com>
> Date: Thu, 29 Oct 2020 17:49:39 -0700

Authorship and date should be fixed to retain the information of the
original commit.

It is trivial to just redo the cherry-pick to fix that information in
this instance but this is the command I usually run for more non-trivial
backports that I have already done:

$ git commit -s --amend -C <sha> --date "$(git show -s --format=%ai <sha>)"

This should allow you to retain the commit message of the original
message along with the author's date.

> Subject: [PATCH] crypto: x86/crc32c - fix building with clang ias
> 
> commit 44623b2818f4a442726639572f44fd9b6d0ef68c upstream
> 
> The clang integrated assembler complains about movzxw:
> 
> arch/x86/crypto/crc32c-pcl-intel-asm_64.S:173:2: error: invalid instruction
> mnemonic 'movzxw'
> 
> It seems that movzwq is the mnemonic that it expects instead,
> and this is what objdump prints when disassembling the file.
> 
> NOTE: this is a custom backport as the surrounding code has been
> changed upstream.

A note of this nature is traditionally placed after the signoffs of the
original patch like my example below:

> Fixes: 6a8ce1ef3940 ("crypto: crc32c - Optimize CRC32C calculation with
> PCLMULQDQ instruction")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[jc: Backport to 5.4]
> Signed-off-by: Jian Cai <caij2003@gmail.com>

I usually like to notate why the patch did not apply cleanly so that it
is easier for others to audit, such as:

[jc: Fixed conflicts due to lack of 34fdce6981b969]

That is merely a suggestion, not required by any means.

Otherwise, the backport seems obvious fine to me.

Cheers,
Nathan

> ---
>  arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> index d9b734d0c8cc..3c6e01520a97 100644
> --- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> +++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> @@ -170,7 +170,7 @@ continue_block:
> 
>   ## branch into array
>   lea jump_table(%rip), bufp
> - movzxw  (bufp, %rax, 2), len
> + movzwq  (bufp, %rax, 2), len
>   lea crc_array(%rip), bufp
>   lea     (bufp, len, 1), bufp
>   JMP_NOSPEC bufp
> -- 
> 2.29.1.341.ge80a0c044ae-goog
