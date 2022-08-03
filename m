Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBAC5891B6
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 19:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbiHCRr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 13:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiHCRrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 13:47:25 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0F565D8
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 10:47:25 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso2748635pjf.5
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 10:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=MUDd76TinUcA5JyTPJBAHn1VumWVzYjA1fKwU0h/HzI=;
        b=qO5gfcg4xLA2tw8kgYmWCiMSZoa3bMaPSlWWvMEDHnSBmoG4CuuhU1qZ7XwM5UBdHr
         5j3LeY2aGkcqy221rmsG4rhd0T1CgwyTKxrsPKmVb9NU+ziQoYMrU9/Oc54p5dgkTPwm
         Nu5Ikpllyb697VZCTJVhKznEbFpBjZ3jCTDU3i1kywz/gZaG7+PcLwQw6BS9kUR2Hxs0
         L+PqUSkl44xJDyE+zKsm/dwnaiZAd3299lQIBKpgEFV1hJTx0htb667IQbt3rvnNxdAq
         iZ2nCAj0ToLZLfVomdZO1QG5YfU0qQ9BAUtGzdpWBWFjGdT5MrNVRUYvG7FmY/78aB6O
         6YKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=MUDd76TinUcA5JyTPJBAHn1VumWVzYjA1fKwU0h/HzI=;
        b=e2W+M8569VzUTKof1a49Kg7woQoWbLu8zEgpC6I4uSobOIpxp8TrutFgLVO1fNhO1X
         wxisBWi/iB3gwWqmPG8F53Gn/A0Jn2kY1d2WKigIjRlkg99BAWexMTBs/UGUWOgCVrAI
         SVL4XxW5/YlHZtyM7GKjzW98ItVfJaZAYKdho3ygAvIQIHFoFWubFogGAH/O5rSwS37h
         bVTGg+C9Mq/Ez5NJ6IHASnMyl+SvGcWypXnbteMs7lFP1CNWHQD94ar9UV5UjEQ/0W7R
         klqj4vGmiPqieMFONbThbgqrJF7eVuOjFea/hgskOzlPJx/j5LU263LKNLNSM7qqYVhp
         dpRg==
X-Gm-Message-State: ACgBeo1nnjgH1kBxG5nvinPlMfYZ4x9Mv7WuYTBn0TKH6Q7VOJV6lUvr
        6Ub48yUEFBnpqEhTj5GmpaYOnaIb+eeAhX6AkKQ=
X-Google-Smtp-Source: AA6agR57gwcJPD8IH/gEAvKbkF47gF8CRmsYSyYYFkNmiyIVUxq/F0HpvSi9awPEMmnipN1zmti4FjVYZT8X+SFHlGU=
X-Received: by 2002:a17:90b:3c0e:b0:1f4:d764:99f8 with SMTP id
 pb14-20020a17090b3c0e00b001f4d76499f8mr5865217pjb.91.1659548844715; Wed, 03
 Aug 2022 10:47:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:902:f551:b0:16d:c799:812c with HTTP; Wed, 3 Aug 2022
 10:47:24 -0700 (PDT)
Reply-To: marykaya3n@gmail.com
From:   Mary Kayash <glennperkins12@gmail.com>
Date:   Wed, 3 Aug 2022 12:47:24 -0500
Message-ID: <CAHcP-bu+dw7kJwSbugqqqzz8VwZvnZBfzzLQHx5yEnUJ1pVS=w@mail.gmail.com>
Subject: Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1031 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [glennperkins12[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [glennperkins12[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please I want to know if the email is valid to reach you.

Mrs Mary.
