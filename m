Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842E044405E
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 12:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhKCLPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 07:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhKCLPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 07:15:34 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C304C061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 04:12:58 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id b12so2992489wrh.4
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 04:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z2dl6DaYE9CraVHFrENxxk3AEPQOSjcvm8GNCeHtckE=;
        b=CDHDfhUGbB+TEch6QVVKEwXfmsa1t3SIVoP4pS1lLQmo8hTdovZ0rduVBdkMGbfyu4
         tCxNSUvSfd5MMLhjHdLRosuUDmcxDFWsEOKA381Refttz+NKIPM1VYQfpinYiN0OMYZl
         260zpJkG1PBKgPQuMCJ4vB4I41jn3bMR18qKyi0SzVIQvLWKQ/s1j7LBt53QvkT3ti9a
         FUPX8BHZLo5GJhKVFFYoNfLe3Ny0aRxmqPmrqx7Y2csN7DFclk9V08hdoBEEzdnyvPzK
         eF1oy+13/aoXJGWuT4esT1ffsn9ixaIH8cd08pm9JWJtwQw5wsCltCemhu6PknkLPiNP
         L7jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z2dl6DaYE9CraVHFrENxxk3AEPQOSjcvm8GNCeHtckE=;
        b=jk4vSkiiAjBq35a9FLDcb463voTZTAON/s7K6Zr2c16bFT7krpCg+AKXR9mIWbi8jh
         /aiI36Z6dnSSqnqIVBgASbJTthfhy0cz+R+AiwJEL04V3TVRoXK0PfVbyjM7FlHunSaC
         bGHjtCZeQ7gqIYm//d5cVJwqrPH3L7xYg9qSnRcHXw3Hka3IE0DVQ3YiEwBIYg0+n1E/
         sTS2hIs5/tSCZs1a817gSh3HG7J3lOlWD+lQbolHGt/MWcwaD7ujO0OeUNt0CVoxYKVk
         v9qmBRi5gobQlJycKODQ/E3d5D8q+Ex6RFZlDHcQKCKVD6bAs6puITPXd2RD8GizZB28
         Pf+A==
X-Gm-Message-State: AOAM532prccFyWqvkHy5Xg2eO+nvqid+C1jg/qCvlbWjOfR09y9Ua+Iw
        opOv51k0Z8T8piLEn0u7Ataa5bS+S6jIAQ==
X-Google-Smtp-Source: ABdhPJzj5KR0pFdAmS9m5/JVJtkthbQwTryzJNO9+7XZnK7jOQxH7NjaATgB+QXzkP6xp5fPKGdpxQ==
X-Received: by 2002:a5d:58f9:: with SMTP id f25mr49475350wrd.206.1635937976805;
        Wed, 03 Nov 2021 04:12:56 -0700 (PDT)
Received: from kerfuffle.. ([2a02:168:9619:0:e47f:e8d:2259:ad13])
        by smtp.gmail.com with ESMTPSA id t127sm5489960wma.9.2021.11.03.04.12.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 04:12:56 -0700 (PDT)
From:   Erik Ekman <erik@kryo.se>
To:     stable@vger.kernel.org
Subject: [PATCH] sfc: Fix reading non-legacy supported link modes
Date:   Wed,  3 Nov 2021 12:12:39 +0100
Message-Id: <20211103111239.110941-1-erik@kryo.se>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here is the backported version for v5.4 and v4.19.

