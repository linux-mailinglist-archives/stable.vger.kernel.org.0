Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A779452B07D
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 04:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbiERChh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 22:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbiERChg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 22:37:36 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D620054683
        for <stable@vger.kernel.org>; Tue, 17 May 2022 19:37:35 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id bo5so858253pfb.4
        for <stable@vger.kernel.org>; Tue, 17 May 2022 19:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=CN4mneC9N7DYDi5mpxWM8VmCmJSfPtVF/U5fcowY6UU=;
        b=z9NrYoiM/xenk9O4MnCChMCK2UnR9L95toQpUetpLe0bGsSsw6YzHSuoQSf2jOADSA
         3Mds+5kcnhtp/3Zz8vLxT5bMXHMnRQZ/mPkcWYfnWpNu3MRd9n1c4p482O3cZS4hwm/N
         KhwhLTsQrDx2e+cV1EAwP8/ZrKnODCLxpVwybvylMP7B4nWQvTxGNF5Hn9lLYPwOPHLK
         dRGkZI5gXcsgY7ZYVRg+92YPwvavQd9Az7TLepV4qnpyI5q0980They7gFJmT/NXSeE/
         /pzQ6t0A4IEAdBrPnAftS7t3naF/1LiLqkxkImTMHSZH8Oa6k90pXVZyovR+6b6yxbOu
         jh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=CN4mneC9N7DYDi5mpxWM8VmCmJSfPtVF/U5fcowY6UU=;
        b=3Qxilbht8vXoKVhmvi9mrr4HeLmZxLZrpBcV0+gmAps4EfLb8TCKg+7rZk9C+arKQV
         xENwEnPy4wlRmDunbel2hVQa3wcV+lBxV9UQGtzWxY7IHhMz6twjHx6I98i0Lo1ofjpu
         77HfgBmcUPpelpz3FqQG4UUzcw6GjSrNJB/AoZzq+I7LFDEnwXsvactOvjsCvNzMDDLa
         5zEjztkjWjV1PQ9jznbAfAgOxZZ7x25eZJGSDdgK6zTKzVZpyr5xCkaXBVT0Zgp/23Ll
         76e1c1iHduKmUcfygSc20l07t0Xnu3PsSzYNlIZIKYcg8LM7uBVZi3VrtxbjbVaGYGG1
         LjCA==
X-Gm-Message-State: AOAM533iLNknT9COFOdArEVhXSVE1yZssdgEkmsBGBCkyv9MyOqSzjmO
        Vfm0LRNlkX5kdzn4geOYKS4uoLCjsEhLaA==
X-Google-Smtp-Source: ABdhPJxIS5jEJRD88zrmewXdpLuVGFYxUDPWfM+FETq1NSS5LJqO8YzHDhli6710EbUbko2RJ8kPpg==
X-Received: by 2002:a63:f91a:0:b0:3f2:8963:78c4 with SMTP id h26-20020a63f91a000000b003f2896378c4mr6659493pgi.593.1652841454886;
        Tue, 17 May 2022 19:37:34 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v8-20020a17090ac90800b001df54afccb3sm314595pjt.6.2022.05.17.19.37.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 19:37:34 -0700 (PDT)
Message-ID: <032e7301-10ef-c392-04ed-345763e893da@kernel.dk>
Date:   Tue, 17 May 2022 20:37:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: Cherry-pick patch request for 5.15-stable
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can you cherrypick:

commit e74ead135bc4459f7d40b1f8edab1333a28b54e8
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Sun Oct 17 00:07:08 2021 +0100

    io_uring: arm poll for non-nowait files

into 5.15-stable? It should apply cleanly.

Thanks,
-- 
Jens Axboe

