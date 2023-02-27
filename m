Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA9F6A3609
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 01:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjB0A6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 19:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjB0A6Q (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 26 Feb 2023 19:58:16 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6307EDF
        for <Stable@vger.kernel.org>; Sun, 26 Feb 2023 16:58:16 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id i5so3408262pla.2
        for <Stable@vger.kernel.org>; Sun, 26 Feb 2023 16:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HZ6EvyfqhGG/NgcCDWOjrdRqV3g0o4pPRQIgirG9ZNU=;
        b=AnI3PehDb5X62omF8RNpKqxD51rvgrtSglLpsj9/5rdQTLekfaogc0ttr8B4+h3/Kj
         2M8E0epo3AsN3lumMKval5XX47oBvMVY+KIPVlDq6tS2W5JnvaBivgV/xn7OfJyJ3eGC
         YQasMva6q5GKBwIvW6hyh3nXV4fqRPARNyPJ+a4mNFszs6GbLemwricArcCW6k9B5RcR
         qkkG8k0qvr5Gb2kpFBEfDcBjI0Ct0d1rdMqpyW6zy1jWgXSludDD2NNBtp8R04Uz0vRH
         1pPkrSt9KFLFZcKdnVYHOtwJhWBKQRnVFBTPj8bn8m1j/smCfKgOaQz/dIT4aUMV4kFy
         WZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HZ6EvyfqhGG/NgcCDWOjrdRqV3g0o4pPRQIgirG9ZNU=;
        b=zWn7FCgR18qpYqe5htm1SGk7dLWC1GyaP0YqQ4bAJ89X8Ytb4RmU2VxJoRuIZlDyOB
         xb8zlZNovcPCnd4bId0TZsOPL44bngGpMPSG217qohXjC5AQe89yYEr4F83IaxnNDtue
         B8i0ndmTIRFrJ/Xd/P5OLj87DFnJYTZroiLQspBcwQRwwt3am1Zs7CjNuPs7P+FcX29E
         ctlRHT7yFKQogE+UVX/Bxwwfk7zWno5YttoSxc/kJgcRja4675j5A/n77ifzaKd7O0HA
         Zx4mN3vVWpzw9FZj2kfRg3SKId69/gtNhxgWvmGiByEBJRyvFnHyvHD8O4y+a5roTJbd
         p9yA==
X-Gm-Message-State: AO0yUKVJkg5RxZGm4XBNHtoSqSxVgBHAyX1O4WRAzlS8EEhSPxvzi7hl
        0X8ZFmgdSRNIOklbqGrh6UgbasrwLKW+MThCDDI=
X-Google-Smtp-Source: AK7set/cgAc+Gn+QVSqcBRQf47OvUPDljyWC3c9Q7QnhW9KY5EWteuXv0Xc5q87pZaamn7Azem/T2DSMvTyZGHuGYD8=
X-Received: by 2002:a17:90a:3ea6:b0:236:6e4c:8a1e with SMTP id
 k35-20020a17090a3ea600b002366e4c8a1emr4072651pjc.1.1677459495230; Sun, 26 Feb
 2023 16:58:15 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7300:1804:b0:9f:620a:97ad with HTTP; Sun, 26 Feb 2023
 16:58:14 -0800 (PST)
From:   Anderson Donald <andersondon401@gmail.com>
Date:   Sun, 26 Feb 2023 16:58:14 -0800
Message-ID: <CAHF-t+Q52xKiz+eb96hYgmS8M+1SkViP7G3kQWs7kz__1eFMsw@mail.gmail.com>
Subject: We finance viable projects only
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.8 required=5.0 tests=BAYES_99,BAYES_999,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Attention: Sir

Our Company is willing, ready to help you grow your network and offer
you Loan funds to complete and fund your existing Projects. We can
send you our Company Terms and Condition after review of your project
plan and executive summary of your project, if you are serious and
Interested contact us for further Information


Best regards,

Donald Anderson
