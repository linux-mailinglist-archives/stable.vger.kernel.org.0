Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B565415E56C
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405498AbgBNQWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:22:40 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45343 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393233AbgBNQWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 11:22:39 -0500
Received: by mail-wr1-f68.google.com with SMTP id g3so11537230wrs.12;
        Fri, 14 Feb 2020 08:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F8W0MotfQnPEa/KdyFQF0W7kLEtQWwDAo9vyrtiU5Gk=;
        b=GUMYpxGiCyf3qvAsvG9GusvIKRkK0vVL0zi86+QpCsvqgQqnwyviEn/Oa968Apl0lw
         TDkrkAfVE8rjwJJGnmolzZR0Bu7nzRD7qAtBsTqSb4umtQk+CALu8EeDwnA+qSBCAy1v
         HvfKlm67BY2KYScY/BL/cA9d9/9gn7XEKLfG5gpqW9ETdmOCv1yRTzIp/+GSKvywAsD6
         Af3fZFvf6OLSy3vA7ITY9h1qKtmccPUjr1I3Th/WdCPcKhGPGvA4d5UPj61gicYg9BPF
         XgJDA+4BuTs2iru68xpoVLqoyhfLDOzDb9rfQK2fdpjdzqNMcsHE3XCMZLQCKjpBweIq
         TE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F8W0MotfQnPEa/KdyFQF0W7kLEtQWwDAo9vyrtiU5Gk=;
        b=kodLSjBKZEB7StIKjxEKA7pPvvhlVuuJms4VYuuDkbK3TSuOFrvtpw73BkFTHKGGNb
         uyGD2I95fZbOSFC7eiHghTu8E036TP0dtO/4r557kMS5mB5C6DS5FRMKRJoZjI3NrbTr
         QsSA6DKEn4XaoU8rjmgnxAxZsoNwwLcY7whpwoaZv0wItwfHP29yxW7uVchnUGXAElB3
         kTOKv4a4PeoVC9Z3ibXpgMVDMcBk3M75U9moDLj2MUvnpkHtbSGsTO+LZ7jeo+m03pIb
         wGr/d4ts/XEJ6Aj/tm2m787+zK84+wP6og8JcVaaZRvS4Gud06LK5Wvmv0Z38YPoDPuM
         9EUQ==
X-Gm-Message-State: APjAAAUJioK5Z5LbV6MywgMetpl8NG3YPgz4A6IVaiDMCq91kKj7a7lJ
        7iUDFEmgFuSeArseudWSt36bmUeYUDrDwZUlgBk=
X-Google-Smtp-Source: APXvYqwr8VK9pA0btz3BZPR8gMaxqgRSDNoIunzZqG4iZhOozas0m6WDC9tRV0qGzH0B/KyocD/tTa393fURFpVYEd0=
X-Received: by 2002:adf:ec4c:: with SMTP id w12mr5088220wrn.124.1581697358169;
 Fri, 14 Feb 2020 08:22:38 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-408-sashal@kernel.org>
In-Reply-To: <20200214154854.6746-408-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 14 Feb 2020 11:22:27 -0500
Message-ID: <CADnq5_MMLNtb=3LLHsYnXtONQf4NWNgV226w2=OFk3JpCRj3sA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 408/542] drm/amdgpu: add the lost mutex_init back
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>, Feifei Xu <Feifei.Xu@amd.com>,
        xinhui pan <xinhui.pan@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:57 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: "Pan, Xinhui" <Xinhui.Pan@amd.com>
>
> [ Upstream commit bd0522112332663e386df1b8642052463ea9b3b9 ]
>
> Initialize notifier_lock.
>
> Bug: https://gitlab.freedesktop.org/drm/amd/issues/1016
> Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
> Reviewed-by: Christian K=C3=B6nig <christian.koenig@amd.com>
> Signed-off-by: xinhui pan <xinhui.pan@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm=
/amd/amdgpu/amdgpu_device.c
> index 332b9c24a2cd0..a2f788ad7e1c6 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> @@ -2797,6 +2797,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
>         mutex_init(&adev->notifier_lock);
>         mutex_init(&adev->virt.dpm_mutex);
>         mutex_init(&adev->psp.mutex);
> +       mutex_init(&adev->notifier_lock);
>

This patch is not relevant here.  The same mutex is already
initialized 3 lines above.

Alex


>         r =3D amdgpu_device_check_arguments(adev);
>         if (r)
> --
> 2.20.1
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
