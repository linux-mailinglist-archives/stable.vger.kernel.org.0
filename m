Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F72739F61
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 14:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfFHMAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 08:00:47 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:39174 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbfFHMAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 08:00:47 -0400
Received: by mail-lj1-f182.google.com with SMTP id v18so3977127ljh.6;
        Sat, 08 Jun 2019 05:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V3agcW1TPfU85dOPr+CkuBHuTqLXcw37LX+ex9gMqu0=;
        b=f6cUyO1dH+FD+YFJ+mLGu80krzvcsty80oGvRXy/rqbhVS9Jdo7s0PUEHh32i5aZPs
         DsBxPuVe4ZqyRTLLPBBmVyd4TQle1hcFfPlqlMpRZ+EAGV94qYTxGEBEh0dUGTmB6IAV
         I2BEXvUavT+6nFMsAHbN4KEihlNvr60kUhKUHSzwxYvddwX1f0GqIGgZFjld5gNkqzET
         rzKuhU0ghS69YxwYDEksxw9AmIvnv4eaFhwDNDyD8qWWY45gWDjLJECSzmHtV0cf/nv6
         8vcwk5BydSPKCbH2dlzKtFqF8s1fXnC+P0WcjRU79d0waNoaM3EAGNALDkScSsTU13io
         PxgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V3agcW1TPfU85dOPr+CkuBHuTqLXcw37LX+ex9gMqu0=;
        b=RKOSYOaNp94aMiU88BiT3fMU9bbDcFKAXgScbBjDBRuoIb3Lit+OAyqmUQaeve0sfv
         asJy673e0OUzgHlZgsi/pz5YU3sgnxvMAQtJMX5b0eeiuXbGcC7Knoqnp/nnFO7OSa7Y
         wBeR3L5ZOP2OlC8j14/wL7F0ySJXcfV2iXvO/P3aGJ+Ygv8OMr1nn3hbPtFIzD3GWSmG
         4R+U9Xf2yGzWe3Ob5VUpxSb4dZXxaCUQFVJKFr5PlrJQ6iUWPDS/X4H9ZwefxRcjEXtk
         /ud8cjLIKpH4is6SHRACXlojpo7WUAAAhTaLBX2rvLVOEA4rBwznCHGTBI5X1owl8y69
         P6qA==
X-Gm-Message-State: APjAAAWoiUhjgpSQmCQ7l1gSSmHoG4t/UxYEQ5okroyyJPiCVONCaAr2
        V3D3/EE9o5KMbnEz8HS9oOdxrMVKRfYhwx7GA9gORQ==
X-Google-Smtp-Source: APXvYqyTwzFbeLcDwiBwhYkn7gKH7E2HP40VyVHo9ssGn/ZpYmq58Y7N+EwXU5xZbU7+NjCcbpyELfMjOsWhOIyC4m4=
X-Received: by 2002:a2e:3913:: with SMTP id g19mr15908455lja.212.1559995245136;
 Sat, 08 Jun 2019 05:00:45 -0700 (PDT)
MIME-Version: 1.0
References: <259986242.BvXPX32bHu@devpool35> <20190606152746.GB21921@kroah.com>
 <20190606152902.GC21921@kroah.com> <CANiq72nfFqYkiYgKJ1UZV3Mx2C3wzu_7TRtXFn=iafNt+Oc_2g@mail.gmail.com>
 <20190606185900.GA19937@kroah.com>
In-Reply-To: <20190606185900.GA19937@kroah.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Sat, 8 Jun 2019 14:00:34 +0200
Message-ID: <CANiq72n2E4Ue0MU5mWitSbsscizPQKML0QQx_DBwJVni+eWMHQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Linux_4=2E9=2E180_build_fails_with_gcc_9_and_=27cleanu?=
        =?UTF-8?Q?p=5Fmodule=27_specifies_less_restrictive_attribute_than_its_targ?=
        =?UTF-8?Q?et_=E2=80=A6?=
To:     Greg KH <greg@kroah.com>
Cc:     Rolf Eike Beer <eb@emlix.com>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 6, 2019 at 8:59 PM Greg KH <greg@kroah.com> wrote:
>
> "manually fixing it up" means "hacked it to pieces" to me, I have no
> idea what the end result really was :)
>
> If someone wants to send me some patches I can actually apply, that
> would be best...

I will give it a go whenever I get some free time :)

Cheers,
Miguel
