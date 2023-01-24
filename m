Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3E06796A4
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 12:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbjAXLbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 06:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbjAXLa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 06:30:59 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F152BF3A
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 03:30:59 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id i5so12975254oih.11
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 03:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=II4zNasgw0R1ombwNR2uePK5F3R1YPSv70GN5NEjLrg=;
        b=VQPxzRImD8bdkz2cq91DikhlyYNDJWu6/B+4KbrkyoKDyZn71TshvS+EOAfEDaBcTv
         F1YjRL7D/C/cRdlqm9v7MganVAJeX/FG4XzqN6RHkUf/wInyAaT1VsTu6aOlZyRjC8BC
         sV/E/nZn2KYgdmGwCnIi8rjRvXmp4Or3TzzSXb5topKrb0cKYUwaflIgJMxLqE2isDKo
         DK0bxzmJJ2vv8jhndgtcmOu8Jxy3C3k/NNYAOKVariHk7oasG56/PMTu+SsFxGKfqwko
         eN60mwl6GmnUQK9lSdzguuXGXLhetaeIdJJ6nFIHUVgUty7uRGyAwzjQk2T+Q7XnNMIh
         aV8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=II4zNasgw0R1ombwNR2uePK5F3R1YPSv70GN5NEjLrg=;
        b=odd2kYsU+jcjm/nTwhqPNTKl5fKoxBk21rysPidkacjxwnF4gopDCWgmC+82qwuSl1
         6mrWZWAS9QGXetiPb72/Y1LpWV/DtbdkaWRhxXizpXJYo2/MbHgVt9agE/GqfzOWjwN4
         GkjrwQUGtldOeSQKtWalAaDU/Ypl4YcSkVPhx0JQwYCwX+mM2HEdsYqchI4szNg+LqeR
         5MJzXH1lWz0kx9EhFAuPhbcsVTEXFiepZh7puEdLme1h6r/2Ve6gsBXifR2KbhWJL8e7
         0H2YsX9cMCVOC1K+uvfk1n7YwO65VfC3z/egW3GmpDS3BhwWTuCPmpDig4ohjvH452N9
         vLmQ==
X-Gm-Message-State: AO0yUKVdZ4PMtrdAE1hHwwQo8rKyWOk5HXRb2wymGnmoA4IdD98BhiDy
        qnMPkadKQf6J4a9QGK9IsVD6P565pId7wa6swWU=
X-Google-Smtp-Source: AK7set8RxHFDDCQHln2EJIyxCCUHpFR4FSps1AQUKKWMU2u36GHP8U4cbwuLmv0UKvE8kdVA2VN6dY6gSs+jW1C/AmA=
X-Received: by 2002:a05:6808:2124:b0:36f:18f:cdfb with SMTP id
 r36-20020a056808212400b0036f018fcdfbmr74160oiw.270.1674559858506; Tue, 24 Jan
 2023 03:30:58 -0800 (PST)
MIME-Version: 1.0
References: <CALFERdzKUodLsm6=Ub3g2+PxpNpPtPq3bGBLbff=eZr9_S=YVA@mail.gmail.com>
 <Y89n98fRfTpLmPUg@kroah.com>
In-Reply-To: <Y89n98fRfTpLmPUg@kroah.com>
From:   Sasa Ostrouska <casaxa@gmail.com>
Date:   Tue, 24 Jan 2023 12:30:47 +0100
Message-ID: <CALFERdyp9YoMLVtkE_HdhY1fSvLh=xm-RxDw-cFAXbrPkUBGMg@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Lukasz Majczak <lma@semihalf.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 6:09 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jan 23, 2023 at 09:44:34PM +0100, Sasa Ostrouska wrote:
> > Hi all, sorry if I put somebody in CC who is not the correct one. I
> > have a google pixelbook and using it with Fedora 37.
> > The last few kernels supplied by fedora 37, 6.1.6, 6.1.7 but also some
> > earlier have no working sound.
> > I see the last kernel for me with working sound is 6.0.18.
> > On my pixelbook this is showing in dmesg:
>
> Any chance you can use 'git bisect' to track down the offending commit?
>
Hi Greg, I never did that in my life, but I can try if you can point
me to some documentation so I can
try to put that together. I know plain git simple stuff like commit, diff etc...

Sasa

> thanks,
>
> greg k-h
