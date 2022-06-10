Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0045458F5
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 02:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbiFJAGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 20:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiFJAGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 20:06:01 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E242FE628
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 17:05:58 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id k24so7084612oij.2
        for <stable@vger.kernel.org>; Thu, 09 Jun 2022 17:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=1duVu17ASMmYjPDCBVBO1LQakxp3l0qS09qKIOF/KKk=;
        b=oCX/x0od+GwxwZfwyJ8u5t439e85i7uEi0lhF0bqKiukpZh9OXkoL0rD7sEkPYN6p8
         fWufJCsJtia2dhH8hGmLWPt3W1X7TYPCIJm/gK/R08g125Aswh3NdSDSTUnP+OK2u5yl
         X9vkfgRwg8Fw8a95DEAT6Atp3CNMPD6Yim2XA7rAjNfOtGiHe8VNOsXvSKWxnVYJK3fG
         Nt/O6ozoIRNqC91YJKLv7brEuadFC3HFd8BFcmKw244BxJKiG+PT3vT0SRU9KvLKVhHt
         F6zSQesYlaJIkZqCtAJA+RzxPE3q9hDVF1VUYIXYTo+kCa3d2kLpR+O+2MA/l9JDcrc3
         7SUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=1duVu17ASMmYjPDCBVBO1LQakxp3l0qS09qKIOF/KKk=;
        b=L6DiIutrQDBqSQc8ejW3T1pMJKBvCJeu0Qf7pBqXLUi+xns+kBg8IMKkn3T6589bw5
         Rge6R5116kf6x8+MspGAWB5CnvYhuulZO7Kot4RjCftptvtUh6J0vKvXu2G6FkQDJnrQ
         MlmxfI4uah+3qxU8/fjaslQ1itoORM+uu3bZP1YKRY+c9UGQxxLKqHpcTcOaJzyogBVo
         jU2il48OnY6hI2z9WE5hKyoPj7+fR6ix91zC+0eApE4kp8ugyN3ioU5FFBGrYVz8EDO3
         +pTXBQovph14j9/10+oysiGDSTKlEChSb8+1A8S1l1vq2VAYBn/Guju0sLWd7r/B+V4V
         bnvA==
X-Gm-Message-State: AOAM531XegFQUTzPzT8o4DMTxFPBp2qf/qm/VdxD0qpTu8cIoAnwLBXB
        NSTxvMh3EOAi7feVPeABvVsORkl2ITU=
X-Google-Smtp-Source: ABdhPJz4NZeuFr8NmlTDpNFh891ISqAuicimMtWhvkUbFYEwEW4t2ccFT431taSXD2oCdDdC6l4Kkg==
X-Received: by 2002:a05:6808:1584:b0:32b:314a:54ef with SMTP id t4-20020a056808158400b0032b314a54efmr3128304oiw.41.1654819557598;
        Thu, 09 Jun 2022 17:05:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 63-20020aca0542000000b00325643bce40sm13847914oif.0.2022.06.09.17.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 17:05:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 9 Jun 2022 17:05:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Boot stalls in v4.9.y to v5.4.y stable queues
Message-ID: <20220610000555.GA2492906@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

all stable release queues from v4.9.y up to v5.4.y have boot stall
problems. The culprit is the backport of commit d7ea0d9df2a6 ("net:
remove two BUG() from skb_checksum_help()"), specifically the following
code.

diff --git a/net/core/dev.c b/net/core/dev.c
index 47468fc5d0c9..d725ca4d4455 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2518,11 +2518,15 @@ int skb_checksum_help(struct sk_buff *skb)
...
-       BUG_ON(offset >= skb_headlen(skb));
+       ret = -EINVAL;
        ^^^^^^^^^^^^^^
+       if (WARN_ON_ONCE(offset >= skb_headlen(skb)))
+               goto out;
+

While that works fine in the upstream kernel since ret is subsequently
always overwritten, that is not the case in older kernels. In those,
the function now always returns -EINVAL.

Guenter
