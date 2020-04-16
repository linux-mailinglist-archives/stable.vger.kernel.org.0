Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A211AC18B
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 14:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635961AbgDPMme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 08:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2635944AbgDPMmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 08:42:32 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E12C061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 05:42:29 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id 1so2264023vsl.9
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 05:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jypZEZLJjM6Wf5VhI4pXonjOuC91lUAPMY7kLHdN2K8=;
        b=SijtgXMrfnLN+APN4uMHMtBFYOEckSxMt4QFsx+OpPoX6FdYJkJQ7e9ZhaHimkgS9V
         V04kYbyjGnNxZURY1+O7ebW2ytgBBapeu+d64XVepyOe/Zb5KZa/JyduQPrt8OwcFFgW
         /Sx4LpQB48EH76r+PesWkSeDCatWoZ5AEprdoEPtUnz7nU2WXC7AuCdodHRl99CYhpbV
         xBTVqUZUvCWWeiLH/o4N8DeyqB8AqG5r63eQUuDFlvgSTFmHgRmLcMPvGGhvsMg+7h53
         oX4pQrt/eo56dos+0CsRUMB7Ctnf5XSapOwVDApMr8gkWPK3lhjk74M8S84GNvQRBANe
         7vpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jypZEZLJjM6Wf5VhI4pXonjOuC91lUAPMY7kLHdN2K8=;
        b=uikv7zdadqIyMY8FT6dDgIREvKoshkm1Nri+CfMidMBcuT7dL4JA2HqQepBNyQPxEA
         MUVCX4CVM2yx5+4r2hs1jQWxzC+6wADCSrwLkUBCGbQ2CTM8bNkMsWepDtX095T484C4
         7N540g6rKU74EWnHKKTSOytEtldXZQbFMTAb83cP6vqeSLvpZ9BJrZoD+lyzV6bLvtQY
         O/UU/e5/tG/XZqDY47EDmJ7GKmHTuHy2TQa3U8DkFAMLhBGGYwCH/m2UYq7Dz6JTrWwN
         gQ6d0kCnp89MK+tJ8bgdj3CyLBe+POortN093emY/Te8kd6geTxsn43uo6GKqhAuFbVk
         36RA==
X-Gm-Message-State: AGi0PuZ5rHNXHQ116jM2R5DFJR1jMc/pYEBEXtaVvgY/VJL+OjwX5EaU
        C/6Orh0Sga8/EaYk7MrAK3/ISvzd1QWNRCn5olctDQ==
X-Google-Smtp-Source: APiQypKZOHofJUt1c8AAhMKmzLT0sXxcMswAourzrwU7cnP0qfBGLvNJyepQCMg8vrc9h02kPlJtc0WUqg8BxzNlvbo=
X-Received: by 2002:a67:f804:: with SMTP id l4mr9047639vso.136.1587040948350;
 Thu, 16 Apr 2020 05:42:28 -0700 (PDT)
MIME-Version: 1.0
References: <1586948847250254@kroah.com> <20200416013743.GS1068@sasha-vm>
In-Reply-To: <20200416013743.GS1068@sasha-vm>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 16 Apr 2020 15:42:18 +0300
Message-ID: <CAOtvUMe9MpNC3z=+ZAxZYNn_aejstMJwSRMCgYHuOwYkqRXAtg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] crypto: ccree - dec auth tag size from
 cryptlen map" failed to apply to 4.19-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 16, 2020 at 4:37 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Wed, Apr 15, 2020 at 01:07:27PM +0200, gregkh@linuxfoundation.org wrot=
e:
> >
> >The patch below does not apply to the 4.19-stable tree.
> >If someone wants it applied there, or to any other stable or longterm
> >tree, then please email the backport, including the original git commit
> >id to <stable@vger.kernel.org>.
> >
> >thanks,
> >
> >greg k-h
> >
> >------------------ original commit in Linus's tree ------------------
> >
> >From 8962c6d2c2b8ca51b0f188109015b15fc5f4da44 Mon Sep 17 00:00:00 2001
> >From: Gilad Ben-Yossef <gilad@benyossef.com>
> >Date: Sun, 2 Feb 2020 18:19:14 +0200
> >Subject: [PATCH] crypto: ccree - dec auth tag size from cryptlen map
> >
> >Remove the auth tag size from cryptlen before mapping the destination
> >in out-of-place AEAD decryption thus resolving a crash with
> >extended testmgr tests.
> >
> >Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> >Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >Cc: stable@vger.kernel.org # v4.19+
> >Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Grabbing:
>
> da3cf67f1bcf ("crypto: ccree - don't mangle the request assoclen")
> 9f31eb6e08cc ("crypto: ccree - zero out internal struct before use")
> ccba2f1112d4 ("crypto: ccree - improve error handling")
>
> resolved this conflict.
>
>
>

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad
--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
