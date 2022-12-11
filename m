Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1CA649289
	for <lists+stable@lfdr.de>; Sun, 11 Dec 2022 06:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiLKFff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 00:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLKFfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 00:35:33 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA97FD37
        for <stable@vger.kernel.org>; Sat, 10 Dec 2022 21:35:32 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-143ffc8c2b2so4798602fac.2
        for <stable@vger.kernel.org>; Sat, 10 Dec 2022 21:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DNFhsPbkfGfOWNF5M4aRb8nwKD8L5aVj2WV/H46NM8s=;
        b=eXiPR5Rd9wfImelxaVaExSPiQNRsOMu2tYhWFHmKu7BzPiqTC9wO4WAVwa5ahj3YgL
         Lu1lN+dharjY5rSXwPc/qQTLUJUwhsVmmEbJN0eUk5yvwgT4BLqJ0iSfot8aKk7UyKzS
         NPHdvBLsjqto486SygcrTgjj0sR7geiDXubf5cOTONDiHHmC5eRqn2//j6Y0oEePfmNX
         ygo9jC/SCZTf6zSy6HqHKcLBYuNJKbZRatN0JSVlivVO4H2KG/NJVJFfvdQLdV2tySdp
         WX9V7bQnMFODUIt5W/0W0hL7f9oK4KR3+p+tWy0DHpAcL4ly3omXRvPE8Oyt+De1FVZ/
         zveQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DNFhsPbkfGfOWNF5M4aRb8nwKD8L5aVj2WV/H46NM8s=;
        b=xPFpelxXyY/njjHh+w5nmNNLrV48BM6z+vmSf7YZPTWxYiahp55yn6srkNrOzWqYKk
         eRhlKZTFLBjs/km8zLDA1hcpz7d2dGz34fPCjE58hV2Hn1fVGMDlNqw8SgIapD/x6Jvz
         /1WuB0Xu2BpFwc+lKJPXGKcvuY1ljAeLnmnn5feOD0MXumv5AsbCrhsBA0iVN92Bt7iI
         Lkmo6uNxnevg+wxTLL2Qd/+kmZDdvh+AcsxMZBSrwm4tvuJg9qhMr5+XUkOEk7VJXxWz
         lqfn7Uoshc6ehVEgQ+Q4olAivacHI2UOTDd9jsOBxqWJoXmBn4kljTHkXkRxeAJFnGqU
         6mmw==
X-Gm-Message-State: ANoB5pm3bOQh2rvte3UntVyRDAiT221XPTnPaG9Z7yFAS+tMXcU7wr9O
        OrXBhOoJPqB0nCH46CyCR7t8q08/HSKsx5Whoq8=
X-Google-Smtp-Source: AA0mqf6Md/PEpuVKSDRYF9fia1bHy+IHCM4sSavu0yIlNgjatbG0u/dfEw08IukaCM5OzSjgw8AUG7YdPULILNg8RYY=
X-Received: by 2002:a05:6870:aa88:b0:143:ca23:34a9 with SMTP id
 gr8-20020a056870aa8800b00143ca2334a9mr28019792oab.235.1670736931620; Sat, 10
 Dec 2022 21:35:31 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6358:1126:b0:e0:8111:6c74 with HTTP; Sat, 10 Dec 2022
 21:35:31 -0800 (PST)
Reply-To: engr.fred_martins@aol.com
From:   "Engr. Fred Martins." <lorir8611@gmail.com>
Date:   Sat, 10 Dec 2022 21:35:31 -0800
Message-ID: <CABJ7TC4V6vNVo-pcMHxjs2HnRpT9UK2YpvOBGBNSbNFO1tBpxA@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings,

I wonder why you continue neglecting my emails. Please, acknowledge
the receipt of this message in reference to the subject above as I
intend to send to you the details of the mail. Sometimes, try to check
your spam box because most of these correspondences fall out sometimes
in SPAM folder.

Best regards,
