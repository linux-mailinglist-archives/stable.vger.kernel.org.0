Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D6118F8AB
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 16:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCWPec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 11:34:32 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46456 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbgCWPec (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 11:34:32 -0400
Received: by mail-ot1-f68.google.com with SMTP id 111so13731301oth.13
        for <stable@vger.kernel.org>; Mon, 23 Mar 2020 08:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hCgk1VTrdcJFXDGUWgmBQZD99HOeWAFwHVgfNENEsv8=;
        b=YP3zkuR27bPxYHrFwL8NFkWPQ9xaXmN6WEiMeaKArdS+NqtFrvZMe4ooc4LQecou9J
         weiQD4DK1OUJ43WfphyBDA1Jk0yOj4AO1dRIiWiQ6Zl7Nq/zeopKNnwx4482W36LqkDH
         gwrTamfth7IPiMGRsSO0zXmVIjQWGEP1tVyNPzw2qZZhA4pDM9E0D1N2jQpdJwhthd0c
         ptbQM+vfQxcsKgsKdr4RRI4TWSkVLVV8fk+UBc8oRuVInBqBSim1EuvhzDu6BwFD0Y8v
         EuHYGyow5jGi1L13WTREQxyFCmmy4iVhtxizHMv8zX5eoo6BPwUrpf+NRuLQ1mxIW0Gg
         ahsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hCgk1VTrdcJFXDGUWgmBQZD99HOeWAFwHVgfNENEsv8=;
        b=UsqETQJF6dBXlGmv0p8vU+wpy688K5VmPPd+4nP6qHOSUimKYPVlglufK1keBkEXeP
         cI2dguVuwwS7DxrAwWBXJoAuvFTlFski+Xs4oEl8yvFcQfK2ih5PaY8vBjhu63i1s4Ep
         G0iI2x4ws4jqV9bPoyZ9onZ1AXRevHQeSGaC9h3O2innCxplBO7aBNyNzyPirbMdVUWc
         shc7vGanz0eI1d12RcnDqUQNUEjt+uie+t4Z/iS6a5D7nlrS+PRwYEFCUVaZGkKFwY+V
         BKxTYimLKiy9TKMVVHkh1m8NWPA7ht2FHJ4cJBnJWlSabKilARy9G9snhtXEvxcZfooj
         ohEA==
X-Gm-Message-State: ANhLgQ25+hbg4Zx6TuHDY598oKNUn9l8sp2wbQAM0PfKHiW02z1UEp0s
        w8RUIz00XIXznO+q2MkEa+SFiTxs
X-Google-Smtp-Source: ADFU+vuFUHwoibCJjlf5qDn9XMglWwJbNlVv3yF0COWOSqQV9cjD1VbyU08SQYN2a0l6QxJdDOcNSA==
X-Received: by 2002:a9d:60b:: with SMTP id 11mr18193167otn.126.1584977670579;
        Mon, 23 Mar 2020 08:34:30 -0700 (PDT)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id t19sm5266407oih.52.2020.03.23.08.34.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 08:34:29 -0700 (PDT)
Date:   Mon, 23 Mar 2020 08:34:27 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     masahiroy@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kbuild: Disable -Wpointer-to-enum-cast"
 failed to apply to 4.19-stable tree
Message-ID: <20200323153427.GA40380@ubuntu-m2-xlarge-x86>
References: <15849737281461@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <15849737281461@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 23, 2020 at 03:28:48PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 82f2bc2fcc0160d6f82dd1ac64518ae0a4dd183f Mon Sep 17 00:00:00 2001
> From: Nathan Chancellor <natechancellor@gmail.com>
> Date: Wed, 11 Mar 2020 12:41:21 -0700
> Subject: [PATCH] kbuild: Disable -Wpointer-to-enum-cast
> 
> Clang's -Wpointer-to-int-cast deviates from GCC in that it warns when
> casting to enums. The kernel does this in certain places, such as device
> tree matches to set the version of the device being used, which allows
> the kernel to avoid using a gigantic union.
> 
> https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L428
> https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L402
> https://elixir.bootlin.com/linux/v5.5.8/source/include/linux/mod_devicetable.h#L264
> 
> To avoid a ton of false positive warnings, disable this particular part
> of the warning, which has been split off into a separate diagnostic so
> that the entire warning does not need to be turned off for clang. It
> will be visible under W=1 in case people want to go about fixing these
> easily and enabling the warning treewide.
> 
> Cc: stable@vger.kernel.org
> Link: https://github.com/ClangBuiltLinux/linux/issues/887
> Link: https://github.com/llvm/llvm-project/commit/2a41b31fcdfcb67ab7038fc2ffb606fd50b83a84
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> 
> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> index ecddf83ac142..ca08f2fe7c34 100644
> --- a/scripts/Makefile.extrawarn
> +++ b/scripts/Makefile.extrawarn
> @@ -48,6 +48,7 @@ KBUILD_CFLAGS += -Wno-initializer-overrides
>  KBUILD_CFLAGS += -Wno-format
>  KBUILD_CFLAGS += -Wno-sign-compare
>  KBUILD_CFLAGS += -Wno-format-zero-length
> +KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
>  endif
>  
>  endif
> 

Attached is a backport that should work for 4.4 through 4.19.

Cheers,
Nathan

--M9NhX3UHpAaciwkO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-kbuild-Disable-Wpointer-to-enum-cast.patch"

From 03368599bf131e92c660d884c84a648f387c89ae Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <natechancellor@gmail.com>
Date: Wed, 11 Mar 2020 12:41:21 -0700
Subject: [PATCH] kbuild: Disable -Wpointer-to-enum-cast

commit 82f2bc2fcc0160d6f82dd1ac64518ae0a4dd183f upstream.

Clang's -Wpointer-to-int-cast deviates from GCC in that it warns when
casting to enums. The kernel does this in certain places, such as device
tree matches to set the version of the device being used, which allows
the kernel to avoid using a gigantic union.

https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L428
https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L402
https://elixir.bootlin.com/linux/v5.5.8/source/include/linux/mod_devicetable.h#L264

To avoid a ton of false positive warnings, disable this particular part
of the warning, which has been split off into a separate diagnostic so
that the entire warning does not need to be turned off for clang. It
will be visible under W=1 in case people want to go about fixing these
easily and enabling the warning treewide.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/887
Link: https://github.com/llvm/llvm-project/commit/2a41b31fcdfcb67ab7038fc2ffb606fd50b83a84
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---
 scripts/Makefile.extrawarn | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 8d5357053f86..486e135d3e30 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -72,5 +72,6 @@ KBUILD_CFLAGS += $(call cc-disable-warning, format)
 KBUILD_CFLAGS += $(call cc-disable-warning, sign-compare)
 KBUILD_CFLAGS += $(call cc-disable-warning, format-zero-length)
 KBUILD_CFLAGS += $(call cc-disable-warning, uninitialized)
+KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 endif
 endif
-- 
2.26.0


--M9NhX3UHpAaciwkO--
