Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE37767F8CF
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 15:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjA1OuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 09:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjA1OuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 09:50:06 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611C528852
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 06:50:03 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id mf7so2060318ejc.6
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 06:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V3rtwfwcsvMx7LBqKbHu3dkZXfAdloErxVvHEqNHOUM=;
        b=ppro+f7OdBBvQxyg9YPldl4lMJdAzW6yHrDfEsKeU4h6mKbPj4XpMDrbXCSTF+ZQib
         q8nBwmcvpjrXv7TxLiEC7TeZPsQ0ozV19K3gJ6BHWIx+IUk3b5RYYzVRhFQf4l5/Fj2g
         L7+vrvKTvMCirtjrDtngGnnf8xHBOGeqDbF5qnwfj5p+ok7eHyzUdggOD9u/dxDnzixW
         RcbWmL7qI9E2x1whhyJ3Aeu3CPbIUr1RBZlOiQOVxKfDDlNFTtu0SFoU/x7NeLDUOe4J
         X7TsoTa67pVoPrch9BqcIHS4KNbhf0Es0IWmdJ5O9+IodRcyWdfax57Vi130++LgwBiE
         c/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=V3rtwfwcsvMx7LBqKbHu3dkZXfAdloErxVvHEqNHOUM=;
        b=T5th1KZoJ0YU+FU65VbOYbJGqmxc2dV676D0wU5hkhC0XaxpUMBW4hkrdtMMWsJGsq
         Va6U5PCZeiaKOC2D90PcBoXWrmD7ZyrZQLzNJTf+QCOrYIeafvYwWGtobiQJIxeQfCdP
         l4iej76/K03TxwyI4Gq2hjJrjyWXihLd6WC05isp+xtEKD+PTAGoZ+K0mJxvOhygbeYX
         6YU0uZdIJbDwu8J92XyCcfJy8It7Su8oPqi/I5FCi+S7JPY8+wdVkeYL/eTi1tuQmL0B
         ABk76ReraEodd3v6wLekTdsDM+TD5HjMrQFy2iGkEmt6pTDtZylGgzXx23e9W/MHm7XX
         CTXg==
X-Gm-Message-State: AFqh2kqi+D1CduW6os0gfSn3lIrmpzv55nmdCNFIyDZ7pGRBvnI2dz8Q
        FbM9pC/0zi13MgO1KShorN8zMkYtr7BJ2Q==
X-Google-Smtp-Source: AMrXdXvYbnbEoWKYeXOor31Nflfm6zNDUISm5bDoBPP5yeVXRQpfN0rRjxWJn3moFsjHifE79oH43A==
X-Received: by 2002:a17:906:1f57:b0:872:2cc4:6886 with SMTP id d23-20020a1709061f5700b008722cc46886mr38852811ejk.30.1674917401771;
        Sat, 28 Jan 2023 06:50:01 -0800 (PST)
Received: from [192.168.178.20] (host-82-63-78-202.business.telecomitalia.it. [82.63.78.202])
        by smtp.gmail.com with ESMTPSA id y14-20020a17090668ce00b0084d4733c428sm3906376ejr.88.2023.01.28.06.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Jan 2023 06:50:01 -0800 (PST)
Message-ID: <cdfc26b5-c045-5f93-b553-942618f0983a@gmail.com>
Date:   Sat, 28 Jan 2023 15:49:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [Nouveau] [PATCH] nouveau: explicitly wait on the fence in
 nouveau_bo_move_m2mf
From:   Computer Enthusiastic <computer.enthusiastic@gmail.com>
To:     stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>
Cc:     Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        Salvatore Bonaccorso <carnil@debian.org>,
        Lyude Paul <lyude@redhat.com>
References: <20220819200928.401416-1-kherbst@redhat.com>
 <CAHSpYy0HAifr4f+z64h+xFUmMNbB4hCR1r2Z==TsB4WaHatQqg@mail.gmail.com>
 <CACO55tv0jO2TmuWcwFiAUQB-__DZVwhv7WNN9MfgMXV053gknw@mail.gmail.com>
 <CAHSpYy117N0A1QJKVNmFNii3iL9mU71_RusiUo5ZAMcJZciM-g@mail.gmail.com>
In-Reply-To: <CAHSpYy117N0A1QJKVNmFNii3iL9mU71_RusiUo5ZAMcJZciM-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

The patch "[Nouveau] [PATCH] nouveau: explicitly wait on the fence in 
nouveau_bo_move_m2mf" [1] was marked for kernels v5.15+ and it was 
merged upstream.

The same patch [1] works with kernel 5.10.y, but it is not been merged 
upstream so far.

According to Karol Herbst suggestion [2], I'm sending this message to 
ask for merging it into 5.10 kernel.

Thanks in advance.

---
[1] 
https://lore.kernel.org/nouveau/20220819200928.401416-1-kherbst@redhat.com/

[2] 
https://lore.kernel.org/nouveau/CACO55tv0jO2TmuWcwFiAUQB-__DZVwhv7WNN9MfgMXV053gknw@mail.gmail.com/
