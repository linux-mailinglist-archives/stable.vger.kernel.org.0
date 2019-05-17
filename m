Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B29821C54
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 19:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfEQRUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 13:20:18 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:33657 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfEQRUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 13:20:18 -0400
Received: by mail-pl1-f169.google.com with SMTP id y3so3658438plp.0
        for <stable@vger.kernel.org>; Fri, 17 May 2019 10:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Cy6EU6RevmtdEuidmGiho3CGseD99MMaVvLLi5iY4rk=;
        b=QEvKKGxquZQCNjmEEWdt2uottYV0hhiE3JD/SlApzlnI3rYWAGIghxEBVtk4M59k5f
         DD3u72ON8Hbuj5ahPeEaeDaRcngHK0nv4eBFewu++tNfoYWhNr5EwN7OfNP+yqrVZQxU
         YtblTTscS0eunqLrvGz6PEEbyeqqnliyptPBLT9QPwTxpxa4hgpBQFG/b09CI+udZmkn
         peMWeeI69XwIlcQJBxMxyH0/zFafp3fF72NwfIqpZRp8AfudKnVNXfz3bvmyc3GHWpLQ
         kBrEb8xtxkZ4jvWOC+uNl5S4YHFBIQvFVQWRpVjIbMUqrPm+31ZiOZgcVV/Ikc+zT6os
         ks+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Cy6EU6RevmtdEuidmGiho3CGseD99MMaVvLLi5iY4rk=;
        b=rb0THVDMp14XTbSTIbxBhFkczvfvYb3NTPA88qhAp5vfTPEy2RKpKTaoxm8+WM/6Fz
         fgimdK8r7YarI5a/ghcWph3RuSqPd1mtkEW3k5/jYakgTiMaMYmvGmD4Kt7F1FyjoZUH
         /mlYwRUtJpA7TgI/9ESUm4RWcKNe1fQ0FwU8tCOshBEtmEwEJCdAjsmR/CxjoGu4NYtJ
         iMXHxW0o+0PqIpK1k9XV4+uq2ky8l1sgW1GKRAkUiTSmRqn1vonJwIwBAK53Pufcy8Ou
         GJsGLPgd5wCO1vBLRBgCr2q9wft4YMaF32i51c58J6J6EdPWHQBF6XfsHBKRoPIVTdOV
         dFFw==
X-Gm-Message-State: APjAAAULpVfxSCSKk18mdbHn1cjeyezoYoQk7J3TvAYy54xGtMk3jWXn
        y+XZkqgz2NE/rSHVvsTnq0+xdQ==
X-Google-Smtp-Source: APXvYqxF9pmYrB/7pMMBl2ffYzNFZzGSdCYVqGLWuylAr4xCoitUQjLMEoK9HkqvvUsNzlwzr3PzCQ==
X-Received: by 2002:a17:902:b204:: with SMTP id t4mr6916122plr.285.1558113617396;
        Fri, 17 May 2019 10:20:17 -0700 (PDT)
Received: from google.com ([2620:15c:201:2:765b:31cb:30c4:166])
        by smtp.gmail.com with ESMTPSA id f4sm10852202pfn.118.2019.05.17.10.20.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 17 May 2019 10:20:16 -0700 (PDT)
Date:   Fri, 17 May 2019 10:20:12 -0700
From:   Eric Biggers <ebiggers@google.com>
To:     gregkh@linuxfoundation.org
Cc:     herbert@gondor.apana.org.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: ccm - fix incompatibility between
 "ccm" and" failed to apply to 4.14-stable tree
Message-ID: <20190517172012.GA223128@google.com>
References: <1558096328102192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558096328102192@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 02:32:08PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 6a1faa4a43f5fabf9cbeaa742d916e7b5e73120f Mon Sep 17 00:00:00 2001
> From: Eric Biggers <ebiggers@google.com>
> Date: Thu, 18 Apr 2019 14:44:27 -0700
> Subject: [PATCH] crypto: ccm - fix incompatibility between "ccm" and
>  "ccm_base"
> 

Why did this fail to apply?  For me it cleanly cherry picks to 4.14 and later.

- Eric
