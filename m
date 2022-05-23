Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0DF5312F5
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbiEWP2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 11:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbiEWP2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 11:28:54 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B549F5EDF6
        for <stable@vger.kernel.org>; Mon, 23 May 2022 08:28:49 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id f21so15925542ejh.11
        for <stable@vger.kernel.org>; Mon, 23 May 2022 08:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XPtsde4gyVo6IJJ2lowRrIJoC9Wl+ngKLvBmCGRosYU=;
        b=he+tcNDA7ndcB7CTw1/DbteaPV0BHHiyChBmUWVYsesTwE4FheIylI/Ktcls1XAOlf
         c3S5t0KEqwBQX9JX4xwIfmleuXXuktbt4EvMIBFVITv7lFRQo4UOVcfh4sYWfMSwx9Pi
         U2Dez6pyB/M7lY0SPdYD6E202dPvVrynR4EtREr2cRXWjYjShDZHRqFQwkQ451aIjm1g
         Yj5vbsF95Iiz1OewX+nUFxpPzlIUW6/66w8OnTPgzJ5PEuG+8FETwydWbBNjSzQ3FzWM
         QBmel4mAnWj99UCYFVXz3muSbptC2IMAtsA0FLB+90gYv5Oqsq65HubkW3/YlLk27+Tn
         Wvog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XPtsde4gyVo6IJJ2lowRrIJoC9Wl+ngKLvBmCGRosYU=;
        b=hAdCAwxU2btDcvqk98r+6mzg6uVVxfhflqLLjS7yzdug7odHk0t9kQY6Wq73Nk/UPl
         5p7f31ezCKqOMSSpMP6tdF6jw/PXI9z3Zuu2IJZY+G9DQ5bluqoVLuhODW3kHH1WfsFr
         YjnUk3d2hTlfG/gJn6y97cMjcp223N4MubMvK/93CBpKlrRyxNEt5sHeD3A6eK5J5xiP
         nKUkaXx5NTlky5QIubg34hUwU+0YU/yyY/2ehNnvYZWZCMpXWzLc8ZjHWWfoK1zEQ3Mh
         uuY4ZTtaHyI/Shp65Y+11xlWs/6/Tfr0H41PcVUOUppSU5DxUByQ4VwTun5dd4S93AIA
         YsHw==
X-Gm-Message-State: AOAM5307VQvL2WrZyPBI9aYu0o+vGD042tIO5L1IIn2lkoMHPq7W+6eJ
        V9cjYtD+346idEhpXt3knRHtOXS4/p1cjCRE
X-Google-Smtp-Source: ABdhPJwrxiEWnwMCc46nqTyw8Rb4U7FGGn9Q/ughz/Boi6eJRPID9+ui33r690dogZXwncyyksQf1g==
X-Received: by 2002:a17:907:6d97:b0:6fe:f9e0:c03f with SMTP id sb23-20020a1709076d9700b006fef9e0c03fmr1908505ejc.219.1653319728245;
        Mon, 23 May 2022 08:28:48 -0700 (PDT)
Received: from ntb.petris.klfree.czf ([2a02:8070:d483:ed00:4bcc:154f:5c11:5870])
        by smtp.gmail.com with ESMTPSA id b18-20020a056402139200b0042ab87ea713sm8285753edv.22.2022.05.23.08.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 08:28:47 -0700 (PDT)
Date:   Mon, 23 May 2022 17:27:48 +0200
From:   Petr Malat <oss@malat.biz>
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Joern Engel <joern@lazybastard.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mtd: phram: Map RAM using memremap instead of ioremap
Message-ID: <Youn9AmqY6/EExDw@ntb.petris.klfree.czf>
References: <20220523142825.3144904-1-oss@malat.biz>
 <3cab9a7f4ed34ca0b742a62c2bdc3bce@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cab9a7f4ed34ca0b742a62c2bdc3bce@AcuMS.aculab.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On Mon, May 23, 2022 at 02:51:41PM +0000, David Laight wrote:
> From: Petr Malat
> > Sent: 23 May 2022 15:28
> > 
> > One can't use memcpy on memory obtained by ioremap, because IO memory
> > may have different alignment and size access restriction than the system
> > memory. Use memremap as phram driver operates on RAM.
> 
> Does that actually help?
> The memcpy() is still likely to issue unaligned accesses
> that the hardware can't handle.

Yes, it solves the issue. Memcpy can cause unaligned access only on
platforms, which can handle it. And on ARM64 it's handled only for
RAM and not for a device memory (__pgprot(PROT_DEVICE_*)).
  Petr
