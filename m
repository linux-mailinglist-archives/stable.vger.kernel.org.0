Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357DA45501F
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 23:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240994AbhKQWGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 17:06:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232621AbhKQWGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 17:06:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637186627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UM3rOln8kBcAURl+w/UPvP+woZK+h5DIoF92PXfCfdQ=;
        b=A9EkBiBsYgbYeMpc3cMEg8y0HwGyFAEYhTtWpp7yGnGNazZmr+MNcL4qEvISdgF4X3lFuJ
        ZzA4sXHZczv9NGs+m3MPuUBBNR+We7p30qNgeT1Eh2r3jJ1cc/upMcuRtIeFIDWQ3ZLlsR
        fupRH/VIidjzM8ZSSAbKdE5caUqR6iI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-2H3OEIOoMNK14CSqLgXlNw-1; Wed, 17 Nov 2021 17:03:46 -0500
X-MC-Unique: 2H3OEIOoMNK14CSqLgXlNw-1
Received: by mail-qv1-f71.google.com with SMTP id e14-20020a0562140d8e00b003bace92a1feso4034076qve.5
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 14:03:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UM3rOln8kBcAURl+w/UPvP+woZK+h5DIoF92PXfCfdQ=;
        b=wRXK3tAZfF10/CoQpEnWyiVrYVQTgGtUsZ75wsLLQTYXnqmDOhlmWBpGfop7EAmwDm
         KgWNedgy9VrHWTVu134koKoyikeTFyk6vJSOoi4i5FQqEim5HmngWzQpKURkIr0YuiJZ
         w/FDIY5SAxg+v6ios+jA6VL4+WV1UWyimFX/d+8I4JSc+Drp8nr62K1+J62Btrxg42KV
         Xh2RdZM7b+LYk84LdDMrIhm9Mg5jcaCMPFxSJ1GQtaQoqqmbdVn8XXlUoMCAkHzqd6z5
         6iWtaQM3gTvztzr5mT7FAJA3XvhcepH8wAzIJu6HiGAeYynrQrTRmqT0trDyn/uot+Ai
         i+pw==
X-Gm-Message-State: AOAM53174hFZmKWhK8Xt7tKl185B0+VFPIfWyhwlpJbnPYWZ6aAS7j5y
        +70nGHDnDKfThAnj/UMLRSkVJMtypnq6WSrtbSqh3ET93T7Wpq7lzW7y4JvSUoqDAQJ334cKHYt
        qwVam/474VzOU1j7n
X-Received: by 2002:ac8:5c53:: with SMTP id j19mr21301628qtj.40.1637186625533;
        Wed, 17 Nov 2021 14:03:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKbmfhLXEcjpNEixYPWQ886lMm649m9jzw2P56FDGKONoExY3utbgtPOsfA1loXEghxgDNQQ==
X-Received: by 2002:ac8:5c53:: with SMTP id j19mr21301599qtj.40.1637186625332;
        Wed, 17 Nov 2021 14:03:45 -0800 (PST)
Received: from [10.0.0.96] ([24.225.241.171])
        by smtp.gmail.com with ESMTPSA id w10sm691272qkp.121.2021.11.17.14.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 14:03:44 -0800 (PST)
Message-ID: <0aea60c5-28d5-258a-3a32-bae1895a96ee@redhat.com>
Date:   Wed, 17 Nov 2021 17:06:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2] tipc: check for null after calling kmemdup
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>, davem@davemloft.net
Cc:     Ying Xue <ying.xue@windriver.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
References: <20211115160143.5099-1-tadeusz.struk@linaro.org>
From:   Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <20211115160143.5099-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Acked-by: Jon Maloy <jmaloy@redhat.com>

On 11/15/21 11:01, Tadeusz Struk wrote:
> kmemdup can return a null pointer so need to check for it, otherwise
> the null key will be dereferenced later in tipc_crypto_key_xmit as
> can be seen in the trace [1].
>
> Cc: Jon Maloy <jmaloy@redhat.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: tipc-discussion@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org # 5.15, 5.14, 5.10
>
> [1] https://syzkaller.appspot.com/bug?id=bca180abb29567b189efdbdb34cbf7ba851c2a58
>
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
> Changed in v2:
> - use tipc_aead_free() to free all crytpo tfm instances
>    that might have been allocated before the fail.
> ---
>   net/tipc/crypto.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
> index dc60c32bb70d..d293614d5fc6 100644
> --- a/net/tipc/crypto.c
> +++ b/net/tipc/crypto.c
> @@ -597,6 +597,10 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
>   	tmp->cloned = NULL;
>   	tmp->authsize = TIPC_AES_GCM_TAG_SIZE;
>   	tmp->key = kmemdup(ukey, tipc_aead_key_size(ukey), GFP_KERNEL);
> +	if (!tmp->key) {
> +		tipc_aead_free(&tmp->rcu);
> +		return -ENOMEM;
> +	}
>   	memcpy(&tmp->salt, ukey->key + keylen, TIPC_AES_GCM_SALT_SIZE);
>   	atomic_set(&tmp->users, 0);
>   	atomic64_set(&tmp->seqno, 0);

