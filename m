Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96130483BFB
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 07:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiADG2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 01:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiADG2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 01:28:39 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF965C061784
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 22:28:38 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id 139so73622090ybd.3
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 22:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zo52sAcCrLydPJZGuQsUiSGb4V93u3EKnrmrn+NDnS0=;
        b=WlaZA6JMCMy7eLmiXY3Es60G5MTviQPPi9KtFixE1yIiIqZky0UZaY2DXgVWH0+MVY
         6YVVcmu1ubBfcqzvOa+2ZGoRgKo80Vs7awwpgWc1zsfOLrleZKjgl5lj4oovhXE8LWmV
         OC8uSKS1wJu5OUFm+qBpax13LsXpPl1Jp8VA598k7cS+7DT4D5c62XlStVMjX6B1zciu
         m2R8VN633HaYEkTl4qTVdRE7phu/rUb65CNNmAIb3VNUCgobRGi/CgU8B6csEtyodZey
         jqrO4Nobp5NlwNCg/wsw8Lbd4yfH7AGBUOH4dKrJkfyggBGv4F+lwBuiuwZNrQSL9jRV
         PCTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zo52sAcCrLydPJZGuQsUiSGb4V93u3EKnrmrn+NDnS0=;
        b=jBKRJ6gJxLDtZVSbxvsPc0xtP9VRac4OlRpVPINuB1kE5CLt4yWp7c5bBQSQN9+zSp
         0Zsr4WlUCQ9jBhdm3kZIQ2Yw+Ip79HZUsXVlfCbmdcDLs+LtBoSV/OQ+1m2J8HaKV/f+
         NnD20NvIZ8x8bSZLM8K2csXrj/N8ccF76bM70tL0SRlfkZU75AUqFhqeaBXTT3RTjNFO
         0ZjL6ZoB78sWaRzB3sJpOm5we/ZfUpSwS86ujeQ8LCWCeXovv8qIjJW+Uw1giQtEHizf
         kYnFFlTPA8sejtodYaF61+c1fqF0JEDVuF1oek4pgkXnMflN6F0qnVlQJ9f+v7LI1Sl/
         ACWA==
X-Gm-Message-State: AOAM531CvIycVRDreXE03s+Y33oDINs2h9HRtmLOBbBS0IUtVDVI36pG
        zzuPiFe6AN6yIRmk1cIV6oyblwvss12hkBZ2edL1iQ==
X-Google-Smtp-Source: ABdhPJy4S8DhHHIyGWw5OPLAe5maT7DK5TOUJPM/35ziqRTyxDbk0qRLix8INKIUNwfrFe3MFLNFr0MTnjXO1xiEDj8=
X-Received: by 2002:a25:8008:: with SMTP id m8mr6802981ybk.704.1641277718036;
 Mon, 03 Jan 2022 22:28:38 -0800 (PST)
MIME-Version: 1.0
References: <20220103142051.883166998@linuxfoundation.org> <f5a6c584-6894-ff2e-d4cb-2af9f5fdaf55@gmail.com>
In-Reply-To: <f5a6c584-6894-ff2e-d4cb-2af9f5fdaf55@gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Jan 2022 11:58:26 +0530
Message-ID: <CA+G9fYurRPwowcEw1LOjr1Lmogi9GMmY2WFgTCtS2H7bWwVx7Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/37] 5.4.170-rc1 review
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Florian

> See my regression report about patch "net: phy: fixed_phy: Fix NULL vs
> IS_ERR() checking in __fixed_phy_register", other than that, the rest
> worked OK.

I see your regression reported on netdev mailing list [1].
Please share steps to reproduce,
  - Kernel tree / branch / commit
  - Kernel config file / link
  - Hardware / Qemu command.


[1] https://lore.kernel.org/netdev/20220103193453.1214961-1-f.fainelli@gmail.com/

Best regards
Naresh Kamboju
