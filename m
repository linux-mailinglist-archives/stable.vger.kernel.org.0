Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A71955360F
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 17:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbiFUP1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 11:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351675AbiFUP1k (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 21 Jun 2022 11:27:40 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F9F2A961
        for <Stable@vger.kernel.org>; Tue, 21 Jun 2022 08:27:39 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id y79so14616175iof.2
        for <Stable@vger.kernel.org>; Tue, 21 Jun 2022 08:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Kpsk6t7byF0Wefcv3WDRoOBLZsTnqCGH43ttikkBli0=;
        b=diEDXlL4V5gzIPX49G2vAqqwGRgWZ6slJC0goYyw3QOvCihM+IodGR/ht3T8TWbDPd
         ivqcrz8tb/pv+djwgPMz2pduRQrwOHNhGpmOH0IhDRpWj8CUZCXEiqRufEIAwUDfFSo0
         UMHn2sX4xk6FwWEUlMMFkxsvL8hRx4iXtFzXW767UfMpXPu0tJjhAuw1FWSXU1XiaemQ
         4wssDsaQ6V/aerGvaTqCSlexDePsEaUWWUwzRVUDxY27fWijampUbZIa1fdkvxK5N/7+
         dDQJI08X27TTom3j3FCnTU5V0AhD1swUMRkO53bRamKjAMguygpg/KHUC0kGhIteD+e1
         a6iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Kpsk6t7byF0Wefcv3WDRoOBLZsTnqCGH43ttikkBli0=;
        b=r95lMrCVoeju/8vEhc1qvNzXJnobRMB0Iydp1g69nTQQ9nuy7Sx3v2/veWadkGbYw3
         w3cekvSv5OV2gUbsDRR6bAiPesOSFxDgvto+QscYxjeiE+DTZ6Ijj6crJ0yAUC26eZ0+
         7z+PTVr7lx2jTGWG9XiVYJFdCIV4RT502mAtgz5iOg86XAMeadgKNMQSvDFX2CYvxYzF
         gogIUDLhyG9JuN+4xXo2P7ZV8heGV3NUctzn/d0BWIhnvMs6oqO85alh8tCinMcJKU+2
         p2EFijzKxxSV+tdYmo+9k8DgUlL8aq3VG0/COl0WwQH3RU3kCIcJFSZkIbhU5C+NOLvh
         hGUQ==
X-Gm-Message-State: AJIora9JWO4ZmhxLXB4H29O2FIAC77Be820m9LS5EOricvxNiLKLCywu
        3ekQQ6YJ/VD0fby3+obBVSb/DLGm23HMwL1Q1uSa0xR/
X-Google-Smtp-Source: AGRyM1sj8DA3Go524KZ+JYb/qgy/gAH5DnEJ7tsR/9AEH6eXTwGJblPJ5Crf7j65Pbur15EGiTUj9tnf+rgYlH4AyEY=
X-Received: by 2002:a05:6602:2f05:b0:66a:381e:1754 with SMTP id
 q5-20020a0566022f0500b0066a381e1754mr14535968iow.144.1655825258649; Tue, 21
 Jun 2022 08:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220621152340.2475484-1-aurabindo.pillai@amd.com> <20220621152340.2475484-2-aurabindo.pillai@amd.com>
In-Reply-To: <20220621152340.2475484-2-aurabindo.pillai@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 21 Jun 2022 11:27:27 -0400
Message-ID: <CADnq5_Ox00B4PQrcBFyp4F69_DxAQvUyLuPqY6fxdzpvfOF0YQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/amd/display: fix incorrect comparison in DML
To:     Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "Siqueira, Rodrigo" <rodrigo.siqueira@amd.com>,
        "for 3.8" <Stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Series is:
Acked-by: Alex Deucher <alexander.deucher@amd.com>

On Tue, Jun 21, 2022 at 11:23 AM Aurabindo Pillai
<aurabindo.pillai@amd.com> wrote:
>
> [Why&How]
> GCC 12 catches the following incorrect comparison in the if arm
>
> drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/dcn32/display_mode_vba_32.c:=
 In function =E2=80=98dml32_ModeSupportAndSystemConfigurationFull=E2=80=99:
> drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/dcn32/display_mode_vba_32.c:=
3740:33: error: the comparison will always evaluate as =E2=80=98true=E2=80=
=99 for the address of =E2=80=98USRRetrainingSupport=E2=80=99 will never be=
 NULL [-Werror=3Daddress]
> 3740 | || &mode_lib->vba.USRRetrainingSupport[i][j])) {
> | ^~
> In file included from ./drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/disp=
lay_mode_lib.h:32,
> from ./drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dc.h:45,
> from drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/dcn32/display_mode_vba_=
32.c:30:
> ./drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/display_mode_vba.h:1175:14=
: note: =E2=80=98USRRetrainingSupport=E2=80=99 declared here
> 1175 | bool USRRetrainingSupport[DC__VOLTAGE_STATES][2];
> |
>
> Fix this by remove preceding & so that value is compared instead of
> address
>
> Fixes: d03037269bf2 ("drm/amd/display: DML changes for DCN32/321")
> Cc: Stable@vger.kernel.org
> Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
> ---
>  drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32=
.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
> index c920d71fbd56..510b7a81ee12 100644
> --- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
> +++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
> @@ -3725,7 +3725,7 @@ void dml32_ModeSupportAndSystemConfigurationFull(st=
ruct display_mode_lib *mode_l
>                                 && (!mode_lib->vba.FCLKChangeRequirementF=
inal || i =3D=3D v->soc.num_states - 1
>                                 || mode_lib->vba.FCLKChangeSupport[i][j] =
!=3D dm_fclock_change_unsupported)
>                                 && (!mode_lib->vba.USRRetrainingRequiredF=
inal
> -                               || &mode_lib->vba.USRRetrainingSupport[i]=
[j])) {
> +                               || mode_lib->vba.USRRetrainingSupport[i][=
j])) {
>                                 mode_lib->vba.ModeSupport[i][j] =3D true;
>                         } else {
>                                 mode_lib->vba.ModeSupport[i][j] =3D false=
;
> --
> 2.36.1
>
