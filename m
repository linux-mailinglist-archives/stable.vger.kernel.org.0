Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CA0518964
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 18:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbiECQPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 12:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239206AbiECQPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 12:15:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BE4625292
        for <stable@vger.kernel.org>; Tue,  3 May 2022 09:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651594291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wp9YHmXDYvM0vTO+lxeqnR+ljJmF4tJFHnGldB3QeSU=;
        b=HErmi5Tpoq5TWb1e+uFvevz2ou2hG2d0jEoaSMtnDPGDK0hUuQobpNE7EheSaqIHzxXv8R
        kTbxvJChKdkfO1strbXRW3nz47OY6kw5jMmt4UvujHdiSVQXtKdP5uOhHqIThHekxe6U79
        yBi22RJgTHW+PGTwVQj/wq1fnLv/wBM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-f6rhiNxYNPe2GH_VsGVZzQ-1; Tue, 03 May 2022 12:11:13 -0400
X-MC-Unique: f6rhiNxYNPe2GH_VsGVZzQ-1
Received: by mail-qt1-f200.google.com with SMTP id w2-20020ac87e82000000b002f3a6e81a56so4570196qtj.14
        for <stable@vger.kernel.org>; Tue, 03 May 2022 09:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wp9YHmXDYvM0vTO+lxeqnR+ljJmF4tJFHnGldB3QeSU=;
        b=TK5/tkimxGqixzSIq4AFHybsZIiZkqPxtUaUNwBiEqkCechmsvtmpG09YUmfgKyT8L
         G/2RXRaRbKMJ8cINMyPoi1Lm8aoROcdPQc7LptKwS5CcRg0TeRHMP34W3IrzPuNT4ypE
         HYaD0d+8iSAtNQk340zfmabllK6HhbDwkW2JJsaw85M6S4MLDHgR27wOqdtqx6uV2jcm
         nV+02T1GP+13HEdNYVGJz6RLBKVen3sDA6XZMbyDEFMHUM2VwQ6Q85SXhaK+Jj9Ia1pZ
         Qp7qvVlNEd3BbEOWFvfigIMLc52srKPrY/cEKwz+pbgAvdBYgD81awXQit2J9lz8Kfjg
         dTow==
X-Gm-Message-State: AOAM531q6D18O4++uLm/qelg9czA6BHzdBdESaY+uPUaNv00VEV8oogs
        QpSZ+cw4WeAx9uf8H4IWL9lblY6UyGoDlfSubF79Y2Rkwoc04upsbfIAOLqiZJ1UzWKyUEmXuKl
        dQixb26yZ04KOLUJO
X-Received: by 2002:a05:6214:1c8a:b0:443:bc78:25ef with SMTP id ib10-20020a0562141c8a00b00443bc7825efmr14197037qvb.2.1651594273449;
        Tue, 03 May 2022 09:11:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9Rhyqa7jIDuuJrIMnnrirw3u18xc4X+9oWAePPIds5Soeh/PXfrbwcmifKRoacw+7Ubd3rA==
X-Received: by 2002:a05:6214:1c8a:b0:443:bc78:25ef with SMTP id ib10-20020a0562141c8a00b00443bc7825efmr14197011qvb.2.1651594273166;
        Tue, 03 May 2022 09:11:13 -0700 (PDT)
Received: from x1 (c-98-239-145-235.hsd1.wv.comcast.net. [98.239.145.235])
        by smtp.gmail.com with ESMTPSA id f22-20020ac84716000000b002f39b99f679sm5846102qtp.19.2022.05.03.09.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 09:11:12 -0700 (PDT)
Date:   Tue, 3 May 2022 12:11:11 -0400
From:   Brian Masney <bmasney@redhat.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qcom-rng - fix infinite loop on requests not
 multiple of WORD_SZ
Message-ID: <YnFUH6nyVs8fBgED@x1>
References: <20220503115010.1750296-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503115010.1750296-1-omosnace@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 03, 2022 at 01:50:10PM +0200, Ondrej Mosnacek wrote:
> The commit referenced in the Fixes tag removed the 'break' from the else
> branch in qcom_rng_read(), causing an infinite loop whenever 'max' is
> not a multiple of WORD_SZ. This can be reproduced e.g. by running:
> 
>     kcapi-rng -b 67 >/dev/null
> 
> There are many ways to fix this without adding back the 'break', but
> they all seem more awkward than simply adding it back, so do just that.
> 
> Tested on a machine with Qualcomm Amberwing processor.
> 
> Fixes: a680b1832ced ("crypto: qcom-rng - ensure buffer for generate is completely filled")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>

Reviewed-by: Brian Masney <bmasney@redhat.com>

We should add '# 5.17+' to the end of the stable line.

