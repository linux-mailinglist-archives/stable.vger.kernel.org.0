Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7F854B0E0
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 14:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244085AbiFNMds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 08:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244453AbiFNMdT (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 14 Jun 2022 08:33:19 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E516844A09
        for <Stable@vger.kernel.org>; Tue, 14 Jun 2022 05:30:39 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-fe15832ce5so12227293fac.8
        for <Stable@vger.kernel.org>; Tue, 14 Jun 2022 05:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=lBFrwc11MgcaK75qf3EwNhKoIfwLYz4Dn7scEjO7Hwc=;
        b=Z+ucsCzke1ljWS4cqfALKMMGupruDUWJLkj7wB5V9Oi1w0Htkni/uFKIVKHP6Y9dua
         BLt/swZqljRUWIdlzLHmtjWTE8DqScuLIsHRGUoOpPyTMIBO83NEU+ItQYL5SklcudH9
         RusTsLHVPcbHQqOq4rDe9nknbNzaE1ZWYP+3+MYksLHV/XBLBw80TkbAWNjqLnQGkSkf
         gaTniVLngmRD+syc8rMBWisUxOlmI1D6+uPd6e0fnOkHZy8LurJk0srPVBbeeBnEBfcQ
         YR9YY57QumrDAI/Kgc9LQCgxFCMSuLxtQxHfNtyD3TQ5wub2W9vxZX81EZs+4nnjj0Ye
         Y8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lBFrwc11MgcaK75qf3EwNhKoIfwLYz4Dn7scEjO7Hwc=;
        b=76e8N5+QkinQv3dC0S4QvTe841toCnaPkshOTtsco99ZCM63fNf9sA2v/CKW5dmZz1
         oFQVqmS8mdNd+YCz0wY25zRdaIBqo42X36OLut2sR/WcNDrjw5gqEIXFHzX+ZD10rN3F
         8OlUoTngsQ+8ZhPxVESFD7D0gr8EuA7kRgXk5Yq0c9Y6vphj9MNvkma8soPtWieTWN46
         XoL1YEuVBSghArvhxJhQWW0x1kBl5/VTXZZQgaPnRhZbfBGDL+PIBOQoGKugZllPZprd
         j/MtjCnNUkSpWuOlIMMGRjEyJN2t+5VKQ7sZ+6bKdqds8LbH9vCQ75sgVK3n7tX4H+ml
         bs0w==
X-Gm-Message-State: AJIora9dgQyGpFRrPTFlNELh2Pas2Y5X+1fGcLWAxgHZeh6X16gBHQ/S
        qvE3hPf/ZPlf00NU71hf+FZczk7dI/zhy9YmahI=
X-Google-Smtp-Source: AGRyM1v+Pez+xsHmQdF0WkVOeHz5rB8WoDNmHKvGzVEDbQ0JiM5hOGAdnKBWTQvhFKcmi3/9Cm//U+q5SKf2kkaGxiQ=
X-Received: by 2002:a05:6870:d287:b0:f1:c50b:9dd1 with SMTP id
 d7-20020a056870d28700b000f1c50b9dd1mr2115019oae.45.1655209839018; Tue, 14 Jun
 2022 05:30:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:c46:0:b0:42d:ab20:ed24 with HTTP; Tue, 14 Jun 2022
 05:30:38 -0700 (PDT)
From:   Daniel Affum <danielaffum05@gmail.com>
Date:   Tue, 14 Jun 2022 15:30:38 +0300
Message-ID: <CAPkju_NUrTyruAOjQR5YGNXoqdv64NK0=m28YYbE93z1H32PqA@mail.gmail.com>
Subject: Confirm Receipt
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear,

I am Daniel Affum a retired civil servant i have a  business to
discuss with you from the Eastern part of Africa aimed at agreed
percentage upon your acceptance of my hand in business and friendship.
Kindly respond to me if you are interested to partner with me for an
update.Very important.

Yours Sincerely,
Daniel Affum.
Reply to:danielaffum005@yahoo.com
