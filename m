Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E936B6A12
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 19:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjCLS1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 14:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCLS1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 14:27:16 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D23539B83
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 11:22:03 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id j3so6514843wms.2
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 11:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678645261;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IjxCsWjpVR9S+80StEn7s0e01LeLFs8YAtijTqjnySY=;
        b=HYITGaJdr5lhdYUtdpfeMWXRb43dp7GCLFXwowWPGVxGCxbRpdMQ82CPNzazdjm+it
         d+C622M60FVkfnnQ+d7XpBsO4J1a0+JUSaZSnXVK8mQHAltknzb/H0k2Din4uZnCWUOF
         hdBr7E0yIQEIyNK4kTyfcG52RFHlKv62lgbh27r5FZn/bQIj09oKjXvw3YPEocprClnR
         C82wz1TJO/25LFdgTYfPZcQAXqY+4ZGseFyOyGkubq7PI/qLaMHe4U/zMZH/GM49LT0j
         iMzp/vc5LTLdKQyEpxJePcQ6Wuy/1bD7iIuNX6j+qobrRxSD9Kwx76vfWwkoH0uUog6d
         ThpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678645261;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjxCsWjpVR9S+80StEn7s0e01LeLFs8YAtijTqjnySY=;
        b=5v86YWwrpsub9cFJhN4DLlt9W1E3XxMf4Y15HZTnBhIroCtTzQdR0vofkuSGp80gR1
         ZlmtVpM9hflrg8dbwGgisrQIyvtSTQJSfI6ggw2WvOFQJ/n085Xz3rBLlyOdyoUPgfuu
         SLCSMBxbUuUtiBgB4UuxcHdN0HWw6gLC5KJOjGGd6lC//nKPoftXAksoIsUgbVt0t36r
         m4UnVaeY9HENJMk6n+DJCNRvLutRJtw0CYToiNu6Ry78QQUh4XuCBjYNU2mN0UummVU6
         KTbTKJMWHB/LrmMJwxyalc97N2xulS5/YfkQ5Y/T8ftT410oboSfHgdrIN5Nm6yUkm2u
         l9bQ==
X-Gm-Message-State: AO0yUKWE/yhIdFOcL9hv0unG11WKS7CV5CJUSsHoatGhgUlI3KLPvODu
        mjE3sUCZCpmxwtQ38ElOiGlfZTy1ZHevzG1pipg=
X-Google-Smtp-Source: AK7set8SZLApWzPVy3yrbH0l4YjldVka3l3oegFtSrH30dMqzqw3nm4/Ga2YX3aKu9v70SHD/eSs5XqBnPhfywYcC/c=
X-Received: by 2002:a05:600c:35c9:b0:3df:97cf:4593 with SMTP id
 r9-20020a05600c35c900b003df97cf4593mr2508585wmq.6.1678645260779; Sun, 12 Mar
 2023 11:21:00 -0700 (PDT)
MIME-Version: 1.0
Sender: toussaintclementina18@gmail.com
Received: by 2002:a5d:6202:0:0:0:0:0 with HTTP; Sun, 12 Mar 2023 11:21:00
 -0700 (PDT)
From:   Clementina Toussaint <mrsclementinetoussaint65@gmail.com>
Date:   Sun, 12 Mar 2023 19:21:00 +0100
X-Google-Sender-Auth: z93Xn7fS-a0g1Py1EGr3j8PjuXU
Message-ID: <CAMW=+b5MrFNMRHgPBoQJbRzMY-DXiKRSKrHx5FLkBHvnT+V=YA@mail.gmail.com>
Subject: Greetings!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, Dearest Friend,

I Am Mrs.Clementina Toussaint, I have something important discussion
for you, please reply
urgently for more details give you further information. And I hereby
advice to contact me by this email address  mrsclementinetoussaint65@gmail.com

REDARDS
Mrs.Clementina Toussaint
