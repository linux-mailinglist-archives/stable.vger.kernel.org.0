Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128AA519D3D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 12:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240562AbiEDKp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 06:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbiEDKpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 06:45:24 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12EC289A3
        for <stable@vger.kernel.org>; Wed,  4 May 2022 03:41:48 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id w1so1610906lfa.4
        for <stable@vger.kernel.org>; Wed, 04 May 2022 03:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=Se/BROuqe7xDfO/oyeNBsPwF5xIqEIXnLulx7tJNvxw=;
        b=J5pu6GcjnhjlhHObvZDolmWypg5+R41fLfAjq3DCOuWGSaWeGpV1KfPEdnWbJ7olFs
         h+Rc3zqiHDDaRGrGSROgDbxLdUJu350Kaw4MYyFkYFQIen+s33krH3v2e7qF/JhijrFN
         NSKKF8M2sEkV/LSiosYmBs4NKXBvl382MrdO7zZNKynomsCzFBhAHgAOiRlZOjKVX9K1
         kUUrRTUi5AzXIU631YmuXLyNOj9ehS7J41+zOSzq/k3YJzGI7uFXsopJUezCtkqRDGDq
         MJVUT6GyzVorvby6dAGAK9EJZV80+S6w8qShp2P4yaKnPKLY/vGje6fxhgGR9+qmuIOp
         CzAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=Se/BROuqe7xDfO/oyeNBsPwF5xIqEIXnLulx7tJNvxw=;
        b=59Y1vNRzFzj6WIuW0iTdXxyThS4WMOJFd8QXkl3RKSCCsr0z7SCsSvY+fmRsaIoAqe
         svxeIL4oY2JRp4aVeprrA/mIUfO8359gwgKqGkbQzMRxeEx+PY18wwUptPMDp7jQGdao
         axgGWpi8z88EsqJ+T88Vb8pi2vPuDEedcVoRPEeAimIGBhxgpxxcSZ29Y23m1RDZc8Fj
         uObWfbtuXo1D7FZpy1tjUGh9TUOzOfVcW91wDc4eEJwTQybeaYeYtuwmqflZI8b3di+p
         ZhgPzguBLcaeWXst/WZ2vzzSoeRt0CzobcH5+ioZNzoG6N2xlKMgMu6u0h3XRU7ql5hF
         ASbg==
X-Gm-Message-State: AOAM532eqMDl7xMTsyBoknImEm/Dau4YNY2sz8+Z59xdbCLnzbK81mRI
        laKnWMBGK18pth4N95Z3Bx3epKj6T4MW82fXrRU=
X-Google-Smtp-Source: ABdhPJzNobai56AN+uHOgEWSWPNCltY1Os78aioVQjLeSFZWEWZFIrf7Ev5ni+BFzxLeMyXg8bJwZRoGeXkMXfHauA0=
X-Received: by 2002:a05:6512:398c:b0:473:ab45:1f7c with SMTP id
 j12-20020a056512398c00b00473ab451f7cmr4122408lfu.341.1651660906796; Wed, 04
 May 2022 03:41:46 -0700 (PDT)
MIME-Version: 1.0
Sender: mrsanahbruun1@gmail.com
Received: by 2002:a9a:4c0b:0:b0:1d0:25f1:3514 with HTTP; Wed, 4 May 2022
 03:41:45 -0700 (PDT)
From:   Lisa Williams <lw4666555@gmail.com>
Date:   Wed, 4 May 2022 11:41:45 +0100
X-Google-Sender-Auth: _cj9wYq7km2vw7mOjxZaZ09vD0s
Message-ID: <CAELFs-m8U5qU-XMdrUDkqu=94YnqB1_0XBo-Xtwq-u=1LQKzzg@mail.gmail.com>
Subject: Hi Dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hi Dear

My name is Lisa  Williams, I am from United States of America, Its my
pleasure to contact you for new and special friendship, I will be glad
to see your reply for us to know each other better

Yours
 Lisa  Williams
