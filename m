Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D94F3D845F
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 02:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhG1ACl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 20:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbhG1ACl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 20:02:41 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CB0C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 17:02:40 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id t68so540784qkf.8
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 17:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b1tI0L/93W13MQiuG/OaeJCyNiLqOD2bmNGKqJZbjBE=;
        b=FXV42MeuBE0AnXElFk5aoiQvnL2F+nioSmK+tZItpRX5YLNUkcsnOy0TtjwD1vnQwq
         3WuGGCQU5GoESxNMDhpH30dKTfgZQ1O41+wrCF/R0RMHzSNFLQ2FA7kkQHgnkfEqmQNu
         F6Sy5ieFoYYuwoc9svJcUFkuFYIry5X9TT0FoZIeliq7sGmxY+85zHZelYtv6Wl3uw7o
         mlUkOP8ri7H1wko1+RPgPcAwiI/IKx0ynvsCs1Fdtfr7m7sP7pg1mQVluxoWecQ/C47Z
         pJVQUnNzCqTfEcvo4lfA9Mbh916Jm6aT1JH+EVSg14gC/SGjKVblKjsizzVY8BwR/T5H
         UHDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b1tI0L/93W13MQiuG/OaeJCyNiLqOD2bmNGKqJZbjBE=;
        b=rpBXgFvA1RiiH87UU88+fKta2dwG7qLYZOOMzRchkfog9HT5X28M6twbSM7w0ZX2bU
         EBpPZaXe4lgYjkyqiQmaVfPYLtKhQoWCyujOFp6jT0DV8gQ+LZaZnd3dK13W4wNbw8W7
         8vgvutnHjUKcN7UoYktNj9cjKolsOhxAtmDiJpxoB3k+GxiRYDeHDjTk9GPAKJ6yG8Qg
         4UFs6p7d8fWe5um9kocp/GIKXRW0Xb1rz7g7EAAzHLKhUird4j2eKoixOHUYwx4UvPzU
         0HMWjNbsCFaSyvhpINrPewc7yJ7YnUTkoZ9pZ+ipisiH1HD/QF2pyyBUpQQsjlc8pExP
         JQEA==
X-Gm-Message-State: AOAM532p/8xd9HrqjggqQtvzaFEYYE2i0N9MkjZ9jeGow6FHJ9Y/TPLT
        Av9nNaIUkTgr/lHr0MyK+id2rnNQskg=
X-Google-Smtp-Source: ABdhPJyDvfJvw9OFL87TBYBDFbxFkwP+A8ifWM5kr7KXcXu0rc9fumUgufauJhIwzPxhViWfn0+8ng==
X-Received: by 2002:a05:620a:319:: with SMTP id s25mr24696923qkm.411.1627430560104;
        Tue, 27 Jul 2021 17:02:40 -0700 (PDT)
Received: from mua.localhost ([2600:1700:e380:2c20::47])
        by smtp.gmail.com with ESMTPSA id d3sm2067736qtp.12.2021.07.27.17.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 17:02:39 -0700 (PDT)
Subject: Re: very long boot times in 5.13 stable.
From:   PGNet Dev <pgnet.dev@gmail.com>
To:     greearb@candelatech.com
Cc:     stable@vger.kernel.org
References: <aeac0ff3-6606-3752-db6c-306a9c643f8f@candelatech.com>
 <CAHv26DhDYNYGmQa7Dt4NoAz74J89pi8+4yuEprFO0bjuN9G7gg@mail.gmail.com>
 <f8be86d0-28ac-3e5b-1969-9115e5e0472c@candelatech.com>
 <CAHv26DjBqX__YYdqJEfMVZKFomuW8+mid5grAvUfMNmXMtC8pA@mail.gmail.com>
 <f3593f21-11e5-c568-c8e7-45b3f6657a02@candelatech.com>
 <CAHv26DjS0iuQ636tZfgYDo9EGmZ9n-ZwB9AaXvrdUUkWyL5ORw@mail.gmail.com>
 <db5517bf-35fb-a18c-47cc-d083b0d32304@candelatech.com>
Message-ID: <1231e3e3-d510-43ec-522a-75e3fe9175fb@gmail.com>
Date:   Tue, 27 Jul 2021 20:04:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <db5517bf-35fb-a18c-47cc-d083b0d32304@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/21 7:51 PM, Ben Greear wrote:
> 
> I bisected to same suspect acpi commit, though it is in 5.13.1, not 5.13.2.
> 
> commit bf155b2eaab40e7d9862ce89ffe2b8a80f86703b (HEAD -> master, refs/patches/master/acpi-resources-add-checks-for)
> Author: Hui Wang <hui.wang@canonical.com>
> Date:   Wed Jun 9 10:14:42 2021 +0800
> 
>      ACPI: resources: Add checks for ACPI IRQ override
> 
>      [ Upstream commit 0ec4e55e9f571f08970ed115ec0addc691eda613 ]
> 
>      The laptop keyboard doesn't work on many MEDION notebooks, but the
>      keyboard works well under Windows and Unix.
> ...
> 
> 
> Thanks,
> Ben

if you have a sec, pls add your result to BZ @

   https://bugzilla.kernel.org/show_bug.cgi?id=213031


the dev's "waiting a while" before fixing the regression, to see if others suffer the same/similar issue.

your comments there should help move things along a bit.

thx!
