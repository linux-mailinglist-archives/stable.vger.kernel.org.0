Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B441515CD15
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 22:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgBMVT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 16:19:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56273 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727772AbgBMVT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 16:19:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581628765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qeytvoYSh96I8mtSTlSSduno0MzSFAndk4/HpJXIggQ=;
        b=JAQCSoWXBsjyu+BuBw6I+9rwLbdq5orvMqLg+cWbmJ703XDikDKnuaK3K4aCCUiaCaipF4
        h5a32fUM9KCqCM7WYnj5JMFpolCxRvTDmGmM7FWzUZ9VbR6QEA1tSXplgSEyAoBifGPX1z
        4BMQ3lLz2lQtRp9ys0ZR9f3mvaIm3n4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-m7UJ5riJPtKG-moRykWRpg-1; Thu, 13 Feb 2020 16:19:24 -0500
X-MC-Unique: m7UJ5riJPtKG-moRykWRpg-1
Received: by mail-qk1-f197.google.com with SMTP id v81so4633037qkb.11
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 13:19:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=qeytvoYSh96I8mtSTlSSduno0MzSFAndk4/HpJXIggQ=;
        b=AIfrX5mvZRnZbrbBQ2cVCUIxQcwQg0shv7n2sPtxGbLiOTMDaefk/9J6jApxZdx5gn
         /JORi1eRzKUR298LRYYxLn5Q8bIrEP39G7lVt6fou1XZFwDp2R1/phbFaAAVdvhpNWKS
         mYqYkfK/xN9RnaAM5VKGU1pr2SY+qbVHtVjazurYZ3Uw8F9WqBR9zyur4YIovDnSKSLo
         weYVwWD07ouVTQoq20C8lGqNcmIpELBSINqLMLncp0NTTB1kl9dURNo2i/IrcQa19HBl
         E7HRkHUvWYGntGYjsyYl+MxfzUgSdo56lKB6aCHKA1eAzCVs2Aoev/6L02C/9n+Etws8
         DiUA==
X-Gm-Message-State: APjAAAXqz6WHhyIanALDjp8AIerypSgCKe9eHJFbgW8yzQSYIjX6V8bX
        4RytDyUYb2Um3hz4WR3CsQMJtobvNhxVDqchz5Ut9lnMJnmumSchjDx7b/Dqs8WkC4VPkm8dRjD
        v/vRkuorbl8pDLcZg
X-Received: by 2002:ad4:5009:: with SMTP id s9mr25210820qvo.30.1581628763484;
        Thu, 13 Feb 2020 13:19:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqzCmwC9yQ4A7PXjkJND1n6vE/oKPj8aI5adAYbhOPDc4vtyT9di5NVjr8sdOtwipFJs2QsKhw==
X-Received: by 2002:ad4:5009:: with SMTP id s9mr25210801qvo.30.1581628763216;
        Thu, 13 Feb 2020 13:19:23 -0800 (PST)
Received: from dhcp-10-20-1-196.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id i13sm1989297qki.70.2020.02.13.13.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 13:19:22 -0800 (PST)
Message-ID: <ca9cf8a812f4dabcfd74d66c1170c31e97f9c7b9.camel@redhat.com>
Subject: Re: [PATCH] drm/nouveau/kms/gv100-: Re-set LUT after clearing for
 modesets
From:   Lyude Paul <lyude@redhat.com>
To:     Sasha Levin <sashal@kernel.org>, nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Date:   Thu, 13 Feb 2020 16:19:21 -0500
In-Reply-To: <20200213173705.3FD89206ED@mail.kernel.org>
References: <20200212231150.171495-1-lyude@redhat.com>
         <20200213173705.3FD89206ED@mail.kernel.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-02-13 at 17:37 +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: facaed62b4cb ("drm/nouveau/kms/gv100: initial support").
> 
> The bot has tested the following trees: v5.5.3, v5.4.19, v4.19.103.
> 
> v5.5.3: Build OK!
> v5.4.19: Build OK!
> v4.19.103: Failed to apply! Possible dependencies:
>     88b703527ba7 ("drm/nouveau/kms/gf119-: add ctm property support")
>     cb55cd0c66a1 ("drm/nouveau/kms/nv50-: allow more flexibility with lut
> formats")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Apply it to 5.5.3, 5.4.19. We can drop the rest

> 
-- 
Cheers,
	Lyude Paul (she/her)
	Associate Software Engineer at Red Hat

