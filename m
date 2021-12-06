Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF25B46961B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 13:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243421AbhLFNDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 08:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243274AbhLFNDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 08:03:03 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E02C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 04:59:34 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id z21so2993005lfu.8
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 04:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:content-language:from
         :subject:cc:content-transfer-encoding;
        bh=fCxJcUzAEg6T9mato1MKFp8WUVBEDQGDxtg358JwWXY=;
        b=nmTZKTk278vTnBJWCnR5ylg9v3qBaN6JDbjSrezbs89igVzEPy1KrRA5cVvN34p7E8
         +iR31AV1r18dS3lVqSAuS8Q38JUITVA3oJnqRU0Yt81OaV19D321O/8vmzOpnhz3UcpQ
         PlpjkdKmXsAeghci1dcB/il5Oq6fRdU/tabuFKSUmK7uWGa29y6K3FDC2Wk5yGEJX7JS
         +BqrBYf0q+eFCYromzQIzUm2vJBY1rToHc5hQH99hpoI9rpBpMDpqbMhmHBTdz8optBW
         YdmBmlikQ9tW8cc3JlqBLdyzcY7TIH5a93+9houmA2ZVqewBmPBRijN2VKwVVfKjbZaG
         wxkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:to
         :content-language:from:subject:cc:content-transfer-encoding;
        bh=fCxJcUzAEg6T9mato1MKFp8WUVBEDQGDxtg358JwWXY=;
        b=qR+i+r1+s44ISrq+bg4LRwnzDd3DGBYy2RLGvRhfIT1LPj3Nw/xre6l7NUi69ivhhP
         CthxbTQDSx4gdKhBykLvJNClNr26fPASoad05JQYN3UFXeKtn11v8LfsK/ItRJh/0w/+
         i0ygX+huuBKWWC//cqUXvfTFKe44MTyzITfg+TWMM+q2mjaMNh+ceHs2ACbn4Q/EQH5Z
         tpIe75e5xABtPojuaaYITJj6xuI11Pq+Z9bYs6ZZmVU/SBnlmZNBY0M3M7Ok52IP5bfs
         QWGS5AgQ9VP99ZbqF/Ve2uh1441e0G3zSJZQOtWdpDAwNoOjFz9ZFh/zqeuYj7U+ui6B
         7CWg==
X-Gm-Message-State: AOAM531rU/8vBoBwSzsa1p3aZFIXfp8CYqAueYzxKFnrtj22Ot9Fk86P
        Ls5jdIc3Q8K9RQSi7MDx2YYNHrWVJ00=
X-Google-Smtp-Source: ABdhPJxdZ7QCpVYpLUARiBnvYDGq3MSG39dloBFe64E2BTaZJC33xlLxX5QAh1nfy4GL9/nQ7e9jqg==
X-Received: by 2002:a05:6512:11e5:: with SMTP id p5mr33875982lfs.537.1638795572448;
        Mon, 06 Dec 2021 04:59:32 -0800 (PST)
Received: from [213.112.1.193] (c-51aad954.51034-0-757473696b74.bbcust.telenor.se. [213.112.1.193])
        by smtp.gmail.com with ESMTPSA id f35sm1347180lfv.98.2021.12.06.04.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 04:59:32 -0800 (PST)
Message-ID: <a11f5d22-658c-44e9-51ab-d39c5e8776da@gmail.com>
Date:   Mon, 6 Dec 2021 13:59:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
To:     stable@vger.kernel.org
Content-Language: en-GB
From:   Thomas Lindroth <thomas.lindroth@gmail.com>
Subject: Could the fix for broken gcc-plugins with gcc-11 be backported to
 5.10?
Cc:     keescook@chromium.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Build support for gcc-plugins are not detected with gcc-11 in lts kernels.
Gentoo and Arch apply their own patch to fix the problem in their distribution
kernels but I would prefer if a proper fix was applied upstream.

https://bugs.gentoo.org/814200 a gentoo report with the relevant info.

I've searched for any upstream discussions about the problem but I've only found
one message saying the backport needs an additional fix. That was almost a year
ago. https://www.spinics.net/lists/stable/msg438000.html

/Thomas Lindroth
