Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1475C15CD1F
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 22:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgBMVUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 16:20:07 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28461 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbgBMVUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 16:20:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581628805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nd779rjJsONnha1CIswBctC2c1f9Miaep8O18wB7j9s=;
        b=XWwFTbC/JM/I43goayFy+9CvAAD0Ryih/0thqNXFtb1g5c101S4y1jLmEzpnarDVXimRsk
        CbNbftmUhp59OFYtDb+IG+ftkLgS1yRBbGYv+OYyTv9cwtzD4ppB02Ob29cQ+4IiA1FFx5
        oZlZvHUdOp8M95rvVIwbbr+6YyXlwfk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-wLUyn-ijMrKuOIEDvb0zxQ-1; Thu, 13 Feb 2020 16:20:03 -0500
X-MC-Unique: wLUyn-ijMrKuOIEDvb0zxQ-1
Received: by mail-qk1-f199.google.com with SMTP id a132so4656433qkg.5
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 13:20:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=nd779rjJsONnha1CIswBctC2c1f9Miaep8O18wB7j9s=;
        b=RQvPvetUqui7P5a8GVuIof6qnCZSJvWAwPaFGo3tFD3vd+LgTUsKEyc3w5YZk0rYA8
         UQ+gcQ4cmHJGsn5UB2cuHmGxAUpYA38sRaEXRA3kfqCEKe/rFiobePDHaV9ZdWSylpHY
         xhxe6R3G75fkHUo+VezRv1JVooz+NLTdVDPPFLWT+TRQ85++Icq4JwlohVZT18qJnGc0
         7BHb4+QBL4V2RJ5iEM7EClmL2eP+tzzym+9Z6kgMCvLr4HT0kvclgfld52eqExWcjRE5
         n7YR1x76hBA7oUxlAlu3J7GFi/EIGG/J/ZJBkdVp/hdxdpf8FA1qbUl3T1yMLGJEfhol
         2WwQ==
X-Gm-Message-State: APjAAAU+k6HSZ0OTHweSwRVo2apzRAqxqgdxdykEZMWKmBMm2Cext/jP
        oD+nErAuvq3LZkA8iEt+dYz9TVcC9bpzNdeycco+6Ap1xrCXQzPfrWabwSVhvHH5q5F5U1LuenQ
        kPTreY7ngZeJ6vLfj
X-Received: by 2002:ac8:958:: with SMTP id z24mr60736qth.40.1581628802976;
        Thu, 13 Feb 2020 13:20:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqwq07stvU3W+5kKflBR0WXmBZX5FrGbpXEOMx9SFuQlv7tyH2CB4SCuup6TjVuHZ8uWTcjVmg==
X-Received: by 2002:ac8:958:: with SMTP id z24mr60722qth.40.1581628802660;
        Thu, 13 Feb 2020 13:20:02 -0800 (PST)
Received: from dhcp-10-20-1-196.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id k29sm2130684qtu.54.2020.02.13.13.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 13:20:02 -0800 (PST)
Message-ID: <1230bc3318ba49877264b02b91ff328fdbb82a54.camel@redhat.com>
Subject: Re: [PATCH 1/4] drm/nouveau/kms/nv50-: Probe SOR caps for DP
 interlacing support
From:   Lyude Paul <lyude@redhat.com>
To:     Sasha Levin <sashal@kernel.org>, nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Date:   Thu, 13 Feb 2020 16:20:01 -0500
In-Reply-To: <20200213173710.C8D1C222C2@mail.kernel.org>
References: <20200212230043.170477-2-lyude@redhat.com>
         <20200213173710.C8D1C222C2@mail.kernel.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For this (and all of the other patches in this series), we can just drop this
from stable. I need to send a respin of this series anyway so I will go ahead
and drop the stable cc from there.

On Thu, 2020-02-13 at 17:37 +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.5.3, v5.4.19, v4.19.103,
> v4.14.170, v4.9.213, v4.4.213.
> 
> v5.5.3: Failed to apply! Possible dependencies:
>     5ff0cb1ce253 ("drm/nouveau/kms/nv50-: Use less encoders by making mstos
> per-head")
> 
> v5.4.19: Failed to apply! Possible dependencies:
>     5ff0cb1ce253 ("drm/nouveau/kms/nv50-: Use less encoders by making mstos
> per-head")
> 
> v4.19.103: Failed to apply! Possible dependencies:
>     5e292e7646ef ("drm/nouveau: Remove unnecessary VCPI checks in
> nv50_msto_cleanup()")
>     5ff0cb1ce253 ("drm/nouveau/kms/nv50-: Use less encoders by making mstos
> per-head")
> 
> v4.14.170: Failed to apply! Possible dependencies:
>     07bbc1c5f49b ("drm/nouveau/core/memory: split info pointers from
> accessor pointers")
>     0b11b30de9d2 ("drm/nouveau/mmu/nv04-nv4x: move global vmm to nvkm_mmu")
>     11fc017dfb1e ("drm/nouveau/kms/nv50: prepare for double-buffered LUTs")
>     1590700d94ac ("drm/nouveau/kms/nv50-: split each resource type into
> their own source files")
>     269fe32d3343 ("drm/nouveau/bar: swap oneinit/init ordering, and rename
> bar3 to bar2")
>     30ed49b55b6e ("drm/nouveau/kms/nv50-: move code underneath dispnv50/")
>     34508f9d260c ("drm/nouveau/kms/nv50-: determine MST support from DP Info
> Table")
>     5b17f3624efa ("drm/nouveau/mmu/nv04: implement vmm on top of new base")
>     5e075fdeb166 ("drm/nouveau/mmu: automatically handle "un-bootstrapping"
> of vmm")
>     6359c982243e ("drm/nouveau/mmu/gp10b: fork from gf100")
>     698c1aa9f83b ("drm/nouveau/kms/nv50-: Don't create MSTMs for eDP
> connectors")
>     7f53d6dc9a72 ("drm/nouveau/core/memory: comptag allocation")
>     806a73356537 ("drm/nouveau/mmu: implement base for new vm management")
>     90df522912ac ("drm/nouveau/kms/nv50: use INTERPOLATE_257_UNITY_RANGE LUT
> on newer chipsets")
>     997a89003c2d ("drm/nouveau/core/memory: add reference counting")
>     b86a45877ead ("drm/nouveau/mmu/gp100: fork from gf100")
>     c83c4097eba8 ("drm/nouveau/mmu: define user interfaces to mmu memory
> allocation")
>     cedc4d57df26 ("drm/nouveau/mmu/gm20b: fork from gf100")
>     d1f6c8d2e9df ("drm/nouveau/mmu/gk20a: fork from gf100")
>     e1e33c791a23 ("drm/nouveau/mmu/gm200: fork from gf100")
>     e69dae85c90b ("drm/nouveau/bar/nv50,g84: drop mmu invalidate")
>     e75182f68b7b ("drm/nouveau/kms/nv50: use "low res" lut for indexed
> mode")
>     eaf1a69110f4 ("drm/nouveau/mmu: add base for type-based memory
> allocation")
>     f4778f08a038 ("drm/nouveau/kms/nv50: fix handling of gamma since atomic
> conversion")
>     f5650478ab07 ("drm/nouveau/disp/nv50-: pass nvkm_memory objects for
> channel push buffers")
> 
> v4.9.213: Failed to apply! Possible dependencies:
>     11fc017dfb1e ("drm/nouveau/kms/nv50: prepare for double-buffered LUTs")
>     34508f9d260c ("drm/nouveau/kms/nv50-: determine MST support from DP Info
> Table")
>     3dbd036b8419 ("drm/nouveau/kms/nv50: separate out mode commit")
>     52aa30f2524d ("drm/nouveau/kms/nv50: switch mst sink back into sst
> mode")
>     698c1aa9f83b ("drm/nouveau/kms/nv50-: Don't create MSTMs for eDP
> connectors")
>     6bbab3b6b656 ("drm/nouveau/kms/nv50: separate out base/ovly channel
> usage bounds commit")
>     a7ae1561909d ("drm/nouveau/kms/nv50: separate out lut commit")
>     ad6336195393 ("drm/nouveau/kms/nv50: separate out core surface commit")
>     f4778f08a038 ("drm/nouveau/kms/nv50: fix handling of gamma since atomic
> conversion")
> 
> v4.4.213: Failed to apply! Possible dependencies:
>     13a3d91f17a5 ("drm: Pass 'name' to drm_encoder_init()")
>     34508f9d260c ("drm/nouveau/kms/nv50-: determine MST support from DP Info
> Table")
>     52aa30f2524d ("drm/nouveau/kms/nv50: switch mst sink back into sst
> mode")
>     698c1aa9f83b ("drm/nouveau/kms/nv50-: Don't create MSTMs for eDP
> connectors")
>     a7ae1561909d ("drm/nouveau/kms/nv50: separate out lut commit")
>     ad6336195393 ("drm/nouveau/kms/nv50: separate out core surface commit")
>     f4778f08a038 ("drm/nouveau/kms/nv50: fix handling of gamma since atomic
> conversion")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
-- 
Cheers,
	Lyude Paul (she/her)
	Associate Software Engineer at Red Hat

