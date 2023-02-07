Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BC468E030
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 19:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjBGSiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 13:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjBGSiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 13:38:01 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D321351F
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 10:37:58 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id o187so19636189ybg.3
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 10:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HyQfDA5JQKapTqk95xlLXJ5aD/AVTOh+bnm0DaoViy4=;
        b=DOceavFqs7lmqL9VBmmbji6y8tloB5770MK/U0Wz/TjEpolNZ8uW2yKkmmixsmHhNT
         MVnaqO67gnD1QCfkZmwYdCQkcr9U1Vq2LnoYJONf9QEJw8raTSWFPK7E6NHgHqREfElb
         Pi9RpjlUHabxLVYGKwrwqZfOb+QE9+4w2R87YHXlfmS4pErfgFSjhV5tmzOmmpHfc8v9
         3o/OgTUlXsoSbIujvAjlH+8gW7YCIoA+0nId8LhzK5TZIhcPhW3PB+pNpgl0Q7NeVZ/j
         s7TGfheHKYjzZ/GVD9vYJTG7/v6dxOP0Wz6MkC7KbvY0m/MEleKmxOKVIkI+RoM6q2O7
         fi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HyQfDA5JQKapTqk95xlLXJ5aD/AVTOh+bnm0DaoViy4=;
        b=FYwQXIiqmCiFJ0aENWPHnj4hiZtTa7D37CSzaOJgLaCCIz0Ku1LzV5cgb34BN8IFcE
         MyhWSG/fHT/RIDoKuQnFivuIUfVMjsdy3VRqiY0x81eFj41L+K9Tmk7Z4+tixrZT9xr0
         DNEptQaJsF5pBBKy2iSSOSVdJm2hwXnuBfLIdbJ7ya5fzhEEsOVPazbQZsG0KEC8ofPm
         1EisQgeY8+Zz/7I0FBK19bU4Xcm+tDFAH1Q1NnQF0e5j/jAjq8FfGDCW4oyo16jMKhQR
         /DLTMexGxJDsEBlahkR+yJgJXfgMkFFLEtZOHzNhF6IN3TJael93LM36YmwIy63acW7Q
         Lt+A==
X-Gm-Message-State: AO0yUKV8Sae7flrc0lUg9z5oVN2RU8d9sDAHKsI1zs2tO+HAHZM/kT+3
        dMDAOfGcNphaPyddlprUuMly/Dith6M+oAxGfgc=
X-Google-Smtp-Source: AK7set/1PM43Xn/NgXyCRm3SOznr8v58UcKh9l1qeLKYo3HMrK03lPcTTvMiyIpNa7VYEFJ1snMd7yh+ojEIG78NkZY=
X-Received: by 2002:a25:8601:0:b0:858:a284:2e3f with SMTP id
 y1-20020a258601000000b00858a2842e3fmr469806ybk.71.1675795077246; Tue, 07 Feb
 2023 10:37:57 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:5244:b0:32d:f582:28e9 with HTTP; Tue, 7 Feb 2023
 10:37:56 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <gracebanneth@gmail.com>
Date:   Tue, 7 Feb 2023 10:37:56 -0800
Message-ID: <CABo=7A2kEgMVyLUQ1CiZRvoBQSxk4HfWAu310qiLHnBR-46AoQ@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gracebanneth[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello Dear,
How are you doing.My name is DR. AVA SMITH from United States.
I am a French and American national (dual) living in the U.S and
sometimes in the U.K for the Purpose of Work.
I hope you consider my friend request and consider me worthy to be your friend.
I will share some of my pics and more details about my self when i get
your response
With love
Dr. Ava
