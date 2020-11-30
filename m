Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596282C7C81
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 02:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgK3BlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 20:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727721AbgK3Bk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Nov 2020 20:40:59 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECE6C0617A6;
        Sun, 29 Nov 2020 17:40:19 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id 62so4898601qva.11;
        Sun, 29 Nov 2020 17:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Mf3BHYJFhhPZ5jtSzDsvclX5TqImvx8XVzPvevCF5NQ=;
        b=MPG4lnqMDmKNgBlDFyv+v2Lzc46T3j8R+AXeOCgQZ0CWUljDjufr1/BmOY+eupwfuF
         8JNYYF6pHEJ6edTAXcoS50TlpCU5/FD2EQRMFcWoVf+PGtSl833lteLQCzttgsq8dDwX
         Hg1zcTbr9pRM2k5HUf7qwqdBLfkp/LtxiYMlK5ve1UKkUGIJ1RsJm2/VlXWiEsI16wjJ
         KuHAVzcc7cVD4mmmAe1x59vUxskdPb2CH1+17jkOYDmPy74qLNBW82MndDhKF/6Xt+uy
         XtTmK8QSQIICHFBgDrf+l2ZGAI85dTT5fBBpnyykaDZGUiz1GM0LnBolQf0pMvV1QH2f
         TSLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Mf3BHYJFhhPZ5jtSzDsvclX5TqImvx8XVzPvevCF5NQ=;
        b=nsjd02bQuW6ejJg06wqe9xz3IFb6QhI0wzib/oQByeaxyYvfrDhuGsmh6q0Qi+f1EC
         HyKr9UV9jyVniHm3syku0YcmDkyOay/JusrfIlis1dI7vJOP/O3cwwg7q2s28xwanzPl
         OjQHEGf39ax8fXuiH/kK6fEJIwfYlx42tMxy54BEFmQNFp7a2sd+fVr/HGU4IeNQFQcg
         Z8D8RumoebkGIV8P6FkyOP5iUUNGpt8nqkdV14oX76G3HS13gIS6wxumnhLfub6WOPN7
         g4yw0iqn8HZ3hsU8yVunRikY/S5NPSoXiRKtqvh1WjF4JPeUbDSxIaPN3cgyUR/SoaXj
         XcJg==
X-Gm-Message-State: AOAM531xCSf2PlRFLzDB1Gk4gV9y2+xrkYgVhFTSv7flKUEuQXhWZrUq
        4DURO5bw3fifoYO4KYZ6PZOtvDmysnE=
X-Google-Smtp-Source: ABdhPJx/kMKCcRoPsI/lNglBliqIcazfzGXD+cqkhxdHQk0c1Y+0HiaU/rgC4Of1+BSOLXnIxD7Mtw==
X-Received: by 2002:ad4:4e30:: with SMTP id dm16mr20048743qvb.47.1606700418616;
        Sun, 29 Nov 2020 17:40:18 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id s11sm14200967qkm.124.2020.11.29.17.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 17:40:18 -0800 (PST)
Date:   Sun, 29 Nov 2020 18:40:16 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Lukas Wunner <lukas@wunner.de>, linux-spi@vger.kernel.org
Subject: Apply d853b3406903a7dc5b14eb5bada3e8cd677f66a2 to 5.4 and 5.9
Message-ID: <20201130014016.GA1980658@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha,

Please apply commit d853b3406903 ("spi: bcm2835aux: Restore err
assignment in bcm2835aux_spi_probe") to linux-5.4.y and linux-5.9.y as a
fix for commit e13ee6cc4781 ("spi: bcm2835aux: Fix use-after-free on
unbind"). I did not realize that commit was tagged for stable so I did
not tag my fix accordingly, sorry for not noticing sooner.

Cheers,
Nathan
