Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0C26490BC
	for <lists+stable@lfdr.de>; Sat, 10 Dec 2022 21:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLJUyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Dec 2022 15:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLJUyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Dec 2022 15:54:23 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4506515A29
        for <stable@vger.kernel.org>; Sat, 10 Dec 2022 12:54:23 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso8408865pjh.1
        for <stable@vger.kernel.org>; Sat, 10 Dec 2022 12:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:reply-to:subject:mime-version:from:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TLBluAgFiyxVbHom7R4fS8VMKYmcltF3m+6h5YXT6bo=;
        b=GkJNH8bLrtemDMZPmbHW919IrWedT/Ml8TEMwD5BLRzW5fMoDWb3BCOP6tVd+9IWnK
         VO8uldhbjlrcwcL+x/UaEhN/l38Beada8aPC5wfvidIYRmejNev6nM180QVyMlkXPtFV
         FseE5BkIe6AkBWJqcNmeov3b+LGfAIS79pabRPHwU5TQRYM0xijciYqcp+Eq6jTVUiCu
         TMDoYggR3SuGmBVjb9nuF7K6lGVBZGaArLWEdZZigP7U8iuNb2zFFXfAtZ01BtA0AsPO
         fVjP5jMAMNHv3lgyxZmdoFkDD9+/YBz9Thvf+ahyakD+GTNFAdeAoYxwG6DT0r/fy13p
         +rEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:reply-to:subject:mime-version:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TLBluAgFiyxVbHom7R4fS8VMKYmcltF3m+6h5YXT6bo=;
        b=nLGfTUztfMD2rr1v6mHcZHu4nYjOF08iBzLqBQh0eAPdGvPOWIxFjtIJWX9EPDmTwB
         nXbcgyGLZVUmBfG0I3KAKC8pyE39yiOzzRx1XBX7hQ5B3ef/MpiQXn/5DqYhHb5WRfb4
         uObw/LuCpG9rBS+me2YrdNKnT9Cixy9kgCYOQl5Ubqab8WsT+Ng5xUP7D32MUz66BZgA
         KKZp8/ICZNU4+y0Y35frkaFo/1j8C3c84huMzl7J9y1uU03O8bKjUbtShq01knpshW9R
         HNSBmecNUVXP87E69YSyus0vrQgR1LHPq5/harMUfkCERojz14MgHPt2rAbvXs4ySdrr
         vQig==
X-Gm-Message-State: ANoB5pm9XLjoVInaW7luYsuMAFtQXD/sZAt78XO/oZQUUCSIcU5LUk5K
        XDaEXm5OrvVS2E1KWj1YBXyOeW96oq9tf3Pc
X-Google-Smtp-Source: AA0mqf6Cnny/kIrJSmRg5lKdquz60csNgKAQ2e051fXbJ2td+FUXB71t9af/L58hXKv1E3J6VIDdZw==
X-Received: by 2002:a05:6a20:441e:b0:ac:31c7:9d7 with SMTP id ce30-20020a056a20441e00b000ac31c709d7mr22620336pzb.52.1670705662870;
        Sat, 10 Dec 2022 12:54:22 -0800 (PST)
Received: from [127.0.1.1] ([202.184.51.63])
        by smtp.gmail.com with ESMTPSA id z9-20020a17090a7b8900b001fd6066284dsm2864132pjc.6.2022.12.10.12.54.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 12:54:22 -0800 (PST)
Message-ID: <6394f1fe.170a0220.c72d1.5885@mx.google.com>
Date:   Sat, 10 Dec 2022 12:54:22 -0800 (PST)
From:   Maria Chevchenko <17jackson5ive@gmail.com>
X-Google-Original-From: Maria Chevchenko <mariachevchenko417@outlook.com>
Content-Type: multipart/alternative; boundary="===============2870829240542943876=="
MIME-Version: 1.0
Subject: Compliment Of The Day,
Reply-To: Maria Chevchenko <mariachevchenko417@outlook.com>
To:     stable@vger.kernel.org
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--===============2870829240542943876==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Please, i need your help; I have important business/project information that i wish to share with you. And, I want you to handle the investment. 
  Please, reply back for more information about this.
  Thank you.
--===============2870829240542943876==--
