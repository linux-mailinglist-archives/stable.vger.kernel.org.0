Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A151F7FAE
	for <lists+stable@lfdr.de>; Sat, 13 Jun 2020 01:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgFLXiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 19:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgFLXh5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 19:37:57 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4663420791;
        Fri, 12 Jun 2020 23:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592005077;
        bh=07QDCF421g/CuXLPx32EKB9Xu/PvgNQ6R+YnFVHUbuw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=hyr+caZu2NRBmgLwdXXu40vb4iTHoYV+HC/tPpLLyKoU1vq6Vj5mupX/DyQQgAWH1
         GC667Hkv16bCjScoofE/VXIGPoCnLbKtxI9crxSO16y/JYOnUWfE5crlsoYYo5XECi
         7GLKq3FjNoJTCy8rwN7rPVQSmF/XrmgzlwT6YhGI=
Received: by mail-ot1-f53.google.com with SMTP id m2so8674340otr.12;
        Fri, 12 Jun 2020 16:37:57 -0700 (PDT)
X-Gm-Message-State: AOAM530SdvRgHVbaJc/wecZi5jFTV3HJOTyF7FWBEBXTPUwzynAbQFGs
        dgBOYw+TLPuregbWni8oiMvdGlrm4cqu4kaSLJA=
X-Google-Smtp-Source: ABdhPJyTRtcPMPqKh5Nfj4+4NWaSGz97CSu/hxlH0RFH6zRAvJcXWfjI0ZvuL8tlEYmqUJnZV3f78BRyXwepAizGOL4=
X-Received: by 2002:a9d:6c4c:: with SMTP id g12mr12585266otq.114.1592005076625;
 Fri, 12 Jun 2020 16:37:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:1d8:0:0:0:0:0 with HTTP; Fri, 12 Jun 2020 16:37:55 -0700 (PDT)
In-Reply-To: <87ftb0im64.fsf@suse.com>
References: <CGME20200611022619epcas1p46fd9d1d54396f0a4206b550949377d99@epcas1p4.samsung.com>
 <20200611022119.31506-1-namjae.jeon@samsung.com> <87ftb0im64.fsf@suse.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 13 Jun 2020 08:37:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd86YGh9d5=zYs_+_NKNXLnFK5jb9EBMm5AGeNuRtnWzeQ@mail.gmail.com>
Message-ID: <CAKYAXd86YGh9d5=zYs_+_NKNXLnFK5jb9EBMm5AGeNuRtnWzeQ@mail.gmail.com>
Subject: Re: [PATCH] smb3: add indatalen that can be a non-zero value to
 calculation of credit charge in smb2 ioctl
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>, linux-cifs@vger.kernel.org,
        Stable <stable@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2020-06-12 20:00 GMT+09:00, Aur=C3=A9lien Aptel <aaptel@suse.com>:
> Hi Namjae,
Hi Aur=C3=A9lien,
>
> Nice to see a patch :)
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Thanks for your review!!
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
