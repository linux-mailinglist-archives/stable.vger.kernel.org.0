Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C114D4D43C6
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 10:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240902AbiCJJwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 04:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiCJJwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 04:52:49 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0749813AA15;
        Thu, 10 Mar 2022 01:51:49 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id l2so9781062ybe.8;
        Thu, 10 Mar 2022 01:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rHM4k9qHE05y6ea8wtU5exWoKwljZBPkN0DLGx/Ohgw=;
        b=niLTOpPRlsHPtgE/EvJEefYFiup4QpN5ukYkwSwyNZNJTeRHhk80EiNtPwwJ9tUtnV
         ApdKX1gkHTkhPUybhzY15Fb7+drPGiY9RXevCYYIAq/HnVyPP/UpGGN5m4ztry8NNTa/
         kZje4Jbf337fp8ashmQj7gunS3xSl3arbDXc+nz7ErjDummW9oEa/tO/BpHjyoxl3Aje
         S8ccGTLA2QoBo0dQMiYV8/IWW3wSL3rajKbT+84+XHPlfpFInMklSKyGw1FzK9v1b1bb
         Wl92WY+i+9GZXP2+tg4iVCtyVEA4Wgakli3jR7794UVK0fWlUkBvfbjQUM80rfb70M3Y
         J56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rHM4k9qHE05y6ea8wtU5exWoKwljZBPkN0DLGx/Ohgw=;
        b=bKKOyrhOBiZf+/l4fFPmir+KuMPenSTXiay+g3/fkQO3KhRFzRIty3jCmq4tWrK33w
         sknhxasFcF5bbxmZtR7M+oGI4ZUVybD3l0q6uu9bmE93tB+yzG/PlPzR12J2aHdUCyOj
         OALGMuumedUFyY+irAvuPQcQeNsOwl6mTxGm9ZLForU4sf3fBhvj/VF/OiEl0NjAaGIg
         IDrKbhL26kBywUKumKKyxvUcRaapXn+4oPVX2oZfk5oWKPPPHasuX7uUOGdaG0K8L806
         f1pmsKy5ZSxR/TdOOSuHdkavNgSLQCigaXDZ3BnIh0KbehuwVELFs4leWim5Er+gXSbf
         jSDw==
X-Gm-Message-State: AOAM533Zk3EyCx44A/bnCH/aD1VE7SKxmqP073W2x5CN3fkGcx/52lMk
        l4b0436Vxr+Vc7+lbj25gsX+Ra9dIobu0Nfmtzk=
X-Google-Smtp-Source: ABdhPJyZWrR7XgK4c+xJLhs09HQxqfmEyaewcW3morQ0vxX23+qrNwpMzGfW08bf4l/e79/kLnT0bf63+Obl78P5Rao=
X-Received: by 2002:a25:7504:0:b0:629:308e:9d95 with SMTP id
 q4-20020a257504000000b00629308e9d95mr3190433ybc.106.1646905908227; Thu, 10
 Mar 2022 01:51:48 -0800 (PST)
MIME-Version: 1.0
References: <20220309155856.155540075@linuxfoundation.org> <CADVatmMODnr1vQ3VGLOACT16wLEFA6hFrTzY44VdPO2M7gX+iw@mail.gmail.com>
 <Yijw3wz29xNiIhWl@kroah.com>
In-Reply-To: <Yijw3wz29xNiIhWl@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 10 Mar 2022 09:51:12 +0000
Message-ID: <CADVatmMbww0jVS7O9BmtrGzfyBN0hfm8n7QNEdZpiigJGSp20Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/18] 4.19.234-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 9:18 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Mar 09, 2022 at 06:08:19PM +0000, Sudip Mukherjee wrote:
> > Hi Greg,
> >
> > On Wed, Mar 9, 2022 at 4:03 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 4.19.234 release.
> > > There are 18 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> > > Anything received after that time might be too late.
> >
> > My tests are still running, but just an initial result for you,
> >
> > x86_64 defconfig fails with:
> > arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
> > arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of
> > function 'unprivileged_ebpf_enabled'
> > [-Werror=implicit-function-declaration]
> >   973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
>
> It's in a .h file, how can it be undefined?  Must be a include path
> somewhere, let me dig...

Looks like the problem is that both "static inline bool
unprivileged_ebpf_enabled(void)" are in the "#ifdef
CONFIG_BPF_SYSCALL" section of include/linux/bpf.h.
I think the one returning false should be in the #else section.


-- 
Regards
Sudip
