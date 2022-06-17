Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A29854F8BF
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 15:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382500AbiFQN6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 09:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382496AbiFQN6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 09:58:04 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193AD31DC2
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 06:57:58 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id w17so5871404wrg.7
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 06:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=lW2zUG8BmTFEvhpMiRIz4x0bqTkZp6EAwXwN8nSZfCQYZF62eJBvtZ6L1vL2SGHYdX
         E4pZomuLSA96BR5z6lougmWbWIol1dichss3YfG0QREhnk8WlpktcY7oUZGZKN49UH2n
         biMjP6DD++/dyY+fnvQuW8+D2y7p9YYr/yOaqMEe5Vy95101KcEgrB+UrHikXyL072O0
         GV25bFpFN7Fa4czNiFk1SGnJZajhecYyEkhFgvqUJ+DexmMoYLDFA2Wxl1b+dLvCpqS5
         QIaC2WuHij1bvY8zQF8sxEui+2ZZv4oYo3GTQiHiHUOaQMnLnFS0sFKXop8/d4x3RJji
         AQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=pLaIhh3ERg7J5ItPDeZOoTzbzgfwV4BmRMwupuZAD2x93IXyFvmqa3afVQCVdyLVau
         8KnwabYJY3NXOD/9veXYb/wHXhZWNSwYiPmeaNilR1ufI4lavyjz1U9ItJKnPDNFGZbX
         Sh4lV37Lk1cCt84kjPx0lpWG3oAVAvnWVQ3uxFO+FhbWOuFK6jzWL5YIEoOvMvXiiXcN
         CP8z/XIlPXc2z8VJ/JCxzw35l/shdaLuuWT1/EL5+sZ5EKvnKl6TNaKS4Ewm5ksJ5PPB
         yvuO2hCC/VGkqcKzS7t+y3I8bGDShwEvxsjWpYDGOGqnAeq+Uv+lNmuHYFxp+3Qt0Ney
         NvNQ==
X-Gm-Message-State: AJIora+Pe+D1tr4yHlaBm8bQu/wJBGoMSDFWDRhX68ZPgU1lto4sqNO/
        1wbdFjBa0DgvGEg5vuu7TGgvZIpzryLzDdeMD/U=
X-Google-Smtp-Source: AGRyM1vPiIAuOzzAbqpVz7KasHqEkFvZUpO8KMXDuYsDMR1JUKntFWJmxqAd/a8sLKbfzRTAB4bYj6i+TJ0xa114ceM=
X-Received: by 2002:a5d:4708:0:b0:215:d1fa:1b9e with SMTP id
 y8-20020a5d4708000000b00215d1fa1b9emr9651787wrq.202.1655474277412; Fri, 17
 Jun 2022 06:57:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:156b:0:0:0:0 with HTTP; Fri, 17 Jun 2022 06:57:57
 -0700 (PDT)
Reply-To: davidnelson7702626@gmail.com
From:   dedi mark <dedi788877@gmail.com>
Date:   Fri, 17 Jun 2022 14:57:57 +0100
Message-ID: <CAF3O_y1fPgF7n520eVpJ2a2Zv1k65JvB+Kxn6apU3v4Zrpf57g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello friend, I want to send money to you to enable me invest in your
country get back to me if you are interested.
