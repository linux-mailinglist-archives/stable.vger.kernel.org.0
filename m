Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F165E621E90
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 22:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiKHVdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 16:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiKHVdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 16:33:02 -0500
Received: from 001.lax.mailroute.net (001.lax.mailroute.net [199.89.1.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A7361777
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:33:01 -0800 (PST)
Received: from localhost (001.lax.mailroute.net [127.0.0.1])
        by 001.lax.mailroute.net (Postfix) with ESMTP id 4N6LtP0WjWz1M8qS
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 21:33:01 +0000 (UTC)
X-Virus-Scanned: by MailRoute
Received: from 001.lax.mailroute.net ([199.89.1.4])
        by localhost (001.lax [127.0.0.1]) (mroute_mailscanner, port 10026)
        with LMTP id ivkNdzOQ5qb3 for <stable@vger.kernel.org>;
        Tue,  8 Nov 2022 21:32:59 +0000 (UTC)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by 001.lax.mailroute.net (Postfix) with ESMTPS id 4N6LtM6sBpz1M8qY
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 21:32:59 +0000 (UTC)
Received: by mail-pl1-f197.google.com with SMTP id n1-20020a170902f60100b00179c0a5c51fso11894236plg.7
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 13:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XvzS6IZtUmkiQUDObZubbiGEND3E6ynZXlDGWsaowMs=;
        b=l7c4lds6IThIy6cpCrJ8JMAWwePfEggJx2upPpc3rjIqN8y6Z7TTt3Do7NRhw8L5bt
         A5VacmPLn8vYrVg2Wm1+czEn3xk2Yh1DWhTJRfG5sk98G/xwwKhV4/v0dywSgk0Phfua
         GrHug2zpEuIkf4ghy1X197/cseDQCwSsfXIJEoP9p+ZZHZEwIVzgz+OO1qhCLJbNkf0f
         Y0t7LpoND24vEM6snXgeh5SK+NwJ0lrrLMDrhWQs6JuiKhTyvW38PklAgc1RBKMRSY9k
         DNTcxUeVwKpmIlUHRdBRuOizfXY40Czy99sshCHdA4s9gdwD8GxptqkHvUBRB6PI3q4l
         t1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XvzS6IZtUmkiQUDObZubbiGEND3E6ynZXlDGWsaowMs=;
        b=PBAaftFk49j7Uc4eTla7YzOgEgFK33uJdITdZI4pgGyikRNlZyXlTKlq09Woy2DxZE
         rt2+qiANy51WZ0O93EbVt4W17imATcmQdiXwXbuS7rJB9tB6Q5VR0t/lfFr1l52od5Y+
         gT1oPXN/kgQNouxAAxq14kVNcpRU21tIg68YBHO8RXEX48VK6rL0+i94cF6/cNeERJB/
         6JR0u3uhZwFn++5bDXfk0gvBrhyWkMAsg2AmL0RjLpjk5H1IRRwLIM3nDtm6xJjKSmV3
         EkKh0ma54jT0zn7XVF7K5VEy7QywGXtIUCYz9CUmrbSFhJRG/N8ipaLUIIdS55vBXaVB
         hxZA==
X-Gm-Message-State: ACrzQf22vE3oKIBSvCjH1iQ02uyN/OiJ+MraTefwyB1vBDeCgfMkvRLl
        xIgNXDBGEucCrrb8n0eZOVz++6Vaef3D0+mVCnheFIyQjnavwxLRrb+Z6W5GuvPpzzR5VgbaIC0
        8zEbwB87ejEaQcwNSaARxtIdQ6iWaXQmFm55fWHkJwHvDpLE=
X-Received: by 2002:a17:902:9b88:b0:188:620d:90fc with SMTP id y8-20020a1709029b8800b00188620d90fcmr27845608plp.61.1667943179059;
        Tue, 08 Nov 2022 13:32:59 -0800 (PST)
X-Google-Smtp-Source: AMsMyM74u/1SS2WCRO6VZM04gxufQf/tkIwogn2aFn4BzsnsFTbOeo04Kfkbq/L5Z9sbrGMnJiqbRFzjakLsbFoktOU=
X-Received: by 2002:a17:902:9b88:b0:188:620d:90fc with SMTP id
 y8-20020a1709029b8800b00188620d90fcmr27845580plp.61.1667943178750; Tue, 08
 Nov 2022 13:32:58 -0800 (PST)
MIME-Version: 1.0
References: <20221108133345.346704162@linuxfoundation.org>
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Tue, 8 Nov 2022 16:32:47 -0500
Message-ID: <CA+pv=HOud9PMz7e9N=ffyF14OeDWU0ddDrZJADaqTPP-q7k6-g@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Nov 8, 2022 at 8:59 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.

5.15.78-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Best,
-srw
