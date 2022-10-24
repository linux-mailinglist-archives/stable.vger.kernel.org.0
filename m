Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC5260AF54
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 17:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiJXPoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 11:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbiJXPnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 11:43:45 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C827B92F75
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 07:35:22 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id r19so5705069qtx.6
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 07:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x28cr+ZIuK//DRpy8TFD/X6rWHWIZZuhI7rLmSEd6vI=;
        b=qOoYRS0TENphIlHwLEnnrCbtyhS9bYMMg5Z0KQy/RT5Hqkmw2pvlGdlOwzb3o6eLzq
         fEbttQr/3GXo+aCvf55AH0PscQFNOKXGl95On4vk2+5bV1bwre3QH99xVLPXCNvhPC46
         oUCRDSEEgxaZfajOeVF8pf4dQClrZsvdfMkvftKfVPF3sIntUFMfiivNW7A72TmApDRQ
         EKig02IaryQY39j8ZG5cf05skuHy3lkAXIW9XIkCobImOs5hPaL/wcUAHEMpa0WzUNUW
         r37TNmrAdvVLjuqk20DrSF05SsM8Ca46XcA2nnP6Toc6zYuy/WLVFdxQqPvxgQnTeAdk
         wq0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x28cr+ZIuK//DRpy8TFD/X6rWHWIZZuhI7rLmSEd6vI=;
        b=GtBUHIeeFRoa7w4mrPd7iy9cEgOVdLISPIOyMdLV047wOW7156mLgYHyG2F7FzKPuR
         yXDeSZOxV9hByefEaZhk1luN6YYroj/ZTS16/khr9TbGPem/Q6mIhmuDRcvqeY6FKuRz
         GZJuccHvitysvi+mPKmS4VvSnRAT9RCCfNpRn4+YqEtcez+4t6npU+zkFUdnN4W1rwhU
         OQyyKoWaaof0//IDQeYQ9z50pY/z37E7U/zIfOeiEWN9y48gHxj4328dQymy2hd+NP76
         MbpKT+W2deBtDipFfV6WUg1iS8NPGDfiZmf3vi40bN5iBoz0vpWOF3b/FtryS2ANz5eq
         botg==
X-Gm-Message-State: ACrzQf2QgHZ9miNq9C0x3CbO7YTzideXqWKybnSODpQniKjoCkWHAKsG
        +XXYdSDF/DOZL5wMN7Vhao4Anok7VW8=
X-Google-Smtp-Source: AMsMyM62WudXLaZDVywAXVX0D84qewoTRUjp/vpuWiDYGSPf6TA9othD94U0j4AvuTokKAblbe2Kww==
X-Received: by 2002:ac8:594a:0:b0:39c:f5c7:8e53 with SMTP id 10-20020ac8594a000000b0039cf5c78e53mr27832346qtz.237.1666620108504;
        Mon, 24 Oct 2022 07:01:48 -0700 (PDT)
Received: from [192.168.50.208] (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id s7-20020a05620a254700b006af0ce13499sm15125378qko.115.2022.10.24.07.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 07:01:47 -0700 (PDT)
Message-ID: <70dbb73f-cb28-8e7a-5b2b-63ef964b28b8@gmail.com>
Date:   Mon, 24 Oct 2022 07:01:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: LTS 5.15 and state of lpfc
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <alexander.levin@microsoft.com>,
        stable <stable@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justintee8345@gmail.com>
References: <cdc7d1cf-3ad2-c2d2-8006-22bf51f8df4a@gmail.com>
 <Y1YPrvniFIaO/jzJ@kroah.com>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <Y1YPrvniFIaO/jzJ@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/23/2022 9:08 PM, Greg Kroah-Hartman wrote:
> 
> Can you just send a patch series that does all of this so that we know
> it is correct and works properly?  I'll be glad to take that into
> 5.15.y.
> 
> thanks,
> 
> greg k-h

Yep. I wasn't sure how you wanted to approach it.

-- james

