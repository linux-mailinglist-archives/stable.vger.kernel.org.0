Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B682EA10E
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 00:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbhADXp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 18:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbhADXp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 18:45:59 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B64C061795;
        Mon,  4 Jan 2021 15:45:18 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id g24so19747298qtq.12;
        Mon, 04 Jan 2021 15:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JKcn5FmVjtdLgYOASDjA00unBiKKTt/1fSkBmrjqn/k=;
        b=smDa0LCh0CtK3FPXBCvVYU5au0IgoTV9ZqbIsKji2U3SNxrn/aj0vutIcewQymx3Mb
         W9v07PzwjXozdxnqRC/vzLotXbn7UpdWsAlqyVWaOsad7bTyrpZF6EaqaPtH13HQ/edC
         zA3oqeTdKchms0BLPbxq3o16nenTLV1mtSUsTBMFfl/MCNyFz+UU5aIt2h4SFQfg0ngU
         LULvahbuuDaEQcgSbcKa2nVE8iksNlze9whsRw0u8g5Wr1SVh4Uel31twcrB0Eeyis4r
         x93YTs/JwUzelq1tFE1g/cGEkMJhaZU/K0p/J9qAbw6nVnznpJDLUk6n1SPnh6aYX9Rd
         t7EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JKcn5FmVjtdLgYOASDjA00unBiKKTt/1fSkBmrjqn/k=;
        b=f80bnQD6za7usciREDRNQ8e58tDZQouLjwzzAeuvDfsU1ViftSG5uM+Nc9yxHVqm2o
         gGtuKOyDAKO3NmgtB5/KZFa4WFp2Fs0c4jB5ZVLMHUhk52QB4Tzz0SrSKLBOTT/KdU0K
         o/a9JNMOqbdFKMRIbJibqoZL9C8Wp4To5cw8P61y/Sm9eE61VHdVGlosvOhCr9lnm4Tq
         9OUMhEP7q+D0Ds9WTg5IOVlQzJgdF6xsJ+QI4BQMImp23grAR8V0H3pCRpb8rhwR687/
         W8Ci2rZXFIfaNVsWRg3XkMmmp8fBL7PrA1bif4dQDTHyPx1QL2/fNKgbT74ERsxYz4iT
         T3Ww==
X-Gm-Message-State: AOAM532wYsHQ4c+LfNMmMe7IZ2qXC3Ez7kKkwbHlar+Gm+s3MLZwUliK
        pMIrUjyXPwUx8iAE6bawpDFPa6fpCpI=
X-Google-Smtp-Source: ABdhPJxIId7YInUzi9s1MpexjtDdKWYEXgaBPVTOj1ys7xu3LTGaj1flIjv6myZeew4CJ1r0mdSuhA==
X-Received: by 2002:a05:620a:4db:: with SMTP id 27mr74435319qks.431.1609793854321;
        Mon, 04 Jan 2021 12:57:34 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id a22sm37490512qkl.121.2021.01.04.12.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 12:57:33 -0800 (PST)
Date:   Mon, 4 Jan 2021 13:57:32 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] powerpc: Handle .text.{hot,unlikely}.* in linker script
Message-ID: <20210104205732.GA1398664@ubuntu-m3-large-x86>
References: <20210104204850.990966-1-natechancellor@gmail.com>
 <CA+icZUVe4AJoLWMqS3MEx700jcwDaJhw78tUgg8iD0dJvEmmYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVe4AJoLWMqS3MEx700jcwDaJhw78tUgg8iD0dJvEmmYg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 09:55:20PM +0100, Sedat Dilek wrote:
> On Mon, Jan 4, 2021 at 9:49 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > Commit eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input
> > sections") added ".text.unlikely.*" and ".text.hot.*" due to an LLVM
> > change [1].
> >
> > After another LLVM change [2], these sections are seen in some PowerPC
> > builds, where there is a orphan section warning then build failure:
> >
> 
> Looks like you forgot to add your references/links to [1] and [2].

Indeed, thank you for pointing that out! v2 coming shortly.

> Might be good to mention...?
> 
> With CONFIG_LD_ORPHAN_WARN=y is enabled

Since this symbol is not user selectable, I do not really think it is
worth mentioning, plus PowerPC has had this enabled for a while :)

Cheers,
Nathan
