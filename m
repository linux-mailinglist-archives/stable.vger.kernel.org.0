Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45D744405F
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 12:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhKCLQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 07:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhKCLQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 07:16:27 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267B4C061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 04:13:51 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d13so2949444wrf.11
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 04:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6E8SSwBvU1MPlsno/YD4cy1cr8waCEj+zupHwiqb1as=;
        b=nf8T01mBJJMON2IGJIpgiKgzsES9Pha5SHxSKhj6VOKu9bsMe8KBmEW0hgzLuewkQH
         ECdGSgqD/QhskxaYq/CBJ97e6wQbexWlOLL3G0s8ADgg8gk/kj6ZyChOp4W0cYPc8lfp
         YTkPmbABrDB/jtnBamP8ob81lgsQULMQlifrD/fuLaGSsohNbvmFrIfWrKsdZFOi0Vx4
         cfCW/kW7rKJ46EK/ocYWm0dArkC7mifWOHSC6aBQy8f8fCuKEaEvuRmrKaVd1xtpPb1I
         bp1ClsvErB9DOQknprTW37WPmnkThwOU+8H8qJfnAJNi/Y0vp0f4gpx4la/mT7aqijv7
         Nj4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6E8SSwBvU1MPlsno/YD4cy1cr8waCEj+zupHwiqb1as=;
        b=OnvYL5HsWL8f3Ge4WjSIFir4cngCabgNofozsIcvHQ5RfCrpF9+WFHTKmdd0R+uSLT
         Vkn/pTIYg204zgq2Hu8b601aJsIdXszIm/4WnjIGH25C72gwM3WAg9hLZVb2mfuqveNn
         XlYqOnvuFnMa8aEs5xtyw1YEN4qYqH/E/zhSkhXelsKbNNQAOxXmMvs0We3cOGEqe0Zb
         15wjguLjbwfmiReHbRL5OakuP8rUKiDIgzKyzAfeZPTq25j+/l71pttmhVGHg49qrB1F
         3Y6fqUzrcCFHyje+BG1vFoE00dKND44HIxx81VgbVq6F9Zw2RTgzLRL1QH2to7GNIsXG
         2Gyw==
X-Gm-Message-State: AOAM533lQTylVe9ubxorAwltFaTDpp7JKpWJNyee3EjnEqprIMhKPiyR
        kRLjC1I2gmITzmKCwPUWKQ14nXuDi5t9yQ==
X-Google-Smtp-Source: ABdhPJyu8Y4pul7icqO1VMLZJBI9wlO7E0zUBjkoV6DkZ5YfDxZ6UlAAWrQgyXwRrlyTSE1M1aEPPQ==
X-Received: by 2002:adf:f88c:: with SMTP id u12mr44420023wrp.29.1635938029401;
        Wed, 03 Nov 2021 04:13:49 -0700 (PDT)
Received: from kerfuffle.. ([2a02:168:9619:0:e47f:e8d:2259:ad13])
        by smtp.gmail.com with ESMTPSA id p2sm3070082wmq.23.2021.11.03.04.13.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 04:13:49 -0700 (PDT)
From:   Erik Ekman <erik@kryo.se>
To:     stable@vger.kernel.org
Subject: [PATCH] sfc: Fix reading non-legacy supported link modes
Date:   Wed,  3 Nov 2021 12:13:39 +0100
Message-Id: <20211103111340.111009-1-erik@kryo.se>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here is the backported version for v5.4 and v4.19

Cheers

