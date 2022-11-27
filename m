Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEA2639AFD
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 14:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiK0NcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 08:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiK0NcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Nov 2022 08:32:01 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53231EB7
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 05:31:59 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id bj12so19883799ejb.13
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 05:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:mime-version:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=biw1utCmNyI+ef9futimPqL2qrgw3YwY9eWMD1oBQZg=;
        b=D580eeqoyjWFp+nV+WKI0I4Z8RZzhnxWvfClRX0nTzFXY/cQls1X9KBMPWfyzqT04k
         JtnzXdlG+7nNIYiGvzseqabY24agvRWViVcZSEOb2ZuhyAeTgmLYj2cdbZHLSGmD6wdt
         lcTUk6rLamvUZgMJ9K/d8RgvOje/tup3bI4oPTVdxYHoxbjXeXmQs7glp1NinS2Jkbpr
         JY9kbCDQiYuXgQKq4yBhuWIcbb3OQBrCI9lTxXhwujVvIYjfvDesm2l2RPCHqJbRezaK
         yxn4RfqzXKwz3nByITle6/WI1uf3TwGx8VLTU40uIgOw6HiXu1qdibPucQ2QQaB5tJqA
         tjhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:mime-version:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=biw1utCmNyI+ef9futimPqL2qrgw3YwY9eWMD1oBQZg=;
        b=WwaspFZm+DIRHKmSQO93rJGEEhrBjGcaddpQqOJ7ZA5dMF628HT8q55lhnGe9NDLms
         e+KRHIbOeBfmZ++dEu6WVksrNcF8Wbf+bv0VscEemOPfW834X5XOzu0RBtdMk0V8nSc2
         zcVgHa/VqcGOgHRsR/AhCMBVO9mCXx/c+YHw9veb2n6CnuKaZ6zzyRasaxjBBMRmEfVw
         hekCngvDqR+LKciibfGnckvApfJtoIvda6oq1lq3XQrwlnj9LvKtRyw1JNq4vQi+Nffd
         ePKF+p7iKeC4Xxlm4BqervUoO7f7eoCJy6hvNKCalaWbamRVI7kzysMnwylSKz1i70Ei
         9Ocg==
X-Gm-Message-State: ANoB5pkY1VJqa2H/9c99xG9p2TYWElmpB8eO94RpG3RI9W3qDupN+evd
        YgI49PPMo2nPPS6ONvIk//jNjSvs3QKlZLup8ejXfso7AEmXJA==
X-Google-Smtp-Source: AA0mqf6hSl2k4QsWSN408cG26b2YlPLuvK4ztPP/FNiunrzclGqOPE2nOwwR91FRjT0GtBzYquQkSWyOgfyip58wL1E=
X-Received: by 2002:a17:906:328e:b0:78d:7f22:2c53 with SMTP id
 14-20020a170906328e00b0078d7f222c53mr23234935ejw.420.1669555917449; Sun, 27
 Nov 2022 05:31:57 -0800 (PST)
Received: from 332509754669 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 27 Nov 2022 05:31:57 -0800
From:   Donald Clemons <Donaldclemons74@gmail.com>
Mime-Version: 1.0
Date:   Sun, 27 Nov 2022 05:31:57 -0800
Message-ID: <CAF5AmZKbuBpzV97yjMO2VgzLMegvzTNvYkKnJDPGLFtDSjoy2Q@mail.gmail.com>
Subject: HARD HAT
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To whom it may concern,
I would like to order HARD HAT . I would be glad if you could email me
back with the types and pricing you carry at the moment .

Regards ,
Mr HAROLD COOPER
PH: 813 750 7707
