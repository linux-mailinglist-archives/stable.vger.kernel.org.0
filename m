Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDBE64D4C9
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 01:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLOApd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 19:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLOApc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 19:45:32 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2EA52887
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 16:45:30 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id q6so13211817lfm.10
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 16:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uYBxsTIDfxCwdcVy0SlVo7L6KklaT8RI7tWL5R76GxA=;
        b=FNLgUFaF9svpbbtMTs3OU9It8D//Y6M14TiwnPoIEkWX7dTcvDln6mrg1q4xzKckYU
         uOEv/8cAWTAAdzNS413nOsRXkWqP008Am6MthTq/7a72YsakjbAuGyXAMJxwnDcvLMUN
         n2UXnHeP2wb+bg33ULDTODUVixLzO912rAdfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uYBxsTIDfxCwdcVy0SlVo7L6KklaT8RI7tWL5R76GxA=;
        b=a9aKeW0uu3kiXO901uXI6dMv3mGBdA5anD1+q19iu94rJP3AqcyKc59AwYP45+eUkh
         x/ylHMhxCb8MtRbr/3tZZ5XMiq/OWZZNZwGT+JAVsyXvlORKE+BzDv9Ik/eqVGnsWZSr
         pxrt40JGQUbtulfS4EfIwYVfzJ4UlWTaV/xiHuiV9A7Lm4I91uTKtbiajAN6VvhIa/1C
         z1+Pk/696qR8/5PNyalpXgFp8GIKIiVZuA06dzOLBx4IvbnPFJjHVJN701nh+TiKCnSG
         PM8yo2UfQ/04Nw1QEoL8yOgU/ZCXp3f8s61hxQZEiJtlqNMunogV4zMUFe9qhYhMp00b
         BYLQ==
X-Gm-Message-State: ANoB5pnEIh2VAByoET01juDUp0Eiw2sGEB3dmpJY7QnPDS/vUGSnsnuL
        pyVx3w+nstqo/CiL3NmzQ0ha+h3MOI+sQYBPeaUqIg==
X-Google-Smtp-Source: AA0mqf4IrWNorDC3Tt/0G9y03c+7uT35Mc6/ZAXwiyOMdQM1IQZ/tj12Krg1jK6LMBSjXQCkCZeCPwck+/ln3oNKC2Y=
X-Received: by 2002:a05:6512:224c:b0:4b5:ad89:8174 with SMTP id
 i12-20020a056512224c00b004b5ad898174mr2000564lfu.84.1671065129157; Wed, 14
 Dec 2022 16:45:29 -0800 (PST)
MIME-Version: 1.0
References: <CAEXW_YR=DvPhk5JWUe7gYHeVsn5d4Wba83x2UB9uqP0EURgk1g@mail.gmail.com>
 <Y5nzjauYRdn7T6T+@kroah.com>
In-Reply-To: <Y5nzjauYRdn7T6T+@kroah.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Wed, 14 Dec 2022 19:45:17 -0500
Message-ID: <CAEXW_YQbqY7Q9zQifQSsR+Fws5Wyu=n0OxMGvuwY4HpNXe0xDQ@mail.gmail.com>
Subject: Re: Please apply to v5.10 stable: 29368e093921 ("x86/smpboot: Move
 rcu_cpu_starting() earlier")
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 14, 2022 at 11:02 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Dec 13, 2022 at 12:17:20PM -0500, Joel Fernandes wrote:
> > Hello,
> >
> > Please apply to the stable v5.10 kernel, the commit: 29368e093921
> > ("x86/smpboot:  Move rcu_cpu_starting() earlier").
> >
> > It made it into the mainline in 5.11.  I am able to reproduce the
> > following splat without it on v5.10 stable, which is identical to the
> > one that the commit fixed:
>
> Now queued up, thanks.

Thanks, Greg! I confirmed with overnight testing that the patch fixes the splat.

 - Joel
