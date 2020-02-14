Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A4815F810
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 21:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389490AbgBNUtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 15:49:24 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38477 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389487AbgBNUtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 15:49:23 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so12459044wrh.5
        for <stable@vger.kernel.org>; Fri, 14 Feb 2020 12:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BG/k+1n242XmQ392+l/+QM8WpV3CVNW+mSgRrXUNaOk=;
        b=SarBqj+oUxptfwZyuPnoE9f5TdNLgDfCHQUMJ/hlsyT34Ix7OOciJH7CP+Ir3b2GzM
         9zb3YRPgjRMX5OrfVnsaU+NWX65BwvyfNy/jlvmnZvXwHmUhKJyKKN4i2ekuDyB+AUaN
         m0OvEgnVfVGPMiW73eqXyVcabZ6/knDSWdzPA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BG/k+1n242XmQ392+l/+QM8WpV3CVNW+mSgRrXUNaOk=;
        b=HiWDM6Qfccl7Nuh+gR+8BwG8qY3LcJrFWvpJixSrV0gW2s1Jk5Kgm9Ib8gFDcTlTjG
         BLx1ksxoaEWODEviMmHZ/Q20at9H0i4cBpDVerHq1jakTbzfdFTnO2Fo8viDDX57GSGq
         ATYQSY3lc0eh8GFDfQn9ER2FzAvZIesXOtwie+H7Yq8oazvt6OHDy5/KtEY+3yXd1uRi
         SCGYdMqJ55S7K2VS65A5yK02lajQEFCCOW/vFk5T8VxRSu6IRYwg2zx8C3K99DU8lo/B
         kJ/hL51/Apc6D4Tw04QDQ5DqZ7s6vjNbmZVBV5yL0Or0nvGsrufodxcO+QdUwKVbXAHv
         qkCw==
X-Gm-Message-State: APjAAAXDJc0q4SI4rbEWLgVFPYdgHMmaVkJua9IRd+i56A8Toh6B7EOx
        z5SSnC6CuWfjMJIZe1kYt6RPXQ==
X-Google-Smtp-Source: APXvYqxncTdduvArrIOwd2nDXfNPYclGCAutEyIXX9NPCJWgKiNMBPvLCR/gffpuMOaRVYxDiBFUkg==
X-Received: by 2002:adf:e74a:: with SMTP id c10mr6152109wrn.254.1581713361497;
        Fri, 14 Feb 2020 12:49:21 -0800 (PST)
Received: from [192.168.1.149] (ip-5-186-115-54.cgn.fibianet.dk. [5.186.115.54])
        by smtp.gmail.com with ESMTPSA id r6sm8400054wrp.95.2020.02.14.12.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 12:49:20 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 4.9 003/141] soc: fsl: qe: change return type of
 cpm_muram_alloc() to s32
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Timur Tabi <timur@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Christophe Leroy <christophe.leroy@c-s.fr>
References: <20200214162122.19794-1-sashal@kernel.org>
 <20200214162122.19794-3-sashal@kernel.org>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <a920b57f-ad9e-5c25-3981-0462febd952a@rasmusvillemoes.dk>
Date:   Fri, 14 Feb 2020 21:49:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214162122.19794-3-sashal@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/02/2020 17.19, Sasha Levin wrote:
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> [ Upstream commit 800cd6fb76f0ec7711deb72a86c924db1ae42648 ]

Hmm. Please note that these two autosel patches were part of a giant
48-patch series. While not all depending on each other, there are
definitely some dependencies, and between 800cd6fb76f0 and 148587a59f6b
there is e.g. be2e9415f8b3 which changes the type used to store the
return value from cpm_muram_alloc(), and a whole lot of other
cpm_muram_alloc() refactorings and cleanups - one of which
(b6231ea2b3c6) caused a regression on ppc 8xx.

So I think taking just these two might not work as expected, but taking
even more from that series is quite error-prone. Unless someone speaks
up and explicitly points out and verifies some specific subset of the
patches for a specific stable tree, I think they should not be added to
any -stable kernel.

[FWIW, we use the whole series backported to 4.19.y on both arm and ppc
platforms, but as the b6231ea2b3c6 case showed, that doesn't really
prove there are no problems cherry-picking these].

Rasmus
