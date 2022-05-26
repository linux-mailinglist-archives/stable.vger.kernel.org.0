Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6697C5352DA
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 19:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbiEZRqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 13:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiEZRqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 13:46:48 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C029EB44;
        Thu, 26 May 2022 10:46:47 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id r68so2920395oie.12;
        Thu, 26 May 2022 10:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aVcKCtr30XetitU4IfTnUZdATlYXh/+qkc69zKkiy3k=;
        b=nyXEUVC7ggPUw7/rThyQn+vH0xzPgrrtHbmfwIRHoCBtlW3Gw0fYMESmoxAi/oEOlW
         qgt7heCVqLC4w5lPvA603X5kKccbgssdcRG8da8Flwf/BCNU/5NMfiQd9wTvSJ2mZpbv
         ivnEJ8nQicjFGDpxySVuXtlmTRt7VMv0wYxWSqzbnX7trKICDoXuCcMbr/6neFqPTBL6
         uvPLvyP/Z5P4cbD3XQLKXakshlA/VXYVzRF66cXQC/ILb257/ajgEVvz08JF0P0wVFYw
         4gFipGYpCwhIM3acm1QsVpa9fBjPudgcCiFfpfJpAOZnTogbajpTnCVlOcyHQ/iBHPWf
         k5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aVcKCtr30XetitU4IfTnUZdATlYXh/+qkc69zKkiy3k=;
        b=xPVIlpLk86KJpG+dvBMMUd4Nabl85939hadJ3knRyPgraks0yWatkLwhYegU55T5Sf
         BB004pQ4Kr9zQZO6EBss2uRwV/EnlPpZdQ97X1n4WJtbyi0RjlpMDLVhALn3rbLXBh1L
         L1vTZhoceHPOOS0dyjInz0omHNUcR6yYfEauEPPUf316MXztdYyODN/CG/sRmGOxQuES
         8CavaCbSXiq3p8UzD//xIXVw8VqLkqpW7lkTD3/+E9eMsNSz0+ydovnh+fp9fmkn6Prj
         1d6jLlaBiv1iVOdy0+gkGYNBJvlPTrr2j7hXcG7dVOJ0s5mtB6nuX3n1upgVdAbGFjrS
         0w8Q==
X-Gm-Message-State: AOAM530ZxpSM9DODFMjTOnp05qWkP2zaffgVLUT/Wu52zOvmFvEd9CEq
        QtWJSf8As7TIiKB9jqfdxYQ=
X-Google-Smtp-Source: ABdhPJwqrSRXwIbMQu0jQLPeFGvZ3cp7i4Nq5r6Qs5z2Zr5IZk+ubko/L8UBLGBpG2ER1S+nGULEtQ==
X-Received: by 2002:aca:280c:0:b0:32a:f677:798b with SMTP id 12-20020aca280c000000b0032af677798bmr1759617oix.48.1653587206840;
        Thu, 26 May 2022 10:46:46 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id dw5-20020a056870770500b000f291be9fa7sm880287oab.31.2022.05.26.10.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 10:46:45 -0700 (PDT)
Date:   Thu, 26 May 2022 10:47:20 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Patch for stable
Message-ID: <Yo+9KLc6VG8CKeH+@yury-laptop>
References: <Yo+t8QAgVTi2E6B4@yury-laptop>
 <Yo+vidb+a9Ctqyih@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo+vidb+a9Ctqyih@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Vitaly Kuznetsov <vkuznets@redhat.com>
+ Paolo Bonzini <pbonzini@redhat.com>

On Thu, May 26, 2022 at 06:49:13PM +0200, Greg Kroah-Hartman wrote:
> On Thu, May 26, 2022 at 09:42:25AM -0700, Yury Norov wrote:
> > Hi Greg,
> > 
> > Can you please consider taking the patch "KVM: x86: hyper-v: fix type
> > of valid_bank_mask" into stable?
> > 
> > Commit ea8c66fe8d8f4f93df941e52120a3512d7bf5128 upstream.
> 
> For what kernel tree(s) should thie be backported?

For me, Ubuntu LTS is important (4.15 and 5.4). I believe, Vitaly
and Paolo may know better for Red Hat, and in general.

Thanks,
Yury
