Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013AF65A2CB
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 06:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiLaFwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 00:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiLaFwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 00:52:07 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C5F13E8D;
        Fri, 30 Dec 2022 21:52:06 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id r11so20867036oie.13;
        Fri, 30 Dec 2022 21:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NVipoNjby+BOws8FLX/AuDw7QSwId0oY3eFy8ssadWI=;
        b=Eodyx5tiVTgtD0iNxx8DYyUGkHEntoWu1TG1qrjaBUm+kuFF6/s1zfxpkLRP55sGyH
         zeJjGoc50wi67Sp2edBB8Xhg9xIpZ5eEoFJonjGY+xKFFspl+/gpAtQRpo6i2J4xUr1y
         BeOlGKbCn6t4NkYEGcI/LiticrnM7TYHvUSax5K2vBL8CUs8LeeH1oD4SCeio5XRYiqX
         cFE2i0u7O1d2dH1PRfv2/bw8Jv5vPWD8Pb+XslWZtpFHQgghZ8pegJYbxvjJrXZPf+ke
         L9AkfbxYZWnn2fbd4rOvrstKGDEe4psvGw6CTyIAg39rszhNRyNvBHoMbHj6xyvCL4P4
         ulqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NVipoNjby+BOws8FLX/AuDw7QSwId0oY3eFy8ssadWI=;
        b=yfjd3vk4bJu9Y2TUGo/DPs7RBjmaY/ozbuy6fhkihOZn3i2t6/NJ6FSLJT9WPw2KpG
         qwJ6WaMLpVaA+B7oeKf3oUG8xuF5qtmGGjDA5ccap+GMGXV9PaBDQdikAANkXk7IgcId
         WsxjmeQSlfgcgGV3ZFt8xQfFkEGvLNnCL3ae4f8if+4tz8iziJ2jqpHfz+GnREaDoxMb
         39aI4U2PTkExkqhn9SAOZACJYjCqCjf8z7p4JwCpQtHo1XtG1l/7uzJVT92FPsa2/dUJ
         at54eaxi/4TPDAFfyBrp4+PEbafkhKX6nHqoLDybYne3PbMNzPz/g9OT7FcZVEPXQtZh
         O7Xg==
X-Gm-Message-State: AFqh2kpLyS6yOJ0jovnrbjpc04a2SrxI/yAT4hDBF5Q7hMUjcL0MZMJ4
        +BDVP4nYzGfajKb/LJ6NW64=
X-Google-Smtp-Source: AMrXdXtyY8bch1tU7KCYxUTZMycyXm3sZrdzNi/A9dT2d64rPBgLOwCeg3fUd5Ot7Wr6FfCcnQjRgw==
X-Received: by 2002:a05:6808:208e:b0:360:d179:97b4 with SMTP id s14-20020a056808208e00b00360d17997b4mr19372178oiw.35.1672465925515;
        Fri, 30 Dec 2022 21:52:05 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j9-20020a056808056900b0034d9042758fsm9883340oig.24.2022.12.30.21.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 21:52:04 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 30 Dec 2022 21:52:03 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Conor Dooley <conor@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Message-ID: <20221231055203.GA2926213@roeck-us.net>
References: <20221230094059.698032393@linuxfoundation.org>
 <Y699qYnUYUwFuQ/E@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y699qYnUYUwFuQ/E@spud>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 31, 2022 at 12:09:13AM +0000, Conor Dooley wrote:
> Hey Greg,
> 
> On Fri, Dec 30, 2022 at 10:49:23AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.0.16 release.
> > There are 1066 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> > Anything received after that time might be too late.
> 
> > Paulo Alcantara <pc@cjr.nz>
> >     cifs: improve symlink handling for smb2+
> 
> This patch here appears to fail allmodconfig + LLVM on RISC-V:
> ../fs/cifs/smb2inode.c:419:4: error: variable 'idata' is uninitialized when used here [-Werror,-Wuninitialized]
>                         idata->symlink_target = kstrdup(cfile->symlink_target, GFP_KERNEL);
>                         ^~~~~
> ../fs/cifs/smb2inode.c:76:35: note: initialize the variable 'idata' to silence this warning
>         struct cifs_open_info_data *idata;
>                                          ^
>                                           = NULL
> 1 error generated.

Fixed with upstream commit 69ccafdd35cdf ("cifs: fix uninitialised var in
smb2_compound_op()").

Guenter

> 
> It looks like this was reported as a smatch error on Christmas Day:
> https://lore.kernel.org/all/202212250020.fyWQFNzF-lkp@intel.com/
> 
> Given the day in question, missing that report seems pretty
> understandable :)
> 
> I tried to see if this had been reported already against the patches
> themselves, rather than Sasha's queue, but given the size of the patchset
> I may have missed it. Apologies for the noise if I have.
> 
> Thanks,
> Conor.
> 


