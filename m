Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDF76C947B
	for <lists+stable@lfdr.de>; Sun, 26 Mar 2023 15:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjCZNYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Mar 2023 09:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjCZNYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Mar 2023 09:24:02 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0037D82;
        Sun, 26 Mar 2023 06:24:00 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id ix20so6030046plb.3;
        Sun, 26 Mar 2023 06:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679837040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pnOOlLKoWlVB67gp3RPUD05wT//LBY3yFpES74W1Vkc=;
        b=qJ0qSreIpqg7n1M2RJjBDhJZNct/hh4eDFZw5tBFyTNWY3W/g8AYQZSPdR0vIiFA8i
         JCA/D3T2q8BkY7jKPCRaJRH6ne7OzfhKZ18nN4jPztDcLZQASNS1YOP78h9cxdwHftKN
         pG3dcGw8VKpbZDXsBClvssSgdr+gusQnrJLtld9M0u7ysTwWD99Ut8cT9xepT8G7cs+v
         yyd6j85VBKXGPGe96u6zafNRWT9O3yQ9BsmY9I8KISTqEVhIVMNxxyiNjFwr6TCAuJnv
         wArLHUpczHBiNXymvTma3ovhG+iAtWm1+dIyGCM8hpSpMy2Rvjqk27a9Ri4kw3d8PYLj
         OWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679837040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pnOOlLKoWlVB67gp3RPUD05wT//LBY3yFpES74W1Vkc=;
        b=Xi0lzizpot1LlGdsY5wkNv4NZavg+8HdAlfYuPM29xiPOptPEFSxZntGDrDS3XmcxQ
         1mSNPrD8XV7oh0oXnOBgWfcyldJDcHwruSW63A5D0iFJWulncph9jliKHDAit9HfOFY1
         sYjG6GdWG9pWnSDURXkcYo7mVQkgouWSSUQSxo/Eh5bYrN8frBBsfZnY4hY86+AVjuWG
         YgoIzk4cVa6dX469p6Qn3PZCqi3OLzPrjgVIK0EmkpucgB2m0bezbMlmIheTaDoaMBrh
         vaOlYXRHmpPiQ+Fj58bQSO3Chy/t4v4M8HQd6lNwyrCqO8Fq4ofwMUIZmpre8oC+mOWb
         +/eA==
X-Gm-Message-State: AO0yUKVUQejOjOOo4g8+4k8giIvp1/oKyB3Cdp4WNX2PNoqZycAKedIs
        hBl2RIzPDo6DlF2yy5NcfmpbSrHbbb4=
X-Google-Smtp-Source: AK7set9OzCDMKxr2gAfR4Tvv6pTg1Zs5M12Fp4wZblK+PYXBW0DBvuChv43wUrBkPscskOMgLpZZeA==
X-Received: by 2002:a05:6a20:8b14:b0:da:fa65:cd89 with SMTP id l20-20020a056a208b1400b000dafa65cd89mr8874490pzh.9.1679837040117;
        Sun, 26 Mar 2023 06:24:00 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-54.three.co.id. [116.206.12.54])
        by smtp.gmail.com with ESMTPSA id b23-20020aa78117000000b005ac8a51d591sm17108200pfi.21.2023.03.26.06.23.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Mar 2023 06:23:59 -0700 (PDT)
Message-ID: <d14fb08c-70e3-4cc7-caf9-87e73eab9194@gmail.com>
Date:   Sun, 26 Mar 2023 20:23:53 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: kernel error at led trigger "phy0tpt"
Content-Language: en-US
To:     Tobias Dahms <dahms.tobias@web.de>,
        Sean Wang <sean.wang@mediatek.com>,
        angelogioacchino.delregno@collabora.com
Cc:     stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-leds@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Linux regressions mailing list <regressions@lists.linux.dev>
References: <91feceb2-0df4-19b9-5ffa-d37e3d344fdf@web.de>
 <3fcc707b-f757-e74b-2800-3b6314217868@leemhuis.info>
 <fcecf6fc-bf18-73a0-9fc1-6850e183323a@web.de>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <fcecf6fc-bf18-73a0-9fc1-6850e183323a@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/26/23 02:20, Tobias Dahms wrote:
> Hello,
> 
> the bisection gives following result:
> --------------------------------------------------------------------
> 18c7deca2b812537aa4d928900e208710f1300aa is the first bad commit
> commit 18c7deca2b812537aa4d928900e208710f1300aa
> Author: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> Date:   Tue May 17 12:47:08 2022 +0200
> 
>     soc: mediatek: pwrap: Use readx_poll_timeout() instead of custom
> function
> 
>     Function pwrap_wait_for_state() is a function that polls an address
>     through a helper function, but this is the very same operation that
>     the readx_poll_timeout macro means to do.
>     Convert all instances of calling pwrap_wait_for_state() to instead
>     use the read_poll_timeout macro.
> 
>     Signed-off-by: AngeloGioacchino Del Regno
> <angelogioacchino.delregno@collabora.com>
>     Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
>     Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
>     Link:
> https://lore.kernel.org/r/20220517104712.24579-2-angelogioacchino.delregno@collabora.com
>     Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> 
>  drivers/soc/mediatek/mtk-pmic-wrap.c | 60
> ++++++++++++++++++++----------------
>  1 file changed, 33 insertions(+), 27 deletions(-)
> --------------------------------------------------------------------
> 

OK, I'm updating the regression status:

#regzbot introduced: 18c7deca2b8125

And for replying, don't top-post, but rather reply inline with
appropriate context instead; hence I cut the replied context.

-- 
An old man doll... just what I always wanted! - Clara

