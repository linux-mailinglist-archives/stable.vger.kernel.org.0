Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FE050DD65
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 11:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbiDYKBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 06:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbiDYKBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 06:01:08 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160301C934
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 02:58:04 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d15so11383218plh.2
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 02:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=kdTSJmnbBK4N/virhew8A7fzQDKu0iWJnLEnGHSX4Dw=;
        b=GFGaWn8bZPxLv/YnXpJQdteboZmnEBsoMAqSJMJuLG+THbJGuyTVpA7qY5+3L6G7uE
         7N6f9hObhGIF/NVglXcaiiFK2j2lql9TnjTy/CygXbWwS7Atgpl2iSAX6m5qBF2fPaTg
         DRYvuPVj199AXDFFHQS6XWT8soXvuVpEHTg6Pzdt9qa/9zYa9lHvqNUMsSXpq1KaqqPv
         S/yss6TS9UOW0pQVM8pwdvv6JyziKhaj3Kzy0W24mwEjewqt53o5rqlssDuN5MNy75dK
         d9khW6m4YdSu9A5fk4x0zE8K6VQEt0IhQ/KR0aTyToBHxudNQr4BDRR4znshv2XqAYUS
         iWBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=kdTSJmnbBK4N/virhew8A7fzQDKu0iWJnLEnGHSX4Dw=;
        b=F+0iUrMzn4MssFS4nmxA4AAltpxtTiZj6wxHvi7Q1QO/lbfSJw1WUIvZCqTr7wEMo1
         tGzstRil/fzNCnNmK2TDnd6OspIDDYROOHnEztCYDm55avEE93cPwRcGMkss1X1F8u2Z
         r4nfJleS6giDVZ0fyL3mHx9c2QrK0AEwSjEtI1olcNNwRG3V/qQQwufSFQJWla/pRINj
         fNsx39dpa7kRWEs4ehk+SD8V5pejciLaymnj98KaE/vx+Z+XoGBNNY45E/IoC0EHM+P5
         R+u59HLepHCSGZ3gj8e3eibmaKq7NjFt6+E/83Qc6jZQ0xB6CoRzeO16ud+AkBUxQXz4
         hvkQ==
X-Gm-Message-State: AOAM531qmkk5Ti+fHL+JXDiXnKZ7QIM1z8S9gs8Ry3X6DLQF8fUc5bUU
        PHglq2rsjgeGeLZrX+6v+EgIpSTrEaPHDiAG1Sw=
X-Google-Smtp-Source: ABdhPJwbj1GK17j9tqShcsNjqCRru+WytGVdjjYvzoTay/FGQ6HboNSMHCbB4RjWArhWaHtrGkllj5OeKc5Tfi2kW+M=
X-Received: by 2002:a17:902:b10e:b0:156:1bf8:bf26 with SMTP id
 q14-20020a170902b10e00b001561bf8bf26mr17324669plr.8.1650880683413; Mon, 25
 Apr 2022 02:58:03 -0700 (PDT)
MIME-Version: 1.0
Sender: wellside347@gmail.com
Received: by 2002:a17:522:41c8:b0:442:10e2:526e with HTTP; Mon, 25 Apr 2022
 02:58:02 -0700 (PDT)
From:   Lisa Williams <lw4666555@gmail.com>
Date:   Mon, 25 Apr 2022 10:58:02 +0100
X-Google-Sender-Auth: -aKiqtGKZliZ6cRZgrI8m-8AYM0
Message-ID: <CACHpVn=6gA6CvT4DHEpy=PH4Siff6pRGW7xEyxGKiECOZbJ0gw@mail.gmail.com>
Subject: Hi Dear
To:     undisclosed-recipients:;
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

-- 
Hi Dear

My name is Lisa Williams, I am from United States of America, Its my
pleasure to contact you for new and special friendship, I will be glad to
see your reply for us to know each other better

Yours
Lisa
