Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6255D1F5EF7
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 01:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgFJX7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 19:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbgFJX7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 19:59:15 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CD5C03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 16:59:15 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id i12so1490007pju.3
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 16:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4edtY8Eu1VUmzgyb4H4wtL7jgrBQx9lKt9GvBevXky0=;
        b=Q2hiuBNl7DimjrdUYi2ooAqqm4AG294p/VhSD8VWon1zlD4FN+T7CqBIvuU+tAPo/n
         A7HiMrppp60xP71Odaw+Jva2OGKXnQJod1tjL4bMVvUJOQtjK19guU/wYL2SBk+OsaOz
         uBKVw7hg6ph0XBUK9ZaaoHWiVwyVX/SJzxmHI1+FaimjCdOwW2oZNVCBLHXNfpXrasEE
         aP6JTy1ErH7qDrOzP+TeiJRre55Bwepi0d+0W66zW5V5uy2jkUUr4LBxz2518Ony4nte
         dHHhC0DpgD9FtxjTYIQhkBvjMEoUIspu6APfXiGrJyWIR9JUSa/KVleqbcWsh7SO+7rW
         UV6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4edtY8Eu1VUmzgyb4H4wtL7jgrBQx9lKt9GvBevXky0=;
        b=NWp6y40NkjMQ2uTyT6mj/IWQIJzFvMwFWaAD9EpddXdXYyrIAsQeWZY9k8UxVzH+Uf
         QRH6TeS+nfcr7kg570eXTyMJ4u/FhCjjHSAlaqWsxdZ1VmxfjAmLoJduy9iOcwA7/kVf
         pFPUu0ZjmdlGKOhTmG9me/h/T+CwAcuO+vAoBytm0Sr3ZcqInug19nfXTNFjXWAvWJpR
         7WRgHTKDoelHzmy6xcsvDsY4Ki38u4iyY8I+RIl2xuExSqCvkAMwDkov7cMFG8ZwAyGs
         IRtkclHEdLUmJsHWFKxtSkdBpJLmm+BuQxAq6ZMSnTTf526IQjuUKM4uIN/85zD+/g8e
         dr8Q==
X-Gm-Message-State: AOAM530uDG19i8wW14/Vzbdn0yq23Z6c3AFlPOObSGjpUk+5BRNMagyB
        g7zwz8teUgtdYAf1y/D25ndc5RlwRMs6h9c3NGZKbw==
X-Google-Smtp-Source: ABdhPJzBiALWimXmEW/mrhw43KwXhxgyZkKVK+Dabqx+aTDniNroIF5EBR89dM6Rf6ozB+g1fmHgY98CXWePtJkj/68=
X-Received: by 2002:a17:902:fe8b:: with SMTP id x11mr4939244plm.179.1591833554874;
 Wed, 10 Jun 2020 16:59:14 -0700 (PDT)
MIME-Version: 1.0
References: <CA+SOCL+ntBRGoA2qttMo=bt_VVKJMm8GEq+bfEoVvgq-j-Y1KA@mail.gmail.com>
In-Reply-To: <CA+SOCL+ntBRGoA2qttMo=bt_VVKJMm8GEq+bfEoVvgq-j-Y1KA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 10 Jun 2020 16:59:03 -0700
Message-ID: <CAKwvOdnC_fKbVLB=q=BZt8gk9arPhEar4c_6ab9KUhfW1V3=Hg@mail.gmail.com>
Subject: Re: Cherry pick 51da9dfb7f20911ae4e79e9b412a9c2d4c373d4b
To:     Jian Cai <jiancai@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Luis Lozano <llozano@google.com>,
        Manoj Gupta <manojgupta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 1:42 PM Jian Cai <jiancai@google.com> wrote:
>
> Hello,
>
> @Nick Desaulniers  made a patch (51da9dfb7f20911ae4e79e9b412a9c2d4c373d4b=
) and it was accepted to mainline as part of ClangBuiltLinux project to mak=
e the kernel compatible with Clang's integrated assembler. Please consider =
cherry picking it back to 5.4 so that we can use Clang's integrated assembl=
er to assemble ChromeOS' Linux kernels.

This would be helpful for us in Android, too.  Seems like CrOS might
beat us to the punch in enabling LLVM_IAS=3D1.  I'm looking to do so for
Android later this year after Android 11 ships, depending on whether
5.4 is a supported kernel (I suppose so, not sure of the plans in
relation to mainline).

>
>
> commit 51da9dfb7f20911ae4e79e9b412a9c2d4c373d4b
> Author: Nick Desaulniers <ndesaulniers@google.com>
> Date:   Thu Jun 4 16:50:49 2020 -0700
>
>     elfnote: mark all .note sections SHF_ALLOC
>
>
> Thanks,
> Jian
>
>
>
>


--=20
Thanks,
~Nick Desaulniers
