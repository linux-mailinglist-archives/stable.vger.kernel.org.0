Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6990B4DD7
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 14:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbfIQMcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 08:32:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36983 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbfIQMcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 08:32:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id i1so2979936wro.4;
        Tue, 17 Sep 2019 05:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XIJSysNlvx4lB2C+QWOSQFkpZ/vA967E/7zPmqCFNH0=;
        b=AJXg3jTVlPRSxCmfbKgU0PaGOMOWE944KTCDf6D8DO7FCemXrPrI7sB6vgtZFNBrkR
         sCp0zkm7y/oF9053v/PEFEG5S2EFa6vQC+0ug17oopmvLOVTpVkdim9JSTjAUDMgLrTE
         snM7+fWjTbpxYRplNKzbYov2rb9lcCj0XcDqQIH5Gh3ZsVtlKnfZQpFpIBq80EvuG9/s
         bZxDR9XN99JhGRq3ebg0/UW+olqKFyYYwszHiYC1g6PWIcBMSbyNvfGUxa7XFC4oFBB8
         RypuRNN6eae1FXSV6naFz3V9Eu3sDwZPRMkvpdQMP1EyFg3S2MjF3k7kNrdsT3hbE/ox
         zWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XIJSysNlvx4lB2C+QWOSQFkpZ/vA967E/7zPmqCFNH0=;
        b=P+DPmhNJRcPBag4rm+21zOwfzUP+iCHUT004tkIVBtwdpQD0U6FbR1eeLm18/xlFLU
         iVZvIZklB8TVs9lp+eVWdynpEz9ljm5fnniR6vsSvvrtCxvVz0437FGyqeXUfNIJI6Qu
         7M3h2UqA/01hmVnD9CDVxyrw4MaFU2OXvJFRYi53cj/4ZnMkW7hVK7ZabI5fMKKEAkrZ
         k2etgcHFFQYoFM89BNkp5CyjMFAFPBtpScjgRS/dfFXCSDFAl0o0QEpChKj4qKjUW63o
         zwgyBVpewqLGXxhrlkbo9zRRlk/t1hHMT0rF4LT3NWfvhYszNkbjpRuZQkGDaGknO0bd
         EFiQ==
X-Gm-Message-State: APjAAAUgOSo29xwH3OuVpLgf5pJjTREHi4cptXzfqpts7W/x6V7Y/BeW
        a/i8GjwfNc5tYaxJtSWfrurPQfJfTlYyoPVz2ZfJbg==
X-Google-Smtp-Source: APXvYqwb7RLesNvB8SdDalTsDttczeMsHIhMlAGPlZuyAJ6ipirh590VYQVix7b4O8BmviIoaUljgm5PcIRYSd183HE=
X-Received: by 2002:a5d:5185:: with SMTP id k5mr2118421wrv.341.1568723556626;
 Tue, 17 Sep 2019 05:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190902083342.27393-1-kai.heng.feng@canonical.com>
In-Reply-To: <20190902083342.27393-1-kai.heng.feng@canonical.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 17 Sep 2019 08:32:23 -0400
Message-ID: <CADnq5_NtPXA-87MU-nmnT4t4+cjgJfR7VbyRxYCpSH9YXE4RUA@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Restore backlight brightness after
 system resume
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     "Wentland, Harry" <harry.wentland@amd.com>,
        "Leo (Sunpeng) Li" <sunpeng.li@amd.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Chunming Zhou <David1.Zhou@amd.com>,
        "for 3.8" <stable@vger.kernel.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Applied.  Thanks!

Alex

On Mon, Sep 2, 2019 at 4:16 PM Kai-Heng Feng
<kai.heng.feng@canonical.com> wrote:
>
> Laptops with AMD APU doesn't restore display backlight brightness after
> system resume.
>
> This issue started when DC was introduced.
>
> Let's use BL_CORE_SUSPENDRESUME so the backlight core calls
> update_status callback after system resume to restore the backlight
> level.
>
> Tested on Dell Inspiron 3180 (Stoney Ridge) and Dell Latitude 5495
> (Raven Ridge).
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 1b0949dd7808..183ef18ac6f3 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -2111,6 +2111,7 @@ static int amdgpu_dm_backlight_get_brightness(struct backlight_device *bd)
>  }
>
>  static const struct backlight_ops amdgpu_dm_backlight_ops = {
> +       .options = BL_CORE_SUSPENDRESUME,
>         .get_brightness = amdgpu_dm_backlight_get_brightness,
>         .update_status  = amdgpu_dm_backlight_update_status,
>  };
> --
> 2.17.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
