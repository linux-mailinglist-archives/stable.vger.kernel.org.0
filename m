Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA65F675BB7
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 18:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjATRiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 12:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjATRit (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 12:38:49 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2A7CE22E
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 09:38:44 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id y18so6234719ljk.11
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 09:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rYvD+Y0hWTK5jGalCS0NVtz+OqS7VgiDHuFPKGlWG+0=;
        b=EwWvLxVI7O9drWbigmDinPoLG5o+sppVpwC4dysHio8S3PsejVdlqkH9Yo3fPeu6nD
         Ovmu/CoHFg553e5TtEOtgQ9++NgxacoOU+xgou5JKQc7RBfjbh/p2iMBe2kTRj3njh1K
         9FIVZ9Q+e9vSqdM9/2OHgMKMXBLcaZvPMSZk+ZvlUb8fk2eS4CCKm1IRl8HmpvP9LDyP
         tc5UbztN1LvBUsfpmmTpHVBhIse4oCaI5KPJ22/Kk0stTz24w0SBr7yaX4wdimv6Hkrb
         WWH6PN/lbLA9jNQhi60O3Bdk8/WaJYbwimbRyltsbgOZtd1xz5Tu5o2ajdhS1UB0Clb6
         yGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rYvD+Y0hWTK5jGalCS0NVtz+OqS7VgiDHuFPKGlWG+0=;
        b=EdFttgdB+o4Izs6vrQAftzP1zzur8zMCMBnifGqvEfHuRiMuu3KX4wxqJFAUKDO7C2
         DwYdYnYtQxVzQuKap4FAmnbS/rXJPKmdapvtbcVPni92qTYeIqHxt0MNebCD8omVZKwH
         B9nZrzIawFM3eHDKCpXq/UyJhylaAqMqg03ndmM9Yc1Qw+LQ1bPb130mtWoaE8k5IJhn
         1zurtLclzYjPPYTyc7+aVn1MNRh2gHkcQOqOXeO5ymJntW8uAlgtWlRdvKPJOMRPOWcN
         w0IPDLEcA2n4OMW/xAYxf3oB7bxUVpTj2o3hLLX10JX2/WpB1PM1gxtx2e9ANhh0sIgl
         cMJA==
X-Gm-Message-State: AFqh2kqRX5IUz5QCt0kIf84+2357ocoZNLlmZPddAwuAEz4c0ORYQs+5
        TwBjep3nLyb5BgVp7hLf/efG074hNKMihBYX290=
X-Google-Smtp-Source: AMrXdXuROcukqUkACxqOaqxT4nQo7Qerw0koOWwTWkUSykRltypi+NFUKLpsUjWuQ/XvnOyi8Ygvpaj5+n3NLgvf5qE=
X-Received: by 2002:a2e:924b:0:b0:288:7d0d:8a58 with SMTP id
 v11-20020a2e924b000000b002887d0d8a58mr1004705ljg.196.1674236322831; Fri, 20
 Jan 2023 09:38:42 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:3c14:0:0:0:0:0 with HTTP; Fri, 20 Jan 2023 09:38:42
 -0800 (PST)
Reply-To: shellymarhkva@gmail.com
From:   "Shelly Marhevka." <keenjrich@gmail.com>
Date:   Fri, 20 Jan 2023 17:38:42 +0000
Message-ID: <CAPs=1U76QpRQ2PTRkw2Hw-hTrUxL3aBYV1DmbTc3C4gqv01pPw@mail.gmail.com>
Subject: =?UTF-8?B?5YaN5Lya?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LS0gDQrkuIrlkajmn5DkuKrml7blgJnlr4TkuobkuIDlsIHpgq7ku7bnu5nkvaDvvIzmnJ/mnJsN
CuaUtuWIsOS9oOeahOWbnuS/oe+8jOS9huS7pOaIkeaDiuiutueahOaYr+S9oOS7juadpeayoeac
iei0ueW/g+WbnuWkjeOAgg0K6K+35Zue5aSN6L+b5LiA5q2l55qE6Kej6YeK44CCDQoNCuiCg+eE
tu+8jA0K6Zuq6I6J546b6LWr5aSr5Y2h44CCDQo=
