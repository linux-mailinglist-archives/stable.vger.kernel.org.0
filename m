Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDF251E535
	for <lists+stable@lfdr.de>; Sat,  7 May 2022 09:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242942AbiEGH2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 May 2022 03:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238791AbiEGH2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 May 2022 03:28:03 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A73A625D
        for <stable@vger.kernel.org>; Sat,  7 May 2022 00:24:17 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id p10so15912857lfa.12
        for <stable@vger.kernel.org>; Sat, 07 May 2022 00:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hcsdovZexsweBQgXsrS9TmegcFHPxrc5+tTSlWIXW4Y=;
        b=l/fxotlu5k8y0NETltlduGCQIozeJi+RgobEFAhUnVRFsaccPs4uYF3GvZSCvl56kq
         1m+xy+M9SazSkkF8skT4IPk8c9nuH5rOP4xxkLFK9uLnnZ0UFmM8mgly+/RYH6VhCYje
         gW5a7DF2SrcVeiS4p6gC691W0TA6R2IbPu8WuIOT3aEGWqQjEWZwLlEcIiw6kQqJNqUU
         zAdJ4I2bOLpr3GbPZRPvwufFpeQiB7Vu65VbNiQnxfdpS73JgF/U+HGUDOyHoK9x5qaT
         WohksDh9yIxEkp6P3oUu47Tkd0llstCjBpGtSno+9YA9jOwLH83tOWFPbU+pzi3q03yU
         5xzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hcsdovZexsweBQgXsrS9TmegcFHPxrc5+tTSlWIXW4Y=;
        b=y26sPmwZOwCuA4/KTyA8z/bUkQaDSNqWyC4TPnWFm2hNrAFNhSUSKbCtHNmlJKMIDJ
         H5HxFMzcShg6k/+6IXVdtl0uwE97M+Yhdbp59ebG9KvBoYVVX+QMMfJugFBvehRTdZPc
         H61dzdTNZO5oPdhETezT5lv1E8G3yKHWhDbllR3D1TM6ZE5aMICj9dK03qbkxG2yUnMP
         gqokqqAkaUbnxAVBPrq2njft8bG/7pZDVg1ItipksqVPzEwm6kBEM8nTBEwvGC4yrexy
         u45JEQmHWhnQf5AOOrHvC1Gj3vdyzq96hIyAZcexoDMEHEyj2Mmoeo9cA1T2BXTz3e1w
         f8jg==
X-Gm-Message-State: AOAM530nnhm7mnA1+OXNI8LGcuo7RjLidKLUfQQ7Nt4e/kilds3mR6iH
        hLnwlu2IretPpRCd6vr3efPUIqjZheqfLu0LYBU71mVAxyzbFw==
X-Google-Smtp-Source: ABdhPJz6+xDt7eq8J2NirLHsFV8X8y2K7quQAYCBjFarVGWhV9jMhGY7xyxgZcfFcrPdm+xSFKDJMHccRB2act/RTqY=
X-Received: by 2002:a05:6512:3b93:b0:474:188b:1c99 with SMTP id
 g19-20020a0565123b9300b00474188b1c99mr128808lfv.549.1651908255592; Sat, 07
 May 2022 00:24:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220504153110.096069935@linuxfoundation.org>
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Sat, 7 May 2022 12:54:04 +0530
Message-ID: <CAHokDB=AfYE_NmKg_AF6-B6yEaJg3=QdTB=0WNXz85ZXfqdQDA@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/225] 5.17.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     skhan@linuxfoundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regression found

Tested-by: Fenil Jain<fkjainco@gmail.com>
