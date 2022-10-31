Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB691613D45
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 19:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiJaSZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 14:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaSZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 14:25:46 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A58D80
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 11:25:45 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id c15so994514qtw.8
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 11:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Py7zMGmFnY5XqkiAhg77R2dN7hSoyzUPOYtjNJ4aYi0=;
        b=J7zmPZvF52+bmzqZ6qRdEx5Ak4paSrezDGg8P7G2fvpbL9v9tmGTr7Z9zT2Vj8AA63
         1BnfhxG8nhHLHCDt0cwYiwK4r5N6UNR64lBPUtrTZf6fSXIdLdekFs3g3ylUVZ+7YmOb
         Za8PcqfHRUKLjxhWNvhmLA4orPlRbIvuMON4lAFsQgXeAAHtLNlGRpLsHjX6IxMp7b3q
         kfOD88NqJb8i8cxvuewtKA8FS+x44mMgU09d+9wu551yXu5km1rW+XYRKm6+w1fEYEK/
         ADbu2sheK7ZhMH0FwXmtBcOVAaExiUkNjEMvMoVrM1DRG/RQhBSjxwQbDmFYuOkGLzHW
         0SwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Py7zMGmFnY5XqkiAhg77R2dN7hSoyzUPOYtjNJ4aYi0=;
        b=i78XnoDvEggUEYV4LnMr7kQLxpmeIjVylZXFTdnvxCUr4zzytt+Dp9Y0xdeu7F5FtJ
         L5IF4VDBQ3msGoaxGCxcK/YwThWHjPmQKj1b64mwTuoSBEnLh9pV88IUcuSl9hlmkXtZ
         ChGn42nsSP9HTT2fgDbAqsLjakjOhatlZcUxYCwxWBzR9rdocbu+iIFcqYP9RFNXco1U
         K8jG5+erEGA0ZnYAXl5b8qrGzgWhGfRDAEOdULT+hJ/J2CkdmxkTEwDANNOjhmyLCRYg
         rPZWlFh8NPyr5VgrLx0GsyHwlNFZHPyzNeOLPZqg2Wvy+CiOkaAwf2VOfm/smXoDJJUc
         T0TQ==
X-Gm-Message-State: ACrzQf3t5eghTqeq/3wUbzsiR1HYDuv/aXLr7x/sxw248m7qVavSr2DI
        ANGBuRyig2XxZPT6SF6ehcAK15YPdMAMf+IomqouZ4vt1BYk3Q==
X-Google-Smtp-Source: AMsMyM4DvleLOfTI4yyNbFfISDA448dNkE+5PEUy4PO12LCRDO3+SRsSB0uNdG225ZoneFw2tIHJKeiNb+I9WudgsY8=
X-Received: by 2002:ac8:5a11:0:b0:3a5:7d:35ee with SMTP id n17-20020ac85a11000000b003a5007d35eemr11466053qta.617.1667240744295;
 Mon, 31 Oct 2022 11:25:44 -0700 (PDT)
MIME-Version: 1.0
From:   Anil Altinay <aaltinay@google.com>
Date:   Mon, 31 Oct 2022 11:25:32 -0700
Message-ID: <CACCxZWP-O07hx0QpZNkuG9xPH-QG71t-1e5qZU8hNkkyvFKVhA@mail.gmail.com>
Subject: Backporting 7a62ed61367b8fd01bae1e18e30602c25060d824 to 5.15 stable
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can you please backport the following commit to 5.15 stable?
Title: "af_unix: Fix memory leaks of the whole sk due to OOB skb."
Commit SHA: 7a62ed61367b8fd01bae1e18e30602c25060d824

This commit fixes "314001f0bf927015e459c9d387d62a231fe93af3" which
landed on "tags/v5.15-rc1~157^2~305".

Best,
Anil
