Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C58335A76D
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 21:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhDITxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 15:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhDITxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 15:53:51 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C93EC061762;
        Fri,  9 Apr 2021 12:53:37 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id e34so1546622wmp.0;
        Fri, 09 Apr 2021 12:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cienTRetHjRyjvTz16vPQOBc3RysjFVWSWHBMB/qjQM=;
        b=vB0/Jtv7OF1fSZaJQwEqxhFxMSpwm9jNwaKFLYKH6biqi077VIBztfo/33NoJSkfi+
         kZY/4cMPoVTRqSo0IH3La8qD+C1SSRml0Nyk0Nbfv+5ZPj7qPbDJfoFBQwKhw1UILHhY
         gSDzLhHDX/dQ+dVHeGl+nWRmHX0QXPHY94KvhHOJCWfOT/sETeJyVVFYuqGU+85fekCD
         U60ukz2Z53XlqXtUmO35z8KSxnVYgSEtOZfzVyX1wEnc6nmzgeqYDROFz5e7Wt3Vl4kY
         +gN2J9nb2AfTDQd9ekjZmHMhGHymraiwv/cllRepa1nPsc9iN5GxNi1dAWv0eWv4izfA
         Jwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cienTRetHjRyjvTz16vPQOBc3RysjFVWSWHBMB/qjQM=;
        b=ImrhrQ9yP89YYD8jFgY5C/TeJr+INo3ZS6QAkKIC0RZjRMHWcGfrPukakgvlFBY6pe
         R0P4IP6ywGf2gTqjAB0/WwrGH68VBOtzqbcodfv/HvbYCeCQVG2IPfd9PCsg4QSqPwN/
         HynrCQW2g9+4H0Dk/HshoZ2bJ4axjbaxwShkwo7RnDrewoxCc3rJ/QghTD0YG5UPONBM
         UlhWTmjMPiOxTf+a4zoiVugORcJ3iRQOpeqjKM8N9ALV3P2m2yyQOn0F/PQscNz/KgpN
         bcMmepdDdjAqcDIo/XtHO0BwG9idY7IQKnzv8obwYCCRLEbMq91vqmDm8TfW+yj5Futg
         z/7g==
X-Gm-Message-State: AOAM530gB/3mMjjwVOwR55C+vhu/mO7Or+qTahBxh1yXlAr7126cR+Tl
        Fp5znWZO8ZI0/leAHniE2iw=
X-Google-Smtp-Source: ABdhPJwjbm4kmtHZZqeYumEDgTxdPAc9ewLNfqcCaNKYNPwj857KaGE+p/8NqT929EPlktMFFRw9ww==
X-Received: by 2002:a05:600c:16c3:: with SMTP id l3mr15194244wmn.110.1617998016110;
        Fri, 09 Apr 2021 12:53:36 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id h8sm5948040wrt.94.2021.04.09.12.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 12:53:35 -0700 (PDT)
Date:   Fri, 9 Apr 2021 20:53:34 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 5.10 38/41] bpf, x86: Validate computation of branch
 displacements for x86-64
Message-ID: <YHCwvvHDe8osg7LE@debian>
References: <20210409095304.818847860@linuxfoundation.org>
 <20210409095306.041350244@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409095306.041350244@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Apr 09, 2021 at 11:54:00AM +0200, Greg Kroah-Hartman wrote:
> From: Piotr Krysiuk <piotras@gmail.com>
> 
> commit e4d4d456436bfb2fe412ee2cd489f7658449b098 upstream.

And, this one also. I am unable to find this SHA in Linus's tree.


--
Regards
Sudip
