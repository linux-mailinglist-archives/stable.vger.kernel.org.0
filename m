Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDB6639B76
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 15:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiK0Oz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 09:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiK0Ozz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Nov 2022 09:55:55 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593316441
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 06:55:54 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id z24so10411676ljn.4
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 06:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BT171Unjb6EFvUBvn33Ts5USHKYTfqzQFkQsCflakoA=;
        b=jzoKj1L/r4UR5+FUeZTqHV81binqEb9DgOIc9ggBZySv7OePA13iQO9Q5cn4C/16xq
         sCF+J/LyM/eJMz7wQt3LAj1hYVb/UVek1lykW/Ir50kbYDv0YR/I3K6C+hYb0JedHLLu
         Al3c+tzB+Tv9V64nKITwToX4LLXaywrDLk5ZUUWMerJF1jj/tF1RCr6ffA2o1qhxdu3w
         E3QmKfsm01eiVy+YoOcLTvDE6Mq7abdZWWeaQ/rHj9NC02orOeYeg6qajWXCt5j0n4Fd
         K5ZL7x68e6Ep6ULzIP5ZmgoCA1INeqykTpp7LMWmaUvtEx51mrZlzpf9ztYvId2vbkUz
         8nLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BT171Unjb6EFvUBvn33Ts5USHKYTfqzQFkQsCflakoA=;
        b=18AGvO1b1osQTVYBcTQogVoy33FhKicpGWttqtKMonFbLThR03xwXJM/1VM2yrmZxB
         dox/RYXNHVycdNYdzCW4d+xJYGBsjgp8sLNkdODhmY6JAYvhRoEh7Y4CqwK0dwOQcgLu
         Bjze7aHp0OIAnd2MNIqOOzZKjlO+t+XpeF4NOyveGw5s7yo9bbKHslFIiSlScBRdEPV6
         aDypc4XFGIy0wi39fJRiBqwA+E5FRdy5Ooga9zb1OeDJCSaWHdq6R1gCqdCf0Ut7lgmA
         wsbQFIRYNFOsNSw80wNZICXfrt9vsuAwgQ+/5t2lXIICiMzmaqct1bsVs7tWyosb5fHw
         7ooQ==
X-Gm-Message-State: ANoB5pmHpKyWTmf6wQ5BSmt8EqXrAf6bWD1f7k20sqq0ceNbQhVx5FmT
        fcV9Lp4vBenzI491o0J3wepAJgugW2QXX3/zSoQ=
X-Google-Smtp-Source: AA0mqf5M6bPCmui47ftr9zAjRvGgc5p5cCRHkFP/1n/05mxJQycIVygYqA8UXpuAOT95NbR4IuzfLm9JjL/EoKA9VRY=
X-Received: by 2002:a05:651c:201c:b0:279:a4b0:c34a with SMTP id
 s28-20020a05651c201c00b00279a4b0c34amr393158ljo.435.1669560952354; Sun, 27
 Nov 2022 06:55:52 -0800 (PST)
MIME-Version: 1.0
Sender: mrabuomarhafiza@gmail.com
Received: by 2002:a2e:9911:0:0:0:0:0 with HTTP; Sun, 27 Nov 2022 06:55:49
 -0800 (PST)
From:   H mimi m <mimih6474@gmail.com>
Date:   Sun, 27 Nov 2022 14:55:49 +0000
X-Google-Sender-Auth: pmOiJLZofxi_O_tPPZc3JlfZ1K4
Message-ID: <CADSmb7hvsAAgfMn1sppZv3B5vqL5YHrG8YEgULo+=Xzur4u+Ug@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If you are interested to use the sum US$9,500,000.00 to help the
orphans around the world and invest it in your country, kindly get
back to me for more information
Warm
Regards,
Mrs.MIMI HASSAN  ABDUL MOHAMMAD
