Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD565A0027
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 19:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239966AbiHXRO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 13:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239953AbiHXROZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 13:14:25 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987287C185;
        Wed, 24 Aug 2022 10:14:24 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id o198so5180208vko.4;
        Wed, 24 Aug 2022 10:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=N5GzBDlpn4EAy1yExQjv95F81OM6b4JNo1+K78vn1fE=;
        b=EjvZ10hXWj/xCJOyKmuLlZ7knk21Gxk4pGI1Z/MFTvr8KSoVkMcnmTy4496TbPYhie
         Xy4EwDWylzaF9wrp6g5eD5nxha+0wZQIQLaO7y8b76i5gduHQFOQimnwTMQBr2FPvQvC
         HD/j8LigLyudys9yS6O2HsGCCGJJE3Ai8Qdsq1NhOqbL4xh189bpXLf+HoxAzEm8YM8C
         5IJB2S3GAug5DBiPnUXdcOMdt029tXTEtz1WvMgcNo7JdX1EZmFCVVQrytAj82A/SpM0
         OkpbtLcPrmTgyMxR9EoBUW42JqEbKXusmgAGqb1X8wznAo8p2sADZLXG3PYxq9KDDIBf
         Ocmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=N5GzBDlpn4EAy1yExQjv95F81OM6b4JNo1+K78vn1fE=;
        b=yjQ411Vjpur1J9tXyVXIcWlLJFloNFVpOBBrF28hN7X1vCQcdNHAuRyV3wyrjvDm/S
         KF31mr3iCgRYCebD/pauBSIixJ+PysNCRDtdB6K9EkRIx/D2bAernS63qzJ+17k1r/3R
         O8hkXXUIFnrTwuAuaY8b4G3CSU0VWxyhg671t4O9cRmT2dETgsNT7c6bsn5IpwhfmU5y
         VfKdMGIpW6pBI7qVgpf9ZaGO1RBxfXdb2v3dgTn84Y/ENBFtCweknbJBXS8A4EZL3j2W
         wcQxu1FXLLR8CE0gnqc7BhueVVR1L8nx7+A7dFlsk7S6mE6g6UbdBUDjqWfnoS1KDhoD
         2cFg==
X-Gm-Message-State: ACgBeo22xG2yrJPIx7F+bqYFbfafxtQ697ClHDQuOh+4CRoQ7SFqfpJV
        OlqrRqyNRzLk3XL3N59MpRTwELO5iJWJC/KMqg7TBSEE9cA=
X-Google-Smtp-Source: AA6agR7ZpnpkqgwFqvHOtTclzdI7w8u9Oj5tTxrFqxR6dxTykEVNr6HgQA4A3O9nVneqArcSBJDRrpUey46P9yRfJbg=
X-Received: by 2002:a1f:5c42:0:b0:382:3eac:56f7 with SMTP id
 q63-20020a1f5c42000000b003823eac56f7mr11965442vkb.24.1661361263464; Wed, 24
 Aug 2022 10:14:23 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Aug 2022 12:14:12 -0500
Message-ID: <CAH2r5muO1OkOV0jjJo89Zpvj43u_X95smuujg66-emQFgSXfgQ@mail.gmail.com>
Subject: "Fixes:" vs. "Cc: stable ..."
To:     Stable <stable@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Do changesets that already included the "Fixes:" tag in the commit
description also need to include the "Cc: stable@vger.kernel.org" in
order to be included in stable?

-- 
Thanks,

Steve
