Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D0724B3C1
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgHTJwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729872AbgHTJv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:51:58 -0400
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB7ED2078D;
        Thu, 20 Aug 2020 09:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917117;
        bh=k8bHNWPEvo8AEqebY8y2/WT7UgwuSqcajPAFIHA45aM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=dTL5NQR/x6e3RqXFaRPGx9zUtnOwtdtSB/9GlC1z2H5M+Lnp3rf2Lpq5qkOajhQZL
         hcbYhFjzGcHaDmKJLNPV2aheslT2/aIJsqe4wO/CZWSc9pySpd1aW38cwmkoNtz+Wv
         xbEowmOQVT5fTeSXpp5kkNG+RC5mFxTRtBvrFMUw=
Received: by mail-qt1-f171.google.com with SMTP id s16so743059qtn.7;
        Thu, 20 Aug 2020 02:51:57 -0700 (PDT)
X-Gm-Message-State: AOAM531jPxBC39Lb0YgviNypwnP3iqsO4cLIKuwhnttfk1G39PtRuhYr
        YNh4cys+auVh8jMY3DaVClclFRyJ7vJHIxG9cew=
X-Google-Smtp-Source: ABdhPJzhapaxSj4V8NhsKO88U5UOzo8ejbnz1E/FhRIpVkbie7D2Zb4ypv7T7anhTEDZxHMKp8nG6pWRn2Bf+vaXCns=
X-Received: by 2002:ac8:5354:: with SMTP id d20mr1950917qto.120.1597917117096;
 Thu, 20 Aug 2020 02:51:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a0c:efc2:0:0:0:0:0 with HTTP; Thu, 20 Aug 2020 02:51:56
 -0700 (PDT)
In-Reply-To: <20200820091619.460392380@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org> <20200820091619.460392380@linuxfoundation.org>
From:   Johan Hovold <johan@kernel.org>
Date:   Thu, 20 Aug 2020 11:51:56 +0200
X-Gmail-Original-Message-ID: <CAMgPeKX54WqE0Wc56u6W3M2JwttV=E7sBKmM5eRa5_Mu7m+okg@mail.gmail.com>
Message-ID: <CAMgPeKX54WqE0Wc56u6W3M2JwttV=E7sBKmM5eRa5_Mu7m+okg@mail.gmail.com>
Subject: Re: [PATCH 5.8 137/232] USB: serial: ftdi_sio: fix break and sysrq handling
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This was never intended for stable as it is not a critical fix and has
never worked properly in the first place. Please drop this one and the
preparatory clean ups from all stable trees.

Johan
