Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E761AC198
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 14:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635998AbgDPMoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 08:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636076AbgDPMoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 08:44:07 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4359EC061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 05:44:07 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id g10so2746374uae.5
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 05:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wCyXe2LNfXES/+fuBLMBi1HmDfF4xps6SbKRv0RhJOY=;
        b=nL5eZOFQVya7TB//Ow18yga9pS/iU9qKjkD7Daszmv3+y4yf+TL/RM8YMMQUDUfQfT
         qPZzlOtuzsdz3AWqSylUcyni9VnTRhjVBrrrpmdYAtj/jwnKl93pq4VxmBm1S2xKKdXn
         0P6hHljqAK2PbE3tcr0QkEjjg9oQNE51WjoG0DfkBDug42j+kHUcSkX3e9Nlvq+6Kqrr
         woVvnFq0rXIbQVvDyjUo87M2DOMG+SecftA7IXHi25E+L0DUuRIj6W+WGn1WiyNJjY/N
         kq3ERcqHs622LdgcL8O8TWysdTNbOKwHUYkuqPeQWMpp7QvMQbTXV0s1s9Ih/3vd4EY3
         6Z7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wCyXe2LNfXES/+fuBLMBi1HmDfF4xps6SbKRv0RhJOY=;
        b=Rxjrr6HYSv8/nqPIrZoVUia+6dpnNzNlPq1DYKzoxSJc9k9FiM2VjBGxb8Rafr1fOO
         oFP18pqtnvNfWFPtc0kCjc/ynvh6iADOO1NFIaXqyo5Owzph6gb7CtVBsk7YNywIZq1s
         J9ITEViQ93AK4dkuwcs0hThAPddJcDBCyLMzd9oWTYdOaYL1lw7oYktAwlDnBSbwOT/J
         F3XRmtAnM+TLAKM7gZVGfxpwgRbCjmLOyAsyKDB7ghp/RUh5UKrzwte//BEmT9znOERM
         0Kl/nZ9xInCTwMU7Nhpd//k+JXO85sJREYst0tBqIlrBGTYR3CGacS42JSckrx5NQnY4
         2C7A==
X-Gm-Message-State: AGi0PubnKEYjjWgx/oUBZBhMpeXG34Yc5CzkP8lA7BnvchcWul8WYcI/
        6pABlqdvHCfznRQrXDu4/TVfquXz3XvmwPITd0ITKFNUmTE=
X-Google-Smtp-Source: APiQypJD1XdR20i1jzUfd1IoobYd4OUlC2K8MDhL+NVgo12H0K+NBfo/ive5S0c5TNRw3fZfwi0Tj6AD6vJmwF/vlZY=
X-Received: by 2002:ab0:2852:: with SMTP id c18mr8491370uaq.27.1587041046427;
 Thu, 16 Apr 2020 05:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <158694882829120@kroah.com> <20200416013757.GT1068@sasha-vm>
In-Reply-To: <20200416013757.GT1068@sasha-vm>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 16 Apr 2020 15:43:56 +0300
Message-ID: <CAOtvUMe5heE1yMUYcr7Gab9kktvV1h=F1N0OKtNUw8yaLoKUow@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] crypto: ccree - only try to map auth tag
 if needed" failed to apply to 4.19-stable tree
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
> On Wed, Apr 15, 2020 at 01:07:08PM +0200, gregkh@linuxfoundation.org wrot=
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
> >From 504e84abec7a635b861afd8d7f92ecd13eaa2b09 Mon Sep 17 00:00:00 2001
> >From: Gilad Ben-Yossef <gilad@benyossef.com>
> >Date: Wed, 29 Jan 2020 16:37:55 +0200
> >Subject: [PATCH] crypto: ccree - only try to map auth tag if needed
> >
> >Make sure to only add the size of the auth tag to the source mapping
> >for encryption if it is an in-place operation. Failing to do this
> >previously caused us to try and map auth size len bytes from a NULL
> >mapping and crashing if both the cryptlen and assoclen are zero.
> >
> >Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> >Cc: stable@vger.kernel.org # v4.19+
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

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad
--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad
