Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2908641137D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 13:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbhITL1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 07:27:04 -0400
Received: from mout.gmx.net ([212.227.15.19]:33593 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230138AbhITL1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 07:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632137126;
        bh=B9gwt7sLGXtN17LhF++FdY8VbX/w+lp9LunStPlAZXY=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=HbNAJCaO3Axz49sDiw9+qcwm0iQ8n9C/pN7aUBwl+uoE5WMz6ZYQJPwFdVCr7hvIR
         6awzxXujC+74Wiz2ZhlPabLMX0b5ek9aXmBxbBUuPy4hHIw9Z8X8E/aTK5023RlhyW
         Y1mY0tv+FmfnDSZmF/AfGcZ2qF9c0d98WtTi7838=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.fritz.box ([185.191.217.45]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N1fis-1mqVIs0m0e-01242Z; Mon, 20
 Sep 2021 13:25:26 +0200
Message-ID: <65a61ffdb4c8090320ec98fe5004e6f7808fa4b9.camel@gmx.de>
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
From:   Mike Galbraith <efault@gmx.de>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        marmarek@invisiblethingslab.com, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org
Date:   Mon, 20 Sep 2021 13:25:25 +0200
In-Reply-To: <YUhTwPhva5olB87d@linux.ibm.com>
References: <20210914094108.22482-1-jgross@suse.com>
         <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
         <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
         <YUdtm8hVH0ps18BK@linux.ibm.com>
         <fc21617d65338078366e70704eb55789a810e45e.camel@gmx.de>
         <YUhTwPhva5olB87d@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:iEjsRv4P4g2ovFM2mp8YyGLSbNjPNeyq9zmAqZMjWIj4gvzRgSx
 rxdywpB0+EybMYOQlSL7qeyYsN0KUzPPSOyFKSiR1/8UaKnC1i9Rvsi/DUnBJRowepgwwqJ
 lKaS3A+gfX3wM9TMD5IgkSvjc0en8MU6akzJ2ueUY4+2qEXYCZl0tnlbkKYHPMD/yx/bnM+
 BOoBQIEDrgYCepkSwp9Sg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1iQ9fo7eVS0=:CxIg8wjRkFSEpwjNEm9TOD
 uxvjEhYhzmMGeSV/uiAIC/MN2iCQnnVfzS9AuvffyGkdtNNF5qrOoXsT1pOdLJxkluQI69jZk
 sPpChKLxxhKo4gdneu1FYxfOg6TLZQxq0l7zVhLAaGT2SXl0rGZ+cAzG/YgCQBclettjZBb7e
 apunpDwxhwSBzVwTD6KzWyVKabqmziiVboXjVb45nT+6aE2W+YVI/5C6aCyAFLVY1wEn/32k+
 2xn++RYr9SivED/OPl6XkFgH+Q7sqc+n9C3zC58DOYJ5o7AavD4XrLqLJqjXrwEZmOo0FTQij
 CmKhXWHwcC3p0jycscFptflz2+R7PR+LpdXbEdzc4ydzMTJuMrAP+Qoaxy4hbSUjRVm/i838S
 YdC/hOK5KEguw9p+lfxe9CmCT74Prf7/G+LTqexs+EoJfFUiuBywYwf9ZWRp1asVJFvfcC0ED
 25UAkcC7X+rSRMRYuchIMtGkLhwC3LuPxOTqvYBmj4KGlk3o0h9t4nYM7oILfo6V0WaKPWVJe
 qL9diHJEHQrbRSEc9hzyfsH0s0iPR3RMIYsr7F6XZoq8XqbDB0N8bYirQSlrxPV3D8+OhPHYh
 VlM5HOtKW6qFCnigIkW3BiK4JQ54s7L5748EBzupblB36OD8Z6nMn2p6h/OTijoXXnBMJbdrQ
 GWpanUxLZ784SUE0PWZIDPy6qImMe6kARgNCzhKG46D3LTfPapMOo9Dmfi3Y2T2ikeFtsiasl
 J/vdHAM+v2j8l/2KN+2zQKaBFHiuWbvK/WxUdjSWYQawVseHXNzAQXUabrFny9o2Hsc6CN8sC
 Z4sePR01+w9DMe4InKhelpYptmNXji/NKAMe8G8s9hhCR+qRe88PABUuo/EN1zgYTN1XhM9yy
 uOeCZjjarAeunFVWmp/Kvt61YUwaUvmthFe46W+4gZxauANUK7oA57pQAqrnQltneP5yRgGDL
 rxVnCHFeQg2EXhYDK6gDxFpT1RTEzl7ofsQfkcQnPjN2xf3sB+sWMshAK6nDcecATxgT8fFim
 uVzD+3MACH6tVDNlvjF9AgGnDwXCYXlyy3cvOV1QLlmB6lQSoq0hRbTrPr4g4/rziOjMdyILk
 9BQZyIxTrH6Whc=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-09-20 at 12:26 +0300, Mike Rapoport wrote:
>
> Can't say anything caught my eye, except the early microcode update.
> Just to rule that out, can you try booting without the early microcode
> update?

Nogo.

> And, to check Juergen's suggestion about failure in
> memblock_x86_reserve_range_setup_data(), can you try this patch on top o=
f
> the failing tip:

Yup, patchlet detoxified it for both boxen.

> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 25425edc81a4..78162d9e90cf 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -716,8 +716,6 @@ static void __init early_reserve_memory(void)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (efi_enabled(EFI_BOOT=
))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0efi_memblock_x86_reserve_range();
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memblock_x86_reserve_range_se=
tup_data();
> -
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0reserve_ibft_region();
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0reserve_bios_regions();
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0trim_snb_memory();
> @@ -888,6 +886,8 @@ void __init setup_arch(char **cmdline_p)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0x86_configure_nx();
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memblock_x86_reserve_range_se=
tup_data();
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0parse_early_param();
> =C2=A0
> =C2=A0#ifdef CONFIG_MEMORY_HOTPLUG
>

