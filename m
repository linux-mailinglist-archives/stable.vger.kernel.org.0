Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42EED539452
	for <lists+stable@lfdr.de>; Tue, 31 May 2022 17:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiEaPxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 May 2022 11:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345919AbiEaPxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 May 2022 11:53:44 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746A48DDF5
        for <stable@vger.kernel.org>; Tue, 31 May 2022 08:53:42 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id nn3-20020a17090b38c300b001e0e091cf03so1924598pjb.1
        for <stable@vger.kernel.org>; Tue, 31 May 2022 08:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=8KcP8g0SX6NNLKFwX4YHAyEfOJb0z0q05cv5Q2aR/eA=;
        b=lL2tO5fhoERlWz0RwF4tnTfX8QI6EM/suaQXQSU4eCJOp7xbKRr02HJgrJhU9rjnQy
         L7Dfa+TCWRKQckeRXhfeYPDdB5OlZGzRMDpJUTgSTCHauMJ9yqDVJr1rsq5DPxjAIqNf
         uMj8CdbZMbq9/d6VcU5fgujT5EWqkT+34PbcTlZmr1SLxAp7be9lyH6S+7OAjLDnkiVA
         O16IwKF86TgxjDWLAey1Feyo3fbpzGZr8s4JdfgMeY+PVpZUfTHKkqEh3gNDkljhQAyy
         jZ20MS3QsaSAxwtawZvJW7MVSCX4dWC/H1skgl/UJUNb3z5ZD1WEegvID+sLSezOeO/I
         VWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=8KcP8g0SX6NNLKFwX4YHAyEfOJb0z0q05cv5Q2aR/eA=;
        b=JlTRrKsGqBtRutAzAuexCb5PQw9QoQVqpQgMtdpvs1fdyM04VSzZNLEdxrsgPRrYCU
         C5uq/BEKTr6Gt70V/p0W89UtfW/uY5tlIIYmEm8GhsDFCIeT466Px6/TJOXETA5NHJb6
         SpwFi41FnOQPxjfwkwwOLsIC9TlSJbE+e7wIkeYsZ6GQ3/V6MZXnPHCLD41DVmSvtV1W
         /FggT/b4zk/59w/K1e6+jDE3+UJzO6TcUNtedxVjlTDY0xHaawuw7TlqD8P8cEiwBr0t
         4+Wu7FtIazjPr5RWPAXf+6Yq3DuPpfpTSpk+BI0bxbfx1SZcqGncYvSAbxSeasnbkeTa
         eqRw==
X-Gm-Message-State: AOAM5301teUD37KgDUf6HUwKzazh955U3HtVhT8CVW0ZSQNk2sKiIw0W
        BZ8E6pn+bq0IQnyyiVgyGGeCUfUpGTdtpA==
X-Google-Smtp-Source: ABdhPJySbfBH6v4drzskdrgYlUFGLJoOcPtqnEP5k0+c8039GL4KUOPVITLTxfLPRaRBrtnGWmZWVg==
X-Received: by 2002:a17:902:ebc8:b0:162:17a3:561 with SMTP id p8-20020a170902ebc800b0016217a30561mr46756930plg.144.1654012421659;
        Tue, 31 May 2022 08:53:41 -0700 (PDT)
Received: from [192.168.254.36] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id n1-20020a170903110100b00163ac8673edsm7456119plh.35.2022.05.31.08.53.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 08:53:41 -0700 (PDT)
Message-ID: <b6ca08bb-2275-ab66-1a78-d4ac9e87057c@linaro.org>
Date:   Tue, 31 May 2022 08:53:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: exfat: check if cluster num is valid
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
Please apply upstream commit: 64ba4b15e5c0 ("exfat: check if cluster num is valid")
to stable 5.18.y and 5.17.y
Backports for 5.15.y and 5.10.y will follow soon.

-- 
Thanks,
Tadeusz
