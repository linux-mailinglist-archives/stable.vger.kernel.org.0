Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD147327BA2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhCAKL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbhCAKL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:11:57 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE04C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 02:11:17 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id u125so13838930wmg.4
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 02:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MX15dBiXZcWyzGAvFkLUhEhdCV72/Xas5u1znK0dMvo=;
        b=rz8TKO5aIm0lGNGLoIJ6g2LZ6mkBp/InvHapV2RQ56HPWwABOPTeN1hP9F6GW3abf1
         msm/oDG8qqAN5B1Ol/NSv2NeilnG6cZN3qlkZ+zAb7ui4faJhHUZRZ53IY58qPyWYx5M
         5xtauoX7zVnWWHfg5oIAbYClCOmd3L/EXiezSG1CaeHx+l6rI9g2X4XqJX0sRQfLS+Wj
         QvzUmwMGuGQymH2WuaWea1J4sswrjU5BT+ixrk/UCruJZj9GJnXTSaLpABi2xWhtKuzU
         BzzFK6yM68L3aV9NcbN3T794EVrwrA4W1a22UzWXCgUH5wGbgCfEK5kZr59J1wN9rD1G
         Vtlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MX15dBiXZcWyzGAvFkLUhEhdCV72/Xas5u1znK0dMvo=;
        b=VOkdeP28W0GdJE7k7Y7bgCTyyQFnwEIor1GyL1E7jPwx5DXij1PZAVilS1Ln4UctGP
         KIXVj47Deo4iRTV5rAAOz3pP2uCRocgz6ErcUuXfWZnGn/lZx64vjoVtg2DIidRCjKZw
         Sb1fsiQQhMbnDIYQ4hlwdmV9j8jwjTGcTASqA79cChSSB6jobssv6aaTG6Ah94WbjRCw
         sF0Dcpu0uKaoiDHom0irPiPbO+/Q7c4vvIfQSERrrrTranzgjc6fk2IPhbgDPoM05fll
         Qn/cfepSANXFzRb1CB4aTTT88rbT5wMjVVUiBxQkiZqVnvdpqno/4/9DoS9yHAFo3Gao
         8DAw==
X-Gm-Message-State: AOAM533YMOO8kJ6gUyf3U85ICWfl+P7vKQqK9gTX5G5a+UOb6ucTxVeH
        HtlViC39lzjhfyEmENvbBqo=
X-Google-Smtp-Source: ABdhPJylH92j0+/cB/cJVh9sPvVbryZ/lnJ8NjoeB/vnuY9rnQ4t8z2WXNlKjurEyhPUUNxYtyJ4qw==
X-Received: by 2002:a1c:7301:: with SMTP id d1mr14910413wmb.33.1614593476136;
        Mon, 01 Mar 2021 02:11:16 -0800 (PST)
Received: from archlinux.localnet (80.142.94.90.dynamic.jazztel.es. [90.94.142.80])
        by smtp.gmail.com with ESMTPSA id l15sm8530242wme.43.2021.03.01.02.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 02:11:15 -0800 (PST)
From:   Diego Calleja <diegocg@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: -stable regression in Intel graphics, introduced in Linux 5.10.9
Date:   Mon, 01 Mar 2021 11:11:13 +0100
Message-ID: <1969510.QSeQnKm9EC@archlinux>
In-Reply-To: <YDyvNoiRAQwT4boR@kroah.com>
References: <3423617.kz1aARBMGD@archlinux> <1911334.sV3ZJath2r@archlinux> <YDyvNoiRAQwT4boR@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

El lunes, 1 de marzo de 2021 10:09:10 (CET) Greg KH escribi=F3:
> I do not see all 3 commits in Linus's tree already, am I missing
> something?
>=20
> What are the git ids that you are looking at?

I used grep on the git log, the commits are there but seem to have differen=
t commit ids (except for the first one)

commit e627d5923cae93fa4188f4c4afba6486169a1337
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue Jan 19 11:07:57 2021 +0000

    drm/i915/gt: One more flush for Baytrail clear residuals


commit d5109f739c9f14a3bda249cb48b16de1065932f0
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Jan 25 22:02:47 2021 +0000

    drm/i915/gt: Flush before changing register state


commit 81ce8f04aa96f7f6cae05770f68b5d15be91f5a2
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 10 12:27:28 2021 +0000

    drm/i915/gt: Correct surface base address for renderclear


