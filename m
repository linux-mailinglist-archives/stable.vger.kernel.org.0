Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FA145991B
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 01:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhKWAWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 19:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhKWAWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 19:22:24 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00DEC061574;
        Mon, 22 Nov 2021 16:19:16 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id d130so11385779vke.0;
        Mon, 22 Nov 2021 16:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WBqdKItLJXp421nms7/dpm4bhBPVLp3R6LIly7eoeZ0=;
        b=e/9mpcUuxT2VrNQ9UGyuV4JeI9NKiCvPglkUS1zg0S5hD+4lWZ6Tpc2xR1NGAJQHTe
         xwrAtAs5HTIG3kqitxPYXT1h5lGAe2J0UqA9HQ5qpPF+guuI6dBXWB2ZOlC9r/wX0VPz
         x1esRueWpLj4cvAFWupNwRdyiWIy0/0ZUFP+laJjUQCMe8asvYyRrPxQ6nN2/kYV4O7H
         SifFYCrqGOrd24UWBmxhXgLZk5CfOvBQ6M0wgfG5hVuL313wlcFQXNNZrBmOy/GSNfoX
         JWZcXqEbfqqruNMKkuwbFnwZbxypG4pDwnaRUEU9qznmGFtdSO7jgP9pPeXRwZ5nGxyV
         RVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WBqdKItLJXp421nms7/dpm4bhBPVLp3R6LIly7eoeZ0=;
        b=1RRZH0WqNOebvVoR6UiRtjoqYQHTDd3j/5Yhfd46b2j6TLMA6shOQx7rz/f5iLmgye
         RPZqmB2fXYLXztLbQaJRx60tKLh1+ZWHjOo5/A5IJnSaUg2MdtHuI8W2X5ZjcWvY8jju
         anrxBfugT2l0n227LHLwGxEBM6aNIAuGm28uGEbZO68298lXCj8WE0+EVWpg0E/he/mE
         Luix9IiBUtctJ/VlA/ArAFsUoy0E6jnOZM0rI/zS8vQ3KFfkhlh4xakbhc9hdGTaZD0I
         xUn65/b7lYQeP+6ymViqX4njnXuPE7X7tPAuHE/YHW/+4MWPmCMyOdfPaogV8yOPNcQw
         Ep6w==
X-Gm-Message-State: AOAM532XrVBPS2SI3buk8pxEDAxIA7iGaVn/4mRsGh+NwESoZX+xntr+
        XZC+sbNIpfIld/FzSt8/vTtWvq4sD4jmC44RwDQ=
X-Google-Smtp-Source: ABdhPJxrE68NzNM8fWOOiF9GIDcbPLKesOWJ1b89CiFHJwmojLtlOiVqkGUr/OEazbFcjt7D9GFpTz/PTR5t/U/6VeQ=
X-Received: by 2002:a05:6122:7d4:: with SMTP id l20mr1975176vkr.26.1637626755641;
 Mon, 22 Nov 2021 16:19:15 -0800 (PST)
MIME-Version: 1.0
References: <20211121114333.6179-1-linkinjeon@kernel.org> <20211121114333.6179-2-linkinjeon@kernel.org>
In-Reply-To: <20211121114333.6179-2-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Tue, 23 Nov 2021 09:19:04 +0900
Message-ID: <CANFS6bZ9-Z8u9juXWoPqL9mWn14_qEUaPt8g4k48X_Xv46=mEQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: contain default data stream even if xattr is empty
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
> If xattr is not supported like exfat or fat, ksmbd server doesn't
> contain default data stream in FILE_STREAM_INFORMATION response. It will
> cause ppt or doc file update issue if local filesystem is such as ones.
> This patch move goto statement to contain it.
>
> Fixes: 9f6323311c70 ("ksmbd: add default data stream name in FILE_STREAM_=
INFORMATION")
> Cc: stable@vger.kernel.org # v5.15
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2pdu.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 82954b2b8d31..2067d5bab1b0 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -4457,6 +4457,12 @@ static void get_file_stream_info(struct ksmbd_work=
 *work,
>                          &stat);
>         file_info =3D (struct smb2_file_stream_info *)rsp->Buffer;
>
> +       buf_free_len =3D
> +               smb2_calc_max_out_buf_len(work, 8,
> +                                         le32_to_cpu(req->OutputBufferLe=
ngth));
> +       if (buf_free_len < 0)
> +               goto out;
> +
>         xattr_list_len =3D ksmbd_vfs_listxattr(path->dentry, &xattr_list)=
;
>         if (xattr_list_len < 0) {
>                 goto out;
> @@ -4465,12 +4471,6 @@ static void get_file_stream_info(struct ksmbd_work=
 *work,
>                 goto out;
>         }
>
> -       buf_free_len =3D
> -               smb2_calc_max_out_buf_len(work, 8,
> -                                         le32_to_cpu(req->OutputBufferLe=
ngth));
> -       if (buf_free_len < 0)
> -               goto out;
> -
>         while (idx < xattr_list_len) {
>                 stream_name =3D xattr_list + idx;
>                 streamlen =3D strlen(stream_name);
> @@ -4514,6 +4514,7 @@ static void get_file_stream_info(struct ksmbd_work =
*work,
>                 file_info->NextEntryOffset =3D cpu_to_le32(next);
>         }
>
> +out:
>         if (!S_ISDIR(stat.mode) &&
>             buf_free_len >=3D sizeof(struct smb2_file_stream_info) + 7 * =
2) {
>                 file_info =3D (struct smb2_file_stream_info *)
> @@ -4522,14 +4523,13 @@ static void get_file_stream_info(struct ksmbd_wor=
k *work,
>                                               "::$DATA", 7, conn->local_n=
ls, 0);
>                 streamlen *=3D 2;
>                 file_info->StreamNameLength =3D cpu_to_le32(streamlen);
> -               file_info->StreamSize =3D 0;
> -               file_info->StreamAllocationSize =3D 0;
> +               file_info->StreamSize =3D cpu_to_le64(stat.size);
> +               file_info->StreamAllocationSize =3D cpu_to_le64(stat.bloc=
ks << 9);
>                 nbytes +=3D sizeof(struct smb2_file_stream_info) + stream=
len;
>         }
>
>         /* last entry offset should be 0 */
>         file_info->NextEntryOffset =3D 0;
> -out:
>         kvfree(xattr_list);
>
>         rsp->OutputBufferLength =3D cpu_to_le32(nbytes);
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
