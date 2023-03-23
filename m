Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063166C5B90
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 01:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCWAyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 20:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCWAyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 20:54:44 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4640344B8
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 17:54:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k3-20020a170902ce0300b0019ca6e66303so11481032plg.18
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 17:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679532884;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S65NNEhtl/wDYDj12HwaLDcnWyMxQlf0feSYJSU7SG4=;
        b=K5h9vNxoiqfy7SEfQ5Wzo+mboGfhyCBFgxU4Oaol0Mpt9EoFohJawPBdNrWcCKNg0i
         JsBSK978j7jTfI9dg5gikGn3tf+PQ0h/30/y8GS280h+9P3aqPZkuRkOcUGP7i1IHDEi
         PSwDDw38XODQlxVcPnSgkbro+eGys5CsbJA4+YDHl3/32kzNMa4yzMVm9TiXXPnDHjB7
         o+/dtp9G5JRUX3KnNWPdOCjVYirEsL+zdX1hNrrsRDwA68iG/KFxCZGaG5wzuEgwrJVK
         hJQGFW68QnuCyNvcpGSCPAlKLgTAvHbq+fCtKGLZWebH9x6hzyRw1QaidHQauBLAXeiC
         9RLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679532884;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S65NNEhtl/wDYDj12HwaLDcnWyMxQlf0feSYJSU7SG4=;
        b=5wlLo3ro3obElkegMUYrEpyyy9rERRFBV8vcCjMP1H/uvI8BfeBS+IuZen/1vopMfa
         P5Zo7JpGC9ntLXUJBNq/M6xnSznK9VCtzMdUcYZw/WoQvH3ajQ5KH2D+zKNROZ165qSO
         APMIhCtlqWUQyz7DED2BXxndax7z/arllqrKMmJhqRDMByXhUVZd7Zi2B+waf8IzY6H8
         RqxAWXacwM8MNGKpUMykRg8AVREjm+E8Go577d8S7F3dIM7RPcB3Y6yYfB73EN5WKDuG
         CBfz9q+1fYmAqVznpucQgu8Yuo/ExlnotLzIASS1M/UbE+SFWddBfeyuDh97KdTVTBGJ
         d7ew==
X-Gm-Message-State: AO0yUKX05d6B/ua0wEHEua1NSKP1W/srMpnfPvzoX5vNJKoL1dDM/ZrI
        Ho/af7P80JGVyCxKmtNNiQ677xZ+9tDI4wsxEXk7zEqDhYb9NNCSCVn5bAwOch6z/CK5nEaAaID
        Elxh1j6y+QRKa3ZjcHxq6sFXSxZ8SlndUAblBsLeepU2dZOZTEsXQVspWgKM5HxXNWSFyQNlexk
        MQlx17rRA=
X-Google-Smtp-Source: AK7set9f/VNTVvQn+1oq8Rq6r5f+2ftS/MDGw71HjUFWGuFFKjFkJTo+UfZGSeHtAJxv5QkuQieq05FMn4xTm1wyHBTnow==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a05:6a00:1a13:b0:626:23a1:7b9d with
 SMTP id g19-20020a056a001a1300b0062623a17b9dmr3052162pfv.6.1679532883714;
 Wed, 22 Mar 2023 17:54:43 -0700 (PDT)
Date:   Thu, 23 Mar 2023 00:54:39 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230323005440.518172-1-meenashanmugam@google.com>
Subject: [PATCH 5.15 0/1] Request to cherry-pick 49c47cc21b5b to 5.15.y
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, hbh25y@gmail.com,
        Meena Shanmugam <meenashanmugam@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 49c47cc21b5b (net: tls: fix possible race condition between
do_tls_getsockopt_conf() and do_tls_setsockopt_conf()) fixes race
condition and use after free. This patch didn't apply cleanly in 5.15
kernel due to the added switch cases in do_tls_getsockopt_conf function.

Hangyu Hua (1):
  net: tls: fix possible race condition between do_tls_getsockopt_conf()
    and do_tls_setsockopt_conf()

 net/tls/tls_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.40.0.348.gf938b09366-goog

