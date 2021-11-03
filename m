Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419DE444066
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 12:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhKCLSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 07:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhKCLSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 07:18:10 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769BDC061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 04:15:34 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d13so2956227wrf.11
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 04:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k5aUrfGdlc8v5jc/+SzOnXbmkrv4P1JTJGENjldZYXA=;
        b=EzertDg8VdEC2AWrVygQOWzRUYUExWd7sZyt3/aEIPRVivtDKUrYz6IyUmu3V5MZHi
         UH/zdLtevHlj3bN9gMlaM4AZ0BjiYrU72SR2NJjp1UX/dPK+rzcAyL3o2jBZVqihTo5m
         uZ2bI74W8JYfXpXR7AtY/MmFAjpjKD6ru9D+UIqUcgVwizefm5BQHVaKll71hzmSRckN
         3Fm/ZKpwrpTBQ3GOBKYDLdcdPI1fUsLOn83MWIzuyh34LWYaUVPpIkTZs3gJWw8ZWnYi
         Paly3pbRKcDNJn58WJa/Ze5m0MJV4Z/V1QdY/wWpCXQsjZKMAnkM+Dr6rVxHKQ4P2YhM
         +hpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k5aUrfGdlc8v5jc/+SzOnXbmkrv4P1JTJGENjldZYXA=;
        b=ffIPrl9QVqLUWcbYWpkNHjjxJKoASSm5A0IMjomrBij/0+a9/83847ku0Ujm+dEjES
         1kkn6zmfHi6zU2Iv/9U4WLtSzRZb9dn1M/ke54gEKaVKTdAw9nfXAs9tV2/WrzeS70qz
         MnhN6j36kMxtt4R4ZCsjnVqFmAvqPsQ5IWGsknIIS2Q4l95a4rvkAmU8kKACF4rB/ViG
         0Fb1h6pj5ztXFDSpqiiTbQ73QuxUQf8KoZWeEdGHraeuNqQdcdcOOfcf/Apj1OpT+Vos
         jaNOi6G8H3tXgKEMCOwXciUTan/+bJvuIaHPhRYfK1xqyP12dKdDykfNk+lvYWXcxvOl
         Wfvg==
X-Gm-Message-State: AOAM530zU+9dEWwoARzmmS5TX/oZAM0tL8DUpptToyuou1v2nPVhRebC
        BETQQrrtqUUU8I0IBzHVuUtJJmqkyTQNQQ==
X-Google-Smtp-Source: ABdhPJzv7K6quUz1cGhBjsWrzNYvSxspMQAjrpM73MzzxDCuezQES1IAA5kIn4rRzEze2QHhELxZJQ==
X-Received: by 2002:a5d:6e8d:: with SMTP id k13mr56229264wrz.295.1635938132644;
        Wed, 03 Nov 2021 04:15:32 -0700 (PDT)
Received: from kerfuffle.. ([2a02:168:9619:0:e47f:e8d:2259:ad13])
        by smtp.gmail.com with ESMTPSA id j10sm1664507wru.15.2021.11.03.04.15.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 04:15:32 -0700 (PDT)
From:   Erik Ekman <erik@kryo.se>
To:     stable@vger.kernel.org
Subject: [PATCH] sfc: Fix reading non-legacy supported link modes
Date:   Wed,  3 Nov 2021 12:15:21 +0100
Message-Id: <20211103111522.111148-1-erik@kryo.se>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here is the backported patch for v5.4 and v4.19.

Cheers

