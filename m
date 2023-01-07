Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C97666112E
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 19:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjAGS4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 13:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbjAGS4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 13:56:45 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F69101CE
        for <stable@vger.kernel.org>; Sat,  7 Jan 2023 10:56:42 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id vm8so10584096ejc.2
        for <stable@vger.kernel.org>; Sat, 07 Jan 2023 10:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AFjVMQAPKgtgwAjgeo4NHRqhJ8zRjmZtRiTh9HjRnnw=;
        b=HqPT/WPnhbgXa1QKnwKrHbgmAXsVpZSzCd0ICOn5nxZTPEiHMmbzlyB5B9n9xY1LG/
         egqWfxBAfRJWDsjD4AXQvwfccwfPBxciSJ4yMFWArvdOjLYBNlNlfIXjtxY8F3cbLkM2
         hwhtl3Vfj3hN5l8MeVUZFA7DySFRmTKpww1DUVkpvIqgCZxA+yxqrhYsaOt+RbkHh7/M
         mPyjm8+SYZUedg27032XHciQUqiYnwpipsDxBmna1KnlnzkUMLQ7CaE+bgvWjDzntZCK
         +OdVRHmMnjXwp7Sh+mwxBTSHTl2s0kmuWdpAfxzdKtul2IrQzPRPq6rDbK9PSMVHvTyD
         WgJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AFjVMQAPKgtgwAjgeo4NHRqhJ8zRjmZtRiTh9HjRnnw=;
        b=rV6vu2zAZ+C73oK/4gW9ajBirqFwvw0srrT3SO/d5hzjWxeptyN3q2t6DZgnUu23AX
         06V6Yyt6EKONWsv7yuPNhbhQT/QkvgGjwkDc0rw90X1/oG5DmPzgX/6cve9qNzRyWn+F
         1LJVdajdiS14F9ZLPvetQtV87Y0wkOetd3bkldpvtbwma4EeeZMoEJcsNbcB9TKJWg4p
         ZgwYot5eKGNxsSYkcRHfrPl8OdO7VWTFV2plXCk0BuLplGUtv2fNYckrYK7QO9tEy+Ak
         /+0NGjajq0QP7LdScdmu6gy6QQSqW3qw5W6cvNF5tX3EfoW/e8kv5pDKyHNS+Qq7RUb7
         8WRQ==
X-Gm-Message-State: AFqh2kpgs0BqKNfcUxu8CPsQCIXhAejY02gkqD2fs8J4rkty1/jwGd04
        2Y74lhrVO2kptJoDdwwNl5WjGgMGgOUCS9yiUqw=
X-Google-Smtp-Source: AMrXdXtYdFhCQGnqn3PoxB8xnD6+isf4Gz3XpBhcvgc3wcQTNTJggJFl9LiTyhWubKirTMxZBeRjo5y0k4pWCctzvEQ=
X-Received: by 2002:a17:907:209b:b0:84d:3a2a:e525 with SMTP id
 pv27-20020a170907209b00b0084d3a2ae525mr44395ejb.634.1673117800639; Sat, 07
 Jan 2023 10:56:40 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6f02:81b:b0:27:37f1:bc15 with HTTP; Sat, 7 Jan 2023
 10:56:39 -0800 (PST)
Reply-To: lisaarobet@gmail.com
From:   Lisa <smithgrace507@gmail.com>
Date:   Sat, 7 Jan 2023 18:56:39 +0000
Message-ID: <CAJ8KLPbckcLAXXZaMv58jRTxktvRBmX9D28-qme3uFMqHRycBg@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 

Hello Dear

How are you doing? please tell me did you receive my Request?
