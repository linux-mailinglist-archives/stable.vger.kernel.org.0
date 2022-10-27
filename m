Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C5060F793
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 14:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbiJ0MkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 08:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235618AbiJ0MkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 08:40:11 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300301D67E
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 05:40:10 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id a14so1953964wru.5
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 05:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eQtHVIh1aNe4Qh0x0ragWBnOPchUE+ZIYXzmSXO/abc=;
        b=AeFqGM1Jxb71fdFBvc6Ql1bK+qMx9qKTYC8onAUectCSWFtnW+wouF78xU2yqV/bPP
         2+S597/ba27ZgtZ7gY90aWdwaAGTmX0MG8MoeixQLtGcq11PUu/0zHSKGYZ9RzwhOGta
         phqrr+AZRPQOGVfiZ/553ZSX6ApbN3VbDB5EkLPPQNZ4EA3isGq3Yisd/Pfh0+xJm4yw
         fuUYOHoeRijxea+HQjl3nsmaXCduwEziWgG1jXolHh8Go/jA3tqU1cgXRKgBn8dxj4Pr
         cf+dehDzifMXSYfG2gyZmsMmmQmQX1uYNAeI9exyr+gaEEIkgLwz369CpOjP/u9vwqNS
         HBZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eQtHVIh1aNe4Qh0x0ragWBnOPchUE+ZIYXzmSXO/abc=;
        b=ernb4TRz8DJPfVKk6I46oh3DnvwNfbhsJZqEPLB/y8mZsAjgDhPm6nDAiBz64diSHC
         5Tvlv8kGn54wAvdSjaoaiZIRWnp1677TWhSubn73ozYV0WaLDGX6VpDfIo9oMCYv1GBO
         WR6L7SO9zD23NYCUNqovVRcZDJo+RmGDycafiU/Evuqvvi6Q6MAxKou0bxViyvxenE+A
         BpTDAxusbXgO9ai3hQqlk5yf+fhEPaBGhcf7qmzR3o3NgvPdA5LRWdfrvA+g8V7UG1xD
         lHuhOnQYE1dh1mg/sttmq88QLfZtTOa48TkD8Vp9pDU61qkoW7+MeR1QB7QWNvgznkOc
         MVWA==
X-Gm-Message-State: ACrzQf3MgSwNBrUjGJCEscQS2IAEPf3f16z9xUwxfpBc96iqi2YMqS+z
        QS1Z5g4gCQoMMdTY1WZhiqZJ5Th1OzP0nHZA2Ro=
X-Google-Smtp-Source: AMsMyM5K81HzvgcLvCCs9jl1M9LRalQ1qIwD13+egy60syW1mH8XEu5noa1t/10l60zj2s/igDRcKWBZ/N34qbA1OpE=
X-Received: by 2002:a5d:6d8a:0:b0:236:6123:a8a5 with SMTP id
 l10-20020a5d6d8a000000b002366123a8a5mr17349585wrs.229.1666874408348; Thu, 27
 Oct 2022 05:40:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:4682:0:0:0:0:0 with HTTP; Thu, 27 Oct 2022 05:40:07
 -0700 (PDT)
From:   "M.Cheickna Toure" <metraoretk1959@gmail.com>
Date:   Thu, 27 Oct 2022 13:40:07 +0100
Message-ID: <CACi=TC4h6zab6YY9oxwj4cpkjApQ0bAnCM7Qrt2DCjsuhtkakw@mail.gmail.com>
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
