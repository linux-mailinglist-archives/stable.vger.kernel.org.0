Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB2B32744E
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 21:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhB1UGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 15:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhB1UGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 15:06:30 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C481BC06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 12:05:49 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id w7so11668927wmb.5
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 12:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dWVBoZRuq7mTfadSRGePj84wl37X9sEueBfkpRpUOh8=;
        b=g2xSrFWIeL6b2uFVWv6tkU2MuVY/AqT+WeUq8ix9OD+b6KXHoxI9KAWF/Bg7IaiRe6
         m5EH9EZFOXK9G2BGwefYNKv1mXoDNS6pv1m43AfP3BTyGWzmHCSJXQAjAdfC0viU8sQi
         XijaQXx9fleyatklK7nqaLDEykvzO2isBTHZcXh7TX0azkd8YdUSnlXVC9qR0SsV7b11
         SiD3c6oavTKsPDKDz42JgtxaCnu74F+K/2KqR7Y+T5JYYBIgeV3BGfYWJFeDjgviDIPW
         uYsE5KXN6LBey7pIS14MmZCZ1vxxFQP3u70L2PjUv2yEYjyGJzoWqvvuRNwMiuN97iLX
         pnqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dWVBoZRuq7mTfadSRGePj84wl37X9sEueBfkpRpUOh8=;
        b=cNNEhcQJReiLfx0IAGR5M1etyidFQAwWGcOt45W0t7Mj5IsCuaJoGhyMsXwxT9qpUb
         9XUBRZ/U3rEbGDbjJMCpDU0gnCnm1fiXdU9/n+6m7EWRp9YObG1H4IVgqclZNH4NrulL
         AzwlTMCyNVWOjLWnF8UfA8xUvYqR8CwujErF+V6rlTtj3Yfh2kocGOwHxYs63d4NHAWm
         DdRb42eWEttbpsA1601RTCjRzh6jYVXlh9i5vyszBmqS9/OPZAO7OaU+0s6hwDh3u8fU
         LRyWoPyCn51XrLwEM7/tqtoBX3xKx93ljvG6dyxOZyDVWC8BG9Jja2+ZGAxtKl99HvZE
         xiuw==
X-Gm-Message-State: AOAM533ccEEGRYP3/6+wixZM5c5fJ8ut+oO0l0+/YhkDbLq96oqmp1eV
        DJGBRFlzNz0mt296n3V5rbQXpQO19AE=
X-Google-Smtp-Source: ABdhPJwURWrom/4l/wV8bSRkMZxcathM8dQ5BtHmdOwsW2K3E9/OzD2zddnFna3pjnZWD6aZgKr3Gg==
X-Received: by 2002:a1c:f30a:: with SMTP id q10mr12688651wmq.159.1614542748564;
        Sun, 28 Feb 2021 12:05:48 -0800 (PST)
Received: from archlinux.localnet (80.142.94.90.dynamic.jazztel.es. [90.94.142.80])
        by smtp.gmail.com with ESMTPSA id n66sm19968862wmn.25.2021.02.28.12.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 12:05:47 -0800 (PST)
From:   Diego Calleja <diegocg@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: -stable regression in Intel graphics, introduced in Linux 5.10.9
Date:   Sun, 28 Feb 2021 21:05:45 +0100
Message-ID: <1911334.sV3ZJath2r@archlinux>
In-Reply-To: <YDuzbvIjMO5mFcYm@kroah.com>
References: <3423617.kz1aARBMGD@archlinux> <YDuzbvIjMO5mFcYm@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

El domingo, 28 de febrero de 2021 16:14:54 (CET) Greg KH escribi=F3:
> Is this the same issue reported here:
> 	https://lore.kernel.org/r/f1070486-891a-8ec0-0390-b9aeb03178ce@redhat.com
> ?

I just tested current mainline (which already contains the three commits me=
ntioned in the bugzilla),
and the problems have disappeared.

Regards.


