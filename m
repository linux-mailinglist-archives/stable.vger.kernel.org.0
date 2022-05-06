Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AB951DFE1
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 22:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392437AbiEFUFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 16:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392431AbiEFUFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 16:05:05 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E264D24F37
        for <stable@vger.kernel.org>; Fri,  6 May 2022 13:01:21 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q23so11330680wra.1
        for <stable@vger.kernel.org>; Fri, 06 May 2022 13:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=C+z24Pl7od6xO10XmMEfecsYemTIfW+XARlPRi62dVY=;
        b=KuxQp31+M0xHsRjC3W90MtgwV7+SMbhF6jSu3fmdK1XIOdXKxiArOXvd9lNrr0XkWT
         ZMWpy0IfzZlceGXk6HCfDJRNCu4kFN7DHBKnZNzEXm8TYMrGx/0Ts0qhFWOc/2yCbubd
         GZIryPLq4wQqI8xSApWbCsVoQfZ9LQmc/klJu4HdOisR8NtYY6kmGWcThABpU/ajbvMW
         SJtSc57Yof/kVRAIEjnm0A9K2Xiy2EGmVnAR8OG8MRA9YIPr/oS3WQKmczuXiyrjlxUd
         0ypD0IHILmZy2qqIe+Mpu9hWUytvcexxyJUj7TigWMK1QZjjMrxlNkQlZIfojfWCk+Yg
         umCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=C+z24Pl7od6xO10XmMEfecsYemTIfW+XARlPRi62dVY=;
        b=6DE6o3pDk1ZlWDnGnz1ZdDh3djMq1QXoFYO0MgH0xccqDGYnxMHmLOjc4RPIrmDWmv
         gjJ2yMF3U+bd1E9lAwQVLXwReUREK+aBtreeH9DuY9nwyxXP15dZruHA+mbJXvD1urjH
         3FIOil1b5lhdWxa+eC0hh0E08kGICm9pw43Gth3se+VpFJsufBnFLILwpV2i71/xwx0k
         vmxwmAAzI9rgG3d4lnlBE9tbnm6ePXmYNCwHrX/harL8P4R/GcwXQH/cYQv7HN/SD/35
         DkYVd0ZI2p1vfSX/iwTZT8zCIzP3BFsLMXO8EXPbHklW8my9HIXSJW773KTTHqGezI+x
         VKKg==
X-Gm-Message-State: AOAM531J29S4Xm4SRFUm6E8qed9mpsnrboQdGspiGk4B/F0H+Gc4mm9r
        d+7ZJkbmuszYbRkPoU5fb2RWXib+zOaZktZ2ycM=
X-Google-Smtp-Source: ABdhPJwBNk4zOcujG7YDWnk2c5fSBW/Uu5X0ox7Obx+JwVQDT3xIgC0VgdtLlutfCk8B9hq+9zaEPS0wnFJ0gmymhEE=
X-Received: by 2002:a5d:6843:0:b0:20a:def2:5545 with SMTP id
 o3-20020a5d6843000000b0020adef25545mr4032637wrw.89.1651867280100; Fri, 06 May
 2022 13:01:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:1f1b:0:0:0:0 with HTTP; Fri, 6 May 2022 13:01:19
 -0700 (PDT)
Reply-To: paulmichael7707@gmail.com
From:   paul michael <gabrielbenjamin299@gmail.com>
Date:   Fri, 6 May 2022 21:01:19 +0100
Message-ID: <CAHdQu5bFG4Fr-rjz04XPcKnfFSUHcU=htHqd4-Vg_MPNao0pFA@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_20,DKIM_SIGNED,
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

Every time I retest your email, it tells me to check with my ISP or
Log onto incoming mail server (POP3): Your e-mail server rejected .
Kindly verify if your email is still valid for us to talk.
