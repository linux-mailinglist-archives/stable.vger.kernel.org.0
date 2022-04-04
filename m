Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E97F4F1EAB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 00:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbiDDVxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382988AbiDDVci (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 17:32:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D77211F
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 14:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649107401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DfDyjcnnLyc2bSZ6jJAVhGllQHcKHgp84LgGIl4EXgM=;
        b=O/xKp+aaN01eINcwTDKyUl7NxBl5p8xF0gD53R5bsy6IveDGmG5wJhuJ1FY8pX4TQNnSEF
        BY09Z92CyZkTnant4pRtPKTIUgibfxGkyCJmn0gXOYOxJiI5fG7nh7tryVBjjLADr6vDDe
        zS0WUN6tlzAVqVXbH0JbuJGTUYEs2KE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-lu6fI0TMP6S35VSZoxKcNg-1; Mon, 04 Apr 2022 17:23:20 -0400
X-MC-Unique: lu6fI0TMP6S35VSZoxKcNg-1
Received: by mail-qk1-f199.google.com with SMTP id 195-20020a3707cc000000b0067b0c849285so7105575qkh.5
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 14:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=DfDyjcnnLyc2bSZ6jJAVhGllQHcKHgp84LgGIl4EXgM=;
        b=blxW0n5vbEBomgXkxYDBmB3Z22G2pHT3u4wMKAdsxeT+NEJRYozWJPWDe44CPjL5mc
         DSW8jv6tnUb/lGyjPU+J3yXfxOAKmolsQlKDv05oSIPxeCsvkxCU0fYlFe14IfeQrqc6
         1dsjxNgO6uQBPtz5DX2roNvs6Dq/YoJAEbfQ0eDtA1730hUZ6Fa76lU7xQHmfr5n40XJ
         2IWTA/XrVHNYF2Q/binaGz2hNDgTRLRSjshdAnX7COPvTxce7RL7keOPuc0uhHhiIPvi
         s1Fai2emRlLosrSy6H238jZmhmLAUYPF5WjTGSwXVvQN8tbV0HLPg+M6cXBLhyZi6bIW
         M42w==
X-Gm-Message-State: AOAM5337CauxGsEz/fekDuvha/VPAhUZ7WUHC4ftgqt0fwF+y8i+whGh
        cinJD1IX71c81ND2XR0BI7tP5MI5JmFjrfusqZ2LolT+uf4plvVCI6fxZUfksCB/cI+VXd0MK+W
        sMdh/pIjMjBPUkyip
X-Received: by 2002:a05:620a:2487:b0:67b:3113:f83f with SMTP id i7-20020a05620a248700b0067b3113f83fmr179302qkn.604.1649107399546;
        Mon, 04 Apr 2022 14:23:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwA/j5T9RBShOaLAqidOK7ozpdzXqamqb+Gc1f+d2xjbvub/SnKUIk0rJFYk2A/f+j9+SQqNg==
X-Received: by 2002:a05:620a:2487:b0:67b:3113:f83f with SMTP id i7-20020a05620a248700b0067b3113f83fmr179283qkn.604.1649107399340;
        Mon, 04 Apr 2022 14:23:19 -0700 (PDT)
Received: from [192.168.8.138] (pool-71-126-244-162.bstnma.fios.verizon.net. [71.126.244.162])
        by smtp.gmail.com with ESMTPSA id x6-20020ac86b46000000b002e02be9c0easm8354800qts.69.2022.04.04.14.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 14:23:18 -0700 (PDT)
Message-ID: <74509d19d84b879b624fa9f40bc8186fd09e750a.camel@redhat.com>
Subject: Re: [PATCH] clk: base: fix an incorrect NULL check on list iterator
From:   Lyude Paul <lyude@redhat.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, bskeggs@redhat.com,
        kherbst@redhat.com, airlied@linux.ie, daniel@ffwll.ch
Cc:     martin.peres@free.fr, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Mon, 04 Apr 2022 17:23:17 -0400
In-Reply-To: <20220327075824.11806-1-xiam0nd.tong@gmail.com>
References: <20220327075824.11806-1-xiam0nd.tong@gmail.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.DarkModeFix.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This should probably be prefixed with the title "drm/nouveau/clk:", but I can
fix that before pushing it.

Reviewed-by: Lyude Paul <lyude@redhat.com>

Will push it to the appropriate repository shortly


On Sun, 2022-03-27 at 15:58 +0800, Xiaomeng Tong wrote:
> The bug is here:
>         if (nvkm_cstate_valid(clk, cstate, max_volt, clk->temp))
>                 return cstate;
> 
> The list iterator value 'cstate' will *always* be set and non-NULL
> by list_for_each_entry_from_reverse(), so it is incorrect to assume
> that the iterator value will be unchanged if the list is empty or no
> element is found (In fact, it will be a bogus pointer to an invalid
> structure object containing the HEAD). Also it missed a NULL check
> at callsite and may lead to invalid memory access after that.
> 
> To fix this bug, just return 'encoder' when found, otherwise return
> NULL. And add the NULL check.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1f7f3d91ad38a ("drm/nouveau/clk: Respect voltage limits in
> nvkm_cstate_prog")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
> b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
> index 57199be082fd..c2b5cc5f97ed 100644
> --- a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
> +++ b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
> @@ -135,10 +135,10 @@ nvkm_cstate_find_best(struct nvkm_clk *clk, struct
> nvkm_pstate *pstate,
>  
>         list_for_each_entry_from_reverse(cstate, &pstate->list, head) {
>                 if (nvkm_cstate_valid(clk, cstate, max_volt, clk->temp))
> -                       break;
> +                       return cstate;
>         }
>  
> -       return cstate;
> +       return NULL;
>  }
>  
>  static struct nvkm_cstate *
> @@ -169,6 +169,8 @@ nvkm_cstate_prog(struct nvkm_clk *clk, struct
> nvkm_pstate *pstate, int cstatei)
>         if (!list_empty(&pstate->list)) {
>                 cstate = nvkm_cstate_get(clk, pstate, cstatei);
>                 cstate = nvkm_cstate_find_best(clk, pstate, cstate);
> +               if (!cstate)
> +                       return -EINVAL;
>         } else {
>                 cstate = &pstate->base;
>         }

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

