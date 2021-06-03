Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652BA39AAC2
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 21:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFCTQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 15:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCTQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 15:16:44 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB0DC06174A;
        Thu,  3 Jun 2021 12:14:45 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n4so6945241wrw.3;
        Thu, 03 Jun 2021 12:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7WlxgnK3Hy0NaOBPDwd7/yzaX5VEvcgLMc5jo8u9ttY=;
        b=lzLW6rj3SC19SSaDWjiZ+TSbkWaCahYwKtlBaGRx+XwVd5KM1L7L6nkI+3oMaMMxXv
         JLWZ1/1F0DdMgVmII5qiXKuNcCsC/6tCtaRkSYFJ/beAxAA2y+7JuG4IiWiEXXIBRNji
         /uDSSy7FoyyssizQ1mZjPZY9gvR6Xfvj5pUvFYHVWonU9VEotzoC+ncTaQvLQwu5J4Mo
         WuiTcDj604+C0x4q8wvV7gDyc+9Vw9rO88e4twIDqMIavruExHh1s99v1qeIL9Teuzil
         ozTDNpTcEjGT0loV6pnRCKSakyFe3g66VE5seMXLUfBeiDF8WmT+SsoHuDgg39MKSlNj
         etlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7WlxgnK3Hy0NaOBPDwd7/yzaX5VEvcgLMc5jo8u9ttY=;
        b=D3fRuh+SJyXZ0y8s/ffEvkwqRmSpqkLwtteRYH/c+nKO4Ao1KxFLn1tXZKrTYKcW6t
         D4Btqnsh2tLaghoqRt8v1ck8yTI7iGpi9LzIxGp7geoGOGRed8RiHiv4R2S7URKcbtla
         dvq+QGr/wIbMUDvFU09mwfo1mRa8N2kC++gffulwgsd5NRBt25hkloQG4BOKD9tPxmiX
         g0EG4gJRg8nkLv+zBCbrCN33OxzN7lFGhBYANuVlEHXZ+ilLTRX5sbanKXKKmWEcbFoQ
         VUXXvra48stcu49AGdB5KTD1vwWKwMU7Ptcr2TgQlv67oTxngxw32wC3yb7cA53ugpsV
         v2GA==
X-Gm-Message-State: AOAM533lyNG9AHNQrNSW7XloLysyEM8dVi3fWzScNYNNIfbtN0MuxZtu
        OQrolrrKVNrAKK6me+vZgt8YrNdfwcfza8FUpNQ9RuLckDg=
X-Google-Smtp-Source: ABdhPJwvocth8yEQSq5B/0Xu78TGimiZgs37x8ZI+OnOaXA85xS6PVx+70viFpXwJFp7dPFg7aHMfY9bDhZYQGP+NaQ=
X-Received: by 2002:a05:6000:1089:: with SMTP id y9mr23891wrw.412.1622747683628;
 Thu, 03 Jun 2021 12:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210531130657.971257589@linuxfoundation.org> <20210531130659.215132273@linuxfoundation.org>
 <20210531202453.GA18772@amd>
In-Reply-To: <20210531202453.GA18772@amd>
From:   Nick Lowe <nick.lowe@gmail.com>
Date:   Thu, 3 Jun 2021 20:14:27 +0100
Message-ID: <CADSoG1u5HVSyo2+AxBVdaWguih8uZsLqnWXMZUZAnM5xc9C61A@mail.gmail.com>
Subject: Re: [PATCH 5.10 036/252] ath10k: drop MPDU which has discard flag set
 by firmware for SDIO
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wen Gong <wgong@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A follow-up patch would, I think, be needed to fix this for big endian
architectures.
