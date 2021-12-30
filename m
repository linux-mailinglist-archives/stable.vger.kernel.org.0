Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DDB481D12
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 15:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240113AbhL3Ob3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 09:31:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39518 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240081AbhL3Ob3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 09:31:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A059C61693;
        Thu, 30 Dec 2021 14:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D43C36AEB;
        Thu, 30 Dec 2021 14:31:27 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FKLZMqhu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1640874685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lHuXjtnGIwA8Zzr3bT7RPQh03xIe4TvMRJ0gk9Qtcas=;
        b=FKLZMqhuokoESY8wJ/omRu/I40BEBHLrMytOZNT//9lPzWrwiGIWsV17qNmSnkYIdFFvF9
        g3ly3f428jJtnra1CUuEQ7qs//Gle01vXxtaAO/9vzOmCM47VkvuC8xnmaGVM3VAYJbXin
        ehSayO9zdecrFpPKMnbSFB1WA3TMRj0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6dc71350 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 30 Dec 2021 14:31:25 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id d1so52248012ybh.6;
        Thu, 30 Dec 2021 06:31:24 -0800 (PST)
X-Gm-Message-State: AOAM533NzUFg0qzO4n37ei8FC7ywT2F33zcc513lxbs2ElhdiPDnc6rN
        DtXMbuulDiIxAsv5CklP7QesCUb7MZlEeioe/Pw=
X-Google-Smtp-Source: ABdhPJw9KXMQERmH/AgSSTou5UkCs5Uy/S9nTRKuLwfn7THmpg0Sfs4j17G+75dELBDtmoarZXCcEx1k3gpmtt9ZCg4=
X-Received: by 2002:a25:1e83:: with SMTP id e125mr38695115ybe.32.1640874683924;
 Thu, 30 Dec 2021 06:31:23 -0800 (PST)
MIME-Version: 1.0
References: <20211228153826.448805-1-Jason@zx2c4.com> <20211229211009.108091-1-linux@dominikbrodowski.net>
In-Reply-To: <20211229211009.108091-1-linux@dominikbrodowski.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 30 Dec 2021 15:31:13 +0100
X-Gmail-Original-Message-ID: <CAHmME9oYy3NYaPuni+Q0BgrRVN+VH8vFpKeOTqBXg8q0pBrFfw@mail.gmail.com>
Message-ID: <CAHmME9oYy3NYaPuni+Q0BgrRVN+VH8vFpKeOTqBXg8q0pBrFfw@mail.gmail.com>
Subject: Re: [PATCH v8 1/7] random: fix crash on multiple early calls to add_bootloader_randomness()
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Ivan T . Ivanov" <iivanov@suse.de>,
        Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Applied, thanks.
