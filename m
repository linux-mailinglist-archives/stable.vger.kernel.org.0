Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EE14CDB5A
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 18:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241333AbiCDRx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 12:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241385AbiCDRx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 12:53:26 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44EA13DCE
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 09:52:32 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id 8so7180106qvf.2
        for <stable@vger.kernel.org>; Fri, 04 Mar 2022 09:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L/urtDFzZC4xatACRSLBQeFFMtch77UX/QBofNty68E=;
        b=InAdpYtCcQYLQ6Xz6GPHsNtREqcY9Tn1Ag476bBrN++oGr6ViSK2JH+JQsv/K+tREN
         P3kT8/KLmGgK0eH2tZ4FPhgz2ZQfKIH8w4r38vmdglzfOkZYuewcld2iD9ZnZD33N/JS
         uSjJBYFylDv0+IH0FKfC+3bOBhX6rKzu0szN8ykGOjsBG+myY8AxCysLtCp79J1eFRbz
         stmWD21I7Rf+VRzheF/OVPP337JHCorIxEyz1K4wOOUUPvSr/ZyzVsWDgyelrVMpkUA9
         6XddGAHHYHHlFjBgz1yRHu9u6VagfIODGYVjcTABqH5XUNxsLOtISqmm1Ynm2UQ/iytI
         Jzew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L/urtDFzZC4xatACRSLBQeFFMtch77UX/QBofNty68E=;
        b=DAKTZ20kX6B32CJt3kB0ATlSp5Y+QaJtz2XFc+Qn82zmu8JNAAdOedp6jt9Ijnzw2u
         gC/RNlKJkOYyE0Q42XJeDaAQNcoEKMlHjoUfMkHt+VBFJudkUjiPG6aGLXmaAvuf3Y9T
         AqXNpScIXpzPPuMJtIckmD4v3tS5f+w0Niuc9hSf15neg0eqW488KTYxBlyeuLLWOn+F
         BGrrUeXtLwyJh8NBe+Oua+BA1Vc526TWdRIdl+9GrW28dGPuVmeyKU36wh0QntBuRKgJ
         TE3zeq4DkKOqoJ6qWr3tRf+lGaCotv8brk5+g2KvvA5LtwhPQHdyM4ABbNxWRKBTa03Q
         dNZw==
X-Gm-Message-State: AOAM530Wssw7p3rNfzRP+oOYzW+wnRWPVsWRL6ibeyxNFppaQciyvadq
        xDymq/OofXlp/NTvUJ0IhaP0SA==
X-Google-Smtp-Source: ABdhPJwvgNhVty7iPiCbaA4nUhk47JCl9z+vlJ50QRjE2HTXfmmLaAxOv0FT2sYPaPUTGe0aE+AOBA==
X-Received: by 2002:ad4:5222:0:b0:432:deec:7219 with SMTP id r2-20020ad45222000000b00432deec7219mr23257604qvq.2.1646416351633;
        Fri, 04 Mar 2022 09:52:31 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id n1-20020a05622a11c100b002dff3364c6esm4018049qtk.19.2022.03.04.09.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 09:52:30 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nQC6P-004xNx-T2; Fri, 04 Mar 2022 13:52:29 -0400
Date:   Fri, 4 Mar 2022 13:52:29 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jarkko@kernel.org, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, David.Laight@ACULAB.COM,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>
Subject: Re: [PATCH v9 1/1] tpm: fix reference counting for struct tpm_chip
Message-ID: <20220304175229.GH6468@ziepe.ca>
References: <20220302094353.3465-1-LinoSanfilippo@gmx.de>
 <20220302094353.3465-2-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302094353.3465-2-LinoSanfilippo@gmx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 02, 2022 at 10:43:53AM +0100, Lino Sanfilippo wrote:
> From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> 
> The following sequence of operations results in a refcount warning:
> 
> 1. Open device /dev/tpmrm.
> 2. Remove module tpm_tis_spi.
> 3. Write a TPM command to the file descriptor opened at step 1.
> 
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 1161 at lib/refcount.c:25 kobject_get+0xa0/0xa4
> refcount_t: addition on 0; use-after-free.
> Modules linked in: tpm_tis_spi tpm_tis_core tpm mdio_bcm_unimac brcmfmac
> sha256_generic libsha256 sha256_arm hci_uart btbcm bluetooth cfg80211 vc4
> brcmutil ecdh_generic ecc snd_soc_core crc32_arm_ce libaes
> raspberrypi_hwmon ac97_bus snd_pcm_dmaengine bcm2711_thermal snd_pcm
> snd_timer genet snd phy_generic soundcore [last unloaded: spi_bcm2835]
> CPU: 3 PID: 1161 Comm: hold_open Not tainted 5.10.0ls-main-dirty #2
> Hardware name: BCM2711
> [<c0410c3c>] (unwind_backtrace) from [<c040b580>] (show_stack+0x10/0x14)
> [<c040b580>] (show_stack) from [<c1092174>] (dump_stack+0xc4/0xd8)
> [<c1092174>] (dump_stack) from [<c0445a30>] (__warn+0x104/0x108)
> [<c0445a30>] (__warn) from [<c0445aa8>] (warn_slowpath_fmt+0x74/0xb8)
> [<c0445aa8>] (warn_slowpath_fmt) from [<c08435d0>] (kobject_get+0xa0/0xa4)
> [<c08435d0>] (kobject_get) from [<bf0a715c>] (tpm_try_get_ops+0x14/0x54 [tpm])
> [<bf0a715c>] (tpm_try_get_ops [tpm]) from [<bf0a7d6c>] (tpm_common_write+0x38/0x60 [tpm])
> [<bf0a7d6c>] (tpm_common_write [tpm]) from [<c05a7ac0>] (vfs_write+0xc4/0x3c0)
> [<c05a7ac0>] (vfs_write) from [<c05a7ee4>] (ksys_write+0x58/0xcc)
> [<c05a7ee4>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
> Exception stack(0xc226bfa8 to 0xc226bff0)
> bfa0:                   00000000 000105b4 00000003 beafe664 00000014 00000000
> bfc0: 00000000 000105b4 000103f8 00000004 00000000 00000000 b6f9c000 beafe684
> bfe0: 0000006c beafe648 0001056c b6eb6944
> ---[ end trace d4b8409def9b8b1f ]---
> 
> The reason for this warning is the attempt to get the chip->dev reference
> in tpm_common_write() although the reference counter is already zero.
> 
> Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") the
> extra reference used to prevent a premature zero counter is never taken,
> because the required TPM_CHIP_FLAG_TPM2 flag is never set.
> 
> Fix this by moving the TPM 2 character device handling from
> tpm_chip_alloc() to tpm_add_char_device() which is called at a later point
> in time when the flag has been set in case of TPM2.
> 
> Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> already introduced function tpm_devs_release() to release the extra
> reference but did not implement the required put on chip->devs that results
> in the call of this function.
> 
> Fix this by putting chip->devs in tpm_chip_unregister().
> 
> Finally move the new implementation for the TPM 2 handling into a new
> function to avoid multiple checks for the TPM_CHIP_FLAG_TPM2 flag in the
> good case and error cases.
> 
> Cc: stable@vger.kernel.org
> Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
> Co-developed-by: Jason Gunthorpe <jgg@ziepe.ca>
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---
>  drivers/char/tpm/tpm-chip.c   | 46 +++++--------------------
>  drivers/char/tpm/tpm.h        |  2 ++
>  drivers/char/tpm/tpm2-space.c | 65 +++++++++++++++++++++++++++++++++++
>  3 files changed, 75 insertions(+), 38 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
