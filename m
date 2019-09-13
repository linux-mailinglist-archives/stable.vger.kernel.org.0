Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D931B1BA4
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 12:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfIMKk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 06:40:58 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42486 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfIMKk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 06:40:57 -0400
Received: by mail-lj1-f195.google.com with SMTP id y23so26593157lje.9
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 03:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C+J9lamyA6ZW0+YfpTLXuhGXKsRf+gk+TsCwF+GvOpI=;
        b=LgiCq9fFfrRLWeC9Befvvw0RXITY4D3isLYXp9xmPQ0/FG9thG0kKQGS1IXuWcPW1/
         V0FyvW72B09KG20crNUhzDCcPccnjp+kvWjZbxFJ6hOFMFmFWBbSoGS51b62tvPMAz+k
         7pHvPtm6bufzxEHOKJjmlWJToQlwvrM/sQyJ+qjcPXjadI+qjR0fhY4oGyT7bEhejVih
         /WOPYFSaPDEQR3oaGiTzKu6NhSmwDgOzn3/CxosX20WQHDRWoKrGXfptm/B7oWgE61rK
         HlflR0oEMdckG7qF6rhjxDbB6B8s4OAi+En/mGv6zoD1Y4cYEG4TUHj3EKhmiuTZxFwd
         Bg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C+J9lamyA6ZW0+YfpTLXuhGXKsRf+gk+TsCwF+GvOpI=;
        b=cjQk4U/dnz/agYuTD4djpJW9Mf/43WOPWmZPBF1/S4gjxENHMlzGCFOXo74WH2MVxj
         T+0AKrYDbRgn+Lu4IbDcmCV+QeephAMGUaqWLI9Ta+5gYfcJ1Jf1ZJ4YwCTwIeJcSBVy
         9a1qBO77ZE+PdzvG4Im65eX2E/3LzoCyfM0pzb1t0C6cQMjNgzzLJmM6PPe6zU/l0GAh
         o9XZZqjwuYmxf07cHh2G2UR6PCDDNiKlN0QU7Ub1ej8VdNd0d0ReZ/lEeR1oz+Q6QCTi
         ekwfOAUXxoXPI7oFcIOiPsYHX1a8lFSnWHQKOXkNQDUbNShNR1A7jQ16tDyGUMnU1dgw
         ksNA==
X-Gm-Message-State: APjAAAVMyTStIu6ofxZ3IJzXwozFY7WSwz7YbkTkHAtUnHwYqZg7PZJA
        d+uyeHikUJYLCu8VuCXnqQU1eWFnYSTv+NQzZo0=
X-Google-Smtp-Source: APXvYqyXWdGRTe0VGIN11vHOaL9SKm+GCrvwjBKs9HbpkUzu1AYV8OtmYK42fcISXFrc+62Wut/8Cmn9RfKRuF7BFmI=
X-Received: by 2002:a2e:91c6:: with SMTP id u6mr12261165ljg.112.1568371255735;
 Fri, 13 Sep 2019 03:40:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190912183854.28194-1-thomas_os@shipmail.org>
In-Reply-To: <20190912183854.28194-1-thomas_os@shipmail.org>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Fri, 13 Sep 2019 16:10:43 +0530
Message-ID: <CAFqt6zYVVCLXCmznkCKGhbe6+NE86KRpXyqTqZ27rh72vOJiAQ@mail.gmail.com>
Subject: Re: [PATCH] drm/ttm: Restore ttm prefaulting
To:     =?UTF-8?Q?Thomas_Hellstr=C3=B6m_=28VMware=29?= 
        <thomas_os@shipmail.org>
Cc:     dri-devel@lists.freedesktop.org,
        linux-graphics-maintainer <linux-graphics-maintainer@vmware.com>,
        pv-drivers@vmware.com, Thomas Hellstrom <thellstrom@vmware.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 13, 2019 at 12:09 AM Thomas Hellstr=C3=B6m (VMware)
<thomas_os@shipmail.org> wrote:
>
> From: Thomas Hellstrom <thellstrom@vmware.com>
>
> Commit 4daa4fba3a38 ("gpu: drm: ttm: Adding new return type vm_fault_t")
> broke TTM prefaulting. Since vmf_insert_mixed() typically always returns
> VM_FAULT_NOPAGE, prefaulting stops after the second PTE.
>
> Restore (almost) the original behaviour. Unfortunately we can no longer
> with the new vm_fault_t return type determine whether a prefaulting
> PTE insertion hit an already populated PTE, and terminate the insertion
> loop. Instead we continue with the pre-determined number of prefaults.
>
> Fixes: 4daa4fba3a38 ("gpu: drm: ttm: Adding new return type vm_fault_t")
> Cc: Souptick Joarder <jrdr.linux@gmail.com>
> Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>

This commit merged into 4.19. Need to Cc stable.

Cc: stable@vger.kernel.org # v4.19+

> ---
>  drivers/gpu/drm/ttm/ttm_bo_vm.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo=
_vm.c
> index 5a580adeb9d1..aa18e8a53727 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
> @@ -290,15 +290,13 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault=
 *vmf,
>                 else
>                         ret =3D vmf_insert_pfn(&cvma, address, pfn);
>
> -               /*
> -                * Somebody beat us to this PTE or prefaulting to
> -                * an already populated PTE, or prefaulting error.
> -                */
> -
> -               if (unlikely((ret =3D=3D VM_FAULT_NOPAGE && i > 0)))
> -                       break;
> -               else if (unlikely(ret & VM_FAULT_ERROR))
> -                       goto out_io_unlock;
> +               /* Never error on prefaulted PTEs */
> +               if (unlikely((ret & VM_FAULT_ERROR))) {
> +                       if (i =3D=3D 0)
> +                               goto out_io_unlock;
> +                       else
> +                               break;
> +               }
>
>                 address +=3D PAGE_SIZE;
>                 if (unlikely(++page_offset >=3D page_last))
> --
> 2.20.1
>
