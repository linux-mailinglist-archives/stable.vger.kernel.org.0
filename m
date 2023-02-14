Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DD069616D
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 11:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjBNKuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 05:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjBNKuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 05:50:11 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522BF7D97
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 02:49:36 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id u75so9950891pgc.10
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 02:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676371772;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=eJUTbsdIDNX95V/oJFpC9RkiUx6gR3zHQ7/qS8TWsfyM2SybbiSmnqJksL7PcKhUh0
         S4QPS478JkJvvjm3B+ZYvbDwonE2er2ix2XRGapi/Y9wwdMbEHoBXzX6tDJAx/PCnVsP
         SgfP7nxMMzJRH7vWasfwCAfDKrTIj7UQ29HimALXB4toMKGx/VyI3n7g0uGcXZIuFSP7
         HgsTt164Iroml8Lrzg880hsTh0uWAUTDomz/7xIQNRRkrdCTDWgkoa0qZHeg5JpyE3qQ
         mD2IauZK/9bhPIe2TZ9VPhdmOyuBXRsZzSlNFgvxtff55bhUzxEOaO8bW8cyHBmZHP23
         Yb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676371772;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=yKnu9HejU95CWIJ2KXWfD0W0/HR6lIZh5IHVbW/zTwXr+he+7ed/1E17HYv8xm0RJN
         1qhhtJ+zm27Jj/8DMsq3di4LB9lQJiEJI/DzHm5vXqd9uyHlB5cruEY8AtSQ+p4EQdht
         pzZsPNfudgWZjLXApLu44YSa+4BGXMsZ8DlkBKCLOC9RYrR326adPJsI/75cbrOHIWrN
         swm4M6Gmar1ZT0FYZ/38Af+WRPoepNJlHza+Z0wkZnS6d2GTUkJVbZKzGpklE5ZcVmpF
         ZygNu2Tgb02025wleR+E9cIatEkAbo/rZuKSUG3Oof6WwlXd/tNffhSiuLcUtcrQphF+
         iXGA==
X-Gm-Message-State: AO0yUKUD7uMcwYqhV35m455Kn24rK6EvYVUGes0hhYHWBzO8S+I3gjZY
        QOezZn6NEsulw3LCIqF7XIcrcdHs5kDGoqbMQ+E=
X-Google-Smtp-Source: AK7set/ccIX3gEl0Z+ZrA/mBggg921g9VIdlU/AFiz1afzfyVBwJA3HoUQXIlEf9s7Czdi84IbwAcqvbnylApS/ijHs=
X-Received: by 2002:aa7:8e82:0:b0:5a8:7d65:c13d with SMTP id
 a2-20020aa78e82000000b005a87d65c13dmr363786pfr.39.1676371771749; Tue, 14 Feb
 2023 02:49:31 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:f2c4:b0:412:871b:c490 with HTTP; Tue, 14 Feb 2023
 02:49:31 -0800 (PST)
Reply-To: ava014708@gmail.com
From:   Dr Ava Smith <smith019a@gmail.com>
Date:   Tue, 14 Feb 2023 11:49:31 +0100
Message-ID: <CALZunAd82AEeNTw8CPPaiOTQ2xrjrV2c7mcTEf35NORK-eN3DQ@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
