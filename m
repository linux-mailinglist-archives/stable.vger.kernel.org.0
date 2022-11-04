Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158A26199A4
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 15:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbiKDOYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 10:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbiKDOYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 10:24:05 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE8230546
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 07:22:29 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso8389108pjc.0
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 07:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=HRYSU7MovNaYRtWzxf0E13rVC8yJpO1j/oErbQ1ktFJywUgByzMihTqcZBgW6+/tyx
         9pmATrUzR6pgdWpbvc2QpBnoGFuP75Qn7ZI9vyTl1jafKQIIQfd3nvKwdp203hx6Nbna
         TgW7d0gHYbBBYD24RUOMK0jo3wK90J19kDEXt5XB7n/AGBTNF0NPjaViCDMDKvOYdiZy
         yD0ZfWUfS9Byi2/f1WdFh4VO5tjeRE53MaA5N4sKfK2W6ONglzCu3a7txwbouJmAifZq
         IdoHBQfH16H5rRm7Jd8PSI/YfFm85iuUb0Rl/y5UiuHwcDnRPZHFTL3oqPrvbeaVL2oQ
         iQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=v86RghQbsP1ikn2StlJ5MV1E0z3VSfMveEVBhQkwzXowpN87cNYemYvtu4MtkyE3kU
         fxIz/zRZs8myldqDKJALM2sQn+3PE0TltYI1ZuWsgi/WrknORgKAWpWGZfuLdoBgOkRt
         wqtgxZa3BnPy9QoBatAeLGxXZGqCpfm+MDAi3DdWu6/ynS+kWCmntlNrZgpAGCBcuXoj
         LLU4ZE+5cAldYC5POn9geDEKT6ocEkMAwLTakLyMYFWdzb24/DFfTSLGM53EwcH5Da2u
         qSlO0fIIZQgTPfO11gZdLGMB0ERAvHgK0MAVYxNqM+C3GVSLmZ1qw6qZXrySIUuakpUh
         aR2A==
X-Gm-Message-State: ACrzQf12tXQaSFL4ppUTQ1raSSGUgRS6/vSGCPNgpDPpxVpPrr1wd3zw
        CFJfHuc6yB98yVtkpo4RU9RciM59yN+7GhEJmkY=
X-Google-Smtp-Source: AMsMyM5sI+7AycTThDb7wSH0Pf9kT/l3+/sbvJL/4yjXZM3F29+wvcpBRGG3meDr3g5pUFicHVxO/UWpJ3FAaHRpgZw=
X-Received: by 2002:a17:902:cec8:b0:186:8553:79d4 with SMTP id
 d8-20020a170902cec800b00186855379d4mr35091706plg.148.1667571747556; Fri, 04
 Nov 2022 07:22:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a20:9386:b0:a4:4d6f:9a3c with HTTP; Fri, 4 Nov 2022
 07:22:26 -0700 (PDT)
Reply-To: subik7633@gmail.com
From:   Susan Bikram <sb8766198@gmail.com>
Date:   Fri, 4 Nov 2022 07:22:26 -0700
Message-ID: <CALhHHa=vpFo6+W_GfScAdEQe5Tvk38YYy-n6YUajxtbxeO0C1w@mail.gmail.com>
Subject: Please can i have your attention
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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

Dear ,

Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.
Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Susan
