Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8516B28CD
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 16:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCIPZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 10:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjCIPZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 10:25:30 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92171FCC;
        Thu,  9 Mar 2023 07:25:01 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id p16so1409021wmq.5;
        Thu, 09 Mar 2023 07:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678375500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=29V03fvB3UU3ILRRCDLx0p+xrMkONX6jLzeWPsnHEJg=;
        b=gPCM1bppWBuMvjUvdsgYtIzU9jOlB9WotoqRUq4Pf/XFwofW0tosBWMFp/es7SjEEh
         Wa8PdOKBaGw8bdJzCKL/TUW0yRP0ZH6EBil9dgW0uggcSKFPZ4Z1RHVFf2bKFpjELdvU
         XgKD2ORkbrnXo8A55LWP9d6LNvL5KFc61nE+tb9yo2J7rlOM5PBaObuEVdOWRgcxNXH4
         dsM92K1mDFWYWu8MQrPTKM+gOTvPm5A1wyoWLkFsa/Ny3FXzaQSG3nsdLlWk89cjt+No
         pr542rZWF/ZRba3QixGKBnvzAlKqs/dpABubEVltjnM2eN7g45PX43OYwFe/aYqu51dS
         um1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678375500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=29V03fvB3UU3ILRRCDLx0p+xrMkONX6jLzeWPsnHEJg=;
        b=G5rKI8X5ZCceeWMaGV1TLWt782ZZukI9lRfA0nTL4eNP7K027UscvdevETuvPgLLPu
         TQdmcdhELzP47VwV4p9ZzJsZWVli9amihWrrYTOR0ND/s/qJohixaCR57AqxvMCWxRlj
         9Jw9u7s0YffiH2D483hWx1FlM2ONDm9LYy5ehQi9ycn1bMHJ/h9KwLxA+DNoxpnv25aJ
         7GHlM5bPaVAB4UhAcvUEF4bF7XuP5nSjeVpPbOVuZC7w848e9mvmgBcvCMoT2WAo0R7A
         u4U1ev2NRfWg2v2HaThMCeHwNlGOyFzIEPYMfaXrvP/6iSIkMjvhDL0Usa2AaYo3FTYR
         2/BA==
X-Gm-Message-State: AO0yUKVrRlIoSt5sHljlXVaR2v9zikAdBiQ+u1hi8LRvkpdQXNHCiVQb
        YCnJnSNPAv6WEw/pMBqtNWfZ1uKyBlgpLBbC9DMMwHzPekMA6A==
X-Google-Smtp-Source: AK7set8bM2z4l7nqYTMmJ2SziZ2vFggDgMcbbRq2+BRlQoOdQrVIH7txE5VtjFw43fUecwY372LFFHhZGDnPbE49eNA=
X-Received: by 2002:a7b:c2a2:0:b0:3eb:5a1e:d524 with SMTP id
 c2-20020a7bc2a2000000b003eb5a1ed524mr5068235wmk.3.1678375499996; Thu, 09 Mar
 2023 07:24:59 -0800 (PST)
MIME-Version: 1.0
References: <CACH9xG8-tEtWstUVmD9eZFEEAqx-E8Gs14wDL+=uNtBK=-KJvQ@mail.gmail.com>
 <ZAmv57xeNqs7v9hY@kroah.com> <CACH9xG9=BFszD9OXspttTFdki0e68b5Hw7o11AUQ7pptSMy9wQ@mail.gmail.com>
 <ZAmzT/D8YxJ3844j@kroah.com>
In-Reply-To: <ZAmzT/D8YxJ3844j@kroah.com>
From:   Sylvain Menu <sylvain.menu@gmail.com>
Date:   Thu, 9 Mar 2023 16:24:48 +0100
Message-ID: <CACH9xG_v_2Y9d3Q16YB57Q5xVwSXe5FqLFSnjox6GotOT3DPmw@mail.gmail.com>
Subject: Re: nfs mount disappears due to inode revalidate failure
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        chuck.lever@oracle.com, jlayton@kernel.org,
        linux-nfs@vger.kernel.org
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

No I don't have that, I found the bug in production by no chance.
I tried to dive into the code but it quickly becomes complex for me,
at least it's easy to reproduce with a little script (while(1) timeout
my_c.code)

thanks
sylvain menu

Le jeu. 9 mars 2023 =C3=A0 11:22, Greg KH <gregkh@linuxfoundation.org> a =
=C3=A9crit :
>
> On Thu, Mar 09, 2023 at 11:17:30AM +0100, Sylvain Menu wrote:
> > I think it's a regression according to the old resolved bugs/tickets
> > but no idea since when it's broken again
>
> Any chance you can do 'git bisect' to find where it broke and what
> commit broke it?
>
> thanks,
>
> greg k-h
