Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB0353AB9F
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 19:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244187AbiFARQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 13:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356262AbiFARQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 13:16:08 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CD6A3094
        for <stable@vger.kernel.org>; Wed,  1 Jun 2022 10:16:04 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id v19so3106151edd.4
        for <stable@vger.kernel.org>; Wed, 01 Jun 2022 10:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=nO1e35nlS2iBCH2yu9QBuuI6RWRv4xTOizhqimByhk0=;
        b=nYT4b/FgeKtAn1F1bNwWv8XOmYDjSYsT2y6hqUZ2k/f/Z7TvSJeDaIrECFxpSeYL52
         +hODypdcVv73lyMq0/OUF3k/jVhK/HmjGk1HhQWS8ZUxSf01vpDg608CFOr7jNyGV6Fu
         eWyIIu9qFYE1NTMM0PkpXPUbcyB8LaEb/mmoQCvFxg+IVO2HPVSiousC9jfcSBMiAHpj
         dbFz7wH9fquNN5VKefXxHN/W8Zh5tBYMw6WhnSaTVtMq3LJTadgDNSb68+4oN7pNonqF
         eO/vevjxAGNaGzNtKAV9x9HUDY2QJhKalLN2BD7atvWkkW+FTktCFOun/lXn9sqxAJ5I
         4T1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=nO1e35nlS2iBCH2yu9QBuuI6RWRv4xTOizhqimByhk0=;
        b=LwIB1g3/wcfJp5HarX/g45fy0uWRAglEgQUEuGb9uYQYoCmCH8twP3YQUkXx7wOUVK
         ls6pkwyaimm6eQOv6lT0QLiM4pskbv25hj2pGKWDXNOQd0vFiBQ3pM883reR7jQQcQwR
         EMEbI+IsZjEGRD28RGJjGyNLcNJJ5cjGE4PehxMrzpZaxiB5xIiy9pNbBX7IEnjqfNpx
         IxIpEDEvNMJlPgoZDQCpUH6s+ZEufq33NiotM9kGqACktA0W86OkrnXTeQER/XfnDQsw
         kgfZhCEcbmp2YPyaJqARxyWLACeb/BbcjOZA6s0kR2E1cwX6ezm3fQx4Y1jwaKdOTSbU
         pdEA==
X-Gm-Message-State: AOAM533Vb61Jv3xV5Psch1Ks2m9c90Ki/oMcWwpc4ZIrNvEKh91itUYr
        zxCoPOtwqCCzvE9p8Geqa1tDjPHdpzyZPMJdQBTam806vAoXHp8h
X-Google-Smtp-Source: ABdhPJygOSSFZmsYtg/Mi753W+9rKuEN41fuX1mUMgwJL51vsx2xC5jTSb01oOeMwLKmJFQyZP+fIsiIe5QaioZDIA8=
X-Received: by 2002:a17:907:3f1f:b0:6fe:b40a:21f0 with SMTP id
 hq31-20020a1709073f1f00b006feb40a21f0mr509211ejc.744.1654103752280; Wed, 01
 Jun 2022 10:15:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:208e:0:0:0:0:0 with HTTP; Wed, 1 Jun 2022 10:15:51 -0700 (PDT)
Reply-To: barristerbenjamin221@gmail.com
From:   Attorney Amadou <gomadoessi@gmail.com>
Date:   Wed, 1 Jun 2022 10:15:51 -0700
Message-ID: <CA+Bj_9acoezR5-pSRJr7qSU==DS4F-Af5vRHjkeXzm+Xk_s+2g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello dear friend.

Please can I talk to you about something very important. I will
appreciate it if you grant me audience.

Sincerely.
Barrister Amadou Benjamin Esq.
...........................................................................=
...............................
Hallo lieber Freund.

Kann ich bitte mit Ihnen =C3=BCber etwas sehr Wichtiges sprechen? Ich werde
es zu sch=C3=A4tzen wissen, wenn Sie mir Audienz gew=C3=A4hren.

Aufrichtig.
Rechtsanwalt Amadou Benjamin Esq.
