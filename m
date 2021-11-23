Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23AE459919
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 01:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhKWAVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 19:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhKWAVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 19:21:30 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA341C061714;
        Mon, 22 Nov 2021 16:18:23 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id ay21so40111431uab.12;
        Mon, 22 Nov 2021 16:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=13yRo0VFNAnOPLFTcWjrwNK42UP3PCceUcdWTF4LVD8=;
        b=UvjVL0By9A0ALx3dL9uZ5ctcG97/04znBABDP6A5BeCTljXtmN65wEM5NEhqKdthEX
         TRwbCdD4kSByjbl2ByIvVnJeVWbe2i3tVoRWGi/LadzYuopCunCjP7EsqMKH6KSfpEu9
         KBroGZ3Fku8F2jvA9axdgDpYjCFkSUTOnxszaRPCh7eYEXj8SJeSd/AoTk/ktYWLhEVe
         g4G7eI7WgC72vyMRGNJY6d+ZXtICwX2+n7TxKvI38LocPBaf7lgC4lvPcd+Unu+XLVMT
         53jHtawcd1z2ZnufQYNuW/wlLSzQK3QUDhbaCJ3YOVSE/LrakDojxG2vFPlAH92xsCyt
         OeGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=13yRo0VFNAnOPLFTcWjrwNK42UP3PCceUcdWTF4LVD8=;
        b=itzAmZ7b15kPsPZwVKRIdoBvQJ2vRmVarHFeR4tSt3rs53FKCzW69PcKyXlcHlsIsb
         agobR3nYMU9uUKcMtI8So3cc7s1c642Ty6etglhcFYGFr90ol3SiZVAcklkkJpVJvt17
         d6Zrxrk1PZAteKUM2vO/Wv3yg1Xv/XDKuk/pmVT1kOwqBRkXnANdn6toTV7ialPsPrJG
         zQwXe94vYPEB2+yl/VsmKwPW63hQFergf6n3OAUTp/GhYmGYME58DEpVhQXbxZLpeydE
         oQyA8WQ9k67LvQ82G1ooBcu3m+CIP2njR1m1Lpmaok5JOFBfXCUV/AibdICVSaxP1msK
         k5iQ==
X-Gm-Message-State: AOAM530Ba4z0HepFCHMEpQiYe+oSD0nV+/wW/mp+hQ78nBUg9ljAat5p
        xvBg70+yU2sIeLF17jcj+p6FZHfsAXikWQZLcJA=
X-Google-Smtp-Source: ABdhPJw92dSi+y/R/Nq1YVcDLsM8UUQ7rgveHDKfXatC7XMuf8WjM9+VN+aF1t0VCTuMpXonsdWaWNQPFSKEHyIUv3A=
X-Received: by 2002:a05:6102:5492:: with SMTP id bk18mr2360042vsb.18.1637626702781;
 Mon, 22 Nov 2021 16:18:22 -0800 (PST)
MIME-Version: 1.0
References: <20211121114333.6179-1-linkinjeon@kernel.org>
In-Reply-To: <20211121114333.6179-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Tue, 23 Nov 2021 09:18:11 +0900
Message-ID: <CANFS6baWX33CqfT1r4GO+b5dFMJDcMe8HqO1AfS7=pZq0t6zPQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: downgrade addition info error msg to debug in smb2_get_info_sec()
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 11=EC=9B=94 21=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 9:33, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> While file transfer through windows client, This error flood message
> happen. This flood message will cause performance degradation and
> misunderstand server has problem.
>
> Fixes: e294f78d3478 ("ksmbd: allow PROTECTED_DACL_SECINFO and UNPROTECTED=
_DACL_SECINFO addition information in smb2 set info security")
> Cc: stable@vger.kernel.org # v5.15
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 121f8e8c70ac..82954b2b8d31 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -5068,7 +5068,7 @@ static int smb2_get_info_sec(struct ksmbd_work *wor=
k,
>         if (addition_info & ~(OWNER_SECINFO | GROUP_SECINFO | DACL_SECINF=
O |
>                               PROTECTED_DACL_SECINFO |
>                               UNPROTECTED_DACL_SECINFO)) {
> -               pr_err("Unsupported addition info: 0x%x)\n",
> +               ksmbd_debug(SMB, "Unsupported addition info: 0x%x)\n",
>                        addition_info);
>
>                 pntsd->revision =3D cpu_to_le16(1);
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
