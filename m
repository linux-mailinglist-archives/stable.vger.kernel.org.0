Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F296DA40F
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 22:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239578AbjDFUuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 16:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237407AbjDFUub (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 16:50:31 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5ADD7EE1
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 13:50:29 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id g29so2513401lfj.4
        for <stable@vger.kernel.org>; Thu, 06 Apr 2023 13:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680814228;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y5Ai8ftFGf/7qrHxBDCebvM00XXHdhtlOXD7WyAX9HQ=;
        b=T5pc9MsVXbCXm3LM4mJKY4i18G3ogeYXOZn0R0f0CkWaaMYdd7Ixy7VEwDaDV3hacV
         nCRs9NxljFGASXjadPf7havGZHnXmEEQ82i1iFmrbCMGgb/aQjYiUSPbeOVn+R8wyycj
         at/mIab6BzF85ZteORzbv7M66cWvilo53oAL9uT3J7ztoLgJlUVxzKhwA2ySPYKOsjyq
         GnVhXUCNgNRXd7MHtI817ki2OKDdByMT3YiZt0cA/SNLPfsEWadgn6YzVOuA4ZE3PjuG
         vd2+3BNx0ymFwMVY+OTdPcUcUkv8W5GyOSDdeiIb3CrI6Lmg3lAslNI3yuatkSc9Xgvf
         rwrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680814228;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y5Ai8ftFGf/7qrHxBDCebvM00XXHdhtlOXD7WyAX9HQ=;
        b=tz4Fm0/2gutDwAvvXz+bZWY7Y+0lvvA6BlKBijcQ8qx88iu2ng4BuuBPotS/qJlmtz
         I+Qs90lVNgZQBZoOPXWo1qs8/QtfcQnWf2E7/B4bbF3ejmhPVLAGX8dH/iUpp1vW+A5D
         qymYVe1HnVuiFeIbpg1aX5UCQgjkl6lzbtlX3146Mw6uU8Un7DY+0NQuhunUz4VyJZN/
         sX0X3GcNg4oATw2Hq/xt3DN0E6SRB4+ySM2SFNBdbiP45JyXwRJYP7N0tI8nWFqN07GQ
         9uJKv5SrYXPkiZbJc6XqaAel6hksKckJhk3QLGwaeSJJ9hQZdSCrR3wuAYdL/agVh2JR
         OA8g==
X-Gm-Message-State: AAQBX9dckBBlib/B3OH1WRzUDWa6xaOgLB257K402zgP1z4GAVJb6JDg
        FyPvpqsMNyvkP7962NeVbE0HXpYflNe1u6hSRZw=
X-Google-Smtp-Source: AKy350bQAsA2MX9SM13lm8DKdunQBdoZgnwU/PCvinWhH5KJQ8Y36mreeGbROHTM9EvqB30zhXRgsTbvaTAqfVjpyac=
X-Received: by 2002:ac2:5201:0:b0:4d5:ca32:9bd6 with SMTP id
 a1-20020ac25201000000b004d5ca329bd6mr144151lfl.2.1680814227842; Thu, 06 Apr
 2023 13:50:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:aa6:c08c:0:b0:24f:5228:ed8 with HTTP; Thu, 6 Apr 2023
 13:50:27 -0700 (PDT)
Reply-To: nepk08544@gmail.com
From:   Leihservice <auwalualiyumalam46@gmail.com>
Date:   Thu, 6 Apr 2023 13:50:27 -0700
Message-ID: <CAHQtquQVdnhcVz5eWYv14hEogKxVhsmZYxzNHSdZgKEwuEfA0A@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Holen Sie sich ein einfaches Darlehen mit einem Zinssatz von 2 %
