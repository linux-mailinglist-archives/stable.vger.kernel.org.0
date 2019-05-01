Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D4C10378
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 02:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfEAAZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 20:25:05 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44966 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfEAAZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 20:25:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id z16so7605449pgv.11
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 17:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=wBeD3b909RdFy58d+At4l9FRNp3CkcTVG43WCw6PgfM=;
        b=UUni8NCNKRgcDZzt09yN4ZkOr5ERYa3/18JrLfu+88GoJq2NgUzSWFDuNo3aIITt5B
         7KFuK+CMHO34y/h5iL2aMmZtXpCYA0mD+NfxYTyILksuHQX6Ykv2lAwzVR7AZqTYqWWp
         jI0aMrTW8MlK+JseDslpMnsuiWE06HVnLD4SCPqLey3xPhGIo6o5CKF5CwyX8z029DGm
         hSa5klySuszuKwEvbbWmOfM2cuNb+dvbwKKjQ5dTdfPbfkFMJnJnGyj3pdn6sSaofMHd
         gDVyaVUfegBgzNhjFnAtt9hI9PQyc8tEo6xjLWeLXLeqKpzSIbFL4rzL58F3axMmnOFk
         UWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=wBeD3b909RdFy58d+At4l9FRNp3CkcTVG43WCw6PgfM=;
        b=TybFLpNYGT/YLeELSq81AYonmAehagbSR8HPE2AAfkMml7oLc45p26Xzc032+DTcRd
         U5r0dLKgdhj8GEjQCO2NQiXXHXPuAXnZn1l3I5XMGJCOvD0944ABPFdWK8vZkvjZOT/x
         /9oNTXLA5lpvksToCypWTohDx6l/hSGwh675GPSR+R9oZngjXldVFZpTAwIh2B3cp7F6
         U+aJfwaInxvLzmVkFP8H9Ml1sX+ofiWQdFyesw1iBzaUWV3dqWwlRunS9lFECXp5EmpV
         UJH7d2t/Fs1MfBYxfQphU68x6bbEk/N5YqWOhr64kGP2/taFZ3DgmuLMqD9XDEwdgYpy
         li4g==
X-Gm-Message-State: APjAAAWlMrTWWDczvaGoBW7CQvB1KIfCG1YCxOINvjT6+Z/ys6cPGTF0
        anPh3pKVJTEKFoq77w5d2fENsw==
X-Google-Smtp-Source: APXvYqyrq84qFMlrdBzc+89KzXCioB8oGv3uwDjU+AogH+K1vFy/FQY/zljc4Y4fjJgLjtya4EJv8Q==
X-Received: by 2002:aa7:8719:: with SMTP id b25mr35960225pfo.90.1556670304608;
        Tue, 30 Apr 2019 17:25:04 -0700 (PDT)
Received: from localhost ([12.206.222.5])
        by smtp.gmail.com with ESMTPSA id x128sm63049012pfx.103.2019.04.30.17.25.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Apr 2019 17:25:03 -0700 (PDT)
Date:   Tue, 30 Apr 2019 17:25:03 -0700 (PDT)
X-Google-Original-Date: Tue, 30 Apr 2019 17:24:03 PDT (-0700)
Subject:     Re: [PATCH] tty: Don't force RISCV SBI console as preferred console
In-Reply-To: <20190425133435.56065-1-anup.patel@wdc.com>
CC:     Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.com,
        aou@eecs.berkeley.edu, Atish Patra <Atish.Patra@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <Anup.Patel@wdc.com>, stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@sifive.com>
To:     Anup Patel <Anup.Patel@wdc.com>
Message-ID: <mhng-955c86e5-6dfb-4554-a435-49cfefad6185@palmer-si-x1e>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Apr 2019 06:35:06 PDT (-0700), Anup Patel wrote:
> The Linux kernel will auto-disables all boot consoles whenever it
> gets a preferred real console.
> 
> Currently on RISC-V systems, if we have a real console which is not
> RISCV SBI console then boot consoles (such as earlycon=sbi) are not
> auto-disabled when a real console (ttyS0 or ttySIF0) is available.
> This results in duplicate prints at boot-time after kernel starts
> using real console (i.e. ttyS0 or ttySIF0) if "earlycon=" kernel
> parameter was passed by bootloader.
> 
> The reason for above issue is that RISCV SBI console always adds
> itself as preferred console which is causing other real consoles
> to be not used as preferred console.
> 
> Ideally "console=" kernel parameter passed by bootloaders should
> be the one selecting a preferred real console.
> 
> This patch fixes above issue by not forcing RISCV SBI console as
> preferred console.
> 
> Fixes: afa6b1ccfad5 ("tty: New RISC-V SBI console driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
>  drivers/tty/hvc/hvc_riscv_sbi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/tty/hvc/hvc_riscv_sbi.c b/drivers/tty/hvc/hvc_riscv_sbi.c
> index 75155bde2b88..31f53fa77e4a 100644
> --- a/drivers/tty/hvc/hvc_riscv_sbi.c
> +++ b/drivers/tty/hvc/hvc_riscv_sbi.c
> @@ -53,7 +53,6 @@ device_initcall(hvc_sbi_init);
>  static int __init hvc_sbi_console_init(void)
>  {
>  	hvc_instantiate(0, 0, &hvc_sbi_ops);
> -	add_preferred_console("hvc", 0, NULL);
>  
>  	return 0;
>  }
> -- 
> 2.17.1
> 

I merged this.  Also, it looks like Exchange is doing something to your patches
that makes them a bit difficult to merge.  If you don't have a way of fixing
that, can you include a pointer to a git tree with a signed commit/tag?
