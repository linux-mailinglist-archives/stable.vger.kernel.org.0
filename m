Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5466C5A03
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 00:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCVXHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 19:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCVXHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 19:07:35 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2E419C4C
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 16:07:34 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id v4-20020a05600c470400b003ee4f06428fso88139wmo.4
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 16:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679526452;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KNooTPFVMHraNukGqIfEhiISoCNA5eajWiFvPD4t+3Q=;
        b=S5obeBdlIx5wbO/0ERri3Lnef0oEKRyVIzcLVmIAKHzNGSLx3U4C4AI2cSsNLgyoBL
         DIPICdaVbeuiFTE8M5VXwuUqDk8Va51u5NeqPaKAS7AOoFboJOFr5DM7Dh2D1gK/u11t
         IyYOqhjN3Q3RtuflAJbAC0CJOQ/hxGcVFk4RMnJ7Mcm7I+/E8s1LpHMHXiYcNQoMMSFy
         cp2C4vHVrqabXvDYZH6eW3kXustg9Y1nyMxMhKG/gZ902zotWIPOaNJlACzh6vz9ILYS
         t9XZft1jX1geeRctFLgxOiYDobSSy4z5cXlUe2QhbDOBNnJDnMQi/mzscM04tqAu8DaN
         9ibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679526452;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KNooTPFVMHraNukGqIfEhiISoCNA5eajWiFvPD4t+3Q=;
        b=OmGhIXVcYlNK+KzuvG5l1HOA9IeWU5M65fIdTcXP9T3kZjHsP9si9p6cAe2CbJokl7
         LMIjzMjLS48hs3zAQZoKOOzWbjxvp9tk88+coktce4FFSjs07e+mJa87jes0s/u9G3I5
         MHB7myd8VFkW+pUcs/z6ncXzrmzgRhUxe8OqtBlY0ieY3H6gn9Pb+dZ9cWzEQkRSNFrN
         G7hCcWkAaGMh6F6fkDORGQpxaMcWq/Q729QSSDilRWDM9/Zu03JOhlteTvDPZQtUMEcC
         ssZ0sjdvio0KN9AaCiM478h9/9zbDG6IMTGOY5GgKGP4bBJiA0ty/Msv40yLxXrRJwhQ
         7QSg==
X-Gm-Message-State: AO0yUKXsrTXL/m61xW4RbgYUUCn1nMqigUNeSfujlatnRnO/uXq7cCUb
        7JrtHPqFv7YZwFQhNXFpBd/yHpdHHmqO/8QQmZL6YfSYnyLWygRCGhNSUA==
X-Google-Smtp-Source: AK7set+LDwjRx1B5LZkv8D3fIedurRYEFrP5e+rcI9d7aABsBK+wbPZ+F+NLZP2TJL/Lo3jERFtcE30NyywskxcL0KA=
X-Received: by 2002:a1c:4b07:0:b0:3df:97c0:1b4 with SMTP id
 y7-20020a1c4b07000000b003df97c001b4mr271392wma.4.1679526452156; Wed, 22 Mar
 2023 16:07:32 -0700 (PDT)
MIME-Version: 1.0
From:   Vaibhav Rustagi <vaibhavrustagi@google.com>
Date:   Wed, 22 Mar 2023 16:07:21 -0700
Message-ID: <CAMVonLh0jPpZpczXFqVpZ0w41OBg97z+6ixZewWQg_2TxL5ttQ@mail.gmail.com>
Subject: Request for cherry-picking commit 4a625ce from Linus' tree
To:     "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

In order to resolve CVE-2023-23005 in kernel v6.1 stable tree, I would
like to request cherry-picking the below commit:

mm/demotion: fix NULL vs IS_ERR checking in memory_tier_init (4a625ce)

The above commit is needed only in v6.1 stable kernel tree since older
LTS versions don't have the implementation which introduced the
problem.

Thanks,
Vaibhav
