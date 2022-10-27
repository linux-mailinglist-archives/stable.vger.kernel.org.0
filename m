Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C16C60F780
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 14:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiJ0MhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 08:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiJ0MhV (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 27 Oct 2022 08:37:21 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B9815A32F
        for <Stable@vger.kernel.org>; Thu, 27 Oct 2022 05:37:17 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id y20so493408uao.8
        for <Stable@vger.kernel.org>; Thu, 27 Oct 2022 05:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eQtHVIh1aNe4Qh0x0ragWBnOPchUE+ZIYXzmSXO/abc=;
        b=qlNsrosJercoAIRBP7rls2+DO6N2QChzhgrNubVLaP/XZ7tWFhYD2doN/zhwy9Cs1e
         L5AwTxtyURDNZaSaQ/ebp/8aEvsmYaIF6x+x+FqPBBWJiYFyt9OMCwRx9tMBIPWnp7F/
         mUwDIG4hGvbAjjLj04uUrwrXcq+uixbDkyXOBjL8NnckOq2OmwSIksNEzw9+DXuTkjel
         anWxa84DOGXhwpFrWIcQXqpOCeE5cO/HPba2rzhAE2cJjKVoruNhznc5g3zZO/KjaCcy
         qLrw3OvYOuUqzMkaPfqOFOyoslmE8CQnW0J9t/SP+zdB02OLr+lewqCLEghdRsaiAnnR
         M2Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eQtHVIh1aNe4Qh0x0ragWBnOPchUE+ZIYXzmSXO/abc=;
        b=AS3LqALfEnD8T1adAghsNWm4trK/ZytRNWgLRqPfMxmHUeX7iB5Yqp/mnvW37QbSx9
         SODK7FzDWvRTdDSjD36QjkgPAGvN18mu7+UD6raCYHLM/AYn0XAmmAiCqzegwSYZqcXq
         lDfoGKSehM5ZIbwEpCpMi+ZUDbKB8/NOq9+bsnLzcHKbGjMKoxe+9iLKm72LWWy3gB4H
         hJNdCZcUN88gOEAOtR/SfNJH+aXWxHIuamcdU9G0GP2AszqSQCE8cFq9JpnwXzBFVPt5
         CGf22BACRsgrwmV8+GcsTVUm4qJinXwXz8swTIZaw1dN4EsjOCnlKAgWsuhpbqlCLogF
         sSaw==
X-Gm-Message-State: ACrzQf2a0x1bQ7g7hKr4XJZ6Vn1S2oUemeP81Acpq/T3XKtsboRAkFnX
        MWoZqr8NxJJbnZzR4zhokH5WGOcv/7fZG3mHzCI=
X-Google-Smtp-Source: AMsMyM6N08J1cioI6DLoa3mFh9ZAP88WuUeI6aE0ejM3764JQ988W4bu8pKA91x/cekbo5NTW4+llGzKYI0ICPZU6fE=
X-Received: by 2002:ab0:32cd:0:b0:408:ffa4:85f9 with SMTP id
 f13-20020ab032cd000000b00408ffa485f9mr4028372uao.62.1666874234647; Thu, 27
 Oct 2022 05:37:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6102:3d83:0:0:0:0 with HTTP; Thu, 27 Oct 2022 05:37:13
 -0700 (PDT)
From:   Cheickna Toure <metk1959@gmail.com>
Date:   Thu, 27 Oct 2022 13:37:13 +0100
Message-ID: <CAOAL42hQPJ6_wWrbOjTu=aUC1hBe-EmZ85SW_AE6rkYp283tBQ@mail.gmail.com>
Subject: Hello, Good afternoon
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,
Good afternoon and how are you?
I have an important and favourable information/proposal which might
interest you to know,
let me hear from you to detail you, it's important
Sincerely,
M.Cheickna
tourecheickna@consultant.com
