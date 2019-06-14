Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCB946C34
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 00:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbfFNWKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 18:10:24 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34815 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFNWKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 18:10:24 -0400
Received: by mail-qt1-f196.google.com with SMTP id m29so4308020qtu.1
        for <stable@vger.kernel.org>; Fri, 14 Jun 2019 15:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=shVnPlPeCTcmlWwFA6ZYR0wKoPt2Nj6+3KOOVZWPU6Q=;
        b=C5aim2cDQPMci7ikQ2XhEgNUsgJoHGnLv+gy1vtbsmQZgtNimHjPP3auidc+mbTR0T
         5w+WVnY5oImcwWnsYCANiHU/4awB01y4+G7IYKW8IPIclQpELUj081D0PsF6fb8XO1P9
         FeT/LIY0C2cWLqN2R/GuxvsySI+fh6pEEe2jwCf6phWJvBakomGdc9TBLhhuSRWgpGkN
         wyTeluUxnMQRS3ocVQ88IBzsepPypbYBM9Kq/sRhDecYeS/qLidt9RhMKVLAcOIq/Rye
         WuVJ7siaJok6jV5SV56U3fY3ADZ2SVoMaUcUI8XfFlOpsA8JWMiTDwKCSwqsyn9ngk7G
         Z2hg==
X-Gm-Message-State: APjAAAVUKkqu825T9BMxmv91rsJxP+k4NwXd0t+KeSOqa8lxuUlkcgyc
        u0xa1wLYhNMnk0IY+3Se9m2tFA==
X-Google-Smtp-Source: APXvYqwMGOA/q06WBinCIWlUW7M/1VZCEHjqAglHG+shefsYrXf4mL7mBVYyp+1OQAdgd64bYneBqw==
X-Received: by 2002:a0c:b39e:: with SMTP id t30mr10413103qve.212.1560550223146;
        Fri, 14 Jun 2019 15:10:23 -0700 (PDT)
Received: from wlan-196-102.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id k33sm2156581qte.69.2019.06.14.15.10.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 15:10:22 -0700 (PDT)
Message-ID: <90274aca8c1b785caf9e3732e8b56e501e573a1f.camel@redhat.com>
Subject: Re: [RESEND PATCH v2 1/2] drm/dp/mst: Reprobe EDID for MST ports on
 resume
From:   Lyude Paul <lyude@redhat.com>
To:     Sasha Levin <sashal@kernel.org>, Juston Li <juston.li@intel.com>,
        Lyude <cpaul@redhat.com>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc:     clinton.a.taylor@intel.com, stable@vger.kernel.org
Date:   Fri, 14 Jun 2019 18:10:20 -0400
In-Reply-To: <20190614215644.8F9D821874@mail.kernel.org>
References: <20181024021925.27026-2-juston.li@intel.com>
         <20190614215644.8F9D821874@mail.kernel.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

uh, Sasha not sure if you're a bot or not but this patch isn't even upstream

On Fri, 2019-06-14 at 21:56 +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.1.9, v4.19.50, v4.14.125,
> v4.9.181, v4.4.181.
> 
> v5.1.9: Build failed! Errors:
>     drivers/gpu/drm/drm_dp_mst_topology.c:2672:9: error: implicit
> declaration of function ‘drm_dp_get_validated_port_ref’; did you mean
> ‘drm_mode_validate_driver’? [-Werror=implicit-function-declaration]
>     drivers/gpu/drm/drm_dp_mst_topology.c:2676:9: error: implicit
> declaration of function ‘drm_dp_get_validated_mstb_ref’; did you mean
> ‘drm_mode_validate_size’? [-Werror=implicit-function-declaration]
>     drivers/gpu/drm/drm_dp_mst_topology.c:2684:3: error: implicit
> declaration of function ‘drm_dp_put_mst_branch_device’; did you mean
> ‘drm_dp_get_mst_branch_device’? [-Werror=implicit-function-declaration]
>     drivers/gpu/drm/drm_dp_mst_topology.c:2715:2: error: implicit
> declaration of function ‘drm_dp_put_port’; did you mean ‘drm_dp_get_port’?
> [-Werror=implicit-function-declaration]
> 
> v4.19.50: Build OK!
> v4.14.125: Build OK!
> v4.9.181: Build OK!
> v4.4.181: Build OK!
> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha
-- 
Cheers,
	Lyude Paul

