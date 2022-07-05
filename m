Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84CD85672BD
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 17:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiGEPel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 11:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiGEPej (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 11:34:39 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D3018E27;
        Tue,  5 Jul 2022 08:34:39 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id r2so14156873qta.0;
        Tue, 05 Jul 2022 08:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Zl6l+NCofyHaAaMIMCac48blXJv7LbUh1X1KIYW7CUY=;
        b=Mttb0u16/aUQIHinZmR/WC63isXaJ/zMVfXtElePw6ErvS4rnJ8Yblbn2TSpDKt2y9
         CPZ9PYF3rMpP4amOqVrMN65+EUUDKQVNZ51o1U/nl6l9GAtYWa2P2EaKEnUcTwfm8s1s
         Pd84b2oPkpcu5xFPwz90CCd/Mr4jIWmT20rICAZ2K43Lv/LUs4bopsBFWXAkif2e1GsW
         Go5ty7BM+UWmejyr2VdQeet6jRQQ7/Fhjz31gIghp02SO4Dru6lK03xD58N42q6vpfeH
         bBnWf0pUD10Fo7pkL0LsxDhVL8p3iHZSovpjaIK++ynX2byhVEr5R8X5X7vMwZTqlrwi
         jCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Zl6l+NCofyHaAaMIMCac48blXJv7LbUh1X1KIYW7CUY=;
        b=b/iFuHzYQpoAfs2Tf35+jc7LXWU35hCDtC7aB2JewWbzIajmAb/fGboCqXsRPvLfPW
         iyay3NFiM5d2tZNEavsAg9a92D63qvnH8+93W4wWzxbarcCObfg0ApkYgHDYsh2xc5Cu
         Wp467DkvJ9UCRo3/0Dq8jBy6QdZ9CdXp8CO29XEz2w0WsrRBV9MPk59IQwyKTUm3DqJo
         SZptqNFD6EOGs6upb+Z4EKpAOsWsahlOinAzKIDPqqxnhHIh5xqxZM9XfioXVaq6KRlo
         MkOdYBi7F37c7gg1oTMZcQQPAAXDlGvZ08xlleOEtquXwpkMs55q5V6bDBnOiEqhMxVX
         MMXA==
X-Gm-Message-State: AJIora9Kgcepxvt2t6PBLQNtp3btxj24YWULUQEfAcd3+tRFSkcVhYGh
        gj7QxeNxBcK4VtLByYUC4O8XHMGHUFQ=
X-Google-Smtp-Source: AGRyM1stUhz929nse5NQ427iAYlCDIqXKdfr+kdFOnjN2kBn2UTQWDjOEmUMuiQsIpQNAfYUtyuD0Q==
X-Received: by 2002:a05:6214:766:b0:473:1b4:3fe0 with SMTP id f6-20020a056214076600b0047301b43fe0mr5085395qvz.102.1657035278062;
        Tue, 05 Jul 2022 08:34:38 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 14-20020ac8594e000000b00304fc3d144esm24068727qtz.1.2022.07.05.08.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 08:34:37 -0700 (PDT)
Message-ID: <5874e274-13e9-a2bf-9cca-670709fc62f6@gmail.com>
Date:   Tue, 5 Jul 2022 08:34:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH 4.9 16/29] net: dsa: bcm_sf2: force pause link settings
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220705115605.742248854@linuxfoundation.org>
 <20220705115606.227964792@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220705115606.227964792@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/5/2022 4:57 AM, Greg Kroah-Hartman wrote:
> From: Doug Berger <opendmb@gmail.com>
> 
> commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream.
> 
> The pause settings reported by the PHY should also be applied to the GMII port
> status override otherwise the switch will not generate pause frames towards the
> link partner despite the advertisement saying otherwise.
> 
> Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Greg, please remove this patch and the ones in 4.14 as well as the fix 
is not quite appropriate, sorry about that.
-- 
Florian
