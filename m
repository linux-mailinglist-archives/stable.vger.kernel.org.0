Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FD23D7F5F
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 22:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhG0Ulh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 16:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhG0Ulh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 16:41:37 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5E9C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 13:41:37 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d2so10559371qto.6
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 13:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=St66ktSH+2+srS7jYKt2P9hTr8b0zWIBokN3M0Oxffg=;
        b=PMjOqzihhocXBhFNYjwa0/d6WfauInTe6wEQpFNzwoWxHLuqeXaV7VVN7fCrI5Dh49
         8YoDelQOcLrdw1fJDjDA22iAdRASyHMJAS4jZ0+ig9H5CyHo9MncjMFa2wJNg++uZ3CC
         qoCly2zpZN5ckirQsz3lqAGhDArKVc+hPoqmu7YGIEj3JbltK8GWJPLvt12C4ZSB0F+V
         WDJ34Kf1qY2A8fvtK8/NMLaXnp0VThOKzchZszmEzJuE0dybDOuIiTtfH21dYELdzH36
         BPGQM2Xxn/JoO2MogB070UTrLKbWe35HOl4X48th45E67Nw4xYszkYGBRe9ALVyvcjIJ
         zMmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=St66ktSH+2+srS7jYKt2P9hTr8b0zWIBokN3M0Oxffg=;
        b=LS9h5i4ACkJMt12LySUkyULDFNu1qCz7/l8iE2wZarW9+6uCWcRsmgbNS6Gdw94Hpx
         ixqLgOG00/kci/gTy+7pE738I6iQI1LYXsvQB+Vj2+4XsUXHJxlzb7SJvV30QfhCPH+H
         5bDdTkR5A5KudNweUMy1mlIL43EoPaXOPtCOyTkd9rud7BvJtpF3WeEuNxPMMzPJnUyw
         i2lZmSC2vxdOeZ3RWk+6biGOLL4ztphc5nMFHGPQGjr6NXM9tw0UoIyD/VhLT/2U14NT
         jDMWXwei8EQMHQT2/s+Ux+LikAMf2LcgrQusl+FCv24HauM8XbtVkG2XBz/CF/X7oqvs
         SD0A==
X-Gm-Message-State: AOAM530LnRRipdPP2C11chs/NLMKvOmv3vntYkUx3tbV3DU6ZrPEaSjR
        ZU9K0fT+nX2U21xESyNQb+Le0jqTCUM=
X-Google-Smtp-Source: ABdhPJzAnlKMlsTFJmjaTX77FzWNyWjNd8/tZd2vKdKpPRp/FAs7xXo20jrP8dLkIa650izAB1EuUA==
X-Received: by 2002:a05:622a:1049:: with SMTP id f9mr20696953qte.111.1627418496335;
        Tue, 27 Jul 2021 13:41:36 -0700 (PDT)
Received: from mua.localhost ([2600:1700:e380:2c20::47])
        by smtp.gmail.com with ESMTPSA id a16sm2186420qkn.107.2021.07.27.13.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 13:41:35 -0700 (PDT)
Subject: Re: very long boot times in 5.13 stable.
From:   PGNet Dev <pgnet.dev@gmail.com>
To:     tmb@tmb.nu, greearb@candelatech.com
Cc:     stable@vger.kernel.org
References: <3d8ebf91-74ac-d1d3-80a7-df5da3fe7d78@tmb.nu>
Message-ID: <10699753-88cb-01a1-c764-41d7b24d2269@gmail.com>
Date:   Tue, 27 Jul 2021 16:43:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <3d8ebf91-74ac-d1d3-80a7-df5da3fe7d78@tmb.nu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/21 4:23 PM, Thomas Backlund wrote:
> and a matching thread:
> "boot of J1900 (quad-core Celeron) mobo: kernel <= 5.12.15, OK; kernel
>   >= 5.12.17, 5.13.4, slow boot (>> 660 secs) + hang/FAIL"
> 
> on stable@ ml.

yep, here:

   https://lore.kernel.org/regressions/3491db05-3bb4-a2c9-2350-881a77734070@gmail.com/

it showed up for me between 5.12.15 & 5.12.17 stable releases.

didn't realize it hadn't landed until 5.13 in linus' tree.
