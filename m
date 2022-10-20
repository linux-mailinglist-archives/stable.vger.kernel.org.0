Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3110C605859
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 09:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJTHWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 03:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJTHWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 03:22:51 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B1A152C73
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 00:22:49 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bv10so32791299wrb.4
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 00:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=31NMl+IcJgQJgzYKHWa3EzUTYhFj4VbgIOVXkrZALUg=;
        b=W2SslhIWWKDeDYKCMQDtAOFt0XJWFeRpxaQTidiLrAbKb0mc2kxig9eURSoLRD4Wm2
         QgvnqS+19bGIhxJNtLAeW41rBZKhSTFBFRKZFTvXNXcgkUwfVhwKNojxyrdqDqQRAJBh
         A/dK1XRMTRDBugASI5//uGUGJbv/99aqZOvutDjeVrqnAKLvzgd8iNMXckOYhuga0vAA
         HWO03VuOp8JtdwSVTwgneyi5it4zEh6NHD8iw+8fnd2/lSPV+tsaGqO+FT/Qltx2B1gT
         mISd+YXmF6+iaT+FibyjVg5m0IkxiZTyHdYuZv2UTUc//GJsIsgl7CUqQPCgR+/Buxw9
         aZpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31NMl+IcJgQJgzYKHWa3EzUTYhFj4VbgIOVXkrZALUg=;
        b=l+beVcEAuZizc8xmmG3wy6gQZDLaDfqGN7t/rkyq7IkyyWNAp+z/iLByNkzqtoCHcC
         xAtnk0dtsFWfxoEUIiMZh5RFbgnX1GMkpv1XIYsMoy0Xt++sbAbLXWIwUpmX31ZFiyVP
         FU+5NbJEnbM6opZYMMNPzQ1wO6bHsAIp8mS19yeFNWPguLxNMKhy9eIcH03IHOP2uhmV
         8dl7lEasBNpBmU2k3KFmTaW5j80z+8Ckdj4VS70Iz24FByN1zLgDotw+kFIR6EhnvDry
         Jz/JzNCAaQ46VT9E1YBDp6/ccFL9LzrMEROGWfcg7k4vhKsf0cTyAJk1I/AwiezDHbC8
         cg9A==
X-Gm-Message-State: ACrzQf2dhAv5OYMcSyyuqiahvyEvp7vtwpu6Po9/bhKQfpjr5Vev5smL
        5scWFg7RsQuPdMyac9XPsbI86K246ww=
X-Google-Smtp-Source: AMsMyM4nUEmN122uAcHxmhOL9g6kCdwku59ckJwNODfabdGPUl6EibsUQ2snniPLWRwllPSBZEJh8Q==
X-Received: by 2002:adf:ed01:0:b0:230:d7c8:9a91 with SMTP id a1-20020adfed01000000b00230d7c89a91mr7726993wro.511.1666250567326;
        Thu, 20 Oct 2022 00:22:47 -0700 (PDT)
Received: from krava ([83.240.63.167])
        by smtp.gmail.com with ESMTPSA id o16-20020a056000011000b0022e38c93195sm15247743wrx.34.2022.10.20.00.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 00:22:46 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 20 Oct 2022 09:22:45 +0200
To:     Greg KH <greg@kroah.com>
Cc:     Slade Watkins <srw@sladewatkins.net>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org,
        kbuild-all@lists.01.org
Subject: Re: [PATCH stable 5.10 5/5] kbuild: Add skip_encoding_btf_enum64
 option to pahole
Message-ID: <Y1D3RTnJXuVaVplU@krava>
References: <20221019085604.1017583-6-jolsa@kernel.org>
 <Y1Cgp/TOmE8scCvJ@b995051e45c0>
 <CA+pv=HPV0iG0NDe6K=7hBa1sVh-cWZZ8XZTVCrHZPDq7A1Z_2g@mail.gmail.com>
 <Y1DYPbYZ39vMnh/I@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1DYPbYZ39vMnh/I@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 20, 2022 at 07:10:21AM +0200, Greg KH wrote:
> On Wed, Oct 19, 2022 at 09:35:23PM -0400, Slade Watkins wrote:
> > On Wed, Oct 19, 2022 at 9:14 PM kernel test robot <lkp@intel.com> wrote:
> > >
> > > Hi,
> > >
> > > Thanks for your patch.
> > >
> > > FYI: kernel test robot notices the stable kernel rule is not satisfied.

the patch 5/5 does not have equivalent commit in linus tree,
so I wonder the warning is because of that

jirka

> > >
> > > Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
> > > Subject: [PATCH stable 5.10 5/5] kbuild: Add skip_encoding_btf_enum64 option to pahole
> > > Link: https://lore.kernel.org/stable/20221019085604.1017583-6-jolsa%40kernel.org
> > 
> > Uh, this should be fine though, right? The stable list was the primary
> > recipient and all show up for me in my stable folder.
> 
> Yes, this is fine, this bot is not that smart at times.
