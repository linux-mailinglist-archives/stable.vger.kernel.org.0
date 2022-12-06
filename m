Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC4864414D
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 11:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbiLFKb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 05:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbiLFKbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 05:31:49 -0500
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495DD1B1C8
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 02:31:43 -0800 (PST)
Received: by mail-vk1-xa30.google.com with SMTP id u9so6589006vkk.4
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 02:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RFIlVPvjXVPxF9O8hj+K8nxMxEboiDUUTjj8ZSFcdS4=;
        b=nh4KYDCXwS8Kaz9Sq4PMjThqs85cjyqKInQj1uItRMMm5pFjxyqQ7bmaDO7v/wLYB5
         2+yhTwnOV6AiLWwJkxB5NxZ6zgjpN83LYHxHAuWyLkRx3W05t1oGvxNid4E3/kUD1phM
         18hX5rDglIqmhe/Sa2pZdTPE9oBt9DuCTx/Z0+V4j3UhbTBokoAScPGVS3lkszQ/GmAz
         +PYwua4arHWcNSUGSV4ItgeTmZtOn9HM1eXMBPQnYKD/oDC711mNSBPUtJq6q99nM0bJ
         Jmph8QNsyzqLQoeeeHQ78DOclI4ZHDuA09ctGkhncrJ+f2LZP1mtwoHVw/1uzEZx83Vm
         UJQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RFIlVPvjXVPxF9O8hj+K8nxMxEboiDUUTjj8ZSFcdS4=;
        b=l3YyRME1Ow38vt57gkBbXs3v6nKd1nGlQUVQ63mAbMTAH+4pCu+z71ss+Olx0B+yLk
         5W7uOAV0GbM/wvLFPz4LvdYQFhpjo9FQGJbzHm6vxlxtpbJfthVTCAb7E3rI+OpCexva
         WiPKqt5/FSlqIVJQSt5bESCRaDp64qCtFEHjCIivS2SN7TD/7L8wdTPrMX6cU0t1bHVO
         Tmrb4vLflR0dwq4ZEGmnJb9KBukZE3Gp2hDl4gpYuv6TAe+pn/hvAgDIhfm/aK1CkD/p
         fcHGRNbZZIvqHMfWKIpSgU5E7y1su8xMgmk3x8/6foTaPR56QajM8JQ9sjTw3Mbq2znO
         Papw==
X-Gm-Message-State: ANoB5pmjecRgYyhem0jjlXnDOIqji3pmZy0SdXSQxWHvP6KwXZeZwbfB
        zZWkygACrVqoEfOHDHbUbpUBLaiOD5dVLHhsDJ8=
X-Google-Smtp-Source: AA0mqf4KOHbb8K7a4YwoI5BH3JLwfMJlaw05drqe/fC6LXeL4PCgUelYVNzUADk3TDkwAkwZ5MdeXPOwXpFZ3DNwHIk=
X-Received: by 2002:a1f:9c43:0:b0:3aa:e2ea:ad36 with SMTP id
 f64-20020a1f9c43000000b003aae2eaad36mr38208397vke.29.1670322702260; Tue, 06
 Dec 2022 02:31:42 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6124:268b:b0:335:d38c:73a9 with HTTP; Tue, 6 Dec 2022
 02:31:41 -0800 (PST)
Reply-To: te463602@gmail.com
From:   "Dr. Mimi Aminu" <mimiaminu319@gmail.com>
Date:   Tue, 6 Dec 2022 02:31:41 -0800
Message-ID: <CAD-C4f7ErYLMEhgztcYC=Qj3zMVTkpajGBZMrVxyc_2SqA4k=g@mail.gmail.com>
Subject: Very Urgent,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,
I tried e-mailing you more than twice but my email bounced back
failure, Note this, soonest you receive this email revert to me before
I deliver the message it's importunate, pressing, crucial. Await your
response.

Best regards
Dr. Mimi Aminu
