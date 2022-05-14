Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E15952700F
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 10:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiENIro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 04:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiENIrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 04:47:43 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C360CE15
        for <stable@vger.kernel.org>; Sat, 14 May 2022 01:47:43 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so9351048pjb.1
        for <stable@vger.kernel.org>; Sat, 14 May 2022 01:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lnnl5vrd67EIxJ6btJmIAuu36YL8gDYDg4uycveQU6c=;
        b=ELT7Ma1WrMXLYzQQRREBDXF2dFRxBxtKQNTqLTVdeUdRV54gXw1I+i7nEnpc1jL/E1
         y96SD6a48iJZR+ezBN3negTBrLkGEGkv93lXtaSfGlwtPcJnQ5AybnaYS0M+McLzre6T
         5dvdE4rQzw3d6CoBfHwohaIlloPC54/zrRYLXPDUabxP3p4CDw0cjiNzO6kozK7HOHqS
         jpIgoMc8Uirtm1R656cZi8TnZ/CQcrA0VWhi4t6VnK9HHYeRJbwaNhhJ9KkyAWHnHOzO
         2uBUbUoFOFrbzPxGpsDMi4SShkPH3pVVSblmX3kKGdudiyEbiznJSApYwCtnln9EJCIH
         RXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lnnl5vrd67EIxJ6btJmIAuu36YL8gDYDg4uycveQU6c=;
        b=hee5LkfHaXTdK5Qc9ZdR4RNNr337ZouzbrHbkdCX+eoN5J9iJMxPLHVNZKf9GK0nbn
         pym3Rqy9Qy+DEdY8G5QeHjPfYUz2u6LbBDmaeeKKLbPtQipKvFWvQV8JIvi6G1AeQBX1
         oQIaBfz35ZgdrSUeEx+mvnGuuP76CwyVEoiWaNl72KjfDju2sdQNtfiWUtkK9obObLVa
         l5uGHjtDRjdG/ly6x1VdVMoRKlY/d76oGHCFpdK73gsmTZwD3yjbc0PGuDISI/757Mua
         Oggk/yrFESmmFDIMg+CPyavoEJg2fVIF0okc+IMB83/JJXU4P36biY1fgVeBxSzHFT7M
         69Pg==
X-Gm-Message-State: AOAM530QdmYx0FybTfNOqhD8ZnTGEL3sygN6wPO7ZX0EX8DMdjoigHca
        YI3Kbol7mQdZuo01L4gEMOXNKcABGQg=
X-Google-Smtp-Source: ABdhPJx3LAWADtOvYoS30VdTQDXAfc5AjOMqwtw9rx2jmP98Dtablv9pZCsPketz6tWxDQX3HEzQmQ==
X-Received: by 2002:a17:903:32d0:b0:15e:8cbc:fd39 with SMTP id i16-20020a17090332d000b0015e8cbcfd39mr8769209plr.95.1652518062584;
        Sat, 14 May 2022 01:47:42 -0700 (PDT)
Received: from localhost (subs28-116-206-12-35.three.co.id. [116.206.12.35])
        by smtp.gmail.com with ESMTPSA id w11-20020a170902ca0b00b0015e8d4eb2e8sm3097583pld.306.2022.05.14.01.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 01:47:41 -0700 (PDT)
Date:   Sat, 14 May 2022 15:47:38 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Meena Shanmugam <meenashanmugam@google.com>
Cc:     gregkh@linuxfoundation.org, enrico.scholz@sigma-chemnitz.de,
        stable@vger.kernel.org, trond.myklebust@hammerspace.com,
        Dexter Rivera <riverade@google.com>
Subject: Re: [PATCH 0/4] Request to cherry-pick f00432063db1 to 5.10
Message-ID: <Yn9sqjJsnsLznmoq@debian.me>
References: <Yn82ZO/Ysxq0v/0/@kroah.com>
 <20220514053453.3277330-1-meenashanmugam@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220514053453.3277330-1-meenashanmugam@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 14, 2022 at 05:34:49AM +0000, Meena Shanmugam wrote:
> The commit f00432063db1a0db484e85193eccc6845435b80e upstream (SUNRPC:
> Ensure we flush any closed sockets before xs_xprt_free()) fixes
> CVE-2022-28893, hence good candidate for stable trees.
> The above commit depends on 3be232f(SUNRPC: Prevent immediate
> close+reconnect)  and  89f4249(SUNRPC: Don't call connect() more than
> once on a TCP socket). Commit 3be232f depends on commit
> e26d9972720e(SUNRPC: Clean up scheduling of autoclose).
> 
> Commits e26d9972720e, 3be232f, f00432063db1 apply cleanly on 5.10
> kernel. commit 89f4249 didn't apply cleanly. This patch series includes
> all the commits required for back porting f00432063db1.
> 

Hi Meena,

I can't speaking about the code (as I'm not subject-expert here), but I
would like to give you suggestions:

  - When sending backported patch series, always prefix the subject with
    "[PATCH x.y]", where x.y is the stable version the backport is made
    against.
  - Abbreviated commit hash should be at least 12 (or my favorite, 14) characters long.
  - Commit identifier should be in format "%h (\"%s\")".
  - As always, DON'T DO top-posting, DO interleaved reply and reply
    below the quoted original message.

Trond and Dexter, any comments or ACKs?

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
