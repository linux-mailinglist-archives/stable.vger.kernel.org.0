Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C35C771DD
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 21:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388429AbfGZTJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 15:09:00 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:32989 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387570AbfGZTJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 15:09:00 -0400
Received: by mail-qk1-f193.google.com with SMTP id r6so39878101qkc.0
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 12:08:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=Qb1+vbELQhwoE9sQvpjeKsKKHLnCMT4wIYjW7XVS9cM=;
        b=B97whWxbIN3dUwiPACNq8wOlzZBJ6KSmnml4P58YVB4Uvj4kgmrgibHv2sl+hFMSpi
         DqtQAQq0/LiaB12t+Etovvmfl1fluV/kh1O15+vVmKg+mVnD01mYAocyLw9zQ4JGCZVP
         CUrBl2XSn+5ROL5b8CF0zOkjLBhCg8HAwoKQ2xdqLQMGDxM7d11idsN6iq888ZaCVh8y
         T6feJJpdocN3TqFujzwmUlkC2yBoK53RhC04dA5lHYQyIMeklKDsXKx6tU8OT8Omv2NT
         TCJVy4DIaRS6KGM5yHQYhr6BGoSvY+ZwH7L87lkBEdEXY+aMJoP9e0kmJ3LXoUiVaJO+
         ssQQ==
X-Gm-Message-State: APjAAAU3HRbKhSao8rOYuemiATj/wJkrnVmO7K5HF2DdOsIl8EUjBE+a
        NFS+HaZt5Pui2RSdsRMu2voYJA==
X-Google-Smtp-Source: APXvYqyuM7wOcBTjeScSuO9H8vXIDps5SKi+kY5qcdZ/phats8pct/QoxMip1HIFc4UfQT0gm5y/Og==
X-Received: by 2002:a37:afc3:: with SMTP id y186mr63596351qke.115.1564168138843;
        Fri, 26 Jul 2019 12:08:58 -0700 (PDT)
Received: from dhcp-10-20-1-11.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id z21sm21581263qto.48.2019.07.26.12.08.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 12:08:56 -0700 (PDT)
Message-ID: <f86af078c7024c2285641386e2b6f1d255d9dbca.camel@redhat.com>
Subject: Re: [PATCH 2/2] drm/nouveau: Don't retry infinitely when receiving
 no data on i2c over AUX
From:   Lyude Paul <lyude@redhat.com>
To:     Sasha Levin <sashal@kernel.org>, nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Date:   Fri, 26 Jul 2019 15:08:55 -0400
In-Reply-To: <20190726141715.A6C48218D3@mail.kernel.org>
References: <20190725194005.16572-3-lyude@redhat.com>
         <20190726141715.A6C48218D3@mail.kernel.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-07-26 at 14:17 +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.2.2, v5.1.19, v4.19.60,
> v4.14.134, v4.9.186, v4.4.186.
> 
> v5.2.2: Build OK!
> v5.1.19: Build OK!
> v4.19.60: Build OK!
> v4.14.134: Build OK!
> v4.9.186: Failed to apply! Possible dependencies:
>     1af5c410cc0c ("drm/nouveau/i2c: modify aux interface to return length
> actually transferred")

skip v4.9
> 
> v4.4.186: Failed to apply! Possible dependencies:
>     1af5c410cc0c ("drm/nouveau/i2c: modify aux interface to return length
> actually transferred")
>     2ed95a4c65a3 ("drm/nouveau: recognise GM200 chipset")
>     7568b1067181 ("drm/nouveau/nvif: split out display interface
> definitions")
>     7d2813c437a0 ("drm/nouveau/ltc/gm204: split implementation from gm107")
>     db1eb528462f ("drm/nouveau: s/gm204/gm200/ in a number of places")
>     e3d26d086092 ("drm/nouveau/ibus/gm204: split implementation from gk104")
> 
> 
and skip v4.4

> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha
-- 
Cheers,
	Lyude Paul

