Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F1C649F06
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 13:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiLLMpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 07:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiLLMoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 07:44:55 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A374411C25
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 04:44:54 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id z14-20020a9d65ce000000b0067059c25facso7188432oth.6
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 04:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=djmzJMwivyyLiUPOZqyA+F0qeEslqUQz3Lv5wy+yIFo=;
        b=gB/cTY67v+kpH4h9BEt4h9CS1lbqyxK6xv7FMq9tG9pBCJ/MaqfsbQbsZWY5gRF5lj
         foYfXiYuWyOLbDcNGUTPRdBP1kUgtBW6lZrPPR5vNYyVSYUhS0XAKeu/layJyLQTq2gA
         GHZoucxVUZkFwH3gk8qgAfZE+xHQy1N8gaLZdjkH8+b8cZhFBK2kXpli7f9+chpdlk2E
         vpfhZybvZm9rcQKuRChzoZA9YrMq+53IJ1VHXjoJmDgUncZ/nrvsHkeqRay65dCiReO+
         yKJEVZqYVaqYoQ5CH+bIN9DfP3n2oN73FKXM/VyHhHjwGH+Zw8ihFDq5hAlKSzrDjhHY
         MuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=djmzJMwivyyLiUPOZqyA+F0qeEslqUQz3Lv5wy+yIFo=;
        b=PTSWQ9o6ufj0vEdEus0eqF3/rR6MQ3RWfo0geZMcqsdLggVxIzNVFWrfPZbHaS/eoV
         TpAm922GcuF9FSxygMSo9VminyUYhJSXDQuHSvgxGo1TTkIEo8R07GRU35khLBl463zU
         ZhgMS8IyM/3pAB1L0YHrY/amS3AWvb5PF2ihjtV/LyCvhF2AyrTEY/qtPmDmRUiuVjoZ
         QtrBuOu8n6/OV76P5XIJVCTQ8h5+1VbfyYGObo5DzDDxyRuFIf3cMB8+VHorjQxysjor
         Kku2AozPw6szCeO81f0DS7rSde5aAamu3Zxa0EOMODWKs0QwcQ90rVko/uJV9BNDOUZ2
         2Sug==
X-Gm-Message-State: ANoB5pnYVQ+HdyBca6uIRRuhtBM2w3MteSe2lyA4moBd19xlnA1HkLfj
        jBVFZfsIeFI432fSgawXzpII76yxMOMd8NBiFug=
X-Google-Smtp-Source: AA0mqf7fcYGmRW/PP7gIakwPnKPUGOhx22CfrJy/2nviTtfMKOQruvioKWfOGJbqqg00D0PbbjnSg54niDo7p+C3zwc=
X-Received: by 2002:a05:6830:6084:b0:66e:86d3:c856 with SMTP id
 by4-20020a056830608400b0066e86d3c856mr13077513otb.121.1670849094022; Mon, 12
 Dec 2022 04:44:54 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6358:44cc:b0:dc:e6c4:1349 with HTTP; Mon, 12 Dec 2022
 04:44:53 -0800 (PST)
Reply-To: te463602@gmail.com
From:   "Dr. Woo Nam" <namwoo633@gmail.com>
Date:   Mon, 12 Dec 2022 04:44:53 -0800
Message-ID: <CADGCwd7RTQkAFK6+yeBDD+=hrv_MVC5jdp2F7dWbnTpuGARJhA@mail.gmail.com>
Subject: Very Urgent,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,
I tried e-mailing you more than twice but my email bounced back
failure, Note this, soonest you receive this email revert to me before
I deliver the message it's importunate, pressing, crucial. Await your
response.

Thanks,
Dr. Woo Nam
