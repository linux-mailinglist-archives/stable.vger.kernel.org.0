Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B21B5ABF58
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 16:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiICOX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 10:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiICOX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 10:23:56 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9555E5E650
        for <stable@vger.kernel.org>; Sat,  3 Sep 2022 07:23:44 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id s66so2257915vkb.4
        for <stable@vger.kernel.org>; Sat, 03 Sep 2022 07:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=R+M1YvVpdR2Y/vihfHhLq4Wuj9YhHF0H0u4Cbj7WBq8=;
        b=a+kxIj5wIaakMgsskOOJhiOqycF5xrT2lUntkBNfbnokCkzsl5m4MOzrJmYJq+n66A
         3znl42F2laGbAqb8nqoPVdDC0GxDXdDZj0iMnUyqfMdc3qoLVs8XnvtlcgnQNzstVXVD
         wczsVzrV/2zsXLG7Rg71LfehaTSq/bDBrTI6VE/z8eZ8RR30LHC7MzEiKVe9tqMDuomp
         VYpFFIhZiUR1qD8uTaXLRk9NsOadnKCKz/N/CPTbTg8oXoHbJy08F7at5FWHMPJnatTt
         /IA0iVAYnBOv/4wOB8m4bAM/Icqyubw8wUz+41dmhhekyKj5/DaAXTqRO0dpYWPuRLwl
         eE6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=R+M1YvVpdR2Y/vihfHhLq4Wuj9YhHF0H0u4Cbj7WBq8=;
        b=HpBlY9dWCo7o+pMDk9SvyRvQh/tgED9VBA8g8Q6klz836vNWgmkwD0WXbG/BF4jU6J
         szvNHy+KC9PPy91vbY2mzN4XSMjh7ALYvY8CkbMpgChyMRvol3sLAufyW0HYY4McBn6N
         V3tfvjrinOSfxTf8NUFirHb5qkrQJhynVFIfJHt35g5xCe6gNYxCGsa+o+A8TvfqG/cI
         9abC4IqGtvg0TYBKxnzW1i4jiyNOvMCv/pN1z8EzwEV6kSwoq0Dh7aoTe8pRVopDKSRn
         EKwRC4SeUIcXP3fBQ7HNdrBORGRuRM/uauS9LrxQqAfmSf1zT/6Oiiy/pIZ/rmx79/K/
         ywVw==
X-Gm-Message-State: ACgBeo2g/vemV15aYiQZ5lwy4xJgRl3F0y+mCBb+nseaMRqmv4lN0gB4
        8uj9PoXFyqNMuivJGlgG3MYc2IOY3FHh4N9KWow=
X-Google-Smtp-Source: AA6agR6bFpbG1LA19v7vQgRzWK6KKazSbJOuAvDp/OpEhIvraypidx8otCYplS9N6zaQ3MOPiPRmd1k1PWQlVzxrIGc=
X-Received: by 2002:a1f:a958:0:b0:378:d584:dd0e with SMTP id
 s85-20020a1fa958000000b00378d584dd0emr11858567vke.17.1662215023676; Sat, 03
 Sep 2022 07:23:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:d3eb:0:b0:2d1:220c:9afa with HTTP; Sat, 3 Sep 2022
 07:23:43 -0700 (PDT)
Reply-To: keenjr73@gmail.com
From:   "keen J. Richardson" <roseibrahim1985@gmail.com>
Date:   Sat, 3 Sep 2022 14:23:43 +0000
Message-ID: <CAEJJipWwwuqVTKP2NOE+yRoZrYj2HzsqtRid2U8+mBM=qGsPDA@mail.gmail.com>
Subject: Guten Morgen
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a30 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [roseibrahim1985[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [keenjr73[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [roseibrahim1985[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Irgendwann letzte Woche wurde Ihnen eine Mail mit der Erwartung von gesende=
t
Ich habe eine Antwortmail von Ihnen erhalten, aber zu meiner
=C3=9Cberraschung haben Sie sich nie die M=C3=BChe gemacht, zu antworten.
Bitte antworten Sie f=C3=BCr weitere Erkl=C3=A4rungen.

Hochachtungsvoll,
Keen J. Richardson.
