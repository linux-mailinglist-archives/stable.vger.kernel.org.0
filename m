Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72E74A6D8F
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 10:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245342AbiBBJNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 04:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237985AbiBBJNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 04:13:23 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B92C061714
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 01:13:22 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id a25so27888332lji.9
        for <stable@vger.kernel.org>; Wed, 02 Feb 2022 01:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=GUnbabXlTICgKvpSu1frtg7HBj83c5DLb9USfGoJW4s=;
        b=TGRojDFA/u5JSMZOqpH4CMNPFwEmZgsj1OuSNL8oI7MX2M4pmHdKoM/KLrcRlacv0q
         aNQyot3DNPz+VtJdjrCKThxts+GIVyTCkQ/mZzwOQx4LPaGAK7AiJOsH3amvYdaUDHUw
         XVU3EjN08FpUSnoToysI1fo7oX4Llg/34l6xCBbH3w+5QlsDg+EUDkhu71bJjPvXXtK1
         ts5RDM3Zan9I3iBiljJ4K4jhfrKNYj+8X0KzIOYZAq051Tw3VsFNB8EPtFG69EF5e43l
         gzgfiHyv6EFQEDslLHXySQ/KpENL1MA8tDgQ3VyzWNIRYa+luw8R97O7sYvdlKrJYTns
         NbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=GUnbabXlTICgKvpSu1frtg7HBj83c5DLb9USfGoJW4s=;
        b=bhgNsjtC+fvdAVKvtzQQQ246p1mVH+qXuq/ycpzP/E/Zm8BFV0sY73Ipv4gg1VzliI
         7V2J+arR0d0CnQ7kqfWy+EdgBwtUUcNzf15LW/aEeD7lk4iFf+R6v+/SwABpx0vpuk9W
         f0xTQoyzVabnKhtQdvbH/U7oROYKCbImMVWSvEPtMtzUjFq/K1LvmpO1tANmdRBx9yUi
         INJEe9aTL8soMW6tJZRtWi4lfMUaBiEFx1CqZ0BbSw8Kj14ZoQo8H4se9ra6xWshOLt8
         AZi4epatkNcNWqZ+aWzXgH73AxP11+iAWkjMn4Uw3aQsy8LVhZk63mzfL0YrFDBanKIE
         mvXQ==
X-Gm-Message-State: AOAM532/Wb+X15EYwbeLtPXR5g6zSD2JzrwWmRUP6fWHH+Gv1g0wSO9X
        LDczyUnOVmH0cg9c1vXip7JO93bKqryQnw==
X-Google-Smtp-Source: ABdhPJwEWN0vZqNjPPRcZe5pGOcM8mwFP2PiUxc9kVF44ikMmlQHnLcAeFdB/swYcYJLWciIXYF6Ug==
X-Received: by 2002:a2e:7c0c:: with SMTP id x12mr19256527ljc.526.1643793200845;
        Wed, 02 Feb 2022 01:13:20 -0800 (PST)
Received: from [192.168.1.11] ([94.103.224.201])
        by smtp.gmail.com with ESMTPSA id e15sm3531016lfr.59.2022.02.02.01.13.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 01:13:20 -0800 (PST)
Message-ID: <6ce8dff1-5dcf-b560-5169-47acef139422@gmail.com>
Date:   Wed, 2 Feb 2022 12:13:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     "# 3.19.x" <stable@vger.kernel.org>
From:   Pavel Skripkin <paskripkin@gmail.com>
Subject: False-positive Bluetooth messages fix in stable kernels
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Greg and Sasha,

can you, please, cherry-pick following commit from Linus' tree:
commit 899663be5e75dc0174dc8bda0b5e6826edf0b29a with subject line 
"Bluetooth: refactor malicious adv data check".

There is missing Fixes: tag inside commit log, which causes this patch 
to not go to stable trees, but it actually fixes false-positive messages 
in dmesg.

I've seen 2 reports and I've asked reporters to test this patch and they 
have reported, that this patch actually fixes the problem [1] (second 
report was private, so I can't refer it there)



[1] 
https://lore.kernel.org/linux-bluetooth/CAC2ZOYuXg4btk9PaE3whmP7JnntsixEvDuBNvv7GL1pvU1nepQ@mail.gmail.com/T/#t





With regards,
Pavel Skripkin
