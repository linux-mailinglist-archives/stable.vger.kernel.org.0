Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774B337906
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 18:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbfFFQAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 12:00:47 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45529 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729145AbfFFQAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 12:00:47 -0400
Received: by mail-ed1-f68.google.com with SMTP id f20so4041132edt.12;
        Thu, 06 Jun 2019 09:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZYp/2XuxF4NBBIxpEf3TefxcM6zkxnjlEsipp8Zq6pU=;
        b=RXu89w+r5huBrCw1onIkFIQGk8BkHVfEL92HtWU3BuaaT4tlAzQZ93TKtQzwlWhne/
         HIRqiE7r2VrTRig5TS2dxVMqD2jevzMQM5ZkrSr4qXVHRfk3TZ/QzghCPR+TX79jpCc+
         0cKjbqBfi41xtJc9yVYvzMHfV19rP21PFRfvj4YRIz7Vke/W8VC9szsgwVFQwkdCWlkY
         PVyi4E+B8w4jnl4msENwMOr57+a+Ha/56Hz+hkoVyisIDXZS8/R0Ht332pLwJHlx+A6W
         sfHMzEUJXoKU0Ej/nsieaxqCB3NXTNzVgMHkhqIzHOCFq9Zxz/rpB0Mmj57oMDa4byD6
         ih6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZYp/2XuxF4NBBIxpEf3TefxcM6zkxnjlEsipp8Zq6pU=;
        b=nm6jJF5m+woRL22or5B5IZBTnei2qkZ7kimcPrZWBFa2xlR2mwOvvMqBw4Vetd2upY
         D5iGgyoqEHMu+VK+ecZfZ57b+ahyj/9Y6Z511nMWwlTxpfFWzuhI9ukuogjyw1DxbiiJ
         DoW50kPdDcnLZl2ve7ETwAiRTCxWkWFycvrGk0D3+xo99rzRNBGEUeXL2zV83OHSSpGc
         bxGWLZkNJJK5BEklSNYOZLHAGpQkRIM4wByfV9B9RmlG0ArvYJil9xbrpTDpSdn0ueQK
         pzN0gadl7aiSiUt6M8HiIw2nmlEp5c6p/vAJJlNqyxM2yV9XIEykFmyPELKxgZNeLbqO
         wONQ==
X-Gm-Message-State: APjAAAXGFLdKfiwyy56p1aaaDn2sDfaDjecKIdAM07JIHHit9TI5UNpo
        ryl+RVrXg9UlCBmMtUkDrN4=
X-Google-Smtp-Source: APXvYqyGjFZNckxSIQ9W/M1DI1XQKNOrsDYlOwVhjaJRjvHd2sY/W888gdKVWefz+3dl28ETjWVXjg==
X-Received: by 2002:a50:e1c9:: with SMTP id m9mr33418888edl.71.1559836845424;
        Thu, 06 Jun 2019 09:00:45 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id y21sm392280ejm.60.2019.06.06.09.00.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 09:00:44 -0700 (PDT)
Date:   Thu, 6 Jun 2019 09:00:42 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 237/276] scsi: lpfc: avoid uninitialized variable
 warning
Message-ID: <20190606160042.GA54183@archlinux-epyc>
References: <20190530030523.133519668@linuxfoundation.org>
 <20190530030539.944220603@linuxfoundation.org>
 <20190606125323.GC27432@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606125323.GC27432@amd>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 02:53:23PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit faf5a744f4f8d76e7c03912b5cd381ac8045f6ec ]
> > 
> > clang -Wuninitialized incorrectly sees a variable being used without
> > initialization:
> > 
> > drivers/scsi/lpfc/lpfc_nvme.c:2102:37: error: variable 'localport' is uninitialized when used here
> >       [-Werror,-Wuninitialized]
> >                 lport = (struct lpfc_nvme_lport *)localport->private;
> >                                                   ^~~~~~~~~
> > drivers/scsi/lpfc/lpfc_nvme.c:2059:38: note: initialize the variable 'localport' to silence this warning
> >         struct nvme_fc_local_port *localport;
> >                                             ^
> >                                              = NULL
> > 1 error generated.
> > 
> > This is clearly in dead code, as the condition leading up to it is always
> > false when CONFIG_NVME_FC is disabled, and the variable is always
> > initialized when nvme_fc_register_localport() got called successfully.
> > 
> > Change the preprocessor conditional to the equivalent C construct, which
> > makes the code more readable and gets rid of the warning.
> 
> Unfortunately, this missed "else" branch where the code was freeing
> the memory with kfree(cstat)... so this introduces a memory leak.
> 
> Best regards,
> 									Pavel

For the record, this is not a problem with the upstream commit (not
saying you thought that or not, I just want to be clear).

Looks like commit 4c47efc140fa ("scsi: lpfc: Move SCSI and NVME Stats to
hardware queue structures") "resolved" this by not making it an issue in
the first place. I think the simpler fix is this.

Thanks for pointing it out!

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 099f70798fdd..645ffb5332b4 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2477,14 +2477,14 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
        lpfc_nvme_template.max_sgl_segments = phba->cfg_nvme_seg_cnt + 1;
        lpfc_nvme_template.max_hw_queues = phba->cfg_nvme_io_channel;
 
+       if (!IS_ENABLED(CONFIG_NVME_FC))
+               return ret;
+
        cstat = kmalloc((sizeof(struct lpfc_nvme_ctrl_stat) *
                        phba->cfg_nvme_io_channel), GFP_KERNEL);
        if (!cstat)
                return -ENOMEM;
 
-       if (!IS_ENABLED(CONFIG_NVME_FC))
-               return ret;
-
        /* localport is allocated from the stack, but the registration
         * call allocates heap memory as well as the private area.
         */

