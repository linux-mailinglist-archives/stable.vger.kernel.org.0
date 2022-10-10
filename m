Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2F35FA15C
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 17:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJJPre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 11:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJJPrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 11:47:33 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4991A81B;
        Mon, 10 Oct 2022 08:47:32 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id k3so13418189ybk.9;
        Mon, 10 Oct 2022 08:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eu4IBPjpIx1vClTLfAm1E4pd4IoQo322CRDW2fzHhzA=;
        b=E9/9NdpVrpY3KWSQHMy/rZkLuemem6gf5q5Iw9OK8MhuDAxYpgWUlq3HOHFN4wrYox
         uhgHNetDJz1dWcV0KYf9chh5SSIvJj0QSOOWf6GRO66RyKi0Uat1HijAvQDENThChKwF
         iwavqVJPzkyPMNi/W3FbWTe9YoljykP3PncaS1Cx2IVRrlxBvvFS0F2zAeY4L427pUyh
         Oyxhv0brNQ42Dgqt2D+neQiGv+HCc99JcDlIjlbNwckLQlJVNQr9WDhvhsell5/elCM5
         uF614dWKfcVyLUD75ogLYz94ieDeI4Dvsq778HruEqjicgHBXcJdms6N2Q26ovWfDwT5
         CcKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eu4IBPjpIx1vClTLfAm1E4pd4IoQo322CRDW2fzHhzA=;
        b=VyRJgTVLJG4ZEqt/CBDZ1ewhhLcj+/Yb//FPRm8u5xNTI9pTond6ZvWuiDh4zkid01
         GEVL/P4eb8JS2b4pVbSkTBhTQZ5ICVvzpCLxR35W47macrI0SSvu55KF2+0PGBuKzv12
         vVbuvi5NmmGxhi2qnCBagPTK70j0Cqr4slgId7TO2Af4b1q5TDkw7EZexJW+d6bmuoIb
         wJdyXwN4ciYjh5I6w/lMt6pwOhakPJx9L/ow96iCgZ7FIKsD2HVT7lw28Uzuxq8OJS3v
         Yul64sfv475cZxpYTVURfGrqTpYj2+A464sgEgACLttcjsZJwxWLkB+Q3fkMfL6q7qYY
         hIXg==
X-Gm-Message-State: ACrzQf2d2+5rVNpy3CJX8GcZY/MEoMoxdP7cvxw308vL6P/q+cNzYcyi
        FzhUEB09RRk8IuwoUj4SQ1+83uwITdFJKGtfmrQ=
X-Google-Smtp-Source: AMsMyM7X9AAskWQ01oYoESm5t6Hd6QLUMPauY+rCd0SMQD/Sfp+EiLNKrs9uwDEjMQ4KxYu6EJ3/3DFFQqGzanUcAlo=
X-Received: by 2002:a25:37c3:0:b0:6be:693a:6031 with SMTP id
 e186-20020a2537c3000000b006be693a6031mr19516623yba.511.1665416851784; Mon, 10
 Oct 2022 08:47:31 -0700 (PDT)
MIME-Version: 1.0
References: <Yyn7MoSmV43Gxog4@kroah.com> <20220925103529.13716-1-yongw.pur@gmail.com>
 <YzmwKxYVDSWsaPCU@kroah.com> <CAOH5QeB2EqpqQd6fw-P199w8K8-3QNv_t-u_Wn1BLnfaSscmCg@mail.gmail.com>
 <Y0BWuJHsK6XDk2nx@kroah.com>
In-Reply-To: <Y0BWuJHsK6XDk2nx@kroah.com>
From:   yong w <yongw.pur@gmail.com>
Date:   Mon, 10 Oct 2022 23:47:30 +0800
Message-ID: <CAOH5QeAX0NzO2mXqBbMRYGMzNMTAq4H1r9r_AFWC2Fj=MNWwiw@mail.gmail.com>
Subject: Re: [PATCH v2 stable-4.19 0/3] page_alloc: consider highatomic
 reserve in watermark fast backports to 4.19
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2022=E5=B9=B410=E6=9C=888=E6=
=97=A5=E5=91=A8=E5=85=AD 00:40=E5=86=99=E9=81=93=EF=BC=9A
>
> A: http://en.wikipedia.org/wiki/Top_post
> Q: Were do I find info about this thing called top-posting?
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
> A: No.
> Q: Should I include quotations after my reply?
>
> http://daringfireball.net/2007/07/on_top
>
>
> On Fri, Oct 07, 2022 at 04:53:50PM +0800, yong w wrote:
> > Is it ok to add my signed-off-by? my signed-off-by is as follows:
> >
> >   Signed-off-by: wangyong <wang.yong12@zte.com.cn>
>
> For obvious reasons, I can not take that from a random gmail account
> (nor should ZTE want me to do that.)
>
> Please fix up your email systems and do this properly and send the
> series again.
>
> thanks,
>
> greg k-h

Sorry, our mail system cannot send external mail for some reason.
And this is my email, I can receive an email and reply to it.

thanks.
