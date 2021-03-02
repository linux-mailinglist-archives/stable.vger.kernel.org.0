Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD36632B00D
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbhCCAa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349163AbhCBM7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 07:59:05 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5930CC061756
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 04:57:50 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id u16so1762757wrt.1
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 04:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Znmqo7L1fy9MGUvv2+ShAXu0D1vZCP0BjrZZR0D0cAc=;
        b=TZu5GJhMJzJrGkUsWBVKLdB5Gifq4vEaUuGYgDJClwvtDuqxwcSj8ugEHxNhIQ15Yp
         fClbzwVG091+nuFV4pHqv8s/QXfR1mIASVNDrV3fKda7CWO6SQ1baSCvL2G1vMF/e6jH
         tf1caNTUYMgmzMHYaIropFq7E/t5UTJDLV5/V1+Re2UnkUS2Dp2HtgHEY7w1yNfgYEo+
         0KZtvivuUrBnkiXm6N9QSd9YHiYBAo7CeKQncE55IZee5M9/7n/OAqbPbmLH0AsPJqlj
         H7V5KYGQP1sQjGDdhizWF9DyJprhNvvRsNC2Py0WcQoDX3GU+JQR4NU0sYmDPyS2Cx3w
         qO0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=Znmqo7L1fy9MGUvv2+ShAXu0D1vZCP0BjrZZR0D0cAc=;
        b=lBMx3SkHIaXucTRoQoiZ7lvXB4LBVA5R41I23bWbPVkJ+eTHWtGe6VjYGg3a69sdDj
         UAbl7CjOuJ9+u6T14PI1Qo4b4/eDXcURczTecdIXVS96L4A9JHlmkq6YSaCziDV1LkhY
         ypiKhBtBVif038E4M95xK+bu9iNJITiUUEd08PKDWHkPk/vWGx5A7ArwKesVdXTXs/Xc
         XdF+6Yn3d7pX8AXQzs3Q9XsMoeYnUT7/84Fo+7CjSQ+s3DTjVOEcssVCJSxWzZREaoG9
         51BaIX34p6JrA2gL9nilZSDBkKyqwFChWCvT3RQdruRBWQGJGmkiRmImjuihLEneeoip
         2csg==
X-Gm-Message-State: AOAM533Rq8HcXWwHmE1TINPYC/DslUOXslOnExeeNa4v/B4R4k/f12xi
        kl3OlBKw5il5eAjzKLWDSCQ=
X-Google-Smtp-Source: ABdhPJyq6URdYOlq9vLNvFlihBhhcqcw+e7Sm0JV8Em8SJ+zgWX9lLzR1b9MA5fS2nvXDOI4SBPAKg==
X-Received: by 2002:adf:d217:: with SMTP id j23mr8194617wrh.113.1614689869056;
        Tue, 02 Mar 2021 04:57:49 -0800 (PST)
Received: from eldamar ([213.55.225.172])
        by smtp.gmail.com with ESMTPSA id p190sm2621704wmp.4.2021.03.02.04.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 04:57:48 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Tue, 2 Mar 2021 13:57:46 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        YunQiang Su <ysu@wavecomp.com>, Helge Deller <deller@gmx.de>
Subject: Please apply commit 2347961b11d4 ("binfmt_misc: pass binfmt_misc
 flags to the interpreter") to 5.10.y and later
Message-ID: <YD42Sh5n2sjF9tNj@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

2347961b11d4 ("binfmt_misc: pass binfmt_misc flags to the
interpreter") was applied in mainline and included in 5.12-rc1.

Probably you could argue here on both a bugfix or feature addition.

My intention is the following: In the Debian bugreport
https://bugs.debian.org/970460 an issue was raised with qemu-user
which needs to know if it has to preserve the argv[0]. As shown there
it is an issue with multi-call binaries.

So again, not sure if you want to consider it, but defintively
Yunqiang Su and others would appreicate. If it gets backported we will
pick it up automatically.

Regards,
Salvatore
