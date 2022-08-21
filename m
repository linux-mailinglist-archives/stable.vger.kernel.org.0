Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C1159B10C
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 02:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbiHUASO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 20:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiHUASN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 20:18:13 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDF6B5F
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 17:18:11 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id m66so7807541vsm.12
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 17:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=0AZOPRDVSoks2gfQsmNNBqLk1N/iNNfw9tguJHt+C4U=;
        b=dgZ9ZNNKDlq3COjScBp/iMwLzUHkW9XzgmbrY7yORx9ZIUwJgrh2kraDYziRjsbbRx
         RKrPmLGvW/syQKfFdNop29pkNV8eGOyCDes5BVKx3ANNLSt4RtY0SJcoBnz+ONdKePNv
         0esvkgeG0P7Yn5FKP3hr+gh2S5qWwHowJG+f5PLR/sldp7CQddEM9WHkB2TAYjKM+6vk
         agd3vN5As8VaM9hcyXbiHfbbzHnyS4POCl3kvlGjRgz8p2WcHkqLVDYHd+EhUCR4023N
         yxT3oLdtpQC94MHdjR8kP6v/GF2gFySjbgBEVfVqtD1fozx5Vho638AtFVXVniG985xD
         C5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=0AZOPRDVSoks2gfQsmNNBqLk1N/iNNfw9tguJHt+C4U=;
        b=DQdsDEKE2B5aAWmkPTZVzW6SVuwbNJP6h7CE+mZvtPLHJfP/l139BT82CgO9rnlw4x
         vlPPOPT2UhvYVV81WI/R/Y6qgUZdb4DcyTosSsbPio4FCOqCMXU26hQVicdtAFXhp2BI
         JjrMw8UZlMXMLK3Ub1jiEAREb+tEka4Sa35UgRSOrcsYI2qsUazX7ttcL5VwK8H47T1f
         xwKXwnpQNdUX3/volzmZAmyVwfQ2Ds9o69QyCf58Pi+1pAy6Bv4sHlGC6vEJsS4Ntg/K
         +BZPVRKaUwIhG5UuO/y2HzTwqSx0Ik51qM6jENx+vBCeaXgm5UaLt+QzVKkPJNvwPrDc
         PGkQ==
X-Gm-Message-State: ACgBeo2zBoDaJh7QWNMyvhM8bS/l1KdZcBbSdPw61vzXqe1moMquPD6m
        9boWaxJ2dr3gO6S8lkY1Ikds0AYFFjTvxOEFnnA=
X-Google-Smtp-Source: AA6agR7QlE/PNhswqtZNByC3Ssvq8d0awSFXHtFnzaD1MuDUlNPcQd8LFf/yDT/jy8ArVVy6CPrI9+/eV3I8w1vyzzQ=
X-Received: by 2002:a05:6102:290a:b0:390:1df3:fe16 with SMTP id
 cz10-20020a056102290a00b003901df3fe16mr3992965vsb.53.1661041090825; Sat, 20
 Aug 2022 17:18:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:ce6c:0:b0:2ea:3277:b46 with HTTP; Sat, 20 Aug 2022
 17:18:10 -0700 (PDT)
Reply-To: te463602@gmail.com
From:   "Mr. KAbore Aouessian" <kiboraouessian@gmail.com>
Date:   Sat, 20 Aug 2022 17:18:10 -0700
Message-ID: <CALGXYcTCCjgNCw1RX8Z+5_q=ZNAauhQ4Ga66+7B15d0kY6WfVw@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,
We the Board Directors believe you are in good health, doing great and
with the hope that this mail will meet you in good condition, We are
privileged and delighted to reach you via email" And we are urgently
waiting to hear from you. and again your number is not connecting.

My regards,
Dr. KAbore Aouessian

Sincerely,
Prof. Chin Guang
