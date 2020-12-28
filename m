Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9853E2E6470
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632850AbgL1PuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404121AbgL1PuV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 10:50:21 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FF5C061794
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 07:49:41 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id dk8so10149688edb.1
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 07:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qtjzQnYDyk5DZh0doxfk9ryaDoFYVWbE/m+K0gu0ViY=;
        b=LV5PziCMI8V0lNM/j2hZ4/vfrM66RgWuPfQnkq6isqcBORDwmUVBr38xHk2UVaSI/l
         M8a/9etOMgPFMSFroXCSRJwqaYO9BoQ7wgenvUIo67soknImAmNAT3H4VCuoqfaT0m9M
         TtIVXNTjYNRB+fLrnS5G+r5x0VL/tuZ+q9NukTT2frkKGtokMDnqRU+5pkiF+koY6XH8
         yxib9G/K+EMQUfT8EE5nr19F6OBBjD1SZbL6J0MKUrRK8VglQ9IGzbHACGl4GTdO/k9A
         shPJunmPxl2flAX5VqobuOx7xiP9SscFWJ/yCUTJIu2F8nRMI0UDTENBpgbHggIPwb2Y
         XENQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qtjzQnYDyk5DZh0doxfk9ryaDoFYVWbE/m+K0gu0ViY=;
        b=BQDHT/eqW/mNzEOsjCI9M8QRZr88JXHDFOr0MuO6WOKnuE2NdPYIm7yqJkVGHQpugq
         ubjm0OgSyo0wIY3VBbeXi8mz0RpbMbIL/zwVp2OTztz/Skx2pvVCJdyBCL6QmCjtVpYh
         s9T4tS9ygyriaQ+biCeID2ICS2cUoVLIxeDBIMp1g6gwqJtGDwjlgUTz0/o8j1v7wOZv
         sNaRVkVocwD+UWEEa2F5ecI5Rd/I22kfFLSSNqsFDGiPk//vcCdkenaTJjkWaN8AxWtg
         Pjsw+hy5hlAIcDPOrtWY276LL3luq6KYOeubzu9RVQEXmC/f1yT+fJ2e+A6PWuL3Zx5Q
         EkFA==
X-Gm-Message-State: AOAM5300au9c1ZEkz8kKIniv6Jwv6MZmKBaWCs4sXbP/F0wKIkVH/av0
        W3f8Sru4gyhLUl1ekcHMz6m7uAD9iyAsyI7t66gKKw==
X-Google-Smtp-Source: ABdhPJziQ1M9E9LBF26vxpg73XufsSFetTyyHkqAqhghz8C78XmVMqBzB9xY9xQL6FX7tfOYT9/giuItOGwCZwAVsUg=
X-Received: by 2002:aa7:cdc3:: with SMTP id h3mr42108289edw.52.1609170579555;
 Mon, 28 Dec 2020 07:49:39 -0800 (PST)
MIME-Version: 1.0
References: <20201228124937.240114599@linuxfoundation.org> <20201228124942.316302285@linuxfoundation.org>
In-Reply-To: <20201228124942.316302285@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 28 Dec 2020 21:19:28 +0530
Message-ID: <CA+G9fYsekTQvNQQEGYi==s9Dv+NPOSEg4jzcyYdAAwpYAYtdtw@mail.gmail.com>
Subject: Re: [PATCH 5.4 106/453] libbpf: Fix BTF data layout checks and allow
 empty BTF
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Perf build failed on stable-rc 5.4 branch due to this patch.

On Mon, 28 Dec 2020 at 19:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Andrii Nakryiko <andrii@kernel.org>
>
> [ Upstream commit d8123624506cd62730c9cd9c7672c698e462703d ]
>
> Make data section layout checks stricter, disallowing overlap of types and
> strings data.
>
> Additionally, allow BTFs with no type data. There is nothing inherently wrong
> with having BTF with no types (put potentially with some strings). This could
> be a situation with kernel module BTFs, if module doesn't introduce any new
> type information.
>
> Also fix invalid offset alignment check for btf->hdr->type_off.
>
> Fixes: 8a138aed4a80 ("bpf: btf: Add BTF support to libbpf")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Link: https://lore.kernel.org/bpf/20201105043402.2530976-8-andrii@kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/lib/bpf/btf.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index d606a358480da..3380aadb74655 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -100,22 +100,18 @@ static int btf_parse_hdr(struct btf *btf)
>                 return -EINVAL;
>         }
>
> -       if (meta_left < hdr->type_off) {
> -               pr_debug("Invalid BTF type section offset:%u\n", hdr->type_off);
> +       if (meta_left < hdr->str_off + hdr->str_len) {
> +               pr_debug("Invalid BTF total size:%u\n", btf->raw_size);

In file included from btf.c:17:0:
btf.c: In function 'btf_parse_hdr':
btf.c:104:48: error: 'struct btf' has no member named 'raw_size'; did
you mean 'data_size'?
   pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
                                                ^
libbpf_internal.h:59:40: note: in definition of macro '__pr'
  libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
                                        ^~~~~~~~~~~
btf.c:104:3: note: in expansion of macro 'pr_debug'
   pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
   ^~~~~~~~

full build log link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-buster-lkft/346/consoleText

-- 
Linaro LKFT
https://lkft.linaro.org
