Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C8526F28C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgIRC7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727677AbgIRCF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 22:05:59 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B72C06174A
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 19:05:58 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id gr14so6020180ejb.1
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 19:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anholt-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ImzYFdv7FV86GEX3X/1tw1hfTU6H6hUSLVTXY/iYER8=;
        b=Y58xKi1obOp2IninGGVaFXvJGsFdsmII8kZ+jjhOcGrqyYoWPKMSQuXr1fQOhMXDH7
         ke7OElRKM0lP/hUCKkFBTvxbnmcrdq8oW+XdwHOxwkf7zLpn3V350ZdQZ3wiTro5H1w9
         NufqIxN544+s5HOUZ91dQ1QSuFHGmjewxAfFYNqCStBz05lQIOYb59kYUSJqfbYpvw32
         BZ4k3oEBJRlfZ6KTuCgywM3T13KJPRsnM6XZoEtjsTLa6FHTEiarx8PMfGG4PViqHJam
         3BiziNkfZFVdTo7dd7iTEAAe62jUVzgPBjXCC7cBiMbPzBYm7tv7De5ycK9NdPELUd6g
         iHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ImzYFdv7FV86GEX3X/1tw1hfTU6H6hUSLVTXY/iYER8=;
        b=j/wj1fkoN3Le7o5tHTEqYAzBFt5bEVFWI7nQjlb8B3dNiBS9J+afzaidTQMJgxNc61
         0uKKE9RA1nOYiakJNz2qSNPB8PZKCQTz2QhKDAB3gcK1oIbowNMFFtbwBPDe19Kr0NCq
         RILpj9W4YIPmE1TkeiYrQF+SpBtrFygzuudsP1h0TLfvZjPFEKYbQ0jW8vJmzmcgIhpy
         sKPLTrdRuJoxvhBmxMboBeR+V1WtDGB29ic+0uhgj/Ob3RtTKBMkrDg4j47QP0GUa882
         K7CqQ8hnva+nXRH8M2h1ON3LYqNy01fY6FRVgLcuCw7Xh4PdKxe0lR0tm0XhQwqC0a5U
         8ysA==
X-Gm-Message-State: AOAM5303XMskUwxj61zSN1lMSgk0YL6fQLfzONWYbKrn8i1c7H0GvwOE
        FNZKSPnxRX5CJZoORg6Nn7YDTzb/EeJ354ETyWARRFLnnUd3LQ==
X-Google-Smtp-Source: ABdhPJxlg7ODADz80YFnr6Q7tPZD8jDi9k5Ly/WiLL8uJJ7BSWXenxN/XEM895zONY25h5SaYAzMlKPht9rTnAX/rTA=
X-Received: by 2002:a17:906:37c6:: with SMTP id o6mr22553734ejc.404.1600394757373;
 Thu, 17 Sep 2020 19:05:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200918020110.2063155-1-sashal@kernel.org>
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
From:   Eric Anholt <eric@anholt.net>
Date:   Thu, 17 Sep 2020 19:05:46 -0700
Message-ID: <CADaigPWfTDJ_G6z3ZKm-bqBO8LPthEBkJoqXk=znGqvDhkw3bw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 001/330] drm/v3d: don't leak bin job if
 v3d_job_init fails.
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Iago Toral Quiroga <itoral@igalia.com>,
        DRI Development <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 7:01 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Iago Toral Quiroga <itoral@igalia.com>
>
> [ Upstream commit 0d352a3a8a1f26168d09f7073e61bb4b328e3bb9 ]
>
> If the initialization of the job fails we need to kfree() it
> before returning.
>
> Signed-off-by: Iago Toral Quiroga <itoral@igalia.com>
> Signed-off-by: Eric Anholt <eric@anholt.net>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190916071125.5255-1-itoral@igalia.com
> Fixes: a783a09ee76d ("drm/v3d: Refactor job management.")
> Reviewed-by: Eric Anholt <eric@anholt.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

You're double freeing with this patch, the bug is already solved.

> ---
>  drivers/gpu/drm/v3d/v3d_gem.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
> index 19c092d75266b..6316bf3646af5 100644
> --- a/drivers/gpu/drm/v3d/v3d_gem.c
> +++ b/drivers/gpu/drm/v3d/v3d_gem.c
> @@ -565,6 +565,7 @@ v3d_submit_cl_ioctl(struct drm_device *dev, void *data,
>                 ret = v3d_job_init(v3d, file_priv, &bin->base,
>                                    v3d_job_free, args->in_sync_bcl);
>                 if (ret) {
> +                       kfree(bin);
>                         v3d_job_put(&render->base);
>                         kfree(bin);
>                         return ret;
> --
> 2.25.1
>
