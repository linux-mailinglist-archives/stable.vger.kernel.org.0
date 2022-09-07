Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778665B006A
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 11:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiIGJ1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 05:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiIGJ1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 05:27:47 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE304804BC;
        Wed,  7 Sep 2022 02:27:46 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id h1so8385333wmd.3;
        Wed, 07 Sep 2022 02:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=6Ts1BS8tFxCuu1ej7FEcJ5LErgGfs4nztrlqbvHtrK4=;
        b=WkBFG//0G7q7v+b4wI+Ua+3+m+tLo1lmiVTRAjuWQzC4psFm8d7GTHcymwfNEVh4AX
         ST0MP6UFohfVCDgOsRzea3YfNsUASfNmBmdEsDCz9+Ye/H9d8auQfJfcxg4ZQkMaFqDD
         xTW5rQo0utdrYS/qVa8H3T/91B04+ZrHYAaPzc4h54GX2v4SOpNa4YgH0tbNBA5bdAAn
         HGRQ6LCn6onj8S87cLtVatjJ0NKv6Ni0LsJNQRqtRKlyQbmljVdAFkuzopXULQKPCNeN
         +lau6EiaN2QnReJfl8EB7eALJkHM1U/3prrj3yjfLqbDZbLjWlSeXoYpUVJ7k/5uAImq
         gn7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=6Ts1BS8tFxCuu1ej7FEcJ5LErgGfs4nztrlqbvHtrK4=;
        b=Lg8qQYlwh48Itbdr3ZqXXiHJ2wQznI0At/NHQ2kqQhyrmZv1ecVb8TINtpOoiHhIq7
         JQ2uru+UhVUnbuFDYH96QYdvzMlyTDP9AwLDTnJ43+bW5XJ0hMDaiViLDVjMBo2WHMOv
         kt3e71llTtBn92P7FosPvj0TGNPJn/+ipk7iDscu/bDLg7MRV+bl982F70Bw9zGBGq+r
         rFfh0IssW8MMLe22Du6y94xangmg16zhNiaeCcOri33Ur5mPB/uxrgKrvJvq5TyfynOB
         XLpINDpA5+0AXJrutGPGjVU+opN1p5HoPj5QtpzEobIhJQqkATcxJENy66Z9/XPofVoc
         rJ5A==
X-Gm-Message-State: ACgBeo3cm6gGFkB9QfSI7a95+Mnbwb+qpDAkpHpWhQ4S/iTKpA96HCAO
        xr+D+rKv6gG0EW13GEk5rlc=
X-Google-Smtp-Source: AA6agR7KaLP2JO4IQvv2fs9PknIbdSC0AfKeTUNPgsTltphxS/mtMBpHAuGsDb1mIQ9DxzZNmotZgQ==
X-Received: by 2002:a7b:cc85:0:b0:3a5:50b2:f9be with SMTP id p5-20020a7bcc85000000b003a550b2f9bemr1410406wma.18.1662542865066;
        Wed, 07 Sep 2022 02:27:45 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id d17-20020a05600c34d100b003b27f644488sm953550wmq.29.2022.09.07.02.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 02:27:44 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:27:42 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/107] 5.15.66-rc1 review
Message-ID: <YxhkDs18QIxmc/qa@debian>
References: <20220906132821.713989422@linuxfoundation.org>
 <CADVatmMTbnOm1bHWdbxVZ26QfbjyhhB+_ZRBMM53GicJczE5=Q@mail.gmail.com>
 <Yxgw6SrPaF43s/pw@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxgw6SrPaF43s/pw@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Wed, Sep 07, 2022 at 07:49:29AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 06, 2022 at 09:46:37PM +0100, Sudip Mukherjee wrote:
> > Hi Greg,
> > 
> > On Tue, Sep 6, 2022 at 2:37 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.66 release.
> > > There are 107 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> > > Anything received after that time might be too late.
> > 
> > My test pipelines are still running, but x86_64 allmodconfig failed
> > with gcc-12 with the error:
> > 
> > drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c: In function
> > 'ipc_protocol_dl_td_process':
> > drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c:406:13: error: the
> > comparison will always evaluate as 'true' for the address of 'cb' will
> > never be NULL [-Werror=address]
> >   406 |         if (!IPC_CB(skb)) {
> >       |             ^
> > In file included from drivers/net/wwan/iosm/iosm_ipc_imem.h:9,
> >                  from drivers/net/wwan/iosm/iosm_ipc_protocol.h:9,
> >                  from drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c:6:
> > ./include/linux/skbuff.h:794:33: note: 'cb' declared here
> >   794 |         char                    cb[48] __aligned(8);
> > 
> > It will need dbbc7d04c549 ("net: wwan: iosm: remove pointless null check").
> 
> Thanks, I have not been testing any branches with gcc12 just yet because
> of these issues :(

All the other arch I build are now ok with gcc-12, except x86_64.
I will make a complete list for x86_64 today and send you.

--
Regards
Sudip
