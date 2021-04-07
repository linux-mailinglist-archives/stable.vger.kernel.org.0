Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DB9356C5A
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 14:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbhDGMli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 08:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhDGMli (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 08:41:38 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66389C06175F
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 05:41:18 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id t23-20020a0568301e37b02901b65ab30024so17900604otr.4
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 05:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Sem0tpTN9T3MD/VzCK2VyBDgkBfHJb9H5xhwkgEpq7I=;
        b=leRKoohDPY723rGx7Q+bDeL9T1PoOxvfeEy5IURvWaCMCW8EwrpiIWLke+6TRDD+RU
         LCkK/tkR8dAFIIXjN3asoCOZWYjsZqEFc9z1nfXB3mgBxn9NF4dZRDhMcWqPpVnMz4TG
         nu8qbej1/YMWAaozQ4mPyCdyWeO9WOHdSno7fVIItc7hj5RLj5DZLD6BaB91odKmczXu
         VDC1VtjUZIKCbO1TNUv9RDqL68gvQvyNWVBVfmlxDyAtgBxgoKCXL8/RQz6z/9NJ5h88
         Bvo5OGQIry4FOZglJWotLxFXm/OWT39hShpJgawuxTOrOhCfUwgqQesnkp14NNIn+xVn
         egtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=Sem0tpTN9T3MD/VzCK2VyBDgkBfHJb9H5xhwkgEpq7I=;
        b=Yb2BVWK/KV2c4IGHl5jEbP8aVxhjmJe+Z6Z4rt2LSual33F4rW/CbeSVxLra5E+CbW
         bmUS5znmL/5s6pVKnTVLH9qsLUaNpU4mp7LORnLCFioZTifW0Ns0Epifrc34DWADEO/+
         y7W3ruLNkHUJntDX48KWPYzVpiKApRCcIC8GbzfdxR8A8rtU1OhP45GEueVFFZac1XUc
         BmKVWAU+QWD1pmgJ7pNr487eBAs+17vuDYD2xmBkX52G9HYS+I6isXPw6jRf5nLKqP/i
         j9/eOYBGiWv/MlKwbqReBDXojwI57ZdakVuahuVQXlDMGL6NR37Qx4n3w/xVJlxoAGH1
         v7gg==
X-Gm-Message-State: AOAM531k6cyOzXmSTCC/D2Tlnssai+mAJ62CuCidfGCX4TG+yHGmbIWk
        YI4medCRbWcTornFe9fhQQI=
X-Google-Smtp-Source: ABdhPJy8NTY7nZtCafTvU9QZFhEllj2TLVeBY+t7cU9jLXX3q6uchtVBAPvF1na0zvMDdx30sTP29w==
X-Received: by 2002:a05:6830:30a5:: with SMTP id g5mr2843024ots.175.1617799277829;
        Wed, 07 Apr 2021 05:41:17 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k15sm5515988otj.46.2021.04.07.05.41.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 05:41:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Subject: COMPILE_TEST related patches for stable branches
Message-ID: <ab0cb60d-9044-695c-dbd4-2a0324296c17@roeck-us.net>
Date:   Wed, 7 Apr 2021 05:41:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please consider adding the following patches to all stable branches.

v5.11.y:

ea29b20a8285 init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM

v4.9.y..v5.10.y:

334ef6ed06fa init/Kconfig: make COMPILE_TEST depend on !S390
ea29b20a8285 init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM

v4.4.y:

bc083a64b6c0 init/Kconfig: make COMPILE_TEST depend on !UML
334ef6ed06fa init/Kconfig: make COMPILE_TEST depend on !S390
ea29b20a8285 init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM

This will prevent issues with s390:randconfig, which may inadvertently
enable COMPILE_TEST while HAS_IOMEM=n. This results in lots of useless
compile errors and stray error reports from 0-day.

Thanks,
Guenter
